/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_DirichletApprox

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 137.
  Dirichlet's approximation theorem.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-export of Mathlib's `exists_int_int_abs_mul_sub_le` (Dirichlet 1842):

      For any ξ : ℝ and n : ℕ with n > 0, there exist integers j, k
      with 0 < k ≤ n and |kξ - j| ≤ 1/(n+1).

  This is the foundational theorem of Diophantine approximation —
  every real number admits good rational approximations.  Roth's
  theorem refines this for algebraic numbers.

  Also wraps `exists_rat_abs_sub_le_and_den_le` for the rational form.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.NumberTheory.DiophantineApproximation.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_DirichletApprox

/-! ## Dirichlet 1842 -/

/-- **Wave T5 session 137 — Dirichlet's approximation theorem (integer form)**.

    For any ξ : ℝ and n > 0, ∃ j, k integers with 0 < k ≤ n and
    |kξ - j| ≤ 1/(n+1). -/
theorem T5_dirichlet_int (ξ : ℝ) {n : ℕ} (n_pos : 0 < n) :
    ∃ j k : ℤ, 0 < k ∧ k ≤ n ∧ |↑k * ξ - j| ≤ 1 / (n + 1) :=
  Real.exists_int_int_abs_mul_sub_le ξ n_pos

/-- **Wave T5 session 137 — Dirichlet's theorem (rational form)**.

    For any ξ : ℝ and n > 0, ∃ rational q with q.den ≤ n and
    |ξ - q| ≤ 1 / ((n+1) * q.den). -/
theorem T5_dirichlet_rat (ξ : ℝ) {n : ℕ} (n_pos : 0 < n) :
    ∃ q : ℚ, |ξ - q| ≤ 1 / (((n : ℝ) + 1) * (q.den : ℝ)) ∧ q.den ≤ n :=
  Real.exists_rat_abs_sub_le_and_den_le ξ n_pos

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 137 — Dirichlet's approximation theorem**.

    Two foundational forms:
    1. Integer: ∃ j, k with |kξ - j| ≤ 1/(n+1), 0 < k ≤ n.
    2. Rational: ∃ q with |ξ - q| ≤ 1/((n+1) * q.den), q.den ≤ n.

    Sub-lemma 26/N in T-5 Phase 3.  Lean-core only.

    Dirichlet (1842) shows every real number admits good rational
    approximations.  Roth's theorem refines this for algebraic
    numbers — algebraic ξ does NOT admit BETTER-than-quadratic
    approximations (κ = 2 is exactly tight). -/
theorem session_137_dirichlet_approx_headline :
    -- (1) Integer form
    (∀ (ξ : ℝ) {n : ℕ} (_n_pos : 0 < n),
        ∃ j k : ℤ, 0 < k ∧ k ≤ n ∧ |↑k * ξ - j| ≤ 1 / (n + 1))
    -- (2) Rational form
    ∧ (∀ (ξ : ℝ) {n : ℕ} (_n_pos : 0 < n),
        ∃ q : ℚ, |ξ - q| ≤ 1 / (((n : ℝ) + 1) * (q.den : ℝ)) ∧ q.den ≤ n) := by
  refine ⟨?_, ?_⟩
  · intros ξ n h; exact T5_dirichlet_int ξ h
  · intros ξ n h; exact T5_dirichlet_rat ξ h

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_DirichletApprox
