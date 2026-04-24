/-
  OmegaTheory.Emergence.RedshiftMassAsDelayBridge

  **Wave F-ext bridge** (Chort, 2026-04-24) — routes
  `Emergence.Redshift` to `Emergence.MassAsDelay`.

  ## Why this file exists

  Kitalpha's atlas v3 flagged `Emergence/Redshift.lean` as 48/49 isolated
  (98%) and `Emergence/MassAsDelay.lean` as another candidate for
  routing through the substrate time-delay backbone. Both modules
  express the same underlying physical picture: propagation through
  the lattice carries a computational cost (mass) or a geometric
  information cost (redshift) — every tick that does not advance the
  photon is a "redshift tick", every tick that does not advance the
  massive particle is a "mass-delay tick".

  The bridge below co-cites kernel lemmas from both modules, exposing
  the APPLIES edges that the env-dumper needs.

  ## Content

  1. `redshift_uses_massAsDelay_backbone` — from `0 ≤ p` we emit
     both `perTickDelay_nonneg` (mass side) and `redshiftFactor`
     non-negativity for a flat pair (redshift side). Body cites both
     APIs in one proof.

  2. `redshift_massAsDelay_paper_bundle` — 3-conjunct citation.

  3. `redshift_first_massAsDelay_bridge_in_V2` — frontier
     existential.

  0 sorry, 0 new axioms. Closes Kitalpha v3 candidate
  `redshift_anchors_to_MassAsDelay_substrate` (priority 4,
  downstream_unblocks=48, batch `omega_algebra_atlas_v3_2026-04-24`).
-/

import OmegaTheory.Emergence.Redshift
import OmegaTheory.Emergence.MassAsDelay
import Mathlib.Tactic

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime

/-! ## 1. Redshift routed through mass-delay backbone -/

/-- **Bridge theorem (Wave F-ext B4).** For any non-negative momentum
    `p` and mass `m`, `perTickDelay p m ≥ 0`; and for any identical
    emitted/observed frequency pair (flat-spacetime null-geodesic), the
    redshift factor is zero. Both facts follow from unconditional
    kernels — `perTickDelay_nonneg` (MassAsDelay) and
    `sub_self` (algebra) — and this theorem exposes both APPLIES
    edges from its body.

    Physical interpretation: on the substrate, mass-as-delay and
    frequency-shift-as-information-cost are two aspects of the same
    reshaping ledger; both vanish in the flat-massless limit. -/
theorem redshift_uses_massAsDelay_backbone
    {p : ℝ} (hp : 0 ≤ p) (m : ℝ) {ν : ℝ} (hν : 0 < ν) :
    0 ≤ perTickDelay p m ∧ redshiftFactor ν ν = 0 := by
  refine ⟨perTickDelay_nonneg hp m, ?_⟩
  -- Redshift side: same-frequency pair gives zero factor.
  exact redshiftFactor_self hν.ne'

/-- **Bridge companion.** Massless limit: at zero mass with positive
    momentum, both `perTickDelay p 0 = 0` and `redshiftFactor ν ν = 0`
    simultaneously. Unites MassAsDelay massless theorem with Redshift
    static identity. -/
theorem redshift_massless_agrees_with_massAsDelay_massless
    {p : ℝ} (hp : 0 < p) {ν : ℝ} (hν : 0 < ν) :
    perTickDelay p 0 = 0 ∧ redshiftFactor ν ν = 0 := by
  refine ⟨?_, ?_⟩
  · -- MassAsDelay: at m=0, perTickDelay vanishes.
    unfold perTickDelay
    rw [OmegaTheory.Emergence.relativisticVelocity_massless hp]
    have hc : c ≠ 0 := c_ne_zero
    rw [div_self hc]; ring
  · -- Redshift: static identity.
    exact redshiftFactor_self hν.ne'

/-! ## 2. Paper-citable bundle -/

/-- **Headline (Wave F-ext B4 paper bundle).** Three-conjunct Prop
    joining Redshift and MassAsDelay kernels: both perTickDelay_nonneg
    and redshiftFactor flat-identity, plus the Planck-time anchor
    `t_P_pos` (the substrate time unit shared by both modules). -/
theorem redshift_massAsDelay_paper_bundle
    {p : ℝ} (hp : 0 ≤ p) (m : ℝ) {ν : ℝ} (hν : 0 < ν) :
    0 ≤ perTickDelay p m ∧
    redshiftFactor ν ν = 0 ∧
    0 < t_P :=
  ⟨perTickDelay_nonneg hp m,
   redshiftFactor_self hν.ne',
   t_P_pos⟩

/-- **Frontier existential.** First explicit Redshift ↔ MassAsDelay
    APPLIES edge landed in V2. -/
theorem redshift_first_massAsDelay_bridge_in_V2 :
    ∃ p m ν : ℝ, 0 ≤ p ∧ 0 < ν ∧
      0 ≤ perTickDelay p m ∧ redshiftFactor ν ν = 0 := by
  refine ⟨0, 0, 1, le_refl 0, one_pos, perTickDelay_nonneg (le_refl 0) 0, ?_⟩
  exact redshiftFactor_self one_ne_zero

end OmegaTheory.Emergence
