/-
  OmegaTheory.Irrationality.Sqrt2Rate

  Exact super-exponential rate for `sqrt2_error_val`.

  The per-tick √2 truncation error decays as `1 / 2^{2^N}`.  The three
  companion error channels have the following convergence profiles:

  * π  — algebraic:       `O(1/N)`                (pi_error_val)
  * e  — factorial:       `O(1/N!)`               (e_error_val)
  * √2 — super-exponential: `O(1/2^{2^N})`        (sqrt2_error_val)

  The ratio lemma below makes the super-exponential nature precise:

      sqrt2_error_val (N+1) = sqrt2_error_val N / 2^{2^N}

  i.e. at each step the error is divided by a factor that itself doubles
  in its exponent.  This is the algebraic fingerprint that separates √2
  from π (`O(1/N)`) and e (`O(1/N!)`) in the Pi Hunch ordering of the
  Irrationality channels.

  Closure: Gacrux proof-hunter-research Target #9 (Shaula, 2026-04-19).

  0 sorry, 0 new axioms.  Builds against OmegaTheory V2 as of 2026-04-19.
-/

import OmegaTheory.Irrationality.Approximations

namespace OmegaTheory.Irrationality

/-! ## 1. Key exponent identity: `2^(2^(N+1)) = 2^(2^N) · 2^(2^N)`

    `2^(N+1) = 2 · 2^N = 2^N + 2^N`, so `2^{2^(N+1)} = 2^{2^N + 2^N}
    = 2^{2^N} · 2^{2^N}` by the power-of-sum identity. -/

private lemma two_pow_succ_outer (N : ℕ) :
    (2 : ℝ) ^ (2 ^ (N + 1)) = (2 : ℝ) ^ (2 ^ N) * (2 : ℝ) ^ (2 ^ N) := by
  have hexp : (2 : ℕ) ^ (N + 1) = 2 ^ N + 2 ^ N := by
    rw [pow_succ]; ring
  rw [hexp, pow_add]

/-! ## 2. Super-exponential rate lemma (main target) -/

/-- **Super-exponential rate for `sqrt2_error_val`.**  The ratio
    `sqrt2_error_val (N+1) / sqrt2_error_val N` equals `1 / 2^(2^N)`,
    making the convergence of the √2 channel genuinely super-exponential.

    This is the algebraic fingerprint distinguishing the √2 channel from
    π (`O(1/N)`) and e (`O(1/N!)`) in the Pi Hunch ordering. -/
theorem sqrt2_error_val_rate (N : ℕ) :
    sqrt2_error_val (N + 1) = sqrt2_error_val N / (2 : ℝ) ^ (2 ^ N) := by
  unfold sqrt2_error_val
  -- Goal: 1 / 2^(2^(N+1)) = (1 / 2^(2^N)) / 2^(2^N)
  have hexp : (2 : ℝ) ^ (2 ^ (N + 1)) = (2 : ℝ) ^ (2 ^ N) * (2 : ℝ) ^ (2 ^ N) :=
    two_pow_succ_outer N
  have hpos : (0 : ℝ) < (2 : ℝ) ^ (2 ^ N) := by positivity
  have hne : (2 : ℝ) ^ (2 ^ N) ≠ 0 := ne_of_gt hpos
  rw [hexp]
  field_simp

/-! ## 3. Strict super-exponential ratio

    A direct strict consequence: the ratio `sqrt2_error_val (N+1) /
    sqrt2_error_val N` is strictly less than `1`, i.e. the step-over-step
    shrinkage factor exceeds `1 : ℝ`.  More precisely, `sqrt2_error_val
    (N+1) = sqrt2_error_val N / 2^(2^N)` and `2^(2^N) ≥ 2 > 1`, hence the
    ratio is at most `1/2`. -/

/-- `sqrt2_error_val (N+1) ≤ sqrt2_error_val N / 2`.  The shrinkage
    factor at each step is *at least* `2`; in fact it is `2^(2^N)`, which
    is `≥ 2` for every `N ≥ 0`. -/
theorem sqrt2_error_val_rate_le_half (N : ℕ) :
    sqrt2_error_val (N + 1) ≤ sqrt2_error_val N / 2 := by
  rw [sqrt2_error_val_rate N]
  -- Goal: sqrt2_error_val N / 2^(2^N) ≤ sqrt2_error_val N / 2
  have herr_pos : 0 < sqrt2_error_val N := sqrt2_error_pos N
  have h_pow_ge_two : (2 : ℝ) ≤ (2 : ℝ) ^ (2 ^ N) := by
    have h1 : (1 : ℕ) ≤ 2 ^ N := Nat.one_le_two_pow
    calc (2 : ℝ) = (2 : ℝ) ^ (1 : ℕ) := by ring
      _ ≤ (2 : ℝ) ^ (2 ^ N) := by
          exact pow_le_pow_right₀ (by norm_num : (1 : ℝ) ≤ 2) h1
  have h_pow_pos : (0 : ℝ) < (2 : ℝ) ^ (2 ^ N) := by positivity
  exact div_le_div_of_nonneg_left herr_pos.le (by norm_num) h_pow_ge_two

/-! ## 4. Strict inequality form of the rate lemma -/

/-- Strict rate form: `sqrt2_error_val (N+1) < sqrt2_error_val N`, obtained
    from the rate identity `sqrt2_error_val (N+1) = sqrt2_error_val N /
    2^(2^N)` by noting `2^(2^N) > 1`. -/
theorem sqrt2_error_val_rate_strict (N : ℕ) :
    sqrt2_error_val (N + 1) < sqrt2_error_val N := by
  rw [sqrt2_error_val_rate N]
  have herr_pos : 0 < sqrt2_error_val N := sqrt2_error_pos N
  have h_one_lt : (1 : ℝ) < (2 : ℝ) ^ (2 ^ N) := by
    have h1 : (1 : ℕ) ≤ 2 ^ N := Nat.one_le_two_pow
    have h_pow_ge_two : (2 : ℝ) ≤ (2 : ℝ) ^ (2 ^ N) := by
      calc (2 : ℝ) = (2 : ℝ) ^ (1 : ℕ) := by ring
        _ ≤ (2 : ℝ) ^ (2 ^ N) := by
            exact pow_le_pow_right₀ (by norm_num : (1 : ℝ) ≤ 2) h1
    linarith
  exact div_lt_self herr_pos h_one_lt

end OmegaTheory.Irrationality
