#!/usr/bin/env python3
"""
Phase 1 — Numerical validation of quark mass ratios against PDG 2024.

We evaluate THREE candidate kernel/ansatz formulas for N ∈ {2,3,4,5,6}:

  A) Pure Nashira quark kernels (as in Lean QuarkMassFromIrrationals.lean):
       m_u(gen) ∝ f_u(δ_gen) = δ^(3/7) / (-ln δ)^3
       m_d(gen) ∝ f_d(δ_gen) = 1 / (-ln δ)^3
     Higgs-vev cancels in ratios.

  B) Combined Yukawa × lepton-Nashira kernel (task-brief ansatz):
       m_u(gen) = v * y_u[gen] * f_lepton(δ_gen)     y_u = (1, 3, 9)
       m_d(gen) = v * y_d[gen] * f_lepton(δ_gen)     y_d = (1, 2, 5)
     Lepton kernel f_lepton(δ) = δ^(4/7) / (-ln δ).

  C) Pure Yukawa profile (no δ weighting):
       m_u(gen) ∝ y_u[gen]    → m_c/m_u = 3, m_t/m_c = 3, m_t/m_u = 9
       m_d(gen) ∝ y_d[gen]    → m_s/m_d = 2, m_b/m_s = 2.5, m_b/m_d = 5
     (independent of N — sanity baseline)

Target PDG 2024 quark masses (MS-bar at 2 GeV for u/d/s, m(m) for c/b, pole for t):
  m_u ≈ 2.16 MeV      m_c ≈ 1.27 GeV     m_t ≈ 172.76 GeV
  m_d ≈ 4.67 MeV      m_s ≈ 93.4 MeV     m_b ≈ 4.18 GeV

Ratios (with PDG uncertainties):
  m_c/m_u ≈ 588   (±~20% PDG, dominated by u uncertainty)
  m_t/m_c ≈ 136   (±~3%)
  m_t/m_u ≈ 79980 (derived)
  m_s/m_d ≈ 20.0  (±~3%)
  m_b/m_s ≈ 44.8  (±~5%)
  m_b/m_d ≈ 895   (derived)
"""
import math

# ---------------- δ-channel truncations (identical to Lean) ----------------
def delta_pi(N):    return 4.0 / (2*N + 3)                 # Leibniz series
def delta_e(N):     return 3.0 / math.factorial(N+1)       # Taylor of e
def delta_sqrt2(N): return 1.0 / (2.0 ** (2**N))           # Newton for √2

# ---------------- kernels ----------------
def nashira_lepton(d):  return d**(4.0/7.0) / (-math.log(d))
def nashira_up(d):      return d**(3.0/7.0) / (-math.log(d))**3
def nashira_down(d):    return 1.0 / (-math.log(d))**3

# Connes D_F Yukawa profiles (Lean YukawaMatrix.yukawaUpQuark / yukawaDownQuark)
y_up    = [1.0, 3.0, 9.0]   # (y_u, y_c, y_t)
y_down  = [1.0, 2.0, 5.0]   # (y_d, y_s, y_b)

# ---------------- PDG 2024 quark masses (MeV) ----------------
m_u_PDG = 2.16            # MeV, MS-bar 2 GeV, ±0.49 (~22%)
m_c_PDG = 1270.0          # MeV, m_c(m_c),    ±20    (~1.6%)
m_t_PDG = 172760.0        # MeV, pole,        ±300   (~0.2%)
m_d_PDG = 4.67            # MeV, MS-bar 2 GeV, ±0.48 (~10%)
m_s_PDG = 93.4            # MeV, MS-bar 2 GeV, ±8.6  (~9%)
m_b_PDG = 4180.0          # MeV, m_b(m_b),    ±30    (~0.7%)

PDG_mc_mu = m_c_PDG / m_u_PDG      # ~588
PDG_mt_mc = m_t_PDG / m_c_PDG      # ~136
PDG_mt_mu = m_t_PDG / m_u_PDG      # ~79980
PDG_ms_md = m_s_PDG / m_d_PDG      # ~20.0
PDG_mb_ms = m_b_PDG / m_s_PDG      # ~44.8
PDG_mb_md = m_b_PDG / m_d_PDG      # ~895

# PDG error budget (% relative, combined in quadrature where sensible)
err_mc_mu = math.sqrt((20/m_u_PDG*m_c_PDG/PDG_mc_mu)**2 + (0.49/m_u_PDG*100)**2) # ~22%
err_mt_mc = math.sqrt((300/m_t_PDG*100)**2 + (20/m_c_PDG*100)**2) # ~1.7%
err_mt_mu = math.sqrt((300/m_t_PDG*100)**2 + (0.49/m_u_PDG*100)**2) # ~22.7%
err_ms_md = math.sqrt((8.6/m_s_PDG*100)**2 + (0.48/m_d_PDG*100)**2) # ~13.9%
err_mb_ms = math.sqrt((30/m_b_PDG*100)**2 + (8.6/m_s_PDG*100)**2) # ~9.3%
err_mb_md = math.sqrt((30/m_b_PDG*100)**2 + (0.48/m_d_PDG*100)**2) # ~10.3%

print("=" * 100)
print("PHASE 1 — Quark mass-ratio scan against PDG 2024")
print("=" * 100)
print(f"PDG reference ratios (central, with PDG uncertainties):")
print(f"  m_c/m_u   = {PDG_mc_mu:>10.2f}   (±{err_mc_mu:.1f}%)")
print(f"  m_t/m_c   = {PDG_mt_mc:>10.2f}   (±{err_mt_mc:.1f}%)")
print(f"  m_t/m_u   = {PDG_mt_mu:>10.2f}   (±{err_mt_mu:.1f}%)")
print(f"  m_s/m_d   = {PDG_ms_md:>10.3f}   (±{err_ms_md:.1f}%)")
print(f"  m_b/m_s   = {PDG_mb_ms:>10.2f}   (±{err_mb_ms:.1f}%)")
print(f"  m_b/m_d   = {PDG_mb_md:>10.2f}   (±{err_mb_md:.1f}%)")
print()

def scan_ansatz(label, f_kernel_up, f_kernel_down,
                y_up_vec=None, y_down_vec=None):
    """
    Generic scan. kernels operate on δ values only.
    If y_*_vec given, use it as multiplicative profile: m ∝ y[gen] * kernel(δ_gen).
    Otherwise m ∝ kernel(δ_gen).
    """
    print("=" * 100)
    print(f"Ansatz: {label}")
    print("=" * 100)
    print(f"{'N':>3} | {'m_c/m_u':>10} {'err %':>8} | {'m_t/m_c':>10} {'err %':>8} | "
          f"{'m_s/m_d':>10} {'err %':>8} | {'m_b/m_s':>10} {'err %':>8} | total |err|")
    print("-" * 125)

    best = {'N': None, 'err_total': 1e99}
    for N in range(2, 7):
        dp = delta_pi(N)
        de = delta_e(N)
        dr = delta_sqrt2(N)
        if not (0 < dp < 1 and 0 < de < 1 and 0 < dr < 1):
            continue
        ku_p = f_kernel_up(dp)   # gen3 (t/b)
        ku_e = f_kernel_up(de)   # gen2 (c/s)
        ku_r = f_kernel_up(dr)   # gen1 (u/d)
        kd_p = f_kernel_down(dp)
        kd_e = f_kernel_down(de)
        kd_r = f_kernel_down(dr)

        if y_up_vec is None:
            mu, mc, mt = ku_r, ku_e, ku_p
            md, ms, mb = kd_r, kd_e, kd_p
        else:
            mu = y_up_vec[0]   * ku_r
            mc = y_up_vec[1]   * ku_e
            mt = y_up_vec[2]   * ku_p
            md = y_down_vec[0] * kd_r
            ms = y_down_vec[1] * kd_e
            mb = y_down_vec[2] * kd_p

        pr_mc_mu = mc / mu
        pr_mt_mc = mt / mc
        pr_ms_md = ms / md
        pr_mb_ms = mb / ms
        pr_mt_mu = mt / mu
        pr_mb_md = mb / md

        e_mc_mu = 100 * (pr_mc_mu - PDG_mc_mu) / PDG_mc_mu
        e_mt_mc = 100 * (pr_mt_mc - PDG_mt_mc) / PDG_mt_mc
        e_ms_md = 100 * (pr_ms_md - PDG_ms_md) / PDG_ms_md
        e_mb_ms = 100 * (pr_mb_ms - PDG_mb_ms) / PDG_mb_ms
        total = abs(e_mc_mu) + abs(e_mt_mc) + abs(e_ms_md) + abs(e_mb_ms)

        if total < best['err_total']:
            best = {
                'N': N, 'err_total': total,
                'mc_mu': pr_mc_mu, 'mt_mc': pr_mt_mc,
                'ms_md': pr_ms_md, 'mb_ms': pr_mb_ms,
                'mt_mu': pr_mt_mu, 'mb_md': pr_mb_md,
                'e_mc_mu': e_mc_mu, 'e_mt_mc': e_mt_mc,
                'e_ms_md': e_ms_md, 'e_mb_ms': e_mb_ms,
            }

        print(f"{N:>3} | {pr_mc_mu:>10.3e} {e_mc_mu:>+8.2f} | "
              f"{pr_mt_mc:>10.3e} {e_mt_mc:>+8.2f} | "
              f"{pr_ms_md:>10.3e} {e_ms_md:>+8.2f} | "
              f"{pr_mb_ms:>10.3e} {e_mb_ms:>+8.2f} | "
              f"{total:>9.2f}")
    print()
    if best['N'] is not None:
        print(f"  best N = {best['N']}  total |err| = {best['err_total']:.2f} %")
        print(f"  m_c/m_u = {best['mc_mu']:.3e}  (PDG {PDG_mc_mu:.2f}, err {best['e_mc_mu']:+.2f}%)")
        print(f"  m_t/m_c = {best['mt_mc']:.3e}  (PDG {PDG_mt_mc:.2f}, err {best['e_mt_mc']:+.2f}%)")
        print(f"  m_s/m_d = {best['ms_md']:.3e}  (PDG {PDG_ms_md:.2f}, err {best['e_ms_md']:+.2f}%)")
        print(f"  m_b/m_s = {best['mb_ms']:.3e}  (PDG {PDG_mb_ms:.2f}, err {best['e_mb_ms']:+.2f}%)")
        print(f"  m_t/m_u = {best['mt_mu']:.3e}  (PDG {PDG_mt_mu:.2f})")
        print(f"  m_b/m_d = {best['mb_md']:.3e}  (PDG {PDG_mb_md:.2f})")
    print()
    return best

# --------- Ansatz A: Pure Nashira quark kernels ---------
best_A = scan_ansatz(
    "A — Pure Nashira quark kernels (as in QuarkMassFromIrrationals.lean)",
    f_kernel_up   = nashira_up,
    f_kernel_down = nashira_down
)

# --------- Ansatz B: Yukawa × lepton Nashira kernel ---------
best_B = scan_ansatz(
    "B — Yukawa profile (1,3,9)/(1,2,5) × lepton Nashira kernel",
    f_kernel_up   = nashira_lepton,
    f_kernel_down = nashira_lepton,
    y_up_vec      = y_up,
    y_down_vec    = y_down
)

# --------- Ansatz C: Pure Yukawa baseline ---------
# No N-dependence; just print the fixed prediction
print("=" * 100)
print("Ansatz C — Pure Yukawa profile (baseline, no δ weighting)")
print("=" * 100)
print(f"  m_c/m_u = {y_up[1]/y_up[0]:.3f} (PDG {PDG_mc_mu:.2f}, err {100*(y_up[1]/y_up[0]-PDG_mc_mu)/PDG_mc_mu:+.2f}%)")
print(f"  m_t/m_c = {y_up[2]/y_up[1]:.3f} (PDG {PDG_mt_mc:.2f}, err {100*(y_up[2]/y_up[1]-PDG_mt_mc)/PDG_mt_mc:+.2f}%)")
print(f"  m_s/m_d = {y_down[1]/y_down[0]:.3f} (PDG {PDG_ms_md:.3f}, err {100*(y_down[1]/y_down[0]-PDG_ms_md)/PDG_ms_md:+.2f}%)")
print(f"  m_b/m_s = {y_down[2]/y_down[1]:.3f} (PDG {PDG_mb_ms:.2f}, err {100*(y_down[2]/y_down[1]-PDG_mb_ms)/PDG_mb_ms:+.2f}%)")
print()

print("=" * 100)
print("CROSS-ANSATZ VERDICT")
print("=" * 100)
print(f"  Ansatz A (pure Nashira quark kernels):    best N={best_A['N']}  total |err| = {best_A['err_total']:.2f}%")
print(f"  Ansatz B (Yukawa × lepton Nashira):       best N={best_B['N']}  total |err| = {best_B['err_total']:.2f}%")
print()
print("PDG uncertainty bounds on key ratios:")
print(f"  m_c/m_u within PDG (±{err_mc_mu:.0f}%)")
print(f"  m_t/m_c within PDG (±{err_mt_mc:.1f}%)")
print(f"  m_s/m_d within PDG (±{err_ms_md:.1f}%)")
print(f"  m_b/m_s within PDG (±{err_mb_ms:.1f}%)")
print()

def check_within_pdg(best, pdg_errs):
    ok_mc_mu = abs(best['e_mc_mu']) < pdg_errs['mc_mu']
    ok_mt_mc = abs(best['e_mt_mc']) < pdg_errs['mt_mc']
    ok_ms_md = abs(best['e_ms_md']) < pdg_errs['ms_md']
    ok_mb_ms = abs(best['e_mb_ms']) < pdg_errs['mb_ms']
    return ok_mc_mu, ok_mt_mc, ok_ms_md, ok_mb_ms

pdg_errs = {'mc_mu': err_mc_mu, 'mt_mc': err_mt_mc, 'ms_md': err_ms_md, 'mb_ms': err_mb_ms}
print("Ansatz A — within PDG uncertainty bands?")
o = check_within_pdg(best_A, pdg_errs)
print(f"  m_c/m_u: {'YES' if o[0] else 'NO'}   m_t/m_c: {'YES' if o[1] else 'NO'}   "
      f"m_s/m_d: {'YES' if o[2] else 'NO'}   m_b/m_s: {'YES' if o[3] else 'NO'}")
print()
print("Ansatz B — within PDG uncertainty bands?")
o = check_within_pdg(best_B, pdg_errs)
print(f"  m_c/m_u: {'YES' if o[0] else 'NO'}   m_t/m_c: {'YES' if o[1] else 'NO'}   "
      f"m_s/m_d: {'YES' if o[2] else 'NO'}   m_b/m_s: {'YES' if o[3] else 'NO'}")
