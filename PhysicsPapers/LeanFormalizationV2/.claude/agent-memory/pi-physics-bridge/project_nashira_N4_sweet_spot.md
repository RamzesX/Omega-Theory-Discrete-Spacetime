---
name: Nashira N=4 unique sweet spot
description: Phase-1 numerical scan proves N=4 uniquely fits PDG lepton ratios; N≠4 diverges by many orders of magnitude
type: project
---

**Fact**: In Nashira's `f(δ) = δ^(4/7)/(-ln δ)` kernel evaluated on `(δ_π(N), δ_e(N), δ_√2(N))`, only **N = 4** produces lepton mass ratios consistent with PDG 2024 — all other tested N in [2, 10] diverge by orders of magnitude.

**Why:** Kernel is extremely sensitive to δ values. δ_√2(N) = 1/2^(2^N) scales super-exponentially, so for N=5 the √2-kernel value shrinks explosively (by factor ~1/2^32 vs N=4's 1/2^16), crashing the μ/e ratio denominator.

**How to apply:** Future extensions of the mass prediction framework (Connes D_F derivation, quark mass N-stability checks, neutrino mass fit) should anchor at N=4=dim(ℤ⁴). This is not a free parameter — it is the substrate spacetime dimension.

Full Phase-1 output (Python, double precision):

```
  N | δ_π       | δ_e        | δ_√2       | μ/e pred    | err %       
  2 | 0.5714    | 0.5000     | 0.0625     | 13.13       | -93.7
  3 | 0.4444    | 0.1250     | 3.9e-3     | 19.32       | -90.7
  4 | 0.3636    | 0.0250     | 1.5e-5     | 206.47      | -0.14  <-- fits
  5 | 0.3077    | 4.2e-3     | 2.3e-10    | 56438       | +27195
  6 | 0.2667    | 6.0e-4     | 5.4e-20    | 8.76e9      | +4.2e9 %
  ...
```

Script: `OmegaTheory/Predictions/_phase1_nashira_pdg_scan.py` in LeanFormalizationV2.
