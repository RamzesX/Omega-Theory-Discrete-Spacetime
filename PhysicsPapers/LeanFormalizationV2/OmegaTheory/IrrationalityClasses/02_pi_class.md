# 02 — π: transcendence class and Mathlib inventory

## Known properties (2026-04-21)

| Property | Value / status | Earliest proof | Mathlib |
|---|---|---|---|
| Irrational | YES | Lambert 1761 | `Irrational.pi` (`Mathlib.Analysis.SpecialFunctions.Pi`) |
| Non-Liouville | YES | Mahler 1953 | not directly stated; follows from μ(π)<∞ |
| Algebraic? | NO (transcendental) | Lindemann 1882 | **MISSING** — only `Mathlib.NumberTheory.Transcendental.Lindemann.AnalyticalPart`, no `Transcendental ℚ Real.pi` conclusion |
| Roth exponent | 2 (conjectured, μ(π) ≤ 7.103 proved) | Zeilberger–Zudilin 2020 | not in Mathlib |
| Mahler class | **S (conjectured)**; ω(π) < ∞ conjectured | — | Mahler framework not in Mathlib |
| Nesterenko triple witness | π, e^π, Γ(1/4) alg-indep | Nesterenko 1996 | axiom `Nesterenko_1996` in V2 |

## Current best irrationality-measure bounds on π

The quantitative upper bound μ(π) ≤ λ is tracked in the literature as the "irrationality measure of π":

- **Mahler 1953**: μ(π) ≤ 42.
- **Hata 1993**: μ(π) ≤ 8.016045…
- **Salikhov 2008**: μ(π) ≤ 7.606308…
- **Zeilberger–Zudilin 2020**: μ(π) ≤ 7.103205334137… (current world record; arXiv:1912.06345).

Conjecture: μ(π) = 2 (shared with almost every real).

**Implication for OmegaTheory.** As long as μ(π) < ∞, π is NOT a Liouville number. This rules out U-class at least for the Liouville subset. Whether π ∈ S or T is **open** — it is not known to be S-number, but it is strongly conjectured (the "Mahler conjecture for π", see Waldschmidt 2006 §3.6).

## Mathlib files touched by OmegaTheory's π machinery

- `Mathlib.Analysis.Real.Pi.Basic` — defines `Real.pi`.
- `Mathlib.Analysis.SpecialFunctions.Complex.Analytic` / `Pi` — `Irrational.pi`.
- `Mathlib.NumberTheory.Transcendental.Lindemann.AnalyticalPart` — analytical part of Lindemann, includes Hermite's integrals but does NOT yet conclude π-transcendence.
- `Mathlib.NumberTheory.Irrational` — basic irrationality framework.

## OmegaTheory files that would benefit from a Lean-level "π ∈ Mahler-S" statement

- `Irrationality/HermitePade/PiStratum.lean` — uses `axiom Real.pi_transcendental` today.
- `Irrationality/HermitePade/GAP_N_Conjecture.lean` — the effective sharpening is about μ(π); native Lean support for μ would let us state the target `μ(π) ≤ 3 + ε` cleanly as `Prop`.
- `Irrationality/HermitePade/Decoupling.lean` — polynomial decoupling depends only on transcendence, so the day we port Lindemann–Weierstrass, `Real.pi_transcendental` deletes.

## What we can commit to proving in Lean (session estimates)

| Statement | Type | Sessions | Blocker |
|---|---|---|---|
| `Irrational Real.pi` | theorem (via Mathlib) | 0.1 | none — direct import |
| `Transcendental ℚ Real.pi` | **axiom today → theorem** | 30+ sessions of Lindemann-Weierstrass porting in Mathlib | MATHLIB port |
| `μ(Real.pi) < ∞` (non-Liouville) | theorem | 5–10 sessions (needs Mahler 1953 style argument) | Mathlib irrationality-measure infra |
| `μ(Real.pi) ≤ 8` (weak Hata) | theorem | 15–25 sessions | Hata 1993 hypergeometric construction |
| `μ(Real.pi) ≤ 7.103` (Zeilberger-Zudilin) | theorem | 40+ sessions | Full hypergeometric quantum construction |
| `Mahler.isS Real.pi` | conjecture → theorem | open-ended (research frontier) | CLASSICAL math open |
| `π ∉ Liouville` via μ(π)<∞ | theorem given μ-bound | 2 sessions after μ-bound | chained on μ-bound |

**Commitments in this scope (go into `:TheoremCandidate` register):**
1. `pi_irrational_mathlib_wrap` — 0.1 session, trivial wrapper.
2. `pi_non_liouville_from_finite_measure` — 3 sessions once μ is in Mathlib.
3. `pi_class_membership_statement` — statement-level only, 1 session.

See `12_graph_register.md` for the registered nodes.
