/-
  OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

  T-5 (Roth's theorem axiom retirement) — master integration session 73.
  Master statement of Roth's theorem in OV2-form, preparing for the
  Phase 2-5 attack.

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  **`RothTheoremStatement`** — the type-theoretic statement of Roth's
  theorem ready for proof in Phase 4:

  > For any irrational algebraic α : ℝ and any ε > 0, there exists C > 0
  > such that for all rationals p/q in lowest terms (q ≥ 1):
  >   `|α - p/q| > C / q^(2+ε)`

  ## Why this is the right form

  Roth's theorem is the CULMINATION of the auxiliary-polynomial +
  index-theorem + Wronskian machinery (Phases 2-3-4 of T-5 plan).
  Stating it cleanly here gives Phases 2-3-4 a concrete target.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
import OmegaTheory.Irrationality.CustomMath.T5_PolynomialIndex
import OmegaTheory.Irrationality.CustomMath.T5_DerivativeCharacterization

namespace OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_Liouville_Bound
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound

/-! ## Master Roth statement -/

/-- **Wave T4b session 73 — Roth's theorem master statement**.

    For any irrational algebraic α : ℝ and any ε > 0, there exists a
    constant C > 0 such that for every nonzero rational q with q ≠ α:

      `|α - (q : ℝ)| ≥ C / (Rat.naiveHeight q)^(2 + ε)`

    This is Roth's improvement over Liouville (which has exponent
    `f.natDegree`).

    PROOF: T-5 Phases 2-3-4 (auxiliary polynomial + index theorem +
    Wronskian + final contradiction). -/
def RothTheorem : Prop :=
  ∀ α : ℝ, Irrational α → IsAlgebraic ℤ α →
    ∀ ε : ℝ, 0 < ε →
      ∃ C : ℝ, 0 < C ∧ ∀ q : ℚ, q ≠ 0 → (q : ℝ) ≠ α →
        C / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)|

/-- **Wave T4b session 73 — Liouville → Roth implication direction**.

    Roth's theorem implies Liouville's bound (with exponent ≤ degree).
    The converse is NOT true (Roth is strictly stronger). -/
theorem Roth_implies_Liouville_form
    (h_roth : RothTheorem) :
    ∀ α : ℝ, Irrational α → IsAlgebraic ℤ α →
      ∃ C : ℝ, 0 < C ∧ ∀ q : ℚ, q ≠ 0 → (q : ℝ) ≠ α →
        C / ((Rat.naiveHeight q : ℝ) ^ 3) ≤ |α - (q : ℝ)| := by
  intros α hα h_alg
  -- Apply Roth with ε = 1 to get exponent 3
  obtain ⟨C, hC, h_bound⟩ := h_roth α hα h_alg 1 zero_lt_one
  refine ⟨C, hC, ?_⟩
  intros q hq hα_q
  -- 2 + 1 = 3
  have := h_bound q hq hα_q
  convert this using 2
  norm_num

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 73 — Roth master statement**.

    Provides:
    1. `RothTheorem` : the Prop encoding Roth's theorem.
    2. `Roth_implies_Liouville_form` : Roth → Liouville (degree-3 form).

    These give Phases 2-3-4 of T-5 a clear target. -/
theorem session_73_roth_master_headline :
    -- (1) Master statement defined
    (RothTheorem ↔
      ∀ α : ℝ, Irrational α → IsAlgebraic ℤ α →
        ∀ ε : ℝ, 0 < ε →
          ∃ C : ℝ, 0 < C ∧ ∀ q : ℚ, q ≠ 0 → (q : ℝ) ≠ α →
            C / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)|)
    -- (2) Implication direction
    ∧ (RothTheorem →
      ∀ α : ℝ, Irrational α → IsAlgebraic ℤ α →
        ∃ C : ℝ, 0 < C ∧ ∀ q : ℚ, q ≠ 0 → (q : ℝ) ≠ α →
          C / ((Rat.naiveHeight q : ℝ) ^ 3) ≤ |α - (q : ℝ)|) := by
  refine ⟨Iff.rfl, ?_⟩
  exact Roth_implies_Liouville_form

end OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement
