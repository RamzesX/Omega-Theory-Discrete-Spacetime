/-
  OmegaTheory.Emergence.MassPhotonBridge

  **Mass-photon bridge: the Compton momentum scale.**

  ## Physical narrative

  `MassAsDelay.lean` proves the high-momentum bound
      `perTickDelay p m ≤ (m c)² / (2 p²)`      (*)
  for any momentum `p > 0`. This bound is a monotone-decreasing
  function of `p`. At the **Compton momentum** `p = m c` the bound
  saturates exactly `1/2` (the largest allowed per-tick delay for a
  particle that still propagates on the forward light-cone). Below
  Compton scale the high-momentum bound exceeds `1/2` and is uninformative
  — the particle is "photon-like" for the purposes of the lattice
  propagator and travels at `c`. Above Compton, the bound is the
  genuine mass-delay regime.

  This file formalises the Compton-momentum equivalence:

  ```
      (m c)² / (2 p²) ≤ 1/2    ↔    m c ≤ p
  ```

  which is the T-α theorem opening the mass-photon bridge. Subsequent
  theorems T-β..T-ε in follow-up files will consume this equivalence
  to derive the saturation identity, monotonicity of the high-energy
  envelope, and the photon/massive dichotomy above/below Compton.

  No axioms, no `sorry`.
-/

import OmegaTheory.Emergence.MassAsDelay
import OmegaTheory.Spacetime.Constants
import Mathlib.Tactic

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime

/-! ## T-α: Compton threshold for the high-momentum bound -/

/-- **perTickDelay_compton_threshold (T-α)**: the high-momentum delay
    bound `(m c)² / (2 p²)` saturates the value `1/2` exactly when
    the momentum reaches the Compton scale `m c`. For `p > 0`:

    `(m c)² / (2 p²) ≤ 1/2  ↔  m c ≤ p`.

    **Physical reading.** At `p = m c` the bound hits `1/2`, the largest
    per-tick delay compatible with a particle still advancing along the
    forward light-cone. Below Compton (`p < m c`) the bound exceeds `1/2`
    and is not informative — the lattice treats the excitation as
    photon-like. Above Compton (`p > m c`) the bound falls below `1/2`
    and the genuine mass-delay regime takes over. -/
theorem perTickDelay_compton_threshold
    {m : ℝ} (hm : 0 < m) (p : ℝ) (hp : 0 < p) :
    (m * c) ^ 2 / (2 * p ^ 2) ≤ 1 / 2 ↔ m * c ≤ p := by
  have hmc_pos : 0 < m * c := mul_pos hm c_pos
  have hp2_pos : 0 < 2 * p ^ 2 := by positivity
  rw [div_le_iff₀ hp2_pos]
  constructor
  · intro h
    -- (m c)^2 ≤ (1/2) · (2 · p^2) = p^2
    have hsq : (m * c) ^ 2 ≤ p ^ 2 := by linarith
    -- Both `m c` and `p` are positive; `a² ≤ b² → a ≤ b`.
    nlinarith [sq_nonneg (p - m * c), sq_nonneg (p + m * c), hmc_pos, hp]
  · intro h
    -- m c ≤ p with both sides non-negative ⇒ (m c)^2 ≤ p^2.
    have hmc_nn : 0 ≤ m * c := le_of_lt hmc_pos
    have hp_nn : 0 ≤ p := le_of_lt hp
    have hsq : (m * c) ^ 2 ≤ p ^ 2 := by nlinarith [sq_nonneg (p - m * c)]
    linarith

end OmegaTheory.Emergence
