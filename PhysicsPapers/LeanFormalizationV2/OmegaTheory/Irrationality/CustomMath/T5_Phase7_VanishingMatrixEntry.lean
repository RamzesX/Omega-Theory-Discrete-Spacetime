/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_VanishingMatrixEntry

  T-5 (Roth's theorem) — **Phase 7 ext #12: vanishing matrix entry
  closed-form definition**, sub session 559eee — STRICT
  critical-path #316 (T-5) Phase 7 ext #12.

  Single-thread hand-authored 2026-04-28 (cycle 65 — post-restart).

  ## What this file delivers

  Concrete definition of the matrix entry that encodes the Schmidt-
  Wirsing-Roth vanishing condition `(1/I!) ∂^I (X^s)` evaluated at α:

      vanishingMatrixEntry I α s
        := ∏ i, (Nat.choose (s i).val (I i).val) * α i^((s i).val - (I i).val)

  Plus structural lemmas for special cases:
  1. `T5_vanishingMatrixEntry_I_zero`: at I = 0, reduces to the
     standard monomial evaluation `∏ α i^(s i).val`
  2. `T5_vanishingMatrixEntry_I_eq_s`: at I = s (diagonal), reduces
     to `∏ Nat.choose (s i) (s i) * α i^0 = 1`
  3. `T5_vanishingMatrixEntry_I_lt_s_componentwise_zero`: when some
     `s i < I i`, the entry is 0 via `Nat.choose_eq_zero_of_lt`

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #12 — concrete vanishing matrix entry definition.

  This is the structural starting point for ext #13+ (matrix-norm
  bound) and ext #14 (full closed-form bridge to multiIteratedPDeriv
  via T5_Phase3-Phase6 vocabulary).
-/

import Mathlib.Data.Nat.Choose.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.BigOperators.GroupWithZero.Finset
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMultiIndex

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_VanishingMatrixEntry

open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMultiIndex

/-! ## Vanishing matrix entry definition -/

/-- **🚨 Wave T5 session 559eee — `vanishingMatrixEntry` closed-form definition**.

    The integer matrix entry encoding the Schmidt-Wirsing-Roth vanishing
    condition `(1/I!) ∂^I (X^s)` evaluated at integer point `α`.

    Closed-form: `∏ i, (Nat.choose (s i) (I i)) * α i^((s i) - (I i))`.

    Note: when some `s i < I i`, `Nat.choose (s i) (I i) = 0` so the
    entry is automatically 0 (matching the calculus fact
    `∂^I (X^s) = 0` when |I| > |s| componentwise). -/
noncomputable def vanishingMatrixEntry {n d : ℕ}
    (I : BoundedMI n d) (α : Fin n → ℤ) (s : BoundedMI n d) : ℤ :=
  ∏ i : Fin n, (Nat.choose (s i).val (I i).val : ℤ) *
    (α i) ^ ((s i).val - (I i).val)

/-! ## I = 0 case: standard monomial evaluation -/

/-- **🚨 Wave T5 session 559eee — `vanishingMatrixEntry 0 α s = ∏ α i^(s i)`**.

    With zero multi-index I = 0 (no derivatives), the matrix entry
    reduces to the standard monomial evaluation. -/
theorem T5_vanishingMatrixEntry_I_zero {n d : ℕ}
    (α : Fin n → ℤ) (s : BoundedMI n d) :
    vanishingMatrixEntry (fun _ : Fin n => (⟨0, Nat.succ_pos d⟩ : Fin (d + 1)))
      α s
      = ∏ i : Fin n, (α i) ^ (s i).val := by
  unfold vanishingMatrixEntry
  apply Finset.prod_congr rfl
  intro i _
  simp [Nat.choose_zero_right]

/-! ## Diagonal I = s case -/

/-- **🚨 Wave T5 session 559eee — `vanishingMatrixEntry s α s = 1`**.

    Diagonal case I = s: each factor is `Nat.choose (s i) (s i) * α i^0 = 1 * 1 = 1`. -/
theorem T5_vanishingMatrixEntry_I_eq_s {n d : ℕ}
    (s : BoundedMI n d) (α : Fin n → ℤ) :
    vanishingMatrixEntry s α s = 1 := by
  unfold vanishingMatrixEntry
  apply Finset.prod_eq_one
  intro i _
  rw [Nat.sub_self]
  simp [Nat.choose_self]

/-! ## I component exceeds s component → entry zero (single-component) -/

/-- **🚨 Wave T5 session 559eee — single-component overflow yields 0**.

    If some component `(s i).val < (I i).val`, then the entry is 0
    because `Nat.choose (s i) (I i) = 0`. -/
theorem T5_vanishingMatrixEntry_lt_zero {n d : ℕ}
    (I : BoundedMI n d) (α : Fin n → ℤ) (s : BoundedMI n d)
    (i : Fin n) (h : (s i).val < (I i).val) :
    vanishingMatrixEntry I α s = 0 := by
  unfold vanishingMatrixEntry
  classical
  rw [← Finset.insert_erase (Finset.mem_univ i)]
  rw [Finset.prod_insert (Finset.notMem_erase _ _)]
  rw [Nat.choose_eq_zero_of_lt h]
  simp

/-! ## VanishingMatrixEntry Prop scaffold -/

/-- **VanishingMatrixEntry**: 3-conjunct Prop packaging the closed-form
    definition + I=0 case + I=s diagonal + single-component overflow. -/
def VanishingMatrixEntry : Prop :=
  (∀ {n d : ℕ} (α : Fin n → ℤ) (s : BoundedMI n d),
    vanishingMatrixEntry (fun _ : Fin n => (⟨0, Nat.succ_pos d⟩ : Fin (d + 1)))
      α s = ∏ i : Fin n, (α i) ^ (s i).val) ∧
  (∀ {n d : ℕ} (s : BoundedMI n d) (α : Fin n → ℤ),
    vanishingMatrixEntry s α s = 1) ∧
  (∀ {n d : ℕ} (I : BoundedMI n d) (α : Fin n → ℤ) (s : BoundedMI n d)
    (i : Fin n), (s i).val < (I i).val →
    vanishingMatrixEntry I α s = 0)

/-- **🚨 Wave T5 session 559eee — `VanishingMatrixEntry`**. -/
theorem T5_vanishing_matrix_entry : VanishingMatrixEntry :=
  ⟨@T5_vanishingMatrixEntry_I_zero,
   @T5_vanishingMatrixEntry_I_eq_s,
   @T5_vanishingMatrixEntry_lt_zero⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559eee — T-5 Phase 7 ext #12: vanishing matrix entry**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #12.

    Concrete closed-form definition of the Schmidt-Wirsing-Roth
    vanishing matrix entry:

        vanishingMatrixEntry I α s :=
          ∏ i, (Nat.choose (s i) (I i)) * α i^((s i) - (I i))

    encoding `(1/I!) ∂^I (X^s)|_{α}` for integer point α.

    Three derivations + Prop:
    1. `T5_vanishingMatrixEntry_I_zero` — at I = 0 reduces to monomial
       evaluation `∏ α i^(s i)`
    2. `T5_vanishingMatrixEntry_I_eq_s` — diagonal case = 1
    3. `T5_vanishingMatrixEntry_lt_zero` — single-component overflow
       yields 0 (matching calculus `∂^I = 0` when |I| > |s|)
    + VanishingMatrixEntry Prop (3-conjunct).

    Mathlib usage: `Nat.choose_zero_right`, `Nat.choose_self`,
    `Nat.choose_eq_zero_of_lt`, `Finset.prod_eq_zero`,
    `Finset.prod_congr`.

    Sub-lemma 205/N in T-1 (T-5 Phase 7 ext #12).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 vanishing matrix entry
    closed-form definition with structural special-case lemmas. -/
theorem session_559eee_T5_phase7_vanishing_matrix_entry_headline :
    VanishingMatrixEntry :=
  T5_vanishing_matrix_entry

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_VanishingMatrixEntry
