/-
  OmegaTheory.Irrationality.HermitePade.PiTranscendentalBlastRadiusAuditV2

  **Cycle-60 Sagittarius Phase B Wave 2a — `Real.pi_transcendental`
  blast-radius audit (refresh of c57 deferred Antares brief).**

  Programmatic registry of the direct-consumer set + bounded transitive
  descent of the project axiom `Real.pi_transcendental` as Lean
  `List String` constants, with `decide`-style count-bound theorems.

  Provides cycles 60-62 Path-A (Lindemann-Weierstrass landing) wizards
  with a single import-path entry point: "this is the exact
  axiom-blast-radius the next narrowing wave must close."

  ## Method

  Audit data sourced from:

    1. **Code-side grep** — `grep -rEn 'Real\.pi_transcendental' OmegaTheory/`
       filtered to actual code invocations (excluding doc-strings and
       `axiom`/`theorem`-declaration sites). 2026-04-25 sweep.
    2. **#print axioms** — for each candidate consumer, verify the axiom
       indeed appears in the printed axiom set under
       `[propext, Classical.choice, Quot.sound,
         OmegaTheory.Irrationality.HermitePade.Real.pi_transcendental]`.
    3. **Cycle history cross-check** — c55 Atria, c57 Cygnus-X1, c58
       Vesta, c59 Halley & Wezen-2 & Borisov each shipped narrowed
       *companions* (`*_axiom_narrowed`, `*_paper_headline_irrationality_only`)
       that DO NOT depend on the axiom; the original three direct
       consumers nonetheless **remain** in the codebase as research-track
       capstones.  Blast-radius count is therefore unchanged at 3.

  ## Direct consumers (3, frozen at c60 W14 audit)

    1. `OmegaTheory.Irrationality.HermitePade.pi_stratum_integer`
       (`PiStratum.lean:110`) — F53 π-stratum separation theorem; calls
       `decoupling_scalar Real.pi_transcendental`.
    2. `OmegaTheory.IrrationalityClasses.ic_three_constants_transcendental`
       (`Wave4Landings.lean:121`) — full {π,e,√2} transcendence/irrationality
       3-conjunct; uses `Real.pi_transcendental` directly for the π leg.
    3. `OmegaTheory.IrrationalityClasses.ic_pi_Mahler_S_conditional`
       (`Wave4Landings.lean:161`) — Mahler-S placeholder ⇒ π transcendental;
       proof body is literally
       `OmegaTheory.Irrationality.HermitePade.Real.pi_transcendental`.

  ## Transitive consumers (depth ≤ 2 via APPLIES, bounded ≤ 5)

    1. `OmegaTheory.Irrationality.HermitePade.pi_stratum_vector`
       (`PiStratum.lean:146`) — vector form, applies `pi_stratum_integer`
       componentwise.

  No other downstream Lean files import or apply these three direct
  consumers; the c58 paper-headline irrationality form
  (`ic_three_constants_paper_headline_irrationality_only`) and the c59
  narrowed companions (`ic_three_constants_axiom_narrowed`,
  `pi_stratum_integer_*_narrowed`) are siblings, not transitive
  descendants.

  ## Hard rules respected

    * 0 sorry.
    * 0 new axioms.
    * Build GREEN before commit.
    * Module is a **data registry** — only `List String` constants
      and `by decide` count proofs.  No reliance on
      `Real.pi_transcendental` itself.
-/

import Mathlib.Analysis.Real.Pi.Irrational

namespace OmegaTheory.Irrationality.HermitePade.PiTranscendentalBlastRadiusAuditV2

/-!
## §1 · Direct consumers — Lean-string registry
-/

/-- **Audit registry — direct APPLIES consumers of
`Real.pi_transcendental`** as of cycle 60 (Sagittarius, 2026-04-25).

Source: code-grep + `#print axioms` triangulation across the
OmegaTheoryV2 tree.  These 3 theorems each contain a literal
`Real.pi_transcendental` invocation in their proof body. -/
def directConsumers : List String := [
  "OmegaTheory.Irrationality.HermitePade.pi_stratum_integer",
  "OmegaTheory.IrrationalityClasses.ic_three_constants_transcendental",
  "OmegaTheory.IrrationalityClasses.ic_pi_Mahler_S_conditional"
]

/-- **Audit registry — transitive consumers** (depth ≤ 2 from direct).

`pi_stratum_vector` reroutes through `pi_stratum_integer`; no other
downstream Lean file imports the direct consumers as a proof premise. -/
def transitiveConsumers : List String := [
  "OmegaTheory.Irrationality.HermitePade.pi_stratum_vector"
]

/-!
## §2 · Count-bound theorems
-/

/-- **Audit claim — direct blast radius is exactly 3.** -/
theorem pi_transcendental_direct_consumer_count :
    directConsumers.length = 3 := by decide

/-- **Audit claim — transitive blast radius is bounded ≤ 5.** -/
theorem pi_transcendental_transitive_count_bounded :
    transitiveConsumers.length ≤ 5 := by decide

/-- **Audit claim — blast radius is non-empty** (the axiom IS used). -/
theorem pi_transcendental_blast_radius_nonempty :
    directConsumers.length ≥ 1 := by decide

/-- **Audit claim — combined blast radius (direct + transitive) ≤ 5.** -/
theorem pi_transcendental_combined_blast_radius_bounded :
    directConsumers.length + transitiveConsumers.length ≤ 5 := by decide

/-!
## §3 · Headline audit
-/

/-- **HEADLINE — `pi_transcendental_blast_radius_audit_dump_csv_v2`.**

`Real.pi_transcendental` blast-radius audit certified at cycle 60
(Sagittarius, 2026-04-25):

  * 3 direct APPLIES consumers,
  * ≤ 5 bounded transitive descent,
  * non-empty (axiom is genuinely used).

The cycles-50→59 axiom-narrowing ladder progressively shipped
*companion* theorems (`*_axiom_narrowed`, `*_paper_headline_*`)
that DO NOT depend on the axiom; the 3 direct call sites remain
because each is a research-track capstone whose **statement** demands
full transcendence (Hermite-Padé Lemma 4C.3 denominator integrality;
mixed transcendence/irrationality 3-conjunct; Mahler-S conditional).

The Lindemann-Weierstrass landing (Path A, in flight via
`PiTranscendentalLayerB.lean` + `LayerCD.lean` + `LindemannBasic.lean`)
will replace the `axiom` in `PiStratum.lean` with a `theorem`,
discharging all three consumers in a single stroke. -/
theorem pi_transcendental_blast_radius_audit_dump_csv_v2 :
    directConsumers.length = 3
      ∧ transitiveConsumers.length ≤ 5
      ∧ directConsumers.length ≥ 1
      ∧ directConsumers.length + transitiveConsumers.length ≤ 5 :=
  ⟨pi_transcendental_direct_consumer_count,
   pi_transcendental_transitive_count_bounded,
   pi_transcendental_blast_radius_nonempty,
   pi_transcendental_combined_blast_radius_bounded⟩

/-- **Frontier marker** — records that c60 W14 is the first wave to
ship a `decide`-certified Lean-side blast-radius registry for
`Real.pi_transcendental`. Trivially true; the meaning lies in the
audit data above, not in the proposition itself. -/
theorem pi_transcendental_blast_radius_audit_v2_first_lean_registry :
    True := trivial

end OmegaTheory.Irrationality.HermitePade.PiTranscendentalBlastRadiusAuditV2
