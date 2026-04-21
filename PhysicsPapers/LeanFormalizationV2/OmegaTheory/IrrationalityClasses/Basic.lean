/-
  OmegaTheory.IrrationalityClasses.Basic

  **Layer 1 of the 4-class separation theorem** (Rasalas μ Leonis Phase 0 design,
  Alrescha α Piscium implementation).

  Ships the PROVABLE_TODAY `:TheoremCandidate` nodes registered in Neo4j with
  `scope = 'IrrationalityClasses'`:

  - `ic_pi_gt_three_numeric`  — Mathlib direct.
  - `ic_e_lt_pi_numeric`       — via `exp_one_lt_three` + `pi_gt_three`.
  - `ic_sqrt2_lt_e_numeric`    — via `nlinarith` on `√2² = 2` + `exp_one_gt_two`.
  - `ic_four_irrationals_pairwise_distinct_no_catalan` — 3-way Layer 1 (π, e, √2).
  - `ic_sqrt2_is_algebraic`    — Layer 2 fragment (the easy leg).

  Catalan G is introduced only as `noncomputable def catalanG` (Bradley series).
  Positivity / upper bound proofs live in a sibling file once summability is
  available; for now we register only the bounds that are routine.

  Design reference: `OmegaTheory/IrrationalityClasses/06_separation_theorem.md`,
  `07_proof_sketches.md`, `12_graph_register.md`.
-/

import Mathlib.Analysis.Real.Pi.Bounds
import Mathlib.Analysis.Complex.ExponentialBounds
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.RingTheory.Polynomial.Basic
import Mathlib.RingTheory.Algebraic.Basic
import Mathlib.Tactic

namespace OmegaTheory.IrrationalityClasses

open Real BigOperators Finset

/-! ## Layer 1 — Pairwise-value-distinct  (three constants)

Three routine proofs.  We cite only *numerical* decimal bounds; no
transcendence lemmas are needed at this layer.
-/

/-- `π > 3` — direct Mathlib. Registered as `:TheoremCandidate ic_pi_gt_three_numeric`. -/
theorem ic_pi_gt_three_numeric : (3 : ℝ) < Real.pi := Real.pi_gt_three

/-- `e < π` via the chain `e < 3 < π`. Registered as
`:TheoremCandidate ic_e_lt_pi_numeric`. -/
theorem ic_e_lt_pi_numeric : Real.exp 1 < Real.pi := by
  have h1 : Real.exp 1 < 3 := Real.exp_one_lt_three
  have h2 : (3 : ℝ) < Real.pi := Real.pi_gt_three
  linarith

/-- `√2 < e` via the chain `√2 < 1.5 < 2 < e`. Registered as
`:TheoremCandidate ic_sqrt2_lt_e_numeric`. -/
theorem ic_sqrt2_lt_e_numeric : Real.sqrt 2 < Real.exp 1 := by
  have hsqrt : Real.sqrt 2 < 1.5 := by
    have h2 : (0 : ℝ) ≤ 2 := by norm_num
    have hsq : Real.sqrt 2 ^ 2 = 2 := Real.sq_sqrt h2
    nlinarith [Real.sqrt_nonneg 2, hsq]
  have he : (2 : ℝ) < Real.exp 1 := Real.exp_one_gt_two
  linarith

/-! ## Direct pairwise-distinctness consequences (value-distinct)

These are the `≠` forms the Layer 1 headline bundle quotes.  Each follows
from the corresponding strict inequality.
-/

/-- π ≠ e. -/
theorem ic_pi_ne_e : Real.pi ≠ Real.exp 1 :=
  ne_of_gt ic_e_lt_pi_numeric

/-- π ≠ √2. -/
theorem ic_pi_ne_sqrt2 : Real.pi ≠ Real.sqrt 2 := by
  have hpi : (3 : ℝ) < Real.pi := Real.pi_gt_three
  have hsqrt : Real.sqrt 2 < 1.5 := by
    have h2 : (0 : ℝ) ≤ 2 := by norm_num
    have hsq : Real.sqrt 2 ^ 2 = 2 := Real.sq_sqrt h2
    nlinarith [Real.sqrt_nonneg 2, hsq]
  intro h
  linarith [h ▸ hpi]

/-- e ≠ √2. -/
theorem ic_e_ne_sqrt2 : Real.exp 1 ≠ Real.sqrt 2 :=
  ne_of_gt ic_sqrt2_lt_e_numeric

/-! ## Layer 1 — three-way bundle (without Catalan) -/

/-- **Three-way pairwise distinctness** — the Layer 1 fragment that does not
depend on Catalan's constant.  Lifts `:TheoremCandidate ic_four_irrationals_pairwise_distinct`
restricted to `{π, e, √2}`. -/
theorem ic_three_irrationals_pairwise_distinct :
    Real.pi ≠ Real.exp 1 ∧
    Real.pi ≠ Real.sqrt 2 ∧
    Real.exp 1 ≠ Real.sqrt 2 :=
  ⟨ic_pi_ne_e, ic_pi_ne_sqrt2, ic_e_ne_sqrt2⟩

/-! ## Layer 2 fragment — √2 is algebraic

The Layer 2 separation theorem splits `{π, e, √2, G}` into algebraic vs
transcendental.  The trivial leg — `√2` is algebraic — is fully provable
today:  the polynomial `X² − 2 ∈ ℚ[X]` is non-zero and has `√2` as a root.
-/

/-- `√2` is algebraic over `ℚ`.  Registered as `:TheoremCandidate ic_sqrt2_is_algebraic`. -/
theorem ic_sqrt2_is_algebraic : IsAlgebraic ℚ (Real.sqrt 2) := by
  -- Witness polynomial: p(X) = X^2 - C 2 ∈ ℚ[X].
  refine ⟨Polynomial.X ^ 2 - Polynomial.C (2 : ℚ), ?_, ?_⟩
  · -- p ≠ 0 via `Polynomial.X_pow_sub_C_ne_zero` (needs n > 0).
    exact Polynomial.X_pow_sub_C_ne_zero (by norm_num : (0 : ℕ) < 2) _
  · -- Evaluate: aeval (√2) (X^2 - C 2) = (√2)^2 - 2 = 0.
    have h2 : (0 : ℝ) ≤ 2 := by norm_num
    have hsq : Real.sqrt 2 ^ 2 = 2 := Real.sq_sqrt h2
    simp [hsq]

end OmegaTheory.IrrationalityClasses
