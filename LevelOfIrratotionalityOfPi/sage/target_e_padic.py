#!/usr/bin/env python3
"""Session 6 / Attack 19 / Target E

Arithmetic p-adic analysis of the Padé evaluations A_n(z_0), B_n(z_0),
C_n(z_0) and of the combined-form numerator structure, for the slice
(a,b,z_0) = (1/2, 3/2, 1/2).

Target E tests fact F52 of Module 11: that the E-function-driven part of
L_n has ord_p growing linearly in n, which is the p-adic non-vanishing
certificate that separates the attack from the G-function world (Attack
13 / F27).

Reads the coefficient data produced by target_a_hermite_pade.py if
available, else recomputes. Emits target_e_output.json.
"""
from __future__ import annotations
import json
import os
import sys
from math import factorial

import sympy as sp
import mpmath

# ----------------------------------------------------------------------
A_PARAM = sp.Rational(1, 2)
B_PARAM = sp.Rational(3, 2)
Z0      = sp.Rational(1, 2)
N_MAX   = 20
PRIMES  = [2, 3, 5, 7, 11, 13]
PREC_BITS = 400
PREC_DPS  = int(PREC_BITS * 0.30103) + 20

OUTPUT_JSON = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                           'target_e_output.json')

# ----------------------------------------------------------------------
def poch(x, k):
    p = sp.Integer(1)
    for i in range(k):
        p *= (x + i)
    return sp.Rational(p)

def f_coeff(k):
    return poch(A_PARAM, k) / (poch(B_PARAM, k) * sp.Integer(factorial(k)))

def g_coeff(k):
    return sp.Integer(k + 1) * f_coeff(k + 1)

def pade_nnn(n):
    rows = 3 * n + 2
    cols = 3 * (n + 1)
    M = sp.zeros(rows, cols)
    for m in range(rows):
        if m <= n:
            M[m, m] = sp.Integer(1)
        for i in range(min(m, n) + 1):
            M[m, (n + 1) + i]     = f_coeff(m - i)
            M[m, 2 * (n + 1) + i] = g_coeff(m - i)
    null = M.nullspace()
    if len(null) != 1:
        raise RuntimeError(f"n={n}: kernel dim {len(null)} != 1")
    v = null[0]
    denoms = [sp.Rational(c).q for c in v]
    L = 1
    for d in denoms:
        L = sp.ilcm(L, d)
    v_int = [int(sp.Rational(c) * L) for c in v]
    alpha = v_int[0:n+1]
    beta  = v_int[n+1:2*(n+1)]
    gamma = v_int[2*(n+1):3*(n+1)]
    # sign normalization
    for coeffs in (alpha, beta, gamma):
        for c in reversed(coeffs):
            if c != 0:
                if c < 0:
                    alpha = [-x for x in alpha]
                    beta  = [-x for x in beta]
                    gamma = [-x for x in gamma]
                break
        else:
            continue
        break
    return alpha, beta, gamma

def rat_poly_eval(coeffs, z0_q):
    s = sp.Rational(0)
    pw = sp.Rational(1)
    for c in coeffs:
        s += sp.Rational(int(c)) * pw
        pw *= z0_q
    return sp.Rational(s)

def ord_p(n_int: int, p: int) -> int:
    """p-adic valuation of a nonzero integer."""
    if n_int == 0:
        return None
    k = 0
    while n_int % p == 0:
        n_int //= p
        k += 1
    return k

# ----------------------------------------------------------------------
def main():
    mpmath.mp.dps = PREC_DPS
    print("=" * 80)
    print(f" Target E — p-adic structure of Pade evaluations")
    print(f" Slice (a,b,z0) = ({A_PARAM}, {B_PARAM}, {Z0})")
    print(f" n = 1..{N_MAX},  primes tested: {PRIMES}")
    print("=" * 80)
    print()
    print(f"{'n':>3} {'A(z0)':>22} {'B(z0)':>22} {'C(z0)':>22}")
    print("-" * 80)

    records = []
    # Cache of Pade coefficients
    pade_cache = {}

    for n in range(1, N_MAX + 1):
        alpha, beta, gamma = pade_nnn(n)
        pade_cache[n] = (alpha, beta, gamma)
        A_val = int(rat_poly_eval(alpha, Z0))
        B_val = int(rat_poly_eval(beta,  Z0))
        C_val = int(rat_poly_eval(gamma, Z0))

        rec = {"n": n, "A": A_val, "B": B_val, "C": C_val, "ord_p": {}}
        for p in PRIMES:
            rec["ord_p"][p] = {
                "A": ord_p(A_val, p),
                "B": ord_p(B_val, p),
                "C": ord_p(C_val, p),
                "gcd_ord": min(
                    ord_p(A_val, p) or 10**9,
                    ord_p(B_val, p) or 10**9,
                    ord_p(C_val, p) or 10**9,
                ),
            }
        records.append(rec)

        # Compact print: show magnitudes
        def short(x):
            s = str(x)
            if len(s) <= 20:
                return s
            return f"{s[:6]}...{s[-6:]}({len(s)}d)"
        print(f"{n:>3} {short(A_val):>22} {short(B_val):>22} {short(C_val):>22}")

    # ---------------- ord_p tables ----------------
    print()
    print("=" * 80)
    print(" ord_p of evaluations — looking for linear growth in n (F52 signature)")
    print("=" * 80)

    growth_data = {}
    for p in PRIMES:
        print(f"\n--- p = {p} ---")
        print(f"  {'n':>3}  {'ord_p(A)':>10}  {'ord_p(B)':>10}  {'ord_p(C)':>10}  {'gcd_ord':>10}")
        A_ords, B_ords, C_ords, g_ords = [], [], [], []
        for r in records:
            oA = r["ord_p"][p]["A"]
            oB = r["ord_p"][p]["B"]
            oC = r["ord_p"][p]["C"]
            og = r["ord_p"][p]["gcd_ord"]
            print(f"  {r['n']:>3}  {str(oA):>10}  {str(oB):>10}  {str(oC):>10}  {str(og):>10}")
            if oA is not None: A_ords.append((r['n'], oA))
            if oB is not None: B_ords.append((r['n'], oB))
            if oC is not None: C_ords.append((r['n'], oC))
            if og < 10**9: g_ords.append((r['n'], og))

        # Linear fit ord_p(X) ~ slope * n + intercept for n >= 5
        def lin_slope(pts, n_min=5):
            pts = [(n, v) for n, v in pts if n >= n_min]
            if len(pts) < 3:
                return None
            xs = [p[0] for p in pts]
            ys = [p[1] for p in pts]
            nv = len(xs)
            sx = sum(xs); sy = sum(ys); sxx = sum(x*x for x in xs); sxy = sum(x*y for x,y in zip(xs,ys))
            return (nv*sxy - sx*sy) / (nv*sxx - sx*sx)

        growth_data[p] = {
            "A_slope": lin_slope(A_ords),
            "B_slope": lin_slope(B_ords),
            "C_slope": lin_slope(C_ords),
            "gcd_slope": lin_slope(g_ords),
        }
        print(f"\n  Linear slopes (from n>=5):")
        print(f"    ord_p(A) vs n  slope ≈ {growth_data[p]['A_slope']}")
        print(f"    ord_p(B) vs n  slope ≈ {growth_data[p]['B_slope']}")
        print(f"    ord_p(C) vs n  slope ≈ {growth_data[p]['C_slope']}")
        print(f"    gcd_ord  vs n  slope ≈ {growth_data[p]['gcd_slope']}")

    # ---------------- F52 verdict ----------------
    print()
    print("=" * 80)
    print(" F52 verdict (linear growth of ord_p would confirm E-function character)")
    print("=" * 80)
    f52_passes = 0
    f52_tested = 0
    for p in PRIMES:
        g = growth_data[p]
        slopes = [g["A_slope"], g["B_slope"], g["C_slope"]]
        slopes = [s for s in slopes if s is not None]
        if not slopes:
            continue
        avg = sum(slopes) / len(slopes)
        linear = abs(avg) > 0.1
        status = "linear growth" if linear else "flat / sub-linear"
        print(f"  p = {p:2d}:  avg slope of ord_p across (A,B,C) = {avg:+6.3f}   [{status}]")
        f52_tested += 1
        if linear:
            f52_passes += 1

    print()
    print(f"  F52 passes for {f52_passes} / {f52_tested} primes tested")
    if f52_passes == f52_tested and f52_tested > 0:
        verdict = "F52 EMPIRICALLY CONFIRMED: ord_p grows linearly for all primes tested — E-function signature"
    elif f52_passes > 0:
        verdict = f"F52 PARTIAL: linear growth for {f52_passes}/{f52_tested} primes — sporadic E-signature"
    else:
        verdict = "F52 FAILS empirically: ord_p is flat across all primes tested. Arithmetic is trivial at this slice."

    print(f"  {verdict}")
    print("=" * 80)

    # Save
    summary = {
        "slice":   {"a": str(A_PARAM), "b": str(B_PARAM), "z0": str(Z0)},
        "n_range": [1, N_MAX],
        "primes":  PRIMES,
        "records": [
            {"n": r["n"],
             "A": str(r["A"]), "B": str(r["B"]), "C": str(r["C"]),
             "ord_p": {str(p): {k: (v if v is None else int(v)) for k, v in d.items()}
                       for p, d in r["ord_p"].items()}}
            for r in records
        ],
        "growth_slopes": {str(p): g for p, g in growth_data.items()},
        "verdict":  verdict,
        "session":  6,
        "attack":   "Attack19_PureHermitePade",
        "target":   "E",
    }
    with open(OUTPUT_JSON, "w") as fh:
        json.dump(summary, fh, indent=2)
    print(f"[saved] {OUTPUT_JSON}")

if __name__ == "__main__":
    main()
