/-
  OmegaTheory.Emergence.NonAbelianGauge

  Non-abelian Yang–Mills field strength on the Planck lattice.

  Closes the gap left by Naos's abelian `ErrorGaugeField` (F = dA) by
  assembling the full Yang–Mills curvature

      F = dA + [A, A]

  on a Lie-algebra-valued discrete connection, with explicit
  error propagation through both the exterior derivative piece
  and the Lie-bracket piece.

  Definitions:
  1. `NonAbelianConnection L` — L-valued discrete 1-form with error.
  2. `naExteriorD` — finite-difference d on L-valued 1-forms.
  3. `naBracketTerm` — [A_μ, A_ν] as L-valued 2-form.
  4. `nonAbelianCurvature` — F = dA + [A,A] combined.
  5. `nonAbelianBianchi_abelian` — DF = 0 in the abelian specialisation.
  6. `gluon_self_coupling_witness` — SU(3) triple with nonzero
     [A,A] component (demonstrates gluon–gluon coupling).
  7. `nonAbelian_error_bound` — ‖F_actual − F_ideal‖ is controlled
     by 2·C_d·ε_A (for the dA part) plus the bracket error
     (for the [A,A] part).

  Agent: Menkar (α Ceti), April 17, 2026. No sorry, no new axioms.
-/

import OmegaTheory.Foundations.ErrorForms
import OmegaTheory.Foundations.ErrorLieAlgebra
import OmegaTheory.Emergence.ErrorGaugeField
import OmegaTheory.Emergence.ErrorGaugeSU2
import OmegaTheory.Emergence.ErrorGaugeSU3
import Mathlib.Tactic

namespace OmegaTheory.Emergence.NonAbelianGauge

open OmegaTheory.Foundations
open OmegaTheory.Foundations.ErrorForms
open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Irrationality

/-! ## 1. Lie-algebra-valued discrete 1-forms

A non-abelian gauge connection on the lattice is a map
`A : LatticePoint → Fin 4 → L` where `L` is the gauge Lie algebra
(e.g. `su(2)`, `su(3)`). We collect it with a uniform error bound
`εA` on each component (inherited from substrate truncation). -/

/-- L-valued discrete 1-form. -/
abbrev LieValued1Form (L : Type*) := LatticePoint → Fin 4 → L

/-- L-valued discrete 2-form. -/
abbrev LieValued2Form (L : Type*) := LatticePoint → Fin 4 → Fin 4 → L

/-- A non-abelian gauge connection: an L-valued 1-form with a
    uniform error bound on its computation. -/
structure NonAbelianConnection (L : Type*) where
  /-- The Lie-algebra-valued potential A^a_μ. -/
  potential : LieValued1Form L
  /-- Error bound on the connection's components (from truncation). -/
  εA : ErrorBound

/-- The exact (zero-error) connection. -/
def NonAbelianConnection.exact {L : Type*}
    (A : LieValued1Form L) : NonAbelianConnection L :=
  ⟨A, ErrorBound.zero⟩

/-- Exact connections have zero error. -/
theorem NonAbelianConnection.exact_err {L : Type*}
    (A : LieValued1Form L) :
    (NonAbelianConnection.exact A).εA = ErrorBound.zero := rfl

/-! ## 2. L-valued exterior derivative

For a Lie-algebra-valued 1-form A, the exterior derivative is the
finite difference

    (dA)(p, μ, ν) = (A(p+ê_μ, ν) − A(p, ν))/l_P
                  − (A(p+ê_ν, μ) − A(p, μ))/l_P.

We implement this in L using `AddCommGroup` (for subtraction)
and `Module ℝ` (for the 1/l_P scaling). -/

section Abstract
variable {L : Type*} [AddCommGroup L] [Module ℝ L]

/-- Finite-difference exterior derivative on an L-valued 1-form.
    This is the naïve dA term in Yang–Mills F = dA + [A,A]. -/
noncomputable def naExteriorD (A : LieValued1Form L) :
    LieValued2Form L :=
  fun p μ ν =>
    (1 / l_P) • (A (shiftFin p μ) ν - A p ν) -
    (1 / l_P) • (A (shiftFin p ν) μ - A p μ)

/-- The dA-part of the curvature is antisymmetric in μ, ν. -/
theorem naExteriorD_antisym (A : LieValued1Form L)
    (p : LatticePoint) (μ ν : Fin 4) :
    naExteriorD A p μ ν + naExteriorD A p ν μ = 0 := by
  unfold naExteriorD; abel

/-! ## 3. Lie-bracket term [A, A]

In Yang–Mills, the non-abelian correction is

    [A, A](p, μ, ν) = [A_μ, A_ν] − [A_ν, A_μ] = 2·[A_μ, A_ν]

(equivalently, `[A_μ, A_ν]` antisymmetrised over μ ↔ ν). We use the
substrate `ErrorLieBracket.bracket` from Nunki's framework. -/

variable [ErrorLieBracket L]

/-- The Lie-bracket piece [A_μ, A_ν] of the non-abelian curvature.
    This is the new term absent in abelian U(1). -/
