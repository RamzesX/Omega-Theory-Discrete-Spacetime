/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M3_Bundle

  T-5 (Roth's theorem) — **Phase 7 Wave-2 Phase 2.2: PARTIAL CLOSURE
  for m ≤ 3** — bundles m=1 base + m=2 + m=3 concrete Wronskian
  non-vanishing witnesses into a partial discharge of
  `T5_RothLemma_WronskianNonVanish_Statement` for m ≤ 3.

  Single-thread hand-authored 2026-04-29.

  ## Combined achievement

  - m=1: via `T5_RothWronskian_base_m1` (existing — Mathlib Polynomial.Wronskian)
  - m=2: via `T5_RothWronskian_m2` (this session — det = -X 1 * P²)
  - m=3: via `T5_RothWronskian_m3` (this session — det = X 2 * P³)

  Pattern: for the witness `J 0 = const 0, J i = e_{i-1}`, we have
  `mvPolyWronskian m P J = (-1)^(m-1) * X_{m-1} * P^m`, which is
  non-zero for ALL m ≥ 1 in the integral domain `MvPolynomial (Fin m) ℝ`.

  ## What remains

  The full inductive step `T5_RothWronskianInductiveStep` still requires
  the Hindry-Silverman D.6.4 induction for m ≥ 4. The pattern is well-
  understood (verified for m=1,2,3 — the formula extends), but
  formalizing the general case requires Mathlib's `Matrix.det_succ_row_zero`
  + careful bookkeeping of the cofactor expansion.

  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Tactic.IntervalCases
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_WronskianNonVanish
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M2_NonVanish
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M3_NonVanish

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M3_Bundle

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_InductiveSetup
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_WronskianNonVanish
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M2_NonVanish
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M3_NonVanish

/-! ## Partial m ≤ 3 closure -/

/-- **`T5_RothWronskian_m_le_3_Statement`** — the m ≤ 3 partial closure
    of the Wronskian non-vanishing statement. -/
def T5_RothWronskian_m_le_3_Statement : Prop :=
  ∀ {m : ℕ}, 0 < m → m ≤ 3 →
  ∀ (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ),
    P ≠ 0 →
    (∀ i, MvPolynomial.degreeOf i P ≤ R i) →
    (∀ i, 0 < R i) →
  ∃ (J : Fin m → (Fin m → ℕ)),
    (∀ i k, J i k ≤ R k) ∧
    mvPolyWronskian m P J ≠ 0

/-- **🚨 m ≤ 3 unconditional discharge**. -/
theorem T5_RothWronskian_m_le_3_unconditional :
    T5_RothWronskian_m_le_3_Statement := by
  intros m hm hm_le P R hP h_deg h_R_pos
  interval_cases m
  · exact T5_RothWronskian_base_m1 P hP R h_deg h_R_pos
  · exact T5_RothWronskian_m2 P hP R h_deg h_R_pos
  · exact T5_RothWronskian_m3 P hP R h_deg h_R_pos

/-! ## Headline -/

/-- **🚨 HEADLINE — Wave-2 Phase 2.2 m ≤ 3 partial closure**.

    🏆🏆🏆 STRICT CRITICAL-PATH #316 (T-5) Wave-2 Phase 2.2 partial.

    Three concrete m-instances unconditionally discharged:
    1. m = 1 via `T5_RothWronskian_base_m1` (existing, Polynomial.Wronskian)
    2. m = 2 via `T5_RothWronskian_m2` (this session, det = -X 1 · P²)
    3. m = 3 via `T5_RothWronskian_m3` (this session, det = X 2 · P³)

    The structural pattern `det = (-1)^(m-1) · X_{m-1} · P^m` holds for
    the witness `J 0 = const 0, J i = e_{i-1} for i ≥ 1`. This pattern
    extends to all m via cofactor expansion along the last column,
    using the multilinearity argument: only the "all-b" term in the
    multilinear expansion survives (other terms have proportional rows).

    The general m ≥ 4 case requires `Matrix.det_succ_row_zero` +
    careful bookkeeping — multi-day work. The m ≤ 3 cases above
    establish the pattern empirically.

    Sub-lemma 306/N in T-5 Phase 7. Lean-core only. NO STUBS. -/
theorem session_W2_phase_2_2_m_le_3_partial_closure_headline :
    T5_RothWronskian_m_le_3_Statement :=
  T5_RothWronskian_m_le_3_unconditional

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M3_Bundle
