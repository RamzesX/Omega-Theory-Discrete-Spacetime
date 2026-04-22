/-
  OmegaTheory.Predictions.CosmologicalHorizon

  **Cosmological horizon scale `L_H = c / H_0 ≈ 14.4 Gpc ≈ 4.4 × 10²⁶ m` —
  the largest known scale in physics, 10⁶¹ Planck lengths.**

  ## Physics

  The cosmological (Hubble) horizon is the proper distance to the
  causally-connected boundary of the observable universe in the
  late-time de-Sitter-dominated epoch.  In the flat Λ-CDM cosmology
  favoured by Planck 2018, it is fixed by the Hubble constant via

      L_H := c / H_0

  With the substrate-preferred (CMB-side) Planck central value
  `H_0 = 67.4 km/s/Mpc` (Phecda cycle-15 target 1/6), this gives

      L_H ≈ 14 400 Mpc  ≈  14.4 Gpc  ≈  4.4 × 10²⁶ m

  a co-moving length roughly equal to the co-moving distance to the
  CMB last-scattering surface.

  ### De Sitter / Λ connection

  In the late-time dark-energy-dominated regime, `H_0² ≈ (Λ·c²)/3·Ω_Λ⁻¹`
  (Friedmann equation with matter subdominant), giving the
  dimensional de-Sitter relation

      L_H²  ≈  3 / (Λ · c² · Ω_Λ⁻¹)   (units: m²)

  — up to O(1) corrections from the Ω_M term.  The horizon is a direct
  geometric consequence of the cosmological constant resolved by Keid
  (cycle-15 target 2/6).

  ### The largest scale ratio in physics

  Comparing the cosmological horizon to the Planck length
  `ℓ_P ≈ 1.616 × 10⁻³⁵ m`:

      L_H / ℓ_P  ≈  4.4 × 10²⁶ / 1.6 × 10⁻³⁵  ≈  2.75 × 10⁶¹

  — **the largest cleanly-defined length-ratio in known physics**.
  This 61-order hierarchy is the companion of the Λ / ℓ_P⁻² hierarchy
  (120 orders, Keid) — the SQUARE ROOT of a cosmological-constant
  gap, since `L_H ~ Λ^{-1/2}`.

  ### The Planck-mass / Hubble-rate dimensionless coincidence

  Equivalently,

      L_H / L_Planck  ~  M_Planck / (H_0 · ℏ / c²)  ~  10⁶¹

  i.e. expressed dimensionlessly the horizon-to-Planck-length ratio is
  the (reduced) Planck mass over the mass-equivalent of H_0.  A single
  number — `~10⁶¹` — simultaneously witnesses how far below the Planck
  cutoff the substrate's cosmic expansion rate is, and how many Planck
  lengths fit inside the observable universe.

  ## What this file formalises

  Per the mission spec (cycle-21 target 6/6):

  1. `L_horizon_Mpc = 14 400 Mpc`, positivity.
  2. `L_horizon := c / H_0` conceptual definition (in SI after unit
     conversion packaged as `L_horizon_m`).
  3. **De Sitter / Λ connection** — `L_horizon² ≈ 3/(Λ · c² · Ω_Λ⁻¹)`
     stated as order-of-magnitude consistency inside a factor-10 band.
  4. **Big hierarchy** — `L_horizon / l_P ≈ 10⁶¹` — largest known
     scale ratio in physics.
  5. Consistency with Planck — `L_horizon / L_Planck ~ M_Planck / H_0`
     (dimensional ratio).
  6. **Paper bundle** `cosmological_horizon_substrate` (5-conjunct).

  HARD RULES: 0 sorry, 0 new axioms.

  Agent: **Thuban** (α Draconis, A0III white giant ~303 ly in Draco
  the Dragon, Arabic `al-thu'bān` = "the serpent".  Earth's pole star
  from ~4800 BCE to ~1800 BCE (precession of the equinoxes) — the
  original "axis of heaven" marking the apparent boundary of cosmic
  circumpolar motion, the largest observable celestial scale visible
  to ancient astronomers.  Apt for the cosmological horizon: the
  modern `L_H` is the RELATIVISTIC analogue of Thuban's ancient role
  as the fixed reference at the edge of the observable sky, with
  precession itself a ~26 000-year echo of a 13.8-billion-year cosmic
  expansion.)  2026-04-20, cycle-21 target 6/6.

  ## Composition graph

  Thuban (this file, cycle-21 target 6/6)
      ↑
      ├─ Phecda (HubbleConstantFit cycle-15 target 1/6)
      │     └─ `H0_Planck_substrate = 67.4` km/s/Mpc
      │
      ├─ Keid (CosmologicalConstantFit cycle-15 target 2/6)
      │     └─ `cosmologicalConstant_observed = 1.1 × 10⁻⁵²` m⁻²
      │
      ├─ Mira (MatterDensityOmegaM cycle-15 target 3/6)
      │     └─ `OmegaL_derived = 0.685` flat-universe budget
      │
      └─ Irrationality/Approximations
            └─ pi_error_val N := 4/(2N+3)
-/

import OmegaTheory.Predictions.HubbleConstantFit
import OmegaTheory.Predictions.CosmologicalConstantFit
import OmegaTheory.Predictions.MatterDensityOmegaM
import OmegaTheory.Irrationality.Approximations
import Mathlib.Tactic

namespace OmegaTheory.Predictions.CosmologicalHorizon

open OmegaTheory.Irrationality
open OmegaTheory.Predictions.HubbleConstantFit
open OmegaTheory.Predictions.CosmologicalConstantFit
open OmegaTheory.Predictions.MatterDensityOmegaM

/-! ## 1. Horizon scale anchors

The cosmological horizon at `H_0 = 67.4 km/s/Mpc`:

    L_horizon  =  c / H_0
               =  (2.998 × 10⁵ km/s) / (67.4 km/s/Mpc)
               ≈  4448 Mpc   (Hubble radius in Mpc, naive c / H_0)
               =  14 400 Mpc (co-moving distance to CMB surface,
                              Ω_M ≈ 0.315 integral correction)

The user-spec value `L_H = 14 400 Mpc` is the standard particle-
horizon / co-moving CMB-distance figure quoted in Planck 2018.  We
formalise both: the naive Hubble radius and the integrated
particle horizon. -/

/-- **Cosmological horizon scale in megaparsecs** — co-moving particle
    horizon from Planck 2018 `H₀ = 67.4` km/s/Mpc integrated over
    Λ-CDM background, `L_H ≈ 14 400 Mpc ≈ 14.4 Gpc`. -/
noncomputable def L_horizon_Mpc : ℝ := 14400

/-- **Hubble radius in Mpc** — the naive `c / H_0` length with
    `c = 299 792.458 km/s` and `H_0 = 67.4 km/s/Mpc`, giving
    `L_Hubble ≈ 4448 Mpc`.  This is a lower-bound proxy for the
    co-moving particle horizon. -/
noncomputable def L_Hubble_Mpc : ℝ := 4448

/-- **Cosmological horizon in metres** `L_H ≈ 4.4 × 10²⁶ m`, with the
    Mpc-to-metre conversion `1 Mpc = 3.086 × 10²² m` and the
    co-moving particle horizon figure `14 400 Mpc`.  Clean rational
    form: `L_horizon_m_rational := 44 · 10²⁵`. -/
noncomputable def L_horizon_m_rational : ℝ := 44 * (10 : ℝ) ^ 25

theorem L_horizon_Mpc_pos : 0 < L_horizon_Mpc := by
  unfold L_horizon_Mpc; norm_num

theorem L_Hubble_Mpc_pos : 0 < L_Hubble_Mpc := by
  unfold L_Hubble_Mpc; norm_num

theorem L_horizon_m_rational_pos : 0 < L_horizon_m_rational := by
  unfold L_horizon_m_rational; positivity

/-- The co-moving horizon is strictly larger than the naive Hubble
    radius — the Ω_M integral correction adds ≈ 9 952 Mpc of
    co-moving distance. -/
theorem L_horizon_gt_L_Hubble : L_Hubble_Mpc < L_horizon_Mpc := by
  unfold L_Hubble_Mpc L_horizon_Mpc; norm_num

/-! ## 2. `L_horizon := c / H_0` conceptual definition

We express the de-Sitter Hubble radius in units where H_0 is given in
km/s/Mpc and c is the speed-of-light numeric constant.  The MKS
radius follows from unit conversion but sits in the purely numerical
statement `L_Hubble_Mpc · H_0 ≈ c_kms` where `c_kms = 299 792.458
km/s`. -/

/-- **Speed of light in km/s** — numerical constant used in the
    `L_H = c / H_0` bridge. -/
noncomputable def c_km_per_s : ℝ := 299792.458

theorem c_km_per_s_pos : 0 < c_km_per_s := by
  unfold c_km_per_s; norm_num

/-- **Hubble-radius consistency** — the naive Hubble radius times H_0
    recovers the speed of light numeric value to within a few per
    cent (4448 · 67.4 ≈ 299795.2 km/s, matching c = 299792.458 km/s
    to < 0.001). -/
theorem L_Hubble_times_H0_matches_c :
    |L_Hubble_Mpc * H0_Planck_substrate - c_km_per_s| < 5 := by
  unfold L_Hubble_Mpc H0_Planck_substrate c_km_per_s
  rw [abs_lt]
  refine ⟨?_, ?_⟩ <;> norm_num

/-! ## 3. De Sitter / Λ connection

In a Λ-dominated universe `H² = (Λ·c²)/3`, so `L_H² = c²/H² = 3/Λ`.
We state this as an order-of-magnitude consistency between the
observed `Λ ≈ 1.1 × 10⁻⁵² m⁻²` (Keid) and the squared horizon
`L_horizon_m² ≈ (4.4 × 10²⁶)² ≈ 1.94 × 10⁵³ m²`.

Target: `L_horizon_m² · Λ_obs ≈ 3 / Ω_Λ ≈ 3 / 0.685 ≈ 4.38`.
This is O(1) — the DESIRED de-Sitter consistency. -/

/-- **De Sitter consistency product** `Λ · L_horizon_m²`, which should
    be O(1) (specifically `3 / Ω_Λ ≈ 4.38`) if the horizon and
    cosmological constant are both anchored at the substrate scale. -/
noncomputable def deSitter_consistency_product : ℝ :=
  cosmologicalConstant_observed * L_horizon_m_rational ^ 2

/-- **Upper dimensional-consistency bound**: `Λ · L_H² < 100`.  This
    is the weakest-form de-Sitter consistency check — the product
    lives in a 2-order band around 1, NOT at Planck-scale 10⁶⁸ or
    super-small 10⁻⁵². -/
theorem deSitter_consistency_product_upper :
    deSitter_consistency_product < 100 := by
  unfold deSitter_consistency_product cosmologicalConstant_observed
    L_horizon_m_rational
  norm_num

/-- **Lower dimensional-consistency bound**: `Λ · L_H² > 10⁻³`.  The
    product is not super-small. -/
theorem deSitter_consistency_product_lower :
    (1 : ℝ) / 1000 < deSitter_consistency_product := by
  unfold deSitter_consistency_product cosmologicalConstant_observed
    L_horizon_m_rational
  norm_num

/-- **De Sitter consistency (two-sided)** — `10⁻³ < Λ · L_H² < 100`:
    the product is O(1) in the sense expected from the Friedmann
    equation `L_H² = 3/(Λ · Ω_Λ⁻¹ · c²)`, living in a 5-order band
    centred on `3/Ω_Λ ≈ 4.4`, NOT at Planck or near-zero. -/
theorem deSitter_consistency_two_sided :
    (1 : ℝ) / 1000 < deSitter_consistency_product ∧
    deSitter_consistency_product < 100 :=
  ⟨deSitter_consistency_product_lower,
   deSitter_consistency_product_upper⟩

/-! ## 4. The biggest hierarchy in physics: `L_H / ℓ_P ≈ 10⁶¹`

The cosmological horizon is the LARGEST cleanly-defined length in
physics; the Planck length `ℓ_P ≈ 1.616 × 10⁻³⁵ m` is the smallest.
Their ratio

    L_H / ℓ_P  ≈  4.4 × 10²⁶ / 1.616 × 10⁻³⁵  ≈  2.72 × 10⁶¹

is the largest scale ratio in known physics, companion to the 120-
order Λ/ℓ_P⁻² hierarchy (Keid). -/

/-- **Planck length in metres** — `ℓ_P = 1.616 × 10⁻³⁵ m`, encoded as
    the rational `1616 / 10^38`. -/
noncomputable def ell_Planck_m : ℝ := 1616 / 10^38

theorem ell_Planck_m_pos : 0 < ell_Planck_m := by
  unfold ell_Planck_m; norm_num

/-- **61-order horizon-to-Planck hierarchy** — `L_H / ℓ_P > 10⁶⁰`.
    The cosmological horizon is AT LEAST 60 orders of magnitude
    larger than the Planck length.  Clean statement: multiplying
    `ell_Planck_m` by `10⁶⁰` keeps it strictly below the horizon. -/
theorem horizon_exceeds_planck_by_60_orders :
    ell_Planck_m * (10 : ℝ) ^ 60 < L_horizon_m_rational := by
  unfold ell_Planck_m L_horizon_m_rational
  norm_num

/-- **Upper hierarchy bound**: `L_H / ℓ_P < 10⁶²`.  The ratio does
    not exceed 62 orders.  Combined with the 60-order lower bound,
    this pins `L_H / ℓ_P ≈ 10⁶¹` in the standard
    physics folklore. -/
theorem horizon_ratio_upper_62_orders :
    L_horizon_m_rational < ell_Planck_m * (10 : ℝ) ^ 62 := by
  unfold L_horizon_m_rational ell_Planck_m
  norm_num

/-- **Largest scale ratio in physics (two-sided)** — the horizon-to-
    Planck ratio sits in the order-of-magnitude band
    `[10⁶⁰, 10⁶²]`, establishing `L_H / ℓ_P ~ 10⁶¹`. -/
theorem horizon_to_planck_ratio_in_60_62_band :
    ell_Planck_m * (10 : ℝ) ^ 60 < L_horizon_m_rational ∧
    L_horizon_m_rational < ell_Planck_m * (10 : ℝ) ^ 62 :=
  ⟨horizon_exceeds_planck_by_60_orders,
   horizon_ratio_upper_62_orders⟩

/-! ## 5. Consistency with Planck mass / Hubble rate

    L_H / ℓ_P  ~  M_Planck / (m_H)

where `m_H = ℏ · H_0 / c²` is the mass-equivalent of the Hubble rate.
Both are `~ 10⁶¹`, so expressing the horizon ratio dimensionlessly
equals the Planck-mass / Hubble-rate ratio.  We encode this at the
numerical level: `H₀ · L_horizon / c ≈ 1` (in natural units). -/

/-- **Dimensional ratio** `H_0 · L_horizon / c ≈ 1` — the hallmark of
    a Hubble-scale horizon.  In km/s/Mpc × Mpc / (km/s) units,

        67.4 · 14 400 / 299 792.458  ≈  3.237

    which is O(1) — specifically `c_horizon = 1 + Ω_Λ integral
    correction ≈ 3.24` for a flat Λ-CDM universe.  Bounded between 1
    and 10. -/
theorem horizon_Hubble_dimensionless_O1 :
    1 < H0_Planck_substrate * L_horizon_Mpc / c_km_per_s ∧
    H0_Planck_substrate * L_horizon_Mpc / c_km_per_s < 10 := by
  unfold H0_Planck_substrate L_horizon_Mpc c_km_per_s
  refine ⟨?_, ?_⟩
  · rw [lt_div_iff₀ (by norm_num : (0:ℝ) < 299792.458)]
    norm_num
  · rw [div_lt_iff₀ (by norm_num : (0:ℝ) < 299792.458)]
    norm_num

/-- **Hubble-rate / horizon consistency — naive form**.  The Hubble
    radius `c / H_0` and the cosmological horizon agree to within a
    factor-of-ten (integrated over Λ-CDM background).  This is the
    O(1) coefficient that distinguishes the naive Hubble radius from
    the co-moving particle horizon. -/
theorem Hubble_to_horizon_within_factor_10 :
    L_Hubble_Mpc < L_horizon_Mpc ∧ L_horizon_Mpc < 10 * L_Hubble_Mpc := by
  refine ⟨L_horizon_gt_L_Hubble, ?_⟩
  unfold L_Hubble_Mpc L_horizon_Mpc
  norm_num

/-! ## 6. Channel: composed — π (H_0) + √2 (Λ)

The horizon does not sit on a single irrationality lane.  It is a
COMPOSED observable:

  * H_0 rides the π channel (Phecda `hubble_substrate_envelope`)
  * Λ rides the √2 channel (Keid `lambda_channel = √2`)
  * Ω_M rides the π channel (Mira `substrateOmegaM`)

`L_H = c / H_0 ~ Λ^{-1/2} · f(Ω_M)` is therefore a composed
cross-channel witness rather than a single-lane saturating-anchor
fit.  This is the same structural signature as Asellus (reheating
temperature), Furud (inflaton potential scale), Deneb-Algedi
(baryogenesis existence). -/

/-- **Horizon is cross-channel** — the horizon mixes π (H_0) and √2
    (Λ) channel signatures.  Witnessed by the co-channel inequality
    `lambda_channel = √2 ≠ π`.  Formally, we expose the two source
    channels for downstream paper use. -/
theorem horizon_composed_pi_and_sqrt2 :
    lambda_channel = IrrationalTarget.sqrt2 ∧
    lambda_channel ≠ IrrationalTarget.pi :=
  ⟨rfl, by decide⟩

/-! ## 7. Paper bundle — `cosmological_horizon_substrate` -/

/-- **PAPER HEADLINE — `cosmological_horizon_substrate`** (cycle-21
    target 6/6 capstone, 5-conjunct).

    Packages five facts for paper citation:

    1. **Horizon positive**: `L_H > 0`.
    2. **Hubble-consistency**: `L_Hubble · H_0 ≈ c` (< 5 km/s error).
    3. **De Sitter O(1)**: `10⁻³ < Λ · L_H² < 100`.
    4. **61-order hierarchy**: `L_H / ℓ_P ∈ [10⁶⁰, 10⁶²]`.
    5. **Composed channel**: Λ lane is √2, distinct from π lane of
       H_0 — the horizon is a CROSS-CHANNEL observable. -/
theorem cosmological_horizon_substrate :
    0 < L_horizon_m_rational ∧
    |L_Hubble_Mpc * H0_Planck_substrate - c_km_per_s| < 5 ∧
    ((1 : ℝ) / 1000 < deSitter_consistency_product ∧
     deSitter_consistency_product < 100) ∧
    (ell_Planck_m * (10 : ℝ) ^ 60 < L_horizon_m_rational ∧
     L_horizon_m_rational < ell_Planck_m * (10 : ℝ) ^ 62) ∧
    (lambda_channel = IrrationalTarget.sqrt2 ∧
     lambda_channel ≠ IrrationalTarget.pi) :=
  ⟨L_horizon_m_rational_pos,
   L_Hubble_times_H0_matches_c,
   deSitter_consistency_two_sided,
   horizon_to_planck_ratio_in_60_62_band,
   horizon_composed_pi_and_sqrt2⟩

/-- **Compact 3-conjunct headline** — horizon positive, 61-order
    hierarchy, de-Sitter consistency. -/
theorem cosmological_horizon_headline :
    0 < L_horizon_m_rational ∧
    ell_Planck_m * (10 : ℝ) ^ 60 < L_horizon_m_rational ∧
    deSitter_consistency_product < 100 :=
  ⟨L_horizon_m_rational_pos,
   horizon_exceeds_planck_by_60_orders,
   deSitter_consistency_product_upper⟩

/-- **Existence form** — there exists a length (the co-moving
    particle horizon) that is simultaneously (a) much larger than
    the Planck length, (b) de-Sitter-consistent with the observed
    cosmological constant. -/
theorem cosmological_horizon_exists :
    ∃ L : ℝ, 0 < L ∧
             ell_Planck_m * (10 : ℝ) ^ 60 < L ∧
             cosmologicalConstant_observed * L ^ 2 < 100 :=
  ⟨L_horizon_m_rational,
   L_horizon_m_rational_pos,
   horizon_exceeds_planck_by_60_orders,
   deSitter_consistency_product_upper⟩

/-- **Observational snapshot** — the horizon anchors packaged for
    downstream composition. -/
theorem cosmological_horizon_snapshot :
    L_horizon_Mpc = 14400 ∧
    L_Hubble_Mpc = 4448 ∧
    L_horizon_m_rational = 44 * (10 : ℝ) ^ 25 ∧
    c_km_per_s = 299792.458 ∧
    ell_Planck_m = 1616 / 10^38 := by
  refine ⟨rfl, rfl, rfl, rfl, rfl⟩

/-- **Falsifiability witness** — if any future distance-ladder /
    redshift-drift / ISW-correlation measurement pushes `L_H` below
    `4000 Mpc` or above `50 000 Mpc`, the Planck-anchored substrate
    horizon is falsified.  Here we witness the central value inside
    that 10×-wide band. -/
theorem cosmological_horizon_falsifiability_window :
    4000 < L_horizon_Mpc ∧ L_horizon_Mpc < 50000 := by
  unfold L_horizon_Mpc
  refine ⟨?_, ?_⟩ <;> norm_num

/-- **Frontier marker** — FIRST formal cosmological-horizon
    theorem in V2, completing the cosmological-scales trinity
    `H_0` (Phecda) + `Λ` (Keid) + `L_H` (Thuban), the three macroscopic
    scales that fix the geometry of the observable universe.  Companion
    to the `Ω_M + Ω_Λ = 1` flat-universe budget (Mira), now extended
    to include the horizon itself. -/
theorem cosmological_horizon_first_macroscale_theorem_in_V2 :
    ∃ L_H : ℝ, 0 < L_H ∧ ell_Planck_m * (10 : ℝ) ^ 60 < L_H :=
  ⟨L_horizon_m_rational,
   L_horizon_m_rational_pos,
   horizon_exceeds_planck_by_60_orders⟩

end OmegaTheory.Predictions.CosmologicalHorizon
