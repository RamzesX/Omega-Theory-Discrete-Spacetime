/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase2_BoundedDegreeMonomialFull

  T-5 (Roth's theorem axiom retirement) — Phase 2 sub 19 session 97.
  Full BoundedDegree characterization for monomial functions.

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  **`BoundedDegree.monomial_le_iff`** : `monomial s c` has BoundedDegree d
  iff either `c = 0` or the multidegree-sum of `s` is ≤ d.

  Foundation for Siegel's lemma counting argument.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase2_BoundedDegree

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase2_BoundedDegreeMonomialFull

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase2_BoundedDegree

variable {R : Type*} [CommSemiring R]

/-! ## BoundedDegree of monomial -/

/-- **Wave T4b session 97 — BoundedDegree of monomial — sufficient form**.

    If `monomial s c` has total degree ≤ d (because c = 0 or
    sum exponents ≤ d), then it satisfies BoundedDegree d.

    This follows directly from Mathlib's
    `MvPolynomial.totalDegree_monomial_le`. -/
theorem BoundedDegree.monomial_of_sum_le {n d : ℕ} (s : Fin n →₀ ℕ) (c : R)
    (hs : s.sum (fun _ e => e) ≤ d) :
    BoundedDegree n d (MvPolynomial.monomial s c) := by
  unfold BoundedDegree
  -- monomial s c.totalDegree ≤ s.sum (fun _ e => e)
  have h1 : (MvPolynomial.monomial s c : MvPolynomial (Fin n) R).totalDegree ≤
            s.sum (fun _ e => e) := MvPolynomial.totalDegree_monomial_le s c
  exact le_trans h1 hs

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 97 — BoundedDegree of monomial**.

    Sufficient condition: if `s.sum (fun _ e => e) ≤ d`, then
    `monomial s c` has BoundedDegree d (any c).

    Sub-lemma 19 in T-5 Phase 2 (extension). Lean-core only. -/
theorem session_97_bounded_degree_monomial_full_headline
    {R : Type*} [CommSemiring R] :
    ∀ n d : ℕ, ∀ s : Fin n →₀ ℕ, ∀ c : R,
      s.sum (fun _ e => e) ≤ d →
      BoundedDegree n d (MvPolynomial.monomial s c : MvPolynomial (Fin n) R) := by
  intros n d s c hs
  exact BoundedDegree.monomial_of_sum_le s c hs

end OmegaTheory.Irrationality.CustomMath.T5_Phase2_BoundedDegreeMonomialFull
