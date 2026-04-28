/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_MultiIteratedPDerivBridgeDischarge

  T-5 (Roth's theorem) — **Phase 7 ext #35: Discharge of
  MultiIteratedPDerivBridge for I=0 row case (Gap A partial closure)**,
  sub session 559bbbb — STRICT critical-path #316 (T-5) Phase 7 ext #35.

  Single-thread hand-authored 2026-04-28 (cycle 65 → 66 transition).

  ## What this file delivers

  Special-case discharge of the Gap A bridge: when the constraint
  matrix has at least one row corresponding to I = 0 (no derivatives,
  pure evaluation), matrix vanishing implies `(eval α) p = 0`.

  Concretely: if `j₀ : J` exists with `I j₀ = 0-MI`, then the j₀-th
  row of the matrix `vanishingMatrix J I (fun _ => α)` equals the
  eval-at-α functional. The matrix-vanishing condition implies that
  row j₀ vanishes on `polyToCoeffs p`, which by ext #18 + ext #12
  + ext #9 round-trip equals `(eval α) p`.

  Single derivation + Prop:
  1. `T5_matrix_vanishing_implies_eval_zero_with_zero_row`: matrix
     vanishing + I has 0 row → eval α p = 0

  This is a STRICTER version of `MultiIteratedPDerivBridge` —
  parameterized by a hypothesis that the matrix has the I=0 row.
  Schmidt's auxiliary polynomial construction always includes this
  row (the constant-evaluation constraint), so this is the relevant
  form for Roth's main proof.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #35 — bridge discharge for I=0 row case.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_VanishingMatrixConstruction
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsToPolyEval
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_BijectionClosure
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_VanishingMatrixEntry
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyToCoeffs

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_MultiIteratedPDerivBridgeDischarge

open MvPolynomial Matrix
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMultiIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_VanishingMatrixEntry
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_VanishingMatrixConstruction
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsToPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyToCoeffs
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsToPolyEval
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BijectionClosure

/-! ## Bridge discharge: matrix vanishing + I has zero row → eval α p = 0 -/

/-- **🚨 Wave T5 session 559bbbb — Bridge discharge for I=0 row case**.

    If the constraint matrix has at least one row corresponding to
    I = 0 (zero multi-index, pure evaluation), the matrix-vanishing
    condition implies `(eval α) p = 0`.

    Proof sketch:
    1. Pick j₀ with I j₀ = 0-MI from hypothesis.
    2. Matrix-vanishing means row j₀ vanishes on polyToCoeffs p:
       `∑ s, vanishingMatrix(j₀, s) · polyToCoeffs p s = 0`
    3. For j₀ with I j₀ = 0-MI: `vanishingMatrix(j₀, s) =
       vanishingMatrixEntry 0 α s = ∏ α^s` (ext #12).
    4. Hence `∑ s, ∏ α^s · polyToCoeffs p s = (eval α) (coeffsToPoly
       (polyToCoeffs p))` (ext #18 + ext #12).
    5. By ext #9 BijectionClosure: `coeffsToPoly (polyToCoeffs p) = p`
       for `p ∈ restrictDegree`. -/
theorem T5_matrix_vanishing_implies_eval_zero_with_zero_row
    {n d : ℕ} {J : Type} [Fintype J]
    (I : J → BoundedMI n d) (α : Fin n → ℤ)
    (p : MvPolynomial (Fin n) ℤ)
    (hp : p ∈ MvPolynomial.restrictDegree (Fin n) ℤ d)
    (h_matrix : vanishingMatrix J I (fun _ => α) *ᵥ
        (polyToCoeffs (d := d) p) = 0)
    (j₀ : J)
    (h_zero_row : I j₀ = (fun _ : Fin n => (⟨0, Nat.succ_pos d⟩ : Fin (d + 1)))) :
    (MvPolynomial.eval α) p = 0 := by
  -- Extract row j₀ of the matrix-vanishing condition + simplify using zero-row
  have h_row : ∑ s : BoundedMI n d, vanishingMatrixEntry
      (fun _ : Fin n => (⟨0, Nat.succ_pos d⟩ : Fin (d + 1)))
      α s * (polyToCoeffs (d := d) p) s = 0 := by
    have h_apply : (vanishingMatrix J I (fun _ => α) *ᵥ
          (polyToCoeffs (d := d) p)) j₀ = 0 := by
      rw [h_matrix]; rfl
    -- Unfold mulVec/dotProduct/vanishingMatrix and substitute I j₀ = 0-MI
    simp only [Matrix.mulVec, dotProduct, vanishingMatrix, h_zero_row] at h_apply
    exact h_apply
  -- Use ext #18 sum form: (eval α) (coeffsToPoly c) = ∑ c k * vanishingMatrixEntry 0 α k
  have h_eval : (MvPolynomial.eval α) (coeffsToPoly (polyToCoeffs (d := d) p))
      = ∑ s : BoundedMI n d, vanishingMatrixEntry
          (fun _ : Fin n => (⟨0, Nat.succ_pos d⟩ : Fin (d + 1)))
          α s * (polyToCoeffs (d := d) p) s := by
    rw [T5_coeffsToPoly_eval_eq_sum]
    apply Finset.sum_congr rfl
    intro s _
    ring
  rw [← T5_coeffsToPoly_polyToCoeffs p hp]
  rw [h_eval]
  exact h_row

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559bbbb — T-5 Phase 7 ext #35:
    Bridge discharge for I=0 row case**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #35.

    🏆 Gap A PARTIAL closure (special case I=0 row).

    Single derivation:
    1. `T5_matrix_vanishing_implies_eval_zero_with_zero_row` —
       discharge for matrices with at least one I=0 row

    Strategy:
    - Extract row j₀ of matrix-vanishing
    - Substitute I j₀ = 0-MI
    - Use ext #18 sum form + ext #12 (I=0 case) + ext #9 round-trip
    - Conclude (eval α) p = 0

    Schmidt's auxiliary polynomial construction always includes the
    I=0 row (constant-evaluation constraint), so this special case
    IS the relevant form for Roth's main proof.

    The fully-general `MultiIteratedPDerivBridge` (any matrix without
    requiring I=0 row) is not provable as stated — would require
    refining the bridge def to add the I=0-row hypothesis. Per
    project rule §7.0 NO STUBS, document this gap rather than stub.

    Mathlib usage: composition via Matrix.mulVec dotProduct unfold +
    T5_coeffsToPoly_eval_eq_sum (ext #18) +
    T5_coeffsToPoly_polyToCoeffs (ext #9 round-trip) +
    T5_vanishingMatrixEntry_I_zero (ext #12).

    Sub-lemma 228/N in T-1 (T-5 Phase 7 ext #35).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 multi-pderiv bridge discharge for
    I=0 row case (Gap A partial closure). -/
theorem session_559bbbb_T5_phase7_bridge_discharge_zero_row_headline
    {n d : ℕ} {J : Type} [Fintype J]
    (I : J → BoundedMI n d) (α : Fin n → ℤ)
    (p : MvPolynomial (Fin n) ℤ)
    (hp : p ∈ MvPolynomial.restrictDegree (Fin n) ℤ d)
    (h_matrix : vanishingMatrix J I (fun _ => α) *ᵥ
        (polyToCoeffs (d := d) p) = 0)
    (j₀ : J)
    (h_zero_row : I j₀ = (fun _ : Fin n => (⟨0, Nat.succ_pos d⟩ : Fin (d + 1)))) :
    (MvPolynomial.eval α) p = 0 :=
  T5_matrix_vanishing_implies_eval_zero_with_zero_row
    I α p hp h_matrix j₀ h_zero_row

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_MultiIteratedPDerivBridgeDischarge
