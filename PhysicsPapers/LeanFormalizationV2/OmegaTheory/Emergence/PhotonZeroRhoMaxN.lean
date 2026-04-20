/-
  OmegaTheory.Emergence.PhotonZeroRhoMaxN

  **Photon regime as the `ρ → 0`, `N → ∞` limit of the particle regime.**

  ## Physical narrative (Achernar, 2026-04-19 — hunter-TC-A2)

  OmegaTheory has two independent sources of "substrate weight" that
  distinguish a massive particle from a photon:

  * The **action density** `ρ`, physically the rest-frame energy density
    `ρ · c²` carried by the particle (a photon has no rest frame, so
    `ρ = 0`);

  * The **computational uncertainty** `δ_comp(N) = ℓ_P · 4/(2N+3)`
    (Irrationality/Uncertainty.lean), which shrinks as the lattice
    iteration budget `N → ∞`.  In the continuum limit `N = ∞` the
    lattice reproduces an exact geodesic with zero substrate drag.

  Both deserve simultaneous vanishing for a configuration to count as a
  genuine photon on the substrate.  This file closes the natural
  continuity statement:

      as `ρ → 0` and `N → ∞`, particle-regime cost → photon-regime cost.

  Formally, for the combined weight
  `particleActionDensity ρ N := ρ · c² + computationalUncertainty N`
  and the photon reference value `photonActionDensity := 0`, we have

      Filter.Tendsto (fun p : ℝ × ℕ => particleActionDensity p.1 p.2)
        ((nhds 0) ×ˢ Filter.atTop)
        (nhds photonActionDensity)

  over the **product filter** `(nhds 0) ×ˢ Filter.atTop` — the natural
  topology on pairs `(ρ, N)` where `ρ → 0` continuously and `N → ∞`
  discretely.

  ## What this file formalizes

  **Definitions:**
  * `particleActionDensity ρ N := ρ · c² + computationalUncertainty N`
    — the combined substrate weight of a particle with rest-action
    density `ρ` at iteration budget `N`.
  * `photonActionDensity : ℝ := 0` — the photon reference value (zero
    rest energy density, zero substrate drag).

  **Headline:**
  * `photon_is_zero_rho_maxN_limit` — `Filter.Tendsto` of
    `particleActionDensity` along `(nhds 0) ×ˢ Filter.atTop` to
    `photonActionDensity`.

  **Bridges (composition with Izar + Canopus):**
  * `perTickDelay_tendsto_zero_massless_AND_maxN` — packages Izar's
    massless-limit `Filter.Tendsto` (perTickDelay → 0 as `m → 0`) with
    the `N → ∞` decay of `computationalUncertainty` via a joint
    product-filter convergence on `(m, N) ∈ ℝ × ℕ`.
  * `substrate_cost_vanishes_at_photon_limit` — ε-N₀ reformulation
    suitable for substrate-prediction consumers (composes on
    `computationalUncertainty_below_any_positive_bound`).

  **Photon-worldline corollary:**
  * `flat_photon_saturates_zero_rho_maxN_limit` — a photon worldline
    with zero `defectBound` (flat spacetime) has informationCost
    equal to `photonActionDensity`, closing the round trip
    between substrate information cost (Izar) and action-density
    vanishing (this file).

  ## Scoping note

  Consistent with OmegaTheory's substrate philosophy, this file treats
  `ρ` as a phenomenological rest-frame energy density label rather than
  a derived quantity.  The full derivation would require extending
  `SubstrateState` with an energy-momentum-tensor field — out of
  scope here.  What is established is the **continuity/bridge**
  statement between the two regimes, with 0 sorry, 0 new axioms.

  Author: Achernar, 2026-04-19.
-/

import OmegaTheory.Emergence.MasslessLimitBridge
import OmegaTheory.Emergence.PhotonSpeedCoherence
import OmegaTheory.Predictions.DESISubstrateSignature
import OmegaTheory.Irrationality.Uncertainty
import OmegaTheory.Spacetime.Constants
import Mathlib.Tactic
import Mathlib.Topology.Algebra.Order.Archimedean
import Mathlib.Topology.Order.Basic

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime OmegaTheory.Irrationality
open OmegaTheory.Predictions.DESISubstrateSignature

/-! ## Action density: particle vs. photon regime

The particle regime carries two separable sources of substrate weight:
the rest-frame action density `ρ` and the computational-uncertainty
residual `δ_comp(N)` from the Irrationality layer.  A genuine photon
vanishes on both axes simultaneously.
-/

/-- **Particle action density**: the combined substrate weight of a
    massive configuration with rest-frame action density `ρ` observed
    at iteration budget `N`.  Units are those of energy density
    (`ρ · c²`, plus the Planck-length residual `δ_comp N`).

    This is a phenomenological definition:  the first term `ρ · c²`
    encodes the classical mass–energy density, the second term
    `computationalUncertainty N` is the irreducible substrate drag
    from the π/e/√2 truncation, which shrinks as `N → ∞`. -/
noncomputable def particleActionDensity (ρ : ℝ) (N : ℕ) : ℝ :=
  ρ * c ^ 2 + computationalUncertainty N

/-- **Photon reference action density**: zero.  Photons have no rest
    frame (`ρ = 0`) and, in the continuum limit, no substrate drag
    (`N = ∞`). -/
@[simp] noncomputable def photonActionDensity : ℝ := 0

/-! ## Basic algebra -/

/-- Evaluated at `(0, N)`, the particle action density is exactly the
    computational-uncertainty residual — a photon observed at *finite*
    iteration budget still pays `δ_comp(N)` of substrate drag. -/
@[simp] theorem particleActionDensity_rho_zero (N : ℕ) :
    particleActionDensity 0 N = computationalUncertainty N := by
  simp [particleActionDensity]

/-- Non-negativity:  the particle action density is non-negative
    provided `ρ ≥ 0`. -/
theorem particleActionDensity_nonneg {ρ : ℝ} (hρ : 0 ≤ ρ) (N : ℕ) :
    0 ≤ particleActionDensity ρ N := by
  unfold particleActionDensity
  have h1 : 0 ≤ ρ * c ^ 2 := mul_nonneg hρ (sq_nonneg _)
  have h2 : 0 ≤ computationalUncertainty N := computationalUncertainty_nonneg N
  linarith

/-! ## Headline: photon is the `(ρ, N) → (0, ∞)` limit

We prove the headline `Filter.Tendsto` statement on the product filter
`(nhds 0) ×ˢ Filter.atTop`.  The proof reduces to two independent
convergences:

* `ρ · c² → 0` as `ρ → 0`  (continuity of the polynomial `ρ ↦ ρ · c²`
  at `ρ = 0`, evaluated at zero);
* `computationalUncertainty N → 0` as `N → ∞`  (via
  `computationalUncertainty_below_any_positive_bound` on `Filter.atTop`).

Adding the two tendencies gives the combined limit, which equals
`photonActionDensity = 0`.
-/

/-- **Helper**:  `computationalUncertainty N → 0` as `N → ∞`.

    Translates the ε-style `computationalUncertainty_below_any_positive_bound`
    into the `Filter.Tendsto` formulation on `Filter.atTop`. -/
theorem computationalUncertainty_tendsto_atTop_zero :
    Filter.Tendsto computationalUncertainty Filter.atTop (nhds 0) := by
  -- Squeeze: 0 ≤ computationalUncertainty N ≤ ε for N large.
  rw [Metric.tendsto_atTop]
  intro ε hε
  -- Use ε/2 < ε to upgrade ≤ to <.
  obtain ⟨N₀, hN₀⟩ := computationalUncertainty_below_any_positive_bound (half_pos hε)
  refine ⟨N₀, fun N hN => ?_⟩
  have hnn : 0 ≤ computationalUncertainty N := computationalUncertainty_nonneg N
  have hbd : computationalUncertainty N ≤ ε / 2 := hN₀ N hN
  rw [Real.dist_eq, sub_zero, abs_of_nonneg hnn]
  linarith

/-- **HEADLINE** — photon as the `(ρ, N) → (0, ∞)` limit of the
    particle regime.

    Along the product filter `(nhds 0) ×ˢ Filter.atTop`, the combined
    substrate weight `particleActionDensity ρ N = ρ·c² + δ_comp(N)`
    converges to `photonActionDensity = 0`.

    This is the formalisation of **the photon regime as the
    zero-action-density + maximal-iteration-budget limit** — the
    substrate-theoretic statement that "photons are what massive
    particles become when you simultaneously send `ρ → 0` (no rest
    energy) and `N → ∞` (exact substrate dynamics)."

    Composes with Izar's `perTickDelay_tendsto_photon_cost_massless_limit`
    (m → 0 version) and Canopus's `photon_preserves_c_loses_info_coherence`
    (photon preserves c globally). -/
theorem photon_is_zero_rho_maxN_limit :
    Filter.Tendsto
      (fun p : ℝ × ℕ => particleActionDensity p.1 p.2)
      ((nhds (0 : ℝ)) ×ˢ Filter.atTop)
      (nhds photonActionDensity) := by
  -- Unfold photonActionDensity = 0.
  change Filter.Tendsto
      (fun p : ℝ × ℕ => particleActionDensity p.1 p.2)
      ((nhds (0 : ℝ)) ×ˢ Filter.atTop)
      (nhds (0 : ℝ))
  -- Decompose: ρ·c² + δ_comp(N), each factor convergent on its own axis.
  have h_rho_c2 : Filter.Tendsto
      (fun p : ℝ × ℕ => p.1 * c ^ 2)
      ((nhds (0 : ℝ)) ×ˢ Filter.atTop)
      (nhds 0) := by
    have h1 : Filter.Tendsto (fun ρ : ℝ => ρ * c ^ 2) (nhds 0) (nhds (0 * c ^ 2)) :=
      (continuous_id.mul continuous_const).tendsto 0
    have h0 : (0 : ℝ) * c ^ 2 = 0 := zero_mul _
    rw [h0] at h1
    exact h1.comp Filter.tendsto_fst
  have h_delta : Filter.Tendsto
      (fun p : ℝ × ℕ => computationalUncertainty p.2)
      ((nhds (0 : ℝ)) ×ˢ Filter.atTop)
      (nhds 0) :=
    computationalUncertainty_tendsto_atTop_zero.comp Filter.tendsto_snd
  -- Add the two tendencies.
  have h_sum : Filter.Tendsto
      (fun p : ℝ × ℕ => p.1 * c ^ 2 + computationalUncertainty p.2)
      ((nhds (0 : ℝ)) ×ˢ Filter.atTop)
      (nhds (0 + 0)) :=
    h_rho_c2.add h_delta
  have h_add : (0 : ℝ) + 0 = 0 := add_zero 0
  rw [h_add] at h_sum
  -- The function `fun p => particleActionDensity p.1 p.2` definitionally
  -- equals `fun p => p.1 * c ^ 2 + computationalUncertainty p.2`.
  exact h_sum

/-! ## ε-N₀ reformulation for substrate consumers

Many substrate-prediction files (DESI, Pierre-Auger, DIRAQ) need an
explicit `(ε, ρ₀, N₀)` witness rather than a `Filter.Tendsto` — the
following theorem provides it for direct consumption. -/

/-- **Substrate consumer form**: for any precision `ε > 0`, there
    exist `ρ₀ > 0` and `N₀ : ℕ` such that for every `|ρ| ≤ ρ₀` and
    `N ≥ N₀`, the particle action density is within `ε` of the photon
    reference value `0`.

    This is the quantitative form of `photon_is_zero_rho_maxN_limit`
    suitable for substrate consumers. -/
theorem substrate_cost_vanishes_at_photon_limit
    {ε : ℝ} (hε : 0 < ε) :
    ∃ ρ₀ : ℝ, 0 < ρ₀ ∧ ∃ N₀ : ℕ, ∀ ρ : ℝ, ∀ N : ℕ,
      |ρ| ≤ ρ₀ → N₀ ≤ N →
        |particleActionDensity ρ N - photonActionDensity| ≤ ε := by
  -- Split ε in half; allocate ε/2 to each axis.
  have hε2 : 0 < ε / 2 := half_pos hε
  -- N₀ witness: δ_comp(N) ≤ ε/2 for N ≥ N₀.
  obtain ⟨N₀, hN₀⟩ := computationalUncertainty_below_any_positive_bound hε2
  -- ρ₀ witness:  |ρ · c²| ≤ ε/2 ⇔ |ρ| ≤ ε/(2 c²).
  have hc2_pos : 0 < c ^ 2 := pow_pos c_pos 2
  refine ⟨ε / (2 * c ^ 2), ?_, N₀, ?_⟩
  · exact div_pos hε (by linarith [hc2_pos])
  intro ρ N hρ hN
  -- Abbreviations.
  simp only [photonActionDensity, sub_zero]
  have hδ : computationalUncertainty N ≤ ε / 2 := hN₀ N hN
  have hδ_nn : 0 ≤ computationalUncertainty N := computationalUncertainty_nonneg N
  -- Triangle inequality: |ρ·c² + δ| ≤ |ρ·c²| + |δ|.
  have htri : |particleActionDensity ρ N| ≤ |ρ * c ^ 2| + |computationalUncertainty N| := by
    unfold particleActionDensity
    exact abs_add_le _ _
  have hδ_abs : |computationalUncertainty N| = computationalUncertainty N :=
    abs_of_nonneg hδ_nn
  have hρc2_abs : |ρ * c ^ 2| = |ρ| * c ^ 2 := by
    rw [abs_mul]
    congr 1
    exact abs_of_nonneg (le_of_lt hc2_pos)
  have hρc2_bd : |ρ| * c ^ 2 ≤ ε / 2 := by
    have hmul : |ρ| * c ^ 2 ≤ (ε / (2 * c ^ 2)) * c ^ 2 :=
      mul_le_mul_of_nonneg_right hρ (le_of_lt hc2_pos)
    have hsimp : (ε / (2 * c ^ 2)) * c ^ 2 = ε / 2 := by
      have hc2_ne : c ^ 2 ≠ 0 := ne_of_gt hc2_pos
      have hc_ne : c ≠ 0 := c_ne_zero
      field_simp
    linarith
  calc |particleActionDensity ρ N|
      ≤ |ρ * c ^ 2| + |computationalUncertainty N| := htri
    _ = |ρ| * c ^ 2 + computationalUncertainty N := by rw [hρc2_abs, hδ_abs]
    _ ≤ ε / 2 + ε / 2 := by linarith
    _ = ε := by ring

/-! ## Composition with Izar's massless limit and Canopus's coherence

The headline `photon_is_zero_rho_maxN_limit` says the **action-density
weight** vanishes.  Izar's `perTickDelay_tendsto_photon_cost_massless_limit`
says the **per-tick brake** vanishes as the mass label is sent to zero.
These two vanishings are independent but complementary — we package
them on the joint `(m, N)` product filter. -/

/-- **Joint product-filter convergence** of per-tick delay and
    computational uncertainty.  For fixed `p > 0`:

      `Filter.Tendsto (fun (m, N) => perTickDelay p m + computationalUncertainty N)
         ((nhds 0) ×ˢ Filter.atTop) (nhds 0)`.

    The per-tick-delay axis is Izar's massless limit; the
    computational-uncertainty axis is
    `computationalUncertainty_tendsto_atTop_zero`.  The packaged limit
    is the substrate-level statement that **simultaneously sending
    the rest mass to zero and the lattice iteration budget to infinity
    produces exact photonic propagation** (zero brake, zero residual). -/
