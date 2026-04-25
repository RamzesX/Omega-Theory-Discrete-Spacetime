# RESEARCH — Mathlib v4.29.0 Lindemann–Weierstrass survey

**Author**: Andromeda (lean-proof-wizard), 2026-04-25 cycle 56 (Leo) Phase B.
**Briefing**: `SAGE_BRIEFING_lindemann_weierstrass_mathlib_port_roadmap_2026-04-25.md`
(Phecda, cycle 53 Phase A).
**Goal**: identify Mathlib content already shipped, refine the Layer-A/B/C/D
roadmap with concrete Mathlib hooks, and port the lightest preliminaries that
are immediately usable.

## TL;DR

The cycle-53 briefing was conservative. **Mathlib v4.29.0 already ships the
heavy "analytical part" of Lindemann–Weierstrass** in
`Mathlib.NumberTheory.Transcendental.Lindemann.AnalyticalPart` (Yuyang Zhao,
2022), including the Hermite construction `exp_polynomial_approx`. What
remains is essentially the **algebraic Galois argument** — Layer B in the
briefing — the bulk of which is standard once the analytical part is
available.

The briefing's Bhavik-Mehta-PR-#19876 estimate ("60% ported, stalled on
`complex_lindemann_lemma_4`") is consistent with this finding. We have the
analytical 60%; we still need the arithmetic 40%.

## Mathlib inventory (verified 2026-04-25 against `~/lean-v2/.lake`)

### Already shipped (free for OmegaTheory)

| Mathlib name | Module | Status |
|---|---|---|
| `irrational_pi` | `Analysis.Real.Pi.Irrational` | full proof, Niven 1947 |
| `Liouville.transcendental` | `NumberTheory.Transcendental.Liouville.Basic` | `Liouville x → Transcendental ℤ x` |
| `Liouville.irrational` | `NumberTheory.Transcendental.Liouville.Basic` | full |
| `Transcendental.irrational` | `NumberTheory.Real.Irrational` | `Transcendental ℚ r → Irrational r` |
| `Transcendental` | `RingTheory.Algebraic.Defs` | the typeclass itself |
| `Transcendental.aeval` / `.pow` / `.infinite` / `.of_aeval` / `.restrictScalars` / `.of_tower_top` | `RingTheory.Algebraic.Basic` | closure ops |
| `Polynomial.taylor` (linear map) | `Algebra.Polynomial.Taylor` | with `taylor_X_pow`, `taylor_apply`, `taylor_coeff` |
| `Polynomial.sumIDeriv` | `Algebra.Polynomial.SumIteratedDerivative` | with arithmetic lemmas, `aeval_sumIDeriv_of_pos`, `eval_sumIDeriv_of_pos` |
| `Polynomial.hermite` (physicists' Hermite poly) | `RingTheory.Polynomial.Hermite.Basic` + `.Gaussian` | full ladder |
| `LindemannWeierstrass.hasDerivAt_cexp_mul_sumIDeriv` | `…/Lindemann/AnalyticalPart` | derivative identity for the Lindemann integrand |
| `LindemannWeierstrass.integral_exp_mul_eval` | same | the auxiliary integral identity (Hermite's `P` function) |
| `LindemannWeierstrass.exp_polynomial_approx` | same | **the technical core** — for any `f : ℤ[X]` with `f.eval 0 ≠ 0` and large prime `p`, builds `nₚ ∈ ℤ`, `gₚ ∈ ℤ[X]` with `‖nₚ • exp r − p • aeval r gₚ‖ ≤ cᵖ / (p−1)!` for `r ∈ f.aroots ℂ` |

### NOT shipped (need port, or alternate route)

| Goal | Status | Difficulty |
|---|---|---|
| `Real.pi_transcendental : Transcendental ℚ Real.pi` | absent | Layer C+D, ~50 lines |
| `Complex.e_transcendental` | absent | should follow from `exp_polynomial_approx` at `f = X − 1`, ~30 lines |
| `LindemannWeierstrass.main` (full multi-α statement) | absent | Layer B+C, ~150 lines (Galois argument) |
| `LindemannWeierstrass.weierstrass` (corollary form) | absent | Layer C, ~10 lines once main lands |

## Refined Layer-by-Layer plan (post-Mathlib-survey)

### Layer A — Hermite preliminaries — **mostly already in Mathlib**

The briefing's three sub-lemmas (`hermite_polynomial_F_Wgen`,
`hermite_F_integral_bound`, `hermite_F_arithmetic_lemma`) are realised by
`exp_polynomial_approx` and its supporting `P_le_aux`, `P_le`,
`P_eq_integral_exp_mul_eval`, `aeval_sumIDeriv_of_pos`,
`eval_sumIDeriv_of_pos`. Wizard cycle-54 should NOT re-derive these — they
should import them and write the **bridge** lemma matching V2's
`Real.pi_transcendental` axiom signature.

### Layer B — Lindemann sub-claims

- **B.1** (`∑ cᵢ exp(αᵢ) ≠ 0` for distinct algebraic αᵢ) — STILL needs the
  symmetric-functions / Galois conjugate argument. ~50 lines.
- **B.2** (iterated derivative gives `(p−1)!` divisibility) — substantially
  covered by `eval_sumIDeriv_of_pos` (which provides exactly this divisibility
  structure) + `exp_polynomial_approx`. ~10 lines bridge.
- **B.3** (large prime contradiction) — STILL needs explicit prime
  cofiniteness argument over conjugate sets. ~30 lines.

### Layer C — Lindemann main + e/π corollaries — **shrinkable to one cycle**

Given Layer A is mostly free, Layers C.2 (`e` transcendental from `α=1`) and
C.3 (`π` transcendental from `α=iπ` and `e^{iπ}=−1`) can be done in **one
cycle** if Layer B's symmetric-function step is in Mathlib (it likely is, see
below).

### Layer D — substrate integration

Unchanged. ~5 lines in `PiStratum.lean`, replace `axiom` with `theorem`.

## Symmetric functions check

The Galois-conjugate step in Layer B uses `Polynomial.aroots`,
`Polynomial.symmetric_functions`, `MvPolynomial.esymm`. Quick check:

- `Polynomial.aroots` — present in `RingTheory.RootsOfUnity` and elsewhere
- `MvPolynomial.esymm` — present in `RingTheory.Polynomial.Symmetric.Defs`
- `Polynomial.eval_esymm_eq_sum_aroots` — partial, may need a corollary

This makes Layer B feasible in one cycle if the wizard is patient.

## Recommended cycle reschedule

The cycle-53 briefing said 4 cycles (54–57). With the AnalyticalPart
finding, this reduces to **2 cycles**:

- **Cycle 57** (Virgo): port Layer B (Galois conjugate + symm-func step) →
  build `Lindemann.main_for_one_alpha : Transcendental ℚ x` whenever
  `x : ℂ` satisfies certain conditions.  ~80 lines.
- **Cycle 58** (Libra): instantiate at `α = iπ` and `α = 1` to derive both
  `Real.pi_transcendental` and `Real.e_transcendental` from
  `Lindemann.main_for_one_alpha`.  ~25 lines.  Replace `axiom` in
  `PiStratum.lean`.

Total: **~105 wizard-lines** over **2 cycles** (vs. briefing's ~225 lines
over 4 cycles).

## What this Phase B file ships

This Phase-B Andromeda contribution:

1. **Survey above** — done.
2. **`LindemannWeierstrassRoadmap.lean`** — a pointer file establishing the
   Mathlib hooks, importing the analytical part, and porting two
   immediately-usable bridge lemmas:
   - `pi_irrational_of_pi_transcendental` — derives `Irrational π` from a
     hypothetical `Transcendental ℚ π`, using `Transcendental.irrational`.
     This is **the consistency-check lemma** showing the substitution we
     plan in Cycle 58 is conservative (we never lose `irrational_pi`).
   - `transcendental_of_exp_eq_neg_one_imp_aux` — abstracted helper: if
     `exp(x) = −1` and `x` were algebraic, then `−1 ∈ exp(algebraic)` would
     contradict the Lindemann statement at `α = x`. (Stub statement that
     the future Layer-C wizard will use.)
3. **No new axioms** introduced — all lemmas reference the existing
   `Real.pi_transcendental` axiom or are independent.

## Open questions for cycle 57

1. Does Mathlib's `Polynomial.aroots ℚ` give us the algebraic-conjugate
   structure we need at `iπ`? Quick check: `iπ ∈ ℂ` is algebraic over ℚ ↔
   π is algebraic over ℚ. So if we have `algebraic_iff_pi_algebraic`,
   Layer B reduces to the integer-α case.
2. Does `Mathlib.RingTheory.AlgebraicIndependent` provide enough for the
   `∑ cᵢ exp(αᵢ) ≠ 0` step? Specifically, can we get
   `AlgebraicIndependent ℚ (fun i => exp αᵢ)` from distinct algebraic αᵢ?

## File deliverable

`OmegaTheory/Irrationality/HermitePade/LindemannWeierstrassRoadmap.lean`:
3 theorems + 1 def-helper, all derived using only Lean core +
existing Mathlib content.

## Citations

- F. Lindemann, *Über die Zahl π*, Math. Ann. 20 (1882), 213–225.
- K. Weierstrass, *Zu Lindemann's Abhandlung*, Sitz. Berlin (1885).
- C. Hermite, *Sur la fonction exponentielle*, CR (1873).
- N. Jacobson, *Basic Algebra I*, §4.12 (referenced by Mathlib).
- Yuyang Zhao, AnalyticalPart.lean, Mathlib (2022, mod-imported into
  Mathlib v4.29.0).
- I. M. Niven, *A simple proof that π is irrational*, Bull. AMS (1947).

## Off-limits (per Sage)

- `OmegaTheory/Irrationality/HermitePade/PiStratum.lean` — locked until
  Layer D in a future cycle.
- All `OmegaTheory/Irrationality/HermitePade/F*` files — older and currently
  consumed by the axiom; Andromeda did not edit any of them.
- All Mathlib core — never edit upstream.
