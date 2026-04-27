/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_SiegelLemma

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 117.
  Siegel's Lemma — direct citation from Mathlib.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Mathlib v4.29 LANDED Siegel's Lemma in 2024 at
  `Mathlib/NumberTheory/SiegelsLemma.lean` (Barroero, Capuano, Turchet).
  This was the feared hard piece for Roth's theorem port — and it's
  FREE.

  Re-exports for OV2 use:

  1. **`T5_siegel_lemma`** : Given a non-zero `m × n` integer matrix
     `A` with `m < n`, there's a non-zero integer vector `t` with
     `Matrix.mulVec A t = 0` and `‖t‖ ≤ (n * ‖A‖) ^ ((m : ℝ) / (n - m))`.
  2. **`T5_siegel_lemma_max1`** : Variant without `A ≠ 0` requirement
     (uses `max 1 ‖A‖`).

  Used in T-5 to construct the auxiliary polynomial in Roth's lemma —
  the underdetermined linear system corresponds to choosing polynomial
  coefficients to vanish to high order at a target point.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.NumberTheory.SiegelsLemma

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_SiegelLemma

open Int.Matrix

-- Local sup-norm on matrices (Mathlib's SiegelsLemma uses this scoped instance)
attribute [local instance] Matrix.seminormedAddCommGroup

variable {α β : Type*} [Fintype α] [Fintype β]

/-! ## Siegel's Lemma — fundamental version -/

/-- **Wave T5 session 117 — Siegel's Lemma (max-1 version)**.

    Given a `m × n` integer matrix `A` with `m < n`, there exists a
    non-zero integer vector `t` with `Matrix.mulVec A t = 0` and bounded norm. -/
theorem T5_siegel_lemma_max1 (A : Matrix α β ℤ)
    (hn : Fintype.card α < Fintype.card β)
    (hm : 0 < Fintype.card α) :
    ∃ t : β → ℤ, t ≠ 0 ∧ Matrix.mulVec A t = 0 ∧
      ‖t‖ ≤ (Fintype.card β * max 1 ‖A‖) ^
        ((Fintype.card α : ℝ) / (Fintype.card β - Fintype.card α)) :=
  Int.Matrix.exists_ne_zero_int_vec_norm_le A hn hm

/-- **Wave T5 session 117 — Siegel's Lemma (sharp version)**.

    Same as above, but with `‖A‖` (not `max 1 ‖A‖`) when `A ≠ 0`.
    This is the version used in Roth's lemma. -/
theorem T5_siegel_lemma (A : Matrix α β ℤ)
    (hn : Fintype.card α < Fintype.card β)
    (hm : 0 < Fintype.card α) (hA : A ≠ 0) :
    ∃ t : β → ℤ, t ≠ 0 ∧ Matrix.mulVec A t = 0 ∧
      ‖t‖ ≤ (Fintype.card β * ‖A‖) ^
        ((Fintype.card α : ℝ) / (Fintype.card β - Fintype.card α)) :=
  Int.Matrix.exists_ne_zero_int_vec_norm_le' A hn hm hA

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 117 — Siegel's Lemma direct cite**.

    Two formulations of Siegel's Lemma from Mathlib's
    `Int.Matrix.exists_ne_zero_int_vec_norm_le{,'}`:

    1. With `max 1 ‖A‖` (always applies).
    2. With `‖A‖` (sharper, requires `A ≠ 0`).

    THE foundational tool of diophantine approximation/transcendence —
    Roth's theorem, Hermite-Lindemann, Schmidt's subspace theorem all
    use this in their auxiliary-polynomial construction.

    Sub-lemma 7/N in T-5 Phase 3.  Lean-core only.

    BIGGEST WIN OF CYCLE 65 — the feared hard piece for Roth's lemma
    is FREE from Mathlib (Barroero/Capuano/Turchet 2024). -/
theorem session_117_siegel_lemma_headline
    {α β : Type*} [Fintype α] [Fintype β] :
    -- (1) max-1 version
    (∀ (A : Matrix α β ℤ),
        Fintype.card α < Fintype.card β →
        0 < Fintype.card α →
        ∃ t : β → ℤ, t ≠ 0 ∧ Matrix.mulVec A t = 0 ∧
          ‖t‖ ≤ (Fintype.card β * max 1 ‖A‖) ^
            ((Fintype.card α : ℝ) / (Fintype.card β - Fintype.card α)))
    -- (2) sharp version
    ∧ (∀ (A : Matrix α β ℤ),
        Fintype.card α < Fintype.card β →
        0 < Fintype.card α → A ≠ 0 →
        ∃ t : β → ℤ, t ≠ 0 ∧ Matrix.mulVec A t = 0 ∧
          ‖t‖ ≤ (Fintype.card β * ‖A‖) ^
            ((Fintype.card α : ℝ) / (Fintype.card β - Fintype.card α))) :=
  ⟨T5_siegel_lemma_max1, T5_siegel_lemma⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_SiegelLemma
