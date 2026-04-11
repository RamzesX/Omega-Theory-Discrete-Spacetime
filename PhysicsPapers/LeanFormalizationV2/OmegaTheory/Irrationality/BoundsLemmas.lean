/-
  OmegaTheory.Irrationality.BoundsLemmas

  Proven error bounds for truncated irrational approximations.
  Ported from V1 (0 sorry in V1) with Mathlib v4.29 import adaptations.

  Key results:
  - Pi error:    |π - truncated_π N|    ≤ 4/(2N+3)      (algebraic)
  - e error:     |e - truncated_e N|    ≤ 3/(N+1)!      (factorial)
  - √2 error:   |√2 - truncated_√2 N|  ≤ 1/2^{2^(N-1)} (super-exponential)
-/

import OmegaTheory.Irrationality.Approximations
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Analysis.SpecialFunctions.ExpDeriv
import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.Analysis.Real.Pi.Leibniz
import Mathlib.Topology.Algebra.InfiniteSum.NatInt
import Mathlib.Tactic

namespace OmegaTheory.Irrationality

open Real BigOperators Finset Filter Topology

/-! ## Leibniz Series Convergence

The Leibniz series converges to π/4:
  Σ_{k=0}^∞ (-1)^k/(2k+1) = π/4

This is `Real.tendsto_sum_pi_div_four` in Mathlib. -/

/-- The Leibniz series converges to π/4 (from Mathlib). -/
theorem leibniz_series_converges :
    Tendsto (fun N => (range N).sum (fun k => leibniz_term k)) atTop (nhds (pi_val / 4)) := by
  have h := Real.tendsto_sum_pi_div_four
  exact h

/-! ## Pi Error Bounds -/

/-- Error in π/4 approximation bounded by next term.
    |π/4 - Σ_{k=0}^N (-1)^k/(2k+1)| ≤ 1/(2N+3)

    Proof: alternating series estimation theorem. -/
theorem pi_quarter_error_bound (N : ℕ) :
    |pi_val / 4 - (range (N + 1)).sum (fun k => leibniz_term k)| ≤
    1 / (2 * N + 3) := by
  -- Define f(k) = 1/(2k+1), the absolute value of the k-th term
  set f : ℕ → ℝ := fun k => 1 / (2 * k + 1) with hf_def
  -- f is antitone (decreasing)
  have hf_anti : Antitone f := by
    intro m n hmn
    simp only [hf_def]
    apply one_div_le_one_div_of_le
    · positivity
    · have : (m : ℝ) ≤ n := Nat.cast_le.mpr hmn
      linarith
  -- The series has the form ∑ (-1)^k * f k
  have hform : ∀ k, leibniz_term k = (-1 : ℝ) ^ k * f k := by
    intro k; simp only [leibniz_term, hf_def, mul_one_div]
  -- Get convergence in standard form for the alternating series lemmas
  have hlim : Tendsto (fun n => ∑ k ∈ range n, (-1 : ℝ) ^ k * f k)
      atTop (nhds (pi_val / 4)) := by
    have hconv := leibniz_series_converges
    simp_rw [hform] at hconv
    exact hconv
  -- Rewrite the goal sum using f
  have htrunc : (range (N + 1)).sum (fun k => leibniz_term k) =
      ∑ k ∈ range (N + 1), (-1 : ℝ) ^ k * f k :=
    Finset.sum_congr rfl (fun k _ => hform k)
  rw [htrunc]
  -- Case analysis on parity of N+1
  rcases Nat.even_or_odd (N + 1) with ⟨m, hm⟩ | ⟨m, hm⟩
  · -- N+1 = 2m (even number of terms)
    have hm2 : N + 1 = 2 * m := by omega
    rcases Nat.eq_zero_or_pos m with rfl | _
    · simp at hm2
    -- S_{2m} ≤ π/4
    have hle : ∑ i ∈ range (2 * m), (-1 : ℝ) ^ i * f i ≤ pi_val / 4 :=
      hf_anti.alternating_series_le_tendsto hlim m
    -- π/4 ≤ S_{2m+1}
    have hge : pi_val / 4 ≤ ∑ i ∈ range (2 * m + 1), (-1 : ℝ) ^ i * f i :=
      hf_anti.tendsto_le_alternating_series hlim m
    -- S_{2m+1} = S_{2m} + f(2m)
    have hsum_succ : ∑ i ∈ range (2 * m + 1), (-1 : ℝ) ^ i * f i =
        (∑ i ∈ range (2 * m), (-1 : ℝ) ^ i * f i) + f (2 * m) := by
      rw [Finset.sum_range_succ]; congr 1
      rw [Even.neg_one_pow ⟨m, two_mul m⟩, one_mul]
    have hrange : range (N + 1) = range (2 * m) := by rw [hm2]
    rw [hrange]
    have h1 : 0 ≤ pi_val / 4 - ∑ i ∈ range (2 * m), (-1 : ℝ) ^ i * f i := by linarith
    have h2 : pi_val / 4 - ∑ i ∈ range (2 * m), (-1 : ℝ) ^ i * f i ≤ f (2 * m) := by
      rw [hsum_succ] at hge; linarith
    rw [abs_of_nonneg h1]
    have hN' : (2 : ℝ) * N + 3 = 4 * m + 1 := by
      have hN_eq : N = 2 * m - 1 := by omega
      have h1 : 1 ≤ 2 * m := by omega
      rw [hN_eq, Nat.cast_sub h1]
      simp only [Nat.cast_mul, Nat.cast_ofNat, Nat.cast_one]; ring
    calc pi_val / 4 - ∑ i ∈ range (2 * m), (-1 : ℝ) ^ i * f i
        ≤ f (2 * m) := h2
      _ = 1 / (2 * (2 * m : ℕ) + 1) := rfl
      _ = 1 / ((4 : ℝ) * m + 1) := by
          congr 1; simp only [Nat.cast_mul, Nat.cast_ofNat]; ring
      _ = 1 / (2 * N + 3) := by rw [hN']
  · -- N+1 = 2m+1 (odd number of terms)
    have hge : pi_val / 4 ≤ ∑ i ∈ range (2 * m + 1), (-1 : ℝ) ^ i * f i :=
      hf_anti.tendsto_le_alternating_series hlim m
    have hle : ∑ i ∈ range (2 * (m + 1)), (-1 : ℝ) ^ i * f i ≤ pi_val / 4 :=
      hf_anti.alternating_series_le_tendsto hlim (m + 1)
    have hsum_succ : ∑ i ∈ range (2 * (m + 1)), (-1 : ℝ) ^ i * f i =
        (∑ i ∈ range (2 * m + 1), (-1 : ℝ) ^ i * f i) - f (2 * m + 1) := by
      rw [show 2 * (m + 1) = 2 * m + 1 + 1 by ring, Finset.sum_range_succ]
      have hodd : Odd (2 * m + 1) := ⟨m, two_mul m ▸ rfl⟩
      simp only [Odd.neg_one_pow hodd, neg_one_mul]; ring
    have hrange : range (N + 1) = range (2 * m + 1) := by rw [hm]
    rw [hrange]
    have h1 : (∑ i ∈ range (2 * m + 1), (-1 : ℝ) ^ i * f i) - pi_val / 4 ≥ 0 := by linarith
    have h2 : (∑ i ∈ range (2 * m + 1), (-1 : ℝ) ^ i * f i) - pi_val / 4 ≤
        f (2 * m + 1) := by rw [hsum_succ] at hle; linarith
    rw [abs_sub_comm, abs_of_nonneg h1]
    have hN' : (2 : ℝ) * N + 3 = 4 * m + 3 := by
      have : N = 2 * m := by omega
      simp only [this, Nat.cast_mul, Nat.cast_ofNat]; ring
    calc (∑ i ∈ range (2 * m + 1), (-1 : ℝ) ^ i * f i) - pi_val / 4
        ≤ f (2 * m + 1) := h2
      _ = 1 / (2 * ((2 * m + 1 : ℕ)) + 1) := rfl
      _ = 1 / ((4 : ℝ) * m + 3) := by
          congr 1
          simp only [Nat.cast_add, Nat.cast_mul, Nat.cast_ofNat, Nat.cast_one]; ring
      _ = 1 / (2 * N + 3) := by rw [hN']

/-- Main π error bound: |π - truncated_π(N)| ≤ 4/(2N+3). -/
theorem pi_error_bound (N : ℕ) :
    |pi_val - truncated_pi N| ≤ 4 / (2 * N + 3) := by
  have h := pi_quarter_error_bound N
  simp only [truncated_pi]
  calc |pi_val - 4 * (range (N + 1)).sum (fun k => leibniz_term k)|
      = |4 * (pi_val / 4 - (range (N + 1)).sum (fun k => leibniz_term k))| := by ring_nf
    _ = 4 * |pi_val / 4 - (range (N + 1)).sum (fun k => leibniz_term k)| := by
        rw [abs_mul, abs_of_pos (by norm_num : (0:ℝ) < 4)]
    _ ≤ 4 * (1 / (2 * N + 3)) := by nlinarith [abs_nonneg (pi_val / 4 - (range (N + 1)).sum (fun k => leibniz_term k))]
    _ = 4 / (2 * N + 3) := by ring

/-! ## Euler's Number Error Bounds -/

/-- e is always greater than its truncated Taylor series. -/
theorem e_error_positive (N : ℕ) : euler_e - truncated_e N > 0 := by
  have hpartial : ∑ k ∈ range (N + 1), (1 : ℝ) / (k.factorial : ℝ) ≤ Real.exp 1 := by
    have h := Real.sum_le_exp_of_nonneg (by norm_num : (0 : ℝ) ≤ 1) (N + 1)
    simp only [one_pow] at h
    exact h
  have hstrict : ∑ k ∈ range (N + 1), (1 : ℝ) / (k.factorial : ℝ) < Real.exp 1 := by
    have hN2_gt : ∑ k ∈ range (N + 2), (1 : ℝ) / (k.factorial : ℝ) >
        ∑ k ∈ range (N + 1), (1 : ℝ) / (k.factorial : ℝ) := by
      rw [Finset.sum_range_succ]
      have hterm_pos : (1 : ℝ) / ((N + 1).factorial : ℝ) > 0 :=
        div_pos one_pos (Nat.cast_pos.mpr (Nat.factorial_pos _))
      linarith
    have hN2_le : ∑ k ∈ range (N + 2), (1 : ℝ) / (k.factorial : ℝ) ≤ Real.exp 1 := by
      have h := Real.sum_le_exp_of_nonneg (by norm_num : (0 : ℝ) ≤ 1) (N + 2)
      simp only [one_pow] at h
      exact h
    linarith
  unfold truncated_e taylor_e_term euler_e
  linarith

/-- Main e error bound: |e - truncated_e(N)| ≤ 3/(N+1)!. -/
theorem e_error_bound (N : ℕ) :
    |euler_e - truncated_e N| ≤ 3 / ((N + 1).factorial : ℝ) := by
  -- The error is positive, so |error| = error
  have hpos := e_error_positive N
  rw [abs_of_pos hpos]
  unfold euler_e truncated_e taylor_e_term
  -- Use Real.exp_bound for n = N+1
  have habs : |(1 : ℝ)| ≤ 1 := by norm_num
  have hN1 : 0 < N + 1 := Nat.succ_pos N
  have hbound := Real.exp_bound habs hN1
  simp only [one_pow, abs_one, one_mul, Nat.succ_eq_add_one] at hbound
  -- hbound: |exp 1 - ∑_{k < N+1} 1/k!| ≤ (N+2) / ((N+1)! * (N+1))
  have hdiff_nonneg : Real.exp 1 - ∑ k ∈ range (N + 1), (1 : ℝ) / (k.factorial : ℝ) ≥ 0 := by
    have h := Real.sum_le_exp_of_nonneg (by norm_num : (0 : ℝ) ≤ 1) (N + 1)
    simp only [one_pow] at h
    linarith
  rw [abs_of_nonneg hdiff_nonneg] at hbound
  -- Now show (N+2) / ((N+1)! * (N+1)) ≤ 3 / (N+1)!
  have hfact_pos : ((N + 1).factorial : ℝ) > 0 := Nat.cast_pos.mpr (Nat.factorial_pos _)
  have hN1_pos : ((N + 1 : ℕ) : ℝ) > 0 := by positivity
  have hkey : ((N + 2 : ℕ) : ℝ) / (((N + 1).factorial : ℝ) * ((N + 1 : ℕ) : ℝ)) ≤
      3 / ((N + 1).factorial : ℝ) := by
    rw [div_le_div_iff₀ (by positivity) hfact_pos]
    have hineq : ((N + 2 : ℕ) : ℝ) ≤ 3 * ((N + 1 : ℕ) : ℝ) := by
      simp only [Nat.cast_add, Nat.cast_one, Nat.cast_ofNat]
      have : (N : ℝ) ≥ 0 := Nat.cast_nonneg N
      linarith
    calc ((N + 2 : ℕ) : ℝ) * ((N + 1).factorial : ℝ)
        ≤ (3 * ((N + 1 : ℕ) : ℝ)) * ((N + 1).factorial : ℝ) := by nlinarith
      _ = 3 * (((N + 1).factorial : ℝ) * ((N + 1 : ℕ) : ℝ)) := by ring
  linarith [hbound, hkey]

/-! ## Square Root of 2 Error Bounds -/

/-- √2 error for Newton-Raphson: |truncated_√2(N) - √2| ≤ 1/2^{2^(N-1)}.
    Newton-Raphson has QUADRATIC convergence: each step doubles precision. -/
theorem sqrt2_error_bound (N : ℕ) (hN : N ≥ 1) :
    |truncated_sqrt2 N - sqrt2| ≤ 1 / (2 : ℝ) ^ (2 ^ (N - 1)) := by
  induction N with
  | zero => omega
  | succ n ih =>
    have hge : truncated_sqrt2 (n + 1) ≥ sqrt2 :=
      truncated_sqrt2_ge_target (n + 1) hN
    have hpos_err : truncated_sqrt2 (n + 1) - sqrt2 ≥ 0 := by linarith
    rw [abs_of_nonneg hpos_err]
    rcases Nat.eq_zero_or_pos n with rfl | hn_pos
    · -- Base case: N = 1
      show truncated_sqrt2 1 - sqrt2 ≤ 1 / (2 : ℝ) ^ (2 ^ 0)
      simp only [pow_zero, pow_one, truncated_sqrt2_one, sqrt2]
      -- Goal: 3/2 - Real.sqrt 2 ≤ 1/2
      have : Real.sqrt 2 > 1 := by
        rw [gt_iff_lt, Real.lt_sqrt (by norm_num)]; norm_num
      linarith
    · -- Inductive case: n ≥ 1
      have hn1 : n ≥ 1 := hn_pos
      have hge_n : truncated_sqrt2 n ≥ sqrt2 :=
        truncated_sqrt2_ge_target n hn1
      have hpos_n : truncated_sqrt2 n > 0 := truncated_sqrt2_pos n
      have hpos_err_n : truncated_sqrt2 n - sqrt2 ≥ 0 := by linarith
      have ih_applied := ih hn1
      rw [abs_of_nonneg hpos_err_n] at ih_applied
      have hrec := sqrt2_error_recurrence n hn1
      rw [hrec]
      -- 2 * truncated_sqrt2 n ≥ 1 (since truncated_sqrt2 n ≥ √2 > 1)
      have hsqrt2_gt_one : sqrt2 > 1 := by
        unfold sqrt2; rw [gt_iff_lt, Real.lt_sqrt (by norm_num)]; norm_num
      have h2x_ge_1 : 2 * truncated_sqrt2 n ≥ 1 := by nlinarith
      -- Square the IH bound
      have hsq_bound : (truncated_sqrt2 n - sqrt2) ^ 2 ≤
          (1 / (2 : ℝ) ^ (2 ^ (n - 1))) ^ 2 := by
        apply sq_le_sq'
        · have : (1 : ℝ) / (2 : ℝ) ^ (2 ^ (n - 1)) > 0 := by positivity
          linarith
        · exact ih_applied
      -- (1/2^k)² = 1/2^{2k} = 1/2^{2^n}
      have hpow_sq : ((1 : ℝ) / (2 : ℝ) ^ (2 ^ (n - 1))) ^ 2 =
          1 / (2 : ℝ) ^ (2 ^ n) := by
        have hexp : 2 ^ (n - 1) * 2 = 2 ^ n := by
          rw [show 2 ^ (n - 1) * 2 = 2 ^ ((n - 1) + 1) from by ring]
          congr 1; omega
        field_simp; rw [← pow_mul]; congr 1; exact hexp.symm
      simp only [Nat.add_sub_cancel]
      calc (truncated_sqrt2 n - sqrt2) ^ 2 / (2 * truncated_sqrt2 n)
          ≤ ((1 : ℝ) / (2 : ℝ) ^ (2 ^ (n - 1))) ^ 2 /
            (2 * truncated_sqrt2 n) := by
            apply div_le_div_of_nonneg_right hsq_bound (by linarith)
        _ = (1 / (2 : ℝ) ^ (2 ^ n)) / (2 * truncated_sqrt2 n) := by
            rw [hpow_sq]
        _ ≤ (1 / (2 : ℝ) ^ (2 ^ n)) / 1 := by
            apply div_le_div_of_nonneg_left (by positivity) (by norm_num)
              h2x_ge_1
        _ = 1 / (2 : ℝ) ^ (2 ^ n) := by ring

/-- Specific values for verification. -/
theorem sqrt2_error_one : |truncated_sqrt2 1 - sqrt2| < 1 / 10 := by
  simp only [truncated_sqrt2_one, sqrt2]
  have hsqrt_lb : Real.sqrt 2 > 14 / 10 := by
    have h1 : (14 / 10 : ℝ) ^ 2 < 2 := by norm_num
    have h3 : Real.sqrt ((14 / 10 : ℝ) ^ 2) < Real.sqrt 2 := Real.sqrt_lt_sqrt (by norm_num) h1
    simp only [Real.sqrt_sq (by norm_num : (0 : ℝ) ≤ 14 / 10)] at h3
    exact h3
  have hsqrt_ub : Real.sqrt 2 < 15 / 10 := by
    have h1 : (2 : ℝ) < (15 / 10) ^ 2 := by norm_num
    have h3 : Real.sqrt 2 < Real.sqrt ((15 / 10 : ℝ) ^ 2) := Real.sqrt_lt_sqrt (by norm_num) h1
    simp only [Real.sqrt_sq (by norm_num : (0 : ℝ) ≤ 15 / 10)] at h3
    exact h3
  rw [abs_sub_lt_iff]
  constructor <;> linarith

theorem sqrt2_error_two : |truncated_sqrt2 2 - sqrt2| < 1 / 100 := by
  simp only [truncated_sqrt2_two, sqrt2]
  have hsqrt_lb : Real.sqrt 2 > 141 / 100 := by
    have h1 : (141 / 100 : ℝ) ^ 2 < 2 := by norm_num
    have h3 : Real.sqrt ((141 / 100 : ℝ) ^ 2) < Real.sqrt 2 := Real.sqrt_lt_sqrt (by norm_num) h1
    simp only [Real.sqrt_sq (by norm_num : (0 : ℝ) ≤ 141 / 100)] at h3
    exact h3
  have hsqrt_ub : Real.sqrt 2 < 17 / 12 := by
    have h1 : (2 : ℝ) < (17 / 12) ^ 2 := by norm_num
    have h3 : Real.sqrt 2 < Real.sqrt ((17 / 12 : ℝ) ^ 2) := Real.sqrt_lt_sqrt (by norm_num) h1
    simp only [Real.sqrt_sq (by norm_num : (0 : ℝ) ≤ 17 / 12)] at h3
    exact h3
  rw [abs_sub_lt_iff]
  constructor <;> linarith

/-! ## Convergence to Zero -/

theorem pi_error_tendsto_zero :
    Tendsto (fun N => |pi_val - truncated_pi N|) atTop (nhds 0) := by
  -- Derive truncated_pi → pi_val from leibniz_series_converges
  have hconv : Tendsto truncated_pi atTop (nhds pi_val) := by
    have h := leibniz_series_converges
    have h1 := h.comp (tendsto_add_atTop_nat 1)
    -- h1: Tendsto (fun N => ∑ k ∈ range (N+1), leibniz_term k) atTop (nhds (pi_val/4))
    have h2 : Tendsto (fun N => (4 : ℝ) * ∑ k ∈ range (N + 1),
        leibniz_term k) atTop (nhds (4 * (pi_val / 4))) :=
      (tendsto_const_nhds).mul h1
    simp only [show (4 : ℝ) * (pi_val / 4) = pi_val from by ring] at h2
    exact h2
  rw [Metric.tendsto_atTop] at hconv ⊢
  intro ε hε; obtain ⟨N, hN⟩ := hconv ε hε; use N; intro n hn
  simp only [Real.dist_eq, sub_zero]
  rw [abs_abs, abs_sub_comm]
  have := hN n hn; rwa [Real.dist_eq] at this

theorem e_error_tendsto_zero :
    Tendsto (fun N => |euler_e - truncated_e N|) atTop (nhds 0) := by
  rw [Metric.tendsto_atTop]
  intro ε hε
  -- 3/(N+1)! < ε for large N. We need (N+1)! > 3/ε.
  obtain ⟨M, hM⟩ : ∃ M : ℕ, (3 : ℝ) / ε < (M.factorial : ℝ) := by
    have h3ε : (3 : ℝ) / ε > 0 := div_pos (by norm_num) hε
    exact ⟨max 2 (Nat.ceil (3 / ε) + 1), by
      calc ((max 2 (Nat.ceil (3 / ε) + 1)).factorial : ℝ)
          ≥ (max 2 (Nat.ceil (3 / ε) + 1) : ℝ) := by
            exact_mod_cast Nat.self_le_factorial _
        _ ≥ (Nat.ceil (3 / ε) + 1 : ℝ) := by
            push_cast; exact le_max_right _ _
        _ > 3 / ε := by linarith [Nat.le_ceil (3 / ε)]⟩
  use M
  intro n hn
  simp only [Real.dist_eq, sub_zero, abs_abs]
  calc |euler_e - truncated_e n|
      ≤ 3 / ((n + 1).factorial : ℝ) := e_error_bound n
    _ ≤ 3 / (M.factorial : ℝ) := by
        apply div_le_div_of_nonneg_left (by norm_num : (0:ℝ) ≤ 3)
          (Nat.cast_pos.mpr (Nat.factorial_pos _))
          (Nat.cast_le.mpr (Nat.factorial_le (by omega)))
    _ < ε := by
        rw [div_lt_iff₀ (Nat.cast_pos.mpr (Nat.factorial_pos _))]
        have := (div_lt_iff₀ hε).mp hM
        linarith

theorem sqrt2_error_tendsto_zero :
    Tendsto (fun N => |truncated_sqrt2 N - sqrt2|) atTop (nhds 0) := by
  rw [Metric.tendsto_atTop]
  intro ε hε
  obtain ⟨K, hK⟩ : ∃ K : ℕ, (1 : ℝ) / (2 : ℝ) ^ K < ε := by
    obtain ⟨k, hk⟩ := exists_pow_lt_of_lt_one hε (by norm_num : (1 / 2 : ℝ) < 1)
    exact ⟨k, by rwa [div_pow, one_pow] at hk⟩
  use K + 1
  intro n hn
  simp only [Real.dist_eq, sub_zero, abs_abs]
  rcases Nat.eq_zero_or_pos n with rfl | hn_pos
  · omega
  · calc |truncated_sqrt2 n - sqrt2|
        ≤ 1 / (2 : ℝ) ^ (2 ^ (n - 1)) := sqrt2_error_bound n hn_pos
      _ ≤ 1 / (2 : ℝ) ^ K := by
          apply div_le_div_of_nonneg_left (by norm_num : (0:ℝ) ≤ 1)
            (by positivity)
            (pow_le_pow_right₀ (by norm_num : (1:ℝ) ≤ 2) (by
              calc K ≤ n - 1 := by omega
                _ ≤ 2 ^ (n - 1) :=
                  (show n - 1 < 2 ^ (n - 1) from
                    Nat.lt_pow_self (show 1 < 2 by norm_num)).le))
      _ < ε := hK

/-! ## Required Iterations for Given Precision -/

/-- Iterations needed for π to precision ε: N ≥ ⌈(4/ε - 3)/2⌉. -/
noncomputable def required_iterations_pi (epsilon : ℝ) (heps : epsilon > 0) : ℕ :=
  Nat.ceil ((4 / epsilon - 3) / 2)

/-- Iterations needed for √2 to precision ε: N ≥ ⌈1 + log₂(log₂(1/ε))⌉. -/
noncomputable def required_iterations_sqrt2 (epsilon : ℝ) (heps : epsilon > 0) : ℕ :=
  max 1 (Nat.ceil (1 + Real.log (Real.log (1 / epsilon) / Real.log 2) / Real.log 2))

end OmegaTheory.Irrationality
