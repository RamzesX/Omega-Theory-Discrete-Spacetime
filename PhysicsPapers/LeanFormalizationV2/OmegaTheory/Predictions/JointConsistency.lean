/-
  OmegaTheory.Predictions.JointConsistency

  Joint consistency of the three independent substrate predictions:

    1. **DESI** dark-energy signature (`DESI_substrate_consistent_uniform`)
    2. **ILL / VCN cold-neutron** (`coldNeutronSubstrate_consistent_with_Ackermann_2026`)
    3. **W1 neutrino mass floor** (`W1_consistent_with_DESI`)

  Each of the three derives from the same `computationalUncertainty` kernel
  at substrate depth `N`, so picking a sufficiently large common `N₀`
  makes all three bounds simultaneously satisfied.  This is the first
  *multi-prediction* consistency theorem in OmegaTheory V2 — it rules
  out the possibility of the substrate being ruled-in by one prediction
  while ruled-out by another.

  Target closure (2026-04-19):
    - Gacrux proof-hunter-research Target #6 (simplified statement)
    - Method M7 (hub-without-shadow): DESI and W1 are both hubs but
      lacked a cross-reference APPLIES edge.  This theorem supplies
      exactly that edge.

  0 sorry, 0 new axioms.  Builds against OmegaTheory V2 as of 2026-04-19.
-/

import OmegaTheory.Predictions.DESISubstrateSignature
import OmegaTheory.Predictions.ColdNeutronILL_VCN
import OmegaTheory.Predictions.NeutrinoMassFloorW1

namespace OmegaTheory.Predictions.JointConsistency

open OmegaTheory.Predictions.DESISubstrateSignature
open OmegaTheory.Predictions.ColdNeutronILL_VCN
open OmegaTheory.Predictions.NeutrinoMassFloorW1

/-- **Joint DESI × ColdNeutron × W1 consistency** (headline).

    There exists a substrate depth `N₀` such that for every `N ≥ N₀`:

    1. Dark-energy deviation `darkEnergySubstrateEpsilon N z` stays within
       the DESI 2024 uniform-in-z bound `ε_DESI_2024` for every
       `z ∈ [0, Z_max_DESI]`.

    2. Cold-neutron fractional deviation
       `(coldNeutronSubstrateFloor N − ILL_E1_measured) / ILL_E1_measured`
       stays within the Ackermann 2026 projected precision
       `ILL_precision_Ackermann_2026`.

    3. There exists a coupling `f_ν > 0` such that the W1 neutrino-mass
       prediction `W1_neutrinoMassPrediction f_ν N` stays strictly below
       the DESI upper bound `m_nu_DESI_upper` — the squeeze window of
       Predictions/NeutrinoMassFloorW1.

    In other words: the same substrate can not be ruled out by DESI
    while being ruled in by the cold-neutron experiment, nor vice versa.
    All three predictions are simultaneously compatible. -/
theorem desi_coldneutron_w1_jointly_consistent :
    ∃ N₀ : ℕ, ∀ N ≥ N₀,
      (∀ z : ℝ, 0 ≤ z → z ≤ Z_max_DESI →
          darkEnergySubstrateEpsilon N z ≤ ε_DESI_2024)
      ∧ ((coldNeutronSubstrateFloor N - ILL_E1_measured) / ILL_E1_measured
            ≤ ILL_precision_Ackermann_2026)
      ∧ (∃ f_nu : ℝ, 0 < f_nu
            ∧ W1_neutrinoMassPrediction f_nu N < m_nu_DESI_upper) := by
  obtain ⟨N_DESI, hDESI⟩ := DESI_substrate_consistent_uniform
  obtain ⟨N_CN,   hCN⟩   := coldNeutronSubstrate_consistent_with_Ackermann_2026
  refine ⟨max N_DESI N_CN, fun N hN => ?_⟩
  have hN_DESI : N_DESI ≤ N := le_trans (le_max_left _ _) hN
  have hN_CN   : N_CN   ≤ N := le_trans (le_max_right _ _) hN
  refine ⟨?_, ?_, ?_⟩
  · -- DESI clause: uniform-in-z bound for every z in [0, Z_max].
    intro z hz hzmax
    exact hDESI N hN_DESI z hz hzmax
  · -- Cold-neutron clause: fractional deviation ≤ Ackermann precision.
    exact hCN N hN_CN
  · -- W1 clause: uses `W1_consistent_with_DESI`, which works for every N
    -- unconditionally (no N₀ threshold needed on that side).
    exact W1_consistent_with_DESI N

/-! ## 1. Squeeze-window upgrade

    The W1 clause above is the loose form (`< m_nu_DESI_upper`).  The
    tighter form, `W1_inside_squeeze_window`, asserts the prediction
    lands strictly inside the 5 meV squeeze between the oscillation
    lower bound and the DESI upper bound.  We upgrade the joint
    consistency theorem to use this tighter form. -/

/-- **Tightened joint consistency.**  Same statement as
    `desi_coldneutron_w1_jointly_consistent`, but the W1 clause is
    replaced by the squeeze-window bound — the prediction lands
    *strictly inside* the 5 meV window `[m_nu_oscillation_lower,
    m_nu_DESI_upper]`, not just below the upper bound.

    This is the paper-worthy version: all three predictions are
    *simultaneously* placed inside their narrow experimental
    windows by a single substrate state at sufficient depth. -/
theorem desi_coldneutron_w1_jointly_consistent_squeeze :
    ∃ N₀ : ℕ, ∀ N ≥ N₀,
      (∀ z : ℝ, 0 ≤ z → z ≤ Z_max_DESI →
          darkEnergySubstrateEpsilon N z ≤ ε_DESI_2024)
      ∧ ((coldNeutronSubstrateFloor N - ILL_E1_measured) / ILL_E1_measured
            ≤ ILL_precision_Ackermann_2026)
      ∧ (∃ f_nu : ℝ, 0 < f_nu
            ∧ m_nu_oscillation_lower < W1_neutrinoMassPrediction f_nu N
            ∧ W1_neutrinoMassPrediction f_nu N < m_nu_DESI_upper) := by
  obtain ⟨N_DESI, hDESI⟩ := DESI_substrate_consistent_uniform
  obtain ⟨N_CN,   hCN⟩   := coldNeutronSubstrate_consistent_with_Ackermann_2026
  refine ⟨max N_DESI N_CN, fun N hN => ?_⟩
  have hN_DESI : N_DESI ≤ N := le_trans (le_max_left _ _) hN
  have hN_CN   : N_CN   ≤ N := le_trans (le_max_right _ _) hN
  refine ⟨?_, ?_, W1_inside_squeeze_window N⟩
  · intro z hz hzmax; exact hDESI N hN_DESI z hz hzmax
  · exact hCN N hN_CN

/-! ## 2. Existence of a consistency witness

    A cleaner "exists a substrate depth that passes all three tests"
    statement, isolating the headline consequence. -/

/-- **A consistent substrate depth exists.**  There exists at least
    one substrate iteration depth `N` at which all three independent
    predictions are simultaneously consistent with their 2σ
    experimental envelopes.  This is the minimal falsifiability
    statement for "the substrate is not already ruled out by any
    single triple of experiments". -/
theorem exists_consistent_substrate_depth :
    ∃ N : ℕ,
      (∀ z : ℝ, 0 ≤ z → z ≤ Z_max_DESI →
          darkEnergySubstrateEpsilon N z ≤ ε_DESI_2024)
      ∧ ((coldNeutronSubstrateFloor N - ILL_E1_measured) / ILL_E1_measured
            ≤ ILL_precision_Ackermann_2026)
      ∧ (∃ f_nu : ℝ, 0 < f_nu
            ∧ m_nu_oscillation_lower < W1_neutrinoMassPrediction f_nu N
            ∧ W1_neutrinoMassPrediction f_nu N < m_nu_DESI_upper) := by
  obtain ⟨N₀, h⟩ := desi_coldneutron_w1_jointly_consistent_squeeze
  exact ⟨N₀, h N₀ le_rfl⟩

end OmegaTheory.Predictions.JointConsistency
