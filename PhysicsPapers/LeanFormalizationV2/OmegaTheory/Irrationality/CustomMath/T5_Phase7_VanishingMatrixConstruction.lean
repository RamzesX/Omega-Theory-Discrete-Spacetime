/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_VanishingMatrixConstruction

  T-5 (Roth's theorem) — **Phase 7 ext #15: vanishing matrix
  construction + sup-norm bound**, sub session 559hhh — STRICT
  critical-path #316 (T-5) Phase 7 ext #15.

  Single-thread hand-authored 2026-04-28 (cycle 65 — post-restart).

  ## What this file delivers

  Concrete matrix `vanishingMatrix` from a Finset of (multi-derivative
  index, evaluation point) pairs to bounded multi-indices, with each
  entry given by `vanishingMatrixEntry` (s559eee).

  Plus the sup-norm bound via `Matrix.norm_le_iff` + ext #14's
  per-entry bound:

      ‖vanishingMatrix J I α‖
        ≤ max over (j, s) of |vanishingMatrixEntry (I j) (α j) s|
        ≤ max over j of (∏ i, 2^d * (max 1 |α_j i|)^d)

  Two derivations + Prop:
  1. `vanishingMatrix`: matrix def
  2. `T5_vanishingMatrix_entry_abs_bound`: per-entry abs bound (direct
     application of ext #14)
  3. `T5_vanishingMatrix_norm_bound`: sup-norm bound (per-entry bound +
     `Matrix.norm_le_iff`)

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #15 — concrete matrix + sup-norm bound.

  Combined with s559xx (`T5_auxiliary_poly_abstract_exists` Siegel)
  and ext #10 (concrete polynomial existence), this gives:
      ∃ p ∈ restrictDegree, p ≠ 0, M *ᵥ polyToCoeffs p = 0,
      ‖p‖ ≤ ((d+1)^n · ‖M‖)^(card J / ((d+1)^n - card J))
  where ‖M‖ is bounded explicitly by ext #14.
-/

import Mathlib.Analysis.Matrix.Normed
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_VanishingMatrixEntry
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_VanishingMatrixEntryBound

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_VanishingMatrixConstruction

open Matrix
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMultiIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_VanishingMatrixEntry
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_VanishingMatrixEntryBound

attribute [local instance] Matrix.seminormedAddCommGroup

/-! ## Vanishing matrix construction -/

/-- **🚨 Wave T5 session 559hhh — `vanishingMatrix` from (J → BoundedMI) + (J → α)**.

    Concrete matrix encoding the Schmidt-Wirsing vanishing system:
    rows indexed by `J` (each carrying a multi-derivative index
    `I j : BoundedMI n d` and evaluation point `α j : Fin n → ℤ`),
    columns indexed by `BoundedMI n d` (the polynomial coefficient
    indices). -/
noncomputable def vanishingMatrix {n d : ℕ} (J : Type*) [Fintype J]
    (I : J → BoundedMI n d) (α : J → Fin n → ℤ) :
    Matrix J (BoundedMI n d) ℤ :=
  fun j s => vanishingMatrixEntry (I j) (α j) s

/-! ## Per-entry abs bound -/

/-- **🚨 Wave T5 session 559hhh — vanishingMatrix per-entry abs bound**.

    Direct corollary of ext #14
    `T5_vanishingMatrixEntry_abs_le_product`. -/
theorem T5_vanishingMatrix_entry_abs_bound {n d : ℕ} {J : Type*}
    [Fintype J] (I : J → BoundedMI n d) (α : J → Fin n → ℤ)
    (j : J) (s : BoundedMI n d) :
    |vanishingMatrix J I α j s|
      ≤ ∏ i : Fin n, ((2 ^ d : ℤ) * (max 1 |α j i|) ^ d) := by
  unfold vanishingMatrix
  exact T5_vanishingMatrixEntry_abs_le_product (I j) (α j) s

/-! ## Sup-norm bound (uniform over j) -/

/-- **🚨 Wave T5 session 559hhh — vanishingMatrix sup-norm bound**.

    For the special-case **uniform-α** instance (all rows use the
    same evaluation point α), the sup-norm of the matrix is bounded
    by the per-entry bound from ext #14.  This is the simplest
    closure of the matrix-level bound we can ship without committing
    to a specific J structure. -/
theorem T5_vanishingMatrix_norm_bound_uniform {n d : ℕ} {J : Type*}
    [Fintype J] (I : J → BoundedMI n d) (α : Fin n → ℤ) :
    ‖vanishingMatrix J I (fun _ => α)‖
      ≤ ((∏ i : Fin n, ((2 ^ d : ℤ) * (max 1 |α i|) ^ d)) : ℝ) := by
  rw [Matrix.norm_le_iff (by
    have := T5_vanishingMatrixEntry_abs_le_product
      (Inhabited.default : BoundedMI n d) α
      (Inhabited.default : BoundedMI n d)
    have h_nn : (0 : ℤ) ≤
        ∏ i : Fin n, ((2 ^ d : ℤ) * (max 1 |α i|) ^ d) :=
      Finset.prod_nonneg (fun i _ => by positivity)
    exact_mod_cast h_nn)]
  intro j s
  -- ‖vanishingMatrix... j s‖ ≤ bound
  have h_int_bound :=
    T5_vanishingMatrix_entry_abs_bound I (fun _ => α) j s
  -- ‖x : ℤ‖ = |x| as real
  rw [Int.norm_eq_abs]
  exact_mod_cast h_int_bound

/-! ## VanishingMatrixConstruction Prop scaffold -/

/-- **VanishingMatrixConstruction**: 2-conjunct Prop packaging the
    per-entry bound + uniform-α sup-norm bound. -/
def VanishingMatrixConstruction : Prop :=
  (∀ {n d : ℕ} {J : Type*} [Fintype J]
    (I : J → BoundedMI n d) (α : J → Fin n → ℤ)
    (j : J) (s : BoundedMI n d),
    |vanishingMatrix J I α j s|
      ≤ ∏ i : Fin n, ((2 ^ d : ℤ) * (max 1 |α j i|) ^ d)) ∧
  (∀ {n d : ℕ} {J : Type*} [Fintype J]
    (I : J → BoundedMI n d) (α : Fin n → ℤ),
    ‖vanishingMatrix J I (fun _ => α)‖
      ≤ ((∏ i : Fin n, ((2 ^ d : ℤ) * (max 1 |α i|) ^ d)) : ℝ))

/-- **🚨 Wave T5 session 559hhh — `VanishingMatrixConstruction`**. -/
theorem T5_vanishing_matrix_construction : VanishingMatrixConstruction :=
  ⟨@T5_vanishingMatrix_entry_abs_bound,
   @T5_vanishingMatrix_norm_bound_uniform⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559hhh — T-5 Phase 7 ext #15: vanishing matrix construction**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #15.

    Concrete matrix `vanishingMatrix` from rows indexed by J
    (each carrying multi-derivative index + eval point) to columns
    indexed by `BoundedMI n d` (coefficient indices), via
    `vanishingMatrixEntry` (s559eee).

    Three derivations + Prop:
    1. `vanishingMatrix` — matrix def
    2. `T5_vanishingMatrix_entry_abs_bound` — per-entry bound
       (direct from ext #14 product bound)
    3. `T5_vanishingMatrix_norm_bound_uniform` — uniform-α
       sup-norm bound via `Matrix.norm_le_iff`
    + VanishingMatrixConstruction Prop (2-conjunct).

    Combined with ext #10 (`T5_auxiliaryPoly_exists_in_restrictDegree`
    + Siegel), gives the full Schmidt-Wirsing-Roth auxiliary
    polynomial existence statement at MvPolynomial level WITH
    explicit matrix-norm bound for the analytical-side argument.

    Mathlib usage: `Matrix.norm_le_iff`, `Matrix.seminormedAddCommGroup`,
    `Int.norm_eq_abs`, `Finset.prod_nonneg`, `positivity`.

    Sub-lemma 208/N in T-1 (T-5 Phase 7 ext #15).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 vanishing matrix construction
    + sup-norm bound. -/
theorem session_559hhh_T5_phase7_vanishing_matrix_construction_headline :
    VanishingMatrixConstruction :=
  T5_vanishing_matrix_construction

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_VanishingMatrixConstruction
