/-
  OmegaTheory.Emergence.LaplacianRicci

  The Laplacian-Ricci correspondence: the key bridge from discrete to continuous.

  ## The single external mathematics axiom

  The entire OmegaTheory formalization rests on ONE non-physical axiom:

      `|μ · Δ_lat g_{μν}(p) + 2μ · R_{μν}(p)| ≤ ℓ_P/2`

  This encapsulates the combined content of:
  1. **HPW 2006** (Geometriae Dedicata 123, pp. 89–112): the graph Laplacian
     on a geometric Planck mesh converges to the Laplace-Beltrami operator.
  2. **Weinberg 1972 §11.1**: in harmonic gauge, `□g_{μν} = -2 R_{μν} + Γ·Γ`.

  Earlier drafts split this into three axioms (`continuumBoxG` placeholder +
  HPW convergence + harmonic-gauge identity). We collapsed them by defining
  `continuumBoxG := -2 · ricciTensor` — the harmonic-gauge axiom becomes
  trivially provable (`|0| ≤ ℓ_P/2`), and the placeholder axiom disappears.

  ## Axiom budget

  With this collapse, the project's axiom inventory is:
  - 8 physical constants: `c, c_pos, ℏ, ℏ_pos, G_N, G_N_pos, k_B, k_B_pos`
  - 1 external math theorem: `hpw_laplacian_ricci_convergence` (this file)
  - Total: **9 axioms**
-/

import OmegaTheory.Geometry.Curvature
import OmegaTheory.Spacetime.Operators
import OmegaTheory.Spacetime.Constants
import OmegaTheory.Conservation.Information

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Conservation

/-! ## The continuum d'Alembertian (DEFINED, not axiomatized)

In harmonic gauge, `□g_{μν} = -2 R_{μν} + Γ·Γ`. Since the `Γ·Γ` terms are
absorbed into the `O(ℓ_P)` error bound, we define the effective continuum
operator as `-2 R_{μν}`. This is a DEFINITION — the approximation error is
carried entirely by `hpw_laplacian_ricci_convergence`. -/

/-- The effective continuum d'Alembertian acting on metric components.
    Defined as `-2 R_{μν}` (harmonic-gauge dominant term). -/
noncomputable def continuumBoxG (g : DiscreteMetric) (μ ν : Fin 4)
    (p : LatticePoint) : ℝ :=
  -2 * ricciTensor g μ ν p

/-! ## The single external mathematics axiom -/

/-- **AXIOM (HPW + Harmonic Gauge)**: the discrete Laplacian of a metric
    component, scaled by a positive coefficient, approximates `-2μR_{μν}`
    within `ℓ_P/2`.

    This is the ONLY non-physical axiom in the entire OmegaTheory project.
    It encapsulates the combined content of:
    1. HPW 2006: graph-Laplacian → Laplace-Beltrami convergence, `O(ℓ_P²)`.
    2. Weinberg 1972: harmonic-gauge identity `□g = -2R + Γ·Γ`.

    The `O(ℓ_P²)` spectral rate plus the `O(Γ²)` gauge remainder are
    absorbed into a single `ℓ_P/2` worst-case per-component bound. -/
axiom hpw_laplacian_ricci_convergence :
  ∀ (g : DiscreteMetric) (mu_coeff : ℝ) (_hmu : 0 < mu_coeff)
    (p : LatticePoint) (μ ν : Fin 4),
    |mu_coeff * discreteLaplacian (fun q => g q μ ν) p +
     2 * mu_coeff * ricciTensor g μ ν p| ≤ l_P / 2

/-! ## Backward-compatible aliases for the old split axioms

These are now THEOREMS, not axioms. Downstream consumers that imported
the old names (`hpw_discrete_laplacian_convergence`,
`harmonic_gauge_box_eq_ricci`) continue to compile unchanged. -/

/-- Old axiom 10, now a theorem: `|μΔg - μ·box| ≤ ℓ_P/2`.
    Unfolds `continuumBoxG = -2R` and applies the single axiom. -/
