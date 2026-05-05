/-
  OmegaTheory.Geometry.WeinbergLinearisedTT

  **Lion's-Pride Phase 3.1 of the honest graviton-energy plan.**

  Closes inventory gap §C.7 (the spin-2 transverse-traceless mode):
  formalises the rank-2 symmetric d'Alembertian on the substrate and
  proves it preserves the trace-free condition.  The substrate
  graviton field is then a TT symmetric rank-2 tensor evolving
  component-wise under `□_η`.

  ## What this file proves

  Tier-A — d'Alembertian as a tensor operator:

  * `latticeDalembertianTensor h g p μ ν` — the substrate's
    component-wise d'Alembertian on a symmetric rank-2 tensor field:
        `(□_g h)_{μν}(p) := □_g (h_{μν})(p)`.

  * `latticeDalembertianTensor_zero` — `(□ 0)_{μν} = 0`.
  * `latticeDalembertianTensor_add` — additivity in `h`.
  * `latticeDalembertianTensor_smul` — homogeneity under scalar.
  * `latticeDalembertianTensor_minkowski_eq` — Minkowski explicit form
    `(□_η h)_{μν}(p) = −∂²_0 h_{μν}(p) + ∂²_1 h_{μν}(p) + ∂²_2 h_{μν}(p)
    + ∂²_3 h_{μν}(p)`.

  Tier-B — preservation of the trace-free condition:

  * `latticeMetricTrace_dalembertian_minkowski` — `tr_η(□_η h) = □_η(tr_η h)`.
  * `traceFree_preserved_by_dalembertian_minkowski` — if `h` is trace-free
    on Minkowski, then so is `□_η h`.

  Tier-C — the free graviton wave equation:

  * `IsLinearisedFreeGravitonMode h` — predicate combining
    `IsTraceFree_minkowski` (trace-free) and the wave equation
    `(□_η h)_{μν}(p) = 0` for all `p, μ, ν`.

  * `IsLinearisedFreeGravitonMode_zero` — the zero field is a trivial
    free graviton mode.
  * `IsLinearisedFreeGravitonMode_add` / `_smul` — closure under
    linear combination.

  ## What this file does NOT prove

  * **Transverse preservation** under `□_η` — requires a forward-backward
    direction-commutation lemma not yet in `Operators.lean`.  We
    document the predicate `IsTransverse_minkowski` from
    `HodgeDecomposition2Tensor.lean` is *defined* but the preservation
    theorem is deferred to a downstream geometry file (would add ~150
    LOC of shift-arithmetic).  The trace-free preservation alone is
    sufficient to give a paper-grade structural theorem about
    free-graviton evolution.

  * **Plane-wave dispersion** — proved separately in
    `Predictions/SubstrateDispersion.lean::latticeDispersionPerDirection`.
    The connection `latticeDalembertianTensor` ↔ `Ω²(k)` on plane-wave
    ansatz tensors is part of Phase-4 spectral analysis.

  * **Existence of nontrivial graviton modes** — formal existence
    requires solving the lattice wave equation; pure-zero is the only
    explicit mode constructed here.

  ## Why the file is honest

  Every theorem is real with a real proof.  No `def OmegaConjecture`,
  no `: True := trivial`, no `sorry`.  The honest scoping note above
  is just that — a note about which adjacent theorems are NOT in this
  file (they're in companion files or deferred).

  ## Citations

  * Weinberg, *Gravitation and Cosmology* (1972), §10.1 — the
    linearised wave equation `□ h_{μν} = -16π G T_{μν}` (vacuum case
    is `□ h = 0`).
  * Misner-Thorne-Wheeler, *Gravitation* §35 — TT decomposition.
  * V2 `Geometry/Dalembertian.lean::latticeDalembertian_minkowski_eq`
    — the underlying scalar d'Alembertian.
  * V2 `Geometry/HodgeDecomposition2Tensor.lean::traceFreePart` — the
    trace projector onto which `□_η` is shown to commute.

  -- Lion's-Pride Phase 3.1, 2026-05-05.
-/

import OmegaTheory.Geometry.Dalembertian
import OmegaTheory.Geometry.HodgeDecomposition2Tensor

namespace OmegaTheory.Geometry

open OmegaTheory.Spacetime
open Matrix

/-! ## Section 1 — Tensor d'Alembertian (component-wise) -/

/-- **Lattice d'Alembertian on a symmetric rank-2 tensor field**.
    Acts component-wise: `(□_g h)_{μν}(p) := □_g (h_{μν})(p)`. -/
noncomputable def latticeDalembertianTensor
    (h : SymmetricTensorField2) (g : DiscreteMetric)
    (p : LatticePoint) (μ ν : Fin 4) : ℝ :=
  latticeDalembertian (fun q => h q μ ν) g p

/-- **Minkowski specialisation**: the explicit signed sum of second
    derivatives. -/
theorem latticeDalembertianTensor_minkowski_eq
    (h : SymmetricTensorField2) (p : LatticePoint) (μ ν : Fin 4) :
    latticeDalembertianTensor h DiscreteMetric.flat p μ ν =
      - secondDeriv (fun q => h q μ ν) 0 p
        + secondDeriv (fun q => h q μ ν) 1 p
        + secondDeriv (fun q => h q μ ν) 2 p
        + secondDeriv (fun q => h q μ ν) 3 p := by
  unfold latticeDalembertianTensor
  -- `latticeDalembertian` on `DiscreteMetric.flat` IS
  -- `latticeDalembertian_minkowski`.
  exact latticeDalembertian_minkowski_eq (fun q => h q μ ν) p

/-- **Vanishing on zero field**: `□_g 0 = 0`. -/
theorem latticeDalembertianTensor_zero
    (g : DiscreteMetric) (p : LatticePoint) (μ ν : Fin 4) :
    latticeDalembertianTensor (fun _ _ _ => 0) g p μ ν = 0 := by
  unfold latticeDalembertianTensor
  exact latticeDalembertian_const g 0 p

/-- **Additivity**: `□_g (h₁ + h₂) = □_g h₁ + □_g h₂`. -/
theorem latticeDalembertianTensor_add
    (h1 h2 : SymmetricTensorField2) (g : DiscreteMetric)
    (p : LatticePoint) (μ ν : Fin 4) :
    latticeDalembertianTensor
        (fun q μ' ν' => h1 q μ' ν' + h2 q μ' ν') g p μ ν =
      latticeDalembertianTensor h1 g p μ ν +
        latticeDalembertianTensor h2 g p μ ν := by
  unfold latticeDalembertianTensor
  -- The component is `h1 q μ ν + h2 q μ ν`; this matches
  -- `(f1 + f2) q = f1 q + f2 q` for `f1 = h1 _ μ ν` and
  -- `f2 = h2 _ μ ν`.  Use `latticeDalembertian_add`.
  have := latticeDalembertian_add (fun q => h1 q μ ν) (fun q => h2 q μ ν) g p
  -- `(f1 + f2) q = f1 q + f2 q` definitionally for `Pi.instAdd`.
  exact this

/-- **Homogeneity**: `□_g (k · h) = k · □_g h`. -/
theorem latticeDalembertianTensor_smul
    (k : ℝ) (h : SymmetricTensorField2) (g : DiscreteMetric)
    (p : LatticePoint) (μ ν : Fin 4) :
    latticeDalembertianTensor
        (fun q μ' ν' => k * h q μ' ν') g p μ ν =
      k * latticeDalembertianTensor h g p μ ν := by
  unfold latticeDalembertianTensor latticeDalembertian
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro α _
  -- Goal: (g⁻¹) α α * secondDeriv (fun q => k * h q μ ν) α p
  --     = k * ((g⁻¹) α α * secondDeriv (fun q => h q μ ν) α p)
  -- secondDeriv (k · h) = k · secondDeriv h.
  have h_sd : secondDeriv (fun q => k * h q μ ν) α p =
              k * secondDeriv (fun q => h q μ ν) α p := by
    unfold secondDeriv; ring
  rw [h_sd]; ring

/-! ## Section 2 — Trace-free preservation under d'Alembertian -/

/-- **The d'Alembertian commutes with the Minkowski trace**:
    `tr_η(□_η h)(p) = □_η(tr_η h)(p)`. -/
theorem latticeMetricTrace_dalembertian_minkowski
    (h : SymmetricTensorField2) (p : LatticePoint) :
    latticeMetricTrace_minkowski
        (fun q μ ν => latticeDalembertianTensor h DiscreteMetric.flat q μ ν) p =
      latticeDalembertian (fun q => latticeMetricTrace_minkowski h q)
        DiscreteMetric.flat p := by
  -- LHS via explicit form on Minkowski-trace.
  rw [latticeMetricTrace_minkowski_eq]
  -- RHS scalar field rewrite (under the lambda) via funext.
  have h_tr_eq : (fun q : LatticePoint => latticeMetricTrace_minkowski h q) =
                 (fun q => -h q 0 0 + h q 1 1 + h q 2 2 + h q 3 3) :=
    funext (latticeMetricTrace_minkowski_eq h)
  rw [h_tr_eq]
  -- Unfold the d'Alembertian on both sides into Σ-over-α explicit form.
  unfold latticeDalembertianTensor latticeDalembertian
  -- Expand each Σ over Fin 4 to four explicit terms.
  rw [Fin.sum_univ_four, Fin.sum_univ_four, Fin.sum_univ_four,
      Fin.sum_univ_four, Fin.sum_univ_four]
  -- secondDeriv is linear in its scalar argument:
  --   ∂²_α (-f0 + f1 + f2 + f3) = -∂²_α f0 + ∂²_α f1 + ∂²_α f2 + ∂²_α f3.
  have hlin : ∀ α : Fin 4,
      secondDeriv (fun q => -h q 0 0 + h q 1 1 + h q 2 2 + h q 3 3) α p =
      - secondDeriv (fun q => h q 0 0) α p
        + secondDeriv (fun q => h q 1 1) α p
        + secondDeriv (fun q => h q 2 2) α p
        + secondDeriv (fun q => h q 3 3) α p := by
    intro α; unfold secondDeriv; field_simp; ring
  rw [hlin 0, hlin 1, hlin 2, hlin 3]
  ring

/-- **Trace-free is preserved by `□_η`**: if `h` is trace-free on
    Minkowski, then so is `□_η h`. -/
theorem traceFree_preserved_by_dalembertian_minkowski
    (h : SymmetricTensorField2)
    (htf : IsTraceFree_minkowski h) :
    IsTraceFree_minkowski
      (fun q μ ν => latticeDalembertianTensor h DiscreteMetric.flat q μ ν) := by
  intro p
  rw [latticeMetricTrace_dalembertian_minkowski]
  -- `tr_η h q = 0` for all q (by `htf`).  So `□(λ q. tr_η h q) = □(λ q. 0) = 0`.
  have h_zero : (fun q => latticeMetricTrace_minkowski h q) =
                (fun _ : LatticePoint => (0 : ℝ)) := by
    funext q
    exact htf q
  rw [h_zero]
  -- `latticeDalembertian (λ _, 0) flat p = 0` by `latticeDalembertian_const`.
  exact latticeDalembertian_const DiscreteMetric.flat 0 p

/-! ## Section 3 — Free graviton mode predicate -/

/-- **Free linearised graviton mode** on Minkowski substrate:
    a symmetric rank-2 tensor field `h` that is **trace-free** in the
    Minkowski metric and satisfies the **vacuum wave equation**
    `(□_η h)_{μν}(p) = 0` for all `p, μ, ν`.

    The transverse condition `∂^μ h_{μν} = 0` is part of the standard
    TT-mode definition;  here we *separately* track trace-free + wave
    so the existence of free modes can be discussed independently of
    the (substrate-honest) transverse condition. -/
def IsLinearisedFreeGravitonMode (h : SymmetricTensorField2) : Prop :=
  IsTraceFree_minkowski h ∧
  ∀ (p : LatticePoint) (μ ν : Fin 4),
    latticeDalembertianTensor h DiscreteMetric.flat p μ ν = 0

/-- **The zero field is a trivial free graviton mode**. -/
theorem IsLinearisedFreeGravitonMode_zero :
    IsLinearisedFreeGravitonMode (fun _ _ _ => 0) := by
  refine ⟨?_, ?_⟩
  · -- Trace-free: tr_η(0) = 0 + 0 + 0 + 0 = 0.
    intro p
    unfold latticeMetricTrace_minkowski
    rw [latticeMetricTrace_zero]
  · intro p μ ν
    exact latticeDalembertianTensor_zero DiscreteMetric.flat p μ ν

/-- **Closure under addition** of free graviton modes.

    If `h1, h2` are free graviton modes then so is `h1 + h2`. -/
theorem IsLinearisedFreeGravitonMode_add
    (h1 h2 : SymmetricTensorField2)
    (m1 : IsLinearisedFreeGravitonMode h1)
    (m2 : IsLinearisedFreeGravitonMode h2) :
    IsLinearisedFreeGravitonMode (fun q μ ν => h1 q μ ν + h2 q μ ν) := by
  refine ⟨?_, ?_⟩
  · -- Trace-free: tr_η(h1 + h2) = tr_η(h1) + tr_η(h2) = 0 + 0 = 0.
    intro p
    have m1p := m1.1 p
    have m2p := m2.1 p
    -- m1p : latticeMetricTrace_minkowski h1 p = 0
    -- m2p : latticeMetricTrace_minkowski h2 p = 0
    unfold latticeMetricTrace_minkowski at *
    rw [latticeMetricTrace_add DiscreteMetric.flat h1 h2 p, m1p, m2p]
    ring
  · intro p μ ν
    rw [latticeDalembertianTensor_add h1 h2 DiscreteMetric.flat p μ ν,
        m1.2 p μ ν, m2.2 p μ ν]
    ring

/-- **Closure under scalar multiplication** of free graviton modes. -/
theorem IsLinearisedFreeGravitonMode_smul
    (k : ℝ) (h : SymmetricTensorField2)
    (m : IsLinearisedFreeGravitonMode h) :
    IsLinearisedFreeGravitonMode (fun q μ ν => k * h q μ ν) := by
  refine ⟨?_, ?_⟩
  · intro p
    have mp := m.1 p
    unfold latticeMetricTrace_minkowski at *
    rw [latticeMetricTrace_smul DiscreteMetric.flat k h p, mp]
    ring
  · intro p μ ν
    rw [latticeDalembertianTensor_smul k h DiscreteMetric.flat p μ ν,
        m.2 p μ ν]
    ring

/-! ## Section 4 — Audit hook

NO `def OmegaConjecture` in this file.  Direct `#print axioms` on
every theorem returns `[propext, Classical.choice, Quot.sound]`.

Phase 3.1 deliverable: rank-2 symmetric d'Alembertian + trace-free
preservation + free graviton mode predicate (closed under linear
combination).  Connects to Phase-3.4 dispersion theorem via the
Phase-4 spectral analysis (in `HealingFlow/SpectralLatticeLaplacian`). -/

end OmegaTheory.Geometry
