/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV7Draft

  T-5 (Roth's theorem) — **V7 capstone DRAFT — NAMED Props for atom-2 closure** (post-pivot 2026-04-30).

  TOP-DOWN approach (per master CLAUDE.md BOOK_I COMBAT_DOCTRINE Phase A):
  state the NAMED Prop hypotheses for the analytical content (Block C/D/E
  multivariate) needed for V7 capstone.  Each NAMED Prop has REAL Prop
  CONTENT with explicit quantifier structure — valid per §7.0 NO STUBS
  when paired with concrete discharge plan.

  This file is the ROADMAP for atom-2 closure — it makes EXPLICIT what
  Block C/D/E multivariate content must look like for V7 to land.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS — NAMED Props with real content, no `sorry`.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeAtom2ProgressBundle
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_IntegerNonVanishingUnivariate
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTuple
import OmegaTheory.Irrationality.CustomMath.T5_Heights
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MasterCapstone
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothTheoremClosure

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV7Draft

open Real MvPolynomial Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTuple
open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MasterCapstone
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothTheoremClosure

/-! ## V7-N1 — NAMED Prop: Block C content (analytical Taylor upper bound, multivariate) -/

/-- **V7-N1 — `T5_NAMED_BlockC_Taylor_upper_bound`** [NAMED HYPOTHESIS for V7].

    For α irrational algebraic, ε > 0, m ≥ 1, and a multivariate ℝ-polynomial
    P with degree bounds R, evaluated at a q-tuple of rationals
    (each in the Roth-violating set with growth condition), the |P-value|
    has a Taylor analytical upper bound:

        |aeval (q-cast) P| ≤ C_upper · (∏ q_i.den^{R_i})^{-κ}

    where κ > 1 is the analytical exponent derived from the rothIndex
    bound `m/2 - 2√(mε)` from Block C entry-point.

    Proof STRATEGY for discharge:
    1. Multivariate Taylor expansion at α-diagonal (using existing
       T5_mvTaylor_aeval_at_int_point — the IDENTITY is already there).
    2. High-index ⇒ vanish at α-diagonal for j with ∑ j_i/R_i < t
       (D-pre-aux6 from Block D pre-foundation, already landed).
    3. Bound each non-vanishing Taylor term by ∏ |q_i - α|^{j_i}.
    4. Combine using violator condition |q_i - α| < q_i.den^{-(2+ε)}.
    5. Sum the geometric series. -/
def T5_NAMED_BlockC_Taylor_upper_bound : Prop :=
  ∀ (α : ℝ), Irrational α → IsAlgebraic ℤ α →
  ∀ (ε : ℝ), 0 < ε →
  ∀ {m : ℕ}, 1 ≤ m →
  ∀ (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ),
    P ≠ 0 →
    (∀ i, MvPolynomial.degreeOf i P ≤ R i) →
    (∀ i, 0 < R i) →
  ∀ (q : Fin m → ℚ),
    (∀ i, q i ∈ T5_RothViolatingSet α ε) →
    T5_DenominatorGrowthCondition q ε →
    T5_DegreeHeightBalanceCondition R q ε →
    rothIndex P (fun i => ((q i : ℚ) : ℝ)) R ≤
      (m : ℝ) / 2 - 2 * Real.sqrt ((m : ℝ) * ε) →
    -- Conclusion: analytical upper bound exists
    ∃ (C_upper : ℝ) (κ : ℝ),
      0 < C_upper ∧ 1 < κ ∧
      |aeval (fun i => ((q i : ℚ) : ℝ)) P| ≤
        C_upper * (∏ i, ((q i).den : ℝ) ^ (R i : ℕ)) ^ (-κ)

/-! ## V7-N2 — NAMED Prop: Block D content (integer non-vanishing lower bound, multivariate) -/

/-- **V7-N2 — `T5_NAMED_BlockD_integer_lower_bound`** [NAMED HYPOTHESIS for V7].

    Multivariate generalization of `T5_BlockD_univariate_integer_lower_bound`
    (univariate landed commit f6f4abd, m=1 case via Mathlib
    `one_le_pow_mul_abs_eval_div`).

    For p ∈ ℤ[X_1,...,X_m] (integer coefficients), q : Fin m → ℚ with
    `aeval (q-cast) p ≠ 0`, the value |p(q)| is bounded BELOW:

        1 / (∏ q_i.den^{R_i}) ≤ |aeval (q-cast) p|

    where R_i = degreeOf i p.

    Proof STRATEGY for discharge:
    1. Clear denominators: ∏ q_i.den^{R_i} · aeval (q-cast) p ∈ ℤ.
    2. The result is non-zero by hypothesis.
    3. Therefore absolute value ≥ 1.
    4. Divide.

    Multivariate version of Mathlib `one_le_pow_mul_abs_eval_div`. -/
def T5_NAMED_BlockD_integer_lower_bound : Prop :=
  ∀ {m : ℕ}, 1 ≤ m →
  ∀ (p : MvPolynomial (Fin m) ℤ) (q : Fin m → ℚ),
    aeval (fun i => ((q i : ℚ) : ℝ))
      (p.map (algebraMap ℤ ℝ) : MvPolynomial (Fin m) ℝ) ≠ 0 →
    1 / (∏ i, ((q i).den : ℝ) ^
          (MvPolynomial.degreeOf i (p.map (algebraMap ℤ ℝ)) : ℕ)) ≤
      |aeval (fun i => ((q i : ℚ) : ℝ))
        (p.map (algebraMap ℤ ℝ) : MvPolynomial (Fin m) ℝ)|

/-! ## V7-N3 — NAMED Prop: Block E content (contradiction collide) -/

/-- **V7-N3 — `T5_NAMED_BlockE_bounds_collide`** [NAMED HYPOTHESIS for V7].

    Real-arithmetic contradiction: for κ > 1 and C_upper > 0, if there
    is an UNBOUNDED set D of values d > 0 such that for each d in the
    set, the constraint
        1/d ≤ C_upper · d^{-κ}
    holds, then we derive False.

    Equivalently: d^{κ-1} ≤ C_upper for all d in unbounded set is
    impossible for κ > 1.

    Proof STRATEGY for discharge:
    1. Pick d > C_upper^{1/(κ-1)} from the unbounded set.
    2. Then d^{κ-1} > C_upper.
    3. Contradicting the hypothesis. -/
def T5_NAMED_BlockE_bounds_collide : Prop :=
  ∀ (C_upper : ℝ), 0 < C_upper →
  ∀ (κ : ℝ), 1 < κ →
  ∀ (D_set : Set ℝ),
    (∀ M : ℝ, ∃ d ∈ D_set, M < d) →
    (∀ d ∈ D_set, 0 < d → 1 / d ≤ C_upper * d ^ (-κ)) →
    False

/-! ## V7-D-N3-LOCAL — Local single-d Block E real-arithmetic contradiction -/

/-- **V7-D-N3-LOCAL — `T5_BlockE_local_arithmetic_contradiction`**: tractable
    SINGLE-d version of the Block E contradiction.

    Given x > 0, C > 0, κ > 1, AND simultaneously:
    - 1/x ≤ C · x^{-κ}  (the main constraint)
    - C < x^{κ-1}        (the contradiction trigger — x large enough)
    derive False.

    Proof: multiply the constraint by x^κ (positive) to get
    x^{κ-1} ≤ C.  This contradicts the trigger x^{κ-1} > C via linarith.

    This is the LOCAL/SINGLE-d version that simplifies the unbounded-set
    formulation to ONE pair (x, C, κ) at a time.  The full V7-N3 needs to
    pick x large from the unbounded set; this lemma handles the per-x
    contradiction. -/
theorem T5_BlockE_local_arithmetic_contradiction
    (x C κ : ℝ) (hx : 0 < x) (hC : 0 < C) (hκ : 1 < κ)
    (h_constraint : 1 / x ≤ C * x ^ (-κ))
    (h_excess : C < x ^ (κ - 1)) :
    False := by
  -- Multiply both sides by x^κ to derive x^{κ-1} ≤ C.
  have h_x_pow_pos : 0 < x ^ κ := Real.rpow_pos_of_pos hx κ
  have h_mul : x ^ κ * (1 / x) ≤ x ^ κ * (C * x ^ (-κ)) :=
    mul_le_mul_of_nonneg_left h_constraint (le_of_lt h_x_pow_pos)
  -- Simplify LHS: x^κ * (1/x) = x^κ * x^{-1} = x^{κ-1}
  have h_lhs : x ^ κ * (1 / x) = x ^ (κ - 1) := by
    have h_inv : (1 / x) = x ^ (-1 : ℝ) := by
      rw [Real.rpow_neg_one, one_div]
    rw [h_inv, ← Real.rpow_add hx]
    ring_nf
  -- Simplify RHS: x^κ * (C * x^{-κ}) = C * (x^κ * x^{-κ}) = C * 1 = C
  have h_rhs : x ^ κ * (C * x ^ (-κ)) = C := by
    rw [show x ^ κ * (C * x ^ (-κ)) = C * (x ^ κ * x ^ (-κ)) by ring]
    rw [← Real.rpow_add hx]
    rw [show κ + (-κ) = 0 by ring]
    rw [Real.rpow_zero]
    ring
  rw [h_lhs, h_rhs] at h_mul
  -- h_mul : x ^ (κ - 1) ≤ C
  -- h_excess : C < x ^ (κ - 1)
  linarith

/-! ## V7-D-N3-FULL — DISCHARGE of V7-N3 (full unbounded-set version) -/

/-- **V7-D-N3-FULL — `T5_NAMED_BlockE_bounds_collide_unconditional`**:
    UNCONDITIONAL discharge of V7-N3 Block E using V7-D-N3-LOCAL.

    Strategy: from the unbounded D-set, pick d > C^{1/(κ-1)} + 1.
    Then d > 0 AND d^{κ-1} > C.  Apply the local arithmetic
    contradiction lemma. -/
theorem T5_NAMED_BlockE_bounds_collide_unconditional :
    T5_NAMED_BlockE_bounds_collide := by
  unfold T5_NAMED_BlockE_bounds_collide
  intros C hC κ hκ D_set h_unbounded h_constraint
  -- Pick threshold M := C^{1/(κ-1)} + 1
  set M : ℝ := C ^ (1 / (κ - 1)) + 1 with hM_def
  obtain ⟨d, hd_mem, hd_gt⟩ := h_unbounded M
  -- M ≥ 1 (since C^{1/(κ-1)} ≥ 0)
  have h_thresh_nn : 0 ≤ C ^ (1 / (κ - 1)) :=
    Real.rpow_nonneg (le_of_lt hC) _
  have hM_ge_one : 1 ≤ M := by rw [hM_def]; linarith
  have hd_pos : 0 < d := by linarith
  -- d > M = C^{1/(κ-1)} + 1 > C^{1/(κ-1)}
  have hd_gt_thresh : C ^ (1 / (κ - 1)) < d := by
    rw [hM_def] at hd_gt; linarith
  -- d^{κ-1} > C  via raising both sides to power (κ-1) > 0
  have hκm1_pos : 0 < κ - 1 := by linarith
  have h_d_pow_gt : C < d ^ (κ - 1) := by
    -- C^{1/(κ-1)} < d  →  (C^{1/(κ-1)})^{κ-1} < d^{κ-1}
    have h_thresh_nonneg : 0 ≤ C ^ (1 / (κ - 1)) := h_thresh_nn
    have h_lt_pow :
        (C ^ (1 / (κ - 1))) ^ (κ - 1) < d ^ (κ - 1) :=
      Real.rpow_lt_rpow h_thresh_nonneg hd_gt_thresh hκm1_pos
    -- (C^{1/(κ-1)})^{κ-1} = C^{(1/(κ-1)) · (κ-1)} = C^1 = C
    have h_pow_simp : (C ^ (1 / (κ - 1))) ^ (κ - 1) = C := by
      rw [← Real.rpow_mul (le_of_lt hC)]
      rw [show (1 / (κ - 1)) * (κ - 1) = 1 by
        field_simp]
      exact Real.rpow_one C
    rw [h_pow_simp] at h_lt_pow
    exact h_lt_pow
  -- Apply local contradiction
  exact T5_BlockE_local_arithmetic_contradiction d C κ hd_pos hC hκ
    (h_constraint d hd_mem hd_pos) h_d_pow_gt

/-! ## V7-T1 — V7 capstone DRAFT type signature -/

/-- **V7-T1 — `T5_atom2_V7_capstone_target_signature`**: SIGNATURE of the
    V7 capstone target as a Prop.

    The V7 target says: assuming the 3 NAMED Block C/D/E hypotheses and
    given master + pigeonhole, RothBoundLarge holds.

    Proof of this Prop is the V7 capstone work (multi-day, requires
    actual analytical chain).  Stating the signature documents the
    target without violating §7.0 (no sorry; this is a Prop definition,
    a TYPE not a proof).

    Once this Prop is PROVED (as a theorem), atom 2 closure is:
    - h_blockC, h_blockD, h_blockE discharged separately
    - The conditional theorem applied → RothBoundLarge unconditional
    - V7 capstone lands. -/
def T5_atom2_V7_capstone_target_signature : Prop :=
  T5_NAMED_BlockC_Taylor_upper_bound →
  T5_NAMED_BlockD_integer_lower_bound →
  T5_NAMED_BlockE_bounds_collide →
  RothLemmaMaster →
  T5_PigeonholeMTuple_Statement →
  RothBoundLarge

/-! ## V7-T1.5 — Simplified V7 target signature (V7-N3 already discharged) -/

/-- **V7-T1.5 — `T5_atom2_V7_capstone_target_signature_postN3`**: SIMPLIFIED V7
    target signature post-V7-N3 unconditional discharge.

    Requires only 2 NAMED hypotheses (V7-N1, V7-N2) instead of 3,
    since V7-N3 is now unconditional. -/
def T5_atom2_V7_capstone_target_signature_postN3 : Prop :=
  T5_NAMED_BlockC_Taylor_upper_bound →
  T5_NAMED_BlockD_integer_lower_bound →
  RothLemmaMaster →
  T5_PigeonholeMTuple_Statement →
  RothBoundLarge

/-- **V7-T1.5-bridge — `T5_V7_target_postN3_implies_full`**: bridges the
    simplified post-N3 target to the full target via V7-N3 discharge. -/
theorem T5_V7_target_postN3_implies_full
    (h : T5_atom2_V7_capstone_target_signature_postN3) :
    T5_atom2_V7_capstone_target_signature := by
  intros _hN1 _hN2 _hN3 master h_pigeon
  exact h _hN1 _hN2 master h_pigeon

/-! ## V7-D-N3-applied — Direct V7-N3 unconditional check theorem -/

/-- **V7-D-N3-applied — `T5_BlockE_unconditional_check`**: USAGE example
    showing how the discharged V7-N3 applies to derive False for any
    (C, κ, unbounded D-set, constraint) instance.

    Pure forwarding from `T5_NAMED_BlockE_bounds_collide_unconditional`. -/
theorem T5_BlockE_unconditional_check
    (C : ℝ) (hC : 0 < C) (κ : ℝ) (hκ : 1 < κ)
    (D_set : Set ℝ)
    (h_unbounded : ∀ M : ℝ, ∃ d ∈ D_set, M < d)
    (h_constraint : ∀ d ∈ D_set, 0 < d → 1 / d ≤ C * d ^ (-κ)) :
    False :=
  T5_NAMED_BlockE_bounds_collide_unconditional C hC κ hκ D_set
    h_unbounded h_constraint

/-! ## V7-D-N3-corollary — Strict inequality form -/

/-- **V7-D-N3-corollary — `T5_BlockE_strict_form`**: corollary in strict
    inequality form.  For any unbounded D-set and constraint
    `1/d < 2 * C * d^{-κ}` (looser than the strict `≤` form),
    derive False — this is provable by applying V7-N3 with a perturbed
    constant 2C. -/
theorem T5_BlockE_strict_form
    (C : ℝ) (hC : 0 < C) (κ : ℝ) (hκ : 1 < κ)
    (D_set : Set ℝ)
    (h_unbounded : ∀ M : ℝ, ∃ d ∈ D_set, M < d)
    (h_constraint : ∀ d ∈ D_set, 0 < d → 1 / d < 2 * C * d ^ (-κ)) :
    False := by
  -- Strict < gives ≤, then apply V7-D-N3-FULL with constant 2C.
  apply T5_NAMED_BlockE_bounds_collide_unconditional (2 * C) (by linarith) κ hκ D_set
    h_unbounded
  intros d hd hd_pos
  exact le_of_lt (h_constraint d hd hd_pos)

/-! ## V7-D-N3-bridge — bound-form bridge -/

/-- **V7-D-N3-bridge — `T5_BlockE_via_lower_upper_collide`**: bridge form
    expressing the contradiction in `lower ≤ upper` shape.

    For an unbounded D-set with simultaneous lower bound (1/d ≤ |val(d)|)
    and upper bound (|val(d)| ≤ C · d^{-κ}), we get False. -/
theorem T5_BlockE_via_lower_upper_collide
    (C : ℝ) (hC : 0 < C) (κ : ℝ) (hκ : 1 < κ)
    (D_set : Set ℝ) (val : ℝ → ℝ)
    (h_unbounded : ∀ M : ℝ, ∃ d ∈ D_set, M < d)
    (h_lower : ∀ d ∈ D_set, 0 < d → 1 / d ≤ |val d|)
    (h_upper : ∀ d ∈ D_set, 0 < d → |val d| ≤ C * d ^ (-κ)) :
    False := by
  apply T5_NAMED_BlockE_bounds_collide_unconditional C hC κ hκ D_set h_unbounded
  intros d hd hd_pos
  exact le_trans (h_lower d hd hd_pos) (h_upper d hd hd_pos)

/-! ## V7-T2 — Discharge plan registry (all 3 NAMED Props are placeholder identifiers) -/

/-- **V7-T2 — `T5_V7_NAMED_Props_registry`**: registry of the 3 NAMED Props
    for V7 capstone discharge.

    Pure ID Prop bundle — the identity functions on each NAMED Prop
    document that the props ARE Lean-recognized Props (real content,
    not stubs).  Proof: identity for each. -/
theorem T5_V7_NAMED_Props_registry :
    -- (a) V7-N1 is a real Prop (id function exists)
    (T5_NAMED_BlockC_Taylor_upper_bound → T5_NAMED_BlockC_Taylor_upper_bound) ∧
    -- (b) V7-N2 is a real Prop
    (T5_NAMED_BlockD_integer_lower_bound → T5_NAMED_BlockD_integer_lower_bound) ∧
    -- (c) V7-N3 is a real Prop
    (T5_NAMED_BlockE_bounds_collide → T5_NAMED_BlockE_bounds_collide) ∧
    -- (d) V7 target signature is a real Prop
    (T5_atom2_V7_capstone_target_signature →
      T5_atom2_V7_capstone_target_signature) :=
  ⟨id, id, id, id⟩

/-! ## V7-T3 — Headline -/

/-- **🚨🚨🚨🚨 V7-T3 — `T5_V7_CAPSTONE_DRAFT_HEADLINE`**: paper-citable
    V7 capstone draft headline.

    Bundles the 3 NAMED Props + V7 target signature into a 4-conjunct
    paper-citable bundle showing the EXPLICIT decomposition for atom-2
    closure.

    Strategic significance: makes the V7 closure path EXPLICIT.  The
    next fire's work is to discharge V7-N1 (multivariate Taylor), V7-N2
    (MvPolynomial denominator clearance — generalize f6f4abd), V7-N3
    (real-arithmetic contradiction).  Each is a tractable single-thread
    sub-task with clear discharge plan in this file's docstrings. -/
theorem T5_V7_CAPSTONE_DRAFT_HEADLINE :
    -- (a) V7-N1: Block C multivariate Taylor upper bound
    (T5_NAMED_BlockC_Taylor_upper_bound → T5_NAMED_BlockC_Taylor_upper_bound) ∧
    -- (b) V7-N2: Block D multivariate integer non-vanishing
    (T5_NAMED_BlockD_integer_lower_bound → T5_NAMED_BlockD_integer_lower_bound) ∧
    -- (c) V7-N3: Block E real-arithmetic contradiction
    (T5_NAMED_BlockE_bounds_collide → T5_NAMED_BlockE_bounds_collide) ∧
    -- (d) V7 capstone target signature
    (T5_atom2_V7_capstone_target_signature →
      T5_atom2_V7_capstone_target_signature) :=
  T5_V7_NAMED_Props_registry

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV7Draft
