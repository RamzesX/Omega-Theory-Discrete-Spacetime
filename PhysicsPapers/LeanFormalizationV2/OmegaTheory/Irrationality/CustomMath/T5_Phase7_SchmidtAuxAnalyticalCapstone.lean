/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxAnalyticalCapstone

  T-5 (Roth's theorem) — **Phase 7 ext #22: Schmidt aux poly +
  analytical bound GRAND CAPSTONE**, sub session 559ooo —
  STRICT critical-path #316 (T-5) Phase 7 ext #22.

  Single-thread hand-authored 2026-04-28 (cycle 65 — post-restart).

  ## What this file delivers

  GRAND analytical capstone combining the SCAFFOLD direction
  (ext #16: Schmidt-Wirsing-Roth aux poly existence) with the
  ANALYTICAL-SIDE bound (ext #19: explicit `|p(α)|` bound) via
  ext #9 BijectionClosure (`p = coeffsToPoly (polyToCoeffs p)`
  on `restrictDegree`).

  Given multi-derivative indices `I : J → BoundedMI n d` and
  uniform eval point `α : Fin n → ℤ` with `card J < (d+1)^n` and
  `0 < card J`:

      ∃ p : MvPolynomial (Fin n) ℤ,
        p ≠ 0 ∧
        p ∈ MvPolynomial.restrictDegree (Fin n) ℤ d ∧
        vanishingMatrix J I (fun _ => α) *ᵥ polyToCoeffs p = 0 ∧
        |MvPolynomial.eval α p|
          ≤ (∑ k : BoundedMI n d, |polyToCoeffs p k|) *
            (∏ i : Fin n, 2^d · (max 1 |α i|)^d)

  This is the **GRAND ANALYTICAL CAPSTONE**: existence + matrix
  vanishing + explicit polynomial-evaluation upper bound.

  The remaining gap toward full Roth: the integer non-vanishing
  argument (ext #23+) requires translating the matrix vanishing
  `M *ᵥ polyToCoeffs p = 0` into concrete polynomial-vanishing
  conditions at α (multiIteratedPDeriv vocabulary, the Phase 3-6
  GAP per crawler intel).

  Single derivation + Prop:
  1. `T5_schmidt_aux_analytical_capstone`: full composition theorem

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #22 — Schmidt aux + analytical bound GRAND CAPSTONE.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxiliaryPolynomial
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_BijectionClosure
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyEvalAbsBound

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxAnalyticalCapstone

open MvPolynomial Matrix
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMultiIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_VanishingMatrixEntry
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_VanishingMatrixConstruction
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsToPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyToCoeffs
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BijectionClosure
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyEvalAbsBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxiliaryPolynomial

/-! ## Schmidt aux + analytical bound GRAND CAPSTONE -/

/-- **🚨 Wave T5 session 559ooo — Schmidt aux + analytical bound capstone**.

    GRAND composition theorem combining:
    - ext #16 `T5_schmidt_auxiliary_polynomial_exists` (existence)
    - ext #9 `T5_coeffsToPoly_polyToCoeffs` (bijection on restrictDegree)
    - ext #19 `T5_coeffsToPoly_eval_abs_bound` (analytical bound)

    Given the dimension inequality, there exists a non-zero
    polynomial in `restrictDegree (Fin n) ℤ d` whose coefficient
    vector annihilates the vanishing matrix AND whose absolute
    evaluation at α is bounded by the explicit (d, n, α)-formula. -/
theorem T5_schmidt_aux_analytical_capstone
    {n d : ℕ} {J : Type*} [Fintype J]
    (I : J → BoundedMI n d) (α : Fin n → ℤ)
    (h_dim : Fintype.card J < (d + 1) ^ n)
    (h_J_pos : 0 < Fintype.card J) :
    ∃ p : MvPolynomial (Fin n) ℤ,
      p ≠ 0 ∧
      p ∈ MvPolynomial.restrictDegree (Fin n) ℤ d ∧
      vanishingMatrix J I (fun _ => α) *ᵥ
        (polyToCoeffs (d := d) p) = 0 ∧
      |(MvPolynomial.eval α) p|
        ≤ (∑ k : BoundedMI n d, |(polyToCoeffs (d := d) p) k|) *
          (∏ i : Fin n, ((2 ^ d : ℤ) * (max 1 |α i|) ^ d)) := by
  obtain ⟨p, hp_ne, hp_mem, hp_eq⟩ :=
    T5_schmidt_auxiliary_polynomial_exists I α h_dim h_J_pos
  refine ⟨p, hp_ne, hp_mem, hp_eq, ?_⟩
  -- Use ext #9 BijectionClosure: p = coeffsToPoly (polyToCoeffs p)
  -- on restrictDegree, so eval α p = eval α (coeffsToPoly (polyToCoeffs p))
  -- Then apply ext #19 with c = polyToCoeffs p
  conv_lhs => rw [← T5_coeffsToPoly_polyToCoeffs p hp_mem]
  exact T5_coeffsToPoly_eval_abs_bound _ α

/-! ## SchmidtAuxAnalyticalCapstone Prop scaffold -/

/-- **SchmidtAuxAnalyticalCapstone**: 1-conjunct Prop packaging the
    GRAND analytical capstone theorem. -/
def SchmidtAuxAnalyticalCapstone : Prop :=
  ∀ {n d : ℕ} {J : Type*} [Fintype J]
    (I : J → BoundedMI n d) (α : Fin n → ℤ),
    Fintype.card J < (d + 1) ^ n →
    0 < Fintype.card J →
    ∃ p : MvPolynomial (Fin n) ℤ,
      p ≠ 0 ∧
      p ∈ MvPolynomial.restrictDegree (Fin n) ℤ d ∧
      vanishingMatrix J I (fun _ => α) *ᵥ
        (polyToCoeffs (d := d) p) = 0 ∧
      |(MvPolynomial.eval α) p|
        ≤ (∑ k : BoundedMI n d, |(polyToCoeffs (d := d) p) k|) *
          (∏ i : Fin n, ((2 ^ d : ℤ) * (max 1 |α i|) ^ d))

/-- **🚨 Wave T5 session 559ooo — `SchmidtAuxAnalyticalCapstone`**. -/
theorem T5_schmidt_aux_analytical_capstone_prop :
    SchmidtAuxAnalyticalCapstone :=
  @T5_schmidt_aux_analytical_capstone

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559ooo — T-5 Phase 7 ext #22:
    Schmidt aux + analytical bound GRAND CAPSTONE**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #22.

    🏆 GRAND ANALYTICAL CAPSTONE — full SCAFFOLD + ANALYTICAL chain.

    Combines:
    - ext #16 `T5_schmidt_auxiliary_polynomial_exists` (existence
      via Schmidt-Wirsing-Roth Siegel composition)
    - ext #9 `T5_coeffsToPoly_polyToCoeffs` (bijection round-trip
      `coeffsToPoly ∘ polyToCoeffs = id` on restrictDegree)
    - ext #19 `T5_coeffsToPoly_eval_abs_bound` (explicit
      `|eval α (coeffsToPoly c)|` upper bound)

    Single derivation + Prop:
    1. `T5_schmidt_aux_analytical_capstone` — GRAND CAPSTONE
       theorem with 4-conjunct existential (p ≠ 0, restrictDegree,
       matrix vanishing, |eval α p| upper bound)
    + SchmidtAuxAnalyticalCapstone Prop (1-conjunct).

    Mathlib usage: `conv_lhs` + `rw` for substitution via
    BijectionClosure round-trip identity.

    Sub-lemma 215/N in T-1 (T-5 Phase 7 ext #22).  Lean-core only.

    REMAINING for full Roth main theorem:
    - ext #23+: integer non-vanishing argument (translate
      matrix vanishing `M *ᵥ polyToCoeffs p = 0` into concrete
      multiIteratedPDeriv-vanishing at α — Phase 3-6 GAP)
    - ext #24+: integer height analysis + final contradiction

    🏆 First Lean-core T-5 Phase 7 GRAND ANALYTICAL CAPSTONE
    combining SCAFFOLD + ANALYTICAL upper bound. -/
theorem session_559ooo_T5_phase7_schmidt_aux_analytical_capstone_headline :
    SchmidtAuxAnalyticalCapstone :=
  T5_schmidt_aux_analytical_capstone_prop

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxAnalyticalCapstone
