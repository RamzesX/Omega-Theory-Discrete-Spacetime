#!/usr/bin/env python3
"""
Phase C refresh step: re-run OV2 :ProofStep source-segmented Cypher migration.

Idempotent: drops existing OV2 :ProofStep nodes WITHOUT full_t1_3=true marker
(preserving FCNCAbsence smoke-test FULL records + LeanDojo Mathlib records),
then recreates from current Theorem.proof_body.

Auto-runs as part of refresh_graph (omega_orchestrator pipeline.py).

Usage (manual):
  OMEGA_NEO4J_PASSWORD=... python3 refresh_ov2_proof_steps.py
"""
import os
import sys
import time

from neo4j import GraphDatabase


DROP_OV2_LITE = """
MATCH (ps:ProofStep)
WHERE ps.namespace = 'OmegaTheoryV2'
  AND coalesce(ps.full_t1_3, false) = false
DETACH DELETE ps
"""

CREATE_OV2_SOURCE_SEGMENTED = """
MATCH (t:Theorem {namespace: 'OmegaTheoryV2'})
WHERE t.proof_body IS NOT NULL
  AND size(t.proof_body) > 5
  AND t.signature IS NOT NULL
  AND NOT EXISTS {
    MATCH (t)-[:HAS_STEP]->(:ProofStep {full_t1_3: true})
  }
WITH t,
     coalesce(t.signature, '') AS sig,
     apoc.text.replace(t.proof_body, '^\\s*by\\s+', '') AS body
WITH t, sig, body,
     apoc.text.split(body, '[;\\n]') AS raw_segments
WITH t, sig, raw_segments,
     [seg IN raw_segments | trim(seg)] AS segments
WITH t, sig, segments,
     [s IN segments
      WHERE s <> ''
        AND NOT s STARTS WITH '--'
        AND NOT s STARTS WITH '/-'
        AND s <> '·' AND s <> '-' AND s <> '{' AND s <> '}'
        AND size(s) > 1 AND size(s) < 500
     ] AS tacs
WITH t, sig, tacs
WHERE size(tacs) >= 1 AND size(tacs) < 50
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
    goal_pseudo: goal_pseudo,
    source_segmented: true
})
CREATE (t)-[:HAS_STEP {step_idx: i}]->(ps)
"""

CREATE_INDEXES = [
    "CREATE INDEX proof_step_parent_idx IF NOT EXISTS FOR (ps:ProofStep) ON (ps.parent_thm)",
    "CREATE INDEX proof_step_step_idx IF NOT EXISTS FOR (ps:ProofStep) ON (ps.step_idx)",
    "CREATE INDEX proof_step_namespace_idx IF NOT EXISTS FOR (ps:ProofStep) ON (ps.namespace)",
]


def main():
    pwd = os.environ.get("OMEGA_NEO4J_PASSWORD") or os.environ.get("NEO4J_PASSWORD")
    if not pwd:
        print("ERROR: OMEGA_NEO4J_PASSWORD env var required", file=sys.stderr)
        sys.exit(1)

    driver = GraphDatabase.driver("bolt://localhost:7687", auth=("neo4j", pwd))
    t0 = time.time()
    with driver.session() as s:
        print("[refresh_ov2_proof_steps] Step 1 (drop OV2 LITE, preserve full_t1_3)...")
        r = s.run(DROP_OV2_LITE).consume()
        print(f"  deleted {r.counters.nodes_deleted} :ProofStep nodes")

        print("[refresh_ov2_proof_steps] Step 2 (source-segment OV2 from proof_body)...")
        r = s.run(CREATE_OV2_SOURCE_SEGMENTED).consume()
        print(f"  created {r.counters.nodes_created} :ProofStep + "
              f"{r.counters.relationships_created} :HAS_STEP edges")

        print("[refresh_ov2_proof_steps] Step 3 (ensure indexes)...")
        for cy in CREATE_INDEXES:
            s.run(cy).consume()
        print(f"  {len(CREATE_INDEXES)} indexes verified")

    elapsed = time.time() - t0
    print(f"[refresh_ov2_proof_steps] DONE in {elapsed:.1f}s")
    driver.close()


if __name__ == "__main__":
    main()
