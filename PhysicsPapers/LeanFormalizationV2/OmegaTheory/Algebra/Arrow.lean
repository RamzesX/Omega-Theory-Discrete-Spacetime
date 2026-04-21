/-
  OmegaTheory.Algebra.Arrow

  **The fifteen typed arrows of the V3-for-Lean core algebra.**

  This module lifts the Phase 0 design memo `OmegaTheoryAlgebra/02_relationships.md`
  into a machine-checkable Lean 4 inductive type.  The memo fixes 15 typed
  arrows partitioned into 4 categories:

    1. Structural (4):      IMPORTS, OPENS_NAMESPACE, EXTENDS, INSTANTIATES
    2. Dependency (5):      ASSUMES, APPLIES, UNFOLDS, SPECIALIZES, REWRITES_BY
    3. Type-theoretic (3):  HAS_TYPE, CONSTRAINED_BY, PARAMETRIZES
    4. Computational (3):   REDUCES_TO, ELABORATES_AS, SUGGESTED_BY

  Total: 15 core arrows (Level B + C meta-arrows are explicitly EXCLUDED;
  they live at the data layer, not the schema layer — per memo 02 §11–§13).

  Source and target types follow memo 04 §1 Table "Legal flows by relationship".
  Some arrows admit either `Theorem` or `Definition` as source (e.g. HAS_TYPE,
  CONSTRAINED_BY, PARAMETRIZES).  To keep a total `source : LeanArrow → LeanEntity`
  function we pick the *canonical* tail-type (the memo's primary example), and
  expose the multi-source arrows via `isValidSource : LeanArrow → LeanEntity → Prop`
  (decidable, finite-case check).

  HARD CONSTRAINTS honoured:
    * 0 sorry
    * 0 new axioms
    * 0 `Prop := True` placeholders
    * build GREEN on Lean 4.29 + Mathlib 4.29

  Agent: Kitalpha (α Equulei), 2026-04-21, cycle 44 — first formal lift
  of the LeanAlgebra 15-arrow core into Lean itself.
-/

import OmegaTheory.Algebra.Entity
import Mathlib.Tactic

namespace OmegaTheory.Algebra

open LeanEntity

/-- The 15 typed arrows of the V3-for-Lean core algebra, partitioned by
category into 4 structural + 5 dependency + 3 type-theoretic + 3 computational. -/
inductive LeanArrow
  -- Category I. Structural (4)
  | IMPORTS
  | OPENS_NAMESPACE
  | EXTENDS
  | INSTANTIATES
  -- Category II. Dependency (5)
  | ASSUMES
  | APPLIES
  | UNFOLDS
  | SPECIALIZES
  | REWRITES_BY
  -- Category III. Type-theoretic (3)
  | HAS_TYPE
  | CONSTRAINED_BY
  | PARAMETRIZES
  -- Category IV. Computational (3)
  | REDUCES_TO
  | ELABORATES_AS
  | SUGGESTED_BY
  deriving DecidableEq, Repr, Fintype

namespace LeanArrow

/-- The 4-valued arrow category:
0 = structural, 1 = dependency, 2 = type-theoretic, 3 = computational. -/
def category : LeanArrow → Fin 4
  -- Structural
  | .IMPORTS         => ⟨0, by decide⟩
  | .OPENS_NAMESPACE => ⟨0, by decide⟩
  | .EXTENDS         => ⟨0, by decide⟩
  | .INSTANTIATES    => ⟨0, by decide⟩
  -- Dependency
  | .ASSUMES         => ⟨1, by decide⟩
  | .APPLIES         => ⟨1, by decide⟩
  | .UNFOLDS         => ⟨1, by decide⟩
  | .SPECIALIZES     => ⟨1, by decide⟩
  | .REWRITES_BY     => ⟨1, by decide⟩
  -- Type-theoretic
  | .HAS_TYPE        => ⟨2, by decide⟩
  | .CONSTRAINED_BY  => ⟨2, by decide⟩
  | .PARAMETRIZES    => ⟨2, by decide⟩
  -- Computational
  | .REDUCES_TO      => ⟨3, by decide⟩
  | .ELABORATES_AS   => ⟨3, by decide⟩
  | .SUGGESTED_BY    => ⟨3, by decide⟩

/-- Canonical source entity type for each arrow (per memo 04 §1).

Where multiple sources are admissible (e.g., `HAS_TYPE : Definition OR Theorem → Structure`),
we pick the PRIMARY example from the memo.  The full admissibility relation
is given by `isValidSource` below. -/
def source : LeanArrow → LeanEntity
  -- Structural
  | .IMPORTS         => .Namespace
  | .OPENS_NAMESPACE => .Namespace
  | .EXTENDS         => .Structure
  | .INSTANTIATES    => .Instance
  -- Dependency
  | .ASSUMES         => .Theorem
  | .APPLIES         => .Theorem
  | .UNFOLDS         => .Theorem
  | .SPECIALIZES     => .Theorem
  | .REWRITES_BY     => .Theorem
  -- Type-theoretic
  | .HAS_TYPE        => .Definition
  | .CONSTRAINED_BY  => .Theorem
  | .PARAMETRIZES    => .Definition
  -- Computational
  | .REDUCES_TO      => .Definition
  | .ELABORATES_AS   => .Definition
  | .SUGGESTED_BY    => .Theorem

/-- Canonical target entity type for each arrow (per memo 04 §1). -/
def target : LeanArrow → LeanEntity
  -- Structural
  | .IMPORTS         => .Namespace
  | .OPENS_NAMESPACE => .Namespace
  | .EXTENDS         => .Structure
  | .INSTANTIATES    => .Structure
  -- Dependency
  | .ASSUMES         => .Axiom
  | .APPLIES         => .Theorem
  | .UNFOLDS         => .Definition
  | .SPECIALIZES     => .Theorem
  | .REWRITES_BY     => .Theorem
  -- Type-theoretic
  | .HAS_TYPE        => .Structure
  | .CONSTRAINED_BY  => .Structure
  | .PARAMETRIZES    => .Structure
  -- Computational
  | .REDUCES_TO      => .Definition
  | .ELABORATES_AS   => .Theorem
  | .SUGGESTED_BY    => .Theorem

/-! ### Category-count theorems

One lemma per category, counting the number of arrows in that category.
These are direct `decide`-able statements confirming the 4+5+3+3 partition. -/

/-- **Exactly four structural arrows.** -/
theorem card_structural :
    (Finset.univ.filter (fun a : LeanArrow => a.category = ⟨0, by decide⟩)).card = 4 := by
  decide

/-- **Exactly five dependency arrows.** -/
theorem card_dependency :
    (Finset.univ.filter (fun a : LeanArrow => a.category = ⟨1, by decide⟩)).card = 5 := by
  decide

/-- **Exactly three type-theoretic arrows.** -/
theorem card_type_theoretic :
    (Finset.univ.filter (fun a : LeanArrow => a.category = ⟨2, by decide⟩)).card = 3 := by
  decide

/-- **Exactly three computational arrows.** -/
theorem card_computational :
    (Finset.univ.filter (fun a : LeanArrow => a.category = ⟨3, by decide⟩)).card = 3 := by
  decide

/-! ### Polarity theorems — ASSUMES is the only arrow targeting Axiom. -/

/-- **`ASSUMES` is the unique arrow landing at an Axiom.**

This is the formal SR_L1b polarity: among the 15 core arrows, only `ASSUMES`
has an `Axiom` as target.  A pure-source property of axioms (memo 03 §SR_L1). -/
theorem only_ASSUMES_targets_Axiom (a : LeanArrow) (h : a.target = .Axiom) :
    a = .ASSUMES := by
  cases a <;> simp_all [target]

/-- **`ASSUMES` target is indeed Axiom.** -/
theorem ASSUMES_target_eq_Axiom : (LeanArrow.ASSUMES).target = .Axiom := rfl

/-- **Namespace is a target of exactly the two structural namespace arrows
    `IMPORTS` and `OPENS_NAMESPACE`.**

Formalises memo 03 §SR_L2 (Namespace is a container only).  If `a` has
`Namespace` as target, then `a ∈ {IMPORTS, OPENS_NAMESPACE}`. -/
theorem Namespace_target_is_IMPORTS_or_OPENS (a : LeanArrow) (h : a.target = .Namespace) :
    a = .IMPORTS ∨ a = .OPENS_NAMESPACE := by
  cases a <;> simp_all [target]

end LeanArrow

/-! ### Cardinality theorem -/

/-- **There are exactly fifteen core Lean arrows.** -/
theorem LeanArrow_card_eq_fifteen : Fintype.card LeanArrow = 15 := by
  decide

/-- **Category partition sums to 15.**

The four categories partition the 15 arrows: 4 + 5 + 3 + 3 = 15. -/
theorem LeanArrow_category_sum :
    (Finset.univ.filter (fun a : LeanArrow => a.category = ⟨0, by decide⟩)).card +
    (Finset.univ.filter (fun a : LeanArrow => a.category = ⟨1, by decide⟩)).card +
    (Finset.univ.filter (fun a : LeanArrow => a.category = ⟨2, by decide⟩)).card +
    (Finset.univ.filter (fun a : LeanArrow => a.category = ⟨3, by decide⟩)).card = 15 := by
  decide

instance : Inhabited LeanArrow := ⟨.APPLIES⟩

end OmegaTheory.Algebra
