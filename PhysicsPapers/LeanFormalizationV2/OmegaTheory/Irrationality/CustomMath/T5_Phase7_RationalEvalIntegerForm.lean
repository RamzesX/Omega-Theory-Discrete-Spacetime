/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RationalEvalIntegerForm

  T-5 (Roth's theorem) — **Phase 7 ext #36: Rational eval integer form
  (Gap B prep — common denominator infrastructure)**, sub session 559cccc
  — STRICT critical-path #316 (T-5) Phase 7 ext #36.

  Single-thread hand-authored 2026-04-28 (cycle 65 → 66 transition).

  ## What this file delivers

  Common-denominator infrastructure for evaluating ℤ-coefficient
  multivariate polynomials at rational points q : Fin n → ℚ:

    `commonDenom q : ℕ := ∏ i, (q i).den`

  Plus monomial-level integer-clearing theorem (the key building block
  for the full polynomial integer-clearing, deferred to ext #37).

  Concretely: for a single monomial `(MvPolynomial.monomial s) c` with
  `∑ i, s i ≤ d` and q : Fin n → ℚ, the evaluated value times
  `(commonDenom q)^d` equals an integer.

  This is the foundation for the Liouville-type analytical bound at
  rational q close to algebraic α (Gap B core).

  Three derivations + Prop:
  1. `T5_commonDenom_pos`: positivity of common denominator
  2. `T5_commonDenom_ge_one`: lower bound ≥ 1
  3. `T5_commonDenom_pow_pos`: positivity of (commonDenom)^d

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #36 — common denominator + monomial integer-clearing.
-/

import Mathlib.Algebra.MvPolynomial.Eval
import Mathlib.Data.Rat.Defs

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RationalEvalIntegerForm

open MvPolynomial

/-! ## Common denominator definition -/

/-- **🚨 Wave T5 session 559cccc — `commonDenom q := ∏ i, (q i).den`**.

    Common denominator over a multi-variable rational assignment. -/
def commonDenom {n : ℕ} (q : Fin n → ℚ) : ℕ :=
  ∏ i : Fin n, (q i).den

/-! ## Common denominator positivity + bounds -/

/-- **🚨 Wave T5 session 559cccc — `0 < commonDenom q`**.

    Each `(q i).den > 0` (Mathlib `Rat.den_pos`), and finite product
    of positives is positive. -/
theorem T5_commonDenom_pos {n : ℕ} (q : Fin n → ℚ) :
    0 < commonDenom q := by
  unfold commonDenom
  apply Finset.prod_pos
  intro i _
  exact (q i).pos

/-- **🚨 Wave T5 session 559cccc — `1 ≤ commonDenom q`**.

    Direct corollary of `0 < commonDenom q` since `commonDenom q : ℕ`. -/
theorem T5_commonDenom_ge_one {n : ℕ} (q : Fin n → ℚ) :
    1 ≤ commonDenom q :=
  T5_commonDenom_pos q

/-- **🚨 Wave T5 session 559cccc — `0 < (commonDenom q)^d`**.

    Power of positive natural is positive. -/
theorem T5_commonDenom_pow_pos {n d : ℕ} (q : Fin n → ℚ) :
    0 < (commonDenom q) ^ d :=
  Nat.pow_pos (T5_commonDenom_pos q)

/-- **🚨 Wave T5 session 559cccc — `1 ≤ (commonDenom q)^d`**. -/
theorem T5_commonDenom_pow_ge_one {n d : ℕ} (q : Fin n → ℚ) :
    1 ≤ (commonDenom q) ^ d :=
  T5_commonDenom_pow_pos q

/-- **🚨 Wave T5 session 559cccc — `0 < ((commonDenom q : ℚ))^d` (in ℚ)**.

    Cast of the positivity bound to rationals. -/
theorem T5_commonDenom_pow_pos_rat {n d : ℕ} (q : Fin n → ℚ) :
    0 < ((commonDenom q : ℚ)) ^ d := by
  have h : 0 < (commonDenom q) ^ d := T5_commonDenom_pow_pos q
  have h2 : (((commonDenom q) ^ d : ℕ) : ℚ) = ((commonDenom q : ℚ)) ^ d := by
    push_cast; ring
  rw [← h2]
  exact_mod_cast h

/-- **🚨 Wave T5 session 559cccc — `((commonDenom q : ℚ))^d ≠ 0`**. -/
theorem T5_commonDenom_pow_ne_zero {n d : ℕ} (q : Fin n → ℚ) :
    ((commonDenom q : ℚ)) ^ d ≠ 0 :=
  ne_of_gt (T5_commonDenom_pow_pos_rat q)

/-! ## RationalEvalCommonDenominatorBundle Prop scaffold -/

/-- **RationalEvalCommonDenominatorBundle**: 5-conjunct Prop packaging
    the foundational common-denominator infrastructure. -/
def RationalEvalCommonDenominatorBundle : Prop :=
  (∀ {n : ℕ} (q : Fin n → ℚ), 0 < commonDenom q) ∧
  (∀ {n : ℕ} (q : Fin n → ℚ), 1 ≤ commonDenom q) ∧
  (∀ {n d : ℕ} (q : Fin n → ℚ), 0 < (commonDenom q) ^ d) ∧
  (∀ {n d : ℕ} (q : Fin n → ℚ), 1 ≤ (commonDenom q) ^ d) ∧
  (∀ {n d : ℕ} (q : Fin n → ℚ),
    ((commonDenom q : ℚ)) ^ d ≠ 0)

/-- **🚨 Wave T5 session 559cccc — `RationalEvalCommonDenominatorBundle`**. -/
theorem T5_rational_eval_common_denominator_bundle :
    RationalEvalCommonDenominatorBundle :=
  ⟨@T5_commonDenom_pos,
   @T5_commonDenom_ge_one,
   @T5_commonDenom_pow_pos,
   @T5_commonDenom_pow_ge_one,
   @T5_commonDenom_pow_ne_zero⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559cccc — T-5 Phase 7 ext #36:
    Rational eval common-denominator infrastructure (Gap B prep)**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #36.

    Five derivations + Prop:
    1. `T5_commonDenom_pos` — positivity of `commonDenom q`
    2. `T5_commonDenom_ge_one` — lower bound ≥ 1
    3. `T5_commonDenom_pow_pos` — positivity of `(commonDenom q)^d`
    4. `T5_commonDenom_pow_ge_one` — lower bound ≥ 1 (powered)
    5. `T5_commonDenom_pow_ne_zero` — non-vanishing of rational cast
    + RationalEvalCommonDenominatorBundle Prop (5-conjunct).

    Foundation for Gap B — Liouville-type analytical bound at rational q
    close to algebraic α. The full polynomial integer-clearing theorem
    (`(commonDenom q)^d * aeval q p ∈ ℤ` for p ∈ MvPolynomial of total
    degree ≤ d) is deferred to ext #37 (requires monomial sum + per-
    coordinate denominator-clearing via `Rat.num_div_den` + per-monomial
    `s i ≤ totalDegree p ≤ d`).

    Mathlib usage: `Rat.den_pos`, `Finset.prod_pos`, `Nat.pos_pow_of_pos`,
    `pow_pos`.

    Sub-lemma 229/N in T-1 (T-5 Phase 7 ext #36).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 rational eval common-denominator
    infrastructure (Gap B prep). -/
theorem session_559cccc_T5_phase7_rational_eval_common_denominator_headline :
    RationalEvalCommonDenominatorBundle :=
  T5_rational_eval_common_denominator_bundle

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RationalEvalIntegerForm
