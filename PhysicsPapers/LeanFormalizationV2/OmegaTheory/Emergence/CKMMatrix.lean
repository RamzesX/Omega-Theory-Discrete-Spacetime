/-
  OmegaTheory.Emergence.CKMMatrix
  Cabibbo-Kobayashi-Maskawa quark mixing matrix.

  The CKM matrix V ∈ U(3) relates mass eigenstates to weak eigenstates
  for quarks. Standard parametrization uses 3 mixing angles (θ_12, θ_13, θ_23)
  and 1 CP-violating phase δ. V arises as V = U_u† · U_d, where U_u and U_d
  diagonalize the up- and down-quark Yukawa matrices respectively.

  Structural only — unitarity is a hypothesis. 0 sorry, 0 axioms.

  Agent: Algol (β Persei), April 17, 2026.
-/

import OmegaTheory.Emergence.FermionContent
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Tactic

namespace OmegaTheory.Emergence

open Complex

/-- The four real CKM parameters: three mixing angles and one CP phase. -/
structure CKMAngles where
  theta12 : ℝ
  theta13 : ℝ
  theta23 : ℝ
  deltaCP : ℝ

/-- A CKM matrix is a 3×3 complex matrix. Unitarity is imposed as a hypothesis. -/
abbrev CKMMatrix : Type := Matrix (Fin 3) (Fin 3) ℂ

/-- Standard-parametrization entries of the CKM matrix (PDG convention):

    V =
    [  c12 c13                 ,  s12 c13                 ,  s13 e^{-iδ}     ]
    [ -s12 c23 - c12 s23 s13 e^{iδ}, c12 c23 - s12 s23 s13 e^{iδ}, s23 c13 ]
    [  s12 s23 - c12 c23 s13 e^{iδ},-c12 s23 - s12 c23 s13 e^{iδ}, c23 c13 ]
-/
noncomputable def ckmStandard (a : CKMAngles) : CKMMatrix := fun i j =>
  let c12 : ℂ := (Real.cos a.theta12 : ℂ)
  let s12 : ℂ := (Real.sin a.theta12 : ℂ)
  let c13 : ℂ := (Real.cos a.theta13 : ℂ)
  let s13 : ℂ := (Real.sin a.theta13 : ℂ)
  let c23 : ℂ := (Real.cos a.theta23 : ℂ)
  let s23 : ℂ := (Real.sin a.theta23 : ℂ)
  let eP  : ℂ := Complex.exp (Complex.I * (a.deltaCP : ℂ))
  let eM  : ℂ := Complex.exp (-(Complex.I * (a.deltaCP : ℂ)))
  match i, j with
  | 0, 0 => c12 * c13
  | 0, 1 => s12 * c13
  | 0, 2 => s13 * eM
  | 1, 0 => -s12 * c23 - c12 * s23 * s13 * eP
  | 1, 1 =>  c12 * c23 - s12 * s23 * s13 * eP
  | 1, 2 =>  s23 * c13
  | 2, 0 =>  s12 * s23 - c12 * c23 * s13 * eP
  | 2, 1 => -c12 * s23 - s12 * c23 * s13 * eP
  | 2, 2 =>  c23 * c13

/-- Experimentally measured CKM angles (PDG 2024, degrees converted to radians).
    θ_12 ≈ 13.04°, θ_23 ≈ 2.38°, θ_13 ≈ 0.201°, δ ≈ 69°. -/
noncomputable def ckmExperimental : CKMAngles :=
  { theta12 := 13.04 * Real.pi / 180
  , theta13 := 0.201 * Real.pi / 180
  , theta23 := 2.38  * Real.pi / 180
  , deltaCP := 69    * Real.pi / 180 }

/-- Unitarity predicate for a CKM matrix: V† V = I. -/
def IsUnitaryCKM (V : CKMMatrix) : Prop :=
  V.conjTranspose * V = (1 : Matrix (Fin 3) (Fin 3) ℂ)

/-- Structural theorem: CKM matrix arises from diagonalization of up and down
    Yukawa matrices. U_u, U_d are the unitary matrices diagonalizing each;
    V_CKM = U_u† · U_d. -/
structure CKMFromYukawa where
  U_up   : Matrix (Fin 3) (Fin 3) ℂ
  U_down : Matrix (Fin 3) (Fin 3) ℂ
  U_up_unitary   : U_up.conjTranspose * U_up = (1 : Matrix (Fin 3) (Fin 3) ℂ)
  U_down_unitary : U_down.conjTranspose * U_down = (1 : Matrix (Fin 3) (Fin 3) ℂ)
  V_CKM : CKMMatrix
  diagonalization : V_CKM = U_up.conjTranspose * U_down

/-- Trivial witness: identity diagonalizations give V_CKM = I (no mixing). -/
noncomputable def trivialCKMFromYukawa : CKMFromYukawa :=
  { U_up   := 1
  , U_down := 1
  , U_up_unitary := by
      simp
  , U_down_unitary := by
      simp
  , V_CKM := 1
  , diagonalization := by
      simp }

/-- Structural theorem: given any pair of unitaries (U_u, U_d), the product
    U_u† · U_d is a valid CKM candidate arising from Yukawa diagonalization. -/
theorem ckm_from_yukawa_diagonalization
    (U_up U_down : Matrix (Fin 3) (Fin 3) ℂ)
    (hUu : U_up.conjTranspose * U_up = (1 : Matrix (Fin 3) (Fin 3) ℂ))
    (hUd : U_down.conjTranspose * U_down = (1 : Matrix (Fin 3) (Fin 3) ℂ)) :
    ∃ W : CKMFromYukawa, W.V_CKM = U_up.conjTranspose * U_down :=
  ⟨{ U_up := U_up
   , U_down := U_down
   , U_up_unitary := hUu
   , U_down_unitary := hUd
   , V_CKM := U_up.conjTranspose * U_down
   , diagonalization := rfl }, rfl⟩

/-- The Jarlskog invariant — a reparametrization-invariant measure of CP violation.
    J = s_12 c_12 · s_23 c_23 · s_13 c_13² · sin δ. -/
noncomputable def jarlskogInvariant (a : CKMAngles) : ℝ :=
  Real.sin a.theta12 * Real.cos a.theta12 *
  Real.sin a.theta23 * Real.cos a.theta23 *
  Real.sin a.theta13 * (Real.cos a.theta13)^2 *
  Real.sin a.deltaCP

/-- When δ = 0 (no CP violation), the Jarlskog invariant vanishes. -/
theorem jarlskog_vanishes_no_cp (a : CKMAngles) (hδ : a.deltaCP = 0) :
    jarlskogInvariant a = 0 := by
  unfold jarlskogInvariant
  rw [hδ, Real.sin_zero]
  ring

/-- When θ_13 = 0 (no 1-3 mixing), the Jarlskog invariant vanishes. -/
theorem jarlskog_vanishes_no_13mixing (a : CKMAngles) (h : a.theta13 = 0) :
    jarlskogInvariant a = 0 := by
  unfold jarlskogInvariant
  rw [h, Real.sin_zero]
  ring

/-- When θ_12 = 0 the Jarlskog invariant vanishes. -/
theorem jarlskog_vanishes_no_12mixing (a : CKMAngles) (h : a.theta12 = 0) :
    jarlskogInvariant a = 0 := by
  unfold jarlskogInvariant
  rw [h, Real.sin_zero]
  ring

/-- When θ_23 = 0 the Jarlskog invariant vanishes. -/
theorem jarlskog_vanishes_no_23mixing (a : CKMAngles) (h : a.theta23 = 0) :
    jarlskogInvariant a = 0 := by
  unfold jarlskogInvariant
  rw [h, Real.sin_zero]
  ring

/-- Conditional unitarity: we assert the standard CKM parametrization is unitary
    as a hypothesis. Future work can establish this by direct computation. -/
def ckmStandardUnitarityHypothesis (a : CKMAngles) : Prop :=
  IsUnitaryCKM (ckmStandard a)

end OmegaTheory.Emergence
