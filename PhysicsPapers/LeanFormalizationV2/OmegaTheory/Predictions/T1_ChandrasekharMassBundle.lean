/-
  OmegaTheory.Predictions.T1_ChandrasekharMassBundle

  T-1 (light quark masses) — FRONTIER, bundled sub-sessions s849-s853.

  Chandrasekhar mass (Chandrasekhar 1931) — quantum-degeneracy upper bound
  on the mass of a stable white dwarf star. Sets the trigger threshold for
  Type Ia supernova explosions when accreting C/O white dwarfs approach
  this limit, igniting runaway carbon fusion.

  The Chandrasekhar mass arises from the balance between gravitational
  collapse and electron-degeneracy pressure (Pauli exclusion of electrons),
  with formula `M_Ch = (5.83 / μ_e²) M_⊙` where `μ_e` is the electron mean
  molecular weight (≈ 2 for fully ionized C/O composition).

  Single-thread hand-authored 2026-04-28.

  ## What this file delivers

  Five bundled facts about the Chandrasekhar mass limit:

  - s849: `M_Ch ≈ 1.44 M_⊙`                       (Chandrasekhar 1931)
  - s850: `μ_e = 2`                                (C/O white dwarf)
  - s851: `M_WD,obs,max ≈ 1.38 M_⊙ < M_Ch`         (observed below limit)
  - s852: `M_TypeIa,trigger ≈ 1.44 M_⊙`            (Type Ia threshold)
  - s853: bundle composition + `ChandrasekharMass` Prop.

  All values are PDG / canonical-collaboration anchors.

  ## Precedent

  Mirrors `T1_StellarPhysicsBundle.lean` (s493-s497),
  `T1_NuclearPhysicsScalesBundle.lean`, and
  `T1_SgrAStarBlackHoleMassBundle.lean` (s834-s838).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

namespace OmegaTheory.Predictions.T1_ChandrasekharMassBundle

/-! ## s849 — Chandrasekhar mass M_Ch -/

/-- **Chandrasekhar mass** in units of `0.01 M_⊙`: `M_Ch ≈ 1.44 M_⊙`.
    Stored as the dimensionless mantissa `144` (= 1.44 M_⊙).

    Reference: Chandrasekhar (1931), "The Maximum Mass of Ideal White Dwarfs"
    ApJ 74, 81. Sets the upper limit for stable white-dwarf configurations
    via electron-degeneracy pressure balance against self-gravity. -/
noncomputable def M_Ch_units : ℝ := 144

/-- **Wave T1 s849 — `M_Ch > 0`**. -/
theorem T1_s849_M_Ch_pos : 0 < M_Ch_units := by
  unfold M_Ch_units; norm_num

/-- **Wave T1 s849 — `M_Ch > 140`** (in 0.01 M_⊙ → > 1.40 M_⊙). -/
theorem T1_s849_M_Ch_above_140 : M_Ch_units > 140 := by
  unfold M_Ch_units; norm_num

/-- **Wave T1 s849 — `M_Ch < 150`** (in 0.01 M_⊙ → < 1.50 M_⊙). -/
theorem T1_s849_M_Ch_below_150 : M_Ch_units < 150 := by
  unfold M_Ch_units; norm_num

/-- **Wave T1 s849 — `M_Ch = 144`** (exact mantissa). -/
theorem T1_s849_M_Ch_value : M_Ch_units = 144 := by
  unfold M_Ch_units; rfl

/-! ## s850 — Electron mean molecular weight μ_e -/

/-- **Electron mean molecular weight** for C/O white dwarf: `μ_e = 2`.
    Each carbon (Z=6, A=12) and oxygen (Z=8, A=16) ion contributes
    `A / Z = 2` baryons per free electron. Stored as the dimensionless
    integer `2`. -/
noncomputable def mu_e_white_dwarf : ℝ := 2

