// ============================================================
// SCOUT findings: Mathlib v4.29 infrastructure relevant to HPW
// Written 2026-04-14 by Scout sub-agent
// ============================================================

// Ensure the axiom node exists (Cataloguer may also write this)
MERGE (hpw:Axiom {namespace:'OmegaTheoryV2', name:'hpw_laplacian_ricci_convergence'});

// ---- HIGHEST-VALUE: Taylor theorem with Lagrange remainder ----
MERGE (m3:MathlibInfra {namespace:'OmegaTheoryV2', name:'taylor_mean_remainder_lagrange'})
SET m3.path = 'Mathlib/Analysis/Calculus/Taylor.lean',
    m3.kind = 'theorem',
    m3.relevance = 'Classic Taylor theorem: f(x)=T_n(x)+f^(n+1)(xi)/(n+1)!*(x-x0)^(n+1) for some xi. Sibling exists_taylor_mean_remainder_bound gives uniform C bound. THE key ingredient to turn discrete second differences into continuum second derivatives with explicit a^2 error.',
    m3.applicability_score = 10,
    m3.required_glue = 'Small. Lift from 1D (Mathlib) to 4D via iteratedFDeriv or via LineDeriv. Need C^4 regularity on metric components + uniform bound on 4th derivatives.';

MATCH (m3:MathlibInfra {namespace:'OmegaTheoryV2', name:'taylor_mean_remainder_lagrange'}),
      (hpw:Axiom {namespace:'OmegaTheoryV2', name:'hpw_laplacian_ricci_convergence'})
MERGE (m3)-[:POTENTIALLY_HELPS]->(hpw);

// ---- HIGH-VALUE: Continuum Laplacian on inner product space ----
MERGE (m2:MathlibInfra {namespace:'OmegaTheoryV2', name:'InnerProductSpace.laplacian'})
SET m2.path = 'Mathlib/Analysis/InnerProductSpace/Laplacian.lean',
    m2.kind = 'definition',
    m2.relevance = 'Delta f on real finite-dim inner product space via canonical covariant tensor of 2nd derivative. Theorem laplacian_eq_iteratedFDeriv_stdOrthonormalBasis states Delta f(x)=sum over basis of iteratedFDeriv 2 f x, mirroring our discreteLaplacian=sum secondDeriv structurally.',
    m2.applicability_score = 8,
    m2.required_glue = 'Target operator for HPW convergence. Need smooth function representing metric component + show discrete second-difference tends to iteratedFDeriv 2 with a^2 remainder via Taylor. Mathlib gives DEFINITION, not convergence.';

MATCH (m2:MathlibInfra {namespace:'OmegaTheoryV2', name:'InnerProductSpace.laplacian'}),
      (hpw:Axiom {namespace:'OmegaTheoryV2', name:'hpw_laplacian_ricci_convergence'})
MERGE (m2)-[:POTENTIALLY_HELPS]->(hpw);

// ---- HIGH-VALUE: Iterated Frechet derivative with bounds ----
MERGE (m7:MathlibInfra {namespace:'OmegaTheoryV2', name:'iteratedFDeriv'})
SET m7.path = 'Mathlib/Analysis/Calculus/ContDiff/Bounds.lean',
    m7.kind = 'definition',
    m7.relevance = 'iteratedFDeriv k f x provides kth derivative as continuous multilinear map. Bounds.lean gives Leibniz-style estimates on norm. Essential for lifting 1D Taylor to multivariate.',
    m7.applicability_score = 8,
    m7.required_glue = 'Moderate. Compose multi-variable Taylor expansion for second difference in each axis direction, then sum over mu in Fin 4. Mathlib has ingredients, not assembled.';

MATCH (m7:MathlibInfra {namespace:'OmegaTheoryV2', name:'iteratedFDeriv'}),
      (hpw:Axiom {namespace:'OmegaTheoryV2', name:'hpw_laplacian_ricci_convergence'})
MERGE (m7)-[:POTENTIALLY_HELPS]->(hpw);

// ---- MEDIUM-VALUE: SimpleGraph Laplacian matrix ----
MERGE (m1:MathlibInfra {namespace:'OmegaTheoryV2', name:'SimpleGraph.lapMatrix'})
SET m1.path = 'Mathlib/Combinatorics/SimpleGraph/LapMatrix.lean',
    m1.kind = 'definition',
    m1.relevance = 'Graph Laplacian L=D-A for SimpleGraph. Matches our discreteLaplacian structurally but only elementary theorems (positive semidefinite, Hermitian, connected components = dim ker). No convergence to Laplace-Beltrami.',
    m1.applicability_score = 4,
    m1.required_glue = 'Huge. Would need: (a) Z^4 lattice as SimpleGraph, (b) metric-weighted variant (current uses unit weights), (c) the entire spectral-convergence theorem from scratch since Mathlib does not formalize HPW 2006.';

MATCH (m1:MathlibInfra {namespace:'OmegaTheoryV2', name:'SimpleGraph.lapMatrix'}),
      (hpw:Axiom {namespace:'OmegaTheoryV2', name:'hpw_laplacian_ricci_convergence'})
MERGE (m1)-[:POTENTIALLY_HELPS]->(hpw);

// ---- MEDIUM-VALUE: Spectrum of Hermitian matrix ----
MERGE (m10:MathlibInfra {namespace:'OmegaTheoryV2', name:'Matrix.IsHermitian.spectralTheorem'})
SET m10.path = 'Mathlib/Analysis/Matrix/Spectrum.lean',
    m10.kind = 'theorem',
    m10.relevance = 'Full spectral theorem for finite-dim Hermitian matrices: real eigenvalues, orthonormal eigenbasis, diagonalization. lapMatrix is Hermitian, so this is available.',
    m10.applicability_score = 5,
    m10.required_glue = 'If we route HPW via spectral comparison (eigenvalues of discrete Laplacian vs Delta on torus), use this. Direct Taylor-expansion proof avoids spectral theory and is cleaner.';

MATCH (m10:MathlibInfra {namespace:'OmegaTheoryV2', name:'Matrix.IsHermitian.spectralTheorem'}),
      (hpw:Axiom {namespace:'OmegaTheoryV2', name:'hpw_laplacian_ricci_convergence'})
MERGE (m10)-[:POTENTIALLY_HELPS]->(hpw);

// ---- MEDIUM-VALUE: Riemannian manifold typeclass ----
MERGE (m4:MathlibInfra {namespace:'OmegaTheoryV2', name:'IsRiemannianManifold'})
SET m4.path = 'Mathlib/Geometry/Manifold/Riemannian/Basic.lean',
    m4.kind = 'structure',
    m4.relevance = 'Prop-valued typeclass: smooth manifold with inner-product tangent spaces and path-length distance. Built on EMetricSpace + RiemannianBundle + IsContMDiffRiemannianBundle. Ships inner-product-space canonical metric instance.',
    m4.applicability_score = 3,
    m4.required_glue = 'Overkill for HPW. HPW is local/coordinate, so EMetric / path-length machinery is dead weight. Skip for axiom elimination.';

MATCH (m4:MathlibInfra {namespace:'OmegaTheoryV2', name:'IsRiemannianManifold'}),
      (hpw:Axiom {namespace:'OmegaTheoryV2', name:'hpw_laplacian_ricci_convergence'})
MERGE (m4)-[:POTENTIALLY_HELPS]->(hpw);

// ---- LOW-VALUE: Covariant derivative / Koszul connection ----
MERGE (m5:MathlibInfra {namespace:'OmegaTheoryV2', name:'IsCovariantDerivativeOn'})
SET m5.path = 'Mathlib/Geometry/Manifold/VectorBundle/CovariantDerivative/Basic.lean',
    m5.kind = 'structure',
    m5.relevance = '2025 Massot/Rothgang/Macbeth work. Defines Koszul connections on vector bundles. Companion Torsion.lean gives torsion. NO curvature, NO Ricci, NO Levi-Civita uniqueness yet.',
    m5.applicability_score = 2,
    m5.required_glue = 'Not directly applicable to HPW. Relevant only if proving a CONTINUUM formula for Ricci from the metric; HPW is a discrete-to-continuum bound, not a continuum identity.';

MATCH (m5:MathlibInfra {namespace:'OmegaTheoryV2', name:'IsCovariantDerivativeOn'}),
      (hpw:Axiom {namespace:'OmegaTheoryV2', name:'hpw_laplacian_ricci_convergence'})
MERGE (m5)-[:POTENTIALLY_HELPS]->(hpw);

// ---- LOW-VALUE: Torsion tensor ----
MERGE (m6:MathlibInfra {namespace:'OmegaTheoryV2', name:'CovariantDerivative.torsion'})
SET m6.path = 'Mathlib/Geometry/Manifold/VectorBundle/CovariantDerivative/Torsion.lean',
    m6.kind = 'definition',
    m6.relevance = 'T(X,Y)=nabla_X Y - nabla_Y X - [X,Y] with vanishing characterisation. Useful for SpinTorsion/BigBounce; orthogonal to HPW.',
    m6.applicability_score = 1,
    m6.required_glue = 'Not applicable for HPW. Separate interest for other OmegaTheory files.';

MATCH (m6:MathlibInfra {namespace:'OmegaTheoryV2', name:'CovariantDerivative.torsion'}),
      (hpw:Axiom {namespace:'OmegaTheoryV2', name:'hpw_laplacian_ricci_convergence'})
MERGE (m6)-[:POTENTIALLY_HELPS]->(hpw);

// ---- LOW-VALUE: exterior derivative on differential forms ----
MERGE (m8:MathlibInfra {namespace:'OmegaTheoryV2', name:'DifferentialForm.VectorField'})
SET m8.path = 'Mathlib/Analysis/Calculus/DifferentialForm/VectorField.lean',
    m8.kind = 'theorem',
    m8.relevance = 'Cartan-style formula for d omega using vector fields and Lie brackets (Kudryashov 2025).',
    m8.applicability_score = 3,
    m8.required_glue = 'Not useful for HPW (a Laplacian statement, not exterior-derivative). Tangentially relevant to PoincareLemma.lean.';

MATCH (m8:MathlibInfra {namespace:'OmegaTheoryV2', name:'DifferentialForm.VectorField'}),
      (hpw:Axiom {namespace:'OmegaTheoryV2', name:'hpw_laplacian_ricci_convergence'})
MERGE (m8)-[:POTENTIALLY_HELPS]->(hpw);

// ---- LOW-VALUE: ExteriorPower ----
MERGE (m9:MathlibInfra {namespace:'OmegaTheoryV2', name:'ExteriorPower'})
SET m9.path = 'Mathlib/LinearAlgebra/ExteriorPower/Basis.lean',
    m9.kind = 'structure',
    m9.relevance = 'Algebraic exterior powers with basis. Useful for discrete forms, not HPW.',
    m9.applicability_score = 1,
    m9.required_glue = 'Not applicable to HPW. Useful for DiscreteForms.lean.';

MATCH (m9:MathlibInfra {namespace:'OmegaTheoryV2', name:'ExteriorPower'}),
      (hpw:Axiom {namespace:'OmegaTheoryV2', name:'hpw_laplacian_ricci_convergence'})
MERGE (m9)-[:POTENTIALLY_HELPS]->(hpw);

// ---- LOW-VALUE: Harmonic functions ----
MERGE (m11:MathlibInfra {namespace:'OmegaTheoryV2', name:'InnerProductSpace.HarmonicAt'})
SET m11.path = 'Mathlib/Analysis/InnerProductSpace/Harmonic/Basic.lean',
    m11.kind = 'definition',
    m11.relevance = 'Harmonic functions (ContDiff 2 + Delta f = 0 locally). Shows continuum Laplacian has working API.',
    m11.applicability_score = 3,
    m11.required_glue = 'Not load-bearing for HPW. Nice sanity check that Mathlib Laplacian is usable.';

MATCH (m11:MathlibInfra {namespace:'OmegaTheoryV2', name:'InnerProductSpace.HarmonicAt'}),
      (hpw:Axiom {namespace:'OmegaTheoryV2', name:'hpw_laplacian_ricci_convergence'})
MERGE (m11)-[:POTENTIALLY_HELPS]->(hpw);

// ---- LOW-VALUE: InnerProductSpace.Spectrum ----
MERGE (m12:MathlibInfra {namespace:'OmegaTheoryV2', name:'LinearMap.IsSymmetric.spectralTheorem'})
SET m12.path = 'Mathlib/Analysis/InnerProductSpace/Spectrum.lean',
    m12.kind = 'theorem',
    m12.relevance = 'Spectral theorem for symmetric linear maps on finite-dim inner product spaces.',
    m12.applicability_score = 3,
    m12.required_glue = 'Use only on spectral route. Taylor route preferred.';

MATCH (m12:MathlibInfra {namespace:'OmegaTheoryV2', name:'LinearMap.IsSymmetric.spectralTheorem'}),
      (hpw:Axiom {namespace:'OmegaTheoryV2', name:'hpw_laplacian_ricci_convergence'})
MERGE (m12)-[:POTENTIALLY_HELPS]->(hpw);

// ---- LOW-VALUE: LapMatrix connected components ----
MERGE (m13:MathlibInfra {namespace:'OmegaTheoryV2', name:'card_connectedComponent_eq_finrank_ker_lapMatrix'})
SET m13.path = 'Mathlib/Combinatorics/SimpleGraph/LapMatrix.lean',
    m13.kind = 'theorem',
    m13.relevance = 'Only nontrivial theorem in LapMatrix.lean. dim ker = connected components. Nothing about spectral convergence to continuum.',
    m13.applicability_score = 2,
    m13.required_glue = 'Not applicable to HPW. Useful only for "geometric meshes are connected" axiom.';

MATCH (m13:MathlibInfra {namespace:'OmegaTheoryV2', name:'card_connectedComponent_eq_finrank_ker_lapMatrix'}),
      (hpw:Axiom {namespace:'OmegaTheoryV2', name:'hpw_laplacian_ricci_convergence'})
MERGE (m13)-[:POTENTIALLY_HELPS]->(hpw);

// ============================================================
// Explicit missing-infrastructure gaps
// ============================================================

MERGE (gap1:MathlibGap {namespace:'OmegaTheoryV2', name:'HPW2006_spectral_convergence'})
SET gap1.description = 'Hildebrandt-Polthier-Wardetzky 2006 (Geom. Dedicata 123:89-112): weighted cotangent-scheme graph Laplacians on triangulated meshes converge to Laplace-Beltrami in operator-norm with rate O(h^2). Does not exist in Mathlib.',
    gap1.estimated_effort = 'Enormous. Original paper is ~24 pages of measure theory, convex analysis, differential geometry estimates. Full formalization is multi-month research-level work.';

MATCH (gap1:MathlibGap {namespace:'OmegaTheoryV2', name:'HPW2006_spectral_convergence'}),
      (hpw:Axiom {namespace:'OmegaTheoryV2', name:'hpw_laplacian_ricci_convergence'})
MERGE (gap1)-[:BLOCKS_ELIMINATION_OF]->(hpw);

MERGE (gap2:MathlibGap {namespace:'OmegaTheoryV2', name:'RicciTensor_and_harmonic_gauge'})
SET gap2.description = 'Mathlib has NO Ricci tensor, NO Riemann curvature, NO harmonic coordinates, NO Weinberg box-g identity. The second half of the HPW axiom (harmonic-gauge identity) lives entirely outside Mathlib.',
    gap2.estimated_effort = 'Very large. Need Levi-Civita existence/uniqueness, curvature R^rho_{sigma mu nu}=dGamma+GammaGamma, contraction to Ricci, second Bianchi, harmonic coords as local atlas choice, Weinberg identity in that atlas.';

MATCH (gap2:MathlibGap {namespace:'OmegaTheoryV2', name:'RicciTensor_and_harmonic_gauge'}),
      (hpw:Axiom {namespace:'OmegaTheoryV2', name:'hpw_laplacian_ricci_convergence'})
MERGE (gap2)-[:BLOCKS_ELIMINATION_OF]->(hpw);

MERGE (gap3:MathlibGap {namespace:'OmegaTheoryV2', name:'metric_weighted_graph_laplacian'})
SET gap3.description = 'SimpleGraph.lapMatrix uses unit edge weights. HPW requires edge weights from intrinsic geometry (cotangent weights on triangulated mesh, or for us discrete metric g_{mu nu} pulled back to edge lengths). Pure SimpleGraph machinery is insufficient.',
    gap3.estimated_effort = 'Moderate. Extend SimpleGraph to weighted graphs with R-valued weights. Some infrastructure exists in SimpleGraph.AdjMatrix; needs composition.';

MATCH (gap3:MathlibGap {namespace:'OmegaTheoryV2', name:'metric_weighted_graph_laplacian'}),
      (hpw:Axiom {namespace:'OmegaTheoryV2', name:'hpw_laplacian_ricci_convergence'})
MERGE (gap3)-[:BLOCKS_ELIMINATION_OF]->(hpw);

MERGE (gap4:MathlibGap {namespace:'OmegaTheoryV2', name:'heat_kernel_and_heat_equation'})
SET gap4.description = 'Mathlib has NO heat kernel, NO heat equation. One standard route to HPW (via heat-kernel asymptotics / Varopoulos-Saloff-Coste theorem) is fully unavailable.',
    gap4.estimated_effort = 'Enormous. Would need parabolic PDE theory built on Mathlib distribution/Schwartz-space infrastructure.';

MATCH (gap4:MathlibGap {namespace:'OmegaTheoryV2', name:'heat_kernel_and_heat_equation'}),
      (hpw:Axiom {namespace:'OmegaTheoryV2', name:'hpw_laplacian_ricci_convergence'})
MERGE (gap4)-[:BLOCKS_ELIMINATION_OF]->(hpw);
