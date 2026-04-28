/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothSetup

  T-5 (Roth's theorem) — **Phase 7 ext #30: Roth contradiction setup —
  combining bridge + lower bound**, sub session 559www —
  STRICT critical-path #316 (T-5) Phase 7 ext #30.

  Single-thread hand-authored 2026-04-28 (cycle 65 — post-restart).

  ## What this file delivers

  Combination theorem stitching ext #29 (`T5_conditional_roth`,
  `MultiIteratedPDerivBridge` → `eval α p = 0`) + ext #23
  (`T5_polyToCoeffs_abs_sum_ge_one`, p ≠ 0 → 1 ≤ ∑ |c k|) into
  the FULL Roth contradiction setup:

  Given the bridge hypothesis, there exists a polynomial p with:
  - p ≠ 0
  - p ∈ restrictDegree (Fin n) ℤ d
  - (eval α) p = 0  (the bridge consequence)
  - 1 ≤ ∑ k, |polyToCoeffs p k|  (integer non-vanishing of coefficients)

  This is the **structural setup for Roth's contradiction**: the
  auxiliary polynomial vanishes at α (from bridge) AND has at least
  one non-zero integer coefficient (from `Int.one_le_abs`). The
  remaining work is the Liouville-type analytical bound at rational
  q close to α (ext #31+).

  Single derivation:
  1. `T5_roth_setup_combined`: full contradiction setup theorem

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #30 — Roth contradiction structural setup.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_ConditionalRoth
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyToCoeffsLowerBound

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothSetup

open MvPolynomial Matrix
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMultiIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyToCoeffs
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyToCoeffsLowerBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_ConditionalRoth

/-! ## Roth contradiction setup -/

/-- **🚨 Wave T5 session 559www — Roth contradiction structural setup**.

    Given the `MultiIteratedPDerivBridge` hypothesis, the Schmidt-Wirsing
    auxiliary polynomial vanishes at α AND has non-zero integer coeff
    abs-sum:

      ∃ p, p ≠ 0 ∧ p ∈ restrictDegree (Fin n) ℤ d ∧
        (eval α) p = 0 ∧
        1 ≤ ∑ k : BoundedMI n d, |polyToCoeffs p k|

    This composes ext #29 (bridge → eval p = 0) with ext #23
    (p ≠ 0 → 1 ≤ ∑ |c k|). -/
theorem T5_roth_setup_combined
    (h_bridge : MultiIteratedPDerivBridge)
    {n d : ℕ} {J : Type} [Fintype J]
    (I : J → BoundedMI n d) (α : Fin n → ℤ)
    (h_dim : Fintype.card J < (d + 1) ^ n)
    (h_J_pos : 0 < Fintype.card J) :
    ∃ p : MvPolynomial (Fin n) ℤ,
      p ≠ 0 ∧
      p ∈ MvPolynomial.restrictDegree (Fin n) ℤ d ∧
      (MvPolynomial.eval α) p = 0 ∧
      1 ≤ ∑ k : BoundedMI n d, |(polyToCoeffs (d := d) p) k| := by
  obtain ⟨p, hp_ne, hp_mem, hp_eval⟩ :=
    T5_conditional_roth h_bridge I α h_dim h_J_pos
  refine ⟨p, hp_ne, hp_mem, hp_eval, ?_⟩
  exact T5_polyToCoeffs_abs_sum_ge_one p hp_ne hp_mem

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559www — T-5 Phase 7 ext #30:
    Roth contradiction structural setup**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #30.

    Composition theorem stitching ext #29 (bridge → eval p = 0) +
    ext #23 (p ≠ 0 → 1 ≤ ∑ |c k|) into the full Roth setup:

        ∃ p, p ≠ 0 ∧ p ∈ restrictDegree ∧
          (eval α) p = 0 ∧
          1 ≤ ∑ k, |polyToCoeffs p k|

    Single derivation:
    1. `T5_roth_setup_combined` — combined setup theorem.

    Structural setup for Roth's contradiction: the auxiliary
    polynomial vanishes at α (from bridge) AND has at least one
    non-zero integer coefficient (from `Int.one_le_abs`).

    Remaining for full Roth:
    - Liouville-type analytical bound at rational q close to α
      (ext #31+)
    - Discharge `MultiIteratedPDerivBridge` via Mathlib `pderiv_mul`
      Leibniz + Phase 5 cross-variable vocabulary
    - Compose into `RothTheorem` Prop in `T5_RothMasterStatement`

    Mathlib usage: composition of ext #29 + ext #23 (no new
    Mathlib lookup at this layer).

    Sub-lemma 223/N in T-1 (T-5 Phase 7 ext #30).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 Roth contradiction structural
    setup (bridge + integer non-vanishing combined). -/
theorem session_559www_T5_phase7_roth_setup_combined_headline
    (h_bridge : MultiIteratedPDerivBridge)
    {n d : ℕ} {J : Type} [Fintype J]
    (I : J → BoundedMI n d) (α : Fin n → ℤ)
    (h_dim : Fintype.card J < (d + 1) ^ n)
    (h_J_pos : 0 < Fintype.card J) :
    ∃ p : MvPolynomial (Fin n) ℤ,
      p ≠ 0 ∧
      p ∈ MvPolynomial.restrictDegree (Fin n) ℤ d ∧
      (MvPolynomial.eval α) p = 0 ∧
      1 ≤ ∑ k : BoundedMI n d, |(polyToCoeffs (d := d) p) k| :=
  T5_roth_setup_combined h_bridge I α h_dim h_J_pos

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothSetup
