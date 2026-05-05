/-
  OmegaTheory.Foundations.HeatKernelMinimal

  **Minimal Seeley-DeWitt / heat-kernel infrastructure for the
  substrate-cutoff Connes spectral action.**

  This file builds the minimal *trace-level* Vassilevich algebra
  (`SpectralMoments`, `GeneralizedLaplacian`, `A4EssentialSectors`,
  `HeatKernelExpansion`) and the field-replacement helpers
  (`withGauge`, `withHiggs`, `withSpin`) used by downstream agents
  to upgrade vacuous canonical sector splits into substantive
  substrate-anchored ones.

  ## What this file provides

  * **§1 — `SpectralMoments`**: cutoff-function moments `f₀, f₂, f₄`
    carried as parameters with non-negativity + non-triviality.
  * **§2 — `GeneralizedLaplacian g`**: the abstract Δ = −∇²g + E
    record with fibre dimension and trace of the endomorphism field.
    Plus the *trace-level* Seeley-DeWitt coefficients `a_0`, `a_2`,
    `a_4` and the gravitational decomposition `a_2 = tr(E) + a_2^grav`.
  * **§3 — `A4EssentialSectors`**: 4-sector split of `a_4` into
    grav / gauge / higgs / spin, each carried as a non-negative
    structural function on `Event`. Plus `essential_a4` sum and
    canonical `zero` / `constantSectors` inhabitants.
  * **§4 — `HeatKernelExpansion`**: combined record bundling the
    above with the substrate cutoff `Λ = 1/δ_comp(N)` via the
    `Λ_eq` field and the `essentially_substrate` hypothesis tying
    the endomorphism trace to `computationalUncertainty N`.
  * **§5 — Field-replacement helpers**: `A4EssentialSectors.withGauge`,
    `.withHiggs`, `.withSpin` allow downstream consumers to upgrade
    a vacuous sector split with substantive non-negative sector
    functions (e.g., `|F|²(x) ∝ δ_comp(N)`, `V(H)(x) ∝ v(N)²`),
    without reconstructing the whole record from scratch.

  ## What this file does NOT prove

  * The full asymptotic expansion `Tr(e^{-tΔ}) ~ (4πt)^{-d/2}·Σt^k·a_k`
    itself — that is a theorem about an unbounded operator and requires
    heat-kernel machinery not in Mathlib v4.29.0.  We carry `a_k` as
    parameters, not as integrated claims.
  * The full Vassilevich `a_4` with `R_μν R^μν + R_μνρσ R^μνρσ` —
    requires bundled inverse metric not on `ErrorBoundedSmoothMetric`.
    The essential-sectors split of §3 is the structural placeholder.
  * The match of SD coefficients to SM couplings — requires RG running.

  ## Lion's-Pride 2026-05-05 cleanup

  The original Ankaa file (2026-04-17) defined five *vacuous canonical
  sector predicates* (`HasYangMills := (∀ x, 0 ≤ 0) ∧ ...` evaluated
  on a sector split where every sector is the zero function).  Those
  predicates plus the `canonical_realizes_*` machinery, the
  `minkowskiHeatKernelExpansion` inhabitant, and the
  `SpectralActionExpansion` structure that consumed them were ALL
  vacuous-canonical (BOOK_VII §8a forbidden) — deleted under the
  Lion's-Pride doctrine.  The honest minimal Vassilevich algebra
  remains.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms.
-/

import OmegaTheory.Foundations.ErrorAlgebra
import OmegaTheory.Irrationality.Uncertainty
import OmegaTheory.Geometry.ErrorBoundedSmooth
import Mathlib.Tactic

namespace OmegaTheory.Foundations.HeatKernelMinimal

open OmegaTheory.Foundations
open OmegaTheory.Irrationality
open OmegaTheory.Geometry.ErrorBoundedSmooth

/-! ## 1. Spectral moments

The cutoff function `f : ℝ → ℝ` in the spectral action `Tr(f(D²/Λ²))`
enters the asymptotic expansion only through its Mellin-transform
moments

    f₀ = ∫₀^∞ f(x) dx                     (weights the Λ⁰·a₄ term)
    f₂ = (1/1!) · ∫₀^∞ x · f(x) dx         (weights the Λ²·a₂ term)
    f₄ = (1/2!) · ∫₀^∞ x² · f(x) dx        (weights the Λ⁴·a₀ term)

We carry the moments as structural parameters — we do *not* compute
them from a concrete `f`, because that would require integration theory
not yet available in the required form.  Non-negativity is the physical
condition that `f ≥ 0`; non-triviality ensures at least one moment is
strictly positive so the spectral action is non-degenerate. -/

/-- Cutoff-function moments for the spectral action `Tr(f(D²/Λ²))`.

    Carries the three moments relevant in dimension 4:
    * `f0` weights the `f₀·a₄` term;
    * `f2` weights the `f₂·Λ²·a₂` term;
    * `f4` weights the `f₄·Λ⁴·a₀` term.

    Non-negativity of each moment is physical (the cutoff function is
    non-negative), and `nonTrivial` ensures the spectral action is not
    identically zero. -/
structure SpectralMoments where
  /-- Zeroth moment `f₀ = ∫₀^∞ f(x) dx`. -/
  f0 : ℝ
  /-- Second moment `f₂ = ∫₀^∞ x·f(x) dx`. -/
  f2 : ℝ
  /-- Fourth moment `f₄ = (1/2)·∫₀^∞ x²·f(x) dx`. -/
  f4 : ℝ
  /-- `f₀ ≥ 0` — physical non-negativity. -/
  f0_nn : 0 ≤ f0
  /-- `f₂ ≥ 0` — physical non-negativity. -/
  f2_nn : 0 ≤ f2
  /-- `f₄ ≥ 0` — physical non-negativity. -/
  f4_nn : 0 ≤ f4
  /-- Non-triviality: at least one moment is strictly positive. -/
  nonTrivial : 0 < f0 ∨ 0 < f2 ∨ 0 < f4

namespace SpectralMoments

/-- Canonical unit moments `(f₀, f₂, f₄) = (1, 1, 1)`.  The simplest
    inhabitant of `SpectralMoments` — physical cutoff functions rescale
    this. -/
noncomputable def unit : SpectralMoments where
  f0 := 1
  f2 := 1
  f4 := 1
  f0_nn := le_of_lt one_pos
  f2_nn := le_of_lt one_pos
  f4_nn := le_of_lt one_pos
  nonTrivial := Or.inl one_pos

end SpectralMoments

/-! ## 2. Generalised Laplacian

A **generalised Laplacian** on a bundle `V → M` is a second-order
operator of the form `Δ = −g^{μν}∇_μ∇_ν + E`, where `E : End(V)` is
the bundle-valued endomorphism potential.  Vassilevich's Seeley-DeWitt
coefficients `a_k(Δ)` are universal polynomials in the curvature of
`g` and the endomorphism `E`.

We work on `ErrorBoundedSmoothMetric` (Alphard's inverse-free
scaffold), so we cannot form `g^{μν}` contractions directly.  For the
sector-presence claims we only need the TRACE of `E` (all the
coefficients that appear in the SD formula are traces over the bundle,
cf. Vassilevich eqs. (3.3.3)–(3.3.5)).  So we carry the fibre
dimension (the trace of the identity on `V`) and the trace of `E` as
scalars.

This is the key simplification that makes the record structurally
inhabitable from OmegaTheory primitives: `fiberDim` is a natural
number, and `endomorphismTrace` is just a real-valued function on
events. -/

/-- Abstract generalised Laplacian on an `ErrorBoundedSmoothMetric`.

    Carries only the TRACE-level data needed for the Seeley-DeWitt
    coefficients `a_0`, `a_2`, `a_4`:
    * `fiberDim : ℕ` — dimension of the bundle on which the Laplacian
      acts (= `tr_V(Id)`).
    * `endomorphismTrace : Event → ℝ` — the scalar function
      `tr_V(E) : Event → ℝ`. -/
structure GeneralizedLaplacian (g : ErrorBoundedSmoothMetric) where
  /-- Fibre dimension of the bundle on which the Laplacian acts. -/
  fiberDim : ℕ
  /-- Positivity of the fibre dimension. -/
  fiberDim_pos : 0 < fiberDim
  /-- Trace of the endomorphism field, `E : Event → ℝ`. -/
  endomorphismTrace : Event → ℝ

namespace GeneralizedLaplacian

variable {g : ErrorBoundedSmoothMetric}

/-- The Seeley-DeWitt coefficient `a_0(x) = tr_V(Id) = fiberDim`.

    Vassilevich eq. (3.3.3): `a_0(Δ) = (4π)^{-d/2}·∫·tr_V(Id)·√g d^dx`.
    At the pointwise scalar level, `a_0 = fiberDim` is the constant
    function. -/
