/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase6_BindOneShift

  T-5 (Roth's theorem) — **Phase 6 ENTRY: bind₁ affine shift +
  pderiv chain rule**, sub session 559pp — STRICT critical-path
  #316 (T-5) Phase 6 ENTRY.

  Single-thread hand-authored 2026-04-28 (cycle 65 — /loop dynamic).
  Per opus-code-crawler intel today: the chain rule
  `pderiv_bind₁_shift` is NOT in Mathlib v4.29 — must port via
  `MvPolynomial.induction_on` (mirrors `pderiv_rename` pattern).

  ## What this file delivers

  Chain-rule infrastructure for the affine-shift translation
  `g i = X i + C (γ i)`:

  1. `T5_pderiv_bind₁_shift` — `pderiv b ∘ bind₁ g = bind₁ g ∘ pderiv b`
     (the chain rule, ~25 lines via induction_on)
  2. `T5_pderiv_iterate_bind₁_shift` — iterated case (~10 lines)
  3. `T5_multiIteratedPDeriv_bind₁_shift` — full foldr commutativity (~10 lines)
  4. `T5_aeval_bind₁_shift` — substitution composition via Mathlib aeval_bind₁

  Combined: `aeval β (multiIteratedPDeriv j (bind₁ g P)) = aeval (β + γ) (multiIteratedPDeriv j P)`.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 6 ENTRY foundation.  Used by `T5_rothIndex_translation_invariance`
  (Phase 6 next step): `rothIndex P α d = rothIndex (shiftPoly α P) 0 d`.
-/

import Mathlib.Algebra.MvPolynomial.PDeriv
import Mathlib.Algebra.MvPolynomial.Monad
import Mathlib.Algebra.MvPolynomial.Eval
import Mathlib.Data.Real.Basic
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase6_BindOneShift

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex

/-! ## Affine shift function -/

/-- The affine shift `g i = X i + C (γ i)` for a fixed `γ : Fin n → ℝ`. -/
noncomputable def shiftFn {n : ℕ} (γ : Fin n → ℝ) :
    Fin n → MvPolynomial (Fin n) ℝ :=
  fun i => X i + C (γ i)

/-- `shiftPoly γ P := bind₁ (shiftFn γ) P` — substitutes `X i` with `X i + C (γ i)`. -/
noncomputable def shiftPoly {n : ℕ} (γ : Fin n → ℝ)
    (P : MvPolynomial (Fin n) ℝ) : MvPolynomial (Fin n) ℝ :=
  bind₁ (shiftFn γ) P

/-! ## Chain rule for pderiv on affine shift -/

/-- **🚨 Wave T5 session 559pp — pderiv chain rule for affine shift**.

    `pderiv b (bind₁ (X + C γ) P) = bind₁ (X + C γ) (pderiv b P)`

    Proof by `MvPolynomial.induction_on` over P (mirrors Mathlib's
    `pderiv_rename` pattern at PDeriv.lean:128). The key fact is
    `pderiv b (X i + C (γ i)) = pderiv b (X i)` (constant kills),
    so the affine-shift case reduces to identity Jacobian. -/
theorem T5_pderiv_bind₁_shift {n : ℕ} (γ : Fin n → ℝ) (b : Fin n)
    (P : MvPolynomial (Fin n) ℝ) :
    pderiv b (bind₁ (shiftFn γ) P) =
      bind₁ (shiftFn γ) (pderiv b P) := by
  induction P using MvPolynomial.induction_on with
  | C a => simp [shiftFn, pderiv_C]
  | add p q hp hq =>
    rw [map_add, Derivation.map_add, hp, hq, Derivation.map_add, map_add]
  | mul_X p i h =>
    -- bind₁ g (p * X i) = (bind₁ g p) * (shiftFn γ i)
    rw [map_mul, bind₁_X_right]
    -- pderiv b ((bind₁ g p) * shiftFn γ i)
    rw [MvPolynomial.pderiv_mul]
    -- = pderiv b (bind₁ g p) * shiftFn γ i + bind₁ g p * pderiv b (shiftFn γ i)
    rw [h]
    -- pderiv b (shiftFn γ i) = pderiv b (X i + C (γ i)) = pderiv b (X i)
    have h_pdshift : pderiv b (shiftFn γ i : MvPolynomial (Fin n) ℝ) =
        pderiv b (X i : MvPolynomial (Fin n) ℝ) := by
      simp [shiftFn]
    rw [h_pdshift]
    -- RHS: bind₁ g (pderiv b (p * X i)) = bind₁ g (pderiv b p * X i + p * pderiv b X i)
    rw [MvPolynomial.pderiv_mul, map_add, map_mul, map_mul, bind₁_X_right]
    -- Need: pderiv b X i = bind₁ shiftFn (pderiv b X i) (since pderiv b X i is constant)
    have h_bind_pderivX : (bind₁ (shiftFn γ)) (pderiv b (X i : MvPolynomial (Fin n) ℝ))
        = pderiv b (X i : MvPolynomial (Fin n) ℝ) := by
      by_cases hib : i = b
      · subst hib; simp
      · have h_pdz : pderiv b (X i : MvPolynomial (Fin n) ℝ) = 0 :=
          pderiv_X_of_ne hib
        rw [h_pdz, map_zero]
    rw [h_bind_pderivX]

/-! ## Iterated chain rule -/

/-- **🚨 Wave T5 session 559pp — iterated pderiv chain rule**.

    `(pderiv b)^[m] (bind₁ (X + C γ) P) = bind₁ (X + C γ) ((pderiv b)^[m] P)`. -/
theorem T5_pderiv_iterate_bind₁_shift {n : ℕ} (γ : Fin n → ℝ) (b : Fin n) (m : ℕ)
    (P : MvPolynomial (Fin n) ℝ) :
    (pderiv b)^[m] (bind₁ (shiftFn γ) P) =
      bind₁ (shiftFn γ) ((pderiv b)^[m] P) := by
  induction m with
  | zero => simp
  | succ k ih =>
    rw [Function.iterate_succ_apply', ih, T5_pderiv_bind₁_shift]
    rw [Function.iterate_succ_apply']

/-! ## multiIteratedPDeriv chain rule -/

/-- **🚨 Wave T5 session 559pp — multi-pderiv chain rule for affine shift**.

    `multiIteratedPDeriv j (shiftPoly γ P) = shiftPoly γ (multiIteratedPDeriv j P)`. -/
theorem T5_multiIteratedPDeriv_bind₁_shift {n : ℕ} (γ : Fin n → ℝ)
    (j : Fin n → ℕ) (P : MvPolynomial (Fin n) ℝ) :
    multiIteratedPDeriv j (shiftPoly γ P) =
      shiftPoly γ (multiIteratedPDeriv j P) := by
  unfold multiIteratedPDeriv shiftPoly
  induction (List.finRange n) with
  | nil => rfl
  | cons k l ih =>
    rw [List.foldr_cons, ih]
    exact T5_pderiv_iterate_bind₁_shift γ k (j k) _

/-! ## aeval-bind₁ substitution composition -/

/-- **🚨 Wave T5 session 559pp — aeval composition through affine shift**.

    `aeval β (shiftPoly γ P) = aeval (fun i => β i + γ i) P`. -/
theorem T5_aeval_bind₁_shift {n : ℕ} (γ β : Fin n → ℝ) (P : MvPolynomial (Fin n) ℝ) :
    aeval β (shiftPoly γ P) = aeval (fun i => β i + γ i) P := by
  unfold shiftPoly
  rw [MvPolynomial.aeval_bind₁]
  have hfg : (fun i => aeval β (shiftFn γ i)) = (fun i => β i + γ i) := by
    funext i
    simp [shiftFn]
  rw [hfg]

/-! ## BindOneShift Prop scaffold -/

/-- **BindOneShift**: 4-conjunct Prop packaging the
    bind₁-affine-shift + pderiv chain-rule infrastructure. -/
def BindOneShift : Prop :=
  (∀ {n : ℕ} (γ : Fin n → ℝ) (b : Fin n) (P : MvPolynomial (Fin n) ℝ),
    pderiv b (bind₁ (shiftFn γ) P) = bind₁ (shiftFn γ) (pderiv b P)) ∧
  (∀ {n : ℕ} (γ : Fin n → ℝ) (b : Fin n) (m : ℕ) (P : MvPolynomial (Fin n) ℝ),
    (pderiv b)^[m] (bind₁ (shiftFn γ) P) = bind₁ (shiftFn γ) ((pderiv b)^[m] P)) ∧
  (∀ {n : ℕ} (γ : Fin n → ℝ) (j : Fin n → ℕ) (P : MvPolynomial (Fin n) ℝ),
    multiIteratedPDeriv j (shiftPoly γ P) = shiftPoly γ (multiIteratedPDeriv j P)) ∧
  (∀ {n : ℕ} (γ β : Fin n → ℝ) (P : MvPolynomial (Fin n) ℝ),
    aeval β (shiftPoly γ P) = aeval (fun i => β i + γ i) P)

/-- **🚨 Wave T5 session 559pp — `BindOneShift`**. -/
theorem T5_bind_one_shift : BindOneShift :=
  ⟨@T5_pderiv_bind₁_shift,
   @T5_pderiv_iterate_bind₁_shift,
   @T5_multiIteratedPDeriv_bind₁_shift,
   @T5_aeval_bind₁_shift⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559pp — T-5 Phase 6 ENTRY: bind₁ affine shift**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 6 ENTRY.

    Four chain-rule + substitution lemmas + Prop:
    1. `T5_pderiv_bind₁_shift`: pderiv chain rule for affine shift
       (the only original-content piece — `bind₁_pderiv` is NOT in
       Mathlib v4.29; ports via `MvPolynomial.induction_on`)
    2. `T5_pderiv_iterate_bind₁_shift`: iterated case
    3. `T5_multiIteratedPDeriv_bind₁_shift`: full foldr commutativity
    4. `T5_aeval_bind₁_shift`: substitution composition
    + BindOneShift Prop (4-conjunct).

    Phase 6 status: ENTRY foundation in place.  Next:
    `T5_rothIndex_translation_invariance` — composing this with
    Phase 5 to give `rothIndex P α d = rothIndex (shiftPoly α P) 0 d`.

    Mathlib usage: `MvPolynomial.bind₁`, `MvPolynomial.bind₁_X_right`,
    `MvPolynomial.aeval_bind₁`, `MvPolynomial.induction_on`,
    `Derivation.leibniz`, `Derivation.map_add`, `pderiv_C`.

    Sub-lemma 190/N in T-1 (T-5 Phase 6 ENTRY).  Lean-core only.

    🏆 First Lean-core T-5 Phase 6 affine-shift chain rule. -/
theorem session_559pp_T5_phase6_bind_one_shift_headline :
    BindOneShift :=
  T5_bind_one_shift

end OmegaTheory.Irrationality.CustomMath.T5_Phase6_BindOneShift
