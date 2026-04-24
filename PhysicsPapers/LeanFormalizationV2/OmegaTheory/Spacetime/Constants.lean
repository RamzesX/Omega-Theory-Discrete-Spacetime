/-
  OmegaTheory.Spacetime.Constants

  Physical constants and their relationships.

  Each fundamental constant (c, ℏ, G_N, k_B) is introduced as a
  `noncomputable opaque` bundle `{x : ℝ // 0 < x}` rather than as a pair
  of axioms.  The opaque construction relies on `Classical.choice` (a
  Lean core axiom), so **no new user-level axioms are introduced** by
  these constants.

  Historical note (cycle-44, Lesath 2026-04-24): this file previously
  declared 8 physical axioms (c, c_pos, hbar, hbar_pos, G_N, G_N_pos,
  k_B, k_B_pos), following the "opaque bundle" pattern Acrab applied to
  six HermitePadé conjectures in Wave C.  Downstream code relies only
  on the positivity theorems (`c_pos`, etc.), not on definitional
  unfolding of the values, so the refactor is behaviourally transparent.

  Everything else in the theory is derived.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Data.Real.Sqrt
import Mathlib.Tactic

namespace OmegaTheory.Spacetime

-- ============================================================
-- Fundamental constants (independent)
-- ============================================================

/-- Speed of light c > 0 (bundled as a positive real via opaque to reduce axiom count).

    The opaque declaration relies on `Classical.choice` (a Lean core axiom), not on a
    user-introduced axiom.  The witness value `1` is arbitrary — downstream code only
    uses `c_pos` and never unfolds `c` definitionally. -/
noncomputable opaque c_bundle : {x : ℝ // 0 < x} := ⟨1, one_pos⟩
noncomputable abbrev c : ℝ := c_bundle.val
theorem c_pos : 0 < c := c_bundle.property

/-- Reduced Planck constant ℏ > 0 (bundled — see `c_bundle` rationale). -/
noncomputable opaque hbar_bundle : {x : ℝ // 0 < x} := ⟨1, one_pos⟩
noncomputable abbrev hbar : ℝ := hbar_bundle.val
theorem hbar_pos : 0 < hbar := hbar_bundle.property

/-- Gravitational constant G > 0 (bundled — see `c_bundle` rationale). -/
noncomputable opaque G_N_bundle : {x : ℝ // 0 < x} := ⟨1, one_pos⟩
noncomputable abbrev G_N : ℝ := G_N_bundle.val
theorem G_N_pos : 0 < G_N := G_N_bundle.property

/-- Boltzmann constant k_B > 0 (bundled — see `c_bundle` rationale). -/
noncomputable opaque k_B_bundle : {x : ℝ // 0 < x} := ⟨1, one_pos⟩
noncomputable abbrev k_B : ℝ := k_B_bundle.val
theorem k_B_pos : 0 < k_B := k_B_bundle.property

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
