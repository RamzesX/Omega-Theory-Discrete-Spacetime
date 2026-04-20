/-
  OmegaTheory.Emergence.MasslessLimitBridge

  **Photons are the `m → 0` limit of massive particles.**

  ## Physical narrative

  OmegaTheory's `MassAsDelay.lean` gives the per-tick brake coefficient
  `perTickDelay p m = 1 − v(p, m) / c`.  For `m = 0` and `p > 0` this
  vanishes identically (photons are exact null geodesics on the
  lattice); for `m ≠ 0` it is strictly positive (mass is delay).

  This file closes the natural continuity statement that bridges the two
  regimes:  *the per-tick delay of a massive particle of momentum `p`
  tends to zero as the rest-mass label is sent continuously to zero*.
  Formally,

      Filter.Tendsto (fun m => perTickDelay p m) (nhds 0) (nhds 0)

  for every fixed `p > 0`.  Physically, this says that photons arise as
  the massless limit of arbitrarily light massive particles — there is
  no discontinuity between "photon" and "very light particle."

  ## What this file formalizes

  1. `perTickDelay_tendsto_photon_cost_massless_limit` (the headline):
     `Tendsto (fun m => perTickDelay p m) (nhds 0) (nhds 0)` for `p > 0`.

     Proof strategy: sandwich theorem with
         0 ≤ perTickDelay p m ≤ (m * c)^2 / (2 * p^2)
     where the lower bound is `perTickDelay_nonneg` and the upper bound
     is `perTickDelay_high_momentum_bound` (which holds for all m when
     p > 0).  The upper bound is a polynomial in `m` times a constant,
     hence continuous at `m = 0` with value `0`.

  2. `perTickDelayTime_tendsto_zero_massless_limit`:  the physical-time
     delay vanishes in the same limit (trivial consequence).

  3. `photon_cost_composition`:  a corollary composing the massless
     limit with `PhotonWorldline.informationCost`:  along any photon
     worldline `w` whose `defectBound` vanishes (flat spacetime), the
     information cost is `0`, which coincides with the `m → 0` limit of
     the per-tick delay.  This bundles the two independent statements
     "photons suffer no delay" and "photons on flat spacetime cost no
     information" as two faces of the same `m → 0` / `D → 0` vanishing.

  No axioms, no `sorry`.  Author: Izar (2026-04-19).
-/

import OmegaTheory.Emergence.MassAsDelay
import OmegaTheory.Emergence.Redshift
import OmegaTheory.Spacetime.Constants
import Mathlib.Tactic
import Mathlib.Topology.Order.Basic

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime

/-! ## Headline: massless limit of per-tick delay

The per-tick delay vanishes continuously as the rest-mass label
approaches zero.  For fixed momentum `p > 0`, the map
`m ↦ perTickDelay p m` is squeezed between `0` and `(mc)²/(2p²)`;
the latter tends to `0` as `m → 0`, forcing the delay to vanish. -/

/-- **Headline**:  for fixed positive momentum `p`, the per-tick delay
    `perTickDelay p m` tends to zero as the rest-mass `m` approaches
    zero.

    This is the continuity/bridge statement formalising "photons are the
    `m → 0` limit of massive particles" — the `m = 0` value
    (`perTickDelay p 0 = 0`, from `perTickDelay_massless`) is actually
    the limit as `m → 0`, not merely the special value.

    Proof via the sandwich theorem with `0 ≤ perTickDelay p m ≤
    (m·c)²/(2p²)`, where the RHS polynomial vanishes at `m = 0`. -/
theorem perTickDelay_tendsto_photon_cost_massless_limit
    {p : ℝ} (hp : 0 < p) :
    Filter.Tendsto (fun m => perTickDelay p m) (nhds 0) (nhds 0) := by
  -- Upper bound: (m*c)^2 / (2*p^2) tends to 0 as m → 0.
  have h_upper : Filter.Tendsto
      (fun m : ℝ => (m * c) ^ 2 / (2 * p ^ 2)) (nhds 0) (nhds 0) := by
    -- (m*c)^2 / (2 p^2) is continuous in m and vanishes at m = 0.
    have hcont : Continuous (fun m : ℝ => (m * c) ^ 2 / (2 * p ^ 2)) := by
      have h1 : Continuous (fun m : ℝ => m * c) := continuous_id.mul continuous_const
      have h2 : Continuous (fun m : ℝ => (m * c) ^ 2) := h1.pow 2
      exact h2.div_const _
    have heval : ((0 : ℝ) * c) ^ 2 / (2 * p ^ 2) = 0 := by ring
    have := hcont.tendsto (0 : ℝ)
    rw [heval] at this
    exact this
  -- Lower bound: the constant 0 function tends to 0.
  have h_lower : Filter.Tendsto (fun _ : ℝ => (0 : ℝ)) (nhds 0) (nhds 0) :=
    tendsto_const_nhds
  -- Sandwich: 0 ≤ perTickDelay p m ≤ (m*c)^2 / (2*p^2).
  refine tendsto_of_tendsto_of_tendsto_of_le_of_le h_lower h_upper ?_ ?_
  · intro m; exact perTickDelay_nonneg hp.le m
  · intro m; exact perTickDelay_high_momentum_bound hp

/-- **Corollary in physical time**:  the per-tick delay measured in
    Planck ticks vanishes in the same limit.  Immediate consequence of
    multiplication by the positive constant `t_P`. -/
theorem perTickDelayTime_tendsto_zero_massless_limit
    {p : ℝ} (hp : 0 < p) :
    Filter.Tendsto (fun m => perTickDelayTime p m) (nhds 0) (nhds 0) := by
  have h := perTickDelay_tendsto_photon_cost_massless_limit hp
  have hmul : Filter.Tendsto (fun m : ℝ => perTickDelay p m * t_P)
      (nhds 0) (nhds (0 * t_P)) :=
    h.mul tendsto_const_nhds
  simpa [perTickDelayTime] using hmul

/-! ## Composition with photon worldline information cost

The `Redshift.lean` result `informationCost_zero_of_flat` says that a
photon worldline traversing flat spacetime (zero defect bound) has zero
information cost.  Combined with `perTickDelay_massless` and the
headline `Tendsto` above, the two vanishings — dynamical (zero delay)
and informational (zero cost) — are two facets of the same limit. -/

/-- **photon_cost_composition**:  for fixed `p > 0`, the per-tick delay
    at `m = 0` coincides with the information cost of any flat-spacetime
    photon worldline.  Both vanish, by independent arguments:
    `perTickDelay_massless` (dynamical) and
    `PhotonWorldline.informationCost_zero_of_flat` (informational).

    This is the "photons are the `m → 0` limit of massive particles"
    statement at a single point: the two operational definitions of
    massless propagation agree. -/
theorem photon_cost_composition
    {p : ℝ} (hp : 0 < p)
    {w : PhotonWorldline} (hw : w.defectBound = 0) :
    perTickDelay p 0 = w.informationCost := by
  rw [perTickDelay_massless hp,
      PhotonWorldline.informationCost_zero_of_flat hw]

/-- **photon_cost_limit_matches_worldline**:  the `m → 0` limit of
    the per-tick delay equals the information cost of any flat-spacetime
    photon worldline.  The limit is `0` (by the headline above) and the
    cost is `0` (by `informationCost_zero_of_flat`), so they agree.

    This closes the bridge: the `Filter.Tendsto` statement and the
    information-cost vanishing are compatible witnesses to the same
    physical content (photons have no rest-frame, no brake, no
    information cost along flat worldlines). -/
theorem photon_cost_limit_matches_worldline
    {p : ℝ} (hp : 0 < p)
    {w : PhotonWorldline} (hw : w.defectBound = 0) :
    Filter.Tendsto (fun m => perTickDelay p m) (nhds 0) (nhds w.informationCost) := by
  rw [PhotonWorldline.informationCost_zero_of_flat hw]
  exact perTickDelay_tendsto_photon_cost_massless_limit hp

end OmegaTheory.Emergence
