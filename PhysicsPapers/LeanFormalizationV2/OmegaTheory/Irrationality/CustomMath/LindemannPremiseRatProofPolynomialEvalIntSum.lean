/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPolynomialEvalIntSum

  Cycle 62 (Pisces) Phase B Wave T-4b session 14 — Phase 4a linearity to
  arbitrary g : ℤ[X] over aroots.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  PROVES: For monic `f : ℤ[X]` and ANY polynomial `g : ℤ[X]`:

      ∃ N : ℤ, ((f.aroots ℂ).map (fun α => Polynomial.aeval α g)).sum = (N : ℂ)

  i.e. the sum of `g(α)` over `α ∈ f.aroots ℂ` is an integer.  This is
  the `(g)-linear extension` of Phase 3's power-sum integer result:
  evaluating any integer polynomial at the roots and summing yields an
  integer.

  Proof: expand `g(α) = ∑_j (g.coeff j) α^j` (via Mathlib
  `eval₂_eq_sum_range`), swap the Multiset sum with the Finset sum
  (Multiset induction), pull each constant `(g.coeff j : ℂ)` out via
  `Multiset.sum_map_mul_left`, then apply Phase 3 (session 13) to
  each individual power sum.

  This is the natural Phase 4a step toward closing the L-W deg ≥ 2
  case: with both elementary symmetric (sessions 10/12), power-sum
  (session 13), and arbitrary integer-polynomial-eval-sum (this
  session) being integer, the symmetric polynomial machinery is in
  place to express the L-W contradiction integer.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPowerSumIntegerInduction
import Mathlib.Algebra.BigOperators.Ring.Multiset

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPolynomialEvalIntSum

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPowerSumIntegerInduction

/-! ## Helper: Multiset.map over Finset.sum swap -/

/-- Helper: swap a Multiset sum-of-(Finset.sum) with a Finset sum-of-Multiset-map.
    Pure linearity of `+`. -/
private theorem multiset_map_finset_sum_swap
    {α β M : Type*} [AddCommMonoid M]
    (s : Multiset α) (T : Finset β) (F : α → β → M) :
    (s.map (fun a => ∑ b ∈ T, F a b)).sum = ∑ b ∈ T, (s.map (fun a => F a b)).sum := by
  induction s using Multiset.induction with
  | empty => simp
  | cons a s ih =>
      simp only [Multiset.map_cons, Multiset.sum_cons, ih]
      rw [Finset.sum_add_distrib]

/-! ## Phase 4a — linearity to arbitrary g : ℤ[X] over aroots -/

/-- **Wave T4b session 14 Phase 4a — `aroots_aeval_sum_is_integer`**.

    For monic `f : ℤ[X]` and any `g : ℤ[X]`:

      `∃ N : ℤ, ((f.aroots ℂ).map (fun α => Polynomial.aeval α g)).sum = (N : ℂ)`.

    The integer `N = ∑_{i ≤ g.natDegree} g.coeff i * (psum i of f.aroots)`
    where each power sum is integer by Phase 3 (session 13).

    Proof:
      1. Expand `aeval α g = ∑_i (g.coeff i : ℂ) * α^i`
         (Mathlib `aeval_def` + `eval₂_eq_sum_range`).
      2. Apply `multiset_map_finset_sum_swap` to swap the Multiset sum and
         the Finset sum.
      3. For each fixed `i`, pull out `(g.coeff i : ℂ)` via
         `Multiset.sum_map_mul_left`.
      4. Apply Phase 3 to express each `((f.aroots ℂ).map (·^i)).sum` as
         the cast of an integer.
      5. The total is the cast of the integer combination. -/
theorem aroots_aeval_sum_is_integer
    (f : Polynomial ℤ) (h_monic : f.Monic) (g : Polynomial ℤ) :
    ∃ N : ℤ, ((f.aroots ℂ).map (fun α => Polynomial.aeval α g)).sum = (N : ℂ) := by
  -- Pick integer for each power sum (Phase 3 / session 13)
  let pickPsum : ℕ → ℤ := fun j =>
    Classical.choose (aroots_psum_is_integer f h_monic j)
  have hPickPsum : ∀ j, ((f.aroots ℂ).map (· ^ j)).sum = (pickPsum j : ℂ) :=
    fun j => Classical.choose_spec (aroots_psum_is_integer f h_monic j)
  -- The integer N
  refine ⟨∑ i ∈ Finset.range (g.natDegree + 1), g.coeff i * pickPsum i, ?_⟩
  -- Expand g.aeval α via eval₂_eq_sum_range
  have h_aeval_expand : ∀ α : ℂ, Polynomial.aeval α g
      = ∑ i ∈ Finset.range (g.natDegree + 1), (g.coeff i : ℂ) * α ^ i := by
    intro α
    rw [Polynomial.aeval_def, Polynomial.eval₂_eq_sum_range]
    rfl
  -- Substitute the expansion uniformly
  have h_lhs_eq :
      ((f.aroots ℂ).map (fun α => Polynomial.aeval α g)).sum
      = ((f.aroots ℂ).map
            (fun α => ∑ i ∈ Finset.range (g.natDegree + 1),
              (g.coeff i : ℂ) * α ^ i)).sum := by
    apply congrArg Multiset.sum
    apply Multiset.map_congr rfl
    intros α _
    exact h_aeval_expand α
  rw [h_lhs_eq]
  -- Swap Multiset.sum and Finset.sum
  rw [multiset_map_finset_sum_swap]
  -- Cast the RHS
  push_cast
  -- Each summand: pull (g.coeff i : ℂ) out via Multiset.sum_map_mul_left
  apply Finset.sum_congr rfl
  intros i _
  rw [Multiset.sum_map_mul_left]
  -- Apply hPickPsum
  rw [hPickPsum i]

/-! ## Phase 4a headline -/

/-- **HEADLINE — Wave T4b session 14 Phase 4a**.  For monic `f : ℤ[X]`
    and any integer polynomial `g : ℤ[X]`, the sum of `g(α)` over
    `α ∈ f.aroots ℂ` is an integer.  Foundation for downstream symmetric
    polynomial machinery (cycle 65+ when L-W contradiction integer is
    constructed). -/
theorem session_14_phase_4a_headline
    (f : Polynomial ℤ) (h_monic : f.Monic) (g : Polynomial ℤ) :
    ∃ N : ℤ, ((f.aroots ℂ).map (fun α => Polynomial.aeval α g)).sum = (N : ℂ) :=
  aroots_aeval_sum_is_integer f h_monic g

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPolynomialEvalIntSum
