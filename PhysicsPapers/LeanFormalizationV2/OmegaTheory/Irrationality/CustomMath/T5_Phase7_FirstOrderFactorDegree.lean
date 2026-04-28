/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_FirstOrderFactorDegree

  T-5 (Roth's theorem) — **Phase 7 ext #62: First-order factor
  natDegree bookkeeping (cubic+ chain prep)**, sub session 559ccccc
  — STRICT critical-path #316 (T-5) Phase 7 ext #62.

  Single-thread hand-authored 2026-04-28 (cycle 65 → 66 transition).

  ## What this file delivers

  Strengthens ext #58 (first-order factor existence) with the natDegree
  bookkeeping: when p has α as root, the factor `g` from `p = (X - C α) * g`
  satisfies `g.natDegree = p.natDegree - 1`.

  Concretely, for p : R[X] with R commutative ring, `p.IsRoot α`, p ≠ 0:
    p = (X - C α) * (p /ₘ (X - C α))
    AND (p /ₘ (X - C α)).natDegree = p.natDegree - 1

  This is **structural infrastructure for Taylor expansion bounding**:
  to bound `|g.eval q|` on a bounded interval, knowing `g.natDegree`
  is critical (e.g., for inducting on degree).

  Two derivations:
  1. `T5_first_order_factor_eq_divByMonic`: p = (X - C α) * (p /ₘ (X - C α))
  2. `T5_first_order_factor_natDegree`: (p /ₘ (X - C α)).natDegree = p.natDegree - 1

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28:
  full prove mode, NO STUBS, NO slim.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #62 — first-order factor natDegree (cubic+ chain prep).
-/

import Mathlib.Algebra.Polynomial.Div

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_FirstOrderFactorDegree

open Polynomial

/-! ## First-order factor as divByMonic -/

/-- **🚨 Wave T5 session 559ccccc — First-order factor as divByMonic**.

    For p : R[X] (R commutative ring) with `p.IsRoot α`:
    `p = (X - C α) * (p /ₘ (X - C α))`.

    This identifies the factor `g` from ext #58 as `p /ₘ (X - C α)`
    explicitly. -/
theorem T5_first_order_factor_eq_divByMonic
    {R : Type*} [CommRing R] (p : Polynomial R) (α : R) (hα : p.IsRoot α) :
    p = (X - C α) * (p /ₘ (X - C α)) := by
  -- Use Polynomial.mul_divByMonic_eq_iff_isRoot
  -- (X - C α).Monic, p /ₘ (X - C α) is the quotient
  -- p = (X - C α) * (p /ₘ (X - C α)) iff p.IsRoot α (since X - C α monic)
  exact (mul_divByMonic_eq_iff_isRoot.mpr hα).symm

/-! ## First-order factor natDegree -/

/-- **🚨 Wave T5 session 559ccccc — First-order factor natDegree**.

    For p : R[X] (R nontrivial) with `p.IsRoot α`:
    `(p /ₘ (X - C α)).natDegree = p.natDegree - 1`. -/
theorem T5_first_order_factor_natDegree
    {R : Type*} [CommRing R] [Nontrivial R]
    (p : Polynomial R) (α : R) :
    (p /ₘ (X - C α)).natDegree = p.natDegree - 1 := by
  have h_monic : (X - C α : Polynomial R).Monic := monic_X_sub_C α
  rw [Polynomial.natDegree_divByMonic p h_monic, natDegree_X_sub_C]

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559ccccc — T-5 Phase 7 ext #62:
    First-order factor natDegree bookkeeping**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #62.

    🏆 STRUCTURAL bookkeeping for cubic+ chain Taylor.

    Two derivations:
    1. `T5_first_order_factor_eq_divByMonic` — explicit factor as
       p /ₘ (X - C α).
    2. `T5_first_order_factor_natDegree` — natDegree = p.natDegree - 1.

    Foundation for Taylor expansion degree induction. To bound
    `|g.eval q|` on a bounded interval, the natDegree of g matters
    (induction step + Lagrange-style bounds).

    Mathlib usage: `Polynomial.mul_divByMonic_eq_iff_isRoot`,
    `Polynomial.natDegree_divByMonic`, `Polynomial.monic_X_sub_C`,
    `Polynomial.natDegree_X_sub_C`.

    Sub-lemma 255/N in T-1 (T-5 Phase 7 ext #62).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 first-order factor natDegree.
    Escanor Pride + Erdős Primarch — full prove mode, NO STUBS, NO slim. -/
theorem session_559ccccc_T5_phase7_first_order_factor_degree_headline
    {R : Type*} [CommRing R] [Nontrivial R]
    (p : Polynomial R) (α : R) (hα : p.IsRoot α) :
    p = (X - C α) * (p /ₘ (X - C α)) ∧
    (p /ₘ (X - C α)).natDegree = p.natDegree - 1 :=
  ⟨T5_first_order_factor_eq_divByMonic p α hα,
   T5_first_order_factor_natDegree p α⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_FirstOrderFactorDegree
