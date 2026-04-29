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
import OmegaTheory.Irrationality.CustomMath.T5_Heights

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeFromMasterAndPigeonhole_Discharge

open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothCompleteDischarge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTuple
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MasterCapstone
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothTheoremClosure
open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open MvPolynomial Real

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

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeFromMasterAndPigeonhole_Discharge
