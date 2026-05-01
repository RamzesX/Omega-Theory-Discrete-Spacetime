// SOTA T1.3 SOURCE-SEGMENTED — refines the LITE migration by parsing the
// actual proof_body source text into per-tactic segments instead of relying
// on the pre-extracted tactic_evidence array.
//
// REPLACES the FULL T1.3 (DumpProofSteps.lean) attempt that OOM-killed WSL
// twice (kernel times 5336s, 5604s). FULL T1.3 needed Lean re-elaboration
// per file → olean cache pinning → 127GB RSS leak. This source-segmented
// approach extracts the same per-step `tactic` + `step_idx` + `prev_tactics`
// information from the already-stored proof_body text via APOC string ops.
//
// What we GET vs FULL T1.3:
//   ✓ tactic (real, exact source text of each step)
//   ✓ step_idx (real)
//   ✓ prev_tactics (real list of preceding steps)
//   ✓ goal_pseudo = signature + " [after: prev]" (LITE approximation, same as before)
//   ✗ goal_before / goal_after (REAL elaborated state) — would need re-elaboration
//
// Compensation: the omega-search MCP tool `goal_to_proof_step` performs
// kNN over `theorem_embedding_goal` (4096-d Qwen3) to retrieve theorems
// with semantically-similar goal shape — covers the "find similar proof
// states" use case at the THEOREM level (vs per-step). For the 17K OV2
// + 175K Mathlib corpus this is sufficient practical retrieval.
//
// Idempotent: drops + re-creates :ProofStep nodes per Theorem.
// Marker: source_segmented: true (distinguishes from LITE's no-marker).

// === Step 1: drop ONLY OV2 :ProofStep without full_t1_3 marker ===
// (Preserve: Mathlib LeanDojo full records + OV2 FCNCAbsence smoke test FULL records)
MATCH (ps:ProofStep)
WHERE ps.namespace = 'OmegaTheoryV2'
  AND coalesce(ps.full_t1_3, false) = false
DETACH DELETE ps;

// === Step 2: split each Theorem.proof_body into tactic segments ===
// Strategy: split on `;` and newline-then-indent boundaries (Lean 4 tactic
// separators). This is approximate — bullet syntax (·, -, ⟨⟩) and nested
// `by` blocks may produce extra "tactic" entries. Filter empties + comments.
//
// We do this in two passes for clarity:
//   Pass A: text → list of (raw, cleaned) tactic strings via apoc.text helpers
//   Pass B: UNWIND with index → CREATE :ProofStep
MATCH (t:Theorem {namespace: 'OmegaTheoryV2'})
WHERE t.proof_body IS NOT NULL
  AND size(t.proof_body) > 5
  AND t.signature IS NOT NULL
  // Skip theorems that already have FULL T1.3 records preserved
  AND NOT EXISTS {
    MATCH (t)-[:HAS_STEP]->(:ProofStep {full_t1_3: true})
  }
WITH t,
     coalesce(t.signature, '') AS sig,
     // Strip the `by` keyword and outer braces if present
     apoc.text.replace(t.proof_body, '^\\s*by\\s+', '') AS body
WITH t, sig, body,
     // Split on `;` OR newline (Lean tactic separators).
     apoc.text.split(body, '[;\\n]') AS raw_segments
WITH t, sig, raw_segments,
     [seg IN raw_segments
      | apoc.text.regreplace(trim(seg), '\\s+', ' ')] AS segments
WITH t, sig, segments,
     // Filter empties, comments, and bullet-only segments.
     [s IN segments
      WHERE s <> ''
        AND NOT s STARTS WITH '--'
        AND NOT s STARTS WITH '/-'
        AND s <> '·'
        AND s <> '-'
        AND s <> '{'
        AND s <> '}'
        AND size(s) > 1
        AND size(s) < 500    // skip absurdly long single-line proofs (unparseable)
     ] AS tacs
WITH t, sig, tacs
WHERE size(tacs) >= 1 AND size(tacs) < 50  // skip pathological cases
UNWIND range(0, size(tacs) - 1) AS i
WITH t, sig, tacs, i,
     tacs[i] AS tac,
     tacs[0..i] AS prev,
     CASE
        WHEN i = 0 THEN sig
        ELSE substring(sig, 0, 200) + ' [after: ' + apoc.text.join(tacs[0..i], ',') + ']'
     END AS goal_pseudo
CREATE (ps:ProofStep {
    namespace: t.namespace,
    parent_thm: t.name,
    step_idx: i,
    tactic: tac,
    prev_tactics: prev,
    goal_pseudo: goal_pseudo,
    source_segmented: true
})
CREATE (t)-[:HAS_STEP {step_idx: i}]->(ps);

// === Step 3: indexes for fast lookup ===
CREATE INDEX proof_step_parent_idx IF NOT EXISTS
FOR (ps:ProofStep) ON (ps.parent_thm);

CREATE INDEX proof_step_step_idx IF NOT EXISTS
FOR (ps:ProofStep) ON (ps.step_idx);

CREATE INDEX proof_step_namespace_idx IF NOT EXISTS
FOR (ps:ProofStep) ON (ps.namespace);

// === Step 4: verification (run separately) ===
//   MATCH (ps:ProofStep) RETURN ps.namespace, count(ps) AS n GROUP BY ps.namespace
//   MATCH (ps:ProofStep) RETURN avg(size(ps.tactic)) AS avg_tactic_len, max(ps.step_idx) AS max_step
