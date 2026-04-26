# NOTES — W1.1 Nereid · `pi_transcendental_blast_radius_eq_3` paper bundle

**Cycle:** 61 (Capricornus) · **Wave:** 1 · **Sage briefing:** Heart-Nebula
canonical-list entry #1 / Algedi S2 (rerank 0.999 · HIGHEST priority,
axiom retirement track) · **Date:** 2026-04-26.

## Landing summary

- **NEW file:** `OmegaTheory/Predictions/PiTranscendentalBlastRadiusBundle.lean`
  · 204 lines · 11 declarations
  (2 `def` + 9 `theorem`).
- **Build:** `lake build OmegaTheory.Predictions.PiTranscendentalBlastRadiusBundle
  --log-level=error` → `2682/2682 jobs GREEN` in 2.0 s on `~/lean-v2/`.
- **Sorry:** 0.
- **New axioms:** 0.
- **Headline `#print axioms`** for all five tested theorems
  (`pi_transcendental_blast_radius_eq_3`,
  `pi_transcendental_blast_radius_eq_3_paper_bundle`,
  `pi_consumers_card_eq_audit_v2_direct_length`,
  `pi_transcendental_blast_radius_nonempty`,
  `pi_transcendental_transitive_blast_radius_le_5`)
  = `[propext, Quot.sound]` only.  **Notably tighter than required:** no
  `Classical.choice`, no `Real.pi_transcendental`.  The blast-radius audit
  about the axiom does not invoke the axiom — paper-clean Lean-core-only
  deliverable.
- **md5:** `e0e14bf22da2ff8efbb566c3bfd0fbfa` · matches `~/lean-v2` ↔ `/mnt/c`.
- **Basic.lean import (parent batch):**
  `import OmegaTheory.Predictions.PiTranscendentalBlastRadiusBundle`
  — to be added by parent **after** the existing
  `OmegaTheory.Irrationality.HermitePade.PiTranscendentalBlastRadiusAuditV2`
  import block at `Basic.lean:4676`.

## Headline theorems (paper-bundle form)

| Name | Statement | Tactic |
|---|---|---|
| `pi_transcendental_blast_radius_eq_3` | `pi_consumers.card = 3` | `by decide` |
| `pi_transcendental_blast_radius_nonempty` | `pi_consumers.Nonempty` | `by decide` |
| `pi_transcendental_blast_radius_ne_empty` | `pi_consumers ≠ ∅` | `by decide` |
| `pi_transcendental_transitive_blast_radius_le_5` | `pi_transitive_consumers.card ≤ 5` | `by decide` |
| `pi_transcendental_combined_blast_radius_le_5` | `pi_consumers.card + pi_transitive_consumers.card ≤ 5` | `by decide` |
| `pi_consumers_card_eq_audit_v2_direct_length` | `pi_consumers.card = AuditV2.directConsumers.length` | `by decide` |
| `pi_transitive_consumers_card_eq_audit_v2_transitive_length` | (analogous for transitive) | `by decide` |
| **`pi_transcendental_blast_radius_eq_3_paper_bundle`** | 5-conjunct paper bundle | structural ⟨…⟩ |
| `pi_transcendental_blast_radius_first_paper_bundle_in_V2` | frontier marker | `trivial` |

## Direct-consumer set (frozen at c61 W1.1 audit)

```lean
def pi_consumers : Finset String := {
  "OmegaTheory.Irrationality.HermitePade.pi_stratum_integer",
  "OmegaTheory.IrrationalityClasses.ic_three_constants_transcendental",
  "OmegaTheory.IrrationalityClasses.ic_pi_Mahler_S_conditional"
}
```

Triangulated via:
1. `grep -rEn 'Real\.pi_transcendental' OmegaTheory/` filtered to actual
   proof-body invocations (excluded docstrings, `axiom` declaration site,
   and theorem-name mentions).
2. Direct read of `PiStratum.lean:110-128`, `Wave4Landings.lean:121-127`,
   `Wave4Landings.lean:161-164` confirming each citation in proof body.
3. Cross-check against c60 W14 `AuditV2.directConsumers` —
   bridge theorem `pi_consumers_card_eq_audit_v2_direct_length` certifies
   the two registries agree on cardinality.

## Why a `Finset` instead of the c60 `List`?

The c60 W14 Sagittarius audit (Kaus-Australis brief, landed by an earlier
wizard at `OmegaTheory/Irrationality/HermitePade/PiTranscendentalBlastRadiusAuditV2.lean`)
shipped a `List String` registry with `.length = 3` proofs.  This c61 W1.1
bundle gives the same factual content the **paper-headline shape**: an
unordered `Finset String` with `card = 3`.  The two registries are
extensionally equivalent via `List.toFinset`, but the paper claim
"Real.pi_transcendental's blast radius is exactly 3 distinct theorems" is
naturally a `Finset.card` statement (the paper does not commit to an
ordering of the consumer names).  A bridge theorem lifts the c60 `List`
count to the c61 `Finset` count.

## Mathlib lemmas used

- `Finset.card` (Mathlib.Data.Finset.Card)
- `Finset.Nonempty` (Mathlib.Data.Finset.Basic)
- `Finset.instDecidableEq` (auto-derived for `Finset String`) — enables
  the `by decide` tactic on cardinality + nonemptiness claims.

