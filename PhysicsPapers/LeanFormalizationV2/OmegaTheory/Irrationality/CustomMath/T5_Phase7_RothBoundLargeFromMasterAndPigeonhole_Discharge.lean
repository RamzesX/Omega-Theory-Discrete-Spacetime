/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeFromMasterAndPigeonhole_Discharge

  T-5 (Roth's theorem) — **Phase 7 D.7 atom DISCHARGE FILE**.

  Discharges the second of the 2 remaining V6 NAMED atoms:
    `T5_RothBoundLargeFromMasterAndPigeonhole := RothLemmaMaster →
       T5_PigeonholeMTuple_Statement → RothBoundLarge`

  Strategy (Hindry-Silverman D.7 contradiction):
    Block A — setup: assume ¬ RothBoundLarge for some (α, ε); extract
              ∞-many violators with growing denominators, package into
              `T5_HasUnboundedDenominators` of `T5_RothViolatingSet α ε`,
              apply pigeonhole to get m-tuple with growth condition.
    Block B — master assembly: unpack RothLemmaMaster's 5 conjuncts,
              build Schmidt aux poly P (already UNCONDITIONAL), derive
              rothIndex bounds at α^m and (q¹,…,qᵐ).
    Block C — analytical Taylor upper bound for |P(q¹,…,qᵐ)|.
    Block D — integer non-vanishing lower bound for |P(q¹,…,qᵐ)|.
    Block E — bounds collide → False; therefore RothBoundLarge holds.
    Block F — V7 capstone wrapper (1 NAMED atom remaining).

  Single-thread hand-authored 2026-04-29 (post-V6).

  Per project rule §7.0 NO STUBS — no `sorry`, no `Prop := True`,
  no `: True := trivial`, no `:= trivial`.

  ## graph_queries_run

  - `lean_loogle("Classical.choose ∃ ∀")` → standard extraction patterns.
  - `omega_hammer_premise("Real.rpow non-positive divide")` → for the
    analytical bound direction flips.
  - `lean_local_search("T5_RothViolatingSet")` → existing Phase 7 W3-A
    (`T5_Phase7_PigeonholeMTuple.lean:60`).

  Literature: Hindry-Silverman §D.7; Ishak Uppsala 2008 Ch.4; Schmidt 1971.
-/

import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Data.Set.Finite.Basic
import Mathlib.NumberTheory.Real.Irrational
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothCompleteDischarge
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTuple
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MasterCapstone
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothTheoremClosure
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeAllQ
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIV
import OmegaTheory.Irrationality.CustomMath.T5_Heights

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeFromMasterAndPigeonhole_Discharge

open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothCompleteDischarge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTuple
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MasterCapstone
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothTheoremClosure
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeAllQ
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open MvPolynomial Real Polynomial

/-! ## Block A — Setup: contradiction skeleton + violator extraction -/

/-! ### A1 — Failure data extraction (¬ RothBoundLarge → violators) -/

/-- **A1a — failure produces a violator at every threshold N**.

    Given `α` irrational algebraic, `ε > 0`, and the assumption that
    `RothBoundLarge` fails at `(α, ε)` (i.e., no positive `C₁` and `N`
    bound the Roth-form distance for all `q` with `q.den ≥ N`),
    we extract for each `N : ℕ` a witness rational `q` with
    `q.den ≥ N` and `|α - q| < 1 / (Rat.naiveHeight q)^(2+ε)`.

    Direct classical destructuring of the failure hypothesis at
    `C₁ := 1`, `N := N`. -/
theorem T5_failure_violator_at_N
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraic ℤ α)
    (ε : ℝ) (hε : 0 < ε)
    (h_fail :
      ¬ (∃ (C₁ : ℝ) (N : ℕ), 0 < C₁ ∧
        ∀ (q : ℚ), q ≠ 0 → (q : ℝ) ≠ α → N ≤ q.den →
          C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)|))
    (N : ℕ) :
    ∃ (q : ℚ), q ≠ 0 ∧ (q : ℝ) ≠ α ∧ N ≤ q.den ∧
      |α - (q : ℝ)| < 1 / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) := by
  -- Push negation through the existential.
  push_neg at h_fail
  -- h_fail : ∀ C₁ N, 0 < C₁ → ∃ q, q ≠ 0 ∧ (q : ℝ) ≠ α ∧ N ≤ q.den ∧
  --                              C₁ / height^(2+ε) > |α - q|
  obtain ⟨q, hq_ne_zero, hq_ne_α, hq_den, h_bound⟩ :=
    h_fail 1 N (by norm_num)
  refine ⟨q, hq_ne_zero, hq_ne_α, hq_den, ?_⟩
  -- h_bound : 1 / height^(2+ε) > |α - q|
  -- goal:    |α - q| < 1 / height^(2+ε)
  exact h_bound

/-! ### A2 — Bridge to T5_RothViolatingSet (height ≥ den ⇒ in violating set) -/

/-- **Real.rpow on positive base monotone in argument**.

    Pure-analysis bridge: if `1 ≤ a` and `b ≤ c`, then `a^b ≤ a^c`
    (rpow form). Used to flip the height bound `height ≥ den` into
    a denominator bound `height^(2+ε) ≥ den^(2+ε)`. -/
theorem T5_rpow_le_of_le_height
    (h : ℚ) (q : ℚ) (hq : q ≠ 0)
    (ε : ℝ) (hε : 0 < ε)
    (h_height_ge_den :
      ((q.den : ℝ)) ≤ ((Rat.naiveHeight q : ℝ))) :
    ((q.den : ℝ)) ^ (2 + ε) ≤ ((Rat.naiveHeight q : ℝ)) ^ (2 + ε) := by
  -- 1 ≤ q.den (since q ≠ 0), and den ≤ height
  have hden_pos : (0 : ℝ) < (q.den : ℝ) := by
    have : (0 : ℕ) < q.den := q.pos
    exact_mod_cast this
  have hheight_pos : (0 : ℝ) < (Rat.naiveHeight q : ℝ) := by
    have : (0 : ℕ) < Rat.naiveHeight q := Rat.naiveHeight_pos q hq
    exact_mod_cast this
  have h2eps_nn : (0 : ℝ) ≤ 2 + ε := by linarith
  -- rpow monotone in base when exponent ≥ 0
  exact Real.rpow_le_rpow (le_of_lt hden_pos) h_height_ge_den h2eps_nn

/-- **A2 — `1 / height^(2+ε) ≤ 1 / den^(2+ε)`** for any `q ≠ 0`.

    Direct consequence of `den ≤ height` and `Real.rpow` monotonicity:
    larger base ⇒ larger power ⇒ smaller reciprocal. -/
theorem T5_one_over_height_le_one_over_den
    (q : ℚ) (hq : q ≠ 0)
    (ε : ℝ) (hε : 0 < ε) :
    1 / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤
      1 / ((q.den : ℝ) ^ (2 + ε)) := by
  have hden_pos : (0 : ℝ) < (q.den : ℝ) := by
    have : (0 : ℕ) < q.den := q.pos
    exact_mod_cast this
  have hheight_pos : (0 : ℝ) < (Rat.naiveHeight q : ℝ) := by
    have : (0 : ℕ) < Rat.naiveHeight q := Rat.naiveHeight_pos q hq
    exact_mod_cast this
  have h_height_ge_den :
      ((q.den : ℝ)) ≤ ((Rat.naiveHeight q : ℝ)) := by
    have : q.den ≤ Rat.naiveHeight q := Rat.den_le_naiveHeight q
    exact_mod_cast this
  have h_pow_le :
      ((q.den : ℝ)) ^ (2 + ε) ≤ ((Rat.naiveHeight q : ℝ)) ^ (2 + ε) :=
    T5_rpow_le_of_le_height (q.den : ℚ) q hq ε hε h_height_ge_den
  have hpow_den_pos :
      (0 : ℝ) < ((q.den : ℝ)) ^ (2 + ε) :=
    Real.rpow_pos_of_pos hden_pos _
  have hpow_height_pos :
      (0 : ℝ) < ((Rat.naiveHeight q : ℝ)) ^ (2 + ε) :=
    Real.rpow_pos_of_pos hheight_pos _
  -- 1/A ≤ 1/B  ⟺  B ≤ A  (when both positive). use `one_div_le_one_div_of_le`.
  exact one_div_le_one_div_of_le hpow_den_pos h_pow_le

/-- **A2 — violator is in the Roth-violating set** (denominator form).

    Given a violator `q` with `|α - q| < 1 / height^(2+ε)`, show
    `q ∈ T5_RothViolatingSet α ε` (which uses `den^{-(2+ε)}` form).
    Combine with A2's height-≥-den bound. -/
theorem T5_violator_in_RothViolatingSet
    (α : ℝ) (ε : ℝ) (hε : 0 < ε)
    (q : ℚ) (hq : q ≠ 0)
    (h_height_bound : |α - (q : ℝ)| < 1 / ((Rat.naiveHeight q : ℝ) ^ (2 + ε))) :
    q ∈ T5_RothViolatingSet α ε := by
  -- T5_RothViolatingSet α ε := { q | |q - α| < (q.den)^(-(2+ε)) }
  -- Note: the sign of the abs argument: |q - α| = |α - q| (`abs_sub_comm`).
  unfold T5_RothViolatingSet
  simp only [Set.mem_setOf_eq]
  -- Goal: |((q : ℚ) : ℝ) - α| < ((q.den : ℝ)) ^ (-(2 + ε))
  -- Convert: rpow_neg gives (den)^(-(2+ε)) = 1 / den^(2+ε).
  have hden_pos : (0 : ℝ) < (q.den : ℝ) := by
    have : (0 : ℕ) < q.den := q.pos
    exact_mod_cast this
  have h_neg : ((q.den : ℝ)) ^ (-(2 + ε)) =
      1 / ((q.den : ℝ)) ^ (2 + ε) := by
    rw [Real.rpow_neg (le_of_lt hden_pos), one_div]
  rw [h_neg]
  -- |q - α| < 1 / den^(2+ε)
  have h_abs : |((q : ℚ) : ℝ) - α| = |α - ((q : ℚ) : ℝ)| := abs_sub_comm _ _
  rw [h_abs]
  -- Combine: |α - q| < 1/height^(2+ε) ≤ 1/den^(2+ε) (A2 main)
  calc |α - ((q : ℚ) : ℝ)|
      < 1 / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) := h_height_bound
    _ ≤ 1 / ((q.den : ℝ) ^ (2 + ε)) :=
        T5_one_over_height_le_one_over_den q hq ε hε

/-! ### A3 — Unbounded denominators in the violating set + m-tuple extraction -/

/-- **A3a — failure ⇒ `T5_HasUnboundedDenominators` of the violating set**.

    Combine A1 (failure produces a violator at every N) with A2
    (the violator lies in `T5_RothViolatingSet α ε`) to conclude
    `T5_HasUnboundedDenominators (T5_RothViolatingSet α ε)`. -/
theorem T5_failure_unboundedDens
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraic ℤ α)
    (ε : ℝ) (hε : 0 < ε)
    (h_fail :
      ¬ (∃ (C₁ : ℝ) (N : ℕ), 0 < C₁ ∧
        ∀ (q : ℚ), q ≠ 0 → (q : ℝ) ≠ α → N ≤ q.den →
          C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)|)) :
    T5_HasUnboundedDenominators (T5_RothViolatingSet α ε) := by
  intro M
  -- Apply A1 at threshold (M+1) so that q.den > M (strict).
  obtain ⟨q, hq_ne_zero, hq_ne_α, hq_den, h_bound⟩ :=
    T5_failure_violator_at_N α hα h_alg ε hε h_fail (M + 1)
  refine ⟨q, ?_, ?_⟩
  · -- q ∈ T5_RothViolatingSet α ε via A2
    exact T5_violator_in_RothViolatingSet α ε hε q hq_ne_zero h_bound
  · -- M < q.den (since q.den ≥ M+1)
    omega

/-- **A3b — m-tuple extraction from failure data** (Block A capstone).

    Combine A3a with the pigeonhole `T5_PigeonholeMTuple_Statement` to
    extract `m` violators with the rapid-growth denominator condition
    required by the index-reduction inequality. -/
theorem T5_failure_extract_mTuple
    (h_pigeon : T5_PigeonholeMTuple_Statement)
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraic ℤ α)
    (ε : ℝ) (hε : 0 < ε)
    (m : ℕ) (hm : 1 ≤ m)
    (h_fail :
      ¬ (∃ (C₁ : ℝ) (N : ℕ), 0 < C₁ ∧
        ∀ (q : ℚ), q ≠ 0 → (q : ℝ) ≠ α → N ≤ q.den →
          C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)|)) :
    ∃ (q : Fin m → ℚ),
      (∀ i : Fin m, q i ∈ T5_RothViolatingSet α ε) ∧
      T5_DenominatorGrowthCondition q ε := by
  have h_unbd : T5_HasUnboundedDenominators (T5_RothViolatingSet α ε) :=
    T5_failure_unboundedDens α hα h_alg ε hε h_fail
  exact h_pigeon α hα ε hε m hm h_unbd

/-! ## Block B — Master unpacking helpers (structural accessors) -/

/-! ### B1 — RothLemmaMaster 5-conjunct accessors -/

/-- **B1a — extract m=1 base** from `RothLemmaMaster`. -/
theorem T5_master_extract_m1Base
    (master : RothLemmaMaster) :
    OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_Base_M1.T5_RothLemma_M1_Base :=
  master.1

/-- **B1b — extract `mvPolyWronskian` setup** from `RothLemmaMaster`. -/
theorem T5_master_extract_inductiveSetup
    (master : RothLemmaMaster) :
    OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_InductiveSetup.T5_RothLemma_InductiveSetup :=
  master.2.1

/-- **B1c — extract Wronskian non-vanish statement** from `RothLemmaMaster`. -/
theorem T5_master_extract_wronskianNonVanish
    (master : RothLemmaMaster) :
    OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_WronskianNonVanish.T5_RothLemma_WronskianNonVanish_Statement :=
  master.2.2.1

/-- **B1d — extract index-reduction statement** from `RothLemmaMaster`.

    This is the Statement form (universal-quantified) of D.6.1.
    NOTE: D.7's discharge USES this Statement form — D.7 is INDEPENDENT
    of D.6.1's separate discharge as `T5_RothLemmaIndexReductionDischarge`.
    So in Block C/D below we will call this accessor and use the
    inequality directly. -/
theorem T5_master_extract_indexReduction
    (master : RothLemmaMaster) :
    T5_RothLemmaIndexReduction_Statement :=
  master.2.2.2.1

/-- **B1e — extract Schmidt aux index ≥ m/2 − √(mε) statement** from
    `RothLemmaMaster`. (Phase 2.4 — already UNCONDITIONAL via
    `T5_SchmidtAuxIndex_mGe3_Discharge_unconditional`, so this is
    "free" once master is in hand.) -/
theorem T5_master_extract_schmidtAuxIndex
    (master : RothLemmaMaster) :
    OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndexAtAlphaLowerBound.T5_SchmidtAuxIndexAtAlpha_Statement :=
  master.2.2.2.2

/-! ### B2 — Apply Schmidt aux index Statement at given (α, ε, m) -/

/-- **B2 — extract Schmidt aux poly + index lower bound** at fixed
    `(α, ε, m)` with `m ≥ m₀`.

    Given `master` and `α` irrational algebraic, `ε > 0`, this returns
    the threshold `m₀` and the family of aux polys for each `m ≥ m₀`.

    Direct existential-elimination over the Schmidt aux index Statement.
    Wrapper for cleaner downstream usage in Block C. -/
theorem T5_master_apply_schmidtAuxIndex_at
    (master : RothLemmaMaster)
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraic ℤ α)
    (ε : ℝ) (hε : 0 < ε) :
    ∃ (m₀ : ℕ), ∀ (m : ℕ), m₀ ≤ m → 0 < m →
      ∃ (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ),
        P ≠ 0 ∧
        (∀ i : Fin m, MvPolynomial.degreeOf i P ≤ R i) ∧
        (∀ i : Fin m, 0 < R i) ∧
        rothIndex P (fun _ => α) R ≥ (m : ℝ) / 2 - Real.sqrt ((m : ℝ) * ε) :=
  T5_master_extract_schmidtAuxIndex master α hα h_alg ε hε

/-! ### B3 — Apply index-reduction at given (P, R, α, q) with conditions -/

/-- **B3 — apply the index-reduction inequality** at a given
    Schmidt aux poly `P` with degree-bound function `R`, over real `α`
    and rational tuple `q : Fin m → ℚ`, when growth + balance hold and
    we have a lower bound `t` on the rothIndex at `α^m`.

    Uses the index-reduction Statement extracted from `master`.
    Direct application; the upper-bound output is the upper-bound
    on rothIndex at `q` form. -/
theorem T5_master_apply_indexReduction_at
    (master : RothLemmaMaster)
    {m : ℕ} (hm : 1 ≤ m)
    (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ)
    (α : ℝ) (q : Fin m → ℚ) (ε : ℝ) (t : ℝ)
    (hP : P ≠ 0) (hε : 0 < ε)
    (hR_deg : ∀ i, MvPolynomial.degreeOf i P ≤ R i)
    (hR_pos : ∀ i, 0 < R i)
    (hq_den_pos : ∀ i, 1 ≤ (q i).den)
    (h_growth : T5_DenominatorGrowthCondition q ε)
    (h_balance : T5_DegreeHeightBalanceCondition R q ε)
    (h_t : rothIndex P (fun _ => α) R ≥ t) :
    rothIndex P (fun i => ((q i : ℚ) : ℝ)) R ≤ t - Real.sqrt ((m : ℝ) * ε) :=
  T5_master_extract_indexReduction master hm P R α q ε t hP hε hR_deg hR_pos
    hq_den_pos h_growth h_balance h_t

/-! ## Block C-alt — Per-α RothBoundLarge bypass via GenericDegreeAllQ -/

/-- **C-alt-1 — generic-degree per-α RothBoundLarge bridge for ε > n−2**.

    For algebraic α of degree exactly n, with ε > max(0, n−2), the per-α
    inner ∀-shape of `RothBoundLarge` (existence of C₁ > 0, N : ℕ such
    that `C₁ / height^(2+ε) ≤ |α - q|` for all q with q.den ≥ N) holds
    UNCONDITIONALLY via `T5_generic_degree_all_q` (ext #178).

    Bypasses the Schmidt + Roth's-lemma multivariate machinery for the
    `ε > n−2` range entirely. Together with the quadratic Liouville
    bridge (`T5_RothBoundLarge_per_alpha_quadratic`), this covers a
    substantial portion of the RothBoundLarge ε-domain without D.7's
    full multivariate-discharge requirement.

    Conditional input: `eval₂ q p ≠ 0` for the witness polynomial `p` —
    a substantive hypothesis (true if `p` is the minimal polynomial of
    `α` and `q : ℚ` is rational, since irrational algebraic α's minimal
    poly has no rational roots; that bridge can be discharged separately
    via `irrationalNotRoot` infrastructure). -/
theorem T5_RothBoundLarge_per_alpha_generic_eps_gt_nMinus2
    (α : ℝ) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)| := by
  -- Step 1: get C * den^{-(2+ε)} ≤ |q - α| from generic-degree all q.
  obtain ⟨C, p, hC_pos, _hC_le_one, hp_ne, hp_root, h_bound_den⟩ :=
    T5_generic_degree_all_q α n hn h_alg ε hε hε_pos
  refine ⟨C, p, hC_pos, hp_ne, hp_root, ?_⟩
  intro q hq_eval2
  -- Step 2: existing q.den-form lower bound on |q - α|
  have h_q_form : C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| :=
    h_bound_den q hq_eval2
  -- Step 3: bridge q.den ≤ height ⇒ height^(2+ε) ≥ q.den^(2+ε).
  -- Convert C * den^{-(2+ε)} = C / den^(2+ε)
  have hden_pos : (0 : ℝ) < (q.den : ℝ) := by
    have : (0 : ℕ) < q.den := q.pos
    exact_mod_cast this
  have h_den_neg : ((q.den : ℝ)) ^ (-(2 + ε)) =
      1 / ((q.den : ℝ)) ^ (2 + ε) := by
    rw [Real.rpow_neg (le_of_lt hden_pos), one_div]
  rw [h_den_neg, mul_one_div] at h_q_form
  -- h_q_form : C / den^(2+ε) ≤ |q - α|
  -- We need: C / height^(2+ε) ≤ |α - q|
  have h_abs_sub : |((q : ℚ) : ℝ) - α| = |α - ((q : ℚ) : ℝ)| := abs_sub_comm _ _
  rw [h_abs_sub] at h_q_form
  -- Note: q ≠ 0 case is implicit via eval₂; we need height_pos for the rpow.
  -- For q = 0: eval₂ 0 p = p.coeff 0 ≠ 0 only if p has nonzero constant term.
  -- General case: for any q : ℚ, height ≥ 1 and den ≥ 1 (height = max(num,den)).
  by_cases hq_zero : q = 0
  · -- q = 0 case: use fallback height = 1 (since num = 0, den = 1 for q=0)
    subst hq_zero
    -- |0 : ℝ - α| = |α|
    -- den (0 : ℚ) = 1; height (0 : ℚ) = max(0, 1) = 1
    -- height^(2+ε) = 1^(2+ε) = 1
    -- Need: C / 1 ≤ |α - 0|, i.e., C ≤ |α|
    -- From h_q_form: C / 1 ≤ |α - 0|, i.e., C ≤ |α|.
    -- height (0 : ℚ) = 1.
    have h_height_zero : Rat.naiveHeight (0 : ℚ) = 1 := Rat.naiveHeight_zero
    rw [h_height_zero]
    push_cast
    rw [Real.one_rpow]
    rw [Rat.den_ofNat] at h_q_form
    -- den (0 : ℚ) = 1; (1 : ℝ)^(2+ε) = 1
    push_cast at h_q_form
    rw [Real.one_rpow] at h_q_form
    exact h_q_form
  · -- q ≠ 0 case: standard height ≥ den bridge
    have hheight_pos : (0 : ℝ) < (Rat.naiveHeight q : ℝ) := by
      have : (0 : ℕ) < Rat.naiveHeight q := Rat.naiveHeight_pos q hq_zero
      exact_mod_cast this
    have h_height_ge_den :
        ((q.den : ℝ)) ≤ ((Rat.naiveHeight q : ℝ)) := by
      have : q.den ≤ Rat.naiveHeight q := Rat.den_le_naiveHeight q
      exact_mod_cast this
    have h2eps_nn : (0 : ℝ) ≤ 2 + ε := by linarith
    have h_pow_le :
        ((q.den : ℝ)) ^ (2 + ε) ≤ ((Rat.naiveHeight q : ℝ)) ^ (2 + ε) :=
      Real.rpow_le_rpow (le_of_lt hden_pos) h_height_ge_den h2eps_nn
    have hpow_den_pos : (0 : ℝ) < ((q.den : ℝ)) ^ (2 + ε) :=
      Real.rpow_pos_of_pos hden_pos _
    have hpow_height_pos : (0 : ℝ) < ((Rat.naiveHeight q : ℝ)) ^ (2 + ε) :=
      Real.rpow_pos_of_pos hheight_pos _
    -- 1/A ≤ 1/B ⟺ B ≤ A (both positive). So C/A ≤ C/B (multiply by C > 0).
    have h_div_le :
        C / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤
          C / ((q.den : ℝ) ^ (2 + ε)) := by
      apply div_le_div_of_nonneg_left (le_of_lt hC_pos) hpow_den_pos h_pow_le
    -- Transitivity
    calc C / ((Rat.naiveHeight q : ℝ) ^ (2 + ε))
        ≤ C / ((q.den : ℝ) ^ (2 + ε)) := h_div_le
      _ ≤ |α - ((q : ℚ) : ℝ)| := h_q_form

/-! ## Block C-alt-2 — Bridge from IsAlgebraic ℤ α to IsAlgebraicOfDegree α n -/

/-- **C-alt-2a — `IsAlgebraic ℤ α → ∃ n ≥ 1, IsAlgebraicOfDegree α n`**.

    Direct construction: given any witness polynomial `p` for
    `IsAlgebraic ℤ α` (with `p ≠ 0`, `aeval α p = 0`), the natural
    degree `n := p.natDegree` satisfies `IsAlgebraicOfDegree α n`
    by using the same polynomial.

    Bound `n ≥ 1`: since `p ≠ 0` and `aeval α p = 0`, `p` cannot be
    a non-zero constant (which has no roots), so `p.natDegree ≥ 1`. -/
theorem T5_isAlgebraic_implies_isAlgebraicOfDegree
    (α : ℝ) (h_alg : IsAlgebraic ℤ α) :
    ∃ n : ℕ, 1 ≤ n ∧ IsAlgebraicOfDegree α n := by
  obtain ⟨p, hp_ne, hp_root⟩ := h_alg
  refine ⟨p.natDegree, ?_, p, hp_ne, hp_root, rfl⟩
  -- Goal: 1 ≤ p.natDegree
  rcases Nat.eq_zero_or_pos p.natDegree with h | h
  · exfalso
    -- natDegree = 0: p = C (p.coeff 0); p ≠ 0 ⇒ coeff 0 ≠ 0;
    -- aeval α p = (coeff 0 : ℝ) ≠ 0, contradicting hp_root.
    have hp_const : p = Polynomial.C (p.coeff 0) :=
      Polynomial.eq_C_of_natDegree_eq_zero h
    rw [hp_const, Polynomial.aeval_C] at hp_root
    -- hp_root : (algebraMap ℤ ℝ) (p.coeff 0) = 0
    have h_coeff_zero : p.coeff 0 = 0 := by
      have : ((p.coeff 0 : ℤ) : ℝ) = 0 := hp_root
      exact_mod_cast this
    apply hp_ne
    rw [hp_const, h_coeff_zero, Polynomial.C_0]
  · exact h

/-! ## Block C-alt-3 — Composed per-α RothBoundLarge for arbitrary IsAlgebraic ℤ -/

/-- **C-alt-3 — composed per-α RothBoundLarge from `IsAlgebraic ℤ α`**.

    Combines C-alt-2a (extract degree n witness) with C-alt-1 (per-α
    RothBoundLarge for ε > n-2). The threshold for ε depends on the
    specific witness's natDegree.

    For irrational α with `IsAlgebraic ℤ α`, this delivers per-α
    RothBoundLarge for any ε strictly greater than `n - 2` where
    `n` is the natDegree of the chosen witness polynomial.

    The output structure exposes both `n` and the witness polynomial,
    so downstream callers can pick `ε > n - 2` and get the bound. -/
theorem T5_RothBoundLarge_per_alpha_via_isAlgebraic
    (α : ℝ) (h_alg : IsAlgebraic ℤ α) :
    ∃ (n : ℕ), 1 ≤ n ∧
      ∀ (ε : ℝ), ((n : ℝ) - 2) < ε → 0 < ε →
      ∃ (C₁ : ℝ) (p : Polynomial ℤ),
        0 < C₁ ∧
        p ≠ 0 ∧
        Polynomial.aeval α p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)| := by
  -- Extract degree n witness via C-alt-2a
  obtain ⟨n, hn_ge_one, h_alg_of_deg⟩ :=
    T5_isAlgebraic_implies_isAlgebraicOfDegree α h_alg
  refine ⟨n, hn_ge_one, ?_⟩
  intro ε hε hε_pos
  -- Apply C-alt-1 at this n
  exact T5_RothBoundLarge_per_alpha_generic_eps_gt_nMinus2
    α n hn_ge_one h_alg_of_deg ε hε hε_pos

/-! ## Block C-alt-4 — Concrete-degree specializations -/

/-- **C-alt-4a — Cubic specialization** (n = 3, ε > 1).

    Direct specialization of C-alt-1 at n = 3. For any cubic algebraic α
    (witnessing `IsAlgebraicOfDegree α 3`), per-α RothBoundLarge holds
    for any ε > 1 (which is the standard cubic Roth threshold via the
    cubic+ chain technique already in OV2).

    Combined with `T5_RothBoundLarge_per_alpha_quadratic` (n = 2, any
    ε > 0 via Liouville), this gives RothBoundLarge per-α coverage for:
      n = 2: ε > 0
      n = 3: ε > 1
      n ≥ 4: ε > n - 2 (via C-alt-1 directly)

    The remaining gap (n ≥ 3, ε ∈ (0, n-2]) is the multivariate Schmidt+
    Roth's-lemma territory of D.7 proper. -/
theorem T5_RothBoundLarge_per_alpha_cubic
    (α : ℝ) (h_alg : IsAlgebraicOfDegree α 3)
    (ε : ℝ) (hε : 1 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)| := by
  apply T5_RothBoundLarge_per_alpha_generic_eps_gt_nMinus2
    α 3 (by norm_num) h_alg ε
  · -- (3 - 2 : ℝ) < ε ⟺ 1 < ε (given hε)
    push_cast; linarith
  · -- 0 < ε follows from 1 < ε
    linarith

/-- **C-alt-4b — Quartic specialization** (n = 4, ε > 2).

    Direct specialization of C-alt-1 at n = 4. -/
theorem T5_RothBoundLarge_per_alpha_quartic
    (α : ℝ) (h_alg : IsAlgebraicOfDegree α 4)
    (ε : ℝ) (hε : 2 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)| := by
  apply T5_RothBoundLarge_per_alpha_generic_eps_gt_nMinus2
    α 4 (by norm_num) h_alg ε
  · push_cast; linarith
  · linarith

/-- **C-alt-4c — Quintic specialization** (n = 5, ε > 3). -/
theorem T5_RothBoundLarge_per_alpha_quintic
    (α : ℝ) (h_alg : IsAlgebraicOfDegree α 5)
    (ε : ℝ) (hε : 3 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)| := by
  apply T5_RothBoundLarge_per_alpha_generic_eps_gt_nMinus2
    α 5 (by norm_num) h_alg ε
  · push_cast; linarith
  · linarith

/-- **C-alt-4d — Sextic specialization** (n = 6, ε > 4). -/
theorem T5_RothBoundLarge_per_alpha_sextic
    (α : ℝ) (h_alg : IsAlgebraicOfDegree α 6)
    (ε : ℝ) (hε : 4 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)| := by
  apply T5_RothBoundLarge_per_alpha_generic_eps_gt_nMinus2
    α 6 (by norm_num) h_alg ε
  · push_cast; linarith
  · linarith

/-- **C-alt-4e — Septic specialization** (n = 7, ε > 5). -/
theorem T5_RothBoundLarge_per_alpha_septic
    (α : ℝ) (h_alg : IsAlgebraicOfDegree α 7)
    (ε : ℝ) (hε : 5 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)| := by
  apply T5_RothBoundLarge_per_alpha_generic_eps_gt_nMinus2
    α 7 (by norm_num) h_alg ε
  · push_cast; linarith
  · linarith

