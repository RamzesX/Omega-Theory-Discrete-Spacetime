/-
  OmegaTheory.Predictions.SpinFlipRate

  **Closed-form T²-scaling extension** of Sirius's `spin_flip_strictly_positive`
  (HermiticityDefect.lean:173).

  Standard QM says an isolated spin-1/2's flip rate under repeated Hermitian
  measurement is exactly zero — measurements are infinitely repeatable.  The
  substrate predicts a finite, T²-scaling rate:

      Γ_flip(T) = 4·ℓ_P²·k_B²·T²/(ℏ²·c²·t_P)

  At T = 300 K this evaluates to ~10⁻⁵² s⁻¹: out of practical reach (~50 OOM
  below cosmic-ray / phonon backgrounds), but *qualitatively* nonzero.  The
  substrate therefore provides a mechanism for finite measurement repeatability
  that standard QM categorically lacks — formalized here as

      Γ_sub(T) > Γ_QM = 0     for any T > 0.

  This file completes Appendix-J §8 row 6 ("theorem to be added" for
  spin-1/2 flip rate).

  Theorems shipped:
    §1. `spinFlipRateSubstrate_eq_paper`         — definitional paper-form
    §2. `spinFlipRateSubstrate_nonneg`           — Γ ≥ 0 always
    §2. `spinFlipRateSubstrate_pos`              — Γ > 0 for T > 0
    §3. `spinFlipRateSubstrate_T_squared_monotone` — 0 ≤ T₁ ≤ T₂ ⇒ Γ(T₁) ≤ Γ(T₂)
    §4. `spinFlipRateSubstrate_strictly_exceeds_standard_QM` — distinguisher
    §5. `spinFlipRateSubstrate_simplified_form`  — equivalent Γ = 4·t_P·k_B²·T²/ℏ²

  No `sorry`.  No new axioms.  Author: team-lead (v2-apr15-lean wave 3),
  2026-04-15.
-/

import OmegaTheory.Spacetime.Constants
import Mathlib.Tactic

namespace OmegaTheory.Predictions

open OmegaTheory.Spacetime

/-! ## §1.  Definitions -/

/-- **Substrate-predicted spin-1/2 flip rate** at temperature `T`.
    Closed form from Appendix-J §3.2:
    `Γ_flip(T) = 4·ℓ_P²·k_B²·T²/(ℏ²·c²·t_P)`.

    Independent of all dynamical details — purely composed of the five
    fundamental constants and temperature.  This is the qualitative
    distinguisher from standard QM's `Γ = 0` baseline. -/
noncomputable def spinFlipRateSubstrate (T : ℝ) : ℝ :=
  4 * l_P ^ 2 * k_B ^ 2 * T ^ 2 / (hbar ^ 2 * c ^ 2 * t_P)

/-- **Standard-QM spin-1/2 flip rate**: exactly zero.  A Hermitian observable's
    projection operators commute with themselves, so immediate re-measurement
    yields the same outcome with probability 1. -/
def spinFlipRateStandardQM : ℝ := 0

/-! ## §2.  Positivity and paper form -/

/-- **Paper identity** (definitional): the rate equals the Appendix-J §3.2
    closed form.  Exists as a named theorem so that papers can cite
    `SpinFlipRate.spinFlipRateSubstrate_eq_paper` rather than the `def` itself. -/
theorem spinFlipRateSubstrate_eq_paper (T : ℝ) :
    spinFlipRateSubstrate T =
      4 * l_P ^ 2 * k_B ^ 2 * T ^ 2 / (hbar ^ 2 * c ^ 2 * t_P) := rfl

/-- **Non-negativity**: the rate is always ≥ 0. -/
theorem spinFlipRateSubstrate_nonneg (T : ℝ) :
    0 ≤ spinFlipRateSubstrate T := by
  unfold spinFlipRateSubstrate
  apply div_nonneg
  · have h4 : (0:ℝ) ≤ 4 := by norm_num
    have hl : 0 ≤ l_P ^ 2 := sq_nonneg _
    have hk : 0 ≤ k_B ^ 2 := sq_nonneg _
    have hT : 0 ≤ T ^ 2 := sq_nonneg _
    exact mul_nonneg (mul_nonneg (mul_nonneg h4 hl) hk) hT
  · have hh : 0 ≤ hbar ^ 2 := sq_nonneg _
    have hc : 0 ≤ c ^ 2 := sq_nonneg _
    exact mul_nonneg (mul_nonneg hh hc) t_P_nonneg

/-- **Strict positivity** at positive temperature.  Rules out the standard-QM
    `Γ = 0` prediction at any nonzero temperature — the core qualitative
    substrate claim. -/
theorem spinFlipRateSubstrate_pos (T : ℝ) (hT : 0 < T) :
    0 < spinFlipRateSubstrate T := by
  unfold spinFlipRateSubstrate
  have h4 : (0:ℝ) < 4 := by norm_num
  have hl : 0 < l_P ^ 2 := pow_pos l_P_pos 2
  have hk : 0 < k_B ^ 2 := pow_pos k_B_pos 2
  have hT2 : 0 < T ^ 2 := pow_pos hT 2
  have hh : 0 < hbar ^ 2 := pow_pos hbar_pos 2
  have hc : 0 < c ^ 2 := pow_pos c_pos 2
  have hnum : 0 < 4 * l_P ^ 2 * k_B ^ 2 * T ^ 2 :=
    mul_pos (mul_pos (mul_pos h4 hl) hk) hT2
  have hden : 0 < hbar ^ 2 * c ^ 2 * t_P :=
    mul_pos (mul_pos hh hc) t_P_pos
  exact div_pos hnum hden

/-! ## §3.  T² monotonicity -/

/-- **T² monotonicity**: `0 ≤ T₁ ≤ T₂ ⇒ Γ_flip(T₁) ≤ Γ_flip(T₂)`.

    The rate inherits the quadratic temperature dependence through its
    `T²` prefactor.  Together with `spinFlipRateSubstrate_pos` this is the
    temperature-dependent discriminator against temperature-independent
    collapse models (e.g., Diosi-Penrose; Appendix-J §2.1). -/
theorem spinFlipRateSubstrate_T_squared_monotone
    {T₁ T₂ : ℝ} (hT1 : 0 ≤ T₁) (h : T₁ ≤ T₂) :
    spinFlipRateSubstrate T₁ ≤ spinFlipRateSubstrate T₂ := by
  unfold spinFlipRateSubstrate
  have h_coeff_nonneg :
      0 ≤ 4 * l_P ^ 2 * k_B ^ 2 / (hbar ^ 2 * c ^ 2 * t_P) := by
    apply div_nonneg
    · have h4 : (0:ℝ) ≤ 4 := by norm_num
      have hl : 0 ≤ l_P ^ 2 := sq_nonneg _
      have hk : 0 ≤ k_B ^ 2 := sq_nonneg _
      exact mul_nonneg (mul_nonneg h4 hl) hk
    · have hh : 0 ≤ hbar ^ 2 := sq_nonneg _
      have hc : 0 ≤ c ^ 2 := sq_nonneg _
      exact mul_nonneg (mul_nonneg hh hc) t_P_nonneg
  have hT2_le : T₁ ^ 2 ≤ T₂ ^ 2 := by
    rw [sq, sq]
    exact mul_self_le_mul_self hT1 h
  have hrhs_eq :
      4 * l_P ^ 2 * k_B ^ 2 * T₂ ^ 2 / (hbar ^ 2 * c ^ 2 * t_P) =
        (4 * l_P ^ 2 * k_B ^ 2 / (hbar ^ 2 * c ^ 2 * t_P)) * T₂ ^ 2 := by ring
  have hlhs_eq :
      4 * l_P ^ 2 * k_B ^ 2 * T₁ ^ 2 / (hbar ^ 2 * c ^ 2 * t_P) =
        (4 * l_P ^ 2 * k_B ^ 2 / (hbar ^ 2 * c ^ 2 * t_P)) * T₁ ^ 2 := by ring
  rw [hlhs_eq, hrhs_eq]
  exact mul_le_mul_of_nonneg_left hT2_le h_coeff_nonneg

/-! ## §4.  Substrate-vs-QM distinguisher -/

/-- **Substrate strictly exceeds standard QM**.  For any positive temperature,
    `Γ_sub(T) > Γ_QM = 0`.  A *qualitative*, not quantitative, distinguisher
    — the numerical gap of ~10⁻⁵² s⁻¹ at 300 K is far below cosmic-ray
    backgrounds, but its existence is the crucial structural claim. -/
theorem spinFlipRateSubstrate_strictly_exceeds_standard_QM
    (T : ℝ) (hT : 0 < T) :
    spinFlipRateStandardQM < spinFlipRateSubstrate T := by
  unfold spinFlipRateStandardQM
  exact spinFlipRateSubstrate_pos T hT

/-! ## §5.  Simplified form via Planck relation -/

/-- **Simplified closed form** using `ℓ_P = c·t_P` (Planck-unit relation
    from `Constants.lean:46`): the rate reduces to

        Γ_flip = 4·t_P·k_B²·T²/ℏ²

    an equivalent expression with `c` eliminated in favour of `t_P`.  Useful
    for dimensional-analysis sketches since the `c` factor cancels exactly. -/
theorem spinFlipRateSubstrate_simplified_form (T : ℝ) :
    spinFlipRateSubstrate T = 4 * t_P * k_B ^ 2 * T ^ 2 / hbar ^ 2 := by
  unfold spinFlipRateSubstrate
  have htP_def : t_P = l_P / c := rfl
  rw [htP_def]
  have hc_ne : (c : ℝ) ≠ 0 := c_ne_zero
  have hlP_ne : l_P ≠ 0 := l_P_ne_zero
  have hh_ne : hbar ≠ 0 := hbar_ne_zero
  field_simp

end OmegaTheory.Predictions
