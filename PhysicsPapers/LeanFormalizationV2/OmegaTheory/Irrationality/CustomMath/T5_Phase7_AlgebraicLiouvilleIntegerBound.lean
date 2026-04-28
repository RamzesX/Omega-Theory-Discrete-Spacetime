/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_AlgebraicLiouvilleIntegerBound

  T-5 (Roth's theorem) — **Phase 7 ext #55: Liouville-style integer
  non-vanishing bound for irrational algebraic α (cubic+ chain
  Yoneda composite of ext #52 + ext #54)**, sub session 559vvvv —
  STRICT critical-path #316 (T-5) Phase 7 ext #55.

  Single-thread hand-authored 2026-04-28 (cycle 65 → 66 transition).

  ## What this file delivers

  Composes ext #52 (univariate integer non-vanishing lower bound)
  with ext #54 (irrational algebraic α has witness natDegree ≥ 2)
  into a clean Liouville-style integer bound:

  For α : ℝ irrational AND `IsAlgebraic ℤ α`, there exists a
  witness f : ℤ[X] with f.natDegree ≥ 2 such that for any q : ℚ
  with `eval₂ Int.cast q f ≠ 0`:

    `1 / q.den^f.natDegree ≤ |eval₂ Int.cast q f|`

  This is the classical-Liouville style integer bound expressed at
  the polynomial-evaluation level. Combined with future Taylor
  upper bound (cubic+ chain step 4), gives Roth contradiction for
  cubic+ algebraic α.

  Single derivation:
  1. `T5_irrational_algebraic_liouville_integer_bound`: combines
     witness existence + non-vanishing lower bound.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28:
  full prove mode, NO STUBS, NO slim.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #55 — Liouville-style integer bound (cubic+ Yoneda composite).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_UnivariateNonVanishingLowerBound
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_AlgebraicWitnessDegreeTwo

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_AlgebraicLiouvilleIntegerBound

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_UnivariateNonVanishingLowerBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_AlgebraicWitnessDegreeTwo

/-! ## Liouville-style integer bound -/

/-- **🚨 Wave T5 session 559vvvv — Liouville integer bound for irrational
    algebraic α**.

    For α irrational AND `IsAlgebraic ℤ α`, there exists a witness
    f : ℤ[X] with f.natDegree ≥ 2 AND `aeval α f = 0` AND for all q ∈ ℚ
    with `eval₂ Int.cast q f ≠ 0`:
      `1 / q.den^f.natDegree ≤ |eval₂ Int.cast q f|`. -/
theorem T5_irrational_algebraic_liouville_integer_bound
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraic ℤ α) :
    ∃ f : Polynomial ℤ, f ≠ 0 ∧ Polynomial.aeval α f = 0 ∧
      2 ≤ f.natDegree ∧
      ∀ (q : ℚ), Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) f ≠ 0 →
        (1 : ℚ) / ((q.den : ℚ)) ^ f.natDegree ≤
          |Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) f| := by
  -- Get witness with natDegree ≥ 2 from ext #54
  obtain ⟨f, hf_ne, hf_root, hf_deg_ge_two⟩ :=
    T5_irrational_algebraic_witness_natDegree_ge_two α hα h_alg
  refine ⟨f, hf_ne, hf_root, hf_deg_ge_two, ?_⟩
  intros q h_nonzero
  -- Apply ext #52
  exact T5_univariate_nonzero_lower_bound f q h_nonzero

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559vvvv — T-5 Phase 7 ext #55:
    Liouville-style integer bound for irrational algebraic α**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #55.

    🏆 CUBIC+ CHAIN COMPOSITE: ext #52 + ext #54 → classical-Liouville
    integer bound at polynomial-evaluation level.

    Single derivation:
    1. `T5_irrational_algebraic_liouville_integer_bound` — composition.

    For α irrational + algebraic, ∃ witness f with natDegree ≥ 2
    AND |eval₂ q f| ≥ 1/q.den^d when eval₂ q f ≠ 0.

    This is the LIOUVILLE-STYLE bound at degree d ≥ 2 — strictly
    weaker than Roth's `1/H^(2+ε)` for d ≥ 3, but the foundation
    for Roth's improvement via Schmidt-Wirsing-Roth.

    Combined with future Taylor upper bound (`|eval₂ q f| ≤ C ·
    |q-α|^k` for q close to α), forces eval₂ q f = 0 contradiction
    for q.den large + Roth-violating + index k > d/(2+ε).

    Mathlib usage: pure composition of ext #52 + ext #54 — no new
    Mathlib lookup.

    Sub-lemma 248/N in T-1 (T-5 Phase 7 ext #55).  Lean-core only.

    🏆 Cubic+ chain composite — classical Liouville integer bound
    extracted via composition. Escanor Pride + Erdős Primarch —
    full prove mode, NO STUBS, NO slim. -/
theorem session_559vvvv_T5_phase7_algebraic_liouville_integer_bound_headline
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraic ℤ α) :
    ∃ f : Polynomial ℤ, f ≠ 0 ∧ Polynomial.aeval α f = 0 ∧
      2 ≤ f.natDegree ∧
      ∀ (q : ℚ), Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) f ≠ 0 →
        (1 : ℚ) / ((q.den : ℚ)) ^ f.natDegree ≤
          |Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) f| :=
  T5_irrational_algebraic_liouville_integer_bound α hα h_alg

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_AlgebraicLiouvilleIntegerBound
