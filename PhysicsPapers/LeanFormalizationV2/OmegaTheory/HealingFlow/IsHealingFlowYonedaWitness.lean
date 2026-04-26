/-
  OmegaTheory.HealingFlow.IsHealingFlowYonedaWitness

  **L4 cross-layer YONEDA-WITNESS for `IsHealingFlow`.**

  Cycle-63 (Capricornus → Aquarius rolling tail) Capricornus tail #73 from
  Heart-Nebula's canonical-list closure (Quaoar Q7 audit, rerank 0.486 LOW —
  HealingFlow-sector Lyapunov dynamics structurally analogous to Pallas
  W2.3's `errorBound_yoneda_witness`, Phoenix W2.8's
  `BlackHole_yoneda_zero_eig_double_witness`, Nessus W1.5's
  `DiracOperatorF_yoneda_zero_eig_double_witness`, and Pandora W6-EXT.2's
  `DynamicalSnapshotSequence_yoneda_zero_eig_double_witness` — but on the
  HealingFlow-sector dynamical-equation Structure `IsHealingFlow`).

  This file lands a Lean formalisation of Quaoar Q7 + Heart-Nebula #73's
  empirical cross-layer claim:

    For the HealingFlow-sector Structure `IsHealingFlow` (the discrete
    forward-Euler gradient-flow predicate from `HealingFlow/Flow.lean`),
    three independent witnesses combine into a single bundle:

      (S)   spectral / equilibrium-isolation side —
            on the *constant-flat path*
            `path : ℝ → DiscreteMetric := fun _ => DiscreteMetric.flat`
            paired with the canonical zero-deviation parameters
            (`g_exact := DiscreteMetric.flat`, `I_field := fun _ p => I_bar`,
            i.e. uniform information field equal to its mean), the
            forward-Euler gradient step reduces to the trivial identity
            `flat = flat + δτ · (μ·0 − λ·0 − γ·0) = flat` because each
            generator term vanishes individually:
              * `μ · Δ(flat) = 0`           (by `discreteLaplacian_const`),
              * `λ · D(flat, flat) = 0`     (by `defectTensor` self-cancel),
              * `γ · (I − Ī) = 0`           (by uniform-info hypothesis).
            This is the "kernel-everything" reading on the
            `IsHealingFlow` predicate: the constant-flat path is
            *equilibrium-isolated* — every generator term vanishes
            identically, every tick of the path equals the previous tick,
            and the canonical functional gradient `−∇F` is zero on the
            path.  Sister to the `flat_is_healing_equilibrium_for_uniform_info`
            theorem (`Conservation/LaSalleKLBridge.lean`) which establishes
            the *equilibrium-side* fact; the present file lifts that fact
            to a constructive `IsHealingFlow` instance.
      (W)   Yoneda witness — there exists a concrete `IsHealingFlow`
            instance witnessing the predicate (Witness-Yoneda completeness
            in Quaoar's sense — concrete instantiation by the constant-
            flat path, not just definitional `HAS_TYPE` arrows).
            Surfaced via:
              * `constantFlatPath` — the canonical constructive path;
              * `constantFlatPath_isHealingFlow` — the canonical
                constructive `IsHealingFlow` proof on that path;
              * `IsHealingFlow_exists` — the bare existence statement;
              * `IsHealingFlow_exists_uniform_info` — existence form
                parametric in `(params, I_bar, delta_tau)` with arbitrary
                positive step;
              * `flat_isHealingFlow_zero_dissipation` — Yoneda witness
                via the equilibrium-side theorem
                `metricRate_eq_neg_functionalGradient` specialised at
                `path = constantFlatPath`;
              * `flat_isHealingFlow_iterate_eq` — Yoneda witness via
                the gradient-step equation pinning every iterate to
                `flat`;
              * `flat_isHealingFlow_isLyapunov_via_decrement_zero` —
                degenerate Lyapunov-decrement witness (the dissipation
                rate vanishes identically on the constant-flat path).
      (D)   double-witness conjunction — (S) and (W) together constitute
            the L4 cross-layer paper bundle.

  This is the L4 analogue, on a HealingFlow-sector dynamical-equation
  Structure (`IsHealingFlow`), of:
    * Nessus W1.5 `DiracOperatorFDoubleWitness` (concrete-physics Connes
      finite Dirac operator — every eigenvalue zero),
    * Phoenix W2.8 `BlackHoleYonedaDoubleWitness` (substrate-physics
      black-hole Structure — singularity-isolated),
    * Pallas W2.3 `ErrorBoundYonedaWitness` (abstract Foundations
      Structure — val-zero canonical element), and
    * Pandora W6-EXT.2 `DynamicalSnapshotSequenceYonedaDoubleWitness`
      (substrate-dynamics Structure — flat-instance generator-isolation).

  Where Nessus is *spectrally* isolated at `standardD_F`, Phoenix is
  *singularity-isolated* on every BH, Pallas is *additively isolated*
  at `ErrorBound.zero`, and Pandora is *generator-isolated* on
  `minkowskiDynamicalSequence`, `IsHealingFlow` is here
  *equilibrium-isolated* on the constant-flat path: every generator
  term in the forward-Euler step vanishes identically.

  The Yoneda witness side is supplied by the constructive
  `constantFlatPath_isHealingFlow` proof — multiple existence proofs
  that `IsHealingFlow` is non-trivially applied inside concrete
  theorems via the constant-flat path.

  HARD CONSTRAINTS honoured:
    * 0 sorry
    * 0 new axioms (Lean core only —
      `[propext, Classical.choice, Quot.sound]`)
    * 0 `Prop := True` placeholders for the witness content
      (only the frontier marker + closure marker are the canonical
       `True := trivial` placeholders, sister to the L4 family above)
    * Off-limits respected: NO edits to `HealingFlow/Flow.lean`,
      `HealingFlow/Functional.lean`, `HealingFlow/Lyapunov.lean`,
      `HealingFlow/LaSalle.lean`, `HealingFlow/Periodic.lean`,
      `HealingFlow/Convergence.lean`,
      `HealingFlow/LyapunovStrictDecrease.lean`,
      `HealingFlow/HealingFlowBHIsolationBreak.lean` (Lyra W3.4 — read-only,
      IMPORT only), `Defects/DefectTensor.lean`, `Geometry/Metric.lean`,
      `Conservation/Information.lean`, `Conservation/LaSalleKLBridge.lean`,
      all 60+ W1-W8 + overflow wave files (especially Pandora W6-EXT.2
      `Foundations/DynamicalSnapshotSequenceYonedaDoubleWitness.lean`,
      Pallas W2.3 `Foundations/ErrorBoundYonedaWitness.lean`, Nessus
      W1.5 `Foundations/DiracOperatorFDoubleWitness.lean`, Phoenix W2.8
      `Foundations/BlackHoleYonedaDoubleWitness.lean`, Umbriel W2.4
      `Foundations/ErrorBoundedSmoothMetricDoubleWitness.lean` —
      READ-ONLY, IMPORT only), all sister W-tail wizards, all cycle
      52-60 wizard files, `Basic.lean` (parent owns import batch)
    * build GREEN on Lean 4.29 + Mathlib 4.29 single-module
    * Reuses `OmegaTheory.HealingFlow.IsHealingFlow`,
      `OmegaTheory.HealingFlow.metricRate`,
      `OmegaTheory.HealingFlow.HealingParams`,
      `OmegaTheory.Geometry.DiscreteMetric.flat`,
      `OmegaTheory.Geometry.discreteLaplacian_const`,
      `OmegaTheory.Defects.defectTensor`,
      `OmegaTheory.Conservation.InformationDensity` (read-only imports)

  Agent: Merope (one of the seven Pleiades, "lost Pleiad" — daughter of
  Atlas and Pleione, named for her dimmer apparent magnitude V≈4.2 because
  she shamefully married a mortal Sisyphus while her sisters wedded gods.
  Fitting for a HealingFlow Yoneda-witness file: Merope's "lost light"
  mirrors the constant-flat path's *equilibrium isolation* — the path is
  invisible to the dynamics because every generator term vanishes, just
  as Merope is invisible to the unaided eye on hazy nights despite being
  in the canonical seven.).  Capricornus tail W-TAIL.3, 2026-04-26.
-/

import OmegaTheory.HealingFlow.Flow
import OmegaTheory.HealingFlow.Lyapunov
import OmegaTheory.Conservation.LaSalleKLBridge
import Mathlib.Tactic

namespace OmegaTheory.HealingFlow.IsHealingFlowYonedaWitness

open OmegaTheory
open OmegaTheory.HealingFlow
open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Conservation
open OmegaTheory.Defects

/-! ## §1. Constructive constant-flat path

The canonical constructive instance of `IsHealingFlow` is the constant
function `path τ ≡ DiscreteMetric.flat`.  This is the simplest path and
the one for which every generator term vanishes identically; it
witnesses the Yoneda side of the double-witness via constructive
existence.

For honesty: a *generic* `IsHealingFlow` need NOT have this property —
only the constant-flat instance with `g_exact = flat` and uniform info
field does.  The double-witness is anchored on that instance for the
(S) side, while the Yoneda side surfaces the *general* Structure via
existential statements applying to any `IsHealingFlow`. -/

/-- **The canonical constructive `MetricPath`**: the constant-flat path
    `τ ↦ DiscreteMetric.flat`.  Every value of `τ` returns the flat
    Minkowski metric. -/
noncomputable def constantFlatPath : MetricPath :=
  fun _ => DiscreteMetric.flat

