import OmegaTheory.Emergence.SU3GellMannMatrixEmbedding

namespace OmegaTheory.Emergence.SU3GellMannMatrixEmbedding

open Matrix Complex

-- Test the specific failing case b=2, (i,j)=(0,1) for row_0
example : ⁅gellMann 0, gellMann 2⁆ =
    ∑ c : Fin 8, ((2 * I : ℂ) * ((su3f 0 2 c : ℂ))) • gellMann c := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    (first
      | rfl
      | (unfold gellMann su3f;
         simp [Ring.lie_def, Matrix.mul_apply, Fin.sum_univ_three,
               Fin.sum_univ_eight, Matrix.smul_apply, Complex.I_sq];
         sorry))

end OmegaTheory.Emergence.SU3GellMannMatrixEmbedding