noncomputable def a0 (Δ : GeneralizedLaplacian g) (_x : Event) : ℝ :=
  (Δ.fiberDim : ℝ)

/-- `a_0(x) > 0` for any generalised Laplacian (fiberDim is a positive
    natural). -/
theorem a0_pos (Δ : GeneralizedLaplacian g) (x : Event) : 0 < Δ.a0 x := by
  unfold a0
  exact_mod_cast Δ.fiberDim_pos

/-- `a_0(x) ≥ 0` for any generalised Laplacian. -/
theorem a0_nonneg (Δ : GeneralizedLaplacian g) (x : Event) : 0 ≤ Δ.a0 x :=
  le_of_lt (Δ.a0_pos x)

/-- The Seeley-DeWitt coefficient `a_2(x) = tr(E)(x) + (R(x)/6)·fiberDim`.

    Vassilevich eq. (3.3.4): `a_2(Δ) = (4π)^{-d/2}·∫[tr_V(E) +
    (R/6)·tr_V(Id)]·√g d^dx`.  The `R/6` factor is the universal
    Gilkey coefficient. -/
noncomputable def a2 (Δ : GeneralizedLaplacian g) (x : Event) : ℝ :=
  Δ.endomorphismTrace x
    + smoothScalarCurvatureEB g x / 6 * (Δ.fiberDim : ℝ)

/-- The gravitational piece of `a_2(x)`: `(R(x)/6)·fiberDim`.  This is
    the Einstein-Hilbert coefficient before multiplication by `f₂·Λ²`
    in the spectral action. -/
noncomputable def a2_grav (Δ : GeneralizedLaplacian g) (x : Event) : ℝ :=
  smoothScalarCurvatureEB g x / 6 * (Δ.fiberDim : ℝ)

/-- Vassilevich decomposition: `a_2 = tr(E) + a_2^grav`. -/
theorem a2_eq_trE_plus_grav (Δ : GeneralizedLaplacian g) (x : Event) :
    Δ.a2 x = Δ.endomorphismTrace x + Δ.a2_grav x := rfl

/-- Simplified Seeley-DeWitt coefficient `a_4(x)` at the trace level,
    using only the terms computable from `smoothScalarCurvatureEB` and
    `tr(E)`.

    The full Vassilevich formula (eq. (3.3.5)) also contains
    `R_μν R^μν` and `R_μνρσ R^μνρσ` which require bundled inverse
    metric contractions unavailable on `ErrorBoundedSmoothMetric`.  We
    carry only the `5R² + 60·R·tr(E) + 180·tr(E)²` trace-level piece.

    The omitted terms are captured by the essential-sectors split of
    §3 (`A4EssentialSectors`), which carries each SM sector as a
    structural non-negative function. -/
noncomputable def a4 (Δ : GeneralizedLaplacian g) (x : Event) : ℝ :=
  ( 5 * (smoothScalarCurvatureEB g x)^2 * (Δ.fiberDim : ℝ)
  + 60 * smoothScalarCurvatureEB g x * Δ.endomorphismTrace x
  + 180 * (Δ.endomorphismTrace x)^2
  ) / 360

end GeneralizedLaplacian

/-! ## 3. Essential-sectors split of `a_4`

Full Vassilevich `a_4` needs `R_μν R^μν`, `R_μνρσ R^μνρσ`, `□R`, `□E`
— none of which are available on `ErrorBoundedSmoothMetric`.  Instead
we **split `a_4` by physical sector** and carry each as a structural
non-negative function on events:

* `grav_sector`   — scalar-curvature contribution
* `gauge_sector`  — Yang-Mills `|F|²` piece
* `higgs_sector`  — Higgs potential `V(H)` + kinetic `|DH|²`
* `spin_sector`   — fermion kinetic `ψ̄D̸ψ` piece

Each sector is non-negative by design (structural field).  Summing
gives "the essential `a_4`".  This is NOT claimed equal to Vassilevich's
full `a_4` — it's a structural decomposition useful for stating
sector-presence. -/

/-- Essential-sector decomposition of the Seeley-DeWitt coefficient
    `a_4`.

    The four sectors correspond to the four SM Lagrangian pieces
    derived from Lichnerowicz `E = R/4 + F·γγ + |H|²·stuff + fermion
    couplings`.  Each is carried as a structural non-negative function;
    the total "essential a_4" is the sum. -/
