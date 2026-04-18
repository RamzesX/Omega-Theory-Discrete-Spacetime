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

/-! ## Corollaries on the Periodic Orbit

Direct consequences of the periodic-orbit analysis above. Each of these
folds the zero-total-dissipation fact back into physical observables. -/

/-- Every pointwise gradient component vanishes at every step on a discrete
    periodic orbit. Combining `gradientNormSq_eq_zero_on_periodic_orbit`
    with the pointwise gradient factorisation from `Lyapunov.lean`. -/
theorem functionalGradient_eq_zero_on_periodic_orbit
    (params : HealingParams) (path : MetricPath)
    (g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (delta_tau : ℝ) (region : Finset LatticePoint)
    (hflow : IsLyapunovHealingFlow params path g_exact I I_bar delta_tau region)
    (tau0 : ℝ) (n : ℕ)
    (hper : IsDiscretePeriodic path delta_tau n tau0)
    (k : ℕ) (hk : k < n)
    (p : LatticePoint) (hp : p ∈ region) (μ ν : Fin 4) :
    functionalGradient params (path (tau0 + k * delta_tau)) g_exact I I_bar p μ ν = 0 := by
  have hnorm := gradientNormSq_eq_zero_on_periodic_orbit params path g_exact I I_bar
    delta_tau region hflow tau0 n hper k hk
  exact gradientNormSq_eq_zero_imp params (path (tau0 + k * delta_tau))
    g_exact I I_bar region hnorm p hp μ ν

/-- F is constant at every step on a discrete periodic orbit: combining
    the telescoping upper bound and the zero-total-dissipation identity
    squeezes F(path(tau0 + j·δτ)) to a common value for every `j ≤ n`.
    The per-step decrement inequality is tight — no step strictly decreases
    the functional when the orbit is periodic. -/
theorem healingFunctional_constant_on_periodic_orbit
    (params : HealingParams) (path : MetricPath)
    (g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (delta_tau : ℝ) (region : Finset LatticePoint)
    (hflow : IsLyapunovHealingFlow params path g_exact I I_bar delta_tau region)
    (tau0 : ℝ) (n : ℕ)
    (hper : IsDiscretePeriodic path delta_tau n tau0)
    (k : ℕ) (hk : k < n) :
    healingFunctional params (path (tau0 + (k + 1) * delta_tau)) g_exact I I_bar region =
    healingFunctional params (path (tau0 + k * delta_tau)) g_exact I I_bar region := by
  -- From Lyapunov: F(τ + δτ) ≤ F(τ) - δτ · ‖∇F‖²
  have hdec := hflow.decrement (tau0 + k * delta_tau)
  -- From periodic orbit: ‖∇F‖²(k) = 0
  have hgrad := gradientNormSq_eq_zero_on_periodic_orbit params path g_exact I I_bar
    delta_tau region hflow tau0 n hper k hk
  -- So F(k+1) ≤ F(k). But F is monotone non-increasing on the whole orbit,
  -- and the cycle F(0) = F(n) = F(0) squeezes every intermediate value.
  -- Direct argument: F(k+1) ≤ F(k); also F(n) = F(0) (periodicity) ≥ F(k+1) ≥ F(k).
  -- But F is antitone, so F(0) ≥ F(k+1). Chain: F(0) ≥ F(k) ≥ F(k+1) ≥ F(n) = F(0).
  -- Therefore F(k) = F(k+1).
  -- Compute: from decrement with hgrad, F((k+1)δτ) ≤ F(kδτ) - δτ·0 = F(kδτ).
  have harith : tau0 + ↑k * delta_tau + delta_tau = tau0 + ↑(k + 1) * delta_tau := by
    push_cast; ring
  rw [harith] at hdec
  rw [hgrad, mul_zero, sub_zero] at hdec
  have hle : healingFunctional params (path (tau0 + ↑(k + 1) * delta_tau))
      g_exact I I_bar region ≤
      healingFunctional params (path (tau0 + ↑k * delta_tau))
      g_exact I I_bar region := hdec
  -- For the reverse inequality, use the telescoping: summing F-drops from k+1 to n,
  -- each summand is non-negative (from decrement + grad ≥ 0), and the total
  -- F(k+1) - F(n) is bounded below by δτ · dissipation(n - (k+1)). But
  -- F(k+1) ≤ F(k), and F(n) = F(0) ≥ F(k) (F antitone from 0 to k). So
  -- F(k+1) - F(n) ≤ F(k) - F(k) = 0. Combined with non-negativity: F(k+1) = F(n).
  -- Then F(k+1) ≥ F(n) = F(0) ≥ F(k). So F(k+1) = F(k).
  -- Simpler: use that F is antitone ⇒ F(k+1) ≤ F(k) and F(0) ≥ F(k+1); combined
  -- with F(0) = F(n) ≤ F(k+1) (F antitone from k+1 to n) gives F(k+1) = F(0) = F(k).
  -- Rather than reprove antitonicity here, use the zero-total-dissipation result
  -- directly: any F-jump would contradict totalDissipation = 0 via telescoping.
  -- Cleaner path: Invoke healingFunctional_telescoping on [0, n] and [0, k+1].
  -- Use the endpoint equality from periodicity + every intermediate F is squeezed
  -- by telescoping inequality + non-negativity of each pointwise summand.
  have hpath_periodic :
      healingFunctional params (path tau0) g_exact I I_bar region =
      healingFunctional params (path (tau0 + ↑n * delta_tau)) g_exact I I_bar region := by
    have hpath : path tau0 = path (tau0 + n * delta_tau) := by
      funext p μ ν; exact hper.2 p μ ν
    rw [hpath]
  -- Telescope from 0 to k+1:
  have htel_up := healingFunctional_telescoping params path g_exact I I_bar delta_tau
    region hflow tau0 (k + 1)
  have htel_full := healingFunctional_telescoping params path g_exact I I_bar delta_tau
    region hflow tau0 n
  -- From hpath_periodic: F(0) - F(n) = 0, so δτ · total(n) ≤ 0. Combined with
  -- ≥ 0 : total(n) = 0. Thus every gradNormSq along the orbit is zero.
  -- Now F(k+1) - F(n) : telescope from k+1 to n, all gradNormSq = 0, so F(k+1) = F(n) = F(0).
  -- Chain: F(0) = F(k+1) ≤ F(k) ≤ F(0) ⟹ equal.
  -- Formally: F(k+1) - F(n) is bounded below by 0 (each drop ≥ 0), and
  -- F(k+1) ≤ F(0) = F(n) so F(k+1) - F(n) ≤ 0. Therefore F(k+1) = F(n) = F(0).
  -- And F(k) ≤ F(0) = F(k+1) (the reverse of hle). Combined: F(k) = F(k+1).
  -- Direct route using antitonicity from Convergence.lean would be cleaner, but
  -- to keep this file standalone we establish the needed inequalities here.
  have hk1_le_0 : healingFunctional params (path (tau0 + ↑(k + 1) * delta_tau))
      g_exact I I_bar region ≤
      healingFunctional params (path tau0) g_exact I I_bar region := by
    -- Apply the telescoping inequality at (k+1) and use totalDissipation ≥ 0
    have hnn := totalDissipation_nonneg params path g_exact I I_bar region delta_tau
      (k + 1) tau0
    have hstep_pos := hflow.step_pos
    have hprod_nn : 0 ≤ delta_tau *
        totalDissipation params path g_exact I I_bar region delta_tau (k + 1) tau0 :=
      mul_nonneg (le_of_lt hstep_pos) hnn
    linarith
  have h0_le_k1 : healingFunctional params (path tau0) g_exact I I_bar region ≤
      healingFunctional params (path (tau0 + ↑(k + 1) * delta_tau))
      g_exact I I_bar region := by
    -- Use hpath_periodic (F(0) = F(n)) combined with antitonicity from k+1 to n.
    -- Apply telescoping on the SHIFTED starting point tau0 + (k+1)δτ over (n - (k+1))
    -- steps. For cleanliness, compute F(k+1) - F(n) via the full telescope:
    -- F(0) - F(n) = (F(0) - F(k+1)) + (F(k+1) - F(n))
    -- where both summands are ≥ 0 (telescoping bound + non-neg dissipation).
    -- From F(0) = F(n), we get F(0) = F(k+1).
    -- We prove: F(n) ≥ F(k+1)·(F antitone from k+1 to n)
    -- This requires a shifted telescope. Use the ORIGINAL telescope and
    -- hpath_periodic + hk1_le_0:
    -- From hk1_le_0: F(k+1) ≤ F(0). From hpath_periodic: F(0) = F(n).
    -- Also F(n) ≤ F(k+1) via shifted telescope below.
    have hshift_tel := healingFunctional_telescoping params path g_exact I I_bar
      delta_tau region hflow (tau0 + ↑(k + 1) * delta_tau) (n - (k + 1))
    have hnn_shift := totalDissipation_nonneg params path g_exact I I_bar region
      delta_tau (n - (k + 1)) (tau0 + ↑(k + 1) * delta_tau)
    have hstep_pos := hflow.step_pos
    have hprod_nn : 0 ≤ delta_tau *
        totalDissipation params path g_exact I I_bar region delta_tau
          (n - (k + 1)) (tau0 + ↑(k + 1) * delta_tau) :=
      mul_nonneg (le_of_lt hstep_pos) hnn_shift
    have hk1_le_n : (k : ℕ) + 1 ≤ n := hk
    have harith2 :
        tau0 + ↑(k + 1) * delta_tau + ↑(n - (k + 1)) * delta_tau =
        tau0 + ↑n * delta_tau := by
      have : (↑(n - (k + 1)) : ℝ) = ↑n - ↑(k + 1) := by
        rw [Nat.cast_sub hk1_le_n]
      rw [this]; ring
    rw [harith2] at hshift_tel
    -- hshift_tel : F(k+1) - F(n) ≥ δτ · total ≥ 0, so F(k+1) ≥ F(n) = F(0).
    linarith
  -- Combine hle (F(k+1) ≤ F(k)) with the matching reverse inequality.
  -- Need to reconcile ↑(k+1) vs ↑k + 1 in the statement.
  have hcast : (↑(k + 1) : ℝ) = ↑k + 1 := by push_cast; ring
  have hle' : healingFunctional params (path (tau0 + (↑k + 1) * delta_tau))
      g_exact I I_bar region ≤
      healingFunctional params (path (tau0 + ↑k * delta_tau))
      g_exact I I_bar region := by
    rw [← hcast]; exact hle
  have h0_le_k1' : healingFunctional params (path tau0) g_exact I I_bar region ≤
      healingFunctional params (path (tau0 + (↑k + 1) * delta_tau))
      g_exact I I_bar region := by
    rw [← hcast]; exact h0_le_k1
  have hk1_le_0' : healingFunctional params (path (tau0 + (↑k + 1) * delta_tau))
      g_exact I I_bar region ≤
      healingFunctional params (path tau0) g_exact I I_bar region := by
    rw [← hcast]; exact hk1_le_0
  -- Now the goal and all hypotheses are in the `↑k + 1` form.
  -- From F(k+1) ≤ F(k) (hle'), F(0) ≤ F(k+1) (h0_le_k1'), F(k+1) ≤ F(0) (hk1_le_0'),
  -- conclude F(k+1) = F(0), and since F(k+1) ≤ F(k) ≤ F(0) = F(k+1), also F(k) = F(k+1).
  -- But wait: we don't yet have F(k) ≤ F(0). Establish via antitonicity:
  have hk_le_0 : healingFunctional params (path (tau0 + ↑k * delta_tau))
      g_exact I I_bar region ≤
      healingFunctional params (path tau0) g_exact I I_bar region := by
    have htel_k := healingFunctional_telescoping params path g_exact I I_bar delta_tau
      region hflow tau0 k
    have hnn_k := totalDissipation_nonneg params path g_exact I I_bar region delta_tau
      k tau0
    have hstep_pos := hflow.step_pos
    have hprod_nn_k : 0 ≤ delta_tau *
        totalDissipation params path g_exact I I_bar region delta_tau k tau0 :=
      mul_nonneg (le_of_lt hstep_pos) hnn_k
    linarith
  linarith

/-- Every point in a discrete periodic orbit satisfies the equilibrium
    balance equation pointwise on the observation region — equivalent
    restatement of `no_nontrivial_periodic_orbits` packaged as a single
    balance-witness claim that quantifies over the whole orbit. -/
theorem every_step_satisfies_balance_on_periodic_orbit
    (params : HealingParams) (path : MetricPath)
    (g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (delta_tau : ℝ) (region : Finset LatticePoint)
    (hflow : IsLyapunovHealingFlow params path g_exact I I_bar delta_tau region)
    (tau0 : ℝ) (n : ℕ)
    (hper : IsDiscretePeriodic path delta_tau n tau0) :
    ∀ k : ℕ, k < n → ∀ p ∈ region, ∀ μ ν : Fin 4,
      params.mu * discreteLaplacian (fun q => path (tau0 + k * delta_tau) q μ ν) p =
        params.lambda * defectTensor (path (tau0 + k * delta_tau)) g_exact p μ ν +
        params.gamma * (I p - I_bar) :=
  fun k hk p hp μ ν =>
    no_nontrivial_periodic_orbits params path g_exact I I_bar delta_tau region
      hflow tau0 n hper k hk p hp μ ν

end OmegaTheory.HealingFlow
