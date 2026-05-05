/-
  OmegaTheory.Foundations.TruncatedFockSpace

  **Lion's-Pride Phase 7.1 (2026-05-06)**:
  *Truncated single-mode Fock space — the simplest substrate QFT
  building block.*

  ## Why this file

  The substrate QFT framework (Phase 7) needs a Fock-space scaffold:

      F(H) = ⊕_{n ≥ 0} Sym^n H        (bosonic Fock space)

  For a single bosonic mode (1-dim 1-particle Hilbert space), this is

      F(ℂ) = ⊕_{n ≥ 0} ℂ ≅ ℓ²(ℕ)

  the space of square-summable sequences indexed by particle number.
  In the SUBSTRATE the lattice is finite per region, so we have a
  natural truncation `n ≤ N` (UV cutoff = lattice scale Λ² = 4/ℓ_P²).
  This gives a TRUNCATED Fock space

      F_N := ⊕_{n=0}^N ℂ ≅ ℂ^{N+1}

  which is finite-dimensional and rigorous.  All Fock-space operators
  (number, creation, annihilation) become finite (N+1) × (N+1)
  matrices.

  This file ships the truncated single-mode Fock space scaffold using
  Mathlib's `Matrix (Fin (N+1)) (Fin (N+1)) ℂ` directly.

  ## What this file ships

  | Property                                              | Theorem                                  |
  |-------------------------------------------------------|------------------------------------------|
  | `numberOperatorTruncated N` : `Matrix (Fin (N+1)) ℂ`   | (definition)                             |
  | `numberOperatorTruncated_isHermitian`                  | (proof)                                  |
  | `numberOperatorTruncated` diagonal entries = `0..N`    | `numberOperatorTruncated_diagonal`        |
  | `harmonicHamiltonianTruncated ω N`                     | (definition: ℏω · (N̂ + 1/2))             |
  | Vacuum energy `E_0 = ℏω/2` (n=0 entry)                 | `harmonicHamiltonian_vacuumEnergy`        |
  | k-th energy eigenvalue `E_k = ℏω(k + 1/2)`             | `harmonicHamiltonian_eigenvalue_k`        |
  | Headline (4-conjunct)                                  | `truncated_fock_space_report`            |

  ## Honest scope

  This file does NOT yet:
  * Define multi-mode Fock space (tensor products of single-mode
    truncated Focks — Phase 7.2).
  * Define creation/annihilation operators `a^†, a` with canonical
    commutation `[a, a^†] = 1` (Phase 7.3 — requires careful handling
    of finite-dim approximation issues at the truncation boundary).
  * Build path-integral measure on field configurations (Phase 7.6).

  What it DOES ship:  the simplest 1-mode finite-dim QFT primitive
  with energy spectrum `E_k = ℏω(k + 1/2)`.  This is the building
  block that Phase 7.2-7.6 will tensor and assemble.

  ## Author

  Lion's-Pride dynamic /loop iteration 26 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import Mathlib.LinearAlgebra.Matrix.Hermitian
import Mathlib.LinearAlgebra.Matrix.Diagonal
import Mathlib.Data.Complex.Basic
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.TruncatedFockSpace

/-! ## 1. The truncated number operator

    `N̂_T (N+1)` is the (N+1) × (N+1) diagonal matrix
        diag(0, 1, 2, ..., N)
    in `ℂ` with the n-th diagonal entry equal to `(n : ℂ)`. -/

/-- **Truncated number operator** on the finite Fock space `ℂ^{N+1}`.

    Diagonal matrix with entries `(0 : ℂ), (1 : ℂ), ..., (N : ℂ)`. -/
noncomputable def numberOperatorTruncated (N : ℕ) :
    Matrix (Fin (N + 1)) (Fin (N + 1)) ℂ :=
  Matrix.diagonal (fun i : Fin (N + 1) => (i.val : ℂ))

/-- **The truncated number operator is Hermitian** (real diagonal). -/
theorem numberOperatorTruncated_isHermitian (N : ℕ) :
    (numberOperatorTruncated N).IsHermitian := by
  unfold numberOperatorTruncated
  -- diagonal of a real-cast (i.val : ℂ) function is Hermitian since
  -- conj((i : ℂ)) = (i : ℂ) for natural i (real-cast).
  apply Matrix.isHermitian_diagonal_iff.mpr
  intro i
  -- Need: IsSelfAdjoint (i.val : ℂ) which means star (i.val : ℂ) = (i.val : ℂ)
  -- which is conj of a real-cast = real-cast.
  show star ((i.val : ℕ) : ℂ) = ((i.val : ℕ) : ℂ)
  exact Complex.conj_natCast i.val

/-- **Diagonal entries of `N̂_T` are 0, 1, 2, ..., N**. -/
theorem numberOperatorTruncated_diagonal (N : ℕ) (i : Fin (N + 1)) :
    (numberOperatorTruncated N) i i = (i.val : ℂ) := by
  unfold numberOperatorTruncated
  rw [Matrix.diagonal_apply_eq]

/-! ## 2. The truncated harmonic-oscillator Hamiltonian

    `Ĥ_T(ω, N) := ℏω · (N̂ + 1/2)` (with ℏ = 1 absorbed into ω).

    Eigenvalues: `E_k = ω · (k + 1/2)` for `k = 0, 1, ..., N`. -/

/-- **Truncated harmonic-oscillator Hamiltonian** (with `ℏ = 1`).

    `Ĥ(ω, N) := ω · N̂ + ω/2 · I`. -/
noncomputable def harmonicHamiltonianTruncated (ω : ℝ) (N : ℕ) :
    Matrix (Fin (N + 1)) (Fin (N + 1)) ℂ :=
  (ω : ℂ) • numberOperatorTruncated N
    + ((ω : ℂ) / 2) • (1 : Matrix (Fin (N + 1)) (Fin (N + 1)) ℂ)

/-- **The k-th diagonal entry of `Ĥ_T(ω, N)` is `ω · (k + 1/2)`** —
    the harmonic-oscillator energy eigenvalue. -/
theorem harmonicHamiltonian_eigenvalue_k
    (ω : ℝ) (N : ℕ) (k : Fin (N + 1)) :
    (harmonicHamiltonianTruncated ω N) k k
      = (ω : ℂ) * ((k.val : ℂ) + 1 / 2) := by
  unfold harmonicHamiltonianTruncated
  rw [Matrix.add_apply, Matrix.smul_apply, Matrix.smul_apply,
      numberOperatorTruncated_diagonal]
  -- (1 : Matrix _ _ _) k k = 1 (identity matrix diagonal)
  rw [Matrix.one_apply_eq]
  simp [smul_eq_mul]
  ring

/-- **Vacuum energy `E_0 = ω/2`** (the n=0 diagonal entry, cf. zero-point
    energy of the quantum harmonic oscillator).

    Lion's-Pride substrate connection: this is the residual energy
    that does NOT vanish even in the substrate's "no-particle"
    state — exactly the kind of energy the Phase 4 graviton-energy
    machinery quantifies via `ℏω/2 + δ_comp(N)`. -/
theorem harmonicHamiltonian_vacuumEnergy (ω : ℝ) (N : ℕ) :
    (harmonicHamiltonianTruncated ω N) ⟨0, Nat.succ_pos N⟩ ⟨0, Nat.succ_pos N⟩
      = (ω : ℂ) / 2 := by
  rw [harmonicHamiltonian_eigenvalue_k ω N ⟨0, Nat.succ_pos N⟩]
  push_cast
  ring

/-! ## 3. Headline composite report -/

/-- **Lion's-Pride Phase 7.1 headline — truncated single-mode Fock-space
    structural report.**

    For any frequency `ω : ℝ`, truncation level `N : ℕ`, and
    excitation number `k : Fin (N+1)`:

    1. **Number operator is Hermitian**:
       `(numberOperatorTruncated N).IsHermitian`.

    2. **Number-operator k-th diagonal entry is k**:
       `(numberOperatorTruncated N) k k = k.val`.

    3. **Harmonic-Hamiltonian k-th eigenvalue is `ω·(k + 1/2)`**:
       `(harmonicHamiltonianTruncated ω N) k k = ω · (k + 1/2)`.

    4. **Vacuum energy is `ω/2`** (zero-point):
       `(harmonicHamiltonianTruncated ω N) ⟨0,..⟩ ⟨0,..⟩ = ω / 2`. -/
theorem truncated_fock_space_report
    (ω : ℝ) (N : ℕ) (k : Fin (N + 1)) :
    (numberOperatorTruncated N).IsHermitian ∧
    (numberOperatorTruncated N) k k = (k.val : ℂ) ∧
    (harmonicHamiltonianTruncated ω N) k k
      = (ω : ℂ) * ((k.val : ℂ) + 1 / 2) ∧
    (harmonicHamiltonianTruncated ω N) ⟨0, Nat.succ_pos N⟩ ⟨0, Nat.succ_pos N⟩
      = (ω : ℂ) / 2 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact numberOperatorTruncated_isHermitian N
  · exact numberOperatorTruncated_diagonal N k
  · exact harmonicHamiltonian_eigenvalue_k ω N k
  · exact harmonicHamiltonian_vacuumEnergy ω N

end OmegaTheory.Foundations.TruncatedFockSpace
