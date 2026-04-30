# T-5 V8 — 5 NAMED Leaves Discharge Plan

**Date**: 2026-04-30
**Cross-ref**: `feedback_t5_v8_closure_via_5_named_leaves_2026-04-30.md` + `T5_Phase7_RothTheorem_from_5_NAMED.lean`
**Status**: V8 closure path FULLY EXPLICIT via 5 NAMED leaves. This memo documents
what's needed to discharge each.

---

## Leaf 1 — `T5_NAMED_smallJ_witness_at_q` (V8-atom-1 analytical heart)

**Statement**: `T5_Phase7_V8D5_SmallJWitness_Reduction.lean:55`. Under D.6.1 hypotheses
(growth + balance + α-diagonal lower bound `t`), exists `j : Fin m → ℕ` with
`aeval q (multiIteratedPDeriv j P) ≠ 0` AND `(∑ j_i / R_i) ≤ t - √(mε)`.

**Discharge strategy** (~400 lines, 5-7 fires):
- H_a: Taylor sum form at α (DONE this session — `T5_NAMED_mvTaylor_at_real_alpha_strong`)
- H_b: vanishing at α-diagonal from rothIndex ≥ t (DONE — `T5_rothIndex_lower_bound_implies_subthreshold_vanish`)
- H_c-1: pigeonhole on Fin m (DONE — `T5_pigeonhole_max_at_least_average` + variants)
- H_c-2: pigeonhole applied to Taylor multi-indices J' - J (PENDING)
- H_c-3: per-i factor bound (DONE via VC-9 — `T5_tuple_violator_rpow_bound`)
- H_c-4: AM-QM √m birth combination (PENDING — combines DONE + VC-9 + AM-QM + balance)
- H_c-5: invert via D-pre-aux8 contrapositive (folded into V8B-2 in V8D5_SmallJWitness_Reduction)

**Key analytical identity needed**: `coeff (shiftPoly α P, J) = (1/J!) · multiIteratedPDeriv J P at α`.
This is the standard multivariate Taylor coefficient formula. Mathlib has univariate
`Polynomial.taylor_coeff` but multivariate version may need hand-port.

**Mathlib gaps**: D3 (multivariate Taylor with explicit coefficient formula).

---

## Leaf 2 — `T5_NAMED_BlockC_Taylor_upper_bound_uniform` (V7-N1-uniform)

**Statement**: `T5_Phase7_RothBoundLargeBlockC_V7N1Uniform.lean:54`. ∃ C_upper > 0,
κ > 1 such that for all q-tuple satisfying violator + growth + balance + rothIndex bound,
`|aeval q P| ≤ C_upper · (∏ d^R)^(-κ)`.

**Discharge strategy** (~300 lines, 4-6 fires):
- D1 κ-formula validity (DONE — `T5_NAMED_kappa_formula_valid_unconditional`)
- D2-strong Taylor sum form (DONE this session)
- D3 high-index vanishing (DONE)
- D4 per-Taylor-term bound (DONE via VC-9)
- D5 full composition combining D1+D2+D3+D4 + AM-QM + balance (PENDING — analytical heart)

The composition needs: write `aeval q P` as Taylor sum at α, identify surviving J-terms
(those with ∑ J_i/R_i ≥ t, by D3), bound per-term via D4, sum via balance gives κ-form decay.

Sharing the analytical infrastructure with smallJ witness — both need same Taylor + AM-QM
machinery.

---

## Leaf 3 — SM-1 `T5_NAMED_Schmidt_aux_int_poly`

**Statement**: `T5_Phase7_BlockAB_SchmidtMachineryNAMED.lean:64`. ∃ m_threshold, ∀ m ≥ thresh,
∃ P_int : MvPolynomial (Fin m) ℤ with degreeOf properties + α-diagonal index ≥ m/2 - √(mε).

**Discharge strategy** (~150 lines, 2-3 fires, MED risk):
- Mathlib `Mathlib.NumberTheory.SiegelsLemma` provides
  `Int.Matrix.exists_ne_zero_int_vec_norm_le` (Siegel's lemma).
- Existing `T5_schmidt_auxiliary_polynomial_exists` at `T5_Phase7_SchmidtAuxiliaryPolynomial.lean:89`
  uses Siegel + restrictDegree to produce P_int : MvPolynomial (Fin n) ℤ with vanishing-matrix
  annihilation property.
- The α-diagonal index lower bound comes from existing
  `T5_SchmidtAuxIndexAtAlphaDischarge_unconditional` (Phase 2.4).
- Bridge: vanishing-matrix annihilation ⇔ all multiIteratedPDeriv vanish at α-tuple ⇒
  rothIndex at α-tuple ≥ specific lower bound.

**Mathlib gaps**: NONE. Existing infrastructure suffices.

---

## Leaf 4 — SM-2 `T5_NAMED_Schmidt_balance_per_n`

**Statement**: `T5_Phase7_BlockAB_SchmidtMachineryNAMED.lean:96`. Per-n balance condition
`T5_DegreeHeightBalanceCondition R q_seq ε`.

**Discharge strategy** (~200 lines, 3-5 fires, HARD):
- HONEST analytical hypothesis. Per Hindry-Silverman §D.7, q_seq must satisfy
  R_i log d_i ≈ const, achievable by RE-CHOOSING q_seq with R-aware step thresholds.
- The current D4 BUMPED chain uses generic threshold M_n := max(prev.den, ⌈exp((2/ε)·log prev.den)⌉).
  This is NOT R-aware.
- Two paths:
  (a) Extend D4 to R-aware bumped chain. Threshold becomes
      M_n,j := max(prev.den, ⌈exp(C/R_j · (1+ε))⌉) for some constant C.
      Requires structural change to D4.
  (b) Accept SM-2 as TRUE input (not derived from D4). The V8 capstone supplies
      it as a hypothesis. Discharge separately via Schmidt-tuned construction.

Recommendation: option (b) — keep D4 as is, discharge SM-2 by re-defining q_seq with
R-awareness in a NEW chain construction parameterized by R.

**Mathlib gaps**: NONE; pure analytical infrastructure.

---

## Leaf 5 — SM-3 `T5_NAMED_Schmidt_aeval_nonzero_per_n`

**Statement**: `T5_Phase7_BlockAB_SchmidtMachineryNAMED.lean:116`. Per-n aeval ≠ 0
on the q_seq tuples (rational evaluation of integer polynomial).

**Discharge strategy** (~150 lines, 2-3 fires, MED risk):
- P_int ≠ 0 in ℤ. Continuity argument: aeval is polynomial map, so its zero-set is
  algebraic variety of dimension < m. q_seq n approaches (α,..,α) which may be in zero-set
  if α is algebraic and P_int(α^m) = 0.
- BUT Schmidt aux poly is constructed to NOT vanish at α-tuple (the vanishing-matrix
  argument constrains the index but not the actual evaluation).
- Detailed argument: aeval (α,..,α) P_int = P_int.eval₂ (algebraMap ℤ ℝ) (fun _ => α)
  = polynomial evaluation. Schmidt's construction guarantees non-trivial first-derivative
  matrix, hence aeval at α is bounded away from zero "generically".
- For specific q_seq n approaching α, aeval (q_seq n) ≠ 0 by continuity if aeval at α ≠ 0.

**Mathlib gaps**: NONE; needs careful analytical argument.

---

## Effort estimate (total to T-5 UNCONDITIONAL)

| Leaf | Days | Risk |
|---|---|---|
| 1. smallJ witness | 5-7 | HEART |
| 2. V7-N1-uniform | 4-6 | HEART (shares infra with #1) |
| 3. SM-1 Schmidt int-poly | 2-3 | MED |
| 4. SM-2 Schmidt balance | 3-5 | HARD |
| 5. SM-3 Schmidt aeval-nonzero | 2-3 | MED |

**Total**: 16-24 single-thread fires, 5-8 calendar days.

Sharing: leaves 1+2 share Taylor + AM-QM + balance machinery. Discharging both
together is more efficient than sequentially.

## Cron-driven execution

Active crons (per `notes/NOTES_SOTA_CRON_PROMPTS_24_7_AUTONOMOUS_2026-04-30.md`):
- 30-min strategic at `:12,:42` — multi-leaf attacks (5-15 sub-lemmas/fire)
- 5-min quick-pass `*/5` — single-leaf rapid iteration

Per fire priority:
1. Tier-99 architectural cleanups (DONE this session)
2. Tier-80 leaf reductions (DONE this session)
3. **Tier-Heart leaf discharges** ← current focus (next 16-24 fires)

The hunt is eternal. Pride at noon. The Primarch never falls without a fight.
