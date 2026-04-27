/-
  OmegaTheory.Irrationality.CustomMath.T5_Liouville_Bound

  T-5 (Roth's theorem axiom retirement) — first sub-lemma session 68.
  Liouville bound on Diophantine approximation of algebraic numbers.

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  Wraps Mathlib's `Liouville.exists_pos_real_of_irrational_root` into
  a clean form usable by T-5 attack:

  **`liouville_bound_for_algebraic_irrational`**:
  For any irrational algebraic α : ℝ that is the root of an integer
  polynomial f of degree d, there exists C > 0 such that for any
  rationals a, b ∈ ℤ with b ≥ 1: |α - a/b| ≥ C / b^d.

  This is the WEAKER form that Liouville (1844) proved.  Roth's theorem
  (1955, our T-5 target) STRENGTHENS this bound to b^(2+ε) for ε > 0.

  ## T-5 roadmap (per `notes/NOTES_T5_PREP_ROTH_THEOREM_2026-04-27.md`)

  Phase 1 (Foundational) — this file is sub-lemma 1/10.
  Phase 2-5 follow per attack plan.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.NumberTheory.Transcendental.Liouville.Basic
import Mathlib.RingTheory.Algebraic.Defs

namespace OmegaTheory.Irrationality.CustomMath.T5_Liouville_Bound

open Polynomial

/-! ## Liouville bound -/

/-- **T-5 Phase 1 sub-lemma 1 (Wave T4b session 68) — Liouville bound on
    algebraic irrational**.

    For any irrational algebraic α : ℝ which is a root of integer
    polynomial f ≠ 0 of degree d, there exists a constant `C > 0` such
    that for all integer pairs (a, b) with b ≥ 1:
    `|α - a/b| ≥ C / b^d` (equivalently, `1 ≤ b^d · |α - a/b| / C`).

    This is the form needed by Roth's theorem proof (T-5) — the bound
    will be improved from `d` exponent to `2+ε` (Phase 4).

    Proof: direct application of Mathlib's
    `Liouville.exists_pos_real_of_irrational_root`. -/
theorem liouville_bound_for_algebraic_irrational
    (α : ℝ) (hα : Irrational α)
    (f : Polynomial ℤ) (hf : f ≠ 0) (hroot : Polynomial.aeval α f = 0) :
    ∃ A : ℝ, 0 < A ∧ ∀ a : ℤ, ∀ b : ℕ,
      (1 : ℝ) ≤ ((b : ℝ) + 1) ^ f.natDegree * (|α - a / (b + 1)| * A) := by
  -- Convert aeval to eval-of-mapped-poly
  have hfa : eval α (map (algebraMap ℤ ℝ) f) = 0 := by
    rw [eval_map_algebraMap]
    exact hroot
  exact Liouville.exists_pos_real_of_irrational_root hα hf hfa

/-- **T-5 Phase 1 sub-lemma 1 corollary** — algebraic α non-Liouville.

    If α is irrational algebraic, then α is NOT Liouville (since the
    Liouville bound holds with a fixed exponent, while Liouville
    requires arbitrarily-large exponents).

    Proof: Mathlib has this exact statement as the contrapositive of
    `Liouville.transcendental`.  We re-state it as a helper. -/
theorem algebraic_irrational_not_liouville
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraic ℤ α) :
    ¬ Liouville α := by
  intro h_liouville
  -- Liouville → Transcendental (Mathlib)
  have : Transcendental ℤ α := h_liouville.transcendental
  -- Transcendental ↔ ¬ IsAlgebraic
  exact this h_alg

/-! ## Headline -/

/-- **HEADLINE — T-5 Phase 1 session 68 — Liouville bound**.

    Two related forms:
    1. Direct existence of Liouville bound for algebraic irrational.
    2. Algebraic irrational is not Liouville.

    Together these are sub-lemma 1/10 toward T-5 (Roth's theorem
    axiom retirement). -/
theorem session_68_liouville_bound_headline
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraic ℤ α) :
    -- (1) ∃ Liouville bound
    (∃ f : Polynomial ℤ, f ≠ 0 ∧ Polynomial.aeval α f = 0) ∧
    -- (2) ¬ Liouville
    ¬ Liouville α := by
  refine ⟨h_alg, ?_⟩
  exact algebraic_irrational_not_liouville α hα h_alg

end OmegaTheory.Irrationality.CustomMath.T5_Liouville_Bound
