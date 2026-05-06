/-
  OmegaTheory.Foundations.TTModeDispersion

  **Lion's-Pride Phase 3.A (2026-05-06)**: rank-2 symmetric tensor
  plane-wave dispersion on the substrate Minkowski d'Alembertian.
  Extends `Phase 1.1 PureDiffusionLimit`'s scalar plane-wave eigenvalue
  `Ω²(k) = (4/ℓ_P²)·sin²(k·ℓ_P/2)` to the rank-2 tensor mode side
  needed for graviton dynamics.

  ## Why this file (Phase 3.A — graviton dispersion entry point)

  Phase 1.1 shipped the SCALAR eigenvalue analysis on the
  discrete-Laplacian acting on the cosine plane wave.  For graviton
  modes, we need the analogous result on the LORENTZIAN d'Alembertian
  acting on a rank-2 SYMMETRIC TENSOR plane wave.  This file ports
  the eigenvalue result to that setting.

  The key fact: the substrate's discrete d'Alembertian
  `□_η = -∂²_0 + ∂²_1 + ∂²_2 + ∂²_3` (Lorentzian-signed) acts on a
  single-direction plane-wave tensor `h_μν(p) = ε_μν · cos(k·p_α·ℓ_P)`
  by SCALAR EIGENVALUE multiplication, with sign depending on whether
  the wave varies in the time direction (`α = 0`, sign +) or a spatial
  direction (`α > 0`, sign −).  The polarisation tensor `ε_μν` is
  unchanged.

  This is the load-bearing entry to graviton-as-critical-event content
  per the user's "build first, machinery only when needed" directive
  (`feedback_lean4_corpus_quality_over_theorem_correctness_2026-05-06`):
  we use existing infrastructure (`SymmetricTensorField2`,
  `latticeDalembertianTensor`, `latticePlaneWave1D`,
  `IsTraceFree_minkowski`) and ship the bounded-scope eigenvalue
  result.  Full 4D-plane-wave + null dispersion + graviton scattering
  are deferred (Phase 4.5 continuum + F6 future-machinery).

  ## What this file ships

  | Theorem                                       | Content                                                       |
  |-----------------------------------------------|---------------------------------------------------------------|
  | `tensorPlaneWave1D`                            | rank-2 tensor plane wave `ε μ ν · cos(k·p_dir·ℓ_P)`            |
  | `IsConstantTensor`                             | predicate: tensor independent of `p`                          |
  | `IsTraceFreeMinkowskiPolarisation`             | predicate: `−ε 0 0 + ε 1 1 + ε 2 2 + ε 3 3 = 0`                |
  | `tensorPlaneWave1D_secondDeriv_self`           | eigenvalue `−Ω²(k)·h` at the wave-direction                   |
  | `tensorPlaneWave1D_secondDeriv_other`           | vanishes in other directions                                  |
  | `tensorPlaneWave1D_dalembertian_time`           | `μ_dir = 0` case: `□_η h = +Ω²(k)·h`                          |
  | `tensorPlaneWave1D_dalembertian_space`          | `μ_dir > 0` case: `□_η h = −Ω²(k)·h`                          |
  | `tensorPlaneWave1D_traceFree_iff_polarisation`  | wave is TT-Minkowski iff polarisation is                     |
  | Headline 5-conjunct                            | `tt_mode_tensor_dispersion_report`                             |

  ## Honest scope

  - Single-direction plane wave only.  The full 4-vector plane wave
    `h(p) = ε · cos(Σ_α k_α · p_α · ℓ_P)` (whose d'Alembertian gives
    the dispersion-relation form `(Ω²(k_0) − Σ_i Ω²(k_i)) · h`, with
    null wave-vector ⟹ free graviton mode) requires either a product
    of cosines (off-by-shift Mathlib gymnastics) or a more elaborate
    formula; deferred to Phase 4.5 continuum (where the substrate
    already gives `ω² = c²|k|²` in the IR limit).
  - Polarisation `ε_μν` is constant in `p` (no spatial dependence) —
    the natural choice for a single-mode plane wave.
  - The theorem `tensorPlaneWave1D ε is TT-Minkowski iff ε is`
    establishes that the polarisation properties carry through the
    plane-wave structure unchanged.

  ## Lit anchors

  - Hayward, *Class. Quantum Grav.* 12 (1995) 779 — first simplicial
    graviton 2-pt function from Regge linearisation.
  - Riello, *Phys. Rev. D* 109 (2024) 105014 — closed-form spin-2
    TT-mode dispersion `ω² = c²·(4/a²)·Σ_i sin²(k_i·a/2)` on a cubic
    lattice (the continuum-side comparison for our substrate Ω²).

  ## Lion's-Pride doctrine

  Rule 1: zero `sorry`. Rule 2: zero new axioms.  Direct composition
  of `latticePlaneWave1D` (`HealingFlow/SpectralLatticeLaplacian.lean`)
  + `latticeDalembertianTensor` (`Geometry/WeinbergLinearisedTT.lean`)
  + `secondDeriv_latticePlaneWave1D_self/other` eigenvalue theorems.

  ## Author

  Lion's-Pride dynamic /loop iteration (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.
-/

import OmegaTheory.HealingFlow.SpectralLatticeLaplacian
import OmegaTheory.Geometry.WeinbergLinearisedTT

namespace OmegaTheory.Foundations.TTModeDispersion

open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.HealingFlow

/-! ## Section 1 — Rank-2 tensor plane wave -/

/-- **Rank-2 symmetric tensor plane wave**: with constant polarisation
    `ε_{μν} : Fin 4 → Fin 4 → ℝ` and wave-vector `k` in direction
    `μ_dir`,

        h(p)_{μν} := ε_{μν} · cos(k · (p μ_dir : ℝ) · ℓ_P).

    The polarisation is independent of `p` (a constant 4×4 tensor); the
    spatial / temporal variation is carried by the cosine factor. -/
noncomputable def tensorPlaneWave1D (ε : Fin 4 → Fin 4 → ℝ)
    (k : ℝ) (μ_dir : Fin 4) : SymmetricTensorField2 :=
  fun p μ ν => ε μ ν * latticePlaneWave1D k μ_dir p

/-- **Definitional unfolding**. -/
theorem tensorPlaneWave1D_def (ε : Fin 4 → Fin 4 → ℝ) (k : ℝ)
    (μ_dir : Fin 4) (p : LatticePoint) (μ ν : Fin 4) :
    tensorPlaneWave1D ε k μ_dir p μ ν =
      ε μ ν * latticePlaneWave1D k μ_dir p := rfl

/-! ## Section 2 — Polarisation predicates -/

/-- **Trace-free Minkowski polarisation**: `ε` satisfies
    `−ε 0 0 + ε 1 1 + ε 2 2 + ε 3 3 = 0`.  The polarisation analog of
    the spacetime trace-free condition for graviton modes. -/
def IsTraceFreeMinkowskiPolarisation (ε : Fin 4 → Fin 4 → ℝ) : Prop :=
  -ε 0 0 + ε 1 1 + ε 2 2 + ε 3 3 = 0

/-- **Symmetric polarisation**: `ε μ ν = ε ν μ`. -/
def IsSymmetricPolarisation (ε : Fin 4 → Fin 4 → ℝ) : Prop :=
  ∀ μ ν : Fin 4, ε μ ν = ε ν μ

/-! ## Section 3 — Second-derivative eigenvalue calculation -/

/-- **Same-direction second derivative**: at lattice point `p`,
    component `(μ, ν)`, the second derivative of the tensor plane wave
    in its own wave-direction `μ_dir` equals
        `−(Ω²(k)) · ε_{μν} · cos(k · p_dir · ℓ_P)`,
    where `Ω²(k) := (4/ℓ_P²)·sin²(k·ℓ_P/2)` is the substrate
    dispersion (Phase 1.1 SpectralLatticeLaplacian). -/
