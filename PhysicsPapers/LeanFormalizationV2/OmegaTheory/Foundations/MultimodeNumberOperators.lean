/-
  OmegaTheory.Foundations.MultimodeNumberOperators

  **Lion's-Pride Phase 7.7 (2026-05-06)**:
  *Per-mode number operator on the multi-mode truncated Fock space,
  plus single-mode-excitation utility states.*

  ## Why this file

  Phase 7.2 (`MultimodeFockSpace`) shipped the multi-mode state type
  `MultimodeFockState k N := Fin k → Fin (N+1)` and the TOTAL number
  operator eigenvalue `Σ_i state(i).val`.

  This file ships the **per-mode** number operator `N̂_i` whose
  eigenvalue at a state `|state⟩` is `state(i).val`, and the
  **single-mode excitation** utility `singleModeExcitation i n`
  which excites mode `i` to level `n`, leaving all others in the
  vacuum.

  Properties shipped:

  1. `perModeNumberEigenvalue state i = (state i).val` (definitional).
  2. `perModeNumberEigenvalue` is bounded by `N` per mode.
  3. `Σ_i perModeNumberEigenvalue state i = totalNumberEigenvalue state`
     (decomposition of total number into per-mode contributions).
  4. `singleModeExcitation i n` has per-mode number `n.val` on mode
     `i` and `0` on all other modes.
  5. `singleModeExcitation i n` has total number `n.val`.

  ## What this file ships

  | Property                                              | Theorem                                       |
  |-------------------------------------------------------|-----------------------------------------------|
  | `perModeNumberEigenvalue state i := (state i).val`     | (definition)                                  |
  | `perModeNumberEigenvalue_bounded`                      | ≤ N for each mode                              |
  | `total_eq_sum_perMode`                                 | total = Σ_i per-mode (decomposition)          |
  | `singleModeExcitation i n`                             | (def: excite only mode i to level n)          |
  | `singleModeExcitation_perMode_self`                    | per-mode number of excited mode = n.val       |
  | `singleModeExcitation_perMode_other`                   | per-mode number of other modes = 0            |
  | `singleModeExcitation_total`                           | total number = n.val                          |
  | Headline (4-conjunct)                                 | `multimode_number_operators_report`            |

  ## Honest scope

  This file ships the EIGENVALUE-LEVEL per-mode structure.  It does
  NOT yet:
  * Define the actual operator `N̂_i` as a linear map on the tensor-
    product Hilbert space — that requires the Mathlib TensorProduct
    Hilbert-space infrastructure (deferred).
  * Prove `[N̂_i, N̂_j] = 0` for `i ≠ j` (commutation across modes) —
    requires operator-level structure.

  What it DOES ship: per-mode eigenvalue functions + decomposition
  of total number + single-mode-excitation states with their
  eigenvalue properties.

  ## Author

  Lion's-Pride dynamic /loop iteration 50 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.MultimodeFockSpace
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.MultimodeNumberOperators

open OmegaTheory.Foundations.MultimodeFockSpace

/-! ## 1. Per-mode number operator eigenvalue

    `N̂_i |state⟩ = state(i).val · |state⟩` (when |state⟩ is a basis
    state — for multi-mode coherent superpositions, only the basis
    expansion makes sense, and per-mode numbers are well-defined
    on basis states only). -/

/-- **Per-mode number operator eigenvalue at `state`**:
    `N̂_i |state⟩ = state(i).val · |state⟩`. -/
def perModeNumberEigenvalue {k N : ℕ}
    (state : MultimodeFockState k N) (i : Fin k) : ℕ :=
  (state i).val

/-- **Per-mode number is bounded by N**. -/
theorem perModeNumberEigenvalue_bounded
    {k N : ℕ} (state : MultimodeFockState k N) (i : Fin k) :
    perModeNumberEigenvalue state i ≤ N := by
  unfold perModeNumberEigenvalue
  exact Nat.lt_succ_iff.mp (state i).isLt

/-- **Total number decomposes as sum of per-mode numbers**:
    `Σ_i N̂_i state = N̂_total state`. -/
theorem total_eq_sum_perMode
    {k N : ℕ} (state : MultimodeFockState k N) :
    (Finset.univ.sum fun i : Fin k => perModeNumberEigenvalue state i)
      = totalNumberEigenvalue state := by
  unfold perModeNumberEigenvalue totalNumberEigenvalue
  rfl

/-! ## 2. Single-mode excitation utility

    `singleModeExcitation i n` is the basis state that excites mode `i`
    to level `n` and leaves all other modes in the vacuum. -/

/-- **Single-mode excitation state**: excite mode `i` to level `n`,
    all other modes in vacuum (level 0). -/
def singleModeExcitation {k N : ℕ}
    (i : Fin k) (n : Fin (N + 1)) : MultimodeFockState k N :=
  fun j => if j = i then n else (⟨0, Nat.succ_pos N⟩ : Fin (N + 1))

/-- **Per-mode number of excited mode**: at the excited mode `i`,
    the eigenvalue is `n.val`. -/
theorem singleModeExcitation_perMode_self
    {k N : ℕ} (i : Fin k) (n : Fin (N + 1)) :
    perModeNumberEigenvalue (singleModeExcitation i n) i = n.val := by
  unfold perModeNumberEigenvalue singleModeExcitation
  simp

/-- **Per-mode number of other modes**: at any mode `j ≠ i`,
    the eigenvalue is `0`. -/
theorem singleModeExcitation_perMode_other
    {k N : ℕ} (i j : Fin k) (n : Fin (N + 1)) (hij : j ≠ i) :
    perModeNumberEigenvalue (singleModeExcitation i n) j = 0 := by
  unfold perModeNumberEigenvalue singleModeExcitation
  rw [if_neg hij]

/-- **Total number of single-mode excitation**: equals `n.val`,
    since only mode `i` contributes a non-zero eigenvalue. -/
theorem singleModeExcitation_total
    {k N : ℕ} [NeZero k] (i : Fin k) (n : Fin (N + 1)) :
    totalNumberEigenvalue (singleModeExcitation i n) = n.val := by
  unfold totalNumberEigenvalue singleModeExcitation
  -- Σ_{j ∈ Fin k} (↑(if j = i then n else ⟨0, _⟩))
  -- Push the coercion inside the if, then sum_ite_eq'
  have h_eq : (fun j : Fin k => ((if j = i then n else (⟨0, Nat.succ_pos N⟩ : Fin (N + 1))) : Fin (N+1)).val)
            = (fun j : Fin k => if j = i then n.val else 0) := by
    funext j
    by_cases h : j = i
    · simp [h]
    · simp [h]
  rw [h_eq]
  rw [Finset.sum_ite_eq']
  simp

/-! ## 3. Headline composite report -/

/-- **Lion's-Pride Phase 7.7 headline — per-mode number operator
    structural report.**

    For any number of modes `k : ℕ` (with NeZero k), truncation
    level `N : ℕ`, mode index `i : Fin k`, excitation level
    `n : Fin (N+1)`, and basis state `state : MultimodeFockState k N`:

    1. **Per-mode bounded by N**:
       `perModeNumberEigenvalue state i ≤ N`.

    2. **Total = Σ per-mode**:
       `Σ_j perModeNumberEigenvalue state j = totalNumberEigenvalue state`.

    3. **Single-mode excitation localises**:
       at the excited mode `i`, the per-mode number is `n.val`.

    4. **Single-mode total excitation**:
       `totalNumberEigenvalue (singleModeExcitation i n) = n.val`. -/
theorem multimode_number_operators_report
    {k N : ℕ} [NeZero k] (i : Fin k) (n : Fin (N + 1))
    (state : MultimodeFockState k N) :
    perModeNumberEigenvalue state i ≤ N ∧
    (Finset.univ.sum fun j : Fin k => perModeNumberEigenvalue state j)
      = totalNumberEigenvalue state ∧
    perModeNumberEigenvalue (singleModeExcitation i n) i = n.val ∧
    totalNumberEigenvalue (singleModeExcitation i n) = n.val := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact perModeNumberEigenvalue_bounded state i
  · exact total_eq_sum_perMode state
  · exact singleModeExcitation_perMode_self i n
  · exact singleModeExcitation_total i n

end OmegaTheory.Foundations.MultimodeNumberOperators
