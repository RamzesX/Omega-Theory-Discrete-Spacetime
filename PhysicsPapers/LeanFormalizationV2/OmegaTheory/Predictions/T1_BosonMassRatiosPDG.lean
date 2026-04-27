/-
  OmegaTheory.Predictions.T1_BosonMassRatiosPDG

  T-1 (light quark masses) — Phase 2 sub session 213.
  PDG boson mass ratio bounds.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Boson mass ratios from PDG anchors:

      M_Z / M_W ≈ 1.13 (PDG, electroweak unification ratio)
      M_H / M_W ≈ 1.56 (PDG)
      M_t / M_H ≈ 1.38 (PDG)
      M_W / M_H ≈ 0.64 (PDG)

  These ratios constrain electroweak unification.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Tactic.Linarith
import OmegaTheory.Predictions.T1_WZMassPDGAnchors
import OmegaTheory.Predictions.T1_HiggsMassPDGAnchor
import OmegaTheory.Predictions.T1_TopQuarkMassPDGAnchor

namespace OmegaTheory.Predictions.T1_BosonMassRatiosPDG

open OmegaTheory.Predictions.T1_WZMassPDGAnchors
open OmegaTheory.Predictions.T1_HiggsMassPDGAnchor
open OmegaTheory.Predictions.T1_TopQuarkMassPDGAnchor

/-! ## PDG boson mass ratios -/

/-- **Wave T1 session 213 — `M_Z / M_W > 1`** (Z heavier than W). -/
theorem T1_M_Z_over_M_W_gt_1 : M_Z_PDG / M_W_PDG > 1 := by
  unfold M_Z_PDG M_W_PDG
  rw [gt_iff_lt, lt_div_iff₀ (by norm_num : (80377 : ℝ) / 1000 > 0)]
  linarith

/-- **Wave T1 session 213 — `M_H / M_W > 1.5`** (PDG ≈ 1.56). -/
theorem T1_M_H_over_M_W_gt_15 : M_H_PDG / M_W_PDG > 1.5 := by
  unfold M_H_PDG M_W_PDG
  rw [gt_iff_lt, lt_div_iff₀ (by norm_num : (80377 : ℝ) / 1000 > 0)]
  linarith

/-- **Wave T1 session 213 — `m_t / M_H > 1`** (top heavier than Higgs). -/
theorem T1_m_t_over_M_H_gt_1 : m_t_PDG / M_H_PDG > 1 := by
  unfold m_t_PDG M_H_PDG
  rw [gt_iff_lt, lt_div_iff₀ (by norm_num : (12510 : ℝ) / 100 > 0)]
  linarith

/-- **Wave T1 session 213 — `M_H / M_Z > 1`** (Higgs heavier than Z). -/
theorem T1_M_H_over_M_Z_gt_1 : M_H_PDG / M_Z_PDG > 1 := by
  unfold M_H_PDG M_Z_PDG
  rw [gt_iff_lt, lt_div_iff₀ (by norm_num : (911876 : ℝ) / 10000 > 0)]
  linarith

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 213 — boson mass ratio PDG bounds**.

    Four foundational ratios:
    1. `M_Z / M_W > 1` (Z heavier than W).
    2. `M_H / M_W > 1.5` (Higgs much heavier than W).
    3. `m_t / M_H > 1` (top heavier than Higgs).
    4. `M_H / M_Z > 1` (Higgs heavier than Z).

    Combined with W < Z < H < m_t, the SM mass spectrum from gauge
    bosons up to top quark has structural ordering.

    Sub-lemma 38/N in T-1.  Lean-core only. -/
theorem session_213_boson_mass_ratios_PDG_headline :
    M_Z_PDG / M_W_PDG > 1
    ∧ M_H_PDG / M_W_PDG > 1.5
    ∧ m_t_PDG / M_H_PDG > 1
    ∧ M_H_PDG / M_Z_PDG > 1 :=
  ⟨T1_M_Z_over_M_W_gt_1, T1_M_H_over_M_W_gt_15,
   T1_m_t_over_M_H_gt_1, T1_M_H_over_M_Z_gt_1⟩

end OmegaTheory.Predictions.T1_BosonMassRatiosPDG
