/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RestrictDegreeMonomial

  T-5 (Roth's theorem) — **Phase 7 ext #2: monomial membership in
  restrictDegree submodule**, sub session 559uu — STRICT
  critical-path #316 (T-5) Phase 7 ext #2.

  Single-thread hand-authored 2026-04-28 (cycle 65 — /loop dynamic).

  ## What this file delivers

  Concrete characterization of monomial membership in the bounded-degree
  submodule:

      `monomial s c ∈ restrictDegree σ R n ↔ (c = 0 ∨ ∀ i, s i ≤ n)`

  Plus the constant special case:

      `C c ∈ restrictDegree σ R n` (always — constants have empty support
      or support = {0} both of which trivially satisfy the bound)

  Bridges Mathlib's `support_monomial` + `mem_restrictDegree` for use
  in the Roth auxiliary polynomial integer-vector ↔ polynomial
  conversion (downstream Phase 7 work).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #2 — monomial-restrictDegree bridge.  Prerequisite for
  the auxiliary-polynomial vector encoding: a non-zero polynomial in
  `restrictDegree σ R n` has support contained in the bounded box,
  hence corresponds bijectively (when σ is `Fin m`) to an integer
  vector indexed by the box — which is what SiegelsLemma operates on.
-/

import Mathlib.RingTheory.MvPolynomial.Basic
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RestrictDegreeExpose

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RestrictDegreeMonomial

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RestrictDegreeExpose

variable {σ : Type*} {R : Type*} [CommSemiring R]

/-! ## Monomial membership characterization -/

/-- **🚨 Wave T5 session 559uu — `monomial s c ∈ restrictDegree iff c=0 or s bounded`**.

    The monomial `c · X^s` is in `restrictDegree σ R n` iff either
    `c = 0` (zero polynomial trivially in any submodule) or every
    component of the multi-index `s` is `≤ n`. -/
theorem T5_monomial_mem_restrictDegree
    [DecidableEq R] (s : σ →₀ ℕ) (c : R) (n : ℕ) :
    (MvPolynomial.monomial s c : MvPolynomial σ R)
        ∈ MvPolynomial.restrictDegree σ R n ↔
      (c = 0 ∨ ∀ i : σ, s i ≤ n) := by
  rw [MvPolynomial.mem_restrictDegree]
  constructor
  · intro h
    by_cases hc : c = 0
    · left; exact hc
    · right
      intro i
      apply h
      rw [MvPolynomial.support_monomial]
      simp [hc]
  · intro h
    intro s' hs' i
    rw [MvPolynomial.support_monomial] at hs'
    by_cases hc : c = 0
    · simp [hc] at hs'
    · simp [hc] at hs'
      subst hs'
      rcases h with hc0 | hbound
      · exact absurd hc0 hc
      · exact hbound i

/-! ## Constants always belong -/

/-- **🚨 Wave T5 session 559uu — `C c ∈ restrictDegree σ R n` always**.

    The constant polynomial `C c = monomial 0 c` has support ⊆ {0},
    where the zero multi-index `0 : σ →₀ ℕ` has every component 0 ≤ n
    trivially.  So `C c` is in any `restrictDegree σ R n`. -/
theorem T5_C_mem_restrictDegree (c : R) (n : ℕ) :
    (MvPolynomial.C c : MvPolynomial σ R)
        ∈ MvPolynomial.restrictDegree σ R n := by
  rw [MvPolynomial.mem_restrictDegree]
  intro s hs i
  -- support of C c is either ∅ (c = 0) or {0} (c ≠ 0)
  -- in either case s = 0 (when in support), so s i = 0 ≤ n
  classical
  rw [MvPolynomial.C_apply, MvPolynomial.support_monomial] at hs
  by_cases hc : c = 0
  · simp [hc] at hs
  · simp [hc] at hs
    subst hs
    simp

/-! ## RestrictDegreeMonomial Prop scaffold -/

/-- **RestrictDegreeMonomial**: 2-conjunct Prop packaging the
    monomial-restrictDegree bridge. -/
def RestrictDegreeMonomial : Prop :=
  (∀ {σ R : Type*} [CommSemiring R] [DecidableEq R] (s : σ →₀ ℕ) (c : R) (n : ℕ),
    (MvPolynomial.monomial s c : MvPolynomial σ R)
        ∈ MvPolynomial.restrictDegree σ R n ↔ (c = 0 ∨ ∀ i : σ, s i ≤ n)) ∧
  (∀ {σ R : Type*} [CommSemiring R] (c : R) (n : ℕ),
    (MvPolynomial.C c : MvPolynomial σ R) ∈ MvPolynomial.restrictDegree σ R n)

/-- **🚨 Wave T5 session 559uu — `RestrictDegreeMonomial`**. -/
theorem T5_restrict_degree_monomial : RestrictDegreeMonomial :=
  ⟨@T5_monomial_mem_restrictDegree,
   @T5_C_mem_restrictDegree⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559uu — T-5 Phase 7 ext #2: monomial-restrictDegree bridge**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #2.

    Two concrete characterizations + Prop:
    1. `T5_monomial_mem_restrictDegree`: monomial `c · X^s` is in
       `restrictDegree σ R n` iff `c = 0` or every component `s i ≤ n`
    2. `T5_C_mem_restrictDegree`: constants `C c` are always in
       `restrictDegree σ R n` for any n
    + RestrictDegreeMonomial Prop (2-conjunct).

    Bridges Mathlib's `support_monomial` + `mem_restrictDegree`
    (s559tt) into a usable API for the downstream Roth auxiliary-
    polynomial integer-vector ↔ polynomial bijection (Phase 7
    SiegelsLemma application).

    Mathlib usage: `MvPolynomial.support_monomial`,
    `MvPolynomial.mem_restrictDegree` (s559tt re-export),
    `MvPolynomial.C_apply` (= `monomial 0`).

    Sub-lemma 195/N in T-1 (T-5 Phase 7 ext #2).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 monomial-restrictDegree bridge. -/
theorem session_559uu_T5_phase7_restrict_degree_monomial_headline :
    RestrictDegreeMonomial :=
  T5_restrict_degree_monomial

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RestrictDegreeMonomial
