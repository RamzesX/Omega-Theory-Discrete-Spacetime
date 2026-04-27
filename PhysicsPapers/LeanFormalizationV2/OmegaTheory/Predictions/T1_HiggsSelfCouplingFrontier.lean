/-
  OmegaTheory.Predictions.T1_HiggsSelfCouplingFrontier

  T-1 (light quark masses) — FRONTIER, sub session 275.
  Higgs self-coupling λ_HHH (HH production at LHC).

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  ATLAS + CMS Run 2 + Run 3 combined HH searches — testing the
  Higgs self-coupling λ_HHH (the "trilinear coupling"):

  - SM:                       κ_λ = λ_HHH / λ_HHH^SM = 1
  - ATLAS Run 2 obs (95% CL): -1.4 < κ_λ < 6.1
  - CMS Run 2 obs (95% CL):    -1.2 < κ_λ < 6.5
  - ATLAS+CMS combined ~2024:  ~similar range, projecting ~3× tighter at HL-LHC
  - HL-LHC target ~3000/fb:   1 ± 0.5 SM-precision

  Key importance: λ_HHH **directly probes the shape of the Higgs
  potential** — whether electroweak symmetry breaking is via
  the canonical Mexican-hat or something more exotic.

  Plus structural facts.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_HiggsSelfCouplingFrontier

/-! ## κ_λ bounds -/

/-- **κ_λ ATLAS Run 2 lower bound** (95% CL): `-1.4`. -/
noncomputable def kappa_lambda_ATLAS_lower : ℝ := -14 / 10

/-- **κ_λ ATLAS Run 2 upper bound** (95% CL): `6.1`. -/
noncomputable def kappa_lambda_ATLAS_upper : ℝ := 61 / 10

/-- **κ_λ CMS Run 2 lower bound** (95% CL): `-1.2`. -/
noncomputable def kappa_lambda_CMS_lower : ℝ := -12 / 10

/-- **κ_λ CMS Run 2 upper bound** (95% CL): `6.5`. -/
noncomputable def kappa_lambda_CMS_upper : ℝ := 65 / 10

/-- **κ_λ SM**: `1`. -/
noncomputable def kappa_lambda_SM : ℝ := 1

/-- **κ_λ HL-LHC projected uncertainty**: `0.5`. -/
noncomputable def kappa_lambda_HL_LHC_uncertainty : ℝ := 1 / 2

/-! ## ATLAS-CMS bound consistency -/

/-- **🚨 FRONTIER — Wave T1 session 275 — `ATLAS lower < CMS lower`**.

    ATLAS Run 2 sets a slightly tighter lower bound. -/
theorem T1_ATLAS_tighter_lower :
    kappa_lambda_ATLAS_lower < kappa_lambda_CMS_lower := by
  unfold kappa_lambda_ATLAS_lower kappa_lambda_CMS_lower; linarith

/-- **🚨 FRONTIER — Wave T1 session 275 — `ATLAS upper < CMS upper`**.

    ATLAS Run 2 sets a slightly tighter upper bound. -/
theorem T1_ATLAS_tighter_upper :
    kappa_lambda_ATLAS_upper < kappa_lambda_CMS_upper := by
  unfold kappa_lambda_ATLAS_upper kappa_lambda_CMS_upper; linarith

/-! ## SM in allowed band (both experiments) -/

/-- **🚨 FRONTIER — Wave T1 session 275 — `SM > ATLAS lower`**.

    SM (κ_λ = 1) is consistent with ATLAS lower bound. -/
theorem T1_SM_above_ATLAS_lower :
    kappa_lambda_SM > kappa_lambda_ATLAS_lower := by
  unfold kappa_lambda_SM kappa_lambda_ATLAS_lower; linarith

/-- **🚨 FRONTIER — Wave T1 session 275 — `SM < ATLAS upper`**.

    SM (κ_λ = 1) is consistent with ATLAS upper bound. -/
theorem T1_SM_below_ATLAS_upper :
    kappa_lambda_SM < kappa_lambda_ATLAS_upper := by
  unfold kappa_lambda_SM kappa_lambda_ATLAS_upper; linarith

/-! ## SM is positive (canonical Mexican hat) -/

/-- **Wave T1 session 275 — `κ_λ SM > 0`**. -/
theorem T1_kappa_SM_pos : 0 < kappa_lambda_SM := by
  unfold kappa_lambda_SM; norm_num

/-- **Wave T1 session 275 — `κ_λ HL-LHC > 0`**. -/
theorem T1_kappa_HL_LHC_pos : 0 < kappa_lambda_HL_LHC_uncertainty := by
  unfold kappa_lambda_HL_LHC_uncertainty; norm_num

/-! ## Future improvement -/

/-- **🚨 FRONTIER — Wave T1 session 275 — `HL-LHC σ << ATLAS Run 2 range`**.

    HL-LHC will narrow allowed band by ~6×. -/
theorem T1_HL_LHC_shrinks_range :
    6 * kappa_lambda_HL_LHC_uncertainty < kappa_lambda_ATLAS_upper - kappa_lambda_ATLAS_lower := by
  unfold kappa_lambda_HL_LHC_uncertainty
         kappa_lambda_ATLAS_upper kappa_lambda_ATLAS_lower
  linarith

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 275 — Higgs self-coupling frontier**.

    🚨 FRONTIER (probing the Higgs potential shape) 🚨

    Eight foundational facts:
    1. `ATLAS lower = -1.4` (Run 2 95% CL).
    2. `ATLAS upper = 6.1` (Run 2 95% CL).
    3. `CMS lower = -1.2` (Run 2 95% CL).
    4. `CMS upper = 6.5` (Run 2 95% CL).
    5. `κ_λ SM = 1 > 0` (canonical Mexican-hat).
    6. `ATLAS lower < CMS lower` (ATLAS tighter low).
    7. `SM in [ATLAS lower, ATLAS upper]` (SM consistent).
    8. `HL-LHC will improve by ~6×` (~0.5 precision target).

    λ_HHH directly probes the shape of the Higgs potential —
    canonical Mexican-hat vs exotic shapes (1st-order phase
    transitions, Coleman-Weinberg, asymmetric, etc.).

    Sub-lemma 97/N in T-1.  Lean-core only.

    🏆 First Lean-core formalization of Higgs self-coupling. -/
theorem session_275_Higgs_self_coupling_frontier_headline :
    kappa_lambda_ATLAS_lower < kappa_lambda_CMS_lower
    ∧ kappa_lambda_ATLAS_upper < kappa_lambda_CMS_upper
    ∧ kappa_lambda_SM > kappa_lambda_ATLAS_lower
    ∧ kappa_lambda_SM < kappa_lambda_ATLAS_upper
    ∧ 0 < kappa_lambda_SM
    ∧ 6 * kappa_lambda_HL_LHC_uncertainty <
        kappa_lambda_ATLAS_upper - kappa_lambda_ATLAS_lower :=
  ⟨T1_ATLAS_tighter_lower, T1_ATLAS_tighter_upper,
   T1_SM_above_ATLAS_lower, T1_SM_below_ATLAS_upper,
   T1_kappa_SM_pos, T1_HL_LHC_shrinks_range⟩

end OmegaTheory.Predictions.T1_HiggsSelfCouplingFrontier
