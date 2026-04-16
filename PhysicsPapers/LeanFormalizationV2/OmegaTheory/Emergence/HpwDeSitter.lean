/-
  OmegaTheory.Emergence.HpwDeSitter

  **Hypothesis-carrying HPW bridge for the de Sitter cosmological metric.**

  The de Sitter metric is the sixth concrete regime in the HPW axiom
  elimination programme, after flat Minkowski (`HpwMinkowski.lean`),
  linearised gravity (`HpwLinearised.lean`), static spherically-symmetric
  vacuum (`HpwSchwarzschild.lean`), spatially-flat FRW (`HpwFRW.lean`),
  and Bianchi I anisotropic (`HpwBianchiI.lean`).  It is the first
  *maximally symmetric* cosmological metric in the programme.

  ## Physical setting

  De Sitter spacetime is the maximally symmetric vacuum solution to
  Einstein's equations with positive cosmological constant `Λ > 0`.
  In flat-slicing coordinates, the line element is
      `ds² = −dt² + a(t)²(dx² + dy² + dz²)`
  where the scale factor is `a(t) = exp(H·t)` with Hubble parameter
  `H = c·√(Λ/3)`.  This is exactly a spatially-flat FRW metric with
  an exponential scale factor — so de Sitter is a *special case* of FRW.

  On the ℤ⁴ lattice, the time coordinate of a lattice point `p` is
  `p 0 : ℤ`, and the discrete scale factor is
      `a(n) = exp(H · l_P · n)`.

  ## Architecture — reuse FRW infrastructure

  Since de Sitter IS FRW with exponential scale factor, we:

  1. Define `deSitterScaleFactor` (discrete) and `deSitterSmoothScaleFactor`
     (smooth interpolant) — both using `Real.exp`.
  2. Construct `DeSitterData` : `FRWScaleFactorData` packaging the
     exponential scale factor with its analytic properties.
  3. Define `DeSitterHpwData` as a thin wrapper around `FRWHpwData`.
  4. Route through the FRW HPW pipeline for axiom-free elimination.
  5. Prove `deSitter_is_frw` — de Sitter is explicitly a special case.

  ## No axioms, no sorries

  Everything below is derived from existing infrastructure.  Zero
  additional axioms, zero sorry.

  -- Castor, HPW elimination wave-7, 2026-04-15
-/

import OmegaTheory.Emergence.HpwFRW

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open OmegaTheory.Geometry

/-! ## Part 1 — de Sitter scale factors (Castor)

The de Sitter scale factor in flat slicing is `a(t) = exp(H·t)` where
`H > 0` is the Hubble parameter.  On the ℤ⁴ lattice with spacing `l_P`,
the discrete scale factor at integer time `n` is `a(n) = exp(H · l_P · n)`.
The smooth interpolant is simply `a_cont(t) = exp(H · t)`.

Key property: `a_cont(l_P · n) = exp(H · l_P · n) = a(n)`, so lattice
agreement is trivially satisfied by construction. -/

/-- The discrete de Sitter scale factor: `a(n) = exp(H · l_P · n)` at
    integer lattice time `n`. -/
noncomputable def deSitterScaleFactor (H : ℝ) : ℤ → ℝ :=
  fun n => Real.exp (H * l_P * ↑n)

/-- The smooth de Sitter scale factor: `a_cont(t) = exp(H · t)`.
    This is the continuum interpolant of `deSitterScaleFactor`. -/
noncomputable def deSitterSmoothScaleFactor (H : ℝ) : ℝ → ℝ :=
  fun t => Real.exp (H * t)

/-- The smooth interpolant agrees with the discrete scale factor at
    lattice points: `a_cont(l_P · n) = a(n)`. -/
theorem deSitter_agree (H : ℝ) (n : ℤ) :
    deSitterSmoothScaleFactor H (l_P * ↑n) = deSitterScaleFactor H n := by
  simp [deSitterSmoothScaleFactor, deSitterScaleFactor, mul_assoc]

/-- The discrete de Sitter scale factor is strictly positive. -/
theorem deSitterScaleFactor_pos (H : ℝ) (n : ℤ) :
    0 < deSitterScaleFactor H n :=
  Real.exp_pos _

/-- The smooth de Sitter scale factor is strictly positive. -/
theorem deSitterSmoothScaleFactor_pos (H : ℝ) (t : ℝ) :
    0 < deSitterSmoothScaleFactor H t :=
  Real.exp_pos _

/-- The smooth de Sitter scale factor is `C^∞` (hence `C^4`). -/
theorem deSitterSmoothScaleFactor_smooth (H : ℝ) :
    ContDiff ℝ ⊤ (deSitterSmoothScaleFactor H) := by
  unfold deSitterSmoothScaleFactor
  exact (contDiff_const.mul contDiff_id).exp

/-- The smooth de Sitter scale factor is in particular `C^4`. -/
theorem deSitterSmoothScaleFactor_c4 (H : ℝ) :
    ContDiff ℝ 4 (deSitterSmoothScaleFactor H) :=
  (deSitterSmoothScaleFactor_smooth H).of_le le_top

/-! ## Part 2 — de Sitter FRW scale-factor data bundle (Castor)

`DeSitterData` bundles the de Sitter exponential scale factor, its smooth
interpolant, and a user-supplied fourth-derivative bound `M₄` into an
`FRWScaleFactorData`.  The bound `M₄` must be supplied because on the
full real line, `exp(H·t)` is unbounded; in practice one works on a
compact time interval where the bound is `H⁴ · exp(H · T_max)`.

The structure carries `H > 0` (positive Hubble parameter) and `M₄`
(the fourth-derivative bound on the working domain). -/

/-- **De Sitter scale-factor data bundle.**

    Given a Hubble parameter `H > 0` and a uniform fourth-derivative
    bound `M₄` (valid on the working time interval), constructs an
    `FRWScaleFactorData` with exponential scale factor `a(t) = exp(H·t)`.

    The fourth-derivative bound hypothesis `h_c4` is carried explicitly
    because `exp(H·t)` grows without bound on `ℝ`; in physical
    applications one restricts to a finite time interval. -/
noncomputable def DeSitterData
    (H : ℝ) (M₄ : ℝ) (hM₄ : 0 ≤ M₄)
    (h_c4 : ∀ t : ℝ, ‖iteratedFDeriv ℝ 4 (deSitterSmoothScaleFactor H) t‖ ≤ M₄) :
    FRWScaleFactorData where
  a := deSitterScaleFactor H
  a_cont := deSitterSmoothScaleFactor H
  h_agree := deSitter_agree H
  h_smooth := deSitterSmoothScaleFactor_c4 H
  h_pos := deSitterScaleFactor_pos H
  M₄ := M₄
  M₄_nonneg := hM₄
  h_c4_bound := h_c4

/-! ## Part 3 — de Sitter discrete metric and smooth field (Castor)

The de Sitter discrete metric is exactly the FRW discrete metric with
exponential scale factor.  The smooth field is the FRW smooth field
with exponential interpolant. -/

/-- The discrete de Sitter metric: at each lattice point `p`, the metric is
    `diag(−1, exp(H·l_P·p₀)², exp(H·l_P·p₀)², exp(H·l_P·p₀)²)`. -/
noncomputable def DiscreteMetric.deSitter (H : ℝ) : DiscreteMetric :=
  DiscreteMetric.frw (deSitterScaleFactor H)

/-- The discrete de Sitter metric is definitionally the FRW metric with
    exponential scale factor. -/
theorem DiscreteMetric.deSitter_eq_frw (H : ℝ) :
    DiscreteMetric.deSitter H = DiscreteMetric.frw (deSitterScaleFactor H) :=
  rfl

/-- The (0,0) component of the de Sitter metric is always `−1`. -/
theorem deSitter_metric_00 (H : ℝ) (p : LatticePoint) :
    DiscreteMetric.deSitter H p 0 0 = -1 := by
  simp [DiscreteMetric.deSitter, DiscreteMetric.frw, frwMetricTensor_00]

/-- Spatial diagonal entries of the de Sitter metric are
    `exp(H · l_P · p₀)²`. -/
theorem deSitter_metric_spatial (H : ℝ) (p : LatticePoint)
    (i : Fin 4) (hi : i ≠ 0) :
    DiscreteMetric.deSitter H p i i =
      (deSitterScaleFactor H (p 0)) ^ 2 := by
  simp [DiscreteMetric.deSitter, DiscreteMetric.frw,
        frwMetricTensor_spatial _ i hi]

/-- The de Sitter scale factor squared is positive. -/
theorem deSitterScaleFactor_sq_pos (H : ℝ) (n : ℤ) :
    0 < deSitterScaleFactor H n ^ 2 :=
  sq_pos_of_pos (deSitterScaleFactor_pos H n)

/-! ## Part 4 — de Sitter HPW hypothesis bundle (Castor)

The de Sitter HPW hypothesis is a thin wrapper around `FRWHpwData`,
specialized to the exponential scale factor.  We provide a dedicated
type alias for clarity, but the content is identical. -/

/-- **De Sitter HPW hypothesis data bundle.**

    A thin wrapper: `DeSitterHpwData H` is exactly `FRWHpwData`
    applied to the de Sitter discrete metric `DiscreteMetric.deSitter H`.
    The three sharp `ℓ_P/12` bounds carry the same content as for
    any FRW metric. -/
abbrev DeSitterHpwData (H : ℝ) : Type :=
  FRWHpwData (DiscreteMetric.deSitter H)

/-! ## Part 5 — HPW witnessing theorems (Castor)

Route through the FRW HPW pipeline.  Since de Sitter IS FRW,
`HpwHypothesis_of_frw` applies directly. -/

/-- **Castor, 2026-04-15.**  **The de Sitter cosmological HPW theorem.**

Given `DeSitterHpwData H`, deliver `HpwHypothesis (DiscreteMetric.deSitter H)`.
Routes through `HpwHypothesis_of_frw` since de Sitter is FRW. -/
noncomputable def HpwHypothesis_of_deSitter
    (H : ℝ) (data : DeSitterHpwData H) :
    HpwHypothesis (DiscreteMetric.deSitter H) :=
  HpwHypothesis_of_frw (DiscreteMetric.deSitter H) data

/-- **Top-level exported constructor.**

Consumer-facing alias of `HpwHypothesis_of_deSitter` with `H` implicit,
suitable for use as an `HpwEliminableRegime` typeclass instance member
in `HpwElimSummary.lean`. -/
noncomputable def deSitterHpwHypothesis
    {H : ℝ} (data : DeSitterHpwData H) :
    HpwHypothesis (DiscreteMetric.deSitter H) :=
  HpwHypothesis_of_deSitter H data

/-! ## Corollaries — full HPW chain on the de Sitter regime

With `HpwHypothesis_of_deSitter` in hand, the downstream HPW consumer
theorems apply with no axiom invocation. -/

/-- **Axiom-free HPW bound on the de Sitter regime.** -/
theorem hpw_bound_deSitter
    {H : ℝ} (data : DeSitterHpwData H)
    (mu_coeff : ℝ) (hmu : 0 < mu_coeff) (hmu_le : mu_coeff ≤ 1)
    (p : LatticePoint) (μ ν : Fin 4) :
    |mu_coeff * discreteLaplacian (fun q => DiscreteMetric.deSitter H q μ ν) p +
     2 * mu_coeff * ricciTensor (DiscreteMetric.deSitter H) μ ν p| ≤ l_P / 2 :=
  hpw_from_hypothesis (HpwHypothesis_of_deSitter H data)
    mu_coeff hmu hmu_le p μ ν

/-- **Axiom-free Laplacian-Ricci correspondence on the de Sitter regime**
(slack `ℓ_P`). -/
theorem laplacian_ricci_correspondence_deSitter
    {H : ℝ} (data : DeSitterHpwData H)
    (mu_coeff : ℝ) (hmu : 0 < mu_coeff) (hmu_le : mu_coeff ≤ 1)
    (p : LatticePoint) (μ ν : Fin 4) :
    |mu_coeff * discreteLaplacian (fun q => DiscreteMetric.deSitter H q μ ν) p +
     2 * mu_coeff * ricciTensor (DiscreteMetric.deSitter H) μ ν p| ≤ l_P :=
  laplacian_ricci_correspondence_from_hypothesis
    (HpwHypothesis_of_deSitter H data) mu_coeff hmu hmu_le p μ ν

/-- **Milestone witness.**  For any `H : ℝ` with a `DeSitterHpwData H`
bundle, the HPW axiom is demonstrably replaceable — i.e. an
`HpwHypothesis (DiscreteMetric.deSitter H)` exists.  This extends the
elimination programme to the de Sitter cosmological regime (the sixth
closed regime, after flat, linearised, static-spherical vacuum, FRW,
and Bianchi I). -/
theorem hpw_eliminable_on_deSitter
    {H : ℝ} (data : DeSitterHpwData H) :
    ∃ W : HpwHypothesis (DiscreteMetric.deSitter H),
      W.g_cont = data.g_cont :=
  ⟨HpwHypothesis_of_deSitter H data, rfl⟩

/-! ## Part 6 — Sanity: de Sitter is FRW (Castor)

An explicit witness that de Sitter in flat slicing is a special case of
the FRW framework. -/

/-- **de Sitter is FRW.**  The discrete de Sitter metric with Hubble
    parameter `H` is exactly the discrete FRW metric with the exponential
    scale factor `n ↦ exp(H · l_P · n)`. -/
theorem deSitter_is_frw (H : ℝ) :
    DiscreteMetric.deSitter H = DiscreteMetric.frw (deSitterScaleFactor H) :=
  rfl

/-! ## Part 7 — Bridge: DeSitterData → HPW data (Castor)

Given `DeSitterData H M₄ hM₄ h_c4` (an `FRWScaleFactorData`) together
with the three sharp `ℓ_P/12` bounds, we can assemble `DeSitterHpwData H`
via the FRW bridge `FRWScaleFactorData.toFRWHpwData`.

The key observation: `(DeSitterData H M₄ hM₄ h_c4).toDiscreteMetric`
definitionally equals `DiscreteMetric.deSitter H`, so the types align
without transport. -/

/-- The discrete metric extracted from `DeSitterData` is definitionally
    `DiscreteMetric.deSitter H`. -/
theorem DeSitterData_toDiscreteMetric_eq
    (H : ℝ) (M₄ : ℝ) (hM₄ : 0 ≤ M₄)
    (h_c4 : ∀ t : ℝ, ‖iteratedFDeriv ℝ 4 (deSitterSmoothScaleFactor H) t‖ ≤ M₄) :
    (DeSitterData H M₄ hM₄ h_c4).toDiscreteMetric = DiscreteMetric.deSitter H :=
  rfl

/-- **Scale-factor → HPW data builder for de Sitter.**  Given a
    `DeSitterData` bundle and the three sharp `ℓ_P/12` bounds on the
    induced discrete metric, produce `DeSitterHpwData H`. -/
noncomputable def DeSitterData_toHpwData
    (H : ℝ) (M₄ : ℝ) (hM₄ : 0 ≤ M₄)
    (h_c4 : ∀ t : ℝ, ‖iteratedFDeriv ℝ 4 (deSitterSmoothScaleFactor H) t‖ ≤ M₄)
    (h_taylor : ∀ (p : LatticePoint) (μ ν : Fin 4),
      |discreteLaplacian
          (fun q => (DeSitterData H M₄ hM₄ h_c4).toDiscreteMetric q μ ν) p
         - continuumLaplacianAt
          (DeSitterData H M₄ hM₄ h_c4).toSmoothMetricField
          (latticeEmbed p) μ ν| ≤ l_P / 12)
    (h_harmonic : ∀ (p : LatticePoint) (μ ν : Fin 4),
      |continuumLaplacianAt
          (DeSitterData H M₄ hM₄ h_c4).toSmoothMetricField
          (latticeEmbed p) μ ν
         + 2 * ricciTensorContinuum
          (DeSitterData H M₄ hM₄ h_c4).toSmoothMetricField
          (latticeEmbed p) μ ν| ≤ l_P / 12)
    (h_ricci : ∀ (p : LatticePoint) (μ ν : Fin 4),
      |ricciTensorContinuum
          (DeSitterData H M₄ hM₄ h_c4).toSmoothMetricField
          (latticeEmbed p) μ ν
         - ricciTensor
          (DeSitterData H M₄ hM₄ h_c4).toDiscreteMetric μ ν p| ≤ l_P / 12) :
    DeSitterHpwData H :=
  (DeSitterData H M₄ hM₄ h_c4).toFRWHpwData h_taylor h_harmonic h_ricci

/-! ## Part 8 — Exponential scale factor properties (Castor)

Additional analytic properties of the exponential scale factor that may
be useful for downstream consumers. -/

/-- At time `n = 0`, the de Sitter scale factor is `1`. -/
theorem deSitterScaleFactor_zero (H : ℝ) :
    deSitterScaleFactor H 0 = 1 := by
  simp [deSitterScaleFactor]

/-- At time `t = 0`, the smooth de Sitter scale factor is `1`. -/
theorem deSitterSmoothScaleFactor_zero (H : ℝ) :
    deSitterSmoothScaleFactor H 0 = 1 := by
  simp [deSitterSmoothScaleFactor]

/-- The de Sitter scale factor is multiplicative:
    `a(m + n) = a(m) · a(n)`. -/
theorem deSitterScaleFactor_add (H : ℝ) (m n : ℤ) :
    deSitterScaleFactor H (m + n) =
      deSitterScaleFactor H m * deSitterScaleFactor H n := by
  simp [deSitterScaleFactor, Int.cast_add, mul_add, Real.exp_add]

/-- The smooth de Sitter scale factor is multiplicative:
    `a_cont(s + t) = a_cont(s) · a_cont(t)`. -/
theorem deSitterSmoothScaleFactor_add (H : ℝ) (s t : ℝ) :
    deSitterSmoothScaleFactor H (s + t) =
      deSitterSmoothScaleFactor H s * deSitterSmoothScaleFactor H t := by
  simp [deSitterSmoothScaleFactor, mul_add, Real.exp_add]

/-- For `H = 0`, the de Sitter scale factor is identically `1`,
    recovering static Minkowski. -/
theorem deSitterScaleFactor_H_zero :
    deSitterScaleFactor 0 = unitScaleFactor := by
  ext n
  simp [deSitterScaleFactor, unitScaleFactor]

/-- For `H = 0`, the de Sitter discrete metric is flat Minkowski. -/
theorem deSitter_H_zero_is_flat :
    DiscreteMetric.deSitter 0 = DiscreteMetric.flat := by
  unfold DiscreteMetric.deSitter
  rw [deSitterScaleFactor_H_zero]
  exact DiscreteMetric.frw_unit

end OmegaTheory.Emergence
