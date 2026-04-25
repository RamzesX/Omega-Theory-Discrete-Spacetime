# SAGE BRIEFING — `pi_transcendental_blast_radius_audit_csv`

**Author**: Zubeneschamali (grothendieck-sage), 2026-04-25 cycle-53 supplemental.
**Build state**: 3,941 GREEN, 1 paper-headline axiom (`Real.pi_transcendental`).

## Candidate

`pi_transcendental_blast_radius_audit_csv`

## Priority

**HIGH** — Track-2 (axiom elimination).  Sister of Phecda's
`pi_transcendental_audit_and_split` cycle-53 wizard, but **wider scope**:
this writes a comprehensive CSV that classifies EVERY top-level theorem in
the corpus by whether it depends transitively on `Real.pi_transcendental`,
distinguishing four classes:

| class | meaning | action |
|-------|---------|--------|
| `STRICT_TRANSCENDENCE` | needs full Lindemann-Weierstrass | KEEP |
| `IRRATIONALITY_SUFFICES` | only uses π is irrational | SWAP to `Real.irrational_pi` |
| `INDIRECT_VIA_DECOUPLING` | via Theorem 4C.3 chain only | DECOUPLE downstream |
| `SPURIOUS_IMPORT` | imports `Real.pi_transcendental` but never invokes it | DELETE import |

## Currently shipped (NOT this candidate)

- `OmegaTheory.Irrationality.HermitePade.AxiomNarrowing.pi_transcendental_audit_via_irrationality_witnesses`
  (cycle-53 in-flight; Phecda).
- 1 canonical `:Axiom` node `Real.pi_transcendental` — 9 transitive descendants
  in the graph (per `axiom_audit` 2026-04-25 result).

## What this candidate adds

A **read-only audit deliverable** under `plans/AUDIT_pi_transcendental_blast_radius_2026-04-25.md`
+ a Cypher report node `:GraphFinding {kind:'pi_transcendental_blast_radius_v1'}` 
classifying each transitive descendant into the 4 classes above.

This is **NOT a Lean theorem**. It is the upstream data product the wizard
needs in order to know which descendants the cycle-53 split-pattern can
target.  Output also annotates each descendant with the candidate mathlib
upstream reference (Niven `Real.irrational_pi`, partial L-W lemmas, etc.).

## Target file

**NEW**: `LeanFormalizationV2/plans/AUDIT_pi_transcendental_blast_radius_2026-04-25.md`

Format:

```markdown
# π-transcendental Blast-Radius Audit
| descendant | class | upstream-mathlib-candidate | action | confidence |
|------------|-------|----------------------------|--------|------------|
| ...        | ...   | ...                        | ...    | ...        |
```

## Statement / Workflow

This briefing closes the candidate by:
1. Running `axiom_audit(targets=...)` per descendant.
2. Cypher: `MATCH (a:Axiom {name:'Real.pi_transcendental'})<-[:ASSUMES|APPLIES*1..5]-(t)`
3. Manual classification per row (estimated 9-15 descendants).
4. Writing `AUDIT_*.md` + a `:GraphFinding` node with `paper_worthy:true`.
5. Recommending which class-2 ones the next cycle's wizard should swap.

## Premise candidates (Cypher / docs, no Lean)

1. `MATCH (t)-[r:ASSUMES|APPLIES*1..5]->(a:Axiom {name:'Real.pi_transcendental'})`
2. `MATCH (m:Theorem {namespace:'Mathlib'}) WHERE m.name CONTAINS 'irrational_pi'`
3. `MATCH (m:Theorem {namespace:'Mathlib'}) WHERE m.name CONTAINS 'transcendental'`
4. Phecda's cycle-53 split-pattern as exemplar of class-2 conversion.
5. Niven's proof of π irrationality (Mathlib `Real.irrational_pi`).

## Proof sketch

(No Lean proof; deliverable is `.md` + `:GraphFinding`.)

- **Step 1**: extract the 9-15 transitive descendants via Cypher.
- **Step 2**: for each, hover_info / open file, classify by USE pattern.
- **Step 3**: cross-reference against Mathlib `Real.irrational_pi`,
  `Liouville_irrational`, partial transcendence material.
- **Step 4**: write CSV + `:GraphFinding` paper_worthy.

## Off-limits files

- `OmegaTheory/Irrationality/HermitePade/AxiomNarrowing.lean` (Phecda READ-ONLY).
- All cycle-53 in-flight files.

## Estimated complexity

**S+** (small-plus) — 3-5 hours, mostly Cypher + classification.  No Lean
edits.

## Strategic note

This is the **prerequisite** for Track-2 wizards to know what to attack.
Without this audit, sage / wizards guess which descendants are class-2.
With this audit, every wizard cycle has 2-4 ready-to-go axiom-elimination
targets.
