/-
  OmegaTheory.Predictions.T1_QCDMasterCapstone

  T-1 (light quark masses) — QCD MASTER CAPSTONE, session 224.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  4-conjunct master capstone tying QCD-related sub-lemmas
  s221-s223 + s187:

  1. **Λ_QCD anchors** (s221): 5-flav and 4-flav both positive, ordered.
  2. **α_s asymptotic freedom** (s222): low-scale > high-scale.
  3. **Decay constants** (s223): f_K > f_π.
  4. **QCD running formula** (s187): α_s_1loop sanity.

  Foundation for T-3 (Λ_QCD) substrate-derivation.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Predictions.T1_LambdaQCDPDGAnchor
import OmegaTheory.Predictions.T1_AlphaSAtTauPDG
import OmegaTheory.Predictions.T1_PionDecayConstantPDG
import OmegaTheory.Foundations.AlphaSRunning1Loop

namespace OmegaTheory.Predictions.T1_QCDMasterCapstone

open OmegaTheory.Predictions.T1_LambdaQCDPDGAnchor
open OmegaTheory.Predictions.T1_AlphaSAtTauPDG
open OmegaTheory.Predictions.T1_PionDecayConstantPDG
open OmegaTheory.Predictions.T1_AlphaSAtMZPDGAnchor
open OmegaTheory.Foundations.AlphaSRunning1Loop

/-- **HEADLINE — Wave T1 session 224 — QCD MASTER CAPSTONE**.

    4-conjunct master capstone for QCD-related sub-lemmas s221-s223 +
    QCD running foundation (s187).

    Lean-core only.  Cycle 65. -/
theorem session_224_T1_QCD_master_capstone :
    -- (1) Λ_QCD anchors
    (Lambda_QCD_5flav_PDG > Lambda_QCD_4flav_PDG)
    -- (2) α_s asymptotic freedom hierarchy
    ∧ (alpha_s_Mtau_PDG > alpha_s_MZ_PDG)
    -- (3) Decay constants ordering
    ∧ (f_K_PDG > f_pi_PDG)
    -- (4) α_s running sanity
    ∧ (∀ (μ₀ α₀ : ℝ) (n_f : ℕ), μ₀ ≠ 0 →
        alpha_s_1loop μ₀ μ₀ α₀ n_f = α₀) :=
  ⟨T1_Lambda_QCD_5flav_gt_4flav,
   T1_alpha_s_Mtau_gt_MZ,
   T1_f_K_gt_f_pi,
   T1_alpha_s_1loop_at_mu0⟩

end OmegaTheory.Predictions.T1_QCDMasterCapstone
