/-
  OmegaTheory.Axioms.SpacetimePostulates

  Explicit, named, auditable physical postulates for Omega Theory.

  ## Purpose

  V2's technical formalization has several hidden assumptions buried
  inside structure fields (e.g. `BoundedSymmetryMetric.pair_swap_bounded`,
  `BianchiMetric.contracted_bianchi_assumption`, `SemiSmoothMetric.defect_bounded`,
  `IsHealingEquilibrium.balance`). These are mathematically honest — they
  are stated hypotheses, not proven theorems — but they are scattered
  across multiple files and hard for a reviewer to find in one place.

  This file collects the physical postulates underlying Omega Theory into
  one reviewable location with named references, ported from V1's
  `Axioms/Spacetime.lean` (596 lines → ~200 lines). A reviewer wanting
  to understand "what does Omega Theory actually assume about physical
  spacetime?" can read THIS file and be done.

  ## Structure

  The postulates fall into six groups:

  **M1** Foundational: Physical spacetime IS the Planck lattice `ℓ_P · ℤ⁴`.
  **M2** Metric: Discrete metric is symmetric, nondegenerate, Lorentzian.
  **M3** Curvature: Discrete Riemann satisfies antisym-34 and first Bianchi.
  **M4** Coordinate symmetry: Second-difference commutativity in smooth regions.
  **M5** Semi-smoothness: Defects exist but are bounded and sparse.
  **M6** Continuum emergence: The discrete-to-continuum limit exists.

  Each postulate is either:
  - A structural choice (definition / type) — already in V2, here as alias
  - A physical axiom (`True`-typed) — for auditability; no mathematical content
  - A hypothesis on a metric class — already encoded in V2 structures

  Nothing in this file changes V2's theorem content; it just makes the
  assumption inventory visible.

  ## Audit trail

  Every `axiom` below is marked with its V2 consumption site (which
  theorem or structure actually USES this postulate) and, where applicable,
  the corresponding paper citation (e.g., "Main Paper §2", "Appendix D §2").
  A reviewer can follow the chain from postulate to theorem to assess
  rigor at a glance.
-/

import OmegaTheory.Spacetime.Constants
import OmegaTheory.Spacetime.Lattice
import OmegaTheory.Spacetime.Operators
import OmegaTheory.Geometry.Metric
import OmegaTheory.Geometry.Curvature
import OmegaTheory.Defects.DefectTensor

namespace OmegaTheory.Axioms

open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Defects

/-! ## M1 — Foundational: Spacetime is the Planck Lattice

**Physical postulate**: Physical spacetime at the Planck scale IS the lattice
`Λ = ℓ_P · ℤ⁴`, not a continuous manifold.

**Structure**: In V2, this is the type `LatticePoint := Fin 4 → ℤ` from
`OmegaTheory.Spacetime.Lattice`. No axiom is needed — it's a definition.

**Falsifiable prediction**: Any experiment showing physical processes
occurring at length scales smaller than `ℓ_P` would falsify this postulate.

**Consumption**: Every V2 file that uses `LatticePoint`. -/

/-- Alias for physical spacetime points: in Omega Theory, a physical
    spacetime event IS a lattice point. This type alias makes the
    identification explicit. -/
abbrev PhysicalSpacetimePoint := LatticePoint

/-- The physical spacetime lattice `Λ = ℓ_P · ℤ⁴`. Alias for `LatticePoint`. -/
def PhysicalSpacetime := LatticePoint

/-- **M1 postulate**: spacetime is discrete at the Planck scale. Stated
    as a `True`-typed physical axiom for auditability. The mathematical
    content is carried by the type `LatticePoint`. -/
axiom m1_spacetime_discrete : True

/-! ## M2 — Metric: Symmetric, Nondegenerate, Lorentzian

**Physical postulate**: The discrete metric `g : LatticePoint → Matrix (Fin 4)
(Fin 4) ℝ` is symmetric, nondegenerate, and has Lorentzian signature at
every lattice point.

**Structure**: In V2, this is the predicate `DiscreteMetric.IsEverywhereLorentzian`
in `OmegaTheory.Geometry.Metric`, which unfolds to `IsSymmetric` + `IsNondegenerate`
+ `det < 0` at every point.

**Consumption**:
- `BoundedSymmetryMetric.symmetric` (structure field)
- `BoundedSymmetryMetric.nondegenerate` (structure field)
- `SemiSmoothMetric.lorentzian` (structure field) -/

/-- M2a: the metric is symmetric everywhere. Physical postulate, expressed
    in V2 as a hypothesis on specific metric instances. -/
axiom m2a_metric_symmetric
    (g : DiscreteMetric) (h : g.IsEverywhereSymmetric) : True

/-- M2b: the metric is nondegenerate everywhere. Physical postulate. -/
axiom m2b_metric_nondegenerate
    (g : DiscreteMetric) (h : ∀ p, IsNondegenerate (g p)) : True

/-- M2c: the metric has Lorentzian signature (`det < 0`) everywhere.
    Physical postulate. -/
axiom m2c_metric_lorentzian
    (g : DiscreteMetric) (h : g.IsEverywhereLorentzian) : True

/-! ## M3 — Curvature: Antisymmetries and First Bianchi

**Mathematical postulate**: The discrete Riemann tensor satisfies the
classical antisymmetry identities.

**Structure**: In V2, these are *theorems* proven in
`OmegaTheory.Geometry.Curvature`:
- `riemann_antisym_34`: R^ρ_{σμν} = -R^ρ_{σνμ}
- `riemannLower_antisym_34`: R_{ρσμν} = -R_{ρσνμ}
- `first_bianchi`: Σ (cyclic in 234) R^ρ_{σμν} = 0

So M3 is NOT an axiom in V2 — it is a consequence of the definition of
the Christoffel symbols and the structure of the discrete Laplacian.
This is a RIGOROUS theorem chain, not a postulate. -/

/-- M3 statement: the discrete Riemann tensor satisfies antisym-34.
    THIS IS PROVEN in `OmegaTheory.Geometry.Curvature.riemann_antisym_34`
    — included here as a cross-reference for the audit trail. -/
theorem m3_riemann_antisym_34 (g : DiscreteMetric) (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    riemannTensor g ρ σ μ ν p = -riemannTensor g ρ σ ν μ p :=
  riemann_antisym_34 g ρ σ μ ν p

/-! ## M4 — Coordinate Symmetry: Second-Difference Commutativity

**Mathematical postulate**: In *smooth* regions (no defects), second-order
symmetric differences commute: `Δ_μ Δ_ν f = Δ_ν Δ_μ f`.

**Structure**: In V2, this holds identically for any scalar field because
the symmetric difference `Δ_μ := (shift μ⁺ - shift μ⁻)/2` is a commutative
linear operator on lattice-indexed functions. It is NOT an axiom.

In defect regions, the forward and backward differences diverge, and
second-difference commutativity FAILS. This is precisely the "emergent
torsion" phenomenon formalized in `OmegaTheory.Torsion.Torsion` and
Appendix P. -/

/-- M4 structural fact: in smooth regions, symmetric differences commute.
    NOT an axiom in V2 — it's built into the lattice field definition.
    This statement is cosmetic; the actual mathematical content lives in
    `Spacetime.Operators`. -/
axiom m4_derivative_commutativity_smooth_regions : True

/-! ## M5 — Semi-Smoothness: Bounded Sparse Defects

**Physical postulate**: The actual (computed) discrete metric differs
from its ideal (infinite-precision) form by a defect tensor whose
Frobenius norm is bounded by a small `ε > 0` pointwise:

    `|g_actual(p) - g_exact(p)| ≤ ε`

**Structure**: In V2, this is `SemiSmoothMetric.defect_bounded` in
`OmegaTheory.Defects.DefectTensor`. It is a structure FIELD
(unproven hypothesis on a metric pair), not a theorem.

**Consumption**:
- `BoundedSymmetryMetric` (extends `SemiSmoothMetric`)
- All curvature-symmetry bounds
- `einstein_with_matter_emergence`

**Non-vacuity**: See `OmegaTheory.Geometry.Examples.flatBSM` for a concrete
(albeit trivial) witness. -/

/-- M5 statement: a semi-smooth metric has bounded pointwise defects.
    Stated as a hypothesis on a pair of metrics; the content lives in
    the V2 structure `SemiSmoothMetric.defect_bounded`. -/
axiom m5_defect_bounded
    (g g_exact : DiscreteMetric) (ε : ℝ) (hε : 0 < ε)
    (h : ∀ p, defectMagnitude g g_exact p ≤ ε) : True

/-! ## M6 — Continuum Emergence

**Physical postulate**: Smooth Riemannian/Lorentzian geometry emerges from
the discrete lattice at length scales `L ≫ ℓ_P`.

**Structure**: In V2, this is operationalized via two split axioms in
`OmegaTheory.Emergence.LaplacianRicci`:
- `hpw_discrete_laplacian_convergence`: HPW (2006) O(ℓ_P²) convergence
  of the graph Laplacian to the Laplace-Beltrami operator.
- `harmonic_gauge_box_eq_ricci`: the standard harmonic-gauge identity
  `□g_{μν} = -2 R_{μν} + Γ·Γ` from classical GR.

The combined statement (old monolithic `laplacian_ricci_correspondence`)
is now a *derived theorem* in `LaplacianRicci.lean`.

**Consumption**: `einstein_with_matter_emergence` in
`OmegaTheory.Emergence.EinsteinEmergence`.

**External validation**: Hildebrandt-Polthier-Wardetzky (2006),
Geometriae Dedicata 123, 89-112. -/

/-- M6 statement: the discrete-to-continuum limit exists in the HPW +
    harmonic-gauge sense. Stated as a `True`-typed axiom pointing at
    the two operational split axioms in `Emergence.LaplacianRicci`. -/
axiom m6_continuum_emergence : True

/-! ## Summary Table

| # | Name | Type | V2 location | Consumers |
|---|------|------|-------------|-----------|
| M1 | `m1_spacetime_discrete` | `True`-typed cosmetic | `Spacetime.Lattice.LatticePoint` | All |
| M2a | `m2a_metric_symmetric` | hypothesis | `BoundedSymmetryMetric.symmetric` | Curvature symmetries |
| M2b | `m2b_metric_nondegenerate` | hypothesis | `BoundedSymmetryMetric.nondegenerate` | Ricci sym bound |
| M2c | `m2c_metric_lorentzian` | hypothesis | `SemiSmoothMetric.lorentzian` | Einstein emergence |
| M3 | `m3_riemann_antisym_34` | **proven theorem** | `Curvature.riemann_antisym_34` | Weyl, Bianchi |
| M4 | `m4_derivative_commutativity_smooth_regions` | `True`-typed cosmetic | `Spacetime.Operators` | Emergent torsion |
| M5 | `m5_defect_bounded` | hypothesis | `SemiSmoothMetric.defect_bounded` | All bounded cascades |
| M6 | `m6_continuum_emergence` | pointer to split axioms | `Emergence.LaplacianRicci` | Einstein emergence |

**Key honesty point**: Only M3 is a proven theorem in V2. M1 and M4 are
structural (carried by type definitions). M2a/b/c and M5 are hypotheses
on specific metric classes — the reviewer should trace each consuming
theorem to understand what specific metric it applies to. M6 is the
single genuine physical axiom of the project, now split into two
operational pieces.

**Axiom count audit**:
- `Spacetime.Constants`: 4 positivity axioms for `c`, `ℏ`, `G_N`, `k_B`
- `Emergence.LaplacianRicci`: 2 split axioms (HPW + harmonic gauge) +
  1 `continuumBoxG` existence axiom
- `Axioms.SpacetimePostulates` (this file): 6 auditability axioms (M1,
  M2a, M2b, M2c, M4, M5, M6), all either `True`-typed or hypothesis-carrying
  — zero mathematical content, pure audit trail
- `Conservation.SpinInformation`: 1 trivial `True`-typed axiom
  (`torsion_info_correspondence`)

Total declared axioms: 14, of which 7 (M1-M6 + `torsion_info_correspondence`)
are `True`-typed cosmetic markers, 4 are physical constants, and 3 carry
genuine mathematical content (the two HPW splits + `continuumBoxG`).
-/

end OmegaTheory.Axioms
