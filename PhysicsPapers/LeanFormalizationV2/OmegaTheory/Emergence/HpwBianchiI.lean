/-
  OmegaTheory.Emergence.HpwBianchiI

  **Hypothesis-carrying HPW bridge for the Bianchi type I
  anisotropic cosmological metric.**

  The Bianchi I metric is the fifth concrete regime in the HPW axiom
  elimination programme, after flat Minkowski (`HpwMinkowski.lean`),
  linearised gravity (`HpwLinearised.lean`), static spherically-symmetric
  vacuum (`HpwSchwarzschild.lean`), and spatially-flat FRW
  (`HpwFRW.lean`).  It is the first *anisotropic* metric in the programme.

  ## Physical setting

  The Bianchi type I line element is
      `ds² = −dt² + a₁(t)²dx₁² + a₂(t)²dx₂² + a₃(t)²dx₃²`.
  Unlike FRW, the three directional scale factors `a₁, a₂, a₃` are
  independent — the spatial expansion may differ along each axis.  FRW
  is the special case `a₁ = a₂ = a₃`.

  On the ℤ⁴ lattice, the time coordinate of a lattice point `p` is
  `p 0 : ℤ`, and the discrete scale factors `aᵢ : ℤ → ℝ` give
      `g(p) = diag(−1, a₁(p₀)², a₂(p₀)², a₃(p₀)²)`.

  The continuum Ricci tensor for Bianchi I is:
      `R₀₀ = −(ä₁/a₁ + ä₂/a₂ + ä₃/a₃)`,
      `Rᵢᵢ = aᵢ·äᵢ + aᵢ·ȧᵢ·Σⱼ(ȧⱼ/aⱼ)`.

  ## Architecture — two halves (mirroring HpwFRW.lean)

  **First half (definitions):**

  1. `bianchiIMetricTensor` — the diagonal Bianchi I 4×4 matrix for
     given `a₁, a₂, a₃`.
  2. `DiscreteMetric.bianchiI` — the discrete metric on the lattice.
  3. `bianchiISmoothField` — smooth continuum metric field from three
     smooth scale factors.
  4. `BianchiIScaleFactorData` — master bundle: three discrete scale
     factors, three smooth interpolants, agreement on lattice, C⁴
     smoothness, positivity, fourth-derivative bounds.

  **Second half (hypothesis discharge):**

  5. `BianchiIHpwData` — hypothesis bundle carrying the three sharp
     `ℓ_P/12` bounds.
  6. `HpwHypothesis_of_bianchiI` — witness constructor.
  7. Axiom-free corollaries.

  ## No axioms, no sorries

  Everything below is derived from existing infrastructure.  Zero
  additional axioms, zero sorry.

  -- Canopus, HPW elimination wave-6, 2026-04-15
-/

import OmegaTheory.Emergence.HpwHypothesis
import OmegaTheory.Emergence.SmoothInterpolant
import OmegaTheory.Emergence.HarmonicGauge
import OmegaTheory.Emergence.RicciComparison
import OmegaTheory.Emergence.HpwFRW

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open OmegaTheory.Geometry

/-! ## Part 1 — Bianchi I discrete metric (Canopus)

A Bianchi type I metric in coordinates `(t, x₁, x₂, x₃)` has line element
    `ds² = −dt² + a₁(t)²dx₁² + a₂(t)²dx₂² + a₃(t)²dx₃²`.
On the ℤ⁴ lattice, the time coordinate of a lattice point `p` is `p 0`,
and the discrete scale factors are `a₁, a₂, a₃ : ℤ → ℝ`.  The metric
tensor at `p` is the diagonal matrix
    `diag(−1, a₁(p₀)², a₂(p₀)², a₃(p₀)²)`. -/

/-- The Bianchi I metric tensor at a point with scale factor values
    `a₁_n, a₂_n, a₃_n`.
    Returns `diag(−1, a₁_n², a₂_n², a₃_n²)`. -/
noncomputable def bianchiIMetricTensor (a₁_n a₂_n a₃_n : ℝ) : MetricTensor :=
  Matrix.diagonal ![(-1 : ℝ), a₁_n ^ 2, a₂_n ^ 2, a₃_n ^ 2]

/-- The discrete Bianchi I metric: at each lattice point `p`, the metric is
    `diag(−1, a₁(p₀)², a₂(p₀)², a₃(p₀)²)` where `p₀ = p 0`. -/
noncomputable def DiscreteMetric.bianchiI
    (a₁ a₂ a₃ : ℤ → ℝ) : DiscreteMetric :=
  fun p => bianchiIMetricTensor (a₁ (p 0)) (a₂ (p 0)) (a₃ (p 0))

/-- Off-diagonal entries of the Bianchi I tensor vanish. -/
theorem bianchiIMetricTensor_diagonal (a₁_n a₂_n a₃_n : ℝ)
    (i j : Fin 4) (h : i ≠ j) :
    bianchiIMetricTensor a₁_n a₂_n a₃_n i j = 0 := by
  simp [bianchiIMetricTensor, h]

/-- The (0,0) component of the Bianchi I tensor is always `−1`. -/
theorem bianchiIMetricTensor_00 (a₁_n a₂_n a₃_n : ℝ) :
    bianchiIMetricTensor a₁_n a₂_n a₃_n 0 0 = -1 := by
  simp [bianchiIMetricTensor]

/-- The (1,1) component of the Bianchi I tensor is `a₁_n²`. -/
theorem bianchiIMetricTensor_11 (a₁_n a₂_n a₃_n : ℝ) :
    bianchiIMetricTensor a₁_n a₂_n a₃_n 1 1 = a₁_n ^ 2 := by
  simp [bianchiIMetricTensor]

/-- The (2,2) component of the Bianchi I tensor is `a₂_n²`. -/
theorem bianchiIMetricTensor_22 (a₁_n a₂_n a₃_n : ℝ) :
    bianchiIMetricTensor a₁_n a₂_n a₃_n 2 2 = a₂_n ^ 2 := by
  simp [bianchiIMetricTensor]

/-- The (3,3) component of the Bianchi I tensor is `a₃_n²`. -/
theorem bianchiIMetricTensor_33 (a₁_n a₂_n a₃_n : ℝ) :
    bianchiIMetricTensor a₁_n a₂_n a₃_n 3 3 = a₃_n ^ 2 := by
  simp [bianchiIMetricTensor]

/-! ## Part 2 — Bianchi I smooth continuum field (Canopus)

Given three smooth interpolants `a₁_cont, a₂_cont, a₃_cont : ℝ → ℝ` of the
discrete scale factors, the continuum Bianchi I metric field is
    `g_cont(x)₀₀ = −1`,
    `g_cont(x)₁₁ = a₁_cont(x₀)²`,
    `g_cont(x)₂₂ = a₂_cont(x₀)²`,
    `g_cont(x)₃₃ = a₃_cont(x₀)²`,
    `g_cont(x)_{μν} = 0`  for `μ ≠ ν`. -/

/-- The smooth continuum Bianchi I metric field, parametrised by three
    smooth interpolants of the scale factors.

    `bianchiISmoothField a₁_cont a₂_cont a₃_cont x μ ν` returns the
    `(μ,ν)` component of
    `diag(−1, a₁_cont(x₀)², a₂_cont(x₀)², a₃_cont(x₀)²)`. -/
noncomputable def bianchiISmoothField
    (a₁_cont a₂_cont a₃_cont : ℝ → ℝ) : SmoothMetricField :=
  fun x μ ν =>
    bianchiIMetricTensor (a₁_cont (x 0)) (a₂_cont (x 0)) (a₃_cont (x 0)) μ ν

/-- Component identity: `bianchiISmoothField` at `x` is the Bianchi I
    tensor with scale factors `a₁_cont(x₀), a₂_cont(x₀), a₃_cont(x₀)`. -/
theorem bianchiISmoothField_eq
    (a₁_cont a₂_cont a₃_cont : ℝ → ℝ) (x : Fin 4 → ℝ) (μ ν : Fin 4) :
    bianchiISmoothField a₁_cont a₂_cont a₃_cont x μ ν =
      bianchiIMetricTensor (a₁_cont (x 0)) (a₂_cont (x 0)) (a₃_cont (x 0)) μ ν :=
  rfl

/-! ## Part 3 — Bianchi I scale-factor data bundle (Canopus)

`BianchiIScaleFactorData` is the master input structure carrying three
discrete scale factors, their smooth interpolants, and the analytic data
required to produce a continuum metric field and an interpolation identity.
It does NOT carry the three sharp HPW bounds — those live in
`BianchiIHpwData` below. -/

/-- **Bianchi I scale-factor data bundle.**

    Carries the data required to construct a discrete Bianchi I metric and
    its smooth continuum interpolant.

    Fields:
    * `a₁, a₂, a₃`            — the three discrete scale factors `ℤ → ℝ`.
    * `a₁_cont, a₂_cont, a₃_cont` — smooth (`C⁴`) interpolants `ℝ → ℝ`.
    * `h_agree₁, h_agree₂, h_agree₃` — lattice agreement for each.
    * `h_smooth₁, h_smooth₂, h_smooth₃` — each interpolant is `ContDiff ℝ 4`.
    * `h_pos₁, h_pos₂, h_pos₃` — each discrete scale factor is strictly positive.
    * `M₄`           — a uniform bound on the fourth derivatives.
    * `M₄_nonneg`    — `0 ≤ M₄`.
    * `h_c4_bound₁, h_c4_bound₂, h_c4_bound₃`
                     — `‖iteratedFDeriv ℝ 4 aᵢ_cont t‖ ≤ M₄` for all `t`. -/
structure BianchiIScaleFactorData : Type where
  /-- The first discrete scale factor. -/
  a₁ : ℤ → ℝ
  /-- The second discrete scale factor. -/
  a₂ : ℤ → ℝ
  /-- The third discrete scale factor. -/
  a₃ : ℤ → ℝ
  /-- The smooth continuum interpolant of the first scale factor. -/
  a₁_cont : ℝ → ℝ
  /-- The smooth continuum interpolant of the second scale factor. -/
  a₂_cont : ℝ → ℝ
  /-- The smooth continuum interpolant of the third scale factor. -/
  a₃_cont : ℝ → ℝ
  /-- Lattice agreement for the first scale factor. -/
  h_agree₁ : ∀ n : ℤ, a₁_cont (l_P * ↑n) = a₁ n
  /-- Lattice agreement for the second scale factor. -/
  h_agree₂ : ∀ n : ℤ, a₂_cont (l_P * ↑n) = a₂ n
  /-- Lattice agreement for the third scale factor. -/
  h_agree₃ : ∀ n : ℤ, a₃_cont (l_P * ↑n) = a₃ n
  /-- The first interpolant is C⁴. -/
  h_smooth₁ : ContDiff ℝ 4 a₁_cont
  /-- The second interpolant is C⁴. -/
  h_smooth₂ : ContDiff ℝ 4 a₂_cont
  /-- The third interpolant is C⁴. -/
  h_smooth₃ : ContDiff ℝ 4 a₃_cont
  /-- The first discrete scale factor is strictly positive. -/
  h_pos₁ : ∀ n : ℤ, 0 < a₁ n
  /-- The second discrete scale factor is strictly positive. -/
  h_pos₂ : ∀ n : ℤ, 0 < a₂ n
  /-- The third discrete scale factor is strictly positive. -/
  h_pos₃ : ∀ n : ℤ, 0 < a₃ n
  /-- Uniform bound on the fourth derivatives. -/
  M₄ : ℝ
  /-- The bound is nonneg. -/
  M₄_nonneg : 0 ≤ M₄
  /-- Fourth derivative of first interpolant is bounded. -/
  h_c4_bound₁ : ∀ t : ℝ, ‖iteratedFDeriv ℝ 4 a₁_cont t‖ ≤ M₄
  /-- Fourth derivative of second interpolant is bounded. -/
  h_c4_bound₂ : ∀ t : ℝ, ‖iteratedFDeriv ℝ 4 a₂_cont t‖ ≤ M₄
  /-- Fourth derivative of third interpolant is bounded. -/
  h_c4_bound₃ : ∀ t : ℝ, ‖iteratedFDeriv ℝ 4 a₃_cont t‖ ≤ M₄

/-! ## Extractors from `BianchiIScaleFactorData` -/

/-- Extract the discrete Bianchi I metric from the scale-factor bundle. -/
noncomputable def BianchiIScaleFactorData.toDiscreteMetric
    (D : BianchiIScaleFactorData) : DiscreteMetric :=
  DiscreteMetric.bianchiI D.a₁ D.a₂ D.a₃

/-- Extract the smooth continuum metric field from the scale-factor bundle. -/
noncomputable def BianchiIScaleFactorData.toSmoothMetricField
    (D : BianchiIScaleFactorData) : SmoothMetricField :=
  bianchiISmoothField D.a₁_cont D.a₂_cont D.a₃_cont

/-- The smooth continuum scale factors at a lattice-embedded time coordinate
    agree with the discrete scale factors. -/
