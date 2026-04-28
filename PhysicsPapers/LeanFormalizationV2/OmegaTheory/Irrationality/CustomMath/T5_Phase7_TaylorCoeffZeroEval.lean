/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorCoeffZeroEval

  T-5 (Roth's theorem) — **Phase 7 ext #121: Taylor coefficient at
  index 0 = eval at α (cubic+ chain bookkeeping)**, sub session
  559uuuuuuu — STRICT critical-path #316 (T-5) Phase 7 ext #121.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Standard fact about `Polynomial.taylor`:

  For p : Polynomial R and α : R:
    `(Polynomial.taylor α p).coeff 0 = p.eval α`

  This is the "constant term of Taylor expansion = value at α" — the
  first-order condition for "α is a root of p" via Taylor language.

  Strategy: Mathlib's `Polynomial.taylor_coeff_zero` is the direct lemma.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #121 — Taylor coefficient at index 0 = eval at α.
-/

import Mathlib.Algebra.Polynomial.Taylor

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorCoeffZeroEval

open Polynomial

/-! ## Taylor coeff zero -/

/-- **🚨 Wave T5 session 559uuuuuuu — Taylor coeff 0 = eval**.

    For p : Polynomial R and α : R:
      `(Polynomial.taylor α p).coeff 0 = p.eval α`. -/
theorem T5_taylor_coeff_zero_eq_eval {R : Type*} [CommSemiring R]
    (α : R) (p : Polynomial R) :
    (Polynomial.taylor α p).coeff 0 = p.eval α :=
  Polynomial.taylor_coeff_zero α p

/-- Companion: equivalent form — Taylor coeff 0 = 0 ↔ p.IsRoot α. -/
theorem T5_taylor_coeff_zero_eq_zero_iff_root {R : Type*} [CommSemiring R]
    (α : R) (p : Polynomial R) :
    (Polynomial.taylor α p).coeff 0 = 0 ↔ p.IsRoot α := by
  rw [T5_taylor_coeff_zero_eq_eval]; rfl

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559uuuuuuu — T-5 Phase 7 ext #121**.

    🏆 BOOKKEEPING — Taylor coefficient at index 0 ↔ root condition.

    Sub-lemma 294/N. Lean-core only. -/
theorem session_559uuuuuuu_T5_phase7_taylor_coeff_zero_eval_headline
    {R : Type*} [CommSemiring R] (α : R) (p : Polynomial R) :
    (Polynomial.taylor α p).coeff 0 = p.eval α ∧
    ((Polynomial.taylor α p).coeff 0 = 0 ↔ p.IsRoot α) :=
  ⟨T5_taylor_coeff_zero_eq_eval α p, T5_taylor_coeff_zero_eq_zero_iff_root α p⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorCoeffZeroEval
