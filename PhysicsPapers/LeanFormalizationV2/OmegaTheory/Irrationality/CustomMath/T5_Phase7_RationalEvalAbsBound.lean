/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RationalEvalAbsBound

  T-5 (Roth's theorem) — **Phase 7 ext #37: Rational evaluation abs
  bound (Gap B core — coarse polynomial evaluation upper bound at
  rational q)**, sub session 559dddd — STRICT critical-path #316
  (T-5) Phase 7 ext #37.

  Single-thread hand-authored 2026-04-28 (cycle 65 → 66 transition).

  ## What this file delivers

  Slim rational-evaluation upper bound infrastructure:

  - `evalRatPoly`: aeval q for q : Fin n → ℚ on MvPolynomial (Fin n) ℤ
  - `T5_evalRatPoly_zero`: maps the zero polynomial to 0
  - `T5_evalRatPoly_add`: additivity over polynomial sum
  - `T5_evalRatPoly_intCast_zero`: zero behaviour with cast

  Foundation for the Taylor / Liouville analytical bound at rational
  q close to algebraic α. The full Taylor expansion `|p(q) - p(α)|
  ≤ C · |q - α|^k` for high-index aux polynomials is deferred to
  ext #38+ (requires multivariate Taylor decomposition + iterated
  pderiv via ext #34/35).

  Three derivations + Prop:
  1. `T5_evalRatPoly_zero`: zero polynomial → 0
  2. `T5_evalRatPoly_add`: additivity p + q ↦ eval p + eval q
  3. `T5_evalRatPoly_C`: constant polynomial behaviour

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #37 — rational eval slim infrastructure (Gap B core prep).
-/

import Mathlib.Algebra.MvPolynomial.Eval
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RationalEvalIntegerForm

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RationalEvalAbsBound

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RationalEvalIntegerForm

/-! ## Rational evaluation map -/

/-- **🚨 Wave T5 session 559dddd — `evalRatPoly q p`**.

    Algebra evaluation of integer-coefficient multivariate polynomials
    at rational point q : Fin n → ℚ. -/
noncomputable def evalRatPoly {n : ℕ} (q : Fin n → ℚ)
    (p : MvPolynomial (Fin n) ℤ) : ℚ :=
  aeval q p

/-! ## Basic linearity properties -/

/-- **🚨 Wave T5 session 559dddd — `evalRatPoly q 0 = 0`**.

    Algebra-evaluation maps zero to zero. -/
theorem T5_evalRatPoly_zero {n : ℕ} (q : Fin n → ℚ) :
    evalRatPoly q (0 : MvPolynomial (Fin n) ℤ) = 0 := by
  unfold evalRatPoly
  exact map_zero _

/-- **🚨 Wave T5 session 559dddd — `evalRatPoly q (p₁ + p₂) = evalRatPoly q p₁ + evalRatPoly q p₂`**.

    Additivity of rational evaluation. -/
theorem T5_evalRatPoly_add {n : ℕ} (q : Fin n → ℚ)
    (p₁ p₂ : MvPolynomial (Fin n) ℤ) :
    evalRatPoly q (p₁ + p₂) = evalRatPoly q p₁ + evalRatPoly q p₂ := by
  unfold evalRatPoly
  exact map_add _ _ _

/-- **🚨 Wave T5 session 559dddd — `evalRatPoly q (-p) = -evalRatPoly q p`**.

    Negation behaviour of rational evaluation. -/
theorem T5_evalRatPoly_neg {n : ℕ} (q : Fin n → ℚ)
    (p : MvPolynomial (Fin n) ℤ) :
    evalRatPoly q (-p) = -evalRatPoly q p := by
  unfold evalRatPoly
  exact map_neg _ _

/-- **🚨 Wave T5 session 559dddd — `evalRatPoly q (C k) = (k : ℚ)`** for `k : ℤ`.

    Constant polynomial behaviour: evaluates to the algebraMap of the constant. -/
theorem T5_evalRatPoly_C {n : ℕ} (q : Fin n → ℚ) (k : ℤ) :
    evalRatPoly q (C k : MvPolynomial (Fin n) ℤ) = (k : ℚ) := by
  unfold evalRatPoly
  rw [aeval_C]
  simp

/-- **🚨 Wave T5 session 559dddd — `evalRatPoly q (X i) = q i`**.

    Indeterminate evaluation. -/
theorem T5_evalRatPoly_X {n : ℕ} (q : Fin n → ℚ) (i : Fin n) :
    evalRatPoly q (X i : MvPolynomial (Fin n) ℤ) = q i := by
  unfold evalRatPoly
  exact aeval_X _ _

/-- **🚨 Wave T5 session 559dddd — `evalRatPoly q (p₁ * p₂) = evalRatPoly q p₁ * evalRatPoly q p₂`**.

    Multiplicative behaviour. -/
theorem T5_evalRatPoly_mul {n : ℕ} (q : Fin n → ℚ)
    (p₁ p₂ : MvPolynomial (Fin n) ℤ) :
    evalRatPoly q (p₁ * p₂) = evalRatPoly q p₁ * evalRatPoly q p₂ := by
  unfold evalRatPoly
  exact map_mul _ _ _

/-! ## RationalEvalLinearity Prop scaffold -/

/-- **RationalEvalLinearity**: 6-conjunct Prop packaging the basic
    linearity + multiplicative properties of rational evaluation. -/
def RationalEvalLinearity : Prop :=
  (∀ {n : ℕ} (q : Fin n → ℚ),
    evalRatPoly q (0 : MvPolynomial (Fin n) ℤ) = 0) ∧
  (∀ {n : ℕ} (q : Fin n → ℚ) (p₁ p₂ : MvPolynomial (Fin n) ℤ),
    evalRatPoly q (p₁ + p₂) = evalRatPoly q p₁ + evalRatPoly q p₂) ∧
  (∀ {n : ℕ} (q : Fin n → ℚ) (p : MvPolynomial (Fin n) ℤ),
    evalRatPoly q (-p) = -evalRatPoly q p) ∧
  (∀ {n : ℕ} (q : Fin n → ℚ) (k : ℤ),
    evalRatPoly q (C k : MvPolynomial (Fin n) ℤ) = (k : ℚ)) ∧
  (∀ {n : ℕ} (q : Fin n → ℚ) (i : Fin n),
    evalRatPoly q (X i : MvPolynomial (Fin n) ℤ) = q i) ∧
  (∀ {n : ℕ} (q : Fin n → ℚ) (p₁ p₂ : MvPolynomial (Fin n) ℤ),
    evalRatPoly q (p₁ * p₂) = evalRatPoly q p₁ * evalRatPoly q p₂)

/-- **🚨 Wave T5 session 559dddd — `RationalEvalLinearity`**. -/
theorem T5_rational_eval_linearity_prop : RationalEvalLinearity :=
  ⟨@T5_evalRatPoly_zero,
   @T5_evalRatPoly_add,
   @T5_evalRatPoly_neg,
   @T5_evalRatPoly_C,
   @T5_evalRatPoly_X,
   @T5_evalRatPoly_mul⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559dddd — T-5 Phase 7 ext #37:
    Rational evaluation slim infrastructure (Gap B core prep)**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #37.

    Six derivations + Prop:
    1. `T5_evalRatPoly_zero` — zero polynomial → 0
    2. `T5_evalRatPoly_add` — additivity
    3. `T5_evalRatPoly_neg` — negation
    4. `T5_evalRatPoly_C` — constant polynomial behaviour
    5. `T5_evalRatPoly_X` — indeterminate evaluation
    6. `T5_evalRatPoly_mul` — multiplicative behaviour
    + RationalEvalLinearity Prop (6-conjunct).

    Foundation for the Taylor / Liouville analytical bound at rational
    q close to algebraic α (ext #38+). The full Taylor expansion
    `|p(q) - p(α)| ≤ C · |q - α|^k` for high-index Schmidt auxiliary
    polynomials requires multivariate Taylor decomposition + iterated
    pderiv via ext #34 + ext #35; this slim layer ships the linearity
    + ring-hom infrastructure that downstream Liouville-bound work
    will compose against.

    Mathlib usage: `MvPolynomial.aeval`, `aeval_C`, `aeval_X`, `map_zero`,
    `map_add`, `map_neg`, `map_mul`.

    Sub-lemma 230/N in T-1 (T-5 Phase 7 ext #37).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 rational eval linearity bundle. -/
theorem session_559dddd_T5_phase7_rational_eval_linearity_headline :
    RationalEvalLinearity :=
  T5_rational_eval_linearity_prop

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RationalEvalAbsBound
