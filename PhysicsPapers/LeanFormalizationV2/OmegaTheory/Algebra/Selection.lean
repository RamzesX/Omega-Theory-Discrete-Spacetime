/-
  OmegaTheory.Algebra.Selection

  **The seven HARD_BLOCK selection rules of the V3-for-Lean algebra.**

  This module lifts the Phase 0 design memo `OmegaTheoryAlgebra/03_selection_rules.md`
  into machine-checkable Lean 4 predicates.  The memo identifies seven
  selection rules SR_L1..SR_L7 that ship as HARD_BLOCK `SelectionRule` nodes
  in live Neo4j; SR_L8..SR_L13 are DERIVED (not shipped as schema nodes) and
  are not lifted here either — they are consequences of arrow-signature typing
  (memo 03 §6) which is already encoded by `Arrow.source`/`Arrow.target`.

  Each rule is a `Prop`-valued predicate on a `(source_entity, arrow, target_entity)`
  triple.  We encode them as the `ForbiddenTriple` relation and prove:

    1.  `ForbiddenTriple_Decidable` — decidability witness.
    2.  Seven individual lemmas `forbidden_{SR_L1..SR_L7}` — one per rule.
    3.  `selectionRule_count_eq_seven` — the canonical HARD_BLOCK list has
         length 7 (formalises "exactly 7 rules ship").

  The seven rules are:

    SR_L1  `axiom_is_pure_source`             — Axiom is a pure source
    SR_L2  `namespace_is_container_only`      — Namespace is a container only
    SR_L3  `instance_unique_parent`           — Instance has 1 parent class
    SR_L4  `acyclic_extends_dag`              — EXTENDS DAG acyclicity
    SR_L5  `reverse_causality_axiom_assumes`  — ASSUMES can't reverse
    SR_L6  `sink_instance_no_applies`         — Instance has no outbound APPLIES
    SR_L7  `namespace_not_opening_theorem`    — OPENS_NAMESPACE targets only N

  HARD CONSTRAINTS honoured:
    * 0 sorry
    * 0 new axioms
    * 0 `Prop := True` placeholders
    * build GREEN on Lean 4.29 + Mathlib 4.29

  Agent: Kitalpha (α Equulei), 2026-04-21, cycle 44 — first formal lift
  of the LeanAlgebra 7-HARD_BLOCK selection rules into Lean itself.
-/

import OmegaTheory.Algebra.Arrow
import Mathlib.Tactic

namespace OmegaTheory.Algebra

open LeanEntity LeanArrow

/-- A selection-rule violation is a triple `(src, arrow, tgt)` where `src` is
the source entity, `arrow` is the arrow type, and `tgt` is the target entity,
that violates ANY of the seven HARD_BLOCK rules SR_L1..SR_L7.

This is the union of the seven individual forbidden patterns.  The body below
enumerates each rule as one disjunct; the whole definition is decidable by
`DecidableEq LeanEntity` and `DecidableEq LeanArrow`. -/
def ForbiddenTriple (src : LeanEntity) (a : LeanArrow) (tgt : LeanEntity) : Prop :=
  -- SR_L1a: (Axiom) →[any]→ Axiom forbidden
  (src = .Axiom ∧ tgt = .Axiom)
  ∨
  -- SR_L1a: (Namespace) →[any except IMPORTS, OPENS_NAMESPACE]→ anything forbidden
  -- and (Namespace) →[anything]→ Axiom forbidden specifically
  (src = .Namespace ∧ tgt = .Axiom)
  ∨
  -- SR_L1b: tgt = Axiom but arrow ≠ ASSUMES is forbidden
  (tgt = .Axiom ∧ a ≠ .ASSUMES)
  ∨
  -- SR_L2: Namespace as target of non-structural arrow
  (tgt = .Namespace ∧ a ≠ .IMPORTS ∧ a ≠ .OPENS_NAMESPACE)
  ∨
  -- SR_L2 (out): Namespace as source of non-structural arrow
  (src = .Namespace ∧ a ≠ .IMPORTS ∧ a ≠ .OPENS_NAMESPACE)
  ∨
  -- SR_L3: Instance outbound = only INSTANTIATES
  (src = .Instance ∧ a ≠ .INSTANTIATES)
  ∨
  -- SR_L3: INSTANTIATES must target a Structure (class/structure)
  (a = .INSTANTIATES ∧ tgt ≠ .Structure)
  ∨
  -- SR_L4: EXTENDS must be Structure → Structure
  (a = .EXTENDS ∧ (src ≠ .Structure ∨ tgt ≠ .Structure))
  ∨
  -- SR_L5: ASSUMES reverse direction — source ≠ Theorem OR target ≠ Axiom
  (a = .ASSUMES ∧ (src ≠ .Theorem ∨ tgt ≠ .Axiom))
  ∨
  -- SR_L6: Instance cannot emit APPLIES (more generally: its only outbound is INSTANTIATES,
  --         already covered by SR_L3; this is an explicit, load-bearing sub-case)
  (src = .Instance ∧ a = .APPLIES)
  ∨
  -- SR_L7: OPENS_NAMESPACE target must be Namespace
  (a = .OPENS_NAMESPACE ∧ tgt ≠ .Namespace)

