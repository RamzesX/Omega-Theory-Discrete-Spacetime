/-
  Irrationality.Bounds.TightBound
  ===============================

  Tighter Euler error bound theorem.

  MATHEMATICAL STATUS: STANDARD RESULT
  ====================================

  This is a well-known tail bound for the exponential series, found in any
  standard analysis textbook. The proof is elementary:

  PROOF SKETCH:
  -------------
  Let R_N = Σ_{k≥N+1} 1/k! be the tail sum.

  R_N = 1/(N+1)! · (1 + 1/(N+2) + 1/((N+2)(N+3)) + ...)

  Each subsequent term is ≤ 1/(N+2) times the previous, so:

  R_N ≤ 1/(N+1)! · Σ_{j≥0} 1/(N+2)^j
      = 1/(N+1)! · (N+2)/(N+1)

  For N ≥ 1: (N+2)/(N+1) ≤ 3/2 < 2

  Therefore: R_N ≤ 2/(N+1)!  ∎

  LITERATURE REFERENCES:
  ----------------------
  1. Rudin, W. "Principles of Mathematical Analysis" (3rd ed.), McGraw-Hill, 1976
     - Chapter 8, Theorem 8.1 and exercises on exponential series

  2. Apostol, T. "Mathematical Analysis" (2nd ed.), Addison-Wesley, 1974
     - Section 9.15, Taylor series remainder estimates

  3. Wikipedia: "Taylor's theorem"
     https://en.wikipedia.org/wiki/Taylor%27s_theorem
     - Section on Lagrange form of remainder and exponential function

  4. Wikipedia: "Taylor series"
     https://en.wikipedia.org/wiki/Taylor_series
     - Section on Maclaurin series of exponential function

  5. Khan Academy: "Lagrange error bound"
     https://www.khanacademy.org/math/ap-calculus-bc/bc-series-new/bc-10-12/v/lagrange-error-bound-exponential-example

  MATHLIB NOTE:
  -------------
  In Mathlib, related bounds can be found in:
  - Mathlib.Analysis.SpecialFunctions.ExpDeriv (exp_bound)
  - Mathlib.Analysis.SpecialFunctions.Pow.Real

  The exact form 2/(N+1)! may require manual derivation from geometric series
  bounds, but is completely standard undergraduate material.

  FORMALIZATION STATUS: LEFT AS SORRY
  -----------------------------------
  This theorem is mathematically trivial (standard textbook result) but
  formalizing it in Lean would require careful setup of tail sum machinery.
  Not a priority for the discrete spacetime formalization project.
-/

import DiscreteSpacetime.Irrationality.Bounds.Common

namespace DiscreteSpacetime.Irrationality

open Real BigOperators Finset Filter Topology

/-! ## Tighter Euler Error Bound

    Refined bound: the error is less than 2 times the first omitted term for N >= 1

    This is a standard result from undergraduate analysis.
    See literature references in file header.
-/

/-- Refined bound: the error is less than 2 times the first omitted term for N >= 1

    Standard tail bound for exponential series. Proof: geometric series comparison.
    References: Rudin Ch.8, Apostol 9.15, any calculus textbook.
-/
theorem e_error_tight_bound (N : ℕ) (hN : N ≥ 1) :
    euler_e - truncated_e N ≤ 2 / ((N + 1).factorial : ℝ) := by
  -- Use Real.exp_bound: |exp 1 - ∑_{k<n} 1/k!| ≤ (n+1)/(n!·n) for |1| ≤ 1, n ≥ 1
  unfold euler_e truncated_e taylor_e_term
  have hN1 : N + 1 ≥ 1 := Nat.le_add_left 1 N
  have habs : |(1 : ℝ)| ≤ 1 := by norm_num
  have hbound := Real.exp_bound habs hN1
  simp only [one_pow, abs_one, one_mul, Nat.succ_eq_add_one] at hbound
  -- hbound: |exp 1 - ∑_{k<N+1} 1/k!| ≤ (N+2) / ((N+1)! * (N+1))
  have hdiff_nonneg : Real.exp 1 - ∑ k ∈ Finset.range (N + 1), (1 : ℝ) / (k.factorial : ℝ) ≥ 0 := by
    have h := Real.sum_le_exp_of_nonneg (by norm_num : (0 : ℝ) ≤ 1) (N + 1)
    simp only [one_pow] at h
    linarith
  rw [abs_of_nonneg hdiff_nonneg] at hbound
  -- Show (N+2) / ((N+1)! * (N+1)) ≤ 2 / (N+1)!
  -- Equivalent to: (N+2) ≤ 2 * (N+1), i.e., N+2 ≤ 2N+2, always true
  have hfact_pos : ((N + 1).factorial : ℝ) > 0 := Nat.cast_pos.mpr (Nat.factorial_pos _)
  have hN1_pos : ((N + 1 : ℕ) : ℝ) > 0 := by positivity
  have hkey : ((N + 2 : ℕ) : ℝ) / (((N + 1).factorial : ℝ) * ((N + 1 : ℕ) : ℝ)) ≤
              2 / ((N + 1).factorial : ℝ) := by
    rw [div_le_div_iff (by positivity) hfact_pos]
    have hineq : ((N + 2 : ℕ) : ℝ) ≤ 2 * ((N + 1 : ℕ) : ℝ) := by
      simp only [Nat.cast_add, Nat.cast_one, Nat.cast_ofNat]
      have : (N : ℝ) ≥ 0 := Nat.cast_nonneg N
      linarith
    calc ((N + 2 : ℕ) : ℝ) * ((N + 1).factorial : ℝ)
        ≤ (2 * ((N + 1 : ℕ) : ℝ)) * ((N + 1).factorial : ℝ) := by nlinarith
      _ = 2 * (((N + 1).factorial : ℝ) * ((N + 1 : ℕ) : ℝ)) := by ring
  have hbound_form : Real.exp 1 - ∑ k ∈ Finset.range (N + 1), (1 : ℝ) / (k.factorial : ℝ) ≤
      ((N + 2 : ℕ) : ℝ) / (((N + 1).factorial : ℝ) * ((N + 1 : ℕ) : ℝ)) := by
    convert hbound using 2 <;> simp [Nat.succ_eq_add_one]
  linarith [hbound_form, hkey]

end DiscreteSpacetime.Irrationality
