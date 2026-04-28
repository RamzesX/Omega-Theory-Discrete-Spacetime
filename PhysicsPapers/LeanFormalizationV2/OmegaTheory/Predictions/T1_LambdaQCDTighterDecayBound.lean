/-
  OmegaTheory.Predictions.T1_LambdaQCDTighterDecayBound

  T-1 (light quark masses) — tighter Λ_QCD < M_Z/4 decay bound,
  sub session 559c — STRICT critical-path #306 derivation extension.

  Single-thread hand-authored 2026-04-28 (cycle 65 — /loop dynamic).

  ## What this file delivers

  Building on s559b 1-loop Λ_QCD = M_Z · exp(-2π/(β₀·α_s(M_Z))), this
  file proves the SHARPER decay bound:

      Λ_QCD < M_Z / 4

  via the chain:
   - RG_exponent < -2 (using π > 3 > β₀·α_s ≈ 0.9039)
   - exp(2) > 4 (using exp(1) > 2 and exp(2) = exp(1)·exp(1))
   - exp(-2) = 1/exp(2) < 1/4
   - exp(RG_exp) < exp(-2) (by exp_strictMono)
   - Λ_QCD = M_Z · exp(RG_exp) < M_Z · (1/4) = M_Z / 4

  Numerically Λ_QCD ≈ 87.6 MeV vs M_Z/4 ≈ 22.8 GeV — extremely loose
  but provable with elementary bounds (no need for tighter exp(6) > 100
  arithmetic).

  Three new derivations:
  - exp(2) > 4 (substrate-independent Mathlib bound)
  - RG_exponent_1loop < -2 (sharpening from s559b's < -1)
  - Λ_QCD < M_Z / 4 (sharper than s559b's < M_Z/2)

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #306 status

  This file extends #306's structural-derivation bounds. Future
  follow-ups: NLL corrections (factor-2.4 to PDG), tighter bound
  Λ_QCD < M_Z / 100 via exp(6) > 100 (needs (exp 1)^6 ≈ 387.4
  arithmetic).
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import OmegaTheory.Predictions.T1_LambdaQCDFromAlphaS1Loop

namespace OmegaTheory.Predictions.T1_LambdaQCDTighterDecayBound

open OmegaTheory.Predictions.T1_LambdaQCDFromAlphaS1Loop

/-! ## Sharpening: RG_exponent < -2 -/

/-- **🚨 Wave T1 session 559c — `RG_exponent_1loop < -2`**.

    Sharpening from s559b's `< -1`: 2π/(β₀·α_s) > 2 ⟺ π > β₀·α_s.
    With β₀·α_s = (23/3)(1179/10000) ≈ 0.9039 and π > 3, this holds. -/
theorem T1_RG_exponent_lt_neg_two : RG_exponent_1loop < -2 := by
  unfold RG_exponent_1loop beta_0_QCD_5flav alpha_s_M_Z_PDG_anchor
  have h_denom_pos : (0 : ℝ) < 23 / 3 * (1179 / 10000) := by norm_num
  rw [neg_div, neg_lt_neg_iff, lt_div_iff₀ h_denom_pos]
  -- goal: 2 * (23/3 * (1179/10000)) < 2 * Real.pi
  have h_pi_gt_3 : (3 : ℝ) < Real.pi := Real.pi_gt_three
  have h_prod_lt : (2 : ℝ) * (23 / 3 * (1179 / 10000)) < 6 := by norm_num
  linarith

/-! ## Sharpening: exp(2) > 4 -/

/-- **🚨 Wave T1 session 559c — `Real.exp 2 > 4`**.

    Pure Mathlib bound: exp(2) = exp(1)·exp(1), and exp(1) > 2 implies
    exp(2) > 4. Substrate-independent. -/
theorem T1_exp_2_gt_4 : (4 : ℝ) < Real.exp 2 := by
  have h_e1_gt_2 : (2 : ℝ) < Real.exp 1 := Real.exp_one_gt_two
  have h_e1_pos : (0 : ℝ) < Real.exp 1 := Real.exp_pos 1
  have h_exp_2_eq : Real.exp 2 = Real.exp 1 * Real.exp 1 := by
    rw [show (2 : ℝ) = 1 + 1 from by norm_num, Real.exp_add]
  rw [h_exp_2_eq]
  nlinarith [h_e1_gt_2, h_e1_pos]

/-! ## Sharper Λ_QCD bound: Λ < M_Z / 4 -/

/-- **🚨 Wave T1 session 559c — `Λ_QCD < M_Z / 4`**.

    Sharper than s559b's `< M_Z / 2` via exp(-2) < 1/4. -/
theorem T1_Lambda_QCD_1loop_lt_M_Z_quarter :
    Lambda_QCD_1loop_GeV < M_Z_GeV / 4 := by
  unfold Lambda_QCD_1loop_GeV
  -- Step 1: exp(RG_exp) < exp(-2)
  have h_step1 : Real.exp RG_exponent_1loop < Real.exp (-2) :=
    Real.exp_strictMono T1_RG_exponent_lt_neg_two
  -- Step 2: exp(-2) < 1/4 (from exp(2) > 4)
  have h_exp2_pos : (0 : ℝ) < Real.exp 2 := Real.exp_pos 2
  have h_step2 : Real.exp (-2) < 1 / 4 := by
    rw [Real.exp_neg]
    rw [inv_eq_one_div]
    exact one_div_lt_one_div_of_lt (by norm_num) T1_exp_2_gt_4
  -- Step 3: combine
  have h_exp_lt_quarter : Real.exp RG_exponent_1loop < 1 / 4 := by linarith
  calc M_Z_GeV * Real.exp RG_exponent_1loop
      < M_Z_GeV * (1 / 4) :=
        mul_lt_mul_of_pos_left h_exp_lt_quarter T1_M_Z_pos
    _ = M_Z_GeV / 4 := by ring

/-! ## SubstrateLambdaQCDTighterBound Prop scaffold -/

/-- **SubstrateLambdaQCDTighterBound**: sharper Λ_QCD decay bound
    capturing 1-loop asymptotic-freedom decay rate.

    Real Prop body. -/
def SubstrateLambdaQCDTighterBound : Prop :=
  RG_exponent_1loop < -2 ∧
  (4 : ℝ) < Real.exp 2 ∧
  Lambda_QCD_1loop_GeV < M_Z_GeV / 4

/-- **🚨 Wave T1 session 559c — `SubstrateLambdaQCDTighterBound`**. -/
theorem T1_substrate_lambda_QCD_tighter_bound :
    SubstrateLambdaQCDTighterBound :=
  ⟨T1_RG_exponent_lt_neg_two, T1_exp_2_gt_4,
   T1_Lambda_QCD_1loop_lt_M_Z_quarter⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 559c — Λ_QCD < M_Z/4 sharper bound**.

    🏆 STRICT CRITICAL-PATH #306 derivation extension.

    Three sharpening theorems:
    1. RG_exponent_1loop < -2 (from π > 3, β₀·α_s ≈ 0.9)
    2. exp(2) > 4 (Mathlib bound from exp(1) > 2)
    3. Λ_QCD < M_Z / 4 (sharper than s559b's < M_Z / 2)
    + SubstrateLambdaQCDTighterBound Prop (3-conjunct).

    Composes naturally with #305 ext s559a (α_s ≤ 2/N): substrate-
    derived α_s decay propagates to substrate-derived Λ_QCD decay
    via the closed-form 1-loop formula.

    Mathlib usage: pure `Real.exp_strictMono`, `Real.exp_add`,
    `Real.exp_one_gt_two`, `Real.pi_gt_three`. NO ODE infra needed.

    Sub-lemma 151/N in T-1.  Lean-core only.

    🏆 First Lean-core sharper Λ_QCD < M_Z/4 1-loop bound. -/
theorem session_559c_lambda_QCD_tighter_decay_bound_headline :
    RG_exponent_1loop < -2 ∧
    (4 : ℝ) < Real.exp 2 ∧
    Lambda_QCD_1loop_GeV < M_Z_GeV / 4 ∧
    SubstrateLambdaQCDTighterBound :=
  ⟨T1_RG_exponent_lt_neg_two, T1_exp_2_gt_4,
   T1_Lambda_QCD_1loop_lt_M_Z_quarter,
   T1_substrate_lambda_QCD_tighter_bound⟩

end OmegaTheory.Predictions.T1_LambdaQCDTighterDecayBound