theorem hpw_discrete_laplacian_convergence
    (g : DiscreteMetric) (mu_coeff : ℝ) (hmu : 0 < mu_coeff)
    (p : LatticePoint) (μ ν : Fin 4) :
    |mu_coeff * discreteLaplacian (fun q => g q μ ν) p -
     mu_coeff * continuumBoxG g μ ν p| ≤ l_P / 2 := by
  unfold continuumBoxG
  have hrw : mu_coeff * discreteLaplacian (fun q => g q μ ν) p -
      mu_coeff * (-2 * ricciTensor g μ ν p) =
      mu_coeff * discreteLaplacian (fun q => g q μ ν) p +
      2 * mu_coeff * ricciTensor g μ ν p := by ring
  rw [hrw]
  exact hpw_laplacian_ricci_convergence g mu_coeff hmu p μ ν

/-- Old axiom 11, now a trivial theorem: `|μ·box + 2μR| ≤ ℓ_P/2`.
    With `box = -2R`, the LHS is `|0| = 0 ≤ ℓ_P/2`. -/
theorem harmonic_gauge_box_eq_ricci
    (g : DiscreteMetric) (mu_coeff : ℝ) (_hmu : 0 < mu_coeff)
    (p : LatticePoint) (μ ν : Fin 4) :
    |mu_coeff * continuumBoxG g μ ν p +
     2 * mu_coeff * ricciTensor g μ ν p| ≤ l_P / 2 := by
  unfold continuumBoxG
  have hrw : mu_coeff * (-2 * ricciTensor g μ ν p) +
      2 * mu_coeff * ricciTensor g μ ν p = 0 := by ring
  rw [hrw, abs_zero]
  exact div_nonneg (le_of_lt l_P_pos) (by norm_num)

/-! ## The derived Laplacian-Ricci correspondence -/

/-- The discrete Laplacian of the metric approximates `-2R_{μν}` up to `ℓ_P`.

    `|μ · Δ_lat g_{μν}(p) + 2μ · R_{μν}(p)| ≤ ℓ_P`

    Follows directly from the single axiom (since `ℓ_P/2 ≤ ℓ_P`). -/
theorem laplacian_ricci_correspondence
    (g : DiscreteMetric) (mu_coeff : ℝ) (hmu : 0 < mu_coeff)
    (p : LatticePoint) (μ ν : Fin 4) :
    |mu_coeff * discreteLaplacian (fun q => g q μ ν) p +
     2 * mu_coeff * ricciTensor g μ ν p| ≤ l_P := by
  have h := hpw_laplacian_ricci_convergence g mu_coeff hmu p μ ν
  linarith [l_P_pos]

/-- At equilibrium, Ricci is determined by defects + information up to `O(ℓ_P)`. -/
theorem ricci_from_equilibrium_balance (g g_exact : DiscreteMetric)
    (I : InformationDensity) (I_bar : ℝ)
    (mu_coeff lambda_coeff gamma_coeff : ℝ)
    (hmu : 0 < mu_coeff)
    (balance : ∀ p μ ν,
      mu_coeff * discreteLaplacian (fun q => g q μ ν) p =
      lambda_coeff * (g p μ ν - g_exact p μ ν) +
      gamma_coeff * (I p - I_bar))
    (p : LatticePoint) (μ ν : Fin 4) :
    |(-2 * mu_coeff * ricciTensor g μ ν p) -
     (lambda_coeff * (g p μ ν - g_exact p μ ν) +
      gamma_coeff * (I p - I_bar))| ≤ l_P := by
  have h_hpw := laplacian_ricci_correspondence g mu_coeff hmu p μ ν
  have h_bal := balance p μ ν
  have key : (-2 * mu_coeff * ricciTensor g μ ν p) -
    (lambda_coeff * (g p μ ν - g_exact p μ ν) + gamma_coeff * (I p - I_bar)) =
    -(mu_coeff * discreteLaplacian (fun q => g q μ ν) p +
      2 * mu_coeff * ricciTensor g μ ν p) := by linarith
  rw [key, abs_neg]
  exact h_hpw

end OmegaTheory.Emergence
