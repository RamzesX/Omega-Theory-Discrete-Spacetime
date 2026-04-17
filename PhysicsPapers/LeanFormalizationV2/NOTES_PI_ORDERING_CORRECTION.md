# NOTES — Pi Hunch ordering correction (2026-04-17)

**Context**: Merope's `NOTES_3GEN_REFINEMENT.md` (2026-04-17) proposed inverting the Pi Hunch convention from `π=heavy, √2=light` to `√2=heavy, π=light` via Connes' spectral formula `m² ∝ f₂·Λ²` with `Λ = 1/δ_comp`.

## User directive

> "Hardest doesn't mean least errors."

π is hardest to compute precisely **BECAUSE** it has the largest residual error `δ_comp(N)` at fixed iteration budget `N`. This is a tautology of the Leibniz series:

- `|π − truncated_π(N)| ≤ 4/(2N+3)` — algebraic `O(1/N)`, slowest convergence, **LARGEST δ**
- `|e − truncated_e(N)| ≤ 3/(N+1)!` — factorial `O(1/N!)`, middle, middle δ
- `|√2 − truncated_√2(N)| ≤ 1/2^(2^N)` — super-exp, fastest, **SMALLEST δ**

"Slowest convergence" = "biggest residual per step" = "most errors". NOT "least errors".

## Category error in Merope's inversion

Merope's §4 uses Connes' identification:
```
mass² ∝ f₂ · Λ²    with    Λ = 1/δ_comp(N)
```

This conflates two distinct objects:

| Connes' `Λ` | OmegaTheory `δ_comp` |
|---|---|
| UV spectral cutoff for gravity action | Substrate computational uncertainty per tick |
| Inverse of shortest wavelength resolvable | Error in approximating irrationals |
| Appears in `f₂·Λ²` (gravitational coupling) | Appears in extended Heisenberg bound |

The `Λ = 1/δ_comp` identification comes from `SpectralActionExpansion.lean` (`spectralAction_cutoff_is_substrate_inverse`) and is physically sensible: the substrate can't resolve below its own computational error, so `Λ = 1/δ` is a natural cutoff.

**But**: the `f₂·Λ²` term in Connes' spectral action is the **gravity action strength**, not the fermion mass. Fermion masses in Chamseddine-Connes come from Yukawa × Higgs VEV, where the Yukawas are the D_F eigenvalues — a separate object.

Using `Λ = 1/δ` to derive fermion mass scaling from the gravity coupling term is a category error.

## What's physically right

Substrate thesis:
1. Each computational tick has error `δ_comp(N) = ℓ_P · 4/(2N+3)` (dominated by π)
2. Error = delay in information propagation
3. More delay per tick = more "resistance to move at c" = more mass
4. Therefore `m ∝ δ_comp_per_channel_i` (possibly with non-linear correction)
5. **π (largest δ) → heaviest; √2 (smallest δ) → lightest**

This is Acamar's original F1 hypothesis, and it matches the CLAUDE.md convention.

## Ratio-fit failure resolution

Acamar's ratio test failed for raw `m ∝ δ`:
- lepton ratios 1 : 207 : 3477
- δ ratios (π:e:√2 at physical N) differ by many orders of magnitude

This does NOT mean the ordering is inverted. It means the mapping is non-linear. Candidates:
- `m ∝ δ^α` for some `α ∈ (0, 1)` compresses the ratio
- `m = a + b·δ` with additive offset compresses
- `m ∝ ln(a + b·δ)` (smooth log, not inverse-log)
- Connes-weighted `m ∝ f_Y(δ)` with a regime-dependent Yukawa kernel `f_Y`

All four preserve the π=heavy ordering.

## Directive for future agents

**When an agent proposes inverting `π=heavy, √2=light`** via any `Λ = 1/δ`-flavored argument:
1. Check the substitution chain — is Λ the gravity cutoff or the fermion mass scale?
2. If it's gravity cutoff, the argument does NOT apply to fermion masses.
3. Fermion Yukawas = D_F eigenvalues, a separate object from the spectral action cutoff.

**The CLAUDE.md convention stands**: `π → heavy, e → middle, √2 → light`.

**Open problem**: find `m = f(δ)` that preserves ordering AND fits observed ratios. This is the right next step for the mass-derivation pathway — NOT inverting the ordering.

## Relevant Lean files for downstream formalization

- `OmegaTheory/Irrationality/Uncertainty.lean` — `computationalUncertainty`, `dominantErrorBound`
- `OmegaTheory/Irrationality/Approximations.lean` — `pi_error_val`, `e_error_val`, `sqrt2_error_val`
- `OmegaTheory/Emergence/SpectralActionExpansion.lean` — `Λ = 1/δ_comp` bridge
- `OmegaTheory/Emergence/YukawaMatrix.lean` — Yukawa framework (currently placeholder)

Future formalization target `LogarithmicGenerationMap.lean` must respect `π=heavy` ordering.

## Cross-references

- `NOTES_DF_EIGENVALUES.md` (Altair, 2026-04-17) — D_F derivation pathways
- `NOTES_3GEN_REFINEMENT.md` (Merope, 2026-04-17) — inverted claim, this note refutes the inversion
- Memory: `feedback_hardest_most_errors.md`
- Neo4j node: `PiHunchOrderingCorrection` under `OmegaTheoryV2`
