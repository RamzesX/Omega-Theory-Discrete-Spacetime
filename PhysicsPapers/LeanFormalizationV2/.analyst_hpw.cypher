// ============================================================
// Analyst sub-agent: HPW 2006 ingredient decomposition
// Namespace: OmegaTheoryV2
// ============================================================

// --- 1. Ensure / annotate the axiom we are trying to eliminate ---
MERGE (hpw:Axiom {namespace:'OmegaTheoryV2', name:'hpw_laplacian_ricci_convergence'})
SET hpw.statement = 'For DiscreteMetric g, mu>0, point p, indices (mu_idx,nu): |mu*discreteLaplacian (g _ mu_idx nu) p + 2*mu*ricciTensor g mu_idx nu p| <= l_P/2',
    hpw.location = 'OmegaTheory/Emergence/LaplacianRicci.lean:67-71',
    hpw.cited_paper_actual = 'Hildebrandt-Polthier-Wardetzky (HPW) 2006, Geom. Ded. 123:89-112. NOT Hoch-Pflaum-Weinrebe.',
    hpw.cited_paper_subject = '2D polyhedral surfaces embedded in R^3, Hausdorff + normal convergence of meshes. No stated O(ell^2) spectral rate in that paper.',
    hpw.weinberg_part_absorbed = 'Yes: continuumBoxG := -2*ricciTensor collapses harmonic-gauge identity box g = -2R + Gamma*Gamma into the error bound',
    hpw.setting_mismatch = 'HPW treats 2D polyhedra in R^3; V2 has Z^4 lattice with constant spacing ell_P and per-point metric, no embedded manifold. Setting mismatch is the central issue.',
    hpw.v2_actual_math_needed = 'Finite-difference truncation error: if g_munu were a C^4 function of a continuum coordinate, then the 3-point second-difference (g(p+e)-2g(p)+g(p-e))/ell^2 = d^2 g/dx^2 + O(ell^2). Combined with the harmonic-gauge identity this gives discreteLaplacian g = -2 Ric + O(ell^2). The ell/2 bound in the axiom is conservative: actual error is O(ell^2 * ||g^(4)||).';

// --- 2. Ingredients of a continuum proof of HPW (for adaptation to V2) ---

// (A) Central-difference Taylor lemma: single-variable second-difference has O(h^2) error
MERGE (i1:ProofIngredient {namespace:'OmegaTheoryV2', name:'central_diff_second_order_accurate'})
SET i1.statement = 'For f : R -> R in C^4, central difference second order Taylor error bounded by (h^2/12) times sup of |f_fourth|',
    i1.status = 'needs_formalising',
    i1.difficulty = 'routine',
    i1.source = 'Standard numerical analysis; derivable from Mathlib.Analysis.Calculus.Taylor',
    i1.mathlib_tools = 'taylor_mean_remainder_lagrange, iteratedDerivWithin',
    i1.is_critical_path = true;

// (B) Separability of the discrete Laplacian on Z^n
MERGE (i2:ProofIngredient {namespace:'OmegaTheoryV2', name:'lattice_laplacian_separates'})
SET i2.statement = 'discreteLaplacian f p = sum over mu of secondDeriv f mu p (already DEFINED this way in V2)',
    i2.status = 'in_repo',
    i2.difficulty = 'trivial',
    i2.source = 'OmegaTheory/Spacetime/Operators.lean:164 (definition)',
    i2.is_critical_path = true;

// (C) Partial-derivative second-order accuracy: 4D extension of (A)
MERGE (i3:ProofIngredient {namespace:'OmegaTheoryV2', name:'partial_secondderiv_second_order_accurate'})
SET i3.statement = 'For F : R^4 -> R in C^4, secondDeriv (F restricted to mu-slice) approx partial_mu^2 F with error (h^2/12)*bound',
    i3.status = 'needs_formalising',
    i3.difficulty = 'routine',
    i3.source = 'Multi-variate Taylor; follows from (A) applied per coordinate',
    i3.is_critical_path = true;

// (D) Harmonic-gauge Ricci formula (the Weinberg step, already absorbed)
MERGE (i4:ProofIngredient {namespace:'OmegaTheoryV2', name:'harmonic_gauge_ricci'})
SET i4.statement = 'In harmonic coordinates, R_{mu nu} = -(1/2) box g_{mu nu} + (quadratic in Gamma); equivalently box g_{mu nu} = -2 R_{mu nu} + O(Gamma^2)',
    i4.status = 'in_repo',
    i4.difficulty = 'absorbed',
    i4.source = 'Absorbed into definition continuumBoxG := -2 * ricciTensor in LaplacianRicci.lean:50',
    i4.is_critical_path = false;

// (E) Continuum interpolant: existence of a smooth g_cont : R^4 -> Matrix agreeing with g on the lattice
MERGE (i5:ProofIngredient {namespace:'OmegaTheoryV2', name:'smooth_continuum_interpolant_existence'})
SET i5.statement = 'Given DiscreteMetric g : Z^4 -> Matrix, there exists a C^4 (or smooth) extension g_cont : R^4 -> Matrix s.t. g_cont(ell*p) = g(p) for lattice points p',
    i5.status = 'needs_formalising',
    i5.difficulty = 'substantial',
    i5.source = 'Standard Whitney / convolution extension; not in Mathlib in this exact form',
    i5.mathlib_tools = 'Mathlib.Analysis.Convolution, Mathlib.Topology.ContinuousFunction.Bounded',
    i5.is_critical_path = true;

// (F) Uniform C^4 bound on the interpolant (physical smoothness assumption)
MERGE (i6:ProofIngredient {namespace:'OmegaTheoryV2', name:'interpolant_c4_bound'})
SET i6.statement = 'The smooth interpolant g_cont has uniformly bounded 4th derivatives: ||D^4 g_cont|| <= M for some M',
    i6.status = 'needs_formalising',
    i6.difficulty = 'substantial',
    i6.source = 'Part of the physical postulate that the metric varies slowly at scales >> ell_P',
    i6.note = 'This is the place where a physical smoothness assumption must be introduced as a hypothesis, not proven',
    i6.is_critical_path = true;

// (G) Continuum Ricci = -(1/2) box g in harmonic gauge (pure Riemannian geometry)
MERGE (i7:ProofIngredient {namespace:'OmegaTheoryV2', name:'continuum_ricci_box_identity'})
SET i7.statement = 'For smooth metric g : R^4 -> Matrix in harmonic coordinates, R_{mu nu}(x) = -(1/2) (partial_alpha partial^alpha g_{mu nu})(x) + Q(g, partial g)(x) where Q is quadratic in Christoffels',
    i7.status = 'needs_formalising',
    i7.difficulty = 'substantial',
    i7.source = 'Weinberg 1972 section 11.1; Carroll lecture notes; folklore in GR. NOT in Mathlib.',
    i7.is_critical_path = true;

// (H) Gauge assumption: g is in harmonic gauge (or error introduced by gauge transformation is bounded)
MERGE (i8:ProofIngredient {namespace:'OmegaTheoryV2', name:'harmonic_gauge_assumption'})
SET i8.statement = 'The continuum metric g_cont is in harmonic gauge: Gamma^rho := g^{mu nu} Gamma^rho_{mu nu} = 0',
    i8.status = 'needs_formalising',
    i8.difficulty = 'substantial',
    i8.source = 'Standard in GR; DeTurck trick provides local existence (Deane Yang 1992)',
    i8.note = 'Can alternatively be weakened to |Gamma^rho| <= ell_P with constant; then Gamma*Gamma contributes O(ell_P^2) to error bound',
    i8.is_critical_path = true;

// (I) Total truncation-error bound: (A) + (C) + (G) + (H) => V2 axiom
MERGE (i9:ProofIngredient {namespace:'OmegaTheoryV2', name:'total_truncation_bound'})
SET i9.statement = 'If assumptions (E)-(H) hold with suitable constants, then |mu*discreteLaplacian g + 2*mu*ricciTensor g|(p) <= C*mu*M*ell_P^2 where C is dimensional constant',
    i9.statement_v2_form = 'The actual axiom says <= ell_P/2 which is O(ell_P). This is LOOSER than what the math gives (O(ell_P^2)), but relies on mu and M being universal and being chosen so the bound is trivially satisfied at sub-Planck scales.',
    i9.status = 'needs_formalising',
    i9.difficulty = 'routine',
    i9.source = 'Triangle inequality on (A), (G), (H)',
    i9.is_critical_path = true;

// (J) Cleaner V2 rewrite: drop HPW citation entirely, replace with explicit hypothesis-carrying theorem
MERGE (i10:ProofIngredient {namespace:'OmegaTheoryV2', name:'v2_hypothesis_carrying_theorem'})
SET i10.statement = 'theorem laplacian_ricci_convergence (g : DiscreteMetric) (g_cont : R^4 -> MetricTensor) (h_interp : interpolates g g_cont) (h_c4 : C^4 g_cont with bound M) (h_harmonic : harmonicGauge g_cont) (mu : R) (hmu : 0 < mu) (p : LatticePoint) (i j : Fin 4) : |mu * discreteLaplacian (fun q => g q i j) p + 2 * mu * ricciTensor g i j p| <= C*mu*M*l_P^2',
    i10.status = 'needs_formalising',
    i10.difficulty = 'substantial',
    i10.source = 'Proposed restructuring; not in repo yet',
    i10.note = 'This would replace the axiom with a theorem that EXPOSES the hypotheses rather than hiding them behind a "cite HPW" handwave.',
    i10.is_critical_path = false;

// --- 3. Dependency edges ---

MATCH (a:ProofIngredient {namespace:'OmegaTheoryV2', name:'central_diff_second_order_accurate'}),
      (b:ProofIngredient {namespace:'OmegaTheoryV2', name:'partial_secondderiv_second_order_accurate'})
MERGE (b)-[:DEPENDS_ON]->(a);

MATCH (a:ProofIngredient {namespace:'OmegaTheoryV2', name:'lattice_laplacian_separates'}),
      (b:ProofIngredient {namespace:'OmegaTheoryV2', name:'total_truncation_bound'})
MERGE (b)-[:DEPENDS_ON]->(a);

MATCH (a:ProofIngredient {namespace:'OmegaTheoryV2', name:'partial_secondderiv_second_order_accurate'}),
      (b:ProofIngredient {namespace:'OmegaTheoryV2', name:'total_truncation_bound'})
MERGE (b)-[:DEPENDS_ON]->(a);

MATCH (a:ProofIngredient {namespace:'OmegaTheoryV2', name:'smooth_continuum_interpolant_existence'}),
      (b:ProofIngredient {namespace:'OmegaTheoryV2', name:'partial_secondderiv_second_order_accurate'})
MERGE (b)-[:DEPENDS_ON]->(a);

MATCH (a:ProofIngredient {namespace:'OmegaTheoryV2', name:'interpolant_c4_bound'}),
      (b:ProofIngredient {namespace:'OmegaTheoryV2', name:'partial_secondderiv_second_order_accurate'})
MERGE (b)-[:DEPENDS_ON]->(a);

MATCH (a:ProofIngredient {namespace:'OmegaTheoryV2', name:'continuum_ricci_box_identity'}),
      (b:ProofIngredient {namespace:'OmegaTheoryV2', name:'total_truncation_bound'})
MERGE (b)-[:DEPENDS_ON]->(a);

MATCH (a:ProofIngredient {namespace:'OmegaTheoryV2', name:'harmonic_gauge_assumption'}),
      (b:ProofIngredient {namespace:'OmegaTheoryV2', name:'continuum_ricci_box_identity'})
MERGE (b)-[:DEPENDS_ON]->(a);

MATCH (a:ProofIngredient {namespace:'OmegaTheoryV2', name:'total_truncation_bound'}),
      (hpw:Axiom {namespace:'OmegaTheoryV2', name:'hpw_laplacian_ricci_convergence'})
MERGE (a)-[:PROVES]->(hpw);

MATCH (a:ProofIngredient {namespace:'OmegaTheoryV2', name:'v2_hypothesis_carrying_theorem'}),
      (hpw:Axiom {namespace:'OmegaTheoryV2', name:'hpw_laplacian_ricci_convergence'})
MERGE (a)-[:REPLACES]->(hpw);

// --- 4. Strategy flag: is the HPW 2006 proof adaptable? ---
MERGE (strat:Strategy {namespace:'OmegaTheoryV2', name:'hpw_elimination_strategy'})
SET strat.verdict = 'HPW 2006 is NOT the right reference. It concerns 2D polyhedral surfaces in R^3 with Hausdorff/normal mesh convergence, not Z^4 with constant spacing. The correct mathematical content for V2 is a far simpler result: finite-difference truncation error on a regular lattice, combined with the Weinberg harmonic-gauge identity.',
    strat.recommendation = 'Do NOT attempt to formalise HPW 2006. Instead, introduce a smooth continuum metric g_cont, a C^4 interpolation hypothesis, a harmonic-gauge hypothesis, and prove the bound by Taylor. The effort is substantial but not a research programme - it is a modest formalization project.',
    strat.reference_swap = 'Replace "HPW 2006" citation with: "Standard finite-difference truncation-error analysis combined with Weinberg 1972 section 11.1 harmonic-gauge Ricci formula."';

RETURN 'done' AS status;
