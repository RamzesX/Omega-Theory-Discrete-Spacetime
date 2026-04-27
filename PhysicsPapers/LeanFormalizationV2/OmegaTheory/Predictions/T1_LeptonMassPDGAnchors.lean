/-
  OmegaTheory.Predictions.T1_LeptonMassPDGAnchors

  T-1 (light quark masses) — Phase 2 sub session 195.
  Lepton mass PDG anchors (e, μ, τ).

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  PDG 2024 lepton masses:
  - m_e = 0.5110 MeV (electron, ±0.0000031)
  - m_μ = 105.6584 MeV (muon, ±0.0000024)
  - m_τ = 1776.86 MeV (tau, ±0.12)

  Plus positivity + lepton hierarchy m_e < m_μ < m_τ.

  These anchor the substrate-derived Connes D_F lepton chain via
  yukawaElectron (1, 4, 16).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_LeptonMassPDGAnchors

/-! ## PDG anchors (in MeV) -/

/-- **m_e PDG**: `0.51099895 MeV` (electron). -/
noncomputable def m_e_PDG : ℝ := 51099895 / 100000000

/-- **m_μ PDG**: `105.6583755 MeV` (muon). -/
noncomputable def m_mu_PDG : ℝ := 1056583755 / 10000000

/-- **m_τ PDG**: `1776.86 MeV` (tau). -/
noncomputable def m_tau_PDG : ℝ := 177686 / 100

/-! ## Positivity -/

/-- **Wave T1 session 195 — `m_e > 0`**. -/
theorem T1_m_e_PDG_pos : 0 < m_e_PDG := by
  unfold m_e_PDG; norm_num

/-- **Wave T1 session 195 — `m_μ > 0`**. -/
theorem T1_m_mu_PDG_pos : 0 < m_mu_PDG := by
  unfold m_mu_PDG; norm_num

/-- **Wave T1 session 195 — `m_τ > 0`**. -/
theorem T1_m_tau_PDG_pos : 0 < m_tau_PDG := by
  unfold m_tau_PDG; norm_num

/-! ## Lepton hierarchy -/

/-- **Wave T1 session 195 — `m_e < m_μ`** (electron lighter than muon). -/
theorem T1_m_e_lt_m_mu : m_e_PDG < m_mu_PDG := by
  unfold m_e_PDG m_mu_PDG; linarith

/-- **Wave T1 session 195 — `m_μ < m_τ`** (muon lighter than tau). -/
theorem T1_m_mu_lt_m_tau : m_mu_PDG < m_tau_PDG := by
  unfold m_mu_PDG m_tau_PDG; linarith

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 195 — Lepton mass PDG anchors**.

    Five foundational facts:
    1. `m_e = 0.511 MeV > 0`.
    2. `m_μ = 105.66 MeV > 0`.
    3. `m_τ = 1776.86 MeV > 0`.
    4. `m_e < m_μ` (electron lighter than muon).
    5. `m_μ < m_τ` (muon lighter than tau).

    Lepton chain anchors for substrate yukawaElectron derivation.

    Sub-lemma 20/N in T-1.  Lean-core only.

    🏆 20 T-1 sub-lemmas LANDED. -/
theorem session_195_lepton_mass_PDG_anchors_headline :
    0 < m_e_PDG ∧ 0 < m_mu_PDG ∧ 0 < m_tau_PDG
    ∧ m_e_PDG < m_mu_PDG ∧ m_mu_PDG < m_tau_PDG :=
  ⟨T1_m_e_PDG_pos, T1_m_mu_PDG_pos, T1_m_tau_PDG_pos,
   T1_m_e_lt_m_mu, T1_m_mu_lt_m_tau⟩

end OmegaTheory.Predictions.T1_LeptonMassPDGAnchors
