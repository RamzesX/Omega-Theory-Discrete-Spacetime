#!/usr/bin/env python3
"""
Cataloguer agent: scan all OmegaTheory V2 Lean files, extract declarations,
and emit Cypher statements that populate the Neo4j graph.

Outputs three files:
  - catalogue_files.cypher       (LeanFile nodes + EntityNavigator CONTAINS edges)
  - catalogue_declarations.cypher (Axioms, Theorems, Definitions + DECLARES edges)
  - catalogue_imports.cypher     (IMPORTS edges between LeanFile nodes)

Run as:
  python3 .neo4j/catalogue_scan.py
"""
from __future__ import annotations

import os
import re
from pathlib import Path

ROOT = Path('/mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/LeanFormalizationV2')
OMEGA = ROOT / 'OmegaTheory'
OUT_DIR = ROOT / '.neo4j'

# Regexes anchored at start-of-line to avoid comments / nested versions.
# Note: Lean often prefaces with 'protected', 'private', etc.
# We allow optional modifiers before the keyword.
MOD_PREFIX = r'(?:(?:@\[[^\]]*\]\s*)?(?:protected\s+|private\s+|noncomputable\s+|unsafe\s+|partial\s+|@\[[^\]]*\]\s*)*)'

# Helper: a Lean identifier (allow dots for namespaced names)
# Unicode-aware: matches Greek letters (δ, μ, ν, Λ, π, …), subscripts (₀–₉),
# blackboard letters (ℝ, ℂ, ℤ, …), plus ASCII letters/digits/underscore/dot/prime/bang.
# `[^\W\d]` = Unicode word char but not digit = letter or underscore.
IDENT = r'[^\W\d][\w\.\'\!₀₁₂₃₄₅₆₇₈₉ℝℂℤℕℚℙΛ]*'

RE_AXIOM     = re.compile(rf'^\s*{MOD_PREFIX}axiom\s+({IDENT})', re.MULTILINE)
RE_THEOREM   = re.compile(rf'^\s*{MOD_PREFIX}theorem\s+({IDENT})', re.MULTILINE)
RE_LEMMA     = re.compile(rf'^\s*{MOD_PREFIX}lemma\s+({IDENT})', re.MULTILINE)
RE_DEF       = re.compile(rf'^\s*{MOD_PREFIX}def\s+({IDENT})', re.MULTILINE)
RE_STRUCTURE = re.compile(rf'^\s*{MOD_PREFIX}structure\s+({IDENT})', re.MULTILINE)
RE_INDUCTIVE = re.compile(rf'^\s*{MOD_PREFIX}inductive\s+({IDENT})', re.MULTILINE)
RE_CLASS     = re.compile(rf'^\s*{MOD_PREFIX}class\s+({IDENT})', re.MULTILINE)
RE_ABBREV    = re.compile(rf'^\s*{MOD_PREFIX}abbrev\s+({IDENT})', re.MULTILINE)
RE_INSTANCE  = re.compile(rf'^\s*{MOD_PREFIX}instance\s+({IDENT})\s*:', re.MULTILINE)

# Imports — any OmegaTheory.<module path>
RE_IMPORT = re.compile(r'^\s*import\s+(OmegaTheory(?:\.[A-Za-z_][A-Za-z0-9_\.]*)+)', re.MULTILINE)

# Directory -> EntityNavigator layer mapping
DIR_TO_LAYER = {
    'Foundations':   'Foundations',
    'Spacetime':     'Spacetime',
    'Tensor':        'Tensor',
    'Geometry':      'Geometry',
    'Defects':       'Defects',
    'Conservation':  'Conservation',
    'HealingFlow':   'HealingFlow',
    'Emergence':     'Emergence',
    'Torsion':       'Torsion',
    'Irrationality': 'Irrationality',
    'Variational':   'Variational',
}


def strip_comments(text: str) -> str:
    """Remove block comments /- ... -/ (can be nested) and line comments -- ..."""
    # Strip nested block comments first
    out = []
    i = 0
    n = len(text)
    depth = 0
    in_string = False
    while i < n:
        c = text[i]
        if not in_string and depth == 0 and c == '-' and i + 1 < n and text[i+1] == '-':
            # line comment to end of line
            j = text.find('\n', i)
            if j == -1:
                break
            out.append('\n')  # preserve line count
            i = j + 1
            continue
        if not in_string and c == '-' and i + 1 < n and text[i+1] == '/' and depth > 0:
            depth -= 1
            i += 2
            continue
        if not in_string and c == '/' and i + 1 < n and text[i+1] == '-':
            depth += 1
            i += 2
            continue
        if depth > 0:
            # preserve newlines for line anchoring accuracy
            if c == '\n':
                out.append('\n')
            i += 1
            continue
        if c == '"' and (i == 0 or text[i-1] != '\\'):
            in_string = not in_string
        out.append(c)
        i += 1
    return ''.join(out)


def layer_for_path(rel_path: Path) -> str | None:
    parts = rel_path.parts
    # rel_path starts with 'OmegaTheory'
    if len(parts) < 3:
        return None  # Root-level file like OmegaTheory/Basic.lean
    dir_name = parts[1]
    return DIR_TO_LAYER.get(dir_name)


def normalize_name(full_name: str) -> str:
    """
    Strip leading namespace components like 'OmegaTheory.Geometry.'.
    Keep only the last dotted segment unless the name itself is qualified
    inside a namespace like 'SemiSmoothMetric.foo'.
    Heuristic: if the full name starts with 'OmegaTheory.', strip everything
    up to the last component. Otherwise return as-is.
    """
    if full_name.startswith('OmegaTheory.'):
        # Drop OmegaTheory.X.Y. prefix
        parts = full_name.split('.')
        return parts[-1]
    return full_name


def escape_cypher(s: str) -> str:
    return s.replace('\\', '\\\\').replace("'", "\\'")


def main():
    files = sorted(OMEGA.rglob('*.lean'))
    print(f'Found {len(files)} Lean files')

    file_rows = []          # (path, layer, declarations_count)
    all_axioms = []         # (file_path, layer, name)
    all_theorems = []       # (file_path, layer, name)
    all_defs = []           # (file_path, layer, name, is_structure, kind)
    import_edges = []       # (from_path, to_module_qualified, to_path)

    for fp in files:
        rel = fp.relative_to(ROOT)
        rel_str = rel.as_posix()
        layer = layer_for_path(rel)
        text = fp.read_text(encoding='utf-8', errors='replace')
        clean = strip_comments(text)

        # Declarations
        axioms = set()
        for m in RE_AXIOM.finditer(clean):
            axioms.add(normalize_name(m.group(1)))

        theorems = set()
        for m in RE_THEOREM.finditer(clean):
            theorems.add(normalize_name(m.group(1)))
        for m in RE_LEMMA.finditer(clean):
            theorems.add(normalize_name(m.group(1)))

        defs = {}  # name -> (is_structure, kind)
        for m in RE_DEF.finditer(clean):
            n = normalize_name(m.group(1))
            defs.setdefault(n, (False, 'def'))
        for m in RE_ABBREV.finditer(clean):
            n = normalize_name(m.group(1))
            defs.setdefault(n, (False, 'abbrev'))
        for m in RE_STRUCTURE.finditer(clean):
            n = normalize_name(m.group(1))
            defs[n] = (True, 'structure')
        for m in RE_INDUCTIVE.finditer(clean):
            n = normalize_name(m.group(1))
            defs[n] = (True, 'inductive')
        for m in RE_CLASS.finditer(clean):
            n = normalize_name(m.group(1))
            defs[n] = (True, 'class')
        for m in RE_INSTANCE.finditer(clean):
            n = normalize_name(m.group(1))
            defs.setdefault(n, (False, 'instance'))

        # Imports of OmegaTheory.*
        imports = set()
        for m in RE_IMPORT.finditer(clean):
            mod = m.group(1)  # e.g. OmegaTheory.Geometry.Connection
            # Convert to file path: OmegaTheory/Geometry/Connection.lean
            path = mod.replace('.', '/') + '.lean'
            imports.add(path)

        decl_count = len(axioms) + len(theorems) + len(defs)
        file_rows.append((rel_str, layer, decl_count))

        for a in axioms:
            all_axioms.append((rel_str, layer, a))
        for t in theorems:
            all_theorems.append((rel_str, layer, t))
        for d, (is_struct, kind) in defs.items():
            all_defs.append((rel_str, layer, d, is_struct, kind))
        for imp in imports:
            import_edges.append((rel_str, imp))

    print(f'Stats:')
    print(f'  files       : {len(file_rows)}')
    print(f'  axioms      : {len(all_axioms)}')
    print(f'  theorems    : {len(all_theorems)}')
    print(f'  definitions : {len(all_defs)}')
    print(f'  imports     : {len(import_edges)}')

    # ----- Write Cypher output files -----
    # 1) Files
    with open(OUT_DIR / 'catalogue_files.cypher', 'w') as f:
        f.write('// Auto-generated by catalogue_scan.py — LeanFile nodes\n')
        for path, layer, dc in file_rows:
            f.write(f"MERGE (file:LeanFile {{namespace: 'OmegaTheoryV2', path: '{escape_cypher(path)}'}}) "
                    f"SET file.declarations_count = {dc}")
            if layer is None:
                f.write(f", file.role = 'aggregator';\n")
            else:
                f.write(f";\n")
            if layer is not None:
                f.write(
                    f"MATCH (ent:EntityNavigator {{namespace: 'OmegaTheoryV2', name: '{layer}'}}), "
                    f"(file:LeanFile {{namespace: 'OmegaTheoryV2', path: '{escape_cypher(path)}'}}) "
                    f"MERGE (ent)-[:CONTAINS]->(file);\n"
                )
        f.write("RETURN 'files done' AS status;\n")

    # 2) Declarations
    with open(OUT_DIR / 'catalogue_declarations.cypher', 'w') as f:
        f.write('// Auto-generated — Axioms, Theorems, Definitions\n')

        # Axioms
        for path, layer, name in all_axioms:
            f.write(
                f"MERGE (ax:Axiom {{namespace: 'OmegaTheoryV2', name: '{escape_cypher(name)}'}}) "
                f"SET ax.file = '{escape_cypher(path)}', ax.declaration_type = 'axiom';\n"
                f"MATCH (ax:Axiom {{namespace: 'OmegaTheoryV2', name: '{escape_cypher(name)}'}}), "
                f"(file:LeanFile {{namespace: 'OmegaTheoryV2', path: '{escape_cypher(path)}'}}) "
                f"MERGE (file)-[:DECLARES]->(ax);\n"
            )
            if layer is not None:
                f.write(
                    f"MATCH (ax:Axiom {{namespace: 'OmegaTheoryV2', name: '{escape_cypher(name)}'}}), "
                    f"(ent:EntityNavigator {{namespace: 'OmegaTheoryV2', name: '{layer}'}}) "
                    f"MERGE (ent)-[:DECLARES_AXIOM]->(ax);\n"
                )

        # Theorems
        for path, layer, name in all_theorems:
            f.write(
                f"MERGE (t:Theorem {{namespace: 'OmegaTheoryV2', name: '{escape_cypher(name)}', file: '{escape_cypher(path)}'}}) "
                f"SET t.declaration_type = 'theorem';\n"
                f"MATCH (t:Theorem {{namespace: 'OmegaTheoryV2', name: '{escape_cypher(name)}', file: '{escape_cypher(path)}'}}), "
                f"(file:LeanFile {{namespace: 'OmegaTheoryV2', path: '{escape_cypher(path)}'}}) "
                f"MERGE (file)-[:DECLARES]->(t);\n"
            )

        # Definitions (use same Theorem/Definition convention — Definition label)
        for path, layer, name, is_struct, kind in all_defs:
            props = (
                f"namespace: 'OmegaTheoryV2', name: '{escape_cypher(name)}', "
                f"file: '{escape_cypher(path)}'"
            )
            extra = f", d.is_structure = {'true' if is_struct else 'false'}, d.kind = '{kind}'"
            f.write(
                f"MERGE (d:Definition {{{props}}}) SET d.declaration_type = 'definition'{extra};\n"
                f"MATCH (d:Definition {{{props}}}), "
                f"(file:LeanFile {{namespace: 'OmegaTheoryV2', path: '{escape_cypher(path)}'}}) "
                f"MERGE (file)-[:DECLARES]->(d);\n"
            )

        f.write("RETURN 'declarations done' AS status;\n")

    # 3) Imports
    with open(OUT_DIR / 'catalogue_imports.cypher', 'w') as f:
        f.write('// Auto-generated — IMPORTS edges between LeanFile nodes\n')
        # Group by consumer path
        unique_edges = set((a, b) for a, b in import_edges)
        for a, b in sorted(unique_edges):
            f.write(
                f"MATCH (src:LeanFile {{namespace: 'OmegaTheoryV2', path: '{escape_cypher(a)}'}}), "
                f"(dst:LeanFile {{namespace: 'OmegaTheoryV2', path: '{escape_cypher(b)}'}}) "
                f"MERGE (src)-[:IMPORTS]->(dst);\n"
            )
        f.write("RETURN 'imports done' AS status;\n")

    # 4) Summary stats
    print('\nSample axioms:')
    for path, layer, name in all_axioms[:12]:
        print(f'  {name:50s}  in  {path}')

    # Collision detection — names that appear in multiple files
    from collections import defaultdict
    tname_to_files = defaultdict(set)
    for path, layer, name in all_theorems:
        tname_to_files[name].add(path)
    dname_to_files = defaultdict(set)
    for path, layer, name, is_struct, kind in all_defs:
        dname_to_files[name].add(path)

    collisions = [(n, sorted(paths)) for n, paths in tname_to_files.items() if len(paths) > 1]
    print(f'\nTheorem-name collisions across files: {len(collisions)}')
    for n, paths in collisions[:10]:
        print(f'  {n}')
        for p in paths:
            print(f'    in {p}')

    d_collisions = [(n, sorted(paths)) for n, paths in dname_to_files.items() if len(paths) > 1]
    print(f'\nDefinition-name collisions across files: {len(d_collisions)}')
    for n, paths in d_collisions[:10]:
        print(f'  {n}')
        for p in paths:
            print(f'    in {p}')


if __name__ == '__main__':
    main()