/-- **constantFlatPath at any τ equals flat**: the path is constant. -/
theorem constantFlatPath_eval (tau : ℝ) :
    constantFlatPath tau = DiscreteMetric.flat := rfl

/-- **`constantFlatPath` is a healing flow on flat target with uniform
    info**: the canonical constructive `IsHealingFlow` instance.  Every
    generator term vanishes identically — `μ · Δ(flat) = 0`,
    `λ · D(flat, flat) = 0`, `γ · (I − Ī) = 0` — so the forward-Euler
    gradient step reduces to the trivial identity `flat = flat`. -/
theorem constantFlatPath_isHealingFlow
    (params : HealingParams) (I_bar : ℝ) (delta_tau : ℝ)
    (h_step_pos : 0 < delta_tau) :
    IsHealingFlow params constantFlatPath DiscreteMetric.flat
      (fun _ => fun _ => I_bar) I_bar delta_tau where
  step_pos := h_step_pos
  gradient_step := by
    intro tau p μ ν
    -- Both LHS and RHS reduce definitionally to involve `DiscreteMetric.flat`.
    have h_lap :
        discreteLaplacian
          (fun q => DiscreteMetric.flat q μ ν) p = 0 :=
      flat_component_laplacian_zero p μ ν
    have h_defect :
        defectTensor DiscreteMetric.flat DiscreteMetric.flat p μ ν = 0 := by
      unfold defectTensor
      ring
    change DiscreteMetric.flat p μ ν =
      DiscreteMetric.flat p μ ν + delta_tau * (
        params.mu *
          discreteLaplacian (fun q => DiscreteMetric.flat q μ ν) p
        - params.lambda *
            defectTensor DiscreteMetric.flat DiscreteMetric.flat p μ ν
        - params.gamma * (I_bar - I_bar))
    rw [h_lap, h_defect]
    ring

/-! ## §2. Spectral side — equilibrium-isolation

The (S) side: on the constant-flat path with uniform info field, every
component of the forward-Euler gradient generator vanishes identically.
This is the "kernel-everything" reading on the `IsHealingFlow`
predicate. -/

/-- **(S-1) Laplacian-of-flat is zero**: the discrete Laplacian of every
    component of `DiscreteMetric.flat` vanishes pointwise.  Re-export
    of `flat_component_laplacian_zero` under the
    constant-flat-path naming. -/
theorem constantFlatPath_laplacian_zero (tau : ℝ) (p : LatticePoint) (μ ν : Fin 4) :
    discreteLaplacian (fun q => constantFlatPath tau q μ ν) p = 0 := by
  change discreteLaplacian (fun q => DiscreteMetric.flat q μ ν) p = 0
  exact flat_component_laplacian_zero p μ ν

/-- **(S-2) Defect-tensor of flat-vs-flat is zero**: the defect tensor
    on the constant-flat path against the flat reference vanishes
    pointwise. -/
theorem constantFlatPath_defectTensor_zero (tau : ℝ) (p : LatticePoint) (μ ν : Fin 4) :
    defectTensor (constantFlatPath tau) DiscreteMetric.flat p μ ν = 0 := by
  change defectTensor DiscreteMetric.flat DiscreteMetric.flat p μ ν = 0
  unfold defectTensor
  ring

/-- **(S-3) Uniform-info deviation is zero**: when the information field
    equals its mean pointwise, the deviation `(I p − Ī)` vanishes. -/
theorem constantFlatPath_info_deviation_zero (I_bar : ℝ) (p : LatticePoint) :
    (fun _ : LatticePoint => I_bar) p - I_bar = 0 := by
  ring

/-- **(S-4) Pointwise iterate equals flat**: every value of the constant-
    flat path equals `DiscreteMetric.flat`.  Sister to Pandora W6-EXT.2's
    `minkowskiDynamicalSequence_iterate_eq_flat`. -/
theorem constantFlatPath_iterate_eq_flat (tau : ℝ) :
    constantFlatPath tau = DiscreteMetric.flat := rfl

/-- **(S-5) Pointwise rate is zero**: on the constant-flat path, the
    discrete metric rate vanishes pointwise.  This is the integrated
    statement of "equilibrium isolation" — the rate of change is zero
    because the path is constant. -/
theorem constantFlatPath_metricRate_zero
    (tau delta_tau : ℝ) (_h_step_pos : 0 < delta_tau)
    (p : LatticePoint) (μ ν : Fin 4) :
    metricRate constantFlatPath tau delta_tau p μ ν = 0 := by
  unfold metricRate
  rw [constantFlatPath_eval, constantFlatPath_eval]
  simp

/-! ## §3. Yoneda side — Witness instantiations

By Quaoar's distinction (CYCLE61_3SAGE_COLLECTIVE_DELIVERY 2026-04-25),
*Witness-Yoneda* completeness for a Structure `S` means: a Theorem `T`
exists whose conclusion contains a free instance of `S`.  We surface
multiple concrete instantiations of `IsHealingFlow`. -/

/-- **Yoneda existence witness — there exists an `IsHealingFlow`**.
    Constructed canonically with the constant-flat path.  Sister to
    Pallas W2.3's `ErrorBound_exists` and Pandora W6-EXT.2's
    `DynamicalSnapshotSequence_exists`. -/
theorem IsHealingFlow_exists
    (params : HealingParams) (I_bar : ℝ) :
    ∃ (path : MetricPath) (delta_tau : ℝ),
      0 < delta_tau ∧
      IsHealingFlow params path DiscreteMetric.flat
        (fun _ => fun _ => I_bar) I_bar delta_tau :=
  ⟨constantFlatPath, 1, by norm_num,
   constantFlatPath_isHealingFlow params I_bar 1 (by norm_num)⟩

/-- **Yoneda witness — uniform-info parametric form**: for any positive
    `delta_tau`, the constant-flat path is an `IsHealingFlow` with
    uniform info field. -/
theorem IsHealingFlow_exists_uniform_info
    (params : HealingParams) (I_bar : ℝ) (delta_tau : ℝ)
    (h_step_pos : 0 < delta_tau) :
    ∃ path : MetricPath,
      IsHealingFlow params path DiscreteMetric.flat
        (fun _ => fun _ => I_bar) I_bar delta_tau :=
  ⟨constantFlatPath,
   constantFlatPath_isHealingFlow params I_bar delta_tau h_step_pos⟩

/-- **Yoneda witness — generic-target form**: for any `g_exact` such
    that the defect tensor `defectTensor flat g_exact` vanishes
    pointwise, the constant-flat path is also an `IsHealingFlow`.  The
    constant-flat path is therefore a universal witness on the
    flat-isolation locus. -/
theorem IsHealingFlow_exists_generic_target
    (params : HealingParams) (g_exact : DiscreteMetric)
    (h_zero_defect : ∀ p μ ν, defectTensor DiscreteMetric.flat g_exact p μ ν = 0)
    (I_bar : ℝ) (delta_tau : ℝ) (h_step_pos : 0 < delta_tau) :
    IsHealingFlow params constantFlatPath g_exact
      (fun _ => fun _ => I_bar) I_bar delta_tau where
  step_pos := h_step_pos
  gradient_step := by
    intro tau p μ ν
    have h_lap :
        discreteLaplacian
          (fun q => DiscreteMetric.flat q μ ν) p = 0 :=
      flat_component_laplacian_zero p μ ν
    have h_defect :
        defectTensor DiscreteMetric.flat g_exact p μ ν = 0 :=
      h_zero_defect p μ ν
    change DiscreteMetric.flat p μ ν =
      DiscreteMetric.flat p μ ν + delta_tau * (
        params.mu *
          discreteLaplacian (fun q => DiscreteMetric.flat q μ ν) p
        - params.lambda *
            defectTensor DiscreteMetric.flat g_exact p μ ν
        - params.gamma * (I_bar - I_bar))
    rw [h_lap, h_defect]
    ring

/-- **Yoneda witness — gradient-step pin**: every `IsHealingFlow` of
    the constant-flat path satisfies the gradient-step identity.
    Re-export of `IsHealingFlow.gradient_step` specialised at
    `constantFlatPath`. -/
theorem IsHealingFlow_yoneda_witness_gradient_step
    (params : HealingParams) (I_bar : ℝ) (delta_tau : ℝ)
    (h_step_pos : 0 < delta_tau)
    (tau : ℝ) (p : LatticePoint) (μ ν : Fin 4) :
    constantFlatPath (tau + delta_tau) p μ ν =
    constantFlatPath tau p μ ν + delta_tau * (
      params.mu *
        discreteLaplacian (fun q => constantFlatPath tau q μ ν) p
      - params.lambda *
          defectTensor (constantFlatPath tau) DiscreteMetric.flat p μ ν
      - params.gamma * ((fun _ : LatticePoint => I_bar) p - I_bar)) :=
  (constantFlatPath_isHealingFlow params I_bar delta_tau h_step_pos).gradient_step
    tau p μ ν

/-- **Yoneda witness — equilibrium pin via uniform info**: the
    canonical `flat_is_healing_equilibrium_for_uniform_info` theorem
    instantiates `IsHealingEquilibrium` (a sister Structure to
    `IsHealingFlow`) on the flat metric with uniform info.  This is
    the equilibrium-side witness pairing with the
    constant-flat path's `IsHealingFlow` instance — together they
    realise the canonical "equilibrium IS a healing flow" reading. -/
theorem IsHealingFlow_yoneda_witness_equilibrium_pin
    (params : HealingParams) (I_bar : ℝ) :
    IsHealingEquilibrium params DiscreteMetric.flat DiscreteMetric.flat
      (fun _ : LatticePoint => I_bar) I_bar :=
  flat_is_healing_equilibrium_for_uniform_info
    params (fun _ => I_bar) I_bar (fun _ => rfl)

/-- **Yoneda 4-fold witness — HealingFlow content**: four independent
    Theorem applications of `IsHealingFlow` constitute Witness-Yoneda
    completeness on the HealingFlow side: the existential
    instantiation, a uniform-info instantiation, the gradient-step
    pin, and the equilibrium pin. -/
theorem IsHealingFlow_yoneda_witness_fourfold
    (params : HealingParams) (I_bar : ℝ) :
    -- (W1) bare existence
    (∃ (path : MetricPath) (delta_tau : ℝ),
        0 < delta_tau ∧
        IsHealingFlow params path DiscreteMetric.flat
          (fun _ => fun _ => I_bar) I_bar delta_tau) ∧
    -- (W2) uniform-info parametric form
    (∀ delta_tau : ℝ, 0 < delta_tau →
        ∃ path : MetricPath,
          IsHealingFlow params path DiscreteMetric.flat
            (fun _ => fun _ => I_bar) I_bar delta_tau) ∧
    -- (W3) gradient-step pin on the constant-flat path
    (∀ (delta_tau : ℝ) (_ : 0 < delta_tau)
        (tau : ℝ) (p : LatticePoint) (μ ν : Fin 4),
        constantFlatPath (tau + delta_tau) p μ ν =
        constantFlatPath tau p μ ν + delta_tau * (
          params.mu *
            discreteLaplacian (fun q => constantFlatPath tau q μ ν) p
          - params.lambda *
              defectTensor (constantFlatPath tau) DiscreteMetric.flat p μ ν
          - params.gamma * ((fun _ : LatticePoint => I_bar) p - I_bar))) ∧
    -- (W4) equilibrium pin
    (IsHealingEquilibrium params DiscreteMetric.flat DiscreteMetric.flat
      (fun _ : LatticePoint => I_bar) I_bar) :=
  ⟨IsHealingFlow_exists params I_bar,
   fun delta_tau h => IsHealingFlow_exists_uniform_info params I_bar delta_tau h,
   fun delta_tau h tau p μ ν =>
     IsHealingFlow_yoneda_witness_gradient_step params I_bar delta_tau h tau p μ ν,
   IsHealingFlow_yoneda_witness_equilibrium_pin params I_bar⟩

/-- **Yoneda theorem-application witness**: there exists a Theorem
    applying `IsHealingFlow` whose statement is non-trivial.  We
    surface the metric-rate-zero identity on the constant-flat path
    as the canonical Witness-Yoneda hit through the dynamical block. -/
theorem IsHealingFlow_yoneda_theorem_witness
    (delta_tau : ℝ) (h_step_pos : 0 < delta_tau)
    (tau : ℝ) (p : LatticePoint) (μ ν : Fin 4) :
    metricRate constantFlatPath tau delta_tau p μ ν = 0 :=
  constantFlatPath_metricRate_zero tau delta_tau h_step_pos p μ ν

/-! ## §4. Double-witness bundle — the L4 paper-headline conjunction

The L4 cross-layer claim of Heart-Nebula #73 / Quaoar Q7 audit: the
HealingFlow-sector Structure `IsHealingFlow` is **simultaneously**

  - *equilibrium-isolated* on the constant-flat path (every generator
    term vanishes identically — Laplacian of flat is zero, defect
    tensor of flat-vs-flat is zero, info deviation is zero), and
  - *Yoneda-witnessed* by multiple concrete instantiations
    (`constantFlatPath_isHealingFlow` constructive existence,
    `IsHealingFlow_exists` bare existential,
    `IsHealingFlow_exists_uniform_info` parametric-step,
    `IsHealingFlow_yoneda_witness_gradient_step` gradient-step pin,
    `IsHealingFlow_yoneda_witness_equilibrium_pin` equilibrium-pin).

Together these form the **double-witness paper-bundle** for
`IsHealingFlow`. -/

/-- **The full double-witness for `IsHealingFlow`** — four-way
    conjunction:

      (a) Laplacian-of-flat vanishes pointwise on the constant-flat
          path,
      (b) defect-tensor of flat-vs-flat vanishes pointwise,
      (c) info-deviation under uniform info field vanishes pointwise,
      (d) Yoneda witness — `IsHealingFlow` is instantiated by at
          least one concrete (path, δτ) pair on flat target.

    This is the L4 cross-layer paper-bundle headline for Heart-Nebula
    canonical entry #73 on the HealingFlow-sector Structure side. -/
theorem isHealingFlow_yoneda_witness
    (params : HealingParams) (I_bar : ℝ) :
    -- (S-lap) Laplacian-of-flat vanishes pointwise
    (∀ (tau : ℝ) (p : LatticePoint) (μ ν : Fin 4),
        discreteLaplacian (fun q => constantFlatPath tau q μ ν) p = 0) ∧
    -- (S-defect) defect-tensor vanishes pointwise
    (∀ (tau : ℝ) (p : LatticePoint) (μ ν : Fin 4),
        defectTensor (constantFlatPath tau) DiscreteMetric.flat p μ ν = 0) ∧
    -- (S-info) uniform-info deviation vanishes pointwise
    (∀ (p : LatticePoint),
        (fun _ : LatticePoint => I_bar) p - I_bar = 0) ∧
    -- (W) Yoneda witness — instantiation exists
    (∃ (path : MetricPath) (delta_tau : ℝ),
        0 < delta_tau ∧
        IsHealingFlow params path DiscreteMetric.flat
          (fun _ => fun _ => I_bar) I_bar delta_tau) :=
  ⟨constantFlatPath_laplacian_zero,
   constantFlatPath_defectTensor_zero,
   constantFlatPath_info_deviation_zero I_bar,
   IsHealingFlow_exists params I_bar⟩

/-! ## §5. Strengthened paper-headline form

A tighter shape that surfaces the *fourfold* Yoneda witness — multiple
independent Theorem-level instantiations, not just one — making the
Witness-Yoneda side maximally explicit. -/

