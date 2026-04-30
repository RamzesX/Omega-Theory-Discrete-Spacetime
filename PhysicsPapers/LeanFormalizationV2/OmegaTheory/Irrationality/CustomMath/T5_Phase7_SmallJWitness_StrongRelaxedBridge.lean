/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_SmallJWitness_StrongRelaxedBridge

  T-5 (Roth's theorem) — **Yoneda-style bridge: strong smallJ → relaxed smallJ**.

  The strong form `T5_NAMED_smallJ_witness_at_q` has bound `≤ t - √(mε)`.
  The relaxed form `T5_NAMED_smallJ_witness_at_q_relaxed` has bound
  `≤ t - √(mε) + ε/m` (relaxed by extra `ε/m` slack).

  Strong ⇒ relaxed is TRIVIAL: the strong bound is tighter, so the
  relaxed (looser) bound also holds.

  Strategic significance: documents the strict-→-relaxed direction.
  The reverse (relaxed-→-strict) requires the δ → 0 limit machinery
  (DLP-1 + DLP-2 + DLP-3 in `T5_Phase7_DeltaLimit_Packaging`).

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8AtomOne_via_SJWC
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8D5_SmallJWitness_Reduction

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_SmallJWitness_StrongRelaxedBridge

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8AtomOne_via_SJWC
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8D5_SmallJWitness_Reduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex

/-! ## SJSR-1 — Strong implies relaxed (Yoneda bridge) -/

/-- **SJSR-1 — `T5_strong_smallJ_implies_relaxed`**: the strict-form
    smallJ witness implies the relaxed-form smallJ witness.

    Direct: the bound `≤ t - √(mε)` is tighter than `≤ t - √(mε) + ε/m`
    (since ε > 0 and m > 0 imply ε/m > 0).  The same witness `j` works,
    just with the looser conclusion. -/
theorem T5_strong_smallJ_implies_relaxed
    (h_strong : T5_NAMED_smallJ_witness_at_q) :
    T5_NAMED_smallJ_witness_at_q_relaxed := by
  intros m hm P R α q ε t hP hε hR_deg hR_pos hq_den h_growth h_balance h_t
  unfold T5_NAMED_smallJ_witness_at_q at h_strong
  obtain ⟨j, h_aeval_ne, h_sum_le⟩ :=
    h_strong hm P R α q ε t hP hε hR_deg hR_pos hq_den h_growth h_balance h_t
  refine ⟨j, h_aeval_ne, ?_⟩
  -- h_sum_le : ∑ j_i / R_i ≤ t - √(mε)
  -- Goal: ∑ j_i / R_i ≤ t - √(mε) + ε/m
  -- Need: ε/m ≥ 0 (since ε > 0 and m ≥ 1 > 0)
  have hm_pos : (0 : ℝ) < (m : ℝ) := by exact_mod_cast hm
  have h_eps_div_m_nn : 0 ≤ ε / (m : ℝ) := div_nonneg (le_of_lt hε) (le_of_lt hm_pos)
  linarith

/-! ## SJSR-2 — Headline: bidirectional architecture -/

/-- **🚨🚨 SJSR-2 — `T5_SMALLJ_STRONG_RELAXED_BRIDGE_HEADLINE`**:
    paper-citable bundle documenting the Yoneda bridge.

    Strategic significance: completes the bidirectional architecture
    between strong and relaxed smallJ witness forms.  Combined with
    DLP-3 (relaxed → strict via δ → 0 limit), the two forms are
    equivalent (modulo small-ε constraint ε₀ ≤ m³/4). -/
theorem T5_SMALLJ_STRONG_RELAXED_BRIDGE_HEADLINE :
    -- Strong implies relaxed (TRIVIAL direction)
    (T5_NAMED_smallJ_witness_at_q → T5_NAMED_smallJ_witness_at_q_relaxed) :=
  T5_strong_smallJ_implies_relaxed

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_SmallJWitness_StrongRelaxedBridge
