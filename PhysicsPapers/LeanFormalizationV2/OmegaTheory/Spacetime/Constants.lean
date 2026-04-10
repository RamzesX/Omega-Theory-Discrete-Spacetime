/-
  OmegaTheory.Spacetime.Constants

  Physical constants and their relationships.
  All constants are axiomatized as positive reals with
  the known dimensional relationships between them.

  These are the only axioms in the system that assert existence
  of specific real numbers. Everything else is derived.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Data.Real.Sqrt
import Mathlib.Tactic

namespace OmegaTheory.Spacetime

-- ============================================================
-- Fundamental constants (independent)
-- ============================================================

/-- Speed of light c > 0. -/
axiom c : ℝ
axiom c_pos : 0 < c

/-- Reduced Planck constant ℏ > 0. -/
axiom hbar : ℝ
axiom hbar_pos : 0 < hbar

/-- Gravitational constant G > 0. -/
axiom G_N : ℝ
axiom G_N_pos : 0 < G_N

/-- Boltzmann constant k_B > 0. -/
axiom k_B : ℝ
axiom k_B_pos : 0 < k_B

-- ============================================================
-- Derived Planck units
-- ============================================================

/-- Planck length: l_P = √(ℏG/c³). -/
noncomputable def l_P : ℝ := Real.sqrt (hbar * G_N / c ^ 3)

/-- Planck time: t_P = l_P / c. -/
noncomputable def t_P : ℝ := l_P / c

/-- Planck energy: E_P = ℏ / t_P. -/
noncomputable def E_P : ℝ := hbar / t_P

/-- Planck mass: M_P = E_P / c². -/
noncomputable def M_P : ℝ := E_P / c ^ 2

/-- Planck density: ρ_P = M_P / l_P³. -/
noncomputable def rho_P : ℝ := M_P / l_P ^ 3

-- ============================================================
-- Positivity lemmas (all proven, no sorry)
-- ============================================================

theorem hbar_G_div_c3_pos : 0 < hbar * G_N / c ^ 3 :=
  div_pos (mul_pos hbar_pos G_N_pos) (pow_pos c_pos 3)

theorem l_P_pos : 0 < l_P :=
  Real.sqrt_pos_of_pos hbar_G_div_c3_pos

theorem t_P_pos : 0 < t_P :=
  div_pos l_P_pos c_pos

theorem E_P_pos : 0 < E_P :=
  div_pos hbar_pos t_P_pos

theorem M_P_pos : 0 < M_P :=
  div_pos E_P_pos (pow_pos c_pos 2)

-- ============================================================
-- Useful nonnegativity corollaries
-- ============================================================

theorem l_P_nonneg : 0 ≤ l_P := le_of_lt l_P_pos
theorem t_P_nonneg : 0 ≤ t_P := le_of_lt t_P_pos
theorem E_P_nonneg : 0 ≤ E_P := le_of_lt E_P_pos
theorem c_nonneg : 0 ≤ c := le_of_lt c_pos
theorem hbar_nonneg : 0 ≤ hbar := le_of_lt hbar_pos

-- ============================================================
-- Nonzero lemmas (for division)
-- ============================================================

theorem c_ne_zero : c ≠ 0 := ne_of_gt c_pos
theorem hbar_ne_zero : hbar ≠ 0 := ne_of_gt hbar_pos
theorem l_P_ne_zero : l_P ≠ 0 := ne_of_gt l_P_pos
theorem t_P_ne_zero : t_P ≠ 0 := ne_of_gt t_P_pos
theorem E_P_ne_zero : E_P ≠ 0 := ne_of_gt E_P_pos

end OmegaTheory.Spacetime
