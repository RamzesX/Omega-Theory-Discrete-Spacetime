/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyToCoeffs

  T-5 (Roth's theorem) — **Phase 7 ext #8: polynomial → coefficient
  vector extraction**, sub session 559aaa — STRICT
  critical-path #316 (T-5) Phase 7 ext #8.

  Single-thread hand-authored 2026-04-28 (cycle 65 — post-restart).

  ## What this file delivers

  Inverse direction of the s559zz `coeffsToPoly` assembly map.

  Plus injectivity of `T5_boundedMItoFinsupp` and the inverse round-trip
  identity `polyToCoeffs ∘ coeffsToPoly = id`, completing the
  bijection at the coefficient-vector ↔ polynomial level.

  Three derivations + Prop:
  1. `polyToCoeffs`: extract `BoundedMI n d → ℤ` coefficient vector
     from any polynomial (just the coefficient at `toFinsupp k`)
  2. `T5_boundedMItoFinsupp_injective`: injectivity of the multi-index
     Finsupp embedding
  3. `T5_polyToCoeffs_coeffsToPoly`: `polyToCoeffs (coeffsToPoly c) = c`
     — coefficient extraction inverts assembly

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #8 — coefficient extraction + bijection closure.
  Combined with s559zz (assembly) the coefficient-vector ↔
  bounded-degree-polynomial bijection is closed in the linear
  embedding direction (the fully-saturated Equiv at restrictDegree
  level requires the converse statement
  `coeffsToPoly (polyToCoeffs p) = p` for `p ∈ restrictDegree`,
  deferred to a future ext sub-iteration).
-/

import Mathlib.Algebra.MvPolynomial.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMultiIndex
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMIToFinsupp
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsToPolynomial

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyToCoeffs

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMultiIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMIToFinsupp
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsToPolynomial

/-! ## Polynomial → coefficient vector extraction -/

/-- **🚨 Wave T5 session 559aaa — `polyToCoeffs` extraction map**.

    Extract a `BoundedMI n d → ℤ` coefficient vector from a polynomial
    `p : MvPolynomial (Fin n) ℤ` by reading off the coefficient at
    each `toFinsupp k` index. -/
noncomputable def polyToCoeffs {n d : ℕ}
    (p : MvPolynomial (Fin n) ℤ) : BoundedMI n d → ℤ :=
  fun k => p.coeff (T5_boundedMItoFinsupp k)

/-! ## Injectivity of T5_boundedMItoFinsupp -/

/-- **🚨 Wave T5 session 559aaa — `T5_boundedMItoFinsupp` is injective**.

    Two BoundedMI elements with the same Finsupp embedding are equal. -/
theorem T5_boundedMItoFinsupp_injective {n d : ℕ} :
    Function.Injective (T5_boundedMItoFinsupp : BoundedMI n d → (Fin n →₀ ℕ)) := by
  intro j₁ j₂ h
  funext i
  apply Fin.val_injective
  have : (T5_boundedMItoFinsupp j₁) i = (T5_boundedMItoFinsupp j₂) i := by rw [h]
  unfold T5_boundedMItoFinsupp at this
  rwa [Finsupp.equivFunOnFinite_symm_apply_apply,
       Finsupp.equivFunOnFinite_symm_apply_apply] at this

/-! ## Inverse round-trip: polyToCoeffs ∘ coeffsToPoly = id -/

/-- **🚨 Wave T5 session 559aaa — `polyToCoeffs (coeffsToPoly c) = c`**.

    The coefficient extraction map inverts the assembly map: any
    coefficient vector `c : BoundedMI n d → ℤ`, assembled into a
    polynomial via s559zz `coeffsToPoly`, then extracted via
    `polyToCoeffs`, yields back `c`. -/
theorem T5_polyToCoeffs_coeffsToPoly {n d : ℕ}
    (c : BoundedMI n d → ℤ) :
    polyToCoeffs (coeffsToPoly c) = c := by
  funext k
  unfold polyToCoeffs coeffsToPoly
  rw [MvPolynomial.coeff_sum]
  rw [Finset.sum_eq_single k]
  · rw [MvPolynomial.coeff_monomial, if_pos rfl]
  · intro k' _ hk'
    rw [MvPolynomial.coeff_monomial]
    have : ¬ (T5_boundedMItoFinsupp k') = (T5_boundedMItoFinsupp k) := by
      intro h
      exact hk' (T5_boundedMItoFinsupp_injective h)
    exact if_neg this
  · intro h
    exact absurd (Finset.mem_univ k) h

/-! ## PolyToCoeffs Prop scaffold -/

/-- **PolyToCoeffs**: 3-conjunct Prop packaging extraction +
    injectivity + inverse round-trip. -/
def PolyToCoeffs : Prop :=
  (∀ {n d : ℕ} (p : MvPolynomial (Fin n) ℤ) (k : BoundedMI n d),
    (polyToCoeffs p) k = p.coeff (T5_boundedMItoFinsupp k)) ∧
  (∀ {n d : ℕ},
    Function.Injective (T5_boundedMItoFinsupp : BoundedMI n d → (Fin n →₀ ℕ))) ∧
  (∀ {n d : ℕ} (c : BoundedMI n d → ℤ),
    polyToCoeffs (coeffsToPoly c) = c)

/-- **🚨 Wave T5 session 559aaa — `polyToCoeffs_apply`** (component identity). -/
theorem T5_polyToCoeffs_apply {n d : ℕ} (p : MvPolynomial (Fin n) ℤ)
    (k : BoundedMI n d) :
    (polyToCoeffs p) k = p.coeff (T5_boundedMItoFinsupp k) := rfl

/-- **🚨 Wave T5 session 559aaa — `PolyToCoeffs`**. -/
theorem T5_poly_to_coeffs : PolyToCoeffs :=
  ⟨@T5_polyToCoeffs_apply,
   @T5_boundedMItoFinsupp_injective,
   @T5_polyToCoeffs_coeffsToPoly⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559aaa — T-5 Phase 7 ext #8: poly → coeffs extraction**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #8.

    Inverse direction of s559zz `coeffsToPoly` assembly + injectivity
    of the multi-index Finsupp embedding + inverse round-trip
    `polyToCoeffs ∘ coeffsToPoly = id`.

    Three derivations + Prop:
    1. `polyToCoeffs` — extract coefficient vector
    2. `T5_boundedMItoFinsupp_injective` — multi-index injectivity
    3. `T5_polyToCoeffs_coeffsToPoly` — inverse round-trip
    + `T5_polyToCoeffs_apply` (component identity)
    + PolyToCoeffs Prop (3-conjunct).

    Closes the linear-embedding direction of the bijection
    `BoundedMI n d → ℤ ≃ MvPolynomial (Fin n) ℤ image of coeffsToPoly`
    via Mathlib's `MvPolynomial.coeff_sum`, `MvPolynomial.coeff_monomial`,
    `Finset.sum_eq_single`, `Finsupp.equivFunOnFinite_symm_apply_apply`.

    Sub-lemma 201/N in T-1 (T-5 Phase 7 ext #8).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 polynomial → coefficient
    extraction + bijection closure (linear-embedding direction). -/
theorem session_559aaa_T5_phase7_poly_to_coeffs_headline :
    PolyToCoeffs :=
  T5_poly_to_coeffs

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyToCoeffs
