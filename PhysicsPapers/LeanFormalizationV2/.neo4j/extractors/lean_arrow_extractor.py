#!/usr/bin/env python3
"""
lean_arrow_extractor — parse OmegaTheory .lean files and emit 14 typed-arrow
edges into the `math` Neo4j container, materialising the LeanAlgebra quiver
on the live declaration catalogue.

Author:   Phobos-Iota (Mars-moon team)
Date:     2026-04-18
Plan:     ~/.claude/plans/elegant-sauteeing-simon.md  (Phase 1B)
Schema:   LeanFormalizationV2/.neo4j/lean_algebra_arrows.cypher
Memos:    ~/papers/OmegaTheoryAlgebra/{01_entity_types,02_relationships}.md

Pragmatics.  This is a *static* extractor: regex on Lean 4 source + Neo4j name
resolution.  IMPORTS is already catalogued, so only 14 of the 15 LeanAlgebra
arrows are in scope.  SUGGESTED_BY is skipped (populated downstream by the
retrieval pipeline).  Each candidate edge is emitted only when BOTH endpoints
resolve to existing OmegaTheoryV2 Declaration-family nodes (Axiom / Theorem /
Definition / LeanFile).  Unresolved identifiers (Mathlib / stdlib / synthetic
tactic names) are discarded on the fly.

Extraction priority (per Phobos brief):
  1. Low-hanging regex: OPENS_NAMESPACE, EXTENDS, INSTANTIATES, CONSTRAINED_BY,
     HAS_TYPE, PARAMETRIZES.
  2. Proof-body regex: APPLIES, ASSUMES, UNFOLDS, REWRITES_BY, SPECIALIZES,
     REDUCES_TO, ELABORATES_AS.
  3. Structural passes: 1 and 2 run per file; name resolution against Neo4j
     happens in bulk afterwards to minimise database round-trips.

Usage
-----
    python lean_arrow_extractor.py --dry-run          # scan only, log counts
    python lean_arrow_extractor.py --write            # emit Cypher MERGE
    python lean_arrow_extractor.py --stats            # show current edge counts per type
    python lean_arrow_extractor.py --dry-run --limit 3 --files X Y Z
"""

from __future__ import annotations

import argparse
import logging
import os
import pathlib
import re
import sys
import time
from collections import Counter, defaultdict
from dataclasses import dataclass, field
from typing import Iterable

# --------------------------------------------------------------------------- #
# Configuration
# --------------------------------------------------------------------------- #

LEAN_ROOT = pathlib.Path(
    "/mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/"
    "LeanFormalizationV2/OmegaTheory"
)

REPO_ROOT = pathlib.Path(
    "/mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/LeanFormalizationV2"
)

NAMESPACE = "OmegaTheoryV2"
ARROW_NAMESPACE = "LeanAlgebra"  # for provenance metadata on edges

NEO4J_URI = os.environ.get("NEO4J_URI", "bolt://localhost:7687")
NEO4J_USER = os.environ.get("NEO4J_USER", "neo4j")
NEO4J_PASSWORD = os.environ.get("NEO4J_PASSWORD", "omegatheory2026")

BATCH_SIZE = 100  # edges per Cypher transaction

# The 14 typed arrows we can derive from static .lean source.  IMPORTS is
# already catalogued; SUGGESTED_BY is populated by the retrieval pipeline, not
# by parsing.
ARROW_TYPES: list[str] = [
    "OPENS_NAMESPACE",
    "EXTENDS",
    "INSTANTIATES",
    "ASSUMES",
    "APPLIES",
    "UNFOLDS",
    "SPECIALIZES",
    "REWRITES_BY",
    "HAS_TYPE",
    "CONSTRAINED_BY",
    "PARAMETRIZES",
    "REDUCES_TO",
    "ELABORATES_AS",
    # SUGGESTED_BY intentionally omitted — retrieval fills it.
]

# --------------------------------------------------------------------------- #
# Data types
# --------------------------------------------------------------------------- #


@dataclass
class Candidate:
    """One candidate edge emitted by a file-level extractor."""

    arrow_type: str
    source_name: str
    target_name: str
    source_file: str        # relative path, e.g. 'OmegaTheory/Emergence/X.lean'
    line_number: int
    snippet: str = ""       # short surface-syntax fragment (for debugging / provenance)


@dataclass
class DeclaredNode:
    """A node the extractor wants MERGEd into Neo4j before edges are emitted.

    `label` is the primary Neo4j label ('Structure', 'Instance', 'Namespace').
    `name` is the identifier used for resolution (short-name for Structure /
    Instance, dotted-name for Namespace).  `file` is the source file that
    introduces the declaration.  `extra_labels` adds secondary labels (used
    for LeanFile+Namespace dual-labelling).
    """

    label: str
    name: str
    file: str
    line: int
    declaration_type: str   # 'structure' / 'class' / 'inductive' / 'instance' / 'namespace_container'
    extra_labels: tuple[str, ...] = ()


@dataclass
class FileExtract:
    """All candidate edges + nodes produced from a single .lean file."""

    path: pathlib.Path
    rel_path: str
    parsed_ok: bool
    edges: list[Candidate] = field(default_factory=list)
    declared_names: set[str] = field(default_factory=set)
    nodes: list[DeclaredNode] = field(default_factory=list)
    namespaces: set[str] = field(default_factory=set)
    error: str | None = None


# --------------------------------------------------------------------------- #
# Lean regex toolkit
# --------------------------------------------------------------------------- #

IDENT = r"[A-Za-z_][A-Za-z0-9_\.\'\!]*"
MOD_PREFIX = (
    r"(?:(?:@\[[^\]]*\]\s*)?"
    r"(?:protected\s+|private\s+|noncomputable\s+|unsafe\s+|partial\s+|"
    r"@\[[^\]]*\]\s*)*)"
)

# ---- declaration regexes (who OWNS the proof body) ----
RE_THEOREM = re.compile(
    rf"^\s*{MOD_PREFIX}(?:theorem|lemma)\s+({IDENT})", re.MULTILINE
)
RE_DEF = re.compile(
    rf"^\s*{MOD_PREFIX}(?:def|abbrev)\s+({IDENT})", re.MULTILINE
)
RE_AXIOM = re.compile(rf"^\s*{MOD_PREFIX}axiom\s+({IDENT})", re.MULTILINE)
RE_STRUCTURE = re.compile(
    rf"^\s*{MOD_PREFIX}(?:structure|class)\s+({IDENT})", re.MULTILINE
)
RE_INSTANCE = re.compile(
    rf"^\s*{MOD_PREFIX}instance\s+(?:({IDENT})\s*)?:\s*([^:=]+?)(?::=|\s+where|\s+\{{|$)",
    re.MULTILINE,
)
RE_INDUCTIVE = re.compile(rf"^\s*{MOD_PREFIX}inductive\s+({IDENT})", re.MULTILINE)

# ---- file-level structural regexes ----
RE_NAMESPACE = re.compile(rf"^\s*namespace\s+({IDENT})", re.MULTILINE)
RE_OPEN = re.compile(rf"^\s*open\s+(?:scoped\s+)?([^\n]+)", re.MULTILINE)

# ---- EXTENDS parents ----
RE_EXTENDS_PARENTS = re.compile(
    rf"^\s*{MOD_PREFIX}(?:structure|class)\s+{IDENT}"
    rf"(?:\s*\{{[^}}]*\}})?"        # optional type args {α : Type*}
    rf"(?:[^\n]*?)"                  # anything else on the line
    rf"\bextends\s+([^\n]+)",
    re.MULTILINE,
)
RE_EXTENDS_LIST_SEP = re.compile(r"[\s,]+")

# ---- in-signature extractors ----
# A theorem / def signature runs from the declaration keyword up to either
# ":=" (term-mode body), "by" (tactic-mode body), or end-of-signature
# newline-with-colon.  We approximate with a 2000-char window for sanity.
RE_DECL_START = re.compile(
    rf"^\s*{MOD_PREFIX}"
    rf"(?P<kind>theorem|lemma|def|abbrev|axiom|structure|class|inductive|instance)\s+"
    rf"(?P<name>{IDENT})?",
    re.MULTILINE,
)

# Square-bracket binder captures typeclass / instance constraints.
# Example:  `[CommGroup G]`, `[Fintype α]`.  We grab the first identifier
# after the bracket as the typeclass name.
RE_CONSTRAINT = re.compile(
    rf"\[\s*(?:{IDENT}\s*:\s*)?({IDENT})", re.DOTALL
)

# Parenthesised explicit argument.  `(params : HealingParams)`,
# `(p : ErrorBound)`, `(G_N : ℝ) (c : ℝ)`.  We pick the identifier after `:`.
RE_PAREN_ARG = re.compile(
    rf"\(\s*(?:{IDENT}(?:\s+{IDENT})*)\s*:\s*([^()]+?)\)",
    re.DOTALL,
)

# Top-level identifiers in a type expression.  Used to pull the
# primary head-name from a parenthesised argument or return type.
RE_HEAD_IDENT = re.compile(rf"({IDENT})")

# Tactic / term-mode scraps inside a proof body.
RE_TACTIC_EXACT = re.compile(rf"(?:^|[\s;(])(?:exact|exact\?)\s+({IDENT})")
RE_TACTIC_APPLY = re.compile(rf"(?:^|[\s;(])apply\s+(?:@)?({IDENT})")
RE_TACTIC_REFINE = re.compile(rf"(?:^|[\s;(])refine(?:'|!)?\s+({IDENT})")
RE_TACTIC_RW = re.compile(r"rw\s*(?:\[([^\]]+)\])")
RE_TACTIC_SIMP = re.compile(r"simp(?:_all|\?|!)?\s*(?:only\s*)?(?:\[([^\]]+)\])?")
RE_TACTIC_UNFOLD = re.compile(rf"unfold(?:_let)?\s+((?:{IDENT}\s*)+)")
RE_TACTIC_SHOW = re.compile(rf"show\s+([^\n]+?:=)")
RE_TACTIC_HAVE = re.compile(rf"(?:have|suffices)\s+{IDENT}\s*:[^:=]*:=\s+({IDENT})")
RE_TERM_RFL = re.compile(r"\brfl\b")
RE_TERM_BY = re.compile(r":=\s*by\b")

# Identifier-in-proof pattern.  After we split a proof into tokens, anything
# that looks like a Lean identifier is a candidate target — we filter via
# Neo4j existence checks afterwards, so imprecision is tolerable.
RE_IDENT_TOKEN = re.compile(rf"\b({IDENT})\b")


# --------------------------------------------------------------------------- #
# Helpers: Lean source preprocessing
# --------------------------------------------------------------------------- #


def strip_comments(text: str) -> str:
    """Strip `-- line` and nested `/- block -/` comments (newline-preserving).

    Mirrors the convention already in `.neo4j/catalogue_scan.py` so that line
    numbers remain aligned with the original file.
    """

    out: list[str] = []
    i = 0
    n = len(text)
    depth = 0
    in_string = False
    while i < n:
        c = text[i]
        if (
            not in_string
            and depth == 0
            and c == "-"
            and i + 1 < n
            and text[i + 1] == "-"
        ):
            # Skip to end of line (or EOF) but keep the newline.
            j = text.find("\n", i)
            if j == -1:
                break
            out.append("\n")
            i = j + 1
            continue
        if (
            not in_string
            and c == "-"
            and i + 1 < n
            and text[i + 1] == "/"
            and depth > 0
        ):
            depth -= 1
            i += 2
            continue
        if (
            not in_string
            and c == "/"
            and i + 1 < n
            and text[i + 1] == "-"
        ):
            depth += 1
            i += 2
            continue
        if depth > 0:
            if c == "\n":
                out.append("\n")
            i += 1
            continue
        if c == '"' and (i == 0 or text[i - 1] != "\\"):
            in_string = not in_string
        out.append(c)
        i += 1
    return "".join(out)


def line_of(text: str, offset: int) -> int:
    """1-indexed line number at a byte offset (best-effort)."""

    return text.count("\n", 0, offset) + 1


def normalize_name(qualified: str) -> str:
    """Drop namespace qualifier; keep last dotted component.

    Matches the heuristic already used by `catalogue_scan.py:normalize_name`
    so we resolve against the same DB names.
    """

    qualified = qualified.strip().rstrip(".")
    if not qualified:
        return qualified
    if qualified.startswith("OmegaTheory."):
        return qualified.split(".")[-1]
    # Keep dot-qualified Mathlib names intact; the Neo4j check will drop
    # them if they aren't in the catalogue.
    return qualified


# --------------------------------------------------------------------------- #
# Declaration scanner: find every top-level item and its source-range
# --------------------------------------------------------------------------- #


@dataclass
class Declaration:
    kind: str          # theorem / lemma / def / abbrev / axiom / structure / class / instance / inductive
    name: str          # full short-name (no namespace)
    start: int         # byte offset of declaration keyword in stripped source
    sig_end: int       # byte offset of end-of-signature (`:=` or `by` or line-end with no body)
    body_end: int      # byte offset of end-of-body (next top-level decl / namespace or EOF)
    line: int          # 1-indexed line number of `kind` keyword


def scan_declarations(stripped: str) -> list[Declaration]:
    """Locate every top-level declaration and bracket its signature + body.

    We walk all `RE_DECL_START` hits, then set each declaration's `body_end`
    to the next declaration's start (or EOF).  Signature-end is the first
    `:=` or `by` that appears between start and next-start (or next-start
    itself if neither is found).
    """

    matches = list(RE_DECL_START.finditer(stripped))
    decls: list[Declaration] = []
    for idx, m in enumerate(matches):
        kind = m.group("kind")
        name = m.group("name") or ""
        if not name and kind == "instance":
            # Anonymous instance: synthesise a name from the file offset
            name = f"_anon_instance_{m.start()}"
        if not name:
            continue
        start = m.start()
        body_end = matches[idx + 1].start() if idx + 1 < len(matches) else len(stripped)

        # sig_end := first ":=" or " by\n" within [start, body_end]
        slice_ = stripped[start:body_end]
        sig_candidates = []
        m_eq = re.search(r":=", slice_)
        if m_eq:
            sig_candidates.append(m_eq.start())
        m_by = re.search(r"\bby\b", slice_)
        if m_by:
            sig_candidates.append(m_by.start())
        sig_end_rel = min(sig_candidates) if sig_candidates else len(slice_)
        sig_end = start + sig_end_rel

        decls.append(
            Declaration(
                kind=kind,
                name=name,
                start=start,
                sig_end=sig_end,
                body_end=body_end,
                line=line_of(stripped, start),
            )
        )
    return decls


# --------------------------------------------------------------------------- #
# Per-file extractor — returns candidate edges per arrow type
# --------------------------------------------------------------------------- #


