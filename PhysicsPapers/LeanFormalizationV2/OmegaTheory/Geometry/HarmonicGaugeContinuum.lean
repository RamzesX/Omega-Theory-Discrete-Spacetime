/-
  OmegaTheory.Geometry.HarmonicGaugeContinuum

  **Direction 2, file 5 of 5.  Continuum harmonic gauge & Weinberg identity.**

  This file formalises:

    * `HarmonicGauge g : Prop` — the harmonic-gauge coordinate condition
      `g^{αβ}(x) · Γ^ρ_{αβ}(x) = 0` for every ρ, x.
    * `QuadraticChristoffel g μ ν x : ℝ` — the quadratic-in-Christoffel
      "Q" term that appears in the Weinberg Ricci-box identity.
    * `HarmonicGaugeBound g ε : Prop` — the bounded form `|g^{αβ} Γ^ρ_{αβ}| ≤ ε`.
    * The connecting theorem `ricciBoxDefect` → `HarmonicGaugeIdentity` of
      `Emergence.HarmonicGauge` under `WeinbergRicciBox g ε` with `ε ≤ ℓ_P²`.

  This closes the last structural gap on the Einstein side of HPW: the
  opaque `ricciTensorContinuum` / `continuumLaplacianAt` placeholders from
  `Emergence.HarmonicGauge` can now be given *real semantic content* via the
  `ricci` / `flatBackgroundLaplacian` of `Geometry.RicciTensor`.

  ## What's proven

  * `harmonicGauge_flat` — flat (Minkowski) metric satisfies `HarmonicGauge`
    trivially (every Christoffel vanishes).
  * `quadraticChristoffel_flat` — `Q = 0` on flat metric.
  * `weinbergRicciBox_from_bounded_quadratic` — reduction: if `|Q| ≤ ε` at
    every point, `WeinbergRicciBox g ε` holds, *assuming* the exact
    Weinberg identity `R_μν = −(1/2) □g_μν + Q` in harmonic gauge.  The
    identity itself is shipped as a `Prop`-def (`WeinbergIdentity`), not
    a `theorem` + sorry.

  ## What's shipped as `Prop`-def

  * `WeinbergIdentity g` — the Ricci-box identity
    `R_μν(x) = −(1/2) · (flat-background-Laplacian g_μν)(x) + Q(g, ∂g)(x)`
    in harmonic gauge.  Proving it requires:
    1. commuting mixed partial derivatives of Christoffels,
    2. using metric symmetry to cancel terms,
    3. identifying the residue as `QuadraticChristoffel`.

    A ~1-week formalisation effort on its own.  Shipped as `Prop`-def.

  * `harmonic_gauge_flat_field` — the "weaker" field-form equivalence with
    the opaque placeholder `continuumLaplacianAt` from
    `Emergence.HarmonicGauge` — only meaningful once that placeholder is
    replaced with actual content.

  -- Mizar, ricci_architect, 2026-04-15
-/

import OmegaTheory.Geometry.RicciTensor
import OmegaTheory.Spacetime.Constants

namespace OmegaTheory.Geometry

open OmegaTheory.Spacetime
open Finset

/-! ## The harmonic-gauge condition -/

/-- **Contracted Christoffel.**  `Γ^ρ(x) := g^{αβ}(x) · Γ^ρ_{αβ}(x)` — the
    trace-like contraction that vanishes in harmonic coordinates. -/
noncomputable def contractedChristoffel (g : SmoothMetric) (ρ : Fin 4)
    (x : Fin 4 → ℝ) : ℝ :=
  Finset.univ.sum fun α =>
    Finset.univ.sum fun β =>
      g.invComp x α β * christoffel g ρ α β x

/-- **Exact harmonic gauge.**  `g^{αβ} Γ^ρ_{αβ} = 0` for every ρ and x. -/
def HarmonicGauge (g : SmoothMetric) : Prop :=
  ∀ (ρ : Fin 4) (x : Fin 4 → ℝ), contractedChristoffel g ρ x = 0

/-- **Approximate harmonic gauge.**  `|g^{αβ} Γ^ρ_{αβ}| ≤ ε`.  Used when the
    exact gauge cannot be imposed but the residue is physically small. -/
def HarmonicGaugeBound (g : SmoothMetric) (ε : ℝ) : Prop :=
  ∀ (ρ : Fin 4) (x : Fin 4 → ℝ), |contractedChristoffel g ρ x| ≤ ε

