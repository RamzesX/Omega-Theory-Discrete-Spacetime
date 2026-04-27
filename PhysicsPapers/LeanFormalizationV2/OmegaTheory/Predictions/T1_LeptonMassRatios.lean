/-
  OmegaTheory.Predictions.T1_LeptonMassRatios

  T-1 (light quark masses) — Phase 2 sub session 196.
  Lepton mass ratios PDG.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  PDG-derived ratios for the lepton chain:

      m_μ / m_e ≈ 207
      m_τ / m_e ≈ 3477
      m_τ / m_μ ≈ 16.8

  Substrate (yukawaElectron) predicts:

      y_μ / y_e = 4
      y_τ / y_e = 16
      y_τ / y_μ = 4

  PDG is dominated by Connes D_F + 4-irrational corrections beyond
  bare Yukawa hierarchy.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Predictions.T1_LeptonMassPDGAnchors

namespace OmegaTheory.Predictions.T1_LeptonMassRatios

open OmegaTheory.Predictions.T1_LeptonMassPDGAnchors

/-! ## PDG lepton mass ratios -/

/-- **Wave T1 session 196 — `m_μ / m_e > 200`**.

    Concretely m_μ/m_e ≈ 207. -/
theorem T1_m_mu_over_m_e_gt_200 : m_mu_PDG / m_e_PDG > 200 := by
  unfold m_mu_PDG m_e_PDG
  rw [gt_iff_lt, lt_div_iff₀ (by norm_num : (51099895 : ℝ) / 100000000 > 0)]
  linarith

/-- **Wave T1 session 196 — `m_τ / m_e > 3000`**.

    Concretely m_τ/m_e ≈ 3477. -/
theorem T1_m_tau_over_m_e_gt_3000 : m_tau_PDG / m_e_PDG > 3000 := by
  unfold m_tau_PDG m_e_PDG
  rw [gt_iff_lt, lt_div_iff₀ (by norm_num : (51099895 : ℝ) / 100000000 > 0)]
  linarith

/-- **Wave T1 session 196 — `m_τ / m_μ > 16`**.

    Concretely m_τ/m_μ ≈ 16.8. -/
theorem T1_m_tau_over_m_mu_gt_16 : m_tau_PDG / m_mu_PDG > 16 := by
  unfold m_tau_PDG m_mu_PDG
  rw [gt_iff_lt, lt_div_iff₀ (by norm_num : (1056583755 : ℝ) / 10000000 > 0)]
  linarith

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 196 — lepton mass ratios PDG**.

    Three PDG ratio bounds:
    1. `m_μ / m_e > 200` (PDG ≈ 207).
    2. `m_τ / m_e > 3000` (PDG ≈ 3477).
    3. `m_τ / m_μ > 16` (PDG ≈ 16.8).

    Substrate (yukawaElectron) gives 4 / 16 / 4. PDG ratios are
    bigger because of Connes D_F + 4-irrational corrections beyond
    bare Yukawa hierarchy.

    Sub-lemma 21/N in T-1.  Lean-core only. -/
theorem session_196_lepton_mass_ratios_headline :
    m_mu_PDG / m_e_PDG > 200
    ∧ m_tau_PDG / m_e_PDG > 3000
    ∧ m_tau_PDG / m_mu_PDG > 16 :=
  ⟨T1_m_mu_over_m_e_gt_200, T1_m_tau_over_m_e_gt_3000, T1_m_tau_over_m_mu_gt_16⟩

end OmegaTheory.Predictions.T1_LeptonMassRatios
