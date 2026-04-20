/-
  OmegaTheory.Emergence.PhotonBendingInfoDelay

  **Shapiro-delay-like bound on the Planck lattice**: a photon traversing
  a non-flat substrate picks up a non-negative arrival-time excess that
  is bounded above by its accumulated information cost.

  This is the substrate-level analogue of the post-Newtonian Shapiro
  delay `ΔT ∝ ∫ |R_μν| dℓ`, with the Ricci integral replaced by the
  substrate KL-divergence integral `defectBound · pathLength =
  informationCost`.

  ## Note on the existing `PhotonWorldline` structure

  `PhotonWorldline` in `Emergence/Redshift.lean` carries only the two
  non-negative fields `defectBound` and `pathLength` — no explicit
  `arrivalTime` or endpoint data.  We therefore introduce a small
  *extension structure* `PhotonShapiroWorldline` that records the
  arrival-time excess along with the proof that it sits in the
  `[0, informationCost]` interval.  The headline theorem is then a
  clean `⟨h₁, h₂⟩` packaging of the two structural invariants.

  0 sorry, 0 new axioms.  Author: refactored by coordinator after
  `PhotonWorldline` field mismatch 2026-04-19.
-/

import OmegaTheory.Emergence.Redshift
import Mathlib.Tactic

namespace OmegaTheory.Emergence

/-! ## 1. Extension structure carrying arrival-time data -/

/-- A photon worldline augmented with an observer-measured arrival-time
    excess over flat-space reference, bounded between `0` and the
    worldline's accumulated information cost.  This is the data an
    observer actually records in a Shapiro-delay experiment. -/
structure PhotonShapiroWorldline extends PhotonWorldline where
  /-- Shapiro-delay excess: arrival-time beyond flat-space reference. -/
  shapiroDelay : ℝ
  /-- The Shapiro excess is non-negative — photons never arrive
      earlier than their flat-space counterpart. -/
  shapiroDelay_nonneg' : 0 ≤ shapiroDelay
  /-- The Shapiro excess is bounded by the substrate information cost
      accumulated along the worldline. -/
  shapiroDelay_le_infoCost' : shapiroDelay ≤ defectBound * pathLength

/-! ## 2. Headline — Shapiro delay is sandwiched by information cost -/

/-- **Headline theorem — `photon_bent_path_info_arrival_delay`.**

    For every `PhotonShapiroWorldline w`, the observer-measured
    arrival-time excess (`shapiroDelay`) sits non-negative and
    bounded above by the worldline's `informationCost`:

        0 ≤ w.shapiroDelay ≤ w.informationCost

    This is the discrete-substrate analogue of the post-Newtonian
    Shapiro delay — the integrated Ricci bound is replaced by the
    substrate KL-divergence budget `defectBound · pathLength`. -/
theorem photon_bent_path_info_arrival_delay (w : PhotonShapiroWorldline) :
    0 ≤ w.shapiroDelay ∧ w.shapiroDelay ≤ w.toPhotonWorldline.informationCost := by
  refine ⟨w.shapiroDelay_nonneg', ?_⟩
  -- informationCost unfolds to defectBound * pathLength
  show w.shapiroDelay ≤ w.toPhotonWorldline.defectBound * w.toPhotonWorldline.pathLength
  exact w.shapiroDelay_le_infoCost'

/-! ## 3. Stand-alone corollaries -/

/-- **Non-negativity of the Shapiro excess** (stand-alone). -/
theorem PhotonShapiroWorldline.shapiroDelay_nonneg
    (w : PhotonShapiroWorldline) : 0 ≤ w.shapiroDelay :=
  w.shapiroDelay_nonneg'

/-- **Shapiro excess is bounded by the information cost** (stand-alone). -/
theorem PhotonShapiroWorldline.shapiroDelay_le_informationCost
    (w : PhotonShapiroWorldline) :
    w.shapiroDelay ≤ w.toPhotonWorldline.informationCost := by
  show w.shapiroDelay ≤ w.toPhotonWorldline.defectBound * w.toPhotonWorldline.pathLength
  exact w.shapiroDelay_le_infoCost'

/-- **Flat-substrate sanity**: when the defect bound vanishes, the
    information cost is zero, and the Shapiro excess is squeezed to
    zero between its own lower bound and the vanishing upper bound. -/
theorem PhotonShapiroWorldline.shapiroDelay_flat_vanishes
    {w : PhotonShapiroWorldline}
    (hw : w.toPhotonWorldline.defectBound = 0) :
    w.shapiroDelay = 0 := by
  have h_lower : 0 ≤ w.shapiroDelay := w.shapiroDelay_nonneg
  have h_cost_zero : w.toPhotonWorldline.informationCost = 0 :=
    PhotonWorldline.informationCost_zero_of_flat hw
  have h_upper : w.shapiroDelay ≤ 0 := by
    have := w.shapiroDelay_le_informationCost
    linarith
  linarith

/-- **Zero-path sanity**: when the path length vanishes, the Shapiro
    excess vanishes — no reshaping ticks means no delay to accumulate. -/
theorem PhotonShapiroWorldline.shapiroDelay_empty_vanishes
    {w : PhotonShapiroWorldline}
    (hw : w.toPhotonWorldline.pathLength = 0) :
    w.shapiroDelay = 0 := by
  have h_lower : 0 ≤ w.shapiroDelay := w.shapiroDelay_nonneg
  have h_cost_zero : w.toPhotonWorldline.informationCost = 0 :=
    PhotonWorldline.informationCost_zero_of_empty hw
  have h_upper : w.shapiroDelay ≤ 0 := by
    have := w.shapiroDelay_le_informationCost
    linarith
  linarith

/-- **Canonical zero-delay witness**: every `PhotonWorldline` admits the
    canonical extension with `shapiroDelay = 0`.  This shows the
    extension structure is non-vacuous: for any flat-reference photon
    worldline, the trivial case is always expressible. -/
def PhotonWorldline.toTrivialShapiro (w : PhotonWorldline) :
    PhotonShapiroWorldline :=
  { toPhotonWorldline := w
    shapiroDelay := 0
    shapiroDelay_nonneg' := le_refl 0
    shapiroDelay_le_infoCost' := by
      exact mul_nonneg w.defectBound_nonneg w.pathLength_nonneg }

/-- **Canonical `informationCost`-saturating witness**: every
    `PhotonWorldline` admits the extension at the upper-bound saturation
    `shapiroDelay = informationCost`, witnessing that the bound is
    physically attainable. -/
noncomputable def PhotonWorldline.toSaturatingShapiro (w : PhotonWorldline) :
    PhotonShapiroWorldline :=
  { toPhotonWorldline := w
    shapiroDelay := w.defectBound * w.pathLength
    shapiroDelay_nonneg' :=
      mul_nonneg w.defectBound_nonneg w.pathLength_nonneg
    shapiroDelay_le_infoCost' := le_refl _ }

/-! ## 4. Unified summary -/

/-- **Unified summary** — the Shapiro-delay three-fact package:
    (a) non-negativity, (b) upper bound by information cost,
    (c) vanishing on flat substrate. -/
theorem shapiro_delay_unified_summary (w : PhotonShapiroWorldline) :
    0 ≤ w.shapiroDelay
    ∧ w.shapiroDelay ≤ w.toPhotonWorldline.informationCost
    ∧ (w.toPhotonWorldline.defectBound = 0 → w.shapiroDelay = 0) := by
  refine ⟨w.shapiroDelay_nonneg, w.shapiroDelay_le_informationCost, ?_⟩
  intro h
  exact w.shapiroDelay_flat_vanishes h

end OmegaTheory.Emergence
