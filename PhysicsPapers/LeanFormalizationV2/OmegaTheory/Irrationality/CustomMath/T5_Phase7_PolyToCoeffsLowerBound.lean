/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyToCoeffsLowerBound

  T-5 (Roth's theorem) — **Phase 7 ext #23: integer-coefficient
  lower bound `1 ≤ ∑ |polyToCoeffs p k|` for non-zero p**, sub
  session 559ppp — STRICT critical-path #316 (T-5) Phase 7 ext #23.

  Single-thread hand-authored 2026-04-28 (cycle 65 — post-restart).

  ## What this file delivers

  Foundation for the integer-non-vanishing argument toward Roth:
  for any non-zero polynomial `p ∈ MvPolynomial.restrictDegree (Fin n) ℤ d`,
  the abs-sum of its coefficient vector is ≥ 1.

      `p ≠ 0 → p ∈ restrictDegree → 1 ≤ ∑ k, |polyToCoeffs p k|`

  This combined with ext #22 (analytical upper bound on `|p(α)|`)
  gives the **two-sided bound chain** that drives Roth's contradiction:
  - Upper bound: `|p(α)| ≤ explicit-formula(d, n, α, sup-coeff)`
  - Lower bound: `1 ≤ ∑ |c k|` (this file)

  Two derivations + Prop:
  1. `T5_polyToCoeffs_exists_nonzero`: `p ≠ 0 → ∃ k, polyToCoeffs p k ≠ 0`
  2. `T5_polyToCoeffs_abs_sum_ge_one`: `1 ≤ ∑ k, |polyToCoeffs p k|`

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #23 — integer non-vanishing foundation.

  Combined with ext #22 GRAND analytical capstone, gives the
  two-sided bound `1 ≤ ∑ |c k| ≤ ‖c‖∞ · (d+1)^n` plus the upper
  bound `|p(α)| ≤ (∑ |c k|) · ∏ 2^d (max 1 |α|)^d`. The lower
  bound on `|p(α)|` itself (≥ 1 for non-zero integer p(α))
  needs ext #24+ (eval-non-vanishing argument).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_BijectionClosure
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_BijectionCorollaries

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyToCoeffsLowerBound

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMultiIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsToPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyToCoeffs
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BijectionClosure
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BijectionCorollaries

/-! ## Existence of non-zero coefficient -/

/-- **🚨 Wave T5 session 559ppp — `p ≠ 0 → ∃ k, polyToCoeffs p k ≠ 0`**.

    For any non-zero polynomial in `restrictDegree`, at least one
    coefficient via `polyToCoeffs` is non-zero. -/
theorem T5_polyToCoeffs_exists_nonzero {n d : ℕ}
    (p : MvPolynomial (Fin n) ℤ)
    (hp_ne : p ≠ 0)
    (hp_mem : p ∈ MvPolynomial.restrictDegree (Fin n) ℤ d) :
    ∃ k : BoundedMI n d, (polyToCoeffs (d := d) p) k ≠ 0 := by
  by_contra h_all
  push_neg at h_all
  -- h_all : ∀ k, polyToCoeffs p k = 0
  apply hp_ne
  -- Goal: p = 0
  rw [← T5_coeffsToPoly_polyToCoeffs p hp_mem]
  -- Goal: coeffsToPoly (polyToCoeffs p) = 0
  rw [T5_coeffsToPoly_eq_zero_iff]
  funext k
  exact h_all k

/-! ## Lower bound on abs-sum of coefficients -/

/-- **🚨 Wave T5 session 559ppp — `1 ≤ ∑ k, |polyToCoeffs p k|`** for non-zero `p`.

    Foundation for integer non-vanishing argument: for non-zero
    polynomial in `restrictDegree`, the abs-sum of its integer
    coefficient vector is at least 1.

    Proof: ext #11 BijectionCorollaries → ∃ k₀, c k₀ ≠ 0 →
    `Int.one_le_abs` → `1 ≤ |c k₀|` → `Finset.single_le_sum` →
    `|c k₀| ≤ ∑ k, |c k|`. -/
theorem T5_polyToCoeffs_abs_sum_ge_one {n d : ℕ}
    (p : MvPolynomial (Fin n) ℤ)
    (hp_ne : p ≠ 0)
    (hp_mem : p ∈ MvPolynomial.restrictDegree (Fin n) ℤ d) :
    (1 : ℤ) ≤ ∑ k : BoundedMI n d, |(polyToCoeffs (d := d) p) k| := by
  obtain ⟨k₀, hk₀⟩ := T5_polyToCoeffs_exists_nonzero p hp_ne hp_mem
  have h_one_le_abs : (1 : ℤ) ≤ |(polyToCoeffs (d := d) p) k₀| :=
    Int.one_le_abs hk₀
  have h_abs_le_sum : |(polyToCoeffs (d := d) p) k₀|
      ≤ ∑ k : BoundedMI n d, |(polyToCoeffs (d := d) p) k| :=
    Finset.single_le_sum (f := fun k => |(polyToCoeffs (d := d) p) k|)
      (fun k _ => abs_nonneg _) (Finset.mem_univ k₀)
  exact h_one_le_abs.trans h_abs_le_sum

/-! ## PolyToCoeffsLowerBound Prop scaffold -/

/-- **PolyToCoeffsLowerBound**: 2-conjunct Prop packaging existence
    of non-zero coefficient + abs-sum lower bound. -/
def PolyToCoeffsLowerBound : Prop :=
  (∀ {n d : ℕ} (p : MvPolynomial (Fin n) ℤ),
    p ≠ 0 →
    p ∈ MvPolynomial.restrictDegree (Fin n) ℤ d →
    ∃ k : BoundedMI n d, (polyToCoeffs (d := d) p) k ≠ 0) ∧
  (∀ {n d : ℕ} (p : MvPolynomial (Fin n) ℤ),
    p ≠ 0 →
    p ∈ MvPolynomial.restrictDegree (Fin n) ℤ d →
    (1 : ℤ) ≤ ∑ k : BoundedMI n d, |(polyToCoeffs (d := d) p) k|)

/-- **🚨 Wave T5 session 559ppp — `PolyToCoeffsLowerBound`**. -/
theorem T5_polyToCoeffs_lower_bound : PolyToCoeffsLowerBound :=
  ⟨@T5_polyToCoeffs_exists_nonzero,
   @T5_polyToCoeffs_abs_sum_ge_one⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559ppp — T-5 Phase 7 ext #23:
    integer-coefficient lower bound for non-zero polynomial**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #23.

    Foundation for integer non-vanishing argument toward Roth:

        p ≠ 0 ∈ restrictDegree → 1 ≤ ∑ k, |polyToCoeffs p k|

    Two derivations + Prop:
    1. `T5_polyToCoeffs_exists_nonzero` — existence of non-zero
       coefficient via ext #9 BijectionClosure + ext #11
       `T5_coeffsToPoly_eq_zero_iff` (contrapositive)
    2. `T5_polyToCoeffs_abs_sum_ge_one` — lower bound via
       `Int.one_le_abs` + `Finset.single_le_sum`
    + PolyToCoeffsLowerBound Prop (2-conjunct).

    Combined with ext #22 GRAND analytical capstone, gives the
    two-sided bound chain:
    - Upper bound (ext #22): `|p(α)| ≤ (∑ |c k|) · ∏ 2^d (max 1 |α|)^d`
    - Lower bound (this file): `1 ≤ ∑ |c k|`
    Plus the integer-non-vanishing of `p(α)` itself (ext #24+).

    Mathlib usage: `Int.one_le_abs`, `Finset.single_le_sum`,
    `Finset.mem_univ`, `abs_nonneg`, `push_neg`.

    Sub-lemma 216/N in T-1 (T-5 Phase 7 ext #23).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 integer-coefficient lower bound
    for non-zero polynomial in restrictDegree. -/
theorem session_559ppp_T5_phase7_polyToCoeffs_lower_bound_headline :
    PolyToCoeffsLowerBound :=
  T5_polyToCoeffs_lower_bound

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyToCoeffsLowerBound
