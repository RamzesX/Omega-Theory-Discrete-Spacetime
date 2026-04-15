/-
  OmegaTheory.HealingFlow.LaSalle

  **LaSalle-type equivalences for the discrete healing flow.**

  Closes the equivalence loop on the Lyapunov theory:

  * forward (Lyapunov-flow + bounded → equilibrium): already in
    `Convergence.lean` via `asymptotic_equilibrium_exists`.
  * backward (equilibrium → fixed trajectory + zero dissipation): landed here.

  The headline identity is

      IsHealingEquilibrium  ↔  IsGradientDescentFixedPoint   (for δτ ≠ 0)

  together with the corollaries

      IsHealingEquilibrium  →  gradientNormSq = 0
      IsHealingEquilibrium  →  dissipationRate = 0
      path 0 at equilibrium → path (n · δτ) = path 0   (static info)

  which collectively give the LaSalle-style picture: equilibrium is exactly
  the fixed-point set of the gradient descent step, and is exactly the
  critical-point set of the Lyapunov functional `F`; trajectories through
  an equilibrium stay there forever under a static information field.

  No `sorry`.  No new axioms.

  Author: team-lead (v2-apr15-lean), 2026-04-15.
-/

import OmegaTheory.HealingFlow.Lyapunov

namespace OmegaTheory.HealingFlow

open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Conservation
open OmegaTheory.Defects

/-! ## Fixed points of the gradient descent step -/

/-- `g` is a **fixed point** of the discrete gradient descent step iff the
    step leaves `g` invariant.

    This is the dynamical analog of "critical point of `F`": the step cannot
    decrease `F` further because the gradient is zero. -/
def IsGradientDescentFixedPoint (params : HealingParams)
    (g g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (delta_tau : ℝ) : Prop :=
  gradientDescentStep params g g_exact I I_bar delta_tau = g

/-! ## (→) Equilibrium ⇒ fixed point -/

/-- **Equilibrium is a fixed point of the gradient descent step.**
    Direct repackaging of `gradientDescentStep_equilibrium`. -/
theorem fixed_point_of_equilibrium (params : HealingParams)
    (g g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (delta_tau : ℝ)
    (heq : IsHealingEquilibrium params g g_exact I I_bar) :
    IsGradientDescentFixedPoint params g g_exact I I_bar delta_tau :=
  gradientDescentStep_equilibrium params g g_exact I I_bar heq delta_tau

/-! ## (←) Fixed point ⇒ equilibrium (positive step) -/

/-- **A fixed point of the gradient descent step (with nonzero step) is a
    healing equilibrium.**

    Proof: if `g - δτ · ∇F = g`, then `δτ · ∇F = 0`; with `δτ ≠ 0` this
    forces `∇F = 0` pointwise, which unfolds to the equilibrium balance
    equation. -/
theorem equilibrium_of_fixed_point (params : HealingParams)
    (g g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (delta_tau : ℝ) (hdelta : delta_tau ≠ 0)
    (hfp : IsGradientDescentFixedPoint params g g_exact I I_bar delta_tau) :
    IsHealingEquilibrium params g g_exact I I_bar := by
  refine ⟨fun p μ ν => ?_⟩
  have hpt : gradientDescentStep params g g_exact I I_bar delta_tau p μ ν
             = g p μ ν := by
    unfold IsGradientDescentFixedPoint at hfp
    rw [hfp]
  unfold gradientDescentStep at hpt
  have hdelta_grad :
      delta_tau * functionalGradient params g g_exact I I_bar p μ ν = 0 := by
    linarith
  have hgrad_zero :
      functionalGradient params g g_exact I I_bar p μ ν = 0 := by
    rcases mul_eq_zero.mp hdelta_grad with h | h
    · exact absurd h hdelta
    · exact h
  unfold functionalGradient at hgrad_zero
  linarith

/-! ## The equivalence -/

/-- **(HEADLINE) Equilibrium ↔ fixed point of gradient descent**.
    The bidirectional characterization for positive discrete step size. -/
theorem equilibrium_iff_fixed_point (params : HealingParams)
    (g g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (delta_tau : ℝ) (hdelta : delta_tau ≠ 0) :
    IsHealingEquilibrium params g g_exact I I_bar ↔
    IsGradientDescentFixedPoint params g g_exact I I_bar delta_tau :=
  ⟨fun heq => fixed_point_of_equilibrium params g g_exact I I_bar
                delta_tau heq,
   fun hfp => equilibrium_of_fixed_point params g g_exact I I_bar
                delta_tau hdelta hfp⟩

/-! ## Equilibrium is a critical point of the Lyapunov functional -/

/-- **Equilibrium implies zero gradient norm.**  Every component of
    `functionalGradient` vanishes at equilibrium, so the sum of squares
    vanishes. -/
theorem gradientNormSq_of_equilibrium (params : HealingParams)
    (g g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (region : Finset LatticePoint)
    (heq : IsHealingEquilibrium params g g_exact I I_bar) :
    gradientNormSq params g g_exact I I_bar region = 0 := by
  unfold gradientNormSq
  apply Finset.sum_eq_zero
  intro p _
  apply Finset.sum_eq_zero
  intro μ _
  apply Finset.sum_eq_zero
  intro ν _
  have hbal := heq.balance p μ ν
  have hgrad : functionalGradient params g g_exact I I_bar p μ ν = 0 := by
    unfold functionalGradient
    linarith
  rw [hgrad]
  ring

/-- **Equilibrium is a critical point of `F`**: the instantaneous dissipation
    rate `dF/dτ = -‖∇F‖²` vanishes at equilibrium. -/
theorem dissipationRate_of_equilibrium (params : HealingParams)
    (g g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (region : Finset LatticePoint)
    (heq : IsHealingEquilibrium params g g_exact I I_bar) :
    dissipationRate params g g_exact I I_bar region = 0 := by
  unfold dissipationRate
  rw [gradientNormSq_of_equilibrium params g g_exact I I_bar region heq]
  ring

/-! ## Zero-gradient-norm ↔ pointwise balance equation on the region -/

/-- **Full regional characterisation**: `gradientNormSq = 0 on region ↔
    balance equation at every point of region`. Strengthens the one-way
    `gradient_zero_implies_balance` to a biconditional. -/
theorem gradientNormSq_zero_iff_balance (params : HealingParams)
    (g g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (region : Finset LatticePoint) :
    gradientNormSq params g g_exact I I_bar region = 0 ↔
    ∀ p ∈ region, ∀ μ ν : Fin 4,
      params.mu * discreteLaplacian (fun q => g q μ ν) p =
      params.lambda * defectTensor g g_exact p μ ν +
      params.gamma * (I p - I_bar) := by
  refine ⟨gradient_zero_implies_balance params g g_exact I I_bar region, ?_⟩
  intro hbal
  unfold gradientNormSq
  apply Finset.sum_eq_zero
  intro p hp
  apply Finset.sum_eq_zero
  intro μ _
  apply Finset.sum_eq_zero
  intro ν _
  have hb := hbal p hp μ ν
  have hgrad : functionalGradient params g g_exact I I_bar p μ ν = 0 := by
    unfold functionalGradient
    linarith
  rw [hgrad]
  ring

/-! ## LaSalle-type trajectory theorem (static information field)

If the initial condition is at equilibrium and the information field is
static, the entire discrete trajectory stays at that initial state. This is
**strict** Lyapunov stability: not "stays close to", but "stays exactly at". -/

/-- **Discrete LaSalle theorem for static info**: on a healing flow with a
    time-independent information field `I`, if `path 0` is at equilibrium
    with respect to `I`, then `path (n · δτ) = path 0` for every `n : ℕ`.

    Proof: induction on `n`.  Base: `path (0 · δτ) = path 0` trivially.
    Step: if `path (k · δτ) = path 0`, then `path (k · δτ)` is at
    equilibrium, so `healing_flow_preserves_equilibrium` gives
    `path ((k+1) · δτ) = path (k · δτ) = path 0`. -/
theorem healing_flow_static_info_path_eq_initial
    (params : HealingParams) (path : MetricPath)
    (g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (delta_tau : ℝ)
    (hflow : IsHealingFlow params path g_exact (fun _ => I) I_bar delta_tau)
    (heq0 : IsHealingEquilibrium params (path 0) g_exact I I_bar)
    (n : ℕ) :
    path ((n : ℝ) * delta_tau) = path 0 := by
  induction n with
  | zero =>
    simp
  | succ k ih =>
    have heq_k : IsHealingEquilibrium
        params (path ((k : ℝ) * delta_tau)) g_exact I I_bar := by
      rw [ih]; exact heq0
    funext p μ ν
    have hstep :
        path ((k : ℝ) * delta_tau + delta_tau) p μ ν
          = path ((k : ℝ) * delta_tau) p μ ν :=
      healing_flow_preserves_equilibrium params path g_exact (fun _ => I)
        I_bar delta_tau hflow ((k : ℝ) * delta_tau) heq_k p μ ν
    have htau : ((k + 1 : ℕ) : ℝ) * delta_tau
                  = (k : ℝ) * delta_tau + delta_tau := by
      push_cast; ring
    rw [htau, hstep, ih]

/-! ## Corollaries: functional and dissipation along an equilibrium trajectory

When the initial state is at equilibrium and the information field is static,
the Lyapunov functional `F` is constant and the dissipation rate `dF/dτ` is
identically zero along the entire discrete trajectory.  Strict Lyapunov
stability cashes out on the functional side as perfect flatness. -/

/-- **Functional constant along an equilibrium trajectory (static info).**
    With a time-independent information field and `path 0` at equilibrium,
    `functionalAtStep n = functionalAtStep 0` for all `n : ℕ`. -/
theorem functionalAtStep_constant_at_equilibrium
    (params : HealingParams) (path : MetricPath)
    (g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (delta_tau : ℝ)
    (region : Finset LatticePoint)
    (hflow : IsHealingFlow params path g_exact (fun _ => I) I_bar delta_tau)
    (heq0 : IsHealingEquilibrium params (path 0) g_exact I I_bar)
    (n : ℕ) :
    functionalAtStep params path g_exact (fun _ => I) I_bar region delta_tau n
      = functionalAtStep params path g_exact (fun _ => I) I_bar
          region delta_tau 0 := by
  unfold functionalAtStep
  rw [healing_flow_static_info_path_eq_initial params path g_exact I I_bar
        delta_tau hflow heq0 n]
  simp

/-- **Dissipation rate is zero along an equilibrium trajectory (static info).**
    At every step `n`, the pointwise dissipation rate computed from the
    trajectory state equals zero — because that state is `path 0`, which is
    at equilibrium. -/
theorem dissipationRate_zero_along_equilibrium_trajectory
    (params : HealingParams) (path : MetricPath)
    (g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (delta_tau : ℝ)
    (region : Finset LatticePoint)
    (hflow : IsHealingFlow params path g_exact (fun _ => I) I_bar delta_tau)
    (heq0 : IsHealingEquilibrium params (path 0) g_exact I I_bar)
    (n : ℕ) :
    dissipationRate params
        (path ((n : ℝ) * delta_tau)) g_exact I I_bar region = 0 := by
  rw [healing_flow_static_info_path_eq_initial params path g_exact I I_bar
        delta_tau hflow heq0 n]
  exact dissipationRate_of_equilibrium params (path 0) g_exact I I_bar
    region heq0

/-- **Gradient norm squared vanishes all along the equilibrium trajectory.**
    Pointwise: at every discrete step `n`, `‖∇F‖² (path (n · δτ)) = 0`. -/
theorem gradientNormSq_zero_along_equilibrium_trajectory
    (params : HealingParams) (path : MetricPath)
    (g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (delta_tau : ℝ)
    (region : Finset LatticePoint)
    (hflow : IsHealingFlow params path g_exact (fun _ => I) I_bar delta_tau)
    (heq0 : IsHealingEquilibrium params (path 0) g_exact I I_bar)
    (n : ℕ) :
    gradientNormSq params
        (path ((n : ℝ) * delta_tau)) g_exact I I_bar region = 0 := by
  rw [healing_flow_static_info_path_eq_initial params path g_exact I I_bar
        delta_tau hflow heq0 n]
  exact gradientNormSq_of_equilibrium params (path 0) g_exact I I_bar
    region heq0

end OmegaTheory.HealingFlow
