"""Re-embed OmegaTheoryV2 theorems with Qwen3-Embedding-8B (BF16) via :7999.

SOTA-COMMIT strategy (coordinator update 2026-04-19):
Writes DIRECTLY to `embedding_lean` property (was ByT5 dim 1472, now Qwen3 dim 4096).
Tags with `embedder='qwen3-8b-bf16'` and `embedding_dim=4096`. No dual-write.

Targets theorems where:
  - signature IS NOT NULL
  - embedder != 'qwen3-8b-bf16' OR embedder IS NULL

Author: Nashira (agent), 2026-04-19
"""
from __future__ import annotations

import argparse
import logging
import os
import sys
import time

import httpx
from neo4j import GraphDatabase

NEO4J_URI = os.environ.get("NEO4J_URI", "bolt://localhost:7687")
NEO4J_USER = os.environ.get("NEO4J_USER", "neo4j")
NEO4J_PASSWORD = os.environ.get("NEO4J_PASSWORD", "omegatheory2026")
QWEN3_URL = os.environ.get("QWEN3_URL", "http://localhost:7999/v1/embeddings")
BATCH_EMBED = int(os.environ.get("BATCH_EMBED", "2"))
BATCH_COMMIT = int(os.environ.get("BATCH_COMMIT", "100"))
HTTP_TIMEOUT = float(os.environ.get("HTTP_TIMEOUT", "300"))

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s  %(levelname)-7s  %(message)s",
    stream=sys.stdout,
)
log = logging.getLogger("reembed_qwen3_v2")


FETCH_MISSING = """
MATCH (t:Theorem {namespace: 'OmegaTheoryV2'})
WHERE t.signature IS NOT NULL
  AND (t.embedder IS NULL OR t.embedder <> 'qwen3-8b-bf16')
RETURN t.name AS name, t.signature AS signature, t.docstring AS docstring
ORDER BY t.name
LIMIT $limit
"""

WRITE_BATCH = """
UNWIND $records AS row
MATCH (t:Theorem {namespace: 'OmegaTheoryV2', name: row.name})
SET t.embedding_lean = row.vec,
    t.embedder = 'qwen3-8b-bf16',
    t.embedding_dim = 4096,
    t.embedding_updated_at = datetime()
"""

COUNT_STATUS = """
MATCH (t:Theorem {namespace: 'OmegaTheoryV2'})
WHERE t.signature IS NOT NULL
RETURN count(t) AS total,
       count(CASE WHEN t.embedder = 'qwen3-8b-bf16' THEN 1 END) AS with_qwen3
"""


def compose_input(name: str, signature: str, docstring: str | None) -> str:
    if docstring and docstring.strip():
        return f"{signature}\n{docstring}"
    return signature


def embed_batch(client: httpx.Client, texts: list[str]) -> list[list[float]]:
    resp = client.post(
        QWEN3_URL,
        json={"input": texts, "model": "qwen3-embedding-8b"},
        timeout=HTTP_TIMEOUT,
    )
    resp.raise_for_status()
    return [d["embedding"] for d in resp.json()["data"]]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--limit", type=int, default=10_000)
    ap.add_argument("--max-total", type=int, default=None)
    args = ap.parse_args()

    driver = GraphDatabase.driver(NEO4J_URI, auth=(NEO4J_USER, NEO4J_PASSWORD))
    client = httpx.Client(timeout=HTTP_TIMEOUT)

    with driver.session() as sess:
        counts = sess.run(COUNT_STATUS).single()
        total_sig = counts["total"]
        done_start = counts["with_qwen3"]
        log.info(f"OmegaTheoryV2 sig-theorems: {total_sig}   already-qwen3: {done_start}   TODO: {total_sig-done_start}")

    t_start = time.time()
    processed = 0
    failed = 0

    while True:
        with driver.session() as sess:
            rows = list(sess.run(FETCH_MISSING, limit=args.limit))
        if not rows:
            log.info("No more missing embeddings.")
            break

        log.info(f"Fetched {len(rows)} rows")
        batch_buf: list[dict] = []
        i = 0
        while i < len(rows):
            chunk = rows[i : i + BATCH_EMBED]
            i += len(chunk)
            texts = [compose_input(r["name"], r["signature"], r.get("docstring")) for r in chunk]
            try:
                vecs = embed_batch(client, texts)
            except Exception as exc:
                failed += len(chunk)
                log.warning(f"Embed failure on {[r['name'] for r in chunk]}: {exc}")
                continue
            for r, v in zip(chunk, vecs):
                batch_buf.append({"name": r["name"], "vec": v})

            if len(batch_buf) >= BATCH_COMMIT:
                with driver.session() as sess:
                    sess.run(WRITE_BATCH, records=batch_buf)
                processed += len(batch_buf)
                dt = time.time() - t_start
                rate = processed / dt if dt > 0 else 0.0
                log.info(f"Committed {processed} total  rate={rate:.2f} thm/s  failed={failed}")
                batch_buf = []

            if args.max_total and processed >= args.max_total:
                break

        if batch_buf:
            with driver.session() as sess:
                sess.run(WRITE_BATCH, records=batch_buf)
            processed += len(batch_buf)
            log.info(f"Flushed {len(batch_buf)}  total={processed}  failed={failed}")
            batch_buf = []

        if args.max_total and processed >= args.max_total:
            break

    with driver.session() as sess:
        counts = sess.run(COUNT_STATUS).single()

    dt_total = time.time() - t_start
    log.info(
        f"DONE  processed_this_run={processed}  failed={failed}  "
        f"total_qwen3_in_db={counts['with_qwen3']}/{counts['total']}  "
        f"elapsed={dt_total:.1f}s  avg_rate={processed/dt_total if dt_total>0 else 0:.2f} thm/s"
    )

    client.close()
    driver.close()


if __name__ == "__main__":
    main()
