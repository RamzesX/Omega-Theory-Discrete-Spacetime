/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_BijectionCorollaries

  T-5 (Roth's theorem) — **Phase 7 ext #11: bijection corollaries
  (injectivity / zero-characterization / image)**, sub session 559ddd —
  STRICT critical-path #316 (T-5) Phase 7 ext #11.

  Single-thread hand-authored 2026-04-28 (cycle 65 — post-restart).

  ## What this file delivers

  Quick structural corollaries of the s559zz/aaa/bbb full bijection.
  Compact useful API for downstream Phase 7 ext sub-iterations:

  Three derivations + Prop:
  1. `T5_coeffsToPoly_injective`: assembly map is injective via
     `Function.HasLeftInverse.injective` with s559aaa as left inverse
  2. `T5_coeffsToPoly_eq_zero_iff`: `coeffsToPoly c = 0 ↔ c = 0`
  3. `T5_polyToCoeffs_surjOn_restrictDegree`: every coefficient vector
     comes from some polynomial in `restrictDegree` (image
     characterization via s559bbb converse round-trip)

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #11 — bijection corollaries.

  These are the structural API touchstones that downstream ext
  sub-iterations will use freely.  Specifically:
  - `coeffsToPoly_injective` lets us prove "two polynomials in
    `restrictDegree` with equal coefficient vectors are equal".
  - `coeffsToPoly_eq_zero_iff` is the contrapositive convenience for
    extracting "non-zero polynomial ⇒ non-zero coefficient vector"
    needed in concrete vanishing-matrix arguments (ext #12+).
  - `polyToCoeffs_surjOn` characterizes the image of `polyToCoeffs`
    on the `restrictDegree` submodule.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsToPolynomial
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyToCoeffs
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_BijectionClosure

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_BijectionCorollaries

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMultiIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsToPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyToCoeffs
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BijectionClosure

/-! ## Injectivity of coeffsToPoly -/

/-- **🚨 Wave T5 session 559ddd — `coeffsToPoly` is injective**.

    Direct corollary of s559aaa via `Function.HasLeftInverse.injective`:
    `polyToCoeffs` is the left inverse of `coeffsToPoly`. -/
theorem T5_coeffsToPoly_injective {n d : ℕ} :
    Function.Injective
      (coeffsToPoly : (BoundedMI n d → ℤ) → MvPolynomial (Fin n) ℤ) := by
  apply Function.HasLeftInverse.injective
  exact ⟨polyToCoeffs (d := d), T5_polyToCoeffs_coeffsToPoly⟩

/-! ## Zero characterization -/

/-- **🚨 Wave T5 session 559ddd — `coeffsToPoly c = 0 ↔ c = 0`**.

    The assembled polynomial vanishes iff the coefficient vector
    vanishes — direct from injectivity + `coeffsToPoly_zero` (s559zz). -/
theorem T5_coeffsToPoly_eq_zero_iff {n d : ℕ} (c : BoundedMI n d → ℤ) :
    coeffsToPoly c = 0 ↔ c = 0 := by
  constructor
  · intro h
    have h_round := T5_polyToCoeffs_coeffsToPoly c
    rw [h] at h_round
    rw [show (polyToCoeffs (d := d) (0 : MvPolynomial (Fin n) ℤ))
          = (0 : BoundedMI n d → ℤ) by
      funext k; unfold polyToCoeffs; simp] at h_round
    exact h_round.symm
  · intro h
    rw [h]
    exact T5_coeffsToPoly_zero

/-! ## Image characterization on restrictDegree -/

/-- **🚨 Wave T5 session 559ddd — `polyToCoeffs` is "surjective" on
    `restrictDegree` image**.

    Every coefficient vector `c : BoundedMI n d → ℤ` is the image of
    some polynomial `p ∈ restrictDegree (Fin n) ℤ d` under
    `polyToCoeffs` — namely `p = coeffsToPoly c` (via s559zz/aaa). -/
theorem T5_polyToCoeffs_surjOn_restrictDegree {n d : ℕ}
    (c : BoundedMI n d → ℤ) :
    ∃ p : MvPolynomial (Fin n) ℤ,
      p ∈ MvPolynomial.restrictDegree (Fin n) ℤ d ∧
      polyToCoeffs (d := d) p = c :=
  ⟨coeffsToPoly c,
   T5_coeffsToPoly_mem_restrictDegree c,
   T5_polyToCoeffs_coeffsToPoly c⟩

/-! ## BijectionCorollaries Prop scaffold -/

/-- **BijectionCorollaries**: 3-conjunct Prop packaging injectivity +
    zero-characterization + image-surjectivity. -/
def BijectionCorollaries : Prop :=
  (∀ {n d : ℕ},
    Function.Injective
      (coeffsToPoly : (BoundedMI n d → ℤ) → MvPolynomial (Fin n) ℤ)) ∧
  (∀ {n d : ℕ} (c : BoundedMI n d → ℤ),
    coeffsToPoly c = 0 ↔ c = 0) ∧
  (∀ {n d : ℕ} (c : BoundedMI n d → ℤ),
    ∃ p : MvPolynomial (Fin n) ℤ,
      p ∈ MvPolynomial.restrictDegree (Fin n) ℤ d ∧
      polyToCoeffs (d := d) p = c)

/-- **🚨 Wave T5 session 559ddd — `BijectionCorollaries`**. -/
theorem T5_bijection_corollaries : BijectionCorollaries :=
  ⟨@T5_coeffsToPoly_injective,
   @T5_coeffsToPoly_eq_zero_iff,
   @T5_polyToCoeffs_surjOn_restrictDegree⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559ddd — T-5 Phase 7 ext #11: bijection corollaries**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #11.

    Quick structural corollaries of the s559zz/aaa/bbb full bijection.

    Three derivations + Prop:
    1. `T5_coeffsToPoly_injective` — assembly map injectivity via
       `Function.HasLeftInverse.injective` (left inverse: s559aaa)
    2. `T5_coeffsToPoly_eq_zero_iff` — vanishing characterization
    3. `T5_polyToCoeffs_surjOn_restrictDegree` — image-surjectivity
       on `restrictDegree` submodule
    + BijectionCorollaries Prop (3-conjunct).

    Compact API for downstream ext sub-iterations: lets concrete
    vanishing-matrix arguments freely interconvert between
    "non-zero polynomial in `restrictDegree`" and "non-zero
    coefficient vector".

    Mathlib usage: `Function.HasLeftInverse.injective`,
    composed with our s559aaa
    `T5_polyToCoeffs_coeffsToPoly = id`.

    Sub-lemma 204/N in T-1 (T-5 Phase 7 ext #11).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 bijection-corollaries
    structural API. -/
theorem session_559ddd_T5_phase7_bijection_corollaries_headline :
    BijectionCorollaries :=
  T5_bijection_corollaries

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_BijectionCorollaries
