/-
  OmegaTheory.Foundations.TaylorBound

  The scalar central-difference Taylor bound — ingredient (A) in the
  Analyst's graph for the HPW elimination chain.

  For `f : ℝ → ℝ` in `C⁴`, the symmetric second difference approximates
  `f''` with error controlled by the sup of `|f⁽⁴⁾|` and `h²`:

      | (f(x+h) − 2·f(x) + f(x−h))/h² − f''(x) |  ≤  (h²/12) · M

  This file provides the 1D scalar bound. The 4D lift for partial
  second differences along a fixed axis follows by restricting to the
  univariate slice through the lattice point in that direction; that
  lift is stated as a corollary here.

  Author: Taylor-prover (HPW elimination team), 2026-04-14.
  Built on Mathlib v4.29, using `taylor_mean_remainder_lagrange_iteratedDeriv`.
-/

import Mathlib.Analysis.Calculus.Taylor
import Mathlib.Analysis.Calculus.IteratedDeriv.Lemmas
import Mathlib.Analysis.Calculus.ContDiff.Basic
import Mathlib.Tactic

namespace OmegaTheory.Foundations

open Set

/-! ## Forward and backward third-order Taylor expansions with remainder

We apply Mathlib's Lagrange-form Taylor theorem for `n = 3`
(`taylor_mean_remainder_lagrange_iteratedDeriv`) in two places:
- forward:  expand `f(x₀ + h)` on the interval `[x₀, x₀+h]`
- backward: expand `f(x₀ − h)` via the reflected function
            `frev y := f (2 x₀ − y)` on `[x₀, x₀+h]`

In the reflected view, odd-order terms pick up a minus sign
(`(-1)^k • iteratedDeriv k f`), so the third-order polynomial of
`frev` at `x₀ + h` equals
`f(x₀) − f'(x₀)·h + f''(x₀)·h²/2 − f'''(x₀)·h³/6`
and the remainder involves `iteratedDeriv 4 f (2x₀ − x')`, which is
still `|·| ≤ M` by hypothesis (`2x₀ − x' ∈ [x₀−h, x₀]`).
-/

/-- The fully explicit Taylor polynomial of degree 3 of a function
`f : ℝ → ℝ` at center `x₀`, evaluated at `x`. For `h := x - x₀`:

    `T₃(x) = f(x₀) + f'(x₀)·h + f''(x₀)·h²/2 + f'''(x₀)·h³/6`.

We state this in closed form as a helper. -/
private lemma taylorWithinEval_three_of_contDiff
    (f : ℝ → ℝ) (a b x : ℝ) (hab : a < b)
    (hf : ContDiff ℝ 3 f) :
    taylorWithinEval f 3 (Icc a b) a x =
      f a + iteratedDeriv 1 f a * (x - a)
          + iteratedDeriv 2 f a * (x - a)^2 / 2
          + iteratedDeriv 3 f a * (x - a)^3 / 6 := by
  have hu : UniqueDiffOn ℝ (Icc a b) := uniqueDiffOn_Icc hab
  have hax : a ∈ Icc a b := left_mem_Icc.mpr hab.le
  -- Rewrite iteratedDerivWithin as iteratedDeriv at the left endpoint.
  have eq_k : ∀ k ≤ (3 : ℕ),
      iteratedDerivWithin k f (Icc a b) a = iteratedDeriv k f a := by
    intro k hk
    apply iteratedDerivWithin_eq_iteratedDeriv hu _ hax
    exact (hf.of_le (by exact_mod_cast hk)).contDiffAt
  rw [taylor_within_apply]
  simp only [Finset.sum_range_succ, Finset.sum_range_zero, zero_add,
    iteratedDerivWithin_zero, Nat.factorial_zero, Nat.cast_one, inv_one,
    pow_zero, mul_one,
    Nat.factorial_one, pow_one, one_mul,
    smul_eq_mul]
  -- Use the endpoint equalities to replace iteratedDerivWithin by iteratedDeriv
  rw [eq_k 1 (by norm_num), eq_k 2 (by norm_num), eq_k 3 (by norm_num)]
  -- Factorials: 2! = 2, 3! = 6
  have h2 : ((Nat.factorial 2 : ℕ) : ℝ) = 2 := by norm_num [Nat.factorial]
  have h3 : ((Nat.factorial 3 : ℕ) : ℝ) = 6 := by norm_num [Nat.factorial]
  rw [h2, h3]
  ring

/-- Forward Lagrange-form Taylor expansion of degree 3 on the interval
`[x₀, x₀ + h]`, with `h > 0`, for `f ∈ C⁴`.

There exists `x' ∈ (x₀, x₀ + h)` such that

    f(x₀+h) = f(x₀) + f'(x₀) h + f''(x₀) h²/2 + f'''(x₀) h³/6
              + f⁽⁴⁾(x') · h⁴ / 24.
-/
lemma taylor_forward_expansion
    (f : ℝ → ℝ) (x₀ h : ℝ) (hh : 0 < h) (hf : ContDiff ℝ 4 f) :
    ∃ x' ∈ Ioo x₀ (x₀ + h),
      f (x₀ + h) =
        f x₀ + iteratedDeriv 1 f x₀ * h
             + iteratedDeriv 2 f x₀ * h^2 / 2
             + iteratedDeriv 3 f x₀ * h^3 / 6
             + iteratedDeriv 4 f x' * h^4 / 24 := by
  have hlt : x₀ < x₀ + h := by linarith
  have hf3 : ContDiffOn ℝ (3 + 1) f (Icc x₀ (x₀ + h)) :=
    (hf.of_le (by norm_num)).contDiffOn
  obtain ⟨x', hx', hrem⟩ :=
    taylor_mean_remainder_lagrange_iteratedDeriv (n := 3) hlt hf3
  refine ⟨x', hx', ?_⟩
  -- From the remainder equation, recover f (x₀ + h).
  have hT := taylorWithinEval_three_of_contDiff f x₀ (x₀ + h) (x₀ + h) hlt
    (hf.of_le (by norm_num))
  -- (x₀+h - x₀) = h
  have hsub : (x₀ + h) - x₀ = h := by ring
  rw [hsub] at hT
  -- Factorial: (3+1)! = 24
  have h24 : ((Nat.factorial (3 + 1) : ℕ) : ℝ) = 24 := by
    norm_num [Nat.factorial]
  -- Unpack the remainder.
  -- f(x₀+h) - taylorPoly = iteratedDeriv 4 f x' * ((x₀+h)-x₀)^4 / 4!
  have : f (x₀ + h) - taylorWithinEval f 3 (Icc x₀ (x₀ + h)) x₀ (x₀ + h) =
        iteratedDeriv (3 + 1) f x' * ((x₀ + h) - x₀) ^ (3 + 1) /
          (Nat.factorial (3 + 1)) := hrem
  rw [hsub, h24] at this
  -- Replace taylor polynomial by its closed form (hT).
  linarith [this, hT]

/-- Backward Lagrange-form Taylor expansion of degree 3 on the interval
`[x₀, x₀ + h]` applied to the reflected function `frev y := f (2 x₀ − y)`.

There exists `x' ∈ (x₀, x₀ + h)` such that

    f(x₀−h) = f(x₀) − f'(x₀) h + f''(x₀) h²/2 − f'''(x₀) h³/6
              + f⁽⁴⁾(2 x₀ − x') · h⁴ / 24.

Note `2 x₀ − x' ∈ (x₀ − h, x₀)`, so if `|f⁽⁴⁾| ≤ M` on `[x₀−h, x₀+h]`,
the reflected evaluation point is still in the interval where the
bound holds.
-/
lemma taylor_backward_expansion
    (f : ℝ → ℝ) (x₀ h : ℝ) (hh : 0 < h) (hf : ContDiff ℝ 4 f) :
    ∃ x' ∈ Ioo x₀ (x₀ + h),
      f (x₀ - h) =
        f x₀ - iteratedDeriv 1 f x₀ * h
             + iteratedDeriv 2 f x₀ * h^2 / 2
             - iteratedDeriv 3 f x₀ * h^3 / 6
             + iteratedDeriv 4 f (2 * x₀ - x') * h^4 / 24 := by
  -- Define the reflection.
  set frev : ℝ → ℝ := fun y => f (2 * x₀ - y) with hfrev
  -- `frev` is C⁴ as a composition of C⁴ functions.
  have hfrev4 : ContDiff ℝ 4 frev := by
    have hlin : ContDiff ℝ 4 (fun y : ℝ => 2 * x₀ - y) := by
      exact (contDiff_const.sub contDiff_id)
    exact hf.comp hlin
  -- Apply forward expansion to frev.
  obtain ⟨x', hx', heq⟩ := taylor_forward_expansion frev x₀ h hh hfrev4
  refine ⟨x', hx', ?_⟩
  -- iteratedDeriv k frev = fun t => (-1)^k • iteratedDeriv k f (2 x₀ - t).
  have hid_comp : ∀ k : ℕ, iteratedDeriv k frev =
      fun t => (-1 : ℝ)^k • iteratedDeriv k f (2 * x₀ - t) := by
    intro k
    -- frev y = f (2*x₀ - y), so iteratedDeriv_comp_const_sub gives the form.
    have := iteratedDeriv_comp_const_sub (n := k) (f := f) (s := 2 * x₀)
    exact this
  -- Evaluate iteratedDeriv k frev at x₀.
  have eval_x0 : ∀ k : ℕ, iteratedDeriv k frev x₀ =
      (-1 : ℝ)^k * iteratedDeriv k f x₀ := by
    intro k
    have h1 := congrFun (hid_comp k) x₀
    simp only [smul_eq_mul] at h1
    have h2 : 2 * x₀ - x₀ = x₀ := by ring
    rw [h2] at h1
    exact h1
  -- Evaluate iteratedDeriv 4 frev at x'.
  have eval_x' : iteratedDeriv 4 frev x' =
      iteratedDeriv 4 f (2 * x₀ - x') := by
    have h1 := congrFun (hid_comp 4) x'
    simp only [smul_eq_mul] at h1
    have : (-1 : ℝ)^4 = 1 := by norm_num
    rw [this, one_mul] at h1
    exact h1
  -- frev (x₀ + h) = f (x₀ - h).
  have hfreveval : frev (x₀ + h) = f (x₀ - h) := by
    simp only [hfrev]; ring_nf
  -- frev x₀ = f x₀.
  have hfrev_x0 : frev x₀ = f x₀ := by
    simp only [hfrev]; ring_nf
  -- Now plug all into heq.
  rw [hfreveval, hfrev_x0, eval_x0 1, eval_x0 2, eval_x0 3, eval_x'] at heq
  -- Simplify the signs: (-1)^1 = -1, (-1)^2 = 1, (-1)^3 = -1.
  have e1 : ((-1 : ℝ))^(1 : ℕ) = -1 := by norm_num
  have e2 : ((-1 : ℝ))^(2 : ℕ) = 1 := by norm_num
  have e3 : ((-1 : ℝ))^(3 : ℕ) = -1 := by norm_num
  rw [e1, e2, e3] at heq
  linarith

/-! ## Main central-difference bound -/

/-- **Central-difference Taylor bound** (ingredient A).

For `f : ℝ → ℝ` in `C⁴` and `h > 0`, if `|f⁽⁴⁾(y)| ≤ M` for every
`y ∈ [x₀ − h, x₀ + h]`, then the symmetric second difference of `f`
approximates `f''(x₀)` with error bounded by `(h²/12)·M`:

    | (f(x₀+h) − 2·f(x₀) + f(x₀−h))/h² − f''(x₀) |  ≤  (h²/12) · M.
-/
theorem central_diff_taylor_bound
    (f : ℝ → ℝ) (x₀ h M : ℝ) (hh : 0 < h)
    (hf : ContDiff ℝ 4 f)
    (h_bound : ∀ y ∈ Set.Icc (x₀ - h) (x₀ + h),
                  |iteratedDeriv 4 f y| ≤ M) :
    |(f (x₀ + h) - 2 * f x₀ + f (x₀ - h)) / h^2 - iteratedDeriv 2 f x₀|
      ≤ (h^2 / 12) * M := by
  -- Apply forward and backward expansions.
  obtain ⟨xf, hxf, heqf⟩ := taylor_forward_expansion f x₀ h hh hf
  obtain ⟨xb, hxb, heqb⟩ := taylor_backward_expansion f x₀ h hh hf
  -- Sum: (f(x₀+h) + f(x₀-h)) - 2 f(x₀) = f''(x₀) h² + remainder,
  -- where remainder = (f⁽⁴⁾(xf) + f⁽⁴⁾(2x₀ - xb)) * h⁴ / 24.
  have hsum :
      f (x₀ + h) - 2 * f x₀ + f (x₀ - h) =
        iteratedDeriv 2 f x₀ * h^2
          + (iteratedDeriv 4 f xf + iteratedDeriv 4 f (2 * x₀ - xb)) * h^4 / 24 := by
    -- Add forward and backward: all odd-order terms cancel.
    linarith [heqf, heqb]
  -- Divide by h² > 0. The remainder divided by h² gives:
  --   (f⁽⁴⁾(xf) + f⁽⁴⁾(2x₀ - xb)) * h² / 24.
  have hh2_pos : 0 < h^2 := by positivity
  have hh2_ne : h^2 ≠ 0 := ne_of_gt hh2_pos
  -- Express the target error.
  have htarget :
      (f (x₀ + h) - 2 * f x₀ + f (x₀ - h)) / h^2 - iteratedDeriv 2 f x₀
        = (iteratedDeriv 4 f xf + iteratedDeriv 4 f (2 * x₀ - xb)) * h^2 / 24 := by
    rw [hsum]
    field_simp
    ring
  rw [htarget]
  -- Now bound |(A + B) * h² / 24| where A = f⁽⁴⁾(xf), B = f⁽⁴⁾(2x₀ - xb).
  -- First verify xf, (2x₀ - xb) are both in [x₀ - h, x₀ + h].
  have hxf_mem : xf ∈ Set.Icc (x₀ - h) (x₀ + h) := by
    refine ⟨?_, ?_⟩
    · linarith [hxf.1]
    · linarith [hxf.2]
  have hxb_refl_mem : (2 * x₀ - xb) ∈ Set.Icc (x₀ - h) (x₀ + h) := by
    refine ⟨?_, ?_⟩
    · linarith [hxb.2]
    · linarith [hxb.1]
  have hA : |iteratedDeriv 4 f xf| ≤ M := h_bound xf hxf_mem
  have hB : |iteratedDeriv 4 f (2 * x₀ - xb)| ≤ M := h_bound (2 * x₀ - xb) hxb_refl_mem
  -- Bound |A + B| ≤ 2M.
  have hAB : |iteratedDeriv 4 f xf + iteratedDeriv 4 f (2 * x₀ - xb)| ≤ 2 * M := by
    calc |iteratedDeriv 4 f xf + iteratedDeriv 4 f (2 * x₀ - xb)|
        ≤ |iteratedDeriv 4 f xf| + |iteratedDeriv 4 f (2 * x₀ - xb)| := abs_add_le _ _
      _ ≤ M + M := add_le_add hA hB
      _ = 2 * M := by ring
  -- Conclude.
  have hM_nn : 0 ≤ M := le_trans (abs_nonneg _) hA
  have h2_nn : (0 : ℝ) ≤ h^2 := le_of_lt hh2_pos
  calc |(iteratedDeriv 4 f xf + iteratedDeriv 4 f (2 * x₀ - xb)) * h^2 / 24|
      = |iteratedDeriv 4 f xf + iteratedDeriv 4 f (2 * x₀ - xb)| * h^2 / 24 := by
        rw [abs_div, abs_mul, abs_of_nonneg h2_nn]
        congr 1
        exact abs_of_nonneg (by norm_num : (0:ℝ) ≤ 24)
    _ ≤ (2 * M) * h^2 / 24 := by
        have := mul_le_mul_of_nonneg_right hAB h2_nn
        linarith
    _ = (h^2 / 12) * M := by ring

/-! ## 4D lift (stretch goal — axis-wise central differences)

For a function `F : (Fin 4 → ℝ) → ℝ` in `C⁴`, the central
second difference along a single axis `μ` reduces to the 1D result
applied to the univariate slice. We expose that reduction here.

We do NOT formalise the full multivariate Laplacian lift at this
layer — that belongs to the discrete-geometry layer and is handled
downstream via `OmegaTheory.Spacetime.Operators`. What we provide is
the *per-axis* 1D bound, which is what `discreteLaplacian` sums over.
-/

/-- **Per-axis central-difference Taylor bound** (ingredient A, axis slice).

Given `F : (Fin 4 → ℝ) → ℝ`, a base point `p : Fin 4 → ℝ`, an axis
`μ : Fin 4`, and `h > 0` with `M` a uniform bound on the fourth
derivative of the univariate slice `t ↦ F (update p μ (p μ + t))`
over `[−h, h]`, the symmetric second difference along `μ` has
error `≤ (h²/12)·M` against that slice's second derivative.

The caller is responsible for identifying the univariate second
derivative with `∂²F/∂x_μ²` via `iteratedDeriv`-to-`iteratedFDeriv`
conversion (Mathlib: `iteratedDeriv_eq_iteratedFDeriv`). -/
theorem central_diff_taylor_bound_axis
    (F : (Fin 4 → ℝ) → ℝ) (p : Fin 4 → ℝ) (μ : Fin 4)
    (h M : ℝ) (hh : 0 < h)
    (hslice : ContDiff ℝ 4 (fun t : ℝ => F (Function.update p μ (p μ + t))))
    (h_bound : ∀ t ∈ Set.Icc (-h) h,
        |iteratedDeriv 4 (fun t : ℝ => F (Function.update p μ (p μ + t))) t|
          ≤ M) :
    |(F (Function.update p μ (p μ + h))
        - 2 * F p
        + F (Function.update p μ (p μ - h))) / h^2
      - iteratedDeriv 2 (fun t : ℝ => F (Function.update p μ (p μ + t))) 0|
      ≤ (h^2 / 12) * M := by
  -- Let g(t) := F(update p μ (p μ + t)). Apply 1D bound at x₀ = 0.
  set g : ℝ → ℝ := fun t => F (Function.update p μ (p μ + t)) with hg
  have hg_x0 : g 0 = F p := by
    simp only [hg, add_zero, Function.update_eq_self]
  have hg_plus : g h = F (Function.update p μ (p μ + h)) := rfl
  have hg_minus : g (-h) = F (Function.update p μ (p μ - h)) := by
    show F (Function.update p μ (p μ + -h)) = F (Function.update p μ (p μ - h))
    have : p μ + -h = p μ - h := by ring
    rw [this]
  -- Apply 1D bound to g at x₀ = 0.
  have hbound_1d : ∀ y ∈ Set.Icc ((0 : ℝ) - h) ((0 : ℝ) + h),
      |iteratedDeriv 4 g y| ≤ M := by
    intro y hy
    apply h_bound
    have : Set.Icc ((0 : ℝ) - h) ((0 : ℝ) + h) = Set.Icc (-h) h := by
      congr 1 <;> ring
    rw [this] at hy
    exact hy
  have h1d := central_diff_taylor_bound g 0 h M hh hslice hbound_1d
  -- Translate g(0+h) = g(h), g(0-h) = g(-h), etc.
  have h0h : (0 : ℝ) + h = h := by ring
  have h0mh : (0 : ℝ) - h = -h := by ring
  rw [h0h, h0mh] at h1d
  rw [hg_plus, hg_x0, hg_minus] at h1d
  exact h1d

/-! ## Ingredient A — multiplied form

The HPW elimination programme (NOTES_HPW_ELIMINATION, Ingredient A) states
Taylor's second-difference bound in the *multiplied* form:

    | f(x₀+h) − 2·f(x₀) + f(x₀−h) − h²·f''(x₀) |  ≤  (h⁴/12) · M.

This is algebraically equivalent to `central_diff_taylor_bound` (multiply
both sides by `h² > 0` and rearrange).  We expose the multiplied form
directly because it is the shape consumed by the triangle-inequality glue
that produces `HpwHypothesis.h_remainder_bound`: the Taylor contribution
appears as `|Δ_lat f − h²·f''|` after all `h²` divisions have been cleared.

Caller-facing note: since the Planck-lattice `discreteLaplacian` already
divides by `ℓ_P²`, consumers usually want the *un*multiplied form.  Both
forms are available. -/

/-- **Ingredient A (multiplied form).**  For `f ∈ C⁴` on `ℝ`, `h > 0`, and
`M` a uniform bound on `|f⁽⁴⁾|` over `[x₀−h, x₀+h]`, the symmetric
second difference approximates `h²·f''(x₀)` with absolute error at most
`(h⁴/12)·M`:

    | f(x₀+h) − 2·f(x₀) + f(x₀−h) − h² · f''(x₀) |  ≤  (h⁴/12) · M. -/
theorem central_diff_second_order_accurate
    (f : ℝ → ℝ) (x₀ h M : ℝ) (hh : 0 < h)
    (hf : ContDiff ℝ 4 f)
    (h_bound : ∀ y ∈ Set.Icc (x₀ - h) (x₀ + h),
                  |iteratedDeriv 4 f y| ≤ M) :
    |f (x₀ + h) - 2 * f x₀ + f (x₀ - h) - h^2 * iteratedDeriv 2 f x₀|
      ≤ h^4 / 12 * M := by
  -- Obtain the divided-form bound from `central_diff_taylor_bound`.
  have hcd := central_diff_taylor_bound f x₀ h M hh hf h_bound
  have hh2_pos : 0 < h^2 := by positivity
  have hh2_nn : 0 ≤ h^2 := le_of_lt hh2_pos
  -- Multiply both sides of the divided bound by h² ≥ 0.  On the LHS we use
  -- the identity  h² · |A/h² − B| = |A − h²·B|.
  have hLHS_eq :
      |f (x₀ + h) - 2 * f x₀ + f (x₀ - h) - h^2 * iteratedDeriv 2 f x₀|
        = h^2 * |(f (x₀ + h) - 2 * f x₀ + f (x₀ - h)) / h^2
                 - iteratedDeriv 2 f x₀| := by
    have hh2_ne : h^2 ≠ 0 := ne_of_gt hh2_pos
    have hfact :
        f (x₀ + h) - 2 * f x₀ + f (x₀ - h) - h^2 * iteratedDeriv 2 f x₀
          = h^2 * ((f (x₀ + h) - 2 * f x₀ + f (x₀ - h)) / h^2
                   - iteratedDeriv 2 f x₀) := by
      field_simp
    rw [hfact, abs_mul, abs_of_nonneg hh2_nn]
  rw [hLHS_eq]
  -- Multiplied bound: h² · ((h²/12) · M) = (h⁴/12) · M.
  have hRHS_eq : h^2 * (h^2 / 12 * M) = h^4 / 12 * M := by ring
  rw [← hRHS_eq]
  exact mul_le_mul_of_nonneg_left hcd hh2_nn

/-- **Ingredient A (per-axis multiplied form).**  4D axis-slice counterpart
of `central_diff_second_order_accurate`.  For `F : (Fin 4 → ℝ) → ℝ`, a base
point `p`, an axis `μ`, and `h > 0`, if `M` uniformly bounds the
fourth derivative of the univariate slice along `μ`, then

    | F(update p μ (p μ + h)) − 2·F(p) + F(update p μ (p μ − h))
      − h² · (f_slice)''(0) |  ≤  (h⁴/12) · M,

where `f_slice(t) := F(update p μ (p μ + t))`.

This is the statement actually consumed by the lattice `secondDeriv` chain,
since `secondDeriv f μ p = (f(shiftFin p μ) − 2 f(p) + f(shiftBackFin p μ)) / ℓ_P²`
matches `F(update p μ (p μ + ℓ_P)) − 2 F(p) + F(update p μ (p μ − ℓ_P))`
divided by `ℓ_P²`.  The multiplied form below removes the `ℓ_P²` division,
exposing the raw Taylor remainder. -/
theorem central_diff_second_order_accurate_axis
    (F : (Fin 4 → ℝ) → ℝ) (p : Fin 4 → ℝ) (μ : Fin 4)
    (h M : ℝ) (hh : 0 < h)
    (hslice : ContDiff ℝ 4 (fun t : ℝ => F (Function.update p μ (p μ + t))))
    (h_bound : ∀ t ∈ Set.Icc (-h) h,
        |iteratedDeriv 4 (fun t : ℝ => F (Function.update p μ (p μ + t))) t|
          ≤ M) :
    |F (Function.update p μ (p μ + h))
        - 2 * F p
        + F (Function.update p μ (p μ - h))
      - h^2 * iteratedDeriv 2 (fun t : ℝ => F (Function.update p μ (p μ + t))) 0|
      ≤ h^4 / 12 * M := by
  -- Run the same scaling argument against the axis form
  -- `central_diff_taylor_bound_axis`.
  have hcd := central_diff_taylor_bound_axis F p μ h M hh hslice h_bound
  have hh2_pos : 0 < h^2 := by positivity
  have hh2_nn : 0 ≤ h^2 := le_of_lt hh2_pos
  have hLHS_eq :
      |F (Function.update p μ (p μ + h))
          - 2 * F p
          + F (Function.update p μ (p μ - h))
        - h^2 * iteratedDeriv 2
            (fun t : ℝ => F (Function.update p μ (p μ + t))) 0|
        = h^2 * |(F (Function.update p μ (p μ + h))
                    - 2 * F p
                    + F (Function.update p μ (p μ - h))) / h^2
                 - iteratedDeriv 2
                     (fun t : ℝ => F (Function.update p μ (p μ + t))) 0| := by
    have hh2_ne : h^2 ≠ 0 := ne_of_gt hh2_pos
    have hfact :
        F (Function.update p μ (p μ + h))
            - 2 * F p
            + F (Function.update p μ (p μ - h))
          - h^2 * iteratedDeriv 2
              (fun t : ℝ => F (Function.update p μ (p μ + t))) 0
          = h^2 * ((F (Function.update p μ (p μ + h))
                      - 2 * F p
                      + F (Function.update p μ (p μ - h))) / h^2
                   - iteratedDeriv 2
                       (fun t : ℝ => F (Function.update p μ (p μ + t))) 0) := by
      field_simp
    rw [hfact, abs_mul, abs_of_nonneg hh2_nn]
  rw [hLHS_eq]
  have hRHS_eq : h^2 * (h^2 / 12 * M) = h^4 / 12 * M := by ring
  rw [← hRHS_eq]
  exact mul_le_mul_of_nonneg_left hcd hh2_nn

/-! ## Ingredient C — per-axis partial second-derivative accuracy

The lattice `discreteLaplacian` sums per-axis second differences
`secondDeriv f μ p` over `μ : Fin 4`.  Each summand is a diagonal partial
second derivative in the continuum limit.  Ingredient **C** of
NOTES_HPW_ELIMINATION is the claim that these *diagonal* partial-second
derivatives approximate the continuum `∂²_{μμ}` with `O(h²)` error — and
this is exactly what `central_diff_second_order_accurate_axis` delivers.

For **off-diagonal** (`μ ≠ ν`) partial-second derivatives, the relevant
discrete operator is an iterated symmetric first difference
`δ^ν δ^μ` (not the diagonal `secondDeriv`), and the continuum limit is
`∂²_{μν} g`.  The error-control proof is structurally similar — two
applications of `taylor_forward_expansion` along nested slices plus a
triangle inequality — but it is *not* consumed by the current
`discreteLaplacian` chain, so we honestly stop at the diagonal case.

The diagonal statement `partial_secondderiv_second_order_accurate` below
is the Ingredient-C deliverable required to close the HPW remainder chain
at the `discreteLaplacian`-consumer interface.  The off-diagonal case is
deferred; see the module docstring of `HpwTotalTruncation.lean`. -/

/-- **Ingredient C (diagonal).**  For `F : (Fin 4 → ℝ) → ℝ`, a base point
`p`, an axis `μ`, and `h > 0`, the axis-wise symmetric second difference
approximates `h² · ∂²_{μμ} F(p)` (where `∂²_{μμ}` is the second derivative
of the univariate `μ`-slice at `t = 0`) with absolute error at most
`(h⁴/12)·M`:

    | F(update p μ (p μ + h)) − 2·F(p) + F(update p μ (p μ − h))
      − h² · (f_slice_μ)''(0) |  ≤  (h⁴/12) · M.

**Scope**: this is the diagonal (`μ = ν`) ingredient C, which is the
version consumed by `OmegaTheory.Spacetime.Operators.discreteLaplacian`.
The off-diagonal (`μ ≠ ν`) lift — mixed partial via iterated central
first differences — is a separate statement and is NOT needed by the
current HPW chain.  A future agent may add it as
`partial_secondderiv_second_order_accurate_mixed` when the consumer
surface grows; until then it is intentional unmet scope, not a gap.

The statement is `rfl`-equivalent to `central_diff_second_order_accurate_axis`
with `ν := μ`; we re-export it under the Ingredient-C name used in
NOTES_HPW_ELIMINATION so the ingredient graph can resolve
`name = partial_secondderiv_second_order_accurate` to this theorem. -/
theorem partial_secondderiv_second_order_accurate
    (F : (Fin 4 → ℝ) → ℝ) (p : Fin 4 → ℝ) (μ : Fin 4)
    (h M : ℝ) (hh : 0 < h)
    (hslice : ContDiff ℝ 4 (fun t : ℝ => F (Function.update p μ (p μ + t))))
    (h_bound : ∀ t ∈ Set.Icc (-h) h,
        |iteratedDeriv 4 (fun t : ℝ => F (Function.update p μ (p μ + t))) t|
          ≤ M) :
    |F (Function.update p μ (p μ + h))
        - 2 * F p
        + F (Function.update p μ (p μ - h))
      - h^2 * iteratedDeriv 2 (fun t : ℝ => F (Function.update p μ (p μ + t))) 0|
      ≤ h^4 / 12 * M :=
  central_diff_second_order_accurate_axis F p μ h M hh hslice h_bound

end OmegaTheory.Foundations
