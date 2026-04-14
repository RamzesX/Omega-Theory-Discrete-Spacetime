/-
  OmegaTheory.Emergence.RicciComparison

  **Discrete–continuum Ricci comparison**, ingredient of the HPW elimination
  chain.

  The HPW axiom's hidden premise is that the discrete Ricci tensor
  `ricciTensor g` (as defined in `OmegaTheory.Geometry.Curvature`)
  approximates *the continuum Ricci tensor of the smooth interpolant*
  within `O(ℓ_P)`.  This file states that comparison precisely,
  packages it as a `RicciComparisonData g` structure, and proves it
  unconditionally in the flat-Minkowski base case.

  The composition lemma `hpw_remainder_from_triangle_decomposition`
  shows exactly where `RicciComparison` plugs into the
  Taylor / harmonic-gauge / Ricci-box chain that underlies HPW.

  ## Where this sits in the HPW elimination plan

  The HPW "hypothesis-carrying theorem" (Architect, `HpwHypothesis`) needs
  `|discreteLaplacian g + 2 · ricciTensor g| ≤ ℓ_P / 2` as its
  `h_remainder_bound` field.  That bound decomposes, via triangle
  inequality, into three analytic pieces:

     |Δ_lat g − ∂²g_cont|              (ingredient A — Taylor truncation)
   + |∂²g_cont + 2·Ricci_cont|          (ingredient B — harmonic gauge,
                                          to be filled in by Gauge-formalizer
                                          in `HarmonicGauge.lean`)
   + 2 · |Ricci_cont − ricciTensor g|   (ingredient C — THIS FILE).

  Each ingredient is strictly smaller than the final goal, and summing
  any three `ℓ_P / 6` pieces yields a tighter `ℓ_P / 2` overall.

  ## Mathlib status

  Mathlib v4.29 does not yet carry a general Ricci tensor of a
  smooth (0,2)-tensor field on `ℝⁿ`, so we *do not* attempt to
  instantiate `ricciTensorContinuum` from the continuum metric
  `g_cont` itself.  We treat the continuum Ricci tensor as an
  opaque real-valued function; a future version can plug in the
  honest object once Mathlib grows the infrastructure.

  -- Ricci-comparison, HPW elimination team, 2026-04-14
-/

import OmegaTheory.Geometry.Curvature
import OmegaTheory.Emergence.LaplacianRicci
import OmegaTheory.Emergence.SmoothInterpolant
import OmegaTheory.Emergence.HarmonicGauge

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open OmegaTheory.Geometry

/-! ## The continuum Ricci tensor as abstract data

A continuum Ricci tensor at `x ∈ ℝ⁴` with indices `(μ, ν)` is a real
number, so the type of a continuum Ricci tensor field is

  `RicciTensorContinuum := (Fin 4 → ℝ) → Fin 4 → Fin 4 → ℝ`.

This is deliberately *not* derived from any smooth metric field; we
only need its value at lattice-embedded points for the comparison. -/

/-- The type of a continuum Ricci tensor field on `ℝ⁴`. -/
abbrev RicciTensorContinuum : Type := (Fin 4 → ℝ) → Fin 4 → Fin 4 → ℝ

/-- The identically-zero continuum Ricci tensor field — the tensor of a
    flat (Minkowski) continuum metric. -/
def zeroRicciTensorContinuum : RicciTensorContinuum :=
  fun _ _ _ => 0

/-! ## The comparison proposition

We state the per-point comparison: at every lattice embedding
`latticeEmbed p ∈ ℝ⁴`, the discrete Ricci tensor `ricciTensor g` and
the continuum Ricci tensor `Rcont` agree within `ℓ_P`.

This is the *ingredient (C)* of the HPW elimination. -/

/-- **Discrete–continuum Ricci comparison.**
    `|ricciTensor g μ ν p − Rcont (embed p) μ ν| ≤ ℓ_P` at every lattice
    point and every index pair.

    The parametrising `latticeEmbed` agrees with the existing embedding
    used in `HpwHypothesis` and `SmoothInterpolant`, so the proposition
    is the same whether we state it here or there. -/