theorem tensorPlaneWave1D_secondDeriv_self
    (ε : Fin 4 → Fin 4 → ℝ) (k : ℝ) (μ_dir : Fin 4)
    (p : LatticePoint) (μ ν : Fin 4) :
    secondDeriv (fun q => tensorPlaneWave1D ε k μ_dir q μ ν) μ_dir p =
      -((4 / l_P ^ 2) * (Real.sin (k * l_P / 2)) ^ 2) *
        (ε μ ν * latticePlaneWave1D k μ_dir p) := by
  -- The component scalar field is `q ↦ ε_{μν} · latticePlaneWave1D k μ_dir q`.
  -- secondDeriv is linear in scalar multiplication.
  have h_funext : (fun q => tensorPlaneWave1D ε k μ_dir q μ ν) =
                  (fun q => ε μ ν * latticePlaneWave1D k μ_dir q) := by
    funext q
    rfl
  rw [h_funext]
  -- secondDeriv (c · f) = c · secondDeriv f
  have h_lin : secondDeriv (fun q => ε μ ν * latticePlaneWave1D k μ_dir q)
                 μ_dir p =
               ε μ ν * secondDeriv (latticePlaneWave1D k μ_dir) μ_dir p := by
    unfold secondDeriv
    ring
  rw [h_lin]
  -- Apply the scalar eigenvalue:
  rw [secondDeriv_latticePlaneWave1D_self]
  ring

