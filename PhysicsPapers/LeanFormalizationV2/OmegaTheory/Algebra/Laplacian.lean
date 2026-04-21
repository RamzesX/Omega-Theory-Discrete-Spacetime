/-
  OmegaTheory.Algebra.Laplacian

  **The 6×6 Hermitian Magnetic Laplacian of the V3-for-Lean core algebra.**

  This module lifts the Phase 0 design memo `OmegaTheoryAlgebra/04_magnetic_laplacian.md`
  into Lean 4.  The memo constructs the matrix

      𝔄 = Δ − T^(g) ⊙ W^(s)

  where `W^(s)` is the symmetrised edge-weight matrix, `D` is the antisymmetric
  direction matrix, `T^(g) = exp(i · 2π · g · D)` is the phase factor at
  charge `g = 1/4` (optimal per MagNet arXiv 2102.11391), and `Δ` is the
  diagonal degree matrix.

  At `g = 1/4` the phase factor takes only three complex values (±i, 1), so
  the matrix has rational-imaginary entries throughout — representable exactly.
  We fix the **canonical (alphabetical) vertex ordering** matching all live
  Python/Cypher consumers:

      index 0 = Axiom,       index 1 = Definition,
      index 2 = Instance,    index 3 = Namespace,
      index 4 = Structure,   index 5 = Theorem.

  From memo §2.5 (mnemonic-ordered matrix), re-indexed alphabetically:

      𝔄[Axiom,      Axiom]      = 0.5
      𝔄[Axiom,      Theorem]    = +0.5i
      𝔄[Definition, Definition] = 2.5
      𝔄[Definition, Structure]  = -1.5i
      𝔄[Definition, Theorem]    = +i
      𝔄[Instance,   Instance]   = 0.5
      𝔄[Instance,   Structure]  = -0.5i
      𝔄[Namespace,  Namespace]  = 0
      𝔄[Structure,  Definition] = +1.5i   (conjugate of (Def, Struct))
      𝔄[Structure,  Instance]   = +0.5i   (conjugate of (Inst, Struct))
      𝔄[Structure,  Structure]  = 3.5
      𝔄[Structure,  Theorem]    = +1.5i   (reversed from mnemonic §2.5 T→S = -1.5i)
      𝔄[Theorem,    Axiom]      = -0.5i   (conjugate of (Ax, Thm))
      𝔄[Theorem,    Definition] = -i      (conjugate of (Def, Thm))
      𝔄[Theorem,    Structure]  = -1.5i   (from T→S = -1.5i)
      𝔄[Theorem,    Theorem]    = 3

  All other entries are 0.

  This file builds:
    * `LeanAlgebraLaplacian : Matrix (Fin 6) (Fin 6) ℂ`
    * `LeanAlgebraLaplacian_isHermitian` — the Hermiticity theorem
    * `LeanAlgebraLaplacian_trace_eq_ten` — `tr 𝔄 = 10`
    * `LeanAlgebraLaplacian_Namespace_row_zero` — decoupling of Namespace

  HARD CONSTRAINTS honoured:
    * 0 sorry
    * 0 new axioms
    * 0 `Prop := True` placeholders
    * build GREEN on Lean 4.29 + Mathlib 4.29

  Agent: Kitalpha (α Equulei), 2026-04-21, cycle 44 — first formal lift
  of the Magnetic Laplacian into Lean, Hermiticity proved structurally.

  Spectral theorem (eigenvalue existence / count) is registered as a
  :TheoremCandidate BLOCKED_ON_MATHLIB — `Matrix.IsHermitian.eigenvalues`
  in Mathlib requires additional `RCLike` / `InnerProductSpace` instances
  that must be discharged in a follow-up module.
-/

import OmegaTheory.Algebra.Selection
import Mathlib.Data.Matrix.Basic
import Mathlib.LinearAlgebra.Matrix.Hermitian
import Mathlib.Data.Complex.Basic
import Mathlib.Tactic

namespace OmegaTheory.Algebra

open Complex Matrix

/-- The canonical (alphabetical) index embedding of `LeanEntity` into `Fin 6`
used by all Python/Cypher consumers.  Repeats `LeanEntity.canonicalIndex`
but is exposed here as a `Fin 6`-valued helper for matrix construction. -/
@[reducible] def LeanEntity.idx : LeanEntity → Fin 6 := LeanEntity.canonicalIndex

/-- **The 6×6 Magnetic Laplacian 𝔄 in canonical alphabetical order.**

Entries are computed from memo 04 §2.5 and re-indexed to alphabetical
(A, D, I, N, S, T) ordering. -/
noncomputable def LeanAlgebraLaplacian : Matrix (Fin 6) (Fin 6) ℂ :=
  fun i j =>
    match (i : ℕ), (j : ℕ) with
    -- Row 0 = Axiom
    | 0, 0 => (1 : ℂ) / 2                           -- 0.5
    | 0, 5 => Complex.I / 2                         -- +0.5i
    -- Row 1 = Definition
    | 1, 1 => (5 : ℂ) / 2                           -- 2.5
    | 1, 4 => - ((3 : ℂ) / 2) * Complex.I           -- -1.5i
    | 1, 5 => Complex.I                             -- +i
    -- Row 2 = Instance
    | 2, 2 => (1 : ℂ) / 2                           -- 0.5
    | 2, 4 => - ((1 : ℂ) / 2) * Complex.I           -- -0.5i
    -- Row 3 = Namespace
    | 3, 3 => 0                                     -- 0
    -- Row 4 = Structure
    | 4, 1 => ((3 : ℂ) / 2) * Complex.I             -- +1.5i
    | 4, 2 => ((1 : ℂ) / 2) * Complex.I             -- +0.5i
    | 4, 4 => (7 : ℂ) / 2                           -- 3.5
    | 4, 5 => ((3 : ℂ) / 2) * Complex.I             -- +1.5i
    -- Row 5 = Theorem
    | 5, 0 => - ((1 : ℂ) / 2) * Complex.I           -- -0.5i
    | 5, 1 => - Complex.I                           -- -i
    | 5, 4 => - ((3 : ℂ) / 2) * Complex.I           -- -1.5i
    | 5, 5 => 3                                     -- 3
    -- All other entries 0
    | _, _ => 0

/-! ## Hermiticity -/

/-- **The Magnetic Laplacian is Hermitian: 𝔄† = 𝔄.**

Proof strategy: unfold each of the 36 entries, compute `star` on the complex
values, and verify `star (𝔄 j i) = 𝔄 i j` for all (i, j) pairs.

Since the entries involve `Complex.I` and rational reals, `star` computes via
`star (a · I) = -(star a) · I = -a · I` (for real `a`), and `star (r : ℂ) = r`
(for real `r`).  The proof reduces to a finite exhaustive check using `decide`
after replacing `Complex.I` structure — but `decide` won't evaluate through
`Complex.I`, so we use an explicit case analysis with `simp [LeanAlgebraLaplacian]`
and normalization lemmas. -/
theorem LeanAlgebraLaplacian_isHermitian :
    LeanAlgebraLaplacian.IsHermitian := by
  apply Matrix.IsHermitian.ext
  intro i j
  -- Finite case analysis on (i, j) pairs.  Fin 6 has 6 elements, so there are
  -- 6 × 6 = 36 cases.  Each case either is on diagonal (self-conjugate real)
  -- or an off-diagonal pair with the ±i phase already set up correctly.
  fin_cases i <;> fin_cases j <;>
    simp [LeanAlgebraLaplacian, Complex.ext_iff,
      Complex.I_re, Complex.I_im, Complex.mul_re, Complex.mul_im,
      Complex.ofReal_re, Complex.ofReal_im,
      Complex.neg_re, Complex.neg_im,
      Complex.div_re, Complex.div_im,
      Complex.normSq] <;>
    ring

/-! ## Trace -/

/-- **The trace of 𝔄 is 10.**

From memo §6: `tr 𝔄 = 0.5 + 3 + 2.5 + 3.5 + 0.5 + 0 = 10`. -/
theorem LeanAlgebraLaplacian_trace_eq_ten :
    LeanAlgebraLaplacian.trace = 10 := by
  simp [Matrix.trace, Fin.sum_univ_six, LeanAlgebraLaplacian]
  ring

/-! ## Namespace decoupling -/

/-- **The Namespace row is entirely zero.**

Consequence of memo §2.5 / §6 observation that Namespace is decoupled from the
behavioral algebra.  This directly implies `0` is an eigenvalue of 𝔄 with
eigenvector `e_N = (0, 0, 0, 1, 0, 0)^T` (index 3 = Namespace). -/
theorem LeanAlgebraLaplacian_Namespace_row_zero (j : Fin 6) :
    LeanAlgebraLaplacian ⟨3, by decide⟩ j = 0 := by
  fin_cases j <;> simp [LeanAlgebraLaplacian]

/-- **The Namespace column is entirely zero.**

The dual of `_row_zero`.  Together they give the Namespace direct-sum
decoupling. -/
theorem LeanAlgebraLaplacian_Namespace_col_zero (i : Fin 6) :
    LeanAlgebraLaplacian i ⟨3, by decide⟩ = 0 := by
  fin_cases i <;> simp [LeanAlgebraLaplacian]

/-! ## Diagonal entries -/

/-- Diagonal of 𝔄 at Axiom slot. -/
theorem LeanAlgebraLaplacian_diag_Axiom :
    LeanAlgebraLaplacian ⟨0, by decide⟩ ⟨0, by decide⟩ = (1 : ℂ) / 2 := by
  simp [LeanAlgebraLaplacian]

/-- Diagonal of 𝔄 at Definition slot. -/
theorem LeanAlgebraLaplacian_diag_Definition :
    LeanAlgebraLaplacian ⟨1, by decide⟩ ⟨1, by decide⟩ = (5 : ℂ) / 2 := by
  simp [LeanAlgebraLaplacian]

/-- Diagonal of 𝔄 at Instance slot. -/
theorem LeanAlgebraLaplacian_diag_Instance :
    LeanAlgebraLaplacian ⟨2, by decide⟩ ⟨2, by decide⟩ = (1 : ℂ) / 2 := by
  simp [LeanAlgebraLaplacian]

/-- Diagonal of 𝔄 at Namespace slot. -/
theorem LeanAlgebraLaplacian_diag_Namespace :
    LeanAlgebraLaplacian ⟨3, by decide⟩ ⟨3, by decide⟩ = 0 := by
  simp [LeanAlgebraLaplacian]

/-- Diagonal of 𝔄 at Structure slot. -/
theorem LeanAlgebraLaplacian_diag_Structure :
    LeanAlgebraLaplacian ⟨4, by decide⟩ ⟨4, by decide⟩ = (7 : ℂ) / 2 := by
  simp [LeanAlgebraLaplacian]

/-- Diagonal of 𝔄 at Theorem slot. -/
theorem LeanAlgebraLaplacian_diag_Theorem :
    LeanAlgebraLaplacian ⟨5, by decide⟩ ⟨5, by decide⟩ = 3 := by
  simp [LeanAlgebraLaplacian]

/-! ## Polarity witnesses -/

/-- **The Namespace diagonal is 0** — witness that Namespace decouples. -/
theorem LeanAlgebraLaplacian_Namespace_diag_zero :
    LeanAlgebraLaplacian ⟨3, by decide⟩ ⟨3, by decide⟩ = 0 :=
  LeanAlgebraLaplacian_diag_Namespace

/-- **Off-diagonal Theorem→Axiom entry is `-0.5i`** (memo §2.5). -/
theorem LeanAlgebraLaplacian_Theorem_to_Axiom :
    LeanAlgebraLaplacian ⟨5, by decide⟩ ⟨0, by decide⟩ = - ((1 : ℂ) / 2) * Complex.I := by
  simp [LeanAlgebraLaplacian]

/-- **Off-diagonal Axiom→Theorem entry is `+0.5i`** (memo §2.5, conjugate pair). -/
theorem LeanAlgebraLaplacian_Axiom_to_Theorem :
    LeanAlgebraLaplacian ⟨0, by decide⟩ ⟨5, by decide⟩ = Complex.I / 2 := by
  simp [LeanAlgebraLaplacian]

end OmegaTheory.Algebra
