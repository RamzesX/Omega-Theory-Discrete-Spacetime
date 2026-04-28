/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_AuxiliaryPolyAbstract

  T-5 (Roth's theorem) — **Phase 7 ext #5: abstract auxiliary polynomial
  existence via SiegelsLemma**, sub session 559xx — STRICT
  critical-path #316 (T-5) Phase 7 ext #5.

  Single-thread hand-authored 2026-04-28 (cycle 65 — /loop dynamic).

  ## What this file delivers

  Direct reduction of the Roth-Schmidt-Wirsing auxiliary polynomial
  existence to Mathlib's SiegelsLemma (re-exposed in s559rr) via the
  bounded multi-index Fintype with cardinality `(d+1)^n` (s559vv).

  Given:
  - a finite index type `J` for the vanishing-row equations
  - a matrix `M : Matrix J (BoundedMI n d) ℤ` encoding the linear
    constraints on the polynomial coefficient vector
  - the dimension inequality `Fintype.card J < (d+1)^n`
  - `0 < Fintype.card J`

  Siegel's Lemma produces:
  - a non-zero integer coefficient vector `p : BoundedMI n d → ℤ`
  - satisfying `M *ᵥ p = 0` (all vanishing rows hold)
  - with sup-norm bound
    `‖p‖ ≤ ((d+1)^n · max 1 ‖M‖)^(card J / ((d+1)^n - card J))`

  Three derivations + Prop:
  1. `T5_auxiliary_poly_abstract_exists`: existence of non-zero integer
     polynomial coefficient vector annihilating the constraint matrix
     (no norm bound — pure existence form)
  2. `T5_auxiliary_poly_abstract_exists_with_bound`: same + norm bound
  3. `T5_auxiliary_poly_abstract_exists_nonzero_M`: tighter bound when
     M ≠ 0 (drops the `max 1` clause)

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #5 — abstract auxiliary polynomial existence.

  This is the pivotal bridge between Mathlib's matrix-level Siegel and
  the polynomial-level Roth-Schmidt-Wirsing argument.  Subsequent ext
  iterations will:
  - construct the concrete vanishing matrix `M` from polynomial
    derivative-evaluation linear functionals (ext #6: IteratedPDeriv,
    ext #7: VanishingRowMatrix)
  - assemble the existence chain into the full Roth main theorem
    (ext #8: AuxiliaryPolyExists concrete + analytical bound +
    integer contradiction)
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SiegelsLemmaExpose
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMultiIndex

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_AuxiliaryPolyAbstract

open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SiegelsLemmaExpose
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMultiIndex
open Matrix

attribute [local instance] Matrix.seminormedAddCommGroup

/-! ## Pure existence form -/

/-- **🚨 Wave T5 session 559xx — Abstract auxiliary polynomial existence (pure)**.

    Given any matrix `M : Matrix J (BoundedMI n d) ℤ` with
    `Fintype.card J < (d+1)^n`, there exists a non-zero integer
    coefficient vector `p : BoundedMI n d → ℤ` with `M *ᵥ p = 0`.

    Direct corollary of `T5_siegel_int_matrix_existence` at α = J,
    β = BoundedMI n d, combined with `T5_boundedMI_card` to convert
    the dimension hypothesis. -/
theorem T5_auxiliary_poly_abstract_exists
    {n d : ℕ} {J : Type*} [Fintype J]
    (M : Matrix J (BoundedMI n d) ℤ)
    (h_dim : Fintype.card J < (d + 1) ^ n)
    (h_J_pos : 0 < Fintype.card J) :
    ∃ p : BoundedMI n d → ℤ, p ≠ 0 ∧ M *ᵥ p = 0 := by
  have h_card : Fintype.card (BoundedMI n d) = (d + 1) ^ n :=
    T5_boundedMI_card n d
  have h_card_lt : Fintype.card J < Fintype.card (BoundedMI n d) := by
    rw [h_card]; exact h_dim
  obtain ⟨p, hp_ne, hp_eq, _⟩ :=
    T5_siegel_int_matrix_existence M h_card_lt h_J_pos
  exact ⟨p, hp_ne, hp_eq⟩

/-! ## With explicit norm bound -/

/-- **🚨 Wave T5 session 559xx — Abstract auxiliary polynomial existence (with bound)**.

    Same as `T5_auxiliary_poly_abstract_exists` but retains the
    Siegel sup-norm bound on the coefficient vector. -/
theorem T5_auxiliary_poly_abstract_exists_with_bound
    {n d : ℕ} {J : Type*} [Fintype J]
    (M : Matrix J (BoundedMI n d) ℤ)
    (h_dim : Fintype.card J < (d + 1) ^ n)
    (h_J_pos : 0 < Fintype.card J) :
    ∃ p : BoundedMI n d → ℤ, p ≠ 0 ∧ M *ᵥ p = 0 ∧
    ‖p‖ ≤ (Fintype.card (BoundedMI n d) * max 1 ‖M‖) ^
          ((Fintype.card J : ℝ) /
           (Fintype.card (BoundedMI n d) - Fintype.card J)) := by
  have h_card : Fintype.card (BoundedMI n d) = (d + 1) ^ n :=
    T5_boundedMI_card n d
  have h_card_lt : Fintype.card J < Fintype.card (BoundedMI n d) := by
    rw [h_card]; exact h_dim
  exact T5_siegel_int_matrix_existence M h_card_lt h_J_pos

/-! ## Tighter form for non-zero M -/

/-- **🚨 Wave T5 session 559xx — Abstract auxiliary polynomial existence (non-zero M)**.

    Tighter bound when the constraint matrix `M ≠ 0` — drops the
    `max 1` clause around `‖M‖`. -/
theorem T5_auxiliary_poly_abstract_exists_nonzero_M
    {n d : ℕ} {J : Type*} [Fintype J]
    (M : Matrix J (BoundedMI n d) ℤ)
    (h_dim : Fintype.card J < (d + 1) ^ n)
    (h_J_pos : 0 < Fintype.card J)
    (hM : M ≠ 0) :
    ∃ p : BoundedMI n d → ℤ, p ≠ 0 ∧ M *ᵥ p = 0 ∧
    ‖p‖ ≤ (Fintype.card (BoundedMI n d) * ‖M‖) ^
          ((Fintype.card J : ℝ) /
           (Fintype.card (BoundedMI n d) - Fintype.card J)) := by
  have h_card : Fintype.card (BoundedMI n d) = (d + 1) ^ n :=
    T5_boundedMI_card n d
  have h_card_lt : Fintype.card J < Fintype.card (BoundedMI n d) := by
    rw [h_card]; exact h_dim
  exact T5_siegel_int_matrix_existence_nonzero_A M h_card_lt h_J_pos hM

/-! ## AuxiliaryPolyAbstract Prop scaffold -/

/-- **AuxiliaryPolyAbstract**: 3-conjunct Prop packaging the abstract
    auxiliary polynomial existence theorems via SiegelsLemma. -/
def AuxiliaryPolyAbstract : Prop :=
  (∀ {n d : ℕ} {J : Type*} [Fintype J]
    (M : Matrix J (BoundedMI n d) ℤ),
    Fintype.card J < (d + 1) ^ n →
    0 < Fintype.card J →
    ∃ p : BoundedMI n d → ℤ, p ≠ 0 ∧ M *ᵥ p = 0) ∧
  (∀ {n d : ℕ} {J : Type*} [Fintype J]
    (M : Matrix J (BoundedMI n d) ℤ),
    Fintype.card J < (d + 1) ^ n →
    0 < Fintype.card J →
    ∃ p : BoundedMI n d → ℤ, p ≠ 0 ∧ M *ᵥ p = 0 ∧
    ‖p‖ ≤ (Fintype.card (BoundedMI n d) * max 1 ‖M‖) ^
          ((Fintype.card J : ℝ) /
           (Fintype.card (BoundedMI n d) - Fintype.card J))) ∧
  (∀ {n d : ℕ} {J : Type*} [Fintype J]
    (M : Matrix J (BoundedMI n d) ℤ),
    Fintype.card J < (d + 1) ^ n →
    0 < Fintype.card J →
    M ≠ 0 →
    ∃ p : BoundedMI n d → ℤ, p ≠ 0 ∧ M *ᵥ p = 0 ∧
    ‖p‖ ≤ (Fintype.card (BoundedMI n d) * ‖M‖) ^
          ((Fintype.card J : ℝ) /
           (Fintype.card (BoundedMI n d) - Fintype.card J)))

/-- **🚨 Wave T5 session 559xx — `AuxiliaryPolyAbstract`**. -/
theorem T5_auxiliary_poly_abstract : AuxiliaryPolyAbstract :=
  ⟨@T5_auxiliary_poly_abstract_exists,
   @T5_auxiliary_poly_abstract_exists_with_bound,
   @T5_auxiliary_poly_abstract_exists_nonzero_M⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559xx — T-5 Phase 7 ext #5: abstract auxiliary polynomial existence**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #5.

    Direct reduction of Roth-Schmidt-Wirsing auxiliary polynomial
    existence to Mathlib's SiegelsLemma at the abstract Matrix level.

    Three forms + Prop:
    1. `T5_auxiliary_poly_abstract_exists` — pure existence
    2. `T5_auxiliary_poly_abstract_exists_with_bound` — Siegel norm
       bound on coefficient sup-norm
    3. `T5_auxiliary_poly_abstract_exists_nonzero_M` — tighter bound
       for M ≠ 0
    + AuxiliaryPolyAbstract Prop (3-conjunct).

    Combines Phase 7 ENTRY (s559rr SiegelsLemma re-export) with
    s559vv (BoundedMI n d Fintype, |BoundedMI n d| = (d+1)^n) to give
    the canonical "given a matrix encoding vanishing constraints with
    fewer rows than coefficient slots, there's a non-zero small
    integer coefficient solution" — the workhorse of Schmidt's
    auxiliary polynomial method.

    Mathlib usage: `Int.Matrix.exists_ne_zero_int_vec_norm_le` (and
    primed variant), via the s559rr re-export.

    Sub-lemma 198/N in T-1 (T-5 Phase 7 ext #5).
    Lean-core only.

    🏆 First Lean-core T-5 Phase 7 abstract auxiliary
    polynomial existence theorem. -/
theorem session_559xx_T5_phase7_auxiliary_poly_abstract_headline :
    AuxiliaryPolyAbstract :=
  T5_auxiliary_poly_abstract

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_AuxiliaryPolyAbstract
