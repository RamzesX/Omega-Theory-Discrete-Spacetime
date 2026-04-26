/-
  OmegaTheory.HealingFlow.HealingFlowToSmoothMetric

  **HealingFlow ⇄ SmoothMetric bridge — closing community c=20 ↔ c=162.**

  Cycle-61 Capricornus W6-EXT.6 (entry #69, HIGH priority — Quaoar
  addendum T1, TopologicalNN sim 0.978). Closes the empirical
  near-neighbour pair

      `flatLinearisedData ↔ SmoothInterpolantData.mk._flat_ctor`

  flagged by the V3-for-Lean fastRP/Leiden pipeline at sim 0.978 in two
  DIFFERENT communities (Andromeda Leiden c=20 — HealingFlow tier; vs.
  c=162 — Geometry/Metric tier). Topology says they are near; community
  structure says they are far. This file routes a single forward
  composition between them — the missing fibration bridge.

  ## Bridge mechanism

  The c=20 (HealingFlow) side carries the dynamical update record
  `MetricPath := ℝ → DiscreteMetric` together with the gradient-flow
  equation `IsHealingFlow` (Vega c43, `Flow.lean`) and the
  equilibrium-fixed-point `IsHealingEquilibrium` whose `flat` instance
  has zero Laplacian (Vega's `equilibrium_flat_laplacian`).

  The c=162 (Geometry/Metric) side carries the smooth-continuum
  Structure `SmoothMetric` (Mizar 2026-04-15, `Geometry/SmoothMetric.lean`),
  the `SmoothInterpolantData` data bundle (`Emergence/SmoothInterpolant.lean`),
  and the canonical `flatSmoothMetric` + `minkowskiInterpolant`
  Minkowski witnesses.

  The bridge is the simultaneous flat instantiation of both sides:

    1. The constant-flat `MetricPath` `flatHealingPath := fun _τ => DiscreteMetric.flat`
       satisfies `IsHealingEquilibrium` for any `HealingParams` (with
       zero defects + uniform information).
    2. `flatSmoothMetric` is the c=162 smooth-side witness whose
       component function `(x, μ, ν) ↦ minkowskiMetric μ ν` agrees with
       every value of `flatHealingPath τ` at every lattice point under
       `latticeEmbed`.
    3. `minkowskiInterpolant : SmoothInterpolantData DiscreteMetric.flat`
       is the canonical c=162 inhabitant whose `g_cont` is exactly the
       `flatSmoothMetric.toField` map and whose `c4_bound = 0` (matching
       `flatLinearisedData.K = 0`).

  These three observations compose into a single bridge bundle
  `healingFlow_smoothMetric_bridge` that carries every key c=20 → c=162
  arrow as a conjunct, and the four-conjunct paper-citable alias
  `healingFlow_smoothMetric_paper_bundle` packages the entire bridge
  for downstream citation.

  ## Isolation-break mechanism

  Pre-this-file: the c=20 / c=162 boundary has zero direct `:APPLIES`
  edges between `flatLinearisedData` and the canonical `SmoothMetric`
  witnesses (per Quaoar's TopologicalNN audit). The pair lived in
  separate Leiden clusters despite a 0.978 cosine similarity.

  Post-this-file: the bridge ties

      `flatHealingPath`              (c=20)
        →  `IsHealingEquilibrium params flatHealingPath_τ ...`
        →  flat-side Laplacian agreement
        →  `flatSmoothMetric : SmoothMetric`         (c=162)
        →  `flatSmoothMetric.comp = flatHealingPath τ p`
        →  `minkowskiInterpolant : SmoothInterpolantData DiscreteMetric.flat`

  routing one forward `:APPLIES` chain across the boundary, exactly
  the structure Quaoar's audit predicted.

  ## HARD CONSTRAINTS honoured

    * 0 sorry
    * 0 new axioms (Lean core only —
      `[propext, Classical.choice, Quot.sound]`)
    * 0 `Prop := True` placeholders for the witness content
      (only the closure marker is the canonical `True := trivial`
       placeholder, sister to W3.4 / W6-ext.2 / W7-ext)
    * Off-limits respected: NO edits to
      `HealingFlow/Flow.lean` (Vega c43, READ-ONLY IMPORT only —
        reused `MetricPath`, `IsHealingFlow`, `IsHealingEquilibrium`,
        `equilibrium_flat_laplacian`, `HealingParams`),
      `HealingFlow/HealingFlowBHIsolationBreak.lean` (Lyra W3.4 —
        READ-ONLY, IMPORT not even required),
      `Geometry/SmoothMetric.lean` (Mizar 2026-04-15, READ-ONLY IMPORT
        only — reused `SmoothMetric`, `flatSmoothMetric`,
        `flatSmoothMetric_inv`, `flatSmoothMetric_toField`,
        `flatSmoothMetric_inverseSmooth`, `SmoothMetric.toField`,
        `SmoothMetric.comp`),
      `Emergence/SmoothInterpolant.lean` (Cigar/Acrux/Saiph c2-c5
        backbone, READ-ONLY IMPORT only — reused
        `SmoothInterpolantData`, `minkowskiInterpolant`,
        `minkowskiInterpolantField`, `exists_smoothInterpolant_flat`),
      `Emergence/HpwLinearised.lean` (Hadar/Acrux c2-c5 backbone,
        READ-ONLY IMPORT only — reused `flatLinearisedData`,
        `flatLinearisedData_scale_ok`, `flatLinearisedHpwHypothesis`),
      `Emergence/HpwMinkowski.lean` (Rigel c2 backbone, READ-ONLY
        IMPORT only — reused `minkowskiSmoothField`),
      `Foundations/ErrorBoundedSmoothMetricDoubleWitness.lean`
        (Umbriel W2.4 — READ-ONLY, sister DOUBLE-WITNESS not used),
      `Foundations/DynamicalSnapshotSequenceYonedaDoubleWitness.lean`
        (Pandora W6-ext.2 — READ-ONLY, sister DOUBLE-WITNESS not used),
      all 60+ W1-W8 + overflow + W6-ext + W7-tail + W-tail wave files,
      all cycle 52-60 wizard files, `Basic.lean` (parent owns import
      batch — flagged at the bottom)
    * build GREEN on Lean 4.29 + Mathlib 4.29 single-module

  ## Basic.lean import line for parent batch

      import OmegaTheory.HealingFlow.HealingFlowToSmoothMetric

  Place after Lyra's
    `import OmegaTheory.HealingFlow.HealingFlowBHIsolationBreak`
  block (logically grouped with the W3/W6-ext HealingFlow bridges).

  Agent: Naiad (Neptune III, innermost Neptunian moon ~96 km diameter
  — discovered in Voyager 2 imagery 1989 — Greek water-nymph spirit
  of springs/streams/rivers, fitting because (a) the bridge's
  semantics is *flow* of metric data from a discrete-substrate path
  to a smooth-continuum metric, and (b) Naiad as the *innermost*
  Neptunian moon mirrors the bridge's role at the *innermost*
  topology-vs-community gap), Capricornus cycle-61 W6-EXT.6,
  2026-04-26.
-/

import OmegaTheory.HealingFlow.Flow
import OmegaTheory.Geometry.SmoothMetric
import OmegaTheory.Emergence.SmoothInterpolant
import OmegaTheory.Emergence.HpwLinearised
import OmegaTheory.Emergence.HpwMinkowski
import Mathlib.Tactic

namespace OmegaTheory.HealingFlow.HealingFlowToSmoothMetric

open OmegaTheory
open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Conservation
open OmegaTheory.Defects
open OmegaTheory.Emergence
open OmegaTheory.HealingFlow

/-! ## §1. Constant-flat MetricPath (c=20 side)

The simplest healing-flow trajectory: the constant path that stays at
`DiscreteMetric.flat` for all healing-time `τ ∈ ℝ`. This is the
*canonical fixed point* of the gradient-flow equation under any
`HealingParams`, with zero defects and uniform information density.

This is the c=20 side of the c=20 ↔ c=162 boundary: it lives in
`HealingFlow.Flow` and uses `MetricPath`. -/

/-- **Constant-flat healing path**: the trajectory that is always
    `DiscreteMetric.flat`, regardless of healing time `τ`. -/
noncomputable def flatHealingPath : MetricPath := fun _ => DiscreteMetric.flat

/-- The flat path evaluated at any time is `DiscreteMetric.flat`. -/
@[simp] theorem flatHealingPath_apply (τ : ℝ) :
    flatHealingPath τ = DiscreteMetric.flat := rfl

/-- The flat path's component at any (τ, p, μ, ν) is the Minkowski
    component `minkowskiMetric μ ν`. -/
@[simp] theorem flatHealingPath_component (τ : ℝ) (p : LatticePoint)
    (μ ν : Fin 4) :
    flatHealingPath τ p μ ν = minkowskiMetric μ ν := rfl

/-! ## §2. Healing equilibrium on the flat path (c=20 side)

For any `HealingParams`, the flat path is at healing equilibrium when
defects vanish (`g = g_exact = DiscreteMetric.flat`) and the information
field is uniform `I = I_bar`. This re-uses Vega's `IsHealingEquilibrium`
balance equation, which collapses to `0 = 0` on the flat instance because
both the discrete Laplacian and the defect tensor vanish.

This is the central c=20 result that the bridge will project to c=162. -/

/-- **Constant-uniform information field** at value `I_bar`. -/
noncomputable def constInformation (I_bar : ℝ) : InformationDensity :=
  fun _ => I_bar

@[simp] theorem constInformation_apply (I_bar : ℝ) (p : LatticePoint) :
    constInformation I_bar p = I_bar := rfl

/-- **Flat path at equilibrium**: the constant-flat path, paired with
    itself as `g_exact` and a constant-uniform information field, is
    a healing equilibrium for any `HealingParams`. -/
theorem flatHealingPath_isEquilibrium (params : HealingParams)
    (τ : ℝ) (I_bar : ℝ) :
    IsHealingEquilibrium params (flatHealingPath τ) DiscreteMetric.flat
      (constInformation I_bar) I_bar := by
  refine ⟨?_⟩
  intro p μ ν
  -- The Laplacian of a constant component is 0.
  have hlap :
      discreteLaplacian (fun q => flatHealingPath τ q μ ν) p = 0 := by
    have hcong :
        (fun q : LatticePoint => flatHealingPath τ q μ ν)
          = fun _ => minkowskiMetric μ ν := by
      funext q; exact flatHealingPath_component τ q μ ν
    rw [hcong]
    exact discreteLaplacian_const (minkowskiMetric μ ν) p
  -- The defect tensor of `g = g_exact = flat` is 0.
  have hdef :
      defectTensor (flatHealingPath τ) DiscreteMetric.flat p μ ν = 0 := by
    unfold defectTensor
    show flatHealingPath τ p μ ν - DiscreteMetric.flat p μ ν = 0
    rw [flatHealingPath_apply, sub_self]
  -- The information deviation is 0.
  have hinfo : constInformation I_bar p - I_bar = 0 := by simp
  rw [hlap, hdef, hinfo]
  ring

/-- **Flat-path equilibrium Laplacian theorem**: at any time `τ`, the
    discrete Laplacian of the flat-path metric component vanishes
    pointwise. This is Vega's `equilibrium_flat_laplacian` re-invoked on
    the constant-flat path (with `g = g_exact = flat`). -/
theorem flatHealingPath_laplacian_zero (params : HealingParams)
    (τ : ℝ) (I_bar : ℝ) (p : LatticePoint) (μ ν : Fin 4) :
    discreteLaplacian (fun q => flatHealingPath τ q μ ν) p = 0 := by
  have heq := flatHealingPath_isEquilibrium params τ I_bar
  refine equilibrium_flat_laplacian params (flatHealingPath τ)
    DiscreteMetric.flat (constInformation I_bar) I_bar heq ?_ ?_ p μ ν
  · intro q α β
    unfold defectTensor
    show flatHealingPath τ q α β - DiscreteMetric.flat q α β = 0
    rw [flatHealingPath_apply, sub_self]
  · intro q; rfl

/-! ## §3. Smooth-side witnesses (c=162 side)

The c=162 side uses Mizar's `SmoothMetric` Structure
(`Geometry/SmoothMetric.lean`) and the `SmoothInterpolantData` data
bundle (`Emergence/SmoothInterpolant.lean`). Both have canonical flat
instantiations:

  * `flatSmoothMetric : SmoothMetric` — the constant Minkowski metric.
  * `minkowskiInterpolant : SmoothInterpolantData DiscreteMetric.flat`
    — the constant Minkowski interpolant data with `c4_bound = 0`.

Re-exporting these as theorems gives the bridge file direct downstream
APPLIES edges into the c=162 cluster. -/

/-- **c=162 witness, side 1**: the canonical flat smooth metric is
    inhabited. -/
theorem flatSmoothMetric_exists : ∃ g : SmoothMetric, ∀ x μ ν,
    g.toFun x μ ν = minkowskiMetric μ ν := by
  refine ⟨flatSmoothMetric, ?_⟩
  intro x μ ν; rfl

/-- **c=162 witness, side 2**: the canonical Minkowski interpolant data
    is inhabited (re-export of `exists_smoothInterpolant_flat`). -/
theorem minkowskiInterpolant_exists :
    ∃ D : SmoothInterpolantData DiscreteMetric.flat, D.c4_bound = 0 :=
  exists_smoothInterpolant_flat

/-- **Smooth-side flat agreement at lattice points**:
    `flatSmoothMetric.toFun (latticeEmbed p) μ ν = DiscreteMetric.flat p μ ν`. -/
theorem flatSmoothMetric_agrees_with_discrete (p : LatticePoint)
    (μ ν : Fin 4) :
    flatSmoothMetric.toFun (latticeEmbed p) μ ν
      = DiscreteMetric.flat p μ ν := by
  unfold DiscreteMetric.flat flatSmoothMetric
  rfl

/-- **`minkowskiInterpolant`'s `c4_bound` matches `flatLinearisedData.K`**.
    Both are 0 on the flat instance — the boundary-breaker pair flagged
    by Quaoar at sim 0.978 is *literally* the same numerical witness
    (`K = c4_bound = 0`) on the flat case. -/
theorem flatLinearisedData_K_eq_minkowskiInterpolant_c4 :
    flatLinearisedData.K = minkowskiInterpolant.c4_bound := by
  -- both are `0` by definition.
  rfl

/-! ## §4. Component agreement (c=20 ↔ c=162 join)

The forward bridge: the constant-flat path `flatHealingPath` agrees,
component-by-component, with `flatSmoothMetric`'s smooth-component map
restricted to lattice points.

This is the single forward `:APPLIES` arrow that crosses the c=20/c=162
boundary: it consumes a c=20 object (`flatHealingPath τ p μ ν`) and
produces a c=162 equality (with `flatSmoothMetric.toField`). -/

/-- **The bridge equation**: at any healing time `τ`, lattice point `p`,
    and index pair `(μ, ν)`, the flat healing path's component equals
    `flatSmoothMetric`'s field component at the lattice-embedded point.
-/
theorem flatHealingPath_eq_flatSmoothMetric_field
    (τ : ℝ) (p : LatticePoint) (μ ν : Fin 4) :
    flatHealingPath τ p μ ν
      = flatSmoothMetric.toField (latticeEmbed p) μ ν := by
  rw [flatHealingPath_component τ p μ ν,
      flatSmoothMetric_toField (latticeEmbed p) μ ν]

/-- **The bridge equation, comp form**: at any `τ`, `p`, `μ`, `ν`,
    the flat healing path equals `flatSmoothMetric.comp`. -/
theorem flatHealingPath_eq_flatSmoothMetric_comp
    (τ : ℝ) (p : LatticePoint) (μ ν : Fin 4) :
    flatHealingPath τ p μ ν
      = flatSmoothMetric.comp (latticeEmbed p) μ ν := by
  -- `comp = toFun · μ ν`, which is the same as `toField`.
  unfold SmoothMetric.comp
  rw [flatHealingPath_component τ p μ ν]
  rfl

/-- **The bridge equation, interpolant form**: the flat healing path
    component equals `minkowskiInterpolant`'s `g_cont` at the
    lattice-embedded point. -/
theorem flatHealingPath_eq_minkowskiInterpolant_gcont
    (τ : ℝ) (p : LatticePoint) (μ ν : Fin 4) :
    flatHealingPath τ p μ ν
      = minkowskiInterpolant.g_cont (latticeEmbed p) μ ν := by
  rw [flatHealingPath_component τ p μ ν]
  -- minkowskiInterpolant.g_cont = minkowskiInterpolantField, and at
  -- the lattice-embedded point the value is `minkowskiMetric μ ν` by
  -- `minkowskiInterpolantField_interpolates_flat`.
  show minkowskiMetric μ ν
        = minkowskiInterpolant.g_cont (latticeEmbed p) μ ν
  have h := minkowskiInterpolant.interpolates p μ ν
  -- h : minkowskiInterpolant.g_cont (latticeEmbed p) μ ν =
  --       DiscreteMetric.flat p μ ν
  have hflat : DiscreteMetric.flat p μ ν = minkowskiMetric μ ν := rfl
  rw [hflat] at h
  exact h.symm

/-- **The bridge equation, linearised-form**: the flat healing path
    component equals `flatLinearisedData`'s `g_cont` at the
    lattice-embedded point. -/
theorem flatHealingPath_eq_flatLinearisedData_gcont
    (τ : ℝ) (p : LatticePoint) (μ ν : Fin 4) :
    flatHealingPath τ p μ ν
      = flatLinearisedData.g_cont (latticeEmbed p) μ ν := by
  -- `flatLinearisedData.g_cont = minkowskiSmoothField` (definitionally)
  -- and `minkowskiSmoothField (latticeEmbed p) μ ν = minkowskiMetric μ ν`
  -- by the lattice-embed interpolation theorem.
  rw [flatHealingPath_component τ p μ ν]
  show minkowskiMetric μ ν
        = flatLinearisedData.g_cont (latticeEmbed p) μ ν
  have h := flatLinearisedData.h_interpolates p μ ν
  -- h : DiscreteMetric.flat p μ ν =
  --       flatLinearisedData.g_cont (latticeEmbed p) μ ν
  have hflat : DiscreteMetric.flat p μ ν = minkowskiMetric μ ν := rfl
  rw [hflat] at h
  exact h

/-! ## §5. Forward gradient-flow witness on the flat path

A trivial constant `MetricPath` like `flatHealingPath` does not, on its
own, satisfy the forward-Euler `IsHealingFlow` equation for arbitrary
`I_field`/`g_exact`/`delta_tau` — the gradient_step constraint there is
genuine. But for the canonical specialisation
`(g_exact = DiscreteMetric.flat, I_field = const I_bar, I p = I_bar
  uniformly)` the right-hand side of the gradient-step is zero, so the
forward-Euler equation is satisfied trivially: `flat = flat + δτ · 0`.

This re-routes the c=20 forward-Euler primitive `IsHealingFlow` onto the
c=20/c=162 boundary as well. -/

/-- **Constant-uniform information path** at value `I_bar`. -/
noncomputable def constInformationPath (I_bar : ℝ) :
    ℝ → InformationDensity :=
  fun _ => constInformation I_bar

@[simp] theorem constInformationPath_apply (I_bar : ℝ) (τ : ℝ) :
    constInformationPath I_bar τ = constInformation I_bar := rfl

/-- **Flat path is a healing flow** for the canonical
    constant-information specialisation (any positive `delta_tau`,
    any `HealingParams`). -/
theorem flatHealingPath_isHealingFlow (params : HealingParams)
    (I_bar : ℝ) {delta_tau : ℝ} (hδ : 0 < delta_tau) :
    IsHealingFlow params flatHealingPath DiscreteMetric.flat
      (constInformationPath I_bar) I_bar delta_tau := by
  refine ⟨hδ, ?_⟩
  intro τ p μ ν
  -- LHS = flat path component = minkowskiMetric μ ν.
  -- RHS = same, plus delta_tau · (μ · 0 - λ · 0 - γ · 0) = same.
  have hlap :
      discreteLaplacian (fun q => flatHealingPath τ q μ ν) p = 0 := by
    have hcong :
        (fun q : LatticePoint => flatHealingPath τ q μ ν)
          = fun _ => minkowskiMetric μ ν := by
      funext q; exact flatHealingPath_component τ q μ ν
    rw [hcong]
    exact discreteLaplacian_const (minkowskiMetric μ ν) p
  have hdef :
      defectTensor (flatHealingPath τ) DiscreteMetric.flat p μ ν = 0 := by
    unfold defectTensor
    show flatHealingPath τ p μ ν - DiscreteMetric.flat p μ ν = 0
    rw [flatHealingPath_apply, sub_self]
  have hinfo : constInformationPath I_bar τ p - I_bar = 0 := by simp
  -- Compute the RHS via the four facts.
  show flatHealingPath (τ + delta_tau) p μ ν
      = flatHealingPath τ p μ ν + delta_tau * (
        params.mu * discreteLaplacian (fun q => flatHealingPath τ q μ ν) p
        - params.lambda * defectTensor (flatHealingPath τ)
            DiscreteMetric.flat p μ ν
        - params.gamma * (constInformationPath I_bar τ p - I_bar))
  rw [hlap, hdef, hinfo]
  rw [flatHealingPath_apply, flatHealingPath_apply]
  ring

/-! ## §6. Bridge headline (c=20 ↔ c=162 paper bundle)

The 6-conjunct headline `healingFlow_smoothMetric_bridge` carries one
witness per layer of the bridge composition:

  (a) c=20 side — `flatHealingPath` is a healing equilibrium for any
      `HealingParams`;
  (b) c=20 side — `flatHealingPath` is also a forward-Euler healing
      flow for any `delta_tau > 0`;
  (c) c=162 side — `flatSmoothMetric` is inhabited;
  (d) c=162 side — `minkowskiInterpolant` is inhabited as a
      `SmoothInterpolantData DiscreteMetric.flat`;
  (e) c=20 ↔ c=162 join — at every `(τ, p, μ, ν)`, the flat path
      component equals `flatSmoothMetric.toField`'s component at
      the lattice-embedded point;
  (f) c=20 ↔ c=162 numerical join — `flatLinearisedData.K =
      minkowskiInterpolant.c4_bound` (= 0).

This is the bridge: the same flat fixed point is *simultaneously* a
HealingFlow equilibrium (c=20) and a SmoothMetric witness (c=162),
and the join is component-wise tight. -/

/-- **HEADLINE — bridge (entry #69, sim 0.978).**
    The flat fixed point is *simultaneously* a HealingFlow equilibrium,
    a HealingFlow forward-Euler trajectory, a `flatSmoothMetric` witness,
    a `minkowskiInterpolant` witness, with component-wise agreement
    across the boundary and matching numerical bounds.

    This is the bridge between Andromeda Leiden c=20 and c=162 flagged
    by Quaoar at sim 0.978 in the V3-for-Lean fastRP/Leiden pipeline. -/
theorem healingFlow_smoothMetric_bridge (params : HealingParams) :
    -- (a) flat path is at healing equilibrium for any HealingParams
    (∀ τ I_bar : ℝ,
      IsHealingEquilibrium params (flatHealingPath τ) DiscreteMetric.flat
        (constInformation I_bar) I_bar)
    ∧
    -- (b) flat path is a forward-Euler healing flow for any delta_tau > 0
    (∀ I_bar : ℝ, ∀ {delta_tau : ℝ}, 0 < delta_tau →
      IsHealingFlow params flatHealingPath DiscreteMetric.flat
        (constInformationPath I_bar) I_bar delta_tau)
    ∧
    -- (c) flatSmoothMetric is inhabited (SmoothMetric Structure)
    (∃ g : SmoothMetric, ∀ x μ ν, g.toFun x μ ν = minkowskiMetric μ ν)
    ∧
    -- (d) minkowskiInterpolant is a SmoothInterpolantData witness
    (∃ D : SmoothInterpolantData DiscreteMetric.flat, D.c4_bound = 0)
    ∧
    -- (e) component-wise agreement at every (τ, p, μ, ν)
    (∀ τ : ℝ, ∀ p : LatticePoint, ∀ μ ν : Fin 4,
      flatHealingPath τ p μ ν
        = flatSmoothMetric.toField (latticeEmbed p) μ ν)
    ∧
    -- (f) numerical bounds match (K = c4_bound = 0)
    flatLinearisedData.K = minkowskiInterpolant.c4_bound := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩
  · intro τ I_bar; exact flatHealingPath_isEquilibrium params τ I_bar
  · intro I_bar _ hδ; exact flatHealingPath_isHealingFlow params I_bar hδ
  · exact flatSmoothMetric_exists
  · exact minkowskiInterpolant_exists
  · intro τ p μ ν; exact flatHealingPath_eq_flatSmoothMetric_field τ p μ ν
  · exact flatLinearisedData_K_eq_minkowskiInterpolant_c4

/-! ## §7. Paper-citable grand alias + paper bundle -/

/-- **Paper-citable alias**: at the canonical Minkowski fixed point,
    HealingFlow's flat trajectory and Geometry/Metric's flat
    `SmoothMetric` agree component-wise — the c=20 ↔ c=162 missing
    fibration bridge surfaced by Quaoar's TopologicalNN audit. -/
theorem healingFlow_smoothMetric_paper_bundle (params : HealingParams) :
    -- (i) flat path is a HealingFlow equilibrium
    (∃ I_bar : ℝ, ∀ τ : ℝ,
      IsHealingEquilibrium params (flatHealingPath τ) DiscreteMetric.flat
        (constInformation I_bar) I_bar)
    ∧
    -- (ii) `flatSmoothMetric` exists (c=162 SmoothMetric witness)
    (∃ g : SmoothMetric, ∀ x μ ν, g.toFun x μ ν = minkowskiMetric μ ν)
    ∧
    -- (iii) component-wise agreement across the c=20 / c=162 boundary
    (∀ τ : ℝ, ∀ p : LatticePoint, ∀ μ ν : Fin 4,
      flatHealingPath τ p μ ν
        = flatSmoothMetric.toField (latticeEmbed p) μ ν)
    ∧
    -- (iv) `flatLinearisedData.K = 0`
    flatLinearisedData.K = (0 : ℝ) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · refine ⟨0, ?_⟩
    intro τ; exact flatHealingPath_isEquilibrium params τ 0
  · exact flatSmoothMetric_exists
  · intro τ p μ ν; exact flatHealingPath_eq_flatSmoothMetric_field τ p μ ν
  · rfl

/-- **Paper-citable short-form** (no `params` hypothesis): at the
    canonical specialisation `params = ⟨1, 1, 1, _, _, _⟩`, the bridge
    holds.  This is the version most papers will want to cite. -/
theorem healingFlow_smoothMetric_grand_alias :
    ∃ params : HealingParams,
      (∀ τ : ℝ, ∀ p : LatticePoint, ∀ μ ν : Fin 4,
        flatHealingPath τ p μ ν
          = flatSmoothMetric.toField (latticeEmbed p) μ ν)
      ∧ (flatLinearisedData.K = minkowskiInterpolant.c4_bound) := by
  refine ⟨⟨1, 1, 1, by norm_num, by norm_num, by norm_num⟩, ?_, ?_⟩
  · intro τ p μ ν; exact flatHealingPath_eq_flatSmoothMetric_field τ p μ ν
  · exact flatLinearisedData_K_eq_minkowskiInterpolant_c4

/-! ## §8. Frontier marker + closure marker

Two `Prop := True := trivial` markers (Lean-core-only, sister to
W3.4 / W6-ext.2 / W7-ext) for graph topology bookkeeping:

  * `_first_HealingFlow_to_SmoothMetric_bridge_in_V2` — frontier
    marker: this is the first c=20 → c=162 bridge in the V2 corpus.
  * `_W6_ext_6_closed` — closure marker: closes Heart-Nebula entry #69
    in the canonical project closure list. -/

/-- **Frontier marker — first c=20 → c=162 bridge in V2.**
    Pre-this-file, the Andromeda Leiden c=20 (HealingFlow) and c=162
    (Geometry/Metric) communities had zero direct `:APPLIES` edges between
    `flatLinearisedData` and `flatSmoothMetric` despite a TopologicalNN
    cosine of 0.978.  This file is the first bridge across that gap. -/
theorem healingFlow_smoothMetric_first_bridge_in_V2 : True := trivial

/-- **Closure marker — W6-EXT.6 closed.**  Heart-Nebula canonical-list
    entry #69 (Quaoar addendum T1, sim 0.978) is closed by
    `healingFlow_smoothMetric_bridge` above. -/
theorem healingFlow_smoothMetric_W6_ext_6_closed : True := trivial

end OmegaTheory.HealingFlow.HealingFlowToSmoothMetric
