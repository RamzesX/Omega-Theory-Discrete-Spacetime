/-
  OmegaTheory.Predictions.T1_LambdaQCDPDGAnchor

  T-1 (light quark masses) — T-3 entry, sub session 221.
  Λ_QCD PDG anchor (T-3 frontier, joint with T-1).

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  PDG 2024 Λ_QCD anchor:
  - Λ_QCD ≈ 332 MeV (5-flavour MS-bar, ±17)
  - Λ_QCD ≈ 213 MeV (4-flavour MS-bar at Δm_charm scale)

  Plus positivity + bounds.

  Λ_QCD is the QCD scale where α_s(Λ_QCD) ~ 1 — the boundary between
  perturbative and non-perturbative QCD.  T-3 derives Λ_QCD from
  substrate truncation δ_comp + α_s running.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_LambdaQCDPDGAnchor

/-! ## PDG anchor -/

/-- **Λ_QCD PDG (5-flavour MS-bar)**: `332 MeV`. -/
noncomputable def Lambda_QCD_5flav_PDG : ℝ := 332

/-- **Λ_QCD PDG (4-flavour MS-bar)**: `213 MeV`. -/
noncomputable def Lambda_QCD_4flav_PDG : ℝ := 213

/-! ## Positivity -/

/-- **Wave T1 session 221 — `Λ_QCD (5-flav) > 0`**. -/
theorem T1_Lambda_QCD_5flav_PDG_pos : 0 < Lambda_QCD_5flav_PDG := by
  unfold Lambda_QCD_5flav_PDG; norm_num

/-- **Wave T1 session 221 — `Λ_QCD (4-flav) > 0`**. -/
theorem T1_Lambda_QCD_4flav_PDG_pos : 0 < Lambda_QCD_4flav_PDG := by
  unfold Lambda_QCD_4flav_PDG; norm_num

/-! ## Sanity bounds -/

/-- **Wave T1 session 221 — `Λ_QCD (5-flav) > Λ_QCD (4-flav)`**.

    Higher-flavour Λ_QCD is LARGER because α_s grows faster with
    more active flavours integrated out. -/
theorem T1_Lambda_QCD_5flav_gt_4flav :
    Lambda_QCD_5flav_PDG > Lambda_QCD_4flav_PDG := by
  unfold Lambda_QCD_5flav_PDG Lambda_QCD_4flav_PDG; linarith

/-- **Wave T1 session 221 — `Λ_QCD (5-flav) > 300`** MeV. -/
theorem T1_Lambda_QCD_5flav_gt_300 :
    Lambda_QCD_5flav_PDG > 300 := by
  unfold Lambda_QCD_5flav_PDG; norm_num

/-- **Wave T1 session 221 — `Λ_QCD (5-flav) < 400`** MeV. -/
theorem T1_Lambda_QCD_5flav_lt_400 :
    Lambda_QCD_5flav_PDG < 400 := by
  unfold Lambda_QCD_5flav_PDG; norm_num

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 221 — Λ_QCD PDG anchors**.

    Five foundational facts:
    1. `Λ_QCD (5-flav) = 332 MeV > 0`.
    2. `Λ_QCD (4-flav) = 213 MeV > 0`.
    3. `Λ_QCD (5-flav) > Λ_QCD (4-flav)` (flavour-dependent).
    4. `Λ_QCD (5-flav) > 300`.
    5. `Λ_QCD (5-flav) < 400`.

    Λ_QCD is the QCD scale where α_s(Λ_QCD) ~ 1.  T-3 frontier
    derives Λ_QCD from substrate truncation δ_comp + α_s running.

    Sub-lemma 46/N in T-1.  Lean-core only.  T-3 entry. -/
theorem session_221_Lambda_QCD_PDG_anchors_headline :
    0 < Lambda_QCD_5flav_PDG ∧ 0 < Lambda_QCD_4flav_PDG
    ∧ Lambda_QCD_5flav_PDG > Lambda_QCD_4flav_PDG
    ∧ Lambda_QCD_5flav_PDG > 300 ∧ Lambda_QCD_5flav_PDG < 400 :=
  ⟨T1_Lambda_QCD_5flav_PDG_pos, T1_Lambda_QCD_4flav_PDG_pos,
   T1_Lambda_QCD_5flav_gt_4flav,
   T1_Lambda_QCD_5flav_gt_300, T1_Lambda_QCD_5flav_lt_400⟩

end OmegaTheory.Predictions.T1_LambdaQCDPDGAnchor
