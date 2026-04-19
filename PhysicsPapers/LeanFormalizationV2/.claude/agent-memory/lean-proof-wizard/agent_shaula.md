---
name: Agent identity — Shaula
description: Took Shaula name 2026-04-19 (hunter-T9 target #9); new OmegaTheory/Irrationality/Sqrt2Rate.lean with exact super-exponential rate for sqrt2_error_val + 2 strict consequences; full project GREEN 3652 jobs
type: user
---

# Agent identity — Shaula

- **Name taken**: 2026-04-19
- **Star catalog**: λ Scorpii — the Scorpion's stinger (brightest "jabbing"
  star in Scorpius).  Fit: super-exponential "stinger" rate of √2 decay.
- **Mission**: Gacrux proof-hunter-research Target #9 — formalize
  `sqrt2_error_val_rate` expressing the genuine super-exponential
  shrinkage of the √2 truncation error channel.

## What was delivered

New file `OmegaTheory/Irrationality/Sqrt2Rate.lean` with three theorems:

1. **`sqrt2_error_val_rate (N : ℕ)`** — exact identity
   `sqrt2_error_val (N+1) = sqrt2_error_val N / 2^(2^N)`.
   Proof hinges on a one-line exponent identity
   `(2 : ℕ)^(N+1) = 2^N + 2^N` (via `pow_succ` + `ring`), then
   `pow_add` to split `2^(2^N + 2^N) = 2^(2^N) · 2^(2^N)` and
   `field_simp` to land the ratio form.

2. **`sqrt2_error_val_rate_le_half (N : ℕ)`** — the step-factor is at
   least 2: `sqrt2_error_val (N+1) ≤ sqrt2_error_val N / 2`, because
   `2^(2^N) ≥ 2` for all `N` (thanks `Nat.one_le_two_pow`).

3. **`sqrt2_error_val_rate_strict (N : ℕ)`** — rederives the strict
   monotone-decrease `sqrt2_error_val (N+1) < sqrt2_error_val N`
   directly from the rate identity via `div_lt_self`.  Redundant with
   the pre-existing `sqrt2_error_val_strict_mono_decr` in
   `LeptonN4Uniqueness.lean` but obtained through the rate lemma path,
   so conceptually useful as a symmetry check.

## Technical notes (reusable by future hunters)

- **`pow_succ`** form in this Mathlib: `a^(n+1) = a^n * a`.  Combined
  with `ring` this suffices to rewrite `2^(N+1)` as `2·2^N` at the
  `ℕ`-exponent layer where `ring` is still sound.
- **`pow_add`** on `ℝ`: `a^(m+n) = a^m · a^n`, the right ingredient for
  pushing `2^(2^N + 2^N)` into a product.
- **`pow_le_pow_right₀`** and **`pow_lt_pow_right₀`** are the Mathlib
  v4.29 names for monotonicity of `a^k` in `k` when `1 ≤ a` (resp.
  `1 < a`) — already used in `LeptonN4Uniqueness.sqrt2_error_val_mono_decr`.
- **`div_lt_self`** expects `0 < a` and `1 < b` to prove `a / b < a`.
- `field_simp` closes `1 / (x*x) = (1/x) / x` once positivity of `x`
  is in scope via `ne_of_gt`.

## Build state after merge

- **Single module**: `~/.elan/bin/lake build OmegaTheory.Irrationality.Sqrt2Rate`
  → 1.0 s, 3287 jobs, first-try green.
- **Full project**: `3652 jobs GREEN` (+1 vs. 3651 baseline before mission).
- **0 sorry, 0 new axioms**; Shaula's file imports only
  `OmegaTheory.Irrationality.Approximations` (tight dependency graph).
- **Mirrored** to `LeanFormalizationV2/OmegaTheory/Irrationality/Sqrt2Rate.lean`
  and Basic.lean updated in both trees.
- **Registration**: imported in `OmegaTheory/Basic.lean` directly after
  `OmegaTheory.Irrationality.StrictMonotonicity`.

## Why this matters for the Pi Hunch

With this lemma, the three channels now have *algebraic* rate identities
in-theorem:

| Channel | Per-tick ratio of error | File |
| ------- | ----------------------- | ---- |
| π       | `(2N+3)/(2N+5)` → 1     | `pi_error_val_strict_mono_decr` |
| e       | `1/(N+2)` → 0           | `e_error_val_strict_mono_decr`  |
| √2      | `1/2^(2^N)` → 0 fast    | `sqrt2_error_val_rate` (new)    |

The √2 row is now the ONLY one with a closed-form *super-exponential*
ratio — the others only shrink polynomially or factorially.  This gives
the √2 channel its structural role in `LeptonN4Uniqueness` and in the
Pi Hunch fermion-mass ordering.
