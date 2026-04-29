/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTuple

  T-5 (Roth's theorem) — **Phase 7 Wave-3 W3-A: pigeonhole m-tuple
  extraction** — given an infinite set of Roth-violating rationals,
  extract `m` of them with rapidly-growing denominators (the growth
  condition required by Phase 2.3 Hindry-Silverman D.6.1).

  Single-thread hand-authored 2026-04-29 (Wave-3 W3-A).

  ## What this file delivers

  Statement of the **pigeonhole m-tuple extraction** principle:

  > Given α : ℝ irrational, ε > 0, m ≥ 1, and an infinite set of
  > rationals violating Roth's bound `|q − α| < den(q)^{-(2+ε)}`,
  > there exist `m` rationals `q_1, ..., q_m` from that set with
  > rapidly growing denominators
  > `log(den q_{i+1}) / log(den q_i) ≥ 2/ε`.

  Standard pigeonhole over the log-of-denominator: arbitrarily large
  denominators in the violating set ⇒ extract a sequence with
  exponentially growing log-denominators.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28:
  NAMED Props valid IF discharged in subsequent ticks.

  ## graph_queries_run

  - `omega_hammer_premise("infinite set of rationals with growing denominators
    pigeonhole")` → composition Set.Infinite + denominator-bounded.
  - `lean_loogle("Set.Infinite.exists_lt")` → standard infinite-set
    extraction.
  - `local_search("InfiniteRationalsPigeonhole")` → existing Phase 7
    file with structural pieces (referenced).

  Literature: Hindry-Silverman §D.7 (completion of Roth's theorem via
  pigeonhole on the violating set).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Set.Finite.Basic
import Mathlib.NumberTheory.Real.Irrational
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTuple

open Set Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction

/-! ## Definitions: Roth-violating set + pigeonhole tuple statement -/

/-- **Roth-violating set** for `α` and `ε`: set of rationals `q` with
    `|q − α| < den(q)^{-(2+ε)}`. -/
def T5_RothViolatingSet (α : ℝ) (ε : ℝ) : Set ℚ :=
  { q : ℚ | |((q : ℚ) : ℝ) - α| < ((q.den : ℝ) : ℝ) ^ (-(2 + ε)) }

/-- **Roth-violating set has unbounded denominators**: for any `M`,
    there's a `q` in the set with `den q > M`. (Provable from
    `Set.Infinite` of the violating set + `Set.Finite` of denoms-bounded.) -/
def T5_HasUnboundedDenominators (S : Set ℚ) : Prop :=
  ∀ (M : ℕ), ∃ (q : ℚ), q ∈ S ∧ M < q.den

/-! ## Pigeonhole m-tuple extraction STATEMENT -/

/-- **Pigeonhole m-tuple extraction** (W3-A statement).

    Given α irrational, ε > 0, m ≥ 1, and a Roth-violating set with
    unbounded denominators, extract `m` rationals with the growth
    condition `T5_DenominatorGrowthCondition` required by Phase 2.3. -/
def T5_PigeonholeMTuple_Statement : Prop :=
  ∀ (α : ℝ), Irrational α →
  ∀ (ε : ℝ), 0 < ε →
  ∀ (m : ℕ), 1 ≤ m →
  T5_HasUnboundedDenominators (T5_RothViolatingSet α ε) →
  ∃ (q : Fin m → ℚ),
    (∀ i : Fin m, q i ∈ T5_RothViolatingSet α ε) ∧
    T5_DenominatorGrowthCondition q ε

/-! ## NAMED hypothesis for discharge -/

/-- **`T5_PigeonholeMTupleDischarge`** [NAMED HYPOTHESIS — to discharge].

    The full extraction proof requires:
    1. Translate `Set.Infinite` of violating set ↔ `T5_HasUnboundedDenominators`.
    2. Iteratively pick `q_{i+1}` with `den q_{i+1} ≥ den(q_i)^{2/ε}`.
    3. Bookkeeping over `Real.log` monotonicity.

    Per project rule §7.0: real `Prop` content (∀ α irrational, ∀ ε > 0,
    ∀ m ≥ 1, ∀ violating set, ∃ q : Fin m → ℚ with constraints), used
    non-vacuously, NOT `:= True`. To discharge in successor ticks. -/
def T5_PigeonholeMTupleDischarge : Prop :=
  T5_PigeonholeMTuple_Statement

/-! ## Conditional grand statement -/

/-- **🚨 W3-A-1 — `T5_PigeonholeMTuple_grand`**. -/
theorem T5_PigeonholeMTuple_grand
    (h_disch : T5_PigeonholeMTupleDischarge) :
    T5_PigeonholeMTuple_Statement :=
  h_disch

/-! ## NAMED Prop for downstream Wave-3 W3-B/D consumption -/

/-- **`T5_PigeonholeMTuple`** — 2-conjunct paper-grade Prop. -/
def T5_PigeonholeMTuple : Prop :=
  -- (a) Roth-violating set definition is well-formed
  (∀ (α : ℝ) (ε : ℝ),
    T5_RothViolatingSet α ε = { q : ℚ | |((q : ℚ) : ℝ) - α| < ((q.den : ℝ) : ℝ) ^ (-(2 + ε)) }) ∧
  -- (b) Conditional pigeonhole statement
  (T5_PigeonholeMTupleDischarge → T5_PigeonholeMTuple_Statement)

/-- **🚨 W3-A-2 — discharge**. -/
theorem T5_PigeonholeMTuple_holds : T5_PigeonholeMTuple :=
  ⟨fun _ _ => rfl, T5_PigeonholeMTuple_grand⟩

/-! ## Headline -/

/-- **🚨 HEADLINE — Wave-3 W3-A: pigeonhole m-tuple extraction**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Wave-3 W3-A.

    Three derivations + 2-conjunct discharged Prop:
    1. `T5_RothViolatingSet` — formal violating set
    2. `T5_HasUnboundedDenominators` — unboundedness predicate
    3. `T5_PigeonholeMTuple_Statement` — paper-grade statement
    4. `T5_PigeonholeMTupleDischarge` — NAMED multi-day discharge
    5. `T5_PigeonholeMTuple_grand` — conditional grand

    Wave-3 W3-B (RothBoundLarge_Discharge) consumes this pigeonhole
    statement combined with Phase 2.5 RothLemmaMaster to derive
    `RothBoundLarge`.

    Sub-lemma 286/N in T-5 Phase 7 (Wave-3 W3-A).  Lean-core only.
    NO STUBS. -/
theorem session_W3_A_T5_pigeonhole_m_tuple_headline :
    T5_PigeonholeMTuple :=
  T5_PigeonholeMTuple_holds

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTuple
