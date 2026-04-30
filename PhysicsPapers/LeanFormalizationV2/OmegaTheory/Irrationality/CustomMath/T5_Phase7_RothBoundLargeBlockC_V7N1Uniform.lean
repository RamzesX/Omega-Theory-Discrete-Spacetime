/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockC_V7N1Uniform

  T-5 (Roth's theorem) — **V7-N1 UNIFORM VARIANT**: stronger form where
  (C_upper, κ) are uniform across all valid q-tuples (depend only on
  α, ε, m, P, R).

  Critical for V7 capstone composition: the SEQ-3 application form
  (Block CDE collide) requires a SINGLE κ across the entire q-tuple
  sequence.  V7-N1's existential κ is per-q which doesn't directly
  feed into SEQ-3.

  V7-N1-uniform → V7-N1 (forward direction trivially).

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS — NAMED Prop with explicit decomposition
  plan, plus bridge theorems.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV7Draft
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockE_SequenceApplications
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockC_V7N1Uniform

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV7Draft
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTuple
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex

/-! ## V7N1U-1 — V7-N1 UNIFORM NAMED Prop -/

/-- **V7N1U-1 — `T5_NAMED_BlockC_Taylor_upper_bound_uniform`** [NAMED HYPOTHESIS].

    Stronger form of V7-N1: (C_upper, κ) depend only on (α, ε, m, P, R)
    and NOT on the specific q-tuple.  This is the form needed for SEQ-3
    application in V7 capstone composition.

    Discharge plan (next-fire):
    1. Multivariate Taylor expansion at α-diagonal (uses
       `T5_mvTaylor_aeval_at_int_point` with α : Fin m → ℝ general).
    2. High-index ⇒ vanish at α-diagonal for j with ∑ j_i/R_i < t
       (D-pre-aux6 already landed in
       T5_Phase7_RothBoundLargeBlockD_RothIndexPosVanish.lean).
    3. Bound non-vanishing Taylor terms by violator condition VC-9.
    4. Combine with growth + balance: κ formula
       κ = (2+ε)(m/2 - 2√(mε))/m, which is > 1 for m large enough
       relative to ε.
    5. C_upper depends on Taylor coefficient max norm and ε.

    Per project rule §7.0: NAMED Prop with REAL ∃-content + explicit
    decomposition plan, used non-vacuously. -/
def T5_NAMED_BlockC_Taylor_upper_bound_uniform : Prop :=
  ∀ (α : ℝ), Irrational α → IsAlgebraic ℤ α →
  ∀ (ε : ℝ), 0 < ε →
  ∀ {m : ℕ}, 1 ≤ m →
  ∀ (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ),
    P ≠ 0 →
    (∀ i, MvPolynomial.degreeOf i P ≤ R i) →
    (∀ i, 0 < R i) →
  ∃ (C_upper : ℝ) (κ : ℝ),
    0 < C_upper ∧ 1 < κ ∧
    -- κ uniform: same for ALL valid q-tuples
    ∀ (q : Fin m → ℚ),
      (∀ i, q i ∈ T5_RothViolatingSet α ε) →
      T5_DenominatorGrowthCondition q ε →
      T5_DegreeHeightBalanceCondition R q ε →
      rothIndex P (fun i => ((q i : ℚ) : ℝ)) R ≤
        (m : ℝ) / 2 - 2 * Real.sqrt ((m : ℝ) * ε) →
      |aeval (fun i => ((q i : ℚ) : ℝ)) P| ≤
        C_upper * (∏ i, ((q i).den : ℝ) ^ (R i : ℕ)) ^ (-κ)

/-! ## V7N1U-2 — V7-N1 uniform implies V7-N1 -/

/-- **V7N1U-2 — `T5_V7N1_uniform_implies_V7N1`**: forward bridge from
    uniform variant to original V7-N1.

    Given the uniform (C_upper, κ) over all q, instantiate at a specific
    q to recover the per-q existential form. -/
theorem T5_V7N1_uniform_implies_V7N1
    (h : T5_NAMED_BlockC_Taylor_upper_bound_uniform) :
    T5_NAMED_BlockC_Taylor_upper_bound := by
  intros α h_irr h_alg ε hε m hm P R h_P_ne h_deg h_R_pos q
    h_q_violator h_growth h_balance h_index
  obtain ⟨C_upper, κ, hC, hκ, h_bound⟩ := h α h_irr h_alg ε hε hm P R
    h_P_ne h_deg h_R_pos
  exact ⟨C_upper, κ, hC, hκ,
    h_bound q h_q_violator h_growth h_balance h_index⟩

/-! ## V7N1U-3 — V7-N1 uniform extracts (C_upper, κ) -/

/-- **V7N1U-3 — `T5_V7N1_uniform_extract`**: explicit (C_upper, κ)
    extraction from the uniform variant.

    Useful for SEQ-3 chaining: extract (C_upper, κ) ONCE, then apply
    to a sequence of q-tuples. -/
theorem T5_V7N1_uniform_extract
    (h : T5_NAMED_BlockC_Taylor_upper_bound_uniform)
    (α : ℝ) (h_irr : Irrational α) (h_alg : IsAlgebraic ℤ α)
    (ε : ℝ) (hε : 0 < ε)
    {m : ℕ} (hm : 1 ≤ m)
    (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ)
    (h_P_ne : P ≠ 0)
    (h_deg : ∀ i, MvPolynomial.degreeOf i P ≤ R i)
    (h_R_pos : ∀ i, 0 < R i) :
    ∃ (C_upper : ℝ) (κ : ℝ), 0 < C_upper ∧ 1 < κ ∧
      ∀ (q : Fin m → ℚ),
        (∀ i, q i ∈ T5_RothViolatingSet α ε) →
        T5_DenominatorGrowthCondition q ε →
        T5_DegreeHeightBalanceCondition R q ε →
        rothIndex P (fun i => ((q i : ℚ) : ℝ)) R ≤
          (m : ℝ) / 2 - 2 * Real.sqrt ((m : ℝ) * ε) →
        |aeval (fun i => ((q i : ℚ) : ℝ)) P| ≤
          C_upper * (∏ i, ((q i).den : ℝ) ^ (R i : ℕ)) ^ (-κ) :=
  h α h_irr h_alg ε hε hm P R h_P_ne h_deg h_R_pos

/-! ## V7N1U-4 — Headline -/

/-- **🚨🚨 V7N1U-4 — `T5_V7N1U_BLOCK_C_UNIFORM_HEADLINE`**: paper-citable
    bundle for V7-N1 uniform variant.

    Strategic significance: V7-N1-uniform is the form needed for SEQ-3
    Block CDE composition.  The extra strength (uniform κ) is needed
    because in the V7 capstone proof, we apply V7-N1 to a sequence of
    q-tuples and need a SINGLE κ for V7-N3 collide.

    Discharging V7-N1-uniform automatically discharges V7-N1
    (V7N1U-2 bridge), so this is the form to target. -/
theorem T5_V7N1U_BLOCK_C_UNIFORM_HEADLINE :
    -- (a) V7N1U-2 bridge: uniform → original V7-N1
    (T5_NAMED_BlockC_Taylor_upper_bound_uniform →
      T5_NAMED_BlockC_Taylor_upper_bound) ∧
    -- (b) V7N1U-3 identity (V7N1-uniform Prop is well-formed)
    (T5_NAMED_BlockC_Taylor_upper_bound_uniform →
      T5_NAMED_BlockC_Taylor_upper_bound_uniform) :=
  ⟨T5_V7N1_uniform_implies_V7N1, id⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockC_V7N1Uniform
