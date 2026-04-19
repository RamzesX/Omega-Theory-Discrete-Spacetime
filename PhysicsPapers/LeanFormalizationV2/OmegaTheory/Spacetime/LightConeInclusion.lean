/-
  OmegaTheory.Spacetime.LightConeInclusion

  **Light cone ⊆ causal future on the discrete Planck lattice.**

  Formalization of Gacrux target #18.

  In the discrete setting built by `OmegaTheory.Spacetime.CausalLattice`, the
  *discrete light cone* of a lattice event `p` is the set of events `q` that
  advance `p`'s time by exactly one tick and saturate the spatial light-cone
  inequality along a single coordinate axis — that is, `|q_i − p_i| = 1` for
  exactly one `i ≠ 0` while the remaining spatial coordinates are unchanged.

  In natural units where one spatial Planck length equals `c ·` (one Planck
  tick), this condition is the lattice analogue of the continuum null-geodesic
  constraint `|Δx⃗| = c · Δt` restricted to a coordinate axis — the
  "null-geodesic lemma" alluded to in the directional propagation picture of
  `OmegaTheory.Emergence.MassAsDelay`.

  The main result is

      null_step_is_causal_successor :
        IsNullStep p q → isCausalSuccessor p q

  which immediately gives the two forms of the headline theorem:

      lightCone_subset_futureCone :
        lightCone p ⊆ futureCone p
      causal_lattice_light_cone_inclusion :
        lightCone p ⊆ futureCone p          -- headline alias

  The inclusion captures the physical content of the lattice causal structure:
  every event on a null geodesic from `p` is necessarily in `p`'s causal
  future, because the null-geodesic condition is a strictly more restrictive
  form of the immediate causal successor relation.

  No new axioms. No incomplete proofs. Purely structural.
-/

import Mathlib.Logic.Relation
import Mathlib.Tactic
import OmegaTheory.Spacetime.Lattice
import OmegaTheory.Spacetime.CausalLattice

namespace OmegaTheory.Spacetime

/-! ## Null step: one-tick saturation of the discrete light cone

`IsNullStep p q` says: `q` advances `p`'s time coordinate by exactly one,
and exactly one spatial coordinate changes by `±1` while the other two
spatial coordinates are unchanged.

This is the discrete form of the continuum null condition
`Δx^μ Δx_μ = 0` on the lattice: one time step forward, one spatial step
along a coordinate axis.
-/

/-- `q` is a *null-step successor* of `p`: time advances by exactly 1, and
    the spatial displacement is a unit vector along one of the three spatial
    axes (so the event sits on the boundary of the discrete light cone). -/
def IsNullStep (p q : LatticePoint) : Prop :=
  q 0 = p 0 + 1 ∧ ∃ i : Fin 4, i ≠ 0 ∧
    (q i = p i + 1 ∨ q i = p i - 1) ∧
    ∀ j : Fin 4, j ≠ 0 → j ≠ i → q j = p j

/-! ## Null step is a causal successor -/

/-- **Null-geodesic lemma → causal successor.**

A lattice null step is a special case of `isCausalSuccessor`: the time
coordinate advances by one and every spatial coordinate moves by at
most one (exactly one saturates to `±1`, the rest are zero). -/
theorem null_step_is_causal_successor {p q : LatticePoint}
    (h : IsNullStep p q) : isCausalSuccessor p q := by
  obtain ⟨htime, i, hi0, hspatial_i, hspatial_rest⟩ := h
  refine ⟨htime, ?_⟩
  intro j hj0
  by_cases hji : j = i
  · -- At the null direction, `q j - p j = ±1`, so `|q j - p j| = 1 ≤ 1`.
    subst hji
    rcases hspatial_i with hplus | hminus
    · rw [hplus]; simp
    · rw [hminus]; simp
  · -- At other spatial directions, `q j = p j`, so `|q j - p j| = 0 ≤ 1`.
    have hj : q j = p j := hspatial_rest j hj0 hji
    rw [hj]; simp

/-- Null steps strictly advance the time coordinate. -/
theorem timeCoord_null_step {p q : LatticePoint} (h : IsNullStep p q) :
    timeCoord p < timeCoord q :=
  timeCoord_step (null_step_is_causal_successor h)

/-! ## Light cone as the transitive closure of null steps -/

/-- The *discrete light cone* of `p`: every event reachable from `p` by a
    finite non-empty chain of null steps. This is the lattice analogue of
    the continuum null-geodesic light cone. -/
def lightCone (p : LatticePoint) : Set LatticePoint :=
  { q | Relation.TransGen IsNullStep p q }

/-- A single null step places `q` inside `p`'s light cone. -/
theorem mem_lightCone_of_null_step {p q : LatticePoint} (h : IsNullStep p q) :
    q ∈ lightCone p :=
  Relation.TransGen.single h

/-! ## Headline: light cone ⊆ causal future -/

/-- **Transitive-closure monotonicity.** If every `R`-step is an `S`-step,
    then `TransGen R` is contained in `TransGen S`. -/
private theorem transGen_mono_of_impl
    {α : Type*} {R S : α → α → Prop}
    (h : ∀ a b, R a b → S a b) {p q : α}
    (hR : Relation.TransGen R p q) : Relation.TransGen S p q := by
  induction hR with
  | single h' => exact Relation.TransGen.single (h _ _ h')
  | tail _ h_step ih => exact Relation.TransGen.tail ih (h _ _ h_step)

/-- **Light cone is contained in the causal future.**

Every event on the discrete light cone of `p` — i.e. reachable from `p`
by a finite chain of null steps — lies in `p`'s causal future, because
each null step is already a causal successor step. -/
theorem lightCone_subset_futureCone (p : LatticePoint) :
    lightCone p ⊆ futureCone p := by
  intro q hq
  -- `hq : Relation.TransGen IsNullStep p q`
  -- `futureCone p = { q | Relation.TransGen isCausalSuccessor p q }`
  exact transGen_mono_of_impl
    (fun _ _ => null_step_is_causal_successor) hq

/-- **Gacrux target #18 — headline theorem.**

Every lattice event's light cone (defined by the null-geodesic lemma) is
a subset of its causal future. -/
theorem causal_lattice_light_cone_inclusion (p : LatticePoint) :
    lightCone p ⊆ futureCone p :=
  lightCone_subset_futureCone p

/-! ## Corollaries -/

/-- Time is strictly monotone along light-cone chains: any event on the
    light cone of `p` has strictly greater time coordinate. -/
theorem timeCoord_mono_on_lightCone {p q : LatticePoint}
    (h : q ∈ lightCone p) : timeCoord p < timeCoord q :=
  timeCoord_monotone (lightCone_subset_futureCone p h)

/-- No event is in its own light cone (discrete chronology protection
    restricted to null geodesics). -/
theorem not_mem_own_lightCone (p : LatticePoint) : p ∉ lightCone p := by
  intro hp
  exact lt_irrefl _ (timeCoord_mono_on_lightCone hp)

/-- Light-cone membership cannot be cyclic: if `q ∈ lightCone p` then
    `p ∉ lightCone q`. -/
theorem lightCone_asymm {p q : LatticePoint}
    (h : q ∈ lightCone p) : p ∉ lightCone q := by
  intro hback
  exact causal_precedence_asymm
    (lightCone_subset_futureCone p h)
    (lightCone_subset_futureCone q hback)

/-- An event on `p`'s light cone is on `p`'s causal boundary in the
    sense that it is never spacelike separated from `p`. -/
theorem lightCone_not_spacelike {p q : LatticePoint}
    (h : q ∈ lightCone p) : ¬ spacelikeSeparated p q := by
  intro ⟨hno_causal, _⟩
  exact hno_causal (Or.inl (lightCone_subset_futureCone p h))

end OmegaTheory.Spacetime
