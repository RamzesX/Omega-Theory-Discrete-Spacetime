/-
  OmegaTheory.IrrationalityClasses.Catalan

  **Catalan's constant — numerical bounds**  (Alrescha α Piscium, 2026-04-21,
  Wave-A by Ruchba δ Cassiopeiae, 2026-04-21).

  Delivers the full bounds/summability story that Alrescha's scaffolding left open:

  - Summability of `catalanTerm` via comparison with `1/(n+1)²` p-series.
  - `catalanTerm` tends to `0` at infinity.
  - Existence of the alternating-series limit: `HasSum` form.
  - `0 < catalanG` via alternating-series lower bound (even partial sum).
  - `catalanG < 1` via alternating-series upper bound (odd partial sum).
  - The three "G ≠ constant" legs for Layer 1 pairwise distinctness.
  - The full 4-way pairwise distinctness bundle `ic_four_irrationals_pairwise_distinct`.

  Proof strategy: Mathlib's
  `Antitone.alternating_series_le_tendsto` (even ≤ limit) and
  `Antitone.tendsto_le_alternating_series` (limit ≤ odd) give a two-sided bound
  around partial sums; we evaluate S_2 = 1 - 1/9 = 8/9 (lower) and
  S_3 = 1 - 1/9 + 1/25 = 209/225 (upper).

  Design reference: `05_catalan_G_class.md`, `12_graph_register.md`.
-/

import OmegaTheory.IrrationalityClasses.Basic
import Mathlib.Analysis.PSeries
import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.Tactic

namespace OmegaTheory.IrrationalityClasses

open Real BigOperators Finset Filter Topology

/-! ## Definition of Catalan's constant

We write the alternating series in Mathlib-canonical `(-1)^n * f n` form so
that `Antitone.alternating_series_le_tendsto` applies directly. -/

/-- Positive term sequence `aₙ = 1/(2n+1)²`. -/
noncomputable def catalanTerm (n : ℕ) : ℝ := 1 / ((2 * n + 1 : ℝ) ^ 2)

/-- Catalan's constant, Bradley alternating series
    `G := Σ' (-1)^n / (2n+1)²` in Mathlib's `∑' (-1)^n * f n` form. -/
noncomputable def catalanG : ℝ := ∑' n : ℕ, (-1 : ℝ) ^ n * catalanTerm n

/-! ## Non-negativity and antitonicity of the term sequence (sanity lemmas) -/

theorem catalanTerm_pos (n : ℕ) : 0 < catalanTerm n := by
  unfold catalanTerm
  positivity

theorem catalanTerm_nonneg (n : ℕ) : 0 ≤ catalanTerm n := (catalanTerm_pos n).le

/-- The term sequence `aₙ = 1/(2n+1)²` is antitone (decreasing). -/
theorem catalanTerm_antitone : Antitone catalanTerm := by
  intro m n hmn
  unfold catalanTerm
  apply one_div_le_one_div_of_le
  · positivity
  · have hm : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
    have hn : (0 : ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
    have hmn' : (m : ℝ) ≤ n := Nat.cast_le.mpr hmn
    nlinarith

/-! ## Summability

We prove `Summable catalanTerm` by comparison with the p-series
`1/(n+1)²`. Since `2n + 1 ≥ n + 1` for all `n : ℕ`, we have
`1/(2n+1)² ≤ 1/(n+1)²`.
-/

/-- Shifted p-series `Σ 1/(n+1)²` is summable. -/
theorem summable_one_div_nat_succ_sq :
    Summable (fun n : ℕ => 1 / ((n : ℝ) + 1) ^ 2) := by
  -- `summable_one_div_nat_pow` gives `Σ 1/n^p` for `1 < p`; we use `p = 2` and shift.
  have hp : Summable (fun n : ℕ => 1 / ((n : ℝ)) ^ 2) :=
    Real.summable_one_div_nat_pow.mpr (by norm_num : (1 : ℕ) < 2)
  -- Shift index by 1.
  have hshift : Summable (fun n : ℕ => 1 / (((n + 1 : ℕ) : ℝ)) ^ 2) :=
    (summable_nat_add_iff (f := fun n : ℕ => 1 / ((n : ℝ)) ^ 2) 1).mpr hp
  -- Rewrite the coercion of `n + 1`.
  convert hshift using 1
  ext n
  push_cast
  ring

/-- The Catalan term sequence is summable. -/
theorem catalanTerm_summable : Summable catalanTerm := by
  -- Compare with `1/(n+1)²`.
  apply Summable.of_nonneg_of_le catalanTerm_nonneg _ summable_one_div_nat_succ_sq
  intro n
  unfold catalanTerm
  apply one_div_le_one_div_of_le
  · -- `0 < (n+1)²`
    have h1 : (0 : ℝ) < (n : ℝ) + 1 := by positivity
    positivity
  · -- `(n+1)² ≤ (2n+1)²`: since `n+1 ≤ 2n+1` and both positive.
    have h1 : ((n : ℝ) + 1) ≤ (2 * n + 1 : ℝ) := by
      have : (0 : ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
      linarith
    have h2 : (0 : ℝ) ≤ (n : ℝ) + 1 := by positivity
    nlinarith

/-- The absolute value of the alternating series is also summable (since
`|(-1)^n * catalanTerm n| = catalanTerm n`). -/
theorem catalanAbsTerm_summable :
    Summable (fun n : ℕ => |(-1 : ℝ) ^ n * catalanTerm n|) := by
  have habs : (fun n : ℕ => |(-1 : ℝ) ^ n * catalanTerm n|) = catalanTerm := by
    ext n
    rw [abs_mul, abs_pow, abs_neg, abs_one, one_pow, one_mul,
        abs_of_nonneg (catalanTerm_nonneg n)]
  rw [habs]
  exact catalanTerm_summable

/-! ## Term sequence tends to zero -/

/-- The Catalan term sequence tends to zero.  Follows directly from
summability (any summable series has vanishing terms). -/
theorem catalanTerm_tendsto_zero :
    Tendsto catalanTerm atTop (𝓝 0) :=
  catalanTerm_summable.tendsto_atTop_zero

/-! ## Alternating-series limit existence (HasSum form) -/

/-- The alternating series is absolutely summable, hence summable. -/
theorem catalanAlternating_summable :
    Summable (fun n : ℕ => (-1 : ℝ) ^ n * catalanTerm n) :=
  (summable_abs_iff.mp catalanAbsTerm_summable)

/-- The alternating series converges to `catalanG` in the `HasSum` sense. -/
theorem catalanG_hasSum :
    HasSum (fun n : ℕ => (-1 : ℝ) ^ n * catalanTerm n) catalanG := by
  unfold catalanG
  exact catalanAlternating_summable.hasSum

/-- Partial sums of the alternating series converge to `catalanG`. -/
theorem catalanG_tendsto :
    Tendsto (fun n : ℕ => ∑ i ∈ Finset.range n, (-1 : ℝ) ^ i * catalanTerm i)
        atTop (𝓝 catalanG) :=
  catalanG_hasSum.tendsto_sum_nat

/-! ## Bounds on Catalan's constant

Using:
- `Antitone.alternating_series_le_tendsto` — even partial sums ≤ limit.
- `Antitone.tendsto_le_alternating_series` — limit ≤ odd partial sums.

With `k = 1`, even partial sum `S_2 = a_0 - a_1 = 1 - 1/9 = 8/9` → gives `8/9 ≤ catalanG`.
With `k = 1`, odd partial sum `S_3 = 1 - 1/9 + 1/25 = 209/225 ≈ 0.928` → gives
`catalanG ≤ 209/225 < 1`.
-/

/-- Value of `catalanTerm` at `n = 0`: `catalanTerm 0 = 1`. -/
theorem catalanTerm_zero : catalanTerm 0 = 1 := by
  unfold catalanTerm
  norm_num

/-- Value of `catalanTerm` at `n = 1`: `catalanTerm 1 = 1/9`. -/
theorem catalanTerm_one : catalanTerm 1 = 1 / 9 := by
  unfold catalanTerm
  norm_num

/-- Value of `catalanTerm` at `n = 2`: `catalanTerm 2 = 1/25`. -/
theorem catalanTerm_two : catalanTerm 2 = 1 / 25 := by
  unfold catalanTerm
  norm_num

/-- Partial sum `∑_{i<2} (-1)^i · catalanTerm i = 1 - 1/9 = 8/9`.
Used for the `k = 1` lower bound: `8/9 ≤ catalanG`. -/
theorem catalanPartial_two :
    ∑ i ∈ Finset.range 2, (-1 : ℝ) ^ i * catalanTerm i = 8 / 9 := by
  rw [Finset.sum_range_succ, Finset.sum_range_succ, Finset.sum_range_zero]
  rw [catalanTerm_zero, catalanTerm_one]
  ring

/-- Partial sum `∑_{i<3} (-1)^i · catalanTerm i = 1 - 1/9 + 1/25 = 209/225`.
Used for the `k = 1` upper bound: `catalanG ≤ 209/225 < 1`. -/
theorem catalanPartial_three :
    ∑ i ∈ Finset.range 3, (-1 : ℝ) ^ i * catalanTerm i = 209 / 225 := by
  rw [Finset.sum_range_succ, Finset.sum_range_succ, Finset.sum_range_succ,
      Finset.sum_range_zero]
  rw [catalanTerm_zero, catalanTerm_one, catalanTerm_two]
  ring

/-- The tight lower bound `8/9 ≤ catalanG` from the even partial sum `S_2 = 8/9`. -/
theorem catalanG_ge_eight_ninths : (8 / 9 : ℝ) ≤ catalanG := by
  have hk1 : ∑ i ∈ Finset.range (2 * 1), (-1 : ℝ) ^ i * catalanTerm i ≤ catalanG :=
    catalanTerm_antitone.alternating_series_le_tendsto catalanG_tendsto 1
  have hrange : (2 * 1 : ℕ) = 2 := by norm_num
  rw [hrange] at hk1
  rw [catalanPartial_two] at hk1
  exact hk1

/-- **`catalanG > 0`** via the even partial sum `S_2 = 8/9 ≤ catalanG`. -/
theorem catalanG_pos : 0 < catalanG := by
  have h := catalanG_ge_eight_ninths
  linarith

/-- The tight upper bound `catalanG ≤ 209/225` from the odd partial sum `S_3 = 209/225`. -/
theorem catalanG_le_209_over_225 : catalanG ≤ (209 / 225 : ℝ) := by
  have hk1 : catalanG ≤ ∑ i ∈ Finset.range (2 * 1 + 1), (-1 : ℝ) ^ i * catalanTerm i :=
    catalanTerm_antitone.tendsto_le_alternating_series catalanG_tendsto 1
  have hrange : (2 * 1 + 1 : ℕ) = 3 := by norm_num
  rw [hrange] at hk1
  rw [catalanPartial_three] at hk1
  exact hk1

/-- **`catalanG < 1`** via the odd partial sum `catalanG ≤ 209/225 < 1`. -/
theorem catalanG_lt_one : catalanG < 1 := by
  have h := catalanG_le_209_over_225
  linarith

/-- **`catalanG > π/4`** — a sharper lower bound (since `π < 32/9` gives `π/4 < 8/9`
and we already have `8/9 ≤ catalanG`).  Numerically `G ≈ 0.9159 > π/4 ≈ 0.7854`. -/
theorem catalanG_gt_pi_over_4 : Real.pi / 4 < catalanG := by
  have hpi : Real.pi < 3.15 := Real.pi_lt_d2
  have h89 : (8 / 9 : ℝ) ≤ catalanG := catalanG_ge_eight_ninths
  -- `π/4 < 3.15/4 = 0.7875 < 8/9 ≈ 0.8889 ≤ catalanG`.
  linarith

/-! ## Layer 1 pairwise-distinctness extensions (4-way, adding G)

With `catalanG_pos` and `catalanG_lt_one` in hand, all three
`G ≠ {π, e, √2}` legs are trivial by numerical bounds. -/

/-- `catalanG < π`: `G < 1 < 3 < π`. -/
theorem ic_catalanG_lt_one_lt_pi : catalanG < Real.pi := by
  have h1 : catalanG < 1 := catalanG_lt_one
  have h3 : (3 : ℝ) < Real.pi := Real.pi_gt_three
  linarith

/-- `catalanG < e`: `G < 1 < 2 < e`. -/
theorem ic_catalanG_lt_e : catalanG < Real.exp 1 := by
  have h1 : catalanG < 1 := catalanG_lt_one
  have h3 : (2 : ℝ) < Real.exp 1 := Real.exp_one_gt_two
  linarith

/-- `catalanG < √2`: numerically `G ≈ 0.916 < √2 ≈ 1.414`.
Proved via `G < 1 < √2` (since `√1 = 1 < √2`). -/
theorem ic_catalanG_vs_sqrt2 : catalanG < Real.sqrt 2 := by
  have h1 : catalanG < 1 := catalanG_lt_one
  have h2 : (1 : ℝ) < Real.sqrt 2 := by
    have hone : (1 : ℝ) = Real.sqrt 1 := (Real.sqrt_one).symm
    rw [hone]
    exact Real.sqrt_lt_sqrt (by norm_num) (by norm_num)
  linarith

/-- `π ≠ G`. -/
theorem ic_pi_ne_catalanG : Real.pi ≠ catalanG :=
  ne_of_gt ic_catalanG_lt_one_lt_pi

/-- `e ≠ G`. -/
theorem ic_e_ne_catalanG : Real.exp 1 ≠ catalanG :=
  ne_of_gt ic_catalanG_lt_e

/-- `√2 ≠ G`. -/
theorem ic_sqrt2_ne_catalanG : Real.sqrt 2 ≠ catalanG :=
  ne_of_gt ic_catalanG_vs_sqrt2

/-! ## Layer 1 four-way bundle

Combines Alrescha's three-way bundle with the three new `G`-legs. -/

/-- **Four-way pairwise distinctness** — the full Layer 1 headline for
`{π, e, √2, G}`.  Lifts `:TheoremCandidate ic_four_irrationals_pairwise_distinct`. -/
theorem ic_four_irrationals_pairwise_distinct :
    Real.pi ≠ Real.exp 1 ∧
    Real.pi ≠ Real.sqrt 2 ∧
    Real.exp 1 ≠ Real.sqrt 2 ∧
    Real.pi ≠ catalanG ∧
    Real.exp 1 ≠ catalanG ∧
    Real.sqrt 2 ≠ catalanG :=
  ⟨ic_pi_ne_e, ic_pi_ne_sqrt2, ic_e_ne_sqrt2,
    ic_pi_ne_catalanG, ic_e_ne_catalanG, ic_sqrt2_ne_catalanG⟩

end OmegaTheory.IrrationalityClasses
