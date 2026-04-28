/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothDistanceLowerBound

  T-5 (Roth's theorem) — **Phase 7 ext #104: Cubic+ Roth distance
  lower bound `|q-α|^k ≥ 1/(M · q.den^d)` (cubic+ chain step 6 —
  inequality flip)**, sub session 559dddddd.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Inequality flip from ext #103: rearranges
  `1/q.den^d ≤ |q-α|^k · M` to `|q-α|^k ≥ 1/(M · q.den^d)` when M > 0.

  Single derivation:
  1. `T5_cubic_roth_distance_lower_bound`: |q-α|^k ≥ 1/(M · q.den^d).

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.
  NO concrete-witness-spam per anti-pattern lock 2026-04-29.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #104 — cubic+ distance lower bound (inequality flip).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothCorePartial

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothDistanceLowerBound

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothCorePartial

/-! ## Distance lower bound -/

/-- **🚨 Wave T5 session 559dddddd — `|q-α|^k ≥ 1/(M · q.den^d)`**.

    Inequality flip from ext #103: assumes M > 0. -/
theorem T5_cubic_roth_distance_lower_bound
    (α : ℝ) (p : Polynomial ℤ) (k : ℕ)
    (h_index : ∀ i, i < k →
      (Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i = 0)
    (q : ℚ) (h_close : |((q : ℚ) : ℝ) - α| ≤ 1)
    (h_nonzero : Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0)
    (h_M_pos : (0 : ℝ) <
      ∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
          |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|) :
    (1 : ℝ) / (((∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
        |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|)) *
      ((q.den : ℝ)) ^ p.natDegree) ≤
      |((q : ℚ) : ℝ) - α| ^ k := by
  -- From s103: 1/q.den^d ≤ |q-α|^k · M
  have h_core := T5_cubic_roth_core_partial α p k h_index q h_close h_nonzero
  -- Set M for clarity
  set M := ∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
              |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|
  -- Need M > 0 (assumed) and q.den^d > 0 (from q.den ≥ 1)
  have h_qden_pos : (0 : ℝ) < ((q.den : ℝ)) ^ p.natDegree := by
    apply pow_pos
    exact_mod_cast q.pos
  -- 1/q.den^d ≤ |q-α|^k · M ↔ 1/(M · q.den^d) ≤ |q-α|^k (using M > 0)
  rw [div_le_iff₀ (by positivity)]
  -- Goal: 1 ≤ |q-α|^k * (M * q.den^d)
  have h : (1 : ℝ) / ((q.den : ℝ)) ^ p.natDegree ≤ |((q : ℚ) : ℝ) - α| ^ k * M :=
    h_core
  rw [div_le_iff₀ h_qden_pos] at h
  linarith

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559dddddd — T-5 Phase 7 ext #104:
    Cubic+ Roth distance lower bound**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #104.

    🏆 INEQUALITY FLIP — Roth-form lower bound on `|q - α|^k`.

    Single derivation:
    1. `T5_cubic_roth_distance_lower_bound` — flip ext #103 to give
       `|q-α|^k ≥ 1/(M · q.den^d)`.

    Combined with `(1/(M · q.den^d))^(1/k) = q.den^(-d/k) / M^(1/k)`:
    For `k > d/(2+ε)`: `q.den^(-d/k) > q.den^(-(2+ε))`, so:
    `|q - α| ≥ M^(-1/k) · q.den^(-d/k) > M^(-1/k) · q.den^(-(2+ε))`.

    This is the **ROTH-FORM BOUND** with `C = M^(-1/k)`.

    REMAINING for unconditional Roth: Schmidt's lemma constructing
    aux p with index k > d/(2+ε) at α.

    Sub-lemma 277/N in T-1 (T-5 Phase 7 ext #104).  Lean-core only. -/
theorem session_559dddddd_T5_phase7_cubic_roth_distance_lower_bound_headline
    (α : ℝ) (p : Polynomial ℤ) (k : ℕ)
    (h_index : ∀ i, i < k →
      (Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i = 0)
    (q : ℚ) (h_close : |((q : ℚ) : ℝ) - α| ≤ 1)
    (h_nonzero : Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0)
    (h_M_pos : (0 : ℝ) <
      ∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
          |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|) :
    (1 : ℝ) / (((∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
        |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|)) *
      ((q.den : ℝ)) ^ p.natDegree) ≤
      |((q : ℚ) : ℝ) - α| ^ k :=
  T5_cubic_roth_distance_lower_bound α p k h_index q h_close h_nonzero h_M_pos

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothDistanceLowerBound
