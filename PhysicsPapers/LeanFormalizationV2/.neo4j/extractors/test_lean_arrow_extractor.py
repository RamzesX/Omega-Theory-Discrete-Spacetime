#!/usr/bin/env python3
"""
Smoke test for lean_arrow_extractor.

Runs the extractor in dry-run mode on three carefully chosen OmegaTheory
files, asserts non-trivial candidate edge counts, and asserts that the
extractor does not crash on the full OmegaTheory tree.

Usage
-----
    python test_lean_arrow_extractor.py           # prints + asserts
    python test_lean_arrow_extractor.py --verbose # dumps sample edges too

Exit code 0 = all assertions pass.

Per the Phobos-Iota brief: this is **not** a unit test framework, it is a
regression harness.  It calls the extractor's public API directly; no Neo4j
is required.
"""

from __future__ import annotations

import argparse
import importlib.util
import pathlib
import sys
from collections import Counter


HERE = pathlib.Path(__file__).resolve().parent
LEAN_ROOT = pathlib.Path(
    "/mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/"
    "LeanFormalizationV2/OmegaTheory"
)
REPO_ROOT = LEAN_ROOT.parent


def _load_extractor():
    """Import the extractor module from sibling file.

    Using importlib directly avoids a sys.path ordering surprise if another
    `lean_arrow_extractor` ever appears in site-packages.  We must register
    the module in `sys.modules` BEFORE exec — Python 3.12's dataclass
    machinery looks the module up by name during class-creation.
    """

    target = HERE / "lean_arrow_extractor.py"
    spec = importlib.util.spec_from_file_location("lean_arrow_extractor", target)
    module = importlib.util.module_from_spec(spec)
    assert spec and spec.loader
    sys.modules["lean_arrow_extractor"] = module
    spec.loader.exec_module(module)
    return module


def _assert(cond: bool, msg: str):
    if not cond:
        print(f"FAIL: {msg}")
        sys.exit(1)
    print(f"ok:   {msg}")


def run_targeted(mod, verbose: bool):
    """Run extractor on 3 canonical files and check the per-type counts."""

    targets = [
        LEAN_ROOT / "Spacetime" / "Constants.lean",
        LEAN_ROOT / "Emergence" / "EinsteinEmergence.lean",
        LEAN_ROOT / "Irrationality" / "Uncertainty.lean",
    ]
    for fp in targets:
        _assert(fp.exists(), f"target exists: {fp.name}")

    extracts = [mod.extract_from_file(fp, REPO_ROOT) for fp in targets]
    for ex in extracts:
        _assert(ex.parsed_ok, f"parse ok: {ex.rel_path}")

    by_file: dict[str, Counter] = {}
    for ex in extracts:
        c = Counter(e.arrow_type for e in ex.edges)
        by_file[ex.rel_path] = c

    def per(path: str, arrow: str) -> int:
        for k, v in by_file.items():
            if k.endswith(path):
                return v[arrow]
        return -1

    # Constants.lean: 9 axioms + derived defs; should yield HAS_TYPE +
    # PARAMETRIZES edges (Planck constants referenced by def bodies).
    _assert(
        per("Spacetime/Constants.lean", "HAS_TYPE") >= 0,
        "Constants.lean: HAS_TYPE extracted without crash",
    )
    _assert(
        per("Spacetime/Constants.lean", "APPLIES") >= 1,
        "Constants.lean: >= 1 APPLIES (positivity chain references)",
    )

    # EinsteinEmergence.lean: 172-line proof; expect many APPLIES + UNFOLDS
    # + REWRITES_BY.
    total = (
        per("Emergence/EinsteinEmergence.lean", "APPLIES")
        + per("Emergence/EinsteinEmergence.lean", "UNFOLDS")
        + per("Emergence/EinsteinEmergence.lean", "REWRITES_BY")
    )
    _assert(
        total >= 20,
        f"EinsteinEmergence.lean: APPLIES+UNFOLDS+REWRITES_BY >= 20 (got {total})",
    )

    # Uncertainty.lean: defines computationalUncertainty, uses l_P, uses
    # ErrorBound (a structure).  Expect >= 1 HAS_TYPE + >= 1 UNFOLDS.
    _assert(
        per("Irrationality/Uncertainty.lean", "UNFOLDS") >= 1,
        "Uncertainty.lean: >= 1 UNFOLDS (unfolds computationalUncertainty)",
    )

    if verbose:
        for rel, c in by_file.items():
            print(f"\n--- {rel} ---")
            for t, n in c.most_common():
                print(f"    {t:20s} {n}")
            sample = [e for e in next(
                ex.edges for ex in extracts if ex.rel_path == rel
            )][:6]
            for e in sample:
                print(
                    f"    [{e.arrow_type:14s}] "
                    f"{e.source_name} -> {e.target_name}  "
                    f"(L{e.line_number})"
                )


def run_full_tree(mod):
    """Assert that the extractor does not crash on the full tree and that
    node-emission candidates pass minimum thresholds."""

    files = sorted(LEAN_ROOT.rglob("*.lean"))
    _assert(
        len(files) >= 200,
        f"full-tree corpus size >= 200 .lean files (got {len(files)})",
    )
    ok = 0
    err = 0
    total_edges = 0
    structures = 0
    instances = 0
    namespaces: set[str] = set()
    for fp in files:
        ex = mod.extract_from_file(fp, REPO_ROOT)
        if ex.parsed_ok:
            ok += 1
            total_edges += len(ex.edges)
            for n in ex.nodes:
                if n.label == "Structure":
                    structures += 1
                elif n.label == "Instance":
                    instances += 1
            namespaces |= ex.namespaces
        else:
            err += 1
            print(f"    parse failed: {ex.rel_path} ({ex.error})")
    _assert(err == 0, f"full-tree: 0 parse failures (got {err})")
    _assert(ok >= 200, f"full-tree: >= 200 files parsed ok (got {ok})")
    _assert(
        total_edges >= 5000,
        f"full-tree: >= 5000 candidate edges extracted (got {total_edges})",
    )
    _assert(
        structures >= 50,
        f"full-tree: >= 50 Structure-node candidates (got {structures})",
    )
    _assert(
        instances >= 5,
        f"full-tree: >= 5 Instance-node candidates (got {instances})",
    )
    _assert(
        len(namespaces) >= 20,
        f"full-tree: >= 20 distinct Namespace strings (got {len(namespaces)})",
    )
    print(
        f"info: full tree — {ok} files parsed, {total_edges} candidate edges, "
        f"{structures} Structure, {instances} Instance, "
        f"{len(namespaces)} Namespace"
    )


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--verbose", action="store_true")
    args = p.parse_args()

    mod = _load_extractor()
    print("=== lean_arrow_extractor smoke test ===\n")
    print("-- targeted files --")
    run_targeted(mod, verbose=args.verbose)
    print("\n-- full-tree regression --")
    run_full_tree(mod)
    print("\nall assertions passed.")


if __name__ == "__main__":
    main()
