#!/usr/bin/env python3
"""
Step 1 (LOCAL): export :ProofStep.goal_before strings to JSONL for cloud upload.

Output format (one record per line):
  {"id": "<elementId>", "name": "<parent_thm>", "step_idx": <i>, "text": "<goal_before>"}

Filters: only :ProofStep with goal_before non-empty + length 50-3000 chars
(Qwen3-Embedding-8B context window allows ~4K tokens, ~3K chars safe).

Usage:
  OMEGA_NEO4J_PASSWORD=... python3 01_export_goals.py --out goals.jsonl
"""
import argparse
import json
import os
import sys
from neo4j import GraphDatabase


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", required=True)
    ap.add_argument("--namespace", default="Mathlib", help="Filter by namespace")
    ap.add_argument("--full-only", action="store_true",
                    help="Only :ProofStep with full_t1_3=true (real elaborated goals)")
    ap.add_argument("--limit", type=int, default=None)
    args = ap.parse_args()

    pwd = os.environ.get("OMEGA_NEO4J_PASSWORD") or os.environ.get("NEO4J_PASSWORD")
    if not pwd:
        print("ERROR: OMEGA_NEO4J_PASSWORD env var required", file=sys.stderr)
        sys.exit(1)

    where_clauses = ["ps.goal_before IS NOT NULL",
                     "size(ps.goal_before) >= 50",
                     "size(ps.goal_before) <= 3000"]
    if args.full_only:
        where_clauses.append("ps.full_t1_3 = true")
    if args.namespace:
        where_clauses.append(f"ps.namespace = '{args.namespace}'")
    where = " AND ".join(where_clauses)
    limit = f"LIMIT {args.limit}" if args.limit else ""
    cy = f"""
    MATCH (ps:ProofStep)
    WHERE {where}
    RETURN elementId(ps) AS id,
           ps.parent_thm AS name,
           ps.step_idx AS step_idx,
           ps.goal_before AS text
    {limit}
    """
    print(f"[export] querying :ProofStep with filter: {where}")
    driver = GraphDatabase.driver("bolt://localhost:7687", auth=("neo4j", pwd))
    n = 0
    with driver.session() as s, open(args.out, "w") as f:
        for rec in s.run(cy):
            f.write(json.dumps({
                "id": rec["id"],
                "name": rec["name"],
                "step_idx": rec["step_idx"],
                "text": rec["text"],
            }, ensure_ascii=False) + "\n")
            n += 1
            if n % 10000 == 0:
                print(f"  ... exported {n}")
    print(f"[export] DONE: {n} records → {args.out}")
    driver.close()


if __name__ == "__main__":
    main()
