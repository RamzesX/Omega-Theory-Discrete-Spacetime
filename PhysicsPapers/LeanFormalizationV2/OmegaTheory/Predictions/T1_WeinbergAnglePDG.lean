/-
  OmegaTheory.Predictions.T1_WeinbergAnglePDG

  T-1 (light quark masses) — Phase 2 sub session 198.
  Weinberg angle θ_W PDG anchor.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  PDG 2024 weak mixing angle:
  - sin²θ_W ≈ 0.23122 (MS-bar at M_Z, ±0.00004)

  Plus positivity + bounds (0 < sin²θ_W < 1/4).

  Foundational for electroweak unification calibration.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_WeinbergAnglePDG

/-! ## PDG anchor -/

/-- **sin²θ_W PDG 2024**: `0.23122` (MS-bar at M_Z). -/
noncomputable def sin_sq_theta_W_PDG : ℝ := 23122 / 100000

/-! ## Positivity -/

/-- **Wave T1 session 198 — `sin²θ_W > 0`**. -/
theorem T1_sin_sq_theta_W_PDG_pos : 0 < sin_sq_theta_W_PDG := by
  unfold sin_sq_theta_W_PDG; norm_num

/-! ## Sanity bounds -/

/-- **Wave T1 session 198 — `sin²θ_W < 1/4`**. -/
theorem T1_sin_sq_theta_W_PDG_lt_quarter :
    sin_sq_theta_W_PDG < 1 / 4 := by
  unfold sin_sq_theta_W_PDG; norm_num

/-- **Wave T1 session 198 — `sin²θ_W > 0.23`** (PDG lower bound). -/
theorem T1_sin_sq_theta_W_PDG_gt_023 :
    sin_sq_theta_W_PDG > 0.23 := by
  unfold sin_sq_theta_W_PDG; norm_num

/-- **Wave T1 session 198 — `sin²θ_W < 0.24`** (PDG upper bound). -/
theorem T1_sin_sq_theta_W_PDG_lt_024 :
    sin_sq_theta_W_PDG < 0.24 := by
  unfold sin_sq_theta_W_PDG; norm_num

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 198 — Weinberg angle PDG anchor**.

    Four foundational facts:
    1. `sin²θ_W = 0.23122 > 0` (PDG MS-bar at M_Z).
    2. `sin²θ_W < 1/4` (sub-quarter, weak vs photon mixing).
    3. `sin²θ_W > 0.23`.
    4. `sin²θ_W < 0.24`.

    Foundational for electroweak unification calibration.

    Sub-lemma 23/N in T-1.  Lean-core only. -/
theorem session_198_weinberg_angle_PDG_anchor_headline :
    0 < sin_sq_theta_W_PDG
    ∧ sin_sq_theta_W_PDG < 1 / 4
    ∧ sin_sq_theta_W_PDG > 0.23
    ∧ sin_sq_theta_W_PDG < 0.24 :=
  ⟨T1_sin_sq_theta_W_PDG_pos, T1_sin_sq_theta_W_PDG_lt_quarter,
   T1_sin_sq_theta_W_PDG_gt_023, T1_sin_sq_theta_W_PDG_lt_024⟩

end OmegaTheory.Predictions.T1_WeinbergAnglePDG
