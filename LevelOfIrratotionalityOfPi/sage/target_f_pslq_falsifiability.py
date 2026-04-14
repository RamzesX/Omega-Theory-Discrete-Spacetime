#!/usr/bin/env python3
"""Session 7 / Attack 19 / Target F  —  PSLQ falsifiability test of
Conjecture 4A.4 for the slice (a,b,z0) = (1/2, 3/2, 1/2).

Conjecture 4A.4 (restated): No nonzero triple (P_0, P_1, P_2) in Z[pi]^3
satisfies  P_0 + P_1 * u + P_2 * v = 0,  where
    u =  1F1(1/2 ; 3/2 ; 1/2),
    v = d/dz 1F1(1/2 ; 3/2 ; z) | z=1/2
      = (1/3) * 1F1(3/2 ; 5/2 ; 1/2).

Equivalently: the Q-vector space V = Q + Q*pi + Q*pi^2 + ... + Q*u + Q*v
(limit deg(pi) = 3 here) has linearly independent generating tuple
    T := [1, pi, pi^2, pi^3, u, v, pi*u, pi*v].

We search over Z-linear relations among T with PSLQ.

Falsifiability:
  * If PSLQ returns no relation at precision high enough to exclude
    relations of coefficient-height <= 10^200 then Conjecture 4A.4
    survives empirically at this slice and degree.
  * If PSLQ returns a relation, print it and verify the residual
    at DOUBLE the working precision. If the relation holds, print
    that Conjecture 4A.4 is empirically FALSIFIED at the tested
    height cut-off.

Output: target_f_output.json  (for Neo4j ingestion).

Run:  python3 target_f_pslq_falsifiability.py
"""

from __future__ import annotations
import json
import os
import sys
from datetime import datetime

import mpmath
from mpmath import mp, mpf, pi, hyp1f1, pslq, mpmathify

# -------------------------------------------------------------
# Configuration
# -------------------------------------------------------------
DIGITS       = 600          # decimal digits of working precision
HEIGHT_LIMIT = 10**200      # max |coefficient| PSLQ is allowed to return
DEGREE_PI    = 3            # include 1, pi, pi^2, pi^3
SLICE        = {"a": "1/2", "b": "3/2", "z0": "1/2"}
OUTPUT_JSON  = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                            "target_f_output.json")

# -------------------------------------------------------------
# Compute 1F1 slice values at requested precision
# -------------------------------------------------------------
def compute_uv(dps: int):
    mp.dps = dps
    a  = mpf(1) / 2
    b  = mpf(3) / 2
    z0 = mpf(1) / 2
    u = hyp1f1(a, b, z0)
    # 1F1'(a;b;z) = (a/b) * 1F1(a+1; b+1; z)
    v = (a / b) * hyp1f1(a + 1, b + 1, z0)
    return u, v


def build_tuple(dps: int):
    mp.dps = dps
    u, v = compute_uv(dps)
    pi_val = mp.pi
    T = [mpf(1), pi_val]
    for k in range(2, DEGREE_PI + 1):
        T.append(pi_val ** k)
    T.append(u)
    T.append(v)
    T.append(pi_val * u)
    T.append(pi_val * v)
    labels = ["1", "pi", "pi^2", "pi^3", "u", "v", "pi*u", "pi*v"]
    return T, labels


# -------------------------------------------------------------
# Run PSLQ
# -------------------------------------------------------------
def run_pslq(T, labels, dps_hint: int, maxcoeff: int):
    # mpmath.pslq takes a list of mpf (or mpc) and returns either a
    # list of small integer coefficients c such that sum(c_i * T_i) ~ 0,
    # or None if no relation below the height bound is found.
    tol_dps = dps_hint // 2
    mp.dps = dps_hint
    result = pslq(T, tol=mpf(10) ** (-tol_dps), maxcoeff=maxcoeff)
    return result


# -------------------------------------------------------------
# Verify a candidate relation by re-evaluating at double precision
# -------------------------------------------------------------
def verify(relation, double_dps: int):
    mp.dps = double_dps
    T, labels = build_tuple(double_dps)
    residual = sum(mpf(c) * t for c, t in zip(relation, T))
    return residual


# -------------------------------------------------------------
# Main driver
# -------------------------------------------------------------
def main():
    print(f"Session 7 — Target F — PSLQ falsifiability test")
    print(f"Slice: a={SLICE['a']}, b={SLICE['b']}, z0={SLICE['z0']}")
    print(f"Tuple deg_pi = {DEGREE_PI}, height limit = 10^200, dps = {DIGITS}")
    print("-" * 60)

    T, labels = build_tuple(DIGITS)
    for lab, val in zip(labels, T):
        head = mp.nstr(val, 12)
        print(f"  {lab:8s} ≈ {head}")
    print("-" * 60)

    print("Running PSLQ ... (this may take a minute)")
    try:
        relation = run_pslq(T, labels, DIGITS, HEIGHT_LIMIT)
    except mpmath.libmp.libhyper.NoConvergence as exc:
        relation = None
        fail_reason = str(exc)
    except Exception as exc:
        relation = None
        fail_reason = f"{type(exc).__name__}: {exc}"
    else:
        fail_reason = None

    if relation is None:
        verdict = "NO_RELATION_FOUND"
        residual = None
        reason = fail_reason or (
            f"PSLQ exhausted up to maxcoeff={HEIGHT_LIMIT} without finding "
            f"a relation; conjecture 4A.4 survives empirically."
        )
        print(f"Result: {verdict}")
        print(f"  {reason}")
    else:
        print(f"Candidate relation (coeffs in same order as labels):")
        for lab, c in zip(labels, relation):
            print(f"  {lab:8s}: {c}")
        # verify at double precision
        double_dps = 2 * DIGITS
        print(f"\nRe-verifying residual at {double_dps} dps ...")
        residual = verify(relation, double_dps)
        residual_str = mp.nstr(residual, 10)
        print(f"  residual = {residual_str}")
        # Compare magnitude with threshold
        if residual == 0 or abs(residual) < mpf(10) ** (-DIGITS):
            verdict = "CONJECTURE_4A4_FALSIFIED_EMPIRICALLY"
        else:
            verdict = "NO_RELATION_FOUND_PSEUDOHIT"
        reason = f"residual at double precision = {residual_str}"
        print(f"Result: {verdict}")

    # -------------------------------------------------------------
    # Write JSON record for Neo4j ingestion
    # -------------------------------------------------------------
    out = {
        "run_at":       datetime.utcnow().isoformat() + "Z",
        "session":      7,
        "target":       "F",
        "attack":       19,
        "slice":        SLICE,
        "degree_pi":    DEGREE_PI,
        "dps":          DIGITS,
        "height_limit": str(HEIGHT_LIMIT),
        "labels":       labels,
        "verdict":      verdict,
        "reason":       reason,
        "relation":     [str(c) for c in relation] if relation else None,
        "residual":     mp.nstr(residual, 20) if residual is not None else None,
    }
    with open(OUTPUT_JSON, "w") as f:
        json.dump(out, f, indent=2)
    print(f"\nWrote {OUTPUT_JSON}")


if __name__ == "__main__":
    main()
