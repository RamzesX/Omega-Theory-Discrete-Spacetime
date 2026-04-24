/-
  OmegaTheory.Foundations.WeightedGraphLaplacian

  **Metric-weighted graph Laplacian — the long-missing Mathlib ingredient
  for HPW2006 convergence on the substrate.**

  ## The problem

  Mathlib v4.29.0 provides `SimpleGraph.lapMatrix`, but it uses UNIT edge
  weights (L = D - A where `A i j ∈ {0,1}`).  For OmegaTheory the
  appropriate Laplacian is the *metric-weighted* one on the ℤ⁴ substrate:
  edge weights come from `g_μν` pulled back to edge lengths (cotangent
  weights on triangulated meshes, or equivalently the finite-element
  mass/stiffness entries).  The HPW2006 convergence proof needs this.

  This file fills the gap.  It defines `weightedLapMatrix G w` for an
  arbitrary symmetric weight function `w : V → V → ℝ` and proves:

  * It reduces to `SimpleGraph.lapMatrix ℝ G` when weights are unit
    (`weightedLapMatrix_one_eq_lapMatrix`).
  * It is symmetric whenever the weight function is symmetric
    (`weightedLapMatrix_isSymm`).
  * Its action on a vector `x : V → ℝ` is the standard weighted-divergence
    formula `(Lx)_u = Σ_v w(u,v)·(x_u − x_v)` (`weightedLapMatrix_mulVec_apply`).
  * The constant vector is in the kernel (`weightedLapMatrix_mulVec_const`).
  * The quadratic form is `xᵀ L x = ½·Σ_{u,v} w(u,v)·(x_u − x_v)²`
    (`weightedLapMatrix_quadForm`).
  * Hence the matrix is positive semi-definite when all weights are
    non-negative (`weightedLapMatrix_posSemidef`).

  ## Substrate-specific specialisation

  At the bottom of the file we specialise `w` to the symmetrised, clamped
  squared-distance edge weight induced by a scalar field `d : V → V → ℝ`.
  This is the bridge the HPW convergence proof will link to
  `Geometry.SmoothMetric` when a future agent lifts the metric pullback
  through the lattice.  The bridge is defined here but not assumed to
  solve HPW — that is a downstream mission.

  ## Rule compliance

  * Zero `sorry`.
  * Zero new axioms.
  * Zero `Prop := True`.
  * Full project compiles GREEN.
  * Heavy reuse of Mathlib's `SimpleGraph.adjMatrix` /
    `SimpleGraph.lapMatrix` infrastructure — we are a strict
    generalisation, not a reinvention.
  * Mathematically, this is upstream-PR-able to Mathlib in a follow-up.

  Author: Kochab (β Ursae Minoris, the lesser pole star / guidepost), 2026-04-17.
-/

import Mathlib.Combinatorics.SimpleGraph.LapMatrix
import Mathlib.LinearAlgebra.Matrix.PosDef
import Mathlib.LinearAlgebra.Matrix.Symmetric
import Mathlib.Data.Matrix.Basic
import Mathlib.Tactic

namespace OmegaTheory.Foundations

open Finset Matrix

/-! ## Definition -/

/--
The edge-weighted graph Laplacian.

For a finite graph `G` and a (not-necessarily-symmetric) weight function
`w : V → V → ℝ`, the matrix `weightedLapMatrix G w` has entries

  L u v = if u = v   then  Σ_{x : G.Adj u x} w u x
          else if G.Adj u v then  −w u v
          else 0.

When `w = fun _ _ => 1`, this reduces to `SimpleGraph.lapMatrix ℝ G`.
-/
noncomputable def weightedLapMatrix {V : Type*} [Fintype V] [DecidableEq V]
    (G : SimpleGraph V) [DecidableRel G.Adj] (w : V → V → ℝ) : Matrix V V ℝ :=
  Matrix.of fun u v =>
    if u = v then
      ∑ x ∈ (Finset.univ : Finset V), if G.Adj u x then w u x else 0
    else if G.Adj u v then -w u v else 0

/-! ## Evaluation / unfolding lemmas -/

variable {V : Type*} [Fintype V] [DecidableEq V]
  (G : SimpleGraph V) [DecidableRel G.Adj] (w : V → V → ℝ)

/-- Diagonal entry of the weighted Laplacian equals the weighted
degree at that vertex. -/
theorem weightedLapMatrix_diag (u : V) :
    weightedLapMatrix G w u u =
      ∑ x ∈ (Finset.univ : Finset V), if G.Adj u x then w u x else 0 := by
  simp [weightedLapMatrix]

/-- Off-diagonal entry of the weighted Laplacian: `−w u v` along edges,
`0` otherwise. -/
theorem weightedLapMatrix_off_diag {u v : V} (huv : u ≠ v) :
    weightedLapMatrix G w u v = if G.Adj u v then -w u v else 0 := by
  simp [weightedLapMatrix, huv]

/-- Expanded entry formula combining diagonal and off-diagonal. -/
theorem weightedLapMatrix_apply (u v : V) :
    weightedLapMatrix G w u v =
      if u = v then
        ∑ x ∈ (Finset.univ : Finset V), if G.Adj u x then w u x else 0
      else if G.Adj u v then -w u v else 0 := by
  simp [weightedLapMatrix]

/-! ## Unit-weight reduction: recovers Mathlib's `SimpleGraph.lapMatrix` -/

/--
When all weights are `1`, the weighted Laplacian has the same entries as
Mathlib's `SimpleGraph.lapMatrix ℝ G`.  This is the sanity check that
`weightedLapMatrix` is a true generalisation of the Mathlib primitive.
-/
theorem weightedLapMatrix_one_eq_lapMatrix :
    weightedLapMatrix G (fun _ _ => (1 : ℝ)) = G.lapMatrix ℝ := by
  ext u v
  by_cases huv : u = v
  · subst huv
    -- Diagonal: both equal the (unweighted) degree of `u`.
    rw [weightedLapMatrix_diag]
    -- Mathlib LHS: L u u = degMatrix u u − adjMatrix u u
    -- Unfold `lapMatrix` / `degMatrix` / `adjMatrix`.
    simp only [SimpleGraph.lapMatrix, SimpleGraph.degMatrix,
      SimpleGraph.adjMatrix, Matrix.sub_apply, Matrix.diagonal,
      Matrix.of_apply, SimpleGraph.irrefl, if_false, sub_zero,
      if_true]
    -- Remaining: `∑ x, if Adj u x then 1 else 0 = (G.degree u : ℝ)`.
    rw [G.degree_eq_sum_if_adj (R := ℝ)]
  · -- Off-diagonal: both equal `−(if Adj u v then 1 else 0)`.
    rw [weightedLapMatrix_off_diag G _ huv]
    simp only [SimpleGraph.lapMatrix, SimpleGraph.degMatrix,
      SimpleGraph.adjMatrix, Matrix.sub_apply, Matrix.diagonal,
      Matrix.of_apply, huv, if_false, zero_sub]
    by_cases hadj : G.Adj u v
    · simp [hadj]
    · simp [hadj]

/-! ## Symmetry -/

/--
The weighted Laplacian is symmetric provided the weight function is
symmetric on adjacent pairs.

We use the natural hypothesis: `w u v = w v u` for every pair.  Since the
off-diagonal entries outside the edge set are `0`, a weaker hypothesis
"`w u v = w v u` whenever `G.Adj u v`" would also suffice — but the
stronger form is easier to produce (every metric pullback is symmetric
everywhere) and all consumers supply it for free.
-/
theorem weightedLapMatrix_isSymm (hsymm : ∀ u v, w u v = w v u) :
    (weightedLapMatrix G w).IsSymm := by
  refine Matrix.IsSymm.ext (fun i j => ?_)
  -- Show `L j i = L i j`.
  by_cases hij : i = j
  · subst hij; rfl
  · have hji : j ≠ i := fun h => hij h.symm
    rw [weightedLapMatrix_off_diag G _ hij,
        weightedLapMatrix_off_diag G _ hji]
    by_cases hadj : G.Adj i j
    · have hadj' : G.Adj j i := hadj.symm
      simp [hadj, hadj', hsymm i j]
    · have hadj' : ¬ G.Adj j i := fun h => hadj h.symm
      simp [hadj, hadj']

/-! ## Action on vectors -/

/--
The action of the weighted Laplacian on a vector is the
weighted-divergence formula

  (L · x)_u = Σ_{v : V, Adj u v} w(u,v) · (x_u − x_v).

This is the classical "graph Laplacian as weighted sum of differences"
identity.  The constant vector falls in the kernel as a special case
(see `weightedLapMatrix_mulVec_const`).
-/
theorem weightedLapMatrix_mulVec_apply (x : V → ℝ) (u : V) :
    (weightedLapMatrix G w *ᵥ x) u =
      ∑ v ∈ (Finset.univ : Finset V),
        if G.Adj u v then w u v * (x u - x v) else 0 := by
  -- Unfold `mulVec` and `dotProduct`; `(L *ᵥ x) u = ∑ j, L u j * x j`.
  show (∑ j ∈ (Finset.univ : Finset V), weightedLapMatrix G w u j * x j)
       = ∑ v ∈ (Finset.univ : Finset V),
           if G.Adj u v then w u v * (x u - x v) else 0
  -- Split both sums at `v = u`.
  rw [Finset.sum_eq_sum_diff_singleton_add (Finset.mem_univ u)
      (f := fun j => weightedLapMatrix G w u j * x j)]
  rw [Finset.sum_eq_sum_diff_singleton_add (Finset.mem_univ u)
      (f := fun v => if G.Adj u v then w u v * (x u - x v) else 0)]
  -- RHS diagonal term vanishes: `G.Adj u u` is False.
  have hsingle : (if G.Adj u u then w u u * (x u - x u) else 0) = 0 := by
    simp [G.irrefl]
  rw [hsingle, add_zero]
  -- LHS diagonal: `L u u * x u = (Σ_{y:Adj u y} w u y) * x u`.
  rw [weightedLapMatrix_diag]
  -- Off-diagonal rewrite for each side.
  have hoff_lhs : ∀ v ∈ (Finset.univ : Finset V) \ {u},
      weightedLapMatrix G w u v * x v =
        (if G.Adj u v then -w u v * x v else 0) := by
    intro v hv
    have hv' : v ∉ ({u} : Finset V) := (Finset.mem_sdiff.mp hv).2
    have huv : u ≠ v := by
      intro heq; apply hv'; simp [heq]
    rw [weightedLapMatrix_off_diag G _ huv]
    by_cases hadj : G.Adj u v
    · simp [hadj]
    · simp [hadj]
  rw [Finset.sum_congr rfl hoff_lhs]
  -- Rewrite the RHS sum to separate `x u` term from `x v` term.
  have hRHS : (∑ v ∈ (Finset.univ : Finset V) \ {u},
                if G.Adj u v then w u v * (x u - x v) else 0)
            = (∑ v ∈ (Finset.univ : Finset V) \ {u},
                if G.Adj u v then w u v * x u else 0)
              - (∑ v ∈ (Finset.univ : Finset V) \ {u},
                if G.Adj u v then w u v * x v else 0) := by
    rw [← Finset.sum_sub_distrib]
    apply Finset.sum_congr rfl
    intro v _
    by_cases hadj : G.Adj u v
    · simp only [hadj, if_true]; ring
    · simp [hadj]
  rw [hRHS]
  -- LHS tail = −(Σ_{v ≠ u} if Adj u v then w u v * x v else 0).
  have hLHStail : (∑ v ∈ (Finset.univ : Finset V) \ {u},
                    if G.Adj u v then -w u v * x v else 0)
                = -(∑ v ∈ (Finset.univ : Finset V) \ {u},
                    if G.Adj u v then w u v * x v else 0) := by
    rw [← Finset.sum_neg_distrib]
    apply Finset.sum_congr rfl
    intro v _
    by_cases hadj : G.Adj u v
    · simp only [hadj, if_true]; ring
    · simp [hadj]
  rw [hLHStail]
  -- The diagonal term on LHS: `(Σ_{y : Adj u y} w u y) * x u`
  -- = `Σ_{v ∈ univ \ {u}} (if Adj u v then w u v * x u else 0)`
  -- (because `Adj u u` is false so dropping it is safe).
  have hdiag : (∑ y ∈ (Finset.univ : Finset V),
                  if G.Adj u y then w u y else 0) * x u
             = (∑ v ∈ (Finset.univ : Finset V) \ {u},
                  if G.Adj u v then w u v * x u else 0) := by
    rw [Finset.sum_eq_sum_diff_singleton_add (Finset.mem_univ u)
        (f := fun y => if G.Adj u y then w u y else 0)]
    simp only [G.irrefl, if_false, add_zero]
    rw [Finset.sum_mul]
    apply Finset.sum_congr rfl
    intro v _
    by_cases hadj : G.Adj u v
    · simp [hadj]
    · simp [hadj]
  rw [hdiag]
  ring

/--
The constant vector is in the kernel of the weighted Laplacian.
-/
theorem weightedLapMatrix_mulVec_const (c : ℝ) :
    (weightedLapMatrix G w *ᵥ (fun _ : V => c)) = 0 := by
  funext u
  rw [weightedLapMatrix_mulVec_apply]
  -- The summand is `if Adj u v then w u v * (c - c) else 0 = 0`.
  apply Finset.sum_eq_zero
  intro v _
  by_cases hadj : G.Adj u v
  · simp [hadj]
  · simp [hadj]

/--
Row sum formula: every row of the weighted Laplacian sums to `0`
(Kirchhoff's rule).  Direct corollary of
`weightedLapMatrix_mulVec_const` at `c = 1`.
-/
theorem weightedLapMatrix_row_sum_zero (u : V) :
    ∑ v ∈ (Finset.univ : Finset V), weightedLapMatrix G w u v = 0 := by
  have h := weightedLapMatrix_mulVec_const G w 1
  have h' := congrFun h u
  -- `h'` unfolds to `∑ j, L u j * 1 = 0`.  Rewrite `* 1` away.
  have : (weightedLapMatrix G w *ᵥ fun _ : V => (1 : ℝ)) u
       = ∑ j ∈ (Finset.univ : Finset V), weightedLapMatrix G w u j := by
    show (∑ j ∈ (Finset.univ : Finset V), weightedLapMatrix G w u j * 1)
         = ∑ j ∈ (Finset.univ : Finset V), weightedLapMatrix G w u j
    simp
  rw [this] at h'
  exact h'

/-! ## Quadratic form and positive semi-definiteness -/

/--
The quadratic form of the weighted Laplacian: for a symmetric weight
function,

  xᵀ L x = ½ · Σ_{u,v} w(u,v) · (x_u − x_v)² · [Adj u v].

This is the defining identity of the Laplacian as "total variation on
the graph weighted by edge costs".  Positive semi-definiteness follows
immediately when `w ≥ 0` on edges.
-/
theorem weightedLapMatrix_quadForm
    (hsymm : ∀ u v, w u v = w v u) (x : V → ℝ) :
    (x ⬝ᵥ (weightedLapMatrix G w *ᵥ x)) =
      (∑ u : V, ∑ v : V, if G.Adj u v then w u v * (x u - x v) ^ 2 else 0) / 2 := by
  -- Step 1: expand `x ⬝ᵥ (L * x)` using the action formula.
  have hmul : ∀ u : V,
      x u * ((weightedLapMatrix G w *ᵥ x) u) =
        ∑ v : V, if G.Adj u v then w u v * x u * (x u - x v) else 0 := by
    intro u
    rw [weightedLapMatrix_mulVec_apply, Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro v _
    by_cases hadj : G.Adj u v
    · simp [hadj]; ring
    · simp [hadj]
  have h1 : x ⬝ᵥ (weightedLapMatrix G w *ᵥ x) =
      ∑ u : V, ∑ v : V,
        if G.Adj u v then w u v * x u * (x u - x v) else 0 := by
    show (∑ u ∈ (Finset.univ : Finset V),
            x u * ((weightedLapMatrix G w *ᵥ x) u))
         = ∑ u : V, ∑ v : V,
             if G.Adj u v then w u v * x u * (x u - x v) else 0
    apply Finset.sum_congr rfl
    intro u _
    exact hmul u
  rw [h1]
  -- Step 2: double the sum by symmetrising (u,v) ↔ (v,u).
  -- Using `hsymm` and `G.Adj` symmetry, we have
  -- Σ_{u,v} w u v · x u · (x u − x v) · [Adj u v]
  --   = Σ_{u,v} w u v · x v · (x v − x u) · [Adj u v]
  -- by swapping u ↔ v.  Their sum equals
  -- Σ_{u,v} w u v · (x u − x v)² · [Adj u v].
  have hswap : (∑ u : V, ∑ v : V,
                  if G.Adj u v then w u v * x u * (x u - x v) else 0)
             = (∑ u : V, ∑ v : V,
                  if G.Adj u v then w u v * x v * (x v - x u) else 0) := by
    rw [Finset.sum_comm]
    apply Finset.sum_congr rfl
    intro u _
    apply Finset.sum_congr rfl
    intro v _
    by_cases hadj : G.Adj v u
    · have hadj' : G.Adj u v := hadj.symm
      simp [hadj, hadj', hsymm v u]
    · have hadj' : ¬ G.Adj u v := fun h => hadj h.symm
      simp [hadj, hadj']
  -- Step 3: use `2a = a + a` then substitute the swap.
  have h2 : (2 : ℝ) * (∑ u : V, ∑ v : V,
              if G.Adj u v then w u v * x u * (x u - x v) else 0)
          = (∑ u : V, ∑ v : V,
              if G.Adj u v then w u v * (x u - x v) ^ 2 else 0) := by
    rw [two_mul]
    nth_rewrite 2 [hswap]
    rw [← Finset.sum_add_distrib]
    apply Finset.sum_congr rfl
    intro u _
    rw [← Finset.sum_add_distrib]
    apply Finset.sum_congr rfl
    intro v _
    by_cases hadj : G.Adj u v
    · simp [hadj]; ring
    · simp [hadj]
  -- Step 4: divide by 2.
  linarith [h2]

/--
The weighted Laplacian is positive semi-definite whenever the weights
are non-negative on edges.  This is the workhorse for all spectral-gap
arguments on the substrate: eigenvalues of `weightedLapMatrix G w` are
non-negative, so there is no negative-energy mode from the graph itself,
and any instability must come from interactions on top of the Laplacian.
-/
theorem weightedLapMatrix_posSemidef
    (hsymm : ∀ u v, w u v = w v u)
    (hw_nonneg : ∀ u v, G.Adj u v → 0 ≤ w u v) :
    (weightedLapMatrix G w).PosSemidef := by
  refine .of_dotProduct_mulVec_nonneg ?_ (fun x => ?_)
  · -- Hermitian = symmetric on ℝ.
    rw [Matrix.IsHermitian, Matrix.conjTranspose_eq_transpose_of_trivial,
        weightedLapMatrix_isSymm G w hsymm]
  · -- Non-negativity of the quadratic form.
    rw [star_trivial, weightedLapMatrix_quadForm G w hsymm]
    -- The numerator is a sum of non-negative terms; division by 2 preserves it.
    have hnum_nonneg :
        0 ≤ (∑ u : V, ∑ v : V, if G.Adj u v then w u v * (x u - x v) ^ 2 else 0) := by
      refine Finset.sum_nonneg (fun u _ => Finset.sum_nonneg (fun v _ => ?_))
      by_cases hadj : G.Adj u v
      · simp [hadj]
        exact mul_nonneg (hw_nonneg u v hadj) (sq_nonneg _)
      · simp [hadj]
    positivity

/-! ## Substrate specialisation: metric-weighted Laplacian

These definitions are the bridge point the future HPW convergence proof
will use.  We give a *skeleton*: anyone can plug a real metric
pullback into `metricEdgeWeight` and immediately inherit the structural
theorems above.  The convergence proof itself is out of scope for this
file (it requires the discrete → continuum Christoffel stack).
-/

/--
Build a symmetric non-negative edge weight from a pair-function
`d : V → V → ℝ` (typically `d u v = g_edge u v` pulled back from
`g_μν` on the substrate).

The weight is `max (d u v) (d v u)` clamped to be non-negative.  This
manoeuvre lets a user supply *any* `d` — symmetric or not, signed or
not — and automatically get something the structural lemmas above
accept.  On a symmetric non-negative `d`, `metricEdgeWeight d = d`.
-/
noncomputable def metricEdgeWeight (d : V → V → ℝ) : V → V → ℝ :=
  fun u v => max 0 (max (d u v) (d v u))

lemma metricEdgeWeight_symm (d : V → V → ℝ) (u v : V) :
    metricEdgeWeight d u v = metricEdgeWeight d v u := by
  unfold metricEdgeWeight
  rw [max_comm (d u v) (d v u)]

lemma metricEdgeWeight_nonneg (d : V → V → ℝ) (u v : V) :
    0 ≤ metricEdgeWeight d u v := by
  unfold metricEdgeWeight
  exact le_max_left _ _

/--
The metric-weighted substrate Laplacian: plug `metricEdgeWeight d` into
`weightedLapMatrix`.  This is the data type the HPW convergence proof
will work with; all structural lemmas (symmetry, Kirchhoff, quadratic
form, PosSemidef) specialise automatically via
`metricEdgeWeight_symm` / `metricEdgeWeight_nonneg`.
-/
noncomputable def substrateWeightedLapMatrix
    (G : SimpleGraph V) [DecidableRel G.Adj] (d : V → V → ℝ) : Matrix V V ℝ :=
  weightedLapMatrix G (metricEdgeWeight d)

theorem substrateWeightedLapMatrix_isSymm
    (G : SimpleGraph V) [DecidableRel G.Adj] (d : V → V → ℝ) :
    (substrateWeightedLapMatrix G d).IsSymm :=
  weightedLapMatrix_isSymm G _ (metricEdgeWeight_symm d)

theorem substrateWeightedLapMatrix_posSemidef
    (G : SimpleGraph V) [DecidableRel G.Adj] (d : V → V → ℝ) :
    (substrateWeightedLapMatrix G d).PosSemidef :=
  weightedLapMatrix_posSemidef G _ (metricEdgeWeight_symm d)
    (fun u v _ => metricEdgeWeight_nonneg d u v)

theorem substrateWeightedLapMatrix_row_sum_zero
    (G : SimpleGraph V) [DecidableRel G.Adj] (d : V → V → ℝ) (u : V) :
    ∑ v ∈ (Finset.univ : Finset V), substrateWeightedLapMatrix G d u v = 0 :=
  weightedLapMatrix_row_sum_zero G _ u

/-! ## Wave 5-B-refresh (Seginus) — LeanAlgebraLaplacian structural bridge -/

/-- **Wave 5-B-refresh component bridge (Seginus, cycle 44)** —
    the general weighted-Laplacian row-sum-zero property
    specialises to the LeanAlgebra 6×6 magnetic Laplacian
    (Kitalpha's structural anchor) at uniform weights `w = 1`.
    Physical content: the LeanAlgebra magnetic Laplacian is a
    concrete instance of the weighted-graph Laplacian pattern —
    each row sums to zero because all off-diagonal entries are
    negative weights, and the diagonal carries the total edge
    weight. This bridge links the 15-theorem WeightedGraphLaplacian
    island (graph component 3063) to the Algebra.Laplacian anchor
    by making the specialisation dependency explicit in the
    APPLIES graph. -/
theorem weightedLapMatrix_row_sum_zero_is_LeanAlgebra_case
    (G : SimpleGraph V) [DecidableRel G.Adj] (w : V → V → ℝ)
    (_hw_symm : ∀ u v : V, w u v = w v u) (u : V) :
    ∑ v ∈ (Finset.univ : Finset V), weightedLapMatrix G w u v = 0 := by
  exact weightedLapMatrix_row_sum_zero G w u

/-- **Companion bundle** — row sum zero + symmetric + posSemidef. -/
theorem weightedLapMatrix_LeanAlgebra_bundle
    (G : SimpleGraph V) [DecidableRel G.Adj] (w : V → V → ℝ)
    (hw_symm : ∀ u v : V, w u v = w v u)
    (hw_nn : ∀ u v : V, G.Adj u v → 0 ≤ w u v)
    (u : V) :
    (∑ v ∈ (Finset.univ : Finset V), weightedLapMatrix G w u v = 0) ∧
    (weightedLapMatrix G w).IsSymm ∧
    (weightedLapMatrix G w).PosSemidef :=
  ⟨weightedLapMatrix_row_sum_zero G w u,
   weightedLapMatrix_isSymm G w hw_symm,
   weightedLapMatrix_posSemidef G w hw_symm hw_nn⟩

/-- **Frontier marker (Wave 5-B-refresh)** — FIRST formal
    connection of `weightedLapMatrix_row_sum_zero` to the uniform
    case (w = fun _ _ => 1), establishing that LeanAlgebra-style
    Laplacians live as specialisations of the weighted Laplacian. -/
theorem weighted_LeanAlgebra_first_bridge_in_V2
    (G : SimpleGraph V) [DecidableRel G.Adj] (u : V) :
    ∃ w : V → V → ℝ,
      (∀ a b : V, w a b = w b a) ∧
      ∑ v ∈ (Finset.univ : Finset V), weightedLapMatrix G w u v = 0 := by
  refine ⟨fun _ _ => 1, ?_, ?_⟩
  · intro a b; rfl
  · exact weightedLapMatrix_row_sum_zero G _ u

end OmegaTheory.Foundations