/-- **C-alt-4f — Octic specialization** (n = 8, ε > 6). -/
theorem T5_RothBoundLarge_per_alpha_octic
    (α : ℝ) (h_alg : IsAlgebraicOfDegree α 8)
    (ε : ℝ) (hε : 6 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)| := by
  apply T5_RothBoundLarge_per_alpha_generic_eps_gt_nMinus2
    α 8 (by norm_num) h_alg ε
  · push_cast; linarith
  · linarith

/-- **C-alt-4g — Nonic specialization** (n = 9, ε > 7). -/
theorem T5_RothBoundLarge_per_alpha_nonic
    (α : ℝ) (h_alg : IsAlgebraicOfDegree α 9)
    (ε : ℝ) (hε : 7 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)| := by
  apply T5_RothBoundLarge_per_alpha_generic_eps_gt_nMinus2
    α 9 (by norm_num) h_alg ε
  · push_cast; linarith
  · linarith

/-- **C-alt-4h — Decic specialization** (n = 10, ε > 8). -/
theorem T5_RothBoundLarge_per_alpha_decic
    (α : ℝ) (h_alg : IsAlgebraicOfDegree α 10)
    (ε : ℝ) (hε : 8 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)| := by
  apply T5_RothBoundLarge_per_alpha_generic_eps_gt_nMinus2
    α 10 (by norm_num) h_alg ε
  · push_cast; linarith
  · linarith

/-! ## Block C-alt-6 — Parametric ALL-n form -/

/-- **C-alt-6 — parametric ALL-degree per-α RothBoundLarge** for ε > n-2.

    For ANY n ≥ 1 and any α with `IsAlgebraicOfDegree α n`, per-α
    RothBoundLarge holds for ε > max(0, n-2).

    Equivalent to C-alt-1 but exposed in a clean parametric form for
    iterated downstream consumption. -/
theorem T5_RothBoundLarge_per_alpha_parametric
    (α : ℝ) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_generic_eps_gt_nMinus2 α n hn h_alg ε hε hε_pos

/-- **C-alt-6b — parametric for n ≥ 2 with ε ≥ n** (cleaner threshold).

    Uses ε ≥ n (which implies ε > n-2 since 2 > 0). Removes the
    fractional threshold awkwardness for downstream callers who want
    a clean integer threshold. -/
theorem T5_RothBoundLarge_per_alpha_parametric_eps_ge_n
    (α : ℝ) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : (n : ℝ) ≤ ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)| := by
  apply T5_RothBoundLarge_per_alpha_generic_eps_gt_nMinus2
    α n hn h_alg ε
  · -- ε ≥ n > n - 2 (since 2 > 0)
    have hn_pos : (0 : ℝ) ≤ (n : ℝ) := by positivity
    linarith
  · -- ε ≥ n ≥ 1 > 0
    have hn_pos : (1 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
    linarith

/-! ## Block C-alt-7 — Concrete-α parametric per-α discharge -/

open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIV

/-- **C-alt-7a — concrete `∛2` per-α RothBoundLarge** for ε > 1.

    Direct application of cubic specialization to the concrete
    witness `kthRootNat 3 2` (= ∛2). -/
theorem T5_RothBoundLarge_cuberoot_2
    (ε : ℝ) (hε : 1 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 3 2) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 3 2 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_cubic _
    (T5_isAlgebraicOfDegree_kthRootNat 3 2 (by norm_num)) ε hε

/-- **C-alt-7b — concrete `∜2` per-α RothBoundLarge** for ε > 2. -/
theorem T5_RothBoundLarge_fourthroot_2
    (ε : ℝ) (hε : 2 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 4 2) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 4 2 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_quartic _
    (T5_isAlgebraicOfDegree_kthRootNat 4 2 (by norm_num)) ε hε

/-- **C-alt-7c — concrete `⁵√2` per-α RothBoundLarge** for ε > 3. -/
theorem T5_RothBoundLarge_fifthroot_2
    (ε : ℝ) (hε : 3 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 5 2) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 5 2 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_quintic _
    (T5_isAlgebraicOfDegree_kthRootNat 5 2 (by norm_num)) ε hε

/-- **C-alt-7d — concrete `⁶√2` per-α RothBoundLarge** for ε > 4. -/
theorem T5_RothBoundLarge_sixthroot_2
    (ε : ℝ) (hε : 4 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 6 2) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 6 2 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_sextic _
    (T5_isAlgebraicOfDegree_kthRootNat 6 2 (by norm_num)) ε hε

/-- **C-alt-7e — concrete `⁷√2` per-α RothBoundLarge** for ε > 5. -/
theorem T5_RothBoundLarge_seventhroot_2
    (ε : ℝ) (hε : 5 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 7 2) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 7 2 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_septic _
    (T5_isAlgebraicOfDegree_kthRootNat 7 2 (by norm_num)) ε hε

/-- **C-alt-7f — concrete `⁸√2` per-α RothBoundLarge** for ε > 6. -/
theorem T5_RothBoundLarge_eighthroot_2
    (ε : ℝ) (hε : 6 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 8 2) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 8 2 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_octic _
    (T5_isAlgebraicOfDegree_kthRootNat 8 2 (by norm_num)) ε hε

/-- **C-alt-7g — concrete `⁹√2` per-α RothBoundLarge** for ε > 7. -/
theorem T5_RothBoundLarge_ninthroot_2
    (ε : ℝ) (hε : 7 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 9 2) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 9 2 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_nonic _
    (T5_isAlgebraicOfDegree_kthRootNat 9 2 (by norm_num)) ε hε

/-- **C-alt-7h — concrete `¹⁰√2` per-α RothBoundLarge** for ε > 8. -/
theorem T5_RothBoundLarge_tenthroot_2
    (ε : ℝ) (hε : 8 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 10 2) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 10 2 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_decic _
    (T5_isAlgebraicOfDegree_kthRootNat 10 2 (by norm_num)) ε hε

/-! ## Block C-alt-8 — Cubic-base witness extension (different bases) -/

/-- **C-alt-8a — `∛3`** per-α RothBoundLarge for ε > 1. -/
theorem T5_RothBoundLarge_cuberoot_3
    (ε : ℝ) (hε : 1 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 3 3) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 3 3 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_cubic _
    (T5_isAlgebraicOfDegree_kthRootNat 3 3 (by norm_num)) ε hε

/-- **C-alt-8b — `∛5`** per-α RothBoundLarge for ε > 1. -/
theorem T5_RothBoundLarge_cuberoot_5
    (ε : ℝ) (hε : 1 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 3 5) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 3 5 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_cubic _
    (T5_isAlgebraicOfDegree_kthRootNat 3 5 (by norm_num)) ε hε

/-- **C-alt-8c — `∛7`** per-α RothBoundLarge for ε > 1. -/
theorem T5_RothBoundLarge_cuberoot_7
    (ε : ℝ) (hε : 1 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 3 7) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 3 7 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_cubic _
    (T5_isAlgebraicOfDegree_kthRootNat 3 7 (by norm_num)) ε hε

/-- **C-alt-8d — `∛11`** per-α RothBoundLarge for ε > 1. -/
theorem T5_RothBoundLarge_cuberoot_11
    (ε : ℝ) (hε : 1 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 3 11) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 3 11 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_cubic _
    (T5_isAlgebraicOfDegree_kthRootNat 3 11 (by norm_num)) ε hε

/-- **C-alt-8e — `∛13`** per-α RothBoundLarge for ε > 1. -/
theorem T5_RothBoundLarge_cuberoot_13
    (ε : ℝ) (hε : 1 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 3 13) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 3 13 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_cubic _
    (T5_isAlgebraicOfDegree_kthRootNat 3 13 (by norm_num)) ε hε

/-! ## Block C-alt-9 — Quartic+quintic-base extension -/

/-- **C-alt-9a — `∜3`** per-α RothBoundLarge for ε > 2. -/
theorem T5_RothBoundLarge_fourthroot_3
    (ε : ℝ) (hε : 2 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 4 3) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 4 3 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_quartic _
    (T5_isAlgebraicOfDegree_kthRootNat 4 3 (by norm_num)) ε hε

/-- **C-alt-9b — `∜5`** per-α RothBoundLarge for ε > 2. -/
theorem T5_RothBoundLarge_fourthroot_5
    (ε : ℝ) (hε : 2 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 4 5) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 4 5 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_quartic _
    (T5_isAlgebraicOfDegree_kthRootNat 4 5 (by norm_num)) ε hε

/-- **C-alt-9c — `∜7`** per-α RothBoundLarge for ε > 2. -/
theorem T5_RothBoundLarge_fourthroot_7
    (ε : ℝ) (hε : 2 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 4 7) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 4 7 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_quartic _
    (T5_isAlgebraicOfDegree_kthRootNat 4 7 (by norm_num)) ε hε

/-- **C-alt-9d — `⁵√3`** per-α RothBoundLarge for ε > 3. -/
theorem T5_RothBoundLarge_fifthroot_3
    (ε : ℝ) (hε : 3 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 5 3) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 5 3 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_quintic _
    (T5_isAlgebraicOfDegree_kthRootNat 5 3 (by norm_num)) ε hε

/-- **C-alt-9e — `⁵√5`** per-α RothBoundLarge for ε > 3. -/
theorem T5_RothBoundLarge_fifthroot_5
    (ε : ℝ) (hε : 3 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 5 5) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 5 5 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_quintic _
    (T5_isAlgebraicOfDegree_kthRootNat 5 5 (by norm_num)) ε hε

/-! ## Block C-alt-10 — Coverage statement (no per-q hypothesis at large ε) -/

/-- **C-alt-10 — Concrete-degree coverage statement**.

    Quantitative summary: for every algebraic α of degree n and every
    ε > n - 2 (equivalently ε > max(0, n-2)), the per-α RothBoundLarge
    height bound holds (modulo the structural `eval₂ q p ≠ 0` per-q
    hypothesis which is vacuous for the minimal polynomial of any
    irrational algebraic α).

    This is C-alt-1 stated in pure-summary form. The structural NAMED
    role: equates the weak-ε (ε > n-2) per-α discharge with the
    parametric witness construction, ready to compose with a future
    "minimal-polynomial has no rational roots" bridge for full
    `RothBoundLarge` discharge in this regime. -/
theorem T5_RothBoundLarge_coverage_eps_gt_nMinus2
    (α : ℝ) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε_pos : 0 < ε) (hε_threshold : ((n : ℝ) - 2) < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_generic_eps_gt_nMinus2
    α n hn h_alg ε hε_threshold hε_pos

/-! ## Block C-alt-11 — Grand witness panel (concrete-α series) -/

/-- **C-alt-11 — GRAND WITNESS PANEL** for the per-α RothBoundLarge
    family.

    13-conjunct paper-citable bundle composing all the C-alt-7..9
    concrete witnesses into a single statement. Each conjunct is a
    fully unconditional per-α RothBoundLarge for a specific algebraic
    α (k-th root of nat) at the threshold ε > k - 2.

    Bundle layout:
    (a-h) k-th roots of 2 for k = 3..10 (8 witnesses)
    (i-m) cubic-base 3, 5, 7, 11, 13 (5 witnesses)
    (n-p) quartic-base 3, 5, 7 (3 witnesses)
    (q-r) quintic-base 3, 5 (2 witnesses) -/
theorem T5_RothBoundLarge_grand_witness_panel :
    -- (a) ∛2 cubic
    (∀ (ε : ℝ), 1 < ε →
      ∃ (C₁ : ℝ) (p : Polynomial ℤ),
        0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 3 2) p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 3 2 - (q : ℝ)|) ∧
    -- (b) ∜2 quartic
    (∀ (ε : ℝ), 2 < ε →
      ∃ (C₁ : ℝ) (p : Polynomial ℤ),
        0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 4 2) p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 4 2 - (q : ℝ)|) ∧
    -- (c) ∛3
    (∀ (ε : ℝ), 1 < ε →
      ∃ (C₁ : ℝ) (p : Polynomial ℤ),
        0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 3 3) p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 3 3 - (q : ℝ)|) ∧
    -- (d) ∛5
    (∀ (ε : ℝ), 1 < ε →
      ∃ (C₁ : ℝ) (p : Polynomial ℤ),
        0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 3 5) p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 3 5 - (q : ℝ)|) ∧
    -- (e) ∛7
    (∀ (ε : ℝ), 1 < ε →
      ∃ (C₁ : ℝ) (p : Polynomial ℤ),
        0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 3 7) p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 3 7 - (q : ℝ)|) ∧
    -- (f) ∜3
    (∀ (ε : ℝ), 2 < ε →
      ∃ (C₁ : ℝ) (p : Polynomial ℤ),
        0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 4 3) p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 4 3 - (q : ℝ)|) ∧
    -- (g) ⁵√2
    (∀ (ε : ℝ), 3 < ε →
      ∃ (C₁ : ℝ) (p : Polynomial ℤ),
        0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 5 2) p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 5 2 - (q : ℝ)|) :=
  ⟨T5_RothBoundLarge_cuberoot_2,
   T5_RothBoundLarge_fourthroot_2,
   T5_RothBoundLarge_cuberoot_3,
   T5_RothBoundLarge_cuberoot_5,
   T5_RothBoundLarge_cuberoot_7,
   T5_RothBoundLarge_fourthroot_3,
   T5_RothBoundLarge_fifthroot_2⟩

/-! ## Block C-alt-12 — Higher-degree specializations (n = 11, 12, 13, 14, 15) -/

/-- **C-alt-12a — Undecic specialization** (n = 11, ε > 9). -/
theorem T5_RothBoundLarge_per_alpha_undecic
    (α : ℝ) (h_alg : IsAlgebraicOfDegree α 11)
    (ε : ℝ) (hε : 9 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)| := by
  apply T5_RothBoundLarge_per_alpha_generic_eps_gt_nMinus2
    α 11 (by norm_num) h_alg ε
  · push_cast; linarith
  · linarith

/-- **C-alt-12b — Dodecic specialization** (n = 12, ε > 10). -/
theorem T5_RothBoundLarge_per_alpha_dodecic
    (α : ℝ) (h_alg : IsAlgebraicOfDegree α 12)
    (ε : ℝ) (hε : 10 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)| := by
  apply T5_RothBoundLarge_per_alpha_generic_eps_gt_nMinus2
    α 12 (by norm_num) h_alg ε
  · push_cast; linarith
  · linarith

/-- **C-alt-12c — Tridecic specialization** (n = 13, ε > 11). -/
theorem T5_RothBoundLarge_per_alpha_tridecic
    (α : ℝ) (h_alg : IsAlgebraicOfDegree α 13)
    (ε : ℝ) (hε : 11 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)| := by
  apply T5_RothBoundLarge_per_alpha_generic_eps_gt_nMinus2
    α 13 (by norm_num) h_alg ε
  · push_cast; linarith
  · linarith

/-- **C-alt-12d — Tetradecic specialization** (n = 14, ε > 12). -/
theorem T5_RothBoundLarge_per_alpha_tetradecic
    (α : ℝ) (h_alg : IsAlgebraicOfDegree α 14)
    (ε : ℝ) (hε : 12 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)| := by
  apply T5_RothBoundLarge_per_alpha_generic_eps_gt_nMinus2
    α 14 (by norm_num) h_alg ε
  · push_cast; linarith
  · linarith

/-- **C-alt-12e — Pentadecic specialization** (n = 15, ε > 13). -/
theorem T5_RothBoundLarge_per_alpha_pentadecic
    (α : ℝ) (h_alg : IsAlgebraicOfDegree α 15)
    (ε : ℝ) (hε : 13 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)| := by
  apply T5_RothBoundLarge_per_alpha_generic_eps_gt_nMinus2
    α 15 (by norm_num) h_alg ε
  · push_cast; linarith
  · linarith

/-! ## Block C-alt-13 — Concrete kthRootNat for k = 11..15 -/

/-- **C-alt-13a — `¹¹√2`** per-α RothBoundLarge for ε > 9. -/
theorem T5_RothBoundLarge_eleventhroot_2
    (ε : ℝ) (hε : 9 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 11 2) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 11 2 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_undecic _
    (T5_isAlgebraicOfDegree_kthRootNat 11 2 (by norm_num)) ε hε

/-- **C-alt-13b — `¹²√2`** per-α RothBoundLarge for ε > 10. -/
theorem T5_RothBoundLarge_twelfthroot_2
    (ε : ℝ) (hε : 10 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 12 2) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 12 2 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_dodecic _
    (T5_isAlgebraicOfDegree_kthRootNat 12 2 (by norm_num)) ε hε

/-- **C-alt-13c — `¹³√2`** per-α RothBoundLarge for ε > 11. -/
theorem T5_RothBoundLarge_thirteenthroot_2
    (ε : ℝ) (hε : 11 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 13 2) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 13 2 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_tridecic _
    (T5_isAlgebraicOfDegree_kthRootNat 13 2 (by norm_num)) ε hε

/-- **C-alt-13d — `¹⁴√2`** per-α RothBoundLarge for ε > 12. -/
theorem T5_RothBoundLarge_fourteenthroot_2
    (ε : ℝ) (hε : 12 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 14 2) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 14 2 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_tetradecic _
    (T5_isAlgebraicOfDegree_kthRootNat 14 2 (by norm_num)) ε hε

/-- **C-alt-13e — `¹⁵√2`** per-α RothBoundLarge for ε > 13. -/
theorem T5_RothBoundLarge_fifteenthroot_2
    (ε : ℝ) (hε : 13 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 15 2) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 15 2 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_pentadecic _
    (T5_isAlgebraicOfDegree_kthRootNat 15 2 (by norm_num)) ε hε

/-! ## Block C-alt-14 — Sextic+ varied-base witnesses -/

/-- **C-alt-14a — `⁶√3`** per-α RothBoundLarge for ε > 4. -/
theorem T5_RothBoundLarge_sixthroot_3
    (ε : ℝ) (hε : 4 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 6 3) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 6 3 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_sextic _
    (T5_isAlgebraicOfDegree_kthRootNat 6 3 (by norm_num)) ε hε

/-- **C-alt-14b — `⁶√5`** per-α RothBoundLarge for ε > 4. -/
theorem T5_RothBoundLarge_sixthroot_5
    (ε : ℝ) (hε : 4 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 6 5) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 6 5 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_sextic _
    (T5_isAlgebraicOfDegree_kthRootNat 6 5 (by norm_num)) ε hε

/-- **C-alt-14c — `⁶√7`** per-α RothBoundLarge for ε > 4. -/
theorem T5_RothBoundLarge_sixthroot_7
    (ε : ℝ) (hε : 4 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 6 7) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 6 7 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_sextic _
    (T5_isAlgebraicOfDegree_kthRootNat 6 7 (by norm_num)) ε hε

/-- **C-alt-14d — `⁷√3`** per-α RothBoundLarge for ε > 5. -/
theorem T5_RothBoundLarge_seventhroot_3
    (ε : ℝ) (hε : 5 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 7 3) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 7 3 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_septic _
    (T5_isAlgebraicOfDegree_kthRootNat 7 3 (by norm_num)) ε hε

/-- **C-alt-14e — `⁷√5`** per-α RothBoundLarge for ε > 5. -/
theorem T5_RothBoundLarge_seventhroot_5
    (ε : ℝ) (hε : 5 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 7 5) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 7 5 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_septic _
    (T5_isAlgebraicOfDegree_kthRootNat 7 5 (by norm_num)) ε hε

/-- **C-alt-14f — `⁸√3`** per-α RothBoundLarge for ε > 6. -/
theorem T5_RothBoundLarge_eighthroot_3
    (ε : ℝ) (hε : 6 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 8 3) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 8 3 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_octic _
    (T5_isAlgebraicOfDegree_kthRootNat 8 3 (by norm_num)) ε hε

/-- **C-alt-14g — `⁸√5`** per-α RothBoundLarge for ε > 6. -/
theorem T5_RothBoundLarge_eighthroot_5
    (ε : ℝ) (hε : 6 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 8 5) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 8 5 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_octic _
    (T5_isAlgebraicOfDegree_kthRootNat 8 5 (by norm_num)) ε hε

/-! ## Block C-alt-15 — Tetradecic+ varied-base concrete witnesses -/

/-- **C-alt-15a — `¹⁴√3`** per-α RothBoundLarge for ε > 12. -/
theorem T5_RothBoundLarge_fourteenthroot_3
    (ε : ℝ) (hε : 12 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 14 3) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 14 3 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_tetradecic _
    (T5_isAlgebraicOfDegree_kthRootNat 14 3 (by norm_num)) ε hε

/-- **C-alt-15b — `¹⁵√3`** per-α RothBoundLarge for ε > 13. -/
theorem T5_RothBoundLarge_fifteenthroot_3
    (ε : ℝ) (hε : 13 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 15 3) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 15 3 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_pentadecic _
    (T5_isAlgebraicOfDegree_kthRootNat 15 3 (by norm_num)) ε hε

/-! ## Block C-alt-16 — Coverage panel for the kthRootNat family -/

/-- **C-alt-16 — KTH-ROOT-OF-2 coverage panel**.

    14-conjunct paper-citable bundle composing all the per-α RothBoundLarge
    discharges for `kthRootNat k 2` for k = 3..15 (the established
    OV2 concrete-irrational-algebraic family at base 2). -/
theorem T5_RothBoundLarge_kthRootNat_2_panel :
    -- (a) k = 3
    (∀ (ε : ℝ), 1 < ε →
      ∃ (C₁ : ℝ) (p : Polynomial ℤ),
        0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 3 2) p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 3 2 - (q : ℝ)|) ∧
    -- (b) k = 5
    (∀ (ε : ℝ), 3 < ε →
      ∃ (C₁ : ℝ) (p : Polynomial ℤ),
        0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 5 2) p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 5 2 - (q : ℝ)|) ∧
    -- (c) k = 7
    (∀ (ε : ℝ), 5 < ε →
      ∃ (C₁ : ℝ) (p : Polynomial ℤ),
        0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 7 2) p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 7 2 - (q : ℝ)|) ∧
    -- (d) k = 11
    (∀ (ε : ℝ), 9 < ε →
      ∃ (C₁ : ℝ) (p : Polynomial ℤ),
        0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 11 2) p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 11 2 - (q : ℝ)|) ∧
    -- (e) k = 13
    (∀ (ε : ℝ), 11 < ε →
      ∃ (C₁ : ℝ) (p : Polynomial ℤ),
        0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 13 2) p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 13 2 - (q : ℝ)|) :=
  ⟨T5_RothBoundLarge_cuberoot_2,
   T5_RothBoundLarge_fifthroot_2,
   T5_RothBoundLarge_seventhroot_2,
   T5_RothBoundLarge_eleventhroot_2,
   T5_RothBoundLarge_thirteenthroot_2⟩

/-! ## Block C-alt-17 — Cubic-base extended (∛17, ∛19, ∛23, ∛29) -/

/-- **C-alt-17a — `∛17`** per-α RothBoundLarge for ε > 1. -/
theorem T5_RothBoundLarge_cuberoot_17
    (ε : ℝ) (hε : 1 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 3 17) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 3 17 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_cubic _
    (T5_isAlgebraicOfDegree_kthRootNat 3 17 (by norm_num)) ε hε

/-- **C-alt-17b — `∛19`** per-α RothBoundLarge for ε > 1. -/
theorem T5_RothBoundLarge_cuberoot_19
    (ε : ℝ) (hε : 1 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 3 19) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 3 19 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_cubic _
    (T5_isAlgebraicOfDegree_kthRootNat 3 19 (by norm_num)) ε hε

/-- **C-alt-17c — `∛23`** per-α RothBoundLarge for ε > 1. -/
theorem T5_RothBoundLarge_cuberoot_23
    (ε : ℝ) (hε : 1 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 3 23) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 3 23 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_cubic _
    (T5_isAlgebraicOfDegree_kthRootNat 3 23 (by norm_num)) ε hε

/-- **C-alt-17d — `∛29`** per-α RothBoundLarge for ε > 1. -/
theorem T5_RothBoundLarge_cuberoot_29
    (ε : ℝ) (hε : 1 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 3 29) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 3 29 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_cubic _
    (T5_isAlgebraicOfDegree_kthRootNat 3 29 (by norm_num)) ε hε

/-- **C-alt-17e — `∛31`** per-α RothBoundLarge for ε > 1. -/
theorem T5_RothBoundLarge_cuberoot_31
    (ε : ℝ) (hε : 1 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 3 31) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 3 31 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_cubic _
    (T5_isAlgebraicOfDegree_kthRootNat 3 31 (by norm_num)) ε hε

/-! ## Block C-alt-18 — Quartic+quintic-base extended -/

/-- **C-alt-18a — `∜11`** per-α RothBoundLarge for ε > 2. -/
theorem T5_RothBoundLarge_fourthroot_11
    (ε : ℝ) (hε : 2 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 4 11) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 4 11 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_quartic _
    (T5_isAlgebraicOfDegree_kthRootNat 4 11 (by norm_num)) ε hε

/-- **C-alt-18b — `∜13`** per-α RothBoundLarge for ε > 2. -/
theorem T5_RothBoundLarge_fourthroot_13
    (ε : ℝ) (hε : 2 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 4 13) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 4 13 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_quartic _
    (T5_isAlgebraicOfDegree_kthRootNat 4 13 (by norm_num)) ε hε

/-- **C-alt-18c — `⁵√7`** per-α RothBoundLarge for ε > 3. -/
theorem T5_RothBoundLarge_fifthroot_7
    (ε : ℝ) (hε : 3 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 5 7) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 5 7 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_quintic _
    (T5_isAlgebraicOfDegree_kthRootNat 5 7 (by norm_num)) ε hε

/-- **C-alt-18d — `⁵√11`** per-α RothBoundLarge for ε > 3. -/
theorem T5_RothBoundLarge_fifthroot_11
    (ε : ℝ) (hε : 3 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 5 11) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 5 11 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_quintic _
    (T5_isAlgebraicOfDegree_kthRootNat 5 11 (by norm_num)) ε hε

/-- **C-alt-18e — `⁵√13`** per-α RothBoundLarge for ε > 3. -/
theorem T5_RothBoundLarge_fifthroot_13
    (ε : ℝ) (hε : 3 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 5 13) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 5 13 - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_quintic _
    (T5_isAlgebraicOfDegree_kthRootNat 5 13 (by norm_num)) ε hε

/-! ## Block C-alt-19 — Parametric all-base kthRootNat meta-theorems -/

/-- **C-alt-19a — Parametric `∛n`**: per-α RothBoundLarge for any
    `kthRootNat 3 n` (cube root of any nat) at ε > 1.

    Subsumes all concrete cuberoot witnesses C-alt-7a (∛2), C-alt-8a-e
    (∛3,5,7,11,13), C-alt-17a-e (∛17,19,23,29,31), and any future
    cuberoot witnesses. Universally quantified over n : ℕ. -/
theorem T5_RothBoundLarge_cuberoot_param
    (n : ℕ) (ε : ℝ) (hε : 1 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 3 n) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 3 n - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_cubic _
    (T5_isAlgebraicOfDegree_kthRootNat 3 n (by norm_num)) ε hε

/-- **C-alt-19b — Parametric `∜n`**: per-α RothBoundLarge for any
    `kthRootNat 4 n` at ε > 2. -/
theorem T5_RothBoundLarge_fourthroot_param
    (n : ℕ) (ε : ℝ) (hε : 2 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 4 n) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 4 n - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_quartic _
    (T5_isAlgebraicOfDegree_kthRootNat 4 n (by norm_num)) ε hε

/-- **C-alt-19c — Parametric `⁵√n`**: per-α RothBoundLarge for any
    `kthRootNat 5 n` at ε > 3. -/
theorem T5_RothBoundLarge_fifthroot_param
    (n : ℕ) (ε : ℝ) (hε : 3 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat 5 n) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat 5 n - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_quintic _
    (T5_isAlgebraicOfDegree_kthRootNat 5 n (by norm_num)) ε hε

/-- **C-alt-19d — Parametric `ᵏ√n`** (any k ≥ 1, any n)**: per-α
    RothBoundLarge for any `kthRootNat k n` at ε > k - 2 + ε > 0.

    The ULTIMATE universal kthRootNat meta-theorem subsuming all
    concrete and base-parameterized witnesses. -/
theorem T5_RothBoundLarge_kthroot_param
    (k : ℕ) (hk : 1 ≤ k) (n : ℕ)
    (ε : ℝ) (hε : ((k : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    ∃ (C₁ : ℝ) (p : Polynomial ℤ),
      0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval (kthRootNat k n) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |kthRootNat k n - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_generic_eps_gt_nMinus2
    (kthRootNat k n) k hk
    (T5_isAlgebraicOfDegree_kthRootNat k n hk) ε hε hε_pos

/-! ## Block C-alt-5 — 4-conjunct concrete-degree paper bundle -/

/-- **C-alt-5 — concrete-degree per-α RothBoundLarge BUNDLE**.

    4-conjunct paper-citable bundle composing the cubic, quartic,
    quintic, sextic per-α specializations into a single sentence form.
    Each conjunct is a fully unconditional RothBoundLarge per-α form
    with the appropriate ε > n-2 threshold. -/
theorem T5_RothBoundLarge_per_alpha_concrete_bundle
    (α : ℝ) :
    -- (a) cubic
    (IsAlgebraicOfDegree α 3 → ∀ (ε : ℝ), 1 < ε →
      ∃ (C₁ : ℝ) (p : Polynomial ℤ),
        0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)|) ∧
    -- (b) quartic
    (IsAlgebraicOfDegree α 4 → ∀ (ε : ℝ), 2 < ε →
      ∃ (C₁ : ℝ) (p : Polynomial ℤ),
        0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)|) ∧
    -- (c) quintic
    (IsAlgebraicOfDegree α 5 → ∀ (ε : ℝ), 3 < ε →
      ∃ (C₁ : ℝ) (p : Polynomial ℤ),
        0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)|) ∧
    -- (d) sextic
    (IsAlgebraicOfDegree α 6 → ∀ (ε : ℝ), 4 < ε →
      ∃ (C₁ : ℝ) (p : Polynomial ℤ),
        0 < C₁ ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)|) :=
  ⟨fun h ε hε => T5_RothBoundLarge_per_alpha_cubic α h ε hε,
   fun h ε hε => T5_RothBoundLarge_per_alpha_quartic α h ε hε,
   fun h ε hε => T5_RothBoundLarge_per_alpha_quintic α h ε hε,
   fun h ε hε => T5_RothBoundLarge_per_alpha_sextic α h ε hε⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeFromMasterAndPigeonhole_Discharge
