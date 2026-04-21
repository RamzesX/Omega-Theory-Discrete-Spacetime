# 03 — e: transcendence class and Mathlib inventory

## Known properties (2026-04-21)

| Property | Value / status | Earliest proof | Mathlib |
|---|---|---|---|
| Irrational | YES | Euler 1737 | `Nat.Prime.not_dvd_fact` based `Irrational_e` derivable; direct `Irrational (Real.exp 1)` — **MISSING** as direct term, follows from transcendence |
| Non-Liouville | YES (μ(e) = 2) | Borel 1899 | not directly stated |
| Algebraic? | NO (transcendental) | Hermite 1873 | **MISSING** as of v4.29.0 |
| Roth exponent | μ(e) = 2 EXACTLY | Borel 1899 | not stated |
| Mahler class | **S** with ω(e) = 1 | Mahler 1932 direct | Mahler framework not in Mathlib |
| Shidlovsky E-function | YES — `exp(z)` is canonical E-function | Siegel 1929 | not in Mathlib |
| Lindemann-Weierstrass witness | `e^α` transcendental ∀ algebraic α ≠ 0 | Lindemann 1882 + Weierstrass 1885 | partial (analytical part) |

## Why e is the cleanest of the four

Of the OmegaTheory quartet, **e is the one with the most classical machinery**. Hermite's 1873 proof of e-transcendence uses simultaneous rational approximation to `(1, e, e², …, eⁿ)` built from Hermite's `e^x ∫ e^(-t) P(t) dt` integrals. This became the template for:

- Lindemann 1882 (π transcendence, via `e^(iπ) = −1`).
- Weierstrass 1885 (algebraic independence of e^(α₁), …, e^(α_n) for linearly-independent algebraic α_i).
- Siegel 1929, Shidlovsky 1956 (E-function class).
- Mahler 1932 Mahler-classification, ω(e) = 1 computed directly from Hermite's construction.

In the Mahler partition, **e is a canonical S-number**: `ω(e) = 1` achieves the lowest possible ω-value for any transcendental (A-numbers have ω = 0 by definition).

## Mathlib files touched

- `Mathlib.Analysis.SpecialFunctions.Exp` — `Real.exp`, `Complex.exp`.
- `Mathlib.Analysis.SpecialFunctions.Exponential` — exponential map properties.
- `Mathlib.NumberTheory.Transcendental.Lindemann.AnalyticalPart` — Hermite's integrals for the analytical half of Lindemann.
- `Mathlib.Data.Nat.Factorial.*` — factorial, for Taylor tail bounds.

## OmegaTheory infrastructure for e

| File | Purpose |
|---|---|
| `Irrationality/Approximations.lean` | `truncated_e N`, `eErrorBound N = 3/(N+1)!`, `e_error_val N` |
| `Irrationality/BoundsLemmas.lean` | `e_error_bound`, `e_error_tendsto_zero` |
| `Irrationality/Uncertainty.lean` | `computationalUncertainty` δ_comp primitive |
| `Emergence/LeptonMassFromIrrationals.lean` | `e_error_le_pi_error`, `e_error_lt_pi_error`, `sqrt2_error_le_e_error`, `sqrt2_error_lt_e_error` — the middle-channel inequalities |

## What we can commit to proving (session estimates)

| Statement | Type | Sessions | Blocker |
|---|---|---|---|
| `Irrational (Real.exp 1)` | theorem | 1 session (compose with Mathlib if present, or port Euler) | minor Mathlib port |
| `Transcendental ℚ (Real.exp 1)` | **currently blocked** | 20+ sessions Hermite port | MATHLIB |
| `μ(Real.exp 1) = 2` | theorem (Borel) | 10 sessions once μ framework exists | Mathlib μ-framework |
| `e is E-function value at 1` | statement-only | 2 sessions | E-function framework |
| `Mahler.isS (Real.exp 1)` with `ω(e) = 1` | theorem in "full-Mahler" world | 15 sessions after Mahler port | Mahler classification in Mathlib |

**Commitments in this scope** (see `12_graph_register.md`):
1. `e_is_irrational_wrap` — trivial wrapper once `Irrational (Real.exp 1)` is in Mathlib.
2. `e_mu_eq_2_statement` — statement-level, μ primitive required.
3. `e_is_E_function_value_statement` — statement only, 2 sessions.
4. `e_is_S_number_conditional` — `ω(e) = 1 → e ∈ S`, conditional on Mahler port.

## Comparison with π (why e ≠ π at Mahler level)

**e**: ω(e) = 1, known; μ(e) = 2, known; *full classical certainty*.
**π**: ω(π) conjecturally ≤ 2.55; μ(π) known ≤ 7.103 (Zeilberger–Zudilin 2020), conjecturally = 2; *partial certainty*.

Even if both are eventually shown to be Mahler-S (which is conjectural for π), the **effective** ω-value for e is known and for π is not. In an Ω-Theory separation-theorem context, this *is* a structural difference: ω(e) = 1 is a specific number; ω(π) is only known to be finite-if-S-number-at-all.

**Takeaway.** e-class ≠ π-class at the level of *known quantitative bounds*, even if both are conjecturally in S. For the purposes of the 4-channel partition, this counts as a qualitative separation.
