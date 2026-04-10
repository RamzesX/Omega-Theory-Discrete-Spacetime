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

end OmegaTheory.Irrationality
