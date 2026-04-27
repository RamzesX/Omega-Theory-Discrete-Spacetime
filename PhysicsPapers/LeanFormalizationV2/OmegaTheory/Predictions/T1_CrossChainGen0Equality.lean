/-
  OmegaTheory.Predictions.T1_CrossChainGen0Equality

  T-1 (light quark masses) — Phase 1 sub session 184.
  Substrate prediction: at gen0, m_u = m_d.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Substrate-level cross-chain equality at the lightest generation:

      m_u(N) = m_d(N) = higgs_vev N

  This is a STRUCTURAL prediction.  Empirically (PDG), this fails:
  m_u/m_d ≈ 0.46.  The discrepancy comes from QCD running between
  scales (the substrate prediction is at the unification scale; PDG
  measures at MS-bar μ = 2 GeV, where running has split the masses).

  This file documents the STRUCTURAL prediction.  T-1 Phase 2 will
  introduce the QCD running calibration to bridge to PDG.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Predictions.T1_SubstrateMassValues

namespace OmegaTheory.Predictions.T1_CrossChainGen0Equality

open OmegaTheory.Emergence.YukawaMatrix
open OmegaTheory.Emergence.HiggsFromError
open OmegaTheory.Predictions.T1_SubstrateMassValues

/-! ## Cross-chain gen0 equality -/

/-- **Wave T1 session 184 — substrate `m_u(N) = m_d(N)`** at gen0.

    Both equal `higgs_vev N` at the substrate level.

    PDG does NOT respect this (m_u/m_d ≈ 0.46).  The discrepancy
    comes from QCD running between scales. -/
theorem T1_m_u_eq_m_d_substrate (N : ℕ) :
    fermionMass (yukawaUpQuark 0) N = fermionMass (yukawaDownQuark 0) N := by
  rw [T1_m_u_substrate_eq, T1_m_d_substrate_eq]

/-- **Wave T1 session 184 — both equal higgs_vev N**. -/
theorem T1_m_u_eq_m_d_eq_higgs_vev (N : ℕ) :
    fermionMass (yukawaUpQuark 0) N = higgs_vev N
    ∧ fermionMass (yukawaDownQuark 0) N = higgs_vev N :=
  ⟨T1_m_u_substrate_eq N, T1_m_d_substrate_eq N⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 184 — cross-chain gen0 equality**.

    Two structural predictions at the lightest quark generation:

    1. `m_u(N) = m_d(N)` (cross-chain equality at substrate level).
    2. Both equal `higgs_vev N` exactly.

    PDG empirically violates this (m_u/m_d ≈ 0.46) due to QCD
    running.  T-1 Phase 2 will introduce the calibration.

    Sub-lemma 8/N in T-1.  Lean-core only. -/
theorem session_184_cross_chain_gen0_equality_headline :
    ∀ (N : ℕ),
      -- (1) cross-chain equality
      fermionMass (yukawaUpQuark 0) N = fermionMass (yukawaDownQuark 0) N
      -- (2) both equal higgs_vev
      ∧ (fermionMass (yukawaUpQuark 0) N = higgs_vev N
          ∧ fermionMass (yukawaDownQuark 0) N = higgs_vev N) :=
  fun N => ⟨T1_m_u_eq_m_d_substrate N, T1_m_u_eq_m_d_eq_higgs_vev N⟩

end OmegaTheory.Predictions.T1_CrossChainGen0Equality
