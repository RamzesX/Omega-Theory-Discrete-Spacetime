/-
  OmegaTheory.Predictions.T1_PionDecayConstantPDG

  T-1 (light quark masses) — Phase 2 sub session 223.
  Pion decay constant f_π PDG anchor.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  PDG 2024 pion decay constant:
  - f_π = 130.2 MeV (charged pion decay constant, ±1.7)
  - f_K = 155.7 MeV (kaon decay constant)

  Plus structural facts: f_K > f_π (strange-flavour enhancement).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_PionDecayConstantPDG

/-! ## PDG anchors -/

/-- **f_π PDG**: `130.2 MeV`. -/
noncomputable def f_pi_PDG : ℝ := 1302 / 10

/-- **f_K PDG**: `155.7 MeV`. -/
noncomputable def f_K_PDG : ℝ := 1557 / 10

/-! ## Positivity -/

/-- **Wave T1 session 223 — `f_π > 0`**. -/
theorem T1_f_pi_PDG_pos : 0 < f_pi_PDG := by
  unfold f_pi_PDG; norm_num

/-- **Wave T1 session 223 — `f_K > 0`**. -/
theorem T1_f_K_PDG_pos : 0 < f_K_PDG := by
  unfold f_K_PDG; norm_num

/-! ## Sanity bounds -/

/-- **Wave T1 session 223 — `f_K > f_π`** (kaon decay constant larger). -/
theorem T1_f_K_gt_f_pi : f_K_PDG > f_pi_PDG := by
  unfold f_K_PDG f_pi_PDG; linarith

/-- **Wave T1 session 223 — `f_π > 100`**. -/
theorem T1_f_pi_PDG_gt_100 : f_pi_PDG > 100 := by
  unfold f_pi_PDG; norm_num

/-- **Wave T1 session 223 — `f_K < 200`**. -/
theorem T1_f_K_PDG_lt_200 : f_K_PDG < 200 := by
  unfold f_K_PDG; norm_num

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 223 — pseudoscalar decay constants PDG**.

    Five foundational facts:
    1. `f_π = 130.2 MeV > 0`.
    2. `f_K = 155.7 MeV > 0`.
    3. `f_K > f_π` (strange enhancement).
    4. `f_π > 100`.
    5. `f_K < 200`.

    Pseudoscalar decay constants foundational for chiral perturbation
    theory + Gell-Mann–Oakes–Renner relation: m_π² · f_π² ∝ (m_u + m_d).

    Sub-lemma 48/N in T-1.  Lean-core only. -/
theorem session_223_decay_constants_PDG_headline :
    0 < f_pi_PDG ∧ 0 < f_K_PDG
    ∧ f_K_PDG > f_pi_PDG
    ∧ f_pi_PDG > 100 ∧ f_K_PDG < 200 :=
  ⟨T1_f_pi_PDG_pos, T1_f_K_PDG_pos, T1_f_K_gt_f_pi,
   T1_f_pi_PDG_gt_100, T1_f_K_PDG_lt_200⟩

end OmegaTheory.Predictions.T1_PionDecayConstantPDG