theorem BianchiIScaleFactorData.a₁_cont_at_lattice
    (D : BianchiIScaleFactorData) (p : LatticePoint) :
    D.a₁_cont (l_P * ↑(p 0)) = D.a₁ (p 0) :=
  D.h_agree₁ (p 0)

theorem BianchiIScaleFactorData.a₂_cont_at_lattice
    (D : BianchiIScaleFactorData) (p : LatticePoint) :
    D.a₂_cont (l_P * ↑(p 0)) = D.a₂ (p 0) :=
  D.h_agree₂ (p 0)

theorem BianchiIScaleFactorData.a₃_cont_at_lattice
    (D : BianchiIScaleFactorData) (p : LatticePoint) :
    D.a₃_cont (l_P * ↑(p 0)) = D.a₃ (p 0) :=
  D.h_agree₃ (p 0)

/-- **Interpolation identity.**  The smooth Bianchi I field agrees with the
    discrete Bianchi I metric at every lattice point. -/
theorem BianchiIScaleFactorData.interpolates (D : BianchiIScaleFactorData)
    (p : LatticePoint) (μ ν : Fin 4) :
    (D.toDiscreteMetric p) μ ν =
      D.toSmoothMetricField (latticeEmbed p) μ ν := by
  unfold BianchiIScaleFactorData.toDiscreteMetric
    BianchiIScaleFactorData.toSmoothMetricField
  unfold DiscreteMetric.bianchiI bianchiISmoothField
  simp only [bianchiIMetricTensor]
  rw [latticeEmbed_zero,
      D.a₁_cont_at_lattice p, D.a₂_cont_at_lattice p,
      D.a₃_cont_at_lattice p]

/-! ## Positivity lemmas -/

/-- The square of the first positive scale factor is positive. -/
theorem BianchiIScaleFactorData.a₁_sq_pos
    (D : BianchiIScaleFactorData) (n : ℤ) :
    0 < D.a₁ n ^ 2 :=
  sq_pos_of_pos (D.h_pos₁ n)

/-- The square of the second positive scale factor is positive. -/
theorem BianchiIScaleFactorData.a₂_sq_pos
    (D : BianchiIScaleFactorData) (n : ℤ) :
    0 < D.a₂ n ^ 2 :=
  sq_pos_of_pos (D.h_pos₂ n)

/-- The square of the third positive scale factor is positive. -/
theorem BianchiIScaleFactorData.a₃_sq_pos
    (D : BianchiIScaleFactorData) (n : ℤ) :
    0 < D.a₃ n ^ 2 :=
  sq_pos_of_pos (D.h_pos₃ n)

/-- The (0,0) component of the discrete Bianchi I metric is always `−1`. -/
theorem BianchiIScaleFactorData.metric_00
    (D : BianchiIScaleFactorData) (p : LatticePoint) :
    D.toDiscreteMetric p 0 0 = -1 := by
  unfold BianchiIScaleFactorData.toDiscreteMetric DiscreteMetric.bianchiI
  exact bianchiIMetricTensor_00 _ _ _

/-! ## Sanity: equal scale factors recover FRW -/

/-- When all three scale factors are equal, the Bianchi I metric tensor
    coincides with the FRW metric tensor. -/
theorem bianchiIMetricTensor_isotropic (a_n : ℝ) :
    bianchiIMetricTensor a_n a_n a_n = frwMetricTensor a_n := by
  ext i j
  simp [bianchiIMetricTensor, frwMetricTensor]

/-- The discrete Bianchi I metric with equal scale factors is the FRW
    metric. -/
theorem DiscreteMetric.bianchiI_isotropic (a : ℤ → ℝ) :
    DiscreteMetric.bianchiI a a a = DiscreteMetric.frw a := by
  ext p i j
  simp [DiscreteMetric.bianchiI, DiscreteMetric.frw,
        bianchiIMetricTensor_isotropic]

/-! ## Part 4 — Bianchi I HPW hypothesis data bundle (Canopus)

`BianchiIHpwData g` packages the three sharp `ℓ_P/12` bounds required to
witness `HpwHypothesis g` for a discrete metric `g` representing a
Bianchi type I anisotropic cosmological spacetime.  Structurally identical
to `FRWHpwData` from `HpwFRW.lean`. -/

/-- **Bianchi I anisotropic cosmological HPW hypothesis data bundle.**

Fields mirror `FRWHpwData`:

