/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_EulerNonZero

  T-5 (Roth's theorem) — **Phase 7 Wave-2 Phase 2.2 ANALYTICAL CORE**:
  the Euler-identity-based non-vanishing lemma for `P + ∑ X_i · pderiv i P`.

  Single-thread hand-authored 2026-04-29 (post web-research on Mathlib EulerIdentity).

  ## What this file delivers

  Key analytical identity from the matrix determinant lemma argument
  for the multivariate Wronskian:

  For homogeneous P of degree n: `P + ∑ X_i · pderiv i P = (n + 1) • P`.

  Used in the matrix determinant lemma `det(P*I + outer((d_iP), (X_j))) =
  P^{m-1} · (P + ∑ X_i · d_iP)` to establish the alt-witness Wronskian
  formula `det = X_0 · P^m` for all m.

  ## Mathlib infrastructure used

  - `MvPolynomial.IsHomogeneous.sum_X_mul_pderiv`
    (`Mathlib.RingTheory.MvPolynomial.EulerIdentity`):
    `∑ i, X i * pderiv i φ = n • φ` for homogeneous φ of degree n.

  Per project rule §7.0 NO STUBS.
-/

import Mathlib.RingTheory.MvPolynomial.EulerIdentity
import Mathlib.Data.Real.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_EulerNonZero

open MvPolynomial Finset

/-! ## P + ∑ X_i · pderiv_i P = (n+1) • P for homogeneous P -/

/-- **Euler-shifted identity for homogeneous polynomials** —
    `P + ∑ X_i · pderiv i P = (n + 1) • P` when P is homogeneous of degree n. -/
theorem T5_homogeneous_sum_X_mul_pderiv_shifted
    {m : ℕ} {n : ℕ} {φ : MvPolynomial (Fin m) ℝ} (h : φ.IsHomogeneous n) :
    φ + ∑ i : Fin m, X i * pderiv i φ = (n + 1 : ℕ) • φ := by
  rw [h.sum_X_mul_pderiv]
  rw [add_smul, one_smul, add_comm]

/-- **Non-vanishing for homogeneous P** — `P + ∑ X_i · pderiv i P ≠ 0`
    when P is homogeneous and non-zero. -/
theorem T5_homogeneous_sum_X_mul_pderiv_shifted_ne_zero
    {m : ℕ} {n : ℕ} {φ : MvPolynomial (Fin m) ℝ}
    (h : φ.IsHomogeneous n) (hφ : φ ≠ 0) :
    φ + ∑ i : Fin m, X i * pderiv i φ ≠ 0 := by
  rw [T5_homogeneous_sum_X_mul_pderiv_shifted h]
  -- (n + 1) • φ ≠ 0 because n + 1 ≠ 0 (in ℕ) and φ ≠ 0 (over CharZero ring)
  intro h_eq
  rw [show ((n + 1 : ℕ) • φ : MvPolynomial (Fin m) ℝ)
        = ((n + 1 : ℕ) : ℝ) • φ from by
        rw [Nat.cast_smul_eq_nsmul]] at h_eq
  rw [smul_eq_zero] at h_eq
  rcases h_eq with h_zero | hφ_eq
  · exact absurd (by exact_mod_cast h_zero : (n + 1 : ℕ) = 0) (Nat.succ_ne_zero n)
  · exact hφ hφ_eq

/-! ## NAMED Prop -/

/-- **`T5_EulerShiftedNonZero`** — paper-grade NAMED Prop (specialized to Fin m).

    For homogeneous non-zero φ of degree n, the Euler-shifted sum
    `φ + ∑ X_i · pderiv i φ` is non-zero. -/
def T5_EulerShiftedNonZero : Prop :=
  ∀ {m : ℕ} {n : ℕ} {φ : MvPolynomial (Fin m) ℝ},
    φ.IsHomogeneous n → φ ≠ 0 → φ + ∑ i : Fin m, X i * pderiv i φ ≠ 0

/-- **🚨 NAMED discharge**. -/
theorem T5_EulerShiftedNonZero_holds : T5_EulerShiftedNonZero :=
  fun h hφ => T5_homogeneous_sum_X_mul_pderiv_shifted_ne_zero h hφ

/-! ## Headline -/

/-- **🚨 HEADLINE — Wave-2 Phase 2.2 ANALYTICAL CORE — Euler shifted**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Wave-2 Phase 2.2 analytical.

    Three derivations:
    1. `T5_homogeneous_sum_X_mul_pderiv_shifted` — formula for homogeneous P
    2. `T5_homogeneous_sum_X_mul_pderiv_shifted_ne_zero` — non-vanishing
    3. `T5_EulerShiftedNonZero_holds` — NAMED discharge

    Web-research finding: `Mathlib.RingTheory.MvPolynomial.EulerIdentity`
    provides `IsHomogeneous.sum_X_mul_pderiv : ∑ X_i · pderiv i φ = n • φ`.
    This file specializes to the SHIFTED form `(n + 1) • φ` and derives
    non-vanishing for homogeneous non-zero P.

    **Strategic role**: this is the analytical KERNEL of the matrix
    determinant lemma argument for the multivariate Wronskian:
    `det(P*I + outer((d_iP), (X_j))) = P^{m-1} · (P + ∑ X_i · d_iP)`.
    For homogeneous P, the second factor equals `(deg + 1) • P ≠ 0`,
    so the determinant is non-zero (in the integral domain).

    For non-homogeneous P, we'd extend via homogeneous decomposition
    `P = ∑_n homogeneousComponent n P` (multi-day work).

    Sub-lemma 315/N in T-5 Phase 7. Lean-core only. NO STUBS. -/
theorem session_W2_phase_2_2_euler_non_zero_homogeneous_headline :
    T5_EulerShiftedNonZero :=
  T5_EulerShiftedNonZero_holds

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_EulerNonZero
