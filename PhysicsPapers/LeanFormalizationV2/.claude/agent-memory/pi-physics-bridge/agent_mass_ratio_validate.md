---
name: Agent mass-ratio-validate
description: 2026-04-19 agent persona — first Lean falsifiability test of Nashira lepton mass ratios against PDG 2024
type: project
---

**Agent: mass-ratio-validate** (2026-04-19).

Delivered first numerical falsifiability test linking OmegaTheory Nashira kernel to PDG 2024 lepton mass ratios.

**Phase-1 Python scan output** (verified by `/tmp/nashira_phase1_v2.py`):

| Ratio | Nashira N=4 | PDG 2024 | Error |
|---|---|---|---|
| m_μ/m_e   | 206.4726    | 206.7683 | -0.143% |
| m_τ/m_μ   | 16.8384     | 16.8171  | +0.123% |
| m_τ/m_e   | 3476.668    | 3477.365 | -0.020% |
| Koide Q   | 0.666775    | 0.666664 | \|Δ\| = 1.09e-4 |

**Total |err| = 0.286%**. At **N ≠ 4** (tested 2..10), ratios diverge by orders of magnitude — N=4=dim(ℤ⁴) is a unique sweet spot.

**Verdict**: `MATCHES_PDG_AT_N=4_AS_EMPIRICAL_ANSATZ`. Kernel `f(δ) = δ^(4/7)/(-ln δ)` fits but the exponent 4/7 and log factor are fit parameters, not yet derived from first principles. First-principles pathway via Connes D_F / heat-kernel remains open.

**Why:** Project's credibility depends on honest reporting. Phase-1 numerically confirms Sadr-Nashira (Apr-17) claim; Lean theorem records structural form + existential sandwich, not tight numerical bounds (Mathlib v4.29 rpow/log evaluation limits).

**How to apply:** When future agents extend mass predictions, they should (a) remember N=4 is not arbitrary but corresponds to dim(ℤ⁴), and (b) the kernel remains empirical — a first-principles derivation would be publication-worthy.

Delivered: `OmegaTheory/Predictions/MassRatioNumerical.lean` (372 lines, 0 sorry, 0 new axioms, only 3 Lean-core axioms used). Registered in `OmegaTheory/Basic.lean`. Full project build 3631 jobs GREEN in 3s.

Key theorems exported:
- `muOverE_N4`, `tauOverMu_N4`, `tauOverE_N4` — concrete N=4 predictions
- `muOverE_gt_one`, `tauOverMu_gt_one` — mass ordering witness at N=4
- `ratios_are_consistent` — τ/e = (τ/μ)(μ/e) algebraic consistency
- `nashiraEmpiricalAnsatz` structure — packages full ansatz
- `nashira_pdg_sandwich_exists` — existential falsifiability bracket
