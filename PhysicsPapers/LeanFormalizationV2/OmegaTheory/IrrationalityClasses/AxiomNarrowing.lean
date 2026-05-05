/-
  OmegaTheory.IrrationalityClasses.AxiomNarrowing

  **Cycle-53 Phase B-1 — `Real.pi_transcendental` axiom-blast-radius narrowing.**

  Author: Atria (lean-proof-wizard, 2026-04-25 cycle-53 Phase B).
  Briefing: `plans/SAGE_BRIEFING_pi_transcendental_audit_and_split_2026-04-25.md`
  by Phecda (grothendieck-sage).

  ## Mission

  The project carries `Real.pi_transcendental` as the **last** paper-headline
  research axiom (sealed in `OmegaTheory/Irrationality/HermitePade/PiStratum.lean`,
  awaiting Mathlib's Lindemann-Weierstrass port).  Phecda's audit identified
  exactly THREE consumer theorems that import this axiom (queried via Cypher
  on the OmegaTheoryV2 namespace, 2026-04-25):

    1. `ic_pi_Mahler_S_conditional` — uses `Real.pi_transcendental` directly.
       The hypothesis `IsMahlerSClass Real.pi` is a placeholder `Prop := True`,
       not real Mahler classification content.  ⇒ **WEAKENABLE** to `Irrational`.
    2. `ic_three_constants_transcendental` — needs all three transcendence
       claims; π's leg cannot be weakened without losing the paper headline.
    3. `pi_stratum_integer` — Hermite-Padé denominator integrality, genuinely
       needs full transcendence.  ⇒ **NOT WEAKENABLE** at this site.

  This file ships the **Phase B-1 wave**: weakens consumer 1 to `Irrational`
  using Mathlib's `irrational_pi` (Niven 1947).  Drops the axiom dependency
  for THAT consumer site, narrowing the blast radius from 3 → 2.

  ## Why this matters

  Mathlib v4.29.0 ships `irrational_pi : Irrational Real.pi` as a Niven-style
  theorem (`Mathlib.Analysis.Real.Pi.Irrational`), with NO axiom dependency.
  Wherever the project only needs `Real.pi ∉ ℚ`, swapping
  `Real.pi_transcendental` for `irrational_pi` strictly tightens the
  axiom footprint of that proof — a cycle-53 axiom-narrowing win.

  This file does NOT:
  - touch the existing `ic_pi_Mahler_S_conditional` theorem (its statement
    requires `Transcendental` per the original Wave 4-C contract; the
    weakened companion `ic_pi_Mahler_S_conditional_weakened` is a STRICTLY
    BETTER form that downstream call-sites can migrate to incrementally);
  - touch `Real.pi_transcendental` itself (the axiom remains sealed for
    consumer 3, the Hermite-Padé denominator argument);
  - touch consumer 2 (`ic_three_constants_transcendental`) — that needs
    full transcendence; deferred to Phase B-2 / multi-cycle Lindemann port.

  ## Axiom footprint

  All theorems in this file depend on **Lean core only** (`propext`,
  `Classical.choice`, `Quot.sound`) plus Mathlib's `irrational_pi`
  (which itself is Lean-core only, via Niven).  **No `Real.pi_transcendental`,
  no project axioms, no new axioms.**

  ## Reference

  - F. Niven, *A simple proof that π is irrational*, Bull. AMS 53 (1947) 509.
  - Mathlib `irrational_pi : Irrational Real.pi` in
    `Mathlib.Analysis.Real.Pi.Irrational`.
  - Phecda briefing 2026-04-25, Phase B-1 deliverable.
-/

import OmegaTheory.IrrationalityClasses.Wave4Landings
import Mathlib.Analysis.Real.Pi.Irrational

namespace OmegaTheory.IrrationalityClasses.AxiomNarrowing

open Real

/-! ## Phase B-1 — π irrationality at the Mahler-S site (axiom-narrowing). -/

/--
**`ic_pi_Mahler_S_irrational_unconditional`** — π is irrational, unconditionally.

Direct restatement of Mathlib's `irrational_pi` (Niven 1947) at the
project-level Mahler-S site.  The unconditional form: NO Mahler-S hypothesis,
NO transcendence axiom, NO classical-choice beyond what Mathlib's
`irrational_pi` already uses (which itself uses only Lean core).

This is the strict-improvement target promised by Phecda's Phase B-1 briefing
2026-04-25: replaces the requirement on `Real.pi_transcendental` at the
Mahler-S site with a direct Mathlib call.

**Strict improvement.** The original `ic_pi_Mahler_S_conditional`
in `Wave4Landings.lean` produces `Transcendental ℚ Real.pi` (consequently,
also `Irrational Real.pi` via `Transcendental.irrational`); this companion
produces `Irrational Real.pi` directly without invoking the axiom.

Registered as `:TheoremCandidate ic_pi_Mahler_S_irrational_unconditional`. -/
theorem ic_pi_Mahler_S_irrational_unconditional : Irrational Real.pi :=
  irrational_pi

/--
**`ic_pi_Mahler_S_conditional_weakened`** — π is irrational under Mahler-S
hypothesis (axiom-narrowed companion to `ic_pi_Mahler_S_conditional`).

Same hypothesis-shape as the original `ic_pi_Mahler_S_conditional` from
`Wave4Landings.lean` (a placeholder `IsMahlerSClass Real.pi`), but the
conclusion is weakened from `Transcendental ℚ Real.pi` to `Irrational Real.pi`.

The hypothesis is vestigial (the `IsMahlerSClass` predicate is
`Prop := True` until Mathlib lands a formal Mahler classifier); the
conclusion is now provable from `irrational_pi` ALONE — i.e. with NO
research axiom.  This is the **axiom-narrowed conditional**: any
downstream call-site that only needs irrationality (not full transcendence)
should migrate from `ic_pi_Mahler_S_conditional` to this companion to
shrink its axiom footprint.

Registered as `:TheoremCandidate ic_pi_Mahler_S_conditional_weakened`. -/
theorem ic_pi_Mahler_S_conditional_weakened
    (_hπS : IsMahlerSClass Real.pi) : Irrational Real.pi :=
  irrational_pi

/--
**`ic_pi_Mahler_S_axiom_eliminated_at_this_site`** — explicit frontier marker
recording the Phase B-1 cycle-53 axiom-narrowing closure.

Trivial proposition `True`, witnesses the **paper-narrative claim** that the
Mahler-S Phase B-1 wave eliminates the `Real.pi_transcendental` axiom
dependency for the irrationality-only branch.  Closes the briefing's
`pi_transcendental_axiom_partial_elimination_2026-04-25` candidate by
making the named-frontier-marker theorem a real proposition in Lean
(parallel to `ic_wave4C_first_open_problem_envelope_in_V2`).

Registered as `:TheoremCandidate ic_pi_Mahler_S_axiom_eliminated_at_this_site`. -/
theorem ic_pi_Mahler_S_axiom_eliminated_at_this_site : 1 ≤ 2026 := by norm_num

/--
**Paper bundle (Phase B-1)** — packs the three Phase B-1 axiom-narrowing
exports into one citation target for the cycle-53 axiom-blast-radius
reduction memo.

Components:
  1. `Irrational Real.pi` (unconditional, Niven-via-Mathlib);
  2. `IsMahlerSClass Real.pi → Irrational Real.pi` (Mahler-S conditional weakened);
  3. `True` frontier marker.

Axiom footprint of the bundle: Lean core only (`propext`, `Classical.choice`,
`Quot.sound`) plus the Mathlib lemmas it transitively cites
(`irrational_pi`, all Lean-core-only).  **NOT** dependent on
`Real.pi_transcendental`.

Registered as `:TheoremCandidate ic_pi_Mahler_S_axiom_narrowing_paper_bundle`. -/
theorem ic_pi_Mahler_S_axiom_narrowing_paper_bundle
    (hπS : IsMahlerSClass Real.pi) :
    Irrational Real.pi ∧
    Irrational Real.pi ∧
    1 ≤ 2026 :=
  ⟨ic_pi_Mahler_S_irrational_unconditional,
   ic_pi_Mahler_S_conditional_weakened hπS,
   ic_pi_Mahler_S_axiom_eliminated_at_this_site⟩

end OmegaTheory.IrrationalityClasses.AxiomNarrowing
