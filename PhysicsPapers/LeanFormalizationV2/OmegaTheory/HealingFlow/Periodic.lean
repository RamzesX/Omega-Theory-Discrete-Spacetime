/-
  OmegaTheory.HealingFlow.Periodic

  Rescued Theorem 7.1 (Chronology Protection): no non-trivial periodic
  orbits of the healing flow exist away from equilibrium.

  ## Background

  The paper's original Theorem 7.1 (Appendix S §7.2) derived chronology
  protection from a circular argument (Fourth Noether Law ⇒ "information
  exists twice on a CTC" ⇒ contradiction). The argument was invalid for
  three independent reasons documented in Appendix S §7A:

  1. A conserved current `∂·J = 0` admits divergence-free circulations
     on cycles (Kirchhoff's law).
  2. The OmegaTheory information current is a gradient `J = ∇I`, hence
     curl-free by construction — `∮J·dl = 0` on any cycle automatically,
     compatible with any circulation pattern.
  3. The "information exists twice" step smuggled in the conclusion
     (distinct time coordinates at the same spacetime point).

  This file replaces that with a Lyapunov periodic-orbit argument:
  F is a Lyapunov function bounded below, F is monotone non-increasing
  along the flow, so on any returning path F must be constant, hence
  ‖∇F‖² = 0 throughout, hence the balance equation holds.

  ## Scope limits

  **This is a theorem about periodic orbits of the relaxation flow g(τ),
  where τ is healing time. It is NOT a theorem about closed timelike
  curves in the physical Lorentzian geometry (M, g).** The two are
  different questions at different conceptual layers. See Appendix S
  §7.3 for the honest chronology-protection status.

  ## Proof strategy

  The proof requires a per-step F-decrement inequality:
  `F(path(τ+δτ)) ≤ F(path τ) - δτ · ‖∇F(path τ)‖²`
  which is not exact for forward-Euler integration — it holds up to
  `O(δτ²)` under a Lipschitz bound on `∇F`. Rather than axiomatize this
  or bury it in a `sorry`, we package it as a structural hypothesis
  `IsLyapunovHealingFlow` that refines `IsHealingFlow` with the explicit
  decrement property. Users who construct such a flow then get the
  periodic-orbit theorem as a clean consequence.

  ## Companion: Proposition 7.2

  Bounded information variance: `F[g] ≤ F₀` implies
  `Σ (I p - I_bar)² ≤ 2·F₀` for the V2 normalization in which
  `infoTerm = (1/2)(I - Ī)²` (no γ prefactor; γ is absorbed into
  the flow coupling, not into the functional).
-/

import OmegaTheory.HealingFlow.Lyapunov

namespace OmegaTheory.HealingFlow

open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Conservation
open OmegaTheory.Defects

/-! ## Discrete Periodicity -/

/-- A healing-flow path is `n`-step periodic with period `n · δτ` starting
    at `tau0` iff `path tau0 = path (tau0 + n · δτ)` pointwise. Non-trivial
    periodicity means `n ≥ 1`. -/
def IsDiscretePeriodic (path : MetricPath) (delta_tau : ℝ) (n : ℕ) (tau0 : ℝ) : Prop :=
  1 ≤ n ∧ ∀ p μ ν, path tau0 p μ ν = path (tau0 + n * delta_tau) p μ ν

/-! ## Lyapunov Healing Flow

A discrete healing flow refined with the per-step F-decrement inequality.
This is the structural hypothesis that lets us prove periodic orbits are
at equilibrium — without it, forward-Euler flows can overshoot and
temporarily increase F, breaking the Lyapunov argument.

The decrement property holds for any flow with step size `δτ ≤ 2/L`
where `L` is the local Lipschitz constant of `∇F`. We do not prove this
from more primitive inputs here; we assert it as part of the structure. -/

/-- A healing flow that satisfies the per-step Lyapunov decrement
    inequality. Fixes an observation region and a constant (frozen)
    information field along the orbit. -/
structure IsLyapunovHealingFlow (params : HealingParams) (path : MetricPath)
    (g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (delta_tau : ℝ) (region : Finset LatticePoint) : Prop where
  /-- The time step is positive. -/
  step_pos : 0 < delta_tau
  /-- Per-step F-decrement inequality: F(path(τ+δτ)) ≤ F(path τ) - δτ · ‖∇F‖².
      This encodes the discrete Lyapunov property for the forward-Euler
      flow. It is a user-supplied hypothesis, not derived from more
      primitive inputs — for sufficiently small `δτ` relative to the
      local Lipschitz constant of `∇F` it holds, but we do not fix
      that constant here. -/
  decrement : ∀ tau,
    healingFunctional params (path (tau + delta_tau)) g_exact I I_bar region ≤
    healingFunctional params (path tau) g_exact I I_bar region -
    delta_tau * gradientNormSq params (path tau) g_exact I I_bar region

/-! ## Total dissipation over an orbit -/

/-- The total dissipation accumulated over `n` forward-Euler steps starting
    at `tau0`: the sum of `‖∇F(path(tau0 + k·δτ))‖²` for `k < n`.
    This is the discrete analog of `∫_{tau0}^{tau0 + n·δτ} ‖∇F‖² dτ / δτ`. -/
noncomputable def totalDissipation
    (params : HealingParams) (path : MetricPath)
    (g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (region : Finset LatticePoint)
    (delta_tau : ℝ) (n : ℕ) (tau0 : ℝ) : ℝ :=
  (Finset.range n).sum fun k =>
    gradientNormSq params (path (tau0 + k * delta_tau)) g_exact I I_bar region

/-- Total dissipation over any number of steps is non-negative, since each
    summand `gradientNormSq` is non-negative. -/
theorem totalDissipation_nonneg
    (params : HealingParams) (path : MetricPath)
    (g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (region : Finset LatticePoint)
    (delta_tau : ℝ) (n : ℕ) (tau0 : ℝ) :
    0 ≤ totalDissipation params path g_exact I I_bar region delta_tau n tau0 := by
  unfold totalDissipation
  exact Finset.sum_nonneg fun k _ =>
    gradientNormSq_nonneg params _ g_exact I I_bar region

/-! ## Dissipation telescoping -/

/-- Over `n` forward-Euler Lyapunov steps, the drop in `F` is at least
    `δτ · totalDissipation`. Proof by induction on `n`, consuming
    `IsLyapunovHealingFlow.decrement` at each step. -/
theorem healingFunctional_telescoping
    (params : HealingParams) (path : MetricPath)
    (g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (delta_tau : ℝ) (region : Finset LatticePoint)
    (hflow : IsLyapunovHealingFlow params path g_exact I I_bar delta_tau region)
    (tau0 : ℝ) (n : ℕ) :
    healingFunctional params (path tau0) g_exact I I_bar region -
      healingFunctional params (path (tau0 + n * delta_tau)) g_exact I I_bar region ≥
    delta_tau * totalDissipation params path g_exact I I_bar region delta_tau n tau0 := by
  induction n with
  | zero =>
    simp [totalDissipation]
  | succ n ih =>
    -- F(τ₀) - F(τ₀ + (n+1)δτ) = (F(τ₀) - F(τ₀ + n·δτ)) + (F(τ₀ + n·δτ) - F(τ₀ + (n+1)δτ))
    -- ≥ δτ · sum_{k<n} + δτ · gradNormSq(τ₀ + n·δτ) = δτ · sum_{k<n+1}
    have hstep := hflow.decrement (tau0 + n * delta_tau)
    -- Rewrite (tau0 + n * delta_tau) + delta_tau = tau0 + (n + 1) * delta_tau
    have harith :
        tau0 + ↑n * delta_tau + delta_tau = tau0 + (↑n + 1) * delta_tau := by ring
    rw [harith] at hstep
    have hnat : (↑(n + 1) : ℝ) = ↑n + 1 := by push_cast; ring
    -- Now combine the induction hypothesis with the step
    have h1 :
        healingFunctional params (path tau0) g_exact I I_bar region -
          healingFunctional params (path (tau0 + ↑(n + 1) * delta_tau)) g_exact I I_bar region =
        (healingFunctional params (path tau0) g_exact I I_bar region -
          healingFunctional params (path (tau0 + ↑n * delta_tau)) g_exact I I_bar region) +
        (healingFunctional params (path (tau0 + ↑n * delta_tau)) g_exact I I_bar region -
          healingFunctional params (path (tau0 + ↑(n + 1) * delta_tau)) g_exact I I_bar region) := by
      ring
    rw [h1]
    have h2 :
        healingFunctional params (path (tau0 + ↑n * delta_tau)) g_exact I I_bar region -
          healingFunctional params (path (tau0 + ↑(n + 1) * delta_tau)) g_exact I I_bar region ≥
        delta_tau *
          gradientNormSq params (path (tau0 + ↑n * delta_tau)) g_exact I I_bar region := by
      rw [hnat]
      linarith [hstep]
    have h3 :
        delta_tau *
          totalDissipation params path g_exact I I_bar region delta_tau (n + 1) tau0 =
        delta_tau * totalDissipation params path g_exact I I_bar region delta_tau n tau0 +
        delta_tau *
          gradientNormSq params (path (tau0 + ↑n * delta_tau)) g_exact I I_bar region := by
      unfold totalDissipation
      rw [Finset.sum_range_succ]
      ring
    rw [h3]
    linarith

/-! ## Periodic orbit ⇒ zero dissipation -/

/-- On a discrete periodic orbit of a Lyapunov healing flow, the total
    dissipation vanishes. This is the key step: periodicity forces
    `F(path τ₀) = F(path (τ₀ + n·δτ))`, which combined with telescoping
    and non-negativity squeezes the dissipation to zero. -/
theorem totalDissipation_eq_zero_of_periodic
    (params : HealingParams) (path : MetricPath)
    (g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (delta_tau : ℝ) (region : Finset LatticePoint)
    (hflow : IsLyapunovHealingFlow params path g_exact I I_bar delta_tau region)
    (tau0 : ℝ) (n : ℕ)
    (hper : IsDiscretePeriodic path delta_tau n tau0) :
    totalDissipation params path g_exact I I_bar region delta_tau n tau0 = 0 := by
  -- From periodicity: path τ₀ = path (τ₀ + n·δτ) pointwise, hence F is equal.
  have hpath : path tau0 = path (tau0 + n * delta_tau) := by
    funext p μ ν
    exact hper.2 p μ ν
  have hFeq :
      healingFunctional params (path tau0) g_exact I I_bar region =
      healingFunctional params (path (tau0 + n * delta_tau)) g_exact I I_bar region := by
    rw [hpath]
  -- From telescoping: F(τ₀) - F(τ₀+nδτ) ≥ δτ · total, so 0 ≥ δτ · total.
  have htel := healingFunctional_telescoping params path g_exact I I_bar delta_tau
    region hflow tau0 n
  have h0 : 0 ≥ delta_tau *
      totalDissipation params path g_exact I I_bar region delta_tau n tau0 := by
    linarith
  -- Combine with δτ > 0 and total ≥ 0 to squeeze total to 0.
  have hstep_pos := hflow.step_pos
  have hnn := totalDissipation_nonneg params path g_exact I I_bar region delta_tau n tau0
  have hprod_nn : 0 ≤ delta_tau *
      totalDissipation params path g_exact I I_bar region delta_tau n tau0 :=
    mul_nonneg (le_of_lt hstep_pos) hnn
  have hprod_zero :
      delta_tau * totalDissipation params path g_exact I I_bar region delta_tau n tau0 = 0 := by
    linarith
  have hdtnz : delta_tau ≠ 0 := ne_of_gt hstep_pos
  exact (mul_eq_zero.mp hprod_zero).resolve_left hdtnz

/-! ## Every intermediate config is at equilibrium -/

/-- Each gradient-norm-square on a discrete periodic orbit is zero. -/
theorem gradientNormSq_eq_zero_on_periodic_orbit
    (params : HealingParams) (path : MetricPath)
    (g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (delta_tau : ℝ) (region : Finset LatticePoint)
    (hflow : IsLyapunovHealingFlow params path g_exact I I_bar delta_tau region)
    (tau0 : ℝ) (n : ℕ)
    (hper : IsDiscretePeriodic path delta_tau n tau0)
    (k : ℕ) (hk : k < n) :
    gradientNormSq params (path (tau0 + k * delta_tau)) g_exact I I_bar region = 0 := by
  have htotal := totalDissipation_eq_zero_of_periodic params path g_exact I I_bar
    delta_tau region hflow tau0 n hper
  unfold totalDissipation at htotal
  have hnn : ∀ j ∈ Finset.range n,
      0 ≤ gradientNormSq params (path (tau0 + j * delta_tau)) g_exact I I_bar region :=
    fun j _ => gradientNormSq_nonneg params _ g_exact I I_bar region
  exact Finset.sum_eq_zero_iff_of_nonneg hnn |>.mp htotal k (Finset.mem_range.mpr hk)

/-! ## Main Theorem (Rescued 7.1): No non-trivial periodic orbits -/

/-- **Rescued Theorem 7.1** (Appendix S §7.2, this project). On any
    discrete periodic orbit of a Lyapunov healing flow, every
    intermediate configuration satisfies the equilibrium balance
    equation — i.e., the entire orbit lies in the equilibrium set.

    Equivalently: the healing flow admits NO non-trivial periodic
    orbits away from equilibrium. This is the rescued version of
    the paper's Theorem 7.1, replacing the circular argument in
    earlier drafts with an honest Lyapunov periodic-orbit theorem.

    **Scope limit**: this is a theorem about periodic orbits of the
    relaxation flow in healing time `τ`, NOT about closed timelike
    curves in the physical spacetime. See Appendix S §7.3 for the
    honest chronology-protection status of OmegaTheory. -/
theorem no_nontrivial_periodic_orbits
    (params : HealingParams) (path : MetricPath)
    (g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (delta_tau : ℝ) (region : Finset LatticePoint)
    (hflow : IsLyapunovHealingFlow params path g_exact I I_bar delta_tau region)
    (tau0 : ℝ) (n : ℕ)
    (hper : IsDiscretePeriodic path delta_tau n tau0)
    (k : ℕ) (hk : k < n) (p : LatticePoint) (hp : p ∈ region) (μ ν : Fin 4) :
    params.mu * discreteLaplacian (fun q => path (tau0 + k * delta_tau) q μ ν) p =
      params.lambda * defectTensor (path (tau0 + k * delta_tau)) g_exact p μ ν +
      params.gamma * (I p - I_bar) := by
  have h0 := gradientNormSq_eq_zero_on_periodic_orbit params path g_exact I I_bar
    delta_tau region hflow tau0 n hper k hk
  exact gradient_zero_implies_balance params (path (tau0 + k * delta_tau))
    g_exact I I_bar region h0 p hp μ ν

/-! ## Proposition 7.2: Bounded information variance

From Appendix S §7.4 (this project). The original paper claimed
`W[g] → ∞` as a geometry approaches a CTC, justified by the circular
"I → 2I → 4I → …" doubling. This proposition is the correct replacement:
under the healing flow, the information variance is bounded ABOVE by
`2 · F₀` where `F₀` is the initial value of the healing functional.

Note on the coefficient: V2's `infoTerm` is `(1/2)(I - Ī)²` with no γ
prefactor (γ is absorbed into the flow coupling, not into the functional).
Hence the bound is `Σ(I-Ī)² ≤ 2·F` rather than the paper's nominal
`2·F/γ`. The two are equivalent under the V2 normalization convention.
-/

/-- The sum `Σ_{p ∈ region} (1/2)(I p - I_bar)²` is bounded above by the
    healing functional `F[g]`, because `F` is a sum of `infoTerm`
    (this quantity) plus two other non-negative terms. -/
theorem infoTerm_sum_le_healingFunctional
    (params : HealingParams)
    (g g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (region : Finset LatticePoint) :
    (region.sum fun p => infoTerm I I_bar p) ≤
      healingFunctional params g g_exact I I_bar region := by
  unfold healingFunctional
  have hsplit :
      (region.sum fun p =>
        infoTerm I I_bar p +
        defectTerm g g_exact params.lambda p +
        smoothnessTerm g params.mu p) =
      (region.sum fun p => infoTerm I I_bar p) +
      (region.sum fun p => defectTerm g g_exact params.lambda p) +
      (region.sum fun p => smoothnessTerm g params.mu p) := by
    rw [← Finset.sum_add_distrib, ← Finset.sum_add_distrib]
  rw [hsplit]
  have hdefect :
      0 ≤ (region.sum fun p => defectTerm g g_exact params.lambda p) :=
    Finset.sum_nonneg fun p _ => defectTerm_nonneg g g_exact params.lambda_pos p
  have hsmooth :
      0 ≤ (region.sum fun p => smoothnessTerm g params.mu p) :=
    Finset.sum_nonneg fun p _ => smoothnessTerm_nonneg g params.mu_pos p
  linarith

/-- **Proposition 7.2**: bounded information variance. Under any
    configuration whose healing functional is bounded by `F₀`, the
    pointwise sum `Σ (I p - I_bar)²` over the observation region is
    bounded by `2 · F₀`. In particular, the information field cannot
    "blow up" on a bounded-F configuration — a clean honest replacement
    for the earlier paper's circular `W → ∞ near CTC` claim. -/
theorem bounded_info_variance
    (params : HealingParams)
    (g g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (region : Finset LatticePoint)
    (F0 : ℝ)
    (hF0 : healingFunctional params g g_exact I I_bar region ≤ F0) :
    (region.sum fun p => (I p - I_bar) ^ 2) ≤ 2 * F0 := by
  have h1 := infoTerm_sum_le_healingFunctional params g g_exact I I_bar region
  have h2 : (region.sum fun p => infoTerm I I_bar p) ≤ F0 := le_trans h1 hF0
  -- Σ infoTerm = Σ (1/2)(I - Ī)² = (1/2) Σ (I - Ī)²
  have hinfoeq :
      (region.sum fun p => infoTerm I I_bar p) =
      (1/2) * (region.sum fun p => (I p - I_bar) ^ 2) := by
    unfold infoTerm
    rw [← Finset.mul_sum]
  rw [hinfoeq] at h2
  linarith

end OmegaTheory.HealingFlow
