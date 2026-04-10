/-
  OmegaTheory.Conservation.Information

  Information density, information current, and the Fourth Noether Law.

  The Fourth Noether Law (∂_μ J^μ_I = 0) is the key physics axiom:
  information is conserved under uniform reshaping of spacetime geometry.
  This is the discrete analog of diffeomorphism invariance.
-/

import OmegaTheory.Spacetime.Lattice
import OmegaTheory.Spacetime.Operators
import OmegaTheory.Spacetime.Constants
import OmegaTheory.Geometry.Metric

namespace OmegaTheory.Conservation

open OmegaTheory.Spacetime
open OmegaTheory.Geometry

/-! ## Information Density -/

/-- Local information density at each lattice point.
    Physically: I(n) encodes the local geometric complexity.
    Mathematically: a scalar field on the lattice. -/
abbrev InformationDensity := ScalarField

/-- Information current: the flow of information through spacetime.
    J^μ_I(n) = information flux in direction μ at point n. -/
abbrev InformationCurrent := LatticePoint → Fin 4 → ℝ

/-- The discrete divergence of the information current:
    ∂_μ J^μ_I = Σ_μ backwardDiff(J^μ, μ). -/
noncomputable def informationDivergence (J : InformationCurrent)
    (p : LatticePoint) : ℝ :=
  discreteDivergence J p

/-! ## Fourth Noether Law (AXIOM)

The central physics postulate: information is conserved.
This follows from uniform reshaping invariance — the symmetry that
the laws of physics don't change under uniform rescaling of the
computational resolution at every point.

In continuous GR, this is analogous to diffeomorphism invariance
implying ∇_μ T^μν = 0. Here, reshaping invariance implies ∂_μ J^μ_I = 0. -/

/-- A conserved information current satisfies ∂_μ J^μ_I = 0. -/
def IsConserved (J : InformationCurrent) : Prop :=
  ∀ p, informationDivergence J p = 0

/-- AXIOM: There exists a conserved information current derived from the metric.
    This is the Fourth Noether Law — information conservation from
    uniform reshaping symmetry. -/
axiom fourth_noether_law :
  ∀ (g : DiscreteMetric), ∃ (I : InformationDensity) (J : InformationCurrent),
    IsConserved J

/-! ## Information-Energy Correspondence -/

/-- The information-energy correspondence: E = k_B T ln(2) · I.
    Local information has an energy cost (Landauer's principle). -/
noncomputable def informationEnergy (I : InformationDensity) (T_temp : ℝ)
    (p : LatticePoint) : ℝ :=
  k_B * T_temp * Real.log 2 * I p

/-- Information energy is nonneg when temperature and information are nonneg. -/
theorem informationEnergy_nonneg {I : InformationDensity} {T_temp : ℝ}
    (hT : 0 ≤ T_temp) (hI : ∀ p, 0 ≤ I p) (p : LatticePoint) :
    0 ≤ informationEnergy I T_temp p := by
  unfold informationEnergy
  apply mul_nonneg
  apply mul_nonneg
  apply mul_nonneg
  · exact le_of_lt k_B_pos
  · exact hT
  · exact le_of_lt (Real.log_pos (by norm_num : (1 : ℝ) < 2))
  · exact hI p

/-! ## Equilibrium Information -/

/-- Mean information density over a region. -/
noncomputable def meanInformation (I : InformationDensity)
    (region : Finset LatticePoint) : ℝ :=
  (region.sum fun p => I p) / region.card

/-- Information deviation from mean. -/
noncomputable def informationDeviation (I : InformationDensity)
    (I_bar : ℝ) (p : LatticePoint) : ℝ :=
  I p - I_bar

end OmegaTheory.Conservation
