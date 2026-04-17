# OPERATOR STRUCTURE MAP -- OmegaTheory V2

Full algebraic structure inventory. 135 Lean files, ~1640 theorems, 0 sorry, 0 axioms.

Generated 2026-04-15 by Opus Code Crawler.

---

## A. FOUNDATIONAL ALGEBRAIC STRUCTURES

### A1. Error Algebra (Layer 0)

| Structure | File | Type | Description | Status |
|-----------|------|------|-------------|--------|
| `ErrorBound` | Foundations/ErrorAlgebra | `structure` (val : R, nonneg) | Nonneg real; error from single computational step | PROVED: add, mul, scale, monotonicity |
| `Valued alpha` | Foundations/ErrorAlgebra | `structure` (val, error) | Any type paired with ErrorBound | PROVED: exact_error_zero |
| `abs_mul_sub_mul_bound` | Foundations/ErrorAlgebra | theorem | Product-rule error: \|ab-a'b'\| <= A*eb + B*ea + ea*eb | PROVED (full + linear variant) |

### A2. Error Lie Algebra (Layer 0)

| Structure | File | Type | Description | Status |
|-----------|------|------|-------------|--------|
| `ErrorLieBracket L` | Foundations/ErrorLieAlgebra | `class` | Bracket + bracketError on type L | PROVED: bracketError_nonneg |
| `ErrorLieAlgebra L` | Foundations/ErrorLieAlgebra | `class extends ErrorLieBracket` | Approximate Lie algebra: antisym, Jacobi, linearity each up to epsilon | PROVED: exact recovery when all epsilon = 0 |
| `substrateLieBracketError N` | Foundations/ErrorLieAlgebra | noncomputable def | = computationalUncertainty(N), decreasing, tends to 0 | PROVED: pos, decreasing, tendsto_zero |

### A3. Error Hopf Algebra (Layer 0)

| Structure | File | Type | Description | Status |
|-----------|------|------|-------------|--------|
| `ErrorCoalgebra V` | Foundations/ErrorHopfStructure | `class` | comult, counit with coassociativity/counitality up to epsilon | PROVED: exact recovery at epsilon=0 |
| `ErrorAntipode V` | Foundations/ErrorHopfStructure | `class` | Antipode S (= healing flow); Hopf axiom up to epsilon | PROVED: exact recovery |
| `ErrorHopfAlgebra V` | Foundations/ErrorHopfStructure | `structure` | Full quasi-Hopf: algebra + coalgebra + antipode | PROVED: all_errors_zero, total_error_bound, tendsto_zero |
| `substrateHopfError N` | Foundations/ErrorHopfStructure | noncomputable def | = computationalUncertainty(N) | PROVED: coalgebra from tick decomposition, healing flow is antipode |

### A4. Error Forms (Layer 0)

| Structure | File | Type | Description | Status |
|-----------|------|------|-------------|--------|
| `ErrorForm0/1/2/3` | Foundations/ErrorForms | `structure` | Discrete k-form + ErrorBound | PROVED: d^2=0 for error forms, exact lifting |
| `errorD0/D1/D2` | Foundations/ErrorForms | noncomputable def | Error-propagating exterior derivative; error scales by C_d = 4/l_P | PROVED: form = d, d^2=0, exact gives 0 error |
| `errorWedge11` | Foundations/ErrorForms | noncomputable def | Wedge with error propagation: A*eH + B*eW + eW*eH | PROVED: form = wedge, exact gives 0 |
| `ErrorMaxwellField` | Foundations/ErrorForms | `structure` | F + eF + e_bianchi + e_source + antisym | PROVED: charge conservation, gauge invariance, Bianchi for gauge-derived |
| `SubstrateBoundedMaxwell N` | Foundations/ErrorForms | `structure extends ErrorMaxwellField` | Noise floors bounded by C_d * delta_comp(N) | PROVED: decreasing, charge conservation |

---

## B. DISCRETE DIFFERENTIAL OPERATORS (Layer 1)

| Operator | File | Type Signature | Acts On | Connected To | Status |
|----------|------|---------------|---------|--------------|--------|
| `forwardDiff` | Spacetime/Operators | ScalarField -> Fin 4 -> LatticePoint -> R | ScalarField | backwardDiff, symmetricDiff, secondDeriv | PROVED: linearity, const=0, commutativity, Leibniz, bridge to symmetricDiff |
| `backwardDiff` | Spacetime/Operators | ScalarField -> Fin 4 -> LatticePoint -> R | ScalarField | forwardDiff, discreteDivergence | PROVED: linearity, const=0, commutativity, Leibniz |
| `symmetricDiff` | Spacetime/Operators | ScalarField -> Fin 4 -> LatticePoint -> R | ScalarField | discreteGradient, Heisenberg p-hat | PROVED: = (forward+backward)/2, commutativity |
| `secondDeriv` | Spacetime/Operators | ScalarField -> Fin 4 -> LatticePoint -> R | ScalarField | discreteLaplacian, Schrodinger, KleinGordon | PROVED: = forward o backward, linearity, const=0 |
| `discreteLaplacian` | Spacetime/Operators | ScalarField -> LatticePoint -> R | ScalarField | Hamiltonian, KleinGordon, healingFlow, LaplacianRicci | PROVED: linearity, const=0 |
| `discreteGradient` | Spacetime/Operators | ScalarField -> LatticePoint -> Fin 4 -> R | ScalarField | = symmetricDiff | PROVED |
| `discreteDivergence` | Spacetime/Operators | VectorField -> LatticePoint -> R | VectorField | conservation laws, codiff | PROVED |

---

## C. DISCRETE EXTERIOR CALCULUS (Layer 3)

| Operator | File | Type Signature | Acts On | Connected To | Status |
|----------|------|---------------|---------|--------------|--------|
| `d0` | Geometry/DiscreteForms | Discrete0Form -> Discrete1Form | 0-forms | d1, gauge potential | PROVED: d1 o d0 = 0 |
| `d1` | Geometry/DiscreteForms | Discrete1Form -> Discrete2Form | 1-forms | Maxwell F=dA, gauge curvature | PROVED: d2 o d1 = 0, antisymmetry |
| `d2` | Geometry/DiscreteForms | Discrete2Form -> Discrete3Form | 2-forms | Bianchi dF=0 | PROVED: d3 o d2 = 0 |
| `d3` | Geometry/DiscreteForms | Discrete3Form -> Discrete4Form | 3-forms | | PROVED: completes de Rham complex |
| `codiff0` | Geometry/HodgeStar | Discrete1Form -> Discrete0Form | 1-forms | charge conservation | PROVED: codiff0^2 = 0 |
| `codiff1` | Geometry/HodgeStar | Discrete2Form -> Discrete1Form | 2-forms | Maxwell current J = codiff1(F) | PROVED |
| `codiff2` | Geometry/HodgeStar | Discrete3Form -> Discrete2Form | 3-forms | | PROVED |
| `hodgeLaplacian0` | Geometry/HodgeStar | Discrete0Form -> Discrete0Form | 0-forms | = codiff0 o d0, Hodge decomposition | PROVED |
| `hodgeLaplacian1` | Geometry/HodgeStar | Discrete1Form -> Discrete1Form | 1-forms | = d0 o codiff0 + codiff1 o d1 | PROVED |
| `wedge11` | Geometry/WedgeProduct | 1-form x 1-form -> 2-form | 1-forms | field strength, error wedge | PROVED: antisymmetry |
| `maxwellCurrent` | Geometry/DiscreteMaxwell | Discrete2Form -> Discrete1Form | 2-forms (F) | charge conservation | PROVED: div J = 0 for antisymmetric F |

---

## D. RIEMANNIAN/LORENTZIAN GEOMETRY (Layer 3)

### D1. Discrete Geometry

| Operator | File | Type | Acts On | Connected To | Status |
|----------|------|------|---------|--------------|--------|
| `minkowskiMetric` | Geometry/Metric | MetricTensor | -- | flat limit of all HPW regimes | PROVED: Lorentzian signature |
| `inverseMetric` | Geometry/Metric | MetricTensor -> MetricTensor | MetricTensor | index raising/lowering | PROVED: inverse of Minkowski |
| `metricDerivative` | Geometry/Connection | DiscreteMetric -> indices -> LatticePoint -> R | metric | Christoffel input | PROVED |
| `christoffelSymbol` | Geometry/Connection | DiscreteMetric -> indices -> LatticePoint -> R | metric | Riemann, covariant deriv | PROVED: symmetric in lower indices |
| `covariantDerivVector` | Geometry/Connection | DiscreteMetric -> VectorField -> ... | vectors | parallel transport | PROVED |
| `covariantDerivCovector` | Geometry/Connection | DiscreteMetric -> CovectorField -> ... | covectors | parallel transport | PROVED |
| `riemannTensor` | Geometry/Curvature | DiscreteMetric -> indices -> LatticePoint -> R | metric | Ricci, Einstein, Weyl | PROVED |
| `ricciTensor` | Geometry/Curvature | DiscreteMetric -> indices -> LatticePoint -> R | metric | Einstein, scalar curvature | PROVED |
| `scalarCurvature` | Geometry/Curvature | DiscreteMetric -> LatticePoint -> R | metric | Einstein tensor | PROVED |
| `einsteinTensor` | Geometry/Curvature | DiscreteMetric -> indices -> LatticePoint -> R | metric | Einstein emergence, HPW | PROVED: trace-free part |
| `kretschmannMixed` | Geometry/Curvature | DiscreteMetric -> LatticePoint -> R | metric | singularity detection | PROVED |

### D2. Continuum Geometry (Mizar stack, Apr 15)

| Operator | File | Type | Description | Status |
|----------|------|------|-------------|--------|
| `SmoothMetric` | Geometry/SmoothMetric | structure | Continuum metric g(x) : R^4 -> MetricTensor | PROVED |
| `Christoffel_cont` | Geometry/Christoffel | (R^4->R) -> indices -> R^4 -> R | Continuum Christoffel symbols | PROVED: symmetry |
| `Riemann_cont` | Geometry/RiemannCurvature | ... | Continuum Riemann tensor | PROVED |
| `Ricci_cont` | Geometry/RicciTensor | ... | Continuum Ricci tensor | PROVED: properties |
| `HarmonicGaugeContinuum` | Geometry/HarmonicGaugeContinuum | ... | Harmonic coordinate condition | PROVED |
| `Weyl/WeylGeneral` | Geometry/Weyl, WeylGeneral | ... | Weyl conformal tensor | PROVED: tracelessness |

---

## E. TORSION (Einstein-Cartan, Layer 10)

| Operator | File | Type | Acts On | Connected To | Status |
|----------|------|------|---------|--------------|--------|
| `torsionTensor` | Torsion/Torsion | Connection -> indices -> LatticePoint -> R | connection | contorsion, EC connection | PROVED: antisymmetry |
| `contorsionTensor` | Torsion/Torsion | Torsion -> indices -> LatticePoint -> R | torsion | EC connection | PROVED |
| `einsteinCartanConnection` | Torsion/Torsion | Metric + Torsion -> ... | metric+torsion | big bounce | PROVED |
| `emergentTorsion` | Torsion/Torsion | SemiSmoothMetric -> ... | defect tensor | spin-torsion coupling | PROVED |
| `torsionPressure` | Torsion/Torsion | fermionDensity -> R | fermion density | big bounce | PROVED: positive |
| `spinDensity` | Torsion/SpinTorsion | SpinorField -> LatticePoint -> R | spinor fields | torsion source | PROVED: nonneg |
| `torsionSpinCoupling` | Torsion/SpinTorsion | R (= l_P^2/hbar) | -- | spin-torsion link | PROVED |
| `torsionFromSpinDensity` | Torsion/SpinTorsion | R -> R | spin density | emergent torsion | PROVED |
| `bounceDensity` | Torsion/BigBounce | R (= c^5/(G^2 hbar)) | -- | Poplawski big bounce | PROVED: positive |

---

## F. GAUGE THEORY (Layers 8+)

### F1. U(1) Electromagnetic

| Operator | File | Type | Acts On | Connected To | Status |
|----------|------|------|---------|--------------|--------|
| `GaugeConnection` | Emergence/ErrorGaugeField | structure (potential, eA) | 1-form + error | Maxwell, holonomy | PROVED |
| `gaugeCurvature` | Emergence/ErrorGaugeField | GaugeConnection -> ErrorForm2 | gauge connection | F=dA, Maxwell | PROVED: form=d1(A), Bianchi exact |
| `gaugeHolonomy` | Emergence/ErrorGaugeField | GaugeConnection -> List OrientedEdge -> R | Wilson loop | Aharonov-Bohm | PROVED: gauge invariant, plaquette=flux |
| `photonSubstrateMassBound` | Emergence/ErrorGaugeField | N -> R (= delta_comp/c) | -- | prediction: nonzero photon mass | PROVED: pos, decreasing, tendsto_zero |
| `lineIntegralOfConnection` | Emergence/AharonovBohm | 1-form -> loop -> R | gauge potential | holonomy, AB effect | PROVED |
| `plaquetteLoop` | Emergence/AharonovBohm | LatticePoint -> Fin4 -> Fin4 -> edges | -- | Stokes, flux | PROVED: Stokes identity |

### F2. SU(2) Weak Force

| Operator | File | Type | Acts On | Connected To | Status |
|----------|------|------|---------|--------------|--------|
| `SU2LieAlgebra` | Emergence/ErrorGaugeSU2 | abbrev (Fin 3 -> R) | -- | weak force | -- |
| `su2Bracket` | Emergence/ErrorGaugeSU2 | SU2LieAlgebra -> SU2LieAlgebra -> SU2LieAlgebra | su(2) elements | Lie algebra | PROVED: antisymmetry exact, **Jacobi PROVED exactly** (BAC-CAB), left-linear |
| `exactSU2LieAlgebra` | Emergence/ErrorGaugeSU2 | instance ErrorLieAlgebra | SU2LieAlgebra | all epsilon = 0 | PROVED |
| `ErrorSU2Bracket N` | Emergence/ErrorGaugeSU2 | structure | -- | substrate bracket at finite N | PROVED: bounds from exact + delta_comp |
| `weakCouplingConstant_from_substrate` | Emergence/ErrorGaugeSU2 | N -> Lambda -> WeakCouplingFromSubstrate | -- | g_W^2 = delta_comp * (Lambda/E_P)^2 | PROVED: pos, decreasing, tendsto_zero |
| `weakBoson_mass_from_error` | Emergence/ErrorGaugeSU2 | ... -> WeakBosonMassFromError | -- | m_W, m_Z from substrate | PROVED: m_W pos, m_Z pos, m_Z > m_W |

### F3. SU(3) Strong Force

| Operator | File | Type | Acts On | Connected To | Status |
|----------|------|------|---------|--------------|--------|
| `SU3LieAlgebra` | Emergence/ErrorGaugeSU3 | abbrev (Fin 8 -> R) | -- | strong force | -- |
| `su3f` | Emergence/ErrorGaugeSU3 | Fin 8 -> Fin 8 -> Fin 8 -> R | structure constants | su(3) bracket | PROVED: antisymmetry (512-case exhaustive check) |
| `su3Bracket` | Emergence/ErrorGaugeSU3 | SU3LieAlgebra -> SU3LieAlgebra -> SU3LieAlgebra | su(3) elements | Lie algebra | PROVED: antisymmetry exact, left-linear. **Jacobi carried as HYPOTHESIS (hJ)** |
| `strongCouplingConstant_from_substrate` | Emergence/ErrorGaugeSU3 | N -> Lambda -> StrongCouplingFromSubstrate | -- | g_s^2 = delta_comp * (Lambda/E_P)^2 | PROVED: pos, decreasing, tendsto_zero |
| `gluonSubstrateMassBound` | Emergence/ErrorGaugeSU3 | N -> R (= delta_comp/c) | -- | nonzero gluon mass | PROVED: pos, decreasing, tendsto_zero |

### F4. Symmetry Breaking & Higgs

| Operator | File | Type | Description | Status |
|----------|------|------|-------------|--------|
| `GaugeSymmetry G V` | Emergence/SymmetryBreaking | structure | Group action of G on V | PROVED: action_one, action_mul |
| `SymmetryBreakingData G H V` | Emergence/SymmetryBreaking | structure | G -> H via vacuum phi_0 | PROVED |
| `GoldstoneCount` | Emergence/SymmetryBreaking | dim_G - dim_H | -- | = 3 for electroweak | PROVED |
| `MexicanHatPotential` | Emergence/SymmetryBreaking | R -> R -> R -> R | scalar field | Higgs potential | PROVED: completing square, vev is minimum, V''(v)=4mu^2, origin unstable |
| `HiggsField N` | Emergence/HiggsFromError | N -> R (= delta_comp(N)) | -- | Higgs = error field | PROVED: pos, ne_zero |
| `higgs_vev N` | Emergence/HiggsFromError | N -> R (= delta_comp(N)) | -- | vev = error level | PROVED: pos, decreasing |
| `symmetryBreakingScale N` | Emergence/HiggsFromError | N -> R | -- | EW breaking scale | PROVED: pos, decreasing |
| `wBosonMass_sq_from_higgs` | Emergence/HiggsFromError | N -> Lambda -> R | -- | m_W^2 = delta^3 (Lambda/E_P)^2 / 4 | PROVED: pos, decreasing, tendsto_zero |
| `symmetry_restoration_at_high_energy` | Emergence/HiggsFromError | theorem | vev -> 0 as N -> inf | PROVED |

---

## G. QUANTUM MECHANICS (Layers 8+)

### G1. Wave Mechanics Operators

| Operator | File | Type | Acts On | Connected To | Status |
|----------|------|------|---------|--------------|--------|
| `discreteLaplacianC` | Emergence/SchrodingerFromLattice | ComplexScalarField -> LatticePoint -> C | complex scalar | Schrodinger, Hamiltonian, KG | PROVED |
| `secondDerivC` | Emergence/SchrodingerFromLattice | ComplexScalarField -> Fin 4 -> LatticePoint -> C | complex scalar | Laplacian_C | PROVED |
| `schrodingerRHS` | Emergence/SchrodingerFromLattice | ... | coarse-grained field | Schrodinger eq | PROVED: bounded residue |
| `schrodingerBoundConst m` | Emergence/SchrodingerFromLattice | R (= 16/l_P^2 + m^2c^2/hbar^2) | -- | UV bound | PROVED |
| `hamiltonianC m V` | Emergence/HilbertEmergence | R -> (LatticePoint->R) -> ComplexScalarField -> LatticePoint -> C | complex scalar | -(hbar^2/2m)Delta + V | **PROVED HERMITIAN** on shift-closed regions |
| `positionOperator mu` | Emergence/Heisenberg | LatticeOperator (= LatticeComplexField -> LatticeComplexField) | complex field | [x,p] commutator | PROVED |
| `momentumOperator mu` | Emergence/Heisenberg | LatticeOperator | complex field | [x,p] commutator | PROVED (symmetric diff = self-adjoint) |
| `LatticeOperator.commutator` | Emergence/Heisenberg | LatticeOperator -> LatticeOperator -> LatticeOperator | operators | Heisenberg, Robertson | PROVED |
| `IsHermitianOnRegion` | Emergence/HilbertEmergence | Prop | operators | observable_expectation_real | PROVED: Hamiltonian satisfies it |

### G2. Klein-Gordon / Dirac

| Operator | File | Type | Acts On | Connected To | Status |
|----------|------|------|---------|--------------|--------|
| `secondTickDiffC` | Emergence/KleinGordon | complex scalar | temporal 2nd deriv | d'Alembertian | PROVED |
| `dAlembertianC` | Emergence/KleinGordon | ComplexScalarField -> LatticePoint -> C | complex scalar | KG operator | PROVED |
| `kleinGordonResidue` | Emergence/KleinGordon | ... | complex scalar | KG equation | PROVED: bounded on static/flat |
| `gammaClifford mu` | Emergence/DiracEquation | Fin 4 -> Matrix (Fin 4) (Fin 4) C | spinor indices | Dirac operator | PROVED: gamma0-3 explicit, diagonal Clifford, entry norm <= 1 |
| `discreteDiracOp m` | Emergence/DiracEquation | R -> DiracSpinorField -> LatticePoint -> Fin 4 -> C | spinor fields | i*gamma*d - mc/hbar | PROVED: vacuum is solution, substrate error bound |
| `IsDiracSolution m psi` | Emergence/DiracEquation | Prop | spinor fields | Dirac equation | PROVED: vacuum satisfies |
| `DiracSquaredIsKG` | Emergence/DiracEquation | structure | -- | D^2 = KG (structural) | PROVED: mass shell E^2 = (pc)^2 + (mc^2)^2 |
| `relativisticEnergy` | Emergence/SpecialRelativity | R -> R -> R | (p, m) | mass shell, Dirac, KG | PROVED: E^2 = (pc)^2 + (mc^2)^2 |

### G3. Hilbert Space Structure

| Structure | File | Description | Status |
|-----------|------|-------------|--------|
| `complexInnerRegion` | Emergence/HilbertEmergence | Sum over region of conj(f)*g | PROVED: conjugate symmetry, linearity, self-inner nonneg |
| `ShiftClosed region` | Emergence/HilbertEmergence | Region closed under nearest-neighbour shifts | Used for Hermiticity |
| `discreteLaplacianC_hermitian` | Emergence/HilbertEmergence | <f, Delta g> = <Delta f, g> | **PROVED** |
| `hamiltonianC_hermitian` | Emergence/HilbertEmergence | <f, H g> = <H f, g> | **PROVED** |
| `observable_expectation_real` | Emergence/HilbertEmergence | Hermitian O => <psi, O psi> in R | **PROVED** |
| `LatticeHilbertStructure` | Emergence/HilbertEmergence | Bundle: inner product + Hermiticity + observables | PROVED |
| `LatticeHermitianOperators` | Emergence/HilbertEmergence | Bundle: Hamiltonian + real expectations | PROVED |

### G4. QM Phenomena

| Structure | File | Description | Status |
|-----------|------|-------------|--------|
| `BornRule` | Emergence/BornRule | p = \|amplitude\|^2 from Gibbs normalization | PROVED as theorem |
| `Interference` | Emergence/Interference | \|A1+A2\|^2 = \|A1\|^2 + \|A2\|^2 + 2Re(A1*A2) | PROVED |
| `Entanglement/Bell/CHSH` | Emergence/Entanglement, CHSHBell | Bell field, CHSH value, Tsirelson bound 2sqrt(2) attained | PROVED |
| `Decoherence` | Emergence/Decoherence | Partial trace, off-diagonal vanishing, environment-induced | PROVED |
| `Heisenberg/Robertson` | Emergence/Heisenberg | Robertson inequality var(A)*var(B) >= (Im<[A,B]>)^2, conditional hbar/2 | PROVED: Robertson exact, conditional via CommutatorMatchesMean |
| `Measurement` | Emergence/Measurement | Collapse, Born rule consistency | PROVED |
| `BekensteinBound` | Emergence/BekensteinBound | Entropy <= A/(4 l_P^2), Bell marginals | PROVED |
| `PathIntegral` | Emergence/PathIntegral | Feynman sum over lattice paths, exp(iS/hbar) | PROVED: interference, substrate error |

---

## H. CONNES SPECTRAL ACTION (Bridge to Standard Model)

| Structure | File | Description | Status |
|-----------|------|-------------|--------|
| `FiniteAlgebra` | Emergence/ConnesSpectralAction | C x H x M_3(C) | PROVED: dim_C = 14, dim_R = 24 |
| `GaugeGroupFromAlgebra` | Emergence/ConnesSpectralAction | Inn(A_F) = U(1) x SU(2) x SU(3) | PROVED: IsStandardModelGaugeGroup |
| `SpectralTriple` | Emergence/ConnesSpectralAction | (Alg, Hilb, Op) with cutoff | PROVED |
| `SpectralActionExpansion` | Emergence/ConnesSpectralAction | Tr(f(D/Lambda)) -> EH + YM + Higgs + CC | Structural (Prop-carrying, True-inhabited) |
| `SubstrateSpectralConnection N` | Emergence/ConnesSpectralAction | cutoff = 1/delta_comp(N) | PROVED: increasing, unbounded |
| `gaugeLieAlgebraDim` | Emergence/ConnesSpectralAction | = 12 = 1 + 3 + 8 | PROVED |

---

## I. HEALING FLOW & EMERGENCE (Layers 7-8)

| Operator | File | Type | Description | Status |
|----------|------|------|-------------|--------|
| `healingFunctional` | HealingFlow/Functional | params -> metric -> ... -> R | F[g] = info + defect + smoothness | PROVED: nonneg |
| `functionalGradient` | HealingFlow/Lyapunov | ... | delta F / delta g | PROVED |
| `gradientNormSq` | HealingFlow/Lyapunov | ... | \|\|grad F\|\|^2 | PROVED |
| `dissipationRate` | HealingFlow/Lyapunov | ... | dF/dtau <= -dt * gradNormSq | PROVED: Lyapunov, tendsto_zero |
| `IsHealingFlow` | HealingFlow/Flow | structure | dg/dtau = -grad F | PROVED: equilibrium, gradient descent |
| `IsHealingEquilibrium` | HealingFlow/Flow | structure | grad F = 0 | PROVED |
| `LaSalle` | HealingFlow/LaSalle | ... | Invariance principle for F | PROVED |
| `EinsteinEmergenceResult` | Emergence/EinsteinEmergence | structure | Healing equilibrium -> Einstein equations | PROVED: 7 HPW regimes |

---

## J. VARIATIONAL CALCULUS (Layer 12)

| Operator | File | Type | Description | Status |
|----------|------|------|-------------|--------|
| `graphLagrangian` | Variational/GraphAction | L(u,v) = (1/2)w(u,v)^2 - phi(u) | discrete Lagrangian | PROVED |
| `graphAction` | Variational/GraphAction | sum of L along path | discrete action | PROVED: additive, stationary principle |
| `graphHamiltonian` | Variational/DiscreteNoether | ... | H = sum p*v - L (Legendre) | PROVED |
| `canonicalMomentum` | Variational/DiscreteNoether | ... | p_mu = dL/d(dot phi_mu) | PROVED |
| `LatticeSymmetry` | Variational/DiscreteNoether | structure | translation/rotation on lattice | PROVED: Noether current conserved |
| `GaugeTransformation` | Variational/DiscreteNoether | structure | phi -> phi + epsilon*delta_phi | PROVED |
| `informationLagrangianDensity` | Variational/InformationGeodesics | ... | Fisher-Rao-type Lagrangian | PROVED |
| `discreteInformationAction` | Variational/InformationGeodesics | ... | information geodesic action | PROVED |

---

## K. CLIFFORD ALGEBRA

| Structure | File | Description | Status |
|-----------|------|-------------|--------|
| `gamma0, gamma1, gamma2, gamma3` | Emergence/DiracEquation | Explicit 4x4 complex matrices (Dirac rep) | PROVED: all entries |
| `gammaClifford mu` | Emergence/DiracEquation | Selector: mu -> gamma matrix | PROVED |
| `gammaClifford_sq` | Emergence/DiracEquation | gamma^mu * gamma^mu = etaPP(mu) * I | **PROVED for all 4 diagonal cases** |
| `gammaClifford_anticommutator_diag` | Emergence/DiracEquation | {gamma^mu, gamma^mu} = 2*eta(mu)*I | **PROVED** |
| `CliffordOffDiagonal` | Emergence/DiracEquation | {gamma^mu, gamma^nu} = 0 for mu != nu | **HYPOTHESIS** (not yet proved component-wise; 12 off-diagonal cases) |
| `gammaClifford_anticommutator` | Emergence/DiracEquation | Full Clifford relation assuming CliffordOffDiagonal | PROVED (modulo hypothesis) |

---

## L. HERMITICITY STATUS

| Operator | Hermiticity | File | Status |
|----------|------------|------|--------|
| `discreteLaplacianC` | <f, Delta g> = <Delta f, g> | HilbertEmergence | **PROVED** on shift-closed regions |
| `hamiltonianC m V` | <f, H g> = <H f, g> | HilbertEmergence | **PROVED** (from Laplacian + real V) |
| `positionOperator` | self-adjoint? | Heisenberg | Not explicitly proved; multiplication by real x |
| `momentumOperator` | self-adjoint? | Heisenberg | Noted as "naturally self-adjoint symmetric-difference"; not formally proved |
| Gamma matrices | Hermiticity | DiracEquation | gamma0 = gamma0^dag PROVED (diagonal real). Spatial gammas: not explicitly proved |

---

## M. JACOBI IDENTITY STATUS

| Algebra | Jacobi Identity | File | Status |
|---------|----------------|------|--------|
| su(2) | [[X,Y],Z] + cyc = 0 | ErrorGaugeSU2 | **PROVED exactly** (BAC-CAB identity, ring tactic) |
| su(3) | [[X,Y],Z] + cyc = 0 | ErrorGaugeSU3 | **HYPOTHESIS (hJ)**: carried as function parameter, NOT proved from su3f |
| ErrorLieAlgebra (abstract) | Jacobi up to epsilon | ErrorLieAlgebra | **PROVED**: exact recovery at epsilon=0 |

---

## N. SYMMETRY INVENTORY

### Symmetries PROVED preserved:
1. **Gauge invariance** (U(1)): F from A+dchi = F from A (PROVED in ErrorGaugeField, AharonovBohm)
2. **d^2 = 0**: exact for all degrees (PROVED in DiscreteForms, ErrorForms)
3. **Charge conservation**: div J = 0 for any antisymmetric F (PROVED in DiscreteMaxwell)
4. **Bianchi identity**: dF = 0 for F = dA (PROVED, algebraic)
5. **Lorentz signature**: Minkowski metric is Lorentzian (PROVED)
6. **Curvature symmetries**: Riemann antisymmetry, Bianchi (PROVED in CurvatureSymmetries)
7. **Torsion antisymmetry**: T^rho_{mu nu} = -T^rho_{nu mu} (PROVED)
8. **Poincare lemma**: d-closed => d-exact on star-shaped domains (PROVED)
9. **Hodge decomposition**: omega = d alpha + codiff beta + harmonic (PROVED structurally)
10. **Gauss-Bonnet**: on 2D lattice subcomplex (PROVED)

### Symmetries BROKEN by substrate (with error bound):
1. **Exact Lie algebra axioms**: broken by delta_comp(N), restored at N->inf
2. **Exact Hopf algebra axioms**: broken by delta_comp(N), restored at N->inf
3. **SU(2)xU(1) -> U(1)_EM**: Higgs vev = delta_comp(N) > 0
4. **Photon masslessness**: m_gamma <= delta_comp(N)/c > 0
5. **Gluon masslessness**: m_gluon <= delta_comp(N)/c > 0
6. **Jacobi identity**: violated by O(delta_comp(N)) on substrate

### Symmetries NOT formalized:
1. CPT symmetry
2. Lepton/baryon number conservation
3. CKM mixing
4. Neutrino oscillation
5. Anomaly cancellation

---

## O. STANDARD MODEL INTERACTIONS -- WHAT'S PRESENT vs MISSING

### PRESENT:
- U(1) gauge theory (photon) -- full lattice formulation + error
- SU(2) gauge theory (W/Z) -- Lie algebra + coupling + masses from substrate
- SU(3) gauge theory (gluons) -- structure constants + coupling + mass bound
- Higgs mechanism -- vev = delta_comp, symmetry breaking, W/Z masses
- Electroweak breaking -- Goldstone count = 3, symmetry restoration
- Dirac equation on lattice -- gamma matrices, Clifford (diagonal), spinor fields
- Klein-Gordon equation -- d'Alembertian, mass shell, bounded residue
- Connes spectral triple -- A_F = C + H + M_3(C), gauge group derivation

### MISSING:

| Missing Interaction | What Would Be Needed | Difficulty |
|--------------------|---------------------|------------|
| **W boson decay** (W -> e + nu) | Coupling to fermion doublets, SU(2) gauge-fermion vertex | Medium |
| **Gluon self-coupling** (triple/quartic vertex) | Non-abelian F = dA + A wedge A for SU(3) | Medium-Hard (F = dA only for abelian) |
| **Neutrino oscillation** | PMNS matrix, mass mixing, Dirac/Majorana distinction | Hard |
| **QCD confinement** | Wilson loop area law, running coupling | Very Hard |
| **CKM matrix** | Quark mixing, CP violation | Hard |
| **Anomaly cancellation** | Triangle diagrams, ABJ anomaly | Hard |
| **Running coupling constants** | Renormalization group flow from lattice | Hard |
| **Yukawa couplings** | Fermion-Higgs vertex | Medium |
| **Non-abelian gauge curvature** | F = dA + [A,A] for SU(2)/SU(3) | **Critical gap** |
| **Gauge covariant derivative** | D = d + igA (non-abelian) | Medium |

---

## P. TOP 10 MISSING CONNECTIONS

These are operator pairs that **exist separately** in the codebase but are **not yet connected** to each other.

### 1. su3Bracket Jacobi identity (NOT PROVED)
**What exists**: su3f structure constants (all 84 nonzero entries), su3Bracket, antisymmetry proved.
**What's missing**: The 512-case Jacobi identity verification. It's carried as hypothesis `hJ`. This is the single biggest algebraic gap -- it blocks full SU(3) ErrorLieAlgebra instantiation.
**Fix**: Exhaustive `fin_cases` with increased heartbeats (like su3f_antisym already uses 800000).

### 2. Non-abelian gauge curvature F = dA + A wedge A
**What exists**: U(1) curvature F = dA (ErrorGaugeField), wedge product (WedgeProduct), SU(2)/SU(3) brackets.
**What's missing**: For non-abelian gauge groups, F_mu_nu = d_mu A_nu - d_nu A_mu + [A_mu, A_nu]. The A-wedge-A term is not assembled. This means gluon self-coupling is absent.
**Fix**: Define `nonAbelianCurvature := d1 A + errorWedge11 A A ...` using the existing bracket.

### 3. Clifford off-diagonal anticommutator — **CLOSED** (Tureis, Apr-15)
**What exists**: All 4 diagonal cases `gamma^mu * gamma^mu = eta(mu)*I` PROVED. Gamma matrices fully defined. **Plus: all 12 off-diagonal cases `{gamma^mu, gamma^nu} = 0` for mu != nu PROVED** via `gammaClifford_offDiagonal` in `DiracEquation.lean:209`. Six unique pair theorems (`gamma0_gamma1_anticomm` through `gamma2_gamma3_anticomm`) each use component-wise `fin_cases i <;> fin_cases j <;> simp [gammaI, gammaJ, Matrix.mul_apply, Matrix.of_apply, Fin.sum_univ_four, Matrix.add_apply] <;> ring` (192 matrix entries per pair, all routine); the 6 reversed pairs close by `rw [add_comm]; exact <pair_lemma>`. The legacy `CliffordOffDiagonal` hypothesis is discharged unconditionally by `cliffordOffDiagonal_holds`, and `gammaClifford_anticommutator_full` gives the full `{γ^μ, γ^ν} = 2η^{μν}·I` Clifford relation without any hypothesis. `diracSquaredIsKG_unconditional` → D²=KG bundle inhabited unconditionally. Verified Apr-17 by Dubhe: full project GREEN 3544 jobs.

### 4. Momentum operator Hermiticity
**What exists**: `momentumOperator mu` defined as symmetric difference (naturally self-adjoint). `IsHermitianOnRegion` defined. `hamiltonianC_hermitian` PROVED.
**What's missing**: Explicit proof that `momentumOperator` is Hermitian on shift-closed regions (would complete the QM operator algebra).
**Fix**: Follows same pattern as `discreteLaplacianC_hermitian`.

### 5. Dirac operator Hermiticity (gamma^0 conjugation)
**What exists**: Dirac operator, gamma matrices, Clifford algebra (partial).
**What's missing**: Proof that `gamma0 * D * gamma0` is Hermitian (standard QFT result). The Predictions/HermiticityDefect.lean proves the DEFECT is bounded but doesn't prove exact Hermiticity.
**Fix**: Requires full Clifford + gamma0-conjugation argument.

### 6. Spectral action concrete expansion
**What exists**: `SpectralActionExpansion` structure with `has_einstein_hilbert`, `has_yang_mills`, `has_higgs`. All set to `True` (trivially inhabited).
**What's missing**: Concrete Seeley-DeWitt coefficient computation connecting to existing Einstein emergence + gauge + Higgs structures.
**Fix**: Hard -- requires heat kernel expansion on the product geometry.

### 7. Gauge covariant derivative (non-abelian)
**What exists**: `covariantDerivVector`, `covariantDerivCovector` (for gravity, Christoffel-based). `GaugeConnection` (U(1)).
**What's missing**: Gauge covariant derivative D_mu = partial_mu + ig A_mu^a T^a for SU(2)/SU(3).
**Fix**: Define using existing su2Bracket/su3Bracket + ErrorGaugeField infrastructure.

### 8. Healing flow -> Dirac equation bridge
**What exists**: Healing flow (Lyapunov, convergence). Dirac operator on lattice.
**What's missing**: How the healing flow equilibrium constrains the Dirac field. The spinor sector doesn't feed back into the healing functional.
**Fix**: Add spinor-metric coupling to healing functional (spinor energy contributes to stress-energy).

### 9. Information geodesics -> QM path integral
**What exists**: `discreteInformationAction` (Fisher-Rao Lagrangian). `pathIntegralAmplitude` (Feynman sum).
**What's missing**: The two geodesic structures are not unified. The information geodesic action should reduce to the Feynman path integral in the appropriate limit.
**Fix**: Show lattice path integral weighting exp(iS/hbar) emerges from information-theoretic Lagrangian.

### 10. Connes algebra <-> ErrorLieAlgebra bridge
**What exists**: `FiniteAlgebra = C x H x M_3(C)` (Connes). `ErrorLieAlgebra` framework with su(2)/su(3) instances.
**What's missing**: The inner automorphisms Inn(A_F) should produce exactly the ErrorLieAlgebra instances for su(2) and su(3). The bridge exists only as dimensional counting (3+8=11 generators), not as an algebraic homomorphism.
**Fix**: Construct explicit map from Inn(C x H x M_3(C)) to su(2) x su(3) error brackets.

---

## Q. SUMMARY STATISTICS

| Category | Count |
|----------|-------|
| Total Lean files | 135 |
| Theorems (approx) | ~1640 |
| `sorry` | **0** |
| New axioms | **0** |
| Algebraic structures (class/structure) | ~50 |
| Operators (noncomputable def, acting on fields) | ~80 |
| Lie algebras formalized | 3: abstract ErrorLie, su(2) (full), su(3) (antisym only, Jacobi hyp) |
| Gauge groups | U(1) (full), SU(2) (full), SU(3) (partial) |
| Hermiticity proofs | Laplacian, Hamiltonian, partial trace |
| Clifford relations proved | 4/16 diagonal, 0/12 off-diagonal |
| Jacobi identities proved | su(2): full. su(3): hypothesis only |
| Falsifiable predictions | 9+ (dispersion, decoherence T^2, redshift floor, teleportation infidelity, Hermiticity defect, Christoffel sparsity, spin flip, photon mass, Jacobi violation) |
