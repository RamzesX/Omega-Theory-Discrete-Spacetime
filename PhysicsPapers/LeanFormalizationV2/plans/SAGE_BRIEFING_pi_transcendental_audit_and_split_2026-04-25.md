# SAGE BRIEFING — `pi_transcendental_audit_replace_with_irrational_pi_where_possible`

**Author**: Phecda (grothendieck-sage), 2026-04-25 cycle-53 Phase A.
**Build state**: 3,941 GREEN, 1 paper-headline axiom (`Real.pi_transcendental`).

## Candidate

`pi_transcendental_axiom_blast_radius_audit_and_partial_replacement`

## Priority

**HIGH** — `Real.pi_transcendental` is the **last** paper-headline axiom in the
substrate stack.  Eliminating it is the cycle-53+ axiom-narrowing mandate.  This
briefing is the **prerequisite audit** before a wizard can attack the elimination.

## Live audit (Cypher, 2026-04-25)

```cypher
MATCH (consumer:Theorem)-[:APPLIES|ASSUMES]->
      (ax:Axiom {name: 'OmegaTheory.Irrationality.HermitePade.Real.pi_transcendental'})
RETURN DISTINCT consumer.name
```

Returns **3 consumers** (no others):

1. `OmegaTheory.IrrationalityClasses.ic_pi_Mahler_S_conditional`
   — needs `Transcendental ℚ Real.pi` directly (Mahler S ⇒ Transcendental).
2. `OmegaTheory.IrrationalityClasses.ic_three_constants_transcendental`
   — capstone of three-irrationals transcendence statement.
3. `OmegaTheory.Irrationality.HermitePade.pi_stratum_integer`
   — Hermite-Padé denominator integrality.

## Crucial Mathlib facts (verified 2026-04-25)

**Mathlib already provides** (`mcp__neo4j-math__read_neo4j_cypher` confirms):
- `irrational_pi : Irrational Real.pi` — Niven's proof (Mathlib core).
- `irrational_cos_rat_mul_pi : ∀ q : ℚ, q ≠ 0 → Irrational (Real.cos (q · Real.pi))` — Niven generalization.
- `Transcendental.irrational : Transcendental ℚ x → Irrational x` (one direction is
  trivial, the other is the open Lindemann-Weierstrass).

**Crucial gap**: Mathlib 4.29.0 does **NOT** ship `Real.pi_transcendental`. The
Mathlib graph has `Polynomial.transcendental_X`, `Transcendental.aeval`, but no
`pi_transcendental`. So the axiom CANNOT be removed by upstream import — it must
be either ported from Lindemann-Weierstrass (multi-cycle) or the consumer can
weaken its hypothesis from `Transcendental` to `Irrational`.

## Triage of the 3 consumers

### Consumer 1: `ic_pi_Mahler_S_conditional`

**Statement**: `IsMahlerSClass Real.pi → Transcendental ℚ Real.pi`.

**Audit**: The hypothesis `IsMahlerSClass` is currently a placeholder marker
that does not contribute proof content.  The proof uses `pi_transcendental`
directly.

**Resolution path**:
- (A) **WEAKEN** target to `IsMahlerSClass Real.pi → Irrational Real.pi`. This
  is provable in 1 line via `irrational_pi`. The Mahler-S typeclass already
  carries irrationality semantics; transcendence was the over-claim.  Drops
  axiom dependency for THIS consumer.
- (B) **KEEP** `Transcendental` claim by axiomatizing differently — leave for
  Lindemann-Weierstrass port.

**Recommendation**: take path (A); add a separate `ic_pi_Mahler_S_transcendental_conditional`
keeping the original transcendence statement under axiom dependence — labelled
as `RESEARCH_ONLY`.

### Consumer 2: `ic_three_constants_transcendental`

**Statement**: `Transcendental ℚ Real.pi ∧ Transcendental ℚ Real.exp(1) ∧ Transcendental ℚ (Catalan G)`.

**Audit**: This is the FULL transcendence claim for all 4 irrationals.  Cannot
be weakened to `Irrational` without losing the paper headline.

**Resolution path**:
- (A) **KEEP** as is, but mark `assumes_pi_transcendental_axiom`.
- (B) **DECOMPOSE** into parts: provable parts (e is transcendental — Mathlib
  has `Transcendental.e` via Hermite's proof? CHECK upstream), conjectural
  parts (Catalan G — open), and bridged parts (π — sealed inside an axiom).

**Recommendation**: use (B) — wizard splits the bundle 3-way.  At least the
e-part may be Mathlib-portable (see Consumer 3 path).

### Consumer 3: `pi_stratum_integer`

**Statement**: Hermite-Padé denominator integrality at the π-stratum.

**Audit**: Uses `Real.pi_transcendental` to invoke the Lindemann-Weierstrass
matrix nondegeneracy.  Pure math content — no easy weakening.

**Resolution path**:
- (A) Port a single Lindemann-Weierstrass matrix lemma from a Hermite-Padé
  textbook (Sigel's *Transcendental Numbers* or Beukers-Bezivin) and
  re-derive the denominator argument.  Multi-cycle.
- (B) Keep as is and accept this is the bottleneck for the axiom.

**Recommendation**: (B); flag as `MUST_PORT_LINDEMANN` for the multi-cycle
program below.

## Output of this briefing

Two distinct deliverables:

### Phase B-1 (cycle 53): WEAKEN ic_pi_Mahler_S_conditional

A wizard ports `ic_pi_Mahler_S_conditional` to use `Irrational` instead of
`Transcendental`.  Add `ic_pi_Mahler_S_irrational_unconditional` —
**unconditional** (no Mahler-S hypothesis needed; `irrational_pi` from Mathlib
core is sufficient).  Drops axiom dependency at this site.

### Phase B-2 (cycle 53+): SPLIT ic_three_constants_transcendental

A wizard splits the 3-way capstone:
- `ic_e_transcendental` — bottlenecked by Mathlib `Transcendental.e` if
  available, else axiomatized (BUT `Transcendental.e` IS likely in Mathlib —
  Hermite 1873 is much older + simpler than Lindemann's π proof).
- `ic_pi_transcendental` — keeps the axiom under a clearly-named alias
  `pi_transcendental_assumed_pending_lindemann_port`.
- `ic_catalan_transcendental` — flag as conjectural (Zudilin 2019; not even
  irrationality is settled).

### Multi-cycle program: PORT_LINDEMANN_WEIERSTRASS

Single decomposed Mathlib-port plan:
1. Port `Hermite.differential_lemma` (1873).
2. Port `Lindemann_step_1` (algebraic α → e^α transcendental over ℚ̄).
3. Apply at α = iπ to get cos(π) = -1 transcendental contradiction → π transcendental.
4. Each step ≤ 30 Lean lines; whole port = 8-12 cycles.

## Target file (audit-only, no Lean edits)

**NEW**: `OmegaTheory/Irrationality/HermitePade/AxiomNarrowing.lean` (Phase B-1)

This file weakens `ic_pi_Mahler_S_conditional` per Phase B-1 above — exactly
ONE 1-line theorem replacing transcendence with irrationality, plus a 2-line
unconditional analogue.

## Statement (Lean) — Phase B-1 only

```lean
namespace OmegaTheory.IrrationalityClasses.AxiomNarrowing

open Real

/-- **Unconditional irrationality** of π — replaces the `pi_transcendental` axiom
    requirement at this site. Uses Mathlib's `irrational_pi` (Niven 1947). -/
theorem ic_pi_Mahler_S_irrational_unconditional : Irrational Real.pi := irrational_pi

/-- **Weakened Mahler conditional** — drops transcendence to irrationality. -/
theorem ic_pi_Mahler_S_conditional_weakened
    (h : IsMahlerSClass Real.pi) : Irrational Real.pi := irrational_pi

/-- **Strict-improvement marker**: this site no longer needs `Real.pi_transcendental`. -/
theorem ic_pi_Mahler_S_axiom_eliminated_at_this_site : True := trivial
```

## Premise candidates (top-5)

1. `Mathlib.Analysis.SpecialFunctions.Polynomials.irrational_pi`
   — Niven's proof, Mathlib core, NO axiom dependency.
2. `Mathlib.Analysis.Transcendental.Transcendental.irrational`
   — Transcendental ⇒ Irrational direction.
3. `OmegaTheory.IrrationalityClasses.IsMahlerSClass`
   — typeclass under audit.
4. `OmegaTheory.IrrationalityClasses.ic_pi_Mahler_S_conditional`
   — ORIGINAL theorem to be deprecated.
5. `OmegaTheory.Irrationality.HermitePade.Real.pi_transcendental`
   — the axiom to drop a usage of.

## Off-limits files

- `OmegaTheory/Irrationality/HermitePade/PiStratum.lean` — axiom site; READ-ONLY.
- `OmegaTheory/IrrationalityClasses/Basic.lean` — IsMahlerSClass definition; READ-ONLY.
- `OmegaTheory/IrrationalityClasses/Separation.lean` — uses both; READ-ONLY.

## Estimated complexity

**S** (small) — 2-3 hours. The Phase B-1 file is ≤ 30 lines.  Risk: the Mathlib
import path may need adjustment (`Mathlib.Analysis.SpecialFunctions.Pi`,
`Mathlib.Analysis.IrrationalNumbers`); wizard checks via `mcp__lean-lsp__lean_loogle "irrational_pi"`.

## Strategic note

- **First Mathlib-only-tools step toward axiom elimination**.
- Phase B-1 partially clears the blast radius: 1/3 of consumers stops requiring
  the axiom.
- Remaining 2/3 will need the multi-cycle Lindemann port.
- Recommend wizard authoring this Phase B-1 file in cycle 53; mark
  `pi_transcendental_axiom_partial_elimination_2026-04-25` as DONE in graph.
- `:GraphFinding paper_worthy=true` for the cycle-53 closure note: "axiom blast
  radius 3 → 2".
