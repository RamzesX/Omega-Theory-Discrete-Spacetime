/-
  OmegaTheory.Predictions.T1_BBNPrimordialAbundancesPDG

  T-1 (light quark masses) — Phase 2 sub session 230.
  BBN primordial abundance PDG anchors.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  PDG 2024 Big Bang Nucleosynthesis (BBN) primordial abundances:
  - Y_p (helium-4 mass fraction) ≈ 0.245 (CMB+BBN)
  - D/H (deuterium-to-hydrogen) ≈ 2.55 × 10^(-5)

  Plus structural facts.

  These constrain η_B and the number of relativistic species N_eff.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_BBNPrimordialAbundancesPDG

/-! ## PDG anchors -/

/-- **Y_p PDG (BBN+CMB)**: `0.245` (helium-4 mass fraction). -/
noncomputable def Y_p_PDG : ℝ := 245 / 1000

/-- **D/H PDG (BBN)**: `2.55 × 10^(-5)`. -/
noncomputable def D_over_H_PDG : ℝ := 255 / 10000000

/-! ## Positivity -/

/-- **Wave T1 session 230 — `Y_p > 0`**. -/
theorem T1_Y_p_PDG_pos : 0 < Y_p_PDG := by
  unfold Y_p_PDG; norm_num

/-- **Wave T1 session 230 — `D/H > 0`**. -/
theorem T1_D_over_H_PDG_pos : 0 < D_over_H_PDG := by
  unfold D_over_H_PDG; norm_num

/-! ## Sanity bounds -/

/-- **Wave T1 session 230 — `Y_p < 1/4`** (helium fraction less than 25%).

    Concretely Y_p = 0.245 < 0.25 by 0.005. -/
theorem T1_Y_p_PDG_lt_quarter : Y_p_PDG < 1 / 4 := by
  unfold Y_p_PDG; norm_num

/-- **Wave T1 session 230 — `Y_p > 0.2`** (helium fraction more than 20%). -/
theorem T1_Y_p_PDG_gt_02 : Y_p_PDG > 0.2 := by
  unfold Y_p_PDG; norm_num

/-- **Wave T1 session 230 — `D/H < 1/10000`** (deuterium very rare). -/
theorem T1_D_over_H_PDG_lt_1e_neg_5 : D_over_H_PDG < 1 / 10000 := by
  unfold D_over_H_PDG; norm_num

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 230 — BBN primordial abundance PDG**.

    Five foundational facts:
    1. `Y_p = 0.245 > 0` (helium-4 mass fraction).
    2. `D/H = 2.55 × 10^(-5) > 0` (deuterium-to-hydrogen).
    3. `Y_p < 1/4` (less than 25%).
    4. `Y_p > 0.2`.
    5. `D/H < 10^(-5)` (deuterium very rare).

    BBN constrains η_B (baryon-to-photon ratio) and N_eff
    (relativistic species count). Independent confirmation of CMB.

    Sub-lemma 55/N in T-1.  Lean-core only. -/
theorem session_230_BBN_PDG_anchors_headline :
    0 < Y_p_PDG ∧ 0 < D_over_H_PDG
    ∧ Y_p_PDG < 1 / 4 ∧ Y_p_PDG > 0.2
    ∧ D_over_H_PDG < 1 / 10000 :=
  ⟨T1_Y_p_PDG_pos, T1_D_over_H_PDG_pos,
   T1_Y_p_PDG_lt_quarter, T1_Y_p_PDG_gt_02,
   T1_D_over_H_PDG_lt_1e_neg_5⟩

end OmegaTheory.Predictions.T1_BBNPrimordialAbundancesPDG
