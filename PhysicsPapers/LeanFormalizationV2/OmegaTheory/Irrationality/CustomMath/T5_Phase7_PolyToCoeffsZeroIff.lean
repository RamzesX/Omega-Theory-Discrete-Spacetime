/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyToCoeffsZeroIff

  T-5 (Roth's theorem) — **Phase 7 ext #32: polyToCoeffs zero
  characterization for restrictDegree polynomials**, sub session 559yyy
  — STRICT critical-path #316 (T-5) Phase 7 ext #32.

  Single-thread hand-authored 2026-04-28 (cycle 65 — post-restart).

  ## What this file delivers

  Zero characterization theorem for `polyToCoeffs` on the
  `restrictDegree` submodule:

      `p ∈ restrictDegree (Fin n) ℤ d → (polyToCoeffs p = 0 ↔ p = 0)`

  Direct corollary of ext #9 (BijectionClosure round-trip
  `coeffsToPoly ∘ polyToCoeffs = id` on restrictDegree) + ext #11
  (BijectionCorollaries `coeffsToPoly c = 0 ↔ c = 0`).

  Useful for converting between polynomial-zero and
  coefficient-vector-zero hypotheses in downstream Roth-style
  arguments (ext #33+).

  Two derivations + Prop:
  1. `T5_polyToCoeffs_eq_zero_iff`: zero characterization iff theorem
  2. `T5_polyToCoeffs_zero_of_zero`: forward direction (p = 0 →
     polyToCoeffs p = 0) — works for ANY p, not just restrictDegree

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #32 — polyToCoeffs zero characterization.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_BijectionClosure
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_BijectionCorollaries
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_AuxiliaryPolyExistsConcrete

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyToCoeffsZeroIff

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMultiIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsToPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyToCoeffs
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BijectionClosure
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BijectionCorollaries
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_AuxiliaryPolyExistsConcrete

/-! ## Forward direction: p = 0 → polyToCoeffs p = 0 -/

/-- **🚨 Wave T5 session 559yyy — `p = 0 → polyToCoeffs p = 0`**.

    Forward direction: substitute `p = 0` into `polyToCoeffs` and
    use ext #10 `T5_polyToCoeffs_zero` (which says
    `polyToCoeffs (0 : MvPolynomial) = 0`). Works for ANY p, not
    just `restrictDegree`. -/
theorem T5_polyToCoeffs_zero_of_zero {n d : ℕ} :
    polyToCoeffs (d := d) (0 : MvPolynomial (Fin n) ℤ)
      = (fun _ : BoundedMI n d => (0 : ℤ)) :=
  T5_polyToCoeffs_zero

/-! ## Zero characterization (iff form) -/

/-- **🚨 Wave T5 session 559yyy — `polyToCoeffs p = 0 ↔ p = 0`**
    for `p ∈ restrictDegree`.

    Zero characterization via the full bijection (ext #9 round-trip
    + ext #11 `coeffsToPoly_eq_zero_iff`).

    Forward direction: `polyToCoeffs p = 0 → coeffsToPoly (polyToCoeffs p) = coeffsToPoly 0 → p = 0`
    using ext #9 + ext #11.

    Backward direction: `p = 0 → polyToCoeffs 0 = 0` via ext #10
    `T5_polyToCoeffs_zero`. -/
theorem T5_polyToCoeffs_eq_zero_iff {n d : ℕ}
    (p : MvPolynomial (Fin n) ℤ)
    (hp : p ∈ MvPolynomial.restrictDegree (Fin n) ℤ d) :
    polyToCoeffs (d := d) p = (fun _ : BoundedMI n d => (0 : ℤ))
      ↔ p = 0 := by
  constructor
  · intro h
    -- polyToCoeffs p = 0 → p = coeffsToPoly (polyToCoeffs p) = coeffsToPoly 0 = 0
    have h_round := T5_coeffsToPoly_polyToCoeffs p hp  -- ext #9
    -- h_round : coeffsToPoly (polyToCoeffs p) = p
    rw [h] at h_round  -- coeffsToPoly 0 = p
    -- coeffsToPoly 0 = 0 (via ext #11 zero-iff with c = 0)
    rw [(T5_coeffsToPoly_eq_zero_iff
          (fun _ : BoundedMI n d => (0 : ℤ))).mpr rfl] at h_round
    exact h_round.symm
  · intro h
    rw [h]
    exact T5_polyToCoeffs_zero_of_zero

/-! ## PolyToCoeffsZeroIff Prop scaffold -/

/-- **PolyToCoeffsZeroIff**: 2-conjunct Prop packaging the
    zero-characterization theorem (forward + iff). -/
def PolyToCoeffsZeroIff : Prop :=
  (∀ {n d : ℕ},
    polyToCoeffs (d := d) (0 : MvPolynomial (Fin n) ℤ)
      = (fun _ : BoundedMI n d => (0 : ℤ))) ∧
  (∀ {n d : ℕ} (p : MvPolynomial (Fin n) ℤ),
    p ∈ MvPolynomial.restrictDegree (Fin n) ℤ d →
    (polyToCoeffs (d := d) p = (fun _ : BoundedMI n d => (0 : ℤ))
      ↔ p = 0))

/-- **🚨 Wave T5 session 559yyy — `PolyToCoeffsZeroIff`**. -/
theorem T5_polyToCoeffs_zero_iff_prop : PolyToCoeffsZeroIff :=
  ⟨@T5_polyToCoeffs_zero_of_zero,
   @T5_polyToCoeffs_eq_zero_iff⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559yyy — T-5 Phase 7 ext #32:
    polyToCoeffs zero characterization**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #32.

    Two derivations + Prop:
    1. `T5_polyToCoeffs_zero_of_zero` — forward: p = 0 →
       polyToCoeffs p = 0 (via ext #10 `T5_polyToCoeffs_zero`)
    2. `T5_polyToCoeffs_eq_zero_iff` — iff: for `p ∈ restrictDegree`,
       polyToCoeffs p = 0 ↔ p = 0 (via ext #9 round-trip +
       ext #11 `coeffsToPoly_eq_zero_iff`)
    + PolyToCoeffsZeroIff Prop (2-conjunct).

    Useful structural converter for downstream Roth-style arguments:
    given `polyToCoeffs p = 0` (matrix vanishing form), derive
    `p = 0` (polynomial form). Used in ext #33+ for combining
    matrix-vanishing with polynomial-non-vanishing reasoning.

    Mathlib usage: composition of ext #9 + ext #10 + ext #11 (no
    new Mathlib lookup at this layer).

    Sub-lemma 225/N in T-1 (T-5 Phase 7 ext #32).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 polyToCoeffs zero
    characterization for restrictDegree polynomials. -/
theorem session_559yyy_T5_phase7_polyToCoeffs_zero_iff_headline :
    PolyToCoeffsZeroIff :=
  T5_polyToCoeffs_zero_iff_prop

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyToCoeffsZeroIff
