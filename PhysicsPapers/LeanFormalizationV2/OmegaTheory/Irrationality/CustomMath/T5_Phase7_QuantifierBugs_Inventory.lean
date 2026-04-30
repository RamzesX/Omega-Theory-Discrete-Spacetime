/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuantifierBugs_Inventory

  T-5 (Roth's theorem) — **Inventory of LITERAL-FALSE NAMED Props in
  V8 architecture + their honest existential replacements**.

  ## Architectural rule (locked 2026-04-30)

  When factoring an outer existential Prop `∃ x₁ x₂ ..., P(x₁, x₂, ...)`
  into sub-NAMEDs, quantifying the witnesses (x₁, x₂, ...) UNIVERSALLY
  in sub-NAMEDs is typically WRONG — it makes the sub-NAMED literal-false.
  The witnesses must be EXISTENTIALLY chosen consistently across
  sub-NAMEDs.

  ## Inventory of LITERAL-FALSE NAMED Props found

  Across the V8 architecture, 3 NAMED Props are LITERAL FALSE due to
  this quantification mismatch:

  ### Bug 1: T5_NAMED_small_eps_axis_in_V8 (V8R7)
  Location: `T5_Phase7_SmallEpsAxis_NAMED.lean:46`
  Claim: `∀ {m} ≥ 1, ∀ ε > 0, ε ≤ m³/16`
  Counter: m=3, ε=100 ⇒ 27/16 < 100. FALSE.
  Fix: existential T5_NAMED_small_eps_axis_existential
       (`T5_Phase7_SmallEpsAxis_Existential.lean:46`) UNCONDITIONALLY closed.

  ### Bug 2: T5_NAMED_V7N1U_D5c_per_q_decay (D5F, my creation)
  Location: `T5_Phase7_V7N1U_D5_Factoring.lean:103`
  Claim: `∀ ... (P, R), ∀ C > 0, ∀ κ > 1, ∀ q ..., |aeval q P| ≤ C·(∏d^R)^{-κ}`
  Counter: take κ → ∞, RHS → 0 but LHS may be O(1). FALSE.
  Fix: existential form (= V7N1U-D5 itself) — fixed 2026-04-30 same fire.

  ### Bug 3: T5_NAMED_Schmidt_alpha_diagonal_index_lower_bound (SM1PD-2)
  Location: `T5_Phase7_SM1_PartialDischarge.lean:56`
  Claim: `∀ α, ∀ ε > 0, ∀ {m} ≥ 1, ∀ P_int, rothIndex P at α ≥ m/2 - √(mε)`
  Counter: m=1, P=X 0, α=√2 ⇒ rothIndex = 0 < 1/2 - √ε. FALSE.
  Fix: existential SM1PD-2-honest = SJF-2
       (`T5_Phase7_Schmidt_Joint_Factoring.lean:90`).

  ## Bidirectional bridges

  This file establishes: SJF-2 ↔ SM1PD-2-honest ↔ existential-SM1PD-2,
  showing the honest forms are LOGICALLY EQUIVALENT.

  Plus paper-citable architectural inventory headline.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SmallEpsAxis_Existential
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_V7N1U_D5_Factoring
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SM1PD2_Quantifier_Audit
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_Schmidt_Joint_Factoring
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockC_V7N1Uniform

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuantifierBugs_Inventory

open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SmallEpsAxis_Existential
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_V7N1U_D5_Factoring
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_V7N1U_PartialDischarge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SM1PD2_Quantifier_Audit
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_Schmidt_Joint_Factoring
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_Schmidt_JointExistence
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_SchmidtMachineryNAMED
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockC_V7N1Uniform

/-! ## QBI-1 — Bug 1 honest replacement (already discharged) -/

/-- **QBI-1 — `T5_small_eps_existential_replaces_universal`**: the
    existential small-eps axis is the honest replacement for the
    literal-false universal form. UNCONDITIONALLY discharged
    (witness m := Nat.ceil(16ε)+1). -/
theorem T5_small_eps_existential_replaces_universal :
    T5_NAMED_small_eps_axis_existential :=
  T5_NAMED_small_eps_axis_existential_unconditional

/-! ## QBI-2 — Bug 2 honest replacement (D5c = V7N1U-D5 = V7N1U) -/

/-- **QBI-2 — `T5_D5c_existential_replaces_universal`**: D5c (after fix)
    is definitionally equal to V7N1U-D5 = V7N1U (existential form). The
    literal-false universal form is RETIRED. -/
theorem T5_D5c_existential_replaces_universal :
    T5_NAMED_V7N1U_D5c_per_q_decay → T5_NAMED_V7N1U_D5_kappa_composition :=
  id

/-! ## QBI-3 — Bug 3 honest replacement (SJF-2 = SM1PD-2-honest) -/

/-- **QBI-3 — `T5_SM1PD2_existential_replaces_universal`**: SJF-2 (honest
    existential) ↔ SM1PD-2-honest. The literal-false universal SM1PD-2
    is RETIRED in favor of either honest form. -/
theorem T5_SM1PD2_existential_replaces_universal :
    T5_NAMED_Schmidt_joint_b_alpha_index_bound ↔
    T5_NAMED_Schmidt_alpha_diagonal_index_lower_bound_existential :=
  ⟨T5_SM1PD2_existential_via_SJF2, T5_SJF2_via_SM1PD2_existential⟩

/-! ## QBI-4 — Architectural lesson (LOCKED 2026-04-30) -/

/-- **🚨🚨🚨🚨🚨 QBI-4 — `T5_QUANTIFIER_BUGS_INVENTORY_HEADLINE`**:
    paper-citable architectural lesson.

    Strategic significance:
    - 3 LITERAL-FALSE NAMED Props identified in V8 codebase.
    - All 3 have honest existential replacements.
    - Architectural rule LOCKED: ∀-quantifying witnesses inside ∃-Props
      makes the sub-Prop literal-false.
    - Future audits: search for `∀ (W : T)` inside Props that should be
      ∃ — check by adversary-witness test ("can ∀ adversary falsify?"). -/
theorem T5_QUANTIFIER_BUGS_INVENTORY_HEADLINE :
    -- Bug 1: small-eps universal → existential (unconditional discharge)
    T5_NAMED_small_eps_axis_existential ∧
    -- Bug 2: D5c universal → V7N1U-D5 existential (definitional equality)
    (T5_NAMED_V7N1U_D5c_per_q_decay → T5_NAMED_V7N1U_D5_kappa_composition) ∧
    -- Bug 3: SM1PD-2 universal → SJF-2 / SM1PD-2-honest (logically equivalent)
    (T5_NAMED_Schmidt_joint_b_alpha_index_bound ↔
      T5_NAMED_Schmidt_alpha_diagonal_index_lower_bound_existential) :=
  ⟨T5_small_eps_existential_replaces_universal,
   T5_D5c_existential_replaces_universal,
   T5_SM1PD2_existential_replaces_universal⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuantifierBugs_Inventory