* `g_cont` — smooth continuum metric field interpolating `g`.
* `h_interpolates` — interpolation identity at lattice points.
* `h_taylor_sharp` — sharp `ℓ_P/12` Taylor-truncation bound.
* `h_harmonic_sharp` — sharp `ℓ_P/12` harmonic-gauge Ricci-box bound.
* `h_ricci_match_sharp` — sharp `ℓ_P/12` discrete-continuum Ricci match. -/
structure BianchiIHpwData (g : DiscreteMetric) : Type where
  /-- A smooth continuum metric field interpolating `g` on the lattice. -/
  g_cont : SmoothMetricField
  /-- `g_cont` interpolates `g` at every lattice point. -/
  h_interpolates : ∀ (p : LatticePoint) (μ ν : Fin 4),
    (g p) μ ν = g_cont (latticeEmbed p) μ ν
  /-- **Sharp Taylor truncation.**  Per-point `ℓ_P/12` bound between the
      discrete Laplacian and the continuum Laplacian of the interpolant. -/
  h_taylor_sharp : ∀ (p : LatticePoint) (μ ν : Fin 4),
    |discreteLaplacian (fun q => g q μ ν) p
       - continuumLaplacianAt g_cont (latticeEmbed p) μ ν| ≤ l_P / 12
  /-- **Sharp harmonic-gauge Ricci-box identity.**  Per-point `ℓ_P/12`
      bound on `|Δ_cont g_{μν} + 2 R^cont_{μν}|`.  For Bianchi I with
      anisotropic non-zero Ricci, this carries genuine physical content. -/
  h_harmonic_sharp : ∀ (p : LatticePoint) (μ ν : Fin 4),
    |continuumLaplacianAt g_cont (latticeEmbed p) μ ν
       + 2 * ricciTensorContinuum g_cont (latticeEmbed p) μ ν| ≤ l_P / 12
  /-- **Sharp discrete-continuum Ricci match.**  Per-point `ℓ_P/12`
      bound between continuum and discrete Ricci tensors. -/
  h_ricci_match_sharp : ∀ (p : LatticePoint) (μ ν : Fin 4),
    |ricciTensorContinuum g_cont (latticeEmbed p) μ ν
       - ricciTensor g μ ν p| ≤ l_P / 12

/-! ## Witnessing theorem

Given a `BianchiIHpwData g`, we deliver an `HpwHypothesis g` by invoking
`hpwHypothesis_remainder_at_twelfth` per lattice point to discharge
`h_remainder_bound`.  The proof is structurally identical to
`HpwHypothesis_of_frw` in `HpwFRW.lean`. -/

/-- **Canopus, 2026-04-15.**  **The Bianchi I anisotropic HPW theorem.**

Given `BianchiIHpwData g`, deliver `HpwHypothesis g`.

Proof: the composite `h_remainder_bound : |Δ_lat g + 2 R_disc| ≤ ℓ_P/2`
is produced per-point by `hpwHypothesis_remainder_at_twelfth`, whose
three hypotheses are exactly the three sharp-`ℓ_P/12` fields of
`BianchiIHpwData`.  The `c4_bound` and `Prop`-documentation fields
receive placeholder values. -/
noncomputable def HpwHypothesis_of_bianchiI
    (g : DiscreteMetric) (data : BianchiIHpwData g) :
    HpwHypothesis g where
  g_cont := data.g_cont
  c4_bound := 1
  c4_bound_pos := by norm_num
  h_interpolates := data.h_interpolates
  h_taylor := True
  h_harmonic := True
  h_ricci_box := True
  h_remainder_bound := by
    intro p μ ν
    exact hpwHypothesis_remainder_at_twelfth g data.g_cont p μ ν
      (data.h_taylor_sharp p μ ν)
      (data.h_harmonic_sharp p μ ν)
      (data.h_ricci_match_sharp p μ ν)

/-- **Top-level exported constructor, mirroring `frwHpwHypothesis`.**

Consumer-facing alias of `HpwHypothesis_of_bianchiI` with `g` implicit,
suitable for use as an `HpwEliminableRegime` typeclass instance member
in `HpwElimSummary.lean`. -/
noncomputable def bianchiIHpwHypothesis
    {g : DiscreteMetric} (data : BianchiIHpwData g) :
    HpwHypothesis g :=
  HpwHypothesis_of_bianchiI g data

/-! ## Corollaries — full HPW chain on the Bianchi I regime

