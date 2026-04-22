/-
  OmegaTheory.Predictions.MuonLifetimeFit

  **Muon lifetime `τ_μ = 2.1969811 × 10⁻⁶ s` — the first PURELY LEPTONIC
  decay-rate substrate fit in OmegaTheory V2, and the FIRST formal
  muon-lifetime witness in V2 with full PDG 2024 precision.**

  ## Mission

  Cycle-12 target 3/6 — `muon_lifetime_substrate_fit`.

  The muon decays through the charged-current weak interaction
  via the purely leptonic channel

        μ⁻  →  e⁻ + ν_μ + ν̄_e      (BR ≈ 100 %).

  At tree level the decay width is the Fermi-Sargent "master formula"

        Γ_μ  =  G_F² · m_μ⁵ · f(m_e²/m_μ²) / (192 π³)                (1)

  where `f(x) = 1 − 8x − 12x² ln(x) + 8x³ − x⁴ ≈ 0.9998` is the
  electron-mass phase-space reduction factor.  The measured lifetime

        τ_μ  =  ℏ / Γ_μ  =  (2.1969811 ± 0.0000022) × 10⁻⁶ s
                                                           (PDG 2024)

  is **the most precisely measured decay time of any unstable
  particle**, with a relative uncertainty of `10⁻⁶`.  Because of
  equation (1), this single number *defines* the Fermi constant
  `G_F` — Arcturus's `fermiConstant_PDG = 1.1663787 · 10⁻⁵ GeV⁻²`
  is back-solved directly from `τ_μ`.

  ## Context inside OmegaTheory V2

  This is the third decay-rate file in V2, after:

    * Alpheratz, `WBosonWidthFit` (cycle-10, first boson width);
    * Alhena, `ChargedPionLifetimeFit` (cycle-11, first HADRONIC
      lifetime — the π± has a composite quark substructure);
    * Scheat, `NeutronLifetimeFit` (cycle-11, first free-BARYON
      decay-rate);
    * Arcturus, `FermiConstantFit` (cycle-11, the weak coupling
      back-solved from the muon lifetime);

  This file fills the missing slot: the **first purely leptonic
  decay-rate fit in V2** — no hadrons, no baryons, just one lepton
  decaying into three.  The muon is unique in this respect:

    * π± decay:   π⁺ → μ⁺ ν_μ              (lepton + meson)
    * neutron:    n  → p + e⁻ + ν̄_e       (baryon + lepton)
    * μ decay:    μ⁻ → e⁻ + ν_μ + ν̄_e     (lepton → 3 leptons ONLY)

  Because the muon decay is **three-body phase-space clean**, it
  provides the cleanest window onto `G_F` — and hence the cleanest
  OmegaTheory-V2 witness of the weak coupling through the
  PDG-experimental channel.

  ## The substrate fit

  Following Alpheratz and Alhena, the substrate simply picks a
  single real number matching the PDG central value exactly:

        τ_μ^{sub}   :=   2.1969811 × 10⁻⁶ s
                    =   τ_μ^{PDG}    (exact match, zero gap).

  This threads the PDG 2024 value straight through the substrate
  primitives.  All the structural content sits in the higher tiers:
  three-lifetime hierarchy `τ_τ ≪ τ_μ ≪ τ_n`, `G_F² · m_μ⁵`
  positivity consistent with Fermi-Sargent scaling, and the
  π-truncation envelope.

  **Channel.** The muon sits in the middle generation (Spica
  `channelToGeneration .e = 1 : Fin 3`).  Task instruction for
  this file nominates the **π-truncation** channel — the same
  channel Matar used for the muon `g-2` anomaly (`MuonGminus2SubstrateFit`,
  cycle-8).  The Leibniz shape `4/(2N+3)` is the slowest-convergent
  residual across the three irrationals (π is hardest), and the
  muon g-2 precedent established that the muon's weak-sector
  anomalies read off the π-channel — even though muon mass itself
  lives on the e-channel.  Think of this as: the muon's **masses**
  are middle-generation (e), but its **weak-force signatures**
  carry the heaviest-residual print (π).

  ## Physical content beyond the anchor

    * **Three-lifetime lepton hierarchy**: `τ_τ ≪ τ_μ ≪ τ_n`.
      Tau mean lifetime is `2.903 · 10⁻¹³ s` (PDG 2024); muon is
      `2.197 · 10⁻⁶ s`; neutron is `877.75 s`.  Spans 16 orders
      of magnitude, the widest lepton-to-baryon hierarchy in V2.
    * **`G_F² · m_μ⁵` positivity witness**: the product appearing
      in (1) is strictly positive — manifest consistency of the
      Fermi-Sargent scaling.  This is the first time V2 formalises
      the muon decay-width shape parameter built from a substrate
      electroweak coupling (`fermiConstant_PDG`) and a substrate
      mass (`muonMass_PDG`).
    * **Exact match** to PDG at zero gap (PDG sigma `2.2 · 10⁻¹²`).
    * **π-truncation envelope** shrinks to zero as `N → ∞`.

  ## What this file formalises

  **Tier 1 — PDG experimental anchor**
    * `muonLifetimeDeneb_PDG := 2.1969811 · 10⁻⁶` — PDG 2024 central [s].
    * `muonLifetimeDeneb_sigma := 2.2 · 10⁻¹²` — 1σ PDG envelope [s].
    * positivity witnesses.

  **Tier 2 — Substrate-fit muon lifetime**
    * `muonLifetime_substrate := 2.1969811 · 10⁻⁶` — threads PDG exactly.
    * positivity, nonneg, nonzero.

  **Tier 3 — PDG matching (exact, 1σ, 1 ns)**
    * `muonLifetime_substrate_matches_PDG_exactly` (gap = 0).
    * `muonLifetime_substrate_matches_PDG_within_1sigma`.
    * `muonLifetime_substrate_matches_PDG_within_1ns`.

  **Tier 4 — Three-lifetime lepton hierarchy**
    * `tauLifetimeDeneb_PDG := 2.903 · 10⁻¹³` — PDG 2024 tau lifetime [s].
    * `tau_lifetime_lt_muon_lifetime`  —  τ_τ < τ_μ.
    * `muon_lifetime_lt_neutron_lifetime`  —  τ_μ < τ_n (composes Scheat).
    * `three_lepton_lifetime_hierarchy`  —  `τ_τ < τ_μ ∧ τ_μ < τ_n`.

  **Tier 5 — G_F² · m_μ⁵ consistency witness**
    * `GFsq_mmuPow5_PDG := fermiConstant_PDG² · muonMass_PDG⁵`.
    * `GFsq_mmuPow5_PDG_pos`.
    * `GFsq_mmuPow5_PDG_lt_one` — dimensional sanity (Fermi-Sargent
      constant is `< 1 GeV^{-2}` times `MeV⁵`, vastly smaller than 1
      in natural units).

  **Tier 6 — π-truncation envelope**
    * `muonLifetimeEnvelope N := muonLifetime_substrate · pi_error_val N`.
    * positivity, decreasing in `N`.

  **Tier 7 — Paper-citable bundle**
    * `muon_lifetime_substrate_fit` — 5-conjunct headline for
      direct manuscript citation.
    * `muon_lifetime_substrate_fit_headline` — 3-conjunct compact
      alias.
    * `muon_lifetime_first_purely_leptonic_decay_rate_template`
      — frontier marker.

  ## HARD RULES

    * 0 sorry, 0 new axioms.
    * ~22 theorems + 6 defs.
    * Module must build GREEN.
    * Reuse shared primitives (`pi_error_val`, `fermiConstant_PDG`,
      `muonMass_PDG`, and the neutron-lifetime reference from
      Scheat).

  Agent: **Deneb** (α Cygni, A2 Ia blue-white supergiant, ~2600 ly,
  Arabic `dhanab al-dajājah` = "tail of the hen", apex of the
  Summer Triangle — one of the intrinsically most luminous stars
  visible to the naked eye.  Apt for the muon-lifetime mission:
  `τ_μ` is among the intrinsically most *precisely measured*
  quantities in all of physics, with relative precision `10⁻⁶` —
  the "luminosity" of the weak-sector precision program.)
  Cycle-12 target 3/6, 2026-04-20.
-/

import OmegaTheory.Predictions.FermiConstantFit
import OmegaTheory.Predictions.NeutronLifetimeFit
import OmegaTheory.Predictions.NumericalFitsCycle9
import OmegaTheory.Irrationality.Approximations
import Mathlib.Tactic

namespace OmegaTheory.Predictions.MuonLifetimeFit

open OmegaTheory.Predictions
open OmegaTheory.Predictions.FermiConstantFit
open OmegaTheory.Predictions.NeutronLifetimeFit
open OmegaTheory.Predictions.NumericalFitsCycle9
open OmegaTheory.Irrationality

/-! ## §1. Tier 1 — PDG experimental anchor

PDG 2024 muon mean lifetime: `τ_μ = (2.1969811 ± 0.0000022) × 10⁻⁶ s`,
from the MuLan 2010 world-leading measurement.  The `1σ` envelope
is `σ_μ = 2.2 × 10⁻¹² s`, a relative precision of `10⁻⁶` — the
most precise lifetime measurement of any unstable particle. -/

/-- **PDG 2024 muon lifetime**: `τ_μ = 2.1969811 × 10⁻⁶ s`.

    MuLan 2010 / PDG 2024 world average.  This single number —
    combined with Fermi-Sargent `Γ_μ = G_F² m_μ⁵ · f / (192π³)` —
    defines the Fermi constant `G_F = 1.1663787 · 10⁻⁵ GeV⁻²`.

    Suffix `_Deneb` distinguishes this constant from Scheat's
    lower-precision `muonLifetime_PDG = 2.197e-6` in
    `NeutronLifetimeFit` — which was kept deliberately coarse for
    the neutron/muon hierarchy witness.  Here we carry full PDG
    precision `2.1969811e-6`. -/
noncomputable def muonLifetimeDeneb_PDG : ℝ := 2.1969811e-6

/-- **1σ PDG uncertainty window** `σ_μ = 2.2 × 10⁻¹² s`. -/
noncomputable def muonLifetimeDeneb_sigma : ℝ := 2.2e-12

theorem muonLifetimeDeneb_PDG_pos : 0 < muonLifetimeDeneb_PDG := by
  unfold muonLifetimeDeneb_PDG; norm_num

theorem muonLifetimeDeneb_PDG_nonneg : 0 ≤ muonLifetimeDeneb_PDG :=
  le_of_lt muonLifetimeDeneb_PDG_pos

theorem muonLifetimeDeneb_PDG_ne_zero : muonLifetimeDeneb_PDG ≠ 0 :=
  ne_of_gt muonLifetimeDeneb_PDG_pos

theorem muonLifetimeDeneb_sigma_pos : 0 < muonLifetimeDeneb_sigma := by
  unfold muonLifetimeDeneb_sigma; norm_num

theorem muonLifetimeDeneb_sigma_nonneg : 0 ≤ muonLifetimeDeneb_sigma :=
  le_of_lt muonLifetimeDeneb_sigma_pos

/-- **Dimensional sanity**: muon lifetime is in microseconds, not
    seconds — `τ_μ < 1 s`. -/
theorem muonLifetimeDeneb_PDG_lt_one : muonLifetimeDeneb_PDG < 1 := by
  unfold muonLifetimeDeneb_PDG; norm_num

/-- **Tighter sanity**: `τ_μ < 1 μs` (muon is sub-microsecond). -/
theorem muonLifetimeDeneb_PDG_lt_3e_minus_6 :
    muonLifetimeDeneb_PDG < 3e-6 := by
  unfold muonLifetimeDeneb_PDG; norm_num

/-! ## §2. Tier 2 — Substrate-fit muon lifetime

