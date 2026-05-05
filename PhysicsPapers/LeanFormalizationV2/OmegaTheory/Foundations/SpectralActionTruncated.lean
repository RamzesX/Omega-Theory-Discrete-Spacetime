/-
  OmegaTheory.Foundations.SpectralActionTruncated

  **Lion's-Pride Phase 6.4 (2026-05-06)**:
  *Truncated heat-trace expansion = the N-th order Taylor approximation
  of `Tr(e^{-tD²})` around `t = 0`, in finite dimensions.*

  ## Why this file

  In Connes-Chamseddine spectral action `S = Tr(f(D/Λ))`, the
  asymptotic expansion at large cutoff `Λ` produces

      S(D, Λ, f)  ~  Σ_k f_k · Λ^{d - k} · ∫ a_k(D²)        (Λ → ∞)

  via the heat-kernel asymptotic of `Tr(e^{-tD²})` at `t → 0⁺`:

      Tr(e^{-tD²})  =  Σ_k (-t)^k / k! · Tr(D^{2k})        (FORMAL Taylor)
                    =  Σ_k (-t)^k / k! · a_k(D²)

  In FINITE DIMENSIONS this Taylor series CONVERGES (since the series
  is just `Σ_i e^{-tλ_i²}` with finitely many λ_i, which is entire in t).
  We can compute the truncated partial sums explicitly:

      truncatedHeatTrace T N t  :=  Σ_{k=0..N} (-t)^k / k! · a_k(T)

  This file ships that scaffold with key identities at low order.

  ## What this file ships

  | Property                                         | Theorem                                  |
  |--------------------------------------------------|------------------------------------------|
  | `truncatedHeatTrace T N t`                       | (definition)                             |
  | At zero order: `truncatedHeatTrace T 0 t = n`    | `truncatedHeatTrace_zero_order`          |
  | At t=0: any N ≥ 0 evaluates to n                 | `truncatedHeatTrace_at_t_zero`           |
  | First-order: `truncatedHeatTrace T 1 t = n - t·a_1` | `truncatedHeatTrace_one`              |
  | Recursion: `T N+1 = T N + (-t)^(N+1)/(N+1)! · a_{N+1}` | `truncatedHeatTrace_succ`         |
  | Headline (4-conjunct)                            | `spectral_action_truncated_report`        |

  ## Honest scope

  This file does NOT yet:
  * Define `Matrix.exp` of `(-t · D²)` directly (Mathlib has it, but
    invoking convergence requires the Banach-algebra-exponential
    chain — Phase 6.4-cont).
  * Prove `truncatedHeatTrace T N t → Tr(e^{-tD²})` as N → ∞ (the
    convergence theorem — Phase 6.4-cont).
  * Connect to continuum spectral action `S = Tr(f(D/Λ))` for an
    actual Λ-cutoff smooth f (Phase 6.5-cont).

  What it DOES ship: the truncated-Taylor-sum scaffold and its
  evaluation at t = 0 + first-order reductions.

  ## Author

  Lion's-Pride dynamic /loop iteration 23 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.HeatKernelCoefficients
import OmegaTheory.Foundations.HeatKernelBochnerForm
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.SpectralActionTruncated

open OmegaTheory.Foundations.FiniteSpectralTriple
open OmegaTheory.Foundations.HeatKernelCoefficients
open OmegaTheory.Foundations.HeatKernelBochnerForm

variable {n : ℕ}

/-! ## 1. Truncated heat-trace definition

    `truncatedHeatTrace T N t := Σ_{k=0..N} (-t)^k / k! · a_k(T)`. -/

/-- **Truncated heat-trace**: `Σ_{k=0..N} (-t)^k / k! · a_k(T)`.

    The N-th order Taylor partial sum of the heat trace
    `Tr(e^{-tD²}) = Σ_k (-t)^k / k! · a_k(T)` around `t = 0`. -/
noncomputable def truncatedHeatTrace
    (T : FiniteSpectralTriple n) (N : ℕ) (t : ℂ) : ℂ :=
  Finset.sum (Finset.range (N + 1)) fun k =>
    (-t)^k / (Nat.factorial k : ℂ) * heatKernelCoef T k

/-! ## 2. Recursion: T (N+1) = T N + (-t)^(N+1)/(N+1)! · a_{N+1} -/

/-- **Truncation step recursion**:
    `truncatedHeatTrace T (N+1) t = truncatedHeatTrace T N t
                                    + (-t)^(N+1) / (N+1)! · a_{N+1}(T)`. -/
theorem truncatedHeatTrace_succ
    (T : FiniteSpectralTriple n) (N : ℕ) (t : ℂ) :
    truncatedHeatTrace T (N + 1) t
      = truncatedHeatTrace T N t
        + (-t)^(N + 1) / (Nat.factorial (N + 1) : ℂ)
          * heatKernelCoef T (N + 1) := by
  unfold truncatedHeatTrace
  rw [Finset.sum_range_succ]

/-! ## 3. Zero-order truncation: T 0 t = a_0(T) = n -/

/-- **Zero-order truncation collapses to `a_0 = n`**:
    `truncatedHeatTrace T 0 t = n` for any t. -/
theorem truncatedHeatTrace_zero_order
    (T : FiniteSpectralTriple n) (t : ℂ) :
    truncatedHeatTrace T 0 t = (n : ℂ) := by
  unfold truncatedHeatTrace
  -- Sum over Finset.range 1 = {0}
  rw [Finset.sum_range_one]
  -- (-t)^0 / 0! * a_0 = 1 * 1 * a_0 = a_0
  rw [pow_zero, Nat.factorial_zero]
  rw [heatKernelCoef_zero T]
  push_cast
  ring

/-! ## 4. Evaluation at t = 0: any truncation order returns n -/

/-- **At `t = 0`, all truncations reduce to the zeroth coefficient `n`**.
    For any `N ≥ 0`:  `truncatedHeatTrace T N 0 = n`. -/
theorem truncatedHeatTrace_at_t_zero
    (T : FiniteSpectralTriple n) (N : ℕ) :
    truncatedHeatTrace T N 0 = (n : ℂ) := by
  unfold truncatedHeatTrace
  -- All terms (-0)^k for k ≥ 1 vanish; only k = 0 survives.
  -- Sum = (-0)^0 / 0! * a_0 + Σ_{k=1..N} 0 * (...) = 1 * a_0 = a_0
  induction N with
  | zero =>
    rw [Finset.sum_range_one, pow_zero, Nat.factorial_zero,
        heatKernelCoef_zero T]
    push_cast; ring
  | succ N ih =>
    rw [Finset.sum_range_succ]
    -- Higher term has factor (-0)^(N+1) = 0
    have h_zero : ((-(0 : ℂ)) ^ (N + 1)) = 0 := by
      simp [neg_zero, zero_pow, Nat.succ_ne_zero]
    rw [h_zero]
    rw [zero_div, zero_mul, add_zero]
    exact ih

/-! ## 5. First-order truncation: T 1 t = n - t · a_1 -/

/-- **First-order truncation**:
    `truncatedHeatTrace T 1 t = a_0(T) − t · a_1(T)
                                = n − t · Tr(D²)`. -/
theorem truncatedHeatTrace_one
    (T : FiniteSpectralTriple n) (t : ℂ) :
    truncatedHeatTrace T 1 t
      = (n : ℂ) - t * heatKernelCoef T 1 := by
  -- truncatedHeatTrace T 1 t = T 0 t + (-t)^1 / 1! · a_1
  rw [truncatedHeatTrace_succ T 0 t, truncatedHeatTrace_zero_order T t]
  -- (-t)^1 / 1! = -t
  rw [pow_one, Nat.factorial]
  push_cast
  ring

/-! ## 6. Headline composite report -/

/-- **Lion's-Pride Phase 6.4 headline — truncated spectral-action
    Taylor expansion structural report.**

    For any finite spectral triple `T : FiniteSpectralTriple n`,
    truncation order `N : ℕ`, and complex parameter `t : ℂ`:

    1. **Zero-order = n**: `truncatedHeatTrace T 0 t = n`.

    2. **At t = 0 evaluates to n**: any `N` gives `T N 0 = n`.

    3. **First-order linearization**:
       `truncatedHeatTrace T 1 t = n − t · a_1(T)`.

    4. **Truncation recursion**:
       `T (N+1) t = T N t + (-t)^(N+1)/(N+1)! · a_{N+1}(T)`. -/
theorem spectral_action_truncated_report
    (T : FiniteSpectralTriple n) (N : ℕ) (t : ℂ) :
    truncatedHeatTrace T 0 t = (n : ℂ) ∧
    truncatedHeatTrace T N 0 = (n : ℂ) ∧
    truncatedHeatTrace T 1 t = (n : ℂ) - t * heatKernelCoef T 1 ∧
    truncatedHeatTrace T (N + 1) t
      = truncatedHeatTrace T N t
        + (-t)^(N + 1) / (Nat.factorial (N + 1) : ℂ)
          * heatKernelCoef T (N + 1) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact truncatedHeatTrace_zero_order T t
  · exact truncatedHeatTrace_at_t_zero T N
  · exact truncatedHeatTrace_one T t
  · exact truncatedHeatTrace_succ T N t

end OmegaTheory.Foundations.SpectralActionTruncated
