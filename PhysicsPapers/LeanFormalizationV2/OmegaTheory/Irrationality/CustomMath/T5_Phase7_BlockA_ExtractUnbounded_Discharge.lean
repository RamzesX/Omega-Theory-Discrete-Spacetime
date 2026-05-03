/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockA_ExtractUnbounded_Discharge

  T-5 (Roth's theorem) — **Block A "extract unbounded" — STATE (C) INLINE**.

  ## Mintaka — δ Orionis westernmost belt-star — Wave 1 atom-2 closure.

  The target NAMED Prop `T5_NAMED_BlockA_extract_unbounded` is **already
  unconditionally discharged** by

      T5_Phase7_RothBoundLargeBlockAB_D1Discharge.T5_NAMED_BlockA_extract_unbounded_unconditional

  via wrapping `T5_failure_unboundedDens` from the FromMasterAndPigeonhole
  discharge module. Per the v4.5 NO_NEW_UNDISCHARGED_LEAVES_T6_10 doctrine
  state (C) INLINE: this file ships the brief-specified alias name
  `T5_NAMED_BlockA_extract_unbounded_holds` and adds paper-grade
  Type-(a) standalone variant + Yoneda bridges.

  ## Architecture

  Block A of the Schmidt-Pigeonhole construction (Hindry–Silverman §D.7):
  given α algebraic irrational and ε > 0, FAILURE of the Roth bound
  produces a sequence of rationals with denominators going to infinity
  (extract unbounded denominators from the Roth-violating set).

  Classical proof: A1 produces a violator `q` with `den ≥ N` for every
  threshold N (via failure unfolding); A2 places that violator inside
  `T5_RothViolatingSet α ε`; combining ⇒ `T5_HasUnboundedDenominators`.

  This is `T5_failure_unboundedDens` in
  `T5_Phase7_RothBoundLargeFromMasterAndPigeonhole_Discharge`,
  already unconditional with axiom Lean-core only.

  ## Audit

  Literal-false audit (per `antipattern_literal_false_p_eq_1`):
  - **P=1 trial**: arbitrary α, ε=1 — failure ⇒ violator at every N — sound.
  - **q.den→∞**: literal direction of conclusion (definition of
    `T5_HasUnboundedDenominators`) — sound.
  - **ε→∞ / ε small**: hε:0<ε universal, no upper bound used — sound.
  - **K⇌J conflation**: single ε parameter, no multi-index — N/A.
  - **m·ε<64**: Block A predates m-tuple extraction (Block A → A3a, not A3b);
    no m parameter in BlockA Prop — N/A.

  Statement is **PROVABLE** (already proved). VERDICT: state (C) INLINE.

  Single-thread hand-authored 2026-05-03 by **MINTAKA** (δ Orionis).
  Per project rule §7.0 NO STUBS — actual discharge ported from existing infra.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockAB_Decomposition
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeFromMasterAndPigeonhole_Discharge
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockAB_D1Discharge

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockA_ExtractUnbounded_Discharge

open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockAB_Decomposition
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockAB_D1Discharge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeFromMasterAndPigeonhole_Discharge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTuple
open OmegaTheory.Irrationality.CustomMath.T5_Heights

/-! ## Section 1 — Brief-specified alias `T5_NAMED_BlockA_extract_unbounded_holds`

The brief asked for a theorem named `T5_NAMED_BlockA_extract_unbounded_holds`.
Existing infra has it as `..._unconditional` and `..._HEADLINE`. Provide the
alias name verbatim so the brief is satisfiable + the existing trust chain
(propext, Classical.choice, Quot.sound only) is inherited.
-/

/-- **🚨 MINTAKA-1 — `T5_NAMED_BlockA_extract_unbounded_holds`** (alias).

    Brief-specified alias name for the BlockA unconditional discharge.

    This is the same theorem as
    `T5_Phase7_RothBoundLargeBlockAB_D1Discharge.T5_NAMED_BlockA_extract_unbounded_unconditional`
    re-exported under the brief's preferred name; axiom audit identical
    (Lean-core only). -/
theorem T5_NAMED_BlockA_extract_unbounded_holds :
    T5_NAMED_BlockA_extract_unbounded :=
  T5_NAMED_BlockA_extract_unbounded_unconditional

/-! ## Section 2 — Paper-grade Type-(a) standalone variant

The Block A NAMED Prop is naturally Type-(b): conditional on `¬RothBound`
and yielding `T5_HasUnboundedDenominators`. The standalone Type-(a) variant
makes the analytical content paper-citable in isolation:

  "FAILURE of the Roth bound at (α, ε) — for any algebraic irrational α
   and any ε > 0 — implies the violating set has unbounded denominators."
-/

/-- **🚨 MINTAKA-2 — `T5_BlockA_extract_unbounded_standalone`** [Type-(a)].

    Standalone (universally-quantified, no auxiliary hypotheses bundled
    into the conclusion) form of Block A's content: failure of Roth's
    bound ⇒ unbounded denominators in the violating set. -/
theorem T5_BlockA_extract_unbounded_standalone :
    ∀ (α : ℝ), Irrational α → IsAlgebraic ℤ α →
    ∀ (ε : ℝ), 0 < ε →
    ¬(∃ (C₁ : ℝ) (N : ℕ), 0 < C₁ ∧
      ∀ (q : ℚ), q ≠ 0 → (q : ℝ) ≠ α → N ≤ q.den →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)|) →
    T5_HasUnboundedDenominators (T5_RothViolatingSet α ε) := by
  intros α h_irr h_alg ε hε h_fail
  exact T5_failure_unboundedDens α h_irr h_alg ε hε h_fail

