/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothPartiallyUnconditional

  T-5 (Roth's theorem) — **Phase 7 ext #42: PARTIALLY UNCONDITIONAL
  Roth (specializes ext #40 capstone with ext #41 unconditional
  RothBoundSmall, reducing to single-hypothesis conditional)**, sub
  session 559iiii — STRICT critical-path #316 (T-5) Phase 7 ext #42.

  Single-thread hand-authored 2026-04-28 (cycle 65 → 66 transition).

  ## What this file delivers

  **PARTIAL UNCONDITIONAL ROTH**: the conditional Roth-theorem capstone
  from ext #40 (`RothCompleteHypotheses → RothTheorem`) is hereby
  reduced to a SINGLE-hypothesis conditional via ext #41's unconditional
  discharge of `RothBoundSmall`:

      `RothBoundLarge → RothTheorem`

  This is the actual frontier of T-5: only the Phase-7-chain
  Schmidt-Wirsing-Roth analytical bound (`RothBoundLarge`) remains
  to be discharged unconditionally.

  Two derivations:
  1. `T5_roth_partially_unconditional`: composes ext #40 + ext #41
  2. `T5_roth_partially_unconditional_explicit_form`: explicit
     RothTheorem-shaped statement under single hypothesis

  Per Escanor-Pride / Erdős-Primarch identity LOCK 2026-04-28:
  full prove mode, NO slim. NAMED hypotheses are intermediate
  steps to discharge — `RothBoundLarge` will be discharged
  unconditionally in s43-s50 via Phase-7 chain composition.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS,
  no slim approaches per Escanor-Pride/Erdős-Primarch identity LOCK.

  ## Step #316 (T-5) status

  Phase 7 ext #42 — PARTIAL UNCONDITIONAL Roth (1-hypothesis conditional).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundSmallDischarge

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothPartiallyUnconditional

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothTheoremClosure
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundSmallDischarge
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

/-! ## Partially unconditional Roth -/

/-- **🚨 Wave T5 session 559iiii — Partial unconditional Roth**.

    The 2-conjunct conditional `RothCompleteHypotheses → RothTheorem`
    from ext #40 reduces to a SINGLE-hypothesis conditional under
    ext #41's unconditional discharge of `RothBoundSmall`:

      `RothBoundLarge → RothTheorem`

    Used NON-VACUOUSLY: composes
    `T5_roth_conditional_closure_capstone` (ext #40) with
    `T5_roth_bound_small_unconditional` (ext #41). -/
theorem T5_roth_partially_unconditional
    (h_large : RothBoundLarge) :
    RothTheorem :=
  T5_roth_conditional_closure_capstone
    ⟨h_large, T5_roth_bound_small_unconditional⟩

/-- **🚨 Wave T5 session 559iiii — Partial unconditional Roth (explicit form)**.

    Explicit statement form of `T5_roth_partially_unconditional` —
    spells out the inner ∀ of `RothTheorem` for citation in
    downstream proofs. -/
theorem T5_roth_partially_unconditional_explicit_form
    (h_large : RothBoundLarge) :
    ∀ (α : ℝ), Irrational α → IsAlgebraic ℤ α →
      ∀ (ε : ℝ), 0 < ε →
      ∃ (C : ℝ), 0 < C ∧
        ∀ (q : ℚ), q ≠ 0 → (q : ℝ) ≠ α →
          C / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)| :=
  T5_roth_partially_unconditional h_large

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559iiii — T-5 Phase 7 ext #42:
    PARTIAL UNCONDITIONAL ROTH (1-hypothesis conditional)**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #42.

    🏆 ROTH REDUCED TO SINGLE NAMED HYPOTHESIS.

    Two derivations:
    1. `T5_roth_partially_unconditional` — `RothBoundLarge → RothTheorem`
    2. `T5_roth_partially_unconditional_explicit_form` — explicit ∀-shape

    Composition of:
    - ext #40 `T5_roth_conditional_closure_capstone`
      (`RothCompleteHypotheses → RothTheorem`)
    - ext #41 `T5_roth_bound_small_unconditional`
      (UNCONDITIONAL `RothBoundSmall`)

    The remaining hypothesis `RothBoundLarge` packages the
    Schmidt-Wirsing-Roth Phase-7 chain (multiIteratedPDeriv +
    matrix vanishing + analytical bound + integer non-vanishing).
    Discharge plan in s43-s50 (multi-session unconditional discharge):
    - s43: multiIteratedPDeriv on product monomials closed form
    - s44: bridge discharge for general I (Gap A FULL)
    - s45: multivariate Taylor expansion at α
    - s46: Schmidt index argument
    - s47: integer non-vanishing UNCONDITIONAL
    - s48: final contradiction → RothBoundLarge
    - s49: T5_roth_bound_large_unconditional theorem
    - s50: 🏆 UNCONDITIONAL RothTheorem

    Mathlib usage: composition of two existing ext theorems (ext #40
    + ext #41) — no new Mathlib lookup at this layer.

    Sub-lemma 235/N in T-1 (T-5 Phase 7 ext #42).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 partial-unconditional Roth — only
    one NAMED hypothesis remains for full Roth closure. Escanor Pride
    + Erdős Primarch — full prove mode, NO STUBS, NO slim. -/
theorem session_559iiii_T5_phase7_roth_partially_unconditional_headline :
    RothBoundLarge → RothTheorem :=
  T5_roth_partially_unconditional

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothPartiallyUnconditional
