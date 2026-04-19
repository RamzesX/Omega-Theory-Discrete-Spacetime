/-
  OmegaTheory.HealingFlow.LyapunovStrictDecrease

  **Target #15 (Gacrux, hunter-T15, 2026-04-19)**

  Strict decrease of the Lyapunov functional under the healing flow whenever
  the substrate is not yet at equilibrium.

  The pre-existing API (`Lyapunov.lean`, `Periodic.lean`, `Convergence.lean`,
  `LaSalle.lean`) provides:

  * `IsLyapunovHealingFlow.decrement`:
      `F(path (τ+δτ)) ≤ F(path τ) - δτ · ‖∇F(path τ)‖²`
    — the per-step non-strict decrement inequality.

  * `gradientNormSq_nonneg`: `0 ≤ ‖∇F‖²`.

  * `gradientNormSq_zero_iff_balance`: `‖∇F‖² = 0 ↔ the pointwise balance
    equation holds on the observation region` (the algebraic statement of
    equilibrium).

  What was missing was the **strict** version: whenever we are genuinely
  away from equilibrium (`0 < ‖∇F‖²`), the step's decrement is strict.
  This file closes that gap.

  ## Theorems

  1. **`lyapunov_strict_decrease_of_positive_defect`** — headline.
     `0 < gradientNormSq → F(path (τ+δτ)) < F(path τ)`.

  2. **`lyapunov_strict_decrease_under_nonzero_defect`** — paper-friendly
     alias matching the mission statement for Target #15.

  3. **`lyapunov_no_strict_drop_implies_balance`** — contrapositive package:
     if the functional does not strictly decrease across a step, then the
     equilibrium balance equation holds at every point of the region.

  4. **`lyapunov_strict_drop_or_balance`** — dichotomy form: at each step
     either the functional strictly drops or the state is at equilibrium.

  5. **`lyapunov_exists_strict_drop_of_positive_defect`** — existential form
     of the headline.

  ## On the converse "strict drop → positive defect"

  The converse `F(τ+δτ) < F(τ) → 0 < ‖∇F(τ)‖²` is NOT derivable from the
  current API. The `decrement` inequality only gives
  `F(τ+δτ) ≤ F(τ) - δτ·‖∇F‖²`, i.e. a LOWER BOUND on the drop.  Any
  user-supplied Lyapunov flow can satisfy the decrement with plenty of
  room to spare and still strictly decrease F even when ‖∇F‖² = 0 (the
  inequality is "≤", not "="). Only the FORWARD direction
  `0 < ‖∇F‖² → strict drop` consumes the inequality in the tight
  direction and so is derivable.

  The contrapositive `no strict drop → ‖∇F‖² = 0` IS derivable (because
  `0 < ‖∇F‖²` would force a strict drop, so no strict drop forces
  `‖∇F‖² ≤ 0`, combined with non-negativity gives `= 0`). This is exactly
  theorem (3) above.

  ## Physics interpretation

  The healing flow has no plateaus away from equilibrium: the substrate
  cannot idle in a non-equilibrium configuration. This is the discrete
  analog of "gradient descent on a smooth Lyapunov function admits no
  critical orbits away from critical points".

  No `sorry`, no new axioms.

  Gacrux — 2026-04-19.
-/

import OmegaTheory.HealingFlow.LaSalle
import OmegaTheory.HealingFlow.Periodic
import OmegaTheory.HealingFlow.Convergence

namespace OmegaTheory.HealingFlow

open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Conservation
open OmegaTheory.Defects

/-! ## Headline: strict Lyapunov decrease under positive defect -/

/-- **Strict Lyapunov decrease (headline)**: on a Lyapunov healing flow,
    whenever the gradient-norm-squared at time `τ` is strictly positive,
    the functional strictly decreases across one forward-Euler step.

    Proof: combine the per-step decrement inequality
    `F(τ+δτ) ≤ F(τ) - δτ · ‖∇F‖²`
    with `δτ > 0` and `0 < ‖∇F‖²` to conclude the drop `F(τ) - F(τ+δτ)` is
    strictly positive, hence `F(τ+δτ) < F(τ)`.

    The positivity of `gradientNormSq` captures "distance from equilibrium":
    by `gradientNormSq_zero_iff_balance`, this is equivalent to saying the
    balance equation is violated at some point in the observation region.
    So the hypothesis `0 < ‖∇F‖²` is precisely "not yet at equilibrium". -/
theorem lyapunov_strict_decrease_of_positive_defect
    (params : HealingParams) (path : MetricPath)
    (g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (delta_tau : ℝ) (region : Finset LatticePoint)
    (hflow : IsLyapunovHealingFlow params path g_exact I I_bar delta_tau region)
    (tau : ℝ)
    (h_pos : 0 < gradientNormSq params (path tau) g_exact I I_bar region) :
    healingFunctional params (path (tau + delta_tau)) g_exact I I_bar region <
    healingFunctional params (path tau) g_exact I I_bar region := by
  have hdec := hflow.decrement tau
  have hdt : 0 < delta_tau := hflow.step_pos
  have hprod_pos :
      0 < delta_tau * gradientNormSq params (path tau) g_exact I I_bar region :=
    mul_pos hdt h_pos
  linarith

/-- **Paper-friendly alias** for the headline (matches the Target #15
    mission statement: "the Lyapunov functional strictly decreases under
    one step of the healing flow whenever the defect measure is positive").

    The notion of "defect measure" used here is `gradientNormSq` — the
    `L²` norm squared of the functional gradient, which vanishes exactly
    at equilibrium (see `LaSalle.gradientNormSq_zero_iff_balance`). -/
theorem lyapunov_strict_decrease_under_nonzero_defect
    (params : HealingParams) (path : MetricPath)
    (g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (delta_tau : ℝ) (region : Finset LatticePoint)
    (hflow : IsLyapunovHealingFlow params path g_exact I I_bar delta_tau region)
    (tau : ℝ)
    (h_defect : 0 < gradientNormSq params (path tau) g_exact I I_bar region) :
    healingFunctional params (path (tau + delta_tau)) g_exact I I_bar region <
    healingFunctional params (path tau) g_exact I I_bar region :=
  lyapunov_strict_decrease_of_positive_defect params path g_exact I I_bar
    delta_tau region hflow tau h_defect

/-! ## Contrapositive: no strict drop ⇒ balance equation -/

/-- **No strict drop implies balance**: if the Lyapunov functional does not
    strictly decrease across a step, then the equilibrium balance equation
    holds at every point of the observation region.

    This is the contrapositive of `lyapunov_strict_decrease_of_positive_defect`
    combined with `gradientNormSq`'s non-negativity and the
    balance-characterisation from `LaSalle.lean`.

    Proof chain:
    * No strict drop + (0 < ‖∇F‖² → strict drop) ⟹ ¬(0 < ‖∇F‖²) ⟹ ‖∇F‖² ≤ 0.
    * `gradientNormSq_nonneg` ⟹ ‖∇F‖² ≥ 0.
    * Squeeze ⟹ ‖∇F‖² = 0.
    * `gradientNormSq_zero_iff_balance` ⟹ pointwise balance holds.

    Physically: the healing flow cannot "rest" on a non-equilibrium state —
    if the metric holds its Lyapunov value for one step, it must already
    be at equilibrium. -/
theorem lyapunov_no_strict_drop_implies_balance
    (params : HealingParams) (path : MetricPath)
    (g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (delta_tau : ℝ) (region : Finset LatticePoint)
    (hflow : IsLyapunovHealingFlow params path g_exact I I_bar delta_tau region)
    (tau : ℝ)
    (h_no_drop :
      ¬ (healingFunctional params (path (tau + delta_tau)) g_exact I I_bar region <
         healingFunctional params (path tau) g_exact I I_bar region)) :
    ∀ p ∈ region, ∀ μ ν : Fin 4,
      params.mu * discreteLaplacian (fun q => path tau q μ ν) p =
      params.lambda * defectTensor (path tau) g_exact p μ ν +
      params.gamma * (I p - I_bar) := by
  -- Step 1: gradientNormSq ≤ 0 (otherwise the strict decrease would apply).
  have h_not_pos :
      ¬ (0 < gradientNormSq params (path tau) g_exact I I_bar region) := by
    intro h_pos
    exact h_no_drop
      (lyapunov_strict_decrease_of_positive_defect params path g_exact I I_bar
        delta_tau region hflow tau h_pos)
  -- Step 2: Combined with non-negativity, gradientNormSq = 0.
  have hnn := gradientNormSq_nonneg params (path tau) g_exact I I_bar region
  have h_le : gradientNormSq params (path tau) g_exact I I_bar region ≤ 0 :=
    not_lt.mp h_not_pos
  have h_zero :
      gradientNormSq params (path tau) g_exact I I_bar region = 0 := by
    linarith
  -- Step 3: Apply the balance characterisation from LaSalle.
  exact (gradientNormSq_zero_iff_balance params (path tau) g_exact I I_bar
    region).mp h_zero

/-! ## Dichotomy: strict drop or equilibrium -/

/-- **Strict drop or balance** (dichotomy). At every step, either the
    Lyapunov functional strictly decreases, or the state is already at
    equilibrium (balance equation holds on the region).

    Useful for case analysis: whenever one proves something about a
    Lyapunov healing flow, one may assume — without loss of generality —
    either a strict drop in `F` or a balance-equilibrium configuration. -/
theorem lyapunov_strict_drop_or_balance
    (params : HealingParams) (path : MetricPath)
    (g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (delta_tau : ℝ) (region : Finset LatticePoint)
    (hflow : IsLyapunovHealingFlow params path g_exact I I_bar delta_tau region)
    (tau : ℝ) :
    (healingFunctional params (path (tau + delta_tau)) g_exact I I_bar region <
      healingFunctional params (path tau) g_exact I I_bar region) ∨
    (∀ p ∈ region, ∀ μ ν : Fin 4,
      params.mu * discreteLaplacian (fun q => path tau q μ ν) p =
      params.lambda * defectTensor (path tau) g_exact p μ ν +
      params.gamma * (I p - I_bar)) := by
  by_cases h : healingFunctional params (path (tau + delta_tau)) g_exact I I_bar region <
               healingFunctional params (path tau) g_exact I I_bar region
  · exact Or.inl h
  · exact Or.inr
      (lyapunov_no_strict_drop_implies_balance params path g_exact I I_bar
        delta_tau region hflow tau h)

/-! ## Existential repackaging -/

/-- **Existence of a strictly smaller future state**: if the gradient-
    norm-squared is positive at time `τ`, then there exists a future time
    `τ'` such that `F(path τ') < F(path τ)`. Restating the headline with
    an existential quantifier for bridging to downstream convergence
    arguments. -/
theorem lyapunov_exists_strict_drop_of_positive_defect
    (params : HealingParams) (path : MetricPath)
    (g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (delta_tau : ℝ) (region : Finset LatticePoint)
    (hflow : IsLyapunovHealingFlow params path g_exact I I_bar delta_tau region)
    (tau : ℝ)
    (h_pos : 0 < gradientNormSq params (path tau) g_exact I I_bar region) :
    ∃ τ' : ℝ,
      healingFunctional params (path τ') g_exact I I_bar region <
      healingFunctional params (path tau) g_exact I I_bar region :=
  ⟨tau + delta_tau,
   lyapunov_strict_decrease_of_positive_defect params path g_exact I I_bar
     delta_tau region hflow tau h_pos⟩

/-! ## Defect-based restatement: pointwise defect forces strict drop

The "positive gradient-norm-squared" hypothesis can equivalently be
phrased as "the balance equation is violated at some point in the
region", using `gradientNormSq_zero_iff_balance` from `LaSalle.lean`. -/

/-- **Balance violation forces strict decrease**: if at time `τ` there is
    some point `p ∈ region` and some indices `μ, ν` at which the balance
    equation does NOT hold, then `F(τ+δτ) < F(τ)`.

    This is the headline in its equivalent "pointwise defect" form. It is
    the sharpest version of the paper's informal claim that "non-trivial
    defect forces strict dissipation of the healing functional". -/
theorem lyapunov_strict_decrease_of_balance_violation
    (params : HealingParams) (path : MetricPath)
    (g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (delta_tau : ℝ) (region : Finset LatticePoint)
    (hflow : IsLyapunovHealingFlow params path g_exact I I_bar delta_tau region)
    (tau : ℝ)
    (h_viol :
      ¬ (∀ p ∈ region, ∀ μ ν : Fin 4,
          params.mu * discreteLaplacian (fun q => path tau q μ ν) p =
          params.lambda * defectTensor (path tau) g_exact p μ ν +
          params.gamma * (I p - I_bar))) :
    healingFunctional params (path (tau + delta_tau)) g_exact I I_bar region <
    healingFunctional params (path tau) g_exact I I_bar region := by
  -- Contrapositive of `lyapunov_no_strict_drop_implies_balance`.
  by_contra h
  exact h_viol
    (lyapunov_no_strict_drop_implies_balance params path g_exact I I_bar
      delta_tau region hflow tau h)

end OmegaTheory.HealingFlow
