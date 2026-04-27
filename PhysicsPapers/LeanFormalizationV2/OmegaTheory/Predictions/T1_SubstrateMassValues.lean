/-
  OmegaTheory.Predictions.T1_SubstrateMassValues

  T-1 (light quark masses) — Phase 1 sub session 181.
  Substrate-derived mass values per quark generation.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Closed form for `fermionMass (yukawaUpQuark gen) N` at each generation:

      m_u(N) = 1 · higgs_vev N
      m_c(N) = 3 · higgs_vev N
      m_t(N) = 9 · higgs_vev N

  Down-type analogues:

      m_d(N) = 1 · higgs_vev N
      m_s(N) = 2 · higgs_vev N
      m_b(N) = 5 · higgs_vev N

  These are SUBSTRATE Yukawa × VEV — the bare values before
  calibration to PDG energy scale.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Predictions.T1_YukawaQuarkValues

namespace OmegaTheory.Predictions.T1_SubstrateMassValues

open OmegaTheory.Emergence.YukawaMatrix
open OmegaTheory.Emergence.HiggsFromError
open OmegaTheory.Predictions.T1_YukawaQuarkValues

/-! ## Up-type substrate masses -/

/-- **Wave T1 session 181 — `m_u(N) = 1 · higgs_vev N = higgs_vev N`**. -/
theorem T1_m_u_substrate_eq (N : ℕ) :
    fermionMass (yukawaUpQuark 0) N = higgs_vev N := by
  unfold fermionMass
  rw [T1_yukawaUpQuark_gen0]
  ring

/-- **Wave T1 session 181 — `m_c(N) = 3 · higgs_vev N`**. -/
theorem T1_m_c_substrate_eq (N : ℕ) :
    fermionMass (yukawaUpQuark 1) N = 3 * higgs_vev N := by
  unfold fermionMass
  rw [T1_yukawaUpQuark_gen1]

/-- **Wave T1 session 181 — `m_t(N) = 9 · higgs_vev N`**. -/
theorem T1_m_t_substrate_eq (N : ℕ) :
    fermionMass (yukawaUpQuark 2) N = 9 * higgs_vev N := by
  unfold fermionMass
  rw [T1_yukawaUpQuark_gen2]

/-! ## Down-type substrate masses -/

/-- **Wave T1 session 181 — `m_d(N) = 1 · higgs_vev N = higgs_vev N`**. -/
theorem T1_m_d_substrate_eq (N : ℕ) :
    fermionMass (yukawaDownQuark 0) N = higgs_vev N := by
  unfold fermionMass
  rw [T1_yukawaDownQuark_gen0]
  ring

/-- **Wave T1 session 181 — `m_s(N) = 2 · higgs_vev N`**. -/
theorem T1_m_s_substrate_eq (N : ℕ) :
    fermionMass (yukawaDownQuark 1) N = 2 * higgs_vev N := by
  unfold fermionMass
  rw [T1_yukawaDownQuark_gen1]

/-- **Wave T1 session 181 — `m_b(N) = 5 · higgs_vev N`**. -/
theorem T1_m_b_substrate_eq (N : ℕ) :
    fermionMass (yukawaDownQuark 2) N = 5 * higgs_vev N := by
  unfold fermionMass
  rw [T1_yukawaDownQuark_gen2]

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 181 — substrate-derived mass values**.

    Six closed-form substrate masses (as multiples of higgs_vev N):
    - up-type: m_u = 1·v, m_c = 3·v, m_t = 9·v
    - down-type: m_d = 1·v, m_s = 2·v, m_b = 5·v

    These are the BARE Yukawa × VEV values. Mass calibration to
    PDG energy scale (T-1 Phase 2) requires QCD running for the
    light quarks (u, d, s) from MS-bar μ=2 GeV reference.

    Sub-lemma 5/N in T-1.  Lean-core only. -/
theorem session_181_substrate_mass_values_headline :
    -- (1) up-type
    (∀ (N : ℕ), fermionMass (yukawaUpQuark 0) N = higgs_vev N
      ∧ fermionMass (yukawaUpQuark 1) N = 3 * higgs_vev N
      ∧ fermionMass (yukawaUpQuark 2) N = 9 * higgs_vev N)
    -- (2) down-type
    ∧ (∀ (N : ℕ), fermionMass (yukawaDownQuark 0) N = higgs_vev N
      ∧ fermionMass (yukawaDownQuark 1) N = 2 * higgs_vev N
      ∧ fermionMass (yukawaDownQuark 2) N = 5 * higgs_vev N) :=
  ⟨fun N => ⟨T1_m_u_substrate_eq N, T1_m_c_substrate_eq N, T1_m_t_substrate_eq N⟩,
   fun N => ⟨T1_m_d_substrate_eq N, T1_m_s_substrate_eq N, T1_m_b_substrate_eq N⟩⟩

end OmegaTheory.Predictions.T1_SubstrateMassValues
