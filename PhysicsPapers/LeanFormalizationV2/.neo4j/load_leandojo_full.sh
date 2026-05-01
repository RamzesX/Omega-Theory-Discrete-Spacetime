#!/usr/bin/env bash
# load_leandojo_full.sh — one-shot LeanDojo benchmark → Neo4j :ProofStep loader
#
# Replaces the OOM-prone FULL T1.3 (DumpProofSteps.lean re-elaboration) approach.
# Source: LeanDojo upstream Zenodo publication (commit 29dcec074d of Mathlib4).
#
# Idempotent: skips download if cached, skips transform if JSONL exists.
# Force re-run with --force to wipe + reload everything.
#
# Usage:
#   OMEGA_NEO4J_PASSWORD=... ./load_leandojo_full.sh
#   OMEGA_NEO4J_PASSWORD=... ./load_leandojo_full.sh --force
#
# Total runtime first-time:  ~3-5 min (68MB download + extract + transform + load)
# Total runtime cached:      ~30s (skip download/transform, just reload Neo4j)

set -euo pipefail

DATASETS_DIR="${HOME}/datasets/leandojo"
JSONL_OUT="${HOME}/lean-v2/.neo4j/data/proof_steps_leandojo.jsonl"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PYTHON="${PYTHON:-/home/norbert/genai_env/bin/python3}"

FORCE=0
[[ "${1:-}" == "--force" ]] && FORCE=1

if [[ -z "${OMEGA_NEO4J_PASSWORD:-}" ]]; then
  echo "ERROR: set OMEGA_NEO4J_PASSWORD env var" >&2
  exit 1
fi

mkdir -p "$DATASETS_DIR" "$(dirname "$JSONL_OUT")"

# === Step 1: download (idempotent) ===
TARBALL="$DATASETS_DIR/leandojo_benchmark_4.tar.gz"
EXTRACT_DIR="$DATASETS_DIR/leandojo_benchmark_4"
if [[ $FORCE -eq 1 || ! -f "$TARBALL" ]]; then
  echo "[1/4] downloading LeanDojo benchmark (68MB)..."
  curl -L --fail 'https://zenodo.org/records/12740403/files/leandojo_benchmark_4.tar.gz' \
       -o "$TARBALL"
else
  echo "[1/4] tarball cached: $TARBALL"
fi

if [[ $FORCE -eq 1 || ! -d "$EXTRACT_DIR/random" ]]; then
  echo "[2/4] extracting..."
  cd "$DATASETS_DIR" && tar -xzf leandojo_benchmark_4.tar.gz
else
  echo "[2/4] extracted dir cached: $EXTRACT_DIR/random"
fi

# === Step 3: transform JSON → JSONL ===
if [[ $FORCE -eq 1 || ! -f "$JSONL_OUT" ]]; then
  echo "[3/4] transforming JSON → JSONL ..."
  "$PYTHON" "$SCRIPT_DIR/leandojo_to_proof_steps.py" \
    --in-dir "$EXTRACT_DIR/random/" \
    --out "$JSONL_OUT"
else
  echo "[3/4] JSONL cached: $JSONL_OUT ($(wc -l < "$JSONL_OUT") lines)"
fi

# === Step 4: load into Neo4j ===
echo "[4/4] loading into Neo4j (Mathlib namespace)..."
"$PYTHON" "$SCRIPT_DIR/load_proof_steps.py" \
  --in "$JSONL_OUT" \
  --namespace Mathlib \
  --batch-size 500

# === Verify ===
echo ""
echo "=== verification ==="
"$PYTHON" -c "
from neo4j import GraphDatabase
import os
d = GraphDatabase.driver('bolt://localhost:7687', auth=('neo4j', os.environ['OMEGA_NEO4J_PASSWORD']))
with d.session() as s:
    r = s.run('MATCH (ps:ProofStep {namespace:\"Mathlib\", full_t1_3:true}) RETURN count(ps) AS n').single()
    print(f'  Mathlib :ProofStep with REAL elaborated goals: {r[\"n\"]:,}')
    r = s.run('MATCH (ps:ProofStep {namespace:\"Mathlib\", full_t1_3:true})-[:HAS_STEP]-() RETURN count(DISTINCT ps) AS n').single()
    print(f'  with :HAS_STEP edge to Theorem:                {r[\"n\"]:,}')
    r = s.run('MATCH ()-[r:HAS_STEP {match:\"exact\"}]->(:ProofStep {full_t1_3:true, namespace:\"Mathlib\"}) RETURN count(r) AS n').single()
    print(f'    via exact-name match:                        {r[\"n\"]:,}')
    r = s.run('MATCH ()-[r:HAS_STEP {match:\"bare\"}]->(:ProofStep {full_t1_3:true, namespace:\"Mathlib\"}) RETURN count(r) AS n').single()
    print(f'    via bare-suffix fallback:                    {r[\"n\"]:,}')
" 2>&1 | grep -v "Notification\|Received\|Verify\|GqlStatusObject"

echo ""
echo "DONE. Query via:"
echo "  cypher: MATCH (ps:ProofStep {full_t1_3:true}) WHERE ps.goal_before CONTAINS '...' RETURN ..."
echo "  MCP:    mcp__omega-search__goal_to_proof_step({...})"