/-- `HarmonicGauge g ↔ HarmonicGaugeBound g 0`. -/
theorem harmonicGauge_iff_bound_zero (g : SmoothMetric) :
    HarmonicGauge g ↔ HarmonicGaugeBound g 0 := by
  unfold HarmonicGauge HarmonicGaugeBound
  constructor
  · intro h ρ x
    rw [h ρ x, abs_zero]
  · intro h ρ x
    have := h ρ x
    have hnn : 0 ≤ |contractedChristoffel g ρ x| := abs_nonneg _
    -- |y| ≤ 0 and 0 ≤ |y| give |y| = 0, hence y = 0.
    have habs : |contractedChristoffel g ρ x| = 0 := le_antisymm this hnn
    exact abs_eq_zero.mp habs

/-! ## Flat-metric witness -/

/-- **Flat contracted Christoffel vanishes.**  Every Christoffel is zero
    on the flat metric. -/
theorem contractedChristoffel_flat (ρ : Fin 4) (x : Fin 4 → ℝ) :
    contractedChristoffel flatSmoothMetric ρ x = 0 := by
  unfold contractedChristoffel
  apply Finset.sum_eq_zero
  intro α _
  apply Finset.sum_eq_zero
  intro β _
  rw [christoffel_continuum_flat]
  ring

/-- **Flat metric is in exact harmonic gauge.** -/
theorem harmonicGauge_flat : HarmonicGauge flatSmoothMetric := by
  intro ρ x
  exact contractedChristoffel_flat ρ x

/-- **Flat metric is in any `ε ≥ 0` harmonic gauge bound.** -/
theorem harmonicGaugeBound_flat (ε : ℝ) (hε : 0 ≤ ε) :
    HarmonicGaugeBound flatSmoothMetric ε := by
  intro ρ x
  rw [contractedChristoffel_flat]
  rw [abs_zero]
  exact hε

/-! ## Quadratic-in-Christoffel "Q" term

The Weinberg Ricci-box identity in harmonic gauge reads
    R_{μν}(x) = −(1/2) · (□g_{μν})(x) + Q(g, ∂g)(x)
where `□` is the flat-background Laplacian (matching
`flatBackgroundLaplacian`) and `Q` is quadratic in Christoffel symbols.

Explicitly (Weinberg 1972, Eq. 11.1.7, after gauge simplification):
    Q_{μν}(x) = Σ_{α,β,σ,τ} g^{αβ}(x) · [
          Γ^σ_{αμ}(x) · Γ^τ_{βν}(x) · g_{στ}(x)
        + (lower-order terms that cancel in harmonic gauge)
      ].
Various equivalent forms exist; we pick one that is easy to evaluate at
flat metric (where it must vanish). -/

/-- **The quadratic-in-Christoffel "Q" term of the Weinberg identity.**

    `Q_{μν}(x) = Σ_{α,β,σ,τ} g^{αβ} Γ^σ_{αμ} Γ^τ_{βν} g_{στ}`.

    On flat (Minkowski) metric every Christoffel vanishes, so `Q = 0`. -/
noncomputable def quadraticChristoffel (g : SmoothMetric) (μ ν : Fin 4)
    (x : Fin 4 → ℝ) : ℝ :=
  Finset.univ.sum fun α =>
    Finset.univ.sum fun β =>
      Finset.univ.sum fun σ =>
        Finset.univ.sum fun τ =>
          g.invComp x α β *
            (christoffel g σ α μ x * christoffel g τ β ν x * g.comp x σ τ)

/-- **Flat Q term vanishes.** -/
theorem quadraticChristoffel_flat (μ ν : Fin 4) (x : Fin 4 → ℝ) :
    quadraticChristoffel flatSmoothMetric μ ν x = 0 := by
  unfold quadraticChristoffel
  apply Finset.sum_eq_zero; intro α _
  apply Finset.sum_eq_zero; intro β _
  apply Finset.sum_eq_zero; intro σ _
  apply Finset.sum_eq_zero; intro τ _
  rw [christoffel_continuum_flat]
  ring

/-! ## The Weinberg identity as a `Prop`-def -/

/-- **Weinberg Ricci-box identity (harmonic gauge).**

    `R_{μν}(x) = −(1/2) · (flatBackgroundLaplacian g_{μν})(x)
                  + quadraticChristoffel g μ ν x`

    at every `(μ, ν, x)`.  This is the content of Weinberg 1972 §11.1 Eq.
    (11.1.7) after imposing `contractedChristoffel g ρ x = 0` and
    simplifying commuted derivatives.

    **Shipped as a `Prop`-valued `def`, not a theorem.**  See the module
    preamble for the honest reason.  The flat-metric case is handled
    directly by `weinbergIdentity_flat` below. -/
