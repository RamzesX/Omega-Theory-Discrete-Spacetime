/-
  OmegaTheory.Irrationality.Uncertainty

  Extended Uncertainty Principle from computational truncation.

  The key insight: Heisenberg's Δx·Δp ≥ ℏ/2 gets an ADDITIONAL term
  from the computational incompleteness of irrational calculations:

    Δx · Δp ≥ ℏ/2 + δ_comp(ρ_S, T)

  This is NOVEL — standard physics has only the ℏ/2 term.
  The computational uncertainty δ_comp depends on:
  - Action density ρ_S (more action = less computation = more uncertainty)
  - Temperature T (hotter = faster thresholds = less precision)
-/

import OmegaTheory.Irrationality.Approximations
import OmegaTheory.Spacetime.Constants

namespace OmegaTheory.Irrationality

open OmegaTheory.Spacetime
open OmegaTheory.Foundations

/-! ## Computational Uncertainty

The additional uncertainty from finite computation of geometric factors.
δ_comp = α · ε(N) where ε is the dominant truncation error and
α is a coupling constant of order l_P. -/

/-- Computational uncertainty from truncation at N iterations.
    δ_comp = l_P · dominant_error(N) -/
noncomputable def computationalUncertainty (N : ℕ) : ℝ :=
  l_P * (dominantErrorBound N).val

/-- Computational uncertainty is nonneg. -/
theorem computationalUncertainty_nonneg (N : ℕ) :
    0 ≤ computationalUncertainty N :=
  mul_nonneg l_P_nonneg (dominantErrorBound N).nonneg

/-- Computational uncertainty is positive for any N. -/
theorem computationalUncertainty_pos (N : ℕ) :
    0 < computationalUncertainty N :=
  mul_pos l_P_pos (pi_error_pos N)

/-- Computational uncertainty decreases with more iterations. -/
theorem computationalUncertainty_decreasing (N : ℕ) :
    computationalUncertainty (N + 1) ≤ computationalUncertainty N := by
  unfold computationalUncertainty
  exact mul_le_mul_of_nonneg_left (dominantError_decreasing N) l_P_nonneg

/-- Computational uncertainty as ErrorBound. -/
noncomputable def computationalUncertaintyBound (N : ℕ) : ErrorBound :=
  ⟨computationalUncertainty N, computationalUncertainty_nonneg N⟩

/-! ## Extended Uncertainty Principle

The standard Heisenberg uncertainty principle is:
  Δx · Δp ≥ ℏ/2

The EXTENDED principle adds computational uncertainty:
  Δx · Δp ≥ ℏ/2 + δ_comp

This is a STRONGER bound — the computational term is always positive. -/

/-- The extended uncertainty bound: ℏ/2 + δ_comp(N). -/
noncomputable def extendedUncertaintyBound (N : ℕ) : ℝ :=
  hbar / 2 + computationalUncertainty N

/-- The extended bound is strictly greater than the Heisenberg bound. -/
theorem extended_gt_heisenberg (N : ℕ) :
    hbar / 2 < extendedUncertaintyBound N := by
  unfold extendedUncertaintyBound
  linarith [computationalUncertainty_pos N]

/-- The extended bound is positive. -/
theorem extendedUncertaintyBound_pos (N : ℕ) :
    0 < extendedUncertaintyBound N := by
  unfold extendedUncertaintyBound
  linarith [div_pos hbar_pos two_pos, computationalUncertainty_nonneg N]

/-- The extended uncertainty principle as a structure.
    An observable pair (x, p) satisfies the extended principle
    if their product exceeds the extended bound. -/
structure SatisfiesExtendedUncertainty (Δx Δp : ℝ) (N : ℕ) : Prop where
  heisenberg : Δx * Δp ≥ hbar / 2
  computational : Δx * Δp ≥ hbar / 2 + computationalUncertainty N

/-- The computational term makes the bound STRICTLY stronger. -/
theorem extended_strictly_stronger (Δx Δp : ℝ) (N : ℕ)
    (h : SatisfiesExtendedUncertainty Δx Δp N) :
    Δx * Δp > hbar / 2 := by
  linarith [h.computational, computationalUncertainty_pos N]

/-! ## Temperature Dependence

Higher temperature → faster action threshold crossings →
fewer computational iterations → larger δ_comp.

The iteration budget N_max = ℏ/(N·k_B·T·t_P) decreases with T. -/

/-- Iteration budget from temperature: N_max ~ ℏ/(k_B·T·t_P).
    (Simplified: single particle, N=1) -/
noncomputable def iterationBudget (T_temp : ℝ) : ℝ :=
  hbar / (k_B * T_temp * t_P)

/-- Higher temperature → fewer iterations. -/
theorem iterationBudget_decreases_with_T (T₁ T₂ : ℝ) (hT1 : 0 < T₁) (hT2 : 0 < T₂)
    (h : T₁ ≤ T₂) :
    iterationBudget T₂ ≤ iterationBudget T₁ := by
  unfold iterationBudget
  apply div_le_div_of_nonneg_left (by linarith [hbar_pos])
  · exact mul_pos (mul_pos k_B_pos hT1) t_P_pos
  · exact mul_le_mul_of_nonneg_right (mul_le_mul_of_nonneg_left h (le_of_lt k_B_pos)) (le_of_lt t_P_pos)

end OmegaTheory.Irrationality