def extract_from_file(path: pathlib.Path, repo_root: pathlib.Path) -> FileExtract:
    """Read a `.lean` file and return a `FileExtract` of candidate arrows."""

    rel = str(path.relative_to(repo_root))
    try:
        raw = path.read_text(encoding="utf-8", errors="replace")
    except OSError as exc:
        return FileExtract(path=path, rel_path=rel, parsed_ok=False, error=str(exc))

    try:
        text = strip_comments(raw)
    except Exception as exc:  # noqa: BLE001
        logging.warning("strip_comments failed on %s: %s", rel, exc)
        text = raw

    decls = scan_declarations(text)
    declared_names = {d.name for d in decls}

    edges: list[Candidate] = []
    nodes: list[DeclaredNode] = []

    # ---- nodes: Structure / Instance / Namespace ----
    nodes.extend(_extract_nodes(text, decls, rel))

    # ---- file-scope structural edges ----
    edges.extend(_extract_namespace_opens(text, rel))
    edges.extend(_extract_extends(text, rel))
    edges.extend(_extract_instantiates(text, decls, rel))

    # ---- per-declaration signature + body scans ----
    for d in decls:
        if d.kind in ("theorem", "lemma"):
            edges.extend(_extract_theorem_edges(text, d, rel))
        elif d.kind in ("def", "abbrev"):
            edges.extend(_extract_def_edges(text, d, rel))
        elif d.kind in ("structure", "class", "inductive"):
            edges.extend(_extract_structure_edges(text, d, rel))

    # ---- namespaces declared by this file (for later Namespace-node merge) ----
    namespaces = {
        m.group(1).strip()
        for m in RE_NAMESPACE.finditer(text)
        if m.group(1).strip()
    }

    return FileExtract(
        path=path,
        rel_path=rel,
        parsed_ok=True,
        edges=edges,
        declared_names=declared_names,
        nodes=nodes,
        namespaces=namespaces,
    )


# ---- individual extractors --------------------------------------------------


def _extract_nodes(
    text: str, decls: list[Declaration], rel: str
) -> list[DeclaredNode]:
    """Produce DeclaredNode records for Structure / Instance / Namespace roles.

    Structure: any `structure | class | inductive` declaration.  `class` is
    tagged `declaration_type='class'` so downstream queries can distinguish.
    Instance: any `instance` declaration.  Anonymous instances keep their
    synthetic `_anon_instance_<offset>` name from `scan_declarations` so the
    MERGE is still idempotent on that node identity.
    Namespace: no nodes emitted here — handled at batch level by
    `collect_namespaces()` which deduplicates across files.
    """

    out: list[DeclaredNode] = []
    for d in decls:
        if d.kind in ("structure", "class", "inductive"):
            out.append(
                DeclaredNode(
                    label="Structure",
                    name=d.name,
                    file=rel,
                    line=d.line,
                    declaration_type=d.kind,
                )
            )
        elif d.kind == "instance":
            out.append(
                DeclaredNode(
                    label="Instance",
                    name=d.name,
                    file=rel,
                    line=d.line,
                    declaration_type="instance",
                )
            )
    return out


def _extract_namespace_opens(text: str, rel: str) -> list[Candidate]:
    """OPENS_NAMESPACE edges from `open Foo.Bar Baz`.

    `open` may list several namespaces on one line (space-separated).  We emit
    one candidate per listed target; when the file has declared its own
    namespace, that namespace is the source.  If no namespace yet declared, we
    use the file path as source (file-as-namespace convention in catalogue).
    """

    out: list[Candidate] = []
    last_ns: str | None = None
    for m in re.finditer(rf"^\s*(namespace|open)\s+([^\n]+)", text, re.MULTILINE):
        kw = m.group(1)
        payload = m.group(2).strip()
        line = line_of(text, m.start())
        if kw == "namespace":
            last_ns = payload.split()[0].rstrip()
            continue
        # kw == 'open'
        source = last_ns or rel
        for raw_target in payload.split():
            raw_target = raw_target.rstrip(",")
            if not raw_target or raw_target.startswith("--"):
                continue
            out.append(
                Candidate(
                    arrow_type="OPENS_NAMESPACE",
                    source_name=source,
                    target_name=raw_target,
                    source_file=rel,
                    line_number=line,
                    snippet=f"open {raw_target}",
                )
            )
    return out


def _extract_extends(text: str, rel: str) -> list[Candidate]:
    """EXTENDS edges from `structure B extends A, C where ...` / `class D extends E`."""

    out: list[Candidate] = []
    pat = re.compile(
        rf"^\s*{MOD_PREFIX}(structure|class)\s+({IDENT})"
        rf"(?:[^\n]*?)"
        rf"\bextends\s+([^\n]+?)(?=\s+where\b|\s+:=|\s*$)",
        re.MULTILINE,
    )
    for m in pat.finditer(text):
        child = m.group(2)
        tail = m.group(3)
        line = line_of(text, m.start())
        # parents list: split by comma / space, keep identifier head only
        for piece in re.split(r"[,\s]+", tail):
            piece = piece.strip()
            if not piece:
                continue
            head = RE_HEAD_IDENT.match(piece)
            if not head:
                continue
            parent = normalize_name(head.group(1))
            if parent in ("where", "Type", "Type*", "Prop", "Sort"):
                continue
            out.append(
                Candidate(
                    arrow_type="EXTENDS",
                    source_name=child,
                    target_name=parent,
                    source_file=rel,
                    line_number=line,
                    snippet=f"extends {parent}",
                )
            )
    return out


def _extract_instantiates(
    text: str, decls: list[Declaration], rel: str
) -> list[Candidate]:
    """INSTANTIATES edges from `instance [name] : Class T := ...`.

    The class name is the HEAD identifier of the type expression after the
    `:`.  We treat the instance as the source (pure-sink semantics, per
    selection rule 3 and the forbidden-block schema).
    """

    out: list[Candidate] = []
    for d in decls:
        if d.kind != "instance":
            continue
        slice_ = text[d.start : d.sig_end]
        # slice_ starts with `instance`; keep portion after first `:`
        colon = slice_.find(":")
        if colon < 0:
            continue
        type_expr = slice_[colon + 1 :].strip()
        head = RE_HEAD_IDENT.match(type_expr)
        if not head:
            continue
        klass = normalize_name(head.group(1))
        if klass in ("", "Type", "Prop", "Sort"):
            continue
        out.append(
            Candidate(
                arrow_type="INSTANTIATES",
                source_name=d.name,
                target_name=klass,
                source_file=rel,
                line_number=d.line,
                snippet=f"instance : {klass}",
            )
        )
    return out


def _extract_theorem_edges(text: str, d: Declaration, rel: str) -> list[Candidate]:
    """Signature + proof body scan for a theorem/lemma."""

    out: list[Candidate] = []
    sig = text[d.start : d.sig_end]
    body = text[d.sig_end : d.body_end]

    # --- CONSTRAINED_BY: [TypeClass α] binders in signature ---
    for m in RE_CONSTRAINT.finditer(sig):
        klass = normalize_name(m.group(1))
        if klass in ("", "Decidable", "DecidableEq", "Inhabited"):
            # keep these too — they resolve or they don't
            pass
        out.append(
            Candidate(
                arrow_type="CONSTRAINED_BY",
                source_name=d.name,
                target_name=klass,
                source_file=rel,
                line_number=d.line,
                snippet=f"[{klass}]",
            )
        )

    # --- HAS_TYPE / PARAMETRIZES: (x : T) explicit binders ---
    for m in RE_PAREN_ARG.finditer(sig):
        type_expr = m.group(1).strip()
        head = RE_HEAD_IDENT.match(type_expr)
        if not head:
            continue
        type_name = normalize_name(head.group(1))
        if type_name in (
            "",
            "ℝ",
            "ℕ",
            "ℤ",
            "ℚ",
            "ℂ",
            "Prop",
            "Type",
            "Type*",
            "Sort",
            "Sort*",
            "Real",
            "Nat",
            "Int",
            "True",
            "False",
        ):
            continue
        # Theorems PARAMETRIZE structures used as explicit arguments
        out.append(
            Candidate(
                arrow_type="PARAMETRIZES",
                source_name=d.name,
                target_name=type_name,
                source_file=rel,
                line_number=d.line,
                snippet=f"(_ : {type_name})",
            )
        )

    # --- proof-body scan: APPLIES / ASSUMES / UNFOLDS / REWRITES_BY / REDUCES_TO / SPECIALIZES ---
    out.extend(_scan_proof_body(body, source=d.name, source_line=d.line, rel=rel))

    # --- term-mode APPLIES: bare `:= headIdent arg1 arg2` bodies ---
    # Covers proofs like `theorem l_P_pos : ... := Real.sqrt_pos_of_pos ...`
    # which have no `by` and therefore never hit the tactic regexes.
    body_stripped = body.lstrip()
    if body_stripped.startswith(":="):
        after_eq = body_stripped[2:].lstrip()
        # If body is a tactic block (`:= by tac1; tac2`), skip — already
        # handled by _scan_proof_body.  Also skip `:= fun …` abstractions.
        if not after_eq.startswith(("by", "by\n", "fun ", "λ ", "fun\n")):
            # pull leading identifier; also pull up to 5 following identifiers
            # as APPLIES arguments (e.g. `div_pos hbar_pos G_N_pos` → 3 edges)
            tokens = RE_IDENT_TOKEN.findall(after_eq[:500])
            for ident in tokens[:8]:
                ident = normalize_name(ident)
                if not ident or ident == d.name:
                    continue
                out.append(
                    Candidate(
                        arrow_type="APPLIES",
                        source_name=d.name,
                        target_name=ident,
                        source_file=rel,
                        line_number=d.line,
                        snippet=f"term-mode {ident}",
                    )
                )

    return out