No lemmas from `Mathlib.Data.Real.Pi.Irrational`, `Mathlib.Analysis`, or
the project's own `Irrationality/` tree were needed — the bundle is
purely a registry of fully-qualified Lean names with cardinality
certificates.

## Strategic context

The c50→c60 axiom-narrowing ladder progressively shipped **companion**
theorems that DO NOT depend on `Real.pi_transcendental`:

- c50 W9 — degree-1 narrowing landed.
- c51 W8 — degree-2 conditional narrowing.
- c52 W10 — degree-3 narrowing.
- c58 W-Phase1-B (Hyades) — paper-headline 3-conjunct
  `ic_three_constants_paper_headline_irrationality_only` (axiom-free).
- c59 W9/W10 (Cygnus-X1, Ganymede) — `PiTranscendentalLayerB.lean` (Galois
  bridge framework, axiom-free up to `LindemannPremiseRat`/`Int`
  hypotheses).
- c60 W14 — `AuditV2.lean` `List`-registry of consumers.
- **c61 W1.1 (this) — `Finset`-registry paper-bundle headline.**

The 3 direct consumers have NOT been reduced; each is a research-track
capstone whose **statement** demands full transcendence.  Once the
in-flight Lindemann-Weierstrass landing
(`Irrationality/CustomMath/LindemannBasic.lean`,
`LindemannGaloisConjugation.lean`, `LindemannGaloisConjugationStep.lean`,
`HermitePade/PiTranscendentalLayerB.lean`,
`PiStratumIntegerNarrowed.lean`) replaces the `axiom` declaration in
`PiStratum.lean:45` with a `theorem`, all three direct consumers will
discharge in a single stroke; the project's last research-track axiom
(`Real.pi_transcendental`) becomes a theorem of Lean core, and the
primitive-assumption count drops `5 → 4` (4 physical existence
postulates, 0 transcendence axioms).

## graph_queries_run (per W1.1 brief — GRAPH-FIRST PROTOCOL)

| Query | Top-1 | Used in proof? |
|---|---|---|
| `mcp__omega-search__*` | (DOWN — embedder :7999 OFF for power hygiene) | n/a |
| Reranker `:7996` smoke test | `Finset.card eq 3 by decide` (rel 0.0020) | confirmed `decide` is the right tactic |
| Repo grep `Real.pi_transcendental` (filtered to proof-body uses) | 3 sites: `PiStratum.lean:128`, `Wave4Landings.lean:126`, `Wave4Landings.lean:164` | yes — fixed `pi_consumers` to those 3 |
| Repo grep `Finset.card.*= [0-9]\b` patterns | `Top20LeverageMenkib.lean:684` (`Finset.card_univ.trans (by decide)`) | confirmed `by decide` works on small finite Finsets |
| Existing-file scan for AuditV2 | `OmegaTheory/Irrationality/HermitePade/PiTranscendentalBlastRadiusAuditV2.lean` (already imported in `Basic.lean:4676`) | yes — the c60 `List` registry is the bridge target |
| Sandbox lean of `({"a","b","c"}:Finset String).card = 3 := by decide` | compiled clean | confirmed paper-headline `Finset` shape works |

`mcp__omega-orchestrator__omega_hammer_premise` and `propose_proof` were
not invoked because the deliverable is a **data registry** (no actual
mathematical premise lookup needed); the proof obligations are all
discharged by `by decide` on closed-term `Finset String` and `List String`
expressions.  The graph-grounded inputs were the 3 fully-qualified
consumer names, sourced from grep + read of the three direct-citation
sites; the audit's cardinality is the substantive claim, not the
proof technique.

## Off-limits respected

- ✅ Sister wizard files W1.2-W1.7 — NOT touched.
- ✅ All cycle 52-60 wizard files — NOT touched.
- ✅ `OmegaTheory/Irrationality/HermitePade/PiStratum*.lean` — NOT touched
  (read-only audit reference).
- ✅ `OmegaTheory/Irrationality/HermitePade/PiTranscendentalBlastRadiusAuditV2.lean`
  — imported only, NOT touched.
- ✅ `OmegaTheory/Spacetime/{Constants,Approximations,Uncertainty}.lean` —
  NOT touched.
- ✅ `OmegaTheory/Algebra/{LeanAlgebraLaplacian,LaplacianSpectralGap}*.lean`
  — NOT touched.
- ✅ `OmegaTheory/Foundations/OmegaAlgebraCohomologyClass.lean` — NOT
  touched.
- ✅ `OmegaTheory/Basic.lean` — NOT touched (parent owns batch); import
  line flagged above for parent integration.

## Build (verbatim)

```
$ cd ~/lean-v2 && ~/.elan/bin/lake build OmegaTheory.Predictions.PiTranscendentalBlastRadiusBundle --log-level=error
✔ [2682/2682] Built OmegaTheory.Predictions.PiTranscendentalBlastRadiusBundle (2.0s)
Build completed successfully (2682 jobs).
```

## Mirror state

| Path | md5 | exists |
|---|---|---|
| `~/lean-v2/OmegaTheory/Predictions/PiTranscendentalBlastRadiusBundle.lean` | `e0e14bf22da2ff8efbb566c3bfd0fbfa` | ✅ |
| `/mnt/c/.../LeanFormalizationV2/OmegaTheory/Predictions/PiTranscendentalBlastRadiusBundle.lean` | `e0e14bf22da2ff8efbb566c3bfd0fbfa` | ✅ |
