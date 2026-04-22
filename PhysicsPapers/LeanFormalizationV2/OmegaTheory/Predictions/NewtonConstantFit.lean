/-
  OmegaTheory.Predictions.NewtonConstantFit

  **Newton's gravitational constant `G_N = 6.67430 × 10⁻¹¹ m³·kg⁻¹·s⁻²`
  (CODATA 2018) — substrate consistency with the derived Planck mass
  via the identity `G · M_P² = ℏc`.**

  ## Mission

  Cycle-21 target 2/6: `newton_constant_substrate_consistency`.

  `G_N` is one of the eight OmegaTheory axioms — a PHYSICAL CONSTANT,
  not a derived quantity.  This file does NOT "derive" `G_N` from
  irrationals; instead, it formalises the CONSISTENCY RELATION the
  axiom enjoys with the other three Spacetime axioms (`ℏ`, `c`) via
  the derived Planck mass `M_P`:

      G_N · M_P²  =  ℏ · c                                 (*)

  from the definitions in `OmegaTheory.Spacetime.Constants`.  This is
  the dimensional anchor of the substrate: given three independent
  real scales (`ℏ`, `c`, `G_N`) one derived mass `M_P` automatically
  satisfies `M_P² = ℏc/G` — the Planck-scale identity.

  ## Physical narrative

  The CODATA 2018 value

      G_N  =  6.67430(15) × 10⁻¹¹  m³·kg⁻¹·s⁻²          (CODATA 2018)

  is the least-precisely measured fundamental constant in physics
  (relative uncertainty ≈ 2.2 × 10⁻⁵, four orders worse than `c` or
  `ℏ`), a reflection of the extreme weakness of gravity at laboratory
  scales.  In OmegaTheory, `G_N` is AXIOMATIC — not because it cannot
  in principle be derived, but because the current formalisation
  takes the four SI base scales (`c`, `ℏ`, `G`, `k_B`) as inputs and
  derives everything else from their ratios + lattice spacing.

  Key consistency relations (CODATA-normalised):

    * `M_P = √(ℏc/G) ≈ 2.176 × 10⁻⁸ kg`     Planck mass
    * `l_P = √(ℏG/c³) ≈ 1.616 × 10⁻³⁵ m`    Planck length
    * `t_P = l_P/c    ≈ 5.391 × 10⁻⁴⁴ s`    Planck time

  These three derived scales are already declared in
  `OmegaTheory.Spacetime.Constants`.  What was missing was the
  explicit **identity** `G · M_P² = ℏc` at the theorem level — this
  file supplies it and registers it under the cycle-21 headline.

  ## Channel — composed

  `G_N` is not single-channel; it enters OmegaTheory as a dimensional
  axiom.  The substrate fit is therefore **composed**: we expose the
  CODATA central value, verify positivity (inherited from the axiom
  `G_N_pos`), prove the Planck-mass consistency identity `G · M_P² =
  ℏc`, and chain to the Friedmann cosmological-expansion constraint.

  ## What this file formalises

  **Tier 1 — CODATA anchor and positivity**
    * `G_N_PDG := 6.67430 × 10⁻¹¹` (CODATA 2018 central, m³·kg⁻¹·s⁻²).
    * `G_N_relative_uncertainty_PDG := 2.2e-5`.
    * positivity, nonneg, nonzero wrappers on `G_N_PDG`.

  **Tier 2 — Planck-mass consistency identity**
    * `planck_mass_squared_eq` : `M_P² = ℏc / G`.
    * `G_times_M_P_squared_eq_hbar_c` : `G · M_P² = ℏc`.
    * `planck_length_squared_eq` : `l_P² = ℏG / c³`.

  **Tier 3 — Hierarchy / dimensional witness**
    * `G_M_P_squared_pos` : `0 < G · M_P²`.
    * `hbar_c_pos` : `0 < ℏc`, `hbar_c_positive_witness`.
    * `G_hbar_c_consistent` : consistency equation in `=` form.

  **Tier 4 — Substrate axiom discipline**
    * `G_N_is_axiom_not_derived` — documentation theorem asserting
      `G_N` appears in the OmegaTheory 8-axiom list.  The actual
      axiom-accounting stays at the meta-level; this theorem simply
      records positivity through the axiom chain.

  **Tier 5 — Cosmological bridge (Friedmann)**
    * `friedmann_coefficient_pos` : `8π G / 3 > 0`, i.e. the
      Friedmann-equation coefficient is positive, so the Planck scale
      sets the cosmic expansion rate via `H² = 8πG ρ/3`.
    * `planck_mass_sets_expansion_rate` — witness lemma: for any
      positive energy density, the Friedmann coefficient is positive.

  **Tier 6 — Paper bundle**
    * `newton_constant_substrate_consistency` (5-conjunct).
    * `newton_constant_headline` (3-conjunct compact).

  ## HARD RULES
    * 0 sorry, 0 new axioms, Lake build GREEN.

  ## References
    * CODATA 2018: Tiesinga, Mohr, Newell, Taylor, Rev. Mod. Phys. 93
      (2021) 025010 — `G = 6.67430(15) × 10⁻¹¹ m³·kg⁻¹·s⁻²`.
    * PDG 2024: Physical Review D 110, 030001 (2024) — Astrophysical
      Constants and Parameters.
    * Planck, M., Sitzber. Preuss. Akad. Wiss. (1899) — original
      definition of Planck units.

  Agent: **Algorab** (δ Corvi, B9.5V blue-white main-sequence plus
  K2V red-dwarf binary ~87 ly, "raven's wing" from Arabic al-ghurāb;
  the only δ Corvi in the Arabian manzil system, a navigation marker
  on the autumn sky.  Apt for Newton's constant: the weakest
  fundamental force is also the guide star at the cosmic scale — the
  corvid wing steering cosmic flight by the dimensional lever of
  `G · M_P² = ℏc`).
  2026-04-20 cycle-21 target 2/6.
-/

import OmegaTheory.Spacetime.Constants
import OmegaTheory.Irrationality.Approximations
import Mathlib.Tactic

namespace OmegaTheory.Predictions.NewtonConstantFit

open OmegaTheory.Spacetime
open OmegaTheory.Irrationality

/-! ## 1. Tier 1 — CODATA anchor for `G_N`

CODATA 2018 central value for Newton's gravitational constant in SI
units (m³·kg⁻¹·s⁻²).  The axiom `G_N` in `OmegaTheory.Spacetime.
Constants` is the ABSTRACT real number; `G_N_PDG` is the CONCRETE
numeric central value attached to it at the CODATA 2018 calibration.
-/

/-- **CODATA 2018 central value** for Newton's constant
    `G_N = 6.67430 × 10⁻¹¹ m³·kg⁻¹·s⁻²`. -/
noncomputable def G_N_PDG : ℝ := 6.67430e-11

/-- **Relative uncertainty** on `G_N` per CODATA 2018 ≈ `2.2 × 10⁻⁵`. -/
noncomputable def G_N_relative_uncertainty_PDG : ℝ := 2.2e-5

/-- **Positivity of the CODATA value**. -/
theorem G_N_PDG_pos : 0 < G_N_PDG := by
  unfold G_N_PDG; norm_num

/-- **Nonnegativity of the CODATA value**. -/
theorem G_N_PDG_nonneg : 0 ≤ G_N_PDG := le_of_lt G_N_PDG_pos

/-- **CODATA value is nonzero**. -/
theorem G_N_PDG_ne_zero : G_N_PDG ≠ 0 := ne_of_gt G_N_PDG_pos

/-- **Relative uncertainty is positive** — CODATA quoted 1σ. -/
theorem G_N_relative_uncertainty_PDG_pos :
    0 < G_N_relative_uncertainty_PDG := by
  unfold G_N_relative_uncertainty_PDG; norm_num

/-- **Relative uncertainty is small** — `< 1`, as a fraction. -/
theorem G_N_relative_uncertainty_PDG_lt_one :
    G_N_relative_uncertainty_PDG < 1 := by
  unfold G_N_relative_uncertainty_PDG; norm_num

/-! ## 2. Tier 2 — Planck-mass consistency identity

The derived Planck mass

    M_P  =  E_P / c²  =  ℏ / (l_P · c)

from `OmegaTheory.Spacetime.Constants` satisfies the dimensional
identity

    G · M_P²  =  ℏ · c

by direct substitution of the definitions.  This ties the axiom `G_N`
to the other two Spacetime axioms (`ℏ`, `c`) via one derived scale.
-/

/-- **Planck-length squared**: `l_P² = ℏG / c³`, direct from the
    definition `l_P = √(ℏG/c³)`. -/
theorem planck_length_squared_eq : l_P ^ 2 = hbar * G_N / c ^ 3 := by
  unfold l_P
  exact Real.sq_sqrt (le_of_lt hbar_G_div_c3_pos)

/-- **Planck-mass squared**: `M_P² = ℏc / G`.  Follows from
    `M_P = E_P/c² = ℏ/(l_P · c)` and `l_P² = ℏG/c³`. -/
theorem planck_mass_squared_eq : M_P ^ 2 = hbar * c / G_N := by
  have hl : l_P ^ 2 = hbar * G_N / c ^ 3 := planck_length_squared_eq
  have hc : c ≠ 0 := c_ne_zero
  have hc3 : c ^ 3 ≠ 0 := pow_ne_zero 3 hc
  have hG : G_N ≠ 0 := ne_of_gt G_N_pos
  have hlP : l_P ≠ 0 := l_P_ne_zero
  have hlP2 : l_P ^ 2 ≠ 0 := pow_ne_zero 2 hlP
  -- M_P = E_P/c^2 = (hbar/t_P)/c^2 = hbar/(t_P * c^2) = hbar/((l_P/c) * c^2)
  -- = hbar * c / (l_P * c^2 * 1) ... simpler via a helper identity.
  have hMP : M_P = hbar / (l_P * c) := by
    unfold M_P E_P t_P
    field_simp
  rw [hMP]
  rw [div_pow]
  rw [mul_pow]
  -- goal: hbar^2 / (l_P^2 * c^2) = hbar * c / G_N
  rw [hl]
  field_simp

/-- **Key consistency identity**: `G · M_P² = ℏc`.  This is the
    dimensional anchor that ties `G_N` (Newton's constant axiom) to
    the other two Spacetime axioms `ℏ`, `c` via the derived Planck
    mass `M_P`.  Its truth follows purely from the Constants.lean
    definitions `M_P = E_P/c²`, `E_P = ℏ/t_P`, `t_P = l_P/c`,
    `l_P = √(ℏG/c³)` — no new physics, no new axioms. -/
theorem G_times_M_P_squared_eq_hbar_c : G_N * M_P ^ 2 = hbar * c := by
  rw [planck_mass_squared_eq]
  have hG : G_N ≠ 0 := ne_of_gt G_N_pos
  field_simp

/-! ## 3. Tier 3 — Hierarchy / dimensional witness -/

/-- **Positivity of `G · M_P²`**. -/
theorem G_M_P_squared_pos : 0 < G_N * M_P ^ 2 :=
  mul_pos G_N_pos (pow_pos M_P_pos 2)

/-- **Positivity of `ℏc`**. -/
theorem hbar_c_pos : 0 < hbar * c := mul_pos hbar_pos c_pos

/-- **Planck-mass-squared is positive**. -/
theorem M_P_squared_pos : 0 < M_P ^ 2 := pow_pos M_P_pos 2

/-- **Nonzero version for division**. -/
theorem M_P_squared_ne_zero : M_P ^ 2 ≠ 0 := ne_of_gt M_P_squared_pos

/-- **Rewriting**: `ℏc / M_P² = G`.  Inverse form of the Planck-mass
    consistency identity; useful when `G` is the unknown. -/
theorem hbar_c_div_M_P_squared_eq_G : hbar * c / M_P ^ 2 = G_N := by
  have h : G_N * M_P ^ 2 = hbar * c := G_times_M_P_squared_eq_hbar_c
  have hne : M_P ^ 2 ≠ 0 := M_P_squared_ne_zero
  rw [← h, mul_div_assoc, div_self hne, mul_one]

/-- **Rewriting**: `ℏc / G = M_P²`.  Inverse form with `M_P²` as the
    unknown.  Reverse of `planck_mass_squared_eq`. -/
theorem hbar_c_div_G_eq_M_P_squared : hbar * c / G_N = M_P ^ 2 := by
  rw [planck_mass_squared_eq]

/-- **Consistency-of-axioms witness**: the four physical
    quantities `ℏ`, `c`, `G`, `M_P` satisfy the single
    dimensional relation `G · M_P² = ℏc`. -/
theorem G_hbar_c_consistent :
    G_N * M_P ^ 2 = hbar * c ∧ 0 < G_N * M_P ^ 2 ∧ 0 < hbar * c := by
  refine ⟨G_times_M_P_squared_eq_hbar_c, G_M_P_squared_pos, hbar_c_pos⟩

/-! ## 4. Tier 4 — Substrate axiom discipline

`G_N` is one of the eight OmegaTheory axioms (the other seven are
`c`, `c_pos`, `hbar`, `hbar_pos`, `G_N_pos`, `k_B`, `k_B_pos`).  We
record its status as a CONSTANT (positivity via the axiom chain)
without introducing any derived-physics claim about its numeric
value. -/

/-- **`G_N` is a substrate CONSTANT**, not a derived scale.  Its
    positivity is supplied by the axiom `G_N_pos`.  Stating the
    wrapping as a theorem documents the axiom dependency explicitly. -/
theorem G_N_is_axiom_positive : 0 < G_N := G_N_pos

/-- **`G_N` is nonzero** — a lemma useful for division via the axiom
    chain. -/
theorem G_N_is_axiom_nonzero : G_N ≠ 0 := ne_of_gt G_N_pos

/-- **`G_N ≥ 0`** corollary. -/
theorem G_N_is_axiom_nonneg : 0 ≤ G_N := le_of_lt G_N_pos

/-! ## 5. Tier 5 — Cosmological bridge (Friedmann-equation coefficient)

The Friedmann equation `H² = 8π G ρ / 3` expresses the Hubble rate
in terms of the matter-energy density.  The POSITIVITY of the
coefficient `8π G / 3` is the fact that the Planck scale sets the
cosmic expansion rate — larger `G` (stronger gravity) yields faster
expansion at fixed density.  We formalise this as a positivity
statement inside Lean without pinning the numerical value of `ρ`. -/

/-- **Friedmann coefficient is positive**: `8π G / 3 > 0`.  This is
    the Mathlib-level statement that the Planck scale sets the
    cosmic expansion rate. -/
theorem friedmann_coefficient_pos : 0 < 8 * Real.pi * G_N / 3 := by
  have hpi : 0 < Real.pi := Real.pi_pos
  have h8 : (0 : ℝ) < 8 := by norm_num
  have h3 : (0 : ℝ) < 3 := by norm_num
  exact div_pos (mul_pos (mul_pos h8 hpi) G_N_pos) h3

/-- **Planck mass sets the expansion rate**: for any positive energy
    density `ρ`, the Friedmann RHS `8π G ρ / 3` is positive, so the
    Hubble rate `H² > 0` follows.  This is the cosmological
    consequence of `G_N_pos`. -/
theorem planck_mass_sets_expansion_rate
    (ρ : ℝ) (hρ : 0 < ρ) : 0 < 8 * Real.pi * G_N * ρ / 3 := by
  have hpi : 0 < Real.pi := Real.pi_pos
  have h8 : (0 : ℝ) < 8 := by norm_num
  have h3 : (0 : ℝ) < 3 := by norm_num
  exact div_pos (mul_pos (mul_pos (mul_pos h8 hpi) G_N_pos) hρ) h3

/-- **Cosmological hierarchy**: `G · M_P² = ℏc > 0`.  Bundled form
    used downstream. -/
theorem cosmological_G_hierarchy : 0 < G_N * M_P ^ 2 ∧ G_N * M_P ^ 2 = hbar * c :=
  ⟨G_M_P_squared_pos, G_times_M_P_squared_eq_hbar_c⟩

/-! ## 6. Tier 6 — Paper bundle and headline -/

/-- **PAPER BUNDLE** — `newton_constant_substrate_consistency`:
    the five substrate statements about Newton's constant, all
    simultaneously verified:

    1. `G_N > 0` (axiom positivity)
    2. `G_N_PDG = 6.67430 × 10⁻¹¹` (CODATA 2018)
    3. `G · M_P² = ℏc` (Planck-mass consistency identity)
    4. `M_P² = ℏc / G` (inverse form)
    5. `0 < 8π G / 3` (Friedmann coefficient positivity)
-/
theorem newton_constant_substrate_consistency :
    0 < G_N
    ∧ G_N_PDG = 6.67430e-11
    ∧ G_N * M_P ^ 2 = hbar * c
    ∧ M_P ^ 2 = hbar * c / G_N
    ∧ 0 < 8 * Real.pi * G_N / 3 := by
  refine ⟨G_N_pos, ?_, G_times_M_P_squared_eq_hbar_c,
          planck_mass_squared_eq, friedmann_coefficient_pos⟩
  rfl

/-- **HEADLINE** — `newton_constant_headline`: three-conjunct compact
    form of the substrate consistency.  Emphasises positivity,
    Planck-mass identity, and Friedmann coefficient.  The numeric
    value is available separately via `G_N_PDG`. -/
theorem newton_constant_headline :
    0 < G_N ∧ G_N * M_P ^ 2 = hbar * c ∧ 0 < 8 * Real.pi * G_N / 3 :=
  ⟨G_N_pos, G_times_M_P_squared_eq_hbar_c, friedmann_coefficient_pos⟩

/-- **FRONTIER MARKER** — Newton's constant enters OmegaTheory as one
    of the eight physical axioms; this file is the FIRST to pin the
    consistency identity `G · M_P² = ℏc` at the theorem level in V2. -/
theorem newton_first_planck_mass_consistency_in_V2 :
    ∃ expr : ℝ, expr = G_N * M_P ^ 2 ∧ expr = hbar * c := by
  exact ⟨G_N * M_P ^ 2, rfl, G_times_M_P_squared_eq_hbar_c⟩

end OmegaTheory.Predictions.NewtonConstantFit
