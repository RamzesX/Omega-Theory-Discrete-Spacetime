# SAGE BRIEFING — `alphaEM_substrate_at_MZ_one_loop_consistent`

**Author**: Zubeneschamali (grothendieck-sage), 2026-04-25 cycle-53 supplemental.
**Build state**: 3,941 GREEN, 1 paper-headline axiom (`Real.pi_transcendental`).

## Candidate

`alphaEM_substrate_at_MZ_one_loop_consistent`

## Priority

**HIGH** — Track-1 precision. `AlphaEMAtMZFit.lean` already lands the
substrate value at the anchor + 1σ window match, but consistency with the
1-loop QED β-function `α_EM(M_Z)⁻¹ ≈ 137.036 - (2/(3π))·log(M_Z²/m_e²) ≈ 127.95`
is currently asserted via constants only.  This briefing makes the running
**explicitly derived from substrate** by closing the gap:

> The substrate prediction `α_EM_substrate(M_Z)` equals the 1-loop running of
> the substrate-α_EM(0) anchor under the QED β-function with `n_f = 6`.

## Currently shipped (NOT this candidate)

- `OmegaTheory.Predictions.AlphaEMAtMZFit.alpha_EM_running_identity_substrate`
  — substrate-side identity, but treated as a fit identity (no β-function step).
- `OmegaTheory.Predictions.AlphaEMAtMZFit.Delta_alpha_substrate_pos`
  — Δα is positive (correct sign of 1-loop running).
- `OmegaTheory.Predictions.AlphaEMAtMZFit.alpha_EM_thomson_inv_eq`
  — α_EM(0) = 1/137.036 anchor.

## What this candidate adds

A **closed-form substrate β-function step**:

`Δα_EM_substrate_one_loop(N) = (2/(3π)) · sum_f Q_f² · log(M_Z²/m_f²)`

with `m_f` the substrate-derived fermion masses (from Yukawa-spectral-action
landings). The headline ties Δα_substrate to the predicted Δα via a
residual-bound `< 1%`.

## Target file

**NEW**: `OmegaTheory/Predictions/AlphaEMRunningOneLoop.lean`

Imports:
- `OmegaTheory.Predictions.AlphaEMAtMZFit`
- `OmegaTheory.Emergence.YukawaSpectralActionBridge` (for m_f from D_F)
- `OmegaTheory.Spacetime.Constants`
- `Mathlib.Analysis.SpecialFunctions.Log.Basic`

## Statement (Lean)

```lean
namespace OmegaTheory.Predictions.AlphaEMRunningOneLoop

/-- 1-loop QED β-function step Δα = (2/(3π)) · Σ Q²·log(M_Z²/m_f²). -/
noncomputable def deltaAlphaOneLoop_substrate (N : ℕ) : ℝ :=
  (2 / (3 * Real.pi)) * (sumOverChargedFermions_substrate N)

theorem deltaAlphaOneLoop_substrate_pos (N : ℕ) :
    0 < deltaAlphaOneLoop_substrate N := by
  sorry

/-- Substrate prediction matches 1-loop QED β-function within 1%. -/
theorem alphaEM_substrate_at_MZ_one_loop_consistent (N : ℕ) :
    |Delta_alpha_substrate N - deltaAlphaOneLoop_substrate N|
      ≤ 0.01 * deltaAlphaOneLoop_substrate N := by
  sorry

/-- Paper bundle: 4-conjunct headline. -/
theorem alphaEM_one_loop_paper_bundle (N : ℕ) :
    deltaAlphaOneLoop_substrate N > 0
    ∧ Delta_alpha_substrate N > 0
    ∧ |Delta_alpha_substrate N - deltaAlphaOneLoop_substrate N|
        ≤ 0.01 * deltaAlphaOneLoop_substrate N
    ∧ Delta_alpha_substrate N < 1 := by
  sorry
```

## Premise candidates (top-5)

1. `OmegaTheory.Predictions.AlphaEMAtMZFit.Delta_alpha_substrate_pos`
2. `OmegaTheory.Predictions.AlphaEMAtMZFit.Delta_alpha_substrate_lt_one`
3. `OmegaTheory.Emergence.YukawaSpectralActionBridge.fermionMassFromDFSpectrum_pos`
4. `OmegaTheory.Predictions.AlphaEMAtMZFit.alpha_EM_thomson_inv_eq`
5. `Mathlib.Analysis.SpecialFunctions.Log.Basic.Real.log_pos`

## Proof sketch

- **Step 1** (`deltaAlphaOneLoop_substrate_pos`): each log term is positive
  since M_Z² > m_f² for f ∈ {e, μ, τ, u, d, s, c, b}; sum of positives is
  positive; multiplication by `2/(3π)` preserves sign via `positivity`.
- **Step 2** (consistency): both quantities have the same anchor; the
  differential is bounded by the higher-loop correction `~α²·log` which is
  numerically `< 0.01·Δα` at M_Z. Use `norm_num` after definitional unfolding.
- **Step 3** (paper bundle): `And.intro` chain with `linarith`/`positivity`
  discharges.

## Off-limits files

- `AlphaEMAtMZFit.lean` (READ-ONLY)
- `YukawaSpectralActionBridge.lean` (READ-ONLY)
- All cycle-53 in-flight files: `pi_transcendental_audit*.lean`,
  `NeutronProtonMassSplittingTightened.lean`, `DESI_Y10*.lean`.

## Estimated complexity

**M** (medium) — 4-6 hours. All inputs landed; main risk is `norm_num`
discharging an 8-term log-sum.  May need explicit numerical bounds per term.

## Strategic note

Closes the cycle-44 frontier item "α_em(M_Z) substrate prediction".  Opens the
door to α_s(M_Z) one-loop running headline (Track-1 #2).
