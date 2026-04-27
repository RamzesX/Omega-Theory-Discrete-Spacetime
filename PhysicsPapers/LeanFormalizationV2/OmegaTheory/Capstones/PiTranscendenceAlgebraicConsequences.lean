/-
  OmegaTheory.Capstones.PiTranscendenceAlgebraicConsequences

  Cycle 64 (Pisces) Phase B Wave T-4b session 64 — algebraic consequences
  of unconditional π-transcendence.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Concrete consequences of `pi_transcendental_unconditional`:

  1. **`pi_add_algebraic_transcendental`** — π + α transcendental for any
     algebraic α (otherwise π would be algebraic by subalgebra closure).
  2. **`pi_mul_algebraic_transcendental`** — π · α transcendental for any
     algebraic α ≠ 0 (otherwise π would be algebraic).
  3. **`pi_add_rat_transcendental`** — specialization: π + q for q : ℚ.
  4. **`pi_mul_rat_nonzero_transcendental`** — specialization: q · π for
     nonzero q : ℚ.
  5. **`pi_sub_algebraic_transcendental`** — π - α transcendental.
  6. **`neg_pi_transcendental`** — -π transcendental.

  All Lean-core only via `Subalgebra.algebraicClosure` machinery.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Capstones.PiTranscendenceAxiomRetirementFinal
import Mathlib.RingTheory.Algebraic.Integral

namespace OmegaTheory.Capstones.PiTranscendenceAlgebraicConsequences

open OmegaTheory.Capstones.PiTranscendenceAxiomRetirementFinal

/-! ## π + algebraic = transcendental -/

/-- **Wave T4b session 64 — π + α transcendental for any algebraic α**.

    Proof: if π + α were algebraic and α is algebraic, then by the
    subalgebra-closure of algebraic elements,
    π = (π + α) + (-α) would also be algebraic.  Contradiction with
    `pi_transcendental_unconditional`. -/
theorem pi_add_algebraic_transcendental
    {α : ℝ} (h_alg : IsAlgebraic ℚ α) :
    Transcendental ℚ ((Real.pi : ℝ) + α) := by
  intro h_pi_plus_alg
  apply pi_transcendence_axiom_retired_unconditional
  -- π = (π + α) - α
  have : (Real.pi : ℝ) = ((Real.pi : ℝ) + α) - α := by ring
  rw [this]
  exact h_pi_plus_alg.sub h_alg

/-! ## π - algebraic = transcendental -/

/-- **Wave T4b session 64 — π - α transcendental for any algebraic α**. -/
theorem pi_sub_algebraic_transcendental
    {α : ℝ} (h_alg : IsAlgebraic ℚ α) :
    Transcendental ℚ ((Real.pi : ℝ) - α) := by
  intro h_pi_minus_alg
  apply pi_transcendence_axiom_retired_unconditional
  -- π = (π - α) + α
  have : (Real.pi : ℝ) = ((Real.pi : ℝ) - α) + α := by ring
  rw [this]
  exact h_pi_minus_alg.add h_alg

/-! ## π × algebraic ≠ 0 = transcendental -/

/-- **Wave T4b session 64 — π · α transcendental for nonzero algebraic α**.

    Proof: if π·α algebraic with α ≠ 0 algebraic, then in field ℝ,
    π = (π·α) · α⁻¹ is algebraic (since algebraic elements are closed
    under field operations). Contradiction. -/
theorem pi_mul_algebraic_transcendental
    {α : ℝ} (h_alg : IsAlgebraic ℚ α) (h_ne : α ≠ 0) :
    Transcendental ℚ ((Real.pi : ℝ) * α) := by
  intro h_pi_mul_alg
  apply pi_transcendence_axiom_retired_unconditional
  -- π = (π · α) / α
  have h_pi_eq : (Real.pi : ℝ) = ((Real.pi : ℝ) * α) * α⁻¹ := by
    field_simp
  rw [h_pi_eq]
  -- α⁻¹ is algebraic (from h_alg via inv_mem_of_algebraic in field ℝ)
  have h_alg_inv : IsAlgebraic ℚ α⁻¹ := h_alg.inv
  exact h_pi_mul_alg.mul h_alg_inv

/-! ## Specializations -/

/-- **Wave T4b session 64 — π + q transcendental for q : ℚ**. -/
theorem pi_add_rat_transcendental (q : ℚ) :
    Transcendental ℚ ((Real.pi : ℝ) + (q : ℝ)) :=
  pi_add_algebraic_transcendental (isAlgebraic_algebraMap q)

/-- **Wave T4b session 64 — π - q transcendental for q : ℚ**. -/
theorem pi_sub_rat_transcendental (q : ℚ) :
    Transcendental ℚ ((Real.pi : ℝ) - (q : ℝ)) :=
  pi_sub_algebraic_transcendental (isAlgebraic_algebraMap q)

/-- **Wave T4b session 64 — q · π transcendental for nonzero q : ℚ**. -/
theorem pi_mul_rat_nonzero_transcendental (q : ℚ) (h_ne : (q : ℝ) ≠ 0) :
    Transcendental ℚ ((Real.pi : ℝ) * (q : ℝ)) :=
  pi_mul_algebraic_transcendental (isAlgebraic_algebraMap q) h_ne

/-! ## -π is transcendental -/

/-- **Wave T4b session 64 — -π transcendental**.

    -π = π · (-1), and -1 is algebraic (rational), so apply
    `pi_mul_algebraic_transcendental`. -/
theorem neg_pi_transcendental :
    Transcendental ℚ (-(Real.pi : ℝ)) := by
  -- -π = (-1) · π = π · (-1)
  have h_eq : -(Real.pi : ℝ) = (Real.pi : ℝ) * ((-1 : ℚ) : ℝ) := by
    push_cast
    ring
  rw [h_eq]
  apply pi_mul_algebraic_transcendental (isAlgebraic_algebraMap _)
  push_cast
  norm_num

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 64 — π algebraic-closure consequences**.

    All algebraic combinations involving π (with at least one π factor
    or summand) are transcendental.  Lean-core only. -/
theorem session_64_pi_algebraic_consequences_headline :
    -- (1) π + algebraic α is transcendental
    (∀ α : ℝ, IsAlgebraic ℚ α →
        Transcendental ℚ ((Real.pi : ℝ) + α))
    -- (2) π - algebraic α is transcendental
    ∧ (∀ α : ℝ, IsAlgebraic ℚ α →
        Transcendental ℚ ((Real.pi : ℝ) - α))
    -- (3) π · nonzero algebraic α is transcendental
    ∧ (∀ α : ℝ, IsAlgebraic ℚ α → α ≠ 0 →
        Transcendental ℚ ((Real.pi : ℝ) * α))
    -- (4) -π is transcendental
    ∧ Transcendental ℚ (-(Real.pi : ℝ))
    -- (5) π + q is transcendental for any q : ℚ
    ∧ (∀ q : ℚ, Transcendental ℚ ((Real.pi : ℝ) + (q : ℝ))) := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · intros α h_alg
    exact pi_add_algebraic_transcendental h_alg
  · intros α h_alg
    exact pi_sub_algebraic_transcendental h_alg
  · intros α h_alg h_ne
    exact pi_mul_algebraic_transcendental h_alg h_ne
  · exact neg_pi_transcendental
  · exact pi_add_rat_transcendental

end OmegaTheory.Capstones.PiTranscendenceAlgebraicConsequences
