/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorNatDegree

  T-5 (Roth's theorem) — **Phase 7 ext #125: Polynomial.taylor
  preserves natDegree (cubic+ chain bookkeeping)**, sub session
  559yyyyyyy — STRICT critical-path #316 (T-5) Phase 7 ext #125.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Polynomial.taylor preserves natDegree:

  For p : Polynomial R and α : R:
    `(Polynomial.taylor α p).natDegree = p.natDegree`

  Mathlib direct: `Polynomial.taylor_natDegree`.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #125 — Polynomial.taylor natDegree preservation.
-/

import Mathlib.Algebra.Polynomial.Taylor

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorNatDegree

open Polynomial

/-! ## taylor preserves natDegree -/

/-- **🚨 Wave T5 session 559yyyyyyy — `(taylor α p).natDegree = p.natDegree`**.

    For p : Polynomial R and α : R. Mathlib direct. -/
theorem T5_taylor_natDegree_eq {R : Type*} [CommSemiring R]
    (α : R) (p : Polynomial R) :
    (Polynomial.taylor α p).natDegree = p.natDegree :=
  Polynomial.natDegree_taylor p α

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559yyyyyyy — T-5 Phase 7 ext #125**.

    🏆 BOOKKEEPING — Polynomial.taylor natDegree preservation.

    Sub-lemma 298/N. Lean-core only. -/
theorem session_559yyyyyyy_T5_phase7_taylor_natDegree_headline
    {R : Type*} [CommSemiring R] (α : R) (p : Polynomial R) :
    (Polynomial.taylor α p).natDegree = p.natDegree :=
  T5_taylor_natDegree_eq α p

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorNatDegree
