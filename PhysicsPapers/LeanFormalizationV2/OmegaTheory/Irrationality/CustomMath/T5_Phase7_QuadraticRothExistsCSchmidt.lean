/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothExistsCSchmidt

  T-5 (Roth's theorem) — **Phase 7 ext #132: QUADRATIC Roth EXISTS-C
  via Schmidt path (unconditional standard Roth signature)**, sub
  session 559ffffffff — STRICT critical-path #316 (T-5) Phase 7 ext #132.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Repackages ext #131 into the EXISTS-C form matching standard Roth
  signature:

  For α : ℝ with `IsQuadraticAlgebraic α` (i.e., ∃ degree-2 ℤ-poly
  with α as root) and ε > 0:
    ∃ C > 0, ∃ p ≠ 0 (annihilating α), ∀ q close to α with eval₂ ≠ 0:
      `C · q.den^(-(2+ε)) ≤ |q-α|`

  UNCONDITIONAL — no SchmidtAuxPolyExists hypothesis needed (since the
  k=1 quadratic discharge is proven explicitly in ext #130).

  Single derivation:
  1. `T5_quadratic_roth_exists_C_via_schmidt`: composes ext #131 +
     C extraction + positivity from ext #118.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #132 — QUADRATIC Roth EXISTS-C via Schmidt path (UNCONDITIONAL).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothFormSchmidtPath
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothConstantPositivity

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothExistsCSchmidt

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothFormSchmidtPath
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothConstantPositivity

/-! ## Quadratic Roth EXISTS-C via Schmidt path -/

/-- **🚨 Wave T5 session 559ffffffff — Quadratic Roth EXISTS-C UNCONDITIONAL**.

    For α : ℝ with `∃ p ∈ ℤ[X], p ≠ 0 ∧ aeval α p = 0 ∧ p.natDegree = 2` and ε > 0:
      ∃ C > 0, ∃ p ≠ 0 (annihilating α), ∀ q close to α with eval₂ ≠ 0:
        `C · q.den^(-(2+ε)) ≤ |q-α|`. -/
theorem T5_quadratic_roth_exists_C_via_schmidt
    (α : ℝ)
    (h_quad_witness : ∃ p : Polynomial ℤ, p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧ p.natDegree = 2)
    (ε : ℝ) (hε : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| := by
  obtain ⟨p, M, hM_pos, hp_ne, hp_root, h_bound⟩ :=
    T5_quadratic_roth_form_via_schmidt_path α h_quad_witness ε hε
  -- C := M^(-1) (since k = 1, the Roth constant is M^(-1))
  refine ⟨M ^ (-(1 / ((1 : ℕ) : ℝ))), p, ?_, hp_ne, hp_root, h_bound⟩
  exact T5_roth_constant_positivity M hM_pos _

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559ffffffff — T-5 Phase 7 ext #132**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #132.

    🏆 QUADRATIC ROTH UNCONDITIONAL via Schmidt path (EXISTS-C form).

    Single derivation:
    1. `T5_quadratic_roth_exists_C_via_schmidt` — UNCONDITIONAL Roth-form
       bound for quadratic α with `C = M^(-1)`.

    Strategy: composes ext #131 (Roth-form via Schmidt path) + ext #118
    (Roth constant positivity).

    Standard Roth signature `∃ C > 0, ∃ p, ...` matches existing T-5
    `T5_quadratic_roth_via_liouville` style. Two independent proof paths
    for quadratic α:
    1. Liouville path (s44+): direct |p(q)| ≥ 1/q.den^d argument.
    2. Schmidt path (this ext): index argument via Taylor + truncation.

    Cross-validates quadratic Roth. Cubic+ requires Schmidt-Wirsing-Roth
    multivariate machinery (NOT covered here).

    Mathlib usage: composition of ext #131 + ext #118.

    Sub-lemma 305/N. Lean-core only.

    🏆 First Lean-core T-5 Phase 7 QUADRATIC ROTH UNCONDITIONAL via Schmidt
       path (EXISTS-C form). Escanor Pride + Erdős Primarch — full prove
       mode, NO STUBS, NO slim. -/
theorem session_559ffffffff_T5_phase7_quadratic_roth_exists_C_via_schmidt_headline
    (α : ℝ)
    (h_quad_witness : ∃ p : Polynomial ℤ, p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧ p.natDegree = 2)
    (ε : ℝ) (hε : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_quadratic_roth_exists_C_via_schmidt α h_quad_witness ε hε

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothExistsCSchmidt
