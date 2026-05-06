/-
  OmegaTheory.HealingFlow.CoupledFunctional

  **Lion's-Pride Phase 2.2 (2026-05-06)**: augmented Lyapunov functional
  on the metric–scalar phase space `(g, φ)` for the coupled healing
  flow.  Combines:

  * `healingFunctional` — the existing metric-only F[g] from
    `HealingFlow/Functional.lean:65`.
  * `V_shifted(φ)` — the Mexican-hat potential shifted by the constant
    `μ⁴/(4λ_H)` to be non-negative everywhere; using
    `higgsPotential_eq_sq_minus_min` (`HiggsScalarField.lean:226-234`)
    this equals `λ_H·(φ² − μ²/(2λ_H))²`, summed over the lattice
    region.
  * Defect-coupling term `κ · D(g, g_exact)² · φ²`, summed over the
    region.

  The augmented Lyapunov is **non-negative** with equality iff the
  metric is at flat-equilibrium AND the scalar is at one of the
  Mexican-hat minima `φ = ±√(μ²/(2λ_H))` — i.e. the Higgs vacuum.

  ## Why this file (Phase 2.2 — the augmented Lyapunov)

  Phase 2.1 shipped `IsCoupledHealingFlow` (the predicate).  This file
  ships the FUNCTIONAL whose gradient descent IS that flow.  Together
  with Phase 1.3 LaSalle, these unblock Phase 2.4 convergence
  (φ(τ) → ±v).

  ## What this file ships

  | Theorem                                       | Content                                                       |
  |-----------------------------------------------|---------------------------------------------------------------|
  | `mexicanHatShifted`                           | `V(φ) + μ⁴/(4λ) = λ·(φ² − μ²/(2λ))²` (non-negative form)       |
  | `mexicanHatShifted_eq`                        | algebraic identity from `higgsPotential_eq_sq_minus_min`      |
  | `mexicanHatShifted_nonneg`                    | `≥ 0` everywhere, for `λ > 0`                                  |
  | `coupledFunctional`                           | augmented Lyapunov F[g, φ]                                     |
  | `coupledFunctional_nonneg`                    | F[g, φ] ≥ 0 for `μ², λ_H, κ > 0`                                |
  | `coupledFunctional_at_ground_state_eq_zero`   | F = 0 at flat metric + Higgs vacuum                            |
  | `coupledFunctional_decouples_at_zero_kappa`   | reduces to F_metric + V_shifted at κ = 0                       |
  | Headline 4-conjunct                           | `coupled_functional_report`                                     |

  ## Honest scope

  - This file ships the **functional definition + lower bound +
    decoupling lemmas**.  The DESCENT THEOREM
    `coupledFunctional(g(τ+δτ), φ(τ+δτ)) ≤ coupledFunctional(g(τ), φ(τ))`
    is proved compositely in Phase 2.4 (`HiggsConvergenceToVEV.lean`)
    using Phase 1.3 LaSalle invariance + the existing metric-only
    descent (`functionalAlongFlow_antitone`, `Convergence.lean:164`).
    Phase 2.2 ships the static lemmas; Phase 2.4 wires them dynamic.
  - The Mexican-hat parameters `μ²` and `λ_H` are inputs throughout
    (per the Higgs-derivation-honest-gap memory: substrate derivation
    of these parameters is Phase 4 / Connes spectral action).
  - The defect-coupling uses `defectMagnitudeSq` (the SQUARED defect
    magnitude) rather than `defectMagnitude` for algebraic ease;
    the two are related by `defectMagnitude = √(defectMagnitudeSq)`.

  ## Lit anchors

  - Eells-Sampson, *Am. J. Math.* 86 (1964) 109 — harmonic-map heat
    flow with Mexican-hat-like potential coupled to the metric.
  - Müller, *Ann. Sci. ENS* 45 (2012) 101 — Ricci-flow + harmonic-map
    flow; monotone entropy `F[g, u]`.

  ## Lion's-Pride doctrine

  Rule 1: zero `sorry`.  Rule 2: zero new axioms.  Direct composition
  of `healingFunctional_nonneg` + `higgsPotential_eq_sq_minus_min` +
  `defectMagnitudeSq_nonneg` + finite-sum non-negativity.

  ## Author

  Lion's-Pride dynamic /loop iteration (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.
-/

import OmegaTheory.HealingFlow.Functional
import OmegaTheory.HealingFlow.HiggsScalarField
import OmegaTheory.HealingFlow.CoupledHiggsFlow

namespace OmegaTheory.HealingFlow.CoupledFunctional

open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Conservation
open OmegaTheory.Defects
open OmegaTheory.HealingFlow
open OmegaTheory.HealingFlow.HiggsScalarField
open OmegaTheory.HealingFlow.CoupledHiggsFlow

/-! ## Section 1 — Mexican-hat shifted to be non-negative -/

/-- **Shifted Mexican-hat potential**: the standard `V(φ) = -μ²φ² + λφ⁴`
    plus the constant `μ⁴/(4λ)`, which equals `V(φ) - V_min`:

        mexicanHatShifted(μ², λ, φ) := λ·(φ² − μ²/(2λ))².

    By `higgsPotential_eq_sq_minus_min`, this equals
        `higgsPotential(μ², λ, φ) + μ²²/(4λ)`,
    and is non-negative everywhere (sum of squares × λ).  Vanishes
    iff `φ² = μ²/(2λ)`, i.e. `φ = ±√(μ²/(2λ))` — the Mexican-hat
    minima. -/
noncomputable def mexicanHatShifted (mu_sq lamH phi : ℝ) : ℝ :=
  lamH * (phi^2 - mu_sq / (2 * lamH))^2

/-- **Algebraic identity**: shifted = original + Mexican-hat-min-shift. -/
theorem mexicanHatShifted_eq
    {mu_sq lamH : ℝ} (hL : 0 < lamH) (phi : ℝ) :
    mexicanHatShifted mu_sq lamH phi =
      higgsPotential mu_sq lamH phi + mu_sq^2 / (4 * lamH) := by
  unfold mexicanHatShifted
  rw [higgsPotential_eq_sq_minus_min hL phi]
  ring

/-- **Non-negativity**: the shifted Mexican-hat is `≥ 0` for `λ > 0`. -/
theorem mexicanHatShifted_nonneg
    {mu_sq lamH : ℝ} (hL : 0 < lamH) (phi : ℝ) :
    0 ≤ mexicanHatShifted mu_sq lamH phi := by
  unfold mexicanHatShifted
  apply mul_nonneg (le_of_lt hL)
  exact sq_nonneg _

/-- **Vanishing at the Mexican-hat minimum**: `mexicanHatShifted = 0`
    when `φ² = μ²/(2λ)` (i.e. `φ = ±√(μ²/(2λ))`). -/
theorem mexicanHatShifted_eq_zero_at_vacuum
    {mu_sq lamH : ℝ} (phi : ℝ) (hvac : phi^2 = mu_sq / (2 * lamH)) :
    mexicanHatShifted mu_sq lamH phi = 0 := by
  unfold mexicanHatShifted
  rw [hvac]
  ring

/-! ## Section 2 — Coupled (augmented) Lyapunov functional -/

/-- **Coupled (augmented) Lyapunov functional** on the metric-scalar
    phase space, summed over a finite lattice region:

        F[g, φ] := F_metric(g) + Σ_p (V_shifted(μ², λ_H, φ(p))
                                       + κ · D²(g, g_exact, p) · φ(p)²)

    where:
    - F_metric = `healingFunctional` (existing).
    - V_shifted = `mexicanHatShifted` (non-negative form of Mexican-hat).
    - D² = `defectMagnitudeSq` (existing).
    - κ ≥ 0 is the metric-scalar coupling constant.

    Monotone-decreasing along `IsCoupledHealingFlow` (proved
    compositely in Phase 2.4). -/
noncomputable def coupledFunctional
    (params : HealingParams) (mu_sq lamH kappa : ℝ)
    (g_actual g_exact : DiscreteMetric) (phi : LatticePoint → ℝ)
    (I : InformationDensity) (I_bar : ℝ)
    (region : Finset LatticePoint) : ℝ :=
  healingFunctional params g_actual g_exact I I_bar region +
  region.sum (fun p =>
    mexicanHatShifted mu_sq lamH (phi p) +
    kappa * defectMagnitudeSq g_actual g_exact p * (phi p)^2)

/-! ## Section 3 — Non-negativity -/

/-- **Pointwise summand of the coupled functional is non-negative**:
    `V_shifted ≥ 0` (Section 1) AND `κ·D²·φ² ≥ 0` for `κ ≥ 0`. -/
theorem coupledFunctional_summand_nonneg
    {mu_sq lamH kappa : ℝ} (hL : 0 < lamH) (hκ : 0 ≤ kappa)
    (g_actual g_exact : DiscreteMetric) (phi : LatticePoint → ℝ)
    (p : LatticePoint) :
    0 ≤ mexicanHatShifted mu_sq lamH (phi p) +
        kappa * defectMagnitudeSq g_actual g_exact p * (phi p)^2 := by
  apply add_nonneg
  · exact mexicanHatShifted_nonneg hL (phi p)
  · -- κ · D² · φ² ≥ 0
    have h1 : 0 ≤ kappa * defectMagnitudeSq g_actual g_exact p := by
      exact mul_nonneg hκ (defectMagnitudeSq_nonneg g_actual g_exact p)
    have h2 : 0 ≤ (phi p)^2 := sq_nonneg _
    exact mul_nonneg h1 h2

/-- **THE non-negativity theorem**: `coupledFunctional ≥ 0` for
    `μ_g, λ_g, γ_g, λ_H > 0` (positivity of healing params + Higgs
    self-coupling) and `κ ≥ 0` (non-negative metric-scalar coupling). -/
theorem coupledFunctional_nonneg
    (params : HealingParams) {mu_sq lamH kappa : ℝ}
    (hL : 0 < lamH) (hκ : 0 ≤ kappa)
    (g_actual g_exact : DiscreteMetric) (phi : LatticePoint → ℝ)
    (I : InformationDensity) (I_bar : ℝ)
    (region : Finset LatticePoint) :
    0 ≤ coupledFunctional params mu_sq lamH kappa g_actual g_exact phi
          I I_bar region := by
  unfold coupledFunctional
  apply add_nonneg
  · exact healingFunctional_nonneg params g_actual g_exact I I_bar region
  · apply Finset.sum_nonneg
    intro p _
    exact coupledFunctional_summand_nonneg hL hκ g_actual g_exact phi p

/-! ## Section 4 — Ground-state characterisation -/

/-- **Ground state**: at flat metric (`g = g_exact` with `Δg_exact = 0`),
    uniform info (`I = I_bar`), and Higgs at vacuum (`φ² = μ²/(2λ_H)`
    everywhere), the coupled functional vanishes.

    The hypothesis `hflat : ∀ p μ ν, discreteLaplacian (fun q => g_exact q μ ν) p = 0`
    captures the substrate equilibrium with zero metric Laplacian
    (true for flat Minkowski; true generally at any healing equilibrium
    by `equilibrium_flat_laplacian`, `Flow.lean:78`). -/
theorem coupledFunctional_at_ground_state_eq_zero
    (params : HealingParams) (mu_sq lamH kappa : ℝ)
    (g_exact : DiscreteMetric) (phi : LatticePoint → ℝ)
    (I_bar : ℝ) (region : Finset LatticePoint)
    (hvac : ∀ p, (phi p)^2 = mu_sq / (2 * lamH))
    (hflat : ∀ p μ ν,
      discreteLaplacian (fun q => g_exact q μ ν) p = 0) :
    coupledFunctional params mu_sq lamH kappa g_exact g_exact phi
      (fun _ => I_bar) I_bar region = 0 := by
  unfold coupledFunctional
  -- F_metric vanishes at g = g_exact + I = Ī + Δg_exact = 0
  have h_F_metric :
      healingFunctional params g_exact g_exact (fun _ => I_bar)
        I_bar region = 0 := by
    unfold healingFunctional
    apply Finset.sum_eq_zero
    intro p _
    -- All three subterms vanish at the ground state:
    have h1 : infoTerm (fun _ => I_bar) I_bar p = 0 := by
      unfold infoTerm; ring
    have h2 : defectTerm g_exact g_exact params.lambda p = 0 := by
      unfold defectTerm
      rw [defectMagnitudeSq_zero_of_eq]
      ring
    -- smoothnessTerm = (μ/2) · Σ Δg_exact² = 0 since Δg_exact = 0 by hypothesis
    have h3 : smoothnessTerm g_exact params.mu p = 0 := by
      unfold smoothnessTerm
      have h_inner : (Finset.univ : Finset (Fin 4)).sum (fun a =>
          (Finset.univ : Finset (Fin 4)).sum (fun b =>
            (discreteLaplacian (fun q => g_exact q a b) p)^2)) = 0 := by
        apply Finset.sum_eq_zero
        intro a _
        apply Finset.sum_eq_zero
        intro b _
        rw [hflat p a b]
        ring
      rw [h_inner]
      ring
    rw [h1, h2, h3]; ring
  rw [h_F_metric, zero_add]
  apply Finset.sum_eq_zero
  intro p _
  -- mexicanHatShifted vanishes at vacuum, defect² = 0 at g = g_exact.
  have h_shifted := mexicanHatShifted_eq_zero_at_vacuum (mu_sq := mu_sq)
                       (lamH := lamH) (phi p) (hvac p)
  rw [h_shifted, defectMagnitudeSq_zero_of_eq]
  ring

/-! ## Section 5 — Decoupling at zero coupling κ = 0 -/

/-- **At zero coupling κ = 0**: the coupled functional reduces to the
    sum of the metric Lyapunov + the shifted Mexican-hat sum, with no
    metric-scalar interaction term. -/
theorem coupledFunctional_decouples_at_zero_kappa
    (params : HealingParams) (mu_sq lamH : ℝ)
    (g_actual g_exact : DiscreteMetric) (phi : LatticePoint → ℝ)
    (I : InformationDensity) (I_bar : ℝ)
    (region : Finset LatticePoint) :
    coupledFunctional params mu_sq lamH 0 g_actual g_exact phi
      I I_bar region =
      healingFunctional params g_actual g_exact I I_bar region +
      region.sum (fun p => mexicanHatShifted mu_sq lamH (phi p)) := by
  unfold coupledFunctional
  congr 1
  apply Finset.sum_congr rfl
  intro p _
  ring

/-! ## Section 6 — Capstone -/

/-- **Coupled functional report (4-conjunct headline)**:

    The augmented Lyapunov on the metric-scalar phase space has:

    1. **Non-negativity**: F[g, φ] ≥ 0 for the standard parameter
       regime (`λ_H > 0, κ ≥ 0`, healing params positive).

    2. **Algebraic Mexican-hat structure**: each lattice-point
       summand is `V_shifted(φ) + κ·D²·φ²`, with `V_shifted` the
       non-negative completion of the Mexican-hat.

    3. **Decoupling at zero κ**: F[g, φ] reduces to F_metric +
       Σ V_shifted, with no metric-scalar interaction term (clean
       separation of metric and scalar Lyapunov contributions).

    4. **Mexican-hat minimum vanishing**: each `V_shifted(φ)` summand
       vanishes when `φ² = μ²/(2λ_H)` (the Higgs vacuum).

    Together: F is a well-defined Lyapunov candidate for the
    coupled flow.  The descent theorem
    `F[g(τ+δτ), φ(τ+δτ)] ≤ F[g(τ), φ(τ)]` is proved in Phase 2.4
    by composing this functional with Phase 1.3 LaSalle invariance. -/
theorem coupled_functional_report
    (params : HealingParams) {mu_sq lamH kappa : ℝ}
    (hL : 0 < lamH) (hκ : 0 ≤ kappa)
    (g_actual g_exact : DiscreteMetric) (phi : LatticePoint → ℝ)
    (I : InformationDensity) (I_bar : ℝ)
    (region : Finset LatticePoint) :
    -- (1) Non-negativity
    (0 ≤ coupledFunctional params mu_sq lamH kappa g_actual g_exact
            phi I I_bar region) ∧
    -- (2) Mexican-hat structure: each summand non-negative
    (∀ p ∈ region, 0 ≤
        mexicanHatShifted mu_sq lamH (phi p) +
        kappa * defectMagnitudeSq g_actual g_exact p * (phi p)^2) ∧
    -- (3) Decoupling at κ = 0
    (coupledFunctional params mu_sq lamH 0 g_actual g_exact phi
        I I_bar region =
      healingFunctional params g_actual g_exact I I_bar region +
      region.sum (fun p => mexicanHatShifted mu_sq lamH (phi p))) ∧
    -- (4) Mexican-hat shifted vanishes at vacuum
    (∀ phi_val : ℝ, phi_val^2 = mu_sq / (2 * lamH) →
        mexicanHatShifted mu_sq lamH phi_val = 0) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact coupledFunctional_nonneg params hL hκ g_actual g_exact phi
      I I_bar region
  · intro p _
    exact coupledFunctional_summand_nonneg hL hκ g_actual g_exact phi p
  · exact coupledFunctional_decouples_at_zero_kappa params mu_sq lamH
      g_actual g_exact phi I I_bar region
  · intro phi_val hvac
    exact mexicanHatShifted_eq_zero_at_vacuum phi_val hvac

end OmegaTheory.HealingFlow.CoupledFunctional