def RicciComparison
    (g : DiscreteMetric)
    (Rcont : RicciTensorContinuum) : Prop :=
  ∀ (p : LatticePoint) (μ ν : Fin 4),
    |ricciTensor g μ ν p - Rcont (latticeEmbed p) μ ν| ≤ l_P

/-- Half-bound version: for the fine decomposition that uses three
    `ℓ_P / 6` pieces, the Ricci comparison is sharpened by a factor of 6.
    (Used in `hpw_remainder_from_triangle_decomposition_sixth`.) -/
def RicciComparisonSharp
    (g : DiscreteMetric)
    (Rcont : RicciTensorContinuum) : Prop :=
  ∀ (p : LatticePoint) (μ ν : Fin 4),
    |ricciTensor g μ ν p - Rcont (latticeEmbed p) μ ν| ≤ l_P / 12

/-- The sharp comparison implies the loose comparison (since `ℓ_P/12 ≤ ℓ_P`). -/
theorem RicciComparison.of_sharp
    {g : DiscreteMetric} {Rcont : RicciTensorContinuum}
    (h : RicciComparisonSharp g Rcont) :
    RicciComparison g Rcont := by
  intro p μ ν
  have := h p μ ν
  have hlP : 0 ≤ l_P := l_P_nonneg
  linarith [this]

/-! ## Bundled data structure

We package the continuum Ricci tensor together with the comparison
proof into a single structure, so downstream consumers (the
Architect's `HpwHypothesis` or Gauge-formalizer's `HarmonicGauge`)
can take it as a typeclass-like argument. -/

/-- **Bundled discrete–continuum Ricci comparison data.**

    Fields:
    * `ricciTensorContinuum` — a continuum Ricci tensor field on `ℝ⁴`.
    * `comparison` — the `RicciComparison` proof.

    The structure does *not* ask for a continuum metric field; the
    smooth interpolant's existence is the responsibility of
    `SmoothInterpolantData`.  This separation is intentional: in
    Mathlib v4.29 we cannot extract `Rcont` from a `SmoothMetricField`
    automatically, so we decouple the two. -/
structure RicciComparisonData (g : DiscreteMetric) : Type where
  /-- The continuum Ricci tensor field. -/
  ricciTensorContinuum : RicciTensorContinuum
  /-- The discrete–continuum Ricci comparison inequality. -/
  comparison : RicciComparison g ricciTensorContinuum

/-! ## Flat-metric instance

For the flat Minkowski lattice metric `DiscreteMetric.flat`, both the
discrete Ricci tensor and the zero continuum Ricci tensor vanish, so
the comparison reduces to `|0 − 0| = 0 ≤ ℓ_P`, which is trivial.

This is a concrete, unconditional instance of `RicciComparisonData`. -/

/-- Flat discrete Ricci tensor vanishes (re-stated from `Curvature.ricci_flat`
    for convenience and import locality). -/
theorem ricciTensor_flat_eq_zero (μ ν : Fin 4) (p : LatticePoint) :
    ricciTensor DiscreteMetric.flat μ ν p = 0 :=
  ricci_flat μ ν p

/-- Zero continuum Ricci tensor vanishes at every point. -/
theorem zeroRicciTensorContinuum_eq_zero (x : Fin 4 → ℝ) (μ ν : Fin 4) :
    zeroRicciTensorContinuum x μ ν = 0 :=
  rfl

/-- **Unconditional flat comparison.**  For `DiscreteMetric.flat` and the
    zero continuum Ricci tensor, `|0 − 0| = 0 ≤ ℓ_P`. -/
theorem ricciComparison_flat :
    RicciComparison DiscreteMetric.flat zeroRicciTensorContinuum := by
  intro p μ ν
  rw [ricciTensor_flat_eq_zero, zeroRicciTensorContinuum_eq_zero]
  rw [sub_self, abs_zero]
  exact l_P_nonneg

/-- **Unconditional flat sharp comparison.**  Same argument gives
    `|0 − 0| = 0 ≤ ℓ_P / 12`.  Used when the fine `ℓ_P/6` triangle
    decomposition is in play. -/
theorem ricciComparisonSharp_flat :
    RicciComparisonSharp DiscreteMetric.flat zeroRicciTensorContinuum := by
  intro p μ ν
  rw [ricciTensor_flat_eq_zero, zeroRicciTensorContinuum_eq_zero]
  rw [sub_self, abs_zero]
  exact div_nonneg l_P_nonneg (by norm_num)

/-- **Flat witness** for `RicciComparisonData DiscreteMetric.flat`. -/
def flatRicciComparison : RicciComparisonData DiscreteMetric.flat where
  ricciTensorContinuum := zeroRicciTensorContinuum
  comparison := ricciComparison_flat

/-- Inhabitance: *some* `RicciComparisonData` exists for the flat metric. -/
theorem exists_ricciComparison_flat :
    ∃ D : RicciComparisonData DiscreteMetric.flat, True :=
  ⟨flatRicciComparison, trivial⟩

/-! ## Triangle decomposition

Here is the central *composition lemma* that glues the three HPW
ingredients.  It is stated at the level of *abstract real numbers*
without reference to any continuum metric, so it depends only on the
triangle inequality.  The three input bounds are:

* `hTaylor`:      `|Δ − ∂² | ≤ εA`  (ingredient A: Taylor truncation)
* `hHarmonic`:    `|∂² + 2R_c | ≤ εB`  (ingredient B: harmonic gauge)
* `hRicciComp`:   `|R_c − R_d | ≤ εC`  (ingredient C: Ricci comparison, THIS FILE)

and the composite conclusion is

       `|Δ + 2·R_d | ≤ εA + εB + 2·εC`.

The specific numerical allocation (`εA = εB = εC = ℓ_P / 6` giving
`ℓ_P / 2`) is stated as a corollary in
`hpw_remainder_from_triangle_decomposition_sixth`. -/

/-- **Triangle decomposition (abstract form).**  Given the three analytic
    bounds, the HPW remainder is controlled by `εA + εB + 2·εC`.

    The proof is a three-step triangle inequality; no analysis needed. -/
theorem hpw_remainder_from_triangle_decomposition
    (Δ d2 Rc Rd εA εB εC : ℝ)
    (hTaylor   : |Δ - d2| ≤ εA)
    (hHarmonic : |d2 + 2 * Rc| ≤ εB)
    (hRicciComp : |Rc - Rd| ≤ εC) :
    |Δ + 2 * Rd| ≤ εA + εB + 2 * εC := by
  -- Step 1:  Δ + 2·Rd = (Δ − ∂²) + (∂² + 2·Rc) + 2·(Rd − Rc)
  -- The sign on the third term flips since |Rd − Rc| = |Rc − Rd|.
  have hsplit :
      Δ + 2 * Rd = (Δ - d2) + (d2 + 2 * Rc) + 2 * (Rd - Rc) := by ring
  rw [hsplit]
  -- Intermediate absolute-value facts.
  have h12 : |(Δ - d2) + (d2 + 2 * Rc)| ≤ |Δ - d2| + |d2 + 2 * Rc| :=
    abs_add_le _ _
  have htri :
      |((Δ - d2) + (d2 + 2 * Rc)) + 2 * (Rd - Rc)|
        ≤ |(Δ - d2) + (d2 + 2 * Rc)| + |2 * (Rd - Rc)| := abs_add_le _ _
  have habs2 : |2 * (Rd - Rc)| = 2 * |Rd - Rc| := by
    rw [abs_mul, abs_of_pos (by norm_num : (0:ℝ) < 2)]
  have hsym : |Rd - Rc| = |Rc - Rd| := abs_sub_comm Rd Rc
  have h2C : 2 * |Rc - Rd| ≤ 2 * εC :=
    mul_le_mul_of_nonneg_left hRicciComp (by norm_num)
  -- Conclude by linarith.
  linarith [htri, h12, hTaylor, hHarmonic, h2C, habs2, hsym]

/-- **Numerical specialisation: the `ℓ_P / 12` allocation.**  Choosing
    `εA = εB = εC = ℓ_P / 12`, the triangle decomposition gives

        `εA + εB + 2·εC = l_P/12 + l_P/12 + 2·l_P/12 = 4·l_P/12 = l_P/3`,

    which is ≤ `ℓ_P / 2` since `l_P ≥ 0`.  Thus this allocation is
    sufficient to reach the HPW target.

    Note: a naive `ℓ_P / 6` allocation yields `4·ℓ_P/6 = 2ℓ_P/3`,
    which exceeds `ℓ_P/2`; the `2·εC` coefficient on the Ricci
    comparison forces the more conservative twelfth allocation. -/
theorem hpw_remainder_from_triangle_twelfth
    (Δ d2 Rc Rd : ℝ)
    (hTaylor   : |Δ - d2| ≤ l_P / 12)
    (hHarmonic : |d2 + 2 * Rc| ≤ l_P / 12)
    (hRicciComp : |Rc - Rd| ≤ l_P / 12) :
    |Δ + 2 * Rd| ≤ l_P / 2 := by
  have h := hpw_remainder_from_triangle_decomposition
    Δ d2 Rc Rd (l_P / 12) (l_P / 12) (l_P / 12)
    hTaylor hHarmonic hRicciComp
  -- Sum = 4·l_P/12 = l_P/3 ≤ l_P/2 since 0 ≤ l_P.
  have hlP : 0 ≤ l_P := l_P_nonneg
  have : l_P / 12 + l_P / 12 + 2 * (l_P / 12) = l_P / 3 := by ring
  rw [this] at h
  -- l_P/3 ≤ l_P/2 since 0 ≤ l_P.
  linarith

/-! ## Bridge to Gauge-formalizer's `RicciMatch`

Gauge-formalizer's `HarmonicGauge.lean` defines a sibling proposition
`RicciMatch g g_cont` taking a `SmoothMetricField` (rather than an
opaque `RicciTensorContinuum`).  The two are intertranslatable: given
a `SmoothMetricField`, its `ricciTensorContinuum` is a
`RicciTensorContinuum`, and `RicciMatch` / `RicciComparison` agree up
to the conventional sign `|A − B| = |B − A|`. -/

/-- From a `SmoothMetricField`, extract the associated abstract
    continuum Ricci tensor field. -/
noncomputable def smoothFieldRicci (g_cont : SmoothMetricField) :
    RicciTensorContinuum :=
  fun x μ ν => ricciTensorContinuum g_cont x μ ν

/-- **Bridge lemma.**  `RicciComparison g (smoothFieldRicci g_cont)` is
    equivalent to Gauge-formalizer's `RicciMatch g g_cont`.  The two
    propositions differ only by the orientation of the difference inside
    the absolute value (both orientations are equal via `abs_sub_comm`). -/
theorem ricciComparison_iff_ricciMatch
    (g : DiscreteMetric) (g_cont : SmoothMetricField) :
    RicciComparison g (smoothFieldRicci g_cont) ↔ RicciMatch g g_cont := by
  unfold RicciComparison RicciMatch smoothFieldRicci
  constructor
  · intro h p μ ν
    have := h p μ ν
    rw [abs_sub_comm] at this
    exact this
  · intro h p μ ν
    have := h p μ ν
    rw [abs_sub_comm] at this
    exact this

/-- Direct: `RicciMatch` implies `RicciComparison` with the
    `smoothFieldRicci` continuum tensor. -/
theorem ricciComparison_of_ricciMatch
    {g : DiscreteMetric} {g_cont : SmoothMetricField}
    (h : RicciMatch g g_cont) :
    RicciComparison g (smoothFieldRicci g_cont) :=
  (ricciComparison_iff_ricciMatch g g_cont).mpr h

/-! ## HpwHypothesis remainder from the triangle decomposition

