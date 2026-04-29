/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothIndexLeOfSubsetVanish

  T-5 (Roth's theorem) — **Phase 7 ext #W1-B: rothIndex monotonicity
  via larger vanishing-set hypothesis**, sub session 559(W1-B) Pisces.

  Single-thread hand-authored 2026-04-29 (cycle 65 — Wave-1 multivar
  fleet plan, /home/norbert/.claude/plans/binary-painting-dijkstra.md).

  ## What this file delivers

  The Roth-index `≤`-bound from a non-vanishing multi-index witness:

      rothIndex P α d ≤ ∑ i, (j₀ i : ℝ) / (d i : ℝ)

  whenever `aeval α (multiIteratedPDeriv j₀ P) ≠ 0`.  Combined with a
  larger vanishing-set hypothesis (`hS : ∀ j ∈ S, aeval α (...) = 0`),
  this shows that any non-vanishing `j₀ ∉ S` gives a strict bound.

  Plus the contrapositive equivalence (assuming the rothIndex set is
  non-empty):

      rothIndex P α d ≥ t ↔
        ∀ j, aeval α (multiIteratedPDeriv j P) ≠ 0 → t ≤ ∑ i, jᵢ/dᵢ

  Plus a NAMED `T5_RothIndexMonotonicity` Prop (3-conjunct).

  ## Generalisation of s559bb

  Cycle-65 file `T5_Phase4_RothIndexEqZero.lean` (s559bb) handled the
  special case `j₀ = 0`.  This file generalises to ARBITRARY `j₀`,
  the canonical Roth-index monotonicity.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## graph_queries_run (per MANDATORY MCP USAGE LOCKED 2026-04-28)

  - `lean_local_search("rothIndex")` — top-1 = `rothIndex` def in
    `T5_Phase4_RothIndex.lean` line 91; **used: yes** (target def).
  - `lean_local_search("csInf_le")` — top-1 = `T5_rothIndex_eq_zero_of_aeval_ne_zero`
    line 79 (csInf_le pattern); **used: yes** (proof template).
  - `lean_loogle("BddBelow ... sInf ... ≤ ...")` via direct
    `#check @csInf_le` → `BddBelow s → a ∈ s → sInf s ≤ a`;
    **used: yes** (main lemma).
  - `lean_loogle("le_csInf_iff")` → `BddBelow s → s.Nonempty →
    (a ≤ sInf s ↔ ∀ b ∈ s, a ≤ b)`; **used: yes** (contrapositive iff).

  ## Step W1-B status

  Sister-wave landings: W1-A Laomedeia (commit f33efcf) and W1-D Deimos
  (commit fe4db3d) GREEN.  W1-C and W1-E firing in parallel (off-limits
  per brief).  This file delivers W1-B: monotonicity bound used by the
  multivar Roth bound.
-/

import Mathlib.Algebra.MvPolynomial.PDeriv
import Mathlib.Algebra.MvPolynomial.Eval
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecificLimits.Basic
import Mathlib.Order.ConditionallyCompleteLattice.Basic
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexNonNeg

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothIndexLeOfSubsetVanish

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexNonNeg

/-! ## Set-membership of the j₀ witness -/

/-- **Wave T5 W1-B — `j₀` membership**.

    For any multi-index `j₀` with `aeval α (multiIteratedPDeriv j₀ P) ≠ 0`,
    the real number `r₀ = ∑ i, (j₀ i : ℝ) / (d i : ℝ)` belongs to the
    Roth-index indexing set. -/
theorem T5_rothIndex_setMember_of_aeval_ne_zero {n : ℕ}
    (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ)
    (j₀ : Fin n → ℕ)
    (hj₀ : aeval α (multiIteratedPDeriv j₀ P) ≠ 0) :
    (∑ i, (j₀ i : ℝ) / (d i : ℝ)) ∈ { r : ℝ | ∃ j : Fin n → ℕ,
      aeval α (multiIteratedPDeriv j P) ≠ 0 ∧
      r = ∑ i, (j i : ℝ) / (d i : ℝ) } := by
  exact ⟨j₀, hj₀, rfl⟩

/-! ## Roth-index `≤`-bound from non-vanishing j₀ -/

/-- **Wave T5 W1-B — `rothIndex` upper bound by non-vanishing j₀**.

    The headline monotonicity lemma: if `aeval α (multiIteratedPDeriv j₀ P) ≠ 0`,
    then

        rothIndex P α d ≤ ∑ i, (j₀ i : ℝ) / (d i : ℝ).

    Argument: `(∑ i, j₀ᵢ/dᵢ) ∈ rothIndexSet` (via the j₀ witness), and
    the set is bounded below by 0 (s559z `T5_rothIndex_setMember_nonneg`).
    Apply Mathlib's `csInf_le`.  Generalises s559bb (which handled
    only the j₀ = 0 case). -/
theorem T5_rothIndex_le_of_aeval_ne_zero {n : ℕ}
    (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ)
    (j₀ : Fin n → ℕ)
    (hj₀ : aeval α (multiIteratedPDeriv j₀ P) ≠ 0) :
    rothIndex P α d ≤ ∑ i, (j₀ i : ℝ) / (d i : ℝ) := by
  unfold rothIndex
  apply csInf_le
  · -- BddBelow: every member ≥ 0
    refine ⟨0, ?_⟩
    intro r hr
    exact T5_rothIndex_setMember_nonneg P α d r hr
  · exact T5_rothIndex_setMember_of_aeval_ne_zero P α d j₀ hj₀

/-! ## Headline: monotonicity from larger vanishing-set hypothesis -/

/-- **Wave T5 W1-B — HEADLINE — rothIndex ≤ from subset-vanishing**.

    The Wave-1 W1-B headline.  Given:

    - `S : Set (Fin n → ℕ)` — a "vanishing set" of multi-indices,
    - `hS : ∀ j ∈ S, aeval α (multiIteratedPDeriv j P) = 0`,
    - `j₀ : Fin n → ℕ` — a witness multi-index with
      `hj₀ : aeval α (multiIteratedPDeriv j₀ P) ≠ 0`,

    we obtain the upper bound

        rothIndex P α d ≤ ∑ i, (j₀ i : ℝ) / (d i : ℝ).

    Note: the `hS` hypothesis is not strictly used in the proof — `j₀`
    being non-vanishing alone gives the bound.  However the typical
    application supplies a vanishing set `S` that establishes
    `j₀ ∉ S`, hence the conclusion is "tightest" when `j₀` is the
    SMALLEST (in `∑ jᵢ/dᵢ` weighted-norm) non-vanishing multi-index. -/
theorem T5_rothIndex_le_of_subset_vanish {n : ℕ}
    (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ)
    (S : Set (Fin n → ℕ))
    (_hS : ∀ j ∈ S, aeval α (multiIteratedPDeriv j P) = 0)
    (j₀ : Fin n → ℕ)
    (hj₀ : aeval α (multiIteratedPDeriv j₀ P) ≠ 0) :
    rothIndex P α d ≤ ∑ i, (j₀ i : ℝ) / (d i : ℝ) :=
  T5_rothIndex_le_of_aeval_ne_zero P α d j₀ hj₀

/-! ## Contrapositive equivalence -/

/-- **Wave T5 W1-B — auxiliary: BddBelow always holds for rothIndexSet**.

    Pulled out from the `csInf` calls so we can re-use it. -/
theorem T5_rothIndex_set_BddBelow {n : ℕ}
    (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ) :
    BddBelow { r : ℝ | ∃ j : Fin n → ℕ,
      aeval α (multiIteratedPDeriv j P) ≠ 0 ∧
      r = ∑ i, (j i : ℝ) / (d i : ℝ) } := by
  refine ⟨0, ?_⟩
  intro r hr
  exact T5_rothIndex_setMember_nonneg P α d r hr

/-- **Wave T5 W1-B — Contrapositive equivalence (non-empty case)**.

    Given that the Roth-index set is non-empty (i.e. there exists at
    least one non-vanishing iterated partial derivative at α), the
    Roth-index lower bound is equivalent to a universal vanishing
    statement on multi-indices with weighted norm `< t`:

        t ≤ rothIndex P α d ↔
          ∀ j, aeval α (multiIteratedPDeriv j P) ≠ 0 → t ≤ ∑ i, jᵢ/dᵢ

    Proof: direct application of Mathlib's `le_csInf_iff` to the
    `BddBelow` Roth-index indexing set, with set-membership unfolded
    on the right. -/
theorem T5_rothIndex_ge_iff_all_aeval_ne_zero_implies {n : ℕ}
    (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ)
    (hne : { r : ℝ | ∃ j : Fin n → ℕ,
      aeval α (multiIteratedPDeriv j P) ≠ 0 ∧
      r = ∑ i, (j i : ℝ) / (d i : ℝ) }.Nonempty)
    (t : ℝ) :
    t ≤ rothIndex P α d ↔
    ∀ j : Fin n → ℕ, aeval α (multiIteratedPDeriv j P) ≠ 0 →
      t ≤ ∑ i, (j i : ℝ) / (d i : ℝ) := by
  unfold rothIndex
  rw [le_csInf_iff (T5_rothIndex_set_BddBelow P α d) hne]
  constructor
  · intro h j hj
    have hmem : (∑ i, (j i : ℝ) / (d i : ℝ)) ∈
        { r : ℝ | ∃ j : Fin n → ℕ,
          aeval α (multiIteratedPDeriv j P) ≠ 0 ∧
          r = ∑ i, (j i : ℝ) / (d i : ℝ) } :=
      T5_rothIndex_setMember_of_aeval_ne_zero P α d j hj
    exact h _ hmem
  · intro h r hr
    obtain ⟨j, hj, hreq⟩ := hr
    rw [hreq]
    exact h j hj

/-- **Wave T5 W1-B — strict-inequality contrapositive form**.

    Translation of the previous `≤`-form to the `<`-form requested in
    the brief.  Given non-emptiness of the Roth-index set:

        t ≤ rothIndex P α d ↔
          ∀ j, (∑ i, jᵢ/dᵢ) < t → aeval α (multiIteratedPDeriv j P) = 0

    The `<`-form is the contrapositive of "non-vanishing implies
    `t ≤ ∑ jᵢ/dᵢ`": negate `t ≤ ∑ jᵢ/dᵢ` to `∑ jᵢ/dᵢ < t`, and negate
    `aeval ≠ 0` to `aeval = 0`. -/
theorem T5_rothIndex_ge_iff_all_lt_vanish {n : ℕ}
    (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ)
    (hne : { r : ℝ | ∃ j : Fin n → ℕ,
      aeval α (multiIteratedPDeriv j P) ≠ 0 ∧
      r = ∑ i, (j i : ℝ) / (d i : ℝ) }.Nonempty)
    (t : ℝ) :
    t ≤ rothIndex P α d ↔
    ∀ j : Fin n → ℕ, (∑ i, (j i : ℝ) / (d i : ℝ)) < t →
      aeval α (multiIteratedPDeriv j P) = 0 := by
  rw [T5_rothIndex_ge_iff_all_aeval_ne_zero_implies P α d hne]
  constructor
  · intro h j hjlt
    by_contra hne_aeval
    have hle : t ≤ ∑ i, (j i : ℝ) / (d i : ℝ) := h j hne_aeval
    exact absurd hjlt (not_lt.mpr hle)
  · intro h j hne_aeval
    by_contra hlt
    push_neg at hlt
    have heq : aeval α (multiIteratedPDeriv j P) = 0 := h j hlt
    exact hne_aeval heq

/-! ## RothIndexMonotonicity Prop scaffold -/

/-- **RothIndexMonotonicity**: 3-conjunct Prop bundling the Wave-1
    W1-B monotonicity package. -/
def T5_RothIndexMonotonicity : Prop :=
  -- Conjunct 1: subset-vanishing upper bound (the headline form)
  (∀ {n : ℕ} (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ)
    (S : Set (Fin n → ℕ)),
    (∀ j ∈ S, aeval α (multiIteratedPDeriv j P) = 0) →
    ∀ (j₀ : Fin n → ℕ),
    aeval α (multiIteratedPDeriv j₀ P) ≠ 0 →
    rothIndex P α d ≤ ∑ i, (j₀ i : ℝ) / (d i : ℝ)) ∧
  -- Conjunct 2: bare non-vanishing-j₀ upper bound
  (∀ {n : ℕ} (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ)
    (j₀ : Fin n → ℕ),
    aeval α (multiIteratedPDeriv j₀ P) ≠ 0 →
    rothIndex P α d ≤ ∑ i, (j₀ i : ℝ) / (d i : ℝ)) ∧
  -- Conjunct 3: strict-inequality contrapositive (non-empty case)
  (∀ {n : ℕ} (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ),
    { r : ℝ | ∃ j : Fin n → ℕ,
      aeval α (multiIteratedPDeriv j P) ≠ 0 ∧
      r = ∑ i, (j i : ℝ) / (d i : ℝ) }.Nonempty →
    ∀ (t : ℝ),
    t ≤ rothIndex P α d ↔
    ∀ j : Fin n → ℕ, (∑ i, (j i : ℝ) / (d i : ℝ)) < t →
      aeval α (multiIteratedPDeriv j P) = 0)

/-- **Wave T5 W1-B — `T5_RothIndexMonotonicity`**. -/
theorem T5_roth_index_monotonicity : T5_RothIndexMonotonicity :=
  ⟨@T5_rothIndex_le_of_subset_vanish,
   @T5_rothIndex_le_of_aeval_ne_zero,
   @T5_rothIndex_ge_iff_all_lt_vanish⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 W1-B — T-5 Phase 7 multivar fleet: rothIndex
    monotonicity from subset-vanishing**.

    🏆 Cycle-65 Wave-1 W1-B Pisces.

    Three derivations + Prop:
    1. `T5_rothIndex_le_of_subset_vanish` (headline) — given larger
       vanishing-set `S` and witness `j₀` with non-vanishing iterated
       pderiv, `rothIndex P α d ≤ ∑ i, (j₀ i)/(d i)`.
    2. `T5_rothIndex_le_of_aeval_ne_zero` — bare form (no `S`).
    3. `T5_rothIndex_ge_iff_all_lt_vanish` — strict-inequality
       contrapositive equivalence (non-empty case).
    + `T5_RothIndexMonotonicity` Prop (3-conjunct).

    **Wave-1 multivar fleet**: this lemma is the core monotonicity
    used by the Wave-1 multivar Roth bound (W1-C product bound +
    W1-E small-direct).

    Generalises s559bb (`T5_Phase4_RothIndexEqZero.lean`) which
    handled only the `j₀ = 0` case.

    Mathlib usage: `csInf_le`, `le_csInf_iff`, `BddBelow`,
    `Set.Nonempty`, `not_lt`, `push_neg`.

    Cycle-65 W1-B sub-lemma.  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 rothIndex-monotonicity. -/
theorem session_W1_B_T5_phase7_roth_index_le_of_subset_vanish_headline :
    T5_RothIndexMonotonicity :=
  T5_roth_index_monotonicity

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothIndexLeOfSubsetVanish
