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
import OmegaTheory.Foundations.TaylorBound


-- Layer 1: Discrete Spacetime
import OmegaTheory.Spacetime.Lattice
import OmegaTheory.Spacetime.Constants
import OmegaTheory.Spacetime.Operators
import OmegaTheory.Spacetime.CausalLattice

-- Layer 2: Error-Propagating Tensor Operations
import OmegaTheory.Tensor.ErrorTensor
import OmegaTheory.Tensor.Operations
import OmegaTheory.Tensor.ValuedGeometry
import OmegaTheory.Tensor.ValuedCurvature

-- Layer 3: Discrete Differential Geometry
import OmegaTheory.Geometry.Metric
import OmegaTheory.Geometry.Connection
import OmegaTheory.Geometry.Curvature
import OmegaTheory.Geometry.CurvatureSymmetries
import OmegaTheory.Geometry.Weyl
import OmegaTheory.Geometry.WeylGeneral
import OmegaTheory.Geometry.Examples
import OmegaTheory.Geometry.DiscreteForms
import OmegaTheory.Geometry.WedgeProduct
import OmegaTheory.Geometry.StructureEquation
import OmegaTheory.Geometry.HodgeStar
import OmegaTheory.Geometry.DiscreteMaxwell
import OmegaTheory.Geometry.DiscreteStokes
import OmegaTheory.Geometry.InnerProduct
import OmegaTheory.Geometry.PoincareLemma
import OmegaTheory.Geometry.HodgeDecomposition
import OmegaTheory.Geometry.GaussBonnet
-- Continuum geometry stack (Mizar + Fomalhaut, Apr 15)
import OmegaTheory.Geometry.SmoothMetric
import OmegaTheory.Geometry.Christoffel
import OmegaTheory.Geometry.RiemannCurvature
import OmegaTheory.Geometry.RicciTensor
import OmegaTheory.Geometry.HarmonicGaugeContinuum
import OmegaTheory.Geometry.RicciProperties
import OmegaTheory.Geometry.WeinbergLinearised

-- Layer 5: Defects
import OmegaTheory.Defects.DefectTensor
import OmegaTheory.Defects.Sparsity

-- Layer 6: Conservation Laws
import OmegaTheory.Conservation.Information
import OmegaTheory.Conservation.NoetherMetaStructure
import OmegaTheory.Conservation.StressEnergy
import OmegaTheory.Conservation.Correspondence
import OmegaTheory.Conservation.SpinInformation
import OmegaTheory.Conservation.InformationKL
import OmegaTheory.Conservation.InformationKLBridge

-- Layer 7: Healing Flow
import OmegaTheory.HealingFlow.Functional
import OmegaTheory.HealingFlow.Flow
import OmegaTheory.HealingFlow.Lyapunov
import OmegaTheory.HealingFlow.Periodic
import OmegaTheory.HealingFlow.Convergence

-- Layer 8: Emergence
import OmegaTheory.Emergence.CoarseGrain
import OmegaTheory.Emergence.LaplacianRicci
import OmegaTheory.Emergence.HpwHypothesis
import OmegaTheory.Emergence.HpwMinkowski
import OmegaTheory.Emergence.HpwLinearised
import OmegaTheory.Emergence.SmoothInterpolant
import OmegaTheory.Emergence.HarmonicGauge
import OmegaTheory.Emergence.RicciComparison
import OmegaTheory.Emergence.HpwSchwarzschild
import OmegaTheory.Emergence.HpwFRW
import OmegaTheory.Emergence.HpwBianchiI
import OmegaTheory.Emergence.HpwDeSitter
import OmegaTheory.Emergence.HpwElimSummary
import OmegaTheory.Emergence.EinsteinEmergence
import OmegaTheory.Emergence.CosmologicalConstant
import OmegaTheory.Emergence.Gravitons
import OmegaTheory.Emergence.SnapshotPropagator
import OmegaTheory.Emergence.PatternIdentity

-- Layer 10: Torsion (Einstein-Cartan)
import OmegaTheory.Torsion.Torsion

-- Layer 11: Irrationality (concrete error sources)
import OmegaTheory.Irrationality.Approximations
import OmegaTheory.Irrationality.ActionDensity

-- Layer 12: Variational (Erdős-Lagrangian, discrete Noether)
import OmegaTheory.Variational.GraphAction
import OmegaTheory.Variational.DiscreteNoether
import OmegaTheory.Variational.InformationGeodesics

-- Extended modules
import OmegaTheory.Torsion.SpinTorsion
import OmegaTheory.Torsion.BigBounce
import OmegaTheory.Irrationality.Uncertainty
import OmegaTheory.Irrationality.BoundsLemmas
import OmegaTheory.Emergence.Predictions
import OmegaTheory.Emergence.DimensionalFlow
import OmegaTheory.Emergence.SpecialRelativity
import OmegaTheory.Emergence.CoarseGrainingMap
import OmegaTheory.Emergence.DispersionFromLattice
import OmegaTheory.Emergence.DispersionBridge
import OmegaTheory.Emergence.SchrodingerFromLattice
import OmegaTheory.Emergence.SnapshotDynamics
import OmegaTheory.Emergence.BornRule
import OmegaTheory.Emergence.Interference
import OmegaTheory.Emergence.Propagator
import OmegaTheory.Emergence.Entanglement
import OmegaTheory.Emergence.Decoherence
import OmegaTheory.Emergence.Measurement
import OmegaTheory.Emergence.Heisenberg
import OmegaTheory.Emergence.BekensteinBound
import OmegaTheory.Emergence.QuantumMechanicsCapstone
import OmegaTheory.Emergence.QmBridgePaper
import OmegaTheory.Emergence.AharonovBohm

-- Layer 9: Falsifiable predictions (substrate vs alternatives)
import OmegaTheory.Predictions.GravDecoherenceTScaling
import OmegaTheory.Predictions.UHECRDispersion
import OmegaTheory.Predictions.RedshiftFloor
import OmegaTheory.Predictions.StochasticTeleportation
import OmegaTheory.Predictions.HermiticityDefect
import OmegaTheory.Predictions.ChristoffelSparsity
import OmegaTheory.Predictions.SpinFlipRate
import OmegaTheory.Predictions.GammaRayDispersion

-- Layer 11b: Irrationality → predictions bridge
import OmegaTheory.Irrationality.PredictionsBridge

-- Layer 13: Paper-citable headline aliases (re-exports for manuscript)
import OmegaTheory.Paper.GeometricRelativistic
import OmegaTheory.Paper.QuantumFoundations