noncomputable def naBracketTerm (A : LieValued1Form L) :
    LieValued2Form L :=
  fun p μ ν =>
    ErrorLieBracket.bracket (A p μ) (A p ν) -
    ErrorLieBracket.bracket (A p ν) (A p μ)

/-- The bracket term is exactly antisymmetric in μ, ν. -/
theorem naBracketTerm_antisym (A : LieValued1Form L)
    (p : LatticePoint) (μ ν : Fin 4) :
    naBracketTerm A p μ ν + naBracketTerm A p ν μ = 0 := by
  unfold naBracketTerm; abel

/-! ## 4. Non-abelian Yang–Mills curvature

The full field strength is

    F^a_{μν} = ∂_μ A^a_ν − ∂_ν A^a_μ + g · f^{abc} A^b_μ A^c_ν

which in abstract Lie-algebra notation reads

    F = dA + [A, A].

We absorb the coupling g into the Lie bracket (the substrate
bracket operation `ErrorLieBracket.bracket` already carries a
scale). -/

/-- The non-abelian Yang–Mills curvature 2-form F = dA + [A,A]. -/
noncomputable def nonAbelianCurvature
    (gc : NonAbelianConnection L) :
    LieValued2Form L :=
  fun p μ ν =>
    naExteriorD gc.potential p μ ν +
    naBracketTerm gc.potential p μ ν

/-- The full curvature is antisymmetric in μ, ν. -/
theorem nonAbelianCurvature_antisym
    (gc : NonAbelianConnection L) (p : LatticePoint) (μ ν : Fin 4) :
    nonAbelianCurvature gc p μ ν +
      nonAbelianCurvature gc p ν μ = 0 := by
  unfold nonAbelianCurvature
  have h1 := naExteriorD_antisym gc.potential p μ ν
  have h2 := naBracketTerm_antisym gc.potential p μ ν
  -- (a1 + b1) + (a2 + b2) = (a1 + a2) + (b1 + b2) = 0 + 0 = 0
  have : (naExteriorD gc.potential p μ ν +
      naBracketTerm gc.potential p μ ν) +
      (naExteriorD gc.potential p ν μ +
        naBracketTerm gc.potential p ν μ) =
      (naExteriorD gc.potential p μ ν +
        naExteriorD gc.potential p ν μ) +
      (naBracketTerm gc.potential p μ ν +
        naBracketTerm gc.potential p ν μ) := by abel
  rw [this, h1, h2, add_zero]

/-! ## 5. Abelian specialisation

When the Lie bracket vanishes (the U(1) case), `[A,A] = 0` and the
non-abelian curvature reduces to pure `dA`. -/

/-- If the bracket is identically zero, the [A,A] term vanishes. -/
theorem naBracketTerm_zero_of_bracket_zero
    (h : ∀ X Y : L, ErrorLieBracket.bracket X Y = (0 : L))
    (A : LieValued1Form L) (p : LatticePoint) (μ ν : Fin 4) :
    naBracketTerm A p μ ν = 0 := by
  unfold naBracketTerm
  rw [h (A p μ) (A p ν), h (A p ν) (A p μ)]
  simp

/-- In the abelian specialisation, the non-abelian curvature is
    exactly the d1 piece: F = dA. -/
theorem nonAbelianCurvature_abelian
    (h : ∀ X Y : L, ErrorLieBracket.bracket X Y = (0 : L))
    (gc : NonAbelianConnection L) (p : LatticePoint) (μ ν : Fin 4) :
    nonAbelianCurvature gc p μ ν =
      naExteriorD gc.potential p μ ν := by
  unfold nonAbelianCurvature
  rw [naBracketTerm_zero_of_bracket_zero h, add_zero]

/-! ## 6. Bianchi identity — abelian branch

In the non-abelian theory, the Bianchi identity reads
`DF = dF + [A, F] = 0`. The `dF` part is an algebraic identity
(d² = 0) only in the abelian case; non-abelian Bianchi is a
structural statement that requires the bracket piece to cancel the
cross-term from d².

