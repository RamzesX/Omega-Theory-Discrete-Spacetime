/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMIToFinsupp

  T-5 (Roth's theorem) — **Phase 7 ext #4: BoundedMI → Finsupp bridge**,
  sub session 559ww — STRICT critical-path #316 (T-5) Phase 7 ext #4.

  Single-thread hand-authored 2026-04-28 (cycle 65 — post-restart).

  ## What this file delivers

  Conversion from the bounded multi-index type `BoundedMI n d`
  (s559vv) to `Fin n →₀ ℕ` via Mathlib's `Finsupp.equivFunOnFinite`,
  with the bound `(toFinsupp j) i ≤ d` preserved.

  Three derivations + Prop:
  1. `T5_boundedMItoFinsupp`: conversion function via Finsupp.equivFunOnFinite.symm
  2. `T5_boundedMItoFinsupp_le`: bound preservation `(toFinsupp j) i ≤ d`
  3. `T5_boundedMItoFinsupp_zero`: `(toFinsupp 0) = 0` (zero multi-index)

  Bridges s559vv (BoundedMI Fintype) ↔ MvPolynomial monomial supports —
  prerequisite for the auxiliary-polynomial integer-coefficient
  vector ↔ polynomial bijection downstream.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #4 — bounded-MI to Finsupp bridge.  Combined with
  s559uu (monomial-restrictDegree), we get:
      `BoundedMI n d → ℤ` ↔ polynomial coefficients of
      `MvPolynomial (Fin n) ℤ` in `restrictDegree (Fin n) ℤ d`.
-/

import Mathlib.Data.Finsupp.Defs
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMultiIndex

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMIToFinsupp

open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMultiIndex

/-! ## BoundedMI → Finsupp conversion -/

/-- **🚨 Wave T5 session 559ww — `BoundedMI n d → (Fin n →₀ ℕ)` via Finsupp.equivFunOnFinite**.

    Converts a bounded multi-index `j : Fin n → Fin (d+1)` to a
    `Finsupp` by extracting the `Nat`-component and using
    `Finsupp.equivFunOnFinite.symm`. -/
noncomputable def T5_boundedMItoFinsupp {n d : ℕ} (j : BoundedMI n d) :
    Fin n →₀ ℕ :=
  Finsupp.equivFunOnFinite.symm (fun i => (j i).val)

/-! ## Bound preservation -/

/-- **🚨 Wave T5 session 559ww — `(toFinsupp j) i ≤ d`**.

    The Finsupp produced from a `BoundedMI n d` has every component
    bounded by `d` — directly via `Fin (d+1)`'s value bound. -/
theorem T5_boundedMItoFinsupp_le {n d : ℕ} (j : BoundedMI n d) (i : Fin n) :
    (T5_boundedMItoFinsupp j) i ≤ d := by
  unfold T5_boundedMItoFinsupp
  rw [Finsupp.equivFunOnFinite_symm_apply_apply]
  -- Goal: (j i).val ≤ d
  -- (j i) : Fin (d + 1), so (j i).val < d + 1, i.e. (j i).val ≤ d
  exact Nat.lt_succ_iff.mp (j i).isLt

/-! ## Zero multi-index goes to zero Finsupp -/

/-- **🚨 Wave T5 session 559ww — `toFinsupp (fun _ => 0) = 0`**.

    The all-zero bounded multi-index converts to the zero Finsupp. -/
theorem T5_boundedMItoFinsupp_zero {n d : ℕ} :
    T5_boundedMItoFinsupp (fun _ : Fin n => (⟨0, Nat.succ_pos d⟩ : Fin (d + 1)))
      = (0 : Fin n →₀ ℕ) := by
  unfold T5_boundedMItoFinsupp
  ext i
  rw [Finsupp.equivFunOnFinite_symm_apply_apply]
  simp

/-! ## BoundedMIToFinsupp Prop scaffold -/

/-- **BoundedMIToFinsupp**: 2-conjunct Prop packaging the
    BoundedMI → Finsupp bridge. -/
def BoundedMIToFinsupp : Prop :=
  (∀ {n d : ℕ} (j : BoundedMI n d) (i : Fin n),
    (T5_boundedMItoFinsupp j) i ≤ d) ∧
  (∀ {n d : ℕ},
    T5_boundedMItoFinsupp (fun _ : Fin n => (⟨0, Nat.succ_pos d⟩ : Fin (d + 1)))
      = (0 : Fin n →₀ ℕ))

/-- **🚨 Wave T5 session 559ww — `BoundedMIToFinsupp`**. -/
theorem T5_bounded_MI_to_finsupp : BoundedMIToFinsupp :=
  ⟨@T5_boundedMItoFinsupp_le,
   @T5_boundedMItoFinsupp_zero⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559ww — T-5 Phase 7 ext #4: BoundedMI → Finsupp bridge**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #4.

    Three derivations + Prop:
    1. `T5_boundedMItoFinsupp`: conversion via Finsupp.equivFunOnFinite.symm
    2. `T5_boundedMItoFinsupp_le`: bound preservation `(toFinsupp j) i ≤ d`
    3. `T5_boundedMItoFinsupp_zero`: zero-multi-index → zero-Finsupp
    + BoundedMIToFinsupp Prop (2-conjunct).

    Bridges s559vv (BoundedMI n d Fintype with cardinality (d+1)^n)
    to `Fin n →₀ ℕ` (Mathlib's monomial multi-index type), enabling
    construction of polynomials with bounded support from
    `BoundedMI n d → ℤ` coefficient vectors.

    Combined with s559uu (monomial-restrictDegree bridge):
    a `BoundedMI n d → ℤ` function corresponds to an integer-
    coefficient polynomial in `restrictDegree (Fin n) ℤ d` —
    which is the input form for SiegelsLemma (s559rr exposed).

    Mathlib usage: `Finsupp.equivFunOnFinite`,
    `Finsupp.equivFunOnFinite_symm_apply_apply`,
    `Nat.lt_succ_iff`.

    Sub-lemma 197/N in T-1 (T-5 Phase 7 ext #4).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 BoundedMI ↔ Finsupp bridge. -/
theorem session_559ww_T5_phase7_bounded_MI_to_finsupp_headline :
    BoundedMIToFinsupp :=
  T5_bounded_MI_to_finsupp

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMIToFinsupp
