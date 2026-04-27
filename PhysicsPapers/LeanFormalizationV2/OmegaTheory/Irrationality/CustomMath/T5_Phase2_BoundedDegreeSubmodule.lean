/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase2_BoundedDegreeSubmodule

  T-5 (Roth's theorem axiom retirement) — Phase 2 sub 16 session 94.
  BoundedDegree as an R-Submodule of MvPolynomial Fin n R.

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  Constructs `BoundedDegreeSubmodule n d R` — the R-Submodule of
  MvPolynomial (Fin n) R consisting of polynomials with
  `totalDegree ≤ d`.

  This is the linear-algebra structure needed for Siegel's lemma:
  the auxiliary polynomial lives in this finite-dimensional R-module,
  and we count basis elements (= monomials with bounded degree) to
  apply pigeonhole.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase2_BoundedDegree
import Mathlib.Algebra.Module.Submodule.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase2_BoundedDegreeSubmodule

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase2_BoundedDegree

variable {R : Type*} [CommSemiring R]

/-! ## BoundedDegree as a Submodule -/

/-- **Wave T4b session 94 — BoundedDegree as R-Submodule**.

    The set of MvPolynomial (Fin n) R with totalDegree ≤ d forms an
    R-Submodule (closed under sum + scalar + contains zero).

    This is the structure used in Siegel's lemma for the auxiliary
    polynomial space. -/
noncomputable def boundedDegreeSubmodule (n d : ℕ) :
    Submodule R (MvPolynomial (Fin n) R) where
  carrier := { p | BoundedDegree n d p }
  add_mem' := fun {p q} hp hq => BoundedDegree.add hp hq
  zero_mem' := BoundedDegree.zero n d
  smul_mem' := fun c {p} hp => BoundedDegree.smul c hp

/-! ## Properties -/

/-- Membership characterization. -/
theorem mem_boundedDegreeSubmodule (n d : ℕ) (p : MvPolynomial (Fin n) R) :
    p ∈ boundedDegreeSubmodule n d (R := R) ↔ BoundedDegree n d p :=
  Iff.rfl

/-- Equivalent characterization in totalDegree form. -/
theorem mem_boundedDegreeSubmodule_iff_totalDegree
    (n d : ℕ) (p : MvPolynomial (Fin n) R) :
    p ∈ boundedDegreeSubmodule n d (R := R) ↔ p.totalDegree ≤ d :=
  Iff.rfl

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 94 — BoundedDegreeSubmodule**.

    Provides:
    1. `boundedDegreeSubmodule n d : Submodule R (MvPolynomial Fin n R)`
    2. Membership = BoundedDegree predicate
    3. Membership = `totalDegree ≤ d`

    Foundation for Siegel's lemma in T-5 Phase 2 hard work.

    Sub-lemma 16 in T-5 Phase 2 (extension beyond ENTRY). Lean-core only. -/
theorem session_94_bounded_degree_submodule_headline
    {R : Type*} [CommSemiring R] :
    -- (1) Membership iff BoundedDegree
    (∀ n d : ℕ, ∀ p : MvPolynomial (Fin n) R,
        p ∈ boundedDegreeSubmodule n d (R := R) ↔ BoundedDegree n d p)
    -- (2) Membership iff totalDegree ≤ d
    ∧ (∀ n d : ℕ, ∀ p : MvPolynomial (Fin n) R,
        p ∈ boundedDegreeSubmodule n d (R := R) ↔ p.totalDegree ≤ d) := by
  refine ⟨?_, ?_⟩
  · exact mem_boundedDegreeSubmodule
  · exact mem_boundedDegreeSubmodule_iff_totalDegree

end OmegaTheory.Irrationality.CustomMath.T5_Phase2_BoundedDegreeSubmodule
