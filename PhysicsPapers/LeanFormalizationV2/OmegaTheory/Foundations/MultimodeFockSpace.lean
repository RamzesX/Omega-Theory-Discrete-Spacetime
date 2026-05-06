/-
  OmegaTheory.Foundations.MultimodeFockSpace

  **Lion's-Pride Phase 7.2 (2026-05-06)**:
  *Multi-mode truncated Fock space — tensor product of single-mode
  Focks for `k` modes.*

  ## Why this file

  The single-mode truncated Fock space `F_N := ⊕_{n=0}^N ℂ ≅ ℂ^{N+1}`
  (Phase 7.1) describes excitations of a SINGLE bosonic mode.  In
  realistic substrate QFT, we have MANY modes (one per lattice point,
  one per momentum value).

  The k-mode truncated Fock space is the tensor product

      F_{N,k} := F_N^{⊗k} ≅ ℂ^{(N+1)^k}

  Equivalently, states are indexed by occupation-number functions
  `state : Fin k → Fin (N+1)` assigning an excitation level
  `state i ∈ {0, ..., N}` to each mode `i`.

  The TOTAL number operator is the sum over modes:

      N̂_total |state⟩  =  (Σ_{i ∈ Fin k} state(i)) · |state⟩

  This file ships the multi-mode-Fock state-indexing scaffold and
  total number eigenvalue.

  ## What this file ships

  | Property                                              | Theorem                                 |
  |-------------------------------------------------------|-----------------------------------------|
  | `MultimodeFockState k N := Fin k → Fin (N+1)`          | (type definition)                       |
  | `totalNumberEigenvalue (state : MultimodeFockState k N) : ℕ` | (defn: Σ state.val)                |
  | `totalNumberEigenvalue_vacuum_eq_zero`                 | ground state has eigenvalue 0           |
  | `totalNumberEigenvalue_bounded_by_kN`                  | eigenvalue ≤ k·N                        |
  | Headline (3-conjunct)                                 | `multimode_fock_space_report`            |

  ## Honest scope

  This file ships the COMBINATORIAL structure of multi-mode Fock
  space (state indexing + total number eigenvalue).  It does NOT yet:
  * Define the actual tensor-product Hilbert-space inner product
    (Phase 7.2-cont — uses Mathlib's `TensorProduct` infrastructure).
  * Define multi-mode creation/annihilation `a_i^†, a_i` acting on
    one factor at a time (Phase 7.2-cont).
  * Prove tensor-product factorisation of the total partition function
    `Z_total = ∏_i Z_i` (Phase 7.2-cont — uses `Finset.sum_prod_pi`).

  What it DOES ship: the state-indexing + total number eigenvalue
  + bound `0 ≤ N̂_total ≤ k·N` — the algebraic shape of multi-mode
  Fock excitations.

  ## Author

  Lion's-Pride dynamic /loop iteration 40 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import Mathlib.Tactic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.MultimodeFockSpace

/-! ## 1. Multi-mode Fock state type

    `MultimodeFockState k N` is a function assigning excitation level
    in `Fin (N+1)` to each of `k` modes. -/

/-- **Multi-mode truncated Fock state**: function from `Fin k`
    (mode index) to `Fin (N+1)` (excitation level in 0..N). -/
abbrev MultimodeFockState (k N : ℕ) : Type := Fin k → Fin (N + 1)

/-! ## 2. Total number operator eigenvalue

    `N̂_total |state⟩ = (Σ_i state(i).val) |state⟩`. -/

/-- **Total number operator eigenvalue** at multi-mode state `state`. -/
def totalNumberEigenvalue {k N : ℕ}
    (state : MultimodeFockState k N) : ℕ :=
  Finset.univ.sum fun i : Fin k => (state i).val

/-! ## 3. Vacuum and excited-state eigenvalue properties -/

/-- **Vacuum eigenvalue is zero**: the all-zero multi-mode state has
    total number 0. -/
theorem totalNumberEigenvalue_vacuum_eq_zero (k N : ℕ) :
    totalNumberEigenvalue
        (fun (_ : Fin k) => (⟨0, Nat.succ_pos N⟩ : Fin (N + 1)))
      = 0 := by
  unfold totalNumberEigenvalue
  -- Σ_i 0 = 0
  simp

/-- **Total eigenvalue is bounded by k·N**: each mode contributes
    at most N, so the sum is at most k · N. -/
theorem totalNumberEigenvalue_bounded_by_kN
    {k N : ℕ} (state : MultimodeFockState k N) :
    totalNumberEigenvalue state ≤ k * N := by
  unfold totalNumberEigenvalue
  -- Each (state i).val ≤ N (since state i : Fin (N+1) means val ≤ N)
  -- So Σ_{i : Fin k} state i ≤ Σ_{i : Fin k} N = k * N
  calc (Finset.univ.sum fun i : Fin k => (state i).val)
      ≤ Finset.univ.sum fun i : Fin k => N := by
        apply Finset.sum_le_sum
        intro i _
        exact Nat.lt_succ_iff.mp (state i).isLt
    _ = (Finset.univ : Finset (Fin k)).card * N := by
        rw [Finset.sum_const]
        ring
    _ = k * N := by
        rw [Finset.card_univ, Fintype.card_fin]

/-! ## 4. Headline composite report -/

/-- **Lion's-Pride Phase 7.2 headline — multi-mode truncated Fock
    space structural report.**

    For any number of modes `k : ℕ`, truncation level `N : ℕ`, and
    multi-mode state `state : MultimodeFockState k N`:

    1. **Vacuum has zero total occupation**:
       `totalNumberEigenvalue (fun _ => 0) = 0`.

    2. **Total occupation is bounded by `k·N`**:
       `totalNumberEigenvalue state ≤ k * N`.

    3. **Total occupation is non-negative** (trivially since it's `ℕ`):
       `0 ≤ totalNumberEigenvalue state`. -/
theorem multimode_fock_space_report
    {k N : ℕ} (state : MultimodeFockState k N) :
    totalNumberEigenvalue
        (fun (_ : Fin k) => (⟨0, Nat.succ_pos N⟩ : Fin (N + 1)))
      = 0 ∧
    totalNumberEigenvalue state ≤ k * N ∧
    0 ≤ totalNumberEigenvalue state := by
  refine ⟨?_, ?_, ?_⟩
  · exact totalNumberEigenvalue_vacuum_eq_zero k N
  · exact totalNumberEigenvalue_bounded_by_kN state
  · exact Nat.zero_le _

end OmegaTheory.Foundations.MultimodeFockSpace
