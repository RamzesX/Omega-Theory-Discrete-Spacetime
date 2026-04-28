/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_VanishingMatrixEntryBound

  T-5 (Roth's theorem) — **Phase 7 ext #14: vanishing matrix entry
  abs bound**, sub session 559ggg — STRICT critical-path #316 (T-5)
  Phase 7 ext #14.

  Single-thread hand-authored 2026-04-28 (cycle 65 — post-restart).

  ## What this file delivers

  Per-component + full-product abs bound on `vanishingMatrixEntry`:

      |∏ i, choose(s_i, I_i) * α_i^(s_i - I_i)|
        ≤ ∏ i, 2^d * (max 1 |α_i|)^d

  This is the **per-entry bound** needed for Schmidt's analytical
  argument: the auxiliary polynomial coefficient vector solution of
  Siegel's lemma has sup-norm bounded in terms of `‖M‖`, where `‖M‖`
  is the matrix sup-norm (max abs entry).  Combined with this entry
  bound, we get an explicit bound on `‖p‖` in terms of `(d, n, |α|)`.

  Two derivations + Prop:
  1. `T5_vanishingMatrixEntry_abs_le_pointwise`: per-component abs
     bound `|choose * α^k| ≤ 2^d * (max 1 |α|)^d`
  2. `T5_vanishingMatrixEntry_abs_le_product`: full product abs bound
     via `Finset.abs_prod` + `Finset.prod_le_prod`

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #14 — entry abs bound.

  This is the NUMERICAL FOUNDATION for ext #15+ (matrix sup-norm
  bound via `Matrix.norm_le_iff` + per-entry bound) and ext #16
  (analytical decay → integer contradiction → final Roth).
-/

import Mathlib.Data.Nat.Choose.Bounds
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.Order.BigOperators.GroupWithZero.Finset
import Mathlib.Algebra.Order.AbsoluteValue.Basic
import Mathlib.Tactic.Positivity
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_VanishingMatrixEntry

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_VanishingMatrixEntryBound

open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMultiIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_VanishingMatrixEntry

/-! ## Per-component abs bound -/

/-- **🚨 Wave T5 session 559ggg — per-component abs bound**.

    For each factor `choose(s_i, I_i) * α_i^(s_i - I_i)` of the
    vanishingMatrixEntry, the absolute value is bounded by
    `2^d * (max 1 |α_i|)^d` using
    `Nat.choose_le_two_pow` + `s_i ≤ d` + power monotonicity. -/
theorem T5_vanishingMatrixEntry_abs_le_pointwise {d : ℕ}
    (a : ℤ) (s_val I_val : ℕ) (h_s : s_val ≤ d) :
    |(Nat.choose s_val I_val : ℤ) * a ^ (s_val - I_val)|
      ≤ (2 ^ d : ℤ) * (max 1 |a|) ^ d := by
  rw [abs_mul, Int.abs_natCast, abs_pow]
  have h_choose : (Nat.choose s_val I_val : ℤ) ≤ 2 ^ d := by
    have h1 : (Nat.choose s_val I_val : ℤ) ≤ (2 : ℤ) ^ s_val := by
      exact_mod_cast Nat.choose_le_two_pow s_val I_val
    have h2 : (2 : ℤ) ^ s_val ≤ (2 : ℤ) ^ d :=
      pow_le_pow_right₀ (by norm_num : (1 : ℤ) ≤ 2) h_s
    exact h1.trans h2
  have h_one_le_max : (1 : ℤ) ≤ max 1 |a| := le_max_left _ _
  have h_pow : |a| ^ (s_val - I_val) ≤ (max 1 |a|) ^ d := by
    have h_left : |a| ^ (s_val - I_val) ≤ (max 1 |a|) ^ (s_val - I_val) :=
      pow_le_pow_left₀ (abs_nonneg a) (le_max_right _ _) _
    have h_right : (max 1 |a|) ^ (s_val - I_val) ≤ (max 1 |a|) ^ d :=
      pow_le_pow_right₀ h_one_le_max (Nat.le_trans (Nat.sub_le _ _) h_s)
    exact h_left.trans h_right
  have h_pow_nn : (0 : ℤ) ≤ |a| ^ (s_val - I_val) :=
    pow_nonneg (abs_nonneg a) _
  have h_2d_nn : (0 : ℤ) ≤ 2 ^ d :=
    pow_nonneg (by norm_num : (0 : ℤ) ≤ 2) d
  exact mul_le_mul h_choose h_pow h_pow_nn h_2d_nn

