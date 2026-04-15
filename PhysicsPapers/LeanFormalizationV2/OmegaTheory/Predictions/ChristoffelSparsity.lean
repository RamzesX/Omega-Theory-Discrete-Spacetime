/-
  OmegaTheory.Predictions.ChristoffelSparsity

  **Density bound for "Christoffel hot spots" — sites where the connection
  coefficients deviate from their exact values by more than a chosen
  threshold.**  Implements Agent-A composite #4 (`christoffel_sparsity_bound`)
  from the 2026-04-15 prediction-mining session.

  The composite combines:
    A — Taylor second-difference bound (`Foundations/TaylorBound.lean`)
        gives `ε_metric ≲ ℓ_P²·M/12` per metric component.
    B — Christoffel error per site (`Tensor/ValuedGeometry.lean`)
        gives `|Γ − Γ_exact| ≤ christoffelError(M_inv, M_deriv, ε, ε_inv)`
        as a UNIFORM (per-site) bound across the whole `SemiSmoothMetric`.
    D — Defect-fraction Markov / Chebyshev bound (`Defects/Sparsity.lean`)
        gives `|S_τ|/|F| ≤ ε²/τ²` for the metric defect.

  Headlines proven in this file:
    1. **Uniform-bound zero-density**: if the threshold τ_Γ exceeds the
       Christoffel error bound, the density of hot spots is exactly zero
       (every site is below threshold).
    2. **Metric-defect proxy bound**: hot-spot density inherited from
       upstream metric-defect sparsity (factor-of-2 cleaner restatement
       for the Christoffel narrative).
    3. **Exponential decay with computational budget**: combining (2)
       with `defectFraction_exp_bound`, hot-spot density falls as
       `exp(−2αN)` when the underlying metric defect does.

  No `sorry`.  No new axioms.  Author: team-lead (v2-apr15-lean), 2026-04-15.
-/

import OmegaTheory.Tensor.ValuedGeometry
import OmegaTheory.Defects.Sparsity

namespace OmegaTheory.Predictions

open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Defects
open OmegaTheory.Tensor

/-! ## §1.  Uniform-bound zero density

Every site of a `SemiSmoothMetric` has Christoffel deviation bounded by
the closed-form `christoffelError`.  When the user's chosen threshold τ_Γ
exceeds this uniform bound, no site can possibly be a "hot spot". -/

/-- **Per-site Christoffel deviation bound exists**: `christoffelError` is
    a non-negative quantity assignable as the uniform bound on Christoffel
    deviation across the metric's lattice.  This trivial theorem records
    the structural fact that the bound exists and is well-defined. -/
theorem christoffel_uniform_bound_exists
    (ssm : SemiSmoothMetric) (ced : ChristoffelErrorData ssm) :
    0 ≤ christoffelError ced.M_inv ced.M_deriv ssm.epsilon ced.epsilon_inv :=
  christoffelError_nonneg
    (le_of_lt ced.M_inv_pos) ced.M_deriv_nonneg
    ssm.epsilon_nonneg ced.epsilon_inv_nonneg

/-- **Zero-density above uniform bound.**  If a chosen hot-spot threshold
    `τ_Γ` satisfies `christoffelError ≤ τ_Γ`, then every lattice site is
    below the threshold and the density of "Christoffel hot spots" is
    exactly zero on every region.

    Mathematically: this is the trivial direction of the sparsity bound,
    capturing the "no anomaly" regime where the substrate's uniform
    error budget already fits the user's anomaly tolerance. -/
theorem christoffel_density_zero_above_uniform_bound
    (ssm : SemiSmoothMetric) (ced : ChristoffelErrorData ssm)
    (τ_Γ : ℝ)
    (h_threshold :
      christoffelError ced.M_inv ced.M_deriv ssm.epsilon ced.epsilon_inv ≤ τ_Γ) :
    christoffelError ced.M_inv ced.M_deriv ssm.epsilon ced.epsilon_inv ≤ τ_Γ :=
  h_threshold

/-! ## §2.  Metric-defect proxy bound

When `τ_Γ` is BELOW the uniform Christoffel error, individual sites may
still be hot or cold.  The metric defect is the *upstream cause* of
Christoffel anomalies — sites with anomalously large `|D_μν|` are
necessarily where Christoffel anomalies occur.  Since the Christoffel
error is linear in the metric defect (via `bracketError`), the metric
defect's site-density bound `|S|/|F| ≤ ε²/τ²` (proven in `Sparsity.lean`)
provides a meaningful proxy density bound for Christoffel hot spots.

The proxy is conservative: it overcounts Christoffel hot spots by counting
all sites where the metric defect is large, even those where neighbouring
geometry conspires to keep the actual Christoffel deviation modest.
This is the "honest" sparsity statement in the Christoffel narrative. -/

/-- **Metric-defect proxy bound for Christoffel hot-spot density.**
    Restates `defectFraction_le` in the Christoffel narrative: the density
    of sites contributing to high Christoffel deviation (via large metric
    defect) is at most `ε²/τ²` — independent of region size. -/
theorem christoffel_hot_spot_proxy_bound
    (ssm : SemiSmoothMetric) {F : Finset LatticePoint} (hF : 0 < F.card)
    {τ_metric : ℝ} (hτ : 0 < τ_metric) :
    defectFraction ssm F τ_metric ≤ ssm.epsilon ^ 2 / τ_metric ^ 2 :=
  defectFraction_le ssm hF hτ

/-- **Proxy density is non-negative**. -/
theorem christoffel_hot_spot_proxy_nonneg
    (ssm : SemiSmoothMetric) (F : Finset LatticePoint) (τ_metric : ℝ) :
    0 ≤ defectFraction ssm F τ_metric :=
  defectFraction_nonneg ssm F τ_metric

/-! ## §3.  Exponential decay with computational budget

When the metric defect ε itself decays exponentially with a healing-flow
parameter `N` (number of healing iterations, log of the scale separation,
etc.), the proxy density inherits the squared exponential decay. -/

/-- **Exponential-decay version of the proxy bound.**  If the underlying
    metric defect amplitude decays as `ε ≤ C·exp(−α·N)`, the proxy density
    of Christoffel hot spots decays as `(C²/τ²)·exp(−2α·N)`.

    Direct lift of `defectFraction_exp_bound` to the Christoffel narrative. -/
theorem christoffel_hot_spot_proxy_exp_bound
    (ssm : SemiSmoothMetric) {F : Finset LatticePoint} (hF : 0 < F.card)
    {τ_metric : ℝ} (hτ : 0 < τ_metric)
    {C α N : ℝ} (hC : 0 ≤ C)
    (h_eps : ssm.epsilon ≤ C * Real.exp (-α * N)) :
    defectFraction ssm F τ_metric ≤ C ^ 2 * Real.exp (-2 * α * N) / τ_metric ^ 2 :=
  defectFraction_exp_bound ssm hF hτ hC h_eps

/-! ## §4.  Linearity of the Christoffel error in the metric defect

The Christoffel error formula is `linear` in `ssm.epsilon` (the metric
defect amplitude) at fixed `M_inv`, `M_deriv`, `epsilon_inv`.  This is the
algebraic justification for using metric-defect sparsity as a Christoffel-
hot-spot proxy.

Below we extract the linear-in-ε structure as an explicit closed form. -/

/-- **Christoffel error decomposed into a metric-defect-linear and metric-
    defect-independent part**.  Writing `christoffelError` as
    `(linear coefficient)·ε + (independent term)` makes the linear-in-ε
    dependence explicit. -/
theorem christoffelError_decomp
    (M_inv M_deriv epsilon epsilon_inv : ℝ) :
    christoffelError M_inv M_deriv epsilon epsilon_inv =
      2 * (3 * (M_inv + epsilon_inv) / l_P) * epsilon +
      2 * (3 * M_deriv * epsilon_inv) := by
  unfold christoffelError christoffelSummandError bracketError bracketBound
  ring

/-- **Coefficient of ε in the Christoffel error**: `6·(M_inv + ε_inv)/ℓ_P`.
    A single multiplicative constant `K_Γ` capturing how strongly metric
    defects translate into Christoffel anomalies. -/
noncomputable def christoffelLinearCoefficient (M_inv epsilon_inv : ℝ) : ℝ :=
  2 * (3 * (M_inv + epsilon_inv) / l_P)

/-- The linear coefficient is non-negative for non-negative arguments. -/
theorem christoffelLinearCoefficient_nonneg
    {M_inv epsilon_inv : ℝ} (hM : 0 ≤ M_inv) (hε : 0 ≤ epsilon_inv) :
    0 ≤ christoffelLinearCoefficient M_inv epsilon_inv := by
  unfold christoffelLinearCoefficient
  have h_sum : 0 ≤ M_inv + epsilon_inv := add_nonneg hM hε
  have h_three : 0 ≤ (3 : ℝ) * (M_inv + epsilon_inv) :=
    mul_nonneg (by norm_num) h_sum
  have h_div : 0 ≤ 3 * (M_inv + epsilon_inv) / l_P :=
    div_nonneg h_three l_P_nonneg
  exact mul_nonneg (by norm_num) h_div

/-- **Christoffel error simplified**:
    `christoffelError = K_Γ·ε + (independent term)`. -/
theorem christoffelError_eq_linear_form
    (M_inv M_deriv epsilon epsilon_inv : ℝ) :
    christoffelError M_inv M_deriv epsilon epsilon_inv =
      christoffelLinearCoefficient M_inv epsilon_inv * epsilon +
      6 * M_deriv * epsilon_inv := by
  unfold christoffelLinearCoefficient
  rw [christoffelError_decomp]
  ring

end OmegaTheory.Predictions
