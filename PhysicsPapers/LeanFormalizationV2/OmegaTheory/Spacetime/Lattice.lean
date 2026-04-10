/-
  OmegaTheory.Spacetime.Lattice

  The fundamental discrete spacetime structure: Λ = l_P · ℤ⁴

  This is Layer 1 of the formalization. All geometry, tensor calculus,
  and physics is built on this discrete structure.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Data.Fin.Basic
import Mathlib.Tactic

namespace OmegaTheory.Spacetime

/-- A point on the 4D integer lattice. This is our discrete spacetime. -/
abbrev LatticePoint := Fin 4 → ℤ

/-- The four spacetime directions. -/
inductive Direction : Type where
  | t : Direction  -- time
  | x : Direction  -- spatial x
  | y : Direction  -- spatial y
  | z : Direction  -- spatial z
deriving DecidableEq, Repr

/-- Convert direction to Fin 4 index. -/
def Direction.toFin : Direction → Fin 4
  | .t => 0
  | .x => 1
  | .y => 2
  | .z => 3

/-- Direction.toFin is injective: distinct directions give distinct indices. -/
theorem Direction.toFin_injective : Function.Injective Direction.toFin := by
  intro a b h
  cases a <;> cases b <;> simp [Direction.toFin] at h <;> try rfl

/-- The unit vector in direction μ. -/
def unitVec (μ : Direction) : LatticePoint :=
  fun i => if i = μ.toFin then 1 else 0

/-- Shift a lattice point by one step in direction μ. -/
def shift (n : LatticePoint) (μ : Direction) : LatticePoint :=
  fun i => n i + unitVec μ i

/-- Shift backwards by one step in direction μ. -/
def shiftBack (n : LatticePoint) (μ : Direction) : LatticePoint :=
  fun i => n i - unitVec μ i

/-- Shifting forward then backward returns to the original point. -/
theorem shift_shiftBack (n : LatticePoint) (μ : Direction) :
    shiftBack (shift n μ) μ = n := by
  ext i
  simp [shift, shiftBack, unitVec]

/-- Shifting backward then forward returns to the original point. -/
theorem shiftBack_shift (n : LatticePoint) (μ : Direction) :
    shift (shiftBack n μ) μ = n := by
  ext i
  simp [shift, shiftBack, unitVec]

/-- The coordination number of Z^4: each point has 8 nearest neighbors
    (±1 in each of 4 directions). -/
def coordinationNumber : ℕ := 8

/-- Nearest neighbor predicate: m is a neighbor of n if they differ
    by exactly one lattice step in some direction. -/
def isNeighbor (n m : LatticePoint) : Prop :=
  ∃ μ : Direction, m = shift n μ ∨ m = shiftBack n μ

/-- Neighborhood is symmetric: if m is a neighbor of n, then n is a neighbor of m. -/
theorem isNeighbor_symm {n m : LatticePoint} (h : isNeighbor n m) : isNeighbor m n := by
  obtain ⟨μ, hμ⟩ := h
  exact ⟨μ, hμ.elim
    (fun h => Or.inr (by rw [h, shift_shiftBack]))
    (fun h => Or.inl (by rw [h, shiftBack_shift]))⟩

/-- A lattice field assigns a value to each lattice point. -/
def LatticeField (α : Type*) := LatticePoint → α

/-- A lattice tensor field of type (p,q) at each point.
    p = number of contravariant (upper) indices
    q = number of covariant (lower) indices
    Each index ranges over Fin 4 (the 4 spacetime directions). -/
def LatticeTensorField (p q : ℕ) :=
  LatticePoint → (Fin p → Fin 4) → (Fin q → Fin 4) → ℝ

/-- A scalar field is a (0,0) tensor field. -/
abbrev ScalarField := LatticeField ℝ

/-- A vector field is a (1,0) tensor field. -/
abbrev VectorField := LatticeTensorField 1 0

/-- A covector field (1-form) is a (0,1) tensor field. -/
abbrev CovectorField := LatticeTensorField 0 1

/-- A (0,2) tensor field (e.g., metric tensor). -/
abbrev Tensor02Field := LatticeTensorField 0 2

/-- A (2,0) tensor field (e.g., inverse metric). -/
abbrev Tensor20Field := LatticeTensorField 2 0

end OmegaTheory.Spacetime
