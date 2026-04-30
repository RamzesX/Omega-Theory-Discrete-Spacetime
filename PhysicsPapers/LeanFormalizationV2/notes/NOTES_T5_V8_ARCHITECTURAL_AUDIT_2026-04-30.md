# T-5 V8 Architectural Audit — 2026-04-30

## Discovery

Three of seven outer NAMED leaves of V8R7 are LITERAL FALSE as written:

1. **`T5_NAMED_small_eps_axis_in_V8`** — quantifier mismatch
   - Stated: `∀ {m} ≥ 1, ∀ ε > 0, ε ≤ m³/16`
   - Counter: m=3, ε=100 ⇒ 27/16 < 100 falsifies
   - Fix: `T5_NAMED_small_eps_axis_existential : ∀ ε > 0, ∃ m ≥ 1, ε ≤ m³/16`

2. **`T5_NAMED_Schmidt_balance_per_n`** — universal q_seq
   - Stated: ∀ q_seq satisfying violator + growth, ∀ n, balance R q_seq holds
   - Counter: any non-R-aware q_seq violates balance
   - Fix: joint existence (P_int, q_seq) where balance proven for THIS specific q_seq

3. **`T5_NAMED_Schmidt_aeval_nonzero_per_n`** — universal q_seq
   - Stated: ∀ q_seq satisfying violator, ∀ n, aeval q_seq P_int ≠ 0
   - Counter: any q_seq with q.0 a rational root of P_int evaluates to 0
   - Fix: joint existence (P_int, q_seq) where aeval ≠ 0 proven for THIS specific q_seq

## Architectural Closures Landed (this fire, 2026-04-30)

**Build delta**: 4637 → 4642 jobs GREEN. Axiom audit Lean-core only on all new theorems.

Files (all in `OmegaTheory/Irrationality/CustomMath/`):

1. `T5_Phase7_SM1_ExistenceUnconditional.lean` (167 lines)
   - SM1EU-7 = `T5_Schmidt_existence_int_poly_unconditional` UNCONDITIONAL
   - Witness: `P_int := ∑ i, X i`
   - Closes 1 of 8 atomic inner NAMED leaves (existence half of SM-1)

2. `T5_Phase7_Schmidt_JointExistence.lean` (151 lines)
   - SJE-1 = `T5_NAMED_Schmidt_joint` (single existential replacing SM-1+SM-2+SM-3)
   - SJE-2/SJE-3 extract existential SM-2/SM-3 from joint
   - Architectural compactification

3. `T5_Phase7_SmallEpsAxis_Existential.lean` (89 lines)
   - SEAE-2 = `T5_NAMED_small_eps_axis_existential_unconditional` UNCONDITIONAL
   - Witness: `m := Nat.ceil(16ε)+1`
   - Replaces literal-false universal small-eps axis

4. `T5_Phase7_RothTheorem_WLOG_eps_le_1.lean` (129 lines)
   - RW-3 = `T5_RothTheorem_via_eps_le_1` UNCONDITIONAL bridge
   - Strategy: case ε ≤ 1 direct; case ε > 1 reduce via `Real.rpow_le_rpow_of_exponent_le`
   - Combined with Schmidt m ≥ 3, makes small-ε constraint automatic

5. `T5_Phase7_V8_NAMEDLeafAudit.lean` (199 lines)
   - VLA-1/2/3 paper-citable architectural audit headlines
   - Documents all 5 closures + remaining HEART analytical content

## Net architectural progress

V8R7 (7 outer NAMED) → V8R3 architecturally reducible via:
- small-eps universal → small-eps existential (SEAE-2 unconditional)
- WLOG ε ≤ 1 absorbs the existential into V8R5's flow (RW-3 bridge)
- SM-1+SM-2+SM-3 universal → Schmidt joint existence (SJE-1)

V8R3 outer NAMED leaves:
- **SJWC-1** = `T5_NAMED_index_at_q_strict_upper_bound` (HEART analytical, ~300 lines)
- **UWF-2** = `T5_NAMED_support_extraction_at_zero` (Mathlib Taylor coeff, ~150 lines)
- **V7N1U** = `T5_NAMED_BlockC_Taylor_upper_bound_uniform` (HEART D5 κ, ~200 lines)
- **Schmidt-joint** = `T5_NAMED_Schmidt_joint` (full §D.7 content, ~400 lines)

Total HEART remaining: ~1100 lines analytical. Realistic single-thread completion: 3-6 weeks sustained.

## Open work for future fires

1. Wire V8R3 capstone using SJE-1 + RW-3 + SEAE-2 to actually deliver V8R7→V8R3 reduction in code (currently architectural-only; capstone-level rewiring of V8R5 needed).

2. Push HEART analytical leaves:
   - SJWC-1 (top priority — analytical heart of smallJ witness)
   - V7N1U-D5 κ-composition (Taylor decay)
   - Schmidt joint discharge (Hindry-Silverman §D.7 full)
   - UWF-2 Taylor coeff at zero (Finsupp arithmetic)

3. Yoneda bridge sweep on the 5 new closures once graph refresh runs.

## References

- File:line for all theorems via T5_Phase7_V8_NAMEDLeafAudit.lean
- Main plan: `~/.claude/plans/binary-painting-dijkstra.md`
- Mathlib lemmas used: `MvPolynomial.coeff_X`, `MvPolynomial.monomial_le_degreeOf`,
  `Real.rpow_le_rpow_of_exponent_le`, `Nat.le_ceil`, `Finsupp.single_left_inj`

## Sources

- Hindry-Silverman *Diophantine Geometry* §D.6 + §D.7
- Mathlib v4.29.0 `MvPolynomial.Degrees`, `Real.rpow`, `Finsupp.single`
- T5_RothMasterStatement — RothTheorem definition
- ErdosPrimarch v8.0 (`~/.claude/CLAUDE.md` BOOK_I-VIII)
