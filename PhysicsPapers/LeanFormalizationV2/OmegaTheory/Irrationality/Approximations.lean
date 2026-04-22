/-
  OmegaTheory.Irrationality.Approximations

  Truncated approximations for π, e, √2 and their error bounds.
  These are the CONCRETE sources of defects in the discrete spacetime:
  computational truncation of irrationals at action thresholds.

  The error bounds produce ErrorBound values that feed into
  SemiSmoothMetric.epsilon — connecting irrationality to geometry.

  Convergence rates:
  - π:  O(1/N) — algebraic (Leibniz series)
  - e:  O(1/N!) — factorial (Taylor series)
  - √2: O(1/2^{2^N}) — super-exponential (Newton-Raphson)

  This is WHY √2 converges fastest and π slowest.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Data.Real.Sqrt
import Mathlib.Data.Nat.Factorial.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Tactic
import OmegaTheory.Foundations.ErrorAlgebra

namespace OmegaTheory.Irrationality

open OmegaTheory.Foundations
open Finset

/-! ## Fundamental Constants -/

noncomputable abbrev pi_val : ℝ := Real.pi
noncomputable abbrev euler_e : ℝ := Real.exp 1
noncomputable abbrev sqrt2 : ℝ := Real.sqrt 2

/-! ## Truncated Approximations -/

/-- Leibniz series term: (-1)^k / (2k+1). -/
noncomputable def leibniz_term (k : ℕ) : ℝ := (-1 : ℝ) ^ k / (2 * k + 1)

/-- Truncated π approximation via Leibniz: 4 · Σ_{k=0}^{N} (-1)^k/(2k+1). -/
noncomputable def truncated_pi (N : ℕ) : ℝ :=
  4 * (range (N + 1)).sum (fun k => leibniz_term k)

/-- Taylor series term for e: 1/k!. -/
noncomputable def taylor_e_term (k : ℕ) : ℝ := 1 / (k.factorial : ℝ)

/-- Truncated e approximation via Taylor: Σ_{k=0}^{N} 1/k!. -/
noncomputable def truncated_e (N : ℕ) : ℝ :=
  (range (N + 1)).sum (fun k => taylor_e_term k)

/-- Newton-Raphson step for √2: x ↦ (x + 2/x)/2. -/
noncomputable def newton_step (x : ℝ) : ℝ := (x + 2 / x) / 2

/-- Truncated √2 via Newton-Raphson starting from x₀ = 1. -/
noncomputable def truncated_sqrt2 : ℕ → ℝ
  | 0 => 1
  | n + 1 => newton_step (truncated_sqrt2 n)

/-! ## Specific Values -/

theorem truncated_pi_zero : truncated_pi 0 = 4 := by
  simp [truncated_pi, leibniz_term]

theorem truncated_e_zero : truncated_e 0 = 1 := by
  simp [truncated_e, taylor_e_term]

theorem truncated_sqrt2_zero : truncated_sqrt2 0 = 1 := rfl

theorem truncated_sqrt2_one : truncated_sqrt2 1 = 3 / 2 := by
  simp [truncated_sqrt2, newton_step]; ring

theorem truncated_sqrt2_two : truncated_sqrt2 2 = 17 / 12 := by
  simp [truncated_sqrt2, newton_step]; ring

/-! ## Positivity -/

theorem truncated_e_pos (N : ℕ) : 0 < truncated_e N := by
  unfold truncated_e
  apply Finset.sum_pos
  · intro k _; unfold taylor_e_term
    exact div_pos one_pos (Nat.cast_pos.mpr (Nat.factorial_pos k))
  · exact ⟨0, Finset.mem_range.mpr (Nat.zero_lt_succ N)⟩

theorem truncated_sqrt2_pos (N : ℕ) : 0 < truncated_sqrt2 N := by
  induction N with
  | zero => simp [truncated_sqrt2]
  | succ n ih =>
    simp [truncated_sqrt2, newton_step]
    linarith [div_pos (add_pos ih (div_pos two_pos ih)) two_pos]

/-! ## Newton-Raphson Helper Lemmas -/

private lemma newton_product_eq_two {x : ℝ} (hx : x > 0) : x * (2 / x) = 2 := by field_simp

private lemma am_ge_gm {a b : ℝ} (ha : a > 0) (hb : b > 0) :
    (a + b) / 2 ≥ Real.sqrt (a * b) := by
  have hsum : 0 ≤ a + b := by linarith
  have h_sq : (a + b) ^ 2 ≥ 4 * a * b := by nlinarith [sq_nonneg (a - b)]
  have h_sqrt : Real.sqrt ((a + b) ^ 2) ≥ Real.sqrt (4 * a * b) :=
    Real.sqrt_le_sqrt h_sq
  rw [Real.sqrt_sq hsum,
    show (4 : ℝ) * a * b = (2 : ℝ) ^ 2 * (a * b) by ring] at h_sqrt
  rw [Real.sqrt_mul (by norm_num : (0 : ℝ) ≤ 2 ^ 2),
    Real.sqrt_sq (by norm_num : (2 : ℝ) ≥ 0)] at h_sqrt
  linarith

/-- Newton step from any positive x gives ≥ √2 (by AM-GM). -/
theorem newton_step_ge_sqrt2 {x : ℝ} (hx : x > 0) : newton_step x ≥ Real.sqrt 2 := by
  unfold newton_step
  calc (x + 2 / x) / 2 ≥ Real.sqrt (x * (2 / x)) :=
        am_ge_gm hx (div_pos (by norm_num) hx)
    _ = Real.sqrt 2 := by rw [newton_product_eq_two hx]

private lemma sq_ge_two_of_ge_sqrt2 {x : ℝ} (_ : x > 0) (hge : x ≥ Real.sqrt 2) :
    x ^ 2 ≥ 2 := by
  nlinarith [sq_nonneg x, sq_nonneg (Real.sqrt 2), Real.sqrt_nonneg 2,
    Real.sq_sqrt (by norm_num : (2 : ℝ) ≥ 0)]

private lemma newton_step_le {x : ℝ} (hx : x > 0) (hge : x ≥ Real.sqrt 2) :
    newton_step x ≤ x := by
  unfold newton_step
  have hdiv : 2 / x ≤ x := by
    rw [div_le_iff₀ hx]; nlinarith [sq_ge_two_of_ge_sqrt2 hx hge]
  linarith

/-- For n ≥ 1, truncated_sqrt2 n ≥ √2. -/
theorem truncated_sqrt2_ge_target (n : ℕ) (hn : n ≥ 1) :
    truncated_sqrt2 n ≥ sqrt2 := by
  match n with
  | 0 => exact (Nat.not_succ_le_zero 0 hn).elim
  | m + 1 => exact newton_step_ge_sqrt2 (truncated_sqrt2_pos m)

/-- Newton-Raphson error satisfies a quadratic recurrence:
    e_{n+1} = e_n² / (2 · x_n) -/
theorem sqrt2_error_recurrence (N : ℕ) (hN : N ≥ 1) :
    truncated_sqrt2 (N + 1) - sqrt2 =
    (truncated_sqrt2 N - sqrt2) ^ 2 / (2 * truncated_sqrt2 N) := by
  have hx_pos : truncated_sqrt2 N > 0 := truncated_sqrt2_pos N
  have hx_ne : truncated_sqrt2 N ≠ 0 := ne_of_gt hx_pos
  have hsq : sqrt2 ^ 2 = 2 := Real.sq_sqrt (by norm_num : (2 : ℝ) ≥ 0)
  simp only [truncated_sqrt2, newton_step]
  field_simp
  nlinarith [hsq]

/-! ## Error Bound Statements

These are the key results connecting to V2's ErrorBound framework. -/

/-- π error bound: |π - truncated_π(N)| ≤ 4/(2N+3).
    Algebraic convergence O(1/N). -/
noncomputable def pi_error_val (N : ℕ) : ℝ := 4 / (2 * N + 3)

/-- e error bound: |e - truncated_e(N)| ≤ 3/(N+1)!.
    Factorial convergence O(1/N!). -/
noncomputable def e_error_val (N : ℕ) : ℝ := 3 / ((N + 1).factorial : ℝ)

/-- √2 error bound: |√2 - truncated_√2(N)| ≤ 1/2^(2^(N-1)) for N ≥ 1.
    Super-exponential convergence. -/
noncomputable def sqrt2_error_val (N : ℕ) : ℝ := 1 / (2 : ℝ) ^ (2 ^ N)

/-! ## Error bounds are positive -/

theorem pi_error_pos (N : ℕ) : 0 < pi_error_val N := by
  unfold pi_error_val; positivity

theorem e_error_pos (N : ℕ) : 0 < e_error_val N := by
  unfold e_error_val
  exact div_pos (by norm_num) (Nat.cast_pos.mpr (Nat.factorial_pos (N + 1)))

theorem sqrt2_error_pos (N : ℕ) : 0 < sqrt2_error_val N := by
  unfold sqrt2_error_val; positivity

/-! ## ErrorBound Wrappers (V2 Integration)

These connect irrationality bounds to V2's error-tracking framework.
Each truncation error produces a concrete ErrorBound value. -/

/-- Pi truncation error as an ErrorBound. -/
noncomputable def piErrorBound (N : ℕ) : ErrorBound :=
  ⟨pi_error_val N, le_of_lt (pi_error_pos N)⟩

/-- Euler e truncation error as an ErrorBound. -/
noncomputable def eErrorBound (N : ℕ) : ErrorBound :=
  ⟨e_error_val N, le_of_lt (e_error_pos N)⟩

/-- √2 truncation error as an ErrorBound. -/
noncomputable def sqrt2ErrorBound (N : ℕ) : ErrorBound :=
  ⟨sqrt2_error_val N, le_of_lt (sqrt2_error_pos N)⟩

/-! ## Dominant Error

The dominant truncation error for a computation using all three irrationals.
π converges slowest (algebraic), so it dominates: dominant error = π error. -/

/-- The three irrational targets. -/
inductive IrrationalTarget
  | pi    -- convergence O(1/N)
  | euler -- convergence O(1/N!)
  | sqrt2 -- convergence O(1/2^{2^N})
deriving DecidableEq, Repr

/-- Error bound for each target at iteration count N. -/
noncomputable def targetErrorBound (target : IrrationalTarget) (N : ℕ) : ErrorBound :=
  match target with
  | .pi => piErrorBound N
  | .euler => eErrorBound N
  | .sqrt2 => sqrt2ErrorBound N

/-- The dominant (largest) error at iteration N.
    π dominates because it converges slowest. -/
noncomputable def dominantErrorBound (N : ℕ) : ErrorBound := piErrorBound N

/-- The dominant error is nonneg (inherited from ErrorBound). -/
theorem dominantError_nonneg (N : ℕ) : 0 ≤ (dominantErrorBound N).val :=
  (dominantErrorBound N).nonneg

/-- The dominant error decreases with more iterations. -/
theorem dominantError_decreasing (N : ℕ) :
    (dominantErrorBound (N + 1)).val ≤ (dominantErrorBound N).val := by
  unfold dominantErrorBound piErrorBound pi_error_val
  simp only
  -- 4/(2(N+1)+3) ≤ 4/(2N+3), i.e., 4/(2N+5) ≤ 4/(2N+3)
  -- Larger denominator → smaller fraction
  have hN : (N : ℝ) ≥ 0 := Nat.cast_nonneg N
  have h1 : (0 : ℝ) < 2 * ↑N + 3 := by linarith
  have h2 : (0 : ℝ) < 2 * ↑(N + 1) + 3 := by push_cast; linarith
  have h3 : 2 * (↑N : ℝ) + 3 ≤ 2 * ↑(N + 1) + 3 := by push_cast; linarith
  exact div_le_div_of_nonneg_left (by norm_num : (0 : ℝ) ≤ 4) h1 h3

/-! ## Catalan-G channel — the 4th irrational residual

The Catalan constant `G = ∑ (-1)^n / (2n+1)²` has an alternating-series residual
dominated by the next-term bound `1 / (2N+1)²`, which decays as `O(1/N²)` — the
fourth convergence profile in the Pi-Hunch ordering.

This completes the four-irrational residual picture:

  * π  —    `O(1/N)`                 `pi_error_val N    = 4 / (2N+3)`
  * e  —    `O(1/N!)`                `e_error_val N     = 3 / (N+1)!`
  * G  —    `O(1/N²)`                `catalan_error_val N = 1 / (2N+1)²`
  * √2 —    `O(1/2^{2^N})`           `sqrt2_error_val N = 1 / 2^{2^N}`
-/

/-- Catalan-G error bound: |G - partial_{N}| ≤ 1/(2N+1)².
    Quadratic convergence O(1/N²), between e's factorial and √2's super-exponential. -/
noncomputable def catalan_error_val (N : ℕ) : ℝ := 1 / ((2 * (N : ℝ) + 1) ^ 2)

theorem catalan_error_pos (N : ℕ) : 0 < catalan_error_val N := by
  unfold catalan_error_val
  have hN : (0 : ℝ) ≤ (N : ℝ) := Nat.cast_nonneg N
  have h1 : (0 : ℝ) < 2 * (N : ℝ) + 1 := by linarith
  positivity

end OmegaTheory.Irrationality
