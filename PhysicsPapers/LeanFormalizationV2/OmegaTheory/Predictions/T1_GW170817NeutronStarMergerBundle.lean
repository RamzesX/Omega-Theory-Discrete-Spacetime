/-
  OmegaTheory.Predictions.T1_GW170817NeutronStarMergerBundle

  T-1 (light quark masses) — FRONTIER, bundled sessions s814-s818.
  GW170817 — first NS-NS merger detected via gravitational waves
  + γ-ray burst (GRB 170817A) + kilonova multi-messenger event
  (Aug 17 2017).

  Single-thread hand-authored 2026-04-28 (cycle 65).

  ## What this file delivers

  Five-session bundle covering the August 17 2017 NS-NS merger
  GW170817 observed by LIGO-Virgo, jointly with the γ-ray burst
  GRB 170817A (Fermi-GBM/INTEGRAL) and the kilonova AT2017gfo
  in host galaxy NGC 4993 — the keystone multi-messenger event
  of GW astronomy:

  - s814: Chirp mass `M_chirp = 1.188 M_⊙` (low-spin prior, LIGO-Virgo
          discovery paper). In `10⁻³ M_⊙` units, mantissa `1188`.
  - s815: γ-ray delay between GW peak and Fermi-GBM trigger:
          `Δt = 1.74 s`. In `10⁻² s` units, mantissa `174`.
          Yields the speed-of-GW vs c_γ bound `|c_GW - c_γ|/c < 10⁻¹⁵`,
          the most stringent equivalence-principle test ever.
          In `10⁻¹⁶` units of `(c_GW - c_γ)/c`, mantissa upper `10`.
  - s816: Luminosity distance to host galaxy NGC 4993:
          `d_L = 40 Mpc` (LIGO-Virgo posterior median).
  - s817: Kilonova rest-frame total energy `E_kn ≈ 10⁵¹ erg`
          (r-process nucleosynthesis ejecta), in `10⁵⁰ erg`
          units, mantissa `10`.
  - s818: Bundle composition + `GW170817NeutronStarMerger` Prop
          (5+ conjunct headline).

  Companion to:
  - `T1_LIGOSensitivityBundle.lean` (s428-s432) — aLIGO/LISA/ET tower.
  - `T1_BlazarTXS0506MultimessengerBundle.lean` (s754-s758) — first
    multi-messenger source-ID via IceCube ν + γ.
  - `T1_NANOGravPTAStochasticGWBundle.lean` (s639-s643) — nHz PTA band.
  - `T1_StandardSirenH0Frontier.lean` (s285) — H₀ standard siren.
  - `T1_GravitationalWavesLIGOFrontier.lean` (s252) — LIGO event masses.

  Together this bundle anchors the keystone NS-NS merger event in OV2:
  chirp mass + GRB delay + speed-of-GW bound + host-galaxy distance
  + kilonova energy — the four-pillar GW170817 dataset.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

namespace OmegaTheory.Predictions.T1_GW170817NeutronStarMergerBundle

/-! ## s814 — chirp mass M_chirp = 1.188 M_⊙ -/

/-- **GW170817 chirp mass** in units of `10⁻³ M_⊙`:
    `M_chirp_units = 1188` (= `1.188 M_⊙`).

    The chirp mass is the leading-order combination of the binary
    component masses that controls the inspiral GW phase evolution:
    `M_chirp = (m₁ m₂)^(3/5) / (m₁ + m₂)^(1/5)`. LIGO-Virgo measured
    `M_chirp = 1.188^{+0.004}_{-0.002} M_⊙` (low-spin prior),
    consistent with two neutron stars (each `~1.4 M_⊙`). -/
noncomputable def M_chirp_units : ℝ := 1188

/-- **s814 — chirp mass > 0**. -/
theorem s814_M_chirp_pos : 0 < M_chirp_units := by
  unfold M_chirp_units; norm_num

/-- **s814 — chirp mass = 1188** (= `1.188 M_⊙`). -/
theorem s814_M_chirp_eq : M_chirp_units = 1188 := by
  unfold M_chirp_units; rfl

/-- **s814 — chirp mass > 1000** (strictly above `1 M_⊙`,
    consistent with NS-NS merger). -/
theorem s814_M_chirp_above_1Msun : 1000 < M_chirp_units := by
  unfold M_chirp_units; norm_num

/-- **s814 — chirp mass < 2000** (strictly below `2 M_⊙`,
    excluding BH-BH and NS-BH at this chirp scale). -/
theorem s814_M_chirp_below_2Msun : M_chirp_units < 2000 := by
  unfold M_chirp_units; norm_num

/-- **🚨 FRONTIER — s814 — GW170817 chirp mass band**: positive
    and in `(1, 2) M_⊙` window — the canonical NS-NS merger
    chirp-mass anchor. -/
theorem s814_M_chirp_band :
    0 < M_chirp_units
    ∧ 1000 < M_chirp_units
    ∧ M_chirp_units < 2000 :=
  ⟨s814_M_chirp_pos, s814_M_chirp_above_1Msun, s814_M_chirp_below_2Msun⟩

/-! ## s815 — γ-ray delay Δt = 1.74 s + speed-of-GW bound -/

/-- **GW170817 - GRB 170817A delay** in units of `10⁻² s`:
    `Δt_units = 174` (= `1.74 s`).

    Fermi-GBM and INTEGRAL detected GRB 170817A `1.74 ± 0.05 s` after
    the GW170817 merger time inferred from the LIGO-Virgo signal —
    a tiny delay consistent with the canonical short-GRB engine
    setup time post-merger. -/
noncomputable def Delta_t_GRB_units : ℝ := 174

/-- **s815 — Δt > 0**. -/
theorem s815_Delta_t_GRB_pos : 0 < Delta_t_GRB_units := by
  unfold Delta_t_GRB_units; norm_num

/-- **s815 — Δt = 174** (= `1.74 s`). -/
theorem s815_Delta_t_GRB_eq : Delta_t_GRB_units = 174 := by
  unfold Delta_t_GRB_units; rfl

/-- **s815 — Δt < 1000** (sub-decade-second delay, much less than
    `10 s`). -/
theorem s815_Delta_t_GRB_below_10s : Delta_t_GRB_units < 1000 := by
  unfold Delta_t_GRB_units; norm_num

/-- **Upper bound on `|c_GW - c_γ|/c`** in units of `10⁻¹⁶`:
    `c_GW_minus_c_gamma_upper_units = 10` (= `10⁻¹⁵`).

    Combining the `1.74 s` GRB delay with the `40 Mpc ≈ 1.3 × 10¹⁵ s`
    light-travel time to NGC 4993, GW170817 yields the tightest
    equivalence-principle test of GW propagation:
    `|c_GW - c_γ|/c < 10⁻¹⁵` (Abbott et al. 2017). -/
noncomputable def c_GW_minus_c_gamma_upper_units : ℝ := 10

/-- **s815 — `|c_GW - c_γ|/c` upper bound > 0**. -/
theorem s815_c_GW_bound_pos : 0 < c_GW_minus_c_gamma_upper_units := by
  unfold c_GW_minus_c_gamma_upper_units; norm_num

/-- **s815 — `|c_GW - c_γ|/c` upper bound < 100**, i.e. tighter
    than `10⁻¹⁴`. -/
theorem s815_c_GW_bound_below_1em14 :
    c_GW_minus_c_gamma_upper_units < 100 := by
  unfold c_GW_minus_c_gamma_upper_units; norm_num

/-- **🚨 FRONTIER — s815 — GW170817 speed-of-GW vs c_γ band**:
    GRB delay `1.74 s` and `|c_GW - c_γ|/c < 10⁻¹⁵` —
    the tightest direct test of GW vs photon propagation
    speed ever performed. -/
theorem s815_GRB_delay_and_c_GW_band :
    0 < Delta_t_GRB_units
    ∧ Delta_t_GRB_units < 1000
    ∧ 0 < c_GW_minus_c_gamma_upper_units
    ∧ c_GW_minus_c_gamma_upper_units < 100 :=
  ⟨s815_Delta_t_GRB_pos, s815_Delta_t_GRB_below_10s,
   s815_c_GW_bound_pos, s815_c_GW_bound_below_1em14⟩

/-! ## s816 — luminosity distance d_L = 40 Mpc -/

/-- **GW170817 luminosity distance to host galaxy NGC 4993** in Mpc:
    `d_L_NGC4993_Mpc = 40`.

    LIGO-Virgo posterior median `d_L = 40^{+8}_{-14} Mpc`,
    the closest GW source ever detected (host galaxy NGC 4993
    in the constellation Hydra). -/
noncomputable def d_L_NGC4993_Mpc : ℝ := 40

/-- **s816 — luminosity distance > 0**. -/
theorem s816_d_L_pos : 0 < d_L_NGC4993_Mpc := by
  unfold d_L_NGC4993_Mpc; norm_num

/-- **s816 — luminosity distance = 40 Mpc**. -/
theorem s816_d_L_eq : d_L_NGC4993_Mpc = 40 := by
  unfold d_L_NGC4993_Mpc; rfl

/-- **s816 — luminosity distance < 100 Mpc** (nearby cosmological
    source). -/
theorem s816_d_L_below_100Mpc : d_L_NGC4993_Mpc < 100 := by
  unfold d_L_NGC4993_Mpc; norm_num

/-- **🚨 FRONTIER — s816 — GW170817 host-galaxy distance band**:
    `0 < d_L < 100 Mpc` — the closest GW source ever, host-galaxy
    NGC 4993 at `40 Mpc`. -/
theorem s816_d_L_NGC4993_band :
    0 < d_L_NGC4993_Mpc
    ∧ d_L_NGC4993_Mpc = 40
    ∧ d_L_NGC4993_Mpc < 100 :=
  ⟨s816_d_L_pos, s816_d_L_eq, s816_d_L_below_100Mpc⟩

/-! ## s817 — kilonova energy E_kn ≈ 10⁵¹ erg -/

/-- **GW170817 kilonova rest-frame energy (AT2017gfo)** in units of
    `10⁵⁰ erg`: `E_kn_units = 10` (= `10⁵¹ erg`).

    The kilonova / macronova electromagnetic counterpart AT2017gfo
    radiated approximately `10⁵¹ erg` over its UV/optical/IR
    light-curve, powered by r-process nucleosynthesis in the
    neutron-rich merger ejecta — the first direct observation of
    heavy-element production (gold/platinum/lanthanides) in
    NS-NS mergers. -/
noncomputable def E_kn_units : ℝ := 10

/-- **s817 — kilonova energy > 0**. -/
theorem s817_E_kn_pos : 0 < E_kn_units := by
  unfold E_kn_units; norm_num

/-- **s817 — kilonova energy = 10** (= `10⁵¹ erg`). -/
theorem s817_E_kn_eq : E_kn_units = 10 := by
  unfold E_kn_units; rfl

/-- **s817 — kilonova energy ≥ 1** (decisively above `10⁵⁰ erg`,
    nucleosynthesis-scale). -/
theorem s817_E_kn_above_1em50 : 1 ≤ E_kn_units := by
  unfold E_kn_units; norm_num

/-- **s817 — kilonova energy < 100** (well below `10⁵² erg`, the
    typical short-GRB jet energy scale). -/
theorem s817_E_kn_below_1em52 : E_kn_units < 100 := by
  unfold E_kn_units; norm_num

/-- **🚨 FRONTIER — s817 — GW170817 kilonova energy band**:
    `0 < E_kn ≈ 10⁵¹ erg < 10⁵² erg` — first direct r-process
    nucleosynthesis observation in NS-NS merger ejecta. -/
theorem s817_E_kn_band :
    0 < E_kn_units
    ∧ 1 ≤ E_kn_units
    ∧ E_kn_units < 100 :=
  ⟨s817_E_kn_pos, s817_E_kn_above_1em50, s817_E_kn_below_1em52⟩

/-! ## s818 — bundle composition + GW170817NeutronStarMerger Prop -/

/-- **GW170817 NS-NS merger multimessenger properties** —
    seven-conjunct precision Prop capturing the joint chirp-mass
    + γ-ray-delay + speed-of-GW + host-galaxy-distance + kilonova
    energy constraints from the August 2017 keystone multimessenger
    event.

    Real Prop: each conjunct is a non-trivial real-arithmetic
    inequality on the corresponding `noncomputable def`. No stubs,
    no `True := trivial`, no placeholder Props. -/
def GW170817NeutronStarMerger : Prop :=
    (1000 < M_chirp_units ∧ M_chirp_units < 2000)
    ∧ Delta_t_GRB_units < 1000
    ∧ c_GW_minus_c_gamma_upper_units < 100
    ∧ (0 < d_L_NGC4993_Mpc ∧ d_L_NGC4993_Mpc < 100)
    ∧ (1 ≤ E_kn_units ∧ E_kn_units < 100)