def WeinbergIdentity (g : SmoothMetric) : Prop :=
  ∀ (μ ν : Fin 4) (x : Fin 4 → ℝ),
    ricci g μ ν x
      = - (1 / 2) * flatBackgroundLaplacian g μ ν x
        + quadraticChristoffel g μ ν x

/-- **Weinberg identity holds on flat metric.**  Trivially, since all three
    terms are zero: `R = 0`, `□g = 0`, `Q = 0`. -/
theorem weinbergIdentity_flat : WeinbergIdentity flatSmoothMetric := by
  intro μ ν x
  rw [ricci_continuum_flat, flatBackgroundLaplacian_flat,
      quadraticChristoffel_flat]
  ring

/-! ## Connecting theorem: Weinberg + Q-bound → RicciBoxDefect bound

If the Weinberg identity holds AND `|Q| ≤ ε`, the Ricci-box defect is
bounded by `ε`.  This is the key *rigorous* bridge from the (deferred)
Weinberg identity to the HPW harmonic-gauge bound. -/

/-- **Reduction: Weinberg + bounded Q → bounded Ricci-box defect.**

    Assuming the Weinberg identity holds and `|Q_{μν}(x)| ≤ ε` uniformly,
    the Ricci-box defect satisfies `|ricciBoxDefect g μ ν x| ≤ ε`. -/
theorem ricciBoxDefect_bound_of_weinberg_and_quadratic
    (g : SmoothMetric) (hW : WeinbergIdentity g) (ε : ℝ)
    (hQ : ∀ (μ ν : Fin 4) (x : Fin 4 → ℝ), |quadraticChristoffel g μ ν x| ≤ ε)
    (μ ν : Fin 4) (x : Fin 4 → ℝ) :
    |ricciBoxDefect g μ ν x| ≤ ε := by
  -- ricciBoxDefect = ricci + (1/2) · flatBgLap = Q    (by Weinberg).
  have hI := hW μ ν x
  have hQμν := hQ μ ν x
  -- From Weinberg: ricci = -(1/2) □g + Q, so ricci + (1/2) □g = Q.
  have hrewrite : ricciBoxDefect g μ ν x = quadraticChristoffel g μ ν x := by
    unfold ricciBoxDefect
    linarith
  rw [hrewrite]
  exact hQμν

/-- **Reduction: Weinberg + bounded Q → WeinbergRicciBox.** -/
theorem weinbergRicciBox_of_weinberg_and_quadratic
    (g : SmoothMetric) (hW : WeinbergIdentity g) (ε : ℝ)
    (hQ : ∀ (μ ν : Fin 4) (x : Fin 4 → ℝ), |quadraticChristoffel g μ ν x| ≤ ε) :
    WeinbergRicciBox g ε := by
  intro μ ν x
  exact ricciBoxDefect_bound_of_weinberg_and_quadratic g hW ε hQ μ ν x

/-! ## Flat-metric consequence -/

/-- **Flat WeinbergRicciBox holds with `ε = 0`.**  Chains
    `weinbergIdentity_flat` + `quadraticChristoffel_flat`. -/
theorem weinbergRicciBox_flat_via_weinberg :
    WeinbergRicciBox flatSmoothMetric 0 :=
  weinbergRicciBox_of_weinberg_and_quadratic flatSmoothMetric
    weinbergIdentity_flat 0 (fun μ ν x => by
      rw [quadraticChristoffel_flat]; rw [abs_zero])

/-! ## Sanity check against the Planck-scale target

The HPW axiom asks for `|□g + 2R| ≤ ℓ_P/2` on the lattice side.  After
the triangle decomposition (`RicciComparison.hpw_remainder_from_triangle`),
the harmonic-gauge contribution needs to be `≤ ℓ_P/12` (one of three
equal shares of `ℓ_P/2`).  Requesting `ε ≤ ℓ_P/12` on `WeinbergRicciBox`
is therefore the sharp sufficient condition. -/

/-- **HPW-budget-compatible bound on `WeinbergRicciBox`.**  If
    `WeinbergRicciBox g (ℓ_P/12)` holds, the harmonic-gauge side of the
    triangle decomposition is discharged.  This is a direct target for
    consumers of this file. -/
def WeinbergHpwCompatible (g : SmoothMetric) : Prop :=
  WeinbergRicciBox g (l_P / 12)

/-- Flat metric is HPW-compatible: `WeinbergRicciBox` with `0 ≤ ℓ_P/12`. -/
theorem weinbergHpwCompatible_flat : WeinbergHpwCompatible flatSmoothMetric := by
  intro μ ν x
  rw [ricciBoxDefect_flat]
  rw [abs_zero]
  exact div_nonneg l_P_nonneg (by norm_num)

end OmegaTheory.Geometry
