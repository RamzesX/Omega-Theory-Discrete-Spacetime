/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorLeadingCoeff

  T-5 (Roth's theorem) — **Phase 7 ext #126: Polynomial.taylor leading
  coefficient = original leading coefficient (cubic+ chain bookkeeping)**,
  sub session 559zzzzzzz — STRICT critical-path #316 (T-5) Phase 7 ext #126.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Polynomial.taylor preserves leading coefficient:

  For p : Polynomial R and α : R:
    `(Polynomial.taylor α p).coeff p.natDegree = p.leadingCoeff`
    `(Polynomial.taylor α p).leadingCoeff = p.leadingCoeff`

  Mathlib direct: `Polynomial.coeff_taylor_natDegree` /
  `Polynomial.leadingCoeff_taylor`.

  Used in cubic+ chain to show M (Taylor coeff sum from k to d) is
  positive when p.leadingCoeff ≠ 0, since |coeff_d (taylor α p)| =
  |p.leadingCoeff| > 0.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #126 — Polynomial.taylor leading coefficient.
-/

import Mathlib.Algebra.Polynomial.Taylor

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorLeadingCoeff

open Polynomial

/-! ## taylor preserves leading coefficient -/

/-- **🚨 Wave T5 session 559zzzzzzz — `(taylor α p).coeff p.natDegree = p.leadingCoeff`**.

    For p : Polynomial R and α : R. Mathlib direct. -/
theorem T5_taylor_coeff_natDegree_eq {R : Type*} [CommSemiring R]
    (α : R) (p : Polynomial R) :
    (Polynomial.taylor α p).coeff p.natDegree = p.leadingCoeff :=
  Polynomial.coeff_taylor_natDegree α p

/-- Companion: leading coefficient preserved. -/
theorem T5_taylor_leadingCoeff_eq {R : Type*} [CommSemiring R]
    (α : R) (p : Polynomial R) :
    (Polynomial.taylor α p).leadingCoeff = p.leadingCoeff :=
  Polynomial.leadingCoeff_taylor α p

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559zzzzzzz — T-5 Phase 7 ext #126**.

    🏆 BOOKKEEPING — Taylor preserves leading coefficient.

    Two derivations:
    1. `T5_taylor_coeff_natDegree_eq` — coeff at index p.natDegree.
    2. `T5_taylor_leadingCoeff_eq`     — leading coeff form.

    Used to establish M > 0 in Schmidt aux poly conditions: for p ≠ 0,
    |coeff_(p.natDegree) of (taylor α p)| = |p.leadingCoeff| > 0.

    Sub-lemma 299/N. Lean-core only. -/
theorem session_559zzzzzzz_T5_phase7_taylor_leadingCoeff_headline
    {R : Type*} [CommSemiring R] (α : R) (p : Polynomial R) :
    (Polynomial.taylor α p).coeff p.natDegree = p.leadingCoeff ∧
    (Polynomial.taylor α p).leadingCoeff = p.leadingCoeff :=
  ⟨T5_taylor_coeff_natDegree_eq α p, T5_taylor_leadingCoeff_eq α p⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorLeadingCoeff
