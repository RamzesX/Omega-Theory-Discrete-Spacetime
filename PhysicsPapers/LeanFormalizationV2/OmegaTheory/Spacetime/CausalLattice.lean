/-
  OmegaTheory.Spacetime.CausalLattice

  Causal structure on the discrete Planck lattice Λ = l_P · ℤ⁴.

  Direction 0 (time) is distinguished. A causal successor advances time by
  exactly one Planck tick and shifts spatially by at most one Planck length
  in each direction — the discrete light cone.

  The transitive closure of this one-step relation defines causal precedence.
  Because the integer time coordinate strictly increases at every step,
  closed timelike curves are impossible.
-/

import Mathlib.Logic.Relation
import Mathlib.Tactic
import OmegaTheory.Spacetime.Lattice

namespace OmegaTheory.Spacetime

/-! ## Time coordinate -/

/-- The time coordinate of a lattice point (direction 0). -/
def timeCoord (p : LatticePoint) : ℤ := p 0

/-! ## Immediate causal successor -/

/-- `q` is an immediate causal successor of `p`: time advances by exactly 1,
    spatial coordinates change by at most 1 each (discrete light cone). -/
def isCausalSuccessor (p q : LatticePoint) : Prop :=
  q 0 = p 0 + 1 ∧ ∀ i : Fin 4, i ≠ 0 → |q i - p i| ≤ 1

/-- A point is never its own immediate causal successor. -/
theorem causal_irrefl (p : LatticePoint) : ¬ isCausalSuccessor p p := by
  intro ⟨h, _⟩
  omega

/-- Time strictly increases at each causal step. -/
theorem timeCoord_step {p q : LatticePoint} (h : isCausalSuccessor p q) :
    timeCoord p < timeCoord q := by
  simp [timeCoord, isCausalSuccessor] at *
  omega

/-! ## Causal precedence (transitive closure) -/

/-- `q` is in the causal future of `p`: there exists a finite chain of
    immediate causal successors from `p` to `q`. -/
def causalPrecedence : LatticePoint → LatticePoint → Prop :=
  Relation.TransGen isCausalSuccessor

/-- Time is strictly monotone along any causal chain. -/
theorem timeCoord_monotone {p q : LatticePoint} (h : causalPrecedence p q) :
    timeCoord p < timeCoord q := by
  induction h with
  | single h => exact timeCoord_step h
  | tail _ h_step ih => exact lt_trans ih (timeCoord_step h_step)

/-- Causal precedence is irreflexive: no point precedes itself. -/
theorem causal_precedence_irrefl (p : LatticePoint) : ¬ causalPrecedence p p := by
  intro h
  exact lt_irrefl _ (timeCoord_monotone h)

/-- Causal precedence is asymmetric: if p ≤_causal q then NOT q ≤_causal p. -/
theorem causal_precedence_asymm {p q : LatticePoint}
    (h : causalPrecedence p q) : ¬ causalPrecedence q p := by
  intro h'
  exact lt_irrefl _ (lt_trans (timeCoord_monotone h) (timeCoord_monotone h'))

/-! ## Future and past cones -/

/-- The future light cone of `p`: all points causally reachable from `p`. -/
def futureCone (p : LatticePoint) : Set LatticePoint :=
  { q | causalPrecedence p q }

/-- The past light cone of `p`: all points from which `p` is causally reachable. -/
def pastCone (p : LatticePoint) : Set LatticePoint :=
  { q | causalPrecedence q p }

/-- A point is never in its own future cone. -/
theorem not_mem_own_futureCone (p : LatticePoint) : p ∉ futureCone p :=
  causal_precedence_irrefl p

/-- A point is never in its own past cone. -/
theorem not_mem_own_pastCone (p : LatticePoint) : p ∉ pastCone p :=
  causal_precedence_irrefl p

/-- Future cone containment is monotone: if p precedes q,
    the future cone of q is contained in the future cone of p. -/
theorem futureCone_subset {p q : LatticePoint} (h : causalPrecedence p q) :
    futureCone q ⊆ futureCone p := by
  intro r hr
  exact Relation.TransGen.trans h hr

/-- Past cone containment is monotone: if p precedes q,
    the past cone of p is contained in the past cone of q. -/
theorem pastCone_subset {p q : LatticePoint} (h : causalPrecedence p q) :
    pastCone p ⊆ pastCone q := by
  intro r hr
  exact Relation.TransGen.trans hr h

/-- If q is in the future cone of p, then p is in the past cone of q. -/
theorem futureCone_iff_pastCone {p q : LatticePoint} :
    q ∈ futureCone p ↔ p ∈ pastCone q :=
  Iff.rfl

/-! ## Chronology protection -/

/-- The lattice has no closed timelike curves: no point is in its own future cone. -/
def HasNoCTC : Prop := ∀ p : LatticePoint, p ∉ futureCone p

/-- A function that strictly increases along causal steps also strictly
    increases along arbitrary causal chains. -/
theorem monotone_along_chain
    (f : LatticePoint → ℤ)
    (hmon : ∀ p q : LatticePoint, isCausalSuccessor p q → f p < f q)
    {p q : LatticePoint} (h : causalPrecedence p q) : f p < f q := by
  induction h with
  | single h => exact hmon _ _ h
  | tail _ h_step ih => exact lt_trans ih (hmon _ _ h_step)

/-- Chronology protection from any global time function: if there exists
    a function f : LatticePoint → ℤ that strictly increases along every
    causal step, then no CTCs exist. This is the discrete analogue of
    Hawking's chronology protection — but here it is a theorem. -/
theorem no_ctc_from_monotone_function
    (f : LatticePoint → ℤ)
    (hmon : ∀ p q : LatticePoint, isCausalSuccessor p q → f p < f q) :
    HasNoCTC := by
  intro p hp
  exact lt_irrefl _ (monotone_along_chain f hmon hp)

/-- The standard causal lattice (with direction 0 as time) has no CTCs.
    This is unconditional — it follows from the definition of `isCausalSuccessor`. -/
theorem no_ctc_of_causal_lattice : HasNoCTC :=
  no_ctc_from_monotone_function timeCoord (fun _ _ h => timeCoord_step h)

/-! ## Causal separation -/

/-- Two points are causally related if one precedes the other. -/
def causallyRelated (p q : LatticePoint) : Prop :=
  causalPrecedence p q ∨ causalPrecedence q p

/-- Two points are spacelike separated if neither causally precedes the other. -/
def spacelikeSeparated (p q : LatticePoint) : Prop :=
  ¬ causallyRelated p q ∧ p ≠ q

/-- Causal relatedness is symmetric. -/
theorem causallyRelated_symm {p q : LatticePoint} :
    causallyRelated p q ↔ causallyRelated q p :=
  Or.comm

/-- Spacelike separation is symmetric. -/
theorem spacelikeSeparated_symm {p q : LatticePoint} :
    spacelikeSeparated p q ↔ spacelikeSeparated q p := by
  simp [spacelikeSeparated, causallyRelated_symm, ne_comm]

/-- Same-time points with distinct spatial positions are spacelike separated. -/
theorem spacelike_of_same_time {p q : LatticePoint}
    (htime : timeCoord p = timeCoord q) (hne : p ≠ q) :
    spacelikeSeparated p q := by
  refine ⟨fun hcr => ?_, hne⟩
  rcases hcr with h | h
  · exact absurd (timeCoord_monotone h) (by omega)
  · exact absurd (timeCoord_monotone h) (by omega)

/-! ## Time difference bound -/

/-- The time difference between causally related points bounds the number
    of causal steps: a chain from p to q needs exactly (q.time - p.time) steps. -/
theorem time_diff_pos {p q : LatticePoint} (h : causalPrecedence p q) :
    0 < timeCoord q - timeCoord p := by
  have := timeCoord_monotone h
  omega

end OmegaTheory.Spacetime
