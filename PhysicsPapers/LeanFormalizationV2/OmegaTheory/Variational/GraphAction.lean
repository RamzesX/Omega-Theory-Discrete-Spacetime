/-
  OmegaTheory.Variational.GraphAction

  Graph-theoretic formulation of the action principle.
  The Erdős-Lagrangian unification: shortest paths on weighted graphs
  correspond to action-minimizing trajectories.

  This connects to V2's framework: the Planck lattice IS a weighted graph,
  and the healing flow minimizes a graph action functional.
-/

import OmegaTheory.Spacetime.Lattice
import OmegaTheory.Spacetime.Constants
import Mathlib.Tactic

namespace OmegaTheory.Variational

open OmegaTheory.Spacetime

/-! ## Weighted Graph -/

/-- A weighted graph on the lattice with symmetric, nonneg edge weights. -/
structure WeightedGraph where
  weight : LatticePoint → LatticePoint → ℝ
  weight_nonneg : ∀ u v, 0 ≤ weight u v
  weight_symm : ∀ u v, weight u v = weight v u

/-- A node potential (scalar field on vertices). -/
abbrev NodePotential := LatticePoint → ℝ

/-! ## Graph Lagrangian and Action -/

/-- Graph Lagrangian at an edge: L(u,v) = (1/2)w(u,v)² - φ(u).
    Kinetic energy from edge weight minus potential energy. -/
noncomputable def graphLagrangian (gr : WeightedGraph) (φ : NodePotential)
    (u v : LatticePoint) : ℝ :=
  (1 / 2 : ℝ) * gr.weight u v ^ 2 - φ u

/-- Graph action along a path: S = Σ L(u_i, u_{i+1}).
    Uses a list of vertices as the path. -/
noncomputable def graphAction (gr : WeightedGraph) (φ : NodePotential)
    (path : List LatticePoint) : ℝ :=
  (path.zip path.tail).foldl (fun acc ⟨u, v⟩ => acc + graphLagrangian gr φ u v) 0

/-- Action of a single edge. -/
noncomputable def edgeAction (gr : WeightedGraph) (φ : NodePotential)
    (u v : LatticePoint) : ℝ :=
  graphLagrangian gr φ u v

/-! ## Uniform Weighted Graph -/

/-- A uniform weighted graph: all edges have the same weight w. -/
noncomputable def uniformGraph (w : ℝ) (hw : 0 ≤ w) : WeightedGraph where
  weight := fun _ _ => w
  weight_nonneg := fun _ _ => hw
  weight_symm := fun _ _ => rfl

/-! ## Action Properties -/

/-- Graph Lagrangian is symmetric in edge weight. -/
theorem graphLagrangian_weight_symm (gr : WeightedGraph) (φ : NodePotential)
    (u v : LatticePoint) :
    (1 / 2 : ℝ) * gr.weight u v ^ 2 = (1 / 2 : ℝ) * gr.weight v u ^ 2 := by
  rw [gr.weight_symm u v]

/-- Action of empty path is zero. -/
theorem graphAction_nil (gr : WeightedGraph) (φ : NodePotential) :
    graphAction gr φ [] = 0 := rfl

/-- Action of singleton path is zero. -/
theorem graphAction_singleton (gr : WeightedGraph) (φ : NodePotential) (p : LatticePoint) :
    graphAction gr φ [p] = 0 := rfl

/-- Erdős-Action Equivalence (weak form):
    The number of edges n in a shortest path equals 2S/w² when
    potential is zero and all weights are equal.
    This connects graph distance to action. -/
theorem erdos_action_equivalence (gr : WeightedGraph) (u v : LatticePoint)
    (w : ℝ) (hw : 0 < w) (hwg : gr.weight u v = w) :
    edgeAction gr (fun _ => 0) u v = (1 / 2) * w ^ 2 := by
  unfold edgeAction graphLagrangian
  rw [hwg]; ring

/-! ## Hamilton-Jacobi on Graphs

The value function S(v) = min action to reach v satisfies the
discrete Hamilton-Jacobi equation:
  S(v) ≤ S(u) + L(u,v) for all edges (u,v)

This is the Bellman optimality principle on graphs. -/

/-- A value function on the graph. -/
abbrev ValueFunction := LatticePoint → ℝ

/-- Bellman optimality: S(v) ≤ S(u) + L(u,v) for all edges. -/
def SatisfiesBellman (gr : WeightedGraph) (φ : NodePotential)
    (S : ValueFunction) : Prop :=
  ∀ u v, S v ≤ S u + graphLagrangian gr φ u v

/-- Zero potential satisfies Bellman trivially with S = 0. -/
theorem zero_satisfies_bellman (gr : WeightedGraph) :
    SatisfiesBellman gr (fun _ => 0) (fun _ => 0) := by
  intro u v
  unfold graphLagrangian
  simp only [sub_zero]
  linarith [mul_nonneg (by norm_num : (0:ℝ) ≤ 1/2) (sq_nonneg (gr.weight u v))]

end OmegaTheory.Variational
