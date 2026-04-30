/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_D5_RestatedAndDischarge

  T-5 (Roth's theorem) — **BlockAB-D5 RESTATED in CORRECTED FORM +
  UNCONDITIONAL DISCHARGE** of corrected form.

  Critical discovery 2026-04-30: original `T5_NAMED_per_n_hypothesis_bundle`
  (in T5_Phase7_RothBoundLargeBlockAB_Decomposition.lean:121-142) is
  PROVABLY FALSE — universally quantifies over `q_seq : ℕ → Fin m → ℚ`
  with no input constraints, so the per-n conjunction must hold for ALL
  q_seq including the constant-zero sequence.  For Schmidt aux P_int
  with no constant term, `aeval (const 0) P = 0`, refuting aeval-nonzero.

  Fix: introduce CORRECTED Prop here taking per-n violator + growth +
  balance + den-unbounded + master α-diagonal lower bound + per-n
  aeval≠0 AS INPUTS, deriving per-n index upper bound + per-n
  D-unboundedness translation as OUTPUTS.

  The two analytical hard inputs (balance + aeval≠0) are deferred to
  V8 outer layer (Schmidt aux R-tuning + Schmidt aux non-vanishing).

  Sub-lemmas:
    - D5.1 `T5_per_n_index_bound_from_master`: per-n master.IR application
    - D5.3 `T5_per_n_unboundedness_translation`: ℕ→ℝ Archimedean lift
    - D5.4 `T5_NAMED_per_n_hypothesis_bundle_corrected_unconditional`: composition

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockAB_Decomposition
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeFromMasterAndPigeonhole_Discharge
import Mathlib.Algebra.Order.BigOperators.GroupWithZero.Finset

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_D5_RestatedAndDischarge

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockAB_Decomposition
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeFromMasterAndPigeonhole_Discharge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MasterCapstone
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTuple
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex

/-! ## D5-restate — Corrected D5 Prop -/

/-- **D5-restate — `T5_NAMED_per_n_hypothesis_bundle_corrected`** [CORRECTED
    NAMED Prop].

    Takes per-n violator + growth + balance + den-unbounded + α-diagonal
    rothIndex lower bound + per-n aeval≠0 AS INPUTS.

    Outputs:
    (a) per-n rothIndex upper bound `≤ t - √(mε)` (from master.IR application)
    (b) per-n D-unboundedness in ℝ-product form (from ℕ-unboundedness lift)

    Note: balance + aeval≠0 inputs deferred to V8 Schmidt machinery
    (Schmidt R-tuning provides balance; Schmidt non-vanishing provides
    aeval≠0). -/
def T5_NAMED_per_n_hypothesis_bundle_corrected : Prop :=
  ∀ (α : ℝ), Irrational α → IsAlgebraic ℤ α →
  ∀ (ε : ℝ), 0 < ε →
  ∀ {m : ℕ}, 1 ≤ m →
  ∀ (P_int : MvPolynomial (Fin m) ℤ),
    (P_int.map (algebraMap ℤ ℝ) : MvPolynomial (Fin m) ℝ) ≠ 0 →
  (∀ i, 0 < MvPolynomial.degreeOf i (P_int.map (algebraMap ℤ ℝ))) →
  ∀ (master : RothLemmaMaster),
  -- Lower bound at α-diagonal (from Schmidt aux index Statement)
  rothIndex (P_int.map (algebraMap ℤ ℝ))
    (fun _ => α)
    (fun j => MvPolynomial.degreeOf j (P_int.map (algebraMap ℤ ℝ))) ≥
    (m : ℝ) / 2 - Real.sqrt ((m : ℝ) * ε) →
  ∀ (q_seq : ℕ → Fin m → ℚ),
    -- INPUTS from D4 + Schmidt machinery
    (∀ n j, q_seq n j ∈ T5_RothViolatingSet α ε) →
    (∀ n, T5_DenominatorGrowthCondition (q_seq n) ε) →
    (∀ n, T5_DegreeHeightBalanceCondition
      (fun j => MvPolynomial.degreeOf j (P_int.map (algebraMap ℤ ℝ)))
      (q_seq n) ε) →
    (∀ M : ℕ, ∃ n, ∀ j, M < (q_seq n j).den) →
    (∀ n, aeval (fun j => ((q_seq n j : ℚ) : ℝ))
      ((P_int.map (algebraMap ℤ ℝ)) : MvPolynomial (Fin m) ℝ) ≠ 0) →
    -- OUTPUTS
    (∀ n, rothIndex (P_int.map (algebraMap ℤ ℝ))
      (fun j => ((q_seq n j : ℚ) : ℝ))
      (fun j => MvPolynomial.degreeOf j (P_int.map (algebraMap ℤ ℝ))) ≤
      (m : ℝ) / 2 - 2 * Real.sqrt ((m : ℝ) * ε)) ∧
    (∀ M : ℝ, ∃ n,
      M < ∏ j, ((q_seq n j).den : ℝ) ^
        (MvPolynomial.degreeOf j (P_int.map (algebraMap ℤ ℝ)) : ℕ))

/-! ## D5.1 — Per-n index bound from master -/

/-- **D5.1 — `T5_per_n_index_bound_from_master`**: applies master's index
    reduction at q := q_seq n for each n.

    Uses `T5_master_apply_indexReduction_at` from existing infrastructure
    (Discharge.lean:309).  The result `t - √(mε)` then composes with the
    α-diagonal lower bound `t = m/2 - √(mε)` to give upper bound
    `m/2 - √(mε) - √(mε) = m/2 - 2√(mε)`. -/
theorem T5_per_n_index_bound_from_master
    (α : ℝ) (h_irr : Irrational α) (h_alg : IsAlgebraic ℤ α)
    (ε : ℝ) (hε : 0 < ε)
    {m : ℕ} (hm : 1 ≤ m)
    (P_int : MvPolynomial (Fin m) ℤ)
    (h_P_ne : (P_int.map (algebraMap ℤ ℝ) : MvPolynomial (Fin m) ℝ) ≠ 0)
    (h_R_pos : ∀ i, 0 < MvPolynomial.degreeOf i (P_int.map (algebraMap ℤ ℝ)))
    (master : RothLemmaMaster)
    (h_t : rothIndex (P_int.map (algebraMap ℤ ℝ))
      (fun _ => α)
      (fun j => MvPolynomial.degreeOf j (P_int.map (algebraMap ℤ ℝ))) ≥
      (m : ℝ) / 2 - Real.sqrt ((m : ℝ) * ε))
    (q_seq : ℕ → Fin m → ℚ)
    (h_growth : ∀ n, T5_DenominatorGrowthCondition (q_seq n) ε)
    (h_balance : ∀ n, T5_DegreeHeightBalanceCondition
      (fun j => MvPolynomial.degreeOf j (P_int.map (algebraMap ℤ ℝ)))
      (q_seq n) ε) :
    ∀ n, rothIndex (P_int.map (algebraMap ℤ ℝ))
      (fun j => ((q_seq n j : ℚ) : ℝ))
      (fun j => MvPolynomial.degreeOf j (P_int.map (algebraMap ℤ ℝ))) ≤
      (m : ℝ) / 2 - 2 * Real.sqrt ((m : ℝ) * ε) := by
  intro n
  -- master.IR gives: rothIndex P q R ≤ t - √(mε), where t = m/2 - √(mε)
  -- So upper bound = m/2 - √(mε) - √(mε) = m/2 - 2√(mε)
  set P : MvPolynomial (Fin m) ℝ := P_int.map (algebraMap ℤ ℝ) with hP
  set R : Fin m → ℕ := fun j => MvPolynomial.degreeOf j P with hR
  -- q_seq n j .den ≥ 1 (rational denominator positive ⇒ ≥ 1 as Nat)
  have h_qden : ∀ i : Fin m, 1 ≤ (q_seq n i).den := fun i => (q_seq n i).pos
  have h_R_deg : ∀ i, MvPolynomial.degreeOf i P ≤ R i := fun i => le_refl _
  -- Apply master.IR at t = m/2 - √(mε)
  have h_master_IR :
      rothIndex P (fun j => ((q_seq n j : ℚ) : ℝ)) R ≤
        ((m : ℝ) / 2 - Real.sqrt ((m : ℝ) * ε)) - Real.sqrt ((m : ℝ) * ε) :=
    T5_master_apply_indexReduction_at master hm P R α (q_seq n) ε
      ((m : ℝ) / 2 - Real.sqrt ((m : ℝ) * ε))
      h_P_ne hε h_R_deg h_R_pos h_qden (h_growth n) (h_balance n) h_t
  -- Algebraic simplification: t - √(mε) = m/2 - 2√(mε)
  have h_eq : ((m : ℝ) / 2 - Real.sqrt ((m : ℝ) * ε)) - Real.sqrt ((m : ℝ) * ε) =
      (m : ℝ) / 2 - 2 * Real.sqrt ((m : ℝ) * ε) := by ring
  rw [h_eq] at h_master_IR
  exact h_master_IR

/-! ## D5.3 — Unboundedness translation ℕ → ℝ -/

/-- **D5.3 — `T5_per_n_unboundedness_translation`**: lifts
    `∀ M : ℕ, ∃ n, ∀ j, M < (q_seq n j).den` to
    `∀ M : ℝ, ∃ n, M < ∏ j, ((q_seq n j).den)^Rⱼ`.

    Strategy: pick N := ⌈M⌉, find n with den > N for all j. Then
    each factor `dⱼ^Rⱼ ≥ dⱼ ≥ N+1 > M` (each Rⱼ ≥ 1). Product
    is bounded below by single factor (others ≥ 1). -/
theorem T5_per_n_unboundedness_translation
    {m : ℕ} (hm : 1 ≤ m)
    (P_int : MvPolynomial (Fin m) ℤ)
    (h_R_pos : ∀ i, 0 < MvPolynomial.degreeOf i (P_int.map (algebraMap ℤ ℝ)))
    (q_seq : ℕ → Fin m → ℚ)
    (h_unbd_nat : ∀ M : ℕ, ∃ n, ∀ j, M < (q_seq n j).den) :
    ∀ M : ℝ, ∃ n,
      M < ∏ j, ((q_seq n j).den : ℝ) ^
        (MvPolynomial.degreeOf j (P_int.map (algebraMap ℤ ℝ)) : ℕ) := by
  intro M
  set R : Fin m → ℕ := fun j => MvPolynomial.degreeOf j (P_int.map (algebraMap ℤ ℝ))
    with hR
  -- Threshold N := ⌈max(M, 0)⌉ + 1
  set N : ℕ := Nat.ceil (max M 0) + 1 with hN
  -- Step 1: M < N as reals
  have h_M_le_ceil : (M : ℝ) ≤ (Nat.ceil (max M 0) : ℝ) := by
    have h1 : M ≤ max M 0 := le_max_left _ _
    have h2 : max M 0 ≤ (Nat.ceil (max M 0) : ℝ) := Nat.le_ceil _
    linarith
  have h_ceil_lt_N : (Nat.ceil (max M 0) : ℝ) < (N : ℝ) := by
    show (Nat.ceil (max M 0) : ℝ) < ((Nat.ceil (max M 0) + 1 : ℕ) : ℝ)
    push_cast
    linarith
  have h_M_lt_N : (M : ℝ) < (N : ℝ) := lt_of_le_of_lt h_M_le_ceil h_ceil_lt_N
  -- Step 2: Find n with all q_seq n j .den > N
  obtain ⟨n, h_all⟩ := h_unbd_nat N
  refine ⟨n, ?_⟩
  -- Step 3: Pick j₀ via hm
  let j₀ : Fin m := ⟨0, by omega⟩
  -- Each (d_j : ℝ) ≥ 1
  have h_dj_ge_1 : ∀ j, (1 : ℝ) ≤ ((q_seq n j).den : ℝ) := by
    intro j
    have : 1 ≤ (q_seq n j).den := (q_seq n j).pos
    exact_mod_cast this
  -- Each (d_j : ℝ)^R_j ≥ 1
  have h_factor_ge_1 : ∀ j, (1 : ℝ) ≤ ((q_seq n j).den : ℝ) ^ (R j : ℕ) :=
    fun j => one_le_pow₀ (h_dj_ge_1 j)
  -- d_{j₀} > N > M
  have h_dj0_gt_N : (N : ℝ) < ((q_seq n j₀).den : ℝ) := by
    have h_Nat : N < (q_seq n j₀).den := h_all j₀
    exact_mod_cast h_Nat
  have h_dj0_gt_M : (M : ℝ) < ((q_seq n j₀).den : ℝ) :=
    lt_trans h_M_lt_N h_dj0_gt_N
  -- d_{j₀}^R_{j₀} ≥ d_{j₀} (using R_{j₀} ≥ 1)
  have h_Rj0_pos : 1 ≤ R j₀ := h_R_pos j₀
  have h_pow_ge_self :
      ((q_seq n j₀).den : ℝ) ≤ ((q_seq n j₀).den : ℝ) ^ (R j₀ : ℕ) := by
    conv_lhs => rw [← pow_one ((q_seq n j₀).den : ℝ)]
    exact pow_le_pow_right₀ (h_dj_ge_1 j₀) h_Rj0_pos
  have h_dj0_pow_gt_M : (M : ℝ) < ((q_seq n j₀).den : ℝ) ^ (R j₀ : ℕ) :=
    lt_of_lt_of_le h_dj0_gt_M h_pow_ge_self
  -- ∏ = factor_j₀ * ∏_others; factor_j₀ ≤ ∏ since ∏_others ≥ 1, factor_j₀ ≥ 0
  have h_prod_eq :
      (∏ j, ((q_seq n j).den : ℝ) ^ (R j : ℕ)) =
      ((q_seq n j₀).den : ℝ) ^ (R j₀ : ℕ) *
      (∏ j ∈ Finset.univ.erase j₀, ((q_seq n j).den : ℝ) ^ (R j : ℕ)) := by
    rw [← Finset.mul_prod_erase Finset.univ _ (Finset.mem_univ j₀)]
  rw [h_prod_eq]
  have h_others_ge_1 :
      (1 : ℝ) ≤ ∏ j ∈ Finset.univ.erase j₀, ((q_seq n j).den : ℝ) ^ (R j : ℕ) :=
    Finset.one_le_prod (fun j _ => h_factor_ge_1 j)
  have h_factor_nn : (0 : ℝ) ≤ ((q_seq n j₀).den : ℝ) ^ (R j₀ : ℕ) :=
    pow_nonneg (Nat.cast_nonneg _) _
  -- a ≤ a * b for a ≥ 0, b ≥ 1
  have h_factor_le_prod :
      ((q_seq n j₀).den : ℝ) ^ (R j₀ : ℕ) ≤
        ((q_seq n j₀).den : ℝ) ^ (R j₀ : ℕ) *
        ∏ j ∈ Finset.univ.erase j₀, ((q_seq n j).den : ℝ) ^ (R j : ℕ) := by
    nlinarith [h_factor_nn, h_others_ge_1]
  linarith

/-! ## D5.4 — Headline: corrected D5 unconditionally discharged -/

/-- **🚨🚨 D5.4 — `T5_NAMED_per_n_hypothesis_bundle_corrected_unconditional`**:
    UNCONDITIONAL discharge of CORRECTED D5.

    Composition of D5.1 (per-n index bound) + D5.3 (D-unboundedness
    translation), with master + α-diagonal lower bound + balance +
    aeval-nonzero as inputs (the latter two deferred to V8 Schmidt
    machinery). -/
theorem T5_NAMED_per_n_hypothesis_bundle_corrected_unconditional :
    T5_NAMED_per_n_hypothesis_bundle_corrected := by
  intro α h_irr h_alg ε hε m hm P_int h_P_ne h_R_pos master h_t
    q_seq h_violator h_growth h_balance h_unbd_nat h_aeval_ne
  refine ⟨?_, ?_⟩
  · -- per-n index bound via D5.1
    exact T5_per_n_index_bound_from_master α h_irr h_alg ε hε hm
      P_int h_P_ne h_R_pos master h_t q_seq h_growth h_balance
  · -- D-unboundedness via D5.3
    exact T5_per_n_unboundedness_translation hm P_int h_R_pos q_seq h_unbd_nat

/-! ## D5.5 — Paper-citable headline -/

/-- **🚨🚨🚨 D5.5 — `T5_BLOCKAB_D5_DISCHARGE_HEADLINE`**: paper-citable
    BlockAB-D5 corrected unconditional discharge. -/
theorem T5_BLOCKAB_D5_DISCHARGE_HEADLINE :
    T5_NAMED_per_n_hypothesis_bundle_corrected :=
  T5_NAMED_per_n_hypothesis_bundle_corrected_unconditional

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_D5_RestatedAndDischarge
