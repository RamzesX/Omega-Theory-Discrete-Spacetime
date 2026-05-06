/-
  OmegaTheory.Foundations.HiggsDoubletBridge

  **Phase B step 5 (2026-05-06)**:
  *Back-compat bridge linking the new `HiggsDoublet := Fin 2 → ℂ`
  type (Phase B step 1) to the existing `higgs_vev N : ℝ` scalar
  in `Emergence/HiggsFromError.lean`. After this bridge, every
  existing Yukawa/mass theorem automatically inherits the doublet
  structure.*

  ## Why this file

  Phase B step 1 (`HiggsDoubletStructure.lean`) introduced the
  proper doublet type `HiggsDoublet := Fin 2 → ℂ`.  But the
  pre-existing infrastructure (`Emergence/HiggsFromError.lean`,
  `HealingFlow/HiggsScalarField.lean`, `Emergence/YukawaMatrix.lean`,
  `Foundations/YukawaMassBirthEvent.lean`, etc.) all use
  `higgs_vev N : ℝ`. To avoid a massive migration, this file ships
  a **bridge**: the substrate's broken-vacuum doublet
  `H_substrate_vacuum N := (0, higgs_vev N)ᵀ` projects via the
  radial-mode operator to exactly `higgs_vev N`.

  This is the **two-line `rfl`** the planning document promised.

  ## What this file ships

  | Declaration                                | Type / Theorem                  |
  |--------------------------------------------|---------------------------------|
  | `H_substrate_vacuum N : HiggsDoublet`      | def (broken-vacuum config)      |
  | `HiggsRadial : HiggsDoublet → ℝ`           | def (`(H 1).re` projection)     |
  | `higgs_vev_eq_HiggsDoublet_radial N`       | the bridge theorem (`rfl`)      |
  | `H_substrate_vacuum_upper_zero`            | charged component vanishes      |
  | `H_substrate_vacuum_lower_real`            | neutral component is real, =v   |
  | `H_substrate_vacuum_pos_radial`            | radial part is positive         |
  | Headline                                   | `higgs_doublet_bridge_report`   |

  ## Honest scope

  Pure type-alignment.  The `H_substrate_vacuum` is the standard
  textbook EW broken-vacuum convention `H = (0, v)ᵀ`.  All theorems
  resolve by `rfl`/`simp` after the radial projection's
  `(↑r : ℂ).re = r` reduction.  No new axioms.

  ## Lion's-Pride doctrine

  Rule 1: zero `sorry`.  Rule 2: zero new axioms.

  ## Author

  Single-thread Opus 4.7 [1M context].  Phase B step 5 of the
  full-mode plan (2026-05-06).
-/

import OmegaTheory.Foundations.HiggsDoubletStructure
import OmegaTheory.Emergence.HiggsFromError
import Mathlib.Data.Complex.Basic
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.HiggsDoubletBridge

open OmegaTheory.Foundations.HiggsDoubletStructure
open OmegaTheory.Emergence.HiggsFromError

/-! ## 1. Substrate broken-vacuum doublet

    After EW symmetry breaking, the SM's broken-vacuum convention
    selects a Higgs doublet of the form `H = (0, v)ᵀ` with `v` real
    and positive (the radial mode).  In OmegaTheory, `v = higgs_vev N`. -/

/-- **Substrate broken-vacuum doublet** at iteration N:
    `H_substrate_vacuum N = (0, higgs_vev N)ᵀ`.

    The standard textbook EW broken vacuum: charged upper component
    vanishes, neutral lower component is real and equals `v`. -/
noncomputable def H_substrate_vacuum (N : ℕ) : HiggsDoublet := fun i =>
  if i = 0 then (0 : ℂ) else ((higgs_vev N : ℝ) : ℂ)

/-! ## 2. Radial-mode projection

    The physical Higgs `h` is the real part of the lower component
    of the doublet: `h(x) = Re(H⁰(x))`.  After SSB this real part
    has the substrate value `higgs_vev N`. -/

/-- **Radial-mode projection** `H ↦ Re(H 1)`. Selects the physical
    real Higgs scalar from the doublet's lower (neutral) component. -/
noncomputable def HiggsRadial (H : HiggsDoublet) : ℝ := (H 1).re

/-! ## 3. The bridge theorem

    The substrate's `higgs_vev N : ℝ` IS the radial mode of the
    broken-vacuum doublet `H_substrate_vacuum N`. -/

/-- **Substrate bridge theorem** — `higgs_vev N` equals the radial
    projection of the broken-vacuum doublet at iteration N.

    This is the back-compat closure: every existing theorem that
    uses `higgs_vev N : ℝ` directly (Yukawa mass, Mexican-hat,
    W-mass, etc.) AUTOMATICALLY inherits the doublet structure
    via this bridge. -/
theorem higgs_vev_eq_HiggsDoublet_radial (N : ℕ) :
    higgs_vev N = HiggsRadial (H_substrate_vacuum N) := by
  unfold HiggsRadial H_substrate_vacuum
  simp

/-! ## 4. Component properties of the broken vacuum -/

/-- **Charged upper component vanishes** at the broken vacuum:
    `H_substrate_vacuum N 0 = 0`. -/
theorem H_substrate_vacuum_upper_zero (N : ℕ) :
    H_substrate_vacuum N 0 = 0 := by
  unfold H_substrate_vacuum; simp

/-- **Neutral lower component is real** at the broken vacuum:
    `H_substrate_vacuum N 1 = ↑(higgs_vev N)`. -/
theorem H_substrate_vacuum_lower_real (N : ℕ) :
    H_substrate_vacuum N 1 = ((higgs_vev N : ℝ) : ℂ) := by
  unfold H_substrate_vacuum; simp

/-- **Radial part is positive** at the broken vacuum:
    `0 < HiggsRadial (H_substrate_vacuum N)`.  Reuses
    `higgs_vev_pos` from `Emergence/HiggsFromError.lean`. -/
theorem H_substrate_vacuum_pos_radial (N : ℕ) :
    0 < HiggsRadial (H_substrate_vacuum N) := by
  rw [← higgs_vev_eq_HiggsDoublet_radial]
  exact higgs_vev_pos N

/-- **Radial part is non-negative** (positivity weaker form). -/
theorem H_substrate_vacuum_nonneg_radial (N : ℕ) :
    0 ≤ HiggsRadial (H_substrate_vacuum N) :=
  le_of_lt (H_substrate_vacuum_pos_radial N)

/-! ## 5. Headline composite -/

/-- **Phase B step 5 headline — Higgs doublet ↔ scalar VEV bridge.**

    Four-conjunct closing the back-compat link between the new
    `HiggsDoublet := Fin 2 → ℂ` type and the existing
    `higgs_vev N : ℝ` substrate scalar:

    1. **Bridge identity**: `higgs_vev N = HiggsRadial (H_substrate_vacuum N)`.
       The substrate scalar IS the radial-mode projection.

    2. **Charged upper vanishes**: `H_substrate_vacuum N 0 = 0`.
       The H⁺ component is zero at the broken vacuum (textbook).

    3. **Neutral lower is real**: `H_substrate_vacuum N 1 = ↑(higgs_vev N)`.
       The H⁰ component carries the substrate VEV as a pure real.

    4. **Radial positivity**: `0 < HiggsRadial (H_substrate_vacuum N)`.
       Inherits `higgs_vev_pos` from `HiggsFromError.lean`.

    After this bridge, every existing Yukawa/mass theorem
    automatically inherits the doublet structure: the substrate's
    `m_f = y_f · higgs_vev N` becomes `m_f = y_f · HiggsRadial (broken vacuum)`. -/
theorem higgs_doublet_bridge_report (N : ℕ) :
    higgs_vev N = HiggsRadial (H_substrate_vacuum N) ∧
    H_substrate_vacuum N 0 = 0 ∧
    H_substrate_vacuum N 1 = ((higgs_vev N : ℝ) : ℂ) ∧
    0 < HiggsRadial (H_substrate_vacuum N) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact higgs_vev_eq_HiggsDoublet_radial N
  · exact H_substrate_vacuum_upper_zero N
  · exact H_substrate_vacuum_lower_real N
  · exact H_substrate_vacuum_pos_radial N

end OmegaTheory.Foundations.HiggsDoubletBridge
