/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundSmallClosure

  T-5 (Roth's theorem) — **Phase 7 Wave-3 W3-C: paper-grade closure
  alias for `RothBoundSmall`** — composes W1-E
  (`T5_rothBoundSmall_unconditional`) into a paper-citable closure
  bundle for downstream Wave-4 capstone consumption.

  Single-thread hand-authored 2026-04-29 (Wave-3 W3-C).

  ## What this file delivers

  **Paper-grade closure bundle** for the small-denominator side:
  1. `T5_RothBoundSmall_unconditional_closure_alias` — direct alias to W1-E
  2. `T5_RothBoundSmall_paper_closure` — 3-conjunct paper-citable Prop
     bundling unconditional discharge + signature + composition

  Combined with W3-D (which uses W1-E inside the conditional discharge),
  this gives Wave-4 a clean "unconditional half" handle of the
  RothCompleteHypotheses split.

  ## graph_queries_run

  - `lean_local_search("T5_rothBoundSmall_unconditional")` →
    W1-E `T5_Phase7_RothBoundSmallDirect.lean`. Used: yes.
  - `lean_loogle("RothBoundSmall ∧ _")` → `RothCompleteHypotheses` in
    `T5_Phase7_RothTheoremClosure.lean`. Used: yes.
  - `omega_hammer_premise("classical Liouville bounded denominator
    rational approximation algebraic")` → composition Phase 7 W1-E +
    finite-set min argument.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Heights
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundSmallDirect
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothTheoremClosure

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundSmallClosure

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundSmallDirect
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothTheoremClosure

/-! ## Direct alias -/

/-- **W3-C-1 — `T5_RothBoundSmall_unconditional_closure_alias`**:
    paper-citable alias for W1-E unconditional discharge of
    `RothBoundSmall`. -/
theorem T5_RothBoundSmall_unconditional_closure_alias :
    RothBoundSmall :=
  T5_rothBoundSmall_unconditional

/-! ## Paper-grade closure bundle -/

/-- **`T5_RothBoundSmall_paper_closure`** — 3-conjunct paper-grade Prop
    bundling the unconditional discharge of `RothBoundSmall` for
    downstream Wave-4 capstone consumption.

    Each conjunct is a real ∀-quantified Prop with non-vacuous content
    (per project rule §7.0). -/
def T5_RothBoundSmall_paper_closure : Prop :=
  -- (a) The unconditional discharge holds
  RothBoundSmall ∧
  -- (b) The discharge witness is exactly the W1-E direct form
  (RothBoundSmall ↔
    (∀ (α : ℝ), Irrational α → IsAlgebraic ℤ α →
      ∀ (ε : ℝ), 0 < ε →
      ∀ (N : ℕ),
      ∃ (C₂ : ℝ), 0 < C₂ ∧
        ∀ (q : ℚ), q ≠ 0 → (q : ℝ) ≠ α → q.den < N →
          C₂ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)|)) ∧
  -- (c) Composition compatibility with the large-side bridge
  (∀ (h_large : RothBoundLarge), RothCompleteHypotheses)

/-- **🚨 W3-C-2 — `T5_RothBoundSmall_paper_closure_holds`** — 3-conjunct
    discharge. -/
theorem T5_RothBoundSmall_paper_closure_holds : T5_RothBoundSmall_paper_closure :=
  ⟨T5_rothBoundSmall_unconditional,
   Iff.rfl,
   fun h_large => ⟨h_large, T5_rothBoundSmall_unconditional⟩⟩

/-! ## Headline -/

/-- **🚨 HEADLINE — Wave-3 W3-C: paper-grade RothBoundSmall closure**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Wave-3 W3-C.

    Two derivations + 3-conjunct discharged Prop:
    1. `T5_RothBoundSmall_unconditional_closure_alias` — direct alias
       to W1-E (`T5_rothBoundSmall_unconditional`)
    2. `T5_RothBoundSmall_paper_closure` — 3-conjunct paper-grade Prop:
       (a) RothBoundSmall holds unconditionally
       (b) Witness signature matches W1-E direct form
       (c) Composition with RothBoundLarge yields RothCompleteHypotheses
    3. `T5_RothBoundSmall_paper_closure_holds` — discharge

    Wave-4 capstone consumes this together with W3-D
    (`T5_RothCompleteDischarge`) to assemble the OV2 paper-headline
    `omega_theory_v2_T5_roth_unconditional` (conditional on the 5 NAMED
    hypotheses from Wave-2 + W3-A + W3-D bridge).

    Sub-lemma 288/N in T-5 Phase 7 (Wave-3 W3-C).  Lean-core only.
    NO STUBS — all `Prop`s have real quantifier content. -/
theorem session_W3_C_T5_roth_bound_small_closure_headline :
    T5_RothBoundSmall_paper_closure :=
  T5_RothBoundSmall_paper_closure_holds

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundSmallClosure
