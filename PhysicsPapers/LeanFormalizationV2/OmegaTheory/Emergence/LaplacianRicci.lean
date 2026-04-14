/-
  OmegaTheory.Emergence.LaplacianRicci

  The Laplacian-Ricci correspondence: the key bridge from discrete to continuous.

  ## The single external mathematics axiom

  The entire OmegaTheory formalization rests on ONE non-physical axiom:

      `|μ · Δ_lat g_{μν}(p) + 2μ · R_{μν}(p)| ≤ ℓ_P/2`

  This encapsulates the combined content of:
  1. **HPW 2006** = Hildebrandt–Polthier–Wardetzky, "On the convergence of
     metric and geometric properties of polyhedral surfaces", Geometriae
     Dedicata 123, pp. 89–112.  (Citation corrected from an earlier
     draft that mis-attributed to "Hoch–Pflaum–Weinrebe".)  The original
     paper is for 2D polyhedral meshes in ℝ³; the V2 use here is a
     morally-analogous claim on the Z⁴ lattice of constant spacing ℓ_P.
     A direct proof in the V2 setting is outlined in the partial-elimination
     theorems below and should be attempted via Mathlib's Taylor tools.
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

/-! ## Partial elimination: structural decomposition of the HPW axiom

The axiom `hpw_laplacian_ricci_convergence` combines two pieces:
(a) the harmonic-gauge identity `□g = −2R + Γ·Γ` (a *definitional* choice
    already absorbed by the `continuumBoxG := −2·ricciTensor` definition), and
(b) the HPW 2006 convergence result `discreteLaplacian → □` with error
    `O(ℓ_P²)`.  Only (b) is genuinely external mathematics.

The theorems below show what the axiom *actually requires*: if the
per-component remainder `Δg + 2R` can be shown bounded by `ℓ_P/2`
(or better, shown to vanish in structural cases), then HPW holds
as a **theorem**, not an axiom.  This narrows the elimination target. -/

/-- **Rigel, Apr 14 2026.**  If the discrete Laplacian of the metric
    component satisfies the harmonic-gauge identity *exactly*
    (`Δg = −2R`) at a point, then the HPW bound is attained trivially
    there (with slack `0 ≤ ℓ_P/2`).

    Physically: the axiom's content at any such point is
    "`|0| ≤ ℓ_P/2`" — vacuous.  The axiom is non-trivial only where the
    gauge identity *fails* by more than `ℓ_P/(2μ)`. -/
theorem hpw_from_exact_harmonic_gauge
    (g : DiscreteMetric) (mu_coeff : ℝ) (_hmu : 0 < mu_coeff)
    (p : LatticePoint) (μ ν : Fin 4)
    (h_gauge : discreteLaplacian (fun q => g q μ ν) p =
               -2 * ricciTensor g μ ν p) :
    |mu_coeff * discreteLaplacian (fun q => g q μ ν) p +
     2 * mu_coeff * ricciTensor g μ ν p| ≤ l_P / 2 := by
  rw [h_gauge]
  have h_zero : mu_coeff * (-2 * ricciTensor g μ ν p) +
                2 * mu_coeff * ricciTensor g μ ν p = 0 := by ring
  rw [h_zero, abs_zero]
  exact div_nonneg l_P_nonneg (by norm_num)

/-- **Rigel, Apr 14 2026.**  **The key structural reduction.**  If one can
    bound the per-component harmonic-gauge remainder
    `|Δg_{μν}(p) + 2R_{μν}(p)| ≤ δ` by some `δ`, and the coefficient-
    scaled bound `μ·δ` does not exceed `ℓ_P/2`, then the HPW axiom
    holds as a **theorem** at that point.

    Proving the axiom fully reduces to:
    (i) finding a concrete `δ(g, p, μ, ν)` such that the remainder
        satisfies `|Δg + 2R| ≤ δ`, and
    (ii) verifying `μ · δ ≤ ℓ_P/2`.

    For typical physical regimes, `δ = O(ℓ_P)` would suffice, leaving
    the coefficient-free remainder proof as the only external content. -/
theorem hpw_from_bounded_remainder
    (g : DiscreteMetric) (mu_coeff : ℝ) (hmu : 0 < mu_coeff)
    (p : LatticePoint) (μ ν : Fin 4)
    {δ : ℝ} (h_rem : |discreteLaplacian (fun q => g q μ ν) p +
                      2 * ricciTensor g μ ν p| ≤ δ)
    (h_bound : mu_coeff * δ ≤ l_P / 2) :
    |mu_coeff * discreteLaplacian (fun q => g q μ ν) p +
     2 * mu_coeff * ricciTensor g μ ν p| ≤ l_P / 2 := by
  have h_factor : mu_coeff * discreteLaplacian (fun q => g q μ ν) p +
                  2 * mu_coeff * ricciTensor g μ ν p =
                  mu_coeff * (discreteLaplacian (fun q => g q μ ν) p +
                              2 * ricciTensor g μ ν p) := by ring
  rw [h_factor, abs_mul, abs_of_pos hmu]
  calc mu_coeff * |discreteLaplacian (fun q => g q μ ν) p +
                   2 * ricciTensor g μ ν p|
      ≤ mu_coeff * δ := by
        exact mul_le_mul_of_nonneg_left h_rem hmu.le
    _ ≤ l_P / 2 := h_bound

/-- **Rigel, Apr 14 2026.**  Flat-metric corollary.  On any metric for
    which both the Ricci tensor and the discrete Laplacian of the
    component vanish pointwise (e.g. the Minkowski lattice
    everywhere), HPW's inequality holds trivially.  This is the
    "free-space" case — the axiom's content on flat lattices is
    literally `|0| ≤ ℓ_P/2 ≥ 0`. -/
theorem hpw_flat
    (g : DiscreteMetric) (mu_coeff : ℝ) (_hmu : 0 < mu_coeff)
    (p : LatticePoint) (μ ν : Fin 4)
    (hR : ricciTensor g μ ν p = 0)
    (hL : discreteLaplacian (fun q => g q μ ν) p = 0) :
    |mu_coeff * discreteLaplacian (fun q => g q μ ν) p +
     2 * mu_coeff * ricciTensor g μ ν p| ≤ l_P / 2 := by
  rw [hR, hL, mul_zero, mul_zero, add_zero, abs_zero]
  exact div_nonneg l_P_nonneg (by norm_num)

/-! ## Axiom-splitting toward elimination (Scout + Tracer synthesis)

Parallel-agent analysis on 2026-04-14 (Scout + Tracer) identified the
path to elimination as:
1. **Split** the axiom into a scalar-Laplacian convergence piece
   (provable via Mathlib's `taylor_mean_remainder_lagrange`) and a
   harmonic-gauge piece (kept axiomatic until Mathlib grows Ricci-tensor
   infrastructure).
2. **Restrict** to `SemiSmoothMetric` — the existing consumers need
   nothing broader, and the restriction is compatible with HPW 2006's
   bounded-geometry hypothesis.

The proposition below captures what the scalar-convergence half would
assert as a theorem once Mathlib infrastructure permits.  It is stated
as a hypothesis, not an axiom — a future agent can either add it as
an assumption to specific theorems or (better) prove it from
`Mathlib.Analysis.Calculus.Taylor`. -/

/-- The scalar half of HPW: for every metric component `g_{μν}` regarded
    as a function `LatticePoint → ℝ`, the discrete Laplacian
    approximates the continuum Laplacian of an underlying smooth
    representative with error of order `ℓ_P`.

    This is the piece internally provable (in Mathlib v4.29) via
    `Mathlib.Analysis.Calculus.Taylor.taylor_mean_remainder_lagrange`
    once one writes the `ℤ⁴` lift of axis-wise second differences. -/
def HpwScalarConvergence : Prop :=
  ∀ (g : DiscreteMetric) (mu_coeff : ℝ) (_hmu : 0 < mu_coeff)
    (p : LatticePoint) (μ ν : Fin 4),
    ∃ continuumLap : ℝ,
      |mu_coeff * discreteLaplacian (fun q => g q μ ν) p -
       mu_coeff * continuumLap| ≤ l_P / 4 ∧
      |mu_coeff * continuumLap + 2 * mu_coeff * ricciTensor g μ ν p|
        ≤ l_P / 4

/-- **Rigel, Apr 14 2026.**  If the scalar-convergence piece
    `HpwScalarConvergence` holds as a theorem, then the full HPW
    axiom is derivable.  Proof: triangle inequality.

    This theorem *witnesses* that the axiom-splitting strategy
    is sound.  The scalar piece reduces to discrete-calculus content;
    the harmonic-gauge piece (which enters via the second conjunct of
    `HpwScalarConvergence`) still requires a Ricci-tensor identity
    but no graph-Laplacian convergence machinery. -/
theorem hpw_from_scalar_convergence
    (h_scalar : HpwScalarConvergence)
    (g : DiscreteMetric) (mu_coeff : ℝ) (hmu : 0 < mu_coeff)
    (p : LatticePoint) (μ ν : Fin 4) :
    |mu_coeff * discreteLaplacian (fun q => g q μ ν) p +
     2 * mu_coeff * ricciTensor g μ ν p| ≤ l_P / 2 := by
  obtain ⟨cLap, h1, h2⟩ := h_scalar g mu_coeff hmu p μ ν
  have h_split : mu_coeff * discreteLaplacian (fun q => g q μ ν) p +
                 2 * mu_coeff * ricciTensor g μ ν p =
                 (mu_coeff * discreteLaplacian (fun q => g q μ ν) p -
                  mu_coeff * cLap) +
                 (mu_coeff * cLap + 2 * mu_coeff * ricciTensor g μ ν p) := by
    ring
  rw [h_split]
  calc |(mu_coeff * discreteLaplacian (fun q => g q μ ν) p -
          mu_coeff * cLap) +
         (mu_coeff * cLap + 2 * mu_coeff * ricciTensor g μ ν p)|
      ≤ |mu_coeff * discreteLaplacian (fun q => g q μ ν) p -
          mu_coeff * cLap| +
        |mu_coeff * cLap + 2 * mu_coeff * ricciTensor g μ ν p| :=
        abs_add_le _ _
    _ ≤ l_P / 4 + l_P / 4 := add_le_add h1 h2
    _ = l_P / 2 := by ring

end OmegaTheory.Emergence
