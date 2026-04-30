/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceLinearity

  T-5 (Roth's theorem) — **V7-N2 LINEARITY of clearance under polynomial
  addition** + general "clearance at R bound" framework.

  Key construction toward V7-N2 closure via support induction:
  - Define `T5_clearance_at_R p R q` (clearance with R as input parameter,
    not fixed to degreeOf)
  - Prove: clearance_at_R is closed under polynomial addition (linearity)
  - Prove: clearance_at_R 0 holds trivially
  - Bridge to V7-N2 NAMED Prop via R := degreeOf · p

  Combined with DCM-2 (general monomial case) + MvPolynomial.as_sum
  + induction over support, this closes V7-N2 multivariate.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS — real proof.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_MultivariateClearanceComposition
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceMonomialCase

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceLinearity

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_MultivariateClearanceComposition
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceMonomialCase

/-! ## DCL-1 — Clearance at R definition (clearance with explicit R bound) -/

/-- **DCL-1 — `T5_clearance_at_R`**: clearance hypothesis with explicit
    R bound parameter (instead of fixing R := degreeOf).

    For p : MvPolynomial (Fin m) ℤ, R : Fin m → ℕ, q : Fin m → ℚ,
    `T5_clearance_at_R p R q` asserts:
      ∃ k : ℤ, (∏ q_j.den^(R j)) · aeval(q-cast) (p.map ℝ) = (k : ℝ)

    Crucially R is a FREE parameter (not necessarily equal to degreeOf p).
    For the integer non-vanishing argument to work, we need R ≥ degreeOf p
    (per-j, in support context).  This is enforced when we APPLY the
    Prop, not in the Prop itself. -/
def T5_clearance_at_R
    {m : ℕ} (p : MvPolynomial (Fin m) ℤ) (R : Fin m → ℕ) (q : Fin m → ℚ) :
    Prop :=
  ∃ k : ℤ,
    (∏ j, ((q j).den : ℝ) ^ (R j)) *
    aeval (fun j => ((q j : ℚ) : ℝ))
      ((p.map (algebraMap ℤ ℝ)) : MvPolynomial (Fin m) ℝ) = (k : ℝ)

/-! ## DCL-2 — Clearance at R holds for the zero polynomial -/

/-- **DCL-2 — `T5_clearance_at_R_zero`**: `T5_clearance_at_R 0 R q`
    trivially holds with witness `k = 0`. -/
theorem T5_clearance_at_R_zero
    {m : ℕ} (R : Fin m → ℕ) (q : Fin m → ℚ) :
    T5_clearance_at_R (0 : MvPolynomial (Fin m) ℤ) R q := by
  refine ⟨0, ?_⟩
  simp

/-! ## DCL-3 — Linearity: clearance_at_R closed under addition -/

/-- **DCL-3 — `T5_clearance_at_R_add`**: linearity of clearance_at_R
    under polynomial addition.

    Given `T5_clearance_at_R p₁ R q` (witness k₁) and
    `T5_clearance_at_R p₂ R q` (witness k₂), derive
    `T5_clearance_at_R (p₁ + p₂) R q` with witness `k₁ + k₂`.

    Proof: aeval (p₁ + p₂) = aeval p₁ + aeval p₂ (linearity).
    Multiplying by ∏ q_j.den^{R_j} gives the sum k₁ + k₂. -/
theorem T5_clearance_at_R_add
    {m : ℕ} (p₁ p₂ : MvPolynomial (Fin m) ℤ) (R : Fin m → ℕ) (q : Fin m → ℚ)
    (h₁ : T5_clearance_at_R p₁ R q)
    (h₂ : T5_clearance_at_R p₂ R q) :
    T5_clearance_at_R (p₁ + p₂) R q := by
  obtain ⟨k₁, hk₁⟩ := h₁
  obtain ⟨k₂, hk₂⟩ := h₂
  refine ⟨k₁ + k₂, ?_⟩
  rw [_root_.map_add, _root_.map_add]
  push_cast
  linear_combination hk₁ + hk₂

/-! ## DCL-4 — Linearity over Finset.sum -/

/-- **DCL-4 — `T5_clearance_at_R_sum`**: clearance_at_R closed under
    Finset.sum.

    Generalization of DCL-3 to sum over a finite index set.  Required
    for the eventual `MvPolynomial.as_sum` decomposition that closes
    full DC-1 via support induction. -/
theorem T5_clearance_at_R_sum
    {m : ℕ} {ι : Type*} (s : Finset ι) (f : ι → MvPolynomial (Fin m) ℤ)
    (R : Fin m → ℕ) (q : Fin m → ℚ)
    (h : ∀ i ∈ s, T5_clearance_at_R (f i) R q) :
    T5_clearance_at_R (∑ i ∈ s, f i) R q := by
  classical
  revert h
  refine Finset.induction_on s ?_ ?_
  · -- base: s = ∅
    intro _
    rw [Finset.sum_empty]
    exact T5_clearance_at_R_zero R q
  · -- step: s = insert a s'
    intros a s' a_notin ih h_all
    rw [Finset.sum_insert a_notin]
    apply T5_clearance_at_R_add
    · exact h_all a (Finset.mem_insert_self a s')
    · apply ih
      intros i hi
      exact h_all i (Finset.mem_insert_of_mem hi)

/-! ## DCL-5 — Bridge: clearance_at_R p (degreeOf · p) ↔ DC-1 component -/

/-- **DCL-5 — `T5_clearance_at_R_degreeOf_eq_DC1_component`**:
    `T5_clearance_at_R p (degreeOf · (p.map ℝ)) q` is exactly the
    per-p form of DC-1 (T5_NAMED_BlockD_multivariate_clearance applied
    to a specific p).

    Statement of definitional equivalence between the explicit-R form
    and the DC-1 form when R = degreeOf · (p.map ℝ). -/
theorem T5_clearance_at_R_degreeOf_eq_DC1_component
    {m : ℕ} (p : MvPolynomial (Fin m) ℤ) (q : Fin m → ℚ) :
    T5_clearance_at_R p
      (fun j => MvPolynomial.degreeOf j (p.map (algebraMap ℤ ℝ))) q ↔
    (∃ k : ℤ,
      (∏ j, ((q j).den : ℝ) ^
        (MvPolynomial.degreeOf j (p.map (algebraMap ℤ ℝ)) : ℕ)) *
      aeval (fun j => ((q j : ℚ) : ℝ))
        ((p.map (algebraMap ℤ ℝ)) : MvPolynomial (Fin m) ℝ) = (k : ℝ)) :=
  Iff.rfl

/-! ## DCL-6 — Headline -/

/-- **🚨🚨 DCL-6 — `T5_DCL_BLOCK_D_LINEARITY_HEADLINE`**: paper-citable
    bundle for the clearance_at_R framework.

    Strategic significance: combined with DCM-2 (monomial clearance
    at degreeOf bound) and `MvPolynomial.as_sum`, this framework gives
    the FULL DC-1 multivariate clearance via support induction:
    1. p = ∑ d ∈ support, monomial d (coeff p d) (as_sum)
    2. Each `monomial d c` has `clearance_at_R` for R := degreeOf p
       (since R_j ≥ d_j by definition of degreeOf as max)
    3. Linearity (DCL-3 / DCL-4) lifts to `clearance_at_R p (degreeOf p) q`
    4. Which is exactly DC-1 (DCL-5 bridge) -/
theorem T5_DCL_BLOCK_D_LINEARITY_HEADLINE :
    -- (a) DCL-2 zero case
    (∀ {m : ℕ} (R : Fin m → ℕ) (q : Fin m → ℚ),
      T5_clearance_at_R (0 : MvPolynomial (Fin m) ℤ) R q) ∧
    -- (b) DCL-3 binary linearity
    (∀ {m : ℕ} (p₁ p₂ : MvPolynomial (Fin m) ℤ) (R : Fin m → ℕ)
      (q : Fin m → ℚ),
      T5_clearance_at_R p₁ R q → T5_clearance_at_R p₂ R q →
      T5_clearance_at_R (p₁ + p₂) R q) ∧
    -- (c) DCL-4 Finset.sum linearity
    (∀ {m : ℕ} {ι : Type*} (s : Finset ι) (f : ι → MvPolynomial (Fin m) ℤ)
      (R : Fin m → ℕ) (q : Fin m → ℚ),
      (∀ i ∈ s, T5_clearance_at_R (f i) R q) →
      T5_clearance_at_R (∑ i ∈ s, f i) R q) :=
  ⟨fun {m} R q => T5_clearance_at_R_zero R q,
   fun {m} p₁ p₂ R q => T5_clearance_at_R_add p₁ p₂ R q,
   fun {m} {ι} s f R q => T5_clearance_at_R_sum s f R q⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceLinearity
