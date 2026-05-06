/-
  OmegaTheory.Foundations.MultimodeCommutation

  **Lion's-Pride Phase 7.8 (2026-05-06)**:
  *Multi-mode number-operator commutation at the eigenvalue level —
  double-mode excitation states + commutativity + total-occupation
  decomposition.*

  ## Why this file

  Phase 7.7 (`MultimodeNumberOperators`) shipped the per-mode number
  operator `N̂_i` and the single-mode excitation utility.

  This file ships the COMMUTATION property at the eigenvalue level:
  for distinct modes `i ≠ j`, applying excitations on both modes
  produces a state whose total occupation is `n.val + m.val`,
  independent of the application order.  This is the eigenvalue-
  level statement of `[N̂_i, N̂_j] = 0`.

  Properties shipped:

  1. `doubleModeExcitation i j n m`: state with `n` excitation on
     mode `i` and `m` excitation on mode `j`, all others vacuum.

  2. **Commutativity**: `doubleModeExcitation i j n m =
     doubleModeExcitation j i m n` for `i ≠ j`.

  3. **Per-mode eigenvalues at the excited modes**: at mode `i`, the
     eigenvalue is `n.val`; at mode `j`, it is `m.val`.

  4. **Total occupation decomposition**:
     `totalNumberEigenvalue (doubleModeExcitation i j n m) = n.val + m.val`
     (proved by reducing to per-mode + zero-elsewhere).

  ## What this file ships

  | Property                                              | Theorem                                       |
  |-------------------------------------------------------|-----------------------------------------------|
  | `doubleModeExcitation i j n m`                        | (def: excite mode i to n and j to m)          |
  | `doubleModeExcitation_commutes`                       | i ≠ j ⟹ swapping arguments preserves state   |
  | `doubleModeExcitation_perMode_first`                  | per-mode at i = n.val                          |
  | `doubleModeExcitation_perMode_second`                 | per-mode at j = m.val (when i ≠ j)            |
  | `doubleModeExcitation_total`                          | total = n.val + m.val (when i ≠ j)            |
  | Headline (4-conjunct)                                 | `multimode_commutation_report`                 |

  ## Honest scope

  This file ships the EIGENVALUE-LEVEL commutation.  It does NOT yet:
  * Define the operator-on-tensor-space `N̂_i ⊗ I` as a concrete
    linear map and prove the operator commutator vanishes — that
    requires Mathlib TensorProduct Hilbert-space machinery.
  * Address fermionic anticommutation (Pauli antisymmetry).

  What it DOES ship: the eigenvalue-level multi-mode commutation,
  giving the substrate-QFT bookkeeping for joint excitations.

  ## Author

  Lion's-Pride dynamic /loop iteration 52 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.MultimodeFockSpace
import OmegaTheory.Foundations.MultimodeNumberOperators
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.MultimodeCommutation

open OmegaTheory.Foundations.MultimodeFockSpace
open OmegaTheory.Foundations.MultimodeNumberOperators

/-! ## 1. Double-mode excitation utility

    `doubleModeExcitation i j n m`: state with `n` excitation on
    mode `i` and `m` excitation on mode `j`. -/

/-- **Double-mode excitation state**: excite mode `i` to level `n`
    and mode `j` to level `m`, all other modes in vacuum. -/
def doubleModeExcitation {k N : ℕ}
    (i j : Fin k) (n m : Fin (N + 1)) : MultimodeFockState k N :=
  fun l => if l = i then n
           else if l = j then m
           else (⟨0, Nat.succ_pos N⟩ : Fin (N + 1))

/-! ## 2. Commutativity at distinct modes

    `i ≠ j` ⟹ swapping `(i, n)` with `(j, m)` produces the same state. -/

/-- **Commutativity at distinct modes**: when `i ≠ j`, excitations
    on the two modes commute as state-constructions. -/
theorem doubleModeExcitation_commutes
    {k N : ℕ} (i j : Fin k) (n m : Fin (N + 1)) (hij : i ≠ j) :
    doubleModeExcitation i j n m = doubleModeExcitation j i m n := by
  funext l
  unfold doubleModeExcitation
  by_cases h_li : l = i
  · -- l = i, so l ≠ j (since i ≠ j)
    have h_lj : l ≠ j := by rw [h_li]; exact hij
    rw [if_pos h_li, if_neg h_lj, if_pos h_li]
  · by_cases h_lj : l = j
    · -- l ≠ i, l = j
      rw [if_neg h_li, if_pos h_lj, if_pos h_lj]
    · -- l ≠ i, l ≠ j
      rw [if_neg h_li, if_neg h_lj, if_neg h_lj, if_neg h_li]

/-! ## 3. Per-mode eigenvalues at excited modes -/

/-- **Per-mode at first excited mode i**: eigenvalue is `n.val`. -/
theorem doubleModeExcitation_perMode_first
    {k N : ℕ} (i j : Fin k) (n m : Fin (N + 1)) :
    perModeNumberEigenvalue (doubleModeExcitation i j n m) i = n.val := by
  unfold perModeNumberEigenvalue doubleModeExcitation
  simp

/-- **Per-mode at second excited mode j (i ≠ j)**: eigenvalue is `m.val`. -/
theorem doubleModeExcitation_perMode_second
    {k N : ℕ} (i j : Fin k) (n m : Fin (N + 1)) (hij : i ≠ j) :
    perModeNumberEigenvalue (doubleModeExcitation i j n m) j = m.val := by
  unfold perModeNumberEigenvalue doubleModeExcitation
  -- l = j: first if `j = i` is false (since i ≠ j), then `j = j` is true → m
  rw [if_neg hij.symm, if_pos rfl]

/-! ## 4. Total occupation decomposition -/

/-- **Total occupation of double-mode excitation**: `n.val + m.val`
    (for `i ≠ j`). -/
theorem doubleModeExcitation_total
    {k N : ℕ} [NeZero k] (i j : Fin k) (n m : Fin (N + 1)) (hij : i ≠ j) :
    totalNumberEigenvalue (doubleModeExcitation i j n m)
      = n.val + m.val := by
  unfold totalNumberEigenvalue doubleModeExcitation
  -- Push coercion inside if-then-else, then split the nested if into a sum
  -- of two indicators (i ≠ j makes them non-overlapping).
  have h_eq :
      (fun l : Fin k => ((if l = i then n
                          else if l = j then m
                          else (⟨0, Nat.succ_pos N⟩ : Fin (N + 1))) : Fin (N+1)).val)
        = (fun l : Fin k =>
              (if l = i then n.val else 0) + (if l = j then m.val else 0)) := by
    funext l
    by_cases h_li : l = i
    · subst h_li
      have : l ≠ j := hij
      -- left side at l = i: nested if gives n
      -- right side: (n.val) + (if i = j then m.val else 0) = n.val + 0 = n.val
      simp [hij]
    · by_cases h_lj : l = j
      · subst h_lj
        -- left side at l = j: skip first (l ≠ i), enter second (l = j → m), val = m.val
        -- right side: (if j = i then n.val else 0) + m.val = 0 + m.val = m.val
        have : l ≠ i := hij.symm
        simp [hij.symm, h_li]
      · simp [h_li, h_lj]
  rw [h_eq]
  -- Now: Σ_l ((if l = i then n.val else 0) + (if l = j then m.val else 0))
  --     = Σ_l (if l = i then n.val else 0) + Σ_l (if l = j then m.val else 0)
  --     = n.val + m.val (each Finset.sum_ite_eq')
  rw [Finset.sum_add_distrib]
  rw [Finset.sum_ite_eq' Finset.univ i (fun _ => n.val)]
  rw [Finset.sum_ite_eq' Finset.univ j (fun _ => m.val)]
  simp

/-! ## 5. Headline composite report -/

/-- **Lion's-Pride Phase 7.8 headline — multi-mode commutation
    structural report.**

    For any number of modes `k : ℕ` (with NeZero k), truncation
    `N : ℕ`, distinct modes `i ≠ j : Fin k`, and excitation levels
    `n m : Fin (N+1)`:

    1. **Commutativity**: doubleModeExcitation i j n m = doubleModeExcitation j i m n.

    2. **Per-mode at first**: per-mode at i = n.val.

    3. **Per-mode at second**: per-mode at j = m.val.

    4. **Total = sum**: total occupation = n.val + m.val. -/
theorem multimode_commutation_report
    {k N : ℕ} [NeZero k] (i j : Fin k) (n m : Fin (N + 1)) (hij : i ≠ j) :
    doubleModeExcitation i j n m = doubleModeExcitation j i m n ∧
    perModeNumberEigenvalue (doubleModeExcitation i j n m) i = n.val ∧
    perModeNumberEigenvalue (doubleModeExcitation i j n m) j = m.val ∧
    totalNumberEigenvalue (doubleModeExcitation i j n m) = n.val + m.val := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact doubleModeExcitation_commutes i j n m hij
  · exact doubleModeExcitation_perMode_first i j n m
  · exact doubleModeExcitation_perMode_second i j n m hij
  · exact doubleModeExcitation_total i j n m hij

end OmegaTheory.Foundations.MultimodeCommutation
