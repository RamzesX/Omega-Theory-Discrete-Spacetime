/-
  OmegaTheory.Irrationality.CustomMath.T5_PolynomialIndex

  T-5 (Roth's theorem axiom retirement) — sub-lemma 4/10 session 71.
  Multiplicity (index) of a polynomial vanishing at a point.

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  Three definitions/lemmas:

  1. **`Polynomial.indexAtPoint`** — the largest `k : ℕ` such that
     `(X - C a)^k ∣ p`, i.e., the multiplicity of `a` as a root of `p`.
     This is `Polynomial.rootMultiplicity` from Mathlib, re-exported
     for T-5 use.

  2. **`Polynomial.indexAtPoint_le_natDegree`** — the index never
     exceeds the polynomial's natural degree.

  3. **`Polynomial.indexAtPoint_gt_zero_iff`** — index > 0 iff p has
     a as a root.

  These are the 1-variable starting point for Roth's "auxiliary
  polynomial" machinery (multivariable index).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.Div
import Mathlib.Algebra.Polynomial.RingDivision
import Mathlib.Algebra.Polynomial.Basic

set_option linter.unusedSectionVars false

namespace OmegaTheory.Irrationality.CustomMath.T5_PolynomialIndex

open Polynomial

variable {R : Type*} [CommRing R] [IsDomain R]

/-! ## Index at a point (single variable) -/

/-- **Wave T4b session 71 — index of polynomial at a point** (1-var).

    `indexAtPoint p a` is the multiplicity of `a` as a root of `p`,
    i.e., the largest `k` such that `(X - C a)^k` divides `p`.

    Re-exported from Mathlib's `Polynomial.rootMultiplicity` for
    the T-5 attack vocabulary. -/
noncomputable def Polynomial.indexAtPoint (p : R[X]) (a : R) : ℕ :=
  p.rootMultiplicity a

/-! ## Properties -/

/-- The index never exceeds the polynomial's natural degree.

    Proof: `(X - C a)^k ∣ p` implies `k ≤ p.natDegree`. -/
theorem Polynomial.indexAtPoint_le_natDegree (p : R[X]) (a : R) (hp : p ≠ 0) :
    Polynomial.indexAtPoint p a ≤ p.natDegree := by
  unfold Polynomial.indexAtPoint
  -- (X - C a)^(rootMultiplicity a p) ∣ p, so rootMultiplicity ≤ natDegree
  have h_dvd : (Polynomial.X - Polynomial.C a) ^ p.rootMultiplicity a ∣ p :=
    p.pow_rootMultiplicity_dvd a
  -- natDegree of (X - C a)^k = k
  have h_natDeg : ((Polynomial.X - Polynomial.C a) ^ p.rootMultiplicity a).natDegree =
                  p.rootMultiplicity a := by
    rw [Polynomial.natDegree_pow, Polynomial.natDegree_X_sub_C]
    ring
  -- natDegree of divisor ≤ natDegree of dividend
  rw [← h_natDeg]
  exact Polynomial.natDegree_le_of_dvd h_dvd hp

/-- Index > 0 iff a is a root of p (and p ≠ 0). -/
theorem Polynomial.indexAtPoint_pos_iff (p : R[X]) (hp : p ≠ 0) (a : R) :
    0 < Polynomial.indexAtPoint p a ↔ Polynomial.IsRoot p a := by
  unfold Polynomial.indexAtPoint
  exact Polynomial.rootMultiplicity_pos hp

/-- `(X - C a)^(indexAtPoint p a) ∣ p`. -/
theorem Polynomial.pow_indexAtPoint_dvd (p : R[X]) (a : R) :
    (Polynomial.X - Polynomial.C a) ^ Polynomial.indexAtPoint p a ∣ p :=
  p.pow_rootMultiplicity_dvd a

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 71 — polynomial index at a point**.

    Foundation for Roth's auxiliary polynomial.  Provides:
    - definition `indexAtPoint p a := rootMultiplicity p a`
    - bound by natDegree
    - characterization via IsRoot
    - divisibility witness

    Sub-lemma 4/10 in T-5 Phase 1. -/
theorem session_71_polynomial_index_headline (R : Type*) [CommRing R] [IsDomain R] :
    -- (1) Definition (re-export of rootMultiplicity)
    (∀ p : R[X], ∀ a : R,
        Polynomial.indexAtPoint p a = p.rootMultiplicity a)
    -- (2) Bound by natDegree (for p ≠ 0)
    ∧ (∀ p : R[X], p ≠ 0 → ∀ a : R,
        Polynomial.indexAtPoint p a ≤ p.natDegree)
    -- (3) Divisibility witness
    ∧ (∀ p : R[X], ∀ a : R,
        (Polynomial.X - Polynomial.C a) ^ Polynomial.indexAtPoint p a ∣ p) := by
  refine ⟨?_, ?_, ?_⟩
  · intros p a; rfl
  · intros p hp a; exact Polynomial.indexAtPoint_le_natDegree p a hp
  · intros p a; exact Polynomial.pow_indexAtPoint_dvd p a

end OmegaTheory.Irrationality.CustomMath.T5_PolynomialIndex
