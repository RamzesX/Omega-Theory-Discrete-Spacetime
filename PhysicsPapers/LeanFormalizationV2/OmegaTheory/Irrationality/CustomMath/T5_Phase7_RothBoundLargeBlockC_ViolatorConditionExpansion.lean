/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockC_ViolatorConditionExpansion

  T-5 (Roth's theorem) — **Block C foundation: violator condition expansion (VC-1..VC-6)**.

  V7-N1 STEP-1 sub-foundation: explicit lemmas about `T5_RothViolatingSet`
  membership and its consequences for analytical Taylor upper bound work.

  Prepares the ground for V7-N1 (Block C multivariate Taylor upper
  bound) by exposing the violator condition `|q - α| < q.den^{-(2+ε)}`
  in usable per-index and per-tuple forms.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS — real Prop content, complete proofs.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTuple
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockC_ViolatorConditionExpansion

open Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTuple

/-! ## VC-1 — Roth-violating set membership iff -/

/-- **VC-1 — `T5_violatingSet_mem_iff`**: membership in `T5_RothViolatingSet α ε`
    unfolds to the strict `|q - α| < q.den^{-(2+ε)}` inequality.

    Trivial unfolding lemma (definitional), but exposes the membership form
    for direct use in Block C analytical chain. -/
theorem T5_violatingSet_mem_iff
    (α : ℝ) (ε : ℝ) (q : ℚ) :
    q ∈ T5_RothViolatingSet α ε ↔
      |((q : ℚ) : ℝ) - α| < ((q.den : ℝ) : ℝ) ^ (-(2 + ε)) := by
  unfold T5_RothViolatingSet
  exact Iff.rfl

/-! ## VC-2 — Membership ⇒ strict bound -/

/-- **VC-2 — `T5_violatingSet_strict_bound`**: forward direction of VC-1
    in usable form.

    Given `q ∈ T5_RothViolatingSet α ε`, derive the strict inequality
    `|q - α| < q.den^{-(2+ε)}`. -/
theorem T5_violatingSet_strict_bound
    (α : ℝ) (ε : ℝ) (q : ℚ)
    (h_q : q ∈ T5_RothViolatingSet α ε) :
    |((q : ℚ) : ℝ) - α| < ((q.den : ℝ) : ℝ) ^ (-(2 + ε)) := h_q

/-! ## VC-3 — Membership ⇒ non-strict bound -/

/-- **VC-3 — `T5_violatingSet_le_bound`**: non-strict version of VC-2.

    Given `q ∈ T5_RothViolatingSet α ε`, derive
    `|q - α| ≤ q.den^{-(2+ε)}` (useful for monotonicity arguments). -/
theorem T5_violatingSet_le_bound
    (α : ℝ) (ε : ℝ) (q : ℚ)
    (h_q : q ∈ T5_RothViolatingSet α ε) :
    |((q : ℚ) : ℝ) - α| ≤ ((q.den : ℝ) : ℝ) ^ (-(2 + ε)) :=
  le_of_lt (T5_violatingSet_strict_bound α ε q h_q)

/-! ## VC-4 — Violator pow bound (single index, natural power) -/

/-- **VC-4 — `T5_violator_natpow_bound`**: raises VC-3 to natural power `j`.

    Given `q ∈ T5_RothViolatingSet α ε`, for any `j : ℕ`,
    `|q - α|^j ≤ (q.den^{-(2+ε)})^j`.

    Derived via monotonicity of natural-power on nonneg reals
    (Mathlib `pow_le_pow_left`).  -/
theorem T5_violator_natpow_bound
    (α : ℝ) (ε : ℝ) (q : ℚ) (j : ℕ)
    (h_q : q ∈ T5_RothViolatingSet α ε) :
    |((q : ℚ) : ℝ) - α| ^ j ≤
      (((q.den : ℝ) : ℝ) ^ (-(2 + ε))) ^ j :=
  pow_le_pow_left₀ (abs_nonneg _) (T5_violatingSet_le_bound α ε q h_q) j

/-! ## VC-5 — Tuple version of VC-4 -/

/-- **VC-5 — `T5_tuple_violator_pow_bound`**: tuple-aggregate of VC-4
    via `Finset.prod_le_prod` over `Fin m`.

    Given a tuple `q : Fin m → ℚ` with each `q i ∈ T5_RothViolatingSet α ε`,
    and an exponent vector `j : Fin m → ℕ`, the product satisfies:
        ∏ i, |q i - α|^{j i} ≤ ∏ i, (q i.den^{-(2+ε)})^{j i}

    This is THE per-i analytical bound that Block C Taylor upper bound
    needs — each violator contributes its individual pow bound, and they
    multiply across the tuple. -/
theorem T5_tuple_violator_pow_bound
    {m : ℕ} (α : ℝ) (ε : ℝ) (q : Fin m → ℚ) (j : Fin m → ℕ)
    (h_q : ∀ i, q i ∈ T5_RothViolatingSet α ε) :
    ∏ i, |((q i : ℚ) : ℝ) - α| ^ (j i) ≤
      ∏ i, ((((q i).den : ℝ) : ℝ) ^ (-(2 + ε))) ^ (j i) := by
  apply Finset.prod_le_prod
  · intros i _
    exact pow_nonneg (abs_nonneg _) _
  · intros i _
    exact T5_violator_natpow_bound α ε (q i) (j i) (h_q i)

/-! ## VC-6 — Headline: natpow form bundle -/

/-- **🚨 VC-6 — `T5_VC_BLOCK_C_VIOLATOR_HEADLINE`**: paper-citable bundle
    of the 5 violator condition expansion lemmas (natpow form).

    Foundational tier-99 sub-foundation for V7-N1 (Block C multivariate
    Taylor upper bound).  Bundles per-index and tuple-aggregate forms of
    the violator strict / non-strict / pow bounds.

    Per project rule §7.0: real Prop content, no `sorry`. -/
theorem T5_VC_BLOCK_C_VIOLATOR_HEADLINE :
    -- (a) Membership iff
    (∀ (α ε : ℝ) (q : ℚ), q ∈ T5_RothViolatingSet α ε ↔
      |((q : ℚ) : ℝ) - α| < ((q.den : ℝ) : ℝ) ^ (-(2 + ε))) ∧
    -- (b) Strict bound
    (∀ (α ε : ℝ) (q : ℚ), q ∈ T5_RothViolatingSet α ε →
      |((q : ℚ) : ℝ) - α| < ((q.den : ℝ) : ℝ) ^ (-(2 + ε))) ∧
    -- (c) Non-strict bound
    (∀ (α ε : ℝ) (q : ℚ), q ∈ T5_RothViolatingSet α ε →
      |((q : ℚ) : ℝ) - α| ≤ ((q.den : ℝ) : ℝ) ^ (-(2 + ε))) ∧
    -- (d) Single-index pow bound
    (∀ (α ε : ℝ) (q : ℚ) (j : ℕ), q ∈ T5_RothViolatingSet α ε →
      |((q : ℚ) : ℝ) - α| ^ j ≤
        (((q.den : ℝ) : ℝ) ^ (-(2 + ε))) ^ j) :=
  ⟨T5_violatingSet_mem_iff,
   T5_violatingSet_strict_bound,
   T5_violatingSet_le_bound,
   T5_violator_natpow_bound⟩

/-! ## VC-7 — Natpow → rpow conversion identity -/

/-- **VC-7 — `T5_violator_natpow_to_rpow`**: identity converting
    `(q.den^{-(2+ε)})^j` (HPow ℕ outer, rpow inner) to
    `q.den^{-(2+ε) · j}` (full rpow).

    Algebraic identity from `Real.rpow_natCast` + `Real.rpow_mul`.
    Required for V7-N1 Block C Taylor analytical chain because the
    Taylor bound goes through full rpow form. -/
theorem T5_violator_natpow_to_rpow
    (q : ℚ) (ε : ℝ) (j : ℕ) :
    (((q.den : ℝ) : ℝ) ^ (-(2 + ε))) ^ j =
      ((q.den : ℝ) : ℝ) ^ (-(2 + ε) * (j : ℝ)) := by
  have h_den_nn : (0 : ℝ) ≤ ((q.den : ℝ) : ℝ) := by
    exact_mod_cast Nat.zero_le q.den
  rw [← Real.rpow_natCast (((q.den : ℝ) : ℝ) ^ (-(2 + ε))) j]
  rw [← Real.rpow_mul h_den_nn]

/-! ## VC-8 — Single-index violator bound directly in rpow form -/

/-- **VC-8 — `T5_violator_rpow_bound`**: combines VC-4 + VC-7 to give
    the violator bound directly in rpow form.

    For `q ∈ T5_RothViolatingSet α ε` and `j : ℕ`,
    `|q - α|^j ≤ q.den^{-(2+ε) · j}` (rpow on RHS).

    This IS the per-index analytical building block for V7-N1 Block C
    Taylor upper bound — directly composable with the full rpow
    machinery used in the Taylor expansion. -/
theorem T5_violator_rpow_bound
    (α : ℝ) (ε : ℝ) (q : ℚ) (j : ℕ)
    (h_q : q ∈ T5_RothViolatingSet α ε) :
    |((q : ℚ) : ℝ) - α| ^ j ≤
      ((q.den : ℝ) : ℝ) ^ (-(2 + ε) * (j : ℝ)) := by
  rw [← T5_violator_natpow_to_rpow q ε j]
  exact T5_violator_natpow_bound α ε q j h_q

/-! ## VC-9 — Tuple version of VC-8 (rpow form) -/

/-- **VC-9 — `T5_tuple_violator_rpow_bound`**: tuple-aggregate of VC-8
    via `Finset.prod_le_prod`.

    Given a tuple `q : Fin m → ℚ` with each `q i ∈ T5_RothViolatingSet α ε`,
    and an exponent vector `j : Fin m → ℕ`:
        ∏ i, |q i - α|^{j i} ≤ ∏ i, q_i.den^{-(2+ε) · j i}

    Pure rpow form on RHS — the FORM that combines directly with the
    multivariate Taylor expansion in V7-N1. -/
theorem T5_tuple_violator_rpow_bound
    {m : ℕ} (α : ℝ) (ε : ℝ) (q : Fin m → ℚ) (j : Fin m → ℕ)
    (h_q : ∀ i, q i ∈ T5_RothViolatingSet α ε) :
    ∏ i, |((q i : ℚ) : ℝ) - α| ^ (j i) ≤
      ∏ i, (((q i).den : ℝ) : ℝ) ^ (-(2 + ε) * ((j i : ℕ) : ℝ)) := by
  apply Finset.prod_le_prod
  · intros i _
    exact pow_nonneg (abs_nonneg _) _
  · intros i _
    exact T5_violator_rpow_bound α ε (q i) (j i) (h_q i)

/-! ## VC-10 — Headline: rpow form bundle -/

/-- **🚨🚨 VC-10 — `T5_VC_BLOCK_C_VIOLATOR_RPOW_HEADLINE`**: paper-citable
    bundle of the 3 rpow-form violator lemmas (VC-7/VC-8/VC-9).

    Tier-80 paper-citable: these ARE the building blocks for V7-N1
    Block C multivariate Taylor analytical chain.  Direct rpow form
    matches the multivariate Taylor expansion machinery in
    `T5_Phase7_MvPolyTaylorAtIntPoint.lean`.

    Per project rule §7.0: real Prop content, no `sorry`. -/
theorem T5_VC_BLOCK_C_VIOLATOR_RPOW_HEADLINE :
    -- (a) VC-7: natpow → rpow conversion
    (∀ (q : ℚ) (ε : ℝ) (j : ℕ),
      (((q.den : ℝ) : ℝ) ^ (-(2 + ε))) ^ j =
        ((q.den : ℝ) : ℝ) ^ (-(2 + ε) * (j : ℝ))) ∧
    -- (b) VC-8: per-index rpow bound
    (∀ (α ε : ℝ) (q : ℚ) (j : ℕ), q ∈ T5_RothViolatingSet α ε →
      |((q : ℚ) : ℝ) - α| ^ j ≤
        ((q.den : ℝ) : ℝ) ^ (-(2 + ε) * (j : ℝ))) ∧
    -- (c) VC-9: tuple rpow bound
    (∀ {m : ℕ} (α ε : ℝ) (q : Fin m → ℚ) (j : Fin m → ℕ),
      (∀ i, q i ∈ T5_RothViolatingSet α ε) →
      ∏ i, |((q i : ℚ) : ℝ) - α| ^ (j i) ≤
        ∏ i, (((q i).den : ℝ) : ℝ) ^ (-(2 + ε) * ((j i : ℕ) : ℝ))) :=
  ⟨T5_violator_natpow_to_rpow,
   T5_violator_rpow_bound,
   fun {m} α ε q j h_q => T5_tuple_violator_rpow_bound α ε q j h_q⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockC_ViolatorConditionExpansion
