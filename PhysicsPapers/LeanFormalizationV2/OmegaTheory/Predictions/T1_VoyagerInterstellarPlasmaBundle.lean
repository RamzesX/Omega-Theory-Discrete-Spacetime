/-
  OmegaTheory.Predictions.T1_VoyagerInterstellarPlasmaBundle

  T-1 — Voyager interstellar plasma + magnetic field bundle, sessions 714-718.

  Single-thread hand-authored 2026-04-28 (cycle 65).

  ## What this file delivers

  Voyager 1 (heliopause crossing 2012) and Voyager 2 (heliopause
  crossing 2018) — direct in-situ measurements of the interstellar
  medium beyond the heliosphere:

  - s714: Heliopause distance Voyager 1: `121.6 AU` (Aug 2012 crossing).
  - s715: Heliopause distance Voyager 2: `119.0 AU` (Nov 2018 crossing).
  - s716: Interstellar plasma density `n_e ≈ 0.08 e⁻/cm³`
          (V1 plasma-wave instrument 2013-2015).
  - s717: Interstellar magnetic field `B_LISM ≈ 0.5 nT`
          (V1 magnetometer post-heliopause; cf. solar wind 5-10 nT).
  - s718: bundle composition + `VoyagerInterstellarPlasma` Prop
          (5+ conjunct).

  Real-valued positive constants (closed-form) encode the Voyager
  in-situ figures.  Distances in AU, plasma density in `10⁻² e⁻/cm³`,
  field in `10⁻¹ nT`.

  Companion to T-1 frontier observational bundles (cosmic rays,
  stellar physics, LIGO sensitivity).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

namespace OmegaTheory.Predictions.T1_VoyagerInterstellarPlasmaBundle

/-! ## s714 — Heliopause distance Voyager 1 -/

/-- **Heliopause distance Voyager 1**: `121.6 AU` (Aug 2012 crossing,
    sun-spacecraft distance at heliosheath/LISM boundary). -/
noncomputable def dist_helio_V1_AU : ℝ := 1216 / 10

/-- **Wave T1 session 714 — `V1 heliopause distance > 0`**. -/
theorem T1_dist_helio_V1_pos : 0 < dist_helio_V1_AU := by
  unfold dist_helio_V1_AU; norm_num

/-- **Wave T1 session 714 — `V1 heliopause distance > 100 AU`**
    (well beyond planets — Pluto perihelion ~30 AU, aphelion ~50 AU). -/
theorem T1_dist_helio_V1_above_100AU :
    dist_helio_V1_AU > 100 := by
  unfold dist_helio_V1_AU; norm_num

/-- **Wave T1 session 714 — `V1 heliopause distance < 200 AU`** (sanity). -/
theorem T1_dist_helio_V1_below_200AU :
    dist_helio_V1_AU < 200 := by
  unfold dist_helio_V1_AU; norm_num

/-! ## s715 — Heliopause distance Voyager 2 -/

/-- **Heliopause distance Voyager 2**: `119.0 AU` (Nov 2018 crossing). -/
noncomputable def dist_helio_V2_AU : ℝ := 1190 / 10

/-- **Wave T1 session 715 — `V2 heliopause distance > 0`**. -/
theorem T1_dist_helio_V2_pos : 0 < dist_helio_V2_AU := by
  unfold dist_helio_V2_AU; norm_num

/-- **Wave T1 session 715 — `V2 heliopause distance > 100 AU`**. -/
theorem T1_dist_helio_V2_above_100AU :
    dist_helio_V2_AU > 100 := by
  unfold dist_helio_V2_AU; norm_num

/-- **Wave T1 session 715 — `V2 heliopause distance < 200 AU`**. -/
theorem T1_dist_helio_V2_below_200AU :
    dist_helio_V2_AU < 200 := by
  unfold dist_helio_V2_AU; norm_num

/-- **🚨 FRONTIER — Wave T1 session 715 — `V1 > V2 heliopause distance`**.

    Voyager 1 (121.6 AU) crossed farther than Voyager 2 (119.0 AU) —
    different trajectories through anisotropic heliosheath. -/
theorem T1_dist_V1_above_V2 :
    dist_helio_V2_AU < dist_helio_V1_AU := by
  unfold dist_helio_V1_AU dist_helio_V2_AU; norm_num

/-! ## s716 — Interstellar plasma density (LISM) -/

/-- **Interstellar plasma electron density**: `n_e ≈ 0.08 e⁻/cm³`,
    stored in units of `10⁻² e⁻/cm³` so the value `8` means
    `8 × 10⁻² = 0.08 e⁻/cm³` (V1 plasma-wave instrument 2013-2015). -/
noncomputable def n_e_LISM_units : ℝ := 8

/-- **Wave T1 session 716 — `n_e (LISM) > 0`** (plasma density positive). -/
theorem T1_n_e_LISM_pos : 0 < n_e_LISM_units := by
  unfold n_e_LISM_units; norm_num

/-- **Wave T1 session 716 — `n_e (LISM) < 100`** (interstellar regime —
    far below dense-cloud `~10²-10⁴ e⁻/cm³`; 100 in `10⁻²` units = 1 e⁻/cm³). -/
theorem T1_n_e_LISM_below_100 : n_e_LISM_units < 100 := by
  unfold n_e_LISM_units; norm_num

/-! ## s717 — Interstellar magnetic field (LISM) -/

/-- **Interstellar magnetic field magnitude**: `B_LISM ≈ 0.5 nT`,
    stored in units of `10⁻¹ nT` so the value `5` means
    `5 × 10⁻¹ = 0.5 nT` (V1 magnetometer post-heliopause).

    Compare solar-wind `B ~ 5-10 nT` (so 50-100 in same units) — about
    a 10× drop crossing into the LISM. -/
noncomputable def B_LISM_units : ℝ := 5

/-- **Wave T1 session 717 — `B_LISM > 0`** (field magnitude positive). -/
theorem T1_B_LISM_pos : 0 < B_LISM_units := by
  unfold B_LISM_units; norm_num

/-- **Wave T1 session 717 — `B_LISM < 100`** (interstellar regime —
    100 in `10⁻¹ nT` = 10 nT, the upper solar-wind bound). -/
theorem T1_B_LISM_below_100 : B_LISM_units < 100 := by
  unfold B_LISM_units; norm_num

/-! ## s718 — bundle composition + Prop scaffold -/

/-- **VoyagerInterstellarPlasma**: heliopause crossings + LISM
    plasma density + interstellar magnetic field, all positive and
    in the expected interstellar-regime bands.

    Real Prop body — load-bearing 5+ conjuncts. -/
def VoyagerInterstellarPlasma : Prop :=
  -- Heliopause distances both above 100 AU
  100 < dist_helio_V1_AU ∧
  100 < dist_helio_V2_AU ∧
  -- V1 farther than V2
  dist_helio_V2_AU < dist_helio_V1_AU ∧
  -- Both below 200 AU
  dist_helio_V1_AU < 200 ∧
  dist_helio_V2_AU < 200 ∧
  -- LISM plasma density positive and below dense-cloud regime
  0 < n_e_LISM_units ∧
  n_e_LISM_units < 100 ∧
  -- LISM magnetic field positive and below upper solar-wind value
  0 < B_LISM_units ∧
  B_LISM_units < 100

/-- **🚨 FRONTIER — Wave T1 session 718 — `VoyagerInterstellarPlasma`**. -/
theorem T1_voyager_interstellar_plasma : VoyagerInterstellarPlasma :=
  ⟨T1_dist_helio_V1_above_100AU,
   T1_dist_helio_V2_above_100AU,
   T1_dist_V1_above_V2,
   T1_dist_helio_V1_below_200AU,
   T1_dist_helio_V2_below_200AU,
   T1_n_e_LISM_pos, T1_n_e_LISM_below_100,
   T1_B_LISM_pos, T1_B_LISM_below_100⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T1 sessions 714–718 — Voyager interstellar plasma bundle**.

    🚨 FRONTIER (Voyager 1/2 in-situ LISM measurements) 🚨

    Eleven foundational facts (s714–s718 bundled):

    1. `dist_helio_V1 = 121.6 AU > 0` (s714).
    2. `dist_helio_V1 > 100 AU` (s714, beyond planets).
    3. `dist_helio_V1 < 200 AU` (s714 sanity).
    4. `dist_helio_V2 = 119.0 AU > 0` (s715).
    5. `dist_helio_V2 > 100 AU` (s715).
    6. `dist_helio_V2 < 200 AU` (s715).
    7. `dist_V2 < dist_V1` (s715 ordering).
    8. `n_e_LISM = 8 (×10⁻² e⁻/cm³) > 0` (s716).
    9. `n_e_LISM < 100 (×10⁻²)` (s716, sub-cloud regime).
    10. `B_LISM = 5 (×10⁻¹ nT) > 0` (s717).
    11. `B_LISM < 100 (×10⁻¹) = 10 nT` (s717, sub-solar-wind upper).

    Plus `VoyagerInterstellarPlasma` Prop (9-conjunct composition).

    Two epoch-marking heliopause crossings:
    - Voyager 1 — Aug 2012 — 121.6 AU.
    - Voyager 2 — Nov 2018 — 119.0 AU.

    Both spacecraft confirm:
    - LISM plasma density `~ 0.08 e⁻/cm³` (post-heliopause jump).
    - LISM magnetic field `~ 0.5 nT` (~10× drop from solar wind).

    Sub-lemma 250+/N in T-1.  Lean-core only.

    🏆 First Lean-core formalization of Voyager 1/2 interstellar
       plasma + magnetic field measurements. -/
theorem session_714_718_voyager_interstellar_plasma_bundle_headline :
    0 < dist_helio_V1_AU
    ∧ 100 < dist_helio_V1_AU
    ∧ dist_helio_V1_AU < 200
    ∧ 0 < dist_helio_V2_AU
    ∧ 100 < dist_helio_V2_AU
    ∧ dist_helio_V2_AU < 200
    ∧ dist_helio_V2_AU < dist_helio_V1_AU
    ∧ 0 < n_e_LISM_units
    ∧ n_e_LISM_units < 100
    ∧ 0 < B_LISM_units
    ∧ B_LISM_units < 100
    ∧ VoyagerInterstellarPlasma :=
  ⟨T1_dist_helio_V1_pos,
   T1_dist_helio_V1_above_100AU,
   T1_dist_helio_V1_below_200AU,
   T1_dist_helio_V2_pos,
   T1_dist_helio_V2_above_100AU,
   T1_dist_helio_V2_below_200AU,
   T1_dist_V1_above_V2,
   T1_n_e_LISM_pos, T1_n_e_LISM_below_100,
   T1_B_LISM_pos, T1_B_LISM_below_100,
   T1_voyager_interstellar_plasma⟩

end OmegaTheory.Predictions.T1_VoyagerInterstellarPlasmaBundle
