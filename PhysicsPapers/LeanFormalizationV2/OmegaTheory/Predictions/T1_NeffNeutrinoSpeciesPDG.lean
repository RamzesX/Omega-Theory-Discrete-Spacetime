/-
  OmegaTheory.Predictions.T1_NeffNeutrinoSpeciesPDG

  T-1 (light quark masses) — Phase 2 sub session 231.
  N_eff effective relativistic species PDG anchor.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  PDG 2024 / Planck 2018:
  - N_eff = 2.99 ± 0.17 (effective relativistic species, BBN+CMB)

  Plus structural facts:
  - N_eff close to 3 (SM prediction: 3.046)
  - N_eff > 2 (excludes 2-flavour neutrinos)
  - N_eff < 4 (excludes extra light neutrino species)

  This bounds DM candidates: any LIGHT new physics must contribute
  to N_eff and is constrained.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_NeffNeutrinoSpeciesPDG

/-! ## PDG anchor -/

/-- **N_eff PDG/Planck 2018**: `2.99` (±0.17). -/
noncomputable def N_eff_PDG : ℝ := 299 / 100

/-! ## Positivity -/

/-- **Wave T1 session 231 — `N_eff > 0`**. -/
theorem T1_N_eff_PDG_pos : 0 < N_eff_PDG := by
  unfold N_eff_PDG; norm_num

/-! ## Sanity bounds -/

/-- **Wave T1 session 231 — `N_eff > 2`** (excludes 2-flavour). -/
theorem T1_N_eff_PDG_gt_2 : N_eff_PDG > 2 := by
  unfold N_eff_PDG; norm_num

/-- **Wave T1 session 231 — `N_eff < 4`** (excludes extra species). -/
theorem T1_N_eff_PDG_lt_4 : N_eff_PDG < 4 := by
  unfold N_eff_PDG; norm_num

/-- **Wave T1 session 231 — `N_eff > 2.5`** (closer to 3). -/
theorem T1_N_eff_PDG_gt_25 : N_eff_PDG > 2.5 := by
  unfold N_eff_PDG; norm_num

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 231 — N_eff PDG anchor**.

    Four foundational facts:
    1. `N_eff = 2.99 > 0`.
    2. `N_eff > 2` (3 active flavours, excludes 2-flavour scenarios).
    3. `N_eff < 4` (excludes light dark radiation/extra species).
    4. `N_eff > 2.5`.

    SM prediction: N_eff = 3.046. Observed: 2.99 ± 0.17 (Planck).
    Match within ~1σ. Constrains light new physics that would couple
    via thermal radiation.

    Sub-lemma 56/N in T-1.  Lean-core only. -/
theorem session_231_N_eff_PDG_anchor_headline :
    0 < N_eff_PDG
    ∧ N_eff_PDG > 2 ∧ N_eff_PDG < 4 ∧ N_eff_PDG > 2.5 :=
  ⟨T1_N_eff_PDG_pos, T1_N_eff_PDG_gt_2, T1_N_eff_PDG_lt_4,
   T1_N_eff_PDG_gt_25⟩

end OmegaTheory.Predictions.T1_NeffNeutrinoSpeciesPDG