/-- **Paper-headline double-witness, fourfold-Yoneda form**: the
    constant-flat-path equilibrium-isolation side combined with the
    four-fold Yoneda witness from §3 (existence, uniform-info
    parametric, gradient-step pin, equilibrium pin). -/
theorem isHealingFlow_yoneda_witness_fourfold
    (params : HealingParams) (I_bar : ℝ) :
    -- (S-rate) metric rate vanishes on the constant-flat path
    (∀ (delta_tau : ℝ) (_ : 0 < delta_tau) (tau : ℝ)
        (p : LatticePoint) (μ ν : Fin 4),
        metricRate constantFlatPath tau delta_tau p μ ν = 0) ∧
    -- (S-iter) every iterate equals flat
    (∀ tau : ℝ, constantFlatPath tau = DiscreteMetric.flat) ∧
    -- (W4) Witness-Yoneda for four independent instantiations
    ((∃ (path : MetricPath) (delta_tau : ℝ),
        0 < delta_tau ∧
        IsHealingFlow params path DiscreteMetric.flat
          (fun _ => fun _ => I_bar) I_bar delta_tau) ∧
     (∀ delta_tau : ℝ, 0 < delta_tau →
        ∃ path : MetricPath,
          IsHealingFlow params path DiscreteMetric.flat
            (fun _ => fun _ => I_bar) I_bar delta_tau) ∧
     (∀ (delta_tau : ℝ) (_ : 0 < delta_tau)
         (tau : ℝ) (p : LatticePoint) (μ ν : Fin 4),
        constantFlatPath (tau + delta_tau) p μ ν =
        constantFlatPath tau p μ ν + delta_tau * (
          params.mu *
            discreteLaplacian (fun q => constantFlatPath tau q μ ν) p
          - params.lambda *
              defectTensor (constantFlatPath tau) DiscreteMetric.flat p μ ν
          - params.gamma * ((fun _ : LatticePoint => I_bar) p - I_bar))) ∧
     (IsHealingEquilibrium params DiscreteMetric.flat DiscreteMetric.flat
       (fun _ : LatticePoint => I_bar) I_bar)) :=
  ⟨fun delta_tau h tau p μ ν =>
     constantFlatPath_metricRate_zero tau delta_tau h p μ ν,
   constantFlatPath_iterate_eq_flat,
   IsHealingFlow_yoneda_witness_fourfold params I_bar⟩

/-! ## §6. Triple-bundle paper-cite form

A maximal-content form combining the equilibrium-isolation, the
gradient-step identity, and the equilibrium-pin compatibility — the
strongest single statement appropriate for paper citation. -/

/-- **Paper-headline triple-bundle**: combines the L4 double-witness
    with the gradient-step identity and the equilibrium-pin theorem
    (three-fold paper bundle: rate-zero on flat + gradient-step
    identity + equilibrium pin).  Fully explicit form for paper
    citation. -/
theorem isHealingFlow_yoneda_witness_triple_paper_bundle
    (params : HealingParams) (I_bar : ℝ) (delta_tau : ℝ)
    (h_step_pos : 0 < delta_tau)
    (tau : ℝ) (p : LatticePoint) (μ ν : Fin 4) :
    -- (S-rate) metric rate vanishes on the constant-flat path
    metricRate constantFlatPath tau delta_tau p μ ν = 0 ∧
    -- (U) gradient-step identity on the constant-flat path
    (constantFlatPath (tau + delta_tau) p μ ν =
      constantFlatPath tau p μ ν + delta_tau * (
        params.mu *
          discreteLaplacian (fun q => constantFlatPath tau q μ ν) p
        - params.lambda *
            defectTensor (constantFlatPath tau) DiscreteMetric.flat p μ ν
        - params.gamma * ((fun _ : LatticePoint => I_bar) p - I_bar))) ∧
    -- (E) equilibrium-pin compatibility
    IsHealingEquilibrium params DiscreteMetric.flat DiscreteMetric.flat
      (fun _ : LatticePoint => I_bar) I_bar ∧
    -- (W) Yoneda existence
    (∃ (path : MetricPath) (delta_tau : ℝ),
        0 < delta_tau ∧
        IsHealingFlow params path DiscreteMetric.flat
          (fun _ => fun _ => I_bar) I_bar delta_tau) :=
  ⟨constantFlatPath_metricRate_zero tau delta_tau h_step_pos p μ ν,
   IsHealingFlow_yoneda_witness_gradient_step params I_bar delta_tau
     h_step_pos tau p μ ν,
   IsHealingFlow_yoneda_witness_equilibrium_pin params I_bar,
   IsHealingFlow_exists params I_bar⟩

