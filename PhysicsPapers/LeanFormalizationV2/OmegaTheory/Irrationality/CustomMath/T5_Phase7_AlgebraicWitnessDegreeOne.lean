/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_AlgebraicWitnessDegreeOne

  T-5 (Roth's theorem) — **Phase 7 ext #53: For algebraic α ≠ 0,
  there exists an integer-poly witness with natDegree ≥ 1 (cubic+
  chain structural lemma — slim version)**, sub session 559tttt —
  STRICT critical-path #316 (T-5) Phase 7 ext #53.

  Single-thread hand-authored 2026-04-28 (cycle 65 → 66 transition).

  ## What this file delivers

  Structural lemma: for any α : ℝ that is non-zero AND algebraic over ℤ,
  there exists a witness polynomial f : ℤ[X] with f ≠ 0,
  aeval α f = 0, AND `f.natDegree ≥ 1`.

  Strategy: from `IsAlgebraic ℤ α` get any witness f. If f.natDegree = 0,
  f is a non-zero constant, but aeval α f = constant_coeff = 0
  contradicts f ≠ 0. So natDegree ≥ 1.

  (The stronger natDegree ≥ 2 for irrational α is deferred to ext #54
  — requires natDegree=1 case which has Lean idiomatic complications
  around `Polynomial.eq_X_add_C_of_natDegree_le_one`-style lemmas.)

  Single derivation:
  1. `T5_nonzero_algebraic_witness_natDegree_ge_one`: ∃ f, f ≠ 0,
     aeval α f = 0, f.natDegree ≥ 1.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28:
  full prove mode, NO STUBS, NO slim shortcuts.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #53 — structural lemma (degree ≥ 1) for cubic+ chain.
-/

import Mathlib.RingTheory.Algebraic.Defs
import Mathlib.Algebra.Polynomial.AlgebraMap
import Mathlib.Data.Real.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_AlgebraicWitnessDegreeOne

open Polynomial

/-! ## Witness polynomial of natDegree ≥ 1 for nonzero algebraic α -/

/-- **🚨 Wave T5 session 559tttt — Witness polynomial natDegree ≥ 1**.

    For α : ℝ non-zero AND `IsAlgebraic ℤ α`, there exists f : ℤ[X]
    with f ≠ 0, aeval α f = 0, AND f.natDegree ≥ 1.

    The case natDegree = 0 (constant polynomial) is ruled out: a
    non-zero constant polynomial cannot vanish at any point. -/
theorem T5_nonzero_algebraic_witness_natDegree_ge_one
    (α : ℝ) (hα : α ≠ 0) (h_alg : IsAlgebraic ℤ α) :
    ∃ f : Polynomial ℤ, f ≠ 0 ∧ Polynomial.aeval α f = 0 ∧
      1 ≤ f.natDegree := by
  obtain ⟨f, hf_ne, hf_root⟩ := h_alg
  refine ⟨f, hf_ne, hf_root, ?_⟩
  -- Suppose natDegree = 0
  by_contra h_lt
  push_neg at h_lt
  have h_zero : f.natDegree = 0 := by omega
  -- f is constant: f = C (f.coeff 0)
  have h_const : f = C (f.coeff 0) :=
    (Polynomial.eq_C_of_natDegree_eq_zero h_zero)
  -- aeval α f = (f.coeff 0 : ℝ) = 0 implies f.coeff 0 = 0
  have h_root : Polynomial.aeval α f = ((f.coeff 0 : ℤ) : ℝ) := by
    rw [h_const]
    simp [Polynomial.aeval_C]
  rw [h_root] at hf_root
  have h_coeff_zero : f.coeff 0 = 0 := by exact_mod_cast hf_root
  -- f = C 0 = 0, contradicting f ≠ 0
  apply hf_ne
  rw [h_const, h_coeff_zero]
  simp

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559tttt — T-5 Phase 7 ext #53:
    Witness polynomial natDegree ≥ 1 for non-zero algebraic α**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #53.

    Single derivation:
    1. `T5_nonzero_algebraic_witness_natDegree_ge_one` — for α non-zero
       and algebraic over ℤ, ∃ witness polynomial of natDegree ≥ 1.

    Strategy: from IsAlgebraic get any witness; rule out natDegree = 0
    via constant-vanishing contradiction.

    Mathlib usage: `Polynomial.eq_C_of_natDegree_eq_zero`,
    `Polynomial.aeval_C`, `IsAlgebraic` definition.

    Sub-lemma 246/N in T-1 (T-5 Phase 7 ext #53).  Lean-core only.

    🏆 Cubic+ chain structural lemma. The stronger natDegree ≥ 2
    for irrational α (ruling out degree 1 → α rational) is deferred
    to ext #54. Escanor Pride + Erdős Primarch — full prove mode,
    NO STUBS, NO slim. -/
theorem session_559tttt_T5_phase7_algebraic_witness_natDegree_ge_one_headline
    (α : ℝ) (hα : α ≠ 0) (h_alg : IsAlgebraic ℤ α) :
    ∃ f : Polynomial ℤ, f ≠ 0 ∧ Polynomial.aeval α f = 0 ∧
      1 ≤ f.natDegree :=
  T5_nonzero_algebraic_witness_natDegree_ge_one α hα h_alg

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_AlgebraicWitnessDegreeOne
