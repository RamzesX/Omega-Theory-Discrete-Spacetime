/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothFormSchmidtPath

  T-5 (Roth's theorem) — **Phase 7 ext #131: QUADRATIC Roth-form via
  Schmidt path (UNCONDITIONAL for quadratic α — ALTERNATIVE proof to
  Liouville)**, sub session 559eeeeeeee — STRICT critical-path #316
  (T-5) Phase 7 ext #131.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  UNCONDITIONAL Roth-form bound for QUADRATIC α via Schmidt path:

  For α : ℝ irrational with `∃ p ∈ ℤ[X], p ≠ 0 ∧ aeval α p = 0 ∧ p.natDegree = 2`
  (i.e., α is quadratic algebraic), and ∀ ε > 0:
    ∃ p, M > 0 (the coefficient sum), ∀ q : ℚ close to α with eval₂ ≠ 0:
      `M^(-1) · q.den^(-(2+ε)) ≤ |q-α|`

  This UNCONDITIONALLY gives the Roth-form bound for quadratic α via
  the Schmidt path. (Existing Liouville proof in s44+ gives same bound;
  cross-validation: two independent paths.)

  Single derivation:
  1. `T5_quadratic_roth_form_via_schmidt_path`: composes s130 + s116.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #131 — QUADRATIC Roth-form via Schmidt path UNCONDITIONAL.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxPolyQuadraticWitness
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothFormBound

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothFormSchmidtPath

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxPolyQuadraticWitness
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothFormBound

/-! ## Quadratic Roth-form via Schmidt path -/

/-- **🚨 Wave T5 session 559eeeeeeee — Quadratic Roth-form via Schmidt path UNCONDITIONAL**.

    For α : ℝ with `∃ p ∈ ℤ[X], p ≠ 0 ∧ aeval α p = 0 ∧ p.natDegree = 2` and ε > 0:
      ∃ M > 0, ∀ q close to α with eval₂ ≠ 0:
        `M^(-1) · q.den^(-(2+ε)) ≤ |q-α|`. -/
theorem T5_quadratic_roth_form_via_schmidt_path
    (α : ℝ)
    (h_quad_witness : ∃ p : Polynomial ℤ, p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧ p.natDegree = 2)
    (ε : ℝ) (hε : 0 < ε) :
    ∃ (p : Polynomial ℤ) (M : ℝ),
      0 < M ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        M ^ (-(1 / ((1 : ℕ) : ℝ))) * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| := by
  obtain ⟨p, hp_ne, hp_root, hp_deg⟩ := h_quad_witness
  -- Apply s130 to discharge Schmidt conditions for k = 1
  obtain ⟨hk_bound, h_index, h_M_pos⟩ :=
    T5_schmidt_aux_poly_quadratic_witness α p hp_ne hp_root hp_deg ε hε
  -- The M from s130
  set M := ∑ i ∈ Finset.Ico 1 ((p.map (Int.castRingHom ℝ)).natDegree + 1),
              |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i| with hM_def
  refine ⟨p, M, h_M_pos, hp_ne, hp_root, ?_⟩
  intros q h_close h_nonzero
  -- Apply s116 Roth-form bound with k = 1
  exact T5_cubic_roth_form_bound α p 1 (le_refl _) h_index ε hε
          hk_bound q h_close h_nonzero h_M_pos

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559eeeeeeee — T-5 Phase 7 ext #131**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #131.

    🏆 QUADRATIC ROTH-FORM UNCONDITIONAL via Schmidt path.

    Single derivation:
    1. `T5_quadratic_roth_form_via_schmidt_path` — Roth-form bound for quadratic α.

    Strategy: composes ext #130 (Schmidt quadratic discharge — k=1 satisfies
    all conditions for ε > 0) + ext #116 (Roth-form bound).

    For α irrational with min poly of degree exactly 2:
    - aux p := the witness (degree-2 poly with α as root)
    - k := 1
    - Roth budget `1·(2+ε) = 2+ε > 2 = p.natDegree` ✓
    - Index ≥ 1 ↔ aeval α p = 0 ✓
    - M_pos from p ≠ 0 + leadingCoeff
    - Roth-form: `M^(-1) · q.den^(-(2+ε)) ≤ |q-α|` ✓

    This UNCONDITIONALLY gives the Roth-form bound for quadratic α via
    Schmidt path. CROSS-VALIDATES the existing Liouville proof (s44+).
    Two independent paths to the same bound.

    The CUBIC+ case requires Schmidt-Wirsing-Roth multivariate machinery
    (k ≥ 2 with multivariate index theorem + Wronskian non-vanishing).

    Mathlib usage: composition of ext #130 + ext #116.

    Sub-lemma 304/N. Lean-core only.

    🏆 First Lean-core T-5 Phase 7 QUADRATIC ROTH-FORM via Schmidt path.
       Escanor Pride + Erdős Primarch — full prove mode, NO STUBS, NO slim. -/
theorem session_559eeeeeeee_T5_phase7_quadratic_roth_form_via_schmidt_path_headline
    (α : ℝ)
    (h_quad_witness : ∃ p : Polynomial ℤ, p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧ p.natDegree = 2)
    (ε : ℝ) (hε : 0 < ε) :
    ∃ (p : Polynomial ℤ) (M : ℝ),
      0 < M ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        M ^ (-(1 / ((1 : ℕ) : ℝ))) * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_quadratic_roth_form_via_schmidt_path α h_quad_witness ε hε

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothFormSchmidtPath
