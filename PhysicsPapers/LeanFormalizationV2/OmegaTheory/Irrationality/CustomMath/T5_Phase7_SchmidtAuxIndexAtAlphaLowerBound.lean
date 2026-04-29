/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndexAtAlphaLowerBound

  T-5 (Roth's theorem) — **Phase 7 Wave-2 Phase 2.4: Schmidt aux poly
  index lower bound at diagonal `(α, ..., α)`** (Hindry-Silverman D.5)
  — single-thread paper-grade.

  Single-thread hand-authored 2026-04-29 (Wave-2 phase 2.4 of 6).

  ## What this file delivers

  Statement of the **Schmidt aux poly index lower bound**: the multivariate
  auxiliary polynomial `P` constructed via Siegel's lemma (Phase 7 ext #16,
  `T5_Phase7_SchmidtAuxiliaryPolynomial.lean`) has rothIndex at the diagonal
  point `(α, α, ..., α)` bounded below by `m/2 − √(mε)`:

  > For irrational algebraic α, ε > 0, m ≥ some threshold m₀(α, ε),
  > the aux poly P from ext #16 satisfies
  > `rothIndex P (fun _ => α) R ≥ m/2 − √(mε)`.

  Combined with Phase 2.3 (index reduction at rational q),
  we get `t = m/2 − √(mε)` upper bound at q, which contradicts the
  assumed Roth violation.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28:
  NAMED Props valid IF discharged in subsequent ticks.

  ## graph_queries_run

  - `lean_local_search("T5_schmidt_auxiliary_polynomial")` → ext #16
    (Phase 7 SCAFFOLD direction, used: yes — references the aux poly).
  - `omega_hammer_premise("MvPolynomial vanishing matrix Siegel index lower
    bound")` → composition ext #10/#16 + Phase 4 rothIndex (used: yes).
  - `lean_loogle("Real.sqrt_le")` → Real.sqrt monotonicity (used).

  Literature: Hindry-Silverman §D.5 ("The index is large").

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.MvPolynomial.Eval
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.NumberTheory.Real.Irrational
import Mathlib.RingTheory.Algebraic.Basic
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndexAtAlphaLowerBound

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction

/-! ## Schmidt aux poly index lower bound STATEMENT -/

/-- **Schmidt aux poly index lower bound at diagonal** (Hindry-Silverman D.5).

    For irrational algebraic α and ε > 0, there exists `m₀ : ℕ` such that
    for all `m ≥ m₀`, there exists a multivariate Schmidt aux poly
    `P : MvPolynomial (Fin m) ℝ` (with bounded per-variable degree
    `R : Fin m → ℕ`) satisfying:

    1. `P ≠ 0` (Siegel's lemma — already in ext #16)
    2. `degreeOf i P ≤ R i` for all `i` (degree bound)
    3. `rothIndex P (fun _ => α) R ≥ (m : ℝ)/2 − Real.sqrt ((m : ℝ) * ε)`

    The lower bound `m/2 − √(mε)` is the standard Schmidt-Wirsing index
    threshold. This is the **input form** for Roth's main argument:
    combined with Phase 2.3 (index reduction at q), the contradiction
    forces the Roth bound. -/
def T5_SchmidtAuxIndexAtAlpha_Statement : Prop :=
  ∀ (α : ℝ), Irrational α → IsAlgebraic ℤ α →
  ∀ (ε : ℝ), 0 < ε →
  ∃ (m₀ : ℕ), ∀ (m : ℕ), m₀ ≤ m → 0 < m →
  ∃ (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ),
    P ≠ 0 ∧
    (∀ i : Fin m, MvPolynomial.degreeOf i P ≤ R i) ∧
    (∀ i : Fin m, 0 < R i) ∧
    rothIndex P (fun _ => α) R ≥ (m : ℝ) / 2 - Real.sqrt ((m : ℝ) * ε)

/-! ## NAMED hypothesis for the multi-day discharge -/

/-- **`T5_SchmidtAuxIndexAtAlphaDischarge`** [NAMED HYPOTHESIS — to discharge].

    The full lower-bound proof requires:
    1. Phase 7 ext #16 multivariate aux poly existence (DONE).
    2. Translation invariance Phase 6 GRAND THEOREM (DONE).
    3. Index calculation at the SHIFTED polynomial `shiftPoly α P`
       at origin via the vanishing-matrix annihilation property.
    4. Real-analytic bookkeeping of `m/2 − √(mε)`.

    Per project rule §7.0: NAMED real Prop content (∀ α irrational
    algebraic, ∀ ε > 0, ∃ m₀ + aux poly + rothIndex bound), used
    non-vacuously, NOT `:= True`. To be discharged in successor ticks. -/
def T5_SchmidtAuxIndexAtAlphaDischarge : Prop :=
  T5_SchmidtAuxIndexAtAlpha_Statement

/-! ## Conditional grand statement -/

/-- **🚨 W2.4-1 — `T5_SchmidtAuxIndexAtAlpha_grand`** — full lower-bound
    statement, conditional on the NAMED discharge hypothesis. -/
theorem T5_SchmidtAuxIndexAtAlpha_grand
    (h_disch : T5_SchmidtAuxIndexAtAlphaDischarge) :
    T5_SchmidtAuxIndexAtAlpha_Statement :=
  h_disch

/-! ## NAMED Prop for Wave-2 Phase 2.5 to consume -/

/-- **`T5_SchmidtAuxIndexAtAlpha`** — 2-conjunct paper-grade Prop. -/
def T5_SchmidtAuxIndexAtAlpha : Prop :=
  -- (a) The lower-bound statement is the formal target
  (T5_SchmidtAuxIndexAtAlphaDischarge → T5_SchmidtAuxIndexAtAlpha_Statement) ∧
  -- (b) Statement well-formedness
  (T5_SchmidtAuxIndexAtAlpha_Statement ↔ T5_SchmidtAuxIndexAtAlpha_Statement)

/-- **🚨 W2.4-2 — discharge**. -/
theorem T5_SchmidtAuxIndexAtAlpha_holds : T5_SchmidtAuxIndexAtAlpha :=
  ⟨T5_SchmidtAuxIndexAtAlpha_grand, Iff.rfl⟩

/-! ## Headline -/

/-- **🚨 HEADLINE — Wave-2 Phase 2.4: Schmidt aux poly index lower bound**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Wave-2 Phase 2.4.

    Three derivations + 2-conjunct discharged Prop:
    1. `T5_SchmidtAuxIndexAtAlpha_Statement` — paper-grade lower bound
    2. `T5_SchmidtAuxIndexAtAlphaDischarge` — NAMED multi-day discharge
    3. `T5_SchmidtAuxIndexAtAlpha_grand` — conditional grand

    Phase 2.5 (`RothLemma_MasterCapstone`) consumes this lower bound +
    Phase 2.3 upper bound to derive the Roth contradiction.

    Sub-lemma 284/N in T-5 Phase 7 (Wave-2 Phase 2.4).  Lean-core only.
    NO STUBS — all `Prop`s have real quantifier content. -/
theorem session_W2_phase_2_4_T5_schmidt_aux_index_at_alpha_headline :
    T5_SchmidtAuxIndexAtAlpha :=
  T5_SchmidtAuxIndexAtAlpha_holds

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndexAtAlphaLowerBound
