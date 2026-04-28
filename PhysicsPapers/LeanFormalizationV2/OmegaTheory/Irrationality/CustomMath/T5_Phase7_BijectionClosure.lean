/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_BijectionClosure

  T-5 (Roth's theorem) — **Phase 7 ext #9: bijection closure
  `coeffsToPoly ∘ polyToCoeffs = id` on `restrictDegree`**, sub session
  559bbb — STRICT critical-path #316 (T-5) Phase 7 ext #9.

  Single-thread hand-authored 2026-04-28 (cycle 65 — post-restart).

  ## What this file delivers

  Closes the converse round-trip of the bijection started by s559zz
  (`coeffsToPoly` assembly) and s559aaa (`polyToCoeffs` extraction):

      `p ∈ restrictDegree (Fin n) ℤ d → coeffsToPoly (polyToCoeffs p) = p`

  Combined with s559aaa's
  `polyToCoeffs (coeffsToPoly c) = c`, this gives a full bijection
  between `BoundedMI n d → ℤ` and the bounded-degree submodule of
  `MvPolynomial (Fin n) ℤ`.

  Three derivations + Prop:
  1. `T5_support_subset_image_toFinsupp`: if `p ∈ restrictDegree`,
     every `v ∈ p.support` is in the image of `T5_boundedMItoFinsupp`
  2. `T5_coeff_zero_of_not_bounded`: if `p ∈ restrictDegree` and
     `s` has some `s i > d`, then `p.coeff s = 0`
  3. `T5_coeffsToPoly_polyToCoeffs`: the converse round-trip identity

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #9 — bijection closure.

  Combined with s559zz/aaa, the linear bijection
  `BoundedMI n d → ℤ ≃ restrictDegree (Fin n) ℤ d`-image is closed.
  The next ext sub-iterations (concrete vanishing matrix construction,
  iterated multi-pderiv closed form, full AuxiliaryPolyExists at the
  MvPolynomial level) build on this dictionary.
-/

import Mathlib.Algebra.MvPolynomial.Basic
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMultiIndex
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMIToFinsupp
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_FinsuppToBoundedMI
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RestrictDegreeMonomial
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsToPolynomial
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyToCoeffs

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_BijectionClosure

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMultiIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMIToFinsupp
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_FinsuppToBoundedMI
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsToPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyToCoeffs

/-! ## Support of restrictDegree polynomial is in image of toFinsupp -/

/-- **🚨 Wave T5 session 559bbb — `p ∈ restrictDegree → support ⊆ image(toFinsupp)`**.

    Every multi-index in the support of a bounded-degree polynomial
    can be uniquely realized as `T5_boundedMItoFinsupp k` for some
    `k : BoundedMI n d`. -/
theorem T5_support_subset_image_toFinsupp {n d : ℕ}
    (p : MvPolynomial (Fin n) ℤ)
    (hp : p ∈ MvPolynomial.restrictDegree (Fin n) ℤ d)
    (v : Fin n →₀ ℕ) (hv : v ∈ p.support) :
    ∃ k : BoundedMI n d, T5_boundedMItoFinsupp k = v := by
  rw [MvPolynomial.mem_restrictDegree] at hp
  have h_bound : ∀ i, v i ≤ d := hp v hv
  exact ⟨T5_finsuppToBoundedMI v h_bound,
         T5_toFinsupp_finsuppToBoundedMI v h_bound⟩

/-! ## Coefficient zero outside bounded multi-indices -/

/-- **🚨 Wave T5 session 559bbb — `p ∈ restrictDegree → p.coeff s = 0` if `s` not bounded**.

    For any `p ∈ restrictDegree (Fin n) ℤ d` and any multi-index
    `s : Fin n →₀ ℕ` with some component `s i > d`, the coefficient
    `p.coeff s = 0` (because `s ∉ p.support`). -/
theorem T5_coeff_zero_of_not_bounded {n d : ℕ}
    (p : MvPolynomial (Fin n) ℤ)
    (hp : p ∈ MvPolynomial.restrictDegree (Fin n) ℤ d)
    (s : Fin n →₀ ℕ) (i : Fin n) (hi : d < s i) :
    p.coeff s = 0 := by
  by_contra h_ne
  rw [MvPolynomial.mem_restrictDegree] at hp
  have h_in_supp : s ∈ p.support := by
    rw [MvPolynomial.mem_support_iff]; exact h_ne
  have h_le : s i ≤ d := hp s h_in_supp i
  exact absurd h_le (not_le.mpr hi)

/-! ## Converse round-trip: coeffsToPoly ∘ polyToCoeffs = id -/

/-- **🚨 Wave T5 session 559bbb — `coeffsToPoly (polyToCoeffs p) = p`** for `p ∈ restrictDegree`.

    The converse direction of the bijection: any polynomial in the
    bounded-degree submodule, decomposed via `polyToCoeffs` and
    re-assembled via `coeffsToPoly`, returns the original polynomial. -/
theorem T5_coeffsToPoly_polyToCoeffs {n d : ℕ}
    (p : MvPolynomial (Fin n) ℤ)
    (hp : p ∈ MvPolynomial.restrictDegree (Fin n) ℤ d) :
    coeffsToPoly (d := d) (polyToCoeffs (d := d) p) = p := by
  ext s
  unfold coeffsToPoly polyToCoeffs
  rw [MvPolynomial.coeff_sum]
  by_cases hs : ∀ i, s i ≤ d
  · -- s is bounded: ∃ unique k with toFinsupp k = s
    obtain ⟨k, hk⟩ : ∃ k : BoundedMI n d, T5_boundedMItoFinsupp k = s :=
      ⟨T5_finsuppToBoundedMI s hs, T5_toFinsupp_finsuppToBoundedMI s hs⟩
    rw [Finset.sum_eq_single k]
    · rw [MvPolynomial.coeff_monomial, hk, if_pos rfl]
    · intro k' _ hkk'
      rw [MvPolynomial.coeff_monomial]
      apply if_neg
      intro h_eq
      rw [← hk] at h_eq
      exact hkk' (T5_boundedMItoFinsupp_injective h_eq)
    · intro h
      exact absurd (Finset.mem_univ k) h
  · -- s not bounded: ∃ i, s i > d
    push_neg at hs
    obtain ⟨i, hi⟩ := hs
    have h_lhs_zero : ∑ k : BoundedMI n d,
        (MvPolynomial.monomial (T5_boundedMItoFinsupp k)
          ((polyToCoeffs p) k)).coeff s = 0 := by
      apply Finset.sum_eq_zero
      intro k _
      rw [MvPolynomial.coeff_monomial]
      apply if_neg
      intro h_eq
      have := T5_boundedMItoFinsupp_le k i
      rw [h_eq] at this
      exact absurd this (not_le.mpr hi)
    have h_rhs_zero : p.coeff s = 0 :=
      T5_coeff_zero_of_not_bounded p hp s i hi
    -- The goal is on coeffsToPoly (polyToCoeffs p), but we unfolded
    -- both. Re-fold the LHS sum to use `h_lhs_zero` as written.
    show ∑ k : BoundedMI n d,
        (MvPolynomial.monomial (T5_boundedMItoFinsupp k)
          (p.coeff (T5_boundedMItoFinsupp k))).coeff s = p.coeff s
    rw [h_rhs_zero]
    apply Finset.sum_eq_zero
    intro k _
    rw [MvPolynomial.coeff_monomial]
    apply if_neg
    intro h_eq
    have := T5_boundedMItoFinsupp_le k i
    rw [h_eq] at this
    exact absurd this (not_le.mpr hi)

/-! ## BijectionClosure Prop scaffold -/

/-- **BijectionClosure**: 3-conjunct Prop packaging the converse
    round-trip + support inclusion + coefficient-zero-outside. -/
def BijectionClosure : Prop :=
  (∀ {n d : ℕ} (p : MvPolynomial (Fin n) ℤ),
    p ∈ MvPolynomial.restrictDegree (Fin n) ℤ d →
    ∀ (v : Fin n →₀ ℕ), v ∈ p.support →
    ∃ k : BoundedMI n d, T5_boundedMItoFinsupp k = v) ∧
  (∀ {n d : ℕ} (p : MvPolynomial (Fin n) ℤ),
    p ∈ MvPolynomial.restrictDegree (Fin n) ℤ d →
    ∀ (s : Fin n →₀ ℕ) (i : Fin n), d < s i → p.coeff s = 0) ∧
  (∀ {n d : ℕ} (p : MvPolynomial (Fin n) ℤ),
    p ∈ MvPolynomial.restrictDegree (Fin n) ℤ d →
    coeffsToPoly (d := d) (polyToCoeffs (d := d) p) = p)

/-- **🚨 Wave T5 session 559bbb — `BijectionClosure`**. -/
theorem T5_bijection_closure : BijectionClosure :=
  ⟨@T5_support_subset_image_toFinsupp,
   @T5_coeff_zero_of_not_bounded,
   @T5_coeffsToPoly_polyToCoeffs⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559bbb — T-5 Phase 7 ext #9: bijection closure**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #9.

    Closes the bijection
    `BoundedMI n d → ℤ ≃ restrictDegree (Fin n) ℤ d`-image started
    by s559zz/aaa.

    Three derivations + Prop:
    1. `T5_support_subset_image_toFinsupp` — support ⊆ image(toFinsupp)
       for any `p ∈ restrictDegree`
    2. `T5_coeff_zero_of_not_bounded` — coefficients vanish outside
       the bounded-multi-index image
    3. `T5_coeffsToPoly_polyToCoeffs` — converse round-trip
       (`coeffsToPoly ∘ polyToCoeffs = id` on `restrictDegree`)
    + BijectionClosure Prop (3-conjunct).

    Combines `MvPolynomial.coeff_sum`, `MvPolynomial.coeff_monomial`,
    `MvPolynomial.mem_restrictDegree`, `MvPolynomial.mem_support_iff`,
    `Finset.sum_eq_single`, `Finset.sum_eq_zero` with our s559uu/yy/ww
    multi-index dictionary.

    Sub-lemma 202/N in T-1 (T-5 Phase 7 ext #9).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 bijection closure
    coefficient-vector ↔ bounded-degree-polynomial. -/
theorem session_559bbb_T5_phase7_bijection_closure_headline :
    BijectionClosure :=
  T5_bijection_closure

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_BijectionClosure
