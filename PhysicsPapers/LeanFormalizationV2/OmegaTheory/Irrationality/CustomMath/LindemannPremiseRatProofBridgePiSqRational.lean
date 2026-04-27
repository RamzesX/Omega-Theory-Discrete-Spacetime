/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofBridgePiSqRational

  Cycle 63 (Pisces, plan v2) Phase B Wave T-4b session 24 — discharge
  bridge sub-case where π² ∈ ℚ.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Discharges a SUB-CASE of the high-degree L-W expansion bridge:

  GIVEN `q : ℚ` with `(Real.pi : ℝ)^2 = (q : ℝ)` (i.e., π² ∈ ℚ), the
  bridge sub-case holds via the explicit polynomial `q.den · X² + q.num`.

  Construction:
  1. Take `f := C q.den * X² + C 0 * X + C q.num : ℤ[X]`.
  2. Apply Mathlib's `Polynomial.aroots_quadratic_eq_pair_iff_of_ne_zero`
     to show `f.aroots ℂ = {iπ, -iπ}`.
  3. Compute `((f.aroots).map exp).sum = exp(iπ) + exp(-iπ) = -1 + -1 = -2` (Euler).
  4. Set m = 2.

  Verifies the bridge for the π² ∈ ℚ sub-case.  Remains for cycle 64+
  (genuine L-W frontier): π² ∉ ℚ case (minpoly of iπ has degree ≥ 4).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofBridgeReduction
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.RingTheory.Polynomial.SmallDegreeVieta

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofBridgePiSqRational

open Polynomial Complex

/-! ## Construction of the explicit polynomial -/

/-- The polynomial `b·X² + 0·X + a` for `b : ℕ` (positive) and `a : ℤ`. -/
noncomputable def quadPoly (a : ℤ) (b : ℕ) : Polynomial ℤ :=
  Polynomial.C (b : ℤ) * Polynomial.X^2 + Polynomial.C (0 : ℤ) * Polynomial.X +
  Polynomial.C a

/-- `quadPoly a b ≠ 0` when `b ≠ 0`. -/
theorem quadPoly_ne_zero (a : ℤ) (b : ℕ) (h_b_pos : 0 < b) :
    quadPoly a b ≠ 0 := by
  unfold quadPoly
  intro h_eq
  have h_b_ne : (b : ℤ) ≠ 0 := by exact_mod_cast Nat.pos_iff_ne_zero.mp h_b_pos
  have h_natDeg : (Polynomial.C (b : ℤ) * Polynomial.X^2 +
                   Polynomial.C (0 : ℤ) * Polynomial.X +
                   Polynomial.C a).natDegree = 2 := by
    have h_step1 : Polynomial.C (b : ℤ) * Polynomial.X^2 +
                   Polynomial.C (0 : ℤ) * Polynomial.X +
                   Polynomial.C a
                 = Polynomial.C (b : ℤ) * Polynomial.X^2 + Polynomial.C a := by
      simp
    rw [h_step1, Polynomial.natDegree_add_C, Polynomial.natDegree_C_mul h_b_ne,
        Polynomial.natDegree_X_pow]
  rw [h_eq] at h_natDeg
  simp at h_natDeg

/-- `(quadPoly a b).eval 0 = a`. -/
theorem quadPoly_eval_zero (a : ℤ) (b : ℕ) :
    Polynomial.eval 0 (quadPoly a b) = a := by
  unfold quadPoly
  simp

/-! ## aroots multiset analysis via Mathlib's Vieta -/

/-- `(quadPoly a b).aroots ℂ = {iπ, -iπ}` when `π² = a/b` and a, b appropriate. -/
theorem aroots_quadPoly_eq_iPi_pair
    (a : ℤ) (b : ℕ)
    (h_pi_sq : (Real.pi : ℝ)^2 = ((a : ℚ) / (b : ℚ) : ℝ))
    (h_b_pos : 0 < b) :
    (quadPoly a b).aroots ℂ =
      {Complex.I * (Real.pi : ℂ), -(Complex.I * (Real.pi : ℂ))} := by
  unfold quadPoly
  have h_b_C_ne : ((b : ℤ) : ℂ) ≠ 0 := by
    have h_b_ne : (b : ℤ) ≠ 0 := by exact_mod_cast Nat.pos_iff_ne_zero.mp h_b_pos
    exact_mod_cast h_b_ne
  rw [Polynomial.aroots_quadratic_eq_pair_iff_of_ne_zero h_b_C_ne]
  refine ⟨?_, ?_⟩
  · -- (algebraMap ℤ ℂ) 0 = -(algebraMap ℤ ℂ b) * (iπ + -iπ)
    show ((0 : ℤ) : ℂ) =
        -((b : ℤ) : ℂ) * (Complex.I * (Real.pi : ℂ) + -(Complex.I * (Real.pi : ℂ)))
    ring
  · -- (algebraMap ℤ ℂ) a = (algebraMap ℤ ℂ b) * iπ * (-iπ)
    show ((a : ℤ) : ℂ) =
        ((b : ℤ) : ℂ) * (Complex.I * (Real.pi : ℂ)) * -(Complex.I * (Real.pi : ℂ))
    -- b * iπ * (-iπ) = -b * (iπ)² = -b * (-π²) = b * π²
    have h_simp : ((b : ℤ) : ℂ) * (Complex.I * (Real.pi : ℂ)) *
                   -(Complex.I * (Real.pi : ℂ))
                = ((b : ℤ) : ℂ) * (Real.pi : ℂ)^2 := by
      have h_I_sq : Complex.I^2 = -1 := Complex.I_sq
      ring_nf
      rw [show Complex.I^2 = -1 from Complex.I_sq]
      ring
    rw [h_simp]
    -- Goal: (a : ℂ) = (b : ℂ) * (π : ℂ)²
    -- π² = a/b, so b · π² = a
    have h_pi_sq_C : ((Real.pi : ℂ))^2 = ((a : ℚ) / (b : ℚ) : ℂ) := by
      have h1 : ((Real.pi : ℂ))^2 = (((Real.pi : ℝ)^2 : ℝ) : ℂ) := by
        push_cast; ring
      rw [h1, h_pi_sq]
      push_cast; rfl
    rw [h_pi_sq_C]
    have h_b_ne : (b : ℂ) ≠ 0 := by exact_mod_cast Nat.pos_iff_ne_zero.mp h_b_pos
    push_cast
    field_simp

/-! ## The exp-sum identity -/

/-- For iπ and -iπ, `exp(iπ) + exp(-iπ) = -2`. -/
theorem exp_iPi_plus_exp_neg_iPi :
    Complex.exp (Complex.I * (Real.pi : ℂ)) +
    Complex.exp (-(Complex.I * (Real.pi : ℂ))) = -2 := by
  have h_iPi : Complex.exp (Complex.I * (Real.pi : ℂ)) = -1 := by
    rw [show (Complex.I * (Real.pi : ℂ)) = ((Real.pi : ℂ) * Complex.I) from by ring]
    exact Complex.exp_pi_mul_I
  have h_neg_iPi : Complex.exp (-(Complex.I * (Real.pi : ℂ))) = -1 := by
    rw [Complex.exp_neg, h_iPi]
    norm_num
  rw [h_iPi, h_neg_iPi]
  ring

/-! ## Main bridge sub-case theorem -/

/-- **Wave T4b session 24 — bridge discharge for π² ∈ ℚ sub-case**. -/
theorem bridge_pi_sq_rational
    (pQ : Polynomial ℚ) (_h_ne : pQ ≠ 0) (_h_natDeg_ge_2 : 2 ≤ pQ.natDegree)
    (_h_zero : Polynomial.aeval (Real.pi : ℝ) pQ = 0)
    (q : ℚ) (h_pi_sq : (Real.pi : ℝ)^2 = (q : ℝ)) :
    ∃ h : Polynomial ℤ, ∃ m : ℕ,
      h ≠ 0 ∧ Polynomial.eval 0 h ≠ 0 ∧ 0 < m ∧
      ((h.aroots ℂ).map Complex.exp).sum = -(m : ℂ) := by
  set b : ℕ := q.den
  have h_b_pos : 0 < b := q.pos
  set a : ℤ := q.num
  have h_pi_sq' : (Real.pi : ℝ)^2 = ((a : ℚ) / (b : ℚ) : ℝ) := by
    rw [h_pi_sq]
    have h_q_eq : q = (a : ℚ) / (b : ℚ) := (Rat.num_div_den q).symm
    rw [h_q_eq]
    push_cast
    rfl
  have h_pi_pos : 0 < Real.pi := Real.pi_pos
  have h_pi_sq_pos : 0 < (Real.pi : ℝ)^2 := pow_pos h_pi_pos 2
  have h_a_ne : a ≠ 0 := by
    intro h_a_zero
    have h_q_zero : q = 0 := by
      rw [Rat.zero_iff_num_zero]
      exact h_a_zero
    rw [h_q_zero] at h_pi_sq
    push_cast at h_pi_sq
    linarith [h_pi_sq, h_pi_sq_pos]
  refine ⟨quadPoly a b, 2, quadPoly_ne_zero a b h_b_pos, ?_, by omega, ?_⟩
  · rw [quadPoly_eval_zero]; exact h_a_ne
  · rw [aroots_quadPoly_eq_iPi_pair a b h_pi_sq' h_b_pos]
    -- Goal: (Multiset.map exp {iπ, -iπ}).sum = -(2 : ℂ)
    simp only [Multiset.insert_eq_cons, Multiset.map_cons, Multiset.map_singleton,
               Multiset.sum_cons, Multiset.sum_singleton]
    -- Goal becomes: exp(iπ) + exp(-iπ) = -(2 : ℂ)
    rw [exp_iPi_plus_exp_neg_iPi]
    push_cast; ring

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofBridgePiSqRational
