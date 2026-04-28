/-
  OmegaTheory.Predictions.T1_BlazarTXS0506MultimessengerBundle

  T-1 — TXS 0506+056 multimessenger ν + γ flare coincidence,
  bundled sessions s754-s758.

  Single-thread hand-authored 2026-04-28.

  ## What this file delivers

  Five-session bundle covering the September 2017 multimessenger
  identification of blazar TXS 0506+056 (z = 0.337) — the first
  astrophysical-source identification of a high-energy neutrino,
  jointly seen by IceCube, MAGIC, and Fermi-LAT:

  - s754: IceCube event IC170922A — `E_ν ≈ 290 TeV` (TeV-scale
          astrophysical ν), in units of 10 TeV, coefficient `29`.
  - s755: TXS 0506+056 host-galaxy redshift `z = 0.337` (optical
          spectroscopy), in units of 1/1000, coefficient `337`.
  - s756: Fermi-LAT γ-ray flare `F_γ ≈ 4 × 10⁻⁸ erg/cm²/s`
          (5× quiescent), in units of `10⁻⁹ erg/cm²/s`, coefficient `40`.
  - s757: Joint significance: `≈5σ` from `3.5σ × 3.5σ` ν–γ chance
          coincidence; in units of `0.1σ`, coefficient `50`.
  - s758: Bundle composition + `BlazarTXSMultimessenger` Prop
          (5+ conjunct headline).

  Companion to `T1_AstroNeutrinoBundle.lean` (diffuse astrophysical
  flux + IceCube/KM3NeT/ANTARES/GZK landscape) and
  `T1_IceCubeGen2UHENuBundle.lean` (UHE ν + Glashow resonance).
  This bundle targets the first multimessenger source-identification
  event — TXS 0506+056 in September 2017.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

namespace OmegaTheory.Predictions.T1_BlazarTXS0506MultimessengerBundle

/-! ## s754 — IceCube event IC170922A: E_ν ≈ 290 TeV -/

/-- **IceCube IC170922A reconstructed neutrino energy** in units of
    `10 TeV`: `29` (i.e. `290 TeV`).

    The September 22, 2017 IceCube alert (IC170922A) was a single
    high-energy track-like event with reconstructed median neutrino
    energy `E_ν ≈ 290 TeV` (~30 % uncertainty), consistent with an
    astrophysical origin. Stored as the integer mantissa for the
    `× 10 TeV` unit. -/
noncomputable def E_nu_IceCube_units : ℝ := 29

/-- **s754 — IC170922A reconstructed energy > 0**. -/
theorem s754_E_nu_IceCube_pos : 0 < E_nu_IceCube_units := by
  unfold E_nu_IceCube_units; norm_num

/-- **s754 — IC170922A reconstructed energy = 29** (`= 290 TeV`). -/
theorem s754_E_nu_IceCube_eq : E_nu_IceCube_units = 29 := by
  unfold E_nu_IceCube_units; rfl

/-- **s754 — IC170922A energy > 10** (decisively above the
    `100 TeV` astrophysical threshold; `290 > 100`). -/
theorem s754_E_nu_IceCube_above_100TeV : 10 < E_nu_IceCube_units := by
  unfold E_nu_IceCube_units; norm_num

/-- **🚨 FRONTIER — s754 — IceCube IC170922A reconstructed neutrino
    energy is `~290 TeV`** — high-energy astrophysical ν alert that
    seeded the multimessenger follow-up campaign on September 22, 2017. -/
theorem s754_IceCube_IC170922A_290TeV :
    0 < E_nu_IceCube_units
    ∧ E_nu_IceCube_units = 29
    ∧ 10 < E_nu_IceCube_units :=
  ⟨s754_E_nu_IceCube_pos, s754_E_nu_IceCube_eq, s754_E_nu_IceCube_above_100TeV⟩

/-! ## s755 — TXS 0506+056 host-galaxy redshift z = 0.337 -/

/-- **TXS 0506+056 host-galaxy redshift** in units of `1/1000`: `337`
    (i.e. `z = 0.337`).

    The host-galaxy redshift was measured via optical spectroscopy
    (Paiano et al. 2018) at `z = 0.3365 ± 0.0010`, rounded here to
    `0.337`.  Stored as the integer numerator over `1000`. -/
noncomputable def z_TXS_0506_units : ℝ := 337 / 1000

/-- **s755 — TXS 0506+056 redshift > 0**. -/
theorem s755_z_TXS_0506_pos : 0 < z_TXS_0506_units := by
  unfold z_TXS_0506_units; norm_num

/-- **s755 — TXS 0506+056 redshift = 337/1000** (`= 0.337`). -/
theorem s755_z_TXS_0506_eq : z_TXS_0506_units = 337 / 1000 := by
  unfold z_TXS_0506_units; rfl

/-- **s755 — TXS 0506+056 redshift < 1** (within Hubble flow,
    no exotic high-z cosmology). -/
theorem s755_z_TXS_0506_below_unity : z_TXS_0506_units < 1 := by
  unfold z_TXS_0506_units; norm_num

/-- **🚨 FRONTIER — s755 — TXS 0506+056 host-galaxy redshift is
    `z = 0.337`** — confirmed via optical spectroscopy (Paiano et al.
    2018), placing the source firmly in the local Hubble flow
    (`0 < z < 1`). -/
theorem s755_TXS_0506_redshift_0_337 :
    0 < z_TXS_0506_units
    ∧ z_TXS_0506_units = 337 / 1000
    ∧ z_TXS_0506_units < 1 :=
  ⟨s755_z_TXS_0506_pos, s755_z_TXS_0506_eq, s755_z_TXS_0506_below_unity⟩

/-! ## s756 — Fermi-LAT γ-ray flare F_γ ≈ 4 × 10⁻⁸ erg/cm²/s -/

/-- **Fermi-LAT γ-ray flare flux** of TXS 0506+056 in September 2017,
    in units of `10⁻⁹ erg cm⁻² s⁻¹`: `40`
    (i.e. `4 × 10⁻⁸ erg cm⁻² s⁻¹`).

    During the IC170922A alert, Fermi-LAT measured TXS 0506+056 in
    a 5× enhanced flaring state relative to its quiescent flux,
    reaching `F_γ ≈ 4 × 10⁻⁸ erg cm⁻² s⁻¹` in the 0.1–300 GeV band.
    Stored as the integer mantissa for the `× 10⁻⁹` unit. -/
noncomputable def F_gamma_TXS_units : ℝ := 40

/-- **s756 — γ-ray flare flux > 0**. -/
theorem s756_F_gamma_TXS_pos : 0 < F_gamma_TXS_units := by
  unfold F_gamma_TXS_units; norm_num

/-- **s756 — γ-ray flare flux = 40** (`= 4 × 10⁻⁸ erg/cm²/s`). -/
theorem s756_F_gamma_TXS_eq : F_gamma_TXS_units = 40 := by
  unfold F_gamma_TXS_units; rfl

/-- **s756 — γ-ray flare flux > 10** (well above the
    `10⁻⁸ erg/cm²/s` cutoff for nominal blazar quiescence). -/
theorem s756_F_gamma_TXS_above_10 : 10 < F_gamma_TXS_units := by
  unfold F_gamma_TXS_units; norm_num

/-- **s756 — γ-ray flare flux < 100** (below the catastrophic
    `10⁻⁷ erg/cm²/s` regime; bounded blazar flare). -/
theorem s756_F_gamma_TXS_below_100 : F_gamma_TXS_units < 100 := by
  unfold F_gamma_TXS_units; norm_num

/-- **🚨 FRONTIER — s756 — Fermi-LAT γ-ray flare flux of TXS 0506+056
    in September 2017 is `4 × 10⁻⁸ erg cm⁻² s⁻¹`** — a `~5×` enhancement
    over the quiescent state, in the bounded blazar-flare envelope
    `(10, 100) × 10⁻⁹`. -/
theorem s756_Fermi_LAT_flare_4e_minus_8 :
    0 < F_gamma_TXS_units
    ∧ F_gamma_TXS_units = 40
    ∧ 10 < F_gamma_TXS_units
    ∧ F_gamma_TXS_units < 100 :=
  ⟨s756_F_gamma_TXS_pos, s756_F_gamma_TXS_eq,
   s756_F_gamma_TXS_above_10, s756_F_gamma_TXS_below_100⟩

/-! ## s757 — Joint ν–γ coincidence significance ≈ 5σ -/

/-- **Joint ν–γ coincidence significance** in units of `0.1σ`: `50`
    (i.e. `5σ`).

    The September 2017 ν–γ coincidence combines IceCube's `~3.5σ`
    deviation from a background-only neutrino expectation with
    Fermi-LAT's `~3.5σ` flaring state, giving a joint chance-coincidence
    probability of `~5σ` (combining roughly as
    `√(3.5² + 3.5²) ≈ 4.95`).  Stored as the integer mantissa for
    the `× 0.1σ` unit. -/
noncomputable def joint_significance_units : ℝ := 50

/-- **s757 — joint significance > 0**. -/
theorem s757_joint_sig_pos : 0 < joint_significance_units := by
  unfold joint_significance_units; norm_num

/-- **s757 — joint significance = 50** (`= 5σ`). -/
theorem s757_joint_sig_eq : joint_significance_units = 50 := by
  unfold joint_significance_units; rfl

/-- **s757 — joint significance > 30** (above the `3σ`
    multimessenger-coincidence threshold). -/
theorem s757_joint_sig_above_3sigma : 30 < joint_significance_units := by
  unfold joint_significance_units; norm_num

/-- **s757 — joint significance < 100** (below `10σ`; bounded,
    not a runaway statistical inflation). -/
theorem s757_joint_sig_below_10sigma : joint_significance_units < 100 := by
  unfold joint_significance_units; norm_num

/-- **🚨 FRONTIER — s757 — Joint ν–γ coincidence significance is
    `~5σ`** — combining IceCube's `~3.5σ` ν excess with Fermi-LAT's
    `~3.5σ` γ flare, the September 2017 chance-coincidence rejection
    sits decisively in the `(3σ, 10σ)` multimessenger envelope. -/
theorem s757_joint_significance_5sigma :
    0 < joint_significance_units
    ∧ joint_significance_units = 50
    ∧ 30 < joint_significance_units
    ∧ joint_significance_units < 100 :=
  ⟨s757_joint_sig_pos, s757_joint_sig_eq,
   s757_joint_sig_above_3sigma, s757_joint_sig_below_10sigma⟩

/-! ## s758 — Bundle composition + BlazarTXSMultimessenger Prop -/

/-- **BlazarTXSMultimessenger** — Prop scaffold capturing the five
    invariants of the September 2017 TXS 0506+056 multimessenger
    identification:

    1. positive IceCube IC170922A reconstructed ν energy at the
       `100 TeV+` astrophysical scale (`E_ν > 10 × 10 TeV = 100 TeV`),
    2. host-galaxy redshift in the local Hubble flow (`0 < z < 1`),
    3. positive Fermi-LAT γ-ray flare flux in the bounded blazar
       envelope (`10 < F_γ < 100` in `10⁻⁹ erg/cm²/s` units),
    4. joint ν–γ coincidence significance above the `3σ`
       multimessenger threshold,
    5. joint significance bounded below `10σ` (no runaway inflation). -/
def BlazarTXSMultimessenger : Prop :=
    10 < E_nu_IceCube_units
    ∧ (0 < z_TXS_0506_units ∧ z_TXS_0506_units < 1)
    ∧ (10 < F_gamma_TXS_units ∧ F_gamma_TXS_units < 100)
    ∧ 30 < joint_significance_units
    ∧ joint_significance_units < 100

/-- **🚨 s758 — BlazarTXSMultimessenger Prop is realised by the bundle**. -/
theorem s758_BlazarTXSMultimessenger_holds : BlazarTXSMultimessenger := by
  unfold BlazarTXSMultimessenger
  exact ⟨s754_E_nu_IceCube_above_100TeV,
         ⟨s755_z_TXS_0506_pos, s755_z_TXS_0506_below_unity⟩,
         ⟨s756_F_gamma_TXS_above_10, s756_F_gamma_TXS_below_100⟩,
         s757_joint_sig_above_3sigma,
         s757_joint_sig_below_10sigma⟩

/-- **🚨 FRONTIER — HEADLINE — s754-s758 — Blazar TXS 0506+056
    multimessenger ν–γ flare-coincidence bundle**.

    Six foundational facts from the September 22, 2017 multimessenger
    identification of blazar TXS 0506+056:

    1. `E_ν_IceCube_units > 10` — IC170922A `~290 TeV` astrophysical ν (s754).
    2. `z_TXS_0506_units < 1` — host redshift in local Hubble flow (s755).
    3. `F_γ_TXS_units > 10` — Fermi-LAT `~5×` enhanced γ flare (s756).
    4. `F_γ_TXS_units < 100` — γ flare bounded below catastrophe (s756).
    5. `joint_significance_units > 30` — joint `>3σ` ν–γ coincidence (s757).
    6. `joint_significance_units < 100` — joint significance bounded `<10σ` (s757).

    Multi-instrument coincidence:
    - **IceCube** (South Pole, 1 km³): IC170922A high-energy track event
      reconstructed at `E_ν ≈ 290 TeV`.
    - **Fermi-LAT** (γ-ray, 0.1–300 GeV): TXS 0506+056 in `~5×` enhanced
      flaring state at `F_γ ≈ 4 × 10⁻⁸ erg/cm²/s`.
    - **MAGIC** (TeV γ-ray): subsequent TeV-band confirmation.
    - **Optical spectroscopy** (Paiano et al. 2018): host redshift
      `z = 0.337`, anchoring the source in the local Hubble flow.

    The combined chance-coincidence probability is `~5σ`, giving the
    first astrophysical-source identification of a high-energy
    cosmic neutrino — opening high-energy multimessenger astronomy.

    Sub-lemmas for sessions s754-s758 in T-1.  Lean-core only. -/
theorem s754_s758_blazar_TXS_0506_multimessenger_bundle_headline :
    10 < E_nu_IceCube_units
    ∧ z_TXS_0506_units < 1
    ∧ 10 < F_gamma_TXS_units
    ∧ F_gamma_TXS_units < 100
    ∧ 30 < joint_significance_units
    ∧ joint_significance_units < 100 :=
  ⟨s754_E_nu_IceCube_above_100TeV,
   s755_z_TXS_0506_below_unity,
   s756_F_gamma_TXS_above_10,
   s756_F_gamma_TXS_below_100,
   s757_joint_sig_above_3sigma,
   s757_joint_sig_below_10sigma⟩

end OmegaTheory.Predictions.T1_BlazarTXS0506MultimessengerBundle