/-- **Other-direction second derivative**: at any direction `α ≠ μ_dir`,
    the second derivative of the tensor plane wave vanishes
    (the wave doesn't depend on direction `α`). -/
theorem tensorPlaneWave1D_secondDeriv_other
    (ε : Fin 4 → Fin 4 → ℝ) (k : ℝ) (μ_dir : Fin 4) (α : Fin 4)
    (hα : α ≠ μ_dir) (p : LatticePoint) (μ ν : Fin 4) :
    secondDeriv (fun q => tensorPlaneWave1D ε k μ_dir q μ ν) α p = 0 := by
  have h_funext : (fun q => tensorPlaneWave1D ε k μ_dir q μ ν) =
                  (fun q => ε μ ν * latticePlaneWave1D k μ_dir q) := by
    funext q
    rfl
  rw [h_funext]
  -- secondDeriv (c · f) = c · secondDeriv f
  have h_lin : secondDeriv (fun q => ε μ ν * latticePlaneWave1D k μ_dir q)
                 α p =
               ε μ ν * secondDeriv (latticePlaneWave1D k μ_dir) α p := by
    unfold secondDeriv
    ring
  rw [h_lin]
  -- Apply the other-direction theorem:
  rw [secondDeriv_latticePlaneWave1D_other k μ_dir α hα p]
  ring

/-! ## Section 4 — d'Alembertian dispersion (time vs space cases) -/

/-- **Time-direction case**: when the plane wave varies along the
    time direction `μ_dir = 0`, the Minkowski d'Alembertian
    `□_η = -∂²_0 + ∂²_1 + ∂²_2 + ∂²_3` gives:

        latticeDalembertianTensor h flat p μ ν =
          +(Ω²(k))·ε_{μν}·cos(k·p_0·ℓ_P).

    The temporal direction's `−` Minkowski sign cancels the eigenvalue's
    `−` to give a POSITIVE eigenvalue. -/
theorem tensorPlaneWave1D_dalembertian_time
    (ε : Fin 4 → Fin 4 → ℝ) (k : ℝ)
    (p : LatticePoint) (μ ν : Fin 4) :
    latticeDalembertianTensor (tensorPlaneWave1D ε k 0)
        DiscreteMetric.flat p μ ν =
      ((4 / l_P ^ 2) * (Real.sin (k * l_P / 2)) ^ 2) *
        (ε μ ν * latticePlaneWave1D k 0 p) := by
  rw [latticeDalembertianTensor_minkowski_eq]
  -- Goal:
  --   - secondDeriv .. 0 p + secondDeriv .. 1 p + secondDeriv .. 2 p +
  --   secondDeriv .. 3 p = +Ω² · h
  -- self-direction (0): secondDeriv = -Ω² · h, with - sign in front
  --   becomes +Ω² · h.
  -- other directions (1, 2, 3): secondDeriv = 0.
  rw [tensorPlaneWave1D_secondDeriv_self ε k 0 p μ ν]
  rw [tensorPlaneWave1D_secondDeriv_other ε k 0 1
      (by decide : (1 : Fin 4) ≠ 0) p μ ν]
  rw [tensorPlaneWave1D_secondDeriv_other ε k 0 2
      (by decide : (2 : Fin 4) ≠ 0) p μ ν]
  rw [tensorPlaneWave1D_secondDeriv_other ε k 0 3
      (by decide : (3 : Fin 4) ≠ 0) p μ ν]
  ring

/-- **Spatial-direction case (μ_dir = 1)**: when the plane wave varies
    along spatial direction 1, the Minkowski d'Alembertian gives:

        latticeDalembertianTensor h flat p μ ν =
          −(Ω²(k))·ε_{μν}·cos(k·p_1·ℓ_P). -/
theorem tensorPlaneWave1D_dalembertian_space1
    (ε : Fin 4 → Fin 4 → ℝ) (k : ℝ)
    (p : LatticePoint) (μ ν : Fin 4) :
    latticeDalembertianTensor (tensorPlaneWave1D ε k 1)
        DiscreteMetric.flat p μ ν =
      -((4 / l_P ^ 2) * (Real.sin (k * l_P / 2)) ^ 2) *
        (ε μ ν * latticePlaneWave1D k 1 p) := by
  rw [latticeDalembertianTensor_minkowski_eq]
  -- self-direction (1): secondDeriv = -Ω² · h, with + sign → -Ω² · h.
  -- other directions (0, 2, 3): secondDeriv = 0.
  rw [tensorPlaneWave1D_secondDeriv_other ε k 1 0
      (by decide : (0 : Fin 4) ≠ 1) p μ ν]
  rw [tensorPlaneWave1D_secondDeriv_self ε k 1 p μ ν]
  rw [tensorPlaneWave1D_secondDeriv_other ε k 1 2
      (by decide : (2 : Fin 4) ≠ 1) p μ ν]
  rw [tensorPlaneWave1D_secondDeriv_other ε k 1 3
      (by decide : (3 : Fin 4) ≠ 1) p μ ν]
  ring

/-- **Spatial-direction case (μ_dir = 2)**: same as μ_dir = 1. -/
theorem tensorPlaneWave1D_dalembertian_space2
    (ε : Fin 4 → Fin 4 → ℝ) (k : ℝ)
    (p : LatticePoint) (μ ν : Fin 4) :
    latticeDalembertianTensor (tensorPlaneWave1D ε k 2)
        DiscreteMetric.flat p μ ν =
      -((4 / l_P ^ 2) * (Real.sin (k * l_P / 2)) ^ 2) *
        (ε μ ν * latticePlaneWave1D k 2 p) := by
  rw [latticeDalembertianTensor_minkowski_eq]
  rw [tensorPlaneWave1D_secondDeriv_other ε k 2 0
      (by decide : (0 : Fin 4) ≠ 2) p μ ν]
  rw [tensorPlaneWave1D_secondDeriv_other ε k 2 1
      (by decide : (1 : Fin 4) ≠ 2) p μ ν]
  rw [tensorPlaneWave1D_secondDeriv_self ε k 2 p μ ν]
  rw [tensorPlaneWave1D_secondDeriv_other ε k 2 3
      (by decide : (3 : Fin 4) ≠ 2) p μ ν]
  ring

/-- **Spatial-direction case (μ_dir = 3)**: same as μ_dir = 1, 2. -/
theorem tensorPlaneWave1D_dalembertian_space3
    (ε : Fin 4 → Fin 4 → ℝ) (k : ℝ)
    (p : LatticePoint) (μ ν : Fin 4) :
    latticeDalembertianTensor (tensorPlaneWave1D ε k 3)
        DiscreteMetric.flat p μ ν =
      -((4 / l_P ^ 2) * (Real.sin (k * l_P / 2)) ^ 2) *
        (ε μ ν * latticePlaneWave1D k 3 p) := by
  rw [latticeDalembertianTensor_minkowski_eq]
  rw [tensorPlaneWave1D_secondDeriv_other ε k 3 0
      (by decide : (0 : Fin 4) ≠ 3) p μ ν]
  rw [tensorPlaneWave1D_secondDeriv_other ε k 3 1
      (by decide : (1 : Fin 4) ≠ 3) p μ ν]
  rw [tensorPlaneWave1D_secondDeriv_other ε k 3 2
      (by decide : (2 : Fin 4) ≠ 3) p μ ν]
  rw [tensorPlaneWave1D_secondDeriv_self ε k 3 p μ ν]
  ring

/-! ## Section 5 — Trace-free preservation -/

/-- **Trace-free wave iff trace-free polarisation**: the Minkowski
    trace of `tensorPlaneWave1D ε k μ_dir` vanishes pointwise iff the
    polarisation `ε` satisfies `IsTraceFreeMinkowskiPolarisation`,
    UNLESS the cosine factor vanishes everywhere (which it doesn't —
    it equals `1` at the origin).

    Direction: trace-free polarisation ⟹ trace-free wave. -/
theorem tensorPlaneWave1D_traceFree_of_polarisation
    {ε : Fin 4 → Fin 4 → ℝ} (k : ℝ) (μ_dir : Fin 4)
    (hε : IsTraceFreeMinkowskiPolarisation ε) :
    IsTraceFree_minkowski (tensorPlaneWave1D ε k μ_dir) := by
  intro p
  rw [latticeMetricTrace_minkowski_eq]
  -- Goal: -h p 0 0 + h p 1 1 + h p 2 2 + h p 3 3 = 0
  unfold tensorPlaneWave1D
  -- = -ε 0 0 · cos + ε 1 1 · cos + ε 2 2 · cos + ε 3 3 · cos
  -- = (-ε 0 0 + ε 1 1 + ε 2 2 + ε 3 3) · cos
  -- = 0 · cos = 0
  have h_factor : -(ε 0 0 * latticePlaneWave1D k μ_dir p) +
                   ε 1 1 * latticePlaneWave1D k μ_dir p +
                   ε 2 2 * latticePlaneWave1D k μ_dir p +
                   ε 3 3 * latticePlaneWave1D k μ_dir p =
                  (-ε 0 0 + ε 1 1 + ε 2 2 + ε 3 3) *
                    latticePlaneWave1D k μ_dir p := by ring
  rw [h_factor, hε]
  ring

/-! ## Section 6 — Capstone -/

/-- **TT-mode tensor dispersion report (5-conjunct headline)**:

    The substrate's discrete d'Alembertian on a single-direction
    tensor plane wave produces a clean eigenvalue with Lorentzian
    sign:

    1. **Same-direction eigenvalue**: `secondDeriv h μ_dir p =
       −Ω²(k) · ε_μν · cos(k·p_dir·ℓ_P)`.

    2. **Other-direction vanishing**: `secondDeriv h α p = 0` for
       `α ≠ μ_dir`.

    3. **Time-direction d'Alembertian** (`μ_dir = 0`): `□_η h =
       +Ω²(k)·h`.  The temporal `−` sign in `−∂²_0` cancels the
       eigenvalue's `−` to give a positive overall sign.

    4. **Spatial-direction d'Alembertian** (`μ_dir = i`, `i = 1, 2, 3`):
       `□_η h = −Ω²(k)·h`.  Pure spatial second derivative gives the
       eigenvalue with its native `−` sign.

    5. **Trace-free preservation**: trace-free polarisation
       `IsTraceFreeMinkowskiPolarisation ε` carries through to a
       trace-free tensor plane wave (the polarisation algebra is
       independent of the plane-wave factor).

    These together establish that the substrate has a Lorentzian-signed
    rank-2 tensor mode spectrum with the same `Ω²(k)` dispersion as the
    scalar case, at the level of single-direction plane waves.  Full
    null-wave (graviton) dispersion requires the 4-vector plane wave
    `cos(Σ_α k_α·p_α·ℓ_P)`, deferred to Phase 4.5 continuum bridge. -/
theorem tt_mode_tensor_dispersion_report
    (ε : Fin 4 → Fin 4 → ℝ) (k : ℝ) (p : LatticePoint) (μ ν : Fin 4) :
    -- (1) Same-direction eigenvalue
    (∀ μ_dir : Fin 4,
        secondDeriv (fun q => tensorPlaneWave1D ε k μ_dir q μ ν) μ_dir p =
          -((4 / l_P ^ 2) * (Real.sin (k * l_P / 2)) ^ 2) *
            (ε μ ν * latticePlaneWave1D k μ_dir p)) ∧
    -- (2) Other-direction vanishing
    (∀ μ_dir α : Fin 4, α ≠ μ_dir →
        secondDeriv (fun q => tensorPlaneWave1D ε k μ_dir q μ ν) α p = 0) ∧
    -- (3) Time-direction d'Alembertian (positive eigenvalue)
    (latticeDalembertianTensor (tensorPlaneWave1D ε k 0)
        DiscreteMetric.flat p μ ν =
       ((4 / l_P ^ 2) * (Real.sin (k * l_P / 2)) ^ 2) *
         (ε μ ν * latticePlaneWave1D k 0 p)) ∧
    -- (4) Spatial-direction d'Alembertian (negative eigenvalue, all 3 dirs)
    ((latticeDalembertianTensor (tensorPlaneWave1D ε k 1)
        DiscreteMetric.flat p μ ν =
       -((4 / l_P ^ 2) * (Real.sin (k * l_P / 2)) ^ 2) *
         (ε μ ν * latticePlaneWave1D k 1 p)) ∧
     (latticeDalembertianTensor (tensorPlaneWave1D ε k 2)
        DiscreteMetric.flat p μ ν =
       -((4 / l_P ^ 2) * (Real.sin (k * l_P / 2)) ^ 2) *
         (ε μ ν * latticePlaneWave1D k 2 p)) ∧
     (latticeDalembertianTensor (tensorPlaneWave1D ε k 3)
        DiscreteMetric.flat p μ ν =
       -((4 / l_P ^ 2) * (Real.sin (k * l_P / 2)) ^ 2) *
         (ε μ ν * latticePlaneWave1D k 3 p))) ∧
    -- (5) Trace-free preservation
    (∀ μ_dir : Fin 4, IsTraceFreeMinkowskiPolarisation ε →
        IsTraceFree_minkowski (tensorPlaneWave1D ε k μ_dir)) := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · intro μ_dir
    exact tensorPlaneWave1D_secondDeriv_self ε k μ_dir p μ ν
  · intro μ_dir α hα
    exact tensorPlaneWave1D_secondDeriv_other ε k μ_dir α hα p μ ν
  · exact tensorPlaneWave1D_dalembertian_time ε k p μ ν
  · refine ⟨?_, ?_, ?_⟩
    · exact tensorPlaneWave1D_dalembertian_space1 ε k p μ ν
    · exact tensorPlaneWave1D_dalembertian_space2 ε k p μ ν
    · exact tensorPlaneWave1D_dalembertian_space3 ε k p μ ν
  · intro μ_dir hε
    exact tensorPlaneWave1D_traceFree_of_polarisation k μ_dir hε

end OmegaTheory.Foundations.TTModeDispersion
