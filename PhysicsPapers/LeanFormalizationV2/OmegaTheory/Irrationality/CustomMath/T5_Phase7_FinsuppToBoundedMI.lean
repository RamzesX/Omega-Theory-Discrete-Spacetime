/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_FinsuppToBoundedMI

  T-5 (Roth's theorem) — **Phase 7 ext #6: inverse map Finsupp → BoundedMI**,
  sub session 559yy — STRICT critical-path #316 (T-5) Phase 7 ext #6.

  Single-thread hand-authored 2026-04-28 (cycle 65 — post-restart).

  ## What this file delivers

  Inverse direction of the s559ww `BoundedMI n d → (Fin n →₀ ℕ)`
  bijection: given a Finsupp `f : Fin n →₀ ℕ` with all components
  `≤ d`, build the corresponding `BoundedMI n d` element.  Plus
  the round-trip identities establishing the (refinement of) the
  full bijection `BoundedMI n d ≃ {f : Fin n →₀ ℕ // ∀ i, f i ≤ d}`.

  Three derivations + Prop:
  1. `T5_finsuppToBoundedMI`: `(f : Fin n →₀ ℕ) → (∀ i, f i ≤ d) → BoundedMI n d`
  2. `T5_finsuppToBoundedMI_toFinsupp`: round-trip BoundedMI → Finsupp → BoundedMI = id
  3. `T5_toFinsupp_finsuppToBoundedMI`: round-trip Finsupp → BoundedMI → Finsupp = id

  Combined with s559ww (`T5_boundedMItoFinsupp`), this gives a complete
  bijection between `BoundedMI n d` and the bounded-degree-d Finsupp
  subtype, which is the natural coefficient index set for
  `MvPolynomial (Fin n) ℤ` polynomials in `restrictDegree (Fin n) ℤ d`.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #6 — Finsupp ← BoundedMI inverse map.  Combined with
  s559uu (monomial-restrictDegree), s559vv (BoundedMI Fintype),
  s559ww (BoundedMI → Finsupp), and s559xx (auxiliary polynomial
  abstract via Siegel), this closes the categorical bijection at the
  multi-index level — the coefficient vector ↔ polynomial dictionary
  needed for the Phase 7 ext #8 concrete `AuxiliaryPolyExists`.
-/

import Mathlib.Data.Finsupp.Defs
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMultiIndex
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMIToFinsupp

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_FinsuppToBoundedMI

open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMultiIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMIToFinsupp

/-! ## Finsupp → BoundedMI inverse map -/

/-- **🚨 Wave T5 session 559yy — `(Fin n →₀ ℕ) → BoundedMI n d` (with bound)**.

    Given a Finsupp `f : Fin n →₀ ℕ` with the bound `∀ i, f i ≤ d`,
    produce the corresponding `BoundedMI n d = Fin n → Fin (d+1)`. -/
def T5_finsuppToBoundedMI {n d : ℕ} (f : Fin n →₀ ℕ)
    (h : ∀ i, f i ≤ d) : BoundedMI n d :=
  fun i => ⟨f i, Nat.lt_succ_of_le (h i)⟩

/-! ## Round-trip identities -/

/-- **🚨 Wave T5 session 559yy — BoundedMI → Finsupp → BoundedMI = id**.

    Going from a BoundedMI to its Finsupp form via s559ww and back via
    `T5_finsuppToBoundedMI` returns the original BoundedMI element. -/
theorem T5_finsuppToBoundedMI_toFinsupp {n d : ℕ} (j : BoundedMI n d)
    (h : ∀ i, (T5_boundedMItoFinsupp j) i ≤ d) :
    T5_finsuppToBoundedMI (T5_boundedMItoFinsupp j) h = j := by
  funext i
  apply Fin.val_injective
  show (T5_boundedMItoFinsupp j) i = (j i).val
  unfold T5_boundedMItoFinsupp
  rw [Finsupp.equivFunOnFinite_symm_apply_apply]

/-- **🚨 Wave T5 session 559yy — Finsupp → BoundedMI → Finsupp = id**.

    Going from a bounded Finsupp to BoundedMI via `T5_finsuppToBoundedMI`
    and back via s559ww returns the original Finsupp. -/
theorem T5_toFinsupp_finsuppToBoundedMI {n d : ℕ}
    (f : Fin n →₀ ℕ) (h : ∀ i, f i ≤ d) :
    T5_boundedMItoFinsupp (T5_finsuppToBoundedMI f h) = f := by
  ext i
  unfold T5_boundedMItoFinsupp T5_finsuppToBoundedMI
  rw [Finsupp.equivFunOnFinite_symm_apply_apply]

/-! ## FinsuppToBoundedMI Prop scaffold -/

/-- **FinsuppToBoundedMI**: 3-conjunct Prop packaging the inverse map
    + round-trip bijection identities. -/
def FinsuppToBoundedMI : Prop :=
  (∀ {n d : ℕ} (f : Fin n →₀ ℕ) (h : ∀ i, f i ≤ d),
    ∀ i, (T5_finsuppToBoundedMI f h i).val = f i) ∧
  (∀ {n d : ℕ} (j : BoundedMI n d)
    (h : ∀ i, (T5_boundedMItoFinsupp j) i ≤ d),
    T5_finsuppToBoundedMI (T5_boundedMItoFinsupp j) h = j) ∧
  (∀ {n d : ℕ} (f : Fin n →₀ ℕ) (h : ∀ i, f i ≤ d),
    T5_boundedMItoFinsupp (T5_finsuppToBoundedMI f h) = f)

/-- **🚨 Wave T5 session 559yy — `T5_finsuppToBoundedMI_val`** —
    component-extraction identity. -/
theorem T5_finsuppToBoundedMI_val {n d : ℕ} (f : Fin n →₀ ℕ)
    (h : ∀ i, f i ≤ d) (i : Fin n) :
    (T5_finsuppToBoundedMI f h i).val = f i := rfl

/-- **🚨 Wave T5 session 559yy — `FinsuppToBoundedMI`**. -/
theorem T5_finsupp_to_bounded_MI : FinsuppToBoundedMI :=
  ⟨@T5_finsuppToBoundedMI_val,
   @T5_finsuppToBoundedMI_toFinsupp,
   @T5_toFinsupp_finsuppToBoundedMI⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559yy — T-5 Phase 7 ext #6: Finsupp → BoundedMI inverse**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #6.

    Inverse direction of the s559ww `BoundedMI n d → (Fin n →₀ ℕ)` map.
    Together with s559ww, this closes the round-trip bijection
    `BoundedMI n d ≃ {f : Fin n →₀ ℕ // ∀ i, f i ≤ d}`.

    Three derivations + Prop:
    1. `T5_finsuppToBoundedMI`: build BoundedMI from bounded Finsupp
    2. `T5_finsuppToBoundedMI_toFinsupp`: round-trip starting BoundedMI
    3. `T5_toFinsupp_finsuppToBoundedMI`: round-trip starting Finsupp
    + `T5_finsuppToBoundedMI_val`: component-extraction
    + FinsuppToBoundedMI Prop (3-conjunct).

    Bridges s559vv/s559ww (BoundedMI Fintype + forward map) into the
    full bijection — provides the dictionary needed for Phase 7 ext #8
    `AuxiliaryPolyExists` to assemble a `BoundedMI n d → ℤ` coefficient
    vector (output of `AuxiliaryPolyAbstract` via Siegel) into a
    polynomial `p ∈ MvPolynomial.restrictDegree (Fin n) ℤ d` with the
    correct support indexing.

    Mathlib usage: `Finsupp.equivFunOnFinite`,
    `Finsupp.equivFunOnFinite_symm_apply_apply`, `Nat.lt_succ_of_le`.

    Sub-lemma 199/N in T-1 (T-5 Phase 7 ext #6).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 BoundedMI ↔ Finsupp full
    bijection closure. -/
theorem session_559yy_T5_phase7_finsupp_to_bounded_MI_headline :
    FinsuppToBoundedMI :=
  T5_finsupp_to_bounded_MI

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_FinsuppToBoundedMI
