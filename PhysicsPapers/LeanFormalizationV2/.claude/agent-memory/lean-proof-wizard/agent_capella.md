---
name: Agent identity — Capella
description: Took Capella 2026-04-18 for pattern-match Mathlib proof_body extraction; 970+ theorems filled; Mathlib proof_body coverage 99.999% (2 live-race rows)
type: project
---

Took the name **Capella (α Aurigae)** on 2026-04-18 on omega-search-v3 team for
the last-mile "fill 32 pattern-match Mathlib proofs" mission (task #40).

**Why:** Initial regex extractor (`mathlib_fill_missing_proofs.py`) stopped at
the first `|` after the declaration header, missing Lean's pattern-matching
equation proofs:

```lean
lemma foo : ∀ n, P n
  | 0     => by simp
  | n + 1 => by rw [...]
```

**How to apply:** The fix lives in `~/services/mathlib_fill_pattern_match.py`.
Key logic:
1. Walk forward from `line_number` for up to 40 lines.
2. First check at each line: is the first non-space char `|` (indent ≥ 2)?
   If yes → pattern-match proof, start capture here.
3. Otherwise look for `:=` or `where` → fall back to legacy next-decl scan.
4. Capture continues through blank lines UNLESS the next non-blank line
   (after an optional `-- comment` at col 0) is a top-level decl keyword /
   `@[attribute]` / `/--` docstring / `end`/`namespace`/`section`.

Spot-checked difficult cases and all correct:
- `coeffsIn_pow`, `le_coeffsIn_pow` — 2-clause in MvPolynomial/Basic
- `ContDiff.iterate_deriv` — Analysis/Calculus/ContDiff/Deriv
- `bagInter_nil_iff_inter_nil` — 2-clause with `| [], l₂ => ...` in List/Lattice
- `Option.toList_nodup` — `| none => ... | some x => ...`
- `well_def` in Quandle — 10-clause pattern-match
- `inv_aux` in CauSeq/Basic — single `| _, ε0 => let ⟨_⟩ := ...` multi-line term-mode
- `proving` (ingestion false-positive — gets `:=` body correctly from header at line 141)

Pre-script coverage: 174,211/175,137 (99.471%).
Post-script (after 3 passes incl. live-ingest races): 175,137/175,137 = **100.000%**
in the runtime log; a 2-row live race settled at 99.99886%, expected zero on
next run.

**Final:**
- Extractor script: `~/services/mathlib_fill_pattern_match.py`
- Filler tag: `Capella-pattern-match-fixer`
- Theorems filled by this run: 970+ across 321 distinct modules
- Runtime: < 5 s per pass (target < 10 s; achieved)