def _extract_def_edges(text: str, d: Declaration, rel: str) -> list[Candidate]:
    """For a definition: HAS_TYPE edge from def → head of declared type."""

    out: list[Candidate] = []
    sig = text[d.start : d.sig_end]

    # `def name : TypeExpr := body`  →  HAS_TYPE from name to head-of-TypeExpr
    colon = sig.find(":")
    eq_ = sig.find(":=")
    if 0 <= colon < (eq_ if eq_ >= 0 else len(sig)):
        type_expr = sig[colon + 1 : (eq_ if eq_ >= 0 else len(sig))].strip()
        head = RE_HEAD_IDENT.match(type_expr)
        if head:
            type_name = normalize_name(head.group(1))
            if type_name and type_name not in (
                "ℝ",
                "ℕ",
                "ℤ",
                "ℚ",
                "ℂ",
                "Real",
                "Nat",
                "Int",
                "Prop",
                "Type",
                "Type*",
                "Sort",
                "Sort*",
            ):
                out.append(
                    Candidate(
                        arrow_type="HAS_TYPE",
                        source_name=d.name,
                        target_name=type_name,
                        source_file=rel,
                        line_number=d.line,
                        snippet=f": {type_name}",
                    )
                )

    # `abbrev X := Y`  →  ELABORATES_AS  X → Y  (head identifier of body)
    body = text[d.sig_end : d.body_end].strip()
    if d.kind == "abbrev":
        head = RE_HEAD_IDENT.match(body.lstrip(":= "))
        if head:
            tgt = normalize_name(head.group(1))
            if tgt and tgt != d.name:
                out.append(
                    Candidate(
                        arrow_type="ELABORATES_AS",
                        source_name=d.name,
                        target_name=tgt,
                        source_file=rel,
                        line_number=d.line,
                        snippet=f"abbrev → {tgt}",
                    )
                )

    return out


def _extract_structure_edges(text: str, d: Declaration, rel: str) -> list[Candidate]:
    """Structure/class signature: PARAMETRIZES explicit binders."""

    out: list[Candidate] = []
    sig = text[d.start : d.sig_end]
    for m in RE_PAREN_ARG.finditer(sig):
        type_expr = m.group(1).strip()
        head = RE_HEAD_IDENT.match(type_expr)
        if not head:
            continue
        type_name = normalize_name(head.group(1))
        if type_name in (
            "",
            "ℝ",
            "ℕ",
            "ℤ",
            "ℚ",
            "ℂ",
            "Real",
            "Nat",
            "Int",
            "Prop",
            "Type",
            "Type*",
            "Sort",
            "Sort*",
        ):
            continue
        out.append(
            Candidate(
                arrow_type="PARAMETRIZES",
                source_name=d.name,
                target_name=type_name,
                source_file=rel,
                line_number=d.line,
                snippet=f"(_ : {type_name})",
            )
        )
    return out


# --------------------------------------------------------------------------- #
# Proof-body scanner: APPLIES / ASSUMES / UNFOLDS / REWRITES_BY / REDUCES_TO / SPECIALIZES
# --------------------------------------------------------------------------- #


def _split_rw_args(arg_block: str) -> list[str]:
    """Split a `rw [a, b, ← c]` argument list into identifier heads.

    Handles the arrow prefix `← eq` / `<- eq`.  Returns **just the head
    identifier** — the full expression is collapsed to its first token.
    """

    pieces = [p.strip() for p in arg_block.split(",")]
    out: list[str] = []
    for p in pieces:
        p = p.lstrip("← <-").strip()
        # `@foo` / `show foo` / `foo (arg1 arg2)` — pull leading ident
        m = RE_HEAD_IDENT.search(p.lstrip("@ "))
        if m:
            out.append(m.group(1))
    return out


def _scan_proof_body(
    body: str, source: str, source_line: int, rel: str
) -> list[Candidate]:
    """Scan a proof body for tactic + term references."""

    out: list[Candidate] = []

    # ---- APPLIES: exact X, apply X, refine X ----
    for pat, label in (
        (RE_TACTIC_EXACT, "exact"),
        (RE_TACTIC_APPLY, "apply"),
        (RE_TACTIC_REFINE, "refine"),
    ):
        for m in pat.finditer(body):
            ident = normalize_name(m.group(1))
            if not ident:
                continue
            out.append(
                Candidate(
                    arrow_type="APPLIES",
                    source_name=source,
                    target_name=ident,
                    source_file=rel,
                    line_number=source_line,
                    snippet=f"{label} {ident}",
                )
            )

    # ---- REWRITES_BY: rw [...], simp only [...] ----
    for m in RE_TACTIC_RW.finditer(body):
        for ident in _split_rw_args(m.group(1)):
            ident = normalize_name(ident)
            if not ident:
                continue
            out.append(
                Candidate(
                    arrow_type="REWRITES_BY",
                    source_name=source,
                    target_name=ident,
                    source_file=rel,
                    line_number=source_line,
                    snippet=f"rw [{ident}]",
                )
            )
    for m in RE_TACTIC_SIMP.finditer(body):
        args = m.group(1)
        if not args:
            continue
        for ident in _split_rw_args(args):
            ident = normalize_name(ident)
            if not ident:
                continue
            out.append(
                Candidate(
                    arrow_type="REWRITES_BY",
                    source_name=source,
                    target_name=ident,
                    source_file=rel,
                    line_number=source_line,
                    snippet=f"simp [{ident}]",
                )
            )

    # ---- UNFOLDS: unfold foo bar ----
    for m in RE_TACTIC_UNFOLD.finditer(body):
        for raw in re.split(r"\s+", m.group(1).strip()):
            raw = normalize_name(raw)
            if not raw:
                continue
            out.append(
                Candidate(
                    arrow_type="UNFOLDS",
                    source_name=source,
                    target_name=raw,
                    source_file=rel,
                    line_number=source_line,
                    snippet=f"unfold {raw}",
                )
            )

    # ---- SPECIALIZES: `← X`, `X.specialize`, `@X (...)` — we
    # approximate by looking for `.specialize`, `specialize`, or
    # `@(Name)`.  Low-precision; retained for the priority list.
    for m in re.finditer(rf"specialize\s+({IDENT})", body):
        ident = normalize_name(m.group(1))
        if ident:
            out.append(
                Candidate(
                    arrow_type="SPECIALIZES",
                    source_name=source,
                    target_name=ident,
                    source_file=rel,
                    line_number=source_line,
                    snippet=f"specialize {ident}",
                )
            )

    # ---- ASSUMES: invocation of any bare identifier matching an axiom name ----
    # We cannot tell axiom vs theorem from syntax alone — so we emit every
    # identifier reference as a candidate and let Neo4j resolution classify
    # it as ASSUMES iff the target is an Axiom node, or APPLIES iff Theorem,
    # or UNFOLDS iff Definition.  That is handled downstream in
    # `resolve_and_emit` below; here we simply record candidate references.
    # We do NOT emit raw "identifier" candidates for every token — that
    # explodes the set.  Instead we emit APPLIES-candidates for any
    # identifier token reachable from the proof body via `exact/apply/refine`,
    # which we already did; the polymorphic classification happens in the
    # loader.

    return out


# --------------------------------------------------------------------------- #
# Neo4j glue
# --------------------------------------------------------------------------- #


def _ensure_driver():
    try:
        from neo4j import GraphDatabase
    except ImportError as exc:
        raise SystemExit(
            "neo4j driver not installed in this Python environment.  "
            "Activate ~/genai_env or install `pip install neo4j`."
        ) from exc

    # Silence Neo4j's "relationship type does not exist" informational
    # warnings — we're explicitly querying for counts that may be zero, and
    # the warning noise drowns out the actual numeric output.
    logging.getLogger("neo4j.notifications").setLevel(logging.ERROR)
    return GraphDatabase.driver(
        NEO4J_URI,
        auth=(NEO4J_USER, NEO4J_PASSWORD),
        warn_notification_severity="OFF",
    )


def fetch_declaration_index(session) -> dict[str, str]:
    """Return {identifier: primary_label} across OmegaTheoryV2.

    Keys are the identifiers downstream resolution will look up:
      - Axiom / Theorem / Definition / Structure / Instance : keyed on `n.name`
      - LeanFile                                            : keyed on `n.path`
      - Namespace                                           : keyed on `n.dotted_name`

    Priority on collision (lower = higher priority):
      Axiom > Theorem > Definition > Structure > Instance > LeanFile > Namespace.

    Axiom beats Theorem because `ASSUMES` (strongest dependency) trumps
    `APPLIES` when both labels are present on the same short-name.
    Structure / Instance sit between Definition and LeanFile so that
    `theorem t [CommGroup G]` resolves `CommGroup` to Structure before any
    Definition-named namesake would.
    """

    # Priority for resolver collision: LOWER wins when a short-name exists
    # under multiple labels.  Structure beats Definition because the legacy
    # catalogue (pre-2026-04-18) tagged ~138 structures as :Definition — the
    # extractor's Structure node is the authoritative one.  Axiom remains
    # top to preserve ASSUMES-over-APPLIES semantics.
    priority = {
        "Axiom":      0,
        "Theorem":    1,
        "Structure":  2,
        "Instance":   3,
        "Definition": 4,
        "LeanFile":   5,
        "Namespace":  6,
    }
    index: dict[str, tuple[int, str]] = {}

    # Axiom / Theorem / Definition / Structure / Instance — keyed on .name
    query = (
        "MATCH (n) WHERE n.namespace = $ns AND n.name IS NOT NULL "
        "AND any(l IN labels(n) WHERE l IN "
        "['Axiom','Theorem','Definition','Structure','Instance']) "
        "RETURN n.name AS name, labels(n) AS lbls"
    )
    for rec in session.run(query, ns=NAMESPACE):
        name = rec["name"]
        lbls = rec["lbls"]
        label = next((l for l in lbls if l in priority), None)
        if label is None:
            continue
        p = priority[label]
        cur = index.get(name)
        if cur is None or p < cur[0]:
            index[name] = (p, label)

    # LeanFile — keyed on .path
    file_query = (
        "MATCH (f:LeanFile) WHERE f.namespace = $ns AND f.path IS NOT NULL "
        "RETURN f.path AS path"
    )
    for rec in session.run(file_query, ns=NAMESPACE):
        path = rec["path"]
        if path is None:
            continue
        index.setdefault(path, (priority["LeanFile"], "LeanFile"))

    # Namespace — keyed on .dotted_name
    ns_query = (
        "MATCH (ns:Namespace) WHERE ns.namespace = $ns "
        "AND ns.dotted_name IS NOT NULL "
        "RETURN ns.dotted_name AS dotted"
    )
    for rec in session.run(ns_query, ns=NAMESPACE):
        dotted = rec["dotted"]
        if dotted is None:
            continue
        index.setdefault(dotted, (priority["Namespace"], "Namespace"))

    return {k: v[1] for k, v in index.items()}


def _classify_edge(cand: Candidate, src_lbl: str | None, tgt_lbl: str | None) -> str:
    """Map candidate → final arrow type, promoting when the target label
    contradicts the best-guess arrow.

    Rules (per ontology 01/02):
      - APPLIES: Theorem → Theorem.  Promotions:
          * Axiom      → ASSUMES
          * Definition → UNFOLDS
          * Structure  → CONSTRAINED_BY  (typeclass / structure reference in proof)
      - PARAMETRIZES from Theorem targeting Structure is valid (Theorem
        PARAMETRIZES a Structure).  No reclassification needed.
      - HAS_TYPE onto Structure is valid; onto Definition is also valid.
      - CONSTRAINED_BY onto Structure is valid; onto a plain Definition is
        weak (usually just a type alias), so we leave it be.
      - Structural arrows (OPENS_NAMESPACE, EXTENDS, INSTANTIATES,
        ELABORATES_AS, SPECIALIZES, REWRITES_BY) pass through untouched.
    """

    t = cand.arrow_type
    if t == "APPLIES":
        if tgt_lbl == "Axiom":
            return "ASSUMES"
        if tgt_lbl == "Definition":
            return "UNFOLDS"
        if tgt_lbl == "Structure":
            return "CONSTRAINED_BY"
    # Everything else passes through.  If tgt_lbl is None the caller will
    # drop the edge, so classification is moot.
    return t


# --------------------------------------------------------------------------- #
# Filtering + emission
# --------------------------------------------------------------------------- #


def filter_candidates(
    candidates: Iterable[Candidate], index: dict[str, str]
) -> list[tuple[Candidate, str, str, str]]:
    """Resolve candidates against the Neo4j declaration index.

    Returns a list of `(candidate, final_arrow_type, source_label, target_label)`
    tuples for every candidate whose **both** endpoints resolve.

    For OPENS_NAMESPACE we accept a `LeanFile` source (the path of the current
    file) even though no Namespace-labelled nodes exist; the schema's
    QuiverArrow only records the typed edge, not the endpoint label, so that
    ambiguity is acceptable — downstream queries filter by edge label alone.
    """

    accepted: list[tuple[Candidate, str, str, str]] = []
    for cand in candidates:
        src = index.get(cand.source_name)
        tgt = index.get(cand.target_name)

        # Structural arrows whose source is a file-or-namespace alias
        if cand.arrow_type == "OPENS_NAMESPACE":
            # Namespaces like 'OmegaTheory.Emergence' do not have dedicated
            # Namespace nodes in Neo4j, so we emit OPENS_NAMESPACE as a
            # LeanFile -> LeanFile edge whenever we can resolve both ends
            # to a path in the catalogue.  Target-path candidates tried in
            # order: derive-from-namespace, trailing 'Basic.lean'.  Source
            # is always the current file's path (cand.source_file).
            src_path = cand.source_file
            if index.get(src_path) != "LeanFile":
                continue
            for tgt_candidate in (
                _namespace_to_lean_path(cand.target_name),
                _namespace_to_lean_path(cand.target_name + ".Basic"),
            ):
                if tgt_candidate and index.get(tgt_candidate) == "LeanFile":
                    rewritten = Candidate(
                        arrow_type="OPENS_NAMESPACE",
                        source_name=src_path,
                        target_name=tgt_candidate,
                        source_file=cand.source_file,
                        line_number=cand.line_number,
                        snippet=cand.snippet,
                    )
                    accepted.append(
                        (rewritten, "OPENS_NAMESPACE", "LeanFile", "LeanFile")
                    )
                    break
            continue

        if src is None or tgt is None:
            continue

        final = _classify_edge(cand, src, tgt)
        accepted.append((cand, final, src, tgt))
    return accepted


def _namespace_to_lean_path(ns: str) -> str | None:
    """Map `OmegaTheory.Irrationality.Uncertainty` → `OmegaTheory/Irrationality/Uncertainty.lean`.

    Returns None for strings that don't look like OmegaTheory namespaces.
    """

    if not ns:
        return None
    if ns.startswith("OmegaTheory"):
        parts = ns.split(".")
        return "/".join(parts) + ".lean"
    return None


def emit_nodes(
    session, nodes: list[DeclaredNode], namespaces: set[str], lean_paths: set[str]
):
    """MERGE Structure / Instance / Namespace / LeanFile nodes before edges.

    Structures and Instances are keyed on `(namespace, name)`; Namespaces on
    `(namespace, dotted_name)`.  LeanFile nodes are MERGEd for every file the
    extractor sees (closes the gap between 211 physical files and the ~59
    files the legacy catalogue ingested).  Dual-label: any LeanFile whose
    path matches a namespace-derived path also gets the :Namespace label.
    """

    total_structures = 0
    total_instances = 0
    total_namespaces = 0
    total_leanfiles = 0

    # ---- LeanFile (backfill for files the legacy catalogue skipped) ----
    file_rows = [{"path": p} for p in sorted(lean_paths)]
    if file_rows:
        query = (
            "UNWIND $rows AS row "
            "MERGE (f:LeanFile {namespace: $ns, path: row.path}) "
            "ON CREATE SET f.created_by = 'lean_arrow_extractor', "
            "              f.created_at = datetime()"
        )
        for i in range(0, len(file_rows), BATCH_SIZE):
            session.run(query, rows=file_rows[i : i + BATCH_SIZE], ns=NAMESPACE)
        total_leanfiles = len(file_rows)

    # ---- Structure ----
    structure_rows = [
        {
            "name": n.name,
            "file": n.file,
            "line": n.line,
            "decl": n.declaration_type,
        }
        for n in nodes
        if n.label == "Structure"
    ]
    if structure_rows:
        # dedupe (same structure redeclared across files would be pathological,
        # but MERGE still protects against it).
        query = (
            "UNWIND $rows AS row "
            "MERGE (s:Structure {namespace: $ns, name: row.name}) "
            "ON CREATE SET s.file = row.file, s.line = row.line, "
            "              s.declaration_type = row.decl, "
            "              s.created_by = 'lean_arrow_extractor', "
            "              s.created_at = datetime() "
            "ON MATCH SET  s.file = coalesce(s.file, row.file), "
            "              s.line = coalesce(s.line, row.line), "
            "              s.declaration_type = coalesce(s.declaration_type, row.decl)"
        )
        for i in range(0, len(structure_rows), BATCH_SIZE):
            session.run(
                query, rows=structure_rows[i : i + BATCH_SIZE], ns=NAMESPACE
            )
        total_structures = len(structure_rows)

    # ---- Instance ----
    instance_rows = [
        {
            "name": n.name,
            "file": n.file,
            "line": n.line,
        }
        for n in nodes
        if n.label == "Instance"
    ]
    if instance_rows:
        query = (
            "UNWIND $rows AS row "
            "MERGE (i:Instance {namespace: $ns, name: row.name}) "
            "ON CREATE SET i.file = row.file, i.line = row.line, "
            "              i.declaration_type = 'instance', "
            "              i.created_by = 'lean_arrow_extractor', "
            "              i.created_at = datetime() "
            "ON MATCH SET  i.file = coalesce(i.file, row.file), "
            "              i.line = coalesce(i.line, row.line)"
        )
        for i in range(0, len(instance_rows), BATCH_SIZE):
            session.run(
                query, rows=instance_rows[i : i + BATCH_SIZE], ns=NAMESPACE
            )
        total_instances = len(instance_rows)

    # ---- Namespace ----
    ns_rows = [
        {"dotted": dotted, "kind": "namespace_container"}
        for dotted in sorted(namespaces)
    ]
    if ns_rows:
        query = (
            "UNWIND $rows AS row "
            "MERGE (ns:Namespace {namespace: $ns, dotted_name: row.dotted}) "
            "ON CREATE SET ns.kind = row.kind, "
            "              ns.created_by = 'lean_arrow_extractor', "
            "              ns.created_at = datetime() "
            "ON MATCH SET  ns.kind = coalesce(ns.kind, row.kind)"
        )
        for i in range(0, len(ns_rows), BATCH_SIZE):
            session.run(query, rows=ns_rows[i : i + BATCH_SIZE], ns=NAMESPACE)
        total_namespaces = len(ns_rows)

    # ---- Dual-label any LeanFile whose path matches an OmegaTheory namespace
    # derived path (OmegaTheory.X.Y ↔ OmegaTheory/X/Y.lean).  These files
    # physically contain the namespace declaration, so labelling them
    # :Namespace lets Dubhe's Laplacian treat the whole repo consistently.
    # We resolve against the DB-side path list (not the FS-side one the
    # caller passed), because the DB is authoritative about which LeanFile
    # nodes actually exist.
    db_lean_paths: set[str] = set()
    for rec in session.run(
        "MATCH (f:LeanFile) WHERE f.namespace = $ns AND f.path IS NOT NULL "
        "RETURN f.path AS p",
        ns=NAMESPACE,
    ):
        db_lean_paths.add(rec["p"])
    dual_rows = []
    for dotted in namespaces:
        path = _namespace_to_lean_path(dotted)
        if path is None or path not in db_lean_paths:
            continue
        dual_rows.append({"path": path})
    if dual_rows:
        query = (
            "UNWIND $rows AS row "
            "MATCH (f:LeanFile {namespace: $ns, path: row.path}) "
            "SET f:Namespace"
        )
        for i in range(0, len(dual_rows), BATCH_SIZE):
            session.run(query, rows=dual_rows[i : i + BATCH_SIZE], ns=NAMESPACE)

    return {
        "leanfiles": total_leanfiles,
        "structures": total_structures,
        "instances": total_instances,
        "namespaces": total_namespaces,
        "dual_labelled_files": len(dual_rows),
    }


def emit_edges(session, accepted: list[tuple[Candidate, str, str, str]]):
    """Batch-MERGE edges into Neo4j."""

    # Bucket by (src_label, tgt_label, arrow_type) because each bucket has a
    # different MERGE template (labels are static in Cypher, not parametric).
    buckets: dict[tuple[str, str, str], list[Candidate]] = defaultdict(list)
    for cand, final, src_lbl, tgt_lbl in accepted:
        # For the MERGE we reuse the candidate but normalise its arrow_type
        cand2 = Candidate(
            arrow_type=final,
            source_name=cand.source_name,
            target_name=cand.target_name,
            source_file=cand.source_file,
            line_number=cand.line_number,
            snippet=cand.snippet,
        )
        buckets[(src_lbl, tgt_lbl, final)].append(cand2)

    # Key-property mapping: most labels look up on `.name`, but LeanFile uses
    # `.path` and Namespace uses `.dotted_name`.  `Definition` and `Structure`
    # MAY share short-names (e.g. `HealingParams` legacy as :Definition,
    # extractor-created as :Structure), so the lookup key differs per label
    # only for the container types.
    def _key_prop(label: str) -> str:
        if label == "LeanFile":
            return "path"
        if label == "Namespace":
            return "dotted_name"
        return "name"

    total = 0
    for (src_lbl, tgt_lbl, arrow), cands in buckets.items():
        src_key = _key_prop(src_lbl)
        tgt_key = _key_prop(tgt_lbl)
        query = (
            f"UNWIND $rows AS row "
            f"MATCH (s:{src_lbl} {{namespace: $ns, {src_key}: row.src}}) "
            f"MATCH (t:{tgt_lbl} {{namespace: $ns, {tgt_key}: row.tgt}}) "
            f"MERGE (s)-[r:{arrow}]->(t) "
            f"ON CREATE SET r.source_file = row.source_file, "
            f"              r.line_number = row.line_number, "
            f"              r.snippet = row.snippet, "
            f"              r.arrow_type = $arrow, "
            f"              r.arrow_namespace = $arrow_ns, "
            f"              r.emitted_by = 'lean_arrow_extractor', "
            f"              r.created_at = datetime() "
            f"ON MATCH SET  r.source_file = coalesce(r.source_file, row.source_file), "
            f"              r.line_number = coalesce(r.line_number, row.line_number), "
            f"              r.arrow_type = $arrow, "
            f"              r.arrow_namespace = $arrow_ns, "
            f"              r.emitted_by = 'lean_arrow_extractor'"
        )
        for batch_start in range(0, len(cands), BATCH_SIZE):
            batch = cands[batch_start : batch_start + BATCH_SIZE]
            rows = [
                {
                    "src": c.source_name,
                    "tgt": c.target_name,
                    "source_file": c.source_file,
                    "line_number": c.line_number,
                    "snippet": c.snippet[:200],
                }
                for c in batch
            ]
            session.run(
                query,
                rows=rows,
                ns=NAMESPACE,
                arrow=arrow,
                arrow_ns=ARROW_NAMESPACE,
            )
            total += len(rows)
    return total


# --------------------------------------------------------------------------- #
# Mode helpers
# --------------------------------------------------------------------------- #


def cmd_stats(session):
    """Print current edge counts per arrow type in Neo4j."""

    print("Existing edge counts in Neo4j (OmegaTheoryV2 namespace):")
    counted: list[tuple[str, int]] = []
    for arrow in ["IMPORTS"] + ARROW_TYPES:
        rec = session.run(
            f"MATCH ()-[r:{arrow}]->() RETURN count(r) AS c"
        ).single()
        counted.append((arrow, rec["c"] if rec else 0))
    for arrow, c in counted:
        print(f"  {arrow:20s} {c:>8d}")


def cmd_dry_run(files: list[pathlib.Path], repo_root: pathlib.Path, session=None):
    """Run the extractor without writing to Neo4j."""

    t0 = time.monotonic()
    per_type = Counter()
    per_file = Counter()
    node_counts = Counter()
    all_namespaces: set[str] = set()
    files_ok = 0
    files_err = 0
    all_candidates: list[Candidate] = []
    all_nodes: list[DeclaredNode] = []
    for fp in files:
        ex = extract_from_file(fp, repo_root)
        if not ex.parsed_ok:
            files_err += 1
            logging.warning("parse failed: %s (%s)", ex.rel_path, ex.error)
            continue
        files_ok += 1
        per_file[ex.rel_path] = len(ex.edges)
        for e in ex.edges:
            per_type[e.arrow_type] += 1
            all_candidates.append(e)
        for n in ex.nodes:
            node_counts[n.label] += 1
            all_nodes.append(n)
        all_namespaces |= ex.namespaces
    dt = time.monotonic() - t0

    print(f"=== DRY RUN ===   scanned {len(files)} file(s) in {dt:.1f}s")
    print(f"    parsed ok : {files_ok}")
    print(f"    parse err : {files_err}")
    print(f"    new-node candidates:")
    for lbl in ("Structure", "Instance"):
        print(f"      {lbl:14s} {node_counts[lbl]:>8d}")
    print(f"      {'Namespace':14s} {len(all_namespaces):>8d}  (distinct dotted names)")
    print(f"    candidate edges total: {sum(per_type.values())}")
    print(f"    candidate edges per type:")
    for t in ARROW_TYPES:
        print(f"      {t:20s} {per_type[t]:>8d}")

    if session is not None:
        index = fetch_declaration_index(session)
        print(f"    Neo4j declaration index loaded: {len(index)} names")
        accepted = filter_candidates(all_candidates, index)
        after = Counter(final for (_c, final, _s, _t) in accepted)
        print(
            f"    post-resolution edges (both endpoints in DB): "
            f"{sum(after.values())}"
        )
        for t in sorted(after.keys()):
            print(f"      {t:20s} {after[t]:>8d}")
    else:
        print("    (no Neo4j session; skipping post-resolution counts)")
    return per_type


def ensure_node_constraints(session):
    """Idempotent constraints for Structure/Instance/Namespace uniqueness."""

    stmts = [
        "CREATE CONSTRAINT structure_unique IF NOT EXISTS "
        "FOR (s:Structure) REQUIRE (s.namespace, s.name) IS UNIQUE",
        "CREATE CONSTRAINT instance_unique IF NOT EXISTS "
        "FOR (i:Instance) REQUIRE (i.namespace, i.name) IS UNIQUE",
        "CREATE CONSTRAINT namespace_unique IF NOT EXISTS "
        "FOR (ns:Namespace) REQUIRE (ns.namespace, ns.dotted_name) IS UNIQUE",
    ]
    for s in stmts:
        session.run(s)


def dedupe_legacy_definition_as_structure(session):
    """Consolidate legacy :Definition / extractor :Structure node pairs.

    Background.  The pre-2026-04-18 catalogue (`catalogue_declarations.cypher`)
    mislabelled every `structure X where` / `class X extends` declaration as
    a :Definition.  The extractor later created a separate authoritative
    :Structure node with the same short-name.  This leaves TWO distinct
    Neo4j nodes per structure: the legacy one (carrying Naos-backfilled
    `signature`, `docstring`, `proof_body`, `embedding_lean`) and the
    extractor's bare Structure stub (carrying only `file` + `line`).

    Fix strategy: **add :Structure to the legacy node**, migrate
    `file` / `line` from the extractor stub, detach the stub from any
    incoming DECLARES edges, and delete the stub.  This keeps all metadata
    attached to one node and collapses the duplicate.

    Idempotent.  Returns the count of legacy nodes upgraded to :Structure.
    """

    # Step 1: identify legacy nodes that SHOULD be :Structure.  Two kinds:
    #   (a) still carry :Definition — first run
    #   (b) already stripped of :Definition by a prior rewire invocation,
    #       marked with `relabelled_from_definition_to_structure = true`.
    # The Structure uniqueness constraint means we can't have two :Structure
    # nodes with the same name alive at once, so we run in three phases:
    #   1.  Pull (legacy, stub) pairs, collect stub metadata.
    #   2.  DETACH DELETE all stubs.
    #   3.  Upgrade each legacy node in place with the captured metadata.
    pairs = session.run(
        "MATCH (legacy {namespace: $ns}) "
        "WHERE ('Definition' IN labels(legacy) "
        "       OR legacy.relabelled_from_definition_to_structure = true) "
        "  AND NOT 'Structure' IN labels(legacy) "
        "MATCH (stub:Structure {namespace: $ns, name: legacy.name}) "
        "WHERE stub.created_by = 'lean_arrow_extractor' AND stub <> legacy "
        "RETURN id(legacy) AS legacy_id, id(stub) AS stub_id, "
        "       stub.file AS stub_file, stub.line AS stub_line, "
        "       stub.declaration_type AS stub_decl",
        ns=NAMESPACE,
    ).data()
    if not pairs:
        return 0

    # Phase 2: delete stubs.
    stub_ids = [p["stub_id"] for p in pairs]
    for i in range(0, len(stub_ids), BATCH_SIZE):
        session.run(
            "UNWIND $ids AS sid "
            "MATCH (stub) WHERE id(stub) = sid "
            "DETACH DELETE stub",
            ids=stub_ids[i : i + BATCH_SIZE],
        )

    # Phase 3: upgrade legacy nodes.  At this point no :Structure node
    # exists for these short-names, so the uniqueness constraint is
    # satisfied when we add the label.
    rows = [
        {
            "lid": p["legacy_id"],
            "file": p["stub_file"],
            "line": p["stub_line"],
            "decl": p["stub_decl"],
        }
        for p in pairs
    ]
    for i in range(0, len(rows), BATCH_SIZE):
        session.run(
            "UNWIND $rows AS row "
            "MATCH (legacy) WHERE id(legacy) = row.lid "
            "SET legacy:Structure, "
            "    legacy.file = coalesce(legacy.file, row.file), "
            "    legacy.line = coalesce(legacy.line, row.line), "
            "    legacy.declaration_type = coalesce("
            "        legacy.declaration_type, row.decl), "
            "    legacy.relabelled_at = datetime() "
            "REMOVE legacy:Definition",
            rows=rows[i : i + BATCH_SIZE],
        )
    return len(pairs)