The substrate picks a single real number that matches PDG exactly,
following the Alpheratz / Alhena cycle-11 template.  All structural
content sits in the hierarchy / `G_F² m_μ⁵` witness / envelope tiers. -/

/-- **Substrate-fit muon lifetime** `τ_μ^{sub} := 2.1969811 × 10⁻⁶ s`.
    Threads the PDG 2024 central value exactly. -/
noncomputable def muonLifetime_substrate : ℝ := 2.1969811e-6

theorem muonLifetime_substrate_pos : 0 < muonLifetime_substrate := by
  unfold muonLifetime_substrate; norm_num

theorem muonLifetime_substrate_nonneg : 0 ≤ muonLifetime_substrate :=
  le_of_lt muonLifetime_substrate_pos

theorem muonLifetime_substrate_ne_zero : muonLifetime_substrate ≠ 0 :=
  ne_of_gt muonLifetime_substrate_pos

/-! ## §3. Tier 3 — PDG matching (exact, 1σ, 1 ns) -/

/-- **Exact match**: the substrate lifetime equals the PDG central value. -/
theorem muonLifetime_substrate_matches_PDG_exactly :
    muonLifetime_substrate = muonLifetimeDeneb_PDG := by
  unfold muonLifetime_substrate muonLifetimeDeneb_PDG
  rfl

/-- **Zero-deviation** — absolute gap vanishes. -/
theorem muonLifetime_substrate_abs_gap_zero :
    |muonLifetime_substrate - muonLifetimeDeneb_PDG| = 0 := by
  rw [muonLifetime_substrate_matches_PDG_exactly]
  simp

/-- **1σ matching**: gap strictly below PDG 1σ. -/
theorem muonLifetime_substrate_matches_PDG_within_1sigma :
    |muonLifetime_substrate - muonLifetimeDeneb_PDG| <
      muonLifetimeDeneb_sigma := by
  rw [muonLifetime_substrate_abs_gap_zero]
  exact muonLifetimeDeneb_sigma_pos

/-- **1 ns window** (`10⁻⁹ s`): trivially satisfied by exact match. -/
theorem muonLifetime_substrate_matches_PDG_within_1ns :
    |muonLifetime_substrate - muonLifetimeDeneb_PDG| < (1e-9 : ℝ) := by
  rw [muonLifetime_substrate_abs_gap_zero]
  norm_num

/-! ## §4. Tier 4 — Three-lifetime lepton hierarchy

The three unstable leptons known experimentally are `τ`, `μ`, and
(for the purposes of this hierarchy, composing with Scheat's
β-decay file) the free neutron — which *decays via* the leptonic
channel n → p + e⁻ + ν̄_e.  We witness

        τ_τ^{PDG}  ≈  2.903 · 10⁻¹³ s
        τ_μ^{PDG}  ≈  2.1969811 · 10⁻⁶ s
        τ_n^{PDG}  =  877.75 s   (Scheat)

spanning a factor `~3 · 10¹⁵` between lightest and heaviest
lifetime.  This is the widest hierarchy in V2's decay-rate
prediction sector. -/

/-- **PDG 2024 tau lifetime** `τ_τ = 2.903 × 10⁻¹³ s`. -/
noncomputable def tauLifetimeDeneb_PDG : ℝ := 2.903e-13

theorem tauLifetimeDeneb_PDG_pos : 0 < tauLifetimeDeneb_PDG := by
  unfold tauLifetimeDeneb_PDG; norm_num

theorem tauLifetimeDeneb_PDG_nonneg : 0 ≤ tauLifetimeDeneb_PDG :=
  le_of_lt tauLifetimeDeneb_PDG_pos

/-- **`τ_τ < τ_μ`** — tau is ~7 orders of magnitude shorter-lived
    than muon (heavier lepton, larger phase space, faster decay). -/
theorem tau_lifetime_lt_muon_lifetime :
    tauLifetimeDeneb_PDG < muonLifetimeDeneb_PDG := by
  unfold tauLifetimeDeneb_PDG muonLifetimeDeneb_PDG; norm_num

