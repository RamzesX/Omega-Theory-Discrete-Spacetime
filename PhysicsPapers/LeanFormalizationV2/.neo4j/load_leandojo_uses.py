#!/usr/bin/env python3
"""
Load :USES edges from leandojo_uses.jsonl into Neo4j.

For each (parent_thm, step_idx, premise) triple:
  1. MATCH the :ProofStep (full_t1_3=true, namespace='Mathlib') by parent_thm+step_idx
  2. Find the premise via exact OR bare-suffix match on Theorem|Definition|Instance
  3. CREATE :USES edge from :ProofStep to the premise node

Idempotent: drops existing :USES edges per (proof_step_id, premise_name) tuple
before re-creating. Re-run safe.

Usage:
  OMEGA_NEO4J_PASSWORD=... python3 load_leandojo_uses.py \
    --in /home/norbert/lean-v2/.neo4j/data/leandojo_uses.jsonl
"""

import argparse
import json
import os
import sys
import time
from pathlib import Path

from neo4j import GraphDatabase


def upsert_batch(tx, batch):
    cy = """
    UNWIND $rows AS row
    // Anchor: the :ProofStep itself (LeanDojo loader created these)
    MATCH (ps:ProofStep {namespace: 'Mathlib', full_t1_3: true,
                        parent_thm: row.parent_thm, step_idx: row.step_idx})
    // Try to resolve the premise: exact name OR bare-suffix on Theorem|Definition|Instance
    WITH ps, row, split(row.premise, '.') AS parts
    WITH ps, row, parts[size(parts)-1] AS bare
    OPTIONAL MATCH (texact)
      WHERE (texact:Theorem OR texact:Definition OR texact:Instance OR texact:Structure)
        AND texact.namespace IN ['Mathlib', 'OmegaTheoryV2']
        AND texact.name = row.premise
    WITH ps, row, bare, texact
    OPTIONAL MATCH (tbare)
      WHERE (tbare:Theorem OR tbare:Definition OR tbare:Instance OR tbare:Structure)
        AND tbare.namespace IN ['Mathlib', 'OmegaTheoryV2']
        AND tbare.name = bare
        AND texact IS NULL
    WITH ps, row, coalesce(texact, tbare) AS premise_node,
         CASE WHEN texact IS NOT NULL THEN 'exact'
              WHEN tbare IS NOT NULL THEN 'bare'
              ELSE 'none' END AS match_kind
    // Skip rows where neither match found
    WITH ps, row, premise_node, match_kind
    WHERE premise_node IS NOT NULL
    MERGE (ps)-[u:USES {premise_name: row.premise}]->(premise_node)
    SET u.match = match_kind, u.premise_file = row.premise_file
    """
    tx.run(cy, rows=batch)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--in", dest="input_file", required=True)
    ap.add_argument("--batch-size", type=int, default=500)
    ap.add_argument("--limit", type=int, default=None)
    args = ap.parse_args()

    pwd = os.environ.get("OMEGA_NEO4J_PASSWORD") or os.environ.get("NEO4J_PASSWORD")
    if not pwd:
        print("ERROR: OMEGA_NEO4J_PASSWORD env var required", file=sys.stderr)
        sys.exit(1)

    in_path = Path(args.input_file)
    print(f"[load_uses] reading {in_path}")
    rows = []
    with in_path.open() as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            rows.append(json.loads(line))
            if args.limit and len(rows) >= args.limit:
                break
    print(f"[load_uses] loaded {len(rows)} premise refs")

    driver = GraphDatabase.driver("bolt://localhost:7687", auth=("neo4j", pwd))
    t0 = time.time()
    pushed = 0
    failed = 0
    with driver.session() as sess:
        batch = []
        for row in rows:
            batch.append(row)
            if len(batch) >= args.batch_size:
                try:
                    sess.execute_write(upsert_batch, batch)
                    pushed += len(batch)
                except Exception as e:
                    print(f"  BATCH ERROR: {e}", file=sys.stderr)
                    failed += len(batch)
                batch = []
                if pushed % 10000 == 0:
                    elapsed = time.time() - t0
                    rate = pushed / elapsed if elapsed > 0 else 0
                    print(f"  ... pushed {pushed}/{len(rows)} ({rate:.0f}/s)")
        if batch:
            try:
                sess.execute_write(upsert_batch, batch)
                pushed += len(batch)
            except Exception as e:
                print(f"  BATCH ERROR: {e}", file=sys.stderr)
                failed += len(batch)
    elapsed = time.time() - t0
    print(f"[load_uses] done: pushed={pushed} failed={failed} in {elapsed:.1f}s")
    driver.close()


if __name__ == "__main__":
    main()
