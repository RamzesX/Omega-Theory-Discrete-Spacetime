/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxPolyQuadraticWitness

  T-5 (Roth's theorem) — **Phase 7 ext #130: Schmidt aux poly QUADRATIC
  WITNESS — for p ∈ ℤ[X] with p.natDegree = 2 and aeval α p = 0,
  k = 1 satisfies all Schmidt conditions for any ε > 0**, sub session
  559dddddddd — STRICT critical-path #316 (T-5) Phase 7 ext #130.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Concrete construction of Schmidt aux poly conditions for QUADRATIC α:

  For p ∈ ℤ[X] with `p ≠ 0`, `Polynomial.aeval α p = 0`, `p.natDegree = 2`:
    - k := 1
    - Roth budget: `(1 : ℝ) * (2+ε) = 2+ε > 2 = p.natDegree` ✓ for ε > 0
    - Index ≥ 1: `(taylor α (p.map ℝ)).coeff 0 = 0` ✓ (from aeval = 0)
    - M_pos: `0 < ∑ |coeff_i|` for i ∈ [1, 3] ✓ (from p ≠ 0 + leadingCoeff)

  This is the QUADRATIC discharge — gives unconditional Schmidt-form
  Roth bound for quadratic α via the Schmidt path (alternative to
  Liouville s44+).

  Single derivation:
  1. `T5_schmidt_aux_poly_quadratic_witness`: discharge for quadratic α.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #130 — Schmidt aux poly QUADRATIC WITNESS discharge.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorMPositiveIntPoly
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtIndexOneRoot
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorCoeffZeroEval

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxPolyQuadraticWitness

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorMPositiveIntPoly
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtIndexOneRoot
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorCoeffZeroEval

/-! ## Schmidt aux poly QUADRATIC WITNESS -/

/-- **🚨 Wave T5 session 559dddddddd — Schmidt aux poly QUADRATIC discharge**.

    For p ∈ ℤ[X] with p ≠ 0, aeval α p = 0, p.natDegree = 2, ε > 0:
    k = 1 satisfies all SchmidtAuxPolyExists conditions. -/
theorem T5_schmidt_aux_poly_quadratic_witness
    (α : ℝ) (p : Polynomial ℤ) (hp_ne : p ≠ 0) (hp_root : Polynomial.aeval α p = 0)
    (hp_deg : p.natDegree = 2) (ε : ℝ) (hε : 0 < ε) :
    -- Roth budget condition: (k : ℝ) * (2+ε) > p.natDegree
    ((1 : ℕ) : ℝ) * (2 + ε) > p.natDegree ∧
    -- Index ≥ 1 condition: ∀ i < 1, (taylor α (p.map ℝ)).coeff i = 0
    (∀ i, i < (1 : ℕ) → (Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i = 0) ∧
    -- M_pos condition
    (0 : ℝ) < ∑ i ∈ Finset.Ico 1 ((p.map (Int.castRingHom ℝ)).natDegree + 1),
                |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i| := by
  refine ⟨?_, ?_, ?_⟩
  · -- Roth budget: 1 · (2+ε) = 2+ε > 2 = p.natDegree
    rw [hp_deg]
    push_cast; linarith
  · -- Index ≥ 1: applies ext #122 (Schmidt index ↔ root) backward
    rw [T5_schmidt_index_one_iff_root]
    -- Need: (p.map ℝ).eval α = 0
    -- From hp_root: aeval α p = 0
    -- aeval α p = Polynomial.eval α (p.map (algebraMap ℤ ℝ))
    --          = Polynomial.eval α (p.map (Int.castRingHom ℝ))
    -- (since algebraMap ℤ ℝ = Int.castRingHom ℝ definitionally)
    have h := hp_root
    rw [Polynomial.aeval_def] at h
    -- h : Polynomial.eval₂ (algebraMap ℤ ℝ) α p = 0
    rw [← Polynomial.eval_map] at h
    -- h : eval α (p.map (algebraMap ℤ ℝ)) = 0
    -- algebraMap ℤ ℝ = Int.castRingHom ℝ definitionally
    convert h using 2
  · -- M_pos: applies ext #129 with k = 1, p ≠ 0, k = 1 ≤ p.natDegree = 2
    apply T5_taylor_M_positive_int_poly α p hp_ne 1
    rw [hp_deg]; norm_num

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559dddddddd — T-5 Phase 7 ext #130**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #130.

    🏆 SCHMIDT QUADRATIC DISCHARGE — for p ∈ ℤ[X] with degree 2 and α
       as root, k = 1 satisfies all SchmidtAuxPolyExists conditions for
       any ε > 0.

    Single derivation:
    1. `T5_schmidt_aux_poly_quadratic_witness` — 3-conjunct discharge.

    Strategy:
    - Roth budget `1·(2+ε) > 2` ↔ `ε > 0` ✓
    - Index ≥ 1 ↔ root condition (ext #122) ✓ (from aeval = 0)
    - M_pos via ext #129 (k=1 ≤ 2 = p.natDegree)

    Combined with the conditional capstone (ext #116 / #117 / #119),
    yields unconditional Roth-form bound for quadratic α via Schmidt
    path. This is an ALTERNATIVE proof of quadratic Roth (the existing
    proof via Liouville is in s44+). Cross-validation: two independent
    paths confirm quadratic Roth.

    The CUBIC+ case is NOT covered by this — for d ≥ 3, k = 1 fails
    the Roth budget for ε ≤ d - 2. Cubic+ requires Schmidt-Wirsing-Roth
    multivariate machinery (k ≥ 2 with multivariate index argument).

    Mathlib usage: composition of ext #122 + ext #129 + Polynomial.aeval_def +
    Polynomial.eval_map.

    Sub-lemma 303/N. Lean-core only.

    🏆 First Lean-core T-5 Phase 7 SCHMIDT QUADRATIC WITNESS DISCHARGE.
       Escanor Pride + Erdős Primarch — full prove mode, NO STUBS, NO slim. -/
theorem session_559dddddddd_T5_phase7_schmidt_aux_poly_quadratic_witness_headline
    (α : ℝ) (p : Polynomial ℤ) (hp_ne : p ≠ 0) (hp_root : Polynomial.aeval α p = 0)
    (hp_deg : p.natDegree = 2) (ε : ℝ) (hε : 0 < ε) :
    ((1 : ℕ) : ℝ) * (2 + ε) > p.natDegree ∧
    (∀ i, i < (1 : ℕ) → (Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i = 0) ∧
    (0 : ℝ) < ∑ i ∈ Finset.Ico 1 ((p.map (Int.castRingHom ℝ)).natDegree + 1),
                |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i| :=
  T5_schmidt_aux_poly_quadratic_witness α p hp_ne hp_root hp_deg ε hε

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxPolyQuadraticWitness
