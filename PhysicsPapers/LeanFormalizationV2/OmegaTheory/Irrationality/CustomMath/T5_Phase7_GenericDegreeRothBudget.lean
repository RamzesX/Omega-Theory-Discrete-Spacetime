/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeRothBudget

  T-5 (Roth's theorem) — **Phase 7 ext #173: Generic-degree Roth budget
  for k=1 + ε > n-2 (cubic+ chain generic pattern)**, sub session
  559uuuuuuuuu — STRICT critical-path #316 (T-5) Phase 7 ext #173.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Generic Roth budget condition for IsAlgebraicOfDegree α n with k=1 + ε > n-2:

  For α : ℝ with IsAlgebraicOfDegree α n (n ≥ 2) and ε > n - 2:
    `(1 : ℝ) * (2 + ε) > p.natDegree = n`

  Generalizes ext #168 (cubic, n=3, ε > 1) to all n ≥ 2.

  Strategy: 1·(2+ε) = 2+ε; for ε > n-2, 2+ε > n = p.natDegree.

  Single derivation:
  1. `T5_generic_degree_roth_budget`: Roth budget for k=1.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #173 — Generic-degree Roth budget for k=1, ε > n-2.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeRothBudget

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree

/-! ## Generic-degree Roth budget for k=1 -/

/-- **🚨 Wave T5 session 559uuuuuuuuu — Roth budget for IsAlgebraicOfDegree α n + ε > n-2**.

    For α with IsAlgebraicOfDegree α n and ε > (n - 2 : ℝ):
    ∃ p ∈ ℤ[X], p ≠ 0, aeval α p = 0, p.natDegree = n,
    `((1 : ℕ) : ℝ) * (2 + ε) > p.natDegree`. -/
theorem T5_generic_degree_roth_budget
    (α : ℝ) (n : ℕ) (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) :
    ∃ (p : Polynomial ℤ),
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      p.natDegree = n ∧
      (((1 : ℕ) : ℝ)) * (2 + ε) > p.natDegree := by
  obtain ⟨p, hp_ne, hp_root, hp_deg⟩ := h_alg
  refine ⟨p, hp_ne, hp_root, hp_deg, ?_⟩
  rw [hp_deg]
  push_cast
  linarith

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559uuuuuuuuu — T-5 Phase 7 ext #173**.

    🏆 BOOKKEEPING — Generic Roth budget for ANY n ≥ 2 with ε > n-2.

    Generalizes:
    - n = 2 (quadratic): ε > 0 (any ε > 0)
    - n = 3 (cubic): ε > 1 (s168)
    - n = 4 (quartic): ε > 2 (NEW)
    - n = 5 (quintic): ε > 3 (NEW)

    For ε ≤ n - 2, need Schmidt-Wirsing-Roth k ≥ 2 multivariate machinery.

    Sub-lemma 346/N. Lean-core only. -/
theorem session_559uuuuuuuuu_T5_phase7_generic_degree_roth_budget_headline
    (α : ℝ) (n : ℕ) (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) :
    ∃ (p : Polynomial ℤ),
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      p.natDegree = n ∧
      (((1 : ℕ) : ℝ)) * (2 + ε) > p.natDegree :=
  T5_generic_degree_roth_budget α n h_alg ε hε

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeRothBudget
