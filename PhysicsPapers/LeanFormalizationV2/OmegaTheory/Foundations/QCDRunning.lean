/-
  OmegaTheory.Foundations.QCDRunning

  T-1 (light quark masses) — Phase 1 entry, session 176.
  3-loop QCD β-function coefficients.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Foundation for QCD running: the β-function coefficients β_0, β_1
  controlling renormalization-group flow of α_s and m_q.

  Definitions:
  1. **`beta_0`** : 1-loop β coefficient, `(33 - 2 n_f) / 12`.
  2. **`beta_1`** : 2-loop β coefficient, `(153 - 19 n_f) / 24`.

  Plus positivity proofs for n_f ∈ {3, 4, 5, 6} (the active flavours
  at the relevant scales for light-quark mass running).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Ring
import Mathlib.Tactic.NormNum

namespace OmegaTheory.Foundations.QCDRunning

/-! ## β-function coefficients -/

/-- **1-loop QCD β-function coefficient** at n_f active flavours.

    `β_0 = (33 - 2·n_f) / 12`. -/
noncomputable def beta_0 (n_f : ℕ) : ℝ := (33 - 2 * (n_f : ℝ)) / 12

/-- **2-loop QCD β-function coefficient** at n_f active flavours.

    `β_1 = (153 - 19·n_f) / 24`. -/
noncomputable def beta_1 (n_f : ℕ) : ℝ := (153 - 19 * (n_f : ℝ)) / 24

/-! ## Positivity at standard active-flavour counts -/

/-- **Wave T1 session 176 — `β_0(3) = 27/12 = 9/4 > 0`** (light quarks). -/
theorem T1_beta_0_pos_3 : 0 < beta_0 3 := by
  have h : beta_0 3 = 27 / 12 := by unfold beta_0; push_cast; ring
  rw [h]; norm_num

/-- **Wave T1 session 176 — `β_0(4) = 25/12 > 0`** (charm threshold). -/
theorem T1_beta_0_pos_4 : 0 < beta_0 4 := by
  have h : beta_0 4 = 25 / 12 := by unfold beta_0; push_cast; ring
  rw [h]; norm_num

/-- **Wave T1 session 176 — `β_0(5) = 23/12 > 0`** (bottom threshold). -/
theorem T1_beta_0_pos_5 : 0 < beta_0 5 := by
  have h : beta_0 5 = 23 / 12 := by unfold beta_0; push_cast; ring
  rw [h]; norm_num

/-- **Wave T1 session 176 — `β_0(6) = 21/12 = 7/4 > 0`** (top threshold). -/
theorem T1_beta_0_pos_6 : 0 < beta_0 6 := by
  have h : beta_0 6 = 21 / 12 := by unfold beta_0; push_cast; ring
  rw [h]; norm_num

/-- **Wave T1 session 176 — `β_1(3) = 96/24 = 4 > 0`**. -/
theorem T1_beta_1_pos_3 : 0 < beta_1 3 := by
  have h : beta_1 3 = 96 / 24 := by unfold beta_1; push_cast; ring
  rw [h]; norm_num

/-- **Wave T1 session 176 — `β_1(4) = 77/24 > 0`**. -/
theorem T1_beta_1_pos_4 : 0 < beta_1 4 := by
  have h : beta_1 4 = 77 / 24 := by unfold beta_1; push_cast; ring
  rw [h]; norm_num

/-- **Wave T1 session 176 — `β_1(5) = 58/24 > 0`**. -/
theorem T1_beta_1_pos_5 : 0 < beta_1 5 := by
  have h : beta_1 5 = 58 / 24 := by unfold beta_1; push_cast; ring
  rw [h]; norm_num

/-- **Wave T1 session 176 — `β_1(6) = 39/24 > 0`**. -/
theorem T1_beta_1_pos_6 : 0 < beta_1 6 := by
  have h : beta_1 6 = 39 / 24 := by unfold beta_1; push_cast; ring
  rw [h]; norm_num

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 176 — QCD β-function positivity**.

    All β_0 and β_1 coefficients are positive at the standard
    active-flavour counts {3, 4, 5, 6}.

    This is the input for asymptotic freedom: positive β-function
    coefficients give running α_s decreasing with energy.

    Sub-lemma 1/N in T-1 Phase 1 (light quark masses).  Lean-core only. -/
theorem session_176_qcd_beta_positivity_headline :
    -- β_0 positive at n_f ∈ {3,4,5,6}
    (0 < beta_0 3 ∧ 0 < beta_0 4 ∧ 0 < beta_0 5 ∧ 0 < beta_0 6)
    -- β_1 positive at n_f ∈ {3,4,5,6}
    ∧ (0 < beta_1 3 ∧ 0 < beta_1 4 ∧ 0 < beta_1 5 ∧ 0 < beta_1 6) :=
  ⟨⟨T1_beta_0_pos_3, T1_beta_0_pos_4, T1_beta_0_pos_5, T1_beta_0_pos_6⟩,
   ⟨T1_beta_1_pos_3, T1_beta_1_pos_4, T1_beta_1_pos_5, T1_beta_1_pos_6⟩⟩

end OmegaTheory.Foundations.QCDRunning
