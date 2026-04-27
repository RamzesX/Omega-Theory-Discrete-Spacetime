/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_TotalDegreeChar

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 126.
  Characterization of `MvPolynomial.totalDegree`.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's totalDegree characterizations:

  1. **`T5_totalDegree_C`** : `(C a).totalDegree = 0`.
  2. **`T5_totalDegree_eq_zero_iff_eq_C`** : `p.totalDegree = 0 ↔ p = C (p.coeff 0)`.
  3. **`T5_totalDegree_eq_zero_iff`** : `p.totalDegree = 0 ↔ ∀ m ∈ p.support, ∀ x, m x = 0`.

  Found via `mcp__omega-orchestrator__omega_hammer_premise` on
  "totalDegree p = 0 ↔ ∃ a, p = C a".

  Used in T-5 polynomial-index calculus where bounded total degree of
  the auxiliary polynomial is one of the input constraints.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.MvPolynomial.Degrees
import Mathlib.RingTheory.MvPolynomial.Homogeneous

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_TotalDegreeChar

open MvPolynomial

variable {σ R : Type*} [CommSemiring R]

/-! ## totalDegree of constants -/

/-- **Wave T5 session 126 — `totalDegree (C a) = 0`**. -/
theorem T5_totalDegree_C (a : R) :
    (C a : MvPolynomial σ R).totalDegree = 0 :=
  MvPolynomial.totalDegree_C a

/-! ## Characterizations -/

/-- **Wave T5 session 126 — `totalDegree = 0` iff equal to constant**.

    `p.totalDegree = 0 ↔ p = C (p.coeff 0)`. -/
theorem T5_totalDegree_eq_zero_iff_eq_C {p : MvPolynomial σ R} :
    p.totalDegree = 0 ↔ p = C (p.coeff 0) :=
  MvPolynomial.totalDegree_eq_zero_iff_eq_C

/-- **Wave T5 session 126 — `totalDegree = 0` iff support is constant-only**. -/
theorem T5_totalDegree_eq_zero_iff (p : MvPolynomial σ R) :
    p.totalDegree = 0 ↔ ∀ m ∈ p.support, ∀ (x : σ), m x = 0 :=
  MvPolynomial.totalDegree_eq_zero_iff σ p

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 126 — totalDegree characterizations**.

    Three formulations of "totalDegree = 0":
    1. `totalDegree (C a) = 0` (constants).
    2. `totalDegree p = 0 ↔ p = C (p.coeff 0)` (functional).
    3. `totalDegree p = 0 ↔ ∀ m ∈ p.support, ∀ x, m x = 0` (support).

    Sub-lemma 15/N in T-5 Phase 3.  Lean-core only.

    Found via mcp__omega-orchestrator__omega_hammer_premise.

    Used in T-5 where the auxiliary polynomial's bounded total degree
    is a key input parameter for Roth's lemma. -/
theorem session_126_total_degree_char_headline
    {σ R : Type*} [CommSemiring R] :
    -- (1) C a
    (∀ a : R, (C a : MvPolynomial σ R).totalDegree = 0)
    -- (2) functional
    ∧ (∀ {p : MvPolynomial σ R}, p.totalDegree = 0 ↔ p = C (p.coeff 0))
    -- (3) support form
    ∧ (∀ (p : MvPolynomial σ R),
        p.totalDegree = 0 ↔ ∀ m ∈ p.support, ∀ (x : σ), m x = 0) :=
  ⟨T5_totalDegree_C, T5_totalDegree_eq_zero_iff_eq_C, T5_totalDegree_eq_zero_iff⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_TotalDegreeChar