With `HpwHypothesis_of_bianchiI` in hand, the downstream HPW consumer
theorems — `hpw_from_hypothesis`, the Laplacian-Ricci correspondence,
the equilibrium-balance form of Ricci — all apply with no axiom
invocation, mirroring the closures in `HpwFRW.lean`. -/

/-- **Axiom-free HPW bound on the Bianchi I anisotropic regime.**
Same statement as `hpw_bound_frw`, but for Bianchi I metrics equipped
with the three sharp bounds. -/
theorem hpw_bound_bianchiI
    {g : DiscreteMetric} (data : BianchiIHpwData g)
    (mu_coeff : ℝ) (hmu : 0 < mu_coeff) (hmu_le : mu_coeff ≤ 1)
    (p : LatticePoint) (μ ν : Fin 4) :
    |mu_coeff * discreteLaplacian (fun q => g q μ ν) p +
     2 * mu_coeff * ricciTensor g μ ν p| ≤ l_P / 2 :=
  hpw_from_hypothesis (HpwHypothesis_of_bianchiI g data)
    mu_coeff hmu hmu_le p μ ν

/-- **Axiom-free Laplacian-Ricci correspondence on the Bianchi I regime**
(slack `ℓ_P`). -/
theorem laplacian_ricci_correspondence_bianchiI
    {g : DiscreteMetric} (data : BianchiIHpwData g)
    (mu_coeff : ℝ) (hmu : 0 < mu_coeff) (hmu_le : mu_coeff ≤ 1)
    (p : LatticePoint) (μ ν : Fin 4) :
    |mu_coeff * discreteLaplacian (fun q => g q μ ν) p +
     2 * mu_coeff * ricciTensor g μ ν p| ≤ l_P :=
  laplacian_ricci_correspondence_from_hypothesis
    (HpwHypothesis_of_bianchiI g data) mu_coeff hmu hmu_le p μ ν

/-- **Milestone witness.**  For any discrete metric `g` equipped with a
`BianchiIHpwData` bundle, the HPW axiom is demonstrably replaceable —
i.e. an `HpwHypothesis g` exists.  This extends the elimination programme
to the Bianchi I anisotropic cosmological regime (the fifth closed regime,
after flat, linearised, static-spherical vacuum, and FRW). -/
theorem hpw_eliminable_on_bianchiI
    {g : DiscreteMetric} (data : BianchiIHpwData g) :
    ∃ H : HpwHypothesis g, H.g_cont = data.g_cont :=
  ⟨HpwHypothesis_of_bianchiI g data, rfl⟩

/-! ## Bridge: scale-factor bundle → HPW data

Given a `BianchiIScaleFactorData` together with the three sharp `ℓ_P/12`
bounds on the induced discrete metric, we can assemble a `BianchiIHpwData`.
The interpolation identity is discharged automatically from the
scale-factor bundle's agreement fields. -/

/-- **Scale-factor → HPW data builder.**  Given `BianchiIScaleFactorData D`
    and the three sharp bounds for `D.toDiscreteMetric`, produce
    `BianchiIHpwData D.toDiscreteMetric` with the smooth field from the
    bundle. -/
noncomputable def BianchiIScaleFactorData.toBianchiIHpwData
    (D : BianchiIScaleFactorData)
    (h_taylor : ∀ (p : LatticePoint) (μ ν : Fin 4),
      |discreteLaplacian (fun q => D.toDiscreteMetric q μ ν) p
         - continuumLaplacianAt D.toSmoothMetricField (latticeEmbed p) μ ν|
        ≤ l_P / 12)
    (h_harmonic : ∀ (p : LatticePoint) (μ ν : Fin 4),
      |continuumLaplacianAt D.toSmoothMetricField (latticeEmbed p) μ ν
         + 2 * ricciTensorContinuum D.toSmoothMetricField (latticeEmbed p) μ ν|
        ≤ l_P / 12)
    (h_ricci : ∀ (p : LatticePoint) (μ ν : Fin 4),
      |ricciTensorContinuum D.toSmoothMetricField (latticeEmbed p) μ ν
         - ricciTensor D.toDiscreteMetric μ ν p| ≤ l_P / 12) :
    BianchiIHpwData D.toDiscreteMetric where
  g_cont := D.toSmoothMetricField
  h_interpolates := D.interpolates
  h_taylor_sharp := h_taylor
  h_harmonic_sharp := h_harmonic
  h_ricci_match_sharp := h_ricci

end OmegaTheory.Emergence
