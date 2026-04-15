/-
  OmegaTheory.Predictions.GammaRayDispersion

  **Pierre Auger 2026 consistency theorem** — substrate's gamma-ray
  time-of-flight dispersion is below any positive upper bound for N
  sufficiently large, formalizing Appendix-J §2.3's "substrate is
  consistent with all current null results" claim.

  Substrate dispersion (Appendix-J §2.3):

      δω/ω = (E/E_P) · 4/(2N+3)

  Pure Lorentz-violation models (by contrast): `δω/ω = κ·(E/E_P)` —
  constant in N.  The *N-dependence* is the qualitative distinguisher:
  substrate decreases toward zero with iteration budget; pure-LV is flat.

  Seven theorems shipped:
    §1. `gammaRayDispersionSubstrate_zero_at_zero_energy`
    §2. `gammaRayDispersionSubstrate_nonneg`
    §2. `gammaRayDispersionSubstrate_pos` (for positive E)
    §3. `gammaRayDispersionSubstrate_decreasing_in_N`
    §4. `gammaRayDispersionSubstrate_below_any_positive_bound`
         — the Pierre Auger consistency theorem
    §5. `pure_LV_is_constant_in_N` — distinguisher half A
    §5. `substrate_vs_pure_LV_distinguisher` — distinguisher half B

  No `sorry`.  No new axioms.  Author: team-lead (v2-apr15-lean wave 4),
  2026-04-15.  Implements Appendix-J §2.3 Pierre Auger consistency
  (arXiv 2602.14720) and the pure-LV distinguisher.
-/

import OmegaTheory.Spacetime.Constants
import Mathlib.Tactic

namespace OmegaTheory.Predictions

open OmegaTheory.Spacetime

/-! ## §1.  Definitions -/

/-- **Substrate-predicted gamma-ray dispersion** for a photon of energy
    `E` propagating through `N` lattice ticks.  Closed form from
    Appendix-J §2.3:

        δω/ω = (E/E_P) · 4/(2N+3)

    The `4/(2N+3)` factor is the dominant π-Leibniz truncation error;
    the `E/E_P` factor is the fundamental energy-over-Planck-energy
    scaling common to all quantum-gravity dispersion models. -/
noncomputable def gammaRayDispersionSubstrate (E : ℝ) (N : ℕ) : ℝ :=
  (E / E_P) * (4 / (2 * (N : ℝ) + 3))

/-- **Pure Lorentz-violation model** with coefficient `κ`: constant-in-N
    fractional dispersion `κ·(E/E_P)`.  Exists as a separate definition
    so that the N-dependence distinguisher can be stated precisely. -/
noncomputable def gammaRayDispersionLorentzViolation (κ E : ℝ) (_N : ℕ) : ℝ :=
  κ * (E / E_P)

/-! ## §2.  Basic positivity and structure -/

/-- Zero dispersion at zero photon energy (sanity check). -/
theorem gammaRayDispersionSubstrate_zero_at_zero_energy (N : ℕ) :
    gammaRayDispersionSubstrate 0 N = 0 := by
  unfold gammaRayDispersionSubstrate
  simp

/-- The denominator `2N + 3` is strictly positive for all `N : ℕ`. -/
private theorem denom_pos (N : ℕ) : 0 < 2 * (N : ℝ) + 3 := by
  have h : 0 ≤ (N : ℝ) := Nat.cast_nonneg N
  linarith

/-- Non-negativity of the substrate dispersion for non-negative `E`. -/
theorem gammaRayDispersionSubstrate_nonneg {E : ℝ} (hE : 0 ≤ E) (N : ℕ) :
    0 ≤ gammaRayDispersionSubstrate E N := by
  unfold gammaRayDispersionSubstrate
  exact mul_nonneg (div_nonneg hE E_P_nonneg)
    (div_nonneg (by norm_num) (le_of_lt (denom_pos N)))

/-- Strict positivity of the substrate dispersion at positive `E`. -/
theorem gammaRayDispersionSubstrate_pos {E : ℝ} (hE : 0 < E) (N : ℕ) :
    0 < gammaRayDispersionSubstrate E N := by
  unfold gammaRayDispersionSubstrate
  exact mul_pos (div_pos hE E_P_pos)
    (div_pos (by norm_num : (0:ℝ) < 4) (denom_pos N))

/-! ## §3.  Monotone decrease in iteration budget -/

/-- **Substrate dispersion decreases with N**: each additional lattice
    tick (i.e., each unit of iteration budget) tightens the upper bound
    on dispersion.  Key structural fact — substrate's prediction
    *vanishes* with unlimited computational budget, whereas pure-LV
    models have a fixed positive floor. -/
theorem gammaRayDispersionSubstrate_decreasing_in_N
    {E : ℝ} (hE : 0 ≤ E) (N : ℕ) :
    gammaRayDispersionSubstrate E (N + 1) ≤ gammaRayDispersionSubstrate E N := by
  unfold gammaRayDispersionSubstrate
  apply mul_le_mul_of_nonneg_left _ (div_nonneg hE E_P_nonneg)
  have h1 : (0 : ℝ) < 2 * (N : ℝ) + 3 := denom_pos N
  have h2 : 2 * (N : ℝ) + 3 ≤ 2 * ((N + 1 : ℕ) : ℝ) + 3 := by
    push_cast; linarith
  exact div_le_div_of_nonneg_left (by norm_num : (0:ℝ) ≤ 4) h1 h2

/-! ## §4.  Pierre Auger consistency theorem

    For any positive upper bound `B > 0`, there exists `N₀` such that
    the substrate prediction at all `N ≥ N₀` sits below `B`.  This is
    the Lean-side version of Appendix-J §2.3's claim that "substrate
    predictions are consistent with all current null results": at any
    experimental sensitivity `B`, the substrate at sufficiently many
    lattice ticks lies below `B`. -/

theorem gammaRayDispersionSubstrate_below_any_positive_bound
    {E : ℝ} (hE : 0 ≤ E) {B : ℝ} (hB : 0 < B) :
    ∃ N₀ : ℕ, ∀ N ≥ N₀, gammaRayDispersionSubstrate E N ≤ B := by
  by_cases hE_zero : E = 0
  · -- `E = 0` trivial: dispersion is zero.
    refine ⟨0, fun N _ => ?_⟩
    rw [hE_zero, gammaRayDispersionSubstrate_zero_at_zero_energy]
    exact le_of_lt hB
  · push_neg at hE_zero
    have hE_pos : 0 < E := lt_of_le_of_ne hE (Ne.symm hE_zero)
    have hEP : 0 < E_P := E_P_pos
    have hEPB : 0 < E_P * B := mul_pos hEP hB
    -- Pick `N₀` strictly greater than `2E/(E_P · B)`.
    obtain ⟨N₀, hN₀⟩ := exists_nat_gt (2 * E / (E_P * B))
    refine ⟨N₀, fun N hN => ?_⟩
    have hN_cast : (N₀ : ℝ) ≤ (N : ℝ) := Nat.cast_le.mpr hN
    have hN_gt : 2 * E / (E_P * B) < (N : ℝ) := lt_of_lt_of_le hN₀ hN_cast
    unfold gammaRayDispersionSubstrate
    have h_rewrite :
        (E / E_P) * (4 / (2 * (N : ℝ) + 3))
          = 4 * E / (E_P * (2 * (N : ℝ) + 3)) := by
      field_simp
    rw [h_rewrite]
    have hsum : 0 < 2 * (N : ℝ) + 3 := denom_pos N
    have hden : 0 < E_P * (2 * (N : ℝ) + 3) := mul_pos hEP hsum
    rw [div_le_iff₀ hden]
    -- Goal: `4 * E ≤ B * (E_P * (2·N + 3))`.
    have h4E_lt : 4 * E / (E_P * B) < 2 * (N : ℝ) := by
      have hN2 : 2 * E / (E_P * B) * 2 < (N : ℝ) * 2 := by linarith
      have : 4 * E / (E_P * B) = 2 * E / (E_P * B) * 2 := by ring
      linarith
    have h4E_lt_2N3 : 4 * E / (E_P * B) < 2 * (N : ℝ) + 3 := by linarith
    have := (div_lt_iff₀ hEPB).mp h4E_lt_2N3
    linarith

/-! ## §5.  Distinguisher from pure Lorentz-violation models -/

/-- **Pure-LV is N-independent**: distinguisher side A.  The pure-LV
    prediction does not depend on the iteration budget `N` — it is a
    constant function of `N` for fixed `κ, E`. -/
theorem pure_LV_is_constant_in_N (κ E : ℝ) (N₁ N₂ : ℕ) :
    gammaRayDispersionLorentzViolation κ E N₁
      = gammaRayDispersionLorentzViolation κ E N₂ := rfl

/-- **Substrate below pure-LV for large N**: distinguisher side B.  For
    any positive pure-LV signal `κ · (E/E_P) > 0`, there exists `N₀`
    such that the substrate prediction at every `N ≥ N₀` lies strictly
    below the pure-LV constant.  Experimental consequence: if a future
    observation detects a fixed nonzero LIV signal, substrate predicts
    the observed coefficient should *decrease* with higher-precision
    measurements (more N available); pure-LV predicts it should stay
    constant. -/
theorem substrate_vs_pure_LV_distinguisher
    {E : ℝ} (hE : 0 < E) {κ : ℝ} (hκ : 0 < κ) :
    ∃ N₀ : ℕ, ∀ N ≥ N₀,
      gammaRayDispersionSubstrate E N < gammaRayDispersionLorentzViolation κ E N := by
  have h_LV_pos : 0 < gammaRayDispersionLorentzViolation κ E 0 := by
    unfold gammaRayDispersionLorentzViolation
    exact mul_pos hκ (div_pos hE E_P_pos)
  obtain ⟨N₀, hN₀⟩ :=
    gammaRayDispersionSubstrate_below_any_positive_bound
      (le_of_lt hE) (half_pos h_LV_pos)
  refine ⟨N₀, fun N hN => ?_⟩
  have h_sub_le : gammaRayDispersionSubstrate E N
                    ≤ gammaRayDispersionLorentzViolation κ E 0 / 2 := hN₀ N hN
  have h_const :
      gammaRayDispersionLorentzViolation κ E 0
        = gammaRayDispersionLorentzViolation κ E N :=
    pure_LV_is_constant_in_N κ E 0 N
  linarith [h_LV_pos, h_const]

end OmegaTheory.Predictions
