/-
  OmegaTheory.Predictions.T1_SubstrateMassPositivity

  T-1 (light quark masses) — Phase 1 sub session 182.
  Substrate mass positivity per quark.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Six per-quark positivity theorems combining:
    - `yukawaUpQuark_pos` / `yukawaDownQuark_pos` (s178 family)
    - `higgs_vev_pos` (Phaeton cycle)

  giving `0 < fermionMass (yukawa quark gen) N` for every quark.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Predictions.T1_SubstrateMassValues

namespace OmegaTheory.Predictions.T1_SubstrateMassPositivity

open OmegaTheory.Emergence.YukawaMatrix
open OmegaTheory.Emergence.HiggsFromError
open OmegaTheory.Predictions.T1_SubstrateMassValues

/-! ## Up-type substrate mass positivity -/

/-- **Wave T1 session 182 — `0 < m_u(N)`**. -/
theorem T1_m_u_substrate_pos (N : ℕ) :
    0 < fermionMass (yukawaUpQuark 0) N := by
  rw [T1_m_u_substrate_eq]; exact higgs_vev_pos N

/-- **Wave T1 session 182 — `0 < m_c(N)`**. -/
theorem T1_m_c_substrate_pos (N : ℕ) :
    0 < fermionMass (yukawaUpQuark 1) N := by
  rw [T1_m_c_substrate_eq]
  have := higgs_vev_pos N
  linarith

/-- **Wave T1 session 182 — `0 < m_t(N)`**. -/
theorem T1_m_t_substrate_pos (N : ℕ) :
    0 < fermionMass (yukawaUpQuark 2) N := by
  rw [T1_m_t_substrate_eq]
  have := higgs_vev_pos N
  linarith

/-! ## Down-type substrate mass positivity -/

/-- **Wave T1 session 182 — `0 < m_d(N)`**. -/
theorem T1_m_d_substrate_pos (N : ℕ) :
    0 < fermionMass (yukawaDownQuark 0) N := by
  rw [T1_m_d_substrate_eq]; exact higgs_vev_pos N

/-- **Wave T1 session 182 — `0 < m_s(N)`**. -/
theorem T1_m_s_substrate_pos (N : ℕ) :
    0 < fermionMass (yukawaDownQuark 1) N := by
  rw [T1_m_s_substrate_eq]
  have := higgs_vev_pos N
  linarith

/-- **Wave T1 session 182 — `0 < m_b(N)`**. -/
theorem T1_m_b_substrate_pos (N : ℕ) :
    0 < fermionMass (yukawaDownQuark 2) N := by
  rw [T1_m_b_substrate_eq]
  have := higgs_vev_pos N
  linarith

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 182 — substrate mass positivity (all 6 quarks)**.

    For any substrate truncation N, all six quarks have positive
    substrate-derived mass:

      0 < m_u(N), m_c(N), m_t(N) (up-type)
      0 < m_d(N), m_s(N), m_b(N) (down-type)

    Sub-lemma 6/N in T-1.  Lean-core only. -/
theorem session_182_substrate_mass_positivity_headline :
    ∀ (N : ℕ),
      0 < fermionMass (yukawaUpQuark 0) N
      ∧ 0 < fermionMass (yukawaUpQuark 1) N
      ∧ 0 < fermionMass (yukawaUpQuark 2) N
      ∧ 0 < fermionMass (yukawaDownQuark 0) N
      ∧ 0 < fermionMass (yukawaDownQuark 1) N
      ∧ 0 < fermionMass (yukawaDownQuark 2) N :=
  fun N => ⟨T1_m_u_substrate_pos N, T1_m_c_substrate_pos N, T1_m_t_substrate_pos N,
            T1_m_d_substrate_pos N, T1_m_s_substrate_pos N, T1_m_b_substrate_pos N⟩

end OmegaTheory.Predictions.T1_SubstrateMassPositivity