/-! ## Full-product abs bound -/

/-- Helper: abs commutes with finite products of integers. -/
private theorem abs_prod_int {ι : Type*} (s : Finset ι) (f : ι → ℤ) :
    |∏ i ∈ s, f i| = ∏ i ∈ s, |f i| := by
  classical
  induction s using Finset.induction with
  | empty => simp
  | @insert x t hx ih =>
    rw [Finset.prod_insert hx, Finset.prod_insert hx, abs_mul, ih]

/-- **🚨 Wave T5 session 559ggg — full vanishingMatrixEntry abs bound**.

    The full matrix entry is bounded by the product of per-component
    bounds via `abs_prod_int` + `Finset.prod_le_prod`. -/
theorem T5_vanishingMatrixEntry_abs_le_product {n d : ℕ}
    (I : BoundedMI n d) (α : Fin n → ℤ) (s : BoundedMI n d) :
    |vanishingMatrixEntry I α s|
      ≤ ∏ i : Fin n, ((2 ^ d : ℤ) * (max 1 |α i|) ^ d) := by
  unfold vanishingMatrixEntry
  rw [abs_prod_int]
  apply Finset.prod_le_prod
  · intro i _
    positivity
  · intro i _
    apply T5_vanishingMatrixEntry_abs_le_pointwise
    -- s i : Fin (d+1), so (s i).val ≤ d
    exact Nat.lt_succ_iff.mp (s i).isLt

/-! ## VanishingMatrixEntryBound Prop scaffold -/

/-- **VanishingMatrixEntryBound**: 2-conjunct Prop packaging the
    per-component + full-product abs bounds. -/
def VanishingMatrixEntryBound : Prop :=
  (∀ {d : ℕ} (a : ℤ) (s_val I_val : ℕ),
    s_val ≤ d →
    |(Nat.choose s_val I_val : ℤ) * a ^ (s_val - I_val)|
      ≤ (2 ^ d : ℤ) * (max 1 |a|) ^ d) ∧
  (∀ {n d : ℕ} (I : BoundedMI n d) (α : Fin n → ℤ) (s : BoundedMI n d),
    |vanishingMatrixEntry I α s|
      ≤ ∏ i : Fin n, ((2 ^ d : ℤ) * (max 1 |α i|) ^ d))

/-- **🚨 Wave T5 session 559ggg — `VanishingMatrixEntryBound`**. -/
theorem T5_vanishing_matrix_entry_bound : VanishingMatrixEntryBound :=
  ⟨@T5_vanishingMatrixEntry_abs_le_pointwise,
   @T5_vanishingMatrixEntry_abs_le_product⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559ggg — T-5 Phase 7 ext #14: vanishing matrix entry abs bound**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #14.

    Per-component + full-product abs bound on `vanishingMatrixEntry`:

        |∏ i, choose(s_i, I_i) * α_i^(s_i - I_i)|
          ≤ ∏ i, 2^d * (max 1 |α_i|)^d

    Two derivations + Prop:
    1. `T5_vanishingMatrixEntry_abs_le_pointwise` — per-component
       via `Nat.choose_le_two_pow` + power monotonicity
    2. `T5_vanishingMatrixEntry_abs_le_product` — full product via
       `Finset.abs_prod` + `Finset.prod_le_prod`
    + VanishingMatrixEntryBound Prop (2-conjunct).

    Numerical foundation for ext #15+ (matrix sup-norm bound via
    `Matrix.norm_le_iff` + per-entry bound) and ext #16 (analytical
    decay → integer contradiction → final Roth main theorem).

    Mathlib usage: `Nat.choose_le_two_pow`, `pow_le_pow_left₀`,
    `pow_le_pow_right₀`, `abs_mul`, `abs_pow`, `Int.abs_natCast`,
    `Finset.abs_prod`, `Finset.prod_le_prod`, `positivity`.

    Sub-lemma 207/N in T-1 (T-5 Phase 7 ext #14).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 vanishingMatrixEntry abs bound. -/
theorem session_559ggg_T5_phase7_vanishing_matrix_entry_bound_headline :
    VanishingMatrixEntryBound :=
  T5_vanishing_matrix_entry_bound

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_VanishingMatrixEntryBound
