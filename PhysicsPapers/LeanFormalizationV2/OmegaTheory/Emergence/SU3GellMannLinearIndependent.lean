/-
  OmegaTheory.Emergence.SU3GellMannLinearIndependent

  Linear independence of the 8 Gell-Mann matrices `λ₁..λ₈` over ℂ.

  Proof strategy: matrix-entry coordinates.  Evaluate `∑ i, g i • λ_i = 0`
  at 8 specific `(row, col)` entries to extract a triangular linear system
  from which every `g i = 0` follows.  After `simp` with the gellMann
  definition, each hypothesis becomes a simple linear equation in `g 0..g 7`.

  Piece 2 of P3t cycle-49 (Menkent v8). No sorry, no new axioms.
-/

import Mathlib.LinearAlgebra.LinearIndependent.Defs
import Mathlib.LinearAlgebra.LinearIndependent.Lemmas
import OmegaTheory.Emergence.SU3GellMannMatrixEmbedding

namespace OmegaTheory.Emergence.SU3GellMannMatrixEmbedding

open Matrix Complex Finset

/-- **Linear independence of the Gell-Mann family** over ℂ.

    Uses matrix-entry coordinates: after evaluating `∑ i, g i • gellMann i = 0`
    at 9 specific entries, `simp` reduces each to a clean scalar equation:
    * `h22 : g 7 = 0`                         (λ₈ unique (2,2) support)
    * `h00 : g 2 + g 7 * (↑√3)⁻¹ = 0`         (λ₃, λ₈ on (0,0))
    * `h11 : -g 2 + g 7 * (↑√3)⁻¹ = 0`        (λ₃, λ₈ on (1,1))
    * `h01 : g 0 - g 1 * I = 0`               (λ₁, λ₂ on (0,1))
    * `h10 : g 0 + g 1 * I = 0`               (λ₁, λ₂ on (1,0))
    * `h02 : g 3 - g 4 * I = 0`               (λ₄, λ₅ on (0,2))
    * `h20 : g 3 + g 4 * I = 0`               (λ₄, λ₅ on (2,0))
    * `h12 : g 5 - g 6 * I = 0`               (λ₆, λ₇ on (1,2))
    * `h21 : g 5 + g 6 * I = 0`               (λ₆, λ₇ on (2,1))

    Adding/subtracting paired equations recovers each `g i = 0`. -/
theorem gellMann_linearIndependent : LinearIndependent ℂ gellMann := by
  rw [Fintype.linearIndependent_iff]
  intro g hsum i
  have h22 := congrFun (congrFun hsum 2) 2
  have h00 := congrFun (congrFun hsum 0) 0
  have h11 := congrFun (congrFun hsum 1) 1
  have h01 := congrFun (congrFun hsum 0) 1
  have h10 := congrFun (congrFun hsum 1) 0
  have h02 := congrFun (congrFun hsum 0) 2
  have h20 := congrFun (congrFun hsum 2) 0
  have h12 := congrFun (congrFun hsum 1) 2
  have h21 := congrFun (congrFun hsum 2) 1
  simp [Finset.sum_apply, Matrix.smul_apply, smul_eq_mul,
        Fin.sum_univ_eight, gellMann, Matrix.zero_apply]
    at h22 h00 h11 h01 h10 h02 h20 h12 h21
  -- After simp:
  -- h22 : g 7 = 0
  -- h00 : g 2 + g 7 * (↑√3)⁻¹ = 0
  -- h11 : -g 2 + g 7 * (↑√3)⁻¹ = 0
  -- h01 : g 0 + -(g 1 * I) = 0
  -- h10 : g 0 + g 1 * I = 0
  -- h02 : g 3 + -(g 4 * I) = 0
  -- h20 : g 3 + g 4 * I = 0
  -- h12 : g 5 + -(g 6 * I) = 0
  -- h21 : g 5 + g 6 * I = 0
  have hg7 : g 7 = 0 := h22
  have hg2 : g 2 = 0 := by
    rw [hg7] at h00; simpa using h00
  have hg0 : g 0 = 0 := by linear_combination (h01 + h10) / 2
  have hg1 : g 1 = 0 := by
    have hI : (I : ℂ) ≠ 0 := Complex.I_ne_zero
    have h : (2 * I : ℂ) * g 1 = 0 := by linear_combination h10 - h01
    have h2I : (2 * I : ℂ) ≠ 0 := mul_ne_zero two_ne_zero hI
    exact (mul_eq_zero.mp h).resolve_left h2I
  have hg3 : g 3 = 0 := by linear_combination (h02 + h20) / 2
  have hg4 : g 4 = 0 := by
    have hI : (I : ℂ) ≠ 0 := Complex.I_ne_zero
    have h : (2 * I : ℂ) * g 4 = 0 := by linear_combination h20 - h02
    have h2I : (2 * I : ℂ) ≠ 0 := mul_ne_zero two_ne_zero hI
    exact (mul_eq_zero.mp h).resolve_left h2I
  have hg5 : g 5 = 0 := by linear_combination (h12 + h21) / 2
  have hg6 : g 6 = 0 := by
    have hI : (I : ℂ) ≠ 0 := Complex.I_ne_zero
    have h : (2 * I : ℂ) * g 6 = 0 := by linear_combination h21 - h12
    have h2I : (2 * I : ℂ) ≠ 0 := mul_ne_zero two_ne_zero hI
    exact (mul_eq_zero.mp h).resolve_left h2I
  -- Conclude: g i = 0 for each i
  fin_cases i
  · exact hg0
  · exact hg1
  · exact hg2
  · exact hg3
  · exact hg4
  · exact hg5
  · exact hg6
  · exact hg7

end OmegaTheory.Emergence.SU3GellMannMatrixEmbedding
