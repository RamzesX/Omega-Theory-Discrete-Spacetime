/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_D4_PigeonholeSequence

  T-5 (Roth's theorem) — **BlockAB-D4 UNCONDITIONAL DISCHARGE** —
  iterative pigeonhole sequence construction via diagonal flattening
  of a strict-monotone bumped chain.

  Strategy:
    1. Build a NEW chain `T5_pigeonholeSeq_bumped` with both
       (a) STRICT monotonicity `d_n < d_{n+1}` and
       (b) growth condition `log d_{n+1} ≥ (2/ε) · log d_n`.
       Use `M_n := max(d_n, Nat.ceil(d_n^(2/ε)))` so threshold dominates
       both raw value (for monotonicity) and growth target.
    2. Prove `d_n.den ≥ n + 2` by induction (from strict monotone).
    3. Diagonal flatten: `q_seq n j := T5_pigeonholeSeq_bumped (n*m + j.val)`.
    4. Diagonal growth + diagonal unboundedness from chain properties.
    5. Final discharge: T5_NAMED_iterative_pigeonhole_sequence_unconditional.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTupleDischarge
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockAB_Decomposition

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_D4_PigeonholeSequence

open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTuple
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTupleDischarge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockAB_Decomposition
open Real

/-! ## D4.0 — Bumped chain (strict monotone + growth) -/

/-- **`T5_pigeonholeSeq_bumped`** — recursive ℕ-chain with BOTH strict
    monotonicity AND log-growth condition.

    Threshold `M_n := max(prev.den, Nat.ceil(exp((2/ε) · log prev.den)))`
    dominates both raw value AND `(2/ε)`-power growth target. -/
noncomputable def T5_pigeonholeSeq_bumped
    {S : Set ℚ} (h : T5_HasUnboundedDenominators S) (ε : ℝ) :
    ℕ → ℚ
  | 0 => Classical.choose (h 1)
  | n + 1 =>
    let prev := T5_pigeonholeSeq_bumped h ε n
    let M_n : ℕ := max prev.den
      (Nat.ceil (Real.exp ((2/ε) * Real.log (prev.den : ℝ))))
    Classical.choose (h M_n)

/-- **`T5_pigeonholeSeq_bumped_mem`**: membership in S at every step. -/
theorem T5_pigeonholeSeq_bumped_mem
    {S : Set ℚ} (h : T5_HasUnboundedDenominators S) (ε : ℝ) (n : ℕ) :
    T5_pigeonholeSeq_bumped h ε n ∈ S := by
  induction n with
  | zero =>
    show Classical.choose (h 1) ∈ S
    exact (Classical.choose_spec (h 1)).1
  | succ k _ =>
    let prev := T5_pigeonholeSeq_bumped h ε k
    let M_k : ℕ := max prev.den
      (Nat.ceil (Real.exp ((2/ε) * Real.log (prev.den : ℝ))))
    show Classical.choose (h M_k) ∈ S
    exact (Classical.choose_spec (h M_k)).1

/-- **`T5_pigeonholeSeq_bumped_strict_mono`**: strict monotonicity of
    the denominator chain.  Critical for induction `d_n ≥ n + 2`. -/
theorem T5_pigeonholeSeq_bumped_strict_mono
    {S : Set ℚ} (h : T5_HasUnboundedDenominators S) (ε : ℝ) (n : ℕ) :
    (T5_pigeonholeSeq_bumped h ε n).den <
      (T5_pigeonholeSeq_bumped h ε (n+1)).den := by
  set prev := T5_pigeonholeSeq_bumped h ε n with hprev
  set M_n : ℕ := max prev.den
    (Nat.ceil (Real.exp ((2/ε) * Real.log (prev.den : ℝ)))) with hM
  -- (n+1)-th element = Classical.choose (h M_n), with den > M_n
  have h_chosen : M_n < (Classical.choose (h M_n)).den :=
    (Classical.choose_spec (h M_n)).2
  -- prev.den ≤ M_n (left arg of max)
  have h_max : prev.den ≤ M_n := le_max_left _ _
  show prev.den < (T5_pigeonholeSeq_bumped h ε (n+1)).den
  -- definitional unfold of (n+1) case
  show prev.den < (Classical.choose (h M_n)).den
  exact lt_of_le_of_lt h_max h_chosen

/-- **`T5_pigeonholeSeq_bumped_growth`**: log-growth condition (Hindry-Silverman D.6). -/
theorem T5_pigeonholeSeq_bumped_growth
    {S : Set ℚ} (h : T5_HasUnboundedDenominators S) (ε : ℝ) (n : ℕ) :
    Real.log ((T5_pigeonholeSeq_bumped h ε (n+1)).den : ℝ) ≥
      (2/ε) * Real.log ((T5_pigeonholeSeq_bumped h ε n).den : ℝ) := by
  set prev := T5_pigeonholeSeq_bumped h ε n with hprev
  set X : ℝ := Real.exp ((2/ε) * Real.log (prev.den : ℝ)) with hX
  set M_n : ℕ := max prev.den (Nat.ceil X) with hM
  have h_chosen : M_n < (Classical.choose (h M_n)).den :=
    (Classical.choose_spec (h M_n)).2
  have h_max_ceil : Nat.ceil X ≤ M_n := le_max_right _ _
  -- Coerce M_n inequality up to ℝ via Nat.ceil
  have h_ceil_lt : (Nat.ceil X : ℝ) < ((Classical.choose (h M_n)).den : ℝ) := by
    have h_lt_nat : Nat.ceil X < (Classical.choose (h M_n)).den :=
      lt_of_le_of_lt h_max_ceil h_chosen
    exact_mod_cast h_lt_nat
  have h_X_le_ceil : X ≤ (Nat.ceil X : ℝ) := Nat.le_ceil X
  have h_X_lt : X < ((Classical.choose (h M_n)).den : ℝ) :=
    lt_of_le_of_lt h_X_le_ceil h_ceil_lt
  have h_X_pos : (0 : ℝ) < X := Real.exp_pos _
  have h_pos : (0 : ℝ) < ((Classical.choose (h M_n)).den : ℝ) := by linarith
  have h_logX : Real.log X = (2/ε) * Real.log (prev.den : ℝ) := by
    simp [hX, Real.log_exp]
  have h_log_le : Real.log X ≤
      Real.log ((Classical.choose (h M_n)).den : ℝ) :=
    (Real.log_le_log_iff h_X_pos h_pos).mpr (le_of_lt h_X_lt)
  rw [h_logX] at h_log_le
  show Real.log ((T5_pigeonholeSeq_bumped h ε (n+1)).den : ℝ) ≥
      (2/ε) * Real.log (prev.den : ℝ)
  -- (n+1)-th term unfolds to Classical.choose (h M_n)
  show Real.log ((Classical.choose (h M_n)).den : ℝ) ≥
      (2/ε) * Real.log (prev.den : ℝ)
  exact h_log_le

/-- **`T5_pigeonholeSeq_bumped_den_ge`**: `d_n.den ≥ n + 2` by induction
    using strict monotonicity (denominator is `ℕ`-valued, increment ≥ 1). -/
theorem T5_pigeonholeSeq_bumped_den_ge
    {S : Set ℚ} (h : T5_HasUnboundedDenominators S) (ε : ℝ) (n : ℕ) :
    n + 2 ≤ (T5_pigeonholeSeq_bumped h ε n).den := by
  induction n with
  | zero =>
    -- d_0 = Classical.choose (h 1) with 1 < d_0.den
    have h_gt : 1 < (Classical.choose (h 1)).den :=
      (Classical.choose_spec (h 1)).2
    show 0 + 2 ≤ (T5_pigeonholeSeq_bumped h ε 0).den
    show 0 + 2 ≤ (Classical.choose (h 1)).den
    omega
  | succ k ih =>
    have h_step :
        (T5_pigeonholeSeq_bumped h ε k).den <
        (T5_pigeonholeSeq_bumped h ε (k+1)).den :=
      T5_pigeonholeSeq_bumped_strict_mono h ε k
    omega

/-! ## D4.1 — Diagonal sequence -/

/-- **`T5_pigeonholeSeq_diagonal`**: doubly-indexed `ℕ → Fin m → ℚ`
    family obtained by diagonal flattening.

    `q_seq n j := T5_pigeonholeSeq_bumped h ε (n * m + j.val)`.
    Within-tuple growth = chain growth at adjacent indices. -/
noncomputable def T5_pigeonholeSeq_diagonal
    {S : Set ℚ} (h : T5_HasUnboundedDenominators S) (ε : ℝ) (m : ℕ) :
    ℕ → Fin m → ℚ :=
  fun n j => T5_pigeonholeSeq_bumped h ε (n * m + j.val)

/-- **`T5_pigeonholeSeq_diagonal_mem`**: every element lies in S. -/
theorem T5_pigeonholeSeq_diagonal_mem
    {S : Set ℚ} (h : T5_HasUnboundedDenominators S) (ε : ℝ) (m : ℕ)
    (n : ℕ) (j : Fin m) :
    T5_pigeonholeSeq_diagonal h ε m n j ∈ S :=
  T5_pigeonholeSeq_bumped_mem h ε (n * m + j.val)

/-! ## D4.2 — Diagonal growth -/

/-- **`T5_pigeonholeSeq_diagonal_growth`**: per-tuple growth condition. -/
theorem T5_pigeonholeSeq_diagonal_growth
    {α ε : ℝ} {m : ℕ}
    (h_unbd : T5_HasUnboundedDenominators (T5_RothViolatingSet α ε))
    (n : ℕ) :
    T5_DenominatorGrowthCondition
      (T5_pigeonholeSeq_diagonal h_unbd ε m n) ε := by
  intro i h_succ
  -- Goal in terms of bumped chain at (n * m + (i.val + 1)) and (n * m + i.val)
  show Real.log
      ((T5_pigeonholeSeq_bumped h_unbd ε (n * m + (i.val + 1))).den : ℝ) ≥
    (2/ε) * Real.log
      ((T5_pigeonholeSeq_bumped h_unbd ε (n * m + i.val)).den : ℝ)
  -- Reindex (n * m + (i.val + 1)) = (n * m + i.val) + 1
  have h_eq : n * m + (i.val + 1) = (n * m + i.val) + 1 := by ring
  rw [h_eq]
  exact T5_pigeonholeSeq_bumped_growth h_unbd ε (n * m + i.val)

/-! ## D4.3+D4.4 — Diagonal unboundedness -/

/-- **`T5_pigeonholeSeq_diagonal_unbounded`**: ∀ M, ∃ n with all
    coordinates having denominator > M.

    From strict monotone `d_k ≥ k + 2`: pick n = M to get
    n*m + j.val ≥ n ≥ M, hence d ≥ M + 2 > M. -/
theorem T5_pigeonholeSeq_diagonal_unbounded
    {α ε : ℝ} {m : ℕ} (hm : 1 ≤ m)
    (h_unbd : T5_HasUnboundedDenominators (T5_RothViolatingSet α ε)) :
    ∀ M : ℕ, ∃ n, ∀ j : Fin m,
      M < (T5_pigeonholeSeq_diagonal h_unbd ε m n j).den := by
  intro M
  refine ⟨M, ?_⟩
  intro j
  show M < (T5_pigeonholeSeq_bumped h_unbd ε (M * m + j.val)).den
  -- d_{M*m + j.val}.den ≥ M*m + j.val + 2
  have h_lower : M * m + j.val + 2 ≤
      (T5_pigeonholeSeq_bumped h_unbd ε (M * m + j.val)).den :=
    T5_pigeonholeSeq_bumped_den_ge h_unbd ε (M * m + j.val)
  -- M ≤ M*m since m ≥ 1
  have h_mge : M ≤ M * m := Nat.le_mul_of_pos_right M (by omega)
  omega

/-! ## D4.5 — Headline: T5_NAMED_iterative_pigeonhole_sequence UNCONDITIONALLY DISCHARGED -/

/-- **🚨🚨 D4.5 — `T5_NAMED_iterative_pigeonhole_sequence_unconditional`**:
    UNCONDITIONAL discharge of BlockAB-D4 NAMED hypothesis.

    Witness: `q_seq n j := T5_pigeonholeSeq_bumped h_unbd ε (n*m + j.val)`.
    The `h_pigeon : T5_PigeonholeMTuple_Statement` hypothesis is unused
    (the bumped chain provides everything needed directly). -/
theorem T5_NAMED_iterative_pigeonhole_sequence_unconditional :
    T5_NAMED_iterative_pigeonhole_sequence := by
  intro α _hα ε _hε m hm _h_pigeon h_unbd
  refine ⟨T5_pigeonholeSeq_diagonal h_unbd ε m, ?_, ?_, ?_⟩
  · intro n j
    exact T5_pigeonholeSeq_diagonal_mem h_unbd ε m n j
  · intro n
    exact T5_pigeonholeSeq_diagonal_growth h_unbd n
  · exact T5_pigeonholeSeq_diagonal_unbounded hm h_unbd

/-! ## D4.6 — Paper-citable headline -/

/-- **🚨🚨🚨 D4.6 — `T5_BLOCKAB_D4_DISCHARGE_HEADLINE`**: paper-citable
    BlockAB-D4 unconditional discharge.

    Combined with D1 (T5_BLOCKAB_D1_DISCHARGE_HEADLINE) and the existing
    BlockAB-D2/D3 leaves, reduces Block A+B closure path to D5 (per-n
    bundle, requires restatement) only. -/
theorem T5_BLOCKAB_D4_DISCHARGE_HEADLINE :
    T5_NAMED_iterative_pigeonhole_sequence :=
  T5_NAMED_iterative_pigeonhole_sequence_unconditional

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_D4_PigeonholeSequence
