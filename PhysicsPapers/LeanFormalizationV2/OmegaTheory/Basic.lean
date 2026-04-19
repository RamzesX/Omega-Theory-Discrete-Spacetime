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
import OmegaTheory.Foundations.ErrorLieAlgebra
import OmegaTheory.Foundations.TaylorBound
import OmegaTheory.Foundations.ErrorForms
import OmegaTheory.Foundations.ErrorHopfStructure
-- Metric-weighted graph Laplacian (Mathlib-gap infrastructure, Kochab 2026-04-17)
-- Generalises SimpleGraph.lapMatrix from unit weights to arbitrary symmetric weights.
-- This is the long-missing ingredient the future HPW convergence proof will use.
import OmegaTheory.Foundations.WeightedGraphLaplacian

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
import OmegaTheory.Geometry.WeinbergConformal
-- Error-Bounded HPW scaffold (Phase 1 of EBHPW mission, 2026-04-17)
import OmegaTheory.Geometry.ErrorBoundedSmooth
-- Substantive EBHPW with explicit perturbation field (Adhara, 2026-04-17)
import OmegaTheory.Geometry.ErrorBoundedSmoothReal
-- Real fderiv-based wrapper around HpwHypothesis.SmoothMetricField (Markab, 2026-04-17)
-- Non-breaking: adds SmoothMetricFieldReal alongside the opaque = 0 placeholders.
import OmegaTheory.Geometry.SmoothMetricFieldReal
-- Minimal Seeley-DeWitt / heat-kernel machinery (Ankaa + Tarazed, 2026-04-17)
-- Depends on ErrorBoundedSmooth, lives in Foundations namespace.
import OmegaTheory.Foundations.HeatKernelMinimal
-- Kempf bandlimit bridge (Albireo, 2026-04-17)
-- Connects Kempf's PRL-2008 quantum-gravity bandlimit to the substrate
-- truncation error via three bridge theorems: O(1/N) scaling, GUP
-- positivity, and UV cutoff identification.  Depends only on Spacetime
-- and Irrationality; lives in Foundations namespace.
import OmegaTheory.Foundations.KempfBandlimit

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
import OmegaTheory.Emergence.HpwSmoothMetricBridge
import OmegaTheory.Emergence.HpwLinearised
import OmegaTheory.Emergence.SmoothInterpolant
import OmegaTheory.Emergence.WhitneyInterpolant
import OmegaTheory.Emergence.WhitneyMollifier
import OmegaTheory.Emergence.HarmonicGauge
import OmegaTheory.Emergence.RicciComparison
import OmegaTheory.Emergence.HpwSchwarzschild
import OmegaTheory.Emergence.HpwFRW
import OmegaTheory.Emergence.HpwBianchiI
import OmegaTheory.Emergence.HpwDeSitter
import OmegaTheory.Emergence.HpwKerr
import OmegaTheory.Emergence.HpwElimSummary
import OmegaTheory.Emergence.BlackHoleFormation
-- Hawking radiation as healing-flow output (Avior, 2026-04-17)
-- Composes with BlackHoleFormation; adds HealingFlowBH namespace
import OmegaTheory.Emergence.HealingFlowBH
import OmegaTheory.Emergence.EinsteinEmergence
import OmegaTheory.Emergence.CosmologicalConstant
import OmegaTheory.Emergence.CosmologicalConstantProblem
import OmegaTheory.Emergence.WormholeStability
import OmegaTheory.Emergence.NegativePressure
import OmegaTheory.Emergence.Gravitons
import OmegaTheory.Emergence.GravitonConditions
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
import OmegaTheory.Emergence.CHSHBell
import OmegaTheory.Emergence.Decoherence
import OmegaTheory.Emergence.Measurement
import OmegaTheory.Emergence.Heisenberg
import OmegaTheory.Emergence.BekensteinBound
import OmegaTheory.Emergence.QuantumMechanicsCapstone
import OmegaTheory.Emergence.QmBridgePaper
import OmegaTheory.Emergence.AharonovBohm
import OmegaTheory.Emergence.ConnesSpectralAction
import OmegaTheory.Emergence.FermionContent
import OmegaTheory.Emergence.ErrorGaugeField
import OmegaTheory.Emergence.ErrorGaugeSU2
import OmegaTheory.Emergence.ErrorGaugeSU3
import OmegaTheory.Emergence.SU3JacobiHelper
import OmegaTheory.Emergence.SU3JacobiFull
import OmegaTheory.Emergence.NonAbelianGauge
import OmegaTheory.Emergence.SymmetryBreaking
import OmegaTheory.Emergence.HiggsFromError
import OmegaTheory.Emergence.PathIntegral
import OmegaTheory.Emergence.RotationCurves
import OmegaTheory.Emergence.SpectralActionExpansion

-- Matter sector (Mirach + Algieba + Phecda + Alioth + Propus wave)
-- FermionContent already imported above (line 155)
import OmegaTheory.Emergence.FermionHypercharge
import OmegaTheory.Emergence.FermionQuantumNumbers
import OmegaTheory.Emergence.AnomalyCancellation
import OmegaTheory.Emergence.SpinStatistics
import OmegaTheory.Emergence.ConnesBimodule
import OmegaTheory.Emergence.AF_Irreducibility
import OmegaTheory.Emergence.CKMMatrix
import OmegaTheory.Emergence.YukawaMatrix
import OmegaTheory.Emergence.DiracFSpectrum
import OmegaTheory.Emergence.DiracLagrangian
import OmegaTheory.Emergence.PMNSMatrix
import OmegaTheory.Emergence.KoideRelation
import OmegaTheory.Emergence.LeptonMassFromIrrationals
import OmegaTheory.Emergence.QuarkMassFromIrrationals

-- Layer 9: Falsifiable predictions (substrate vs alternatives)
import OmegaTheory.Predictions.GravDecoherenceTScaling
import OmegaTheory.Predictions.UHECRDispersion
import OmegaTheory.Predictions.RedshiftFloor
import OmegaTheory.Predictions.StochasticTeleportation
import OmegaTheory.Predictions.HermiticityDefect
import OmegaTheory.Predictions.ChristoffelSparsity
import OmegaTheory.Predictions.SpinFlipRate
import OmegaTheory.Predictions.GammaRayDispersion
import OmegaTheory.Predictions.AdditionalPredictions
import OmegaTheory.Predictions.WarwickGQuEST
import OmegaTheory.Predictions.NeutrinoMassFloor
import OmegaTheory.Predictions.JarlskogFromIrrationals
import OmegaTheory.Predictions.MixingAnglesFromIrrationals
-- Pi Hunch mass-ordering capstone (pi-capstone, 2026-04-19)
-- Links δ_comp(N) ordering of (π, e, √2) to fermion mass hierarchy
-- via a strictly monotone Yukawa kernel. Conditional consequence.
import OmegaTheory.Predictions.PiHunchMassOrdering

-- Layer 1b: Planck ↔ eV unit conversions (composes with NeutrinoMassFloor)
-- Created 2026-04-17 by Enif. Lives in Spacetime namespace; imported here
-- because it depends on NeutrinoMassFloor from Predictions layer.
import OmegaTheory.Spacetime.UnitConversions

-- Layer 11b: Irrationality → predictions bridge
import OmegaTheory.Irrationality.PredictionsBridge

-- Layer 13: Paper-citable headline aliases (re-exports for manuscript)
import OmegaTheory.Paper.GeometricRelativistic
import OmegaTheory.Paper.QuantumFoundations
