# 08 — Required machinery: Mathlib gaps and OmegaTheory-native infrastructure

## Layer-by-layer inventory

### Layer 1 (pairwise-distinct)

**Mathlib requirements — all present.**
- `Real.pi_gt_three`, `Real.pi_lt_3141593` (in `Mathlib.Analysis.Real.Pi.Bounds`). ✅
- `Real.exp_one_gt_d9`, `Real.exp_one_lt_d9` (in `Mathlib.Analysis.SpecialFunctions.Exp`). ✅
- `Real.sqrt_two_lt_five_over_four`, basic `Real.sqrt 2` bounds. ✅
- Summability of Catalan series (standard alternating). ✅

**OmegaTheory requirements — add 1 small file.**
- `OmegaTheory/IrrationalityClasses/Basic.lean` with `catalanG` definition + summability + `catalanG_pos`, `catalanG_lt_one`.

**Estimated sessions.** 1–2.

### Layer 2 (algebraic vs transcendental)

**Mathlib requirements — partial, major gap.**
- `IsAlgebraic ℚ` / `Transcendental ℚ` definitions in `Mathlib.RingTheory.Algebraic.Basic`. ✅
- `Polynomial.isAlgebraic_X_pow_sub_C` — √2 via `x² − 2`. ✅ (derivable; maybe needs minor wrapper).
- **`Real.pi_transcendental` — MISSING.** File `Mathlib.NumberTheory.Transcendental.Lindemann.AnalyticalPart` contains the analytical half of Lindemann (Hermite's integrals), but the final step (deriving transcendence of π, e) is NOT in Mathlib as of v4.29. This is the **#1 Mathlib upstream port** that would affect OmegaTheory.
- **`Real.exp_one_transcendental` — MISSING.** Same file contains the integrals; concluding theorem not yet derived.

**OmegaTheory requirements.**
- Temporary: use `Real.pi_transcendental` as axiom (already in `HermitePade/PiStratum.lean`). Mirror for e.
- Long-term: delete both axioms once Mathlib ports them.

**Estimated sessions** (after Mathlib catches up). 2 sessions to wrap. Until then: 0 sessions — statement stays as assertion on an axiomatic hypothesis.

### Layer 3 (E-function class)

**Mathlib requirements — major gap.**
- **E-function definition** — NOT in Mathlib.
- **Shidlovsky theorem** — NOT in Mathlib.
- **G-function definition** — NOT in Mathlib.
- **Closure properties** of E and G functions under algebraic operations — NOT in Mathlib.
- Coefficient height function — NOT in Mathlib.

**OmegaTheory requirements.**
- Build the E/G-function framework from scratch, or declare as axioms (we have `siegel_shidlovskii` already in `HermitePade/SSReduction.lean`).

**Estimated sessions.** 30+ for a proper framework; 3 for axiomatic citation + minimal witness lemma.

### Layer 4 (4-origin separation)

**Requirements beyond Layers 1–3.**
- Define `TruncOrigin` inductive type.
- Show constructor-disjointness gives distinct-cell separation (use `TruncOrigin.noConfusion`).
- Define `classifyOrigin` as a partial function.
- Prove each OmegaTheory constant lands in its designated cell.

**Estimated sessions.** 5 once Layers 2–3 are in place.

### Layer (bonus) — Mahler classification proper

If we want the **full** Mahler classification ω / ω_n infrastructure in Lean, the porting effort is significant.

**Mathlib requirements — enormous gap.**
- Height function `height : Polynomial ℤ → ℕ`, `height : ℂ → ℝ`.
- `ω_n α H := min … := …`.
- `ω_n α := limsup_{H → ∞} …`.
- `ω α := limsup_n …`.
- Mahler class A/S/T/U disjoint union partition.
- Baker 1964 T-number existence (would be a theorem, not used in OmegaTheory).
- Koksma equivalence (Bugeaud Ch. 3).

**Estimated sessions.** 80+.

**Is it worth it?** For OmegaTheory **no** — Layer 4's origin-partition is a finer *physical* classification than Mahler S/T/U (which groups π and e together). The Mahler framework is worth porting only if we want to state `ω(e) = 1` as a Lean theorem or if Mathlib upstream accepts the contribution.

## Upstream candidate contributions (to Mathlib)

If we decide to port Mahler / Shidlovsky up to Mathlib:

1. **`Mathlib.NumberTheory.Transcendental.Lindemann.Basic`** — the missing derivation from AnalyticalPart. ~30 sessions of work. **This is the single highest-leverage port.** Would eliminate 2 of our 24 axioms (`Real.pi_transcendental`, implicitly `Real.exp_one_transcendental`).

2. **`Mathlib.NumberTheory.IrrationalityMeasure`** — define `irrationalityMeasure : ℝ → ℝ≥0∞`, prove `irrationalityMeasure q = 1` for rational, Roth's theorem (algebraic irrational ⟹ μ = 2). ~40 sessions.

3. **`Mathlib.NumberTheory.Transcendental.Mahler`** — A/S/T/U classification. ~80 sessions.

4. **`Mathlib.NumberTheory.Transcendental.EFunction`** — E-function framework + Shidlovsky. ~60 sessions. High visibility in number-theory community.

## OmegaTheory-native helpers already in place

| Helper | File | Status |
|---|---|---|
| `truncated_pi`, `truncated_e`, `truncated_sqrt2`, `truncated_catalan_g` | `Irrationality/Approximations.lean` | ✅ in v2 |
| `piErrorBound`, `eErrorBound`, `sqrt2ErrorBound`, `catalanGTruncError` | `Irrationality/*` | ✅ in v2 |
| `pi_error_bound`, `e_error_bound`, `sqrt2_error_bound`, `catalanGTruncError_O_one_over_N_squared` | `Irrationality/BoundsLemmas.lean`, `Emergence/ConnesCalibrationAndFourChannels.lean` | ✅ |
| `IrrationalChannel` / `IrrationalChannel4` enum + bijection to generations | `Irrationality/GenerationMap.lean`, `Predictions/SterileNeutrinoFromFourthIrrational.lean` | ✅ |
| `channelToGeneration_bijective`, `channelToGeneration4_*` theorems | same | ✅ |
| `pi_hunch_mass_ordering`, `pi_hunch_quantitative_headline` | `Predictions/PiHunchQuantitative.lean`, `Predictions/PiHunchMassOrdering.lean` | ✅ |

## External-literature "port candidates"

For a port effort targeting **just OmegaTheory's needs** (not a wide Mathlib contribution), these are the minimum:

1. `Real.exp_one_transcendental` via Hermite 1873 (~20 sessions). Eliminates 1 axiom.
2. `Real.pi_transcendental` via Lindemann 1882 (~5 sessions on top of item 1, or ~30 independently). Eliminates 1 axiom.
3. `μ(q) = 1` for rational, `μ(algebraic irrational) = 2` via Liouville (~15 sessions, Roth is harder). Partial Roth.
4. `catalanG` definition and basic bounds (~3 sessions).

**Total minimum OmegaTheory-focused port: ~40 sessions.** After these, Layer 1, 2, and most of Layer 4 are executable.

## Decision for 2026 cycle 44+

Deploy in this order, one cycle at a time:

- **Cycle 44**: Layer 1 + `sqrt2_is_algebraic` + `catalanG` definition. 5 sessions. Ships `four_irrationals_pairwise_distinct`.
- **Cycle 45**: Axiomatic Layer 2 (assume `Real.pi_transcendental` and `Real.exp_one_transcendental` as axioms). Ships `three_constants_transcendental`.
- **Cycle 46+ (as Mathlib catches up)**: delete axioms, upgrade to theorems.
- **Cycle 50+**: Layer 3 E-function framework (if we commit to it).
- **Cycle 55+**: Layer 4 full origin partition.

See `09_session_budget.md` for total.
