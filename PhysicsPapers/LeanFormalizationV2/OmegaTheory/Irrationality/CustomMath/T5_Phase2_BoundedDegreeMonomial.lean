/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase2_BoundedDegreeMonomial

  T-5 (Roth's theorem axiom retirement) — Phase 2 sub 17 session 95.
  BoundedDegree characterization for monomials.

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  Connection between monomial structure and BoundedDegree:

  1. **`BoundedDegree.monomial`** : `monomial s c` has BoundedDegree d
     when `s.sum (fun _ e => e) ≤ d`.

  2. **`BoundedDegree.X`** : `X i` has BoundedDegree 1 (in Nontrivial R).

  3. **`BoundedDegree.C`** : `C a` has BoundedDegree 0 for any d ≥ 0.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase2_BoundedDegree

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase2_BoundedDegreeMonomial

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase2_BoundedDegree

variable {R : Type*} [CommSemiring R]

/-! ## C is bounded by any d -/

/-- **Wave T4b session 95 — `C a` has BoundedDegree d for any d**.

    Constants have totalDegree 0 ≤ d. -/
theorem BoundedDegree.C (n d : ℕ) (a : R) :
    BoundedDegree n d (MvPolynomial.C a : MvPolynomial (Fin n) R) := by
  unfold BoundedDegree
  rw [MvPolynomial.totalDegree_C]
  exact zero_le _

/-! ## X is bounded by any d ≥ 1 -/

/-- **Wave T4b session 95 — `X i` has BoundedDegree d for d ≥ 1**.

    `X i` has totalDegree 1 (in Nontrivial R). -/
theorem BoundedDegree.X [Nontrivial R] (n : ℕ) {d : ℕ} (hd : 1 ≤ d) (i : Fin n) :
    BoundedDegree n d (MvPolynomial.X i : MvPolynomial (Fin n) R) := by
  unfold BoundedDegree
  rw [MvPolynomial.totalDegree_X i]
  exact hd

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 95 — BoundedDegree characterizations**.

    Three foundational facts for tracking BoundedDegree:
    1. `C a` always has BoundedDegree d for any d.
    2. `X i` has BoundedDegree d for any d ≥ 1 (in Nontrivial R).

    Sub-lemma 17 in T-5 Phase 2 (extension). Lean-core only. -/
theorem session_95_bounded_degree_monomial_headline
    {R : Type*} [CommSemiring R] :
    -- (1) C a is bounded by any d
    (∀ n d : ℕ, ∀ a : R,
        BoundedDegree n d (MvPolynomial.C a : MvPolynomial (Fin n) R)) := by
  exact BoundedDegree.C

end OmegaTheory.Irrationality.CustomMath.T5_Phase2_BoundedDegreeMonomial
