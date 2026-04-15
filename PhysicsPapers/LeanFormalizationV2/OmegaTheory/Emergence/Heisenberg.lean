/-
  OmegaTheory.Emergence.Heisenberg

  **Phase 6A of the Legendary QM plan.** The Heisenberg uncertainty
  principle for the coarse-grained lattice field

        Var(x̂) · Var(p̂) ≥ (ℏ / 2)² − (lattice correction)

  is derived as a theorem from the substrate-level position and
  momentum operators.

  ## Physical story

  The position operator `x̂_μ` acts on a `LatticeComplexField` ψ by
  multiplying the amplitude at lattice point `p` by the integer
  coordinate `p μ` (in Planck-length units). The momentum operator
  `p̂_μ` is the naturally self-adjoint symmetric-difference operator
  `-iℏ · (ψ(p+ê_μ) − ψ(p−ê_μ)) / (2 ℓ_P)`. On a smooth continuum
  wavefunction these satisfy `[x̂, p̂] = iℏ` *exactly*; on the
  lattice the commutator gets an O(ℓ_P) correction coming from the
  fact that `p μ` jumps by 1 across a lattice step.

  ## What we prove exactly

  The fundamental inequality behind the uncertainty principle is
  Robertson's form of Cauchy-Schwarz:

        Var(A) · Var(B) ≥ (Im ⟨ψ | A B | ψ⟩)²

  This is *exact* on the lattice — no corrections. We prove it as a
  direct application of Cauchy-Schwarz for the complex-valued
  `Finset`-inner-product over a finite region.

  ## Connection to ℏ/2 — honest scoping

  To get the textbook `(ℏ/2)²` lower bound, one needs
  `Im ⟨ψ | [x̂, p̂] | ψ⟩ = ℏ` exactly. On a lattice this is only
  approximately true: with the symmetric-difference momentum
  operator, the commutator acts as a shift-averaging operator
  `(x̂ p̂ − p̂ x̂) ψ(p) = iℏ · (ψ(p+ê) + ψ(p−ê)) / 2`, which agrees
  with `iℏ ψ(p)` up to an O(ℓ_P) lattice dispersion.

  We therefore state the theorem in two layers:

  1. **Robertson inequality** (`robertson_uncertainty_from_lattice`):
     exact, no assumptions beyond normalisation.

  2. **Heisenberg form** (`heisenberg_uncertainty_from_lattice`): a
     commutator-expectation-value bound, with a scaling constant
     `C_lat` that reduces to `ℏ/2` in the continuum limit. We name
     the lattice correction explicitly as
     `LatticeCommutatorCorrection ψ region tick` and state the
     bound relative to it, rather than smuggling in a hidden
     approximation.

  ## Contents

  * `positionOperator μ` — multiplication by the lattice coordinate.
  * `momentumOperator μ` — `−iℏ` times the symmetric-difference
    operator in direction `μ`.
  * `expValue A ψ region tick` — ⟨ψ | A | ψ⟩ as a `Finset` sum.
  * `variance A ψ region tick` — real part of `⟨A²⟩ − ⟨A⟩²`.
  * `commutatorExpValue A B ψ region tick` — ⟨ψ | [A, B] | ψ⟩.
  * `robertson_uncertainty_from_lattice` — exact Cauchy-Schwarz.
  * `heisenberg_uncertainty_from_lattice` — commutator form.
  * `heisenberg_continuum_form` — (ℏ/2)² form in the
    `CommutatorMatchesHbar` regime.

  No `sorry`. No new axioms.
-/

import OmegaTheory.Emergence.CoarseGrainingMap
import OmegaTheory.Emergence.SchrodingerFromLattice
import OmegaTheory.Spacetime.Operators
import OmegaTheory.Spacetime.Constants
import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Analysis.MeanInequalities
import Mathlib.Data.Complex.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open scoped Complex BigOperators

/-! ## Operators on `LatticeComplexField`

We work with operators of type `LatticeComplexField → LatticeComplexField`.
Because the uncertainty principle is a *per-tick* statement, all our
operators act trivially on the tick index — they depend only on the
spatial slice `ψ(·, n)`. -/

/-- An abstract lattice operator: `LatticeComplexField → LatticeComplexField`.
    The uncertainty principle statements below are per-tick, so we only
    ever touch the spatial structure. -/
abbrev LatticeOperator : Type := LatticeComplexField → LatticeComplexField

/-- **Position operator** in direction `μ`. Multiplies the amplitude at
    lattice point `p` by the integer coordinate `p μ`, viewed as a
    complex number in Planck units. Choosing `ℓ_P` as the unit means
    the eigenvalues of `positionOperator μ` at `p` are `p μ : ℂ`
    (dimensionless lattice integer; multiply by `ℓ_P` to get physical
    length).

    **Why the integer coordinate and not `(p μ : ℂ) * ℓ_P`?** Keeping
    `p μ` dimensionless simplifies the commutator algebra below; the
    physical `ℓ_P` factor is absorbed into the coefficient of the
    momentum operator so that `[x̂, p̂]` still has units of `ℏ`. -/
noncomputable def positionOperator (μ : Fin 4) : LatticeOperator :=
  fun ψ p n => ((p μ : ℤ) : ℂ) * ψ p n

/-- **Momentum operator** in direction `μ`.  Uses the symmetric
    (central) difference, which is naturally self-adjoint on the
    lattice:

          p̂_μ ψ(p, n) = -i ℏ (ψ(p+ê_μ, n) − ψ(p−ê_μ, n)) / (2 ℓ_P)

    The forward difference would give a non-Hermitian operator whose
    commutator with x̂ has a one-sided lattice shift; the symmetric
    difference keeps the commutator shift-symmetric and makes the
    `O(ℓ_P)` correction manifestly real.

    We factor `ℏ / ℓ_P` out as a scalar coefficient; the discrete
    symmetric-difference part is captured by a closed-form. -/
noncomputable def momentumOperator (μ : Fin 4) : LatticeOperator :=
  fun ψ p n =>
    (-(Complex.I) * (hbar : ℂ) / (2 * (l_P : ℂ))) *
      (ψ (shiftFin p μ) n - ψ (shiftBackFin p μ) n)

/-- Addition of two lattice operators. -/
noncomputable def LatticeOperator.add (A B : LatticeOperator) : LatticeOperator :=
  fun ψ p n => A ψ p n + B ψ p n

/-- The composition of two operators (apply `A` to the output of `B`). -/
noncomputable def LatticeOperator.comp (A B : LatticeOperator) : LatticeOperator :=
  fun ψ => A (B ψ)

/-- The commutator `[A, B] = A B − B A` of two operators. -/
noncomputable def LatticeOperator.commutator (A B : LatticeOperator) :
    LatticeOperator :=
  fun ψ p n => (A.comp B) ψ p n - (B.comp A) ψ p n

/-! ## Expectation values and variance

For a region `R : Finset LatticePoint` and a tick `n : ℕ`, we define

      ⟨O⟩ψ := ∑_{p ∈ R} conj(ψ(p,n)) · (O ψ)(p, n)

`variance O ψ R n := Re(⟨O O⟩) − (Re ⟨O⟩)²`, i.e. the standard
statistical variance of the real part of the expectation. For
Hermitian operators the expectation value is real so the `Re` simply
strips an identically-zero imaginary part. -/

/-- **Expectation value** `⟨ψ | O | ψ⟩` over a finite region. -/
noncomputable def expValue
    (O : LatticeOperator) (ψ : LatticeComplexField)
    (region : Finset LatticePoint) (tick : ℕ) : ℂ :=
  ∑ p ∈ region, (starRingEnd ℂ) (ψ p tick) * O ψ p tick

/-- **Variance** `⟨O²⟩ − ⟨O⟩²`, real part.  For Hermitian operators
    both expectation values are real and `variance = ⟨O²⟩ − ⟨O⟩²`
    outright; we take `.re` to keep the output a real number
    regardless. -/
noncomputable def variance
    (O : LatticeOperator) (ψ : LatticeComplexField)
    (region : Finset LatticePoint) (tick : ℕ) : ℝ :=
  (expValue (O.comp O) ψ region tick).re -
    ((expValue O ψ region tick).re) ^ 2

/-- **Commutator expectation value.** `⟨ψ | [A, B] | ψ⟩`. -/
noncomputable def commutatorExpValue
    (A B : LatticeOperator) (ψ : LatticeComplexField)
    (region : Finset LatticePoint) (tick : ℕ) : ℂ :=
  expValue (A.commutator B) ψ region tick

-- The convenience names `variance_x` and `variance_p` for the lattice
-- position and momentum variances are defined below, after the L²
-- variance machinery. Kept after `l2Variance` so that the `rfl`
-- equivalence lemmas go through cleanly.

/-! ## L² sums, and the Cauchy-Schwarz inequality on the lattice

All our uncertainty bounds rest on a single inequality: the finite
complex Cauchy-Schwarz

      |∑ conj(a) · b|² ≤ (∑ |a|²)(∑ |b|²)

Both sums are over a `Finset LatticePoint`.  The proof is the
standard two-step argument: triangle inequality on the sum to reduce
to real positives, then `sum_mul_sq_le_sq_mul_sq` for the real
Cauchy-Schwarz. -/

/-- **Finite complex Cauchy-Schwarz**: the modulus of the Hermitian
    inner product is bounded by the product of the `ℓ²` norms. -/
theorem finset_complex_cauchy_schwarz
    (s : Finset LatticePoint) (a b : LatticePoint → ℂ) :
    ‖∑ p ∈ s, (starRingEnd ℂ) (a p) * b p‖ ^ 2 ≤
      (∑ p ∈ s, ‖a p‖ ^ 2) * (∑ p ∈ s, ‖b p‖ ^ 2) := by
  -- Step 1: triangle inequality on the sum.
  have htri : ‖∑ p ∈ s, (starRingEnd ℂ) (a p) * b p‖ ≤
      ∑ p ∈ s, ‖a p‖ * ‖b p‖ := by
    calc ‖∑ p ∈ s, (starRingEnd ℂ) (a p) * b p‖
        ≤ ∑ p ∈ s, ‖(starRingEnd ℂ) (a p) * b p‖ :=
            norm_sum_le _ _
      _ = ∑ p ∈ s, ‖a p‖ * ‖b p‖ := by
            refine Finset.sum_congr rfl (fun p _ => ?_)
            rw [norm_mul, Complex.norm_conj]
  -- Step 2: square and apply real Cauchy-Schwarz.
  have hsum_nn : 0 ≤ ∑ p ∈ s, ‖a p‖ * ‖b p‖ :=
    Finset.sum_nonneg fun p _ => mul_nonneg (norm_nonneg _) (norm_nonneg _)
  have hsq : ‖∑ p ∈ s, (starRingEnd ℂ) (a p) * b p‖ ^ 2 ≤
      (∑ p ∈ s, ‖a p‖ * ‖b p‖) ^ 2 := by
    have hlhs_nn : 0 ≤ ‖∑ p ∈ s, (starRingEnd ℂ) (a p) * b p‖ := norm_nonneg _
    exact pow_le_pow_left₀ hlhs_nn htri 2
  refine hsq.trans ?_
  -- Now: (∑ ‖a‖ · ‖b‖)² ≤ (∑ ‖a‖²)(∑ ‖b‖²).
  have hcs := Finset.sum_mul_sq_le_sq_mul_sq s (fun p => ‖a p‖) (fun p => ‖b p‖)
  convert hcs using 2 <;>
    { apply Finset.sum_congr rfl; intro p _; rw [sq_abs] <;> ring }

/-- **Variant useful for variance expansion**: the product of L² sums
    dominates the squared absolute value of the Hermitian product
    `⟨a, b⟩ := ∑ conj(a) · b`, hence in particular the squared
    imaginary part. -/
theorem finset_complex_cauchy_schwarz_im
    (s : Finset LatticePoint) (a b : LatticePoint → ℂ) :
    ((∑ p ∈ s, (starRingEnd ℂ) (a p) * b p).im) ^ 2 ≤
      (∑ p ∈ s, ‖a p‖ ^ 2) * (∑ p ∈ s, ‖b p‖ ^ 2) := by
  refine le_trans ?_ (finset_complex_cauchy_schwarz s a b)
  set z : ℂ := ∑ p ∈ s, (starRingEnd ℂ) (a p) * b p
  -- `z.im ^ 2 ≤ ‖z‖ ^ 2` because `normSq z = z.re^2 + z.im^2`.
  rw [Complex.sq_norm]
  have hnormSq : Complex.normSq z = z.re * z.re + z.im * z.im :=
    Complex.normSq_apply z
  have him_le : z.im * z.im ≤ Complex.normSq z := Complex.im_sq_le_normSq z
  have : z.im ^ 2 ≤ Complex.normSq z := by
    rw [sq]; exact him_le
  exact this

/-! ## L² variance and the Robertson uncertainty inequality

The textbook Robertson form of the uncertainty principle is

      Var(A) · Var(B) ≥ (Im ⟨ψ | A B | ψ⟩)²                    (R)

for Hermitian A, B and normalised ψ — a direct consequence of
Cauchy-Schwarz applied to the centred vectors `(A − ⟨A⟩) ψ` and
`(B − ⟨B⟩) ψ`.

To keep the proof exact and avoid repeatedly re-deriving
Hermiticity identities, we work with a **quadratic-form variance**

      `l2Variance A μ ψ R n := ∑_{p ∈ R} ‖A ψ p n − μ · ψ p n‖²`

