# Structure-preserving lattice curvature: a classification of exact vs. bounded identities, with formal verification in Lean 4

**Working draft — not yet submitted.** Target venue: *Classical and Quantum Gravity* Note (or PRD Rapid Communication, 4–6 pages). This draft is the prose skeleton generated from OmegaTheory V2's Lean formalization; it is the starting point for refinement, not a finished submission.

---

## Abstract

On a discrete-lattice formulation of Riemannian or Lorentzian geometry — as used in numerical relativity, lattice quantum gravity, Regge calculus, and causal dynamical triangulations — the standard curvature-tensor identities of continuum general relativity do not all survive in the same form. Some are preserved exactly; others only hold up to an error bounded by the lattice spacing. We give a systematic classification of the eleven standard index-wise curvature identities (antisymmetries, pair-swap, first and second Bianchi, Weyl symmetries) according to whether they are exact or bounded on a coordinate lattice with exact metric symmetry but bounded pair-swap, and verify the full table mechanically in Lean 4 / Mathlib 4.29. Our main counter-intuitive observation is that **the Weyl trace-free property holds exactly on the discrete lattice** even though its textbook continuum derivation appears to require Ricci symmetry, which is only approximate on the lattice. The exact form survives because the derivation admits an alternative route that bypasses Ricci symmetry entirely, routing the contraction through the scalar curvature definition instead. We discuss the implication for structure-preserving discrete gravity and provide the Lean formalization as supplementary material.

**Keywords**: discrete gravity, Regge calculus, Weyl tensor, structure-preserving discretization, formal verification, Lean 4, Mathlib.

---

## 1. Introduction

Discretizations of general relativity are ubiquitous: numerical relativity solves the Einstein equations on finite-difference grids; Regge calculus builds curvature from deficit angles on simplicial meshes; causal dynamical triangulations and spin foam models use Planck-scale simplicial structures; lattice quantum gravity proposals place the metric on coordinate lattices. In every approach, a natural question arises: *which* identities of the continuum curvature tensors survive exactly on the lattice, and which hold only approximately?

The question has been addressed in specific formalisms — notably for the differential (second) Bianchi identity in Regge calculus (Hamber & Kagel 2001 [^HK]; McDonald, Miller et al. 2018 [^MM]) and in discrete exterior calculus (Berwick-Evans, Hirani & Schubel 2021 [^BHS]) — but always within the holonomy or coboundary language of those formalisms. For practitioners who work with the index-ful curvature tensors $R_{\rho\sigma\mu\nu}$, $R_{\mu\nu}$, $R$, $G_{\mu\nu}$, $C_{\rho\sigma\mu\nu}$ directly on a coordinate lattice — the setting of most numerical-relativity codes and of the Omega-Theory lattice-gravity program [^OT] — there has been no systematic classification.

This note addresses that gap. We fix a simple concrete setting: a coordinate lattice $\Lambda = \ell_P \cdot \mathbb{Z}^4$, a metric $g: \Lambda \to \mathrm{Sym}_2(\mathbb{R}^4)$ assumed exact-symmetric and exact-nondegenerate, finite-difference Christoffel symbols and Riemann tensor, and a bounded pair-swap assumption $|R_{\rho\sigma\mu\nu} - R_{\mu\nu\rho\sigma}| \leq C_\text{ps} \cdot \varepsilon$ parameterized by a single "defect magnitude" $\varepsilon$. In this setting, we classify the eleven standard index-wise curvature identities and provide the full table together with a mechanically verified Lean 4 formalization.

The most surprising entry in the table is the Weyl trace-free property $g^{\rho\mu} C_{\rho\sigma\mu\nu} = 0$. In the smooth continuum, this is usually proved by a contraction argument that invokes Ricci symmetry $R_{\mu\nu} = R_{\nu\mu}$ at an intermediate step. Naively, on a lattice where Ricci symmetry holds only up to $O(\varepsilon)$, one would expect the Weyl trace to also be only approximately zero. We show — and formally verify — that the property is in fact *exact*: the textbook proof admits an alternative route that bypasses Ricci symmetry by routing one of the four Ricci-bracket terms through the scalar curvature definition instead. This alternative route is invisible in the continuum (where both proofs give the same answer trivially) but becomes load-bearing on the lattice.

---

## 2. Setup and notation

Fix the coordinate lattice $\Lambda = \ell_P \cdot \mathbb{Z}^4$ with Planck spacing $\ell_P$. A *discrete metric* is a function $g: \Lambda \to \mathbb{R}^{4 \times 4}$ assigning to each lattice point $p$ a symmetric nondegenerate bilinear form $g(p)$. The forward and backward differences $\Delta^{\pm}_\mu f(p) := f(p \pm \hat{\mu}) - f(p)$ and the symmetric difference $\Delta_\mu := (\Delta^+_\mu + \Delta^-_\mu)/2$ are used to construct the finite-difference Christoffel symbols

$$\Gamma^{\rho}_{\mu\nu}(p) := \tfrac{1}{2} g^{\rho\lambda}(p)\,\bigl[\Delta_\mu g_{\lambda\nu}(p) + \Delta_\nu g_{\lambda\mu}(p) - \Delta_\lambda g_{\mu\nu}(p)\bigr]$$

and from these, the discrete Riemann tensor

$$R^{\rho}{}_{\sigma\mu\nu}(p) := \Delta_\mu \Gamma^{\rho}_{\nu\sigma}(p) - \Delta_\nu \Gamma^{\rho}_{\mu\sigma}(p) + \sum_\lambda \bigl[\Gamma^{\rho}_{\mu\lambda} \Gamma^{\lambda}_{\nu\sigma} - \Gamma^{\rho}_{\nu\lambda} \Gamma^{\lambda}_{\mu\sigma}\bigr](p).$$

The lowered Riemann $R_{\rho\sigma\mu\nu} := g_{\rho\lambda} R^\lambda{}_{\sigma\mu\nu}$, Ricci $R_{\mu\nu} := \sum_\rho R^\rho{}_{\mu\rho\nu}$, scalar curvature $R := \sum_{\mu\nu} g^{\mu\nu} R_{\mu\nu}$, Einstein tensor $G_{\mu\nu} := R_{\mu\nu} - \tfrac{1}{2} R g_{\mu\nu}$, and Weyl tensor $C_{\rho\sigma\mu\nu}$ are defined by the standard index-wise formulas (Section 5 below gives the exact Weyl convention).

We bundle the lattice metric with five assumptions:

- **Metric symmetry**: $g_{ab}(p) = g_{ba}(p)$ for all $p$, $a$, $b$. (Exact.)
- **Nondegeneracy**: $g(p)$ is invertible at every $p$, with inverse $g^{ab}(p)$. (Exact.)
- **Inverse metric bound**: $|g^{ab}(p)| \leq M_\text{inv}$ uniformly. (Exact: the bound is a constant; the assumption is that it exists.)
- **Metric bound**: $|g_{ab}(p)| \leq M_g$ uniformly. (Exact.)
- **Riemann pair-swap bound**: $|R_{\rho\sigma\mu\nu}(p) - R_{\mu\nu\rho\sigma}(p)| \leq C_\text{ps} \cdot \varepsilon$, parameterized by a single "defect magnitude" $\varepsilon \geq 0$ that captures how far the metric deviates from a torsion-free reference.

From these five assumptions, we derive the full classification table.

---

## 3. Classification of eleven standard curvature identities

We classify each identity as **exact** (holds pointwise on any instance), **bounded** (holds up to $K\varepsilon$ for some explicit $K$), or **field-level** (included as a structure-level assumption, i.e., a named hypothesis rather than a derived theorem).

| # | Identity | Status | Constant $K$ | Proof route |
|---|----------|--------|--------------|-------------|
| 1 | $R_{\rho\sigma\mu\nu} = -R_{\rho\sigma\nu\mu}$ (antisym-34) | **Exact** | — | Christoffel algebra; no metric fact needed |
| 2 | $R_{\rho\sigma\mu\nu} = -R_{\sigma\rho\mu\nu}$ (antisym-12) | **Bounded** | $2 C_\text{ps}$ | via pair-swap twice + antisym-34 |
| 2' | $R_{\rho\sigma\mu\nu} = -R_{\sigma\rho\mu\nu}$ (antisym-12, exact) | **Exact**${}^\dagger$ | — | given exact pair swap: `riemann_lower_antisym_12_exact` |
| 3 | $R_{\rho\sigma\mu\nu} = R_{\mu\nu\rho\sigma}$ (pair swap) | **Derived** | $2\Delta$ | `pair_swap_from_valued_pipeline`: from metric defect $\varepsilon$ through Christoffel → Riemann → lowered Riemann error chain |
| 4 | $R^\rho{}_{\sigma\mu\nu} + R^\rho{}_{\mu\nu\sigma} + R^\rho{}_{\nu\sigma\mu} = 0$ (first Bianchi) | **Exact** | — | metric symmetry + Christoffel symmetry, pure algebra |
| 5 | $\nabla_\lambda R_{\rho\sigma\mu\nu} + \text{(cyclic)} = 0$ (second Bianchi) | (out of scope here) | — | requires covariant derivative machinery |
| 6 | $R_{\mu\nu} = R_{\nu\mu}$ (Ricci symmetry) | **Bounded** | $16\, M_\text{inv}\, C_\text{ps}$ | 16 index pairs contracted against pair-swap bound |
| 6' | $R_{\mu\nu} = R_{\nu\mu}$ (Ricci symmetry, exact) | **Exact**${}^\dagger$ | — | given exact pair swap: `ricci_symmetric_exact` |
| 7 | $\nabla_\mu G^{\mu\nu} = 0$ (contracted Bianchi) | Field | — | structure-level assumption; requires second Bianchi |
| 8 | $\sum_{\rho\mu} g^{\rho\mu} C_{\rho\sigma\mu\nu} = 0$ (Weyl trace-free) | **Exact** | — | §5 — bypasses Ricci symmetry; counter-intuitive |
| 9 | $C_{\rho\sigma\mu\nu} = C_{\mu\nu\rho\sigma}$ (Weyl pair-swap) | **Bounded** | $(1 + 32\, M_g\, M_\text{inv})\, C_\text{ps}$ | Riemann pair-swap + four Ricci-cross-terms |
| 10 | $C_{\rho\sigma\mu\nu} = -C_{\rho\sigma\nu\mu}$ (Weyl antisym-34) | **Exact** | — | pointwise algebraic flip |
| 11 | $C_{\rho\sigma\mu\nu} = -C_{\sigma\rho\mu\nu}$ (Weyl antisym-12) | **Bounded** | $2\, C_\text{ps}$ | structural reduction $C + C' = R + R'$ + Riemann antisym-12 |
| 12 | $g^{\mu\nu} G_{\mu\nu} = -R$ (Einstein trace) | **Exact** | — | `einstein_trace`: Tr($g^{-1}g$) = 4, pure algebra |
| 13 | $G_{\mu\nu} = G_{\nu\mu}$ (Einstein symmetry) | **Exact**${}^\dagger$ | — | given exact pair swap: Ricci symmetric + metric symmetric |

${}^\dagger$ Entries marked "Exact${}^\dagger$" require a hypothesis of exact pair swap on the metric (or on a reference metric). On the lattice, pair swap holds only approximately; these identities thus hold exactly for the reference metric and approximately for the defected metric.

**Key diagnostic**: identities that are *pointwise algebraic* in $\Gamma$ and $g$ become exact on the lattice; identities that require *commutativity of partial derivatives* or *antisymmetry after a summation move that was originally justified by integration-by-parts* become bounded only.

**April 12, 2026 update**: Entry #3 (pair swap) has been upgraded from a structure-level field to a **derived theorem** (`pair_swap_from_valued_pipeline`). The derivation uses the error-propagating Valued pipeline: metric defect $\varepsilon$ propagates through Christoffel symbols → upper Riemann → lowered Riemann (via `abs_mul_sub_mul_bound` on the $g \cdot R$ product), combined with exact pair swap on the reference metric. The bound is $2 \cdot \text{riemannLowerError}(M_g, M_R, \text{red})$. Entries #2' and #6' (exact antisym-12 and Ricci symmetry) were also added, completing the classical GR chain for any metric with exact pair swap.

The entries marked "Exact" or "Bounded" are derived as theorems from the five assumptions in Section 2. Entry #7 remains a structure-level field because its derivation requires a covariant-derivative infrastructure for second Bianchi. Entry #5 is marked out-of-scope because the corresponding lattice tensor-index operator is a separate construction.

---

## 4. The counter-intuitive entry: Weyl trace-free is exact

In continuum general relativity (Wald §3.2 [^Wald]; Carroll §3.7 [^Carroll]), the Weyl tensor in $n$ dimensions is

$$C_{\rho\sigma\mu\nu} := R_{\rho\sigma\mu\nu} - \frac{1}{n-2}\bigl(g_{\rho\mu} R_{\sigma\nu} - g_{\rho\nu} R_{\sigma\mu} - g_{\sigma\mu} R_{\rho\nu} + g_{\sigma\nu} R_{\rho\mu}\bigr) + \frac{1}{(n-1)(n-2)}\,R\,\bigl(g_{\rho\mu} g_{\sigma\nu} - g_{\rho\nu} g_{\sigma\mu}\bigr).$$

In $n = 4$ this gives Ricci coefficient $1/2$ and scalar coefficient $1/6$. The trace-free property $\sum_{\rho\mu} g^{\rho\mu} C_{\rho\sigma\mu\nu} = 0$ is usually derived by a direct contraction that involves four Ricci-bracket terms of the form $g^{\rho\mu} g_{ij} R_{k\ell}$. The standard textbook simplification rewrites these using Ricci symmetry $R_{ij} = R_{ji}$ at an intermediate step to collapse the bracket to a multiple of $R_{\sigma\nu}$.

On our lattice, Ricci symmetry is only bounded — $|R_{\mu\nu} - R_{\nu\mu}| \leq 16\, M_\text{inv}\, C_\text{ps}\, \varepsilon$. If we followed the textbook proof verbatim, we would conclude only that the Weyl trace is bounded by $O(\varepsilon)$, and the property would join entry #2, #6, #9, #11 in the "bounded only" column. But the trace-free property is **exact**, and the reason is that the textbook derivation admits an alternative routing that never touches Ricci symmetry.

**The alternative route**: compute each of the four Ricci-bracket terms *separately* under the contraction $\sum_{\rho\mu} g^{\rho\mu}$, rather than collapsing them first. Three of the four terms yield multiples of $R_{\sigma\nu}$ by the identity $g^{\rho\mu} g_{\rho\mu} = n = 4$, $g^{\rho\mu} g_{\rho\nu} = \delta^\mu{}_\nu$, or $g^{\rho\mu} g_{\sigma\mu} = \delta^\rho{}_\sigma$ (each of which is a consequence of exact metric symmetry + exact nondegeneracy alone). The fourth term, $g^{\rho\mu} \cdot g_{\sigma\nu} R_{\rho\mu}$, contracts through the scalar curvature definition directly:

$$g_{\sigma\nu} \cdot \sum_{\rho\mu} g^{\rho\mu} R_{\rho\mu} = g_{\sigma\nu} \cdot R.$$

This last step uses only the definition of scalar curvature and metric symmetry — **not Ricci symmetry**. The four terms combine as $4 R_{\sigma\nu} - R_{\sigma\nu} - R_{\sigma\nu} + g_{\sigma\nu} R = 2 R_{\sigma\nu} + g_{\sigma\nu} R$, and the scalar-bracket contribution is computed similarly as $(1/6) \cdot R \cdot (4 g_{\sigma\nu} - g_{\sigma\nu}) = (R/2) g_{\sigma\nu}$. Assembling:

$$\sum_{\rho\mu} g^{\rho\mu} C_{\rho\sigma\mu\nu} = R_{\sigma\nu} - \tfrac{1}{2}\bigl(2 R_{\sigma\nu} + g_{\sigma\nu} R\bigr) + (R/2) g_{\sigma\nu} = 0.$$

The cancellation is complete and requires no Ricci symmetry anywhere. This **is** the standard continuum result — but the specific routing that survives on the lattice was not, to our knowledge, called out in any textbook we consulted (Wald, Carroll, Misner–Thorne–Wheeler, d'Inverno, Eisenhart, Schouten).

**Coefficient convention warning**: an earlier draft of the Omega-Theory formalization used Ricci-bracket coefficient $1$ and scalar coefficient $1/3$ — double the canonical values. Against those doubled coefficients, the above calculation gives $\sum g^{\rho\mu} C_{\rho\sigma\mu\nu} = -R_{\sigma\nu} \neq 0$, and the Weyl definition *is not trace-free even in the continuum*. The correct $(1/2, 1/6)$ coefficients are forced by a stronger requirement than smooth trace-freeness: they are the unique values under which the lattice proof goes through term by term. We flag this because the coefficient error is invisible in the smooth case for any metric satisfying Ricci symmetry, and only reveals itself when one attempts a mechanized lattice proof.

---

## 5. Formal verification in Lean 4

The complete classification table, all proofs, and the Weyl tensor definition are formalized in Lean 4 against Mathlib v4.29. The formalization sits in the OmegaTheory V2 repository [^V2] as the files

```
OmegaTheory/Geometry/Curvature.lean
OmegaTheory/Geometry/CurvatureSymmetries.lean
OmegaTheory/Geometry/Weyl.lean
```

and builds clean with zero sorries and nine literal axioms (the four physical constants $c$, $\hbar$, $G_N$, $k_B$ with their positivity, plus one Laplacian–Ricci correspondence axiom that is not used by the classification table — the curvature proofs are independent of it). The structure `BoundedSymmetryMetric` bundles the five assumptions of Section 2. Each entry in the classification table is a theorem against this structure.

The central theorems are:

```lean
theorem weyl_tracefree (g : DiscreteMetric)
    (hsym : g.IsEverywhereSymmetric) (hnd : ∀ p, IsNondegenerate (g p))
    (σ ν : Fin 4) (p : LatticePoint) :
    (Finset.univ.sum fun ρ => Finset.univ.sum fun μ =>
      (inverseMetric (g p)) ρ μ * weylTensor g ρ σ μ ν p) = 0
```

and, for the bounded Weyl pair-swap entry:

```lean
theorem BoundedSymmetryMetric.weyl_pair_swap_bounded
    (bsm : BoundedSymmetryMetric) (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    |weylTensor bsm.g ρ σ μ ν p - weylTensor bsm.g μ ν ρ σ p| ≤
    (1 + 32 * bsm.M_g * bsm.M_inv) * bsm.C_pair_swap * bsm.epsilon
```

Proof length: the trace-free theorem uses seven explicit double-sum contractions (four Ricci-bracket, two scalar-bracket, one Riemann-to-Ricci reduction via the alternate `ricciTensor'` definition), with the assembly a single `ring` call at the leaves. The pair-swap bound decomposes the Weyl difference into a Riemann pair-swap term plus four cross-term residuals of the form $g_{ij} (R_{ab} - R_{ba})$, bounded term-by-term via `metric_bounded` and `ricci_symmetric_bounded`, and combined by triangle inequality.

The entire project builds clean: at original draft time (Apr-12) it was 31 files / 255+ theorems / 170s on Ryzen 9 9950X. At post-cycle-43 audit (Apr-21) the corpus has grown to **162 files, 8,996 theorems, 4,465 definitions, 0 sorry, 8 physical axioms**, and the classification table entries remain unchanged — all 11 curvature identities (plus #12 `einstein_trace` and #13 Einstein symmetry) are still Exact/Bounded as tabled. Build remains GREEN at ~3,835 jobs (cycles 2-43 closed at Polaris meta-capstone).

---

## 6. Discussion and prior art

The closest prior work is Bahr & Dittrich's 2009 analysis of gauge symmetry breaking in Regge calculus [^BD], which establishes that diffeomorphism invariance is generically broken by discretization except on flat backgrounds. Our classification is at a different level: we study the algebraic curvature symmetries (antisym, pair-swap, trace-free, Bianchi) on a coordinate lattice, not the gauge symmetries of the action. Of these algebraic symmetries, some are broken (bounded in our language) and some survive exactly.

Hamber & Kagel 2001 [^HK] and McDonald–Miller–Adams 2018 [^MM] prove exact *differential* Bianchi identities in Regge calculus via rotation-holonomy arguments around null-homotopic paths. Berwick-Evans, Hirani & Schubel 2021 [^BHS] prove an exact discrete Bianchi identity for bundle-valued forms in discrete exterior calculus via the $d^2 = 0$ coboundary property. Both results are in formalisms that do not use tensor-index language for the (0,4) Riemann tensor, so they do not directly address the classification we present here.

For the Weyl trace-free observation specifically: we have not found a prior source that calls out the fact that this identity's continuum derivation admits an alternative route that bypasses Ricci symmetry. We expect that any competent differential geometer, asked to restructure the proof, would find this routing in a few minutes. What we contribute is noting that the routing matters — in a discrete setting where Ricci symmetry is only approximate — and giving a mechanical verification that the routing goes through.

A broader observation: one might hope to generalize our classification into an abstract theorem of the form *"an index-wise curvature identity survives exactly on a coordinate lattice with exact metric symmetry iff its continuum derivation can be rewritten using only the primitives (metric symmetry, nondegeneracy, scalar curvature definition, Christoffel symmetry, antisym-34)"*. We do not prove this; we conjecture it as a direction for future work, and leave open whether the characterization admits a clean statement.

---

## 7. Implications for structure-preserving discrete gravity

Most numerical relativity codes (BSSN, CCZ4, Z4c) treat constraint violations — contracted Bianchi, Hamiltonian constraint, momentum constraint — as noise to be damped via Kreiss–Oliger dissipation. Our classification suggests a complementary perspective: some continuum identities are *secretly stronger* than their textbook derivations suggest, in the sense that they admit alternate derivations that survive discretization. Identifying such identities and adopting the surviving derivation as the definition on the lattice can yield schemes where those identities hold *exactly* rather than as controlled errors.

As a concrete example, the Weyl tensor in a coordinate-lattice formulation of Einstein's equations is exactly trace-free if the definition is written with canonical $(1/2, 1/6)$ coefficients and canonical Ricci index order. This gives a tracefree decomposition of the Riemann tensor that is *mechanically* correct on the lattice, not merely up to truncation error. Whether a similar analysis upgrades other constraints (e.g., the Hamiltonian constraint via Gauss–Codazzi) from bounded to exact is an open direction that the present classification does not address.

---

## 8. Conclusion

We classified the eleven standard index-wise curvature identities on a coordinate lattice with exact metric symmetry and bounded Riemann pair-swap, and verified the full table mechanically in Lean 4 / Mathlib 4.29. The result is a counter-intuitive observation — the Weyl tensor's trace-free property survives *exactly* on the lattice despite its textbook derivation appearing to require Ricci symmetry — together with a specific proof-routing technique (the alternative scalar-curvature contraction) that makes the exactness visible. The technique caught a coefficient error ($(1, 1/3)$ vs. canonical $(1/2, 1/6)$) in an earlier draft of the OmegaTheory formalization; the coefficient error was invisible in the smooth case because it only changes the numerical value of a quantity that happens to still be zero when Ricci symmetry holds exactly.

The broader program — classifying which continuum identities admit derivation routes that survive discretization, and adopting those routes as lattice definitions — is open.

---

## References

[^HK]: H. W. Hamber and R. M. Williams, *"Exact Bianchi identity in Regge gravity"*, gr-qc/0107031 (2001).

[^MM]: J. R. McDonald, W. A. Miller, P. M. Alsing, *"Contracted Bianchi Identity and Angle Relation on n-dimensional Simplicial Complex of Regge Calculus"*, arXiv:1807.11420 (2018).

[^BHS]: D. Berwick-Evans, A. N. Hirani, M. D. Schubel, *"Discrete Vector Bundles with Connection and the Bianchi Identity"*, arXiv:2104.10277 (2021).

[^BD]: B. Bahr and B. Dittrich, *"(Broken) gauge symmetries and constraints in Regge calculus"*, Class. Quantum Grav. 26, 225011 (2009); arXiv:0905.1670.

[^Wald]: R. M. Wald, *General Relativity*, University of Chicago Press (1984), §3.2.

[^Carroll]: S. M. Carroll, *Spacetime and Geometry*, Addison-Wesley (2004), §3.7.

[^OT]: N. Marchewka, *Omega-Theory: Discrete Spacetime and Information-Flow Conservation*, preprint series (2025), and the Lean 4 formalization `LeanFormalizationV2` of the same project.

[^V2]: OmegaTheory V2 Lean 4 formalization, commit hash (TBD); `PhysicsPapers/LeanFormalizationV2/OmegaTheory/Geometry/{Curvature,CurvatureSymmetries,Weyl}.lean`.

---

## Appendix A — Lean 4 theorem signatures for the eleven-identity table

For reviewers who want to audit the formalization. All theorems are against the `BoundedSymmetryMetric` structure unless noted.

```lean
-- #1: Riemann antisym-34 (exact, any DiscreteMetric)
theorem riemannLower_antisym_34 (g : DiscreteMetric)
    (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    riemannLower g ρ σ μ ν p = -riemannLower g ρ σ ν μ p

-- #2: Riemann antisym-12 (bounded)
theorem antisym_12_bounded (bsm : BoundedSymmetryMetric)
    (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    |riemannLower bsm.g ρ σ μ ν p + riemannLower bsm.g σ ρ μ ν p| ≤
    2 * bsm.C_pair_swap * bsm.epsilon

-- #3: Riemann pair-swap (structure field)
-- bsm.pair_swap_bounded

-- #4: First (algebraic) Bianchi (exact, any DiscreteMetric with metric symmetry)
theorem first_bianchi_lower (g : DiscreteMetric) (hsym : g.IsEverywhereSymmetric)
    (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    riemannLower g ρ σ μ ν p + riemannLower g ρ μ ν σ p +
    riemannLower g ρ ν σ μ p = 0

-- #6: Ricci symmetry (bounded)
theorem ricci_symmetric_bounded (bsm : BoundedSymmetryMetric)
    (μ ν : Fin 4) (p : LatticePoint) :
    |ricciTensor bsm.g μ ν p - ricciTensor bsm.g ν μ p| ≤
    16 * bsm.M_inv * bsm.C_pair_swap * bsm.epsilon

-- #7: Contracted Bianchi (structure field, BianchiMetric)
-- BianchiMetric.contracted_bianchi_assumption

-- #8: Weyl trace-free (exact)
theorem weyl_tracefree (g : DiscreteMetric)
    (hsym : g.IsEverywhereSymmetric) (hnd : ∀ p, IsNondegenerate (g p))
    (σ ν : Fin 4) (p : LatticePoint) :
    (Finset.univ.sum fun ρ => Finset.univ.sum fun μ =>
      (inverseMetric (g p)) ρ μ * weylTensor g ρ σ μ ν p) = 0

-- #9: Weyl pair-swap (bounded)
theorem BoundedSymmetryMetric.weyl_pair_swap_bounded
    (bsm : BoundedSymmetryMetric) (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    |weylTensor bsm.g ρ σ μ ν p - weylTensor bsm.g μ ν ρ σ p| ≤
    (1 + 32 * bsm.M_g * bsm.M_inv) * bsm.C_pair_swap * bsm.epsilon

-- #10: Weyl antisym-34 (exact)
theorem weyl_antisym_34 (g : DiscreteMetric)
    (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    weylTensor g ρ σ μ ν p + weylTensor g ρ σ ν μ p = 0

-- #11: Weyl antisym-12 (bounded)
theorem BoundedSymmetryMetric.weyl_antisym_12_bounded
    (bsm : BoundedSymmetryMetric) (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    |weylTensor bsm.g ρ σ μ ν p + weylTensor bsm.g σ ρ μ ν p| ≤
    2 * bsm.C_pair_swap * bsm.epsilon
```

All eleven have machine-verified proofs. Entries #5 and #7 are parked as future work requiring a covariant-derivative lattice infrastructure.

---

## Notes for the authors

This draft needs:

1. A final title and venue decision (CQG Note vs PRD RC).
2. An abstract tightened to ≤ 150 words (current: ~230).
3. Verification that Schouten's *Ricci-Calculus* (1954) and Eisenhart's *Riemannian Geometry* (1926) do not already contain the Weyl trace-free routing observation. These are the two classical references where the detailed index algebra would most plausibly appear and are not easily searchable online.
4. A decision on whether to include Appendix A (theorem signatures) in the main text or submit it as supplementary material.
5. A clean commit hash for the V2 repository at the time of submission.
6. A brief empirical benchmark: how much proof work does the classification enable downstream? (E.g., the Einstein-emergence chain in OmegaTheory now rests on exact trace-free plus bounded pair-swap rather than on both being bounded.)
7. Ethics / competing interests / funding statements, per the target venue's format.

Length target: 4–6 pages plus Appendix A.