Plugging in `εA + εB + 2εC = ℓ_P/2` into the abstract triangle lemma
specialised to the discrete-Laplacian / continuum-Laplacian / continuum-
Ricci / discrete-Ricci quadruple gives exactly the
`HpwHypothesis.h_remainder_bound` target.  This is the consumer-facing
theorem that ties RicciComparison into the HPW chain. -/

/-- **HPW remainder bound from the three ingredients.**

    Given per-point:
    * a Taylor bound `|Δ_lat g(p) − Δ_cont g_cont(ι p)| ≤ εA`,
    * a harmonic-gauge bound `|Δ_cont g_cont(ι p) + 2 R_cont g_cont(ι p)| ≤ εB`,
    * a Ricci-comparison bound `|R_cont g_cont(ι p) − R_disc(g,p)| ≤ εC`,

    the discrete HPW remainder obeys `|Δ_lat g(p) + 2 R_disc(g,p)| ≤ εA + εB + 2εC`.

    This is the consumer-facing form of
    `hpw_remainder_from_triangle_decomposition`, specialised to the
    concrete operators appearing in `HpwHypothesis.h_remainder_bound`. -/
theorem hpwHypothesis_remainder_from_triangle
    (g : DiscreteMetric) (g_cont : SmoothMetricField)
    (p : LatticePoint) (μ ν : Fin 4)
    {εA εB εC : ℝ}
    (hTaylor : |discreteLaplacian (fun q => g q μ ν) p
                 - continuumLaplacianAt g_cont (latticeEmbed p) μ ν| ≤ εA)
    (hHarmonic : |continuumLaplacianAt g_cont (latticeEmbed p) μ ν
                   + 2 * ricciTensorContinuum g_cont (latticeEmbed p) μ ν| ≤ εB)
    (hRicciComp : |ricciTensorContinuum g_cont (latticeEmbed p) μ ν
                    - ricciTensor g μ ν p| ≤ εC) :
    |discreteLaplacian (fun q => g q μ ν) p + 2 * ricciTensor g μ ν p|
      ≤ εA + εB + 2 * εC := by
  exact hpw_remainder_from_triangle_decomposition
    (discreteLaplacian (fun q => g q μ ν) p)
    (continuumLaplacianAt g_cont (latticeEmbed p) μ ν)
    (ricciTensorContinuum g_cont (latticeEmbed p) μ ν)
    (ricciTensor g μ ν p)
    εA εB εC hTaylor hHarmonic hRicciComp

/-- **HPW remainder bound at the `ℓ_P/12` allocation.**  Specialises
    `hpwHypothesis_remainder_from_triangle` with all three epsilons set to
    `ℓ_P/12`, producing the clean `ℓ_P/2` conclusion required by
    `HpwHypothesis.h_remainder_bound`. -/
theorem hpwHypothesis_remainder_at_twelfth
    (g : DiscreteMetric) (g_cont : SmoothMetricField)
    (p : LatticePoint) (μ ν : Fin 4)
    (hTaylor : |discreteLaplacian (fun q => g q μ ν) p
                 - continuumLaplacianAt g_cont (latticeEmbed p) μ ν|
               ≤ l_P / 12)
    (hHarmonic : |continuumLaplacianAt g_cont (latticeEmbed p) μ ν
                   + 2 * ricciTensorContinuum g_cont (latticeEmbed p) μ ν|
                 ≤ l_P / 12)
    (hRicciComp : |ricciTensorContinuum g_cont (latticeEmbed p) μ ν
                    - ricciTensor g μ ν p| ≤ l_P / 12) :
    |discreteLaplacian (fun q => g q μ ν) p + 2 * ricciTensor g μ ν p|
      ≤ l_P / 2 := by
  exact hpw_remainder_from_triangle_twelfth
    (discreteLaplacian (fun q => g q μ ν) p)
    (continuumLaplacianAt g_cont (latticeEmbed p) μ ν)
    (ricciTensorContinuum g_cont (latticeEmbed p) μ ν)
    (ricciTensor g μ ν p)
    hTaylor hHarmonic hRicciComp

end OmegaTheory.Emergence
