/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivCommute

  T-5 (Roth's theorem axiom retirement) — Phase 3 entry session 110.
  Schwarz's theorem for MvPolynomial: partial derivatives commute.

  Single-thread hand-authored 2026-04-27 (cycle 65 entry).

  ## What this file delivers

  Mathlib v4.29 has `pderiv_C`, `pderiv_X_self`, `pderiv_mul` (Leibniz),
  `pderiv_pow`, `pderiv_map`, `pderiv_rename`, but does NOT have a
  commutativity lemma for two `pderiv`'s.  Phase 3 of T-5 (Roth's theorem
  port) needs this for the multivariable polynomial-index calculus.

  Main result:
  **`T5_pderiv_pderiv_comm`** : `pderiv i (pderiv j p) = pderiv j (pderiv i p)`
  for `p : MvPolynomial σ R` over any `CommSemiring R`.

  Proof: induction on `p` via `MvPolynomial.induction_on'` (monomial +
  add).  Monomial case uses `pderiv_monomial`, `tsub_right_comm`, and a
  case-split on `i = j` vs `i ≠ j`.  Add case is by linearity.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.MvPolynomial.PDeriv

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivCommute

open MvPolynomial Finsupp

variable {σ R : Type*} [CommSemiring R]

/-! ## Schwarz's theorem (commutativity of partial derivatives) -/

/-- **Wave T5 session 110 — Schwarz's theorem on monomials**.

    Pderiv commutes on monomials. -/
theorem T5_pderiv_pderiv_comm_monomial (i j : σ) (s : σ →₀ ℕ) (a : R) :
    pderiv i (pderiv j (monomial s a : MvPolynomial σ R)) =
      pderiv j (pderiv i (monomial s a : MvPolynomial σ R)) := by
  classical
  rw [pderiv_monomial, pderiv_monomial, pderiv_monomial, pderiv_monomial]
  -- Goals: monomial (s - single j 1 - single i 1) (a * s j * (s - single j 1) i)
  --      = monomial (s - single i 1 - single j 1) (a * s i * (s - single i 1) j)
  -- Equal degrees: s - single j 1 - single i 1 = s - single i 1 - single j 1
  have hdeg : (s - single j 1 - single i 1 : σ →₀ ℕ) =
              (s - single i 1 - single j 1 : σ →₀ ℕ) := by
    ext k
    simp only [Finsupp.tsub_apply]
    exact tsub_right_comm
  rw [hdeg]
  -- Now coefficients: a * s j * (s - single j 1) i = a * s i * (s - single i 1) j
  congr 1
  by_cases hij : i = j
  · subst hij; ring
  · -- i ≠ j: (s - single j 1) i = s i, (s - single i 1) j = s j
    have h1 : ((s - single j 1 : σ →₀ ℕ) i) = s i := by
      rw [Finsupp.tsub_apply, Finsupp.single_apply]
      have : ¬ (j = i) := fun h => hij h.symm
      simp [this]
    have h2 : ((s - single i 1 : σ →₀ ℕ) j) = s j := by
      rw [Finsupp.tsub_apply, Finsupp.single_apply]
      simp [hij]
    rw [h1, h2]
    ring

/-- **HEADLINE — Wave T5 session 110 — Schwarz's theorem for MvPolynomial**.

    Partial derivatives commute on any MvPolynomial over any CommSemiring.

    `pderiv i (pderiv j p) = pderiv j (pderiv i p)`. -/
theorem T5_pderiv_pderiv_comm (i j : σ) (p : MvPolynomial σ R) :
    pderiv i (pderiv j p) = pderiv j (pderiv i p) := by
  induction p using MvPolynomial.induction_on' with
  | monomial s a =>
    exact T5_pderiv_pderiv_comm_monomial i j s a
  | add p q hp hq =>
    simp only [map_add, hp, hq]

/-! ## Headline (Phase 3 entry) -/

/-- **HEADLINE — T-5 Phase 3 entry session 110 — Schwarz for MvPolynomial**.

    First Phase-3 sub-lemma of Roth's theorem port.  Two formulations:
    1. `pderiv` commutes on monomials.
    2. `pderiv` commutes on arbitrary MvPolynomial (extends by induction).

    Foundational for index-of-polynomial calculus (next sessions). -/
theorem session_110_pderiv_schwarz_headline
    {σ R : Type*} [CommSemiring R] :
    -- (1) On monomials
    (∀ (i j : σ) (s : σ →₀ ℕ) (a : R),
        pderiv i (pderiv j (monomial s a : MvPolynomial σ R)) =
          pderiv j (pderiv i (monomial s a : MvPolynomial σ R)))
    -- (2) On arbitrary p
    ∧ (∀ (i j : σ) (p : MvPolynomial σ R),
        pderiv i (pderiv j p) = pderiv j (pderiv i p)) :=
  ⟨T5_pderiv_pderiv_comm_monomial, T5_pderiv_pderiv_comm⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivCommute
