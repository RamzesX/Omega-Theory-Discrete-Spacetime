#!/usr/bin/env python3
"""
Load FULL T1.3 :ProofStep records from `dump_proof_steps` JSONL into Neo4j.

Upgrades the LITE :ProofStep nodes (created via T1_3_proof_steps_lite.cypher
with goal_pseudo) to have REAL elaborated goal_str fields:
  - goal_before  ← real ⊢ goal text (from Meta.ppGoal during re-elaboration)
  - goal_after   ← post-tactic goal text
  - line, col    ← source position of tactic syntax
  - tactic_kind  ← Syntax node kind (debug)

Idempotent: replaces :ProofStep nodes per (parent_thm, step_idx) on each run.
Works for both OmegaTheoryV2 and Mathlib namespaces (auto-detected).

Usage:
  OMEGA_NEO4J_PASSWORD=... python3 load_proof_steps.py --in dump.jsonl
  OMEGA_NEO4J_PASSWORD=... python3 load_proof_steps.py --in dump.jsonl --namespace Mathlib
"""

import argparse
import json
import os
import sys
import time
from pathlib import Path

from neo4j import GraphDatabase


def detect_namespace(parent_thm: str) -> str:
    if parent_thm.startswith("OmegaTheory.") or parent_thm.startswith("OmegaTheory"):
        return "OmegaTheoryV2"
    if parent_thm.startswith("Mathlib."):
        return "Mathlib"
    # Heuristic: bare names without dots are usually OV2 root-namespace.
    if "." not in parent_thm:
        return "OmegaTheoryV2"
    # Things like Real.*, Nat.*, List.* are Mathlib in our graph.
    return "Mathlib"


def upsert_batch(tx, batch, default_namespace=None):
    """Idempotent upsert: drop existing :ProofStep for (parent_thm,step_idx) then create."""
    rows = []
    for rec in batch:
        ns = default_namespace or detect_namespace(rec["parent_thm"])
        rows.append({
            "namespace": ns,
            "parent_thm": rec["parent_thm"],
            "step_idx": rec["step_idx"],
            "tactic": rec.get("tactic", ""),
            "tactic_kind": rec.get("tactic_kind", ""),
            "goal_before": rec.get("goal_before", ""),
            "goal_after": rec.get("goal_after", ""),
            "n_goals_before": rec.get("n_goals_before", 0),
            "n_goals_after": rec.get("n_goals_after", 0),
            "file": rec.get("file", ""),
            "line": rec.get("line", 0),
            "col": rec.get("col", 0),
        })
    # Strategy: per (parent_thm, step_idx) detach-delete LITE node then create FULL.
    # This is one Cypher per row but batched in single tx.
    cy = """
    UNWIND $rows AS row
    OPTIONAL MATCH (old:ProofStep {namespace: row.namespace, parent_thm: row.parent_thm, step_idx: row.step_idx})
    DETACH DELETE old
    WITH row
    MATCH (t:Theorem {namespace: row.namespace, name: row.parent_thm})
    CREATE (ps:ProofStep {
        namespace: row.namespace,
        parent_thm: row.parent_thm,
        step_idx: row.step_idx,
        tactic: row.tactic,
        tactic_kind: row.tactic_kind,
        goal_before: row.goal_before,
        goal_after: row.goal_after,
        n_goals_before: row.n_goals_before,
        n_goals_after: row.n_goals_after,
        file: row.file,
        line: row.line,
        col: row.col,
        full_t1_3: true
    })
    CREATE (t)-[:HAS_STEP {step_idx: row.step_idx, full_t1_3: true}]->(ps)
    """
    tx.run(cy, rows=rows)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--in", dest="input_file", required=True, help="JSONL from dump_proof_steps")
    ap.add_argument("--namespace", default=None, help="Force namespace (else auto-detect)")
    ap.add_argument("--batch-size", type=int, default=200)
    ap.add_argument("--neo4j-uri", default="bolt://localhost:7687")
    ap.add_argument("--neo4j-user", default="neo4j")
    ap.add_argument("--limit", type=int, default=None, help="Limit records (smoke test)")
    args = ap.parse_args()

    pwd = os.environ.get("OMEGA_NEO4J_PASSWORD") or os.environ.get("NEO4J_PASSWORD")
    if not pwd:
        print("ERROR: OMEGA_NEO4J_PASSWORD env var required", file=sys.stderr)
        sys.exit(1)

    in_path = Path(args.input_file)
    if not in_path.exists():
        print(f"ERROR: input file not found: {in_path}", file=sys.stderr)
        sys.exit(1)

    print(f"[load_proof_steps] reading {in_path}")
    records = []
    with in_path.open() as f:
        for line_no, line in enumerate(f, 1):
            line = line.strip()
            if not line:
                continue
            try:
                rec = json.loads(line)
                records.append(rec)
                if args.limit and len(records) >= args.limit:
                    break
            except json.JSONDecodeError as e:
                print(f"  WARN line {line_no}: {e}", file=sys.stderr)
    print(f"[load_proof_steps] loaded {len(records)} records")

    # Group by namespace for visibility.
    if args.namespace:
        ns_counts = {args.namespace: len(records)}
    else:
        ns_counts = {}
        for rec in records:
            ns = detect_namespace(rec["parent_thm"])
            ns_counts[ns] = ns_counts.get(ns, 0) + 1
    print(f"[load_proof_steps] namespaces: {ns_counts}")

    # Push.
    driver = GraphDatabase.driver(args.neo4j_uri, auth=(args.neo4j_user, pwd))
    t0 = time.time()
    pushed = 0
    failed = 0
    with driver.session() as sess:
        batch = []
        for rec in records:
            batch.append(rec)
            if len(batch) >= args.batch_size:
                try:
                    sess.execute_write(upsert_batch, batch, args.namespace)
                    pushed += len(batch)
                except Exception as e:
                    print(f"  BATCH ERROR: {e}", file=sys.stderr)
                    failed += len(batch)
                batch = []
                if pushed % 1000 == 0:
                    elapsed = time.time() - t0
                    rate = pushed / elapsed if elapsed > 0 else 0
                    print(f"  ... pushed {pushed}/{len(records)} ({rate:.0f}/s)")
        if batch:
            try:
                sess.execute_write(upsert_batch, batch, args.namespace)
                pushed += len(batch)
            except Exception as e:
                print(f"  BATCH ERROR: {e}", file=sys.stderr)
                failed += len(batch)
    elapsed = time.time() - t0
    print(f"[load_proof_steps] done: pushed={pushed} failed={failed} in {elapsed:.1f}s")
    driver.close()


if __name__ == "__main__":
    main()
