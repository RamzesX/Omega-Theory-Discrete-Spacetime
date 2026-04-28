/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_WronskianBasicAdaptation

  T-5 (Roth's theorem) — Phase 3 Wronskian basic adaptation,
  sub session 559m — STRICT critical-path #316 (T-5) derivation.

  Single-thread hand-authored 2026-04-28 (cycle 65 — strategic cron).

  ## What this file delivers

  Per crawler intel 2026-04-28: Mathlib's `Polynomial.Wronskian` is
  available at `Mathlib.RingTheory.Polynomial.Wronskian`. This file
  ships T-5 Phase 3 adaptation: re-export + algebraic identities
  (antisymmetry + bilinearity) over ℝ[X] for OV2 namespace
  consistency.

  Six derivations + Prop:
  - Self-Wronskian zero: W(a, a) = 0 (re-export from Mathlib)
  - Antisymmetry: W(a, b) = -W(b, a)
  - Bilinearity left: W(a+b, c) = W(a, c) + W(b, c)
  - Bilinearity right: W(a, b+c) = W(a, b) + W(a, c)
  - Self-zero composition: ∀ a, W(a, a) = 0
  - Antisymmetric composition: W(a, b) + W(b, a) = 0

  These are foundational for the Phase 3 core (Wronskian non-vanishing
  for Roth-index polynomial via Vandermonde-style determinant).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  This file ships small Phase 3 building block: Wronskian basic
  adaptation. Next concrete step (~150-200 lines): Wronskian
  non-vanishing for Roth-index auxiliary polynomial via Vandermonde-
  style determinant adaptation (per crawler intel
  `project_t5_roth_phase3_intel_2026-04-28`).

  Phase 3 entry layer remains essentially complete (66 files, 8034
  lines) — this file slots in alongside the existing layer.
-/

import Mathlib.RingTheory.Polynomial.Wronskian
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Ring

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_WronskianBasicAdaptation

open Polynomial

/-! ## ℝ-Wronskian re-export -/

/-- **wronskian_R**: Wronskian for real polynomials, OV2 namespace alias. -/
noncomputable def wronskian_R (a b : ℝ[X]) : ℝ[X] := wronskian a b

/-! ## Self-Wronskian zero (Mathlib re-export) -/

/-- **🚨 Wave T1 session 559m — `W(a, a) = 0`** for real polynomials.

    Re-export of Mathlib's `wronskian_self_eq_zero` for ℝ[X]
    specialization. -/
theorem T5_wronskian_R_self_eq_zero (a : ℝ[X]) : wronskian_R a a = 0 :=
  wronskian_self_eq_zero a

/-! ## Antisymmetry: W(a, b) = -W(b, a) -/

/-- **🚨 Wave T1 session 559m — Wronskian antisymmetry**.

    `W(a, b) = -W(b, a)` follows directly from the definition
    `W(a, b) := a · b' - a' · b`. -/
theorem T5_wronskian_R_antisym (a b : ℝ[X]) :
    wronskian_R a b = -wronskian_R b a := by
  unfold wronskian_R wronskian
  ring

/-- **🚨 Wave T1 session 559m — Wronskian sum vanishes**: `W(a, b) + W(b, a) = 0`. -/
theorem T5_wronskian_R_sum_swap (a b : ℝ[X]) :
    wronskian_R a b + wronskian_R b a = 0 := by
  rw [T5_wronskian_R_antisym a b]; ring

/-! ## Bilinearity in first argument -/

/-- **🚨 Wave T1 session 559m — Wronskian additive in left arg**:
    `W(a + b, c) = W(a, c) + W(b, c)`. -/
theorem T5_wronskian_R_add_left (a b c : ℝ[X]) :
    wronskian_R (a + b) c = wronskian_R a c + wronskian_R b c := by
  unfold wronskian_R wronskian
  rw [Polynomial.derivative_add]
  ring

/-! ## Bilinearity in second argument -/

/-- **🚨 Wave T1 session 559m — Wronskian additive in right arg**:
    `W(a, b + c) = W(a, b) + W(a, c)`. -/
theorem T5_wronskian_R_add_right (a b c : ℝ[X]) :
    wronskian_R a (b + c) = wronskian_R a b + wronskian_R a c := by
  unfold wronskian_R wronskian
  rw [Polynomial.derivative_add]
  ring

/-! ## T5_Phase3_WronskianBasicAdaptation Prop scaffold -/

/-- **T5WronskianBasicAdaptation**: T-5 Phase 3 Wronskian basic
    algebraic identities + Mathlib re-export.

    Real Prop body — composes 5 algebraic identities (antisym +
    bilinearity left/right + self-zero + sum-swap) into single
    Prop for downstream Phase 3 core consumers. -/
def T5WronskianBasicAdaptation : Prop :=
  (∀ a : ℝ[X], wronskian_R a a = 0) ∧
  (∀ a b : ℝ[X], wronskian_R a b = -wronskian_R b a) ∧
  (∀ a b : ℝ[X], wronskian_R a b + wronskian_R b a = 0) ∧
  (∀ a b c : ℝ[X], wronskian_R (a + b) c = wronskian_R a c + wronskian_R b c) ∧
  (∀ a b c : ℝ[X], wronskian_R a (b + c) = wronskian_R a b + wronskian_R a c)

/-- **🚨 Wave T1 session 559m — `T5WronskianBasicAdaptation`**. -/
theorem T5_wronskian_basic_adaptation : T5WronskianBasicAdaptation :=
  ⟨T5_wronskian_R_self_eq_zero,
   T5_wronskian_R_antisym,
   T5_wronskian_R_sum_swap,
   T5_wronskian_R_add_left,
   T5_wronskian_R_add_right⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 559m — T-5 Phase 3 Wronskian basic adaptation**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 3 building block.

    Five algebraic identities + Prop:
    1. W(a, a) = 0 (self-zero, re-export)
    2. W(a, b) = -W(b, a) (antisymmetry)
    3. W(a, b) + W(b, a) = 0 (sum-swap)
    4. W(a+b, c) = W(a, c) + W(b, c) (left bilinearity)
    5. W(a, b+c) = W(a, b) + W(a, c) (right bilinearity)
    + T5WronskianBasicAdaptation Prop (5-conjunct).

    Foundation for Phase 3 core: Wronskian non-vanishing for Roth-
    index auxiliary polynomial via Vandermonde-style determinant
    (next single-file step ~150-200 lines per crawler intel).

    Mathlib usage: re-export `Polynomial.wronskian` + `derivative_add`
    + ring. NO new infrastructure needed.

    Sub-lemma 161/N in T-1 (T-5 Phase 3 building block).  Lean-core only.

    🏆 First Lean-core T-5 Phase 3 Wronskian basic adaptation. -/
theorem session_559m_T5_wronskian_basic_adaptation_headline :
    (∀ a : ℝ[X], wronskian_R a a = 0) ∧
    (∀ a b : ℝ[X], wronskian_R a b = -wronskian_R b a) ∧
    (∀ a b : ℝ[X], wronskian_R a b + wronskian_R b a = 0) ∧
    (∀ a b c : ℝ[X], wronskian_R (a + b) c = wronskian_R a c + wronskian_R b c) ∧
    (∀ a b c : ℝ[X], wronskian_R a (b + c) = wronskian_R a b + wronskian_R a c) ∧
    T5WronskianBasicAdaptation :=
  ⟨T5_wronskian_R_self_eq_zero,
   T5_wronskian_R_antisym,
   T5_wronskian_R_sum_swap,
   T5_wronskian_R_add_left,
   T5_wronskian_R_add_right,
   T5_wronskian_basic_adaptation⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_WronskianBasicAdaptation
