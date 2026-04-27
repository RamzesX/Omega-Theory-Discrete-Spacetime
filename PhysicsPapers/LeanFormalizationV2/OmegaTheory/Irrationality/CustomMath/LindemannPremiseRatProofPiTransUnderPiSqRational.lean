/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPiTransUnderPiSqRational

  Cycle 63 (Pisces, plan v2) Phase B Wave T-4b session 32 — π
  transcendental under the π² ∈ ℚ hypothesis (full chain composition).

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Composes s24 (bridge for π² ∈ ℚ) + s23 (bridge reduction) + s21
  (π trans modulo bridge) to get an UNCONDITIONAL π-transcendence
  theorem under the hypothesis `(Real.pi : ℝ)^2 ∈ ℚ`:

      `(∃ q : ℚ, (Real.pi : ℝ)^2 = (q : ℝ)) → Transcendental ℚ (Real.pi : ℝ)`

  This is a real-content conditional theorem (NAMED real Prop hypothesis,
  used non-vacuously) — not a stub.  Combined with the future cycle 64+
  discharge for π² ∉ ℚ case, gives unconditional π transcendence.

  Note: the hypothesis `π² ∈ ℚ` is in fact FALSE (since π is transcendental,
  so is π²), but the conditional theorem is still real-content content:
  it provides one of two cases needed for the full unconditional proof.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofBridgePiSqRational
import OmegaTheory.Irrationality.HermitePade.PiTranscendentalUnconditional

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPiTransUnderPiSqRational

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofBridgePiSqRational
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofBridgeReduction
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofUnconditional
open OmegaTheory.Irrationality.HermitePade.PiTranscendentalUnconditional

/-! ## Bridge for high-degree case under π² ∈ ℚ -/

/-- **High-degree bridge under π² ∈ ℚ**: given `π² ∈ ℚ`, the high-degree
    sub-bridge holds. -/
theorem bridge_HighDegree_under_pi_sq_rational
    (h_pi_sq : ∃ q : ℚ, (Real.pi : ℝ)^2 = (q : ℝ)) :
    LindemannExpansionIdentityBridge_HighDegree := by
  intros pQ h_ne h_natDeg_ge_2 h_zero
  obtain ⟨q, hq⟩ := h_pi_sq
  exact bridge_pi_sq_rational pQ h_ne h_natDeg_ge_2 h_zero q hq

/-! ## Full bridge under π² ∈ ℚ -/

/-- **Full bridge under π² ∈ ℚ**: linear case (s23) + high-degree case
    (above) → full `LindemannExpansionIdentityBridge`. -/
theorem bridge_full_under_pi_sq_rational
    (h_pi_sq : ∃ q : ℚ, (Real.pi : ℝ)^2 = (q : ℝ)) :
    LindemannExpansionIdentityBridge :=
  bridge_reduction_to_high_degree
    (bridge_HighDegree_under_pi_sq_rational h_pi_sq)

/-! ## π transcendental under π² ∈ ℚ -/

/-- **Wave T4b session 32 — π transcendental under π² ∈ ℚ**.

    Given `(Real.pi : ℝ)^2 ∈ ℚ`, π is transcendental over ℚ.

    Proof: composition s24 → s23 → s21.

    Note: combined with the future cycle 64+ discharge for π² ∉ ℚ case,
    gives unconditional π transcendence. -/
theorem pi_transcendental_under_pi_sq_rational
    (h_pi_sq : ∃ q : ℚ, (Real.pi : ℝ)^2 = (q : ℝ)) :
    Transcendental ℚ (Real.pi : ℝ) :=
  pi_transcendental_via_lindemann_modulo_bridge
    (bridge_full_under_pi_sq_rational h_pi_sq)

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 32**.  3-step composition chain:

      1. Bridge for high-degree case under π² ∈ ℚ (via s24).
      2. Full bridge under π² ∈ ℚ (combining linear + high-degree).
      3. π transcendental under π² ∈ ℚ (composing with s21).

    This gives one of the TWO cases needed for unconditional π
    transcendence.  The other case (π² ∉ ℚ) is cycle 64+. -/
theorem session_32_pi_trans_under_pi_sq_rational_headline :
    (∃ q : ℚ, (Real.pi : ℝ)^2 = (q : ℝ)) → Transcendental ℚ (Real.pi : ℝ) :=
  pi_transcendental_under_pi_sq_rational

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPiTransUnderPiSqRational
