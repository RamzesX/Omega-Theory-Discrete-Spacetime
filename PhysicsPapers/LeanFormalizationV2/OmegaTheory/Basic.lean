/-
  OmegaTheory — Discrete Spacetime with Error-Propagating Tensor Calculus

  A Lean 4 formalization of the Omega Theory of discrete quantum gravity.
  Key insight: Einstein's equations emerge from a discrete lattice where
  computational truncation errors are bounded and self-healing.

  Architecture (bottom-up):
  1. Foundations.ErrorAlgebra — how errors compose
  2. Spacetime.Lattice — Z^4 lattice
  3. Spacetime.Constants — Planck scale constants
  (more layers added as foundations are proven solid)
-/

-- Layer 0: Foundations
import OmegaTheory.Foundations.ErrorAlgebra


-- Layer 1: Discrete Spacetime
import OmegaTheory.Spacetime.Lattice
import OmegaTheory.Spacetime.Constants
import OmegaTheory.Spacetime.Operators

-- Layer 2: Error-Propagating Tensor Operations
import OmegaTheory.Tensor.ErrorTensor
import OmegaTheory.Tensor.Operations
import OmegaTheory.Tensor.ValuedGeometry

-- Layer 3: Discrete Differential Geometry
import OmegaTheory.Geometry.Metric
import OmegaTheory.Geometry.Connection
import OmegaTheory.Geometry.Curvature
import OmegaTheory.Geometry.CurvatureSymmetries
import OmegaTheory.Geometry.Weyl
import OmegaTheory.Geometry.Examples

-- Layer 5: Defects
import OmegaTheory.Defects.DefectTensor

-- Layer 6: Conservation Laws
import OmegaTheory.Conservation.Information
import OmegaTheory.Conservation.NoetherMetaStructure
import OmegaTheory.Conservation.StressEnergy
import OmegaTheory.Conservation.Correspondence
import OmegaTheory.Conservation.SpinInformation

-- Layer 7: Healing Flow
import OmegaTheory.HealingFlow.Functional
import OmegaTheory.HealingFlow.Flow
import OmegaTheory.HealingFlow.Lyapunov
import OmegaTheory.HealingFlow.Periodic

-- Layer 8: Emergence
import OmegaTheory.Emergence.CoarseGrain
import OmegaTheory.Emergence.LaplacianRicci
import OmegaTheory.Emergence.EinsteinEmergence
import OmegaTheory.Emergence.Gravitons
import OmegaTheory.Emergence.SnapshotPropagator

-- Layer 10: Torsion (Einstein-Cartan)
import OmegaTheory.Torsion.Torsion

-- Layer 11: Irrationality (concrete error sources)
import OmegaTheory.Irrationality.Approximations
import OmegaTheory.Irrationality.ActionDensity

-- Layer 12: Variational (Erdős-Lagrangian, discrete Noether)
import OmegaTheory.Variational.GraphAction
import OmegaTheory.Variational.DiscreteNoether

-- Extended modules
import OmegaTheory.Torsion.SpinTorsion
import OmegaTheory.Torsion.BigBounce
import OmegaTheory.Irrationality.Uncertainty
import OmegaTheory.Irrationality.BoundsLemmas
import OmegaTheory.Emergence.Predictions
