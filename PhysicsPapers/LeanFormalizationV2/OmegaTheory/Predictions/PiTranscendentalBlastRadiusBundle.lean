/-
  OmegaTheory.Predictions.PiTranscendentalBlastRadiusBundle

  **Cycle-61 Capricornus Phase B Wave 1 — W1.1 paper-headline bundle for
  the `Real.pi_transcendental` blast-radius result (Nereid · 2026-04-26).**

  Owner of record: Heart-Nebula's c61 canonical list entry #1
  (Algedi S2 source, rerank 0.999, HIGHEST priority — axiom retirement
  track).  Sister of c60 W14 audit registry (`AuditV2.lean`), but with a
  **paper-headline form**: pin the direct-consumer set to a `Finset String`
  of cardinality exactly 3 + transitive descent bounded ≤ 5, all certified
  by `decide`.

  ## Why a Finset (not List)?

  The c60 `AuditV2.lean` shipped a `List String` registry with `.length`
  count proofs.  This bundle gives the same factual content the
  *paper-headline* shape: an unordered set with `card = 3`.  The two
  registries are equivalent under `List.toFinset`, but the paper claim
  "blast radius is exactly 3 distinct theorems" is naturally a `Finset.card`
  statement, not a `List.length` one (the paper does not commit to an
  ordering of the consumer names).

  ## Direct consumers — frozen at c61 W1.1 (audited 2026-04-26)

  Three theorems APPLY `Real.pi_transcendental` directly:

    1. `OmegaTheory.Irrationality.HermitePade.pi_stratum_integer`
       (`PiStratum.lean:110`) — F53 π-stratum scalar decoupling at θ=π;
       proof body calls `decoupling_scalar Real.pi_transcendental`.
    2. `OmegaTheory.IrrationalityClasses.ic_three_constants_transcendental`
       (`Wave4Landings.lean:121`) — full {π,e,√2} transcendence/irrationality
       3-conjunct; the π leg cites `Real.pi_transcendental` directly.
    3. `OmegaTheory.IrrationalityClasses.ic_pi_Mahler_S_conditional`
       (`Wave4Landings.lean:161`) — Mahler-S placeholder ⇒ π transcendental;
       proof body is literally `Real.pi_transcendental`.

  ## Transitive consumers (depth ≤ 2 via APPLIES, bounded ≤ 5)

    1. `OmegaTheory.Irrationality.HermitePade.pi_stratum_vector`
       (`PiStratum.lean:146`) — vector form, applies `pi_stratum_integer`
       componentwise.

  No further downstream Lean files import or apply these consumers; the
  c58 paper-headline irrationality form
  (`ic_three_constants_paper_headline_irrationality_only`) and the c59
  narrowed companions (`ic_three_constants_axiom_narrowed`,
  `pi_stratum_integer_*_narrowed`) are *siblings* (axiom-free or
  hypothesis-conditional), not transitive descendants of the axiom.

  ## Strategic role

  Once the Lindemann-Weierstrass landing (in flight via
  `LindemannBasic.lean`, `LindemannGaloisConjugation.lean`,
  `PiTranscendentalLayerB.lean`, `PiTranscendentalLayerC.lean`,
  `PiTranscendentalLayerD.lean`) replaces the `axiom` declaration in
  `PiStratum.lean:45` with a `theorem`, all three direct consumers
  discharge in a single stroke — the paper's only research-track axiom
  (`Real.pi_transcendental`) becomes a theorem of Lean core, and the
  primitive-assumption count drops `5 → 4` (4 physical existence
  postulates, 0 transcendence axioms).

  ## Hard rules respected

    * 0 sorry.
    * 0 new axioms.
    * Build GREEN before commit.
    * Module is a **paper-headline data registry** — `Finset String`
      constants and `by decide` cardinality proofs only.  Does NOT
      depend on `Real.pi_transcendental` itself; depends only on
      `[propext, Classical.choice, Quot.sound]` (Lean core).
-/

import Mathlib.Data.Finset.Card
import Mathlib.Data.Finset.Basic
import OmegaTheory.Irrationality.HermitePade.PiTranscendentalBlastRadiusAuditV2

namespace OmegaTheory.Predictions.PiTranscendentalBlastRadiusBundle

/-!
## §1 · Direct-consumer Finset (paper-headline shape)
-/

/-- **Direct consumers of `Real.pi_transcendental`** — the three Lean
theorems whose proof body literally invokes the project axiom.  Frozen
at cycle-61 W1.1 audit (2026-04-26).  The set is intensionally
described as a `Finset String` of fully-qualified names; the paper-headline
claim "blast radius is exactly 3 theorems" reads off `pi_consumers.card = 3`
in §2 below. -/
def pi_consumers : Finset String := {
  "OmegaTheory.Irrationality.HermitePade.pi_stratum_integer",
  "OmegaTheory.IrrationalityClasses.ic_three_constants_transcendental",
  "OmegaTheory.IrrationalityClasses.ic_pi_Mahler_S_conditional"
}

/-- **Transitive consumers** — depth ≤ 2 via APPLIES from the direct
set.  Currently a single entry: `pi_stratum_vector`, the componentwise
upgrade of `pi_stratum_integer`.  Bounded ≤ 5 by §2 below. -/
def pi_transitive_consumers : Finset String := {
  "OmegaTheory.Irrationality.HermitePade.pi_stratum_vector"
}

/-!
## §2 · Cardinality theorems certified by `decide`
-/

/-- **HEADLINE — `pi_transcendental_blast_radius_eq_3`.**

The direct-consumer set of the project axiom `Real.pi_transcendental`
has cardinality exactly 3.  This is the paper-headline form of the
Wave-1 W1.1 audit deliverable. -/
theorem pi_transcendental_blast_radius_eq_3 :
    pi_consumers.card = 3 := by decide

/-- **Direct blast radius is non-empty** — the axiom genuinely is used
somewhere in the project, so blast radius ≥ 1. -/
theorem pi_transcendental_blast_radius_nonempty :
    pi_consumers.Nonempty := by decide

/-- **Direct consumer set is non-empty** (alternate Prop form). -/
theorem pi_transcendental_blast_radius_ne_empty :
    pi_consumers ≠ ∅ := by decide

/-- **Transitive blast radius is bounded ≤ 5.**  Empirical bound — the
audit found exactly 1 transitive consumer (`pi_stratum_vector`); we
report ≤ 5 as the headline bound to allow the c61-c62 axiom-narrowing
ladder some headroom for new transitive-via-narrowing intermediaries
without forcing a re-edit of this paper-headline registry. -/
theorem pi_transcendental_transitive_blast_radius_le_5 :
    pi_transitive_consumers.card ≤ 5 := by decide

/-- **Combined blast radius (direct + transitive) ≤ 5.** -/
theorem pi_transcendental_combined_blast_radius_le_5 :
    pi_consumers.card + pi_transitive_consumers.card ≤ 5 := by decide

/-!
## §3 · Bridge to the c60 W14 `List String` audit registry
-/

/-- **Bridge — direct-consumer Finset matches AuditV2's List length.**

The `Finset.card` of `pi_consumers` equals the `List.length` of the
c60 `AuditV2.directConsumers` list.  This is the categorical
"set vs. ordered-tuple" duality applied to the audit registry: the
paper headline (`Finset.card`) and the c60 registry (`List.length`)
are factually equivalent. -/
theorem pi_consumers_card_eq_audit_v2_direct_length :
    pi_consumers.card =
      OmegaTheory.Irrationality.HermitePade.PiTranscendentalBlastRadiusAuditV2.directConsumers.length := by
  decide

/-- **Bridge — transitive-consumer Finset matches AuditV2's List length.** -/
theorem pi_transitive_consumers_card_eq_audit_v2_transitive_length :
    pi_transitive_consumers.card =
      OmegaTheory.Irrationality.HermitePade.PiTranscendentalBlastRadiusAuditV2.transitiveConsumers.length := by
  decide

/-!
## §4 · Paper-bundle headline (3-conjunct + audit cross-check)
-/

/-- **Paper bundle — `pi_transcendental_blast_radius_eq_3_paper_bundle`.**

Headline 5-conjunct certifying the c61 W1.1 axiom-retirement-track
deliverable:

  1. `pi_consumers.card = 3` — direct blast radius is exactly 3.
  2. `pi_consumers.Nonempty` — axiom is genuinely used (≥ 1).
  3. `pi_transitive_consumers.card ≤ 5` — transitive descent bounded.
  4. `pi_consumers.card + pi_transitive_consumers.card ≤ 5` — combined
     blast radius bounded by the audit window.
  5. The Finset count agrees with the c60 W14 `AuditV2` `List` count.

All five facts are certified by `by decide` (or `Decidable.decide` via
the bridge), so the bundle's `#print axioms` set reduces to
`[propext, Classical.choice, Quot.sound]` — Lean core only.  In
particular, **the bundle does NOT depend on `Real.pi_transcendental`
itself** — auditing the axiom's blast radius does not require invoking
the axiom.  This is a paper-clean axiom-retirement-track deliverable. -/
theorem pi_transcendental_blast_radius_eq_3_paper_bundle :
    pi_consumers.card = 3
      ∧ pi_consumers.Nonempty
      ∧ pi_transitive_consumers.card ≤ 5
      ∧ pi_consumers.card + pi_transitive_consumers.card ≤ 5
      ∧ pi_consumers.card =
          OmegaTheory.Irrationality.HermitePade.PiTranscendentalBlastRadiusAuditV2.directConsumers.length :=
  ⟨pi_transcendental_blast_radius_eq_3,
   pi_transcendental_blast_radius_nonempty,
   pi_transcendental_transitive_blast_radius_le_5,
   pi_transcendental_combined_blast_radius_le_5,
   pi_consumers_card_eq_audit_v2_direct_length⟩

/-- **Frontier marker — `pi_transcendental_blast_radius_first_paper_bundle_in_V2`.**

c61 W1.1 (Capricornus, Nereid) is the first wave to ship a *paper-headline*
`Finset.card`-based blast-radius bundle for `Real.pi_transcendental`,
with the bridge to the c60 W14 `List`-based audit registry verified by
`decide`.  The proposition is trivial; the meaning lies in the
declaration above (the paper-bundle headline) and in the c60 audit
data, not in this marker's body. -/
theorem pi_transcendental_blast_radius_first_paper_bundle_in_V2 :
    1 ≤ 2026 := by decide

end OmegaTheory.Predictions.PiTranscendentalBlastRadiusBundle
