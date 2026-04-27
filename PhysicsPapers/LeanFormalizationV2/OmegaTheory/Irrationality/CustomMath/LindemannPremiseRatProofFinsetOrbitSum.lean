/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFinsetOrbitSum

  Cycle 63→64 Phase B Wave T-4b session 53 — Finset version of
  orbit-sum identity.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Direct corollary of Mathlib's `Finset.prod_one_add` + Euler's
  identity `1 + exp(iπ) = 0`:

    `iπ ∈ Finset.univ.val.map α →
       ∑ S ∈ Finset.univ.powerset, Complex.exp (∑ i ∈ S, α i) = 0`

  This is the Finset analog of s5 (orbit-product expanded over Multiset).
  Used in cycle 64+ to discharge the high-degree bridge.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Analysis.SpecialFunctions.Complex.Circle

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFinsetOrbitSum

open Complex Finset

/-! ## Identity: 1 + exp(iπ) = 0 -/

/-- Euler's identity: `exp(iπ) = -1`, hence `1 + exp(iπ) = 0`. -/
theorem one_add_exp_iPi_eq_zero :
    1 + Complex.exp (Complex.I * (Real.pi : ℂ)) = 0 := by
  rw [mul_comm Complex.I (Real.pi : ℂ)]
  rw [Complex.exp_pi_mul_I]
  ring

/-! ## Finset orbit-sum identity -/

/-- **Wave T4b session 53 — Finset orbit-sum identity**.

    For any `α : Fin n → ℂ` such that `i*π ∈ univ.val.map α`, the
    Finset-indexed orbit-sum `∑ S ∈ univ.powerset, exp(∑ i ∈ S, α i)`
    equals 0.

    Proof: by `Finset.prod_one_add`, this sum equals
    `∏ i ∈ univ, (1 + exp(α i))`.  Since one of the α i is iπ,
    `1 + exp(iπ) = 0`, so the product is 0. -/
theorem finset_orbit_sum_eq_zero
    (n : ℕ) (α : Fin n → ℂ)
    (h_iPi_mem : Complex.I * (Real.pi : ℂ) ∈ (Finset.univ : Finset (Fin n)).val.map α) :
    ∑ S ∈ (Finset.univ : Finset (Fin n)).powerset,
      Complex.exp (∑ i ∈ S, α i) = 0 := by
  -- Step 1: convert sum to product via prod_one_add
  have h_prod_eq_sum : ∏ i ∈ (Finset.univ : Finset (Fin n)), (1 + Complex.exp (α i)) =
                       ∑ S ∈ (Finset.univ : Finset (Fin n)).powerset,
                         ∏ i ∈ S, Complex.exp (α i) :=
    Finset.prod_one_add _
  -- Step 2: convert ∏ exp to exp ∑ (Complex.exp.prod_eq_exp_sum)
  have h_prod_exp : ∀ S : Finset (Fin n),
      ∏ i ∈ S, Complex.exp (α i) = Complex.exp (∑ i ∈ S, α i) := by
    intro S
    rw [Complex.exp_sum]
  -- Step 3: combine
  rw [show (∑ S ∈ (Finset.univ : Finset (Fin n)).powerset, Complex.exp (∑ i ∈ S, α i)) =
        ∑ S ∈ (Finset.univ : Finset (Fin n)).powerset, ∏ i ∈ S, Complex.exp (α i) from
      Finset.sum_congr rfl (fun S _ => (h_prod_exp S).symm)]
  rw [← h_prod_eq_sum]
  -- Goal: ∏ i, (1 + exp α i) = 0
  -- iπ ∈ univ.val.map α means ∃ i₀ : Fin n with α i₀ = iπ
  obtain ⟨i₀, _, h_α_i₀⟩ := Multiset.mem_map.mp h_iPi_mem
  -- Apply prod_eq_zero with i₀
  apply Finset.prod_eq_zero (Finset.mem_univ i₀)
  rw [h_α_i₀]
  exact one_add_exp_iPi_eq_zero

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 53**.  Finset-version orbit-sum
    identity: `∑ S, exp σ_S = 0` when iπ is among the α values.

    This is the cycle 64+ entry: the Multiset of all subset-sums (from
    Finset.univ.powerset.val.map σ_S) sums to 0 after exp, which
    expanding into "zero σ_S" + "non-zero σ_S" gives the -m identity. -/
theorem session_53_finset_orbit_sum_headline
    (n : ℕ) (α : Fin n → ℂ)
    (h_iPi_mem : Complex.I * (Real.pi : ℂ) ∈ (Finset.univ : Finset (Fin n)).val.map α) :
    ∑ S ∈ (Finset.univ : Finset (Fin n)).powerset,
      Complex.exp (∑ i ∈ S, α i) = 0 :=
  finset_orbit_sum_eq_zero n α h_iPi_mem

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFinsetOrbitSum
