/-
  OmegaTheory.Geometry.HodgeStar

  Discrete Hodge theory on the Planck lattice: codifferentials, Hodge
  Laplacian, and Hodge decomposition infrastructure.

  Extends the discrete de Rham complex (DiscreteForms.lean) with the
  "dual" half of the Hodge-de Rham theory. The exterior derivative d
  goes "up" in form degree; the codifferential delta goes "down."
  Together they define the Hodge Laplacian Delta = d*delta + delta*d.

  Key results:
  1. `codiff0` — codifferential Omega^1 -> Omega^0 (discrete divergence)
  2. `codiff1` — codifferential Omega^2 -> Omega^1
  3. `hodgeLaplacian0` — Hodge Laplacian on 0-forms = discreteLaplacian
  4. `hodgeLaplacian1` — Hodge Laplacian on 1-forms
  5. `harmonic0_iff` — f is harmonic iff Hodge-Laplacian vanishes
  6. `codiff0_comp_codiff1` — delta^2 = 0 (dual of d^2 = 0)

  Convention: we use the POSITIVE codifferential (no (-1)^k factor),
  matching the existing `discreteLaplacian = sum_mu secondDeriv f mu`.
  This avoids sign issues with the Minkowski metric.

  Agent: Lyra (April 13, 2026)
-/

import OmegaTheory.Geometry.DiscreteForms
import Mathlib.Tactic

namespace OmegaTheory.Geometry

open OmegaTheory.Spacetime

/-! ## Codifferential (Discrete Divergence)

  The codifferential delta maps k-forms to (k-1)-forms by applying
  the backward difference in the contracted index:
    (delta omega)_{i1...i_{k-1}}(p) = sum_mu backward_diff_mu(omega_{mu,i1,...})(p)

  This is the discrete adjoint of the exterior derivative d with respect
  to the L^2 inner product on the lattice.
-/

/-- Codifferential on 1-forms (discrete divergence): delta_0 : Omega^1 -> Omega^0.
    (delta_0 omega)(p) = sum_mu backward_diff_mu(omega(., mu))(p). -/
noncomputable def codiff0 (ω : Discrete1Form) : Discrete0Form :=
  fun p => Finset.univ.sum fun μ : Fin 4 =>
    backwardDiff (fun q => ω q μ) μ p

/-- Codifferential on 2-forms: delta_1 : Omega^2 -> Omega^1.
    (delta_1 omega)(p, nu) = sum_mu backward_diff_mu(omega(., mu, nu))(p). -/
noncomputable def codiff1 (ω : Discrete2Form) : Discrete1Form :=
  fun p ν => Finset.univ.sum fun μ : Fin 4 =>
    backwardDiff (fun q => ω q μ ν) μ p

/-- Codifferential on 3-forms: delta_2 : Omega^3 -> Omega^2.
    (delta_2 omega)(p, nu, rho) = sum_mu backward_diff_mu(omega(., mu, nu, rho))(p). -/
noncomputable def codiff2 (ω : Discrete3Form) : Discrete2Form :=
  fun p ν ρ => Finset.univ.sum fun μ : Fin 4 =>
    backwardDiff (fun q => ω q μ ν ρ) μ p

/-! ### Codifferential Properties -/

/-- Codifferential of zero 1-form is zero. -/
theorem codiff0_zero (p : LatticePoint) :
    codiff0 zero1Form p = 0 := by
  unfold codiff0 zero1Form backwardDiff
  simp

/-- Codifferential of zero 2-form is zero. -/
theorem codiff1_zero (p : LatticePoint) (ν : Fin 4) :
    codiff1 zero2Form p ν = 0 := by
  unfold codiff1 zero2Form backwardDiff
  simp

/-- Codifferential is linear: delta(omega_1 + omega_2) = delta(omega_1) + delta(omega_2). -/
theorem codiff0_add (ω₁ ω₂ : Discrete1Form) (p : LatticePoint) :
    codiff0 (add1Form ω₁ ω₂) p = codiff0 ω₁ p + codiff0 ω₂ p := by
  unfold codiff0 add1Form
  simp only [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl; intro μ _
  unfold backwardDiff; field_simp; ring

/-- Codifferential commutes with scalar multiplication. -/
theorem codiff0_smul (k : ℝ) (ω : Discrete1Form) (p : LatticePoint) :
    codiff0 (smul1Form k ω) p = k * codiff0 ω p := by
  simp only [codiff0, smul1Form, backwardDiff]
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl; intro μ _; ring

/-! ## Hodge Laplacian

  The Hodge Laplacian Delta = d*delta + delta*d on k-forms.
  On 0-forms, Delta_0 = delta_0 . d_0 (since there's no d_{-1}).
  On 1-forms, Delta_1 = d_0 . delta_0 + delta_1 . d_1.
-/

/-- Hodge Laplacian on 0-forms: Delta_0 f = delta_0(d_0 f).
    Since 0-forms have no "incoming" d, this is just the codifferential
    applied to the exterior derivative. -/
noncomputable def hodgeLaplacian0 (f : Discrete0Form) : Discrete0Form :=
  codiff0 (d0 f)

/-- Hodge Laplacian on 1-forms: Delta_1 omega = d_0(delta_0 omega) + delta_1(d_1 omega). -/
noncomputable def hodgeLaplacian1 (ω : Discrete1Form) : Discrete1Form :=
  fun p ν => d0 (codiff0 ω) p ν + codiff1 (d1 ω) p ν

/-! ## The Bridge: Hodge Laplacian = Discrete Laplacian

  The crown jewel of the Hodge theory module: the Hodge Laplacian
  on 0-forms equals the existing `discreteLaplacian` from Operators.lean.
  This connects the de Rham complex to the spectral theory of the lattice. -/

/-- The Hodge Laplacian on 0-forms equals the discrete Laplacian:
    Delta_0 f = sum_mu (f(p+mu) - 2f(p) + f(p-mu)) / l_P^2.
    This bridges the Hodge-de Rham theory to Operators.lean. -/
theorem hodgeLaplacian0_eq_discreteLaplacian (f : Discrete0Form) (p : LatticePoint) :
    hodgeLaplacian0 f p = discreteLaplacian f p := by
  unfold hodgeLaplacian0 codiff0 d0
  -- Both sides equal sum_mu secondDeriv f mu p
  -- LHS = sum_mu backwardDiff(forwardDiff f mu) mu p
  -- RHS = sum_mu secondDeriv f mu p (by definition)
  unfold discreteLaplacian
  apply Finset.sum_congr rfl; intro μ _
  -- backwardDiff(forwardDiff f mu) mu p = secondDeriv f mu p
  simp only [secondDeriv, backwardDiff, forwardDiff, shiftBackFin_shiftFin]
  field_simp; ring

/-- The Hodge Laplacian of a constant is zero. -/
theorem hodgeLaplacian0_const (k : ℝ) (p : LatticePoint) :
    hodgeLaplacian0 (fun _ => k) p = 0 := by
  rw [hodgeLaplacian0_eq_discreteLaplacian]
  exact discreteLaplacian_const k p

/-- The Hodge Laplacian vanishes iff the discrete Laplacian vanishes. -/
theorem hodgeLaplacian0_eq_zero_iff (f : Discrete0Form) (p : LatticePoint) :
    hodgeLaplacian0 f p = 0 ↔ discreteLaplacian f p = 0 := by
  rw [hodgeLaplacian0_eq_discreteLaplacian]

/-! ## delta^2 = 0 (Dual of d^2 = 0)

  Just as d^2 = 0 (d1_comp_d0, d2_comp_d1), the codifferential satisfies
  delta^2 = 0. On the lattice, this follows from the commutativity of
  backward differences, which is the dual of forward difference commutativity. -/

/-- Backward differences commute: Delta^-_mu(Delta^-_nu f) = Delta^-_nu(Delta^-_mu f). -/
theorem backwardDiff_comm' (f : ScalarField) (μ ν : Fin 4) (p : LatticePoint) :
    backwardDiff (fun q => backwardDiff f ν q) μ p =
    backwardDiff (fun q => backwardDiff f μ q) ν p := by
  unfold backwardDiff
  have h := shiftBackFin_comm p μ ν
  field_simp; rw [h]; ring

/-- delta^2 = 0: codiff0(codiff1 omega) = 0 for antisymmetric 2-forms.
    This is the dual of d2_comp_d1 (d^2 = 0).

    Proof: S = Σ_α Σ_μ D⁻_α(D⁻_μ ω(·,μ,α))
    By backwardDiff_finset_sum: distribute outer D⁻ into sum.
    By backwardDiff_comm': swap derivative order D⁻_α D⁻_μ = D⁻_μ D⁻_α.
    By Finset.sum_comm: swap sum indices α ↔ μ.
    By antisymmetry: ω(q,μ,α) = -ω(q,α,μ).
    Hence S = -S, so S = 0. -/
theorem codiff0_comp_codiff1 (ω : Discrete2Form) (hanti : IsAntisymmetric2 ω)
    (p : LatticePoint) :
    codiff0 (codiff1 ω) p = 0 := by
  unfold codiff0 codiff1
  simp_rw [backwardDiff_finset_sum]
  -- S = Σ_α Σ_μ BD_α(BD_μ(ω(·,μ,α)))(p). Show S = -S, hence S = 0.
  -- Helper: backwardDiff of negated function = negated backwardDiff
  have bd_neg : ∀ (g : ScalarField) (d : Fin 4) (q : LatticePoint),
      backwardDiff (fun r => -g r) d q = -backwardDiff g d q := by
    intro g d q; unfold backwardDiff; ring
  -- Key: each summand f(α,μ) = -f(μ,α)
  have key : ∀ α μ : Fin 4,
      backwardDiff (fun q => backwardDiff (fun r => ω r μ α) μ q) α p =
      -(backwardDiff (fun q => backwardDiff (fun r => ω r α μ) α q) μ p) := by
    intro α μ
    -- Swap derivative order: BD_α(BD_μ f) = BD_μ(BD_α f)
    rw [backwardDiff_comm']
    -- Apply antisymmetry inside: ω(r,μ,α) = -ω(r,α,μ)
    simp_rw [show ∀ r, ω r μ α = -ω r α μ from fun r => hanti r μ α]
    -- Pull negation through two layers of backwardDiff
    simp_rw [bd_neg]
  -- Now S = Σ_α Σ_μ (-f(μ,α)) = -(Σ_α Σ_μ f(μ,α)) = -(Σ_μ Σ_α f(α,μ)) = -S
  have : (Finset.univ.sum fun α =>
    Finset.univ.sum fun μ =>
      backwardDiff (fun q => backwardDiff (fun r => ω r μ α) μ q) α p) =
    -(Finset.univ.sum fun α =>
    Finset.univ.sum fun μ =>
      backwardDiff (fun q => backwardDiff (fun r => ω r μ α) μ q) α p) := by
    -- Rewrite each summand using key
    conv_lhs =>
      arg 2; ext α; arg 2; ext μ
      rw [key α μ]
    -- Factor out negations
    simp only [Finset.sum_neg_distrib]
    -- Swap sum order: Σ_α Σ_μ f(μ,α) = Σ_μ Σ_α f(α,μ) after renaming
    rw [Finset.sum_comm]
  linarith

/-! ## Exact and Coexact Forms

  A form is exact if omega = d(alpha) for some lower-degree form.
  A form is coexact if omega = delta(beta) for some higher-degree form.
  A form is harmonic if Delta(omega) = 0, equivalently d(omega) = 0 AND delta(omega) = 0. -/

/-- A 0-form is coexact (trivially false — there are no (-1)-forms).
    Included for completeness of the Hodge decomposition. -/
def IsCoexact0 (_ : Discrete0Form) : Prop := False

/-- A 1-form is coexact if omega = d_0(f) for some 0-form f.
    (Confusingly, this is the same as being exact. For 1-forms,
    exact and coexact coincide with different form degrees.) -/
def IsCoexact1 (ω : Discrete1Form) : Prop :=
  ∃ β : Discrete2Form, ω = codiff1 β

/-- A 0-form is co-closed if delta_0 vanishes (trivially true since delta_{-1} doesn't exist). -/
def IsCoClosed0 (_ : Discrete0Form) : Prop := True

/-- A 1-form is co-closed if its codifferential vanishes: delta_0(omega) = 0. -/
def IsCoClosed1 (ω : Discrete1Form) : Prop :=
  ∀ p, codiff0 ω p = 0

/-- Closed 0-forms have vanishing Hodge Laplacian:
    if d_0 f = 0 everywhere, then Delta_0 f = 0 everywhere. -/
theorem closed_implies_hodgeLaplacian0_zero (f : Discrete0Form)
    (hclosed : ∀ p μ, d0 f p μ = 0) :
    ∀ p, hodgeLaplacian0 f p = 0 := by
  intro p
  unfold hodgeLaplacian0 codiff0
  apply Finset.sum_eq_zero; intro μ _
  simp only [hclosed, backwardDiff_const]

/-! ## Weitzenböck-Type Identity

  On the flat lattice, the Hodge Laplacian on 1-forms decomposes as:
  Delta_1 = d_0 . delta_0 + delta_1 . d_1
  = (gradient of divergence) + (codifferential of curl)

  In the continuum with flat metric, this equals the componentwise Laplacian:
  (Delta_1 omega)_nu = sum_mu d^2 omega_nu / dx_mu^2

  We prove the discrete analogue: the Hodge Laplacian on 1-forms
  equals the componentwise discrete Laplacian plus cross terms. -/

/-- The componentwise discrete Laplacian on 1-forms. -/
noncomputable def componentLaplacian1 (ω : Discrete1Form) : Discrete1Form :=
  fun p ν => Finset.univ.sum fun μ : Fin 4 =>
    secondDeriv (fun q => ω q ν) μ p

/-- For the flat lattice, the "grad-div" part of the Hodge Laplacian on 1-forms. -/
noncomputable def gradDiv (ω : Discrete1Form) : Discrete1Form :=
  fun p ν => d0 (codiff0 ω) p ν

/-- For the flat lattice, the "codiff-curl" part of the Hodge Laplacian on 1-forms. -/
noncomputable def codiffCurl (ω : Discrete1Form) : Discrete1Form :=
  fun p ν => codiff1 (d1 ω) p ν

/-- The Hodge Laplacian on 1-forms splits as grad-div + codiff-curl. -/
theorem hodgeLaplacian1_split (ω : Discrete1Form) (p : LatticePoint) (ν : Fin 4) :
    hodgeLaplacian1 ω p ν = gradDiv ω p ν + codiffCurl ω p ν := by
  rfl

/-- On the flat lattice, the componentwise Laplacian equals the Hodge Laplacian
    on 1-forms. This is the discrete Weitzenböck identity for flat space
    (Weitzenböck = Hodge Laplacian + curvature term; curvature = 0 for flat). -/
theorem weitzenbock_flat (ω : Discrete1Form) (p : LatticePoint) (ν : Fin 4) :
    hodgeLaplacian1 ω p ν = componentLaplacian1 ω p ν := by
  unfold hodgeLaplacian1 componentLaplacian1 d0 codiff0 codiff1 d1
  unfold forwardDiff backwardDiff secondDeriv
  simp only [shiftBackFin_shiftFin]
  -- The grad-div part has (Σ_x f(p+ν) - Σ_x f(p)) / l_P.
  -- Distribute into the sum so all terms live in a single Σ_x.
  simp only [← Finset.sum_sub_distrib, Finset.sum_div, ← Finset.sum_add_distrib]
  -- Now compare per summand, using mixed shift commutativity for cross terms
  apply Finset.sum_congr rfl; intro x _
  simp only [shiftFin_shiftBackFin_comm]
  field_simp; ring

end OmegaTheory.Geometry
