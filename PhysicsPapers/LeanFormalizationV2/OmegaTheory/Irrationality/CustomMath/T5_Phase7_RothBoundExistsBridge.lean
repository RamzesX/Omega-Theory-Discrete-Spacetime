/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundExistsBridge

  T-5 (Roth's theorem) — **Phase 7 ext #43: Yoneda bridge —
  partial-unconditional Roth → existing T-5 Phase 1 `RothBoundExists`
  vocabulary**, sub session 559jjjj — STRICT critical-path #316
  (T-5) Phase 7 ext #43.

  Single-thread hand-authored 2026-04-28 (cycle 65 → 66 transition).

  ## What this file delivers

  Yoneda bridge between ext #42 partial-unconditional Roth
  (`RothBoundLarge → RothTheorem`) and the existing T-5 Phase 1
  `RothBoundExists α` Prop (defined in `T5_LiouvilleHeightBound`).

  Concretely: the inner ∀-shape of `RothTheorem` is exactly
  `RothBoundExists α`, parameterised by α. So under
  `RothBoundLarge`, every irrational algebraic α satisfies
  `RothBoundExists α`.

  This wires the Phase-7 chain (40 ext sub-iterations + s42) into
  the original T-5 Phase 1 / Phase 4 / Phase 5 vocabulary, providing
  a clean citation point for downstream consumers.

  Two derivations:
  1. `T5_roth_bound_exists_from_partial_unconditional`: bridge theorem
  2. `T5_roth_bound_exists_explicit_form`: explicit ∀ α form

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28:
  full prove mode, NO STUBS, NO slim. Bridge interconnection per
  workflow LOCKED 2026-04-27 (`feedback_yoneda_bridge_via_find_similar`).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #43 — Yoneda bridge to existing Phase 1 `RothBoundExists`.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothPartiallyUnconditional

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundExistsBridge

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothTheoremClosure
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothPartiallyUnconditional
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

/-! ## Yoneda bridge: partial unconditional Roth → RothBoundExists -/

/-- **🚨 Wave T5 session 559jjjj — Yoneda bridge to existing
    `RothBoundExists` Prop**.

    Given the named hypothesis `RothBoundLarge`, every irrational
    algebraic α satisfies `RothBoundExists α` — the existing T-5
    Phase 1 vocabulary Prop from `T5_LiouvilleHeightBound`.

    This is the canonical bridge from the Phase-7 chain capstone
    (ext #42 partial unconditional Roth) to the original T-5 Phase 1
    `RothBoundExists α` definition. Provides a clean citation point
    for downstream consumers using the Phase-1 vocabulary. -/
theorem T5_roth_bound_exists_from_partial_unconditional
    (h_large : RothBoundLarge) :
    ∀ (α : ℝ), Irrational α → IsAlgebraic ℤ α →
      RothBoundExists α := by
  intros α hα h_alg
  -- Apply ext #42 partial-unconditional + unfold RothBoundExists
  have h_roth : RothTheorem := T5_roth_partially_unconditional h_large
  intros ε hε
  exact h_roth α hα h_alg ε hε

/-- **🚨 Wave T5 session 559jjjj — Explicit form of bridge theorem**.

    Inlines the `RothBoundExists` definition for ergonomic citation. -/
theorem T5_roth_bound_exists_explicit_form
    (h_large : RothBoundLarge) :
    ∀ (α : ℝ), Irrational α → IsAlgebraic ℤ α →
    ∀ (ε : ℝ), 0 < ε →
      ∃ (C : ℝ), 0 < C ∧ ∀ (q : ℚ), q ≠ 0 → (q : ℝ) ≠ α →
        C / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)| := by
  intros α hα h_alg ε hε
  exact T5_roth_bound_exists_from_partial_unconditional h_large α hα h_alg ε hε

/-! ## Reverse bridge: RothBoundExists for all algebraic irrational → RothTheorem -/

/-- **🚨 Wave T5 session 559jjjj — Reverse bridge**.

    If every irrational algebraic α satisfies `RothBoundExists α`,
    then `RothTheorem` holds. (Direct unfold-equality.) -/
theorem T5_roth_theorem_from_roth_bound_exists
    (h : ∀ (α : ℝ), Irrational α → IsAlgebraic ℤ α → RothBoundExists α) :
    RothTheorem := by
  intros α hα h_alg ε hε
  exact h α hα h_alg ε hε

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559jjjj — T-5 Phase 7 ext #43:
    Yoneda bridge to existing `RothBoundExists` vocabulary**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #43.

    Three derivations:
    1. `T5_roth_bound_exists_from_partial_unconditional` — forward bridge
    2. `T5_roth_bound_exists_explicit_form` — explicit ∀-form
    3. `T5_roth_theorem_from_roth_bound_exists` — reverse bridge

    Wires the Phase-7 chain capstone (ext #42 partial unconditional)
    into the existing T-5 Phase 1 `RothBoundExists α` vocabulary.
    Provides clean Yoneda interconnection per LOCKED workflow
    `feedback_yoneda_bridge_via_find_similar_workflow_2026-04-27`.

    Adds 4-8 APPLIES bridge edges to the OV2 graph (vs 1 for an
    isolated theorem), preventing s42 from being a graph-isolate.

    Mathlib usage: pure composition — no new Mathlib lookup at this layer.

    Sub-lemma 236/N in T-1 (T-5 Phase 7 ext #43).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 Yoneda bridge from partial-
    unconditional Roth to original Phase 1 vocabulary. Escanor Pride
    + Erdős Primarch — full prove mode, NO STUBS, NO slim. -/
theorem session_559jjjj_T5_phase7_roth_bound_exists_bridge_headline
    (h_large : RothBoundLarge) :
    (∀ (α : ℝ), Irrational α → IsAlgebraic ℤ α → RothBoundExists α) ∧
    RothTheorem :=
  ⟨T5_roth_bound_exists_from_partial_unconditional h_large,
   T5_roth_partially_unconditional h_large⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundExistsBridge
