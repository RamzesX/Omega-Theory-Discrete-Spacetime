/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMultiIndex

  T-5 (Roth's theorem) — **Phase 7 ext #3: bounded multi-index Fintype**,
  sub session 559vv — STRICT critical-path #316 (T-5) Phase 7 ext #3.

  Single-thread hand-authored 2026-04-28 (cycle 65 — /loop dynamic).

  ## What this file delivers

  Concrete bounded multi-index type `BoundedMI n d := Fin n → Fin (d+1)`
  with automatic Fintype instance and explicit cardinality
  `(d+1)^n` — this is the index set for the Roth auxiliary-polynomial
  coefficient vector when interfacing with Mathlib's
  `Int.Matrix.exists_ne_zero_int_vec_norm_le` (s559rr).

  Three derivations + Prop:
  1. `BoundedMI` definition (Pi-type, automatic Fintype)
  2. `T5_boundedMI_card`: card = (d+1)^n
  3. `T5_boundedMI_card_pos`: card ≥ 1 (always non-empty)

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #3 — Fintype foundation for the polynomial-vector
  bijection.  With `BoundedMI n d` as the index set, a
  `BoundedMI n d → ℤ` function corresponds to an integer-coefficient
  bounded-degree polynomial in `MvPolynomial (Fin n) ℤ`, which is
  the natural input form for SiegelsLemma.
-/

import Mathlib.Data.Fintype.BigOperators
import Mathlib.Data.Fintype.Pi
import Mathlib.Data.Fintype.Fin

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMultiIndex

/-! ## Bounded multi-index type -/

/-- `BoundedMI n d := Fin n → Fin (d + 1)` — the type of multi-indices
    `j : Fin n → ℕ` with each component `j i ≤ d`, encoded as a
    function into `Fin (d+1)` so that the bound is in the type.

    `Fin n → Fin (d+1)` is automatically `Fintype` with cardinality
    `(d+1)^n` via `Pi` instance. -/
def BoundedMI (n d : ℕ) : Type := Fin n → Fin (d + 1)

instance instFintypeBoundedMI (n d : ℕ) : Fintype (BoundedMI n d) :=
  inferInstanceAs (Fintype (Fin n → Fin (d + 1)))

instance instDecidableEqBoundedMI (n d : ℕ) : DecidableEq (BoundedMI n d) :=
  inferInstanceAs (DecidableEq (Fin n → Fin (d + 1)))

instance instInhabitedBoundedMI (n d : ℕ) : Inhabited (BoundedMI n d) :=
  ⟨fun _ => ⟨0, Nat.succ_pos d⟩⟩

/-! ## Cardinality -/

/-- **🚨 Wave T5 session 559vv — `BoundedMI n d` cardinality = `(d+1)^n`**.

    Direct corollary of `Fintype.card_fun` on `Fin n → Fin (d+1)`. -/
theorem T5_boundedMI_card (n d : ℕ) :
    Fintype.card (BoundedMI n d) = (d + 1) ^ n := by
  show Fintype.card (Fin n → Fin (d + 1)) = (d + 1) ^ n
  rw [Fintype.card_fun, Fintype.card_fin, Fintype.card_fin]

/-- **🚨 Wave T5 session 559vv — `BoundedMI n d` always non-empty**. -/
theorem T5_boundedMI_card_pos (n d : ℕ) :
    0 < Fintype.card (BoundedMI n d) := by
  rw [T5_boundedMI_card]
  exact Nat.pow_pos (Nat.succ_pos d)

/-! ## BoundedMultiIndex Prop scaffold -/

/-- **BoundedMultiIndex**: 2-conjunct Prop packaging the bounded
    multi-index Fintype + cardinality. -/
def BoundedMultiIndex : Prop :=
  (∀ (n d : ℕ), Fintype.card (BoundedMI n d) = (d + 1) ^ n) ∧
  (∀ (n d : ℕ), 0 < Fintype.card (BoundedMI n d))

/-- **🚨 Wave T5 session 559vv — `BoundedMultiIndex`**. -/
theorem T5_bounded_multi_index : BoundedMultiIndex :=
  ⟨T5_boundedMI_card, T5_boundedMI_card_pos⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559vv — T-5 Phase 7 ext #3: bounded multi-index Fintype**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #3.

    Defines `BoundedMI n d := Fin n → Fin (d + 1)` — the type of
    multi-indices `j : Fin n → ℕ` with each component `≤ d`, with
    automatic Fintype + DecidableEq + Inhabited instances and explicit
    cardinality `(d+1)^n`.

    Two main theorems + Prop:
    1. `T5_boundedMI_card`: |BoundedMI n d| = (d+1)^n
    2. `T5_boundedMI_card_pos`: always ≥ 1 (since (d+1)^n ≥ 1)

    + BoundedMultiIndex Prop (2-conjunct).

    This is the index set β in the SiegelsLemma application:
    `Int.Matrix.exists_ne_zero_int_vec_norm_le (A : Matrix α β ℤ)`
    with `β = BoundedMI n d` enumerating monomial coefficients of
    a degree-≤d polynomial in n variables.

    Per opus-code-crawler intel: card β = (d+1)^n is the number of
    coefficient unknowns in the Roth-Schmidt-Wirsing auxiliary
    polynomial linear system; the dimension count card α < card β
    drives Siegel's existence proof.

    Mathlib usage: `Fintype.card_fun`, `Fintype.card_fin`,
    `Pi` Fintype instance, `Nat.pos_pow_of_pos`.

    Sub-lemma 196/N in T-1 (T-5 Phase 7 ext #3).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 bounded multi-index Fintype. -/
theorem session_559vv_T5_phase7_bounded_multi_index_headline :
    BoundedMultiIndex :=
  T5_bounded_multi_index

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMultiIndex
