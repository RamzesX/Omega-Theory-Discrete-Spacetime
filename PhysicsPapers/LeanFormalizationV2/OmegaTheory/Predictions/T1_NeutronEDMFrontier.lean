/-
  OmegaTheory.Predictions.T1_NeutronEDMFrontier

  T-1 (light quark masses) — FRONTIER, sub session 250.
  Neutron Electric Dipole Moment (EDM) bound (PSI 2020).

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  PSI 2020 nEDM upper bound (improved by ~3× over previous):
  - |d_n| < 1.8 × 10^(-26) e·cm (90% CL)

  This bound is what gives |θ̄_QCD| < 10^(-10) (s242).

  Plus structural facts.

  Future experiments (PIENU, n2EDM at PSI) aim for 10× better.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_NeutronEDMFrontier

/-! ## Anchor (in e·cm) -/

/-- **|d_n| upper bound PSI 2020**: `1.8 × 10^(-26) e·cm`. -/
noncomputable def d_n_upper_PDG : ℝ := 18 / 1000000000000000000000000000

/-! ## Positivity -/

/-- **Wave T1 session 250 — `|d_n| upper bound > 0`**. -/
theorem T1_d_n_upper_PDG_pos : 0 < d_n_upper_PDG := by
  unfold d_n_upper_PDG; norm_num

/-! ## Smallness -/

/-- **🚨 FRONTIER — Wave T1 session 250 — `|d_n| < 10^(-25)`**. -/
theorem T1_d_n_upper_lt_1e_neg_25 :
    d_n_upper_PDG < 1 / 10000000000000000000000000 := by
  unfold d_n_upper_PDG; norm_num

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 250 — neutron EDM frontier**.

    🚨 FRONTIER (best CP-violation constraint) 🚨

    Two foundational facts:
    1. `|d_n| < 1.8 × 10^(-26) e·cm > 0` (PSI 2020).
    2. `|d_n| < 10^(-25) e·cm`.

    nEDM bound is the most stringent constraint on CP-violation in
    QCD. It's what limits θ̄_QCD < 10^(-10) (strong CP problem).
    Future PSI n2EDM aims for 10× tighter bound.

    Sub-lemma 75/N in T-1.  Lean-core only.

    🏆 75 T-1 sub-lemmas LANDED. -/
theorem session_250_nEDM_frontier_headline :
    0 < d_n_upper_PDG
    ∧ d_n_upper_PDG < 1 / 10000000000000000000000000 :=
  ⟨T1_d_n_upper_PDG_pos, T1_d_n_upper_lt_1e_neg_25⟩

end OmegaTheory.Predictions.T1_NeutronEDMFrontier
