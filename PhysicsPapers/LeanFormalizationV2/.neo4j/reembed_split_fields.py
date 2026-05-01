#!/usr/bin/env python3
"""reembed_split_fields.py — Phase 1 multi-index backfill.

Embeds each Theorem's `signature`, `proof_body`, and `docstring` as SEPARATE
vectors (stored in `embedding_signature`, `embedding_proof`, `embedding_docstring`)
for downstream RRF fusion retrieval (Phase 2).

Profile-aware: reads active profile to pick embedder URL + alias + query_wrap.
Idempotent: skips theorems that already have the target embedding unless
--overwrite is specified.

Usage:
    python3 reembed_split_fields.py                          # all fields, OV2 only
    python3 reembed_split_fields.py --namespace Mathlib      # Mathlib too (slow)
    python3 reembed_split_fields.py --field signature         # just one field
    python3 reembed_split_fields.py --dry-run                # show what would happen
    python3 reembed_split_fields.py --overwrite               # re-embed everything

Env vars honored:
    OMEGA_PROFILES_DIR, OMEGA_PROFILE, OMEGA_NEO4J_URI/USER/PASSWORD
"""
from __future__ import annotations

import argparse
import os
import sys
import time
from pathlib import Path
from typing import Any

import httpx
from neo4j import GraphDatabase

try:
    import tomllib
except ImportError:
    import tomli as tomllib  # type: ignore

# ── Profile (lightweight — no import of omega_orchestrator package) ─────────

PROFILES_DIR = Path(
    os.environ.get("OMEGA_PROFILES_DIR", "/home/norbert/services/profiles")
)


def resolve_profile_path() -> Path:
    for env_key in ("OMEGA_PROFILE_PATH",):
        if os.environ.get(env_key):
            p = Path(os.environ[env_key])
            if p.exists():
                return p
    named = os.environ.get("OMEGA_PROFILE")
    if named:
        p = PROFILES_DIR / f"{named}.toml"
        if p.exists():
            return p
    for fname in ("active.toml", "default.toml"):
        p = PROFILES_DIR / fname
        if p.exists():
            return p
    raise FileNotFoundError(f"no profile under {PROFILES_DIR}")


def load_profile_server(role: str) -> dict:
    """Return the first [[servers]] entry matching role (embedding/reranking)."""
    with open(resolve_profile_path(), "rb") as f:
        data = tomllib.load(f)
    for entry in data.get("servers", []):
        if entry.get("role") == role:
            return entry
    raise ValueError(f"profile has no server with role={role}")


# ── Field-specific task descriptions (Qwen3 instruction-aware embedding) ────

TASK_PER_FIELD = {
    "signature": (
        "Given a Lean 4 theorem signature, encode its type-theoretic content "
        "so that semantically equivalent statements produce nearby vectors."
    ),
    "proof": (
        "Given a Lean 4 tactic proof body, encode its proof-pattern "
        "(tactics used, structural shape, induction type) so analogous proofs "
        "produce nearby vectors."
    ),
    "docstring": (
        "Given a Lean 4 declaration's doc comment, encode the author's stated "
        "intent and mathematical meaning."
    ),
    "goal": (
        "Given a Lean 4 theorem signature treated as a proof goal, encode the "
        "goal-state context so that goals closable by analogous tactic prefixes "
        "produce nearby vectors."
    ),
}

FIELD_TO_PROPERTY = {
    "signature":  ("signature",  "embedding_signature"),
    "proof":      ("proof_body", "embedding_proof"),
    "docstring":  ("docstring",  "embedding_docstring"),
    "goal":       ("signature",  "embedding_goal"),
}


# ── Embedder client (sync, for a one-shot batch script) ────────────────────


class Embedder:
    def __init__(self, base_url: str, alias: str, query_wrap: str):
        self.base_url = base_url.rstrip("/")
        self.alias = alias
        self.query_wrap = query_wrap
        self.client = httpx.Client(timeout=60.0)

    def embed(self, texts: list[str], task: str) -> list[list[float]]:
        """Batch-embed with profile's query_wrap applied per text."""
        bodies = [
            self.query_wrap.format(task=task, text=t) if self.query_wrap else t
            for t in texts
        ]
        r = self.client.post(
            f"{self.base_url}/v1/embeddings",
            json={"input": bodies, "model": self.alias},
        )
        r.raise_for_status()
        data = r.json()["data"]
        # Preserve order
        return [row["embedding"] for row in sorted(data, key=lambda d: d["index"])]


# ── Main backfill loop ──────────────────────────────────────────────────────


def crop_text(t: str | None, cap: int) -> str | None:
    """Qwen3 has a 32K ctx but we cap aggressively to keep batch sizes sane."""
    if not t:
        return None
    t = t.strip()
    if not t:
        return None
    return t[:cap]


FIELD_CAPS = {
    "signature": 1500,
    "proof": 2000,     # reduced from 4000 — Qwen3 context pressure on big proofs
    "docstring": 1000,
    "goal": 1800,      # signature-as-goal; allow more than signature alone for context
}


def fetch_batch(
    session, namespace: str, field_prop: str, emb_prop: str,
    batch_size: int, overwrite: bool,
) -> list[dict]:
    """Return up to `batch_size` Theorem nodes needing this embedding.

    Excludes rows previously marked as skipped (emb_prop_skipped_at IS NOT NULL)
    so poisonous inputs don't keep retrying.
    """
    where_missing = "" if overwrite else f"AND t.{emb_prop} IS NULL AND t.{emb_prop}_skipped_at IS NULL"
    cypher = f"""
        MATCH (t:Theorem {{namespace: $ns}})
        WHERE t.{field_prop} IS NOT NULL
          AND trim(t.{field_prop}) <> ''
          {where_missing}
        RETURN elementId(t) AS eid, t.name AS name,
               t.{field_prop} AS text
        LIMIT $batch
    """
    return [dict(r) for r in session.run(cypher, ns=namespace, batch=batch_size)]


def write_batch(session, emb_prop: str, rows: list[dict], vecs: list[list[float]]) -> None:
    # UNWIND + SET in a single transaction for speed.
    payload = [
        {"eid": r["eid"], "vec": v, "at": time.time()}
        for r, v in zip(rows, vecs)
    ]
    cypher = f"""
        UNWIND $rows AS row
        MATCH (t) WHERE elementId(t) = row.eid
        SET t.{emb_prop} = row.vec,
            t.{emb_prop}_at = row.at
    """
    session.run(cypher, rows=payload).consume()


def run_field(
    session, embedder: Embedder, namespace: str, field: str,
    batch_size: int, overwrite: bool, dry_run: bool,
) -> dict:
    field_prop, emb_prop = FIELD_TO_PROPERTY[field]
    task = TASK_PER_FIELD[field]
    cap = FIELD_CAPS[field]

    # In dry-run, query the TOTAL number of rows to embed (up-front count) and
    # show just the first batch sample — no loop, no embedder calls, no writes.
    if dry_run:
        where_missing = "" if overwrite else f"AND t.{emb_prop} IS NULL"
        count_q = f"""
            MATCH (t:Theorem {{namespace: $ns}})
            WHERE t.{field_prop} IS NOT NULL
              AND trim(t.{field_prop}) <> ''
              {where_missing}
            RETURN count(t) AS n
        """
        n_rows = session.run(count_q, ns=namespace).single()["n"]
        sample = fetch_batch(session, namespace, field_prop, emb_prop, 3, overwrite)
        print(f"  [DRY] {n_rows} {field}(s) pending in {namespace}")
        for r in sample:
            preview = (r.get("text") or "")[:80].replace("\n", " ")
            print(f"    · {r['name']}: {preview!r}")
        est_seconds = n_rows / 43  # Qwen3-Emb-8B ≈ 43 emb/s
        print(f"  [DRY] estimated wall time: {est_seconds / 60:.1f} min "
              f"({n_rows} rows @ ~43 emb/s)")
        return {
            "field": field,
            "namespace": namespace,
            "rows_pending": n_rows,
            "rows_written": 0,
            "est_wall_minutes": round(est_seconds / 60, 1),
            "dry_run": True,
        }

    total_written = 0
    total_skipped = 0
    t0 = time.monotonic()
    while True:
        batch = fetch_batch(session, namespace, field_prop, emb_prop, batch_size, overwrite)
        if not batch:
            break

        texts = [crop_text(r["text"], cap) or "(empty)" for r in batch]
        try:
            vecs = embedder.embed(texts, task=task)
            if len(vecs) != len(batch):
                raise RuntimeError(
                    f"embedder returned {len(vecs)} vectors for {len(batch)} inputs"
                )
            write_batch(session, emb_prop, batch, vecs)
            total_written += len(batch)
        except Exception as batch_err:
            # Batch failed — try single-item to surface the specific offender,
            # skip any row that itself errors.
            print(f"  {field}: batch of {len(batch)} failed ({batch_err}); falling back to singles",
                  flush=True)
            for r, t in zip(batch, texts):
                try:
                    v = embedder.embed([t], task=task)
                    if v:
                        write_batch(session, emb_prop, [r], v)
                        total_written += 1
                except Exception as single_err:
                    # Mark as attempted so we don't retry forever — write an
                    # empty marker property so the row is excluded on next run.
                    session.run(
                        f"MATCH (t) WHERE elementId(t) = $eid "
                        f"SET t.{emb_prop}_skipped_at = $at, "
                        f"t.{emb_prop}_skipped_reason = $reason",
                        eid=r["eid"], at=time.time(), reason=str(single_err)[:400],
                    ).consume()
                    total_skipped += 1
                    print(f"    SKIP {r['name']}: {single_err}", flush=True)
        elapsed = time.monotonic() - t0
        rate = total_written / max(elapsed, 0.01)
        print(f"  {field}: total_written={total_written:5d}  skipped={total_skipped}  "
              f"rate={rate:.1f}/s", flush=True)

    elapsed = time.monotonic() - t0
    return {
        "field": field,
        "namespace": namespace,
        "rows_written": total_written,
        "rows_skipped": total_skipped,
        "elapsed_s": round(elapsed, 1),
        "rate_per_s": (round(total_written / elapsed, 1) if elapsed else 0),
    }


def main() -> int:
    ap = argparse.ArgumentParser(
        description="Backfill split-field embeddings for Theorem nodes"
    )
    ap.add_argument("--namespace", default="OmegaTheoryV2",
                    help="namespace filter (default OmegaTheoryV2)")
    ap.add_argument("--field", choices=["signature", "proof", "docstring", "goal", "all"],
                    default="all", help="which field to embed")
    ap.add_argument("--batch-size", type=int, default=32,
                    help="theorems per embedder request")
    ap.add_argument("--overwrite", action="store_true",
                    help="re-embed theorems that already have the embedding")
    ap.add_argument("--dry-run", action="store_true",
                    help="show what would happen without calling embedder or writing")
    args = ap.parse_args()

    # Resolve embedder via profile
    server = load_profile_server("embedding")
    base_url = f"http://localhost:{server['port']}"
    embedder = Embedder(
        base_url=base_url,
        alias=server["alias"],
        query_wrap=server.get("query_wrap", ""),
    )
    print(f"profile server: {server['id']} @ {base_url} alias={server['alias']} "
          f"dim={server.get('model_dim', '?')}")
    if args.dry_run:
        print("(DRY RUN — no embedder calls, no Neo4j writes)")

    # Neo4j driver
    uri = os.environ.get("OMEGA_NEO4J_URI", "bolt://localhost:7687")
    user = os.environ.get("OMEGA_NEO4J_USER", "neo4j")
    pw = os.environ.get("OMEGA_NEO4J_PASSWORD", "omegatheory2026")
    driver = GraphDatabase.driver(uri, auth=(user, pw))

    fields = ["signature", "proof", "docstring", "goal"] if args.field == "all" else [args.field]
    results = []
    with driver.session() as s:
        for field in fields:
            print(f"\n=== field: {field} (ns={args.namespace}) ===")
            res = run_field(
                s, embedder, args.namespace, field,
                batch_size=args.batch_size,
                overwrite=args.overwrite,
                dry_run=args.dry_run,
            )
            results.append(res)
            print(f"  summary: {res}")

    driver.close()
    print("\n=== DONE ===")
    for r in results:
        print(f"  {r}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
