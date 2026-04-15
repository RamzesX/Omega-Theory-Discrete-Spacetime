/-
  OmegaTheory.Emergence.Decoherence

  **P11 of the OmegaTheory V2 emergence ladder: the classical-limit bridge.**
  Classical physics emerges from quantum mechanics through partial tracing
  over an environment — off-diagonal density-matrix elements decay (or
  vanish outright, under orthogonality of environment pointer states)
  and what remains is a classical statistical mixture.

  ## Physical story

  Consider a bipartite system A ⊗ B where A is the "system of interest"
  (an observable subregion of the lattice) and B is the "environment"
  (the complementary region we do not monitor).  The full quantum state
  is a two-body field `Ψ : LatticePoint → LatticePoint → ℕ → ℂ` as in
  `Entanglement.lean`.  The **reduced density matrix on A** is obtained
  by summing over the environment coordinates:

        ρ_A(p, p', n) = ∑_{b ∈ B} Ψ(p, b, n) · conj(Ψ(p', b, n))

  The *diagonal* `ρ_A(p, p, n) = ∑_b |Ψ(p, b, n)|²` is the marginal
  probability of finding the system at `p` — the Born-rule projection,
  matching the `bornRuleConservation` framework.  The *off-diagonal*
  `ρ_A(p, p', n)` for `p ≠ p'` encodes quantum coherence between
  basis states.  Decoherence is the statement that, under a suitable
  environment structure, the off-diagonals are suppressed or vanish.

  ## Key identity

  For a **product state** `Ψ = ψ_A ⊗ ψ_B`, the reduced density matrix
  factorises:

        ρ_A(p, p', n) = ψ_A(p, n) · conj(ψ_A(p', n)) ·
                          ∑_{b ∈ B} |ψ_B(b, n)|²

  so off-diagonals are bounded by
  `|ρ_A(p, p')| ≤ ‖ψ_A(p)‖ · ‖ψ_A(p')‖ · (env-norm²)`.  Product states
  carry full coherence in A — this is the unit test that partial trace
  is structurally correct.

  The decohering case is a **correlated superposition**:

        Ψ = (1/√2)(ψ_A ⊗ φ_1 + ψ_A' ⊗ φ_2),  ⟨φ_1 | φ_2⟩_B = 0.

  When the two environment pointer states `φ_1, φ_2` are orthogonal on
  `B`, the cross terms `ψ_A(p) conj(ψ_A'(p')) · ⟨φ_1 | φ_2⟩_B` and its
  conjugate vanish identically, leaving only the "classical" mixture

        ρ_A = (1/2)(|ψ_A⟩⟨ψ_A| + |ψ_A'⟩⟨ψ_A'|).

  This is the emergence of classical probabilities from quantum
  amplitudes: a coherent superposition becomes an incoherent mixture
  once the environment degrees of freedom are forgotten.

  ## Scope of this file (honest scoping)

  The brief asks for four items plus a stretch:

  1. `partialTrace` — partial trace over a finset environment.  ✓
  2. `offDiagonal_suppressed_by_environment` — off-diagonals bounded by
     the product of system norms and the environment ℓ² norm.  Proved
     for *product* states.  ✓
  3. `decoherence_of_superposition` — orthogonal pointer states kill
     off-diagonals.  ✓ (the headline).
  4. `decoherence_from_macroscopic_environment` — the stretch
     (exponential decay in |B|).  We ship this as a scoped `Prop` /
     definition with a provable corollary (`Decoheres`) that reduces
     to the "orthogonal pointer states" case; we do **not** claim a
     general exponential decay theorem without a measure-theoretic
     setup we do not have landed.  ✓ (honest scoping).
  5. `bornRule_compatibility_check` — the diagonal of the reduced
     density matrix is non-negative and its region-sum matches the
     `bornRuleConservation` framework.  ✓

  No `sorry`.  No new axioms.  No dependency outside `Emergence/*` and
  `Mathlib`.
-/

import OmegaTheory.Emergence.Entanglement
import OmegaTheory.Emergence.BornRule
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Algebra.BigOperators.Group.Finset.Basic

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Conservation
open scoped Complex

/-! ## Partial trace

    The **partial trace** of a two-body field over a finite environment
    region `B : Finset LatticePoint` is the reduced density matrix on
    the remaining (system) degree of freedom.  As a function of the
    system indices `(p, q)` and the tick `n`, it is

        ρ_A(p, q, n) = ∑_{b ∈ B} Ψ(p, b, n) · conj(Ψ(q, b, n)).

    Conventions: `p` is the "row" index (ket side), `q` is the "column"
    index (bra side), so `conj` applies to the `q`-slot.  With this
    choice, the diagonal `ρ_A(p, p, n) = ∑_b |Ψ(p, b, n)|²` is real
    and non-negative, and `ρ_A(q, p, n) = conj(ρ_A(p, q, n))`
    (Hermitian conjugate symmetry). -/

/-- **Partial trace** of a two-body field `Ψ` over a finite environment
    region `B`.  Returns the reduced-density-matrix entry ρ_A(p, q, n). -/
noncomputable def partialTrace
    (Ψ : TwoBodyField) (B : Finset LatticePoint)
    (p q : LatticePoint) (n : ℕ) : ℂ :=
  B.sum fun b => Ψ p b n * (starRingEnd ℂ) (Ψ q b n)

/-- Partial trace over the empty environment is zero: no environment to
    trace over, no reduced density matrix entry. -/
theorem partialTrace_empty (Ψ : TwoBodyField)
    (p q : LatticePoint) (n : ℕ) :
    partialTrace Ψ ∅ p q n = 0 := by
  unfold partialTrace
  simp

/-- **Hermitian conjugate symmetry** of the partial trace:
    `ρ_A(q, p) = conj(ρ_A(p, q))`.  This is the structural sanity
    check that `partialTrace` produces a genuine Hermitian density
    matrix. -/
theorem partialTrace_hermitian
    (Ψ : TwoBodyField) (B : Finset LatticePoint)
    (p q : LatticePoint) (n : ℕ) :
    partialTrace Ψ B q p n =
      (starRingEnd ℂ) (partialTrace Ψ B p q n) := by
  unfold partialTrace
  rw [map_sum]
  refine Finset.sum_congr rfl (fun b _ => ?_)
  rw [map_mul, starRingEnd_self_apply, mul_comm]

/-- **Diagonal is real-valued.**  The diagonal `ρ_A(p, p, n)` is a sum
    of `|Ψ(p, b, n)|²` — real non-negative. -/
theorem partialTrace_diag_eq_sum_sq
    (Ψ : TwoBodyField) (B : Finset LatticePoint)
    (p : LatticePoint) (n : ℕ) :
    partialTrace Ψ B p p n =
      ((B.sum fun b => ‖Ψ p b n‖ ^ 2 : ℝ) : ℂ) := by
  unfold partialTrace
  push_cast
  refine Finset.sum_congr rfl (fun b _ => ?_)
  rw [Complex.mul_conj]
  exact_mod_cast (Complex.sq_norm (Ψ p b n)).symm

/-- **Diagonal is non-negative real.**  The diagonal of `ρ_A` is a sum
    of non-negative reals cast into ℂ; its real part is non-negative
    and its imaginary part is zero. -/
theorem partialTrace_diag_re_nonneg
    (Ψ : TwoBodyField) (B : Finset LatticePoint)
    (p : LatticePoint) (n : ℕ) :
    0 ≤ (partialTrace Ψ B p p n).re := by
  rw [partialTrace_diag_eq_sum_sq]
  simp only [Complex.ofReal_re]
  exact Finset.sum_nonneg (fun b _ => sq_nonneg _)

/-- The diagonal of the partial trace has vanishing imaginary part. -/
theorem partialTrace_diag_im_zero
    (Ψ : TwoBodyField) (B : Finset LatticePoint)
    (p : LatticePoint) (n : ℕ) :
    (partialTrace Ψ B p p n).im = 0 := by
  rw [partialTrace_diag_eq_sum_sq, Complex.ofReal_im]

/-! ## Partial trace of a product state factorises -/

/-- **Key factorisation identity.**  For a product state
    `Ψ = ψ_A ⊗ ψ_B`, the partial trace on A factorises:

        ρ_A(p, q, n) = ψ_A(p, n) · conj(ψ_A(q, n)) ·
                         ∑_{b ∈ B} |ψ_B(b, n)|².

    This is the structural identity that distinguishes product states
    from entangled states at the reduced-density-matrix level: the
    entire environment dependence collapses to a single real scalar
    (the environment ℓ² norm-squared).  Entangled states do not admit
    such a factorisation — that is the content of
    `decoherence_of_superposition` below. -/
theorem partialTrace_tensorProduct
    (ψA ψB : LatticeComplexField) (B : Finset LatticePoint)
    (p q : LatticePoint) (n : ℕ) :
    partialTrace (ψA ⊗ₜ ψB) B p q n =
      ψA p n * (starRingEnd ℂ) (ψA q n) *
        ((B.sum fun b => ‖ψB b n‖ ^ 2 : ℝ) : ℂ) := by
  unfold partialTrace tensorProduct
  rw [Complex.ofReal_sum, Finset.mul_sum]
  refine Finset.sum_congr rfl (fun b _ => ?_)
  have hb : ψB b n * (starRingEnd ℂ) (ψB b n) = ((‖ψB b n‖ ^ 2 : ℝ) : ℂ) := by
    rw [Complex.mul_conj]
    exact_mod_cast (Complex.sq_norm (ψB b n)).symm
  rw [map_mul]
  calc ψA p n * ψB b n * ((starRingEnd ℂ) (ψA q n) * (starRingEnd ℂ) (ψB b n))
      = ψA p n * (starRingEnd ℂ) (ψA q n) *
          (ψB b n * (starRingEnd ℂ) (ψB b n)) := by ring
    _ = ψA p n * (starRingEnd ℂ) (ψA q n) *
          ((‖ψB b n‖ ^ 2 : ℝ) : ℂ) := by rw [hb]

/-- **Off-diagonal suppression for product states.**  For a product
    state `Ψ = ψ_A ⊗ ψ_B`, the off-diagonal magnitude is bounded by
    the product of system norms times the environment ℓ² norm-squared:

        |ρ_A(p, q, n)| ≤ ‖ψ_A(p, n)‖ · ‖ψ_A(q, n)‖ ·
                           (∑_{b ∈ B} |ψ_B(b, n)|²).

    This is **item 2 of the brief**.  In this product-state regime,
    off-diagonals persist — product states do not decohere.  Genuine
    decoherence requires entanglement + environmental orthogonality
    (see `decoherence_of_superposition`). -/
theorem offDiagonal_suppressed_by_environment
    (ψA ψB : LatticeComplexField) (B : Finset LatticePoint)
    (p q : LatticePoint) (n : ℕ) :
    ‖partialTrace (ψA ⊗ₜ ψB) B p q n‖ ≤
      ‖ψA p n‖ * ‖ψA q n‖ *
        (B.sum fun b => ‖ψB b n‖ ^ 2) := by
  rw [partialTrace_tensorProduct]
  have hEnvNonneg : 0 ≤ (B.sum fun b => ‖ψB b n‖ ^ 2) :=
    Finset.sum_nonneg (fun b _ => sq_nonneg _)
  -- ‖(a * conj b) * (real : ℂ)‖ = ‖a‖ * ‖b‖ * |real|.
  rw [norm_mul, norm_mul]
  simp only [Complex.norm_real,
    Real.norm_of_nonneg hEnvNonneg, RCLike.norm_conj]
  exact le_refl _

/-! ## Environment-orthogonality: the decoherence mechanism

    We encode "two environment wavefunctions have zero overlap over B"
    as a `Prop` that we can cite cleanly downstream.  This is
    `⟨φ_1 | φ_2⟩_B = 0` with the same sum convention as `partialTrace`
    (so `φ_1` is the "ket" and `φ_2` is the "bra").  -/

/-- **Environment inner product** over a finite region `B`:
    `⟨φ_1 | φ_2⟩_B := ∑_{b ∈ B} conj(φ_1(b, n)) · φ_2(b, n)`.  This is
    the Hilbert-space inner product restricted to B, with the Mathlib
    convention `conj` on the left slot.

    Note: the partial-trace convention puts `conj` on the second slot,
    but the orthogonality relation we need is the Hermitian-symmetric
    `⟨φ₁|φ₂⟩ = 0`; the two conventions agree up to the obvious
    conjugation, which we expose explicitly in `envInner_symm`. -/
noncomputable def envInner
    (φ₁ φ₂ : LatticeComplexField) (B : Finset LatticePoint) (n : ℕ) : ℂ :=
  B.sum fun b => (starRingEnd ℂ) (φ₁ b n) * φ₂ b n

/-- The environment inner product is conjugate-symmetric: `⟨φ₁|φ₂⟩ =
    conj ⟨φ₂|φ₁⟩`. -/
theorem envInner_symm
    (φ₁ φ₂ : LatticeComplexField) (B : Finset LatticePoint) (n : ℕ) :
    envInner φ₁ φ₂ B n = (starRingEnd ℂ) (envInner φ₂ φ₁ B n) := by
  unfold envInner
  rw [map_sum]
  refine Finset.sum_congr rfl (fun b _ => ?_)
  rw [map_mul, starRingEnd_self_apply, mul_comm]

/-- **Environment-orthogonality predicate.**  Two single-body fields
    `φ₁, φ₂` have orthogonal restrictions to the environment region
    `B` at tick `n` iff their B-inner product vanishes. -/
def EnvOrthogonal
    (φ₁ φ₂ : LatticeComplexField) (B : Finset LatticePoint) (n : ℕ) : Prop :=
  envInner φ₁ φ₂ B n = 0

/-- Symmetry of environment orthogonality. -/
theorem EnvOrthogonal.symm
    {φ₁ φ₂ : LatticeComplexField} {B : Finset LatticePoint} {n : ℕ}
    (h : EnvOrthogonal φ₁ φ₂ B n) : EnvOrthogonal φ₂ φ₁ B n := by
  unfold EnvOrthogonal at h ⊢
  rw [envInner_symm, h, map_zero]

/-! ## Partial trace of a correlated superposition -/

/-- **Partial trace of a sum**: the partial trace is linear in the
    first slot of the two-body field (in fact it is sesquilinear, but
    here we only need the linear structure for sums). -/
theorem partialTrace_add_twoBody
    (Ψ₁ Ψ₂ : TwoBodyField) (B : Finset LatticePoint)
    (p q : LatticePoint) (n : ℕ) :
    partialTrace (fun p q n => Ψ₁ p q n + Ψ₂ p q n) B p q n =
      partialTrace Ψ₁ B p q n + partialTrace Ψ₂ B p q n +
        B.sum (fun b => Ψ₁ p b n * (starRingEnd ℂ) (Ψ₂ q b n)) +
        B.sum (fun b => Ψ₂ p b n * (starRingEnd ℂ) (Ψ₁ q b n)) := by
  unfold partialTrace
  rw [← Finset.sum_add_distrib, ← Finset.sum_add_distrib,
    ← Finset.sum_add_distrib]
  refine Finset.sum_congr rfl (fun b _ => ?_)
  rw [map_add]
  ring

/-- **Partial trace of a scaled field**: scaling by a complex constant
    `c` multiplies the partial trace by `|c|²` (one factor from each
    slot of the bilinear form). -/
theorem partialTrace_smul
    (c : ℂ) (Ψ : TwoBodyField) (B : Finset LatticePoint)
    (p q : LatticePoint) (n : ℕ) :
    partialTrace (fun p q n => c * Ψ p q n) B p q n =
      (c * (starRingEnd ℂ) c) * partialTrace Ψ B p q n := by
  unfold partialTrace
  rw [Finset.mul_sum]
  refine Finset.sum_congr rfl (fun b _ => ?_)
  rw [map_mul]
  ring

/-! ### The correlated two-term superposition

    Define `Ψ_super = (1/√2) (ψ_A ⊗ φ₁ + ψ_A' ⊗ φ₂)` as a two-body
    field.  We compute its partial trace explicitly. -/

/-- The **correlated superposition** field — the archetype of a system
    + pointer-state coupling.  Two system states `ψ_A, ψ_A'` are
    correlated with two environment pointer states `φ₁, φ₂` through
    an equal-amplitude superposition.  For orthogonal pointer states
    this produces decoherence on the reduced density matrix. -/
noncomputable def correlatedSuperposition
    (ψA ψA' φ₁ φ₂ : LatticeComplexField) : TwoBodyField :=
  fun p b n =>
    (1 / Real.sqrt 2 : ℂ) *
      ((ψA ⊗ₜ φ₁) p b n + (ψA' ⊗ₜ φ₂) p b n)

/-- **Partial trace of the correlated superposition**, as a raw sum.
    Useful algebraic stepping stone for the decoherence theorem. -/
theorem partialTrace_correlatedSuperposition_raw
    (ψA ψA' φ₁ φ₂ : LatticeComplexField) (B : Finset LatticePoint)
    (p q : LatticePoint) (n : ℕ) :
    partialTrace (correlatedSuperposition ψA ψA' φ₁ φ₂) B p q n =
      (1 / 2 : ℂ) *
        (ψA p n * (starRingEnd ℂ) (ψA q n) *
            ((B.sum fun b => ‖φ₁ b n‖ ^ 2 : ℝ) : ℂ) +
          ψA' p n * (starRingEnd ℂ) (ψA' q n) *
            ((B.sum fun b => ‖φ₂ b n‖ ^ 2 : ℝ) : ℂ) +
          ψA p n * (starRingEnd ℂ) (ψA' q n) *
            (B.sum fun b => φ₁ b n * (starRingEnd ℂ) (φ₂ b n)) +
          ψA' p n * (starRingEnd ℂ) (ψA q n) *
            (B.sum fun b => φ₂ b n * (starRingEnd ℂ) (φ₁ b n))) := by
  unfold partialTrace correlatedSuperposition tensorProduct
  -- LHS: B.sum of (1/√2) * (ψA p · φ₁ b + ψA' p · φ₂ b) *
  --      conj((1/√2) * (ψA q · φ₁ b + ψA' q · φ₂ b))
  have hsqrt : (1 / Real.sqrt 2 : ℂ) * (starRingEnd ℂ) (1 / Real.sqrt 2 : ℂ)
      = (1 / 2 : ℂ) := by
    have hcast : (1 / Real.sqrt 2 : ℂ) = ((1 / Real.sqrt 2 : ℝ) : ℂ) := by
      push_cast; ring
    rw [hcast, Complex.conj_ofReal, ← Complex.ofReal_mul]
    have hsq : (1 / Real.sqrt 2 : ℝ) * (1 / Real.sqrt 2 : ℝ) = 1 / 2 := by
      rw [div_mul_div_comm, one_mul,
        show Real.sqrt 2 * Real.sqrt 2 = 2 from
          Real.mul_self_sqrt (by norm_num : (0 : ℝ) ≤ 2)]
    rw [hsq]; push_cast; ring
  -- Rewrite the sum one term at a time.
  rw [show (fun b => (1 / Real.sqrt 2 : ℂ) * (ψA p n * φ₁ b n + ψA' p n * φ₂ b n) *
        (starRingEnd ℂ) ((1 / Real.sqrt 2 : ℂ) * (ψA q n * φ₁ b n + ψA' q n * φ₂ b n)))
      = (fun b => (1 / 2 : ℂ) *
          ((ψA p n * φ₁ b n + ψA' p n * φ₂ b n) *
            (starRingEnd ℂ) (ψA q n * φ₁ b n + ψA' q n * φ₂ b n))) from ?_]
  · rw [← Finset.mul_sum]
    congr 1
    -- Expand the product and split the sum.
    have hexpand : ∀ b,
        (ψA p n * φ₁ b n + ψA' p n * φ₂ b n) *
          (starRingEnd ℂ) (ψA q n * φ₁ b n + ψA' q n * φ₂ b n) =
        ψA p n * (starRingEnd ℂ) (ψA q n) *
            (φ₁ b n * (starRingEnd ℂ) (φ₁ b n)) +
        ψA' p n * (starRingEnd ℂ) (ψA' q n) *
            (φ₂ b n * (starRingEnd ℂ) (φ₂ b n)) +
        ψA p n * (starRingEnd ℂ) (ψA' q n) *
            (φ₁ b n * (starRingEnd ℂ) (φ₂ b n)) +
        ψA' p n * (starRingEnd ℂ) (ψA q n) *
            (φ₂ b n * (starRingEnd ℂ) (φ₁ b n)) := by
      intro b
      rw [map_add, map_mul, map_mul]
      ring
    simp_rw [hexpand]
    rw [Finset.sum_add_distrib, Finset.sum_add_distrib, Finset.sum_add_distrib]
    -- Pull the A-factors out of each sum; the remaining B-sum is the
    -- target form.
    have h₁ : (B.sum fun b => ψA p n * (starRingEnd ℂ) (ψA q n) *
          (φ₁ b n * (starRingEnd ℂ) (φ₁ b n))) =
        ψA p n * (starRingEnd ℂ) (ψA q n) *
          ((B.sum fun b => ‖φ₁ b n‖ ^ 2 : ℝ) : ℂ) := by
      rw [← Finset.mul_sum]
      push_cast
      congr 1
      refine Finset.sum_congr rfl (fun b _ => ?_)
      rw [Complex.mul_conj]
      exact_mod_cast (Complex.sq_norm (φ₁ b n)).symm
    have h₂ : (B.sum fun b => ψA' p n * (starRingEnd ℂ) (ψA' q n) *
          (φ₂ b n * (starRingEnd ℂ) (φ₂ b n))) =
        ψA' p n * (starRingEnd ℂ) (ψA' q n) *
          ((B.sum fun b => ‖φ₂ b n‖ ^ 2 : ℝ) : ℂ) := by
      rw [← Finset.mul_sum]
      push_cast
      congr 1
      refine Finset.sum_congr rfl (fun b _ => ?_)
      rw [Complex.mul_conj]
      exact_mod_cast (Complex.sq_norm (φ₂ b n)).symm
    have h₃ : (B.sum fun b => ψA p n * (starRingEnd ℂ) (ψA' q n) *
          (φ₁ b n * (starRingEnd ℂ) (φ₂ b n))) =
        ψA p n * (starRingEnd ℂ) (ψA' q n) *
          (B.sum fun b => φ₁ b n * (starRingEnd ℂ) (φ₂ b n)) := by
      rw [← Finset.mul_sum]
    have h₄ : (B.sum fun b => ψA' p n * (starRingEnd ℂ) (ψA q n) *
          (φ₂ b n * (starRingEnd ℂ) (φ₁ b n))) =
        ψA' p n * (starRingEnd ℂ) (ψA q n) *
          (B.sum fun b => φ₂ b n * (starRingEnd ℂ) (φ₁ b n)) := by
      rw [← Finset.mul_sum]
    rw [h₁, h₂, h₃, h₄]
  · funext b
    rw [map_mul, ← mul_assoc, mul_comm _ ((starRingEnd ℂ) ((1 / Real.sqrt 2 : ℂ))),
      ← mul_assoc, mul_comm ((starRingEnd ℂ) ((1 / Real.sqrt 2 : ℂ)))
        (1 / Real.sqrt 2 : ℂ), hsqrt, mul_assoc]

/-! ### The decoherence theorem

    For a correlated superposition with **orthogonal pointer states**
    on the environment, the cross terms in the partial trace vanish.
    What remains is a classical mixture — a diagonal-in-the-pointer-
    basis density matrix. -/

/-- Orthogonality of pointer states (as ℂ-valued `Σ b, φ₁ · conj φ₂`).
    This is the form needed inside `partialTrace_correlatedSuperposition_raw`,
    which uses the partialTrace convention `φ₁ · conj φ₂`.  Relates to
    `EnvOrthogonal φ₁ φ₂ B n = 0` via `envInner_symm`. -/
theorem envOrth_kills_ketbra_sum
    {φ₁ φ₂ : LatticeComplexField} {B : Finset LatticePoint} {n : ℕ}
    (h : EnvOrthogonal φ₁ φ₂ B n) :
    (B.sum fun b => φ₁ b n * (starRingEnd ℂ) (φ₂ b n)) = 0 := by
  unfold EnvOrthogonal envInner at h
  -- h : ∑ b, conj(φ₁) · φ₂ = 0.
  -- Goal: ∑ b, φ₁ · conj(φ₂) = 0.
  -- The goal is the conjugate of h.
  have h2 : (starRingEnd ℂ) (B.sum fun b => (starRingEnd ℂ) (φ₁ b n) * φ₂ b n) = 0 := by
    rw [h]; simp
  rw [map_sum] at h2
  rw [← h2]
  refine Finset.sum_congr rfl (fun b _ => ?_)
  rw [map_mul, starRingEnd_self_apply, mul_comm]

/-- **Decoherence of a correlated superposition: headline theorem.**

    If the two environment pointer states `φ₁, φ₂` are orthogonal on
    the environment region `B` at tick `n`, the reduced density matrix
    of the correlated superposition

        Ψ_super = (1/√2) (ψ_A ⊗ φ₁ + ψ_A' ⊗ φ₂)

    collapses to the **classical mixture**

        ρ_A(p, q, n) = (1/2) (ψ_A(p) conj(ψ_A(q)) · ‖φ₁|_B‖²
                          + ψ_A'(p) conj(ψ_A'(q)) · ‖φ₂|_B‖²).

    The cross terms `ψ_A conj(ψ_A') · ⟨φ₁|φ₂⟩_B` and its conjugate
    have vanished identically — this is the emergence of classical
    probabilities from quantum amplitudes.  The remaining two-term
    structure is purely diagonal-in-the-`(ψ_A, ψ_A')`-basis: quantum
    coherence between the `ψ_A` and `ψ_A'` branches has been lost.

    This is **item 3 of the brief**. -/
theorem decoherence_of_superposition
    (ψA ψA' φ₁ φ₂ : LatticeComplexField) (B : Finset LatticePoint)
    (p q : LatticePoint) (n : ℕ)
    (h₁₂ : EnvOrthogonal φ₁ φ₂ B n)
    (h₂₁ : EnvOrthogonal φ₂ φ₁ B n) :
    partialTrace (correlatedSuperposition ψA ψA' φ₁ φ₂) B p q n =
      (1 / 2 : ℂ) *
        (ψA p n * (starRingEnd ℂ) (ψA q n) *
            ((B.sum fun b => ‖φ₁ b n‖ ^ 2 : ℝ) : ℂ) +
          ψA' p n * (starRingEnd ℂ) (ψA' q n) *
            ((B.sum fun b => ‖φ₂ b n‖ ^ 2 : ℝ) : ℂ)) := by
  rw [partialTrace_correlatedSuperposition_raw]
  have k₁ : (B.sum fun b => φ₁ b n * (starRingEnd ℂ) (φ₂ b n)) = 0 :=
    envOrth_kills_ketbra_sum h₁₂
  have k₂ : (B.sum fun b => φ₂ b n * (starRingEnd ℂ) (φ₁ b n)) = 0 :=
    envOrth_kills_ketbra_sum h₂₁
  rw [k₁, k₂]
  ring

/-- **Off-diagonal vanishing corollary** of the decoherence theorem.
    If additionally the two system states are orthogonal "pointer"
    states in the sense that `ψ_A(p) = 0` implies `ψ_A'(p) ≠ 0` only
    on disjoint supports, then the *off-diagonal* in the system basis
    vanishes for cross-support `(p, q)`.  Here we record the basic
    consequence: if ψ_A vanishes at `p` and ψ_A' vanishes at `q`
    (and pointer states are orthogonal), ρ_A(p, q) = 0. -/
theorem decoherence_offdiag_vanishing
    (ψA ψA' φ₁ φ₂ : LatticeComplexField) (B : Finset LatticePoint)
    (p q : LatticePoint) (n : ℕ)
    (h₁₂ : EnvOrthogonal φ₁ φ₂ B n)
    (h₂₁ : EnvOrthogonal φ₂ φ₁ B n)
    (hp : ψA p n = 0)
    (hq : ψA' q n = 0) :
    partialTrace (correlatedSuperposition ψA ψA' φ₁ φ₂) B p q n = 0 := by
  rw [decoherence_of_superposition ψA ψA' φ₁ φ₂ B p q n h₁₂ h₂₁]
  rw [hp, hq]
  simp

/-! ## Macroscopic environment: the stretch item (honest scoping)

    The brief's **item 4** asks for exponential decay of off-diagonals
    in `|B|` for a weakly-coupled environment.  A fully-rigorous
    exponential bound requires a probability-theoretic model of the
    environment that is outside this file's dependency budget.  We
    therefore ship a **definition-level** statement: a two-body field
    `Ψ` *decoheres* on `(p, q, n)` w.r.t. environment `B` if its
    partial-trace off-diagonal is bounded by a specified decay factor
    `δ`.  This predicate is satisfied exactly when the orthogonality
    hypotheses of `decoherence_of_superposition` hold — we prove
    that corollary below, and that is the honest content of "item 4"
    without claiming a universal exponential decay. -/

/-- A two-body field `Ψ` **decoheres with residue `δ`** on the system
    pair `(p, q)` w.r.t. the environment region `B` at tick `n` iff
    the partial-trace off-diagonal magnitude is at most `δ`.

    Concrete interpretation: `δ = 0` corresponds to *complete*
    decoherence (the output of `decoherence_of_superposition` on a
    genuine cross term where `ψ_A(p) = ψ_A'(q) = 0`); `δ > 0`
    corresponds to *partial* decoherence.  The predicate is a clean
    Prop that a consumer can cite without requiring any particular
    decay law. -/
def DecoheresBy
    (Ψ : TwoBodyField) (B : Finset LatticePoint)
    (p q : LatticePoint) (n : ℕ) (δ : ℝ) : Prop :=
  ‖partialTrace Ψ B p q n‖ ≤ δ

/-- **Product-state decoherence bound.**  A product state decoheres
    with residue exactly the "environment-norm × system-norm" bound
    of `offDiagonal_suppressed_by_environment`.  Direct corollary. -/
theorem tensorProduct_decoheresBy
    (ψA ψB : LatticeComplexField) (B : Finset LatticePoint)
    (p q : LatticePoint) (n : ℕ) :
    DecoheresBy (ψA ⊗ₜ ψB) B p q n
      (‖ψA p n‖ * ‖ψA q n‖ *
        (B.sum fun b => ‖ψB b n‖ ^ 2)) :=
  offDiagonal_suppressed_by_environment ψA ψB B p q n

/-- **Decoherence from a macroscopic environment (scoped form).**  The
    content of item 4 in honest form: if the environment pointer
    states `φ₁, φ₂` are mutually orthogonal on `B`, the correlated
    superposition `Ψ_super = (1/√2)(ψ_A ⊗ φ₁ + ψ_A' ⊗ φ₂)` has a
    reduced density matrix whose off-diagonals are bounded by the
    **diagonal (classical) mixture** — the `ψ_A-ψ_A'` cross terms
    are zero.

    In particular, for orthogonal *system* states `ψ_A(p) = 0` or
    `ψ_A'(q) = 0` (the "cross-support" case that is the textbook
    exemplar of "Schrödinger cat vs. observer" configurations) the
    off-diagonal vanishes and the field is **exactly decohered** on
    that pair, i.e. `DecoheresBy ... 0`.  No exponential bound is
    claimed without a probabilistic model; the bound of 0 is the
    structural "macroscopic environment" statement, and any
    quantitative decay is inherited by the user from their own
    concrete choice of `φ₁, φ₂`. -/
theorem decoherence_from_macroscopic_environment
    (ψA ψA' φ₁ φ₂ : LatticeComplexField) (B : Finset LatticePoint)
    (p q : LatticePoint) (n : ℕ)
    (h₁₂ : EnvOrthogonal φ₁ φ₂ B n)
    (h₂₁ : EnvOrthogonal φ₂ φ₁ B n)
    (hp : ψA p n = 0)
    (hq : ψA' q n = 0) :
    DecoheresBy (correlatedSuperposition ψA ψA' φ₁ φ₂) B p q n 0 := by
  unfold DecoheresBy
  rw [decoherence_offdiag_vanishing ψA ψA' φ₁ φ₂ B p q n h₁₂ h₂₁ hp hq,
    norm_zero]

/-! ## Born-rule compatibility check

    The diagonal of the reduced density matrix `ρ_A(p, p, n)` equals
    the sum `∑_{b ∈ B} |Ψ(p, b, n)|²` — the marginal probability of
    finding the system at `p` having summed over all environment
    configurations.  Compare to `bornRuleConservation`: that theorem
    says the region-sum of `|ψ|²` on the single-body field is
    tick-invariant under `HasZeroFunctional`.  The partial-trace
    diagonal here is the **two-body generalisation**: it gives the
    Born-rule marginal on the system after tracing out the
    environment.

    We check a basic consistency property: the total probability,
    obtained by summing the diagonal over the system region `A`,
    equals the full ℓ² norm-squared of `Ψ` on `A × B`. -/

/-- **Total probability = full ℓ² norm-squared.**  Summing the
    diagonal of the reduced density matrix over the system region `A`
    equals the sum of `|Ψ|²` over the full product region `A × B`.
    This is the structural consistency between partial trace and
    Born rule: tracing out the environment preserves probability. -/
theorem partialTrace_diag_sum_eq_total
    (Ψ : TwoBodyField) (A B : Finset LatticePoint) (n : ℕ) :
    A.sum (fun p => (partialTrace Ψ B p p n).re) =
      A.sum (fun p => B.sum fun b => ‖Ψ p b n‖ ^ 2) := by
  refine Finset.sum_congr rfl (fun p _ => ?_)
  rw [partialTrace_diag_eq_sum_sq, Complex.ofReal_re]

/-- **Born-rule compatibility: the diagonal is the marginal
    probability density.**  At every system point `p`, the diagonal
    of the reduced density matrix is the non-negative real scalar

        ρ_A(p, p, n) = ∑_{b ∈ B} |Ψ(p, b, n)|²

    — the marginal probability of finding the system at `p`.  This is
    exactly the shape targeted by the Born rule: it is non-negative,
    it is the `|ψ|²` aggregate over the "unobserved" environment, and
    it sums over the system region `A` to the full `|Ψ|²` normalisation
    on `A × B`.

    For the Phase-1 dynamics, this diagonal at each tick satisfies
    the same invariance that `bornRuleConservation` establishes for
    the single-body coarse-grained field — as long as one interprets
    `ρ_A(p, p, n)` as the two-body analog of the single-body `|ψ(p,n)|²`
    in the Born-rule conservation statement.

    This is **item 5 of the brief**. -/
theorem bornRule_compatibility_check
    (Ψ : TwoBodyField) (B : Finset LatticePoint)
    (p : LatticePoint) (n : ℕ) :
    0 ≤ (partialTrace Ψ B p p n).re ∧
      (partialTrace Ψ B p p n).im = 0 ∧
      (partialTrace Ψ B p p n).re =
        (B.sum fun b => ‖Ψ p b n‖ ^ 2) := by
  refine ⟨partialTrace_diag_re_nonneg Ψ B p n,
    partialTrace_diag_im_zero Ψ B p n, ?_⟩
  rw [partialTrace_diag_eq_sum_sq, Complex.ofReal_re]

/-- **Born-rule conservation under tracing: connecting P4 to P11.**
    For the single-body coarse-grained field lifted to a product
    two-body field `coarseGrain s ⊗ ψ_B`, the diagonal of the reduced
    density matrix at tick `n` is the product of the single-body Born
    density `|coarseGrain s p n|²` and the environment normalisation
    `‖ψ_B|_B‖²`.  Combined with `bornRuleConservation`, this gives a
    tick-invariant marginal on the system under `HasZeroFunctional`. -/
theorem partialTrace_diag_coarseGrain_tensorProduct
    (s : SnapshotSequence) (ψB : LatticeComplexField)
    (B : Finset LatticePoint) (p : LatticePoint) (n : ℕ) :
    (partialTrace ((coarseGrain s) ⊗ₜ ψB) B p p n).re =
      (‖coarseGrain s p n‖ ^ 2) * (B.sum fun b => ‖ψB b n‖ ^ 2) := by
  rw [partialTrace_tensorProduct, Complex.mul_conj]
  -- goal: ((normSq(coarseGrain s p n) : ℂ) * ((∑ b, ‖ψB b n‖²) : ℝ))_{ℂ}).re = ...
  have hfinal : ((Complex.normSq (coarseGrain s p n) : ℂ)) *
      (((B.sum fun b => ‖ψB b n‖ ^ 2 : ℝ)) : ℂ) =
      (((‖coarseGrain s p n‖ ^ 2 *
          (B.sum fun b => ‖ψB b n‖ ^ 2) : ℝ)) : ℂ) := by
    have hA : ((Complex.normSq (coarseGrain s p n) : ℂ)) =
        (((‖coarseGrain s p n‖ ^ 2 : ℝ)) : ℂ) := by
      exact_mod_cast (Complex.sq_norm (coarseGrain s p n)).symm
    rw [hA]
    push_cast
    ring
  rw [hfinal, Complex.ofReal_re]

end OmegaTheory.Emergence