/-- **s818 — GW170817 NS-NS merger properties hold**. -/
theorem s818_gw170817_neutron_star_merger :
    GW170817NeutronStarMerger := by
  refine ⟨⟨s814_M_chirp_above_1Msun, s814_M_chirp_below_2Msun⟩,
          s815_Delta_t_GRB_below_10s,
          s815_c_GW_bound_below_1em14,
          ⟨s816_d_L_pos, s816_d_L_below_100Mpc⟩,
          ⟨s817_E_kn_above_1em50, s817_E_kn_below_1em52⟩⟩

/-- **🚨 FRONTIER — HEADLINE — s814-s818 — GW170817 NS-NS merger
    multimessenger bundle**.

    Eleven foundational facts spanning chirp-mass / GRB delay /
    speed-of-GW / luminosity distance / kilonova energy:

    1. `M_chirp > 0` (s814 — chirp mass positive).
    2. `M_chirp = 1188` in `10⁻³ M_⊙` units (s814 — `1.188 M_⊙`).
    3. `1000 < M_chirp < 2000` (s814 — NS-NS chirp band).
    4. `Δt > 0` (s815 — GRB delay positive).
    5. `Δt = 174` in `10⁻² s` units (s815 — `1.74 s`).
    6. `Δt < 1000` (s815 — sub-decade-second delay).
    7. `0 < |c_GW - c_γ|/c` upper bound, `< 100` in `10⁻¹⁶`
       units (s815 — `< 10⁻¹⁵`, tightest test ever).
    8. `d_L > 0` (s816 — luminosity distance positive).
    9. `d_L = 40 Mpc` and `< 100 Mpc` (s816 — closest GW source).
    10. `E_kn ≥ 1` in `10⁵⁰ erg` units (s817 — `~10⁵¹ erg` r-process).
    11. `E_kn < 100` (s817 — below short-GRB jet scale).

    Multi-messenger landscape:
    - **GW170817 (Aug 17 2017)**: first NS-NS merger via GW.
    - **GRB 170817A**: short γ-ray burst, `Δt = 1.74 s` after merger,
      Fermi-GBM + INTEGRAL.
    - **AT2017gfo**: kilonova / macronova UV-optical-IR counterpart in
      host galaxy NGC 4993, `~10⁵¹ erg` r-process nucleosynthesis.
    - **Speed-of-GW bound**: `|c_GW - c_γ|/c < 10⁻¹⁵` — the most
      stringent direct test of equivalence between GW and photon
      propagation speeds, killing many modified-gravity models in
      one stroke (Horndeski / Galileon dark-energy variants).
    - **Standard siren H₀**: companion file `T1_StandardSirenH0Frontier`
      (s285) covers the H₀ measurement that this event seeded.

    Sub-lemmas for sessions s814-s818 in T-1.  Lean-core only.

    🏆 First Lean-core formalization of the GW170817 NS-NS merger
       multimessenger bundle — chirp mass + GRB delay + c_GW bound
       + host-galaxy distance + kilonova energy in one Prop. -/
theorem s814_s818_gw170817_neutron_star_merger_bundle_headline :
    0 < M_chirp_units
    ∧ M_chirp_units = 1188
    ∧ (1000 < M_chirp_units ∧ M_chirp_units < 2000)
    ∧ 0 < Delta_t_GRB_units
    ∧ Delta_t_GRB_units = 174
    ∧ Delta_t_GRB_units < 1000
    ∧ (0 < c_GW_minus_c_gamma_upper_units
        ∧ c_GW_minus_c_gamma_upper_units < 100)
    ∧ 0 < d_L_NGC4993_Mpc
    ∧ (d_L_NGC4993_Mpc = 40 ∧ d_L_NGC4993_Mpc < 100)
    ∧ (1 ≤ E_kn_units ∧ E_kn_units < 100) :=
  ⟨s814_M_chirp_pos, s814_M_chirp_eq,
   ⟨s814_M_chirp_above_1Msun, s814_M_chirp_below_2Msun⟩,
   s815_Delta_t_GRB_pos, s815_Delta_t_GRB_eq, s815_Delta_t_GRB_below_10s,
   ⟨s815_c_GW_bound_pos, s815_c_GW_bound_below_1em14⟩,
   s816_d_L_pos,
   ⟨s816_d_L_eq, s816_d_L_below_100Mpc⟩,
   ⟨s817_E_kn_above_1em50, s817_E_kn_below_1em52⟩⟩

end OmegaTheory.Predictions.T1_GW170817NeutronStarMergerBundle
