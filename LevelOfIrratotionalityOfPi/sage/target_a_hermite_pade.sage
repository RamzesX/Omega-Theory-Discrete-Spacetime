#!/usr/bin/env sage
# -*- coding: utf-8 -*-
#
# Session 6 / Attack 19 / Target A
# Pure Hermite-Pade Type II [n; n, n] simultaneous approximant to
#     (1, f(z), g(z))   with   f(z) = 1F1(a; b; z),   g(z) = d/dz f(z).
#
# Test slice: (a, b, z0) = (1/2, 3/2, 1/2).
#
# Verifies:
#   F49 (existence & uniqueness of [n;n,n] Pade over Q(pi) — here over Q
#        since at construction stage no pi is involved),
#   F50 (contour-driven exponential decay |L_n| ~ rho^{-n}),
#   F51 (Pochhammer-driven denominator growth d_n ~ Delta^n),
#   and collects the data needed for GAP_F: decide rho > Delta.
#
# Ran successfully on SageMath 10.x.
#
# Emits JSON summary to sage/target_a_output.json for Neo4j ingestion.
#
# NOTE on the slice choice: (a,b)=(1,2) is DEGENERATE because
# 1F1(1;2;z) = (e^z - 1)/z makes {1, f, g} Q(z)-linearly dependent
# via (1-z)f + z g = 1. The smallest clean slice is half-integer parameters.

from sage.all import (
    QQ, ZZ, RealField, PolynomialRing, PowerSeriesRing, Matrix, Rational,
    factorial, prod, lcm, log, abs as sage_abs,
)
import json, os, sys

# ----------------------------------------------------------------------
# Configuration
# ----------------------------------------------------------------------
A_PARAM = QQ(1) / 2
B_PARAM = QQ(3) / 2
Z0      = QQ(1) / 2
N_MAX   = 6
PREC    = 400    # bits of precision for numerical evaluation of |L_n|

OUTPUT_JSON = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                           'target_a_output.json')

# ----------------------------------------------------------------------
# Taylor coefficients  f_k = (a)_k / ((b)_k * k!),  g_k = (k+1) f_{k+1}
# ----------------------------------------------------------------------
def poch(x, k):
    return prod((x + i) for i in range(k)) if k > 0 else QQ(1)

def f_coeff(k):
    return poch(A_PARAM, k) / (poch(B_PARAM, k) * factorial(k))

def g_coeff(k):
    return (k + 1) * f_coeff(k + 1)

# ----------------------------------------------------------------------
# Solve for the Pade approximant [n; n, n]
# ----------------------------------------------------------------------
R = PolynomialRing(QQ, 'z')
z = R.gen()

def pade_nnn(n):
    """Return (A, B, C) in Z[z], each of degree <= n, unique up to Q-scalar,
    such that ord_{z=0}(A + B f + C g) >= 3n + 2.

    The coefficient ring after clearing denominators is Z[z]; the result
    certifies existence (F49) and gives an exact integer representative.
    """
    rows = 3 * n + 2            # number of Taylor-vanishing conditions
    cols = 3 * (n + 1)          # alpha_0..alpha_n, beta_0..beta_n, gamma_0..gamma_n
    M = Matrix(QQ, rows, cols, sparse=False)
    for m in range(rows):
        if m <= n:
            M[m, m] = QQ(1)                          # z^m coeff of A(z)
        for i in range(min(m, n) + 1):
            M[m, (n + 1) + i]       = f_coeff(m - i)  # beta_i contribution to z^m
            M[m, 2 * (n + 1) + i]   = g_coeff(m - i)  # gamma_i contribution to z^m
    K = M.right_kernel()
    if K.dimension() != 1:
        raise RuntimeError(
            f"n={n}: kernel dim = {K.dimension()} (expected 1). "
            f"Slice (a,b)=({A_PARAM},{B_PARAM}) is degenerate at this order."
        )
    v = K.basis()[0]
    # Clear denominators to land in Z^{3n+3}
    den = lcm([c.denominator() for c in v])
    v = den * v

    alpha = list(v[0:n + 1])
    beta  = list(v[n + 1:2 * (n + 1)])
    gamma = list(v[2 * (n + 1):3 * (n + 1)])

    A = R(alpha)
    B = R(beta)
    C = R(gamma)

    # Sign normalization: make the first nonzero leading coefficient positive
    for poly in (A, B, C):
        if poly != 0:
            if poly.leading_coefficient() < 0:
                A, B, C = -A, -B, -C
            break

    # Verify vanishing order (F49 certificate)
    S = PowerSeriesRing(QQ, 'w', default_prec=3 * n + 5)
    w = S.gen()
    fs = sum(f_coeff(k) * w**k for k in range(3 * n + 5))
    gs = sum(g_coeff(k) * w**k for k in range(3 * n + 5))
    Rseries = S(A(w)) + S(B(w)) * fs + S(C(w)) * gs
    vord = Rseries.valuation()
    assert vord >= 3 * n + 2, f"n={n}: ord_0 R = {vord} < {3*n+2}"
    return A, B, C, vord

# ----------------------------------------------------------------------
# High-precision numerical evaluation
# ----------------------------------------------------------------------
def eval_L(A, B, C, z0_q, prec):
    """Compute L_n = R_n(z0) at `prec` bits. Returns (L_n, |L_n|, Az, Bz, Cz).
    Truncation of the series for f, g is dynamic: stop when the next term
    contributes below 2^{-(prec+20)} in magnitude.
    """
    RRhp = RealField(prec)
    z0 = RRhp(z0_q)
    # Dynamic series truncation for f(z0), g(z0)
    tol = RRhp(2) ** (-(prec + 20))

    def safe_sum(coeff_fn):
        s = RRhp(0)
        pw = RRhp(1)  # z0^k, starting at k=0
        for k in range(0, 50000):
            term = RRhp(coeff_fn(k)) * pw
            s += term
            if k > 5 and sage_abs(term) < tol:
                return s
            pw *= z0
        raise RuntimeError("series failed to converge within 50000 terms")

    fz = safe_sum(f_coeff)
    gz = safe_sum(g_coeff)

    # Evaluate polynomials at z0
    Az = sum(RRhp(A[i]) * (z0 ** i) for i in range(A.degree() + 1))
    Bz = sum(RRhp(B[i]) * (z0 ** i) for i in range(B.degree() + 1))
    Cz = sum(RRhp(C[i]) * (z0 ** i) for i in range(C.degree() + 1))

    Lval = Az + Bz * fz + Cz * gz
    return Lval, sage_abs(Lval), Az, Bz, Cz, fz, gz

# ----------------------------------------------------------------------
# Main
# ----------------------------------------------------------------------
def main():
    print("=" * 78)
    print(f" Target A — Hermite-Pade [n;n,n] simultaneous approximant")
    print(f" f(z) = 1F1({A_PARAM}; {B_PARAM}; z)")
    print(f" g(z) = f'(z)")
    print(f" Slice: (a, b, z0) = ({A_PARAM}, {B_PARAM}, {Z0})")
    print(f" n = 1 .. {N_MAX},  precision = {PREC} bits")
    print("=" * 78)

    RR_report = RealField(80)
    results = []

    for n in range(1, N_MAX + 1):
        A, B, C, vord = pade_nnn(n)
        height = max(
            [ZZ(c).abs() for c in list(A) + list(B) + list(C) if c != 0]
            or [ZZ(0)]
        )

        Lval, Labs, Az, Bz, Cz, fz, gz = eval_L(A, B, C, Z0, PREC)

        Aq = A(Z0)
        Bq = B(Z0)
        Cq = C(Z0)
        denom_q = lcm([Aq.denominator(), Bq.denominator(), Cq.denominator()])

        # Empirical decay/growth rates (natural log)
        rho_hat   = RR_report((-log(Labs)) / n) if Labs > 0 else None
        delta_hat = RR_report(log(RR_report(denom_q)) / n) if denom_q > 1 else RR_report(0)

        print(f"\n--- n = {n} ---------------------------------------------------")
        print(f"  A_n(z) = {A}")
        print(f"  B_n(z) = {B}")
        print(f"  C_n(z) = {C}")
        print(f"  height (max |Z-coeff|) : {height}")
        print(f"  ord_{{z=0}} R_n          : {vord}   (required >= {3*n+2})")
        print(f"  A_n(1/2)  = {Aq}")
        print(f"  B_n(1/2)  = {Bq}")
        print(f"  C_n(1/2)  = {Cq}")
        print(f"  lcm of denoms at z0   : {denom_q}")
        print(f"  L_n = R_n(1/2)         ≈ {RealField(50)(Lval)}")
        print(f"  |L_n|                  ≈ {RealField(50)(Labs)}")
        print(f"  rho_hat   = -log|L_n|/n ≈ {rho_hat}")
        print(f"  Delta_hat =  log(d_n)/n ≈ {delta_hat}")

        results.append({
            "n": int(n),
            "A_poly":    [str(c) for c in A.list()],
            "B_poly":    [str(c) for c in B.list()],
            "C_poly":    [str(c) for c in C.list()],
            "height":    int(height),
            "ord_R":     int(vord),
            "A_at_z0":   str(Aq),
            "B_at_z0":   str(Bq),
            "C_at_z0":   str(Cq),
            "denom_z0":  int(denom_q),
            "L_value":   str(Lval),
            "L_abs":     str(Labs),
            "rho_hat":   str(rho_hat) if rho_hat is not None else None,
            "delta_hat": str(delta_hat),
        })

    print("\n" + "=" * 78)
    print(" Summary table (GAP_F criterion: need rho > Delta asymptotically)")
    print("=" * 78)
    print(f"{'n':>3}  {'|L_n|':>22}  {'rho_hat':>14}  {'Delta_hat':>14}  {'rho - Delta':>14}")
    for row in results:
        n = row["n"]
        Labs = RealField(60)(row["L_abs"])
        r = RealField(30)(row["rho_hat"]) if row["rho_hat"] else RealField(30)(0)
        D = RealField(30)(row["delta_hat"])
        print(f"{n:3d}  {Labs:22.6e}  {r:14.6f}  {D:14.6f}  {(r - D):14.6f}")

    summary = {
        "slice":   {"a": str(A_PARAM), "b": str(B_PARAM), "z0": str(Z0)},
        "n_max":   int(N_MAX),
        "prec":    int(PREC),
        "results": results,
        "session": 6,
        "attack":  "Attack19_PureHermitePade",
        "target":  "A",
    }
    with open(OUTPUT_JSON, "w") as fh:
        json.dump(summary, fh, indent=2)
    print(f"\n[saved] {OUTPUT_JSON}")

    # Quick verdict
    final = results[-1]
    r_final = float(final["rho_hat"]) if final["rho_hat"] else 0.0
    d_final = float(final["delta_hat"])
    print()
    print("=" * 78)
    print(f"  Provisional (n={final['n']}):  rho_hat = {r_final:.4f}   Delta_hat = {d_final:.4f}")
    if r_final > d_final:
        print(f"  rho > Delta  ✓   (gap = {r_final - d_final:.4f})   -> GAP_F trending CLOSED")
    elif r_final < d_final:
        print(f"  rho < Delta  ✗   (gap = {d_final - r_final:.4f})   -> need different slice")
    else:
        print(f"  rho ≈ Delta  — need Target B (n up to 20) for stable fit")
    print("=" * 78)


if __name__ == "__main__":
    main()
