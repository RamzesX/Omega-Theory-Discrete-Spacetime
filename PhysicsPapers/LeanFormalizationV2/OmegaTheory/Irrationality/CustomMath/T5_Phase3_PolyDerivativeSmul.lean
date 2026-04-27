/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyDerivativeSmul

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 165.
  `Polynomial.derivative_smul`.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-export of Mathlib's `derivative_smul`:

      `derivative (s • p) = s • derivative p`.

  Confirms `derivative` is S-linear for any scalar action S.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.Derivative

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyDerivativeSmul

open Polynomial

/-! ## derivative distributes over SMul -/

/-- **Wave T5 session 165 — `derivative (s • p) = s • derivative p`**.

    `derivative` is S-linear for any scalar action. -/
theorem T5_polynomial_derivative_smul
    {R : Type*} [Semiring R]
    {S : Type*} [SMulZeroClass S R] [IsScalarTower S R R]
    (s : S) (p : R[X]) :
    Polynomial.derivative (s • p) = s • Polynomial.derivative p :=
  Polynomial.derivative_smul s p

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 165 — derivative_smul**.

    `derivative (s • p) = s • derivative p`.

    Confirms `derivative` is S-linear for any scalar action S.

    Sub-lemma 52/N in T-5 Phase 3.  Lean-core only. -/
theorem session_165_polynomial_derivative_smul_headline :
    ∀ {R : Type*} [_inst : Semiring R]
       {S : Type*} [_inst' : SMulZeroClass S R] [_inst'' : IsScalarTower S R R]
       (s : S) (p : R[X]),
        Polynomial.derivative (s • p) = s • Polynomial.derivative p :=
  fun {_R} _inst {_S} _inst' _inst'' s p =>
    T5_polynomial_derivative_smul s p

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyDerivativeSmul
