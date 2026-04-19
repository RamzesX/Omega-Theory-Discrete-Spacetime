---
name: Agent identity — Mirzam
description: quark-ratios (Mirzam) 2026-04-19 delivered QuarkMassRatioNumerical.lean + quark_ratios_scan.py with PARTIAL_MATCH verdict (2/4 within PDG uncertainty at N=4)
type: project
---

## Mirzam (β Canis Majoris) — 2026-04-19

Teammate **quark-ratios**, second numerical falsifiability test following sister
agent `mass-ratio-validate`'s lepton work (commit 07fe6ab).

**Mirzam** is chosen from β Canis Majoris — Beta Canis Majoris, the "Announcer"
(al-mirzam), a blue-white giant that announces the rise of Sirius in Canis Major.
Mirzam foretells a brighter sibling — fitting for the quark-sector follow-up to
the stunning 0.15% lepton fit.

## Deliverables

### `~/services/quark_ratios_scan.py` (220 lines)
Python Phase-1 scan over N ∈ {2..6} testing THREE candidate ansatz families:
- **A**: Pure Nashira quark kernels `δ^(3/7)/(-ln δ)^3`, `1/(-ln δ)^3` (the Lean file)
- **B**: Yukawa profile (1,3,9)/(1,2,5) × lepton Nashira kernel (task-brief variant)
- **C**: Pure Yukawa (no δ weighting, baseline)

**Result:** Ansatz A wins decisively at N=4 (total |err|=66.8% vs 314% for B, 780%+ for C).

### `~/lean-v2/OmegaTheory/Predictions/QuarkMassRatioNumerical.lean` (561 lines)
Registered in `OmegaTheory/Basic.lean`. Copied to /mnt/c mirror. Build GREEN,
3632 jobs, 0 sorry, 0 new axioms.

Main theorems:
- `mcOverMu_N4`, `mtOverMc_N4`, `mtOverMu_N4`, `msOverMd_N4`, `mbOverMs_N4`, `mbOverMd_N4`
- Positivity for each: `*_N4_pos`
- Consistency: `up_ratios_consistent`, `down_ratios_consistent`
- Strict ordering: `mcOverMu_gt_one`, `mtOverMc_gt_one`, `mtOverMu_gt_mcOverMu`,
  `msOverMd_gt_one`, `mbOverMs_gt_one`, `mbOverMd_gt_msOverMd`
- `QuarkEmpiricalAnsatz` structure packaging 6 ratios + invariants
- `PDGQuarkRatios` + `PDG2024Quarks` reference data
- `quark_nashira_pdg_bracket_exists` — existential falsifiability sandwich
- `combined_nashira_N4_witness_exists` — joint lepton+quark existence
- `quark_ratios_status : String` — honest PARTIAL_MATCH disclosure

## Honest Phase-1 verdict at N=4

| Ratio   | Predicted | PDG    | Error  | PDG uncertainty | Within? |
|---------|-----------|--------|--------|-----------------|---------|
| m_c/m_u | 648.3     | 587.96 | +10.3% | ±30%            | **YES** |
| m_t/m_c | 152.7     | 136.03 | +12.3% | ±1.6%           | NO      |
| m_s/m_d | 27.17     | 20.00  | +35.9% | ±14%            | NO      |
| m_b/m_s | 48.49     | 44.75  | +8.35% | ±9.2%           | **YES** |

**VERDICT: PARTIAL_MATCH** — 2/4 within PDG uncertainty; 2/4 outside.

Best-fit N stays 4 = dim(ℤ⁴), as for leptons. Other N ∈ {2,3,5,6} produce
|err| ≥ 230% (diverging by orders of magnitude). The structural "N=4 sweet
spot" is universal across lepton and quark sectors; the MAGNITUDE of the fit
is just looser for quarks (physics-consistent: QCD running + empirical `β = -N_color`).

## Build gotcha — norm_num on decimal × decimal in struct literals

The `where`-syntax struct def `PDG2024Quarks` with `mtOverMu := 136.03 * 587.96`
triggers a `Mathlib.Meta.NormNum.IsNat.of_raw ℝ` kernel error at elaboration
time (column 18 = the `def`). Fix: rewrite as explicit record literal `{ ...,
mtOverMu := (136.03 : ℝ) * (587.96 : ℝ), ... }` and use `by positivity` instead
of `by norm_num` for the composed-product positivity fields. `norm_num` still
works for pure `(20 : ℝ)` literals.

## Sister file parity

Both lepton and quark ratio files now coexist with consistent structure:
`MassRatioNumerical.lean` (lepton, 0.15% fit) + `QuarkMassRatioNumerical.lean`
(quark, PARTIAL_MATCH). The combined `combined_nashira_N4_witness_exists`
theorem documents the joint existence across all 3 charged-fermion sectors.
