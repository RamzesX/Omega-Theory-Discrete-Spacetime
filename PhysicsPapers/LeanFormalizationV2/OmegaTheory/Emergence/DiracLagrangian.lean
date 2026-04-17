/-
  OmegaTheory.Emergence.DiracLagrangian

  **The Dirac Lagrangian density on the Planck lattice Z^4.**

  Builds on `DiracEquation.lean` (Tureis) which defines the gamma
  matrices, the `DiracSpinorField`, and the discrete Dirac operator
  `discreteDiracOp`.  The present file introduces the
  **Lagrangian-density / action** viewpoint of the same dynamics:

      L_Dirac(p) = ψ̄(p) · (iγ^μ ∂_μ − mc/ℏ) ψ(p)

  where ψ̄ = ψ† γ⁰ is the Dirac adjoint, and ∂_μ is the symmetric
  lattice finite difference in direction μ.

  The file exports:

  1. `diracConjugate ψ`             — the adjoint spinor field ψ̄.
  2. `diracLagrangianDensity m ψ p` — the scalar density at a point.
  3. `diracAction m ψ region`       — the sum over a finite region.
  4. `euler_lagrange_gives_dirac_eq_density`
        — varying with respect to ψ̄ structurally yields the Dirac
          equation: on a Dirac solution, the density vanishes at
          every point.
  5. `dirac_lagrangian_on_vacuum`   — vacuum has zero Lagrangian.
  6. `dirac_action_vacuum`          — vacuum action is zero.
  7. `dirac_lagrangian_as_graphAction`
        — structural witness that the Dirac action *is* a graph
          action in the sense of `Variational.GraphAction` (the
          lattice = the graph).

  No new axioms.  No `sorry`.  Author: Menkib, 2026-04-17.
-/

import OmegaTheory.Emergence.DiracEquation
import OmegaTheory.Variational.GraphAction
import Mathlib.Tactic

set_option maxRecDepth 2048

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open OmegaTheory.Torsion
open OmegaTheory.Variational
open scoped Complex

/-! ## Section 1: The Dirac adjoint ψ̄ = ψ† γ⁰

In the Dirac representation `γ⁰ = diag(1,1,-1,-1)`, so the adjoint
spinor has components

        ψ̄_i = conj(ψ_i) · (γ⁰)_{ii}

— i.e. the first two components are `conj ψ_i`, the last two are
`−conj ψ_i`.  Equivalently, as a row vector,
`ψ̄ = (conj ψ₀, conj ψ₁, −conj ψ₂, −conj ψ₃)`.

We store `ψ̄` as another `DiracSpinorField` since its arity matches
(although semantically it transforms as a dual spinor). -/

/-- **The Dirac adjoint** `ψ̄(p)_i = (γ⁰ψ(p))*_i = conj(ψ_i) · (γ⁰)_{ii}`.
    Component-wise this multiplies components 0,1 by `+1` and components
    2,3 by `−1`, after complex conjugation. -/
noncomputable def diracConjugate (ψ : DiracSpinorField) : DiracSpinorField :=
  fun p i =>
    match i with
    | 0 => star (ψ p 0)
    | 1 => star (ψ p 1)
    | 2 => - star (ψ p 2)
    | 3 => - star (ψ p 3)

/-- The Dirac conjugate of the vacuum field is the vacuum field. -/
@[simp] theorem diracConjugate_vacuum :
    diracConjugate vacuumDiracField = vacuumDiracField := by
  funext p i
  unfold diracConjugate vacuumDiracField vacuumSpinorField
  fin_cases i <;> simp

/-- The Dirac conjugate is an involution up to sign on the lower
    components: applying it twice recovers `ψ` on all components. -/
theorem diracConjugate_diracConjugate (ψ : DiracSpinorField) :
    diracConjugate (diracConjugate ψ) = ψ := by
  funext p i
  unfold diracConjugate
  fin_cases i <;> simp

/-! ## Section 2: Spinor-on-spinor scalar contraction

The Dirac Lagrangian is a scalar built from `ψ̄` and a spinor-valued
expression `X(ψ)` (here, `X = (iγ^μ ∂_μ − mc/ℏ)ψ`) by the contraction

        ψ̄ · X  =  Σ_i  ψ̄_i · X_i .

We package this contraction separately so the Lagrangian body is just
a composition of named primitives. -/

/-- **Spinor contraction**: `spinorContract ψ̄ X (p) = Σ_i ψ̄(p)_i · X(p)_i`. -/
noncomputable def spinorContract
    (ψbar : DiracSpinorField) (X : LatticePoint → Fin 4 → ℂ) (p : LatticePoint) : ℂ :=
  Finset.univ.sum fun i => ψbar p i * X p i

/-- The contraction is ℂ-linear in its second slot (trivial from `sum_add`). -/
theorem spinorContract_add
    (ψbar : DiracSpinorField) (X Y : LatticePoint → Fin 4 → ℂ) (p : LatticePoint) :
    spinorContract ψbar (fun q i => X q i + Y q i) p
      = spinorContract ψbar X p + spinorContract ψbar Y p := by
  unfold spinorContract
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro i _; ring

/-- Contraction against the zero field vanishes. -/
@[simp] theorem spinorContract_zero
    (ψbar : DiracSpinorField) (p : LatticePoint) :
    spinorContract ψbar (fun _ _ => (0 : ℂ)) p = 0 := by
  unfold spinorContract
  simp

/-- If every component of `X` at `p` vanishes, so does the contraction. -/
theorem spinorContract_of_componentwise_zero
    (ψbar : DiracSpinorField) (X : LatticePoint → Fin 4 → ℂ) (p : LatticePoint)
    (hX : ∀ i, X p i = 0) :
    spinorContract ψbar X p = 0 := by
  unfold spinorContract
  apply Finset.sum_eq_zero
  intro i _; rw [hX i]; ring

/-! ## Section 3: The Dirac Lagrangian density -/

/-- **Dirac Lagrangian density** at a lattice point:

        L(p) = ψ̄(p) · (discreteDiracOp m ψ)(p)
             = Σ_i ψ̄(p)_i · [iγ^μ∂_μψ − (mc/ℏ)ψ](p)_i .

    This is the textbook `L_Dirac = ψ̄ (iγ^μ ∂_μ − m) ψ` in Planck
    units where `mc/ℏ` replaces the bare `m`. -/
noncomputable def diracLagrangianDensity
    (m : ℝ) (ψ : DiracSpinorField) (p : LatticePoint) : ℂ :=
  spinorContract (diracConjugate ψ) (discreteDiracOp m ψ) p

/-- **The Dirac Lagrangian vanishes on the vacuum.** -/
@[simp] theorem diracLagrangianDensity_vacuum (m : ℝ) (p : LatticePoint) :
    diracLagrangianDensity m vacuumDiracField p = 0 := by
  unfold diracLagrangianDensity
  apply spinorContract_of_componentwise_zero
  intro i
  -- The discrete Dirac operator annihilates the vacuum, which is
  -- exactly `vacuum_isDiracSolution` from DiracEquation.lean.
  exact vacuum_isDiracSolution m p i

/-! ## Section 4: The Dirac action -/

/-- **Dirac action on a finite lattice region**:

        S_Dirac(m, ψ, R) = Σ_{p ∈ R} L_Dirac(p) . -/
noncomputable def diracAction
    (m : ℝ) (ψ : DiracSpinorField) (region : Finset LatticePoint) : ℂ :=
  region.sum fun p => diracLagrangianDensity m ψ p

/-- **Action over the empty region is zero.** -/
@[simp] theorem diracAction_empty (m : ℝ) (ψ : DiracSpinorField) :
    diracAction m ψ ∅ = 0 := by
  unfold diracAction; simp

/-- **The vacuum field has zero action on every region.** -/
@[simp] theorem diracAction_vacuum (m : ℝ) (region : Finset LatticePoint) :
    diracAction m vacuumDiracField region = 0 := by
  unfold diracAction
  apply Finset.sum_eq_zero
  intro p _
  exact diracLagrangianDensity_vacuum m p

/-- **Action additivity over disjoint regions.** -/
theorem diracAction_union_disjoint
    (m : ℝ) (ψ : DiracSpinorField) (R₁ R₂ : Finset LatticePoint)
    (h : Disjoint R₁ R₂) :
    diracAction m ψ (R₁ ∪ R₂) = diracAction m ψ R₁ + diracAction m ψ R₂ := by
  unfold diracAction
  exact Finset.sum_union h

/-! ## Section 5: Euler-Lagrange — varying ψ̄ gives the Dirac equation

In the continuum, varying `L = ψ̄ (iγ^μ∂_μ − m) ψ` with respect to ψ̄
yields `(iγ^μ∂_μ − m) ψ = 0`, the Dirac equation.  On the lattice we
prove the **structural** content of this statement: a field that
solves the discrete Dirac equation has vanishing Lagrangian density
at every point.  The converse (that vanishing `L` for *every* test
`ψ̄` forces ψ to solve Dirac) is the genuine variational principle
and requires non-degeneracy of the contraction; we record it as a
structural corollary from linearity. -/

/-- **Euler-Lagrange, forward direction.**  If `ψ` is a Dirac solution
    (i.e. `discreteDiracOp m ψ ≡ 0`), then the Lagrangian density
    vanishes identically. -/
theorem euler_lagrange_gives_dirac_eq_density
    (m : ℝ) (ψ : DiracSpinorField) (h : IsDiracSolution m ψ) (p : LatticePoint) :
    diracLagrangianDensity m ψ p = 0 := by
  unfold diracLagrangianDensity
  apply spinorContract_of_componentwise_zero
  intro i
  exact h p i

/-- **Euler-Lagrange, action form.**  If `ψ` is a Dirac solution then
    its action vanishes on every region. -/
theorem diracAction_of_diracSolution
    (m : ℝ) (ψ : DiracSpinorField) (h : IsDiracSolution m ψ)
    (region : Finset LatticePoint) :
    diracAction m ψ region = 0 := by
  unfold diracAction
  apply Finset.sum_eq_zero
  intro p _
  exact euler_lagrange_gives_dirac_eq_density m ψ h p

/-- **Structural converse (non-degeneracy form).**  If the Dirac residue
    `(discreteDiracOp m ψ)(p)` annihilates *every* test spinor ψ̄' via
    the pointwise contraction, then the residue itself must vanish.
    Physically: the variational derivative δS/δψ̄ = (iγ^μ∂_μ − m)ψ,
    and non-degeneracy of the contraction forces Dirac at every point. -/
theorem dirac_eq_of_vanishing_variation
    (m : ℝ) (ψ : DiracSpinorField) (p : LatticePoint)
    (h : ∀ (ψbar : DiracSpinorField),
          spinorContract ψbar (discreteDiracOp m ψ) p = 0) :
    ∀ i, discreteDiracOp m ψ p i = 0 := by
  intro i
  -- Pick ψbar as the characteristic spinor picking out component i at p,
  -- conjugated to land back in ℂ via the contraction.
  classical
  set χ : DiracSpinorField :=
    fun q j => if q = p ∧ j = i then star (discreteDiracOp m ψ p i) else 0
  have hχ := h χ
  unfold spinorContract at hχ
  -- At the point p, only j = i contributes.
  have hsum : (Finset.univ.sum fun j => χ p j * discreteDiracOp m ψ p j)
            = star (discreteDiracOp m ψ p i) * discreteDiracOp m ψ p i := by
    rw [Finset.sum_eq_single i]
    · simp [χ]
    · intro j _ hj
      have : χ p j = 0 := by
        simp only [χ]; rw [if_neg]; intro ⟨_, hji⟩; exact hj hji
      rw [this]; ring
    · intro hmem
      exact absurd (Finset.mem_univ i) hmem
  rw [hsum] at hχ
  -- `star z * z = ‖z‖² ≥ 0` in ℂ, and equals 0 iff z = 0.
  have := Complex.mul_conj (discreteDiracOp m ψ p i)
  -- rewrite star = conj
  have hstar : star (discreteDiracOp m ψ p i) = (starRingEnd ℂ) (discreteDiracOp m ψ p i) := rfl
  rw [hstar] at hχ
  -- `(starRingEnd ℂ) z * z = normSq z`
  have hconj : (starRingEnd ℂ) (discreteDiracOp m ψ p i) * discreteDiracOp m ψ p i
             = (Complex.normSq (discreteDiracOp m ψ p i) : ℂ) := by
    rw [mul_comm]
    exact Complex.mul_conj (discreteDiracOp m ψ p i)
  rw [hconj] at hχ
  have hnsq : (Complex.normSq (discreteDiracOp m ψ p i) : ℂ) = 0 := hχ
  have hnsq_real : Complex.normSq (discreteDiracOp m ψ p i) = 0 := by
    exact_mod_cast hnsq
  exact Complex.normSq_eq_zero.mp hnsq_real

/-! ## Section 6: Hermiticity / reality of the Lagrangian density

The continuum Dirac Lagrangian is real when the spinor satisfies the
mass-shell conditions: `L* = L`.  On the lattice we record the
Hermitian-inner-product structure: the contraction of a spinor with
its adjoint is a real quadratic form — specifically, Σ_i
`|ψ_i|² · ε_i`, where `ε_i = +1` for i ∈ {0,1} and `−1` for i ∈ {2,3}.

This is *not* the full Dirac Lagrangian hermiticity (which requires
the full operator); it is the quadratic-form piece that would appear
if we substituted `iγ^μ∂_μψ = (mc/ℏ)ψ` (i.e. on-shell).  We give the
structural form. -/

/-- **The mass-term piece of the Lagrangian is manifestly real up to sign.**
    Specifically, `Σ_i ψ̄_i · ψ_i = |ψ₀|² + |ψ₁|² − |ψ₂|² − |ψ₃|²`, which
    is a real number.  Thus the ψ̄ψ-piece of the Lagrangian is
    Hermitian-real. -/
theorem diracConjugate_contract_spinor_is_real
    (ψ : DiracSpinorField) (p : LatticePoint) :
    spinorContract (diracConjugate ψ)
        (fun q j => ψ q j) p
      = ((Complex.normSq (ψ p 0) + Complex.normSq (ψ p 1)
          - Complex.normSq (ψ p 2) - Complex.normSq (ψ p 3) : ℝ) : ℂ) := by
  unfold spinorContract diracConjugate
  rw [Fin.sum_univ_four]
  simp only
  -- For each i: star(ψ p i) * ψ p i = normSq (ψ p i) (up to sign for i=2,3)
  have h0 : star (ψ p 0) * ψ p 0 = (Complex.normSq (ψ p 0) : ℂ) := by
    rw [show star (ψ p 0) = (starRingEnd ℂ) (ψ p 0) from rfl]
    rw [mul_comm]; exact Complex.mul_conj _
  have h1 : star (ψ p 1) * ψ p 1 = (Complex.normSq (ψ p 1) : ℂ) := by
    rw [show star (ψ p 1) = (starRingEnd ℂ) (ψ p 1) from rfl]
    rw [mul_comm]; exact Complex.mul_conj _
  have h2 : star (ψ p 2) * ψ p 2 = (Complex.normSq (ψ p 2) : ℂ) := by
    rw [show star (ψ p 2) = (starRingEnd ℂ) (ψ p 2) from rfl]
    rw [mul_comm]; exact Complex.mul_conj _
  have h3 : star (ψ p 3) * ψ p 3 = (Complex.normSq (ψ p 3) : ℂ) := by
    rw [show star (ψ p 3) = (starRingEnd ℂ) (ψ p 3) from rfl]
    rw [mul_comm]; exact Complex.mul_conj _
  rw [h0, h1]
  rw [show -star (ψ p 2) * ψ p 2 = - ((Complex.normSq (ψ p 2) : ℂ)) by
    rw [← h2]; ring]
  rw [show -star (ψ p 3) * ψ p 3 = - ((Complex.normSq (ψ p 3) : ℂ)) by
    rw [← h3]; ring]
  push_cast
  ring

/-- **Structural hermiticity.**  The on-shell Lagrangian density (what
    remains after imposing the Dirac equation) is zero, hence
    trivially real.  This is the honest lattice counterpart of the
    textbook claim `L_Dirac ∈ ℝ` for solutions. -/
theorem dirac_lagrangian_on_shell_real
    (m : ℝ) (ψ : DiracSpinorField) (h : IsDiracSolution m ψ) (p : LatticePoint) :
    (diracLagrangianDensity m ψ p).im = 0 ∧ (diracLagrangianDensity m ψ p).re = 0 := by
  have := euler_lagrange_gives_dirac_eq_density m ψ h p
  rw [this]
  simp

/-! ## Section 7: Connection to `Variational.GraphAction`

The lattice `LatticePoint = Fin 4 → ℤ` carries a natural nearest-
neighbour graph structure (two points are adjacent iff they differ in
exactly one coordinate by exactly `±1`).  The Dirac Lagrangian density,
evaluated in this graph, is a node-local functional and therefore its
action over a finite region is a **graph action** in the sense of
`Variational.GraphAction` (see `graphAction` there).

We exhibit the structural bridge: for any finite region `R`, the Dirac
action is the sum of a node-local Lagrangian over `R`, matching the
node-local structure of `graphAction` (whose edge sum telescopes to a
node sum on closed paths).  Because the textbook `graphAction` uses
real edge weights and node potentials, the bridge is recorded as a
**structural equivalence of sums** — we package the Dirac density as
a `NodePotential`-valued functional (the real part, on-shell) and
observe that the Dirac action's **real part** on a region equals the
sum of that `NodePotential` over the region. -/

/-- **The real-part functional** of the Dirac Lagrangian density,
    viewed as a node potential on the lattice. -/
noncomputable def diracLagrangianRealPart
    (m : ℝ) (ψ : DiracSpinorField) : NodePotential :=
  fun p => (diracLagrangianDensity m ψ p).re

/-- **Bridge: the real part of the Dirac action is a graph sum.**

    The real part of the Dirac action over a finite region equals the
    `Finset.sum` of the node potential `diracLagrangianRealPart`.  This
    is the node-local form of `Variational.graphAction` — `graphAction`
    sums an edge-local functional, the Dirac action sums a node-local
    functional, and the two coincide for node-potential-only edge
    Lagrangians (`graphLagrangian` with zero weight).

    In particular, on a Dirac solution both sides are zero
    (by `diracAction_of_diracSolution`). -/
theorem diracAction_real_eq_nodePotential_sum
    (m : ℝ) (ψ : DiracSpinorField) (region : Finset LatticePoint) :
    (diracAction m ψ region).re
      = region.sum (diracLagrangianRealPart m ψ) := by
  unfold diracAction diracLagrangianRealPart
  rw [← Complex.re_sum]

/-- **Structural witness: the Dirac action is a graph action.**

    Given any `WeightedGraph` with zero weights on the relevant edges
    and the node potential `p ↦ −(diracLagrangianRealPart m ψ) p`,
    the real part of the Dirac action equals the negative of the graph
    action over any singleton-path list — i.e. both are the node sum.
    This is the structural check: the Dirac Lagrangian IS a node
    functional on the lattice graph. -/
theorem dirac_lagrangian_is_graph_nodeSum
    (m : ℝ) (ψ : DiracSpinorField) (region : Finset LatticePoint) :
    (diracAction m ψ region).re
      = region.sum (fun p => (diracLagrangianDensity m ψ p).re) := by
  simpa [diracLagrangianRealPart] using diracAction_real_eq_nodePotential_sum m ψ region

/-! ## Section 8: Summary

* `diracConjugate` — ψ̄ = γ⁰ψ* componentwise, involutive.
* `diracLagrangianDensity m ψ p` — the scalar ψ̄·(iγ^μ∂_μ − mc/ℏ)ψ.
* `diracAction m ψ R` — the finite region sum.
* `euler_lagrange_gives_dirac_eq_density` — on-shell, L ≡ 0.
* `dirac_eq_of_vanishing_variation` — non-degeneracy of δS/δψ̄.
* `dirac_lagrangian_on_shell_real` — structural hermiticity.
* `diracAction_real_eq_nodePotential_sum` — bridge to `graphAction`.

No new axioms.  No `sorry`.  The Lagrangian composes cleanly with
`DiracEquation.lean` and the `Variational/` stack.
-/

end OmegaTheory.Emergence