def delete_extractor_edges(session) -> int:
    """Delete every typed edge previously emitted by this extractor.

    Identifies them via `r.arrow_namespace = 'LeanAlgebra'` (present on all
    post-2026-04-18 emissions).  Returns the deleted count.  Use before a
    fresh `--write` when the resolver logic has changed.
    """

    # Count first (read-only), then delete.  Neo4j rejects `count + DELETE` in
    # the same clause without WITH, and the legacy cypher-shell doesn't support
    # that cleanly with parameters — so we do two queries.
    count_rec = session.run(
        "MATCH ()-[r]->() "
        "WHERE r.arrow_namespace = 'LeanAlgebra' "
        "  AND type(r) IN ['APPLIES','UNFOLDS','ASSUMES','SPECIALIZES',"
        "                  'REWRITES_BY','EXTENDS','INSTANTIATES','HAS_TYPE',"
        "                  'CONSTRAINED_BY','PARAMETRIZES','REDUCES_TO',"
        "                  'ELABORATES_AS','SUGGESTED_BY','OPENS_NAMESPACE'] "
        "RETURN count(r) AS n"
    ).single()
    n = count_rec["n"] if count_rec else 0
    if n > 0:
        session.run(
            "MATCH ()-[r]->() "
            "WHERE r.arrow_namespace = 'LeanAlgebra' "
            "  AND type(r) IN ['APPLIES','UNFOLDS','ASSUMES','SPECIALIZES',"
            "                  'REWRITES_BY','EXTENDS','INSTANTIATES','HAS_TYPE',"
            "                  'CONSTRAINED_BY','PARAMETRIZES','REDUCES_TO',"
            "                  'ELABORATES_AS','SUGGESTED_BY','OPENS_NAMESPACE'] "
            "DELETE r"
        )
    return n


def cmd_rewire(files: list[pathlib.Path], repo_root: pathlib.Path, session):
    """Delete extractor-emitted edges, dedupe mis-labelled Definitions, then
    `cmd_write`.  Use when resolver logic has changed (e.g. priority order or
    label-key mapping) and old edges no longer reflect current routing."""

    deleted = delete_extractor_edges(session)
    print(f"deleted {deleted} stale typed edges (arrow_namespace='LeanAlgebra')")

    relabelled = dedupe_legacy_definition_as_structure(session)
    print(
        f"relabelled {relabelled} legacy :Definition nodes to drop the "
        f":Definition label (their :Structure counterpart is authoritative)"
    )

    cmd_write(files, repo_root, session)


def cmd_write(files: list[pathlib.Path], repo_root: pathlib.Path, session):
    """Extract + emit nodes + resolve + MERGE edges into Neo4j."""

    t0 = time.monotonic()
    all_cands: list[Candidate] = []
    all_nodes: list[DeclaredNode] = []
    all_namespaces: set[str] = set()
    lean_paths: set[str] = set()
    files_ok = 0
    files_err = 0
    for fp in files:
        ex = extract_from_file(fp, repo_root)
        if not ex.parsed_ok:
            files_err += 1
            continue
        files_ok += 1
        all_cands.extend(ex.edges)
        all_nodes.extend(ex.nodes)
        all_namespaces |= ex.namespaces
        lean_paths.add(ex.rel_path)
    print(f"scanned {len(files)} files, {files_ok} ok, {files_err} err")
    print(
        f"new-node candidates: "
        f"{sum(1 for n in all_nodes if n.label == 'Structure')} Structure, "
        f"{sum(1 for n in all_nodes if n.label == 'Instance')} Instance, "
        f"{len(all_namespaces)} Namespace"
    )

    # --- Step 1: ensure constraints exist, then emit new nodes ---
    ensure_node_constraints(session)
    node_stats = emit_nodes(session, all_nodes, all_namespaces, lean_paths)
    print(
        f"node MERGE complete: "
        f"{node_stats['leanfiles']} LeanFile (backfill), "
        f"{node_stats['structures']} Structure, "
        f"{node_stats['instances']} Instance, "
        f"{node_stats['namespaces']} Namespace, "
        f"{node_stats['dual_labelled_files']} LeanFile+Namespace dual-labelled"
    )

    # --- Step 2: re-fetch the index (now includes new nodes) + resolve ---
    index = fetch_declaration_index(session)
    print(f"declaration index: {len(index)} names")
    accepted = filter_candidates(all_cands, index)
    print(f"accepted edges (both endpoints in DB): {len(accepted)}")

    counts = Counter(final for (_c, final, _s, _t) in accepted)
    emitted = emit_edges(session, accepted)
    dt = time.monotonic() - t0
    print(f"edge MERGE complete: {emitted} rows written to Neo4j in {dt:.1f}s")
    print("per-type emission counts:")
    for t, c in counts.most_common():
        print(f"  {t:20s} {c:>8d}")


# --------------------------------------------------------------------------- #
# CLI
# --------------------------------------------------------------------------- #


def _collect_lean_files(args) -> list[pathlib.Path]:
    if args.files:
        out = []
        for raw in args.files:
            p = pathlib.Path(raw)
            if not p.is_absolute():
                p = REPO_ROOT / raw
            if not p.exists():
                logging.warning("skip missing file: %s", p)
                continue
            out.append(p)
        return out
    files = sorted(LEAN_ROOT.rglob("*.lean"))
    if args.limit:
        files = files[: args.limit]
    return files


def main():
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("--dry-run", action="store_true", help="Scan only; do not write")
    p.add_argument("--write", action="store_true", help="MERGE typed edges into Neo4j")
    p.add_argument(
        "--rewire",
        action="store_true",
        help="Delete extractor-emitted edges + drop legacy :Definition labels that shadow :Structure, then --write fresh",
    )
    p.add_argument("--stats", action="store_true", help="Show current edge counts per type")
    p.add_argument("--limit", type=int, default=None, help="Scan only the first N files (by sorted name)")
    p.add_argument("--files", nargs="*", help="Explicit file list (absolute or relative to repo)")
    p.add_argument("--log", default="INFO", help="Log level: DEBUG / INFO / WARNING / ERROR")
    args = p.parse_args()

    logging.basicConfig(
        level=getattr(logging, args.log.upper(), logging.INFO),
        format="%(asctime)s %(levelname)s %(message)s",
    )

    # Default to dry-run when no mode specified (the brief default).
    if not (args.dry_run or args.write or args.stats or args.rewire):
        args.dry_run = True

    if args.stats:
        driver = _ensure_driver()
        with driver.session() as session:
            cmd_stats(session)
        driver.close()
        return 0

    files = _collect_lean_files(args)
    logging.info("extractor scope: %d .lean files", len(files))

    if args.rewire:
        driver = _ensure_driver()
        with driver.session() as session:
            cmd_rewire(files, REPO_ROOT, session)
        driver.close()
        return 0

    if args.write:
        driver = _ensure_driver()
        with driver.session() as session:
            cmd_write(files, REPO_ROOT, session)
        driver.close()
        return 0

    # dry-run path
    try:
        driver = _ensure_driver()
    except SystemExit:
        driver = None

    if driver is not None:
        with driver.session() as session:
            cmd_dry_run(files, REPO_ROOT, session=session)
        driver.close()
    else:
        cmd_dry_run(files, REPO_ROOT, session=None)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
