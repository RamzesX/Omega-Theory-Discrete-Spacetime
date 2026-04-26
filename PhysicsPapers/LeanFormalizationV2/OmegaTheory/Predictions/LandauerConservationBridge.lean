/-
  LandauerConservationBridge.lean — Cycle 61 Capricornus Phase B Wave 2 W2.1 (Encke)

  **Bridge: Landauer in Predictions ↔ Landauer in Conservation.**

  The substrate carries TWO definitions of the per-bit erasure energy that
  agree on the nose but live in different namespaces:

  * `OmegaTheory.Predictions.landauerEnergyPerBit T = k_B · T · log 2`
      (substrate-information capstone, paired with `bekensteinEntropyBits`
       and `substrateInformationCorrection`)
  * `OmegaTheory.Conservation.landauerEnergy       T = k_B · T · log 2`
      (energy-information correspondence, paired with `energyFromInformation`
       and `bekensteinHawkingEntropy`)

  This NEW companion file ties the two together with one definitional
  identity and a small ladder of consequences (positivity transport,
  monotonicity transport, scaling transport, info→energy roundtrip).

  ## Honest narrower-true note (Encke, 2026-04-26)
  The W2.1 briefing's literal goal was `landauerEnergyPerBit T = landauerEnergy T / log 2`.
  Both upstream definitions are structurally identical
  (`k_B * T * Real.log 2`), so the literal goal would be FALSE — it would
  divide both sides by `log 2`, off by a factor of `log 2 ≠ 0`.
  The honest, paper-correct bridge is the *equality* on the nose,
  not the ratio.  Briefing semantic intent (cross-namespace identity for
  composability) is fully met by the structural equality.

  ## Headline
  `bridge_landauer_predictions_to_conservation T :
       Predictions.landauerEnergyPerBit T = Conservation.landauerEnergy T`

  ## Cross-corroborated by
  * Andromeda W1 retrieval (rerank 0.9697, HIGH priority).
  * Quaoar's 1-cocycle gap finding (this bridge closes the
    cocycle on the `landauerEnergy*` family).
  * Reranker 2026-04-26: top-1 = both definitions equal `k_B T log 2`
    at score > 0.98 each.

  Author: Encke (cycle-61 Capricornus W2.1 wizard).
-/

import OmegaTheory.Predictions.InformationSecondLaw
import OmegaTheory.Conservation.Correspondence
import Mathlib.Tactic

namespace OmegaTheory.Predictions

open OmegaTheory.Conservation OmegaTheory.Spacetime

/-! ## §1.  The structural identity. -/

/-- **Bridge — Landauer per-bit energy in Predictions equals Landauer
    energy in Conservation.**

    Both definitions unfold to the same `k_B · T · Real.log 2`, so the
    bridge is a definitional equality.  It allows any `Predictions.*`
    consumer that reasons in terms of `landauerEnergyPerBit T` to discharge
    its goal via `Conservation.*` lemmas about `landauerEnergy T` (and
    vice-versa).

    This is the W2.1 headline of cycle-61 Capricornus and closes the
    1-cocycle gap that Quaoar's finding registered on the
    `landauerEnergy*` consumer family. -/
theorem bridge_landauer_predictions_to_conservation (T : ℝ) :
    landauerEnergyPerBit T = OmegaTheory.Conservation.landauerEnergy T := by
  unfold landauerEnergyPerBit OmegaTheory.Conservation.landauerEnergy
  rfl

/-- Symmetric form (Conservation → Predictions). -/
theorem bridge_landauer_conservation_to_predictions (T : ℝ) :
    OmegaTheory.Conservation.landauerEnergy T = landauerEnergyPerBit T :=
  (bridge_landauer_predictions_to_conservation T).symm

/-! ## §2.  Property transport along the bridge. -/

/-- Positivity (Conservation → Predictions) — transports
    `Conservation.landauerEnergy_pos`. -/
theorem landauerEnergyPerBit_pos_via_bridge (T : ℝ) (hT : 0 < T) :
    0 < landauerEnergyPerBit T := by
  rw [bridge_landauer_predictions_to_conservation]
  exact OmegaTheory.Conservation.landauerEnergy_pos T hT

/-- Non-negativity transport. -/
theorem landauerEnergyPerBit_nonneg_via_bridge (T : ℝ) (hT : 0 ≤ T) :
    0 ≤ landauerEnergyPerBit T := by
  rw [bridge_landauer_predictions_to_conservation]
  exact OmegaTheory.Conservation.landauerEnergy_nonneg T hT

/-- Vanishing at `T = 0` — via the Conservation form. -/
theorem landauerEnergyPerBit_zero :
    landauerEnergyPerBit 0 = 0 := by
  rw [bridge_landauer_predictions_to_conservation]
  exact OmegaTheory.Conservation.landauerEnergy_zero

/-- Monotonicity transported from `Conservation.landauerEnergy_mono`. -/
theorem landauerEnergyPerBit_mono {T₁ T₂ : ℝ} (h : T₁ ≤ T₂) :
    landauerEnergyPerBit T₁ ≤ landauerEnergyPerBit T₂ := by
  rw [bridge_landauer_predictions_to_conservation,
      bridge_landauer_predictions_to_conservation]
  exact OmegaTheory.Conservation.landauerEnergy_mono h

/-- Scale transport `landauerEnergyPerBit (lam · T) = lam · landauerEnergyPerBit T`. -/
theorem landauerEnergyPerBit_scale (T lam : ℝ) :
    landauerEnergyPerBit (lam * T) = lam * landauerEnergyPerBit T := by
  rw [bridge_landauer_predictions_to_conservation,
      bridge_landauer_predictions_to_conservation]
  exact OmegaTheory.Conservation.landauerEnergy_scale T lam

/-! ## §3.  Composability with `energyFromInformation`. -/

/-- Energy-from-information rewritten through the bridge:
    `energyFromInformation I T = landauerEnergyPerBit T · I`. -/
theorem energyFromInformation_via_predictions_landauer (I T : ℝ) :
    OmegaTheory.Conservation.energyFromInformation I T
      = landauerEnergyPerBit T * I := by
  unfold OmegaTheory.Conservation.energyFromInformation
  rw [bridge_landauer_conservation_to_predictions]

/-! ## §4.  Paper bundle. -/

/-- **Paper bundle (cycle-61 Capricornus W2.1).**

    Captures:
    1. Cross-namespace identity (Predictions.landauerEnergyPerBit
       = Conservation.landauerEnergy).
    2. Strict positivity at any positive temperature (transported).
    3. Vanishing at `T = 0` (transported).
    4. Monotonicity in `T` (transported).
    5. Linearity in scale `lam` (transported). -/
theorem landauer_predictions_conservation_paper_bundle (T : ℝ) (hT : 0 < T) :
    landauerEnergyPerBit T = OmegaTheory.Conservation.landauerEnergy T
    ∧ 0 < landauerEnergyPerBit T
    ∧ landauerEnergyPerBit 0 = 0
    ∧ landauerEnergyPerBit T ≤ landauerEnergyPerBit (T + 1)
    ∧ ∀ lam : ℝ,
        landauerEnergyPerBit (lam * T) = lam * landauerEnergyPerBit T :=
  ⟨bridge_landauer_predictions_to_conservation T,
   landauerEnergyPerBit_pos_via_bridge T hT,
   landauerEnergyPerBit_zero,
   landauerEnergyPerBit_mono (by linarith),
   fun lam => landauerEnergyPerBit_scale T lam⟩

/-- Frontier marker — Encke's W2.1 closure of the Landauer 1-cocycle gap
    flagged by Quaoar in the cycle-61 topology audit. -/
theorem bridge_landauer_predictions_to_conservation_first_landed_in_V2 :
    ∀ T : ℝ,
      landauerEnergyPerBit T = OmegaTheory.Conservation.landauerEnergy T :=
  fun T => bridge_landauer_predictions_to_conservation T

end OmegaTheory.Predictions
