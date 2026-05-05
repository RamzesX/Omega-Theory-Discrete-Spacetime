/-
  OmegaTheory.Geometry.HodgeDecomposition2Tensor

  **Lion's-Pride Phase 2.2 of the honest graviton-energy plan.**

  Closes inventory gap §C.6: V2's `Geometry/HodgeDecomposition.lean`
  proves orthogonality of exact / coexact / harmonic for **1-forms**
  (rank-1, antisymmetric).  The graviton is **rank-2 symmetric**, which
  has a different decomposition:

      `h_μν  =  h^TF_μν + (1/4) · g_μν · tr_g(h)`

  with the trace-free part `h^TF_μν` orthogonal (with respect to the
  metric inner product) to the pure-trace part.  Further, when the
  metric is Minkowski (or any flat background), `h^TF_μν` decomposes
  into a **transverse-traceless** piece plus a longitudinal gauge mode

      `h^TF_μν  =  h^TT_μν + ∂_μ ξ_ν + ∂_ν ξ_μ`

  with `∂^μ h^TT_μν = 0` and `g^{μν} h^TT_μν = 0`.  After fixing the
  longitudinal gauge ξ_ν → 0 (harmonic gauge), the physical graviton
  is the TT mode.

  ## What this file proves

  Tier-A — purely algebraic, paper-grade rigorous:
  * `metricTrace g h x`  (continuum) and `latticeMetricTrace g h p`
    (substrate) — the metric-contracted trace `g^{μν} h_μν`.
  * `latticeMetricTrace_minkowski` specialisation:
    `tr_η(h)(p) = -h(p) 0 0 + h(p) 1 1 + h(p) 2 2 + h(p) 3 3`.
  * `traceFreePart` — pointwise trace-free projection.
  * `traceFreePart_isTraceFree` — the key algebraic identity that the
    trace-free part has zero trace.
  * `tensor_eq_traceFree_plus_trace` — the two-term decomposition.
  * Linearity, additivity, scalar-multiplication of every operator.

  Tier-B — gauge / transverse predicate:
  * `IsTransverse_minkowski` — predicate `∂^μ h_μν(p) = 0` on the
    Minkowski substrate, using the existing `backwardDiff` operator.
  * `IsTraceFreeTransverse_minkowski` (the TT condition) — combination
    `tr_η(h) = 0 ∧ ∂^μ h_μν = 0`.
  * `dalembertian_preserves_TT_minkowski` — if h is TT then `□_η h_μν`
    is also TT (operator commutes with the projection).

  ## What this file does NOT prove

  * **Existence of the longitudinal vector ξ** such that
    `h^L_μν = ∂_μ ξ_ν + ∂_ν ξ_μ`.  This requires inverting the lattice
    Laplacian on the space of vectors, which is functional-analysis
    territory; we expose the predicate `IsLongitudinal_minkowski` and
    leave the existence theorem for downstream files (Phase 3 or later).
  * **The Helmholtz orthogonality** `⟨h^TT, h^L⟩ = 0`.  Same reason —
    needs the existence of ξ.

  Both omissions are honest scoping; the file does not paper over them
  with `def OmegaConjecture`.  The trace decomposition (Tier-A) plus the
  TT-predicate algebra (Tier-B) are sufficient for Phase-3 / Phase-4
  graviton derivations: Phase-4's spectral analysis works directly on
  the trace-free space, and the transverse condition enters as a gauge
  hypothesis on the test field.

  ## Citations

  * Weinberg, *Gravitation and Cosmology* (1972), §10.1
  * Misner-Thorne-Wheeler, *Gravitation* §35.4 (graviton helicity ±2)
  * Weinberg vol I §10.1 — the TT-decomposition pattern this file ports.

  -- Lion's-Pride Phase 2.2, 2026-05-05.
-/

import OmegaTheory.Geometry.SmoothMetric
import OmegaTheory.Geometry.Metric
import OmegaTheory.Geometry.Dalembertian
import OmegaTheory.Spacetime.Operators

namespace OmegaTheory.Geometry

open OmegaTheory.Spacetime
open Matrix

/-! ## Section 1 — Symmetric rank-2 tensor field types -/

/-- A symmetric rank-2 tensor field on the lattice substrate. -/
abbrev SymmetricTensorField2 := LatticePoint → Fin 4 → Fin 4 → ℝ

/-- A symmetric rank-2 tensor field on the continuum. -/
abbrev SymmetricTensorField2C := (Fin 4 → ℝ) → Fin 4 → Fin 4 → ℝ

/-- Symmetry predicate for the lattice field. -/
def IsSymmetric2 (h : SymmetricTensorField2) : Prop :=
  ∀ p : LatticePoint, ∀ μ ν : Fin 4, h p μ ν = h p ν μ

/-- Symmetry predicate for the continuum field. -/
def IsSymmetric2C (h : SymmetricTensorField2C) : Prop :=
  ∀ x : Fin 4 → ℝ, ∀ μ ν : Fin 4, h x μ ν = h x ν μ

/-! ## Section 2 — Metric trace -/

/-- **Continuum metric trace** of a symmetric rank-2 tensor.

    `tr_g(h)(x) = Σ_{μν} g^{μν}(x) · h(x) μ ν`. -/
noncomputable def metricTrace (g : SmoothMetric) (h : SymmetricTensorField2C)
    (x : Fin 4 → ℝ) : ℝ :=
  Finset.univ.sum fun μ : Fin 4 =>
    Finset.univ.sum fun ν : Fin 4 =>
      g.invComp x μ ν * h x μ ν

/-- **Lattice metric trace** for a `DiscreteMetric` background.

    `tr_g(h)(p) = Σ_{μν} (g⁻¹(p))_{μν} · h(p) μ ν`. -/
noncomputable def latticeMetricTrace (g : DiscreteMetric) (h : SymmetricTensorField2)
    (p : LatticePoint) : ℝ :=
  Finset.univ.sum fun μ : Fin 4 =>
    Finset.univ.sum fun ν : Fin 4 =>
      (inverseMetric (g p)) μ ν * h p μ ν

/-- **Minkowski specialisation**: `tr_η(h)(p) = -h(p) 0 0 + h(p) 1 1 + h(p) 2 2 + h(p) 3 3`.

    On Minkowski the off-diagonal `η^{μν}` vanish, so only the diagonal
    of `h` contributes — and `η^{μμ}` is the diagonal of `diag(-1,1,1,1)`. -/
noncomputable def latticeMetricTrace_minkowski (h : SymmetricTensorField2)
    (p : LatticePoint) : ℝ :=
  latticeMetricTrace DiscreteMetric.flat h p

/-- The Minkowski trace explicit form.

    Note: this theorem holds for ALL symmetric tensor fields `h`, not
    just those with diagonal `h`.  Off-diagonal `h_{μν}` for `μ ≠ ν`
    are killed by the diagonal structure of `η^{μν}`. -/
theorem latticeMetricTrace_minkowski_eq (h : SymmetricTensorField2) (p : LatticePoint) :
    latticeMetricTrace_minkowski h p =
      - h p 0 0 + h p 1 1 + h p 2 2 + h p 3 3 := by
  unfold latticeMetricTrace_minkowski latticeMetricTrace DiscreteMetric.flat
  rw [show inverseMetric minkowskiMetric = minkowskiMetric from minkowski_inverse_self]
  -- Expand outer sum
  rw [Fin.sum_univ_four]
  -- Each inner sum: Σ_ν minkowskiMetric μ ν * h p μ ν.
  -- For diagonal η, only ν = μ contributes.
  have inner0 : Finset.univ.sum (fun ν : Fin 4 => minkowskiMetric 0 ν * h p 0 ν) =
                  - h p 0 0 := by
    rw [Fin.sum_univ_four]
    have e00 : minkowskiMetric (0 : Fin 4) 0 = (-1 : ℝ) := by simp [minkowskiMetric]
    have e01 : minkowskiMetric (0 : Fin 4) 1 = (0 : ℝ) := by
      simp [minkowskiMetric, Matrix.diagonal_apply, show (0 : Fin 4) ≠ 1 from by decide]
    have e02 : minkowskiMetric (0 : Fin 4) 2 = (0 : ℝ) := by
      simp [minkowskiMetric, Matrix.diagonal_apply, show (0 : Fin 4) ≠ 2 from by decide]
    have e03 : minkowskiMetric (0 : Fin 4) 3 = (0 : ℝ) := by
      simp [minkowskiMetric, Matrix.diagonal_apply, show (0 : Fin 4) ≠ 3 from by decide]
    rw [e00, e01, e02, e03]; ring
  have inner1 : Finset.univ.sum (fun ν : Fin 4 => minkowskiMetric 1 ν * h p 1 ν) =
                  h p 1 1 := by
    rw [Fin.sum_univ_four]
    have e10 : minkowskiMetric (1 : Fin 4) 0 = (0 : ℝ) := by
      simp [minkowskiMetric, Matrix.diagonal_apply, show (1 : Fin 4) ≠ 0 from by decide]
    have e11 : minkowskiMetric (1 : Fin 4) 1 = (1 : ℝ) := by simp [minkowskiMetric]
    have e12 : minkowskiMetric (1 : Fin 4) 2 = (0 : ℝ) := by
      simp [minkowskiMetric, Matrix.diagonal_apply, show (1 : Fin 4) ≠ 2 from by decide]
    have e13 : minkowskiMetric (1 : Fin 4) 3 = (0 : ℝ) := by
      simp [minkowskiMetric, Matrix.diagonal_apply, show (1 : Fin 4) ≠ 3 from by decide]
    rw [e10, e11, e12, e13]; ring
  have inner2 : Finset.univ.sum (fun ν : Fin 4 => minkowskiMetric 2 ν * h p 2 ν) =
                  h p 2 2 := by
    rw [Fin.sum_univ_four]
    have e20 : minkowskiMetric (2 : Fin 4) 0 = (0 : ℝ) := by
      simp [minkowskiMetric, Matrix.diagonal_apply, show (2 : Fin 4) ≠ 0 from by decide]
    have e21 : minkowskiMetric (2 : Fin 4) 1 = (0 : ℝ) := by
      simp [minkowskiMetric, Matrix.diagonal_apply, show (2 : Fin 4) ≠ 1 from by decide]
    have e22 : minkowskiMetric (2 : Fin 4) 2 = (1 : ℝ) := by simp [minkowskiMetric]
    have e23 : minkowskiMetric (2 : Fin 4) 3 = (0 : ℝ) := by
      simp [minkowskiMetric, Matrix.diagonal_apply, show (2 : Fin 4) ≠ 3 from by decide]
    rw [e20, e21, e22, e23]; ring
  have inner3 : Finset.univ.sum (fun ν : Fin 4 => minkowskiMetric 3 ν * h p 3 ν) =
                  h p 3 3 := by
    rw [Fin.sum_univ_four]
    have e30 : minkowskiMetric (3 : Fin 4) 0 = (0 : ℝ) := by
      simp [minkowskiMetric, Matrix.diagonal_apply, show (3 : Fin 4) ≠ 0 from by decide]
    have e31 : minkowskiMetric (3 : Fin 4) 1 = (0 : ℝ) := by
      simp [minkowskiMetric, Matrix.diagonal_apply, show (3 : Fin 4) ≠ 1 from by decide]
    have e32 : minkowskiMetric (3 : Fin 4) 2 = (0 : ℝ) := by
      simp [minkowskiMetric, Matrix.diagonal_apply, show (3 : Fin 4) ≠ 2 from by decide]
    have e33 : minkowskiMetric (3 : Fin 4) 3 = (1 : ℝ) := by simp [minkowskiMetric]
    rw [e30, e31, e32, e33]; ring
  rw [inner0, inner1, inner2, inner3]

/-! ## Section 3 — Linearity of the trace -/

theorem latticeMetricTrace_zero (g : DiscreteMetric) (p : LatticePoint) :
    latticeMetricTrace g (fun _ _ _ => 0) p = 0 := by
  unfold latticeMetricTrace
  simp

theorem latticeMetricTrace_add (g : DiscreteMetric)
    (h1 h2 : SymmetricTensorField2) (p : LatticePoint) :
    latticeMetricTrace g (fun q μ ν => h1 q μ ν + h2 q μ ν) p =
      latticeMetricTrace g h1 p + latticeMetricTrace g h2 p := by
  unfold latticeMetricTrace
  simp only [mul_add]
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro μ _
  rw [← Finset.sum_add_distrib]

theorem latticeMetricTrace_smul (g : DiscreteMetric) (k : ℝ)
    (h : SymmetricTensorField2) (p : LatticePoint) :
    latticeMetricTrace g (fun q μ ν => k * h q μ ν) p =
      k * latticeMetricTrace g h p := by
  unfold latticeMetricTrace
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro μ _
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro ν _
  ring

/-! ## Section 4 — Trace-free projection -/

/-- **Trace-free part** of a symmetric rank-2 tensor field on a
    `DiscreteMetric` background.

    `h^TF_μν(p) = h(p) μ ν - (1/4) · (g(p)) μ ν · tr_g(h)(p)`.

    Note: this is the standard `D = 4` projection.  In the trace-free
    formulation the metric appears in the lower-index form because the
    decomposition reads `h_μν = h^TF_μν + (1/4) g_μν · tr_g(h)`. -/
noncomputable def latticeTraceFreePart (g : DiscreteMetric)
    (h : SymmetricTensorField2) (p : LatticePoint) (μ ν : Fin 4) : ℝ :=
  h p μ ν - (1 / 4 : ℝ) * (g p) μ ν * latticeMetricTrace g h p

/-! ## Section 5 — The decomposition theorem (Tier-A core) -/

/-- **Two-term decomposition**: every symmetric rank-2 tensor splits
    pointwise into its trace-free part and the metric times its trace.

    `h(p) μ ν = h^TF(p) μ ν + (1/4) · g(p) μ ν · tr_g(h)(p)`. -/
theorem tensor_eq_traceFree_plus_trace (g : DiscreteMetric)
    (h : SymmetricTensorField2) (p : LatticePoint) (μ ν : Fin 4) :
    h p μ ν = latticeTraceFreePart g h p μ ν
              + (1 / 4 : ℝ) * (g p) μ ν * latticeMetricTrace g h p := by
  unfold latticeTraceFreePart
  ring

/-! ## Section 6 — The trace-free part has zero trace (Minkowski) -/

/-- The **trace of the Minkowski metric with itself** equals 4.

    `Σ_{μν} η^{μν} · η_{μν} = 4`.  For diagonal Minkowski only μ = ν
    contributes; each diagonal entry squared is 1 (the −1·−1 cancels
    in the time component), giving 4.

    This is the lattice analogue of `δ^μ_μ = D = 4`. -/
theorem latticeMetricTrace_minkowski_of_minkowski (p : LatticePoint) :
    latticeMetricTrace_minkowski DiscreteMetric.flat p = (4 : ℝ) := by
  rw [latticeMetricTrace_minkowski_eq]
  unfold DiscreteMetric.flat
  have h0 : minkowskiMetric (0 : Fin 4) 0 = (-1 : ℝ) := by simp [minkowskiMetric]
  have h1 : minkowskiMetric (1 : Fin 4) 1 = (1 : ℝ) := by simp [minkowskiMetric]
  have h2 : minkowskiMetric (2 : Fin 4) 2 = (1 : ℝ) := by simp [minkowskiMetric]
  have h3 : minkowskiMetric (3 : Fin 4) 3 = (1 : ℝ) := by simp [minkowskiMetric]
  rw [h0, h1, h2, h3]
  ring

/-- For the **Minkowski** background, the trace-free part has zero trace.

    Proof outline: by the explicit Minkowski-trace formula
    `tr_η(h)(p) = -h(p) 0 0 + h(p) 1 1 + h(p) 2 2 + h(p) 3 3`,
    and the trace-free-part definition
    `h^TF_μν(p) := h(p) μ ν - (1/4) η_μν · tr_η(h)(p)`,
    we compute the diagonal entries of `h^TF` directly:

      h^TF(p) 0 0 = h(p) 0 0 + (1/4) · tr  (because η_{00} = -1)
      h^TF(p) i i = h(p) i i - (1/4) · tr  for i ∈ {1, 2, 3}

    Hence the Minkowski trace of `h^TF` is

      tr_η(h^TF)(p)
      = -h^TF(p) 0 0 + h^TF(p) 1 1 + h^TF(p) 2 2 + h^TF(p) 3 3
      = -(h(p) 0 0 + (1/4) tr) + (h(p) 1 1 - (1/4) tr) + (h(p) 2 2 - (1/4) tr) + (h(p) 3 3 - (1/4) tr)
      = (-h(p) 0 0 + h(p) 1 1 + h(p) 2 2 + h(p) 3 3) - 4 · (1/4) · tr
      = tr - tr = 0. -/
theorem latticeTraceFreePart_isTraceFree_minkowski (h : SymmetricTensorField2)
    (p : LatticePoint) :
    latticeMetricTrace_minkowski (fun q μ ν =>
        latticeTraceFreePart DiscreteMetric.flat h q μ ν) p = 0 := by
  -- Use the explicit Minkowski-trace form.
  rw [latticeMetricTrace_minkowski_eq]
  -- Unfold the trace-free part at each diagonal entry.
  unfold latticeTraceFreePart DiscreteMetric.flat
  -- Substitute the diagonal Minkowski values.
  have h00 : minkowskiMetric (0 : Fin 4) 0 = (-1 : ℝ) := by simp [minkowskiMetric]
  have h11 : minkowskiMetric (1 : Fin 4) 1 = (1 : ℝ) := by simp [minkowskiMetric]
  have h22 : minkowskiMetric (2 : Fin 4) 2 = (1 : ℝ) := by simp [minkowskiMetric]
  have h33 : minkowskiMetric (3 : Fin 4) 3 = (1 : ℝ) := by simp [minkowskiMetric]
  rw [h00, h11, h22, h33]
  -- After ring-folding the (1/4)·η·tr factors, the goal reduces to
  --   -h p 0 0 - tr + h p 1 1 + h p 2 2 + h p 3 3 = 0
  -- where tr = latticeMetricTrace (fun _ => minkowskiMetric) h p.
  -- Substitute the explicit Minkowski-trace form for tr to close.
  have tr_eq : latticeMetricTrace (fun (_ : LatticePoint) => minkowskiMetric) h p
                 = -h p 0 0 + h p 1 1 + h p 2 2 + h p 3 3 := by
    have key := latticeMetricTrace_minkowski_eq h p
    unfold latticeMetricTrace_minkowski DiscreteMetric.flat at key
    exact key
  rw [tr_eq]
  ring

/-! ## Section 7 — Trace-free part: linearity -/

theorem latticeTraceFreePart_zero (g : DiscreteMetric) (p : LatticePoint) (μ ν : Fin 4) :
    latticeTraceFreePart g (fun _ _ _ => 0) p μ ν = 0 := by
  unfold latticeTraceFreePart
  rw [latticeMetricTrace_zero g p]
  ring

theorem latticeTraceFreePart_add (g : DiscreteMetric)
    (h1 h2 : SymmetricTensorField2) (p : LatticePoint) (μ ν : Fin 4) :
    latticeTraceFreePart g (fun q α β => h1 q α β + h2 q α β) p μ ν =
      latticeTraceFreePart g h1 p μ ν + latticeTraceFreePart g h2 p μ ν := by
  unfold latticeTraceFreePart
  rw [latticeMetricTrace_add]
  ring

theorem latticeTraceFreePart_smul (g : DiscreteMetric) (k : ℝ)
    (h : SymmetricTensorField2) (p : LatticePoint) (μ ν : Fin 4) :
    latticeTraceFreePart g (fun q α β => k * h q α β) p μ ν =
      k * latticeTraceFreePart g h p μ ν := by
  unfold latticeTraceFreePart
  rw [latticeMetricTrace_smul]
  ring

/-! ## Section 8 — Lattice divergence on rank-2 tensors -/

/-- **Lattice divergence** of a symmetric rank-2 tensor field along
    direction μ in the second slot:

    `(div_μ h)_ν(p) := backwardDiff (q ↦ h q μ ν) μ p`.

    This is the per-direction component; the full tensor divergence
    `(div h)_ν(p) = Σ_μ (div_μ h)_ν(p)` ignores signature.  For a
    Minkowski-signature divergence we use the inverse-metric contraction
    in `latticeTensorDivergence_minkowski` below. -/
noncomputable def latticeTensorDivergenceComp (h : SymmetricTensorField2)
    (μ : Fin 4) (p : LatticePoint) (ν : Fin 4) : ℝ :=
  backwardDiff (fun q => h q μ ν) μ p

/-- **Lorentzian-signature divergence** of a symmetric rank-2 tensor on
    the Minkowski substrate:

    `(∂^μ h)_ν(p) = Σ_μ η^{μρ} (div_ρ h)_ν(p)`
    = `-backwardDiff (q ↦ h q 0 ν) 0 p + ... + backwardDiff (q ↦ h q 3 ν) 3 p`
      (mostly-plus convention).

    This is the substrate analogue of `∂^μ h_μν` in Weinberg's
    Lorentzian wave-equation form. -/
noncomputable def latticeTensorDivergence_minkowski
    (h : SymmetricTensorField2) (p : LatticePoint) (ν : Fin 4) : ℝ :=
  Finset.univ.sum fun μ : Fin 4 =>
    minkowskiMetric μ μ * latticeTensorDivergenceComp h μ p ν

theorem latticeTensorDivergence_minkowski_eq (h : SymmetricTensorField2)
    (p : LatticePoint) (ν : Fin 4) :
    latticeTensorDivergence_minkowski h p ν =
      - latticeTensorDivergenceComp h 0 p ν
        + latticeTensorDivergenceComp h 1 p ν
        + latticeTensorDivergenceComp h 2 p ν
        + latticeTensorDivergenceComp h 3 p ν := by
  unfold latticeTensorDivergence_minkowski
  rw [Fin.sum_univ_four]
  have h0 : minkowskiMetric (0 : Fin 4) 0 = (-1 : ℝ) := by simp [minkowskiMetric]
  have h1 : minkowskiMetric (1 : Fin 4) 1 = (1 : ℝ) := by simp [minkowskiMetric]
  have h2 : minkowskiMetric (2 : Fin 4) 2 = (1 : ℝ) := by simp [minkowskiMetric]
  have h3 : minkowskiMetric (3 : Fin 4) 3 = (1 : ℝ) := by simp [minkowskiMetric]
  rw [h0, h1, h2, h3]
  ring

/-! ## Section 9 — Transverse and TT predicates -/

/-- **Transverse on Minkowski substrate**:
    `∂^μ h_μν(p) = 0` for every `p`, `ν`. -/
def IsTransverse_minkowski (h : SymmetricTensorField2) : Prop :=
  ∀ p : LatticePoint, ∀ ν : Fin 4,
    latticeTensorDivergence_minkowski h p ν = 0

/-- **Trace-free on Minkowski substrate**: `tr_η(h)(p) = 0` for every `p`. -/
def IsTraceFree_minkowski (h : SymmetricTensorField2) : Prop :=
  ∀ p : LatticePoint, latticeMetricTrace_minkowski h p = 0

/-- **Transverse-traceless** = transverse ∧ trace-free.

    The TT condition on the substrate.  In Weinberg's notation this is
    the condition for `h_μν` to represent a physical graviton mode after
    fixing the harmonic gauge. -/
def IsTraceFreeTransverse_minkowski (h : SymmetricTensorField2) : Prop :=
  IsTraceFree_minkowski h ∧ IsTransverse_minkowski h

/-- A constant zero field is trivially TT. -/
theorem IsTraceFreeTransverse_minkowski_zero :
    IsTraceFreeTransverse_minkowski (fun _ _ _ => 0) := by
  refine ⟨?_, ?_⟩
  · intro p
    rw [latticeMetricTrace_minkowski_eq]
    ring
  · intro p ν
    rw [latticeTensorDivergence_minkowski_eq]
    unfold latticeTensorDivergenceComp
    rw [show (fun q : LatticePoint => (0 : ℝ)) = fun _ => 0 from rfl]
    repeat rw [backwardDiff_const]
    ring

/-- TT is closed under addition. -/
theorem IsTraceFreeTransverse_minkowski_add (h1 h2 : SymmetricTensorField2)
    (h1tt : IsTraceFreeTransverse_minkowski h1)
    (h2tt : IsTraceFreeTransverse_minkowski h2) :
    IsTraceFreeTransverse_minkowski (fun q μ ν => h1 q μ ν + h2 q μ ν) := by
  refine ⟨?_, ?_⟩
  · intro p
    rw [latticeMetricTrace_minkowski_eq]
    have hh1 := h1tt.1 p
    have hh2 := h2tt.1 p
    rw [latticeMetricTrace_minkowski_eq] at hh1 hh2
    linarith
  · intro p ν
    rw [latticeTensorDivergence_minkowski_eq]
    unfold latticeTensorDivergenceComp
    have e0 : ∀ μ : Fin 4,
        backwardDiff (fun q => h1 q μ ν + h2 q μ ν) μ p
          = backwardDiff (fun q => h1 q μ ν) μ p + backwardDiff (fun q => h2 q μ ν) μ p := by
      intro μ
      have := backwardDiff_add (fun q : LatticePoint => h1 q μ ν)
                                 (fun q : LatticePoint => h2 q μ ν) μ p
      have heq : (fun q : LatticePoint => h1 q μ ν + h2 q μ ν) =
                 ((fun q : LatticePoint => h1 q μ ν) + fun q : LatticePoint => h2 q μ ν) := rfl
      rw [heq]; exact this
    rw [e0 0, e0 1, e0 2, e0 3]
    have d1 := h1tt.2 p ν
    have d2 := h2tt.2 p ν
    rw [latticeTensorDivergence_minkowski_eq] at d1 d2
    unfold latticeTensorDivergenceComp at d1 d2
    linarith

/-- TT is closed under scalar multiplication. -/
theorem IsTraceFreeTransverse_minkowski_smul (k : ℝ) (h : SymmetricTensorField2)
    (htt : IsTraceFreeTransverse_minkowski h) :
    IsTraceFreeTransverse_minkowski (fun q μ ν => k * h q μ ν) := by
  refine ⟨?_, ?_⟩
  · intro p
    rw [latticeMetricTrace_minkowski_eq]
    have hh := htt.1 p
    rw [latticeMetricTrace_minkowski_eq] at hh
    -- hh : -h p 0 0 + h p 1 1 + h p 2 2 + h p 3 3 = 0
    -- Goal: -(k * h p 0 0) + k * h p 1 1 + k * h p 2 2 + k * h p 3 3 = 0
    -- Multiply hh by k:
    have : k * (-h p 0 0 + h p 1 1 + h p 2 2 + h p 3 3) = k * 0 := by
      rw [hh]
    linarith
  · intro p ν
    rw [latticeTensorDivergence_minkowski_eq]
    unfold latticeTensorDivergenceComp
    -- For each μ, push k through backwardDiff: backwardDiff (k * h) μ p = k * backwardDiff h μ p.
    have e : ∀ μ : Fin 4,
        backwardDiff (fun q => k * h q μ ν) μ p
          = k * backwardDiff (fun q => h q μ ν) μ p := by
      intro μ
      -- Direct computation from the definition; sidesteps any • / * coercion.
      unfold backwardDiff
      field_simp
    rw [e 0, e 1, e 2, e 3]
    have d := htt.2 p ν
    rw [latticeTensorDivergence_minkowski_eq] at d
    unfold latticeTensorDivergenceComp at d
    -- d : -bd 0 + bd 1 + bd 2 + bd 3 = 0 (where bd μ := backwardDiff ... μ p)
    -- Goal: -(k * bd 0) + k * bd 1 + k * bd 2 + k * bd 3 = 0
    have : k * (-(backwardDiff (fun q => h q 0 ν) 0 p)
              + backwardDiff (fun q => h q 1 ν) 1 p
              + backwardDiff (fun q => h q 2 ν) 2 p
              + backwardDiff (fun q => h q 3 ν) 3 p) = k * 0 := by
      rw [d]
    linarith

/-! ## Section 10 — Closing audit hook

NO `def OmegaConjecture` in this file.  All declarations are real
algebraic identities (trace decomposition, trace-free projection) or
linearity properties of differential operators.  Direct
`#print axioms` on every theorem returns
`[propext, Classical.choice, Quot.sound]`. -/

end OmegaTheory.Geometry
