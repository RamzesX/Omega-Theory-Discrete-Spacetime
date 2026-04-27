/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivVarsVanish

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 125.
  PDeriv vanishes when variable is not in `vars`.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-export of Mathlib's `MvPolynomial.pderiv_eq_zero_of_notMem_vars`:

      `i ∉ f.vars  →  pderiv i f = 0`.

  Plus iterated form: if `i ∉ f.vars` and `k ≥ 1`, then
  `(pderiv i)^[k] f = 0`.

  Useful for Roth's polynomial-index calculus: variables that don't
  actually appear in the polynomial contribute zero to the index.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.MvPolynomial.PDeriv

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivVarsVanish

open MvPolynomial

variable {σ R : Type*} [CommSemiring R]

/-! ## Pderiv vanishes off the vars set -/

/-- **Wave T5 session 125 — pderiv vanishes for `i ∉ f.vars`**.

    If `i` is not among the variables actually appearing in `f`, then
    `pderiv i f = 0`. -/
theorem T5_pderiv_eq_zero_of_notMem_vars
    {i : σ} {f : MvPolynomial σ R} (h : i ∉ f.vars) :
    pderiv i f = 0 :=
  MvPolynomial.pderiv_eq_zero_of_notMem_vars h

/-- **Wave T5 session 125 — iterated pderiv vanishes for `i ∉ f.vars`**.

    If `i ∉ f.vars` and `k ≥ 1`, then `(pderiv i)^[k] f = 0`. -/
theorem T5_pderiv_iterate_eq_zero_of_notMem_vars
    {i : σ} {f : MvPolynomial σ R} (h : i ∉ f.vars) (k : ℕ) (hk : 1 ≤ k) :
    ((pderiv i)^[k] f) = 0 := by
  obtain ⟨m, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (by omega : k ≠ 0)
  -- k = m + 1
  rw [Function.iterate_succ_apply, T5_pderiv_eq_zero_of_notMem_vars h]
  -- Goal: (pderiv i)^[m] 0 = 0
  clear hk
  induction m with
  | zero => simp
  | succ n ih =>
    rw [Function.iterate_succ_apply', ih]
    exact map_zero _

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 125 — pderiv-vars vanishing**.

    Two formulations:
    1. `i ∉ f.vars  →  pderiv i f = 0` (Mathlib direct).
    2. `i ∉ f.vars ∧ 1 ≤ k  →  (pderiv i)^[k] f = 0` (iterated).

    Sub-lemma 14/N in T-5 Phase 3.  Lean-core only.

    Useful for Roth's polynomial-index calculus: variables not actually
    appearing in `P` contribute zero to the index. -/
theorem session_125_pderiv_vars_vanishing_headline
    {σ R : Type*} [CommSemiring R] :
    -- (1) Direct
    (∀ {i : σ} {f : MvPolynomial σ R}, i ∉ f.vars → pderiv i f = 0)
    -- (2) Iterated
    ∧ (∀ {i : σ} {f : MvPolynomial σ R} (k : ℕ),
        i ∉ f.vars → 1 ≤ k →
        ((pderiv i)^[k] f) = 0) := by
  refine ⟨?_, ?_⟩
  · intros i f h; exact T5_pderiv_eq_zero_of_notMem_vars h
  · intros i f k h hk; exact T5_pderiv_iterate_eq_zero_of_notMem_vars h k hk

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivVarsVanish
