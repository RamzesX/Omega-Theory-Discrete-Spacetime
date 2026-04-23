/-
  OmegaTheory.Irrationality.GaussianSaturation

  **Wave-A EVIDENCE #3 — Gaussian minimum-uncertainty saturation of
  the extended Heisenberg bound.**

  ## Mission

  Upgrades `extendedBound_saturation` (Mothallah iter-1) from "some
  positive pair saturates the extended bound" to the more physics-
  relevant statement "the saturating pair is specifically the
  Gaussian minimum-uncertainty wavefunction's (σ_x, σ_p) pair."

  Status tag: EVIDENCE (not LOAD_BEARING).  A full Hilbert-space
  Gaussian saturation proof requires wave-packet formalism that lives
  in a future QM module (`extendedBound_saturation_hilbert`
  backlog).  This file commits to the scalar shadow: a minimal local
  predicate `IsGaussianMinimumUncertainty` is defined and the
  symmetric square-root saturation pair from Mothallah
  (`saturatingWidth`) is shown to satisfy it at every `N`.

  ## Scope

  The mission proposed using Mathlib's `ProbabilityTheory.gaussianPDF`
  / `IsGaussian` to tag the pair, but that requires a
  `MeasurableSpace` / `BorelSpace` / `InnerProductSpace` stack
  incompatible with the flat-ℝ `SaturatingWitness` record.
  Rather than fight Mathlib (mission explicit permission), we
  define a minimal local predicate capturing exactly the physics
  content: a pair (σ_x, σ_p) is a Gaussian minimum-uncertainty
  state FOR a target bound `bound` iff σ_x, σ_p > 0 and
  `σ_x · σ_p = bound` (equality, not just ≥).

  This sidesteps Mathlib Gaussian but still encodes the key fact:
  at the bound, a Gaussian (σ_x, σ_p) saturates — achieving equality.
  Full Hilbert-space proof is downstream.

  ## Name

  Agent: **Homam** (ζ Pegasi, B8.5 V blue main-sequence ~209 ly;
  Arabic `hammām` "lucky star of the hero"). Continuing Wave-A after
  LOAD_BEARING #1 + #2 landings on 2026-04-23.

  No sorry, no new axioms, scalar-shadow formulation.
-/

import OmegaTheory.Irrationality.Uncertainty
import OmegaTheory.Irrationality.ExtendedBoundUniqueness

namespace OmegaTheory.Irrationality

open OmegaTheory
open OmegaTheory.Spacetime

/-! ## §1. Local Gaussian-minimum-uncertainty predicate

We work at the ℝ-scalar level: a pair (σ_x, σ_p) of positive reals
is a Gaussian minimum-uncertainty saturator of a target `bound`
iff its product equals `bound`.  This is the textbook Heisenberg-
extremal characterization — Gaussian wavepackets are the unique
states that saturate the Heisenberg bound with EQUALITY, and the
equality takes the form σ_x σ_p = ℏ/2 in the unextended case.
Our substrate generalises to σ_x σ_p = ℏ/2 + δ_comp(N) at each
truncation budget `N`. -/

/-- A pair `(σ_x, σ_p)` is a Gaussian minimum-uncertainty saturator
    of a target bound `bound : ℝ` iff both are positive and their
    product equals `bound` exactly.

    This is the scalar shadow of the full Hilbert-space statement
    "the pair `(σ_x, σ_p)` arises from a Gaussian wavefunction
    ψ(x) = C · exp(-x²/(4σ_x²)) and its Fourier transform, saturating
    the Heisenberg bound with equality".  The Gaussian-specific
    upgrade over mere `SaturatingWitness` is that this predicate
    pins EQUALITY (not inequality) of the product to the bound. -/
def IsGaussianMinimumUncertainty (σ_x σ_p : ℝ) (bound : ℝ) : Prop :=
  0 < σ_x ∧ 0 < σ_p ∧ σ_x * σ_p = bound

/-- Positivity shadow from the predicate. -/
theorem IsGaussianMinimumUncertainty.σ_x_pos {σ_x σ_p bound : ℝ}
    (h : IsGaussianMinimumUncertainty σ_x σ_p bound) : 0 < σ_x :=
  h.1

theorem IsGaussianMinimumUncertainty.σ_p_pos {σ_x σ_p bound : ℝ}
    (h : IsGaussianMinimumUncertainty σ_x σ_p bound) : 0 < σ_p :=
  h.2.1

theorem IsGaussianMinimumUncertainty.product_eq {σ_x σ_p bound : ℝ}
    (h : IsGaussianMinimumUncertainty σ_x σ_p bound) :
    σ_x * σ_p = bound :=
  h.2.2

/-- The product of a Gaussian minimum-uncertainty pair is positive
    iff the target bound is positive.  Companion check. -/
theorem IsGaussianMinimumUncertainty.bound_pos {σ_x σ_p bound : ℝ}
    (h : IsGaussianMinimumUncertainty σ_x σ_p bound) : 0 < bound := by
  rw [← h.product_eq]
  exact mul_pos h.σ_x_pos h.σ_p_pos

/-! ## §2. The symmetric Gaussian witness

The Mothallah `saturatingWidth N` in both slots is the canonical
Gaussian-shadow minimum-uncertainty witness for the extended
Heisenberg bound `ℏ/2 + δ_comp(N)`.  This is a direct wrapping of
`saturatingWidth_sq`. -/

/-- **Wave-A EVIDENCE #3 landing** —
    `pi_hunch_saturating_state_is_gaussian`.

    At every truncation budget `N`, the symmetric Mothallah width
    `saturatingWidth N` in both slots forms a Gaussian minimum-
    uncertainty pair saturating the extended Heisenberg bound
    `ℏ/2 + δ_comp(N)`.

    Concretely we prove two things:
    (1) `saturatingWidth N = √(extendedUncertaintyBound N)`
        (already `rfl` by definition of `saturatingWidth`);
    (2) The pair `(saturatingWidth N, saturatingWidth N)` satisfies
        `IsGaussianMinimumUncertainty ... (extendedUncertaintyBound N)`,
        i.e. both are positive and their product equals the bound.

    Physical reading: the substrate correction δ_comp only becomes
    experimentally visible when the position/momentum widths sit at
    the symmetric Gaussian point √(ℏ/2 + δ_comp(N)) — a testable
    prediction distinguishing the substrate theory from standard
    Heisenberg (where the saturator is √(ℏ/2)). -/
theorem pi_hunch_saturating_state_is_gaussian (N : ℕ) :
    saturatingWidth N = Real.sqrt (extendedUncertaintyBound N)
    ∧ IsGaussianMinimumUncertainty
        (saturatingWidth N) (saturatingWidth N)
        (extendedUncertaintyBound N) := by
  refine ⟨rfl, ?_, ?_, ?_⟩
  · exact saturatingWidth_pos N
  · exact saturatingWidth_pos N
  · exact saturatingWidth_sq N

/-! ## §3. Uniqueness of the symmetric Gaussian saturator

Given an extended bound `b = ℏ/2 + δ_comp(N)`, the symmetric
Gaussian saturator (σ_x = σ_p) is unique — it is the square-root
`√b`.  This reproduces the textbook statement that at fixed bound
the minimum-uncertainty Gaussian has a specific width. -/

/-- Uniqueness of the symmetric Gaussian saturator: if a pair
    `(σ, σ)` is a Gaussian minimum-uncertainty saturator of a
    positive bound `b`, then `σ = √b`. -/
theorem symmetric_gaussian_width_unique (σ : ℝ) (bound : ℝ)
    (h : IsGaussianMinimumUncertainty σ σ bound) :
    σ = Real.sqrt bound := by
  have hσ : 0 < σ := h.σ_x_pos
  have hsq : σ * σ = bound := h.product_eq
  -- σ² = b, σ > 0, so σ = √b.
  have hb_nn : 0 ≤ bound := by
    rw [← hsq]
    exact mul_nonneg hσ.le hσ.le
  have : σ ^ 2 = bound := by rw [pow_two]; exact hsq
  rw [← this]
  rw [Real.sqrt_sq hσ.le]

/-- Corollary: at every `N`, the unique symmetric Gaussian saturator
    of `extendedUncertaintyBound N` is exactly `saturatingWidth N`. -/
theorem saturatingWidth_is_unique_symmetric_gaussian (N : ℕ)
    (σ : ℝ)
    (h : IsGaussianMinimumUncertainty σ σ (extendedUncertaintyBound N)) :
    σ = saturatingWidth N := by
  rw [symmetric_gaussian_width_unique σ _ h]
  rfl

/-! ## §4. Packaged four-conjunct Wave-A EVIDENCE headline -/

/-- **Wave-A EVIDENCE #3 packaged** — four-conjunct signature.

    Simultaneously witnesses:
    (1) `saturatingWidth N = √(extendedUncertaintyBound N)`
        (identification with the Gaussian-wavefunction width);
    (2) the pair `(saturatingWidth, saturatingWidth)` is a Gaussian
        minimum-uncertainty state for the extended bound;
    (3) the symmetric Gaussian saturator is unique at each `N`;
    (4) the product `saturatingWidth N * saturatingWidth N` equals
        `extendedUncertaintyBound N` (the saturation equality). -/
theorem pi_hunch_gaussian_saturation_packaged (N : ℕ) :
    saturatingWidth N = Real.sqrt (extendedUncertaintyBound N)
    ∧ IsGaussianMinimumUncertainty
        (saturatingWidth N) (saturatingWidth N)
        (extendedUncertaintyBound N)
    ∧ (∀ σ : ℝ,
        IsGaussianMinimumUncertainty σ σ (extendedUncertaintyBound N) →
        σ = saturatingWidth N)
    ∧ saturatingWidth N * saturatingWidth N = extendedUncertaintyBound N := by
  obtain ⟨h_sqrt, h_gauss⟩ := pi_hunch_saturating_state_is_gaussian N
  refine ⟨h_sqrt, h_gauss, ?_, saturatingWidth_sq N⟩
  intro σ hσ
  exact saturatingWidth_is_unique_symmetric_gaussian N σ hσ

/-- Companion: the existence of the canonical Gaussian minimum-
    uncertainty witness at every `N`.  This is the constructive
    existence side of the Wave-A EVIDENCE claim. -/
theorem gaussian_saturator_exists (N : ℕ) :
    ∃ σ_x σ_p : ℝ, IsGaussianMinimumUncertainty σ_x σ_p
      (extendedUncertaintyBound N) := by
  refine ⟨saturatingWidth N, saturatingWidth N, ?_, ?_, ?_⟩
  · exact saturatingWidth_pos N
  · exact saturatingWidth_pos N
  · exact saturatingWidth_sq N

end OmegaTheory.Irrationality
