/-
  OmegaTheory.Irrationality.HermitePade.F50_Decay

  F50 — Super-exponential decay bound for the Padé remainder (Module 04/10
  of the π K₂-opacity diary, Attack 19 Pre-Siegel Hermite–Padé).

  Informal statement
  ------------------
  Let `R_n(z) = A_n(z) · 1 + B_n(z) · f(z) + C_n(z) · g(z)` be a Type II
  `[n; n, n]` simultaneous Padé remainder (§F49), so that `R_n` vanishes
  to order `≥ 3n + 2` at `z = 0`.  If `f, g` are holomorphic on a disk of
  radius `r`, then for any `|z₀| < r` the Cauchy contour integral on
  `|ζ| = r` gives

        |R_n(z₀)|  ≤  M · (|z₀| / r)^(3n + 2),

  where `M = r · sup_{|ζ|=r} |R_n(ζ) / (ζ - z₀)|` is a constant
  independent of `n` up to Padé-normalisation; i.e. `R_n(z₀)` decays
  super-exponentially in `n`.

  Scope of this file
  ------------------
  The full contour argument (Cauchy's integral formula on `ℂ` with
  holomorphicity of `f, g`) is heavy and relies on Mathlib's
  complex-analysis infrastructure.  Per the task description, we scope
  down to the **clean algebraic lemma** that is the "arithmetic heart" of
  F50: a *Taylor-tail bound* on polynomials whose low-order coefficients
  vanish.

  Specifically, we prove:
  • `taylor_tail_bound` — if `p : ℝ[X]` has `p.coeff k = 0` for every
    `k < N`, then on the real disk `|z| ≤ r` we have
      `|p.eval z| ≤ M · |z|^N`
    with `M = ∑_{k=N}^{deg p} |p.coeff k| · r^(k - N)`.

  • `F50_decay_algebraic` — the specialisation relevant to Attack 19:
    with `N = 3 n + 2`, the bound takes the form
      `|p.eval z| ≤ M · |z|^(3 n + 2)`.

  These are the algebraic inputs fed to the contour argument; the
  remaining complex-analytic step (replacing `M` by an `n`-independent
  bound via maximum modulus on the contour `|ζ| = r`) is out of scope
  for this file and is the subject of the companion diary note on F50.

  Dependencies: Mathlib v4.29 (`Polynomial.eval`, `Finset.sum`,
  `Finset.Ico`, `abs_pow`, `abs_mul`, `pow_le_pow_left₀`).
  No sorries, no axioms beyond Mathlib.
-/

import Mathlib.Algebra.Polynomial.Eval.Defs
import Mathlib.Algebra.Polynomial.Eval.Degree
import Mathlib.Algebra.Polynomial.Degree.Defs
import Mathlib.Algebra.Polynomial.Coeff
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.Order.AbsoluteValue.Basic
import Mathlib.Analysis.Normed.Field.Basic

namespace OmegaTheory.Irrationality.HermitePade

open Polynomial BigOperators Finset

/--
Evaluation of a polynomial at `z` is the sum over `k ∈ range (deg p + 1)`
of `coeff k · z^k`.  We state this in the form we will use below:
`eval z p = ∑_{k ∈ range (deg + 1)} coeff k · z^k`.

This is just `Polynomial.eval_eq_sum_range` packaged for convenience.
-/
private lemma eval_eq_sum_range_real (p : ℝ[X]) (z : ℝ) :
    p.eval z = ∑ k ∈ range (p.natDegree + 1), p.coeff k * z ^ k :=
  Polynomial.eval_eq_sum_range z

/--
**Taylor-tail bound (algebraic form of F50).**

If every coefficient of `p : ℝ[X]` in degrees `k < N` vanishes, then on
the interval `|z| ≤ r` (with `0 ≤ r`, `0 ≤ |z|`, `|z| ≤ r`) we have the
pointwise bound

    `|p.eval z| ≤ (∑_{k ∈ range (deg p + 1), N ≤ k} |coeff k| · r^(k - N)) · |z|^N`.

The constant on the right depends only on the high-order tail of `p`
and on `r`; it is independent of `z`.  In the Padé setting with
`N = 3 n + 2`, this is the clean algebraic core of F50 decay.

Proof sketch.  Expand `eval z p` as a sum over `k ∈ range (deg + 1)`.
Split the sum at `N`: the `k < N` part vanishes by hypothesis.  For the
`k ≥ N` part, factor `z^k = z^N · z^(k-N)`, bound `|z^(k-N)| ≤ r^(k-N)`,
and pull `|z|^N` out of the sum.
-/
theorem taylor_tail_bound
    (p : ℝ[X]) {N : ℕ}
    (hvanish : ∀ k, k < N → p.coeff k = 0)
    {r z : ℝ} (_hr : 0 ≤ r) (hz : |z| ≤ r) :
    |p.eval z| ≤
      (∑ k ∈ (range (p.natDegree + 1)).filter (fun k => N ≤ k),
          |p.coeff k| * r ^ (k - N)) * |z| ^ N := by
  -- Step 1: expand eval into a finite sum.
  have hz_nn : 0 ≤ |z| := abs_nonneg z
  have heval : p.eval z = ∑ k ∈ range (p.natDegree + 1), p.coeff k * z ^ k :=
    eval_eq_sum_range_real p z
  -- Step 2: drop terms with `k < N` (they contribute 0).
  have hlow : ∀ k ∈ (range (p.natDegree + 1)).filter (fun k => k < N),
      p.coeff k * z ^ k = 0 := by
    intro k hk
    rcases Finset.mem_filter.mp hk with ⟨_, hkN⟩
    simp [hvanish k hkN]
  have hsplit :
      p.eval z =
        ∑ k ∈ (range (p.natDegree + 1)).filter (fun k => N ≤ k),
            p.coeff k * z ^ k := by
    rw [heval]
    -- Partition `range (deg + 1)` into the two filters `k < N` and `N ≤ k`.
    have hpart :
        ∑ k ∈ range (p.natDegree + 1), p.coeff k * z ^ k
          = (∑ k ∈ (range (p.natDegree + 1)).filter (fun k => k < N),
                  p.coeff k * z ^ k)
            + ∑ k ∈ (range (p.natDegree + 1)).filter (fun k => N ≤ k),
                  p.coeff k * z ^ k := by
      rw [← Finset.sum_filter_add_sum_filter_not (range (p.natDegree + 1))
            (fun k => k < N) (fun k => p.coeff k * z ^ k)]
      congr 1
      apply Finset.sum_congr
      · ext k; simp [not_lt]
      · intros; rfl
    rw [hpart]
    rw [Finset.sum_eq_zero hlow, zero_add]
  -- Step 3: bound the remaining sum term-by-term.
  have habs_eval :
      |p.eval z| ≤
        ∑ k ∈ (range (p.natDegree + 1)).filter (fun k => N ≤ k),
            |p.coeff k * z ^ k| := by
    rw [hsplit]
    exact Finset.abs_sum_le_sum_abs _ _
  -- Step 4: for each k with N ≤ k, show the term bound.
  have hterm :
      ∀ k ∈ (range (p.natDegree + 1)).filter (fun k => N ≤ k),
        |p.coeff k * z ^ k| ≤ |p.coeff k| * r ^ (k - N) * |z| ^ N := by
    intro k hk
    rcases Finset.mem_filter.mp hk with ⟨_, hNk⟩
    -- |coeff k * z^k| = |coeff k| * |z|^k
    have h1 : |p.coeff k * z ^ k| = |p.coeff k| * |z| ^ k := by
      rw [abs_mul, abs_pow]
    -- |z|^k = |z|^(k-N) * |z|^N
    have hkN : k = (k - N) + N := (Nat.sub_add_cancel hNk).symm
    have h2 : |z| ^ k = |z| ^ (k - N) * |z| ^ N := by
      conv_lhs => rw [hkN]
      rw [pow_add]
    -- |z|^(k-N) ≤ r^(k-N)
    have h3 : |z| ^ (k - N) ≤ r ^ (k - N) :=
      pow_le_pow_left₀ hz_nn hz (k - N)
    -- Combine.
    rw [h1, h2]
    have hcoeff_nn : 0 ≤ |p.coeff k| := abs_nonneg _
    have hzN_nn : 0 ≤ |z| ^ N := pow_nonneg hz_nn N
    calc |p.coeff k| * (|z| ^ (k - N) * |z| ^ N)
        = (|p.coeff k| * |z| ^ (k - N)) * |z| ^ N := by ring
      _ ≤ (|p.coeff k| * r ^ (k - N)) * |z| ^ N := by
            apply mul_le_mul_of_nonneg_right _ hzN_nn
            exact mul_le_mul_of_nonneg_left h3 hcoeff_nn
      _ = |p.coeff k| * r ^ (k - N) * |z| ^ N := by ring
  -- Step 5: sum up the term bounds and factor |z|^N out.
  have hsum_bound :
      ∑ k ∈ (range (p.natDegree + 1)).filter (fun k => N ≤ k),
          |p.coeff k * z ^ k|
        ≤ ∑ k ∈ (range (p.natDegree + 1)).filter (fun k => N ≤ k),
              |p.coeff k| * r ^ (k - N) * |z| ^ N :=
    Finset.sum_le_sum hterm
  have hfactor :
      ∑ k ∈ (range (p.natDegree + 1)).filter (fun k => N ≤ k),
          |p.coeff k| * r ^ (k - N) * |z| ^ N
        = (∑ k ∈ (range (p.natDegree + 1)).filter (fun k => N ≤ k),
              |p.coeff k| * r ^ (k - N)) * |z| ^ N := by
    rw [← Finset.sum_mul]
  linarith [habs_eval, hsum_bound, hfactor.symm.le, hfactor.le]

/--
**F50 — super-exponential decay (algebraic specialisation).**

With `N = 3 n + 2`, the Taylor-tail bound reads: for any polynomial
`p : ℝ[X]` whose coefficients in degrees `k < 3 n + 2` all vanish, and
for any `|z| ≤ r` with `0 ≤ r`,

    `|p.eval z| ≤ M_p · |z|^(3 n + 2)`,

where `M_p` is the tail-constant

    `M_p = ∑_{k ≥ 3n+2} |p.coeff k| · r^(k - (3n+2))`.

This is the form used in Attack 19:  the Padé remainder `R_n` from F49
satisfies the coefficient-vanishing hypothesis by construction (order of
vanishing `≥ 3 n + 2` at `0`), and this bound shows the remainder decays
at least like `|z₀|^(3 n + 2)` — super-exponentially in `n` whenever
`|z₀| < 1`.  The full contour-integral upgrade that makes `M_p`
`n`-uniform uses Cauchy's formula; it is out of scope for this file.
-/
theorem F50_decay_algebraic
    (p : ℝ[X]) (n : ℕ)
    (hvanish : ∀ k, k < 3 * n + 2 → p.coeff k = 0)
    {r z : ℝ} (hr : 0 ≤ r) (hz : |z| ≤ r) :
    |p.eval z| ≤
      (∑ k ∈ (range (p.natDegree + 1)).filter (fun k => 3 * n + 2 ≤ k),
          |p.coeff k| * r ^ (k - (3 * n + 2))) * |z| ^ (3 * n + 2) :=
  taylor_tail_bound p hvanish hr hz

/-!
### Axiom audit

Both theorems depend only on Lean's core axioms plus Mathlib's standard
classical axioms (`propext`, `Classical.choice`, `Quot.sound`) — no
invocation of `Real.pi_transcendental` here (this file is about
arbitrary real polynomials).
-/
-- #print axioms taylor_tail_bound
-- #print axioms F50_decay_algebraic

end OmegaTheory.Irrationality.HermitePade
