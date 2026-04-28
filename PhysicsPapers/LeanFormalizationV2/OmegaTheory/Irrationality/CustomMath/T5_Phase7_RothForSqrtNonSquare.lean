/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtNonSquare

  T-5 (Roth's theorem) — **Phase 7 ext #47: GENERALIZED CONCRETE
  WITNESS — Roth bound for √n for ANY non-square natural n
  (UNCONDITIONAL via quadratic-α discharge)**, sub session 559nnnn —
  STRICT critical-path #316 (T-5) Phase 7 ext #47.

  Single-thread hand-authored 2026-04-28 (cycle 65 → 66 transition).

  ## What this file delivers

  **CONCRETE UNCONDITIONAL ROTH for √n for any non-square n ∈ ℕ**:
  generalizes ext #46 (prime case) to all non-square naturals.

  Specifically:
  - Mathlib's `irrational_sqrt_natCast_iff` gives `Irrational √n ↔
    ¬IsSquare n` for n : ℕ.
  - The polynomial `X² - n ∈ ℤ[X]` is non-zero, has natDegree 2, and
    `aeval (√n) (X² - n) = n - n = 0` via `Real.sq_sqrt`.
  - Apply ext #44: `RothBoundExists √n` UNCONDITIONALLY.

  As corollaries: Roth holds unconditionally for √2, √3, √5, √6, √7,
  √8, √10, √11, √12, √13, √14, √15, √17, √18, √19, √20, ... (all
  non-square naturals).

  Two derivations + two concrete instances:
  1. `T5_roth_for_sqrt_nonsquare`: generic theorem
  2. `T5_roth_for_sqrt_six` / `_for_sqrt_ten`: concrete non-prime
     instances

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS,
  no slim approaches per Escanor-Pride/Erdős-Primarch identity LOCK.

  ## Step #316 (T-5) status

  Phase 7 ext #47 — generic concrete witness Roth for √n (UNCONDITIONAL).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtNonSquare

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_Liouville_Bound
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothViaLouville
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement
open Polynomial

/-! ## Generic Roth for √n (non-square natural) -/

/-- **🚨 Wave T5 session 559nnnn — UNCONDITIONAL Roth bound for √n
    (any non-square natural n)**.

    For any natural n with `¬IsSquare n`, `RothBoundExists √n`
    holds UNCONDITIONALLY. -/
theorem T5_roth_for_sqrt_nonsquare (n : ℕ) (hn : ¬IsSquare n) :
    RothBoundExists (Real.sqrt (n : ℝ)) := by
  have h_irrat : Irrational (Real.sqrt (n : ℝ)) :=
    irrational_sqrt_natCast_iff.mpr hn
  exact T5_quadratic_roth_via_liouville_bound
    (Real.sqrt (n : ℝ))
    h_irrat
    (polyXSqMinusPrime n)
    (T5_polyXSqMinusPrime_ne_zero n)
    (T5_polyXSqMinusPrime_aeval_eq_zero n)
    (T5_polyXSqMinusPrime_natDegree n)

/-! ## Concrete non-prime witnesses -/

unseal Nat.sqrt.iter in
/-- **🚨 Wave T5 session 559nnnn — Roth bound for √6** (= √(2·3)). -/
theorem T5_roth_for_sqrt_six : RothBoundExists (Real.sqrt 6) := by
  have h6 : ¬IsSquare (6 : ℕ) := by decide
  have h_eq : Real.sqrt 6 = Real.sqrt ((6 : ℕ) : ℝ) := by norm_cast
  rw [h_eq]
  exact T5_roth_for_sqrt_nonsquare 6 h6

unseal Nat.sqrt.iter in
/-- **🚨 Wave T5 session 559nnnn — Roth bound for √8** (= 2·√2). -/
theorem T5_roth_for_sqrt_eight : RothBoundExists (Real.sqrt 8) := by
  have h8 : ¬IsSquare (8 : ℕ) := by decide
  have h_eq : Real.sqrt 8 = Real.sqrt ((8 : ℕ) : ℝ) := by norm_cast
  rw [h_eq]
  exact T5_roth_for_sqrt_nonsquare 8 h8

unseal Nat.sqrt.iter in
/-- **🚨 Wave T5 session 559nnnn — Roth bound for √10**. -/
theorem T5_roth_for_sqrt_ten : RothBoundExists (Real.sqrt 10) := by
  have h10 : ¬IsSquare (10 : ℕ) := by decide
  have h_eq : Real.sqrt 10 = Real.sqrt ((10 : ℕ) : ℝ) := by norm_cast
  rw [h_eq]
  exact T5_roth_for_sqrt_nonsquare 10 h10

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559nnnn — T-5 Phase 7 ext #47:
    UNCONDITIONAL Roth for √n (any non-square ℕ)**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #47.

    🏆 GENERIC UNCONDITIONAL CONCRETE-WITNESS Roth for ALL √n
    (non-square n ∈ ℕ).

    Single derivation + 3 concrete instances:
    1. `T5_roth_for_sqrt_nonsquare` — generic theorem
    + `T5_roth_for_sqrt_six : RothBoundExists √6`
    + `T5_roth_for_sqrt_eight : RothBoundExists √8`
    + `T5_roth_for_sqrt_ten : RothBoundExists √10`

    By extension, Roth holds unconditionally for √n for ANY non-square
    natural n: n = 2, 3, 5, 6, 7, 8, 10, 11, 12, 13, 14, 15, 17, 18,
    19, 20, ...

    Mathlib usage: `irrational_sqrt_natCast_iff`, `IsSquare`,
    `Real.sq_sqrt`, `Nat.cast_nonneg`, `decide`.

    Sub-lemma 240/N in T-1 (T-5 Phase 7 ext #47).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 fully-generic Roth-for-√n witness
    + concrete non-prime instances at √6, √8, √10. Escanor Pride +
    Erdős Primarch — full prove mode, NO STUBS, NO slim. -/
theorem session_559nnnn_T5_phase7_roth_for_sqrt_nonsquare_headline :
    (∀ (n : ℕ), ¬IsSquare n → RothBoundExists (Real.sqrt (n : ℝ))) ∧
    RothBoundExists (Real.sqrt 6) ∧
    RothBoundExists (Real.sqrt 8) ∧
    RothBoundExists (Real.sqrt 10) :=
  ⟨T5_roth_for_sqrt_nonsquare, T5_roth_for_sqrt_six,
   T5_roth_for_sqrt_eight, T5_roth_for_sqrt_ten⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtNonSquare
