import OmegaTheory.Emergence.SU3GellMannMatrixEmbedding

namespace OmegaTheory.Emergence.SU3GellMannMatrixEmbedding

open Matrix Complex

example (g : Fin 8 → ℂ) (hsum : (∑ i : Fin 8, g i • gellMann i) = 0) :
    ∀ i, g i = 0 := by
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
  sorry

end OmegaTheory.Emergence.SU3GellMannMatrixEmbedding