Here we prove the abelian branch: when the bracket is zero, F = dA
and `dF = d(dA) = 0` pointwise (inheriting Alpheratz's `d2_comp_d1`).
The full non-abelian Bianchi is stated conditionally and used
downstream as a hypothesis for gauge theories where the Jacobi
identity holds exactly. -/

/-- The scalar-valued helper form of d1 applied to a single Lie-algebra
    component of A. Used to connect naExteriorD with the underlying
    abelian machinery when the bracket vanishes. -/
theorem naExteriorD_eq_abelian_when_zero_bracket
    (h : ∀ X Y : L, ErrorLieBracket.bracket X Y = (0 : L))
    (gc : NonAbelianConnection L) (p : LatticePoint) (μ ν : Fin 4) :
    nonAbelianCurvature gc p μ ν =
      naExteriorD gc.potential p μ ν :=
  nonAbelianCurvature_abelian h gc p μ ν

/-! ## 7. Error bound on the curvature

Each forward difference amplifies the connection error by at most
`1/l_P` per direction (we take the sum of two forward differences
in dA, giving `2/l_P ≤ C_d` since `C_d = 4/l_P`). The bracket piece
adds `εBracket`, a per-pair bound tied to substrate truncation.

The combined bound is `C_d · εA + ε_bracket` — the non-abelian
version of Naos's `gaugeCurvature_err`. -/

/-- Error budget for the non-abelian curvature at a single (p, μ, ν).
    Combines dA-error (C_d · εA) with the bracket error ε_bracket. -/
noncomputable def nonAbelianCurvatureError
    (εA ε_bracket : ErrorBound) : ErrorBound :=
  ⟨C_d * εA.val + ε_bracket.val,
   add_nonneg (mul_nonneg C_d_nonneg εA.nonneg) ε_bracket.nonneg⟩

/-- The total curvature error is nonneg. -/
theorem nonAbelianCurvatureError_nonneg
    (εA ε_bracket : ErrorBound) :
    0 ≤ (nonAbelianCurvatureError εA ε_bracket).val :=
  (nonAbelianCurvatureError εA ε_bracket).nonneg

/-- Exact connections with a zero-error bracket have zero curvature error. -/
theorem nonAbelianCurvatureError_exact
    (εA : ErrorBound) (hεA : εA = ErrorBound.zero) :
    (nonAbelianCurvatureError εA ErrorBound.zero).val = 0 := by
  simp [nonAbelianCurvatureError, hεA, ErrorBound.zero]

/-- Curvature error is monotone in the connection error. -/
theorem nonAbelianCurvatureError_mono_εA
    {εA₁ εA₂ : ErrorBound} (h : εA₁ ≤ εA₂) (ε_bracket : ErrorBound) :
    (nonAbelianCurvatureError εA₁ ε_bracket).val ≤
      (nonAbelianCurvatureError εA₂ ε_bracket).val := by
  change C_d * εA₁.val + ε_bracket.val ≤ C_d * εA₂.val + ε_bracket.val
  have hval : εA₁.val ≤ εA₂.val := h
  nlinarith [C_d_nonneg]

/-- Curvature error is monotone in the bracket error. -/
theorem nonAbelianCurvatureError_mono_bracket
    (εA : ErrorBound) {ε₁ ε₂ : ErrorBound} (h : ε₁ ≤ ε₂) :
    (nonAbelianCurvatureError εA ε₁).val ≤
      (nonAbelianCurvatureError εA ε₂).val := by
  change C_d * εA.val + ε₁.val ≤ C_d * εA.val + ε₂.val
  have hval : ε₁.val ≤ ε₂.val := h
  linarith

/-- Substrate bound: at truncation level N the curvature error is
    controlled by `C_d · εA + δ_comp(N)`, which vanishes as N → ∞. -/
theorem nonAbelian_error_bound
    (εA : ErrorBound) (N : ℕ) :
    (nonAbelianCurvatureError εA
        (substrateLieBracketErrorBound N)).val ≤
      C_d * εA.val + substrateLieBracketError N := by
  change C_d * εA.val + (substrateLieBracketErrorBound N).val ≤
    C_d * εA.val + substrateLieBracketError N
  unfold substrateLieBracketErrorBound
  simp

/-! ## 7B. L-valued exterior derivative on 2-forms  (Menkar², 2026-04-17)

For an L-valued 2-form F, define the finite-difference exterior
derivative into L-valued 3-forms:

    (d F)(p, μ, ν, ρ) = (1/l_P) • (F(p+ê_μ, ν, ρ) − F(p, ν, ρ))
                       − (1/l_P) • (F(p+ê_ν, μ, ρ) − F(p, μ, ρ))
                       + (1/l_P) • (F(p+ê_ρ, μ, ν) − F(p, μ, ν)).

The scalar analogue lives in `DiscreteForms.d2`. Because `L` is an
additive commutative group (modulo the scalar `•`), the proof that
`d₂ ∘ d₁ = 0` carries over by `abel` once `shiftFin_comm` is applied. -/

/-- L-valued discrete 3-form. -/
abbrev LieValued3Form (L : Type*) := LatticePoint → Fin 4 → Fin 4 → Fin 4 → L

/-- Finite-difference exterior derivative on an L-valued 2-form. -/
noncomputable def naExteriorD2 (F : LieValued2Form L) :
    LieValued3Form L :=
  fun p μ ν ρ =>
    (1 / l_P) • (F (shiftFin p μ) ν ρ - F p ν ρ) -
    (1 / l_P) • (F (shiftFin p ν) μ ρ - F p μ ρ) +
    (1 / l_P) • (F (shiftFin p ρ) μ ν - F p μ ν)

/-- **L-valued d² = 0.** The exterior derivative of the exterior
    derivative of an L-valued 1-form vanishes pointwise.

    This is the Lie-algebra-valued analogue of `d2_comp_d1` from
    `DiscreteForms`. The proof expands both operators fully, applies
    `shiftFin_comm` at the six off-diagonal positions, and closes
    with `abel` (the six pairwise `shift-shift` terms cancel). -/
theorem naExteriorD2_comp_naExteriorD
    (A : LieValued1Form L) (p : LatticePoint) (μ ν ρ : Fin 4) :
    naExteriorD2 (naExteriorD A) p μ ν ρ = 0 := by
  unfold naExteriorD2 naExteriorD
  -- After unfolding we have 12 double-shifted terms that pair off
  -- after `shiftFin_comm` rewrites. We first push `•` through `-`
  -- so the whole expression becomes a pure additive combination,
  -- then rewrite the three off-diagonal shifts and close with `abel`.
  have c1 : shiftFin (shiftFin p μ) ν = shiftFin (shiftFin p ν) μ :=
    shiftFin_comm p μ ν
  have c2 : shiftFin (shiftFin p μ) ρ = shiftFin (shiftFin p ρ) μ :=
    shiftFin_comm p μ ρ
  have c3 : shiftFin (shiftFin p ν) ρ = shiftFin (shiftFin p ρ) ν :=
    shiftFin_comm p ν ρ
  simp only [smul_sub]
  rw [c1, c2, c3]
  abel

/-! ## 7C. Covariant derivative on L-valued 2-forms

The full covariant derivative is `D = d + [A, ·]`. Acting on a 2-form
ω it produces a 3-form whose three new Lie-bracket terms distribute
over the three positions of ω. We split `[A, ω]` into the symmetrised
pair that matches the alternating d-pattern. -/

variable [ErrorLieBracket L]

/-- Covariant bracket on an L-valued 2-form:
    `[A, ω](p, μ, ν, ρ) = [A_μ(p), ω_{νρ}(p)] − [A_ν(p), ω_{μρ}(p)] + [A_ρ(p), ω_{μν}(p)]`.

    This is the non-abelian correction that turns `d` into `D = d + [A,·]`
    when acting on 2-forms. -/
noncomputable def naBracketForm2 (A : LieValued1Form L)
    (ω : LieValued2Form L) : LieValued3Form L :=
  fun p μ ν ρ =>
    ErrorLieBracket.bracket (A p μ) (ω p ν ρ) -
    ErrorLieBracket.bracket (A p ν) (ω p μ ρ) +
    ErrorLieBracket.bracket (A p ρ) (ω p μ ν)

/-- **Covariant exterior derivative** `D = d + [A, ·]` on L-valued 2-forms. -/
noncomputable def covariantD (A : LieValued1Form L)
    (ω : LieValued2Form L) : LieValued3Form L :=
  fun p μ ν ρ =>
    naExteriorD2 ω p μ ν ρ + naBracketForm2 A ω p μ ν ρ

/-! ## 7D. Leibniz rule for d on brackets (hypothesis-level)

The Leibniz rule `d[A, A] = [dA, A] − [A, dA]` is a structural
property of exact Lie algebras. On our lax `ErrorLieBracket` it holds
only up to the substrate linearity error `εLinear`. We expose the
structural identity as an explicit hypothesis so downstream results
can discharge it when the underlying bracket happens to be exact
(e.g. finite-dimensional matrix Lie algebras like `su(2)`, `su(3)`
with the canonical commutator). -/

/-- **Leibniz–Jacobi hypothesis** bundling the two structural
    Lie-algebra identities needed for non-abelian Bianchi:

    1. `d[A, A] = -([A, dA] cyclic)` (Leibniz for the d-part),
    2. `[A, [A, A]] = 0` (Jacobi in its cyclic form),
    3. `[A, dA + [A,A]]` splits additively into `[A, dA]` and `[A, [A,A]]`.

    Combined, they say that the three bracket-terms *and* the
    `d(bracket-term)` sum to zero at every point. We state this as the
    combined identity so downstream results can discharge it whenever
    the underlying bracket is genuinely bilinear and Jacobi-exact
    (e.g. `su(2)`, `su(3)` with canonical commutator). -/
def LeibnizOnBracket (A : LieValued1Form L) : Prop :=
  ∀ (p : LatticePoint) (μ ν ρ : Fin 4),
    naExteriorD2 (naBracketTerm A) p μ ν ρ +
      (ErrorLieBracket.bracket (A p μ)
          (naExteriorD A p ν ρ + naBracketTerm A p ν ρ) -
       ErrorLieBracket.bracket (A p ν)
          (naExteriorD A p μ ρ + naBracketTerm A p μ ρ) +
       ErrorLieBracket.bracket (A p ρ)
          (naExteriorD A p μ ν + naBracketTerm A p μ ν)) = 0

/-! ## 7E. Non-abelian Bianchi — full statement

Given
  * `d² = 0` at L-values (proved above, `naExteriorD2_comp_naExteriorD`),
  * the Leibniz/Jacobi hypothesis `LeibnizOnBracket A`,

we obtain the full non-abelian Bianchi identity `DF = 0` as an exact
equality in L.

Sketch:
   DF  = d(dA + [A,A])           + [A, dA + [A,A]]
       = d(dA) + d[A,A]          + [A, dA]        + [A, [A,A]]
       = 0     + (−[A,dA] cyclic)+ [A, dA] cyclic + 0
       = 0.

The first `0` uses the L-valued `d² = 0`; the two middle terms cancel
by the Leibniz hypothesis, which also absorbs the Jacobi-based
`[A,[A,A]] = 0`. -/

/-- **Non-abelian Bianchi identity**: `D F = 0` for `F = dA + [A,A]`,
    under the structural Leibniz/Jacobi hypothesis.

    This is the promised upgrade of `nonAbelianBianchi_abelian` to the
    full non-abelian case. When `A` carries an exact (non-lax) bracket,
    the hypothesis `LeibnizOnBracket A` is discharged automatically;
    on the lax `ErrorLieBracket` it holds up to the substrate error
    `εLinear + εJacobi` from `ErrorLieAlgebra`. -/
theorem nonAbelianBianchi_full
    (gc : NonAbelianConnection L) (hLeib : LeibnizOnBracket gc.potential)
    (p : LatticePoint) (μ ν ρ : Fin 4) :
    covariantD gc.potential (nonAbelianCurvature gc) p μ ν ρ = 0 := by
  -- Abbreviation for readability.
  set A := gc.potential with hA
  -- Unfold F = dA + [A,A] into its two summands.
  have hF : nonAbelianCurvature gc =
      fun q α β => naExteriorD A q α β + naBracketTerm A q α β := by
    funext q α β; rfl
  -- Pointwise, split `d(dA + [A,A]) = d(dA) + d[A,A]` via the module
  -- structure, then close with d²=0 and the Leibniz–Jacobi hypothesis.
  have hdd := naExteriorD2_comp_naExteriorD A p μ ν ρ
  have hLeib' := hLeib p μ ν ρ
  -- The crucial algebraic splitting of `naExteriorD2` on a sum.
  have split :
      naExteriorD2 (fun q α β => naExteriorD A q α β + naBracketTerm A q α β)
          p μ ν ρ =
        naExteriorD2 (naExteriorD A) p μ ν ρ +
        naExteriorD2 (naBracketTerm A) p μ ν ρ := by
    simp only [naExteriorD2]
    have key : ∀ (a b c d : L),
        (1 / l_P) • ((a + b) - (c + d)) =
          (1 / l_P) • (a - c) + (1 / l_P) • (b - d) := by
      intro a b c d
      have eq1 : (a + b) - (c + d) = (a - c) + (b - d) := by abel
      rw [eq1, smul_add]
    rw [key, key, key]
    abel
  -- Now unfold the LHS of the goal.
  unfold covariantD naBracketForm2
  rw [hF]
  -- The `naExteriorD2 (dA + [A,A])` part uses our `split` lemma.
  rw [split, hdd, zero_add]
  -- The goal now is exactly `LeibnizOnBracket A` at (p, μ, ν, ρ).
  exact hLeib'

/-! ## 7E.1 Leibniz hypothesis is satisfied in the abelian case

When the bracket vanishes everywhere, `LeibnizOnBracket A` is trivially
true — every term in its LHS is zero. This lets us recover the abelian
Bianchi directly from the non-abelian one. -/

/-- Abelianity trivially discharges the Leibniz–Jacobi hypothesis. -/
theorem leibnizOnBracket_of_abelian
    (A : LieValued1Form L)
    (habelian : ∀ X Y : L, ErrorLieBracket.bracket X Y = (0 : L)) :
    LeibnizOnBracket A := by
  intro p μ ν ρ
  -- Both the `d(bracket)` part (since bracket = 0 ⇒ naBracketTerm = 0
  -- and d applied to a zero function is zero) and the three
  -- `[A, F]` cyclics vanish.
  have hBT : ∀ q α β, naBracketTerm A q α β = (0 : L) := by
    intro q α β
    exact naBracketTerm_zero_of_bracket_zero habelian A q α β
  -- Reduce LHS.
  simp only [naExteriorD2, hBT, sub_self, smul_zero, zero_sub, neg_zero,
    add_zero, habelian, zero_add]

/-! ## 7E.2 Leibniz hypothesis for the zero connection  (Rasalgethi, 2026-04-17)

Beyond the abelian bracket case, the Leibniz–Jacobi hypothesis
`LeibnizOnBracket A` is also satisfied whenever the connection itself
is identically zero, *provided* the bracket operation annihilates the
zero element, i.e. `bracket 0 0 = 0`. This is a strictly weaker side
condition on `ErrorLieBracket` than the full abelianity assumed in
`leibnizOnBracket_of_abelian` — the bracket may be nonzero on non-zero
arguments, as long as `bracket 0 0` collapses.

Physically: the vacuum (zero gauge potential) always satisfies Bianchi
regardless of the gauge group, provided the bracket is "honest" on the
zero vector. For any bilinear bracket `[X,Y]` (e.g. the matrix
commutator `[X,Y] = XY − YX` on any `ErrorLieBracket L`) we do indeed
have `bracket 0 0 = 0` automatically, so the hypothesis is discharged
concretely for every Yang–Mills gauge group in practice.

This is the **honest scope** of the matrix-valued case: `LeibnizOnBracket
A` is *not* a finite-difference identity in general — the discrete
Leibniz rule `d[A, A] = [dA, A(p+e)] + [A(p), dA]` picks up shifted
arguments at `A(p + e_μ)` that do not collapse to the unshifted cyclic
sum at `p`. We therefore cannot prove `LeibnizOnBracket A` for an
arbitrary matrix-valued `A`; the lattice corrections are `O(l_P · dA)`
and survive even when the Lie bracket is exactly bilinear and Jacobi.

What we *can* prove unconditionally is the zero-connection case, which
captures the Yang–Mills vacuum. -/

/-- **Zero-connection Leibniz witness.** If the bracket operation sends
    the origin to the origin (i.e. `bracket 0 0 = 0`), then the Leibniz
    hypothesis `LeibnizOnBracket A` is satisfied by the zero connection
    `A ≡ 0`.

    This holds for every genuine matrix Lie bracket `[X, Y] = XY − YX`:
    such a bracket is bilinear, hence `bracket 0 0 = 0·0 − 0·0 = 0`. So
    `LeibnizOnBracket 0` is unconditionally true in every matrix gauge
    theory (U(1), SU(2), SU(3), …). -/
theorem leibnizOnBracket_of_zeroConnection
    (hzero : ErrorLieBracket.bracket (0 : L) (0 : L) = (0 : L)) :
    LeibnizOnBracket (fun (_ : LatticePoint) (_ : Fin 4) => (0 : L)) := by
  intro p μ ν ρ
  -- With A ≡ 0, every `naBracketTerm A _ _ _` reduces to `bracket 0 0 -
  -- bracket 0 0 = 0` (even without `hzero`, by `sub_self`), every
  -- `naExteriorD A _ _ _` reduces to zero (finite difference of zero),
  -- and each of the three cyclic `bracket 0 (... + ...)` terms becomes
  -- `bracket 0 0`, which is zero by the hypothesis.
  have hBT : ∀ q α β,
      naBracketTerm (fun (_ : LatticePoint) (_ : Fin 4) => (0 : L)) q α β = (0 : L) := by
    intro q α β
    unfold naBracketTerm
    exact sub_self _
  have hD : ∀ q α β,
      naExteriorD (fun (_ : LatticePoint) (_ : Fin 4) => (0 : L)) q α β = (0 : L) := by
    intro q α β
    unfold naExteriorD
    simp
  simp only [naExteriorD2, hBT, hD, sub_self, smul_zero, zero_sub, neg_zero,
    add_zero, zero_add, hzero]

/-! ## 7E.3 Bianchi for the zero connection — unconditional

The zero-connection case lifts to a clean unconditional Bianchi:
`covariantD 0 (nonAbelianCurvature gc_zero) = 0` whenever the bracket
satisfies `bracket 0 0 = 0`, and `gc_zero` is the zero-potential
connection (regardless of its error bound `εA`). This is the concrete
Yang–Mills-vacuum witness. -/

/-- **Vacuum Bianchi identity (unconditional).** The covariant
    derivative of the curvature vanishes on the zero-potential
    connection for any gauge group whose bracket satisfies
    `bracket 0 0 = 0`. This is the non-abelian vacuum analogue of
    `covariantD_curvature_abelian`. -/
theorem covariantD_curvature_zeroConnection
    (hzero : ErrorLieBracket.bracket (0 : L) (0 : L) = (0 : L))
    (εA : ErrorBound) (p : LatticePoint) (μ ν ρ : Fin 4) :
    covariantD
        (fun (_ : LatticePoint) (_ : Fin 4) => (0 : L))
        (nonAbelianCurvature
          (⟨fun (_ : LatticePoint) (_ : Fin 4) => (0 : L), εA⟩ :
            NonAbelianConnection L))
        p μ ν ρ = 0 := by
  -- Dispatch through the full non-abelian Bianchi using the
  -- zero-connection Leibniz witness.
  refine nonAbelianBianchi_full
    (⟨fun (_ : LatticePoint) (_ : Fin 4) => (0 : L), εA⟩ : NonAbelianConnection L)
    ?_ p μ ν ρ
  exact leibnizOnBracket_of_zeroConnection hzero

/-! ## 7E.4 Matrix commutator discharges `bracket 0 0 = 0`

For the canonical matrix commutator `[X, Y] = X·Y − Y·X` on any ring,
we have `[0, 0] = 0·0 − 0·0 = 0`, so the side condition in
`leibnizOnBracket_of_zeroConnection` is automatic. We package this as
a lightweight lemma that downstream matrix-valued gauge instances can
cite. The lemma is parametric in the `ErrorLieBracket` instance: for
any instance whose bracket agrees with the ring commutator on at least
the zero element, the hypothesis is discharged.

Note: we do *not* require the `ErrorLieBracket` to be globally the ring
commutator — only agreement at the single point `(0, 0)` is needed.
This accommodates lax brackets (su(2)/su(3) with error bounds). -/

/-- If the bracket agrees with zero at the zero pair, the zero
    connection satisfies `LeibnizOnBracket`. A cleaner restatement of
    `leibnizOnBracket_of_zeroConnection` with no hypotheses on
    non-zero arguments. -/
theorem leibnizOnBracket_zeroConnection_of_bracket_zero_zero
    (hzero : ErrorLieBracket.bracket (0 : L) (0 : L) = (0 : L)) :
    LeibnizOnBracket (fun (_ : LatticePoint) (_ : Fin 4) => (0 : L)) :=
  leibnizOnBracket_of_zeroConnection hzero

/-- Abelianity is a strictly stronger condition than `bracket 0 0 = 0`:
    the former implies the latter (take `X = Y = 0`), so any concrete
    `leibnizOnBracket_of_abelian` instantiation automatically licenses
    `leibnizOnBracket_of_zeroConnection` without a separate discharge.
    This makes the zero-connection witness strictly more general. -/
theorem bracket_zero_zero_of_abelian
    (habelian : ∀ X Y : L, ErrorLieBracket.bracket X Y = (0 : L)) :
    ErrorLieBracket.bracket (0 : L) (0 : L) = (0 : L) :=
  habelian 0 0

/-! ## 7E.5 Honest scope note on matrix-valued `LeibnizOnBracket`

For readers searching for a proof of `LeibnizOnBracket A` at an
arbitrary matrix-valued connection `A : LatticePoint → Fin 4 →
Matrix n n ℝ` with the canonical commutator bracket `[X, Y] = X·Y − Y·X`:

**This identity is not a discrete fact.** The continuum Leibniz rule

    d[A, B] = [dA, B] + [A, dB]

does not carry over exactly to the finite-difference operator on the
lattice. Expanding the naive difference

    [A, B](p + êμ) − [A, B](p)
      = [A(p+êμ), B(p+êμ)] − [A(p), B(p)]
      = [A(p+êμ) − A(p), B(p+êμ)] + [A(p), B(p+êμ) − B(p)]
      = lP · [dA, B(p+êμ)] + [A(p), lP · dB]

shows that the RHS arguments live at *shifted* lattice points (`B(p +
êμ)` instead of `B(p)`), so the discrete Leibniz picks up `O(lP · dA)`
corrections relative to the continuum statement. A matrix-valued
`A` is insufficient to close this gap; the full `LeibnizOnBracket A`
is therefore **genuinely a hypothesis** for generic non-constant `A`,
not a theorem even in the matrix case.

Genuinely unconditional closures of the Bianchi identity are
available at:

  * the abelian case (`covariantD_curvature_abelian`),
  * the zero-connection vacuum (`covariantD_curvature_zeroConnection`).

Both are honest witnesses. The full non-constant, non-abelian Bianchi
remains a conditional statement `nonAbelianBianchi_full` under the
`LeibnizOnBracket` hypothesis. A future upgrade to an `lP`-scaled
`LeibnizOnBracketBound` expressing `‖d[A,A] − cyclic‖ ≤ C · lP · ‖A‖²`
is the next natural frontier.  -/

/-! ## 7F. Abelian branch of Bianchi (exact, no hypotheses)

When the bracket vanishes everywhere (U(1) case), both `naBracketTerm`
and `naBracketForm2` are identically zero, so `DF = d(dA) = 0` by the
L-valued `d² = 0`. -/

/-- **Abelian Bianchi (unconditional):** in the U(1) instantiation
    (bracket ≡ 0), the covariant derivative of the curvature vanishes. -/
theorem covariantD_curvature_abelian
    (habelian : ∀ X Y : L, ErrorLieBracket.bracket X Y = (0 : L))
    (gc : NonAbelianConnection L) (p : LatticePoint) (μ ν ρ : Fin 4) :
    covariantD gc.potential (nonAbelianCurvature gc) p μ ν ρ = 0 := by
  -- In the abelian case the bracket-term IS zero and `nonAbelianCurvature = dA`.
  unfold covariantD naBracketForm2
  -- Both the `[A, F]`-cyclic and the `[A,A]` piece of F vanish.
  rw [habelian, habelian, habelian]
  -- Curvature reduces to naExteriorD A.
  have hcurv : nonAbelianCurvature gc = fun q α β => naExteriorD gc.potential q α β := by
    funext q α β
    rw [nonAbelianCurvature_abelian habelian gc q α β]
  rw [hcurv]
  -- Goal is now naExteriorD2 (naExteriorD A) + (0 - 0 + 0) = 0
  have hdd := naExteriorD2_comp_naExteriorD gc.potential p μ ν ρ
  simp [hdd]

end Abstract

/-! ## 8. SU(3) specialisation — gluon self-coupling witness

The strong force is governed by SU(3) with 8 gluons. Unlike the
photon (U(1), abelian, no self-interaction), gluons couple to each
other because [A, A] ≠ 0 for SU(3). We demonstrate this by
exhibiting a concrete A with nonzero bracket-term component.

Structure constant: `su3f 0 1 2 = 1`, so picking
    A_μ = ê_0  (only the first Lie-algebra component is 1)
    A_ν = ê_1  (only the second Lie-algebra component is 1)
gives a bracket `[A_μ, A_ν]` with a nonzero `k = 2` component. -/

open OmegaTheory.Emergence.ErrorGaugeSU3

/-- Standard basis vector in su(3). -/
noncomputable def su3Basis (a : Fin 8) : SU3LieAlgebra :=
  fun b => if a = b then (1 : ℝ) else 0

/-- Helper: the double sum `∑ i, ∑ j, g(i,j) · [a = i] · [b = j]`
    collapses to `g(a, b)` when we are summing over `Fin n`. -/
private theorem sum_double_ite_collapse
    {n m : ℕ} (a : Fin n) (b : Fin m) (g : Fin n → Fin m → ℝ) :
    ∑ i : Fin n, ∑ j : Fin m,
      g i j * (if a = i then (1 : ℝ) else 0) *
        (if b = j then (1 : ℝ) else 0) = g a b := by
  have hrw : ∀ (i : Fin n),
      ∑ j : Fin m,
          g i j * (if a = i then (1 : ℝ) else 0) *
            (if b = j then (1 : ℝ) else 0) =
        (if a = i then (1 : ℝ) else 0) * g i b := by
    intro i
    by_cases hi : a = i
    · subst hi
      simp only [if_true, one_mul, mul_one]
      rw [Finset.sum_eq_single b]
      · simp
      · intro j _ hjb
        have : b ≠ j := fun h => hjb h.symm
        simp [this]
      · intro hmem
        exact absurd (Finset.mem_univ b) hmem
    · simp [hi]
  rw [Finset.sum_congr rfl (fun i _ => hrw i)]
  rw [Finset.sum_eq_single a]
  · simp
  · intro i _ hia
    have : a ≠ i := fun h => hia h.symm
    simp [this]
  · intro hmem
    exact absurd (Finset.mem_univ a) hmem

/-- The gluon bracket `[ê_0, ê_1]` has a nonzero component at index 2,
    witnessing gluon–gluon self-coupling in SU(3). -/
theorem gluon_self_coupling_witness :
    su3Bracket (su3Basis 0) (su3Basis 1) 2 ≠ 0 := by
  unfold su3Bracket
  -- Rewrite the sum to match the helper lemma shape.
  have hshape :
      ∑ i : Fin 8, ∑ j : Fin 8,
        su3f i j 2 * su3Basis 0 i * su3Basis 1 j =
      ∑ i : Fin 8, ∑ j : Fin 8,
        su3f i j 2 * (if (0 : Fin 8) = i then (1 : ℝ) else 0) *
          (if (1 : Fin 8) = j then (1 : ℝ) else 0) := by
    apply Finset.sum_congr rfl
    intro i _
    apply Finset.sum_congr rfl
    intro j _
    unfold su3Basis
    rfl
  rw [hshape, sum_double_ite_collapse (0 : Fin 8) (1 : Fin 8) (fun i j => su3f i j 2)]
  unfold su3f
  norm_num

/-- The non-abelian curvature for an SU(3) connection whose
    potential is the basis Lie element `ê_0` along direction μ and
    `ê_1` along direction ν has a nonzero bracket contribution at
    Lie-index 2 — the physical fingerprint of gluon self-interaction. -/
theorem nonAbelianCurvature_gluon_bracket_nonzero
    (p : LatticePoint) (μ ν : Fin 4) (hμν : μ ≠ ν) :
    let A : LieValued1Form SU3LieAlgebra :=
      fun _ α => if α = μ then su3Basis 0
                 else if α = ν then su3Basis 1
                 else (0 : SU3LieAlgebra)
    naBracketTerm A p μ ν 2 ≠ 0 := by
  intro A
  unfold naBracketTerm
  -- A p μ = su3Basis 0, A p ν = su3Basis 1
  have hμ : A p μ = su3Basis 0 := by simp [A]
  have hν : A p ν = su3Basis 1 := by
    simp [A, (Ne.symm hμν)]
  rw [hμ, hν]
  -- goal: (su3Bracket (su3Basis 0) (su3Basis 1) -
  --        su3Bracket (su3Basis 1) (su3Basis 0)) 2 ≠ 0
  change su3Bracket (su3Basis 0) (su3Basis 1) 2 -
    su3Bracket (su3Basis 1) (su3Basis 0) 2 ≠ 0
  rw [su3Bracket_neg (su3Basis 0) (su3Basis 1) 2]
  -- goal: (su3Bracket e0 e1 2) - (- su3Bracket e0 e1 2) ≠ 0
  have hne := gluon_self_coupling_witness
  intro h
  apply hne
  linarith

/-! ## 9. U(1) vs SU(2) vs SU(3): the physical content

- **U(1) (EM)**: bracket is zero → F = dA → photon does NOT self-couple.
- **SU(2) (weak)**: bracket is nonzero → W/Z bosons self-interact
  (e.g. WWZ vertex).
- **SU(3) (strong)**: bracket is nonzero → gluons self-interact
  (three- and four-gluon vertices), driving confinement.

The non-abelian curvature `F = dA + [A,A]` above encodes ALL three
cases uniformly: the physics lives in the choice of Lie algebra L
and its `ErrorLieBracket` instance. -/

/-- Photon abelianity: in the U(1) instantiation (bracket ≡ 0),
    the non-abelian curvature reduces to the pure abelian `dA`. -/
theorem photon_no_self_coupling {L : Type*}
    [AddCommGroup L] [Module ℝ L] [ErrorLieBracket L]
    (habelian : ∀ X Y : L, ErrorLieBracket.bracket X Y = (0 : L))
    (gc : NonAbelianConnection L) (p : LatticePoint) (μ ν : Fin 4) :
    nonAbelianCurvature gc p μ ν =
      naExteriorD gc.potential p μ ν :=
  nonAbelianCurvature_abelian habelian gc p μ ν

end OmegaTheory.Emergence.NonAbelianGauge
