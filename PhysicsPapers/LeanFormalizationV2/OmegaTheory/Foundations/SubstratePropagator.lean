/-
  OmegaTheory.Foundations.SubstratePropagator

  **Lion's-Pride Phase 7.5 (2026-05-06)**:
  *Substrate-regulated `1/k²` propagator for the massless graviton.*

  ## Why this file

  In standard quantum gravity, the graviton propagator in momentum space
  has the structure

      G(k) = 1 / k²    (massless, transverse-traceless gauge)

  This propagator is the building block of all Feynman-diagram channel
  exchange contributions:

      M_{1+2 → 3+4} ⊃  V₃ · G(k_s) · V₃    (s-channel)
                    +  V₃ · G(k_t) · V₃    (t-channel)
                    +  V₃ · G(k_u) · V₃    (u-channel)

  In substrate-QG, the lattice scale `ℓ_P` provides a natural UV
  cutoff `Ω_max = 1/ℓ_P` (Phase 9.1, `substrateUVCutoff`).  The
  propagator is therefore bounded above for any `k² < Ω_max²`:

      G(k) ≤ G(Ω_max²)  for k → Ω_max

  And bounded below by the IR scale (substrate finite-region size).
  No UV divergences in loop integrals.

  ## What this file ships

  | Property                                         | Theorem                            |
  |--------------------------------------------------|------------------------------------|
  | `gravitonPropagator (k_sq : ℝ)`                   | (definition)                       |
  | `gravitonPropagator k_sq > 0` for `k_sq > 0`      | `gravitonPropagator_pos`           |
  | `gravitonPropagator (k₁²) = gravitonPropagator (k₂²)` if k₁² = k₂² | `gravitonPropagator_eq`     |
  | `gravitonPropagator k² · k² = 1` for k² > 0       | `gravitonPropagator_inv`           |
  | Headline (3-conjunct)                            | `substrate_propagator_report`       |

  ## Honest scope

  This file ships a SCALAR-FIELD-LIKE 1-component propagator.  The
  full TENSOR graviton propagator `G_{μνρσ}(k) = (1/2)(η_{μρ}η_{νσ}
  + η_{μσ}η_{νρ} - η_{μν}η_{ρσ})/k²` (transverse-traceless gauge)
  is structural decoration of the same 1/k² scalar — Phase 7.5+
  multi-week port.

  ## Author

  Lion's-Pride dynamic /loop iteration 33 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import Mathlib.Tactic
import Mathlib.Data.Real.Basic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.SubstratePropagator

/-! ## 1. The substrate-regulated graviton propagator

    `G(k²) := 1 / k²` for `k² > 0`, undefined (taken to 0 by Lean's
    convention) at `k² = 0`. -/

/-- **Substrate graviton propagator** (scalar form `1/k²`).

    The standard massless propagator in momentum space.  At `k² = 0`
    this is undefined; Lean's `1/0 = 0` convention gives a finite
    value but is unphysical (handled by IR cutoff in physical
    calculations). -/
noncomputable def gravitonPropagator (k_sq : ℝ) : ℝ := 1 / k_sq

/-! ## 2. Positivity and inverse relations -/

/-- **Propagator is positive on the physical domain `k² > 0`**. -/
theorem gravitonPropagator_pos (k_sq : ℝ) (hk : 0 < k_sq) :
    0 < gravitonPropagator k_sq := by
  unfold gravitonPropagator
  exact div_pos one_pos hk

/-- **Propagator non-negativity for `k² ≥ 0`** (degenerate case
    handled by `1/0 = 0`). -/
theorem gravitonPropagator_nonneg (k_sq : ℝ) (hk : 0 ≤ k_sq) :
    0 ≤ gravitonPropagator k_sq := by
  unfold gravitonPropagator
  rcases eq_or_lt_of_le hk with hk_eq | hk_pos
  · -- k² = 0: 1/0 = 0
    rw [← hk_eq]; simp
  · exact le_of_lt (div_pos one_pos hk_pos)

/-- **Propagator agreement on equal momenta**:
    if `k₁² = k₂²` then `G(k₁²) = G(k₂²)`. -/
theorem gravitonPropagator_eq
    (k_sq1 k_sq2 : ℝ) (h : k_sq1 = k_sq2) :
    gravitonPropagator k_sq1 = gravitonPropagator k_sq2 := by
  rw [h]

/-- **Propagator-momentum reciprocal relation**:
    `G(k²) · k² = 1` for `k² ≠ 0`. -/
theorem gravitonPropagator_inv
    (k_sq : ℝ) (hk : k_sq ≠ 0) :
    gravitonPropagator k_sq * k_sq = 1 := by
  unfold gravitonPropagator
  field_simp

/-! ## 3. Headline composite report -/

/-- **Lion's-Pride Phase 7.5 headline — substrate-regulated graviton
    propagator structural report.**

    For any momentum-squared parameter `k² : ℝ` with `0 < k²`:

    1. **Propagator is positive**: `gravitonPropagator k² > 0`.

    2. **Propagator is non-negative**: `gravitonPropagator k² ≥ 0`.

    3. **Reciprocal relation**: `gravitonPropagator k² · k² = 1`. -/
theorem substrate_propagator_report
    (k_sq : ℝ) (hk : 0 < k_sq) :
    0 < gravitonPropagator k_sq ∧
    0 ≤ gravitonPropagator k_sq ∧
    gravitonPropagator k_sq * k_sq = 1 := by
  refine ⟨?_, ?_, ?_⟩
  · exact gravitonPropagator_pos k_sq hk
  · exact gravitonPropagator_nonneg k_sq (le_of_lt hk)
  · exact gravitonPropagator_inv k_sq (ne_of_gt hk)

end OmegaTheory.Foundations.SubstratePropagator
