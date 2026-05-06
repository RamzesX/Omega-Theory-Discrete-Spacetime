/-
  OmegaTheory.Foundations.PathIntegralLattice

  **Lion's-Pride Phase 7.6 (2026-05-06)**:
  *Rigorous finite-lattice path integral on truncated substrate.*

  ## Why this file

  Continuum QFT path integrals `Z = ∫ Dφ e^{iS[φ]}` are NON-RIGOROUS
  because the measure `Dφ` on infinite-dimensional configuration
  space does not exist (Wightman, Glimm-Jaffe).

  In the substrate, the lattice scale `ℓ_P` makes the configuration
  space FINITE per region:
      Configs(N) = (some finite-dim space)^{lattice points in region}

  This is a finite-dim space, so Lebesgue measure WORKS, and the
  path integral is a rigorous Lebesgue (or counting) sum.

  This file ships the simplest rigorous lattice path integral:
  Wick-rotated Euclidean partition function

      Z_E[S]  :=  Σ_{i = 0}^{n-1}  exp(-S(i))

  for a finite "configuration space" of size `n` and Euclidean action
  `S : Fin n → ℝ`.  This is a CONVERGENT FINITE SUM — the rigorous
  substrate replacement for the formal continuum integral.

  ## What this file ships

  | Property                                              | Theorem                                  |
  |-------------------------------------------------------|------------------------------------------|
  | `pathIntegralLatticeEuclidean n S`                     | (definition: Σ exp(-S))                  |
  | `pathIntegralLatticeEuclidean_pos`                     | Z > 0 (sum of positive exponentials)     |
  | `pathIntegralLatticeEuclidean_zero_action_eq_n`        | Z[S=0] = n (count of configs)            |
  | `pathIntegralLatticeEuclidean_const_action`            | Z[S=c] = n · exp(-c)                     |
  | Headline (4-conjunct)                                 | `path_integral_lattice_report`            |

  ## Honest scope

  This file ships the EUCLIDEAN partition-function form (Wick-rotated).
  The Lorentzian form `Z = Σ exp(iS)` requires complex analysis —
  Phase 7.6+ multi-week port.

  Multi-mode tensor-product partition functions follow from the
  single-mode case via `Σ_{i,j} exp(-(S₁(i) + S₂(j))) = Z₁ · Z₂`
  (Phase 7.2-cont).

  ## Author

  Lion's-Pride dynamic /loop iteration 39 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.PathIntegralLattice

/-! ## 1. The Euclidean lattice path integral

    `Z_E[S] := Σ exp(-S(i))` over `i = 0..n-1`. -/

/-- **Euclidean lattice path integral** for a finite-dim configuration
    space `Fin n` with action `S : Fin n → ℝ`.

    Wick-rotated form: `Z_E := Σ exp(-S(i))`.  Rigorous finite sum
    (no measure-theoretic subtleties of continuum path integrals). -/
noncomputable def pathIntegralLatticeEuclidean
    (n : ℕ) (S : Fin n → ℝ) : ℝ :=
  Finset.univ.sum fun i : Fin n => Real.exp (- S i)

/-! ## 2. Positivity: Z > 0 for any action

    Sum of positive exponentials is positive. -/

/-- **Path integral positivity**: `Z_E[S] > 0` for any action `S`,
    provided the configuration space is non-empty (n ≥ 1).

    Each summand `exp(-S(i))` is strictly positive. -/
theorem pathIntegralLatticeEuclidean_pos
    {n : ℕ} (hn : 0 < n) (S : Fin n → ℝ) :
    0 < pathIntegralLatticeEuclidean n S := by
  unfold pathIntegralLatticeEuclidean
  -- Sum of positive numbers is positive when at least one summand exists
  apply Finset.sum_pos
  · intro i _; exact Real.exp_pos _
  · -- Need: Finset.univ : Finset (Fin n) is nonempty
    rw [← Finset.card_pos]
    rw [Finset.card_univ, Fintype.card_fin]
    exact hn

/-! ## 3. Special cases: zero action and constant action -/

/-- **Zero action gives count of configurations**:
    `Z_E[S=0] = n` (sum of `exp(0) = 1` over n entries). -/
theorem pathIntegralLatticeEuclidean_zero_action_eq_n (n : ℕ) :
    pathIntegralLatticeEuclidean n (fun _ => 0) = (n : ℝ) := by
  unfold pathIntegralLatticeEuclidean
  simp only [neg_zero, Real.exp_zero]
  -- Σ_{i=0..n-1} 1 = n
  rw [Finset.sum_const, Finset.card_univ, Fintype.card_fin]
  simp

/-- **Constant action**: `Z_E[S = c] = n · exp(-c)`. -/
theorem pathIntegralLatticeEuclidean_const_action
    (n : ℕ) (c : ℝ) :
    pathIntegralLatticeEuclidean n (fun _ => c) = (n : ℝ) * Real.exp (-c) := by
  unfold pathIntegralLatticeEuclidean
  rw [Finset.sum_const, Finset.card_univ, Fintype.card_fin]
  simp

/-! ## 4. Headline composite report -/

/-- **Lion's-Pride Phase 7.6 headline — finite-lattice Euclidean
    path integral structural report.**

    For any finite configuration size `n : ℕ` with `0 < n`, action
    `S : Fin n → ℝ`, and constant `c : ℝ`:

    1. **Path integral is positive**: `Z_E[S] > 0`.

    2. **Zero action = config count**: `Z_E[S=0] = n`.

    3. **Constant action**: `Z_E[S=c] = n · exp(-c)`.

    4. **Path integral is a Σ**: `Z_E[S] = Σ exp(-S(i))`. -/
theorem path_integral_lattice_report
    {n : ℕ} (hn : 0 < n) (S : Fin n → ℝ) (c : ℝ) :
    0 < pathIntegralLatticeEuclidean n S ∧
    pathIntegralLatticeEuclidean n (fun _ => 0) = (n : ℝ) ∧
    pathIntegralLatticeEuclidean n (fun _ => c) = (n : ℝ) * Real.exp (-c) ∧
    pathIntegralLatticeEuclidean n S
      = Finset.univ.sum (fun i : Fin n => Real.exp (- S i)) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact pathIntegralLatticeEuclidean_pos hn S
  · exact pathIntegralLatticeEuclidean_zero_action_eq_n n
  · exact pathIntegralLatticeEuclidean_const_action n c
  · rfl

end OmegaTheory.Foundations.PathIntegralLattice
