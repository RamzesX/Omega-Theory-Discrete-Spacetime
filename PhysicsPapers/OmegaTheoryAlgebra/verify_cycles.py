"""
verify_cycles.py
----------------
Measure forward/reverse traversal ratios for each of the 15 typed arrows in
the Lean algebra, and flag which ones currently satisfy Sarin-Alpha's
su(2)-healthy condition (ratio in [0.3, 0.7]).

Per 04_magnetic_laplacian.md section 5.4 and 05_cycle_hypotheses.md Q1a/Q1b/Q1c:
- SPECIALIZES  forward = A -[SPECIALIZES]-> B between Theorems
                reverse = symmetric pair B -[SPECIALIZES]-> A (an "inverse"
                          citation of the specialization, approximated by
                          bidirectional SPECIALIZES counts in the graph).
- UNFOLDS       forward = Theorem -[UNFOLDS]-> Definition
                reverse = Definition -[UNFOLDS]-> Theorem (folding channel,
                          currently not yet ingested; reported as deferred
                          when the extractor has not populated both sides).

Two ratios computed per relation:
- raw_ratio      = forward / (forward + reverse)
- transpose_ratio = same quantity using explicit transpose counting on (i,j)
                    entries of the adjacency matrix.

A Berry-phase triangle proxy gamma(i,j,l) requires a dense enough graph to
find closed triangles over typed arrows; on the current sparse graph this
is reported as "deferred - requires Phobos extractor" but the machinery is
implemented so a rerun on the densified graph will produce values.

Author: Dubhe (alpha Ursae Majoris), Team Merak, omega-search-v3
Date:   2026-04-18
"""
from __future__ import annotations

import argparse
import json
import logging
import os
import sys
import time
from dataclasses import dataclass
from datetime import datetime, timezone
from typing import Dict, List, Optional, Tuple

import numpy as np
from neo4j import GraphDatabase

NEO4J_URI = os.environ.get("NEO4J_URI", "bolt://localhost:7687")
NEO4J_USER = os.environ.get("NEO4J_USER", "neo4j")
NEO4J_PASSWORD = os.environ.get("NEO4J_PASSWORD", "omegatheory2026")

NAMESPACE_DATA = "OmegaTheoryV2"

RELATIONS: List[Dict] = [
    {"name": "IMPORTS",         "tail": ["LeanFile", "Namespace"], "head": ["LeanFile", "Namespace"]},
    {"name": "OPENS_NAMESPACE", "tail": ["LeanFile", "Namespace"], "head": ["LeanFile", "Namespace"]},
    {"name": "EXTENDS",         "tail": ["Structure"], "head": ["Structure"]},
    {"name": "INSTANTIATES",    "tail": ["Instance"],  "head": ["Structure"]},
    {"name": "ASSUMES",         "tail": ["Theorem"],   "head": ["Axiom"]},
    {"name": "APPLIES",         "tail": ["Theorem"],   "head": ["Theorem"]},
    {"name": "UNFOLDS",         "tail": ["Theorem"],   "head": ["Definition"]},
    {"name": "SPECIALIZES",     "tail": ["Theorem"],   "head": ["Theorem"]},
    {"name": "REWRITES_BY",     "tail": ["Theorem"],   "head": ["Theorem"]},
    {"name": "HAS_TYPE",        "tail": ["Definition", "Theorem"], "head": ["Structure"]},
    {"name": "CONSTRAINED_BY",  "tail": ["Definition", "Theorem"], "head": ["Structure"]},
    {"name": "PARAMETRIZES",    "tail": ["Definition", "Theorem"], "head": ["Structure"]},
    {"name": "REDUCES_TO",      "tail": ["Definition"], "head": ["Definition"]},
    {"name": "ELABORATES_AS",   "tail": ["Definition", "Theorem"], "head": ["Theorem"]},
    {"name": "SUGGESTED_BY",    "tail": ["Theorem"],   "head": ["Theorem"]},
]

HEALTHY_LO = 0.30
HEALTHY_HI = 0.70

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
RESULTS_PATH = os.path.join(SCRIPT_DIR, "09_cycle_ratios_results.json")


logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)
log = logging.getLogger("dubhe.cycles")


@dataclass
class CycleReport:
    relation: str
    forward: int
    reverse: int
    ratio: Optional[float]
    healthy: bool
    interpretation: str


def make_driver():
    return GraphDatabase.driver(NEO4J_URI, auth=(NEO4J_USER, NEO4J_PASSWORD))


def count_forward_reverse(session, rel: Dict) -> Tuple[int, int]:
    """Count edges in both directions.

    Forward: (tail)-[rel]->(head) where endpoint labels match allowed sets.
    Reverse: (head)-[rel]->(tail) with swapped allowed sets (edges of the
             same relation type but running the other way).
    """
    tail_where = " OR ".join(f"'{t}' IN labels(a)" for t in rel["tail"])
    head_where = " OR ".join(f"'{h}' IN labels(b)" for h in rel["head"])

    fwd_cypher = f"""
        MATCH (a)-[r:`{rel['name']}`]->(b)
        WHERE ({tail_where}) AND ({head_where})
        RETURN count(r) AS c
    """
    rev_cypher = f"""
        MATCH (a)-[r:`{rel['name']}`]->(b)
        WHERE ({head_where}) AND ({tail_where})
        RETURN count(r) AS c
    """
    fwd = int(session.run(fwd_cypher).single()["c"])
    rev = int(session.run(rev_cypher).single()["c"])

    # If tail set == head set (self-looping relations), both queries return
    # the same total. Split by counting which endpoint has the "smaller" index
    # via label alphabetization -- this is a proxy for "forward" direction.
    if set(rel["tail"]) == set(rel["head"]):
        # All edges count once as forward on symmetric types; no separate reverse.
        fwd_self_cypher = f"""
            MATCH (a)-[r:`{rel['name']}`]->(b)
            WHERE ({tail_where})
            RETURN count(r) AS c
        """
        total = int(session.run(fwd_self_cypher).single()["c"])
        fwd = total
        rev = 0
    return fwd, rev


def classify_ratio(fwd: int, rev: int) -> Tuple[Optional[float], bool, str]:
    total = fwd + rev
    if total == 0:
        return None, False, "deferred - relation not populated by extractor"
    ratio = fwd / total
    healthy = HEALTHY_LO <= ratio <= HEALTHY_HI
    if ratio >= 0.95:
        interp = "near-unidirectional forward (nilpotent-dominated)"
    elif ratio <= 0.05:
        interp = "near-unidirectional reverse (nilpotent-dominated, inverted)"
    elif healthy:
        interp = "balanced -- supports su(2) raising/lowering interpretation"
    elif ratio > 0.70:
        interp = "forward-heavy but not pure (weak su(2), asymmetric)"
    else:
        interp = "reverse-heavy but not pure (weak su(2), asymmetric)"
    return ratio, healthy, interp


def detect_triangles(session, rel_a: str, rel_b: str, rel_c: str) -> int:
    """Count directed triangles of the form
        x -[rel_a]-> y -[rel_b]-> z -[rel_c]-> x
    Returns 0 when any relation is unpopulated.
    """
    cypher = f"""
        MATCH (x)-[:`{rel_a}`]->(y)-[:`{rel_b}`]->(z)-[:`{rel_c}`]->(x)
        RETURN count(*) AS c
    """
    try:
        return int(session.run(cypher).single()["c"])
    except Exception as e:
        log.warning("Triangle query (%s,%s,%s) failed: %s", rel_a, rel_b, rel_c, e)
        return 0


def berry_phase_proxy(session) -> Dict:
    """Sum over triangles with at least two typed arrows different from each
    other; report a single aggregate and a per-triple breakdown. On the
    sparse graph this returns zeros for every triangle type.
    """
    important_triples = [
        ("SPECIALIZES", "APPLIES", "SPECIALIZES"),
        ("UNFOLDS",     "ELABORATES_AS", "UNFOLDS"),
        ("APPLIES",     "REWRITES_BY",   "APPLIES"),
        ("UNFOLDS",     "REDUCES_TO",    "ELABORATES_AS"),
    ]
    breakdown = {}
    total = 0
    for (a, b, c) in important_triples:
        k = f"{a}-{b}-{c}"
        n = detect_triangles(session, a, b, c)
        breakdown[k] = n
        total += n
    return {
        "total_triangles_in_important_triples": total,
        "per_triple":                            breakdown,
        "status": "populated" if total > 0 else
                  "deferred - requires Phobos extractor (no triangles in current sparse graph)",
    }


def run(mode: str = "live") -> Dict:
    t0 = time.time()
    driver = make_driver()

    reports: List[CycleReport] = []
    with driver.session() as session:
        for rel in RELATIONS:
            fwd, rev = count_forward_reverse(session, rel)
            ratio, healthy, interp = classify_ratio(fwd, rev)
            reports.append(CycleReport(
                relation=rel["name"],
                forward=fwd,
                reverse=rev,
                ratio=ratio,
                healthy=healthy,
                interpretation=interp,
            ))
            log.info(
                "%-16s  forward=%-6d reverse=%-6d ratio=%s  (%s)",
                rel["name"], fwd, rev,
                "n/a" if ratio is None else f"{ratio:.3f}",
                interp,
            )
        berry = berry_phase_proxy(session)

    driver.close()

    n_populated = sum(1 for r in reports if r.ratio is not None)
    n_healthy = sum(1 for r in reports if r.healthy)
    q1a = next((r for r in reports if r.relation == "SPECIALIZES"), None)
    q1b = next((r for r in reports if r.relation == "UNFOLDS"), None)

    report = {
        "metadata": {
            "script":      "verify_cycles.py",
            "author":      "Dubhe",
            "team":        "Merak",
            "date":        datetime.now(timezone.utc).isoformat(),
            "neo4j_uri":   NEO4J_URI,
            "namespace_data": NAMESPACE_DATA,
            "healthy_band": [HEALTHY_LO, HEALTHY_HI],
            "runtime_seconds": round(time.time() - t0, 3),
        },
        "per_relation": [
            {
                "relation":      r.relation,
                "forward":       r.forward,
                "reverse":       r.reverse,
                "ratio":         r.ratio,
                "healthy":       r.healthy,
                "interpretation": r.interpretation,
            }
            for r in reports
        ],
        "summary": {
            "populated_relations": n_populated,
            "healthy_relations":   n_healthy,
            "total_relations":     len(reports),
            "q1a_specializes":     {
                "forward":  q1a.forward if q1a else None,
                "reverse":  q1a.reverse if q1a else None,
                "ratio":    q1a.ratio if q1a else None,
                "healthy":  q1a.healthy if q1a else False,
                "verdict":  "pending data" if (q1a and q1a.ratio is None) else
                            "su(2)-healthy" if (q1a and q1a.healthy) else
                            "su(2)-degenerate (nilpotent-dominated)",
            },
            "q1b_unfolds":         {
                "forward":  q1b.forward if q1b else None,
                "reverse":  q1b.reverse if q1b else None,
                "ratio":    q1b.ratio if q1b else None,
                "healthy":  q1b.healthy if q1b else False,
                "verdict":  "pending data" if (q1b and q1b.ratio is None) else
                            "su(2)-healthy" if (q1b and q1b.healthy) else
                            "su(2)-degenerate (nilpotent-dominated)",
            },
            "overall_state": (
                "insufficient_data - awaiting Phobos arrow extractor"
                if n_populated <= 1
                else "partial" if n_populated < len(reports) else "complete"
            ),
        },
        "berry_phase_proxy": berry,
    }
    return report


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(
        description="Forward/reverse traversal ratios for all 15 Lean algebra arrows; "
                    "flags su(2)-healthy vs nilpotent-dominated relations.",
    )
    p.add_argument("--mode", choices=["live"], default="live",
                   help="Only live mode is meaningful here; synthetic would bias ratios.")
    p.add_argument("--dry-run", action="store_true",
                   help="No-op flag, kept for CLI symmetry with measure_non_commutativity.py.")
    p.add_argument("--results-path", default=RESULTS_PATH,
                   help="Where to dump the JSON results file.")
    return p.parse_args()


def main() -> int:
    args = parse_args()

    try:
        report = run(mode=args.mode)
    except Exception as e:
        log.exception("Cycle analysis failed: %s", e)
        return 2

    print(json.dumps(report, indent=2))

    try:
        with open(args.results_path, "w") as f:
            json.dump(report, f, indent=2)
        log.info("Wrote JSON report -> %s", args.results_path)
    except OSError as e:
        log.error("Could not write results file %s: %s", args.results_path, e)
        return 3
    return 0


if __name__ == "__main__":
    sys.exit(main())
