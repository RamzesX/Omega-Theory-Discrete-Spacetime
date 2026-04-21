# 00 — Motivation: Why irrationality classes matter to OmegaTheory

> **Goal statement.** Create the Omega algebra that completely describes physics — or as much as we can formally prove. Irrationality classes are one of the puzzle pieces. This memo explains *which* piece.

## The 4-channel / 4-generation partition

OmegaTheory derives Standard-Model structure from the truncation error `δ_comp(N) = ℓ_P · 4/(2N+3)` of the Leibniz series for π (see `Irrationality/Uncertainty.lean`, `Probe/PiAndOmegaStructure.lean#L100` `irrationality_implies_quantum_uncertainty`). The cycle-24–43 arc extended this to four distinct constants, each paired with a generation of Standard-Model matter:

| Constant | Truncation rate | SM channel | Primary Lean file |
|---|---|---|---|
| π | `O(1/N)` (Leibniz) | heavy: top, tau, charm-top bridge | `Predictions/PiHunchQuantitative.lean` |
| e | `O(1/N!)` (Taylor) | middle: muon, charm, bottom-middle | `Emergence/LeptonMassFromIrrationals.lean` |
| √2 | `O(2^(−2^N))` (Newton) | light: electron, up, down | `Emergence/ConnesDFYukawaMass.lean` |
| Catalan G | `O(1/(2N+1)²)` | **sterile ν / DM** (cycle 27 Hydor, cycle 43 Polaris) | `Predictions/SterileNeutrinoFromFourthIrrational.lean` |

Mapping to 4 Connes-DF eigenvalues: `OmegaTheory.Emergence.ConnesDFYukawaMass.DFEigenvalueSpectrum` carries `lambda_pi`, `lambda_e`, `lambda_sqrt2`, `lambda_catalan`. The bijection to 4 generations is `channelToGeneration_bijective` (`Irrationality/GenerationMap.lean`) extended by `PMNS_fourth_column_from_catalan_G` (`Emergence/ConnesCalibrationAndFourChannels.lean`).

## Why not just four *numerical* δ(N)?

Two δ(N) can share an irrationality class even if their asymptotics differ. Example: π and ζ(3) both have μ ≤ finite bound (Salikhov 2008: μ(π) ≤ 7.6063; Rhin 1996: μ(ζ(3)) ≤ 5.5138). They are both **Mahler S-numbers** (strongly conjectured but not fully proved). A physics theory that only leans on "different δ" could be accused of merely re-scaling the same scalar — four knobs of a single knob.

OmegaTheory's claim is stronger: **the four substrates inhabit four qualitatively different layers of classical transcendence theory**. That is what the cycle-24–43 arc assumes. This folder's job is to make that assumption *explicit*, *cited*, and either *proved* or *flagged as conjectural* — per our hard rule "narrower true theorem > false dressed-up claim".

## The classical hierarchy (preview for §01)

From coarsest to finest:

1. **Rational vs irrational.** `Irrational` in Mathlib. Fails for √2 (√2 IS irrational, but it's ALGEBRAIC irrational, which classifies it at a deeper level; rational/irrational alone is too coarse).
2. **Liouville vs non-Liouville.** `Mathlib.NumberTheory.Transcendental.Liouville` has the full ladder. π, e, G are all non-Liouville. √2, being algebraic, is non-Liouville by Roth.
3. **Algebraic vs transcendental.** Lindemann 1882 settles π. Hermite 1873 settles e. √2 is algebraic. Catalan G: **OPEN**.
4. **Roth exponent.** Every algebraic irrational has exponent exactly 2 (Thue–Siegel–Roth 1955). So √2 is at the Roth floor.
5. **Mahler classification {A, S, T, U}.** Partitions all complex numbers. A = algebraic, S = "typical transcendental" (like e, almost every real), T = intermediate rarity, U = "Liouville-like". Baker 1964 gave rare explicit T-examples. See Bugeaud's *Approximation by algebraic numbers* (2004) chapter 3.
6. **Shidlovsky E-function class.** Siegel–Shidlovsky 1956 algebraic-independence for solutions of linear ODEs with polynomial coefficients satisfying arithmetic conditions. e lives here. π does **not** live in the E-function class (it's the value of `arctan(1)·4`, the underlying function is a G-function — a different world).
7. **Nesterenko algebraic-independence triple** `(π, e^π, Γ(1/4))` (1996). Gives transcendence degree 3 — the deepest known elementary bound.
8. **Zudilin modular / Beukers–Rivoal–Zudilin** linear forms in odd zeta / Dirichlet β. Gives that infinitely many β(2n) are irrational, and at least one of β(2), β(4), …, β(14) is irrational. Catalan G = β(2) waits here.

Layers 1–4 are provable today in Lean (modulo Mathlib porting of a few theorems we list in §08). Layer 5 (Mahler classification) is **not in Mathlib** and is the biggest lift. Layer 6 (E-function) has partial scaffolding (`Mathlib.NumberTheory.Transcendental.Lindemann.AnalyticalPart`, see PiStratum.lean comment). Layers 7 and 8 are axioms in V2 today (`Nesterenko_1996`, `siegel_shidlovskii`).

## Relation to the "Pi Hunch" central thesis

`CLAUDE.md` has the convention: hardest-to-compute = largest residual error = heaviest channel. This folder sits *above* that ordering: the ordering is ordinal (there is a heaviest), and this folder argues the four slots are **incomparable** at the level of classification — each of π, e, √2, G belongs to a different cell of the Mahler/Shidlovsky/Nesterenko partition.

## Goal statement, reproduced for tracking

> "**Create the Omega algebra that completely describes physics — or as much as we can prove.**
> Irrationality classes are one of the puzzle pieces; the 4-class separation theorem is the specific deliverable. We collect the puzzle pieces, one provable sub-theorem at a time."

This framing is shared across `OmegaTheoryAlgebra/README.md`, `IMPORTANT.md`, and the root `README.md`. See `11_master_plan_skeleton.md` for the full puzzle view.

## Amendments
- 2026-04-21 (Rasalas): first pass, ≤ 2 pages per coordinator brief.
