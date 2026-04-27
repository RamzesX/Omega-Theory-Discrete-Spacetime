/-
  OmegaTheory.Predictions.T1_WZMassPDGAnchors

  T-1 (light quark masses) — Phase 2 sub session 189.
  M_W and M_Z PDG anchor constants.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  PDG 2024 W/Z gauge boson masses (in GeV):
  - M_W = 80.377 ± 0.012 GeV
  - M_Z = 91.1876 ± 0.0021 GeV (already in s188)

  Plus W/Z mass ratio bound: M_W < M_Z (a structural electroweak fact).

  Used in T-1 Phase 2 for electroweak threshold scale crossings during
  QCD running.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_WZMassPDGAnchors

/-! ## PDG anchor constants -/

/-- **M_W PDG 2024**: `80.377 GeV`. -/
noncomputable def M_W_PDG : ℝ := 80377 / 1000

/-- **M_Z PDG 2024**: `91.1876 GeV`. -/
noncomputable def M_Z_PDG : ℝ := 911876 / 10000

/-! ## Positivity -/

/-- **Wave T1 session 189 — `M_W > 0`**. -/
theorem T1_M_W_PDG_pos : 0 < M_W_PDG := by
  unfold M_W_PDG; norm_num

/-- **Wave T1 session 189 — `M_Z > 0`**. -/
theorem T1_M_Z_PDG_pos : 0 < M_Z_PDG := by
  unfold M_Z_PDG; norm_num

/-! ## Mass ordering W < Z -/

/-- **Wave T1 session 189 — `M_W < M_Z`**.

    W is lighter than Z (electroweak symmetry breaking). -/
theorem T1_M_W_lt_M_Z : M_W_PDG < M_Z_PDG := by
  unfold M_W_PDG M_Z_PDG; linarith

/-! ## Sanity bounds -/

/-- **Wave T1 session 189 — `M_W > 80`**. -/
theorem T1_M_W_PDG_gt_80 : M_W_PDG > 80 := by
  unfold M_W_PDG; norm_num

/-- **Wave T1 session 189 — `M_Z > 90`**. -/
theorem T1_M_Z_PDG_gt_90 : M_Z_PDG > 90 := by
  unfold M_Z_PDG; norm_num

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 189 — W/Z mass PDG anchors**.

    Five foundational facts:
    1. `M_W = 80.377 GeV > 0` (PDG 2024).
    2. `M_Z = 91.1876 GeV > 0` (PDG 2024).
    3. `M_W < M_Z` (electroweak ordering).
    4. `M_W > 80 GeV`.
    5. `M_Z > 90 GeV`.

    Used in T-1 Phase 2 for electroweak threshold scale crossings
    during QCD running.

    Sub-lemma 14/N in T-1.  Lean-core only. -/
theorem session_189_WZ_mass_PDG_anchors_headline :
    0 < M_W_PDG ∧ 0 < M_Z_PDG ∧ M_W_PDG < M_Z_PDG
    ∧ M_W_PDG > 80 ∧ M_Z_PDG > 90 :=
  ⟨T1_M_W_PDG_pos, T1_M_Z_PDG_pos, T1_M_W_lt_M_Z,
   T1_M_W_PDG_gt_80, T1_M_Z_PDG_gt_90⟩

end OmegaTheory.Predictions.T1_WZMassPDGAnchors
