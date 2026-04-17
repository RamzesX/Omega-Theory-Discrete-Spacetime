/-
  OmegaTheory.Probe.StressTest1

  Stress test for lean-proof-wizard pattern.
  Three ambitious proofs about the extended uncertainty bound and δ_comp.
-/

import OmegaTheory.Irrationality.Uncertainty
import OmegaTheory.Spacetime.Constants
import OmegaTheory.Conservation.Correspondence
import Mathlib.Tactic

namespace OmegaTheory.Probe

open OmegaTheory.Spacetime OmegaTheory.Irrationality

/-- Proof 1: The extended uncertainty bound exceeds ℏ/2 by EXACTLY δ_comp(N). -/
theorem stress_extended_gap (N : ℕ) :
    extendedUncertaintyBound N - hbar / 2 = computationalUncertainty N := by
  unfold extendedUncertaintyBound
  ring

/-- Proof 2: δ_comp(N) can be made arbitrarily small.
    Archimedean reduction: δ_comp(N) = l_P · 4/(2N+3), so picking
    2N+3 > 4·l_P/ε makes the product strictly below ε. -/
theorem stress_eventually_small (ε : ℝ) (hε : 0 < ε) :
    ∃ N : ℕ, computationalUncertainty N < ε := by
  -- δ_comp(N) = l_P * 4/(2N+3).  We want  l_P * 4/(2N+3) < ε
  --   ↔  2N+3 > 4 l_P / ε.
  obtain ⟨N, hN⟩ := exists_nat_gt (4 * l_P / ε)
  refine ⟨N, ?_⟩
  -- Unfold the definitions to the concrete expression l_P * (4/(2N+3)).
  unfold computationalUncertainty
    OmegaTheory.Irrationality.dominantErrorBound
    OmegaTheory.Irrationality.piErrorBound
    OmegaTheory.Irrationality.pi_error_val
  -- Denominator positivity
  have h2N3_pos : (0 : ℝ) < 2 * (N : ℝ) + 3 := by positivity
  -- From `4 * l_P / ε < N`, multiply both sides by ε (>0):
  --    4 * l_P < N * ε ≤ (2N+3)/... easier: reduce inequality to linarith.
  -- We will prove  l_P * (4/(2N+3)) < ε   ↔   l_P * 4 < ε * (2N+3).
  rw [show (l_P * (4 / (2 * (N : ℝ) + 3)) : ℝ) = (l_P * 4) / (2 * (N : ℝ) + 3) by ring]
  rw [div_lt_iff₀ h2N3_pos]
  -- Goal:  l_P * 4 < ε * (2N+3)
  -- We have   4 * l_P / ε < N   hence   4 * l_P < N * ε   (since ε > 0).
  have h1 : 4 * l_P < (N : ℝ) * ε := by
    have := (div_lt_iff₀ hε).mp hN
    linarith
  -- ε * (2N+3) = 2·N·ε + 3·ε ≥ N·ε + 3·ε > 4·l_P  since N·ε ≥ 0 adds slack and 3ε > 0.
  nlinarith [hε, l_P_nonneg, Nat.cast_nonneg (α := ℝ) N]

/-- Proof 3: δ_comp is positive AND (weakly) decreasing — packaged. -/
theorem stress_delta_properties (N : ℕ) :
    0 < computationalUncertainty N ∧
    computationalUncertainty (N + 1) ≤ computationalUncertainty N :=
  ⟨computationalUncertainty_pos N, computationalUncertainty_decreasing N⟩

end OmegaTheory.Probe