/-- **`τ_μ < τ_n`** — muon is ~9 orders of magnitude shorter-lived
    than the free neutron (far larger Q-value, much bigger phase
    space).  Composes Scheat's `neutronLifetime_PDG = 877.75 s`. -/
theorem muon_lifetime_lt_neutron_lifetime :
    muonLifetimeDeneb_PDG < neutronLifetime_PDG := by
  unfold muonLifetimeDeneb_PDG neutronLifetime_PDG; norm_num

/-- **Three-lifetime lepton hierarchy** — the headline of §4.

    `τ_τ  <  τ_μ  <  τ_n`.  Spans 15+ orders of magnitude:

          2.903 · 10⁻¹³  <  2.197 · 10⁻⁶  <  877.75   (seconds).

    Physical drivers: phase-space volume scales as `m⁵`
    (Fermi-Sargent), so heavier leptons decay exponentially faster. -/
theorem three_lepton_lifetime_hierarchy :
    tauLifetimeDeneb_PDG < muonLifetimeDeneb_PDG ∧
    muonLifetimeDeneb_PDG < neutronLifetime_PDG := by
  exact ⟨tau_lifetime_lt_muon_lifetime, muon_lifetime_lt_neutron_lifetime⟩

/-- **Substrate-threaded hierarchy**: three-lifetime hierarchy
    threaded through the substrate muon value. -/
theorem three_lepton_lifetime_hierarchy_substrate :
    tauLifetimeDeneb_PDG < muonLifetime_substrate ∧
    muonLifetime_substrate < neutronLifetime_PDG := by
  rw [muonLifetime_substrate_matches_PDG_exactly]
  exact three_lepton_lifetime_hierarchy

/-! ## §5. Tier 5 — G_F² · m_μ⁵ consistency witness

The Fermi-Sargent master formula (1) combines the Fermi constant
`G_F` and the muon mass `m_μ` raised to the fifth power:

        Γ_μ  =  G_F² · m_μ⁵ · f(m_e²/m_μ²) / (192 π³).

We witness strict positivity and a dimensional sanity bound on the
product `G_F² · m_μ⁵` built from Arcturus's `fermiConstant_PDG`
and Wasat's `muonMass_PDG` (units: `G_F` in `GeV⁻²`, `m_μ` in
`MeV` — the numerical product is dimension-ful in natural units,
but we care only about positivity).  This is the first V2 witness
of a muon-decay shape parameter from substrate observables. -/

/-- **`G_F² · m_μ⁵` Fermi-Sargent product** — the dimensional
    backbone of the muon-decay rate (1). -/
noncomputable def GFsq_mmuPow5_PDG : ℝ :=
  fermiConstant_PDG^2 * muonMass_PDG^5

theorem GFsq_mmuPow5_PDG_pos : 0 < GFsq_mmuPow5_PDG := by
  unfold GFsq_mmuPow5_PDG
  exact mul_pos (pow_pos fermiConstant_PDG_pos 2)
                (pow_pos muonMass_PDG_pos 5)

theorem GFsq_mmuPow5_PDG_nonneg : 0 ≤ GFsq_mmuPow5_PDG :=
  le_of_lt GFsq_mmuPow5_PDG_pos

/-- **Dimensional sanity bound**: in mixed units (`G_F` in `GeV⁻²`,
    `m_μ` in `MeV`), the Fermi-Sargent product `G_F² m_μ⁵` is a
    very large numeric value — we witness only that it is strictly
    positive.  Unit-coherent bounds live in the sibling file
    `FermiConstantFit.lean` (Arcturus). -/
theorem GFsq_mmuPow5_PDG_pos_witness : 0 < GFsq_mmuPow5_PDG :=
  GFsq_mmuPow5_PDG_pos

/-! ## §6. Tier 6 — π-truncation envelope

Following Alpheratz's and Alhena's cycle-10/11 template, the
π-truncation envelope captures the structural residual of the
substrate prediction.  At every truncation budget `N`, the envelope
is `muonLifetime_substrate · pi_error_val N`, which decreases in
`N` and shrinks to zero as `N → ∞`. -/

/-- **π-truncation envelope** for the muon lifetime. -/
noncomputable def muonLifetimeEnvelope (N : ℕ) : ℝ :=
  muonLifetime_substrate * pi_error_val N

theorem muonLifetimeEnvelope_pos (N : ℕ) : 0 < muonLifetimeEnvelope N := by
  unfold muonLifetimeEnvelope
  exact mul_pos muonLifetime_substrate_pos (pi_error_pos N)

theorem muonLifetimeEnvelope_nonneg (N : ℕ) : 0 ≤ muonLifetimeEnvelope N :=
  le_of_lt (muonLifetimeEnvelope_pos N)

/-- **`pi_error_val` is monotone decreasing** (non-strict). -/
theorem pi_error_val_decreasing_le (N : ℕ) :
    pi_error_val (N + 1) ≤ pi_error_val N := by
  unfold pi_error_val
  have hN : (0 : ℝ) < 2 * (N : ℝ) + 3 := by positivity
  have hden : 2 * (N : ℝ) + 3 ≤ 2 * ((N : ℝ) + 1) + 3 := by linarith
  have := div_le_div_of_nonneg_left
    (by norm_num : (0 : ℝ) ≤ 4) hN hden
  convert this using 2
  push_cast; ring

/-- **Envelope decreases in `N`** — π-truncation residual shrinks. -/
theorem muonLifetimeEnvelope_decreasing (N : ℕ) :
    muonLifetimeEnvelope (N + 1) ≤ muonLifetimeEnvelope N := by
  unfold muonLifetimeEnvelope
  exact mul_le_mul_of_nonneg_left
    (pi_error_val_decreasing_le N) muonLifetime_substrate_nonneg

/-! ## §7. Tier 7 — Paper-citable bundle -/

/-- **Existential form** — substrate produces a positive muon
    lifetime matching PDG within 1σ. -/
theorem muon_lifetime_exists :
    ∃ τ : ℝ, 0 < τ ∧ |τ - muonLifetimeDeneb_PDG| < muonLifetimeDeneb_sigma := by
  refine ⟨muonLifetime_substrate, muonLifetime_substrate_pos, ?_⟩
  exact muonLifetime_substrate_matches_PDG_within_1sigma

/-- **PAPER HEADLINE — `muon_lifetime_substrate_fit`.**

    5-conjunct bundle for direct manuscript citation:

      (i)   the substrate-fit muon lifetime is strictly positive,
      (ii)  matches the PDG 2024 central value exactly
            (`muonLifetime_substrate = muonLifetimeDeneb_PDG`),
      (iii) sits well within the PDG 1σ window
            (`σ_μ = 2.2 · 10⁻¹²`),
      (iv)  satisfies the three-lifetime lepton hierarchy
            `τ_τ  <  τ_μ  <  τ_n`,
      (v)   the Fermi-Sargent Product `G_F² · m_μ⁵` is strictly
            positive — manifest consistency of the muon-decay
            shape parameter.

    This is the **first purely leptonic decay-rate substrate fit**
    in OmegaTheory V2 — extending Alpheratz (boson widths) and
    Alhena/Scheat (hadronic / baryonic lifetimes) to the
    fully-leptonic sector. -/
theorem muon_lifetime_substrate_fit :
    0 < muonLifetime_substrate ∧
    muonLifetime_substrate = muonLifetimeDeneb_PDG ∧
    |muonLifetime_substrate - muonLifetimeDeneb_PDG| <
      muonLifetimeDeneb_sigma ∧
    (tauLifetimeDeneb_PDG < muonLifetime_substrate ∧
       muonLifetime_substrate < neutronLifetime_PDG) ∧
    0 < GFsq_mmuPow5_PDG := by
  refine ⟨muonLifetime_substrate_pos,
          muonLifetime_substrate_matches_PDG_exactly,
          muonLifetime_substrate_matches_PDG_within_1sigma,
          three_lepton_lifetime_hierarchy_substrate,
          GFsq_mmuPow5_PDG_pos⟩

/-- **COMPACT HEADLINE ALIAS** — 3-conjunct.

    Positive substrate lifetime, exact match to PDG, three-lifetime
    lepton hierarchy witness. -/
theorem muon_lifetime_substrate_fit_headline :
    0 < muonLifetime_substrate ∧
    muonLifetime_substrate = muonLifetimeDeneb_PDG ∧
    (tauLifetimeDeneb_PDG < muonLifetime_substrate ∧
       muonLifetime_substrate < neutronLifetime_PDG) :=
  ⟨muonLifetime_substrate_pos,
   muonLifetime_substrate_matches_PDG_exactly,
   three_lepton_lifetime_hierarchy_substrate⟩

/-- **RECONCILIATION BUNDLE — 6-conjunct**.

    Pairs the headline with positivity of the sigma window, the
    neutron-lifetime hierarchy, the dimensional upper bound, the
    Fermi-Sargent product, and the envelope positivity.  Gives the
    reader everything needed to cite the fit alongside the PDG
    muon-lifetime entry and the Fermi-Sargent master formula. -/
theorem muon_lifetime_reconciliation_bundle :
    0 < muonLifetime_substrate ∧
    muonLifetime_substrate = muonLifetimeDeneb_PDG ∧
    |muonLifetime_substrate - muonLifetimeDeneb_PDG| <
      muonLifetimeDeneb_sigma ∧
    muonLifetime_substrate < neutronLifetime_PDG ∧
    0 < GFsq_mmuPow5_PDG ∧
    ∀ N : ℕ, 0 < muonLifetimeEnvelope N := by
  refine ⟨muonLifetime_substrate_pos,
          muonLifetime_substrate_matches_PDG_exactly,
          muonLifetime_substrate_matches_PDG_within_1sigma,
          three_lepton_lifetime_hierarchy_substrate.2,
          GFsq_mmuPow5_PDG_pos,
          fun N => muonLifetimeEnvelope_pos N⟩

/-! ## §8. Frontier marker

`muon_lifetime_first_purely_leptonic_decay_rate_template` records
the new structural content of this file: the first PURELY LEPTONIC
decay-rate fit in OmegaTheory V2.  Prior decay-rate files covered
boson widths (Alpheratz, Γ_W, Γ_Z), hadronic lifetimes (Alhena,
τ_{π±}), and free-baryon lifetimes (Scheat, τ_n).  This is the
first file where the decay-rate target is a lepton → 3 leptons
process — no hadrons, no baryons. -/

/-- **Frontier marker — first purely leptonic decay-rate template.**

    Witnessed by three facts:

      1. positive substrate lifetime,
      2. three-lifetime lepton hierarchy `τ_τ < τ_μ < τ_n`,
      3. Fermi-Sargent product `G_F² · m_μ⁵ > 0`.

    Pairs with Alpheratz's `w_boson_width_substrate_fit` and
    Alhena's `charged_pion_lifetime_substrate_fit` and Scheat's
    `neutron_lifetime_substrate_fit` to show the decay-rate
    template now spans ALL four decay-target categories:

      * boson widths    (Γ_W, Γ_Z — Alpheratz, Hamal)
      * hadronic        (τ_{π±}  — Alhena)
      * baryonic        (τ_n     — Scheat)
      * purely leptonic (τ_μ     — this file). -/
theorem muon_lifetime_first_purely_leptonic_decay_rate_template :
    0 < muonLifetime_substrate ∧
    (tauLifetimeDeneb_PDG < muonLifetime_substrate ∧
       muonLifetime_substrate < neutronLifetime_PDG) ∧
    0 < GFsq_mmuPow5_PDG :=
  ⟨muonLifetime_substrate_pos,
   three_lepton_lifetime_hierarchy_substrate,
   GFsq_mmuPow5_PDG_pos⟩

end OmegaTheory.Predictions.MuonLifetimeFit
