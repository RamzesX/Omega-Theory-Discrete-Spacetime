/-
  OmegaTheory.Irrationality.ActionDensity

  Action density and computational time emergence (Appendix A).

  Formalizes three core Appendix-A constructions:
  - Def 2.1: ρ_S := S/V         (raw action density)
  - Def 2.2: ρ_S := N·k_B·T/V    (thermodynamic form via equipartition)
  - Postulate A4: dt := dS/L     (time emerges from action increment / Lagrangian)
  - Corollary A5: N_max := ℏ/(L·t_P)  (iteration budget from Lagrangian)

  Companion to `Uncertainty.lean`, which has the extended uncertainty
  principle Δx·Δp ≥ ℏ/2 + δ(ρ_S) that consumes action density.
-/

import OmegaTheory.Spacetime.Constants

namespace OmegaTheory.Irrationality

open OmegaTheory.Spacetime

/-! ## Action Density (Def 2.1 & 2.2) -/

/-- Raw action density: action per unit volume, ρ_S := S/V.
    Paper reference: Appendix A, Definition 2.1. -/
noncomputable def actionDensity (S V : ℝ) : ℝ := S / V

/-- Thermodynamic action density via equipartition:
    ρ_S := N·k_B·T / V.
    Paper reference: Appendix A, Definition 2.2. -/
noncomputable def thermalActionDensity (N T V : ℝ) : ℝ := N * k_B * T / V

/-! ## Emergent Time (Postulate A4) -/

/-- Emergent time from action increment: dt := dS / L.
    Time is not fundamental — it is the ratio of action change to
    Lagrangian. Paper reference: Appendix A, Postulate A4. -/
noncomputable def emergentTime (dS L : ℝ) : ℝ := dS / L

/-- Iteration budget at a given Lagrangian scale:
    N_max := ℏ / (L · t_P).
    This is how many Planck-tick updates the computational substrate
    can afford at action rate L before the universe runs out of
    Planck-action per Planck-tick. Paper reference: Corollary A5. -/
noncomputable def iterationBudgetFromLagrangian (L : ℝ) : ℝ :=
  hbar / (L * t_P)

/-! ## Positivity theorems -/

/-- Action density is positive when action and volume are. -/
theorem actionDensity_pos {S V : ℝ} (hS : 0 < S) (hV : 0 < V) :
    0 < actionDensity S V := by
  unfold actionDensity
  exact div_pos hS hV

/-- Action density is nonneg when action is nonneg and volume positive. -/
theorem actionDensity_nonneg {S V : ℝ} (hS : 0 ≤ S) (hV : 0 < V) :
    0 ≤ actionDensity S V := by
  unfold actionDensity
  exact div_nonneg hS hV.le

/-- Thermal action density is positive for positive N, T, V. -/
theorem thermalActionDensity_pos {N T V : ℝ}
    (hN : 0 < N) (hT : 0 < T) (hV : 0 < V) :
    0 < thermalActionDensity N T V := by
  unfold thermalActionDensity
  exact div_pos (mul_pos (mul_pos hN k_B_pos) hT) hV

/-- Emergent time is positive when action increment and Lagrangian are. -/
theorem emergentTime_pos {dS L : ℝ} (hdS : 0 < dS) (hL : 0 < L) :
    0 < emergentTime dS L := by
  unfold emergentTime
  exact div_pos hdS hL

/-- The iteration budget from a positive Lagrangian is positive. -/
theorem iterationBudget_pos {L : ℝ} (hL : 0 < L) :
    0 < iterationBudgetFromLagrangian L := by
  unfold iterationBudgetFromLagrangian
  exact div_pos hbar_pos (mul_pos hL t_P_pos)

/-! ## Dimensional consistency check

The raw action density of `S = N·k_B·T` must coincide with the
thermodynamic form. This is a pure definitional equation but is
worth exposing as a theorem so downstream consumers can rewrite. -/

/-- Consistency: `actionDensity (N·k_B·T) V = thermalActionDensity N T V`.
    Confirms Def 2.1 and Def 2.2 refer to the same object when
    action is supplied via equipartition. -/
theorem action_density_dim_check (N T V : ℝ) :
    actionDensity (N * k_B * T) V = thermalActionDensity N T V := by
  unfold actionDensity thermalActionDensity
  rfl

end OmegaTheory.Irrationality