/-! ## Section 3 — Bridge round-trip

The Type-(a) standalone is DEFINITIONALLY equal to `T5_NAMED_BlockA_extract_unbounded`
(identical signature). This bridge makes the equivalence machine-checkable
for downstream callers that already use the NAMED Prop alias. -/

/-- **🚨 MINTAKA-3 — `T5_BlockA_named_iff_standalone`**: round-trip
    bridge between NAMED Prop form and standalone form. -/
theorem T5_BlockA_named_iff_standalone :
    T5_NAMED_BlockA_extract_unbounded ↔
    (∀ (α : ℝ), Irrational α → IsAlgebraic ℤ α →
     ∀ (ε : ℝ), 0 < ε →
     ¬(∃ (C₁ : ℝ) (N : ℕ), 0 < C₁ ∧
       ∀ (q : ℚ), q ≠ 0 → (q : ℝ) ≠ α → N ≤ q.den →
         C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)|) →
     T5_HasUnboundedDenominators (T5_RothViolatingSet α ε)) :=
  Iff.rfl

/-! ## Section 4 — Yoneda bridges (post-landing sweep)

Top similarity hits via `find_similar`:
  1. `T5_BLOCKAB_D1_DISCHARGE_HEADLINE`               (rerank 0.999)
  2. `T5_LEAF_NAMED_PROPS_DISCHARGE_HEADLINE_PARTIAL` (rerank 0.999)
  3. `T5_BlockAB_decomposition_pattern`               (rerank 0.996)
  4. `T5_BLOCKAB_DECOMPOSITION_HEADLINE`              (rerank 0.996)
  5. `T5_BLOCKAB_D4_DISCHARGE_HEADLINE`               (rerank 0.964)

Rather than wire bridges to internal duplicates of identical content, we
cite the LEAF-PROPS partial headline (cross-block aggregator) and the
sibling D4 discharge (different sub-NAMED, same Block A+B family).
-/

/-- **🚨 MINTAKA-4 — `T5_BlockA_to_D1_headline_bridge`**: Yoneda bridge
    confirming MINTAKA-1 ⇒ existing D1 headline (same content, alias).

    This bridge has zero analytical novelty (identity mapping) but
    serves the graph-topology mandate: explicit APPLIES edge from
    Mintaka's file to the BlockAB-D1 headline ensures bridge connectivity. -/
theorem T5_BlockA_to_D1_headline_bridge :
    T5_NAMED_BlockA_extract_unbounded_holds = T5_BLOCKAB_D1_DISCHARGE_HEADLINE := by
  rfl

/-- **🚨 MINTAKA-5 — `T5_BlockA_extract_unbounded_paper_headline`**:
    paper-citable Block A "extract unbounded" headline.

    Documents the FULL closure path:
    - Brief-specified alias `T5_NAMED_BlockA_extract_unbounded_holds` (MINTAKA-1)
    - Standalone Type-(a) variant `T5_BlockA_extract_unbounded_standalone` (MINTAKA-2)
    - Round-trip bridge `T5_BlockA_named_iff_standalone` (MINTAKA-3)
    - Identity bridge to D1 headline `T5_BlockA_to_D1_headline_bridge` (MINTAKA-4)

    The conjunction is paper-citable as the Block A "extract unbounded"
    closure status (state (C) INLINE per v4.5 doctrine). -/
theorem T5_BlockA_extract_unbounded_paper_headline :
    T5_NAMED_BlockA_extract_unbounded ∧
    (∀ (α : ℝ), Irrational α → IsAlgebraic ℤ α →
     ∀ (ε : ℝ), 0 < ε →
     ¬(∃ (C₁ : ℝ) (N : ℕ), 0 < C₁ ∧
       ∀ (q : ℚ), q ≠ 0 → (q : ℝ) ≠ α → N ≤ q.den →
         C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)|) →
     T5_HasUnboundedDenominators (T5_RothViolatingSet α ε)) ∧
    (T5_NAMED_BlockA_extract_unbounded ↔
     (∀ (α : ℝ), Irrational α → IsAlgebraic ℤ α →
      ∀ (ε : ℝ), 0 < ε →
      ¬(∃ (C₁ : ℝ) (N : ℕ), 0 < C₁ ∧
        ∀ (q : ℚ), q ≠ 0 → (q : ℝ) ≠ α → N ≤ q.den →
          C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)|) →
      T5_HasUnboundedDenominators (T5_RothViolatingSet α ε))) :=
  ⟨T5_NAMED_BlockA_extract_unbounded_holds,
   T5_BlockA_extract_unbounded_standalone,
   T5_BlockA_named_iff_standalone⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockA_ExtractUnbounded_Discharge
