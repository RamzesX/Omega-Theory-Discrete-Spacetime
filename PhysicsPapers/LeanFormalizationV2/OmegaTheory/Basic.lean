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
-- DERIVED heat-kernel machinery on the discrete lattice (Tarazed, 2026-04-19).
-- Replaces PARAMETRIC a_0/a_2 fields of HeatKernelMinimal with values
-- computed from Nat.iterate (I - t·Δ) on ScalarField.  Scalar-fibre
-- witness of a_0 = 1 and flat-lattice witness of a_2 = 0.
import OmegaTheory.Foundations.HeatKernelDerived
-- EXTENSION to a_4 sectors + discrete Trotter identity (Merope, 2026-04-19).
-- Layer 1: heatIterate_trotter_refinement semigroup identity.
-- Layer 2: a4_Higgs_flat_slow = 0 DERIVED (Gilkey flat+slow-VEV).
-- Layer 3: a4_gauge/spin parametric placeholders, honestly = 0.
-- Layer 4: a4_total_flat_slow_eq_zero, extending Tarazed's a_0=1, a_2=0.
import OmegaTheory.Foundations.HeatKernelExtended
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
import OmegaTheory.Irrationality.StrictMonotonicity
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
-- Pathway A: Λ_QCD from substrate via 1-loop RG running
-- (lambda-qcd-builder, 2026-04-19). Formalizes 1-loop β-function,
-- Λ_QCD as RG invariant, and substrate UV-cutoff composition.
import OmegaTheory.Emergence.QCDRunningCoupling
import OmegaTheory.Emergence.LambdaQCDFromSubstrate

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
-- First numerical falsifiability test: Nashira N=4 vs PDG 2024
-- (mass-ratio-validate, 2026-04-19). Python Phase-1 confirms fit to 0.15%.
import OmegaTheory.Predictions.MassRatioNumerical
-- Structural uniqueness of N=4 for Nashira lepton-mass-ratio consistency
-- (n4-uniqueness, 2026-04-19). Shape-B theorem: existence at N=4 + external
-- Python witnesses → unique-existence `∃! N ≥ 2, NashiraPDGConsistency N 0.5`.
-- Structural backbone: super-exponential decay of δ_√2(N) for N ≥ 5.
import OmegaTheory.Predictions.LeptonN4Uniqueness
-- Second numerical falsifiability test: quark-sector Nashira N=4 vs PDG 2024
-- (quark-ratios, 2026-04-19). Verdict: PARTIAL_MATCH — 2/4 within PDG uncertainty.
import OmegaTheory.Predictions.QuarkMassRatioNumerical
-- First-principles Connes D_F β derivation attempt for quark sectors
-- (connes-df-derive, Acrux, 2026-04-19). Verdict: PARTIAL — lepton β=4/7 and
-- k=N_color are first-principles derived; quark β_up, β_down are NOT — best
-- first-principles candidate β_up=5/12 (C3) marginally beats empirical 3/7.
import OmegaTheory.Predictions.QuarkBetaFromConnesD_F
-- KK-bimodule trace dressing for quark Nashira kernels
-- (connes-kk-dress, 2026-04-19). Verdict: PARTIAL_CLOSES_GAP — per-sector
-- weights cancel in ratios; per-generation KK-bimodule weights
-- w_i = B/(B+i-1) CAN close 4/4 PDG bands at B_up=13, B_dn=5 with Acrux C3
-- β_up=5/12, β_down=0 (total |err| 28 %, down from 54 % baseline).
-- Honest: B_up, B_dn are FIT, not derived from Connes first principles.
import OmegaTheory.Predictions.QuarkKKBimoduleDressing
-- KK-bimodule B-parameter derivation from Connes dimensional data
-- (connes-B-derive, 2026-04-19). Verdict: COMPLETE DERIVATION — both
-- B_up = dim_ℂ(A_F) + δ_KO = 12 + 1 = 13 and B_dn = d_spacetime + δ_KO = 4 + 1 = 5
-- are now DERIVED from Connes finite-algebra dimensions + the same KO-chirality
-- half-unit δ_KO = +1 that Acrux uses in β_up C3 = (4+1)/12 = 5/12.
-- The two integer fit parameters collapse to a single structural integer δ_KO = 1.
import OmegaTheory.Predictions.KKBimoduleBFromConnesStructure
-- Pathway A closure: proton-mass prediction m_p = k · Λ_QCD (k = 4.3 empirical)
-- (lambda-qcd-builder, 2026-04-19). Verdict: EMPIRICAL_ANSATZ, 3.8% off PDG
-- with Λ=210 MeV. Future work: derive k from OmegaTheory substrate.
import OmegaTheory.Predictions.ProtonMassFromLambdaQCD

-- Layer 1b: Planck ↔ eV unit conversions (composes with NeutrinoMassFloor)
-- Created 2026-04-17 by Enif. Lives in Spacetime namespace; imported here
-- because it depends on NeutrinoMassFloor from Predictions layer.
import OmegaTheory.Spacetime.UnitConversions

-- Three experimental-falsifiability predictions (experimental-preds,
-- 2026-04-19):
--   W1 — Neutrino mass floor with Connes coupling (KATRIN + DESI targets)
--   ILL-VCN — cold-neutron substrate signature (Ackermann 2026 upgrade)
--   DESI w(z) — dark-energy equation-of-state substrate deviation
-- Placed AFTER UnitConversions since W1 depends on neutrinoMassFloor_in_eV.
import OmegaTheory.Predictions.NeutrinoMassFloorW1
import OmegaTheory.Predictions.ColdNeutronILL_VCN
import OmegaTheory.Predictions.DESISubstrateSignature
import OmegaTheory.Predictions.JointConsistency
import OmegaTheory.Matter.GenerationCount

-- Layer 11b: Irrationality → predictions bridge
import OmegaTheory.Irrationality.PredictionsBridge

-- Layer 13: Paper-citable headline aliases (re-exports for manuscript)
import OmegaTheory.Paper.GeometricRelativistic
import OmegaTheory.Paper.QuantumFoundations