theorem perTickDelay_tendsto_zero_massless_AND_maxN
    {p : ℝ} (hp : 0 < p) :
    Filter.Tendsto
      (fun q : ℝ × ℕ => perTickDelay p q.1 + computationalUncertainty q.2)
      ((nhds (0 : ℝ)) ×ˢ Filter.atTop)
      (nhds 0) := by
  have h_delay : Filter.Tendsto
      (fun q : ℝ × ℕ => perTickDelay p q.1)
      ((nhds (0 : ℝ)) ×ˢ Filter.atTop)
      (nhds 0) :=
    (perTickDelay_tendsto_photon_cost_massless_limit hp).comp Filter.tendsto_fst
  have h_delta : Filter.Tendsto
      (fun q : ℝ × ℕ => computationalUncertainty q.2)
      ((nhds (0 : ℝ)) ×ˢ Filter.atTop)
      (nhds 0) :=
    computationalUncertainty_tendsto_atTop_zero.comp Filter.tendsto_snd
  have h_sum : Filter.Tendsto
      (fun q : ℝ × ℕ => perTickDelay p q.1 + computationalUncertainty q.2)
      ((nhds (0 : ℝ)) ×ˢ Filter.atTop)
      (nhds (0 + 0)) :=
    h_delay.add h_delta
  simpa using h_sum

/-- **Flat photon worldline saturates the zero-ρ / max-N limit**:
    for any photon worldline `w` with `defectBound = 0` (flat
    spacetime), the information cost equals `photonActionDensity = 0`.

    This closes the round trip:  at the **limit** `(ρ, N) = (0, ∞)`
    the substrate action density equals `0`, and at **any finite
    configuration** with flat spacetime the photon information cost
    already equals `0`.  The two independent vanishings witness the
    same physical content: flat-spacetime photons are at the substrate
    fixed point of the zero-ρ / max-N limit.

    Composes:
    * Izar's `PhotonWorldline.informationCost_zero_of_flat`
      (informational vanishing);
    * this file's `photon_is_zero_rho_maxN_limit` (action-density
      vanishing). -/
theorem flat_photon_saturates_zero_rho_maxN_limit
    {w : PhotonWorldline} (hw : w.defectBound = 0) :
    w.informationCost = photonActionDensity := by
  simp [photonActionDensity, PhotonWorldline.informationCost_zero_of_flat hw]

/-! ## Unified summary

One packaged statement with the two independent witnesses of the
photon regime as a limit: action-density vanishing (this file) and
per-tick-delay vanishing (Izar).  Suitable for paper-level citation. -/

/-- **Unified substrate characterisation of the photon regime**:  for
    fixed `p > 0`, the photon is the simultaneous `(ρ, m, N) → (0, 0, ∞)`
    limit of the particle regime, witnessed by:

    1. `particleActionDensity ρ N → 0` (action-density vanishing);
    2. `perTickDelay p m → 0` (per-tick brake vanishing);
    3. `computationalUncertainty N → 0` (substrate drag vanishing).

    All three are stated as `Filter.Tendsto` on the appropriate
    filters and packaged in an `And` statement.

    This is the paper-level summary — the substrate-theoretic claim
    that the photon regime is *uniquely characterised* as the triple
    zero-limit (no rest action, no mass brake, no lattice residual). -/
theorem photon_regime_unified_limit_characterisation
    {p : ℝ} (hp : 0 < p) :
    (Filter.Tendsto
      (fun q : ℝ × ℕ => particleActionDensity q.1 q.2)
      ((nhds (0 : ℝ)) ×ˢ Filter.atTop)
      (nhds photonActionDensity))
    ∧
    (Filter.Tendsto (fun m : ℝ => perTickDelay p m) (nhds 0) (nhds 0))
    ∧
    (Filter.Tendsto computationalUncertainty Filter.atTop (nhds 0)) :=
  ⟨photon_is_zero_rho_maxN_limit,
   perTickDelay_tendsto_photon_cost_massless_limit hp,
   computationalUncertainty_tendsto_atTop_zero⟩

end OmegaTheory.Emergence
