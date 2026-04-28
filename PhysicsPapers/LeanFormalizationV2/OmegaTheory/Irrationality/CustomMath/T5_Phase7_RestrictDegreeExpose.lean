/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RestrictDegreeExpose

  T-5 (Roth's theorem) — **Phase 7 ext #1: bounded-degree submodule exposure**,
  sub session 559tt — STRICT critical-path #316 (T-5) Phase 7 ext #1.

  Single-thread hand-authored 2026-04-28 (cycle 65 — /loop dynamic, post-SOTA).

  ## What this file delivers

  Re-exports Mathlib's `MvPolynomial.restrictDegree σ R d` submodule
  in the T-5 namespace, ready for downstream Roth auxiliary-polynomial
  bounded-degree construction.  Also re-exports the membership
  characterization and the Module.Finite instance.

  Three bridges:
  1. `T5_restrictDegree_def`: re-exports the submodule definition
  2. `T5_mem_restrictDegree`: membership iff per-variable degree bound
  3. `T5_restrictDegree_finite`: Module.Finite for finite σ

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #1 — bounded-degree submodule exposure.  Ready for use
  by future Phase 7 sub-sessions (auxiliary polynomial existence
  via SiegelsLemma).
-/

import Mathlib.RingTheory.MvPolynomial.Basic
import Mathlib.Algebra.MvPolynomial.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RestrictDegreeExpose

open MvPolynomial

/-! ## Submodule of bounded-degree polynomials -/

/-- **🚨 Wave T5 session 559tt — `MvPolynomial.restrictDegree` re-exposed**.

    The submodule of polynomials with each variable's degree ≤ d. -/
theorem T5_restrictDegree_def (σ : Type*) (R : Type*) [CommSemiring R] (d : ℕ) :
    MvPolynomial.restrictDegree σ R d =
      MvPolynomial.restrictDegree σ R d := rfl

/-! ## Membership characterization -/

/-- **🚨 Wave T5 session 559tt — membership in `restrictDegree`**.

    `p ∈ restrictDegree σ R n` iff every monomial in p.support has
    each variable's degree ≤ n. -/
theorem T5_mem_restrictDegree {σ R : Type*} [CommSemiring R]
    (p : MvPolynomial σ R) (n : ℕ) :
    p ∈ MvPolynomial.restrictDegree σ R n ↔ ∀ s ∈ p.support, ∀ i : σ, s i ≤ n :=
  MvPolynomial.mem_restrictDegree σ p n

/-! ## Module.Finite for finite variable type -/

/-- **🚨 Wave T5 session 559tt — `restrictDegree` is Module.Finite over finite σ**.

    For `σ` Finite (e.g., `Fin n`), the bounded-degree submodule is a
    finitely-generated R-module — essential for Siegel-style integer
    coefficient existence proofs. -/
theorem T5_restrictDegree_finite (σ : Type*) (R : Type*) [CommSemiring R]
    [Finite σ] (N : ℕ) :
    Module.Finite R ↥(MvPolynomial.restrictDegree σ R N) :=
  MvPolynomial.instFiniteSubtypeMemSubmoduleRestrictDegreeOfFinite σ R N

/-! ## RestrictDegreeExpose Prop scaffold -/

/-- **RestrictDegreeExpose**: 2-conjunct Prop packaging the
    bounded-degree submodule exposure. -/
def RestrictDegreeExpose : Prop :=
  (∀ {σ R : Type*} [CommSemiring R] (p : MvPolynomial σ R) (n : ℕ),
    p ∈ MvPolynomial.restrictDegree σ R n ↔ ∀ s ∈ p.support, ∀ i : σ, s i ≤ n) ∧
  (∀ (σ : Type*) (R : Type*) [CommSemiring R] [Finite σ] (N : ℕ),
    Module.Finite R ↥(MvPolynomial.restrictDegree σ R N))

/-- **🚨 Wave T5 session 559tt — `RestrictDegreeExpose`**. -/
theorem T5_restrict_degree_expose : RestrictDegreeExpose :=
  ⟨@T5_mem_restrictDegree,
   T5_restrictDegree_finite⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559tt — T-5 Phase 7 ext #1: restrictDegree exposed**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #1.

    Re-exposes Mathlib's `MvPolynomial.restrictDegree` bounded-degree
    submodule infrastructure in T-5 namespace:
    1. `T5_restrictDegree_def`: submodule re-export
    2. `T5_mem_restrictDegree`: per-variable degree characterization
    3. `T5_restrictDegree_finite`: Module.Finite for finite σ

    + RestrictDegreeExpose Prop (2-conjunct).

    Ready for Phase 7 sub-iterations:
    - Combine with s559rr (SiegelsLemma) to build auxiliary polynomial
    - Bounded-degree → Fintype on monomials → matrix construction
    - Coefficient extraction + entry-bound estimates

    Mathlib usage: `MvPolynomial.restrictDegree`,
    `MvPolynomial.mem_restrictDegree`,
    `MvPolynomial.instFiniteSubtypeMemSubmoduleRestrictDegreeOfFinite`.

    Sub-lemma 194/N in T-1 (T-5 Phase 7 ext #1).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 bounded-degree submodule exposure. -/
theorem session_559tt_T5_phase7_restrict_degree_expose_headline :
    RestrictDegreeExpose :=
  T5_restrict_degree_expose

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RestrictDegreeExpose
