/-
  OmegaTheory.Predictions.T1_DarkMatterDensityPDG

  T-1 (light quark masses) — Phase 2 sub session 233.
  Dark matter density Ω_DM PDG anchor.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  PDG 2024 / Planck 2018:
  - Ω_DM = 0.265 (cold dark matter density fraction)
  - Ω_b = 0.049 (baryon density fraction)
  - Ω_DM/Ω_b ≈ 5.4 (DM:baryon ratio)

  Plus structural facts.

  Foundational for OV2 sterile neutrino DM derivation
  (`SterileNeutrinoFromFourthIrrational.lean`).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Tactic.Linarith
import Mathlib.Data.Real.Basic
import OmegaTheory.Predictions.T1_DarkEnergyPDG

namespace OmegaTheory.Predictions.T1_DarkMatterDensityPDG

open OmegaTheory.Predictions.T1_DarkEnergyPDG

/-! ## PDG anchors -/

/-- **Ω_DM Planck 2018**: `0.265` (cold dark matter density). -/
noncomputable def Omega_DM_PDG : ℝ := 265 / 1000

/-- **Ω_b Planck 2018**: `0.0490` (baryon density). -/
noncomputable def Omega_b_PDG : ℝ := 49 / 1000

/-! ## Positivity -/

/-- **Wave T1 session 233 — `Ω_DM > 0`**. -/
theorem T1_Omega_DM_PDG_pos : 0 < Omega_DM_PDG := by
  unfold Omega_DM_PDG; norm_num

/-- **Wave T1 session 233 — `Ω_b > 0`**. -/
theorem T1_Omega_b_PDG_pos : 0 < Omega_b_PDG := by
  unfold Omega_b_PDG; norm_num

/-! ## Sanity bounds -/

/-- **Wave T1 session 233 — `Ω_DM > Ω_b`** (DM dominates baryons). -/
theorem T1_Omega_DM_gt_Omega_b : Omega_DM_PDG > Omega_b_PDG := by
  unfold Omega_DM_PDG Omega_b_PDG; linarith

/-- **Wave T1 session 233 — `Ω_DM < Ω_Λ`** (DE dominates DM). -/
theorem T1_Omega_DM_lt_Omega_Lambda :
    Omega_DM_PDG < Omega_Lambda_PDG := by
  unfold Omega_DM_PDG Omega_Lambda_PDG; linarith

/-- **Wave T1 session 233 — `Ω_DM > 5·Ω_b`** (DM is ~5× baryons). -/
theorem T1_Omega_DM_gt_5x_Omega_b :
    Omega_DM_PDG > 5 * Omega_b_PDG := by
  unfold Omega_DM_PDG Omega_b_PDG; linarith

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 233 — Dark matter density Ω_DM PDG**.

    Five foundational facts:
    1. `Ω_DM = 0.265 > 0`.
    2. `Ω_b = 0.0490 > 0`.
    3. `Ω_DM > Ω_b` (DM dominates baryons).
    4. `Ω_DM < Ω_Λ` (DE dominates DM).
    5. `Ω_DM > 5 · Ω_b` (DM ~5× baryons).

    Foundational for OV2 sterile neutrino DM derivation
    (4th irrational channel in OV2 substrate model).

    Sub-lemma 58/N in T-1.  Lean-core only. -/
theorem session_233_Omega_DM_PDG_anchor_headline :
    0 < Omega_DM_PDG ∧ 0 < Omega_b_PDG
    ∧ Omega_DM_PDG > Omega_b_PDG
    ∧ Omega_DM_PDG < Omega_Lambda_PDG
    ∧ Omega_DM_PDG > 5 * Omega_b_PDG :=
  ⟨T1_Omega_DM_PDG_pos, T1_Omega_b_PDG_pos,
   T1_Omega_DM_gt_Omega_b, T1_Omega_DM_lt_Omega_Lambda,
   T1_Omega_DM_gt_5x_Omega_b⟩

end OmegaTheory.Predictions.T1_DarkMatterDensityPDG
