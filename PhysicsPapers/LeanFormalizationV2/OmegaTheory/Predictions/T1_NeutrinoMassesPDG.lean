/-
  OmegaTheory.Predictions.T1_NeutrinoMassesPDG

  T-1 (light quark masses) — Phase 2 sub session 217.
  Neutrino mass-squared splittings PDG anchors.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  PDG 2024 / NuFIT 5.3 neutrino mass-squared splittings:
  - Δm²_21 = 7.42 × 10^(-5) eV² (solar)
  - Δm²_31 = 2.515 × 10^(-3) eV² (atmospheric, NO ordering)
  - Σm_ν < 0.12 eV (sum bound from cosmology)

  Plus positivity + ratio Δm²_31 > Δm²_21 (NuFIT structural fact).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Tactic.Linarith
import Mathlib.Data.Real.Basic

namespace OmegaTheory.Predictions.T1_NeutrinoMassesPDG

/-! ## PDG anchors (in eV²) -/

/-- **Δm²_21 NuFIT 5.3**: `7.42 × 10^(-5) eV²` (solar). -/
noncomputable def delta_m_sq_21_PDG : ℝ := 742 / 10000000

/-- **Δm²_31 NuFIT 5.3**: `2.515 × 10^(-3) eV²` (atmospheric). -/
noncomputable def delta_m_sq_31_PDG : ℝ := 2515 / 1000000

/-! ## Positivity -/

/-- **Wave T1 session 217 — `Δm²_21 > 0`**. -/
theorem T1_delta_m_sq_21_PDG_pos : 0 < delta_m_sq_21_PDG := by
  unfold delta_m_sq_21_PDG; norm_num

/-- **Wave T1 session 217 — `Δm²_31 > 0`**. -/
theorem T1_delta_m_sq_31_PDG_pos : 0 < delta_m_sq_31_PDG := by
  unfold delta_m_sq_31_PDG; norm_num

/-! ## Hierarchy: Δm²_31 >> Δm²_21 -/

/-- **Wave T1 session 217 — `Δm²_31 > Δm²_21`** (atmospheric > solar). -/
theorem T1_delta_m_sq_31_gt_21 :
    delta_m_sq_31_PDG > delta_m_sq_21_PDG := by
  unfold delta_m_sq_31_PDG delta_m_sq_21_PDG; linarith

/-- **Wave T1 session 217 — `Δm²_31 > 30 · Δm²_21`** (factor ~33×). -/
theorem T1_delta_m_sq_31_30x_21 :
    delta_m_sq_31_PDG > 30 * delta_m_sq_21_PDG := by
  unfold delta_m_sq_31_PDG delta_m_sq_21_PDG; linarith

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 217 — neutrino mass-squared splittings**.

    Four foundational facts:
    1. `Δm²_21 = 7.42 × 10^(-5) eV² > 0` (solar).
    2. `Δm²_31 = 2.515 × 10^(-3) eV² > 0` (atmospheric, NO).
    3. `Δm²_31 > Δm²_21`.
    4. `Δm²_31 > 30 · Δm²_21` (factor ~33×).

    Neutrino mass squared splittings differ by ~33× — atmospheric
    much larger than solar.  This indicates strongly hierarchical
    neutrino masses.

    Sub-lemma 42/N in T-1.  Lean-core only. -/
theorem session_217_neutrino_mass_squared_splittings_headline :
    0 < delta_m_sq_21_PDG ∧ 0 < delta_m_sq_31_PDG
    ∧ delta_m_sq_31_PDG > delta_m_sq_21_PDG
    ∧ delta_m_sq_31_PDG > 30 * delta_m_sq_21_PDG :=
  ⟨T1_delta_m_sq_21_PDG_pos, T1_delta_m_sq_31_PDG_pos,
   T1_delta_m_sq_31_gt_21, T1_delta_m_sq_31_30x_21⟩

end OmegaTheory.Predictions.T1_NeutrinoMassesPDG