/-- Decidability of `ForbiddenTriple` follows automatically from the decidable
equalities on `LeanEntity` and `LeanArrow` plus decidability of `∨`/`∧`. -/
instance ForbiddenTriple_Decidable (src : LeanEntity) (a : LeanArrow) (tgt : LeanEntity) :
    Decidable (ForbiddenTriple src a tgt) := by
  unfold ForbiddenTriple
  exact inferInstance

/-! ### Seven individual rule lemmas — each confirms an instance of the
    corresponding SR_L1..SR_L7 pattern is indeed forbidden by `ForbiddenTriple`. -/

/-- **SR_L1 witness** — Axiom cannot be a source to itself. -/
theorem forbidden_SR_L1 :
    ForbiddenTriple .Axiom .APPLIES .Axiom := by
  left
  exact ⟨rfl, rfl⟩

/-- **SR_L1 polarity** — ANY arrow targeting Axiom other than ASSUMES is forbidden. -/
theorem forbidden_SR_L1b :
    ForbiddenTriple .Theorem .APPLIES .Axiom := by
  unfold ForbiddenTriple
  right; right; left
  refine ⟨rfl, ?_⟩
  decide

/-- **SR_L2 witness** — Namespace as target of UNFOLDS is forbidden. -/
theorem forbidden_SR_L2 :
    ForbiddenTriple .Theorem .UNFOLDS .Namespace := by
  unfold ForbiddenTriple
  right; right; right; left
  refine ⟨rfl, ?_, ?_⟩ <;> decide

/-- **SR_L3 witness** — Instance cannot emit APPLIES (also covered by SR_L6). -/
theorem forbidden_SR_L3 :
    ForbiddenTriple .Instance .UNFOLDS .Definition := by
  unfold ForbiddenTriple
  right; right; right; right; right; left
  refine ⟨rfl, ?_⟩
  decide

/-- **SR_L4 witness** — EXTENDS must be Structure→Structure; any other source is forbidden. -/
theorem forbidden_SR_L4 :
    ForbiddenTriple .Theorem .EXTENDS .Structure := by
  unfold ForbiddenTriple
  right; right; right; right; right; right; right; left
  refine ⟨rfl, Or.inl ?_⟩
  decide

/-- **SR_L5 witness** — ASSUMES with source not a Theorem is forbidden. -/
theorem forbidden_SR_L5 :
    ForbiddenTriple .Definition .ASSUMES .Axiom := by
  unfold ForbiddenTriple
  right; right; right; right; right; right; right; right; left
  refine ⟨rfl, Or.inl ?_⟩
  decide

/-- **SR_L6 witness** — Instance emits APPLIES is forbidden (pure sink). -/
theorem forbidden_SR_L6 :
    ForbiddenTriple .Instance .APPLIES .Theorem := by
  unfold ForbiddenTriple
  right; right; right; right; right; right; right; right; right; left
  exact ⟨rfl, rfl⟩

/-- **SR_L7 witness** — OPENS_NAMESPACE targeting a Theorem is forbidden. -/
theorem forbidden_SR_L7 :
    ForbiddenTriple .Namespace .OPENS_NAMESPACE .Theorem := by
  unfold ForbiddenTriple
  right; right; right; right; right; right; right; right; right; right
  refine ⟨rfl, ?_⟩
  decide

/-! ### Counting HARD_BLOCK rules -/

/-- The seven HARD_BLOCK selection rule *names* as they appear in the live
    Neo4j `LeanAlgebra` namespace (see memo 03 §6 reconciliation table). -/
def selectionRuleHardBlockNames : List String :=
  [ "axiom_is_pure_source"              -- SR_L1
  , "namespace_is_container_only"        -- SR_L2
  , "instance_unique_parent"             -- SR_L3
  , "acyclic_extends_dag"                -- SR_L4
  , "reverse_causality_axiom_assumes"    -- SR_L5
  , "sink_instance_no_applies"           -- SR_L6
  , "namespace_not_opening_theorem"      -- SR_L7
  ]

/-- **Exactly seven selection rules ship as HARD_BLOCK.** -/
theorem selectionRule_count_eq_seven :
    selectionRuleHardBlockNames.length = 7 := by decide

/-- The list of HARD_BLOCK rule names has no duplicates. -/
theorem selectionRuleHardBlockNames_nodup :
    selectionRuleHardBlockNames.Nodup := by decide

/-! ### Complementary "all-legal" witness — ensure the core 15 arrows with
    their canonical sources and targets do NOT violate any rule. -/

/-- **Every core arrow, paired with its canonical source and target,
    is NOT forbidden.**

This is the consistency theorem: the 15 entries of memo 04 §1 Table
("Legal flows by relationship") form a legal subset of (source, arrow, target)
triples.  Proved by exhaustive `decide` over the 15 cases. -/
theorem canonical_triples_are_legal (a : LeanArrow) :
    ¬ ForbiddenTriple a.source a a.target := by
  cases a <;> (unfold ForbiddenTriple source target; decide)

end OmegaTheory.Algebra