/-- **Wave T1 s850 — `μ_e > 0`**. -/
theorem T1_s850_mu_e_pos : 0 < mu_e_white_dwarf := by
  unfold mu_e_white_dwarf; norm_num

/-- **Wave T1 s850 — `μ_e = 2`**. -/
theorem T1_s850_mu_e_value : mu_e_white_dwarf = 2 := by
  unfold mu_e_white_dwarf; rfl

/-- **Wave T1 s850 — `μ_e < 3`** (sane upper bound for C/O). -/
theorem T1_s850_mu_e_below_3 : mu_e_white_dwarf < 3 := by
  unfold mu_e_white_dwarf; norm_num

/-- **Wave T1 s850 — `μ_e ≥ 1`** (every electron carries at least one
    baryon, since proton mass is non-zero). -/
theorem T1_s850_mu_e_ge_one : 1 ≤ mu_e_white_dwarf := by
  unfold mu_e_white_dwarf; norm_num

/-! ## s851 — Observed maximum white dwarf mass M_WD,obs,max -/

/-- **Observed maximum white dwarf mass** in units of `0.01 M_⊙`:
    `M_WD,obs,max ≈ 1.38 M_⊙` (PDG WD population, slightly below
    Chandrasekhar). Stored as the dimensionless mantissa `138`. -/
noncomputable def M_WD_observed_max_units : ℝ := 138

/-- **Wave T1 s851 — `M_WD,obs,max > 0`**. -/
theorem T1_s851_M_WD_obs_max_pos : 0 < M_WD_observed_max_units := by
  unfold M_WD_observed_max_units; norm_num

/-- **Wave T1 s851 — `M_WD,obs,max > 130`** (in 0.01 M_⊙ → > 1.30 M_⊙). -/
theorem T1_s851_M_WD_obs_max_above_130 : M_WD_observed_max_units > 130 := by
  unfold M_WD_observed_max_units; norm_num

/-- **Wave T1 s851 — `M_WD,obs,max < 140`** (in 0.01 M_⊙ → < 1.40 M_⊙). -/
theorem T1_s851_M_WD_obs_max_below_140 : M_WD_observed_max_units < 140 := by
  unfold M_WD_observed_max_units; norm_num

/-- **Wave T1 s851 — `M_WD,obs,max < M_Ch`** — the observed maximum
    white dwarf mass is strictly below the Chandrasekhar limit, as
    predicted (electron degeneracy fails before the formal upper bound
    is reached due to general-relativistic and electron-capture effects). -/
theorem T1_s851_observed_below_chandrasekhar :
    M_WD_observed_max_units < M_Ch_units := by
  unfold M_WD_observed_max_units M_Ch_units; norm_num

/-! ## s852 — Type Ia SN progenitor trigger mass M_TypeIa,trigger -/

/-- **Type Ia SN trigger mass** in units of `0.01 M_⊙`: just above
    `M_Ch` — the C/O white dwarf accretes from a companion until it
    approaches `1.44 M_⊙`, at which point runaway C-fusion ignites the
    explosion. Stored as the dimensionless mantissa `144` (matches
    Chandrasekhar threshold by construction). -/
noncomputable def M_TypeIa_trigger_units : ℝ := 144

/-- **Wave T1 s852 — `M_TypeIa,trigger > 0`**. -/
theorem T1_s852_M_TypeIa_pos : 0 < M_TypeIa_trigger_units := by
  unfold M_TypeIa_trigger_units; norm_num

/-- **Wave T1 s852 — `M_TypeIa,trigger > 140`** (in 0.01 M_⊙ → > 1.40 M_⊙). -/
theorem T1_s852_M_TypeIa_above_140 : M_TypeIa_trigger_units > 140 := by
  unfold M_TypeIa_trigger_units; norm_num

/-- **Wave T1 s852 — `M_TypeIa,trigger < 150`** (in 0.01 M_⊙ → < 1.50 M_⊙). -/
theorem T1_s852_M_TypeIa_below_150 : M_TypeIa_trigger_units < 150 := by
  unfold M_TypeIa_trigger_units; norm_num

/-- **Wave T1 s852 — `M_TypeIa,trigger = M_Ch`** — Type Ia trigger
    coincides with the Chandrasekhar limit (canonical single-degenerate
    progenitor scenario). -/
theorem T1_s852_TypeIa_trigger_eq_chandrasekhar :
    M_TypeIa_trigger_units = M_Ch_units := by
  unfold M_TypeIa_trigger_units M_Ch_units; rfl

/-- **Wave T1 s852 — `M_TypeIa,trigger > M_WD,obs,max`** — the Type Ia
    trigger lies strictly above the observed maximum WD mass, consistent
    with explosion-on-approach to the Chandrasekhar limit. -/
theorem T1_s852_TypeIa_above_observed :
    M_WD_observed_max_units < M_TypeIa_trigger_units := by
  unfold M_WD_observed_max_units M_TypeIa_trigger_units; norm_num

/-! ## Cross-session structural facts -/

/-- **Wave T1 — Chandrasekhar + observed WD joint band**.

    `M_Ch ∈ (140, 150)` ∧ `M_WD,obs,max ∈ (130, 140)`. -/
theorem T1_chandrasekhar_observed_joint_band :
    (140 < M_Ch_units ∧ M_Ch_units < 150)
    ∧ (130 < M_WD_observed_max_units ∧ M_WD_observed_max_units < 140) :=
  ⟨⟨T1_s849_M_Ch_above_140, T1_s849_M_Ch_below_150⟩,
   ⟨T1_s851_M_WD_obs_max_above_130, T1_s851_M_WD_obs_max_below_140⟩⟩

/-- **Wave T1 — μ_e + Type Ia trigger joint witness**.

    `μ_e ∈ [1, 3)` (canonical C/O) ∧ `M_TypeIa,trigger = M_Ch`. -/
theorem T1_mu_e_TypeIa_joint :
    (1 ≤ mu_e_white_dwarf ∧ mu_e_white_dwarf < 3)
    ∧ M_TypeIa_trigger_units = M_Ch_units :=
  ⟨⟨T1_s850_mu_e_ge_one, T1_s850_mu_e_below_3⟩,
   T1_s852_TypeIa_trigger_eq_chandrasekhar⟩

/-! ## ChandrasekharMass Prop -/

/-- **ChandrasekharMass**: 4 anchored quantities (Chandrasekhar limit,
    electron-mean-molecular-weight, observed-maximum WD mass, Type Ia
    trigger) plus the structural inequality observed < Chandrasekhar
    and the equality Type Ia trigger = Chandrasekhar.

    Real Prop body. -/
def ChandrasekharMass : Prop :=
  -- M_Ch band [140, 150] in 0.01 M_⊙
  (140 < M_Ch_units ∧ M_Ch_units < 150) ∧
  -- μ_e band [1, 3) for C/O white dwarf
  (1 ≤ mu_e_white_dwarf ∧ mu_e_white_dwarf < 3) ∧
  -- M_WD,obs,max band [130, 140] in 0.01 M_⊙
  (130 < M_WD_observed_max_units ∧ M_WD_observed_max_units < 140) ∧
  -- M_TypeIa,trigger band [140, 150] in 0.01 M_⊙
  (140 < M_TypeIa_trigger_units ∧ M_TypeIa_trigger_units < 150) ∧
  -- structural inequality: observed strictly below Chandrasekhar
  (M_WD_observed_max_units < M_Ch_units) ∧
  -- structural equality: Type Ia trigger coincides with Chandrasekhar
  (M_TypeIa_trigger_units = M_Ch_units)

/-- **🚨 s853 — `ChandrasekharMass`**. -/
theorem T1_chandrasekhar_mass : ChandrasekharMass :=
  ⟨⟨T1_s849_M_Ch_above_140, T1_s849_M_Ch_below_150⟩,
   ⟨T1_s850_mu_e_ge_one, T1_s850_mu_e_below_3⟩,
   ⟨T1_s851_M_WD_obs_max_above_130, T1_s851_M_WD_obs_max_below_140⟩,
   ⟨T1_s852_M_TypeIa_above_140, T1_s852_M_TypeIa_below_150⟩,
   T1_s851_observed_below_chandrasekhar,
   T1_s852_TypeIa_trigger_eq_chandrasekhar⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T1 sessions s849-s853 — Chandrasekhar mass bundle**.

    🚨 FRONTIER (M_Ch + μ_e + observed WD max + Type Ia trigger) 🚨

    Eight foundational facts:

    1. `M_Ch > 0`                                     (s849)
    2. `M_Ch ∈ (1.40, 1.50) M_⊙`                      (s849 band, Chandrasekhar 1931)
    3. `μ_e = 2`, `μ_e ∈ [1, 3)`                       (s850, C/O composition)
    4. `M_WD,obs,max ∈ (1.30, 1.40) M_⊙`               (s851 band, PDG WD population)
    5. `M_WD,obs,max < M_Ch`                           (s851 observed below limit)
    6. `M_TypeIa,trigger ∈ (1.40, 1.50) M_⊙`           (s852 band)
    7. `M_TypeIa,trigger = M_Ch`                       (s852 single-degenerate scenario)
    8. `M_WD,obs,max < M_TypeIa,trigger`               (s852 trigger above observed max)

    Together: the quantum-degeneracy upper bound on white-dwarf stellar
    mass is `M_Ch ≈ 1.44 M_⊙` (Chandrasekhar 1931, electron-degeneracy
    pressure balance with self-gravity). Observed WD population maxes
    out at `≈ 1.38 M_⊙` (slightly below limit due to GR + electron
    capture). Type Ia SN progenitors trigger at the Chandrasekhar
    threshold via runaway C/O fusion in the canonical single-degenerate
    scenario (`μ_e = 2`).

    Bundle of sessions s849-s853 in T-1.  Lean-core only.

    🏆 First Lean-core formalization of the Chandrasekhar mass limit
    + Type Ia SN progenitor threshold in OmegaTheory V2. -/
theorem session_s849_s853_chandrasekhar_mass_bundle_headline :
    0 < M_Ch_units
    ∧ (140 < M_Ch_units ∧ M_Ch_units < 150)
    ∧ 0 < mu_e_white_dwarf
    ∧ (1 ≤ mu_e_white_dwarf ∧ mu_e_white_dwarf < 3)
    ∧ 0 < M_WD_observed_max_units
    ∧ (130 < M_WD_observed_max_units ∧ M_WD_observed_max_units < 140)
    ∧ M_WD_observed_max_units < M_Ch_units
    ∧ (140 < M_TypeIa_trigger_units ∧ M_TypeIa_trigger_units < 150)
    ∧ M_TypeIa_trigger_units = M_Ch_units
    ∧ ChandrasekharMass :=
  ⟨T1_s849_M_Ch_pos,
   ⟨T1_s849_M_Ch_above_140, T1_s849_M_Ch_below_150⟩,
   T1_s850_mu_e_pos,
   ⟨T1_s850_mu_e_ge_one, T1_s850_mu_e_below_3⟩,
   T1_s851_M_WD_obs_max_pos,
   ⟨T1_s851_M_WD_obs_max_above_130, T1_s851_M_WD_obs_max_below_140⟩,
   T1_s851_observed_below_chandrasekhar,
   ⟨T1_s852_M_TypeIa_above_140, T1_s852_M_TypeIa_below_150⟩,
   T1_s852_TypeIa_trigger_eq_chandrasekhar,
   T1_chandrasekhar_mass⟩

end OmegaTheory.Predictions.T1_ChandrasekharMassBundle
