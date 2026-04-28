/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsToPolyEval

  T-5 (Roth's theorem) — **Phase 7 ext #18: coeffsToPoly polynomial
  evaluation = sum over vanishingMatrixEntry 0 α**, sub session 559kkk
  — STRICT critical-path #316 (T-5) Phase 7 ext #18.

  Single-thread hand-authored 2026-04-28 (cycle 65 — post-restart).

  ## What this file delivers

  Bridges `coeffsToPoly` (s559zz polynomial assembly) and
  `vanishingMatrixEntry` (s559eee closed-form matrix entry) via
  polynomial evaluation:

      `(MvPolynomial.eval α) (coeffsToPoly c)
         = ∑ k : BoundedMI n d, c k * vanishingMatrixEntry 0 α k`

  This is the **analytical-side starter** for Roth's main proof:
  evaluating the auxiliary polynomial at any point α : Fin n → ℤ
  reduces to a dot product of the coefficient vector `c` with the
  no-derivative matrix-entry row `vanishingMatrixEntry 0 α (·)`.

  Two derivations + Prop:
  1. `T5_finsupp_prod_eq_univ_prod`: helper bridging Finsupp.prod
     to Finset.univ-prod via `Finsupp.prod_fintype`
  2. `T5_coeffsToPoly_eval_eq_sum`: main bridge theorem

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #18 — analytical-side starter.

  Combined with ext #16 (Schmidt aux poly with explicit norm bound),
  this gives:
      |coeffsToPoly c at α| ≤ ‖c‖_∞ · |BoundedMI n d| · max_k |vanishingMatrixEntry 0 α k|
      ≤ ‖c‖_∞ · (d+1)^n · ∏ i, (max 1 |α i|)^d
  i.e., the analytical bound on `|p(α)|` for any α : Fin n → ℤ.
-/

import Mathlib.Algebra.BigOperators.Finsupp.Basic
import Mathlib.Algebra.MvPolynomial.Eval
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsToPolynomial
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_VanishingMatrixEntry

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsToPolyEval

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMultiIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMIToFinsupp
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsToPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_VanishingMatrixEntry

/-! ## Finsupp.prod ↔ Finset.univ-prod bridge -/

/-- **🚨 Wave T5 session 559kkk — `Finsupp.prod` for BoundedMI's
    `T5_boundedMItoFinsupp` extends to univ-prod**.

    Direct application of `Finsupp.prod_fintype` since `α^0 = 1`. -/
theorem T5_finsupp_prod_eq_univ_prod {n d : ℕ}
    (k : BoundedMI n d) (α : Fin n → ℤ) :
    (T5_boundedMItoFinsupp k).prod (fun i e => (α i) ^ e)
      = ∏ i : Fin n, (α i) ^ ((T5_boundedMItoFinsupp k) i) := by
  apply Finsupp.prod_fintype
  intro i
  exact pow_zero (α i)

/-! ## Main bridge: coeffsToPoly evaluation = sum over matrix entries -/

/-- **🚨 Wave T5 session 559kkk — `coeffsToPoly` evaluation as
    matrix-entry sum**.

    Evaluating the assembled polynomial `coeffsToPoly c` at α is
    a dot product of the coefficient vector `c` with the
    no-derivative matrix entry row `vanishingMatrixEntry 0 α (·)`. -/
theorem T5_coeffsToPoly_eval_eq_sum {n d : ℕ}
    (c : BoundedMI n d → ℤ) (α : Fin n → ℤ) :
    (MvPolynomial.eval α) (coeffsToPoly c)
      = ∑ k : BoundedMI n d, c k *
          vanishingMatrixEntry
            (fun _ : Fin n => (⟨0, Nat.succ_pos d⟩ : Fin (d + 1)))
            α k := by
  unfold coeffsToPoly
  rw [MvPolynomial.eval_sum]
  apply Finset.sum_congr rfl
  intro k _
  rw [MvPolynomial.eval_monomial]
  -- Goal: c k * (toFinsupp k).prod (fun i e => α i ^ e)
  --     = c k * vanishingMatrixEntry 0 α k
  congr 1
  rw [T5_finsupp_prod_eq_univ_prod]
  rw [T5_vanishingMatrixEntry_I_zero]
  apply Finset.prod_congr rfl
  intro i _
  unfold T5_boundedMItoFinsupp
  rw [Finsupp.equivFunOnFinite_symm_apply_apply]

/-! ## CoeffsToPolyEval Prop scaffold -/

/-- **CoeffsToPolyEval**: 2-conjunct Prop packaging the
    Finsupp/univ bridge + main eval-as-sum theorem. -/
def CoeffsToPolyEval : Prop :=
  (∀ {n d : ℕ} (k : BoundedMI n d) (α : Fin n → ℤ),
    (T5_boundedMItoFinsupp k).prod (fun i e => (α i) ^ e)
      = ∏ i : Fin n, (α i) ^ ((T5_boundedMItoFinsupp k) i)) ∧
  (∀ {n d : ℕ} (c : BoundedMI n d → ℤ) (α : Fin n → ℤ),
    (MvPolynomial.eval α) (coeffsToPoly c)
      = ∑ k : BoundedMI n d, c k *
          vanishingMatrixEntry
            (fun _ : Fin n => (⟨0, Nat.succ_pos d⟩ : Fin (d + 1)))
            α k)

/-- **🚨 Wave T5 session 559kkk — `CoeffsToPolyEval`**. -/
theorem T5_coeffs_to_poly_eval : CoeffsToPolyEval :=
  ⟨@T5_finsupp_prod_eq_univ_prod,
   @T5_coeffsToPoly_eval_eq_sum⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559kkk — T-5 Phase 7 ext #18:
    coeffsToPoly evaluation as matrix-entry sum**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #18.

    Bridges polynomial evaluation of the assembled `coeffsToPoly c`
    at α to a dot product with the no-derivative matrix entry row
    via Mathlib's `Finsupp.prod_fintype` (since `α^0 = 1`).

    Two derivations + Prop:
    1. `T5_finsupp_prod_eq_univ_prod` — Finsupp/univ bridge
    2. `T5_coeffsToPoly_eval_eq_sum` — main eval-as-sum theorem
    + CoeffsToPolyEval Prop (2-conjunct).

    This is the **analytical-side starter** for Roth's main proof:
    combined with ext #14 (entry abs bound 2^d · max 1 |α|^d) and
    ext #16 (Siegel coefficient norm), gives an explicit upper
    bound on `|coeffsToPoly c at α|` in terms of (d, n, α).

    Mathlib usage: `MvPolynomial.eval_sum`, `MvPolynomial.eval_monomial`,
    `Finsupp.prod_fintype`, `Finsupp.equivFunOnFinite_symm_apply_apply`,
    `pow_zero`.

    Sub-lemma 211/N in T-1 (T-5 Phase 7 ext #18).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 polynomial evaluation ↔ matrix
    entry bridge (analytical-side starter). -/
theorem session_559kkk_T5_phase7_coeffsToPoly_eval_headline :
    CoeffsToPolyEval :=
  T5_coeffs_to_poly_eval

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsToPolyEval
