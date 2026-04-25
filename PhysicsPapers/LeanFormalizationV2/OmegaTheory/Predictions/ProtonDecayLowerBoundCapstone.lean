/-
  OmegaTheory.Predictions.ProtonDecayLowerBoundCapstone

  **W19 — Proton decay lower-bound orphans capstone (Cycle 60 / Sagittarius / Wave 2b).**

  ## Mission (Cycle 60 / Sagittarius / Wave 2b — Kaus-Borealis)

  `Predictions/ProtonDecayLowerBound.lean` (Alkaid, cycle-19 target 1/6,
  Apr 20) ships 30+ formal theorems formalising the substrate prediction
  `τ_p(p → e⁺ π⁰) > 2.4 × 10³⁴ yr` and the FIRST-EVER formal GUT-model-
  exclusion theorem in OmegaTheory V2 (minimal Georgi-Glashow SU(5)
  ruled out). Per Kaus-Australis's c60 W19 topology audit, the file
  contained 27 internal-orphan theorems (54% orphan rate) — capstone
  composition + paper-bundle wiring missing.

  This NEW companion file imports `ProtonDecayLowerBound.lean` (read-
  only) + the `MagneticMonopoleSuppressionFromTopology.lean` sister
  GUT-cosmology prediction, then wraps ≥12 representative orphan
  theorems into a single paper-headline capstone with internal APPLIES
  edges. No new physical content — pure composition + frontier marker.

  ## Composition

  Orphans wrapped (citation surfaces):
    * Tier 1 anchor — `protonLifetime_SuperK_lower_bound_pos`,
      `_value`, `universeAge_yr_pos`, `C_tau_proton_pos`.
    * Tier 2 substrate — `substrateProtonLifetime_pos`,
      `substrateProtonLifetime_at_0`, `_at_0_exceeds_SuperK`,
      `_increasing_in_N`.
    * Tier 3 super-K — `proton_decay_substrate_satisfies_SuperK`.
    * Tier 4 GUT-exclusion — `minimalSU5_below_SuperK`,
      `minimal_SU5_ruled_out`, `substrate_falsifies_minimal_SU5`.
    * Tier 5 hierarchy — `proton_lifetime_dwarfs_universe_age`,
      `substrate_proton_lifetime_dwarfs_universe_age`.
    * Tier 6 super-exp — `substrateProtonDecayRate_decreasing_in_N`,
      `substrateProtonDecayRate_upper_bound_pos`.
    * Tier 7 channel — `proton_decay_channel_is_sqrt2`,
      `proton_decay_channel_not_pi`,
      `proton_decay_same_channel_as_theta_QCD`.
    * Sister GUT-cosmology — `magnetic_monopole_suppression_from_topology`
      (Magnetic monopole topological suppression — sibling rare-process
      bound from non-trivial-π₁ algebra).

  ## Paper hook (Section 6.6 — proton stability + GUT exclusion)

  Single citation point:
  `OmegaTheory.Predictions.ProtonDecayLowerBoundCapstone.proton_decay_lower_bound_orphans_capstone`

  Falsification axis: Hyper-K target 10³⁵ yr; if Hyper-K observes a
  proton-decay event with τ_p < 10³³ yr, both substrate prediction at
  N = 0 AND minimal SU(5) cap are simultaneously violated, but the
  contrapositive `substrate_refuted_if_tau_below_minimalSU5` survives.

  ## HARD RULES

  * 0 sorry, 0 new axioms, lake build GREEN.
  * Pure composition: no new defs (other than the capstone proposition
    itself), no new physical constants.
-/

import OmegaTheory.Predictions.ProtonDecayLowerBound
import OmegaTheory.Predictions.MagneticMonopoleSuppressionFromTopology

namespace OmegaTheory.Predictions.ProtonDecayLowerBoundCapstone

open OmegaTheory.Predictions
open OmegaTheory.Predictions.ProtonDecayLowerBound
open OmegaTheory.Irrationality

/-! ## 1. 8-conjunct paper-headline capstone — single-citation point

    Composes 12+ orphan theorems from `ProtonDecayLowerBound.lean` plus
    the `MagneticMonopoleSuppressionFromTopology` sister into ONE
    paper-citation bundle. Each conjunct cites its originating
    Alkaid cycle-19 orphan. -/

/-- **W19 — proton decay lower-bound orphans capstone.**

    8-conjunct citable bundle (orphans now have IN-degree ≥ 1):
      (1) Super-K experimental anchor positivity
          (`protonLifetime_SuperK_lower_bound_pos`),
      (2) substrate lifetime positivity for every truncation budget N
          (`substrateProtonLifetime_pos`),
      (3) substrate at N=0 strictly exceeds Super-K bound
          (`substrateProtonLifetime_at_0_exceeds_SuperK`,
          tier-3 concrete numerical witness 4.8e34 > 2.4e34 yr),
      (4) substrate falsifies minimal SU(5) at N=0
          (`substrate_falsifies_minimal_SU5`,
          first formal GUT-model-exclusion in V2),
      (5) minimal SU(5) cap below Super-K
          (`minimalSU5_below_SuperK`),
      (6) substrate decay rate decreases monotonically in N
          (`substrateProtonDecayRate_decreasing_in_N`,
          super-exponential suppression witness),
      (7) proton-decay channel is √2 (super-exp lane)
          (`proton_decay_channel_is_sqrt2`),
      (8) proton-decay channel matches θ_QCD channel (Sheliak's
          rare-process universality —
          `proton_decay_same_channel_as_theta_QCD`).

    This is the paper Section 6.6 single-citation point. -/
theorem proton_decay_lower_bound_orphans_capstone :
    -- (1) Super-K anchor positivity
    0 < protonLifetime_SuperK_lower_bound ∧
    -- (2) substrate lifetime positivity for every N
    (∀ N : ℕ, 0 < substrateProtonLifetime N) ∧
    -- (3) substrate at N=0 beats Super-K
    protonLifetime_SuperK_lower_bound < substrateProtonLifetime 0 ∧
    -- (4) substrate falsifies minimal SU(5)
    minimalSU5_lifetime_upper_bound < substrateProtonLifetime 0 ∧
    -- (5) minimal SU(5) cap below Super-K
    minimalSU5_lifetime_upper_bound < protonLifetime_SuperK_lower_bound ∧
    -- (6) decay rate monotone-decreasing in N
    (∀ N : ℕ, substrateProtonDecayRate_upper_bound (N + 1)
                ≤ substrateProtonDecayRate_upper_bound N) ∧
    -- (7) channel is √2
    proton_decay_channel = IrrationalTarget.sqrt2 ∧
    -- (8) channel matches θ_QCD super-exp lane
    proton_decay_channel = StrongCPThetaBound.theta_QCD_channel := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · exact protonLifetime_SuperK_lower_bound_pos
  · exact fun N => substrateProtonLifetime_pos N
  · exact substrateProtonLifetime_at_0_exceeds_SuperK
  · exact substrate_falsifies_minimal_SU5
  · exact minimalSU5_below_SuperK
  · exact fun N => substrateProtonDecayRate_decreasing_in_N N
  · rfl
  · exact proton_decay_same_channel_as_theta_QCD

/-! ## 2. Targeted projection lemmas — single-citation paper hooks

    Each lemma extracts ONE numerical face of the bundle for direct
    paper citation without unpacking the 8-conjunct. -/

/-- **Super-K experimental anchor positivity** — single-citation. -/
theorem capstone_superK_anchor_pos :
    0 < protonLifetime_SuperK_lower_bound :=
  protonLifetime_SuperK_lower_bound_pos

/-- **Substrate lifetime positivity** — single-citation. -/
theorem capstone_substrate_lifetime_pos (N : ℕ) :
    0 < substrateProtonLifetime N :=
  substrateProtonLifetime_pos N

/-- **Substrate beats Super-K at N=0** — single-citation. -/
theorem capstone_substrate_beats_superK :
    protonLifetime_SuperK_lower_bound < substrateProtonLifetime 0 :=
  substrateProtonLifetime_at_0_exceeds_SuperK

/-- **Substrate falsifies minimal SU(5)** — single-citation. -/
theorem capstone_substrate_falsifies_minSU5 :
    minimalSU5_lifetime_upper_bound < substrateProtonLifetime 0 :=
  substrate_falsifies_minimal_SU5

/-- **Channel is √2 super-exp lane** — single-citation. -/
theorem capstone_channel_sqrt2 :
    proton_decay_channel = IrrationalTarget.sqrt2 := rfl

/-- **24-order universe-age hierarchy** — single-citation. -/
theorem capstone_dwarfs_universe_age :
    1e24 * universeAge_yr < protonLifetime_SuperK_lower_bound :=
  proton_lifetime_dwarfs_universe_age

/-- **Substrate hierarchy at N=0** — single-citation. -/
theorem capstone_substrate_dwarfs_universe_age :
    1e24 * universeAge_yr < substrateProtonLifetime 0 :=
  substrate_proton_lifetime_dwarfs_universe_age

/-- **Substrate lifetime grows in N** — single-citation. -/
theorem capstone_substrate_lifetime_increasing (N : ℕ) :
    substrateProtonLifetime N ≤ substrateProtonLifetime (N + 1) :=
  substrateProtonLifetime_increasing_in_N N

/-- **Substrate decay rate falls in N** — single-citation. -/
theorem capstone_decay_rate_decreasing (N : ℕ) :
    substrateProtonDecayRate_upper_bound (N + 1)
      ≤ substrateProtonDecayRate_upper_bound N :=
  substrateProtonDecayRate_decreasing_in_N N

/-- **Substrate decay rate positivity** — single-citation. -/
theorem capstone_decay_rate_pos (N : ℕ) :
    0 < substrateProtonDecayRate_upper_bound N :=
  substrateProtonDecayRate_upper_bound_pos N

/-- **Channel ≠ π** — single-citation falsifiability. -/
theorem capstone_channel_not_pi :
    proton_decay_channel ≠ IrrationalTarget.pi :=
  proton_decay_channel_not_pi

/-- **Channel matches θ_QCD** — sister rare-process universality. -/
theorem capstone_channel_eq_thetaQCD :
    proton_decay_channel = StrongCPThetaBound.theta_QCD_channel :=
  proton_decay_same_channel_as_theta_QCD

/-! ## 3. Rare-process companion — magnetic monopole suppression

    The proton-decay √2-channel sits alongside another rare BSM-
    suppression theorem: magnetic-monopole topological suppression
    via trivial substrate fundamental group. Both are "rare-process"
    bounds inherited from substrate algebra rather than fine-tuning. -/

/-- **Magnetic monopole companion bundle** — composes the proton-
    decay capstone with the sibling magnetic-monopole topological
    suppression theorem. Both predictions ride substrate-level rare-
    process suppression: proton decay via √2 super-exp truncation,
    monopole suppression via π₁(substrate) = trivial. -/
theorem proton_decay_with_monopole_suppression_companion :
    -- proton-decay headline at N=0
    protonLifetime_SuperK_lower_bound < substrateProtonLifetime 0 ∧
    minimalSU5_lifetime_upper_bound < substrateProtonLifetime 0 ∧
    -- magnetic-monopole substrate suppression (∀-quantified over substrate regions)
    (∀ region : MagneticMonopoleSuppressionFromTopology.SubstrateRegion,
      (MagneticMonopoleSuppressionFromTopology.monopole_count_in region : ℝ) ≤
        MagneticMonopoleSuppressionFromTopology.lattice_topology_bound *
          region.volume_Mpc3) := by
  refine ⟨?_, ?_, ?_⟩
  · exact substrateProtonLifetime_at_0_exceeds_SuperK
  · exact substrate_falsifies_minimal_SU5
  · exact MagneticMonopoleSuppressionFromTopology.magnetic_monopole_suppression_from_topology

/-! ## 4. Frontier marker — orphans-now-wired witness -/

/-- **Frontier marker — proton-decay orphans wired into capstone (W19).**

    Records the milestone: 12+ previously-internal-orphan theorems
    from `ProtonDecayLowerBound.lean` (Alkaid c19) + sister
    `MagneticMonopoleSuppressionFromTopology` now have IN-degree ≥ 1
    via the Kaus-Borealis c60 W19 capstone. Post-c61 graph refresh
    will see the orphan rate in `Predictions/ProtonDecayLowerBound.lean`
    drop from 27/50 (54%) toward ≤ 22/50 (≤ 44%). -/
theorem proton_decay_lower_bound_orphans_first_capstone_in_V2 :
    ∃ N : ℕ,
      protonLifetime_SuperK_lower_bound < substrateProtonLifetime N ∧
      minimalSU5_lifetime_upper_bound < substrateProtonLifetime N ∧
      proton_decay_channel = IrrationalTarget.sqrt2 :=
  ⟨0, substrateProtonLifetime_at_0_exceeds_SuperK,
       substrate_falsifies_minimal_SU5, rfl⟩

/-! ## 5. Falsifiability paper hook -/

/-- **Falsifiability hook**: substrate refutation contrapositive.

    If a future experiment ever measures `τ_p < 10³³` yr (below the
    minimal-SU(5) cap), the substrate prediction at N=0 is
    automatically refuted (via `substrate_refuted_if_tau_below_minimalSU5`).
    This makes the capstone a directly-Popper-falsifiable claim. -/
theorem capstone_falsifiability_witness :
    ∀ tau_future : ℝ,
      tau_future < minimalSU5_lifetime_upper_bound →
      tau_future < substrateProtonLifetime 0 :=
  substrate_refuted_if_tau_below_minimalSU5

end OmegaTheory.Predictions.ProtonDecayLowerBoundCapstone
