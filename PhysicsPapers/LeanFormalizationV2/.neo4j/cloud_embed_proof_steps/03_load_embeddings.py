#!/usr/bin/env python3
"""
Step 3 (LOCAL): load embeddings.jsonl back into Neo4j as
:ProofStep.embedding_goal property + create vector index.

Idempotent: SET overwrites. Re-runnable.

Usage:
  OMEGA_NEO4J_PASSWORD=... python3 03_load_embeddings.py --in embeddings.jsonl
"""
import argparse
import json
import os
import sys
import time
from neo4j import GraphDatabase


VECTOR_INDEX_NAME = "proof_step_embedding_goal"
VECTOR_DIM = 4096


def upsert_batch(tx, batch):
    cy = """
    UNWIND $rows AS row
    MATCH (ps:ProofStep) WHERE elementId(ps) = row.id
    SET ps.embedding_goal = row.vec,
        ps.embedding_goal_at = datetime()
    """
    tx.run(cy, rows=batch)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--in", dest="input_file", required=True)
    ap.add_argument("--batch-size", type=int, default=200)
    args = ap.parse_args()

    pwd = os.environ.get("OMEGA_NEO4J_PASSWORD") or os.environ.get("NEO4J_PASSWORD")
    if not pwd:
        print("ERROR: OMEGA_NEO4J_PASSWORD env var required", file=sys.stderr)
        sys.exit(1)

    rows = []
    with open(args.input_file) as f:
        for line in f:
            line = line.strip()
            if line:
                rows.append(json.loads(line))
    print(f"[load] {len(rows)} embeddings to push")

    driver = GraphDatabase.driver("bolt://localhost:7687", auth=("neo4j", pwd))
    t0 = time.time()
    pushed = 0
    failed = 0
    with driver.session() as s:
        batch = []
        for row in rows:
            batch.append(row)
            if len(batch) >= args.batch_size:
                try:
                    s.execute_write(upsert_batch, batch)
                    pushed += len(batch)
                except Exception as e:
                    print(f"  BATCH ERROR: {e}", file=sys.stderr)
                    failed += len(batch)
                batch = []
                if pushed % 5000 == 0:
                    elapsed = time.time() - t0
                    print(f"  ... pushed {pushed}/{len(rows)} ({pushed/elapsed:.0f}/s)")
        if batch:
            try:
                s.execute_write(upsert_batch, batch)
                pushed += len(batch)
            except Exception as e:
                print(f"  BATCH ERROR: {e}", file=sys.stderr)
                failed += len(batch)
    elapsed = time.time() - t0
    print(f"[load] done: pushed={pushed} failed={failed} in {elapsed:.0f}s")

    # Create the vector index (idempotent)
    print(f"[load] creating vector index {VECTOR_INDEX_NAME} (dim={VECTOR_DIM})...")
    with driver.session() as s:
        s.run(f"""
            CREATE VECTOR INDEX {VECTOR_INDEX_NAME} IF NOT EXISTS
            FOR (ps:ProofStep) ON (ps.embedding_goal)
            OPTIONS {{indexConfig: {{
                `vector.dimensions`: {VECTOR_DIM},
                `vector.similarity_function`: 'cosine'
            }}}}
        """)
    print(f"[load] vector index online — query via db.index.vector.queryNodes('{VECTOR_INDEX_NAME}', k, queryVec)")
    driver.close()


if __name__ == "__main__":
    main()
