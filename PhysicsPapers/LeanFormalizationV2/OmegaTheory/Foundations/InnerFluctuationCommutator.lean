/-
  OmegaTheory.Foundations.InnerFluctuationCommutator

  **Lion's-Pride Phase 6.5f (2026-05-06)**:
  *Algebraic backbone of Connes' inner-fluctuation construction —
  the Hermiticity of `i · [D, A]` for Hermitian D, A. This is the
  Lie-bracket structure underlying the gauge field of the spectral
  action.*

  ## Why this file

  In Connes' noncommutative-geometry framework, the inner fluctuation
  of a finite Dirac operator `D_F` is

      D_F  ↦  D_F  +  π(A)  +  ε J A J⁻¹

  where `A = Σᵢ aᵢ · [D_F, bᵢ]` is a "1-form" — a sum of products of
  algebra elements `aᵢ, bᵢ ∈ A_F` with commutators `[D_F, bᵢ]`.

  At the heart of this construction is a SIMPLE ALGEBRAIC fact: for
  Hermitian D and Hermitian A,

      [D, A]  :=  D·A − A·D    is ANTI-Hermitian

  hence

      i · [D, A]    is HERMITIAN

  This is the Lean-side proof that inner fluctuations preserve
  Hermiticity (when scaled by `i`), which is the PHYSICAL requirement
  for the fluctuated Dirac to remain self-adjoint and hence describe
  a sensible quantum theory.

  ## What this file ships

  | Property                                          | Theorem                                  |
  |---------------------------------------------------|------------------------------------------|
  | `commutator D A = D*A - A*D`                       | (definition)                            |
  | `commutator D A` is anti-Hermitian for D, A Herm. | `commutator_isAntiHermitian`             |
  | `i · commutator D A` is Hermitian                  | `i_smul_commutator_isHermitian`          |
  | Sum of i · commutators is Hermitian (gauge field)  | `sum_i_commutators_isHermitian`          |
  | Headline 3-conjunct                                | `inner_fluctuation_commutator_report`     |

  ## Honest scope

  This file ships ONLY the COMMUTATOR-ALGEBRAIC backbone of inner
  fluctuations.  It does NOT ship:

  * The full inner-fluctuation construction with `J` involution
    (requires real-spectral-triple structure; multi-month).
  * The connection of inner fluctuations to physical gauge fields
    (requires the real-form decomposition of A_F into U(1) × SU(2)
    × SU(3) gauge group; Phase 6.5g+).
  * The Higgs-scalar-from-fluctuation-1-form identification (also
    Phase 6.5g+).

  What it DOES ship: the rigorous algebraic theorem that
  `[D, A]` is anti-Hermitian for Hermitian D, A, hence `i · [D, A]`
  is Hermitian — the foundation of the gauge field in Connes' NCG.

  ## Lion's-Pride doctrine applied

  Rule 1: zero `sorry`.  Rule 2: zero new axioms.
  Direct proof via `Matrix.conjTranspose_mul` + `Matrix.conjTranspose_sub`
  + `Matrix.conjTranspose_smul` + `Complex.conj_I`.  No abstraction
  towers.

  ## Author

  Lion's-Pride dynamic /loop iteration (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.
-/

import OmegaTheory.Foundations.StandardModelFromConnes
import Mathlib.LinearAlgebra.Matrix.Hermitian
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.InnerFluctuationCommutator

open scoped Matrix

variable {n : ℕ}

/-! ## 1. Commutator and anti-Hermitian predicate -/

/-- **Commutator of two matrices**: `[D, A] := D · A − A · D`. -/
noncomputable def commutator (D A : Matrix (Fin n) (Fin n) ℂ) :
    Matrix (Fin n) (Fin n) ℂ :=
  D * A - A * D

/-- **Anti-Hermitian predicate**: `Mᴴ = -M`. -/
def IsAntiHermitian (M : Matrix (Fin n) (Fin n) ℂ) : Prop :=
  Mᴴ = -M

/-! ## 2. Commutator of two Hermitian matrices is anti-Hermitian -/

/-- **For Hermitian D and Hermitian A, `[D, A]` is anti-Hermitian**.

    Proof: `(D·A − A·D)ᴴ = Aᴴ·Dᴴ − Dᴴ·Aᴴ = A·D − D·A = -(D·A − A·D)`. -/
theorem commutator_isAntiHermitian
    (D A : Matrix (Fin n) (Fin n) ℂ)
    (hD : D.IsHermitian) (hA : A.IsHermitian) :
    IsAntiHermitian (commutator D A) := by
  unfold IsAntiHermitian commutator
  rw [Matrix.conjTranspose_sub, Matrix.conjTranspose_mul, Matrix.conjTranspose_mul]
  rw [hD, hA]
  -- Goal: A * D - D * A = -(D * A - A * D)
  rw [neg_sub]

/-! ## 3. `i · commutator` is Hermitian -/

/-- **`i · [D, A]` is Hermitian for Hermitian D, A**.

    Since `[D, A]` is anti-Hermitian (`Mᴴ = -M`), multiplying by `i`
    flips the sign on the conjugate-transpose:
        `(i · M)ᴴ = -i · Mᴴ = -i · (-M) = i · M`.

    This is the standard physics trick: `i · [D, A]` is the gauge-
    invariant Hermitian "1-form" derived from the algebra-Dirac
    commutator. -/
theorem i_smul_commutator_isHermitian
    (D A : Matrix (Fin n) (Fin n) ℂ)
    (hD : D.IsHermitian) (hA : A.IsHermitian) :
    (Complex.I • commutator D A).IsHermitian := by
  unfold Matrix.IsHermitian
  rw [Matrix.conjTranspose_smul]
  rw [show (star Complex.I : ℂ) = -Complex.I from by
       rw [show (star Complex.I : ℂ) = (starRingEnd ℂ) Complex.I from rfl]
       rw [Complex.conj_I]]
  -- Goal: (-Complex.I) • (commutator D A)ᴴ = Complex.I • commutator D A
  have hAH : (commutator D A)ᴴ = -(commutator D A) := commutator_isAntiHermitian D A hD hA
  rw [hAH, smul_neg, neg_smul]
  abel

/-! ## 4. Sum of `i · commutator`s is Hermitian (gauge field) -/

/-- **A sum of `i · [D, Aₖ]` for Hermitian D, Aₖ is Hermitian**.

    This is the Connes "1-form" gauge field structure: every gauge
    field in the spectral action is built as a sum of i·commutators of
    algebra elements with the Dirac.  The sum's Hermiticity is what
    keeps the fluctuated Dirac self-adjoint. -/
theorem sum_i_commutators_isHermitian
    (D : Matrix (Fin n) (Fin n) ℂ) (hD : D.IsHermitian)
    (m : ℕ) (A : Fin m → Matrix (Fin n) (Fin n) ℂ)
    (hA : ∀ k, (A k).IsHermitian) :
    (∑ k : Fin m, Complex.I • commutator D (A k)).IsHermitian := by
  -- Sum of Hermitian matrices is Hermitian
  unfold Matrix.IsHermitian
  rw [Matrix.conjTranspose_sum]
  apply Finset.sum_congr rfl
  intros k _
  -- Each summand is Hermitian by i_smul_commutator_isHermitian
  exact i_smul_commutator_isHermitian D (A k) hD (hA k)

/-! ## 5. The inner-fluctuated Dirac D + Σ i·[D, Aₖ] is Hermitian -/

/-- **Inner-fluctuated Dirac**: `D + Σ i · [D, Aₖ]` is Hermitian if `D` and
    each `Aₖ` are Hermitian.

    This is the rigorous statement that Connes' inner fluctuation
    `D → D + π(A)` (where `A = Σ aₖ · [D, bₖ]` after the J-involution
    is folded in) preserves self-adjointness — a fundamental
    requirement for the spectral action to describe a sensible
    quantum theory. -/
theorem inner_fluctuated_dirac_isHermitian
    (D : Matrix (Fin n) (Fin n) ℂ) (hD : D.IsHermitian)
    (m : ℕ) (A : Fin m → Matrix (Fin n) (Fin n) ℂ)
    (hA : ∀ k, (A k).IsHermitian) :
    (D + ∑ k : Fin m, Complex.I • commutator D (A k)).IsHermitian := by
  unfold Matrix.IsHermitian
  rw [Matrix.conjTranspose_add]
  rw [hD]
  rw [Matrix.conjTranspose_sum]
  congr 1
  apply Finset.sum_congr rfl
  intros k _
  exact i_smul_commutator_isHermitian D (A k) hD (hA k)

/-! ## 6. Headline composite report -/

/-- **Lion's-Pride Phase 6.5f headline — inner-fluctuation commutator
    Hermiticity report.**

    For Hermitian Dirac `D : Matrix (Fin n) (Fin n) ℂ` and Hermitian
    1-form generators `A : Fin m → Matrix (Fin n) (Fin n) ℂ`:

    1. **Anti-Hermiticity of single commutator**:
       `[D, A k]` is anti-Hermitian for Hermitian D, A k.

    2. **Hermiticity of i·commutator**:
       `i · [D, A k]` is Hermitian.

    3. **Hermiticity of inner-fluctuated Dirac**:
       `D + Σ i · [D, A k]` is Hermitian — Connes' inner-fluctuation
       construction preserves self-adjointness. -/
theorem inner_fluctuation_commutator_report
    (D : Matrix (Fin n) (Fin n) ℂ) (hD : D.IsHermitian)
    (m : ℕ) (A : Fin m → Matrix (Fin n) (Fin n) ℂ)
    (hA : ∀ k, (A k).IsHermitian) :
    (∀ k, IsAntiHermitian (commutator D (A k))) ∧
    (∀ k, (Complex.I • commutator D (A k)).IsHermitian) ∧
    (D + ∑ k : Fin m, Complex.I • commutator D (A k)).IsHermitian := by
  refine ⟨?_, ?_, ?_⟩
  · intro k; exact commutator_isAntiHermitian D (A k) hD (hA k)
  · intro k; exact i_smul_commutator_isHermitian D (A k) hD (hA k)
  · exact inner_fluctuated_dirac_isHermitian D hD m A hA

end OmegaTheory.Foundations.InnerFluctuationCommutator