structure A4EssentialSectors (g : ErrorBoundedSmoothMetric)
    (Δ : GeneralizedLaplacian g) where
  grav_sector : Event → ℝ
  gauge_sector : Event → ℝ
  higgs_sector : Event → ℝ
  spin_sector : Event → ℝ
  grav_nn : ∀ x, 0 ≤ grav_sector x
  gauge_nn : ∀ x, 0 ≤ gauge_sector x
  higgs_nn : ∀ x, 0 ≤ higgs_sector x
  spin_nn : ∀ x, 0 ≤ spin_sector x

namespace A4EssentialSectors

variable {g : ErrorBoundedSmoothMetric} {Δ : GeneralizedLaplacian g}

/-- The essential `a_4(x)` = sum of the four sectors. -/
noncomputable def essential_a4 (s : A4EssentialSectors g Δ) (x : Event) : ℝ :=
  s.grav_sector x + s.gauge_sector x + s.higgs_sector x + s.spin_sector x

/-- `essential_a4(x) ≥ 0`: sum of non-negatives. -/
theorem essential_a4_nonneg (s : A4EssentialSectors g Δ) (x : Event) :
    0 ≤ s.essential_a4 x := by
  unfold essential_a4
  have h₁ := s.grav_nn x
  have h₂ := s.gauge_nn x
  have h₃ := s.higgs_nn x
  have h₄ := s.spin_nn x
  linarith

/-- The canonical trivial sector split: all four sectors identically
    zero.  Satisfies all non-negativity constraints vacuously.  Useful
    as a default base for the field-replacement helpers of §5. -/
noncomputable def zero (g : ErrorBoundedSmoothMetric)
    (Δ : GeneralizedLaplacian g) : A4EssentialSectors g Δ where
  grav_sector := fun _ => 0
  gauge_sector := fun _ => 0
  higgs_sector := fun _ => 0
  spin_sector := fun _ => 0
  grav_nn := fun _ => le_refl 0
  gauge_nn := fun _ => le_refl 0
  higgs_nn := fun _ => le_refl 0
  spin_nn := fun _ => le_refl 0

/-- The canonical constant-per-sector split from a fixed non-negative
    real `c`: every sector is the constant function `c`. -/
noncomputable def constantSectors (g : ErrorBoundedSmoothMetric)
    (Δ : GeneralizedLaplacian g) (c : ℝ) (hc : 0 ≤ c) :
    A4EssentialSectors g Δ where
  grav_sector := fun _ => c
  gauge_sector := fun _ => c
  higgs_sector := fun _ => c
  spin_sector := fun _ => c
  grav_nn := fun _ => hc
  gauge_nn := fun _ => hc
  higgs_nn := fun _ => hc
  spin_nn := fun _ => hc

end A4EssentialSectors

/-! ## 4. Heat-kernel expansion at the substrate cutoff

The combined record bundling:
* a generalised Laplacian `Δ`;
* its essential-sector split `a4Sectors`;
* the cutoff-function moments;
* the cutoff `Λ = 1/δ_comp(N)`;
* the **essentially_substrate** hypothesis tying the endomorphism to
  the substrate's `computationalUncertainty`.

The `essentially_substrate` field is the critical rule-3 ingredient:
it forces the endomorphism trace to be anchored to
`computationalUncertainty N` at at least one event. -/

/-- Heat-kernel expansion data at the substrate cutoff `Λ = 1/δ_comp(N)`. -/
structure HeatKernelExpansion (g : ErrorBoundedSmoothMetric) (N : ℕ) where
  Δ : GeneralizedLaplacian g
  a4Sectors : A4EssentialSectors g Δ
  moments : SpectralMoments
  Λ : ℝ
  /-- The cutoff is exactly the inverse substrate uncertainty. -/
  Λ_eq : Λ = 1 / computationalUncertainty N
  Λ_pos : 0 < Λ
  /-- **Substrate-essential hypothesis**: at at least one event, the
      endomorphism trace is anchored to `computationalUncertainty N`. -/
  essentially_substrate : ∃ x : Event,
    Δ.endomorphismTrace x = computationalUncertainty N

namespace HeatKernelExpansion

variable {g : ErrorBoundedSmoothMetric} {N : ℕ}

/-- `Λ⁴ > 0`. -/
theorem Λ_pow_four_pos (H : HeatKernelExpansion g N) : 0 < H.Λ ^ 4 :=
  pow_pos H.Λ_pos 4

/-- `Λ² > 0`. -/
theorem Λ_pow_two_pos (H : HeatKernelExpansion g N) : 0 < H.Λ ^ 2 :=
  pow_pos H.Λ_pos 2

/-- `Λ⁴ ≥ 0`. -/
theorem Λ_pow_four_nonneg (H : HeatKernelExpansion g N) : 0 ≤ H.Λ ^ 4 :=
  le_of_lt H.Λ_pow_four_pos

/-- `Λ² ≥ 0`. -/
theorem Λ_pow_two_nonneg (H : HeatKernelExpansion g N) : 0 ≤ H.Λ ^ 2 :=
  le_of_lt H.Λ_pow_two_pos

end HeatKernelExpansion

/-! ## 5. Field-replacement helpers (`withGauge` / `withHiggs` / `withSpin`)

These helpers allow downstream consumers to UPGRADE the vacuous
`A4EssentialSectors.zero` base witness with **substantive**
non-zero sector functions, without needing to construct a full
`A4EssentialSectors` from scratch.

Pattern: given an existing sector split `s` and a new non-negative
function `σ : Event → ℝ`, produce a new `A4EssentialSectors` equal
to `s` except with the chosen sector replaced by `σ`.

Substantive substrate sources for these slots are:
* `gauge`: `|F|²(x) ∝ δ_comp(N)` (substrate gauge curvature)
* `higgs`: `V(H)(x) ∝ (higgs_vev N)²` (Higgs potential at minimum)
* `spin`: `ψ̄D̸ψ` indicator (Dirac kinetic presence)

Once the substrate field theory matures, these wires become the
substantive non-negative inputs to a non-vacuous spectral-action
sector accounting. -/

namespace A4EssentialSectors

variable {g : ErrorBoundedSmoothMetric} {Δ : GeneralizedLaplacian g}

/-- Replace the `gauge_sector` of an existing sector split with a new
    non-negative function. -/
noncomputable def withGauge (s : A4EssentialSectors g Δ)
    (F2 : Event → ℝ) (hF2 : ∀ x, 0 ≤ F2 x) : A4EssentialSectors g Δ where
  grav_sector := s.grav_sector
  gauge_sector := F2
  higgs_sector := s.higgs_sector
  spin_sector := s.spin_sector
  grav_nn := s.grav_nn
  gauge_nn := hF2
  higgs_nn := s.higgs_nn
  spin_nn := s.spin_nn

/-- Replace the `higgs_sector` of an existing sector split with a new
    non-negative function. -/
noncomputable def withHiggs (s : A4EssentialSectors g Δ)
    (V : Event → ℝ) (hV : ∀ x, 0 ≤ V x) : A4EssentialSectors g Δ where
  grav_sector := s.grav_sector
  gauge_sector := s.gauge_sector
  higgs_sector := V
  spin_sector := s.spin_sector
  grav_nn := s.grav_nn
  gauge_nn := s.gauge_nn
  higgs_nn := hV
  spin_nn := s.spin_nn

/-- Replace the `spin_sector` of an existing sector split with a new
    non-negative function. -/
noncomputable def withSpin (s : A4EssentialSectors g Δ)
    (K : Event → ℝ) (hK : ∀ x, 0 ≤ K x) : A4EssentialSectors g Δ where
  grav_sector := s.grav_sector
  gauge_sector := s.gauge_sector
  higgs_sector := s.higgs_sector
  spin_sector := K
  grav_nn := s.grav_nn
  gauge_nn := s.gauge_nn
  higgs_nn := s.higgs_nn
  spin_nn := hK

/-- `withGauge` preserves the gauge sector's new function at every event. -/
theorem withGauge_gauge (s : A4EssentialSectors g Δ)
    (F2 : Event → ℝ) (hF2 : ∀ x, 0 ≤ F2 x) (x : Event) :
    (s.withGauge F2 hF2).gauge_sector x = F2 x := rfl

/-- `withHiggs` preserves the higgs sector's new function at every event. -/
theorem withHiggs_higgs (s : A4EssentialSectors g Δ)
    (V : Event → ℝ) (hV : ∀ x, 0 ≤ V x) (x : Event) :
    (s.withHiggs V hV).higgs_sector x = V x := rfl

/-- `withSpin` preserves the spin sector's new function at every event. -/
theorem withSpin_spin (s : A4EssentialSectors g Δ)
    (K : Event → ℝ) (hK : ∀ x, 0 ≤ K x) (x : Event) :
    (s.withSpin K hK).spin_sector x = K x := rfl

end A4EssentialSectors

end OmegaTheory.Foundations.HeatKernelMinimal
