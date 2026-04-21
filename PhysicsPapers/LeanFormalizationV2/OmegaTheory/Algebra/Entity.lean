/-
  OmegaTheory.Algebra.Entity

  **The six Lean entity types of the V3-for-Lean graph algebra.**

  This module lifts the Phase 0 design memo `OmegaTheoryAlgebra/01_entity_types.md`
  into a machine-checkable Lean 4 inductive type.  The memo fixes six entity
  types — Axiom, Definition, Instance, Namespace, Structure, Theorem — as the
  atomic vertex labels of the V3-for-Lean quiver.  These are the *core* six
  that preserve the Ramsey R(3,3) = 6 guarantee (HypatiaBasis §2.1).  Level B
  extensions (Tactic, Attribute) are intentionally NOT part of this core
  inductive — they live at a separate schema layer.

  Height assignment follows `01_entity_types.md` §3:
    - Axiom         → 3  (pure source, no prerequisites)
    - Definition    → 2  (semantic data, depends on axioms)
    - Instance      → 1  (pure sink, consumes a class)
    - Namespace     → 0  (purely organizational)
    - Structure     → 2  (framework, parameterizable)
    - Theorem       → 1  (active hub)

  The Axiom-as-max-height polarity (§4) and Namespace-as-min-height polarity
  (§5) are theorems here, not conventions.  Both are proved by `decide`.

  HARD CONSTRAINTS honoured:
    * 0 sorry
    * 0 new axioms
    * 0 `Prop := True` placeholders
    * build GREEN on Lean 4.29 + Mathlib 4.29

  Agent: Kitalpha (α Equulei), 2026-04-21, cycle 44 — first formal lift
  of the LeanAlgebra 6-entity core into Lean itself.

  Canonical index order (for any future Matrix-valued construction in this
  directory) is **alphabetical**:

      [Axiom, Definition, Instance, Namespace, Structure, Theorem]

  i.e. canonical index 0=Axiom, 1=Definition, 2=Instance, 3=Namespace,
  4=Structure, 5=Theorem.  This matches the Python/Cypher consumers already
  running on the live Neo4j `math` container (memo 04 §1).
-/

import Mathlib.Data.Fintype.Basic
import Mathlib.Tactic

namespace OmegaTheory.Algebra

/-- The six Lean entity types of the V3-for-Lean core algebra.

Each constructor corresponds to one of Lean 4's core top-level declaration
kinds (after the equivalence collapses justified in memo 01 §2):

- `axiom`                                      → `Axiom`
- `theorem`, `lemma`                           → `Theorem`
- `def`, `abbrev`, `noncomputable def`, `opaque` → `Definition`
- `structure`, `class`                         → `Structure`
- `instance`                                   → `Instance`
- `namespace`, `section`, module/file          → `Namespace`

These six, and only these six, preserve the Ramsey R(3, 3) = 6 guarantee.
Tactic and Attribute (Level B) are *not* part of this core type. -/
inductive LeanEntity
  | Axiom
  | Definition
  | Instance
  | Namespace
  | Structure
  | Theorem
  deriving DecidableEq, Repr, Fintype

namespace LeanEntity

/-- Canonical index of each entity type, in alphabetical order.
This matches the Python / Cypher / numpy indexing already in use
in live scripts on the Neo4j `math` container. -/
def canonicalIndex : LeanEntity → Fin 6
  | .Axiom      => ⟨0, by decide⟩
  | .Definition => ⟨1, by decide⟩
  | .Instance   => ⟨2, by decide⟩
  | .Namespace  => ⟨3, by decide⟩
  | .Structure  => ⟨4, by decide⟩
  | .Theorem    => ⟨5, by decide⟩

/-- Height function `h : LeanEntity → ℕ`, per memo 01 §3.

An entity of higher height is *causally earlier* in a Lean development:
axioms are declared before they can be `ASSUMES`-referenced, definitions
before they can be `UNFOLDS`-unrolled, etc.  The Axiom height (3) is the
maximum; the Namespace height (0) is the minimum. -/
def height : LeanEntity → ℕ
  | .Axiom      => 3
  | .Definition => 2
  | .Instance   => 1
  | .Namespace  => 0
  | .Structure  => 2
  | .Theorem    => 1

/-! ### Height equations (one per entity type) -/

theorem height_Axiom_eq_three : height .Axiom = 3 := rfl
theorem height_Definition_eq_two : height .Definition = 2 := rfl
theorem height_Instance_eq_one : height .Instance = 1 := rfl
theorem height_Namespace_eq_zero : height .Namespace = 0 := rfl
theorem height_Structure_eq_two : height .Structure = 2 := rfl
theorem height_Theorem_eq_one : height .Theorem = 1 := rfl

/-! ### Polarity theorems — Axiom is the pure source, Namespace is the strict sink. -/

/-- **Axiom is the unique pure source.**

For every entity `e`, the Axiom's height is at least as large as `e`'s.
This is the formal statement of memo 01 §4: an axiom is *causally earliest*,
so no entity can have strictly greater height.  Proved by exhaustive
`decide` on the six constructors. -/
theorem Axiom_is_pure_source (e : LeanEntity) :
    height e ≤ height .Axiom := by
  cases e <;> decide

/-- **Namespace is the strict sink.**

For every entity `e`, Namespace's height is at most `e`'s.  Matches memo 01
§5: a namespace is purely organizational, the lowest tier of the graph. -/
theorem Namespace_is_strict_sink (e : LeanEntity) :
    height .Namespace ≤ height e := by
  cases e <;> decide

/-- The Axiom height is strictly greater than every non-Axiom height. -/
theorem Axiom_height_strict (e : LeanEntity) (he : e ≠ .Axiom) :
    height e < height .Axiom := by
  cases e <;> simp_all (config := { decide := true })

/-- The Namespace height is strictly less than every non-Namespace height. -/
theorem Namespace_height_strict (e : LeanEntity) (he : e ≠ .Namespace) :
    height .Namespace < height e := by
  cases e <;> simp_all (config := { decide := true })

end LeanEntity

/-! ### Cardinality theorem -/

/-- **There are exactly six core Lean entity types.**

This is the Ramsey R(3, 3) = 6 guarantee in its most direct form: the core
ontology has exactly six vertex labels.  Proved by `decide` via the derived
`Fintype` instance. -/
theorem LeanEntity_card_eq_six : Fintype.card LeanEntity = 6 := by
  decide

/-! ### Decidability witnesses.  Useful for any downstream automation that
    wants to case-split on entity type or sum height over a finite set. -/

instance : Inhabited LeanEntity := ⟨.Theorem⟩

end OmegaTheory.Algebra
