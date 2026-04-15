#!/usr/bin/env python3
"""Tracer helper: run Cypher via Neo4j HTTP API (docker exec blocked in sandbox).

Usage:
  python3 tracer_run.py "<single CYPHER>"
  python3 tracer_run.py -f path/to/file.cypher
"""
from __future__ import annotations

import sys, json, base64, urllib.request, urllib.error

NEO4J_URL = "http://localhost:7474/db/neo4j/tx/commit"
AUTH = base64.b64encode(b"neo4j:omegatheory2026").decode()


def run_statements(stmts: list[str]) -> None:
    payload = json.dumps({"statements": [{"statement": s} for s in stmts]}).encode()
    req = urllib.request.Request(
        NEO4J_URL, data=payload,
        headers={"Content-Type": "application/json",
                 "Authorization": "Basic " + AUTH},
        method="POST")
    try:
        with urllib.request.urlopen(req) as r:
            body = r.read().decode()
    except urllib.error.HTTPError as e:
        print(f"HTTP {e.code}:", e.read().decode(), file=sys.stderr)
        sys.exit(1)
    data = json.loads(body)
    if data.get("errors"):
        print("Cypher errors:", file=sys.stderr)
        print(json.dumps(data["errors"], indent=2), file=sys.stderr)
        sys.exit(1)

    results = data.get("results", [])
    for idx, res in enumerate(results):
        cols = res.get("columns", [])
        rows = res.get("data", [])
        if not rows:
            continue
        print(f"--- result {idx}: {', '.join(cols)} ({len(rows)} rows) ---")
        for r in rows:
            row = r.get("row", [])
            print("\t".join(
                json.dumps(v, ensure_ascii=False) if not isinstance(v, str) else v
                for v in row))
    print(f"[ok] ran {len(stmts)} statements, got {len(results)} result sets")


def main() -> None:
    if len(sys.argv) < 2:
        print(__doc__, file=sys.stderr)
        sys.exit(2)
    if sys.argv[1] == "-f":
        with open(sys.argv[2]) as f:
            text = f.read()
        stmts = [s.strip() for s in text.split(";") if s.strip()]
    else:
        stmts = [sys.argv[1]]
    run_statements(stmts)


if __name__ == "__main__":
    main()
