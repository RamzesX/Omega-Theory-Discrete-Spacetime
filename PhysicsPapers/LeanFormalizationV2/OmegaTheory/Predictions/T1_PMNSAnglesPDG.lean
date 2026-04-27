/-
  OmegaTheory.Predictions.T1_PMNSAnglesPDG

  T-1 (light quark masses) — Phase 2 sub session 203.
  PMNS mixing angles PDG anchors.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  PDG 2024 / NuFIT 5.3 PMNS mixing angles (sin² convention):
  - sin²(θ_12) ≈ 0.307 (solar)
  - sin²(θ_13) ≈ 0.0220 (reactor)
  - sin²(θ_23) ≈ 0.561 (atmospheric, NO ordering best-fit)

  Plus positivity + standard bounds.

  Mirror of CKM angles — PMNS is the lepton-sector analogue.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_PMNSAnglesPDG

/-! ## PDG anchors (sin² convention) -/

/-- **sin²(θ_12) PMNS PDG/NuFIT 5.3**: `0.307` (solar). -/
noncomputable def sin_sq_theta_12_PMNS_PDG : ℝ := 307 / 1000

/-- **sin²(θ_13) PMNS PDG/NuFIT 5.3**: `0.0220` (reactor). -/
noncomputable def sin_sq_theta_13_PMNS_PDG : ℝ := 22 / 1000

/-- **sin²(θ_23) PMNS PDG/NuFIT 5.3**: `0.561` (atmospheric, NO). -/
noncomputable def sin_sq_theta_23_PMNS_PDG : ℝ := 561 / 1000

/-! ## Positivity -/

/-- **Wave T1 session 203 — `sin²(θ_12) > 0`**. -/
theorem T1_sin_sq_theta_12_PMNS_pos : 0 < sin_sq_theta_12_PMNS_PDG := by
  unfold sin_sq_theta_12_PMNS_PDG; norm_num

/-- **Wave T1 session 203 — `sin²(θ_13) > 0`**. -/
theorem T1_sin_sq_theta_13_PMNS_pos : 0 < sin_sq_theta_13_PMNS_PDG := by
  unfold sin_sq_theta_13_PMNS_PDG; norm_num

/-- **Wave T1 session 203 — `sin²(θ_23) > 0`**. -/
theorem T1_sin_sq_theta_23_PMNS_pos : 0 < sin_sq_theta_23_PMNS_PDG := by
  unfold sin_sq_theta_23_PMNS_PDG; norm_num

/-! ## Sanity bounds (sin² in [0, 1]) -/

/-- **Wave T1 session 203 — `sin²(θ_12) < 1`**. -/
theorem T1_sin_sq_theta_12_PMNS_lt_one : sin_sq_theta_12_PMNS_PDG < 1 := by
  unfold sin_sq_theta_12_PMNS_PDG; norm_num

/-- **Wave T1 session 203 — `sin²(θ_13) < 1/4`** (small reactor angle). -/
theorem T1_sin_sq_theta_13_PMNS_lt_quarter :
    sin_sq_theta_13_PMNS_PDG < 1 / 4 := by
  unfold sin_sq_theta_13_PMNS_PDG; norm_num

/-- **Wave T1 session 203 — `sin²(θ_23) < 1`**. -/
theorem T1_sin_sq_theta_23_PMNS_lt_one : sin_sq_theta_23_PMNS_PDG < 1 := by
  unfold sin_sq_theta_23_PMNS_PDG; norm_num

/-! ## Hierarchy: θ_13 (reactor) is smallest -/

/-- **Wave T1 session 203 — `sin²(θ_13) < sin²(θ_12)`** (reactor < solar). -/
theorem T1_sin_sq_theta_13_lt_12 :
    sin_sq_theta_13_PMNS_PDG < sin_sq_theta_12_PMNS_PDG := by
  unfold sin_sq_theta_13_PMNS_PDG sin_sq_theta_12_PMNS_PDG; linarith

/-- **Wave T1 session 203 — `sin²(θ_13) < sin²(θ_23)`** (reactor < atmospheric). -/
theorem T1_sin_sq_theta_13_lt_23 :
    sin_sq_theta_13_PMNS_PDG < sin_sq_theta_23_PMNS_PDG := by
  unfold sin_sq_theta_13_PMNS_PDG sin_sq_theta_23_PMNS_PDG; linarith

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 203 — PMNS angle PDG anchors**.

    Eight foundational facts:
    1-3: positivity (all three sin²(θ) > 0).
    4-6: sin² < 1 / sin²(θ_13) < 1/4 / sin²(θ_23) < 1.
    7-8: hierarchy θ_13 (reactor) is smallest.

    Sub-lemma 28/N in T-1.  Lean-core only.

    Mirror of CKM Wolfenstein anchors — PMNS is the lepton-sector
    analogue. -/
theorem session_203_PMNS_angles_PDG_anchors_headline :
    -- positivity
    (0 < sin_sq_theta_12_PMNS_PDG ∧ 0 < sin_sq_theta_13_PMNS_PDG
     ∧ 0 < sin_sq_theta_23_PMNS_PDG)
    -- bounds
    ∧ (sin_sq_theta_12_PMNS_PDG < 1 ∧ sin_sq_theta_13_PMNS_PDG < 1 / 4
       ∧ sin_sq_theta_23_PMNS_PDG < 1)
    -- hierarchy
    ∧ (sin_sq_theta_13_PMNS_PDG < sin_sq_theta_12_PMNS_PDG
       ∧ sin_sq_theta_13_PMNS_PDG < sin_sq_theta_23_PMNS_PDG) :=
  ⟨⟨T1_sin_sq_theta_12_PMNS_pos, T1_sin_sq_theta_13_PMNS_pos,
    T1_sin_sq_theta_23_PMNS_pos⟩,
   ⟨T1_sin_sq_theta_12_PMNS_lt_one, T1_sin_sq_theta_13_PMNS_lt_quarter,
    T1_sin_sq_theta_23_PMNS_lt_one⟩,
   ⟨T1_sin_sq_theta_13_lt_12, T1_sin_sq_theta_13_lt_23⟩⟩

end OmegaTheory.Predictions.T1_PMNSAnglesPDG
