#!/usr/bin/env python3
"""Delta Qwen3 re-embed: only re-embed theorems whose embedding is missing,
wrong dim, or whose env_dumped_at is newer than their embedding time.

2026-04-24 perf rewrite (post bench):
  Empirical rates on 713-char theorems via :7999 (llama.cpp HIP, RX 9060 XT):
    SERIAL 1-by-1:         ~16 emb/s
    PARALLEL 8 single:     ~13 emb/s  (slower — 4 slot contention)
    ARRAY batch=8, 1 req:   ~63 emb/s  (3.9× serial — fits 1 ubatch=4096)
    ARRAY batch=50, 1 req:  ~7 emb/s   (needs 3-4 forward passes, same as serial)

  Optimal pattern: BATCH=15 (~4500 tokens, 1 GPU forward pass) + 4 concurrent
  workers = ~250 emb/s target. Server's --parallel 4 + --cont-batching drives
  the parallelism; we just need to keep 4 slots fed.

Author: Rasalhague (α Ophiuchi), 2026-04-20. Perf: 2026-04-24.
"""
import httpx, time, sys
from concurrent.futures import ThreadPoolExecutor
from neo4j import GraphDatabase

EMBED_URL = 'http://localhost:7999/v1/embeddings'
MODEL = 'qwen3-8b'
# BATCH sized so all token counts in one request fit one ubatch-size=4096
# forward pass. At ~300 tokens/theorem: BATCH=15 gives ~4500 tokens ≈ 1 pass.
# For very short theorems, BATCH=20-25 would work; for long (>500-token) ones,
# BATCH=10 is safer. 15 is a conservative compromise that avoids wasted passes.
BATCH = 8
# WORKERS=1 is empirically OPTIMAL for this llama-server setup (2026-04-24 bench):
#   4 concurrent × 15-text batches  → 41 emb/s
#   4 SERIAL    × 15-text batches  → 54 emb/s (faster!)
# Reason: llama-server's --parallel 4 queues embedding requests and adds slot
# contention instead of truly parallelising GPU inference. Keep WORKERS=1
# unless the server is re-launched with a different batching mode. ThreadPool
# is retained for easy flip if server behavior changes.
WORKERS = 1
# Per-worker HTTP timeout (seconds). Large batches of long theorems can push
# past 30s under high GPU load; 120s leaves headroom.
HTTP_TIMEOUT = 120
DRIVER = GraphDatabase.driver('bolt://localhost:7687', auth=('neo4j', 'omegatheory2026'))

FETCH = '''
MATCH (t:Theorem {namespace: 'OmegaTheoryV2'})
WHERE t.source = 'lean_env_v1'
  AND (
    t.embedding_qwen3_8b IS NULL
    OR t.embedding_qwen3_8b_at IS NULL
    OR (t.env_dumped_at IS NOT NULL AND t.embedding_qwen3_8b_at < t.env_dumped_at)
  )
RETURN t.name AS name,
       t.signature AS sig,
       coalesce(t.docstring, '') AS doc
'''

WRITE = '''
UNWIND $rows AS row
MATCH (t:Theorem {namespace: 'OmegaTheoryV2', name: row.name})
SET t.embedding_qwen3_8b = row.vec,
    t.embedding_lean = row.vec,
    t.embedding_qwen3_8b_at = datetime(),
    t.embedding_model = 'Qwen3-Embedding-8B',
    t.embedding_dim = 4096,
    t.embedder = 'qwen3-8b-bf16'
'''


def embed_batch(texts, client=None):
    """Send one HTTP request with an array of texts, return list of embeddings."""
    c = client or httpx
    r = c.post(EMBED_URL, json={'input': texts, 'model': MODEL}, timeout=HTTP_TIMEOUT)
    r.raise_for_status()
    data = r.json()['data']
    return [d['embedding'] for d in data]


def _build_text(r):
    """Compose theorem-embedding text from signature + docstring."""
    sig = (r['sig'] or '')[:1200]
    doc = '\n' + r['doc'][:400] if r['doc'] else ''
    return (sig + doc)[:2000]


def _process_batch(batch, client):
    """Embed one batch; on failure fall back to per-item retries."""
    texts = [_build_text(r) for r in batch]
    try:
        vecs = embed_batch(texts, client)
    except Exception as e:
        print(f'  ERROR batch size={len(batch)}: {e}. Retrying singly.', flush=True)
        vecs = []
        for t in texts:
            try:
                vecs.extend(embed_batch([t], client))
            except Exception as e2:
                print(f'    skip: {e2}', flush=True)
                vecs.append(None)
    return [{'name': r['name'], 'vec': v} for r, v in zip(batch, vecs) if v is not None]


def main():
    with DRIVER.session() as s:
        rows = s.run(FETCH).data()
    total = len(rows)
    print(f'[delta-embed] Theorems to embed: {total}')
    print(f'[delta-embed] config: BATCH={BATCH}, WORKERS={WORKERS}')
    sys.stdout.flush()
    if not rows:
        print('[delta-embed] nothing to do.')
        return

    t0 = time.time()
    done = 0
    last_report = 0
    # Shared connection pool — httpx.Client reuses TCP connections across
    # threads, saving TLS/handshake overhead per request.
    with httpx.Client() as client, \
         ThreadPoolExecutor(max_workers=WORKERS) as pool:
        batches = [rows[i:i + BATCH] for i in range(0, len(rows), BATCH)]
        futures = [pool.submit(_process_batch, b, client) for b in batches]
        for fut, b in zip(futures, batches):
            rows_to_write = fut.result()
            if rows_to_write:
                for attempt in range(5):
                    try:
                        with DRIVER.session() as s:
                            s.run(WRITE, rows=rows_to_write)
                        break
                    except Exception as e:
                        if 'DeadlockDetected' in str(e) and attempt < 4:
                            time.sleep(1 + attempt)
                            continue
                        raise
            done += len(b)
            if done - last_report >= 50 or done == total:
                elapsed = time.time() - t0
                eta = (elapsed / max(done, 1)) * (total - done)
                rate = done / max(elapsed, 0.01)
                print(f'  {done}/{total}  elapsed={elapsed:.0f}s  eta={eta:.0f}s  rate={rate:.1f} emb/s')
                sys.stdout.flush()
                last_report = done
    print(f'[delta-embed] done. Embedded {done} in {time.time()-t0:.1f}s '
          f'({done/max(time.time()-t0, 0.01):.1f} emb/s)')
    DRIVER.close()


if __name__ == '__main__':
    main()
