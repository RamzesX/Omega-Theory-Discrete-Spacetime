/-
  OmegaTheory.Predictions.T1_SubstrateMassHierarchy

  T-1 (light quark masses) — Phase 1 sub session 183.
  Substrate mass hierarchy m_q1 < m_q2 < m_q3 within each chain.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Substrate-predicted mass ordering at any truncation N:

      m_u(N) < m_c(N) < m_t(N)   (up-type)
      m_d(N) < m_s(N) < m_b(N)   (down-type)

  These follow from:
  - `T1_m_*_substrate_eq` (s181): closed forms `m_q = y_q · v`
  - `higgs_vev_pos` (Phaeton): `0 < v(N)`
  - Yukawa hierarchy `1 < 3 < 9` and `1 < 2 < 5`

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Predictions.T1_SubstrateMassValues

namespace OmegaTheory.Predictions.T1_SubstrateMassHierarchy

open OmegaTheory.Emergence.YukawaMatrix
open OmegaTheory.Emergence.HiggsFromError
open OmegaTheory.Predictions.T1_SubstrateMassValues

/-! ## Up-type substrate mass hierarchy -/

/-- **Wave T1 session 183 — `m_u(N) < m_c(N)`** (substrate). -/
theorem T1_m_u_lt_m_c_substrate (N : ℕ) :
    fermionMass (yukawaUpQuark 0) N < fermionMass (yukawaUpQuark 1) N := by
  rw [T1_m_u_substrate_eq, T1_m_c_substrate_eq]
  have hv := higgs_vev_pos N
  linarith

/-- **Wave T1 session 183 — `m_c(N) < m_t(N)`** (substrate). -/
theorem T1_m_c_lt_m_t_substrate (N : ℕ) :
    fermionMass (yukawaUpQuark 1) N < fermionMass (yukawaUpQuark 2) N := by
  rw [T1_m_c_substrate_eq, T1_m_t_substrate_eq]
  have hv := higgs_vev_pos N
  linarith

/-! ## Down-type substrate mass hierarchy -/

/-- **Wave T1 session 183 — `m_d(N) < m_s(N)`** (substrate). -/
theorem T1_m_d_lt_m_s_substrate (N : ℕ) :
    fermionMass (yukawaDownQuark 0) N < fermionMass (yukawaDownQuark 1) N := by
  rw [T1_m_d_substrate_eq, T1_m_s_substrate_eq]
  have hv := higgs_vev_pos N
  linarith

/-- **Wave T1 session 183 — `m_s(N) < m_b(N)`** (substrate). -/
theorem T1_m_s_lt_m_b_substrate (N : ℕ) :
    fermionMass (yukawaDownQuark 1) N < fermionMass (yukawaDownQuark 2) N := by
  rw [T1_m_s_substrate_eq, T1_m_b_substrate_eq]
  have hv := higgs_vev_pos N
  linarith

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 183 — substrate mass hierarchy**.

    Two structural orderings at any substrate truncation N:

    1. up-type:   m_u(N) < m_c(N) < m_t(N)
    2. down-type: m_d(N) < m_s(N) < m_b(N)

    Both follow from substrate Yukawa hierarchy (s178) +
    higgs_vev positivity.

    Sub-lemma 7/N in T-1.  Lean-core only. -/
theorem session_183_substrate_mass_hierarchy_headline :
    ∀ (N : ℕ),
      -- (1) up-type
      (fermionMass (yukawaUpQuark 0) N < fermionMass (yukawaUpQuark 1) N
        ∧ fermionMass (yukawaUpQuark 1) N < fermionMass (yukawaUpQuark 2) N)
      -- (2) down-type
      ∧ (fermionMass (yukawaDownQuark 0) N < fermionMass (yukawaDownQuark 1) N
        ∧ fermionMass (yukawaDownQuark 1) N < fermionMass (yukawaDownQuark 2) N) :=
  fun N => ⟨⟨T1_m_u_lt_m_c_substrate N, T1_m_c_lt_m_t_substrate N⟩,
            ⟨T1_m_d_lt_m_s_substrate N, T1_m_s_lt_m_b_substrate N⟩⟩

end OmegaTheory.Predictions.T1_SubstrateMassHierarchy
