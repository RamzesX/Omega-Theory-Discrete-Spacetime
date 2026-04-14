#!/usr/bin/env python3
"""Session 6 / Attack 19 / Target A  —  pure Python (sympy + mpmath) version.

Computes Type II simultaneous Hermite-Pade [n; n, n] approximants to
    (1, f(z), g(z))
with  f(z) = 1F1(a; b; z)  and  g(z) = f'(z),  over  Q[z].

Test slice: (a, b, z0) = (1/2, 3/2, 1/2).

Run:  python3 target_a_hermite_pade.py
Emits target_a_output.json next to this script for Neo4j ingestion.
"""
from __future__ import annotations
import json
import os
import sys
from fractions import Fraction
from math import factorial

import sympy as sp
import mpmath

# ----------------------------------------------------------------------
# Configuration
# ----------------------------------------------------------------------
A_PARAM = sp.Rational(1, 2)
B_PARAM = sp.Rational(3, 2)
Z0      = sp.Rational(1, 2)
N_MAX   = 6
PREC_BITS  = 400
PREC_DPS   = int(PREC_BITS * 0.30103) + 20   # decimal places for mpmath

OUTPUT_JSON = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                           'target_a_output.json')

# ----------------------------------------------------------------------
# Taylor coefficients  f_k = (a)_k / ((b)_k * k!),  g_k = (k+1) * f_{k+1}
# ----------------------------------------------------------------------
def poch(x: sp.Rational, k: int) -> sp.Rational:
    prod = sp.Integer(1)
    for i in range(k):
        prod = prod * (x + i)
    return sp.Rational(prod)

def f_coeff(k: int) -> sp.Rational:
    return poch(A_PARAM, k) / (poch(B_PARAM, k) * sp.Integer(factorial(k)))

def g_coeff(k: int) -> sp.Rational:
    return sp.Integer(k + 1) * f_coeff(k + 1)

# ----------------------------------------------------------------------
# Pade solver
# ----------------------------------------------------------------------
def pade_nnn(n: int):
    """Return (A_coeffs, B_coeffs, C_coeffs) as lists of length n+1 in Z,
    unique up to sign, satisfying ord_{z=0} (A + B f + C g) >= 3n + 2.
    """
    rows = 3 * n + 2
    cols = 3 * (n + 1)
    M = sp.zeros(rows, cols)
    for m in range(rows):
        if m <= n:
            M[m, m] = sp.Integer(1)                    # alpha_m contributes to z^m
        for i in range(min(m, n) + 1):
            M[m, (n + 1) + i]       = f_coeff(m - i)    # beta_i
            M[m, 2 * (n + 1) + i]   = g_coeff(m - i)    # gamma_i

    # Kernel over Q
    null = M.nullspace()
    if len(null) != 1:
        raise RuntimeError(
            f"n={n}: kernel dim = {len(null)} (expected 1). "
            f"Slice (a,b)=({A_PARAM}, {B_PARAM}) is degenerate at this order."
        )
    v = null[0]
    # Clear denominators to Z
    denoms = [sp.Rational(c).q for c in v]
    L = 1
    for d in denoms:
        L = sp.ilcm(L, d)
    v_int = [int(sp.Rational(c) * L) for c in v]

    alpha = v_int[0 : n + 1]
    beta  = v_int[n + 1 : 2 * (n + 1)]
    gamma = v_int[2 * (n + 1) : 3 * (n + 1)]

    # Sign normalization: first nonzero leading coefficient positive
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

    # Verify vanishing order (F49 certificate) by substituting power series
    # Compute A + B f + C g up to z^{3n+4} and check valuation.
    max_deg = 3 * n + 4
    # coefficients of A + B f + C g at z^m
    R_coeffs = [sp.Rational(0)] * (max_deg + 1)
    for i, ai in enumerate(alpha):
        if ai != 0:
            R_coeffs[i] += sp.Rational(ai)
    for i, bi in enumerate(beta):
        if bi == 0:
            continue
        for k in range(0, max_deg - i + 1):
            R_coeffs[i + k] += sp.Rational(bi) * f_coeff(k)
    for i, ci in enumerate(gamma):
        if ci == 0:
            continue
        for k in range(0, max_deg - i + 1):
            R_coeffs[i + k] += sp.Rational(ci) * g_coeff(k)

    vord = None
    for m, rc in enumerate(R_coeffs):
        if rc != 0:
            vord = m
            break
    if vord is None:
        vord = max_deg + 1
    assert vord >= 3 * n + 2, f"n={n}: vanishing order {vord} < {3*n+2}"

    return alpha, beta, gamma, vord

# ----------------------------------------------------------------------
# High-precision evaluation
# ----------------------------------------------------------------------
def eval_series(coeff_fn, z0_mpf, tol_mpf):
    """Sum coeff_fn(k) * z0^k until terms drop below tol_mpf."""
    total = mpmath.mpf(0)
    pw = mpmath.mpf(1)  # z0^0
    for k in range(0, 50000):
        c = mpmath.mpf(str(coeff_fn(k)))
        term = c * pw
        total += term
        if k > 5 and mpmath.fabs(term) < tol_mpf:
            return total, k
        pw *= z0_mpf
    raise RuntimeError("series failed to converge within 50000 terms")

def poly_at(coeffs, z0_mpf):
    s = mpmath.mpf(0)
    pw = mpmath.mpf(1)
    for c in coeffs:
        s += mpmath.mpf(int(c)) * pw
        pw *= z0_mpf
    return s

def rat_poly_at(coeffs, z0_q):
    """Evaluate polynomial in Q at z0 in Q, returning sp.Rational."""
    s = sp.Rational(0)
    pw = sp.Rational(1)
    for c in coeffs:
        s += sp.Rational(c) * pw
        pw *= z0_q
    return sp.Rational(s)

# ----------------------------------------------------------------------
# Main
# ----------------------------------------------------------------------
def main():
    mpmath.mp.dps = PREC_DPS
    z0_mpf = mpmath.mpf(str(Z0))
    tol = mpmath.mpf(2) ** (-(PREC_BITS + 20))

    print("=" * 78)
    print(f" Target A — Hermite-Pade [n;n,n] simultaneous approximant")
    print(f" f(z) = 1F1({A_PARAM}; {B_PARAM}; z),   g(z) = f'(z)")
    print(f" Slice: (a, b, z0) = ({A_PARAM}, {B_PARAM}, {Z0})")
    print(f" n = 1 .. {N_MAX},  mpmath dps = {mpmath.mp.dps}")
    print("=" * 78)

    # Pre-compute f(z0), g(z0) at high precision once
    fz, nterms_f = eval_series(f_coeff, z0_mpf, tol)
    gz, nterms_g = eval_series(g_coeff, z0_mpf, tol)
    print(f"  f(z0) computed with {nterms_f} terms,  g(z0) with {nterms_g}")
    print(f"  f(z0) ≈ {mpmath.nstr(fz, 30)}")
    print(f"  g(z0) ≈ {mpmath.nstr(gz, 30)}")

    results = []
    for n in range(1, N_MAX + 1):
        alpha, beta, gamma, vord = pade_nnn(n)
        height = max(abs(c) for c in alpha + beta + gamma if c != 0) if any(
            c != 0 for c in alpha + beta + gamma
        ) else 0

        # Evaluate polynomial pieces at z0 — exact in Q, and as mpmath floats
        Aq = rat_poly_at(alpha, Z0)
        Bq = rat_poly_at(beta,  Z0)
        Cq = rat_poly_at(gamma, Z0)
        denom_q = sp.ilcm(sp.ilcm(Aq.q, Bq.q), Cq.q)

        Az = poly_at(alpha, z0_mpf)
        Bz = poly_at(beta,  z0_mpf)
        Cz = poly_at(gamma, z0_mpf)
        Lval = Az + Bz * fz + Cz * gz
        Labs = mpmath.fabs(Lval)

        # Empirical rates
        rho_hat   = (-mpmath.log(Labs) / n) if Labs > 0 else None
        delta_hat = mpmath.log(mpmath.mpf(int(denom_q))) / n if denom_q > 1 else mpmath.mpf(0)

        def poly_str(coeffs, var='z'):
            terms = []
            for i, c in enumerate(coeffs):
                if c == 0:
                    continue
                if i == 0:
                    terms.append(f"{c}")
                elif i == 1:
                    terms.append(f"{c}*{var}")
                else:
                    terms.append(f"{c}*{var}^{i}")
            return ' + '.join(terms) if terms else '0'

        print(f"\n--- n = {n} ---------------------------------------------------")
        print(f"  A_n(z) = {poly_str(alpha)}")
        print(f"  B_n(z) = {poly_str(beta)}")
        print(f"  C_n(z) = {poly_str(gamma)}")
        print(f"  height (max |Z-coeff|)  : {height}")
        print(f"  ord_{{z=0}} R_n            : {vord}    (required >= {3*n+2})")
        print(f"  A_n(1/2)  = {Aq}")
        print(f"  B_n(1/2)  = {Bq}")
        print(f"  C_n(1/2)  = {Cq}")
        print(f"  lcm of denoms at z0     : {denom_q}")
        print(f"  L_n = R_n(1/2)          ≈ {mpmath.nstr(Lval, 25)}")
        print(f"  |L_n|                   ≈ {mpmath.nstr(Labs, 25)}")
        print(f"  rho_hat    = -log|L_n|/n ≈ {mpmath.nstr(rho_hat, 12)}")
        print(f"  Delta_hat  =  log(d_n)/n ≈ {mpmath.nstr(delta_hat, 12)}")

        results.append({
            "n": n,
            "A_poly":    [str(c) for c in alpha],
            "B_poly":    [str(c) for c in beta],
            "C_poly":    [str(c) for c in gamma],
            "height":    int(height),
            "ord_R":     int(vord),
            "A_at_z0":   str(Aq),
            "B_at_z0":   str(Bq),
            "C_at_z0":   str(Cq),
            "denom_z0":  int(denom_q),
            "L_value":   mpmath.nstr(Lval, 60),
            "L_abs":     mpmath.nstr(Labs, 60),
            "rho_hat":   mpmath.nstr(rho_hat, 20),
            "delta_hat": mpmath.nstr(delta_hat, 20),
        })

    # Summary
    print("\n" + "=" * 78)
    print(" Summary (GAP_F criterion: want rho > Delta asymptotically)")
    print("=" * 78)
    print(f"{'n':>3}  {'|L_n|':>28}  {'rho_hat':>14}  {'Delta_hat':>14}  {'rho - Delta':>14}")
    for row in results:
        n = row["n"]
        Labs = mpmath.mpf(row["L_abs"])
        r = mpmath.mpf(row["rho_hat"])
        D = mpmath.mpf(row["delta_hat"])
        diff = r - D
        print(f"{n:3d}  {mpmath.nstr(Labs, 8):>28}  {mpmath.nstr(r, 10):>14}  "
              f"{mpmath.nstr(D, 10):>14}  {mpmath.nstr(diff, 10):>14}")

    summary = {
        "slice":   {"a": str(A_PARAM), "b": str(B_PARAM), "z0": str(Z0)},
        "n_max":   N_MAX,
        "prec_bits":   PREC_BITS,
        "results": results,
        "session": 6,
        "attack":  "Attack19_PureHermitePade",
        "target":  "A",
    }
    with open(OUTPUT_JSON, "w") as fh:
        json.dump(summary, fh, indent=2)
    print(f"\n[saved] {OUTPUT_JSON}")

    final = results[-1]
    r = float(mpmath.mpf(final["rho_hat"]))
    D = float(mpmath.mpf(final["delta_hat"]))
    print("\n" + "=" * 78)
    print(f"  Provisional at n={final['n']}:  rho_hat = {r:.4f}   Delta_hat = {D:.4f}")
    if r > D:
        print(f"  rho > Delta  [OK]  (gap = {r - D:.4f})  -> GAP_F trending CLOSED for this slice")
    elif r < D:
        print(f"  rho < Delta  [x]   (gap = {D - r:.4f})  -> need different slice or longer n")
    else:
        print(f"  rho ~= Delta — run Target B (n up to 20) for stable fit")
    print("=" * 78)

if __name__ == "__main__":
    main()
