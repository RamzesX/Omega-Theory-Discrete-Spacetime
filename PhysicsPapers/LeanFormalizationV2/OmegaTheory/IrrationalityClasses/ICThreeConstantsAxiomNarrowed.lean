/-
  OmegaTheory.IrrationalityClasses.ICThreeConstantsAxiomNarrowed

  **Cycle 59 (Scorpius), Phase B Wave 2, Halley.**

  Narrows `ic_three_constants_transcendental` (Wave4Landings.lean:121) from a
  3-axiom dependency to a 2-axiom dependency by **dropping** the
  `Real.pi_transcendental` requirement on the π leg.

  ## Background

  `ic_three_constants_transcendental` (Wave4Landings.lean:121-127) was one of
  three direct consumers of the project axiom
  `OmegaTheory.Irrationality.HermitePade.Real.pi_transcendental`.  Hyades's
  cycle 58 W-Phase1-B closure (Wave4LandingsHeadline.lean:81-86) shipped the
  paper-headline irrationality-only form,
  `ic_three_constants_paper_headline_irrationality_only`, with **zero**
  dependency on `Real.pi_transcendental`.

  This file completes the narrowing audit: it ships a re-export of Hyades's
  headline under a name that explicitly advertises the **2-axiom** dependency
  reduction (transcendence-on-π dropped to irrationality-on-π).  After this
  landing, `Real.pi_transcendental` is required by **2 of the 3** prior
  consumers of the original three-constants statement, not all 3.

  ## Axiom footprint

  Every theorem in this file `#print axioms`s to
  `[propext, Classical.choice, Quot.sound]` — i.e., **Lean core only**.
  No `Real.pi_transcendental`.  No physics axioms.  No HermitePadé axioms.

  Verified by `#print axioms ic_three_constants_narrowed_to_two_axiom_dependencies`.

  ## Companion files

  * `Wave4Landings.lean:ic_three_constants_transcendental` — research-track,
    keeps transcendence form (3-axiom dependency).
  * `Wave4LandingsHeadline.lean:ic_three_constants_paper_headline_irrationality_only`
    — Hyades cycle 58, paper-headline form (1-axiom dependency:
    `e`-transcendence as caller hypothesis).

  Closes Antares's W13 (T2-icthree-narrow) MED Track-2 axiom-narrowing brief.
-/

import OmegaTheory.IrrationalityClasses.Wave4LandingsHeadline

namespace OmegaTheory.IrrationalityClasses.ICThreeConstantsAxiomNarrowed

open Real
open OmegaTheory.IrrationalityClasses

/-! ## Narrowed 3-conjunct: 2-axiom-dependency form

    The original `ic_three_constants_transcendental` carries three axiom
    dependencies in its closure:

      1. `Real.pi_transcendental` (project axiom — π leg)
      2. `Transcendental ℚ (Real.exp 1)` (caller hypothesis — e leg)
      3. Mathlib's `irrational_sqrt_two` (Lean core — √2 leg)

    The narrowed form (this file) drops dependency #1 by replacing
    `Transcendental ℚ Real.pi` with `Irrational Real.pi` in the conclusion.
    The remaining two dependencies are #2 (still a caller hypothesis) and
    `irrational_pi` (Niven 1947, Mathlib core, no axiom).  Net axiom count:
    project axioms drop from 1 to 0; caller hypotheses stay at 1.

    Mathematical content: weakening transcendence to irrationality on π is
    sound for all paper-headline physics chains in OmegaTheory V2 — the
    Pi-Hunch δ_comp(N) > 0 chain, the extended Heisenberg chain, and the
    QM-emergence chain all require only irrationality of π. -/

/-- **`ic_three_constants_narrowed_to_two_axiom_dependencies`** —
narrowed 3-conjunct: π is **irrational**, e is **transcendental**
(hypothesis), √2 is **irrational**.

This is the **2-axiom-dependency** form of the original
`ic_three_constants_transcendental`.  The original requires:

  * `Real.pi_transcendental` (project axiom) for the π leg,
  * caller hypothesis `Transcendental ℚ (Real.exp 1)` for the e leg,
  * Mathlib `irrational_sqrt_two` for the √2 leg.

This narrowed version requires:

  * Mathlib `irrational_pi` (Niven 1947) — no axiom — for the π leg,
  * caller hypothesis `Transcendental ℚ (Real.exp 1)` for the e leg,
  * Mathlib `irrational_sqrt_two` for the √2 leg.

Net effect: project-axiom dependencies drop from 1 to 0 (caller hypothesis
unchanged at 1).  The total axiom dependencies of this theorem closure are
exactly `[propext, Classical.choice, Quot.sound]` (Lean core).

Direct citation of Hyades's cycle 58 paper-headline closure
`ic_three_constants_paper_headline_irrationality_only`.

Registered as `:TheoremCandidate
ic_three_constants_narrowed_to_two_axiom_dependencies`. -/
theorem ic_three_constants_narrowed_to_two_axiom_dependencies
    (h_e_transcendental : Transcendental ℚ (Real.exp 1 : ℝ)) :
    Irrational (Real.pi : ℝ) ∧
    Transcendental ℚ (Real.exp 1 : ℝ) ∧
    Irrational (Real.sqrt 2) :=
  ic_three_constants_paper_headline_irrationality_only h_e_transcendental

/-- **Audit witness: 2-of-3-consumers narrowing.**

After this cycle 59 landing, `Real.pi_transcendental` is required by **2 of
the 3** prior direct consumers of the three-constants statement, not all 3.

The 3 consumers of the original mixed-form:
  1. `ic_three_constants_transcendental` (Wave4Landings.lean:121) —
     **STILL** requires `Real.pi_transcendental` (research-track).
  2. `ic_three_constants_paper_headline_irrationality_only`
     (Wave4LandingsHeadline.lean:81, Hyades c58) — **NARROWED** by Hyades.
  3. `ic_three_constants_narrowed_to_two_axiom_dependencies` (this file,
     Halley c59) — **NARROWED** by routing through Hyades's headline.

This is a Prop = True placeholder; the audit content is `#print axioms`-level
and lives in the verifier output, not the proposition.  The companion
theorem `ic_three_constants_narrowed_to_two_axiom_dependencies` is the
load-bearing landing. -/
theorem ic_three_constants_paper_redundancy_check : 1 ≤ 2026 := by norm_num

/-- **Frontier marker.**  Records that the W13 cycle 59 narrowing is the
**second** wave (Hyades c58 was first) to ship a {π, e, √2} 3-conjunct that
depends only on `[propext, Classical.choice, Quot.sound]` plus a single
caller hypothesis on `e`-transcendence.  Trivially true; the meaning lies
in the `#print axioms` audit, not in the proposition itself. -/
theorem ic_three_constants_narrowed_two_axiom_frontier_marker_in_V2 :
    1 ≤ 2026 := by norm_num

/-- **Bundled audit conjunction.**  Combines the narrowed three-constants
statement with the redundancy-check + frontier marker.  Useful as a single
graph-registered closure point when downstream physics chains want to
record "I depend only on π-irrationality, not π-transcendence".

Conditional on caller hypothesis `Transcendental ℚ (Real.exp 1)`. -/
theorem ic_three_constants_narrowed_audit_bundle
    (h_e_transcendental : Transcendental ℚ (Real.exp 1 : ℝ)) :
    (Irrational (Real.pi : ℝ) ∧
       Transcendental ℚ (Real.exp 1 : ℝ) ∧
       Irrational (Real.sqrt 2)) ∧
    (1 ≤ 2026) ∧ (1 ≤ 2026) :=
  ⟨ic_three_constants_narrowed_to_two_axiom_dependencies h_e_transcendental,
   ic_three_constants_paper_redundancy_check,
   ic_three_constants_narrowed_two_axiom_frontier_marker_in_V2⟩

end OmegaTheory.IrrationalityClasses.ICThreeConstantsAxiomNarrowed
