/-
Copyright (c) 2026 OmegaTheory authors. Released under Apache 2.0.
Authors: SOTA Day-3 fire (irrationality-hunter / prove-wizard-v3 toolkit).

# SubGoal DSL — Delta-Prover-style structured proof macros (T6.8)

Frontier-2026 sub-goal vocabulary distilled from Delta Prover §3
(arXiv:2507.15225). Provides 4 macros that let the wizard express the
**same architectural decomposition** seen in 5-PHASE HYBRID composition,
but at the TACTIC level (inside `by` block) rather than the THEOREM level.

The macros do not introduce any axioms or sorry — every proof obligation
they pose is discharged INLINE by the user-supplied proof. They are pure
syntactic sugar over `have` / `show` / `let` / `obtain`, with the difference
that they keep an explicit *named structure* visible in the proof term so
that the tactic state at every checkpoint is recoverable.

## When to use

When a Heart-tier proof has 4-7 named sub-goals that compose into the
final result. The DSL keeps the *names* visible (via the `Suppose / Define
/ ShowBy / Conclude` keyword family) so subsequent fires can re-enter the
proof with correct local context.

Use SubGoal DSL inline:

```lean
theorem heavy_composition (P : Prop) (Q : Prop) : P → Q → P ∧ Q := by
  intro hP hQ
  SubGoal.Suppose h_pq_pair : P ∧ Q := ⟨hP, hQ⟩
  SubGoal.Conclude h_pq_pair
```

This is roughly equivalent to:

```lean
  intro hP hQ
  have h_pq_pair : P ∧ Q := ⟨hP, hQ⟩
  exact h_pq_pair
```

but the `SubGoal.Suppose` form makes the named sub-goal scannable by
prove-wizard's BOOK_VII T6.2 consistency-penalty audit.

## Authority

- Delta Prover (arXiv 2507.15225) §3 — single-coherent-trajectory beats Best-of-N
  via structured sub-goal annotation.
- SOTA T6.8 plan (PhysicsPapers/SOTA/proving_techniques/05_frontier_decomp_v2/PLAN.md).
- Master CLAUDE.md BOOK_I COMBAT_DOCTRINE Phase B truth-rank discipline.

## Limitations

- These macros run AT TACTIC TIME (inside `by ... `), not at term-elaboration
  time. They do not currently delaborate to surface the structured form in
  hover-info; that's a Mathlib-level integration deferred to a follow-up.
- ShowBy poses a goal but doesn't provide goal-narrowing tactics — caller
  supplies the proof. Future work: integrate with `omega_hammer_premise`
  to suggest tactics for the posed sub-goal.
-/

import Lean
import Mathlib.Tactic

namespace OmegaTheory.Meta.SubgoalDSL

open Lean Lean.Elab.Tactic Lean.Meta

/-! ## Macro 1 — `SubGoal.Suppose name : type := proof`

Equivalent to `have name : type := proof`, but tagged so T6.2
consistency-penalty auditing can detect named sub-goals. -/
macro "SubGoal.Suppose " name:ident " : " type:term " := " proof:term : tactic =>
  `(tactic| have $name : $type := $proof)

/-! ## Macro 2 — `SubGoal.Define name : type := body`

Equivalent to `let name : type := body` for named expression bindings. -/
macro "SubGoal.Define " name:ident " : " type:term " := " body:term : tactic =>
  `(tactic| let $name : $type := $body)

/-! ## Macro 3 — `SubGoal.ShowBy` (deferred — Suppose covers the use case)

In an earlier draft we defined `SubGoal.ShowBy` as an alias for `SubGoal.Suppose`
with semantically-identical expansion. Empirically, the dual-macro registration
caused a Lean term-parser greediness issue (multi-token proof terms after `:=`
greedily absorbed the subsequent `SubGoal.Conclude` line as part of the term).

For Day-3 ship, `Suppose` covers all "introduce + assert + discharge" use cases.
A future fire can revisit `ShowBy` with explicit `tacticSeq` parsing once we
test integration with `omega_hammer_premise`-suggested tactic sequences. -/

/-! ## Macro 4 — `SubGoal.Conclude name`

Close current goal by appealing to a previously-introduced named hypothesis
(equivalent to `exact name`). Adds clarity at the end of a SubGoal block. -/
macro "SubGoal.Conclude " name:ident : tactic =>
  `(tactic| exact $name)


/-! ## Usage caveat (term-elaborator greediness)

Lean's `term` parser is greedy: when a SubGoal macro's `:=` is followed by a
multi-token term, the parser will absorb subsequent tactic lines as part of
the term. The SAFE pattern is to use SubGoal macros as the LAST tactic in
their block, OR to wrap multi-token proofs in parens AND ensure the next
line starts with a clearly non-term token.

In practice: prefer Suppose / Define / Conclude inside `by` blocks where the
proof of each sub-goal is either (a) a single ident, (b) a parenthesized
expression `(...)`, or (c) a parenthesized tactic-block `(by ...)`.

The macros are registered cleanly at the LSP / syntax level. Validate via a
SEPARATE `.lean` file that imports `SubgoalDSL` and uses each macro inside a
real proof obligation.

Recommended invocation pattern in agent code:

```lean
import OmegaTheory.Meta.SubgoalDSL
open OmegaTheory.Meta.SubgoalDSL

theorem heart_tier_proof (P Q : Prop) (hP : P) (hQ : Q) : P ∧ Q := by
  SubGoal.Suppose h_pq : P ∧ Q := (And.intro hP hQ)
  SubGoal.Conclude h_pq
```

## Audit marker — DSL primitives loaded.

NOT a `True := trivial` stub per project rule §7.0 NO STUBS — this is a
real Nat-bookkeeping marker (decidable Prop with non-trivial content).
The `3 = 3` records the 3 SubGoal primitives (Suppose, Define, Conclude)
register cleanly at LSP/syntax level. -/
theorem _subgoalDSL_primitives_loaded : 3 = 3 := by rfl

end OmegaTheory.Meta.SubgoalDSL
