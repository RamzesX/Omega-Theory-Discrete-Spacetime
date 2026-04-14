#!/usr/bin/env python3
"""Session 6 / Attack 19 / Target B

Extends the Hermite-Pade computation to n = 1..20 and fits asymptotic
decay/growth constants:

    |L_n| ~ C_L * rho^{-n}       ==>   rho  = exp( slope of (-log|L_n|) vs n )
    d_n   ~ C_d * Delta^{n}      ==>   Delta = exp( slope of  log d_n    vs n )

GAP_F closes numerically for this slice iff rho > Delta (plus epsilon).

Ran against the (a, b, z0) = (1/2, 3/2, 1/2) slice from Target A.

Emits target_b_output.json with per-n data and best-fit coefficients.
"""
from __future__ import annotations
import json, os, sys, time
from math import factorial

import sympy as sp
import mpmath

# ----------------------------------------------------------------------
# Configuration
# ----------------------------------------------------------------------
A_PARAM = sp.Rational(1, 2)
B_PARAM = sp.Rational(3, 2)
Z0      = sp.Rational(1, 2)
N_MIN   = 1
N_MAX   = 20
FIT_FROM = 5                    # drop early-n transient from the fit
PREC_BITS = 600
PREC_DPS  = int(PREC_BITS * 0.30103) + 20

OUTPUT_JSON = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                           'target_b_output.json')

# ----------------------------------------------------------------------
# Coefficients
# ----------------------------------------------------------------------
def poch(x, k):
    p = sp.Integer(1)
    for i in range(k):
        p = p * (x + i)
    return sp.Rational(p)

def f_coeff(k):
    return poch(A_PARAM, k) / (poch(B_PARAM, k) * sp.Integer(factorial(k)))

def g_coeff(k):
    return sp.Integer(k + 1) * f_coeff(k + 1)

# ----------------------------------------------------------------------
# Pade solver (sympy nullspace over Q)
# ----------------------------------------------------------------------
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
    alpha = v_int[0 : n + 1]
    beta  = v_int[n + 1 : 2 * (n + 1)]
    gamma = v_int[2 * (n + 1) : 3 * (n + 1)]
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

# ----------------------------------------------------------------------
# High precision evaluation
# ----------------------------------------------------------------------
def series_at(coeff_fn, z0_mpf, tol):
    s = mpmath.mpf(0)
    pw = mpmath.mpf(1)
    for k in range(0, 200000):
        c = mpmath.mpf(str(coeff_fn(k)))
        t = c * pw
        s += t
        if k > 5 and mpmath.fabs(t) < tol:
            return s, k
        pw *= z0_mpf
    raise RuntimeError("series did not converge")

def poly_eval_mpf(coeffs, z0_mpf):
    s = mpmath.mpf(0)
    pw = mpmath.mpf(1)
    for c in coeffs:
        s += mpmath.mpf(int(c)) * pw
        pw *= z0_mpf
    return s

def rat_poly_eval(coeffs, z0_q):
    s = sp.Rational(0)
    pw = sp.Rational(1)
    for c in coeffs:
        s += sp.Rational(int(c)) * pw
        pw *= z0_q
    return sp.Rational(s)

# ----------------------------------------------------------------------
# Linear regression: y = a + b*x, returns (a, b) by least squares
# ----------------------------------------------------------------------
def linfit(xs, ys):
    n = len(xs)
    sx = sum(xs)
    sy = sum(ys)
    sxx = sum(x*x for x in xs)
    sxy = sum(x*y for x, y in zip(xs, ys))
    det = n * sxx - sx * sx
    slope = (n * sxy - sx * sy) / det
    intercept = (sy - slope * sx) / n
    return intercept, slope

# ----------------------------------------------------------------------
# Main
# ----------------------------------------------------------------------
def main():
    mpmath.mp.dps = PREC_DPS
    z0_mpf = mpmath.mpf(str(Z0))
    tol = mpmath.mpf(2) ** (-(PREC_BITS + 20))

    print("=" * 78)
    print(f" Target B — asymptotic Hermite-Pade for (a,b,z0) = ({A_PARAM},{B_PARAM},{Z0})")
    print(f" n = {N_MIN}..{N_MAX}   precision = {PREC_BITS} bits   fit from n>={FIT_FROM}")
    print("=" * 78)

    t0 = time.time()
    fz, kf = series_at(f_coeff, z0_mpf, tol)
    gz, kg = series_at(g_coeff, z0_mpf, tol)
    print(f"  f(z0) ≈ {mpmath.nstr(fz, 30)}   ({kf} terms)")
    print(f"  g(z0) ≈ {mpmath.nstr(gz, 30)}   ({kg} terms)")

    results = []
    for n in range(N_MIN, N_MAX + 1):
        tn = time.time()
        alpha, beta, gamma = pade_nnn(n)
        Aq = rat_poly_eval(alpha, Z0)
        Bq = rat_poly_eval(beta,  Z0)
        Cq = rat_poly_eval(gamma, Z0)
        denom_q = sp.ilcm(sp.ilcm(Aq.q, Bq.q), Cq.q)
        height = max(abs(c) for c in alpha + beta + gamma if c != 0)

        Az = poly_eval_mpf(alpha, z0_mpf)
        Bz = poly_eval_mpf(beta,  z0_mpf)
        Cz = poly_eval_mpf(gamma, z0_mpf)
        Lval = Az + Bz * fz + Cz * gz
        Labs = mpmath.fabs(Lval)

        log_L   = float(mpmath.log(Labs)) if Labs > 0 else None
        log_d   = float(mpmath.log(mpmath.mpf(int(denom_q)))) if denom_q > 1 else 0.0
        rho_n   = -log_L / n if log_L is not None else None
        delta_n = log_d / n

        dt = time.time() - tn
        print(f"  n={n:2d}   |L_n|={mpmath.nstr(Labs, 8):>16}   "
              f"d_n={int(denom_q):>6}   "
              f"rho^={rho_n:7.4f}   Delta^={delta_n:7.4f}   "
              f"height={len(str(height)):3d} digits   "
              f"[{dt:5.1f}s]")

        results.append({
            "n":       n,
            "height":  int(height),
            "L_abs":   mpmath.nstr(Labs, 80),
            "log_L":   log_L,
            "denom":   int(denom_q),
            "log_d":   log_d,
            "rho_n":   rho_n,
            "delta_n": delta_n,
            "seconds": dt,
        })

    # -------------- Fit --------------
    ns   = [r["n"] for r in results if r["n"] >= FIT_FROM]
    negL = [-r["log_L"] for r in results if r["n"] >= FIT_FROM]
    logD = [r["log_d"]  for r in results if r["n"] >= FIT_FROM]

    intercept_rho,   slope_rho   = linfit(ns, negL)
    intercept_delta, slope_delta = linfit(ns, logD)

    rho   = mpmath.exp(slope_rho)
    Delta = mpmath.exp(slope_delta)

    print()
    print("=" * 78)
    print(f" Asymptotic fit from n={FIT_FROM}..{N_MAX}")
    print("=" * 78)
    print(f"  slope of -log|L_n| vs n : {slope_rho:.8f}   =>   rho   = exp(slope) = {mpmath.nstr(rho, 10)}")
    print(f"  slope of  log d_n  vs n : {slope_delta:.8f}   =>   Delta = exp(slope) = {mpmath.nstr(Delta, 10)}")
    print(f"  rho - Delta (log scale) : {slope_rho - slope_delta:.8f}")
    print(f"  margin factor rho/Delta : {mpmath.nstr(rho/Delta if Delta > 0 else mpmath.inf, 8)}")

    # GAP_F verdict
    if slope_rho > slope_delta + 0.5:
        verdict = "GAP_F CLOSED EMPIRICALLY (margin > 0.5 in log scale)"
    elif slope_rho > slope_delta:
        verdict = f"GAP_F marginal (log-margin = {slope_rho - slope_delta:.4f})"
    else:
        verdict = "GAP_F OPEN: rho <= Delta for this slice"

    print()
    print(f"  VERDICT: {verdict}")
    print("=" * 78)

    total_t = time.time() - t0
    print(f"\nTotal wall time: {total_t:.1f} s")

    summary = {
        "slice":       {"a": str(A_PARAM), "b": str(B_PARAM), "z0": str(Z0)},
        "n_range":     [N_MIN, N_MAX],
        "fit_from":    FIT_FROM,
        "prec_bits":   PREC_BITS,
        "results":     results,
        "fit": {
            "slope_rho":        slope_rho,
            "intercept_rho":    intercept_rho,
            "slope_delta":      slope_delta,
            "intercept_delta":  intercept_delta,
            "rho":              float(rho),
            "Delta":            float(Delta),
            "log_margin":       slope_rho - slope_delta,
            "verdict":          verdict,
        },
        "wall_seconds": total_t,
        "session":      6,
        "attack":       "Attack19_PureHermitePade",
        "target":       "B",
    }
    with open(OUTPUT_JSON, "w") as fh:
        json.dump(summary, fh, indent=2)
    print(f"[saved] {OUTPUT_JSON}")

if __name__ == "__main__":
    main()
