// SOTA T1.1 + T6.11 — set per-Theorem difficulty proxy + freshness boost
//
// Goal: enable auto-Tier (99 / 80 / Heart) ranking for the prove-wizard
//       and weight freshly-proved theorems higher in retrieval.
//
// Authority: ~/.claude/plans/binary-painting-dijkstra.md (T1.1 + T6.11)
// Memory:    feedback_decomposition_research_v2_2026-04-30.md technique #11
// Created:   2026-04-30
//
// Idempotent — re-running updates difficulty/tier/freshness in place.
// Run via: cypher-shell -a bolt://localhost:7687 -u neo4j -p omegatheory2026 -f set_difficulty_and_freshness.cypher
// or via:  mcp__neo4j-math__write_neo4j_cypher
//
// PASS 1 — Difficulty proxy (T1.1)
// =================================
// difficulty = log10(byte_len + 1)
//            + 0.3 · #applies (out-degree on APPLIES edges)
//            + 0.5 · count_have_obtain_refine (in proof_body)
//            + 1.0 · count_NAMED_in_signature
// Tier:
//   tier = "99"     if difficulty ≤ Q33  (routine — closed by exact?/aesop)
//   tier = "80"     if Q33 < difficulty ≤ Q66  (medium — manual w/ LSP help)
//   tier = "Heart"  if difficulty > Q66  (hard — requires 5-PHASE HYBRID)

// Step 1.A: Compute raw difficulty per Theorem (writes t.difficulty)
CALL apoc.periodic.iterate(
  '
   MATCH (t:Theorem {namespace: "OmegaTheoryV2"})
   WHERE t.proof_body IS NOT NULL OR t.signature IS NOT NULL
   RETURN t
  ',
  '
   WITH t,
        coalesce(toFloat(size(t.proof_body)), 0.0) AS body_len,
        coalesce(t.signature, "") AS sig
   WITH t, body_len, sig,
        // count tactic-keywords in proof_body (cheap regex-free string match)
        size(split(coalesce(t.proof_body, ""), "have ")) - 1
          + size(split(coalesce(t.proof_body, ""), "obtain ")) - 1
          + size(split(coalesce(t.proof_body, ""), "refine ")) - 1
          AS n_have_obtain_refine,
        // out-degree on APPLIES (proxy for fan-out / lemma usage)
        size((t)-[:APPLIES]->()) AS n_applies,
        // count "T5_NAMED_" / "_NAMED_" tokens in signature (residual hypothesis count)
        size(split(sig, "_NAMED_")) - 1 AS n_named
   SET t.difficulty =
       toFloat(log(body_len + 1.0) / log(10.0))
       + 0.3 * toFloat(n_applies)
       + 0.5 * toFloat(n_have_obtain_refine)
       + 1.0 * toFloat(n_named),
       t.n_have_obtain_refine = n_have_obtain_refine,
       t.n_named_in_sig = n_named,
       t.difficulty_set_at = datetime()
  ',
  {batchSize: 1000, parallel: false}
) YIELD batches, total
RETURN "difficulty_pass" AS pass, batches, total;

// Step 1.B: Compute tier quantile thresholds + assign tier
// (single-shot since quantile depends on full distribution)
MATCH (t:Theorem {namespace: "OmegaTheoryV2"})
WHERE t.difficulty IS NOT NULL
WITH collect(t.difficulty) AS scores
WITH scores,
     scores[toInteger(size(scores) * 0.33)] AS q33,
     scores[toInteger(size(scores) * 0.66)] AS q66
// Persist thresholds as graph metadata
MERGE (m:DifficultyThresholds {namespace: "OmegaTheoryV2"})
SET m.q33 = q33,
    m.q66 = q66,
    m.computed_at = datetime(),
    m.method = "quantile_0.33_0.66"
RETURN q33, q66;

// Step 1.C: Assign tier based on q33/q66
CALL apoc.periodic.iterate(
  '
   MATCH (t:Theorem {namespace: "OmegaTheoryV2"})
   WHERE t.difficulty IS NOT NULL
   MATCH (m:DifficultyThresholds {namespace: "OmegaTheoryV2"})
   RETURN t, m.q33 AS q33, m.q66 AS q66
  ',
  '
   SET t.tier = CASE
     WHEN t.difficulty <= q33 THEN "99"
     WHEN t.difficulty <= q66 THEN "80"
     ELSE "Heart"
   END
  ',
  {batchSize: 2000, parallel: false}
) YIELD batches, total
RETURN "tier_pass" AS pass, batches, total;

// PASS 2 — Library freshness boost (T6.11)
// =========================================
// freshness = exp(-(now - env_dumped_at) / TAU) where TAU = 7 days
// Used by hybrid retrieval to boost recently-touched Theorems by ~20%.

CALL apoc.periodic.iterate(
  '
   MATCH (t:Theorem {namespace: "OmegaTheoryV2"})
   WHERE t.env_dumped_at IS NOT NULL
   RETURN t
  ',
  '
   WITH t,
        duration.inDays(t.env_dumped_at, datetime()).days AS days_old
   SET t.freshness = exp(-toFloat(days_old) / 7.0),
       t.freshness_set_at = datetime()
  ',
  {batchSize: 2000, parallel: false}
) YIELD batches, total
RETURN "freshness_pass" AS pass, batches, total;

// PASS 3 — Verification + summary
// ================================
MATCH (t:Theorem {namespace: "OmegaTheoryV2"})
WHERE t.tier IS NOT NULL
WITH t.tier AS tier, count(t) AS n
RETURN tier, n
ORDER BY
  CASE tier
    WHEN "99" THEN 1
    WHEN "80" THEN 2
    WHEN "Heart" THEN 3
    ELSE 4
  END;
