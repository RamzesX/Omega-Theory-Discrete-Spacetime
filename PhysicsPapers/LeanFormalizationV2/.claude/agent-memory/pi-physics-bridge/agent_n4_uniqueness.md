---
name: Agent identity — n4-uniqueness
description: Shape-B structural uniqueness theorem for Nashira N=4 vs PDG lepton ratios, 2026-04-19
type: user
---

**Agent name**: n4-uniqueness (2026-04-19 mission).

Built `OmegaTheory/Predictions/LeptonN4Uniqueness.lean` (489 L) as a Shape-B uniqueness theorem (per the `feedback_mathlib_rpow_log_limits` pattern).

**Main theorem**:
```
lepton_PDG_uniquely_at_N_eq_4
    (h_N4 : phase1_witness_N4)
    (h_fail_ge_5 : phase1_witness_failure_N_ge_5)
    (h_fail_lt_4 : phase1_witness_failure_N_lt_4) :
    ∃! N : ℕ, 2 ≤ N ∧ NashiraPDGConsistency N 0.5
```

**Unconditional structural content** (no Python input needed):
- `sqrt2_error_val_strict_mono_decr`: `δ_√2(N+1) < δ_√2(N)` for every N (super-exp decay)
- `sqrt2_error_val_5_lt_4`: `δ_√2(5) < δ_√2(4)` via exact `1/2^32 < 1/2^16`
- `sqrt2_error_val_strict_lt_at_4`: `δ_√2(N) < δ_√2(4)` for N ≥ 5
- `nashira_denominator_strict_lt`: `nashiraKernel (δ_√2(5)) < nashiraKernel (δ_√2(4))`
- `nashiraN4_structural_exists`: `∃ a : NashiraEmpiricalAnsatz, a.muOverE = muOverE_at 4`
- `ratios_consistent_at`: `τ/e = (τ/μ)(μ/e)` for all N ≥ 2

**External-witness uniqueness**:
- `phase1_witness_N4` / `phase1_witness_failure_N_ge_5` / `phase1_witness_failure_N_lt_4` are Prop-level hypotheses fed by Python Phase-1 `_phase1_nashira_pdg_scan.py`
- `lepton_PDG_uniquely_at_N_eq_4` takes them as premises and delivers `∃!`

**Axioms used** (all Lean core, no project axioms):
- propext
- Classical.choice
- Quot.sound

**Why Shape B (not tight numerical bounds)**: Mathlib v4.29 lacks a `norm_num` extension for `Real.rpow` on arbitrary rationals. Proving `|muOverE_at 5 − 206.77| > 0.5` requires evaluating `(1/2^32)^(4/7) / log(1/2^32)` with sub-0.5 tolerance, currently impossible without a Taylor-series numerical harness. The shape-B formulation captures the full mathematical content except the final tight-epsilon check, which is delegated to external Phase-1 Python at double precision.