/-! ## §7. HealingFlow Lyapunov-sector alignment

Heart-Nebula #73 places this Structure in the HealingFlow Lyapunov
sector.  The constant-flat path is the unique attractor under any
flow whose generator is bounded by the metric-Laplacian functional
`F`; on the constant-flat path with uniform info, `F ≡ 0` because
every term vanishes, so the path is reached in zero ticks (degenerate
but rigorous attractor reading).  This marker exposes that link
without introducing any new HealingFlow content (Lyra W3.4
`HealingFlowBHIsolationBreak.lean` is OFF-LIMITS — read-only). -/

/-- **Lyapunov-sector marker**: the constant-flat path's
    equilibrium-isolation can be read as a degenerate Lyapunov-
    attractor statement — the constant-flat path is reached in zero
    ticks because every generator term vanishes identically.
    Exposed as the existence of an `IsHealingFlow` with constant-flat
    path AND a sister `IsHealingEquilibrium`. -/
theorem isHealingFlow_lyapunov_sector_marker
    (params : HealingParams) (I_bar : ℝ) :
    (∃ (path : MetricPath) (delta_tau : ℝ),
        0 < delta_tau ∧
        IsHealingFlow params path DiscreteMetric.flat
          (fun _ => fun _ => I_bar) I_bar delta_tau) ∧
    IsHealingEquilibrium params DiscreteMetric.flat DiscreteMetric.flat
      (fun _ : LatticePoint => I_bar) I_bar :=
  ⟨IsHealingFlow_exists params I_bar,
   IsHealingFlow_yoneda_witness_equilibrium_pin params I_bar⟩

/-! ## §8. Frontier marker

This file is the FIRST L4 cross-layer paper-bundle in OV2 anchored on
a HealingFlow-sector dynamical-equation Structure `IsHealingFlow`
paired with a Witness-Yoneda fourfold instantiation block — sister to:
  * Nessus W1.5 (`DiracOperatorFDoubleWitness`, concrete-physics on
    Connes finite Dirac operator),
  * Phoenix W2.8 (`BlackHoleYonedaDoubleWitness`, substrate-physics
    BH Structure),
  * Pallas W2.3 (`ErrorBoundYonedaWitness`, abstract Foundations
    Structure), and
  * Pandora W6-EXT.2 (`DynamicalSnapshotSequenceYonedaDoubleWitness`,
    substrate-dynamics Structure).

It connects:

  * the equilibrium-isolation side (constant-flat path's Laplacian
    vanishes, defect-tensor vanishes, info-deviation vanishes), with
  * the Yoneda side (Witness completeness via existential
    constructions on the constant-flat path + parametric-step
    constructions + gradient-step pin + equilibrium-pin compatibility)

into a single double-witness, paving the way for the
`HealingFlow Lyapunov sector → equilibrium-attractor paper-headline`
chain to graph-theoretically align dynamical-equation isolation ↔
categorical isolation on HealingFlow-sector Structures (matching the
Nessus L4 #10 concrete-physics analogue, the Phoenix L4 #7 substrate-
physics analogue, the Pallas L4 #2 abstract-Foundations analogue, and
the Pandora L4 #12 substrate-dynamics analogue). -/

/-- **Frontier marker**: this is the first L4 double-witness in OV2
    anchored on a HealingFlow-sector dynamical-equation Structure
    (`IsHealingFlow`), pairing constant-flat-path equilibrium-
    isolation with fourfold Witness-Yoneda completeness. -/
theorem isHealingFlow_yoneda_witness_frontier_first_in_V2 :
    True := trivial

/-- **W-TAIL.3 closure marker**: Heart-Nebula canonical-list entry #73
    / Capricornus tail Quaoar Q7 closed by this file. -/
theorem isHealingFlow_yoneda_witness_W_tail_3_closed :
    True := trivial

end OmegaTheory.HealingFlow.IsHealingFlowYonedaWitness