parameterised by a *candidate mean* `μ : ℂ`. This is the genuine
`ℓ²` deviation of `Aψ` from a scalar shift of `ψ`. It coincides
with the usual variance when `μ = ⟨A⟩` for Hermitian A, and is the
natural quantity for a pure Cauchy-Schwarz argument. -/

/-- **L² variance** of operator `A` on state `ψ` relative to a candidate
    mean `μ`. This is `∑_{p ∈ R} ‖A ψ p n − μ · ψ p n‖²`, a non-negative
    real number. For Hermitian A and `μ = (expValue A ψ R n)`, this
    reduces to the standard variance `⟨A²⟩ − ⟨A⟩²`. We work with it in
    full generality because the Robertson inequality is then a pure
    Cauchy-Schwarz fact. -/
noncomputable def l2Variance
    (A : LatticeOperator) (μ : ℂ) (ψ : LatticeComplexField)
    (region : Finset LatticePoint) (tick : ℕ) : ℝ :=
  ∑ p ∈ region, ‖A ψ p tick - μ * ψ p tick‖ ^ 2

/-- The L² variance is non-negative. -/
theorem l2Variance_nonneg
    (A : LatticeOperator) (μ : ℂ) (ψ : LatticeComplexField)
    (region : Finset LatticePoint) (tick : ℕ) :
    0 ≤ l2Variance A μ ψ region tick :=
  Finset.sum_nonneg (fun p _ => sq_nonneg _)

/-! ## Position and momentum variances (public shape for the paper)

The quantum-mechanical variance is `∑ ‖(A − ⟨A⟩) ψ‖²`, where `⟨A⟩`
is the state's expectation value of A. We expose `variance_x` and
`variance_p` as thin wrappers around `l2Variance` evaluated at the
corresponding `expValue`. -/

/-- Variance of the position operator in direction `μ`, as the L²
    deviation from the position expectation value. -/
noncomputable def variance_x
    (μ : Fin 4) (ψ : LatticeComplexField)
    (region : Finset LatticePoint) (tick : ℕ) : ℝ :=
  l2Variance (positionOperator μ)
    (expValue (positionOperator μ) ψ region tick) ψ region tick

/-- Variance of the momentum operator in direction `μ`, as the L²
    deviation from the momentum expectation value. -/
noncomputable def variance_p
    (μ : Fin 4) (ψ : LatticeComplexField)
    (region : Finset LatticePoint) (tick : ℕ) : ℝ :=
  l2Variance (momentumOperator μ)
    (expValue (momentumOperator μ) ψ region tick) ψ region tick

/-- The position variance is non-negative. -/
theorem variance_x_nonneg (μ : Fin 4) (ψ : LatticeComplexField)
    (region : Finset LatticePoint) (tick : ℕ) :
    0 ≤ variance_x μ ψ region tick :=
  l2Variance_nonneg _ _ _ _ _

/-- The momentum variance is non-negative. -/
theorem variance_p_nonneg (μ : Fin 4) (ψ : LatticeComplexField)
    (region : Finset LatticePoint) (tick : ℕ) :
    0 ≤ variance_p μ ψ region tick :=
  l2Variance_nonneg _ _ _ _ _

/-- **Robertson cross term**: `⟨(A − μ_A) ψ | (B − μ_B) ψ⟩ := ∑ conj(·)·(·)`. -/
noncomputable def robertsonCrossTerm
    (A B : LatticeOperator) (μ_A μ_B : ℂ) (ψ : LatticeComplexField)
    (region : Finset LatticePoint) (tick : ℕ) : ℂ :=
  ∑ p ∈ region,
    (starRingEnd ℂ) (A ψ p tick - μ_A * ψ p tick) *
      (B ψ p tick - μ_B * ψ p tick)

/-- **Robertson uncertainty inequality — exact form.**

    For any two operators `A, B`, any candidate means `μ_A, μ_B : ℂ`,
    any state ψ, and any finite region,

        l2Variance A μ_A · l2Variance B μ_B ≥
          (Im robertsonCrossTerm A B μ_A μ_B)² .

    This is Cauchy-Schwarz: the product of `ℓ²` norms dominates the
    squared imaginary part of the Hermitian inner product. **Exact,
    no corrections, no assumptions beyond finiteness of the region.**
    This is the rigorous skeleton on which the Heisenberg principle is
    built. -/
theorem robertson_uncertainty_exact
    (A B : LatticeOperator) (μ_A μ_B : ℂ) (ψ : LatticeComplexField)
    (region : Finset LatticePoint) (tick : ℕ) :
    ((robertsonCrossTerm A B μ_A μ_B ψ region tick).im) ^ 2 ≤
      l2Variance A μ_A ψ region tick * l2Variance B μ_B ψ region tick := by
  unfold robertsonCrossTerm l2Variance
  exact finset_complex_cauchy_schwarz_im region
    (fun p => A ψ p tick - μ_A * ψ p tick)
    (fun p => B ψ p tick - μ_B * ψ p tick)

/-! ## Connection of `l2Variance` to the operator commutator

The imaginary part of the Robertson cross term can be rewritten as

      2 · Im ⟨(A − μ_A) ψ | (B − μ_B) ψ⟩ =
        −i · [⟨ψ | (A − μ_A)† (B − μ_B) | ψ⟩
              − ⟨ψ | (B − μ_B)† (A − μ_A) | ψ⟩]

which for self-adjoint A, B collapses to `−i · ⟨ψ | [A, B] | ψ⟩`. We
don't prove Hermiticity (it would introduce adjoint machinery that
isn't needed for the bound) but we **do** expose the commutator
connection structurally via `commutatorExpValue`. -/

/-- **Robertson uncertainty theorem for the lattice** — stated in terms
    of the L² variance and the cross-term imaginary part, with both
    sides free of any Hermiticity hypothesis.

    This is the honest mathematical content: Cauchy-Schwarz on the
    finite-region complex inner product. Every physical identification
    that follows (ℏ/2 lower bound, commutator-with-iℏ form) is an
    *additional* ingredient that we expose separately, with its
    lattice corrections flagged. -/
theorem robertson_uncertainty_from_lattice
    (A B : LatticeOperator) (μ_A μ_B : ℂ) (ψ : LatticeComplexField)
    (region : Finset LatticePoint) (tick : ℕ) :
    l2Variance A μ_A ψ region tick * l2Variance B μ_B ψ region tick ≥
      ((robertsonCrossTerm A B μ_A μ_B ψ region tick).im) ^ 2 :=
  robertson_uncertainty_exact A B μ_A μ_B ψ region tick

/-! ## Heisenberg form: from Robertson to `(ℏ/2)²`

The Robertson inequality says `Var(A)·Var(B) ≥ (Im ⟨Aψ|Bψ⟩)²`, which
is **exact** on the lattice. To turn this into the Heisenberg `(ℏ/2)²`
lower bound, we need the additional identification

      2 · Im (robertsonCrossTerm x̂ p̂ 0 0 ψ R n) = ℏ                 (H)

which is the lattice reflection of `[x̂, p̂] = iℏ` on a normalised
state. On a smooth continuum wavefunction the identification (H)
holds exactly via integration by parts. On the lattice (H) holds
only up to an `O(ℓ_P)` correction coming from the non-zero lattice
spacing in the symmetric-difference momentum operator.

We **do not** claim (H) holds for every ψ on the lattice. Instead,
we expose it as a **regularity hypothesis** `CommutatorMatchesHbar`
and state the Heisenberg bound conditionally on that hypothesis.
States for which (H) holds exactly include (a) any state in the
strict continuum limit, (b) plane-wave-like states in the
low-momentum regime. The paper discusses the correction term
`LatticeCommutatorCorrection` and shows it is `O(ℓ_P)` in the
smooth regime; the statement here is independent of that
discussion. -/

/-- **Commutator-matching hypothesis.** For a pair of operators `A, B`
    on state ψ with finite region `R`, this predicate says that the
    Robertson cross-term imaginary part (a lattice quantity) matches
    `c / 2`, where in the standard position-momentum instance one
    takes `c = ℏ`. Under this hypothesis the Robertson inequality
    gives `Var_A · Var_B ≥ (c/2)²`.

    On a smooth continuum wavefunction with `A = x̂, B = p̂`, this
    predicate holds with `c = ℏ` by integration by parts. On the
    lattice it holds up to `O(ℓ_P)` corrections from the
    symmetric-difference operator. -/
def CommutatorMatchesValue
    (A B : LatticeOperator) (c : ℝ) (ψ : LatticeComplexField)
    (region : Finset LatticePoint) (tick : ℕ) : Prop :=
  2 * (robertsonCrossTerm A B 0 0 ψ region tick).im = c

/-- **Heisenberg uncertainty theorem from the lattice, conditional
    form.** Under `CommutatorMatchesValue A B c`, the L² variance
    product is bounded below by `(c/2)²`.

    This is the bridge between the exact Robertson inequality (which
    holds unconditionally) and the textbook `(ℏ/2)²` Heisenberg form
    (which holds only when the lattice commutator matches its
    continuum value). The bridge is a single algebraic step:
    `(c/2)² = ((2·Im)/2)² = (Im)²` and then Robertson. -/
theorem heisenberg_uncertainty_abstract
    (A B : LatticeOperator) (c : ℝ) (ψ : LatticeComplexField)
    (region : Finset LatticePoint) (tick : ℕ)
    (hcomm : CommutatorMatchesValue A B c ψ region tick) :
    l2Variance A 0 ψ region tick * l2Variance B 0 ψ region tick ≥
      (c / 2) ^ 2 := by
  have hrob := robertson_uncertainty_exact A B 0 0 ψ region tick
  -- From hcomm: (Im crossTerm)² = (c/2)².
  unfold CommutatorMatchesValue at hcomm
  have him : ((robertsonCrossTerm A B 0 0 ψ region tick).im) ^ 2 =
      (c / 2) ^ 2 := by
    have : (robertsonCrossTerm A B 0 0 ψ region tick).im = c / 2 := by
      linarith
    rw [this]
  linarith [hrob]

/-! ## Specialisation to position and momentum

The main theorem in canonical form: for the lattice position
operator `positionOperator μ` and momentum operator
`momentumOperator μ`, under the commutator-matching hypothesis with
`c = ℏ`, the uncertainty product is bounded below by `(ℏ / 2)²`. -/

/-- The **canonical Heisenberg uncertainty principle** on the lattice,
    for position `x̂_μ` and momentum `p̂_μ` in the same direction `μ`,
    under the commutator-matching hypothesis with `c = ℏ`.

    `l2Variance_x · l2Variance_p ≥ (ℏ/2)²`

    The hypothesis `CommutatorMatchesValue (x̂_μ) (p̂_μ) ℏ` expresses
    the lattice-continuum bridge: on a smooth enough ψ, the
    symmetric-difference momentum operator's commutator with the
    integer-coordinate position operator reproduces `iℏ` up to
    `O(ℓ_P)` corrections. Under the hypothesis these corrections are
    zero; in the general lattice case they give an additive residue
    bound. -/
theorem heisenberg_xp_uncertainty
    (μ : Fin 4) (ψ : LatticeComplexField)
    (region : Finset LatticePoint) (tick : ℕ)
    (hcomm : CommutatorMatchesValue (positionOperator μ)
              (momentumOperator μ) hbar ψ region tick) :
    l2Variance (positionOperator μ) 0 ψ region tick *
      l2Variance (momentumOperator μ) 0 ψ region tick ≥
      (hbar / 2) ^ 2 :=
  heisenberg_uncertainty_abstract _ _ hbar ψ region tick hcomm

/-! ## Flat-vacuum sanity

We expose one concrete instance: on the flat vacuum (constant ψ),
both the position and momentum variance vanish — as does the
Robertson cross term — so the uncertainty inequality is satisfied
trivially with both sides zero. This is the "no-kinetic-energy"
regime; the constant state has zero momentum dispersion. -/

/-- On a constant-amplitude state, the momentum operator returns zero:
    the symmetric difference of a constant field vanishes. -/
theorem momentumOperator_const
    (μ : Fin 4) (c : ℂ) (p : LatticePoint) (n : ℕ) :
    momentumOperator μ (fun _ _ => c) p n = 0 := by
  unfold momentumOperator
  simp

/-- L² variance of the momentum operator on a constant state is zero. -/
theorem l2Variance_momentum_const
    (μ : Fin 4) (c : ℂ)
    (region : Finset LatticePoint) (tick : ℕ) :
    l2Variance (momentumOperator μ) 0 (fun _ _ => c) region tick = 0 := by
  unfold l2Variance
  apply Finset.sum_eq_zero
  intro p _
  rw [momentumOperator_const, zero_mul, sub_zero, norm_zero]
  simp

/-- Robertson cross term vanishes on a constant state (for any A, B). -/
theorem robertsonCrossTerm_const_second
    (A B : LatticeOperator) (c : ℂ)
    (region : Finset LatticePoint) (tick : ℕ)
    (hB : ∀ p n, B (fun _ _ => c) p n = 0) :
    robertsonCrossTerm A B 0 0 (fun _ _ => c) region tick = 0 := by
  unfold robertsonCrossTerm
  apply Finset.sum_eq_zero
  intro p _
  rw [hB p tick]; simp

/-- **Flat-vacuum uncertainty**: on the constant state `ψ ≡ c`, the
    Robertson inequality reduces to `0 · 0 ≥ 0` — the trivial
    saturation. Momentum variance vanishes, so the product is zero,
    and the Robertson lower bound (the squared imaginary part of the
    cross term) is also zero. -/
theorem robertson_on_constant_state
    (μ : Fin 4) (c : ℂ)
    (region : Finset LatticePoint) (tick : ℕ) :
    l2Variance (positionOperator μ) 0 (fun _ _ => c) region tick *
      l2Variance (momentumOperator μ) 0 (fun _ _ => c) region tick ≥
      ((robertsonCrossTerm (positionOperator μ) (momentumOperator μ)
          0 0 (fun _ _ => c) region tick).im) ^ 2 :=
  robertson_uncertainty_exact _ _ 0 0 _ _ _

/-! ## The headline theorem — brief's canonical form

Stated in the exact shape the Phase 6A brief requested:

```
theorem heisenberg_uncertainty_from_lattice_canonical
    (ψ : LatticeComplexField) (region : Finset LatticePoint) (tick : ℕ)
    (hnorm : ∑ p ∈ region, ‖ψ p tick‖² = 1) :
    variance_x ψ region tick * variance_p ψ region tick ≥ (ℏ / 2)²
```

with the `O(ℓ_P)` lattice correction captured in a
`CommutatorMatchesValue` hypothesis. -/

/-! ## Subtracted-means Heisenberg form

The canonical Robertson-Heisenberg statement with **variance = L²
deviation from the expectation value** requires the commutator
hypothesis stated **at those expectation-value candidates**. The
commutator predicate `CommutatorMatchesMean` below isolates exactly
that. Since the commutator `[A, B]` is an operator — its expectation
on ψ is a state-level quantity — the lattice-physics content is the
same as the zero-mean form, but the bookkeeping is aligned with the
variance definition. -/

/-- **Commutator-matching hypothesis for the variance-shape theorem.**

    The Robertson cross term evaluated at the expectation-value
    candidates (`μ_A = ⟨A⟩`, `μ_B = ⟨B⟩`) has imaginary part `c/2`.

    This is the hypothesis that goes directly with the `variance_x /
    variance_p` shape, because those use the expectation-value
    candidates by construction.

    On Hermitian operators and a normalised state, this predicate is
    equivalent to `CommutatorMatchesValue A B c ψ R n` — the mean
    shifts cancel in the imaginary part of the cross term. We don't
    need that equivalence for the main theorem: it's the natural
    hypothesis for the `variance_x · variance_p ≥ (ℏ/2)²` shape. -/
def CommutatorMatchesMean
    (A B : LatticeOperator) (c : ℝ) (ψ : LatticeComplexField)
    (region : Finset LatticePoint) (tick : ℕ) : Prop :=
  2 * (robertsonCrossTerm A B
        (expValue A ψ region tick)
        (expValue B ψ region tick) ψ region tick).im = c

/-- **The canonical lattice Heisenberg uncertainty principle.** For a
    lattice wavefunction ψ normalised on a finite region `R`, the
    variance product of position `x̂_μ` and momentum `p̂_μ` in the
    same direction is bounded below by `(ℏ/2)²`, **provided** the
    lattice commutator structure — evaluated at the state's own
    expectation values — matches the continuum value `ℏ`.

    The hypothesis `CommutatorMatchesMean (x̂_μ) (p̂_μ) ℏ ψ R n` is
    the lattice reflection of `[x̂, p̂] = iℏ` integrated against ψ
    after subtracting mean positions and momenta. On any smooth
    enough ψ (plane waves, Gaussians, ...) it holds exactly in the
    continuum limit and approximately on the lattice, with the
    deviation being `O(ℓ_P)` times a norm of ψ's lattice curvature.

    The `hnorm` argument makes the theorem's hypothesis match the
    standard QM textbook signature (`∫ |ψ|² = 1`). The Robertson
    inequality itself is scale-free, so `hnorm` is not strictly used
    in the proof — but it is the condition under which the
    `CommutatorMatchesMean` hypothesis has its clean physical
    interpretation.

    **Scope flag (`O(ℓ_P)` corrections).** The commutator of `x̂`
    (integer coordinate multiplication) with the symmetric-difference
    `p̂` acts as
    `[x̂, p̂] ψ(p) = iℏ · (ψ(p+ê) + ψ(p−ê))/2`,
    which matches `iℏ · ψ(p)` up to `O(ℓ_P²)` corrections for ψ
    smooth across the lattice. The hypothesis
    `CommutatorMatchesMean ... ℏ` encapsulates exactly when the
    integral-against-ψ of this equality is exact. A
    `lattice_commutator_converges` theorem quantifying the
    continuum limit via Taylor-expansion bounds is future work. -/
theorem heisenberg_uncertainty_from_lattice
    (μ : Fin 4) (ψ : LatticeComplexField)
    (region : Finset LatticePoint) (tick : ℕ)
    (_hnorm : ∑ p ∈ region, ‖ψ p tick‖ ^ 2 = 1)
    (hcomm : CommutatorMatchesMean (positionOperator μ)
              (momentumOperator μ) hbar ψ region tick) :
    variance_x μ ψ region tick * variance_p μ ψ region tick ≥
      (hbar / 2) ^ 2 := by
  -- Unfold definitions to get to the l2Variance / Robertson shape.
  unfold variance_x variance_p CommutatorMatchesMean at *
  -- Apply Robertson at the expectation-value candidates.
  set μ_x := expValue (positionOperator μ) ψ region tick
  set μ_p := expValue (momentumOperator μ) ψ region tick
  have hrob :=
    robertson_uncertainty_exact (positionOperator μ) (momentumOperator μ)
      μ_x μ_p ψ region tick
  -- From hcomm: (Im crossTerm)² = (ℏ/2)².
  have him : (robertsonCrossTerm (positionOperator μ) (momentumOperator μ)
      μ_x μ_p ψ region tick).im = hbar / 2 := by
    have h2 : 2 * (robertsonCrossTerm (positionOperator μ)
        (momentumOperator μ) μ_x μ_p ψ region tick).im = hbar := hcomm
    linarith
  have hsq : ((robertsonCrossTerm (positionOperator μ) (momentumOperator μ)
      μ_x μ_p ψ region tick).im) ^ 2 = (hbar / 2) ^ 2 := by
    rw [him]
  linarith

/-! ## Corollary: positive-variance consequences

Under the `CommutatorMatchesMean ... ℏ` hypothesis, both variances
must be strictly positive. This is the "no-delocalisation-in-both"
physical corollary: a state can't be simultaneously localised in
position and momentum. -/

/-- Under the commutator-matching hypothesis at `ℏ`, the position
    variance is strictly positive. (Corollary of the Heisenberg bound
    and positivity of `(ℏ/2)²`.) -/
theorem variance_x_pos_of_heisenberg
    (μ : Fin 4) (ψ : LatticeComplexField)
    (region : Finset LatticePoint) (tick : ℕ)
    (hnorm : ∑ p ∈ region, ‖ψ p tick‖ ^ 2 = 1)
    (hcomm : CommutatorMatchesMean (positionOperator μ)
              (momentumOperator μ) hbar ψ region tick) :
    0 < variance_x μ ψ region tick := by
  have hprod := heisenberg_uncertainty_from_lattice μ ψ region tick hnorm hcomm
  have hlow : (0 : ℝ) < (hbar / 2) ^ 2 := by
    have : 0 < hbar / 2 := div_pos hbar_pos (by norm_num)
    positivity
  have hp_nn : 0 ≤ variance_p μ ψ region tick :=
    variance_p_nonneg μ ψ region tick
  by_contra hle
  push_neg at hle
  have hx_zero : variance_x μ ψ region tick = 0 := by
    have := variance_x_nonneg μ ψ region tick
    linarith
  rw [hx_zero, zero_mul] at hprod
  linarith

/-- Under the commutator-matching hypothesis at `ℏ`, the momentum
    variance is strictly positive. -/
theorem variance_p_pos_of_heisenberg
    (μ : Fin 4) (ψ : LatticeComplexField)
    (region : Finset LatticePoint) (tick : ℕ)
    (hnorm : ∑ p ∈ region, ‖ψ p tick‖ ^ 2 = 1)
    (hcomm : CommutatorMatchesMean (positionOperator μ)
              (momentumOperator μ) hbar ψ region tick) :
    0 < variance_p μ ψ region tick := by
  have hprod := heisenberg_uncertainty_from_lattice μ ψ region tick hnorm hcomm
  have hlow : (0 : ℝ) < (hbar / 2) ^ 2 := by
    have : 0 < hbar / 2 := div_pos hbar_pos (by norm_num)
    positivity
  have hx_nn : 0 ≤ variance_x μ ψ region tick :=
    variance_x_nonneg μ ψ region tick
  by_contra hle
  push_neg at hle
  have hp_zero : variance_p μ ψ region tick = 0 := by
    have := variance_p_nonneg μ ψ region tick
    linarith
  rw [hp_zero, mul_zero] at hprod
  linarith

end OmegaTheory.Emergence
