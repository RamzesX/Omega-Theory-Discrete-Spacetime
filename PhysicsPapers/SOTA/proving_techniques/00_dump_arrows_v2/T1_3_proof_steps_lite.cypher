// SOTA T1.3 LITE — ProofStep nodes from existing tactic_evidence
//
// FULL T1.3 (per PLAN.md) requires Lean LSP secondary pass via
// Lean.Elab.Tactic.evalTactic snapshot capture (~300 lines + ~1 week).
// LITE version: leverage already-extracted tactic_evidence array (T1.2 done)
// to materialize :ProofStep nodes WITHOUT running Lean.
//
// Schema:
//   (t:Theorem)-[:HAS_STEP]->(:ProofStep {
//     parent_thm: t.name,
//     step_idx:   0..N-1,
//     tactic:     t.tactic_evidence[i],
//     prev_tactics: t.tactic_evidence[0..i],   // for tactic-prefix retrieval
//     goal_pseudo: <signature> ++ "[after: " ++ join(prev_tactics, ',') ++ "]"
//   })
//
// goal_pseudo is a LITE approximation of the actual elaborated goal-state.
// Real per-step goals require LSP secondary pass (deferred).
// Even with this approximation, retrieval works for the "given prefix, what
// next?" use case because the prefix encodes the relevant proof history.
//
// IDEMPOTENT: drops + re-creates :ProofStep nodes per Theorem.
//
// Run via:
//   python3 -c "from neo4j import GraphDatabase; ..." (see loader script)
// OR via cypher-shell:
//   cypher-shell -u neo4j -p $OMEGA_NEO4J_PASSWORD -f T1_3_proof_steps_lite.cypher

// === Step 1: drop any existing :ProofStep for OV2 (idempotent re-run) ===
MATCH (ps:ProofStep {namespace: 'OmegaTheoryV2'})
DETACH DELETE ps;

// === Step 2: create :ProofStep nodes from tactic_evidence ===
MATCH (t:Theorem {namespace: 'OmegaTheoryV2'})
WHERE t.tactic_evidence IS NOT NULL
  AND size(t.tactic_evidence) >= 1
  AND t.signature IS NOT NULL
WITH t,
     coalesce(t.signature, '') AS sig,
     t.tactic_evidence AS tacs
UNWIND range(0, size(tacs) - 1) AS i
WITH t, sig, tacs, i,
     tacs[i] AS tac,
     tacs[0..i] AS prev,
     CASE
        WHEN i = 0 THEN sig
        ELSE substring(sig, 0, 200) + ' [after: ' + apoc.text.join(tacs[0..i], ',') + ']'
     END AS goal_pseudo
CREATE (ps:ProofStep {
    namespace: 'OmegaTheoryV2',
    parent_thm: t.name,
    step_idx: i,
    tactic: tac,
    prev_tactics: prev,
    goal_pseudo: goal_pseudo
})
CREATE (t)-[:HAS_STEP {step_idx: i}]->(ps);

// === Step 3: index parent_thm + step_idx for fast lookups ===
CREATE INDEX proof_step_parent_idx IF NOT EXISTS
FOR (ps:ProofStep) ON (ps.parent_thm);

CREATE INDEX proof_step_step_idx IF NOT EXISTS
FOR (ps:ProofStep) ON (ps.step_idx);

// === Step 4: Verify ===
// Run separately:
//   MATCH (ps:ProofStep {namespace: 'OmegaTheoryV2'}) RETURN count(ps) AS total
//   MATCH (ps:ProofStep) RETURN avg(ps.step_idx) AS avg_step_idx
//   MATCH (t:Theorem)-[:HAS_STEP]->(ps:ProofStep) RETURN count(ps) AS edge_count
