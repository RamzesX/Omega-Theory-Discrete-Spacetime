#!/usr/bin/env python3
"""
KK-Bimodule Trace Dressing — species-dependent multiplicative weights
for the Connes spectral ratio scan.

HYPOTHESIS (Altair's memo §2.2 + coordinator brief):

    m_sector_gen(N) = w_sector · higgs_vev · Y_sector[gen] · f(δ_gen(N))

where `w_sector` is a multiplicative species-dependent weight coming from
the KK-bimodule trace on the Connes almost-commutative spectral triple
    A_F = ℂ ⊕ ℍ ⊕ M_3(ℂ) ,   H_F = 96-dim ,   KO-dim = 6.

Key observation (Altair §2.2, last paragraph):
    > "the species-generation coefficient comes from the KK-bimodule
    >  representation's trace against the Dirac kernel. Absent the
    >  heat-kernel expansion, we formalize spectralWeight_X(i) as a
    >  STRUCTURAL PARAMETER — a real number per (species, generation)"

For RATIO predictions (which is all we compute), the GENERATION-INDEPENDENT
pieces cancel. The species-dependent piece `w_sector` ALSO cancels in
intra-sector ratios because both numerator and denominator receive the
same `w`. So `w_sector` alone cannot change intra-sector ratios such as
`m_c/m_u`, `m_t/m_c`, `m_s/m_d`, `m_b/m_s`.

!!! THIS MEANS: a naive per-sector weight WILL NOT CLOSE THE GAP. !!!

To matter, the dressing must be GENERATION-DEPENDENT within a sector.
Generation-dependent weights come from:
  * KK-bimodule projection onto generation-indexed subspaces
    (left-action + right-action of A_F ⊗ A_F^op on H_F)
  * chirality projection (left-handed weak doublet vs right-handed singlet)
  * KO-dimension "doublet" chirality factors

Candidate weights per generation:
  * Weight of gen i ∝ dim(projection onto H_F(gen=i, sector=X))
  * Weight of gen i ∝ chirality_factor(gen i) from SU(2)_L doublet count
  * For up/down sectors: per-generation SU(2)_L_up/L_down count differs?

But at block-matrix level, ALL three generations have the SAME SU(2) and
colour content (per Connes reconstruction, each generation replicates
(Q_L, u_R, d_R, ℓ_L, e_R, ν_R) with identical representation structure).
So generation-indexed bimodule weights are all EQUAL by symmetry.

CONCLUSION (structural): a "trace dressing of A_F ⊗ A_F^op onto H_F" that
respects the generation symmetry cannot close intra-sector mass-ratio gaps.

However, two LESS-SYMMETRIC dressings might close:

A. CHIRALITY-BREAKING DRESSING: Connes' KO-dim 6 introduces a chirality grading
   Γ that distinguishes left-handed and right-handed components. If the
   up-type quark's chirality content differs per GENERATION (e.g., due to
   spontaneous symmetry breaking by the Higgs VEV entering per-generation
   differently), then w_up(gen) can differ per gen.

B. GENERATION-SPECIFIC IRRATIONAL DRESSING: Altair's memo §3.1.5 notes
   that the 3-irrationals assignment (π → heavy, e → middle, √2 → light)
   is an empirical mapping. A KK-trace dressing could enforce gen-specific
   weights w_i = dim(H_F_gen_i_X_block) / dim(H_F). By representation-theory,
   this is CONSTANT across generations (all 3 gens have same bimodule
   structure per Connes SM reconstruction), so option B also fails.

ACTUAL TEST: can a PAIR (w_up, w_down) with w_up, w_down ∈ {rationals from
small dim counts} improve anything, even though the math says "cancels
in ratios"? We explore ALL per-sector weights to confirm the prediction
that they cancel.

THEN we explore GENERATION-DEPENDENT weights w(gen, sector) drawn from
bimodule-counting candidates:
  * SU(2)_L content: gen_i all have same doublet, weight = 2 for each
  * Chirality: R has weight 1 (singlet), L has weight 2 (doublet)
  * Hierarchy ansatz: w_i ∝ 2^(i-1), w_i ∝ (i+1), w_i ∝ i, etc.
    — NOT derived from bimodule, flagged explicitly

The honest search: if gen-dependent weights from bimodule symmetry all
collapse to equal values, we record a NEGATIVE RESULT.
"""

import math
from fractions import Fraction

# ---------- truncation errors δ (identical to Lean) ----------
def delta_pi(N):    return 4.0 / (2*N + 3)
def delta_e(N):     return 3.0 / math.factorial(N + 1)
def delta_sqrt2(N): return 1.0 / (2.0 ** (2**N))

# ---------- Kernel: f(δ) = δ^β / (-ln δ)^k ----------
def kernel(delta, beta, k):
    if delta <= 0 or delta >= 1:
        return float('nan')
    return (delta ** beta) / (-math.log(delta)) ** k

# ---------- PDG 2024 ----------
m_u, m_c, m_t = 2.16, 1270.0, 172760.0
m_d, m_s, m_b = 4.67, 93.4, 4180.0
R_mc_mu = m_c / m_u       # ~588
R_mt_mc = m_t / m_c       # ~136
R_ms_md = m_s / m_d       # ~20.0
R_mb_ms = m_b / m_s       # ~44.8

# PDG relative errors (% per ratio)
err_mc_mu_pct = 22.0
err_mt_mc_pct = 1.6
err_ms_md_pct = 13.9
err_mb_ms_pct = 9.0

def ratio_err_pct(pred, target):
    return 100.0 * (pred - target) / target

# ========== PHASE 0: analytic demonstration that per-sector weights cancel ==========
print("=" * 100)
print("PHASE 0 — Analytic: per-SECTOR weights w_up, w_down CANCEL in intra-sector ratios")
print("=" * 100)
print()
print("Given: m_i = w_sector · Y_gen_i · f(δ_i)")
print("Ratio: m_i / m_j = (w · Y_i · f_i) / (w · Y_j · f_j) = Y_i/Y_j · f_i/f_j")
print("                                                         ")
print("The `w_sector` factor CANCELS. Per-sector dressing changes NOTHING.")
print()
print("QED: only GENERATION-DEPENDENT weights w(gen, sector) can move ratios.")
print()

# ========== PHASE 1: baseline for context ==========
# Use empirical atik β = 3/7, k = 3 (and β_down = 0)
def predict_ratios(N, beta_up, k_up, beta_dn, k_dn, w_up_gen=(1,1,1), w_dn_gen=(1,1,1)):
    """
    Compute 4 quark mass ratios given:
      - δ assignments: light=√2, middle=e, heavy=π
      - kernel params (beta, k) per sector
      - per-generation weights w_up_gen=(w1,w2,w3) for (u,c,t), etc.
    """
    d_sqrt2 = delta_sqrt2(N)  # light → u, d
    d_e     = delta_e(N)      # middle → c, s
    d_pi    = delta_pi(N)     # heavy → t, b

    f_u = w_up_gen[0] * kernel(d_sqrt2, beta_up, k_up)
    f_c = w_up_gen[1] * kernel(d_e,     beta_up, k_up)
    f_t = w_up_gen[2] * kernel(d_pi,    beta_up, k_up)

    f_d = w_dn_gen[0] * kernel(d_sqrt2, beta_dn, k_dn)
    f_s = w_dn_gen[1] * kernel(d_e,     beta_dn, k_dn)
    f_b = w_dn_gen[2] * kernel(d_pi,    beta_dn, k_dn)

    return {
        'm_c/m_u': f_c / f_u,
        'm_t/m_c': f_t / f_c,
        'm_s/m_d': f_s / f_d,
        'm_b/m_s': f_b / f_s,
    }

def hit_count(ratios):
    return sum([
        abs(ratio_err_pct(ratios['m_c/m_u'], R_mc_mu)) <= err_mc_mu_pct,
        abs(ratio_err_pct(ratios['m_t/m_c'], R_mt_mc)) <= err_mt_mc_pct,
        abs(ratio_err_pct(ratios['m_s/m_d'], R_ms_md)) <= err_ms_md_pct,
        abs(ratio_err_pct(ratios['m_b/m_s'], R_mb_ms)) <= err_mb_ms_pct,
    ])

print("=" * 100)
print("PHASE 1 — BASELINE (Acrux's C3 at N=4): β_up=5/12, β_dn=0, k=3, uniform weights")
print("=" * 100)
print()
N = 4
r = predict_ratios(N, 5/12, 3, 0, 3)
for key in ['m_c/m_u', 'm_t/m_c', 'm_s/m_d', 'm_b/m_s']:
    pred = r[key]
    target_map = {'m_c/m_u': R_mc_mu, 'm_t/m_c': R_mt_mc, 'm_s/m_d': R_ms_md, 'm_b/m_s': R_mb_ms}
    err_map = {'m_c/m_u': err_mc_mu_pct, 'm_t/m_c': err_mt_mc_pct, 'm_s/m_d': err_ms_md_pct, 'm_b/m_s': err_mb_ms_pct}
    tgt = target_map[key]
    tol = err_map[key]
    err = ratio_err_pct(pred, tgt)
    mark = "HIT" if abs(err) <= tol else "MISS"
    print(f"  {key:10s}: pred={pred:>12.4f}  PDG={tgt:>12.4f}  err={err:+6.2f}%  tol={tol:4.1f}%  {mark}")
hits = hit_count(r)
print(f"  --> C3 baseline hits {hits}/4 PDG bands")
print()

# ========== PHASE 2: generation-dependent weight scan ==========
print("=" * 100)
print("PHASE 2 — GENERATION-DEPENDENT KK-bimodule weights")
print("=" * 100)
print()
print("Scan w_up_gen=(w_u, w_c, w_t), w_dn_gen=(w_d, w_s, w_b) with small-integer ratios.")
print("Why: although Connes' block-matrix reconstruction is generation-symmetric, the")
print("KK-bimodule trace can potentially break the symmetry if we interpret the three")
print("generations as living in distinct IRRATIONALITY LABELS (π, e, √2). Then the")
print("weights become irrational-label-specific, not generation-index-specific.")
print()
print("Trying weights w(δ) where δ ∈ {δ_π, δ_e, δ_√2} — the weight only depends on")
print("which irrational labels the generation. Under the 3-irrationals mapping this")
print("is mathematically identical to a generation-indexed weight.")
print()

# Generate small-integer ratio weights
candidates = []
for num1 in range(1, 9):
    for den1 in range(1, 9):
        for num2 in range(1, 9):
            for den2 in range(1, 9):
                # weights (1, num1/den1, num2/den2) — always normalize first gen to 1
                w1 = 1.0
                w2 = num1 / den1
                w3 = num2 / den2
                if w2 == 1.0 or w3 == 1.0 or w2 == w3:
                    continue
                candidates.append((1.0, w2, w3))

# Deduplicate by rounding
seen = set()
dedup = []
for c in candidates:
    key = tuple(round(x, 6) for x in c)
    if key not in seen:
        seen.add(key)
        dedup.append(c)
candidates = dedup
print(f"  {len(candidates)} candidate weight triples (w_light=1, w_mid, w_heavy).")
print()

# Scan: for each (beta_up, k_up, beta_dn, k_dn) baseline, try all weight combinations
print("  Scanning β_up = 5/12 (Acrux C3), β_dn = 0, k=3 with all w_up_gen × w_dn_gen...")
print()

beta_up_fixed = 5/12
k_up_fixed    = 3
beta_dn_fixed = 0
k_dn_fixed    = 3
N = 4

best_hits = 0
best_entries = []
all_hits = []
total_scanned = 0
for w_up in candidates:
    for w_dn in candidates:
        total_scanned += 1
        r = predict_ratios(N, beta_up_fixed, k_up_fixed, beta_dn_fixed, k_dn_fixed, w_up, w_dn)
        h = hit_count(r)
        if h >= 3:
            all_hits.append((h, w_up, w_dn, r))
        if h > best_hits:
            best_hits = h
            best_entries = [(h, w_up, w_dn, r)]
        elif h == best_hits and h >= 3:
            best_entries.append((h, w_up, w_dn, r))

print(f"  Scanned {total_scanned} (w_up × w_dn) pairs")
print(f"  Best hit count: {best_hits}/4")
print(f"  # candidates at best hit count: {len(best_entries)}")
print(f"  # candidates with ≥3 PDG hits: {len(all_hits)}")
print()

if best_hits >= 3:
    print("  Best candidates (top 10 by sum of |err|):")
    # Rank by total absolute error
    def total_err(r):
        target_map = {'m_c/m_u': R_mc_mu, 'm_t/m_c': R_mt_mc, 'm_s/m_d': R_ms_md, 'm_b/m_s': R_mb_ms}
        return sum(abs(ratio_err_pct(r[k], target_map[k])) for k in target_map)
    all_hits_sorted = sorted(all_hits, key=lambda e: (-e[0], total_err(e[3])))
    for h, w_up, w_dn, r in all_hits_sorted[:10]:
        print(f"    hits={h}, w_up={w_up}, w_dn={w_dn}")
        for k in ['m_c/m_u', 'm_t/m_c', 'm_s/m_d', 'm_b/m_s']:
            target_map = {'m_c/m_u': R_mc_mu, 'm_t/m_c': R_mt_mc, 'm_s/m_d': R_ms_md, 'm_b/m_s': R_mb_ms}
            err_map = {'m_c/m_u': err_mc_mu_pct, 'm_t/m_c': err_mt_mc_pct, 'm_s/m_d': err_ms_md_pct, 'm_b/m_s': err_mb_ms_pct}
            err = ratio_err_pct(r[k], target_map[k])
            mark = "HIT" if abs(err) <= err_map[k] else "MISS"
            print(f"      {k:10s}: pred={r[k]:>12.4f}  PDG={target_map[k]:>12.4f}  err={err:+6.2f}%  {mark}")
        print()

# ========== PHASE 3: search over β_up, β_dn WITH weights ==========
print("=" * 100)
print("PHASE 3 — Joint scan: β_up, β_dn, weights")
print("=" * 100)
print()
print("If weights alone don't close at (5/12, 0), maybe a principled β + weight combo does.")
print("Scan β_up ∈ {p/q | p,q ≤ 12}, β_dn ∈ {0, -1/12, -2/12, ..., -8/12}")
print("with per-generation weights w ∈ {small integer ratios}.")
print()

# Restrict to a smaller weight set for joint scan
joint_weights = []
for num1 in range(1, 5):
    for den1 in range(1, 5):
        for num2 in range(1, 5):
            for den2 in range(1, 5):
                w = (1.0, num1/den1, num2/den2)
                if w[1] != 1.0 and w[2] != 1.0 and w[1] != w[2]:
                    joint_weights.append(w)

# Dedup
seen = set()
jd = []
for c in joint_weights:
    key = tuple(round(x, 6) for x in c)
    if key not in seen:
        seen.add(key)
        jd.append(c)
joint_weights = jd

# β candidates (rationals with denominator ≤ 12)
beta_up_cands = []
beta_dn_cands = []
for q in range(2, 13):
    for p in range(0, q + 1):
        beta_up_cands.append(Fraction(p, q))
        beta_dn_cands.append(Fraction(p, q))

# Dedup
beta_up_cands = sorted(set(beta_up_cands))
beta_dn_cands = sorted(set(beta_dn_cands))

# Full scan (this is ~80^3 combinations, will take a bit)
print(f"  β_up candidates: {len(beta_up_cands)}")
print(f"  β_dn candidates: {len(beta_dn_cands)}")
print(f"  weight triples: {len(joint_weights)}")
print(f"  Total combinations: ~{len(beta_up_cands) * len(beta_dn_cands) * len(joint_weights)**2}")
print()

best_hits_joint = 0
best_joint = []
k_up, k_dn, N = 3, 3, 4

# Optimization: search in stages
# Stage 1: iterate β_up, β_dn with uniform weights — check if ANY β pair gives 4/4 with uniform
print("  Stage 1: β scan with uniform weights...")
best_beta_uniform = None
best_beta_hits = 0
for b_up in beta_up_cands:
    for b_dn in beta_dn_cands:
        r = predict_ratios(N, float(b_up), k_up, float(b_dn), k_dn)
        h = hit_count(r)
        if h > best_beta_hits:
            best_beta_hits = h
            best_beta_uniform = (b_up, b_dn, r)
print(f"    Best β with uniform weights: {best_beta_uniform[0]}, {best_beta_uniform[1]} → {best_beta_hits}/4 hits")
print()

# Stage 2: for top β pairs from stage 1, try weights
# Find β pairs that got at least 2 hits
top_beta_pairs = []
for b_up in beta_up_cands:
    for b_dn in beta_dn_cands:
        r = predict_ratios(N, float(b_up), k_up, float(b_dn), k_dn)
        h = hit_count(r)
        if h >= 2:
            top_beta_pairs.append((b_up, b_dn, h))
print(f"  Stage 2: {len(top_beta_pairs)} β pairs with ≥2 hits baseline; try weights on them")

combos_closing = []
combos_3hit = []
for b_up, b_dn, baseline_h in top_beta_pairs:
    for w_up in joint_weights:
        for w_dn in joint_weights:
            r = predict_ratios(N, float(b_up), k_up, float(b_dn), k_dn, w_up, w_dn)
            h = hit_count(r)
            if h == 4:
                combos_closing.append((b_up, b_dn, w_up, w_dn, r))
            if h >= 3 and (b_up, b_dn, w_up, w_dn, r) not in combos_3hit:
                combos_3hit.append((b_up, b_dn, w_up, w_dn, r))

print(f"    Found {len(combos_closing)} combinations that hit ALL 4 PDG bands")
print(f"    Found {len(combos_3hit)} combinations that hit ≥3 PDG bands")
print()

if combos_closing:
    print("  All 4/4 PDG hits found! Top 10:")
    for i, (b_up, b_dn, w_up, w_dn, r) in enumerate(combos_closing[:10]):
        print(f"    [{i+1}] β_up={b_up}, β_dn={b_dn}, w_up={w_up}, w_dn={w_dn}")
        for k in ['m_c/m_u', 'm_t/m_c', 'm_s/m_d', 'm_b/m_s']:
            target_map = {'m_c/m_u': R_mc_mu, 'm_t/m_c': R_mt_mc, 'm_s/m_d': R_ms_md, 'm_b/m_s': R_mb_ms}
            err = ratio_err_pct(r[k], target_map[k])
            print(f"        {k:10s}: pred={r[k]:>12.4f}  err={err:+6.2f}%")
        print()
elif combos_3hit:
    print("  3/4 hits found (best available). Top 10:")
    # Rank by total error
    def total_err(r):
        target_map = {'m_c/m_u': R_mc_mu, 'm_t/m_c': R_mt_mc, 'm_s/m_d': R_ms_md, 'm_b/m_s': R_mb_ms}
        return sum(abs(ratio_err_pct(r[k], target_map[k])) for k in target_map)
    combos_3hit_sorted = sorted(combos_3hit, key=lambda e: total_err(e[4]))
    for i, (b_up, b_dn, w_up, w_dn, r) in enumerate(combos_3hit_sorted[:10]):
        print(f"    [{i+1}] β_up={b_up}, β_dn={b_dn}, w_up={w_up}, w_dn={w_dn}")
        for k in ['m_c/m_u', 'm_t/m_c', 'm_s/m_d', 'm_b/m_s']:
            target_map = {'m_c/m_u': R_mc_mu, 'm_t/m_c': R_mt_mc, 'm_s/m_d': R_ms_md, 'm_b/m_s': R_mb_ms}
            err_map = {'m_c/m_u': err_mc_mu_pct, 'm_t/m_c': err_mt_mc_pct, 'm_s/m_d': err_ms_md_pct, 'm_b/m_s': err_mb_ms_pct}
            err = ratio_err_pct(r[k], target_map[k])
            mark = "HIT" if abs(err) <= err_map[k] else "MISS"
            print(f"        {k:10s}: pred={r[k]:>12.4f}  err={err:+6.2f}%  {mark}")
        print()

# ========== PHASE 4: "principled" KK-bimodule weight candidates ==========
print("=" * 100)
print("PHASE 4 — PRINCIPLED KK-bimodule candidates")
print("=" * 100)
print()
print("Candidate weights derived from actual Connes bimodule dimensions:")
print()
print("  A_F = ℂ ⊕ ℍ ⊕ M_3(ℂ),  dim_C A_F = 1+2+9 = 12")
print("  lepton acting dim = dim_C ℂ + dim_C ℍ = 3")
print("  up-quark acting dim (incl. M_3 fund) = 3 + 3 = 6")
print("  down-quark acting dim = 3 + 3 = 6 (same)")
print()
print("  Per-gen within sector: ALL 3 gens have IDENTICAL bimodule content")
print("  in standard Connes reconstruction. So principled weights are (1, 1, 1).")
print()
print("  But: chirality-weighted versions break this:")
print("   - L-doublet contributes 2, R-singlet contributes 1 → weight 3 per fermion")
print("   - If one gen has more L-content vs R than another → asymmetry")
print()
print("  Candidates to test (just for the record):")

principled_candidates = [
    ("Equal (1,1,1)", (1, 1, 1), (1, 1, 1), "Connes block-matrix symmetry — baseline"),
    ("Chirality 3:3:3", (3, 3, 3), (3, 3, 3), "L+R = 2+1 = 3 per gen, uniform"),
    ("KO-dim +1 heavy", (1, 1, 2), (1, 1, 2), "heavy gen has extra +1 from KO-dim 6 = 4+2"),
    ("KO-dim 1:2:3", (1, 2, 3), (1, 2, 3), "linear gen index — ad hoc"),
    ("Sector-fund 1:3:9", (1, 3, 9), (1, 3, 9), "matches M_3 dim powers 3^0, 3^1, 3^2"),
    ("color triplet weight", (1, 1, 1), (3, 3, 3), "up: 1 (no color mixing), dn: 3 (color)"),
    ("color triplet 3:9:27", (1, 3, 9), (1, 3, 9), "M_3^2 action chain"),
]

best_principled = None
best_principled_h = 0
for label, w_up, w_dn, rationale in principled_candidates:
    r = predict_ratios(N, 5/12, 3, 0, 3, w_up, w_dn)
    h = hit_count(r)
    total = sum(abs(ratio_err_pct(r[k], {'m_c/m_u': R_mc_mu, 'm_t/m_c': R_mt_mc, 'm_s/m_d': R_ms_md, 'm_b/m_s': R_mb_ms}[k])) for k in r)
    print(f"\n  [{label}] {rationale}")
    for k in ['m_c/m_u', 'm_t/m_c', 'm_s/m_d', 'm_b/m_s']:
        target_map = {'m_c/m_u': R_mc_mu, 'm_t/m_c': R_mt_mc, 'm_s/m_d': R_ms_md, 'm_b/m_s': R_mb_ms}
        err_map = {'m_c/m_u': err_mc_mu_pct, 'm_t/m_c': err_mt_mc_pct, 'm_s/m_d': err_ms_md_pct, 'm_b/m_s': err_mb_ms_pct}
        err = ratio_err_pct(r[k], target_map[k])
        mark = "HIT" if abs(err) <= err_map[k] else "MISS"
        print(f"    {k:10s}: pred={r[k]:>12.4f}  err={err:+6.2f}%  {mark}")
    print(f"    Hit count: {h}/4, total |err| = {total:.1f}%")
    if h > best_principled_h:
        best_principled_h = h
        best_principled = (label, w_up, w_dn, r, total)

print()
print("=" * 100)
print("FINAL SUMMARY")
print("=" * 100)
print()
print(f"Baseline (uniform weights, β_up=5/12, β_dn=0): {hit_count(predict_ratios(N, 5/12, 3, 0, 3))}/4 hits")
print(f"Best weight-only search result: {best_hits}/4 hits")
if best_hits >= 3 and best_entries:
    h, w_up, w_dn, r = best_entries[0]
    total = sum(abs(ratio_err_pct(r[k], {'m_c/m_u': R_mc_mu, 'm_t/m_c': R_mt_mc, 'm_s/m_d': R_ms_md, 'm_b/m_s': R_mb_ms}[k])) for k in r)
    print(f"  Example: w_up={w_up}, w_dn={w_dn}")
    print(f"  Total |err| = {total:.1f}%")

print(f"Best joint β + weight search: {len(combos_closing)} 4/4 hits, {len(combos_3hit)} 3/4 hits")
print(f"Best principled KK-bimodule candidate: {best_principled_h}/4 hits")
if best_principled:
    label, w_up, w_dn, r, total = best_principled
    print(f"  = {label}: w_up={w_up}, w_dn={w_dn}, total |err| = {total:.1f}%")
