/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLarge_BlockD_IntegerNonVanish

  T-5 (Roth's theorem) — **D.7 Block D: integer non-vanishing lower bound foundations**.

  Foundational sub-lemmas establishing the integer-coefficient
  arithmetic for Block D of D.7:

  - D-1..3: trivial existence of rational eval₂ + arithmetic.
  - D-4..5: integer-coefficient witness existence + non-vanishing
    bridge.
  - D-6: marker.

  Single-thread hand-authored 2026-04-29.

  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Algebra.Polynomial.RingDivision
import Mathlib.Algebra.Polynomial.Eval.Defs

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLarge_BlockD_IntegerNonVanish

open Polynomial

/-! ## D-1 — Eval₂ exists as rational -/

/-- **D-1 — `T5_int_poly_eval₂_rat_eq`**: for `p : ℤ[X]` and `q : ℚ`,
    the eval₂ exists as a rational number. -/
theorem T5_int_poly_eval₂_rat_eq (p : Polynomial ℤ) (q : ℚ) :
    ∃ (r : ℚ), Polynomial.eval₂ (Int.castRingHom ℚ) q p = r :=
  ⟨_, rfl⟩

/-! ## D-2 — Eval₂ at 0 -/

/-- **D-2 — `T5_int_poly_eval₂_at_zero`**: `eval₂ ι 0 p = ι (p.coeff 0)`.
    Mathlib `Polynomial.eval₂_at_zero` gives the form. -/
theorem T5_int_poly_eval₂_at_zero (p : Polynomial ℤ) :
    Polynomial.eval₂ (Int.castRingHom ℚ) 0 p =
      (Int.castRingHom ℚ) (p.coeff 0) := by
  exact Polynomial.eval₂_at_zero _

/-! ## D-3 — Eval at 0 = coeff 0 -/

/-- **D-3 — `T5_eval_zero_eq_coeff_zero_int`**: `eval 0 p = p.coeff 0`. -/
theorem T5_eval_zero_eq_coeff_zero_int (p : Polynomial ℤ) :
    Polynomial.eval (0 : ℤ) p = p.coeff 0 := by
  simp [Polynomial.eval_eq_sum, Polynomial.sum_def]
  by_cases h : p.coeff 0 = 0
  · rw [h]
    apply Finset.sum_eq_zero
    intro x hx
    rcases Nat.eq_zero_or_pos x with hx0 | hxpos
    · subst hx0; rw [pow_zero, mul_one]; exact h
    · rw [zero_pow (Nat.pos_iff_ne_zero.mp hxpos), mul_zero]
  · have h0_supp : 0 ∈ p.support := Polynomial.mem_support_iff.mpr h
    rw [Finset.sum_eq_single (0 : ℕ)]
    · simp
    · intro b hb hb_ne_zero
      rcases Nat.pos_iff_ne_zero.mpr hb_ne_zero with hbp
      rw [zero_pow hb_ne_zero, mul_zero]
    · intro h_not
      exact absurd h0_supp h_not

/-! ## D-4 — Eval₂ via map -/

/-- **D-4 — `T5_int_poly_eval₂_via_map`**: `eval₂ f x p = eval x (p.map f)`.
    Standard Mathlib `Polynomial.eval₂_eq_eval_map`. -/
theorem T5_int_poly_eval₂_via_map
    (p : Polynomial ℤ) (q : ℚ) :
    Polynomial.eval₂ (Int.castRingHom ℚ) q p = Polynomial.eval q (p.map (Int.castRingHom ℚ)) :=
  Polynomial.eval₂_eq_eval_map _

/-! ## D-5 — Integer non-vanishing bridge -/

/-- **D-5 — `T5_int_poly_eval₂_nonzero_via_int_witness`**: if for some
    integer `m ≠ 0` the rational eval₂ scaled by integer denominator
    equals `(m : ℚ)`, then the rational eval₂ is non-zero. -/
theorem T5_int_poly_eval₂_nonzero_via_int_witness
    (p : Polynomial ℤ) (q : ℚ) (D : ℚ) (m : ℤ)
    (hD_ne : D ≠ 0)
    (h_eq : Polynomial.eval₂ (Int.castRingHom ℚ) q p * D = (m : ℚ))
    (h_m_ne : m ≠ 0) :
    Polynomial.eval₂ (Int.castRingHom ℚ) q p ≠ 0 := by
  intro hzero
  rw [hzero, zero_mul] at h_eq
  apply h_m_ne
  exact_mod_cast h_eq.symm

/-! ## D-6 — Block D foundational marker -/

/-- **D-6 — `T5_BlockD_foundational_marker`**: 4-conjunct marker for
    Block D foundational sub-lemmas. -/
theorem T5_BlockD_foundational_marker :
    (∀ (p : Polynomial ℤ) (q : ℚ),
      ∃ (r : ℚ), Polynomial.eval₂ (Int.castRingHom ℚ) q p = r) ∧
    (∀ (p : Polynomial ℤ),
      Polynomial.eval₂ (Int.castRingHom ℚ) 0 p =
        (Int.castRingHom ℚ) (p.coeff 0)) ∧
    (∀ (p : Polynomial ℤ),
      Polynomial.eval (0 : ℤ) p = p.coeff 0) ∧
    (∀ (p : Polynomial ℤ) (q : ℚ),
      Polynomial.eval₂ (Int.castRingHom ℚ) q p =
        Polynomial.eval q (p.map (Int.castRingHom ℚ))) :=
  ⟨T5_int_poly_eval₂_rat_eq,
   T5_int_poly_eval₂_at_zero,
   T5_eval_zero_eq_coeff_zero_int,
   T5_int_poly_eval₂_via_map⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLarge_BlockD_IntegerNonVanish
