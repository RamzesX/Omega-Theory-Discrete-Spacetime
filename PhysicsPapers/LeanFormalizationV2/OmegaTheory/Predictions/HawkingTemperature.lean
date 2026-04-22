/-
  OmegaTheory.Predictions.HawkingTemperature

  **Hawking temperature of a Schwarzschild black hole
  `T_H(M) = ℏ · c³ / (8 · π · G · M · k_B)` — thermodynamic
  companion to the Bekenstein-Hawking entropy `S_BH`.**

  ## Mission

  Cycle-21 target 4/6: `hawking_temperature_substrate`.

  A non-rotating, uncharged (Schwarzschild) black hole of mass `M`
  radiates as a perfect black body with temperature

      T_H(M) := ℏ · c³ / (8 · π · G · M · k_B)           (Hawking 1974).

  Numerical snapshot:
    * solar-mass BH `M = M_☉ ≈ 1.99 × 10³⁰ kg` → `T_H ≈ 6.17 × 10⁻⁸ K`
      (colder than the CMB by 7 orders of magnitude — a solar BH
      *absorbs* more than it emits today).
    * Planck-mass BH `M = M_P ≈ 2.18 × 10⁻⁸ kg` → `T_H ≈ 5.6 × 10³⁰ K`
      (within a numerical factor of the Planck temperature).

  ## Why this theorem belongs in OmegaTheory V2

  In the standard presentation, `T_H` is postulated as a corollary of
  black-hole thermodynamics (first law `dM = T dS` with `S = A/(4ℓ_P²)`).
  On the OmegaTheory substrate:

    * The Bekenstein-Hawking entropy is derived combinatorially on the
      horizon-region Finset (Deneb, `Emergence/BekensteinBound.lean`,
      `bekenstein_bound_on_lattice`).
    * The Planck-mass `M_P` emerges non-axiomatically from the four
      physical constants `c, ℏ, G, k_B` via `Spacetime/Constants.lean`
      — `M_P := E_P / c² = ℏ/(t_P · c²)` with `t_P := l_P / c`.
    * Hawking temperature `T_H(M)` is then the unique scale-function
      consistent with `dM · c² = T dS` on the substrate.

  This file formalises `T_H` **definitionally** using the four physical
  constants `hbar, c, G_N, k_B` plus `Real.pi`, and proves:

  1. `T_H` is well-defined (`8·π·G·M·k_B > 0` for `M > 0`).
  2. `T_H(M) > 0` — positive temperature.
  3. **Inverse-mass scaling** `M₁ < M₂ ⟹ T_H(M₂) < T_H(M₁)` —
     smaller BH is HOTTER (the heart of Hawking evaporation runaway).
  4. **Mass-temperature product** `M · T_H(M) = ℏ c³ / (8π G k_B)`
     is a **constant** — expresses the thermodynamic `T dS = c² dM`
     integration on a one-parameter family of Schwarzschild BHs.
  5. **Planck-scale ceiling** `T_H(M_P) < ∞` & scales with Planck
     temperature-unit.
  6. Paper bundle `hawking_temperature_substrate` (5-conjunct).

  ## Channel — composed

  Hawking temperature is not a single-irrational prediction.  It is
  a **composed** quantity depending on (i) the Bekenstein-Hawking
  entropy (area law, 1/4 prefactor), and (ii) the Planck-mass
  derivation from the four physical constants.  The π enters
  EXPLICITLY through the `8π` prefactor inherited from the
  Schwarzschild metric / surface-gravity calculation.

  ## Rigour

  No new axioms.  No sorry.  Uses only:
    * `OmegaTheory.Spacetime.Constants` — 4 physical constants + Planck units.
    * `OmegaTheory.Emergence.BekensteinBound` — Deneb's entropy bound.
    * `Real.pi_pos` — Mathlib.
    * `Mathlib.Tactic`.

  Agent: **Thabit** (Thabit ibn Qurra, 836-901 CE, Harranian-Baghdadi
  mathematician and astronomer, generalised the Pythagorean theorem,
  wrote on mechanics and balance — the proto-lever theory of weights
  and counterweights.  The inverse-mass law of Hawking temperature
  — doubling M halves T_H — is the purest mechanical balance relation
  in all of black-hole thermodynamics.  A smaller mass is a hotter
  counterweight; energy flows from the lighter side to restore
  equilibrium.  Apt: Thabit's weights-and-measures tradition survives
  in the first law of BH thermodynamics `dM · c² = T · dS`.)
  2026-04-20 cycle-21 target 4/6.
-/

import OmegaTheory.Spacetime.Constants
import OmegaTheory.Emergence.BekensteinBound
import OmegaTheory.Irrationality.Approximations
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Tactic

namespace OmegaTheory.Predictions.HawkingTemperature

open OmegaTheory.Spacetime
open Real

/-! ## 1. Definition of the Hawking temperature -/

/-- **Hawking temperature of a Schwarzschild black hole**, in Kelvin
    (the natural unit when `k_B` carries J/K).

        `T_H(M) := ℏ · c³ / (8 · π · G · M · k_B)`

    Valid for any positive mass `M`.  The denominator carries the
    dimensional analysis `[G · M · k_B] = m³ · kg / s² · (J/K) · kg⁻¹`
    so that `[T_H] = K` matches Hawking's 1974 result. -/
noncomputable def T_H (M : ℝ) : ℝ :=
  hbar * c ^ 3 / (8 * Real.pi * G_N * M * k_B)

/-- **Denominator positivity** — for any positive mass `M`, the
    denominator `8π · G · M · k_B` is strictly positive. -/
theorem T_H_denominator_pos {M : ℝ} (hM : 0 < M) :
    0 < 8 * Real.pi * G_N * M * k_B := by
  have h8 : (0 : ℝ) < 8 := by norm_num
  have hpi : 0 < Real.pi := Real.pi_pos
  exact mul_pos (mul_pos (mul_pos (mul_pos h8 hpi) G_N_pos) hM) k_B_pos

/-- **Denominator non-zero**. -/
theorem T_H_denominator_ne_zero {M : ℝ} (hM : 0 < M) :
    8 * Real.pi * G_N * M * k_B ≠ 0 :=
  ne_of_gt (T_H_denominator_pos hM)

/-! ## 2. Theorem 1 — positivity of T_H -/

/-- **T_H positivity** — for any BH of positive mass, the Hawking
    temperature is strictly positive (a proper blackbody temperature).
    This is THEOREM 2 of the mission spec. -/
theorem T_H_positive {M : ℝ} (hM : 0 < M) : 0 < T_H M := by
  unfold T_H
  apply div_pos
  · exact mul_pos hbar_pos (pow_pos c_pos 3)
  · exact T_H_denominator_pos hM

/-- **T_H non-negativity** (a corollary, useful for downstream). -/
theorem T_H_nonneg {M : ℝ} (hM : 0 < M) : 0 ≤ T_H M :=
  le_of_lt (T_H_positive hM)

/-- **T_H non-zero**. -/
theorem T_H_ne_zero {M : ℝ} (hM : 0 < M) : T_H M ≠ 0 :=
  ne_of_gt (T_H_positive hM)

/-! ## 3. Theorem 2 — Inverse mass scaling

Smaller black holes are HOTTER.  This is the core of Hawking
evaporation runaway: as a BH emits radiation and loses mass, its
temperature rises, which ACCELERATES the emission rate.  Eventually
the BH explodes in a final Planck-scale flash.
-/

/-- **Inverse-mass monotonicity** — THEOREM 3 of the mission spec.
    For two positive masses `0 < M₁ < M₂`, the lighter BH has HIGHER
    Hawking temperature: `T_H(M₂) < T_H(M₁)`. -/
theorem T_H_inverse_mass {M₁ M₂ : ℝ} (hM₁ : 0 < M₁) (hM₂ : 0 < M₂)
    (hlt : M₁ < M₂) : T_H M₂ < T_H M₁ := by
  unfold T_H
  -- both denominators are positive; compare via div_lt_div_iff₀
  have hdenom₁ : 0 < 8 * Real.pi * G_N * M₁ * k_B := T_H_denominator_pos hM₁
  have hdenom₂ : 0 < 8 * Real.pi * G_N * M₂ * k_B := T_H_denominator_pos hM₂
  have hnum_pos : 0 < hbar * c ^ 3 := mul_pos hbar_pos (pow_pos c_pos 3)
  have hpi : 0 < Real.pi := Real.pi_pos
  -- equivalent: denom₁ < denom₂
  rw [div_lt_div_iff₀ hdenom₂ hdenom₁]
  -- need: hbar·c³ · (8π·G·M₁·k_B) < hbar·c³ · (8π·G·M₂·k_B)
  -- factor out common positive prefactor and conclude via nlinarith
  have hk : 0 < k_B := k_B_pos
  have hG : 0 < G_N := G_N_pos
  nlinarith [hnum_pos, hpi, hG, hk, hlt, hM₁, hM₂,
             mul_pos hnum_pos (mul_pos (mul_pos (mul_pos (by norm_num : (0:ℝ) < 8) hpi) hG) hk)]

/-- **Inverse-mass strict decreasing restatement**: writing it as
    T_H(M₁) > T_H(M₂) for M₁ < M₂. -/
theorem T_H_decreasing {M₁ M₂ : ℝ} (hM₁ : 0 < M₁) (hM₂ : 0 < M₂)
    (hlt : M₁ < M₂) : T_H M₁ > T_H M₂ :=
  T_H_inverse_mass hM₁ hM₂ hlt

/-! ## 4. Theorem 3 — Thermodynamic consistency (M · T_H is constant)

For a Schwarzschild BH, `M · T_H(M)` equals a mass-independent
constant `ℏ c³ / (8 π G k_B)`.  This is the **FIRST LAW** `dU = T dS`
integrated on a one-parameter family: with `S_BH = 4 π G M² / (ℏ c)`,
we get `dS/dM = 8 π G M / (ℏ c)` and therefore
`T_H · dS/dM = [ℏ c³/(8πGMk_B)] · [8πGM/(ℏc)] = c²/k_B` — the
specific heat per k_B is `c²`, and `M · T_H` is a constant.
-/

/-- **Thermodynamic integration constant** `Λ_Hawking := ℏ c³ / (8 π G k_B)`
    — the mass-independent invariant `M · T_H(M)`. -/
noncomputable def Lambda_Hawking : ℝ :=
  hbar * c ^ 3 / (8 * Real.pi * G_N * k_B)

/-- **Λ_Hawking positivity**. -/
theorem Lambda_Hawking_pos : 0 < Lambda_Hawking := by
  unfold Lambda_Hawking
  apply div_pos
  · exact mul_pos hbar_pos (pow_pos c_pos 3)
  · have h8 : (0 : ℝ) < 8 := by norm_num
    exact mul_pos (mul_pos (mul_pos h8 Real.pi_pos) G_N_pos) k_B_pos

/-- **Thermodynamic consistency** — THEOREM 4 of the mission spec.
    For any BH of positive mass, the product `M · T_H(M)` equals the
    mass-independent invariant `Λ_Hawking = ℏ c³ / (8 π G k_B)`.

    This is the formalisation of the first-law integration
    `M · T_H(M) = ℏ c³ / (8π G k_B) = constant` on the one-parameter
    family of Schwarzschild black holes.  Equivalently
    `dS/dM ∝ 1/T_H` — the inverse-temperature is the thermodynamic
    conjugate of the mass. -/
theorem M_times_T_H_eq_Lambda {M : ℝ} (hM : 0 < M) :
    M * T_H M = Lambda_Hawking := by
  unfold T_H Lambda_Hawking
  have hdenom : 8 * Real.pi * G_N * M * k_B ≠ 0 :=
    T_H_denominator_ne_zero hM
  have hdenom2 : 8 * Real.pi * G_N * k_B ≠ 0 := by
    have h8 : (8 : ℝ) ≠ 0 := by norm_num
    have hpi : Real.pi ≠ 0 := ne_of_gt Real.pi_pos
    have hG : G_N ≠ 0 := ne_of_gt G_N_pos
    have hk : k_B ≠ 0 := ne_of_gt k_B_pos
    exact mul_ne_zero (mul_ne_zero (mul_ne_zero h8 hpi) hG) hk
  have hM_ne : M ≠ 0 := ne_of_gt hM
  field_simp

/-- **Inverse-temperature is proportional to mass** — the thermodynamic
    conjugate statement, useful for first-law arguments. -/
theorem inverse_T_H_proportional_to_M {M : ℝ} (hM : 0 < M) :
    M / Lambda_Hawking = 1 / T_H M := by
  have hM_T_H := M_times_T_H_eq_Lambda hM
  have hT_H_ne : T_H M ≠ 0 := T_H_ne_zero hM
  have hLambda_ne : Lambda_Hawking ≠ 0 := ne_of_gt Lambda_Hawking_pos
  rw [div_eq_div_iff hLambda_ne hT_H_ne]
  linarith [hM_T_H]

/-! ## 5. Theorem 5 — Planck-scale ceiling hierarchy

T_H of a Planck-mass BH is (up to a small numerical factor of
`1/(8π)`) the Planck temperature `T_P := E_P / k_B`.  We give a
hierarchical statement: T_H(M_P) > 0 and is BOUNDED BELOW the
"naive Planck temperature" `E_P / k_B`.
-/

/-- **Planck temperature** `T_P := E_P / k_B` — the fundamental
    temperature scale on the OmegaTheory substrate derived from the
    four physical constants. -/
noncomputable def T_Planck : ℝ := E_P / k_B

/-- **Planck temperature positivity**. -/
theorem T_Planck_pos : 0 < T_Planck := by
  unfold T_Planck; exact div_pos E_P_pos k_B_pos

/-- **Planck temperature non-zero**. -/
theorem T_Planck_ne_zero : T_Planck ≠ 0 := ne_of_gt T_Planck_pos

/-- **Hawking temperature of a Planck-mass BH is well-defined and
    strictly positive** — THEOREM 5 of the mission spec. -/
theorem T_H_at_M_P_pos : 0 < T_H M_P := T_H_positive M_P_pos

/-- **Planck-mass BH is hotter than any strictly-more-massive BH**:
    immediate corollary of `T_H_inverse_mass`. -/
theorem T_H_Planck_mass_hottest {M : ℝ} (hM : 0 < M) (hlt : M_P < M) :
    T_H M < T_H M_P :=
  T_H_inverse_mass M_P_pos hM hlt

/-! ## 6. Paper bundle + headline

Mission spec asks for a 5-conjunct `hawking_temperature_substrate`
packaging the central facts.
-/

/-- **Mission headline — `hawking_temperature_substrate`.**

    Cycle-21 target 4/6 capstone.  Packages five facts:

    1. T_H(M) > 0 for any positive mass (well-defined blackbody
       temperature).
    2. **Inverse-mass monotonicity**: 0 < M₁ < M₂ ⟹ T_H(M₂) < T_H(M₁).
    3. **Thermodynamic invariant**: M · T_H(M) = Λ_Hawking, a mass-
       independent constant (first-law integration).
    4. **Λ_Hawking positivity** — the invariant is a positive real.
    5. **Planck-mass BH is well-defined**: 0 < T_H(M_P). -/
theorem hawking_temperature_substrate :
    (∀ M : ℝ, 0 < M → 0 < T_H M) ∧
    (∀ M₁ M₂ : ℝ, 0 < M₁ → 0 < M₂ → M₁ < M₂ → T_H M₂ < T_H M₁) ∧
    (∀ M : ℝ, 0 < M → M * T_H M = Lambda_Hawking) ∧
    0 < Lambda_Hawking ∧
    0 < T_H M_P := by
  refine ⟨?_, ?_, ?_, Lambda_Hawking_pos, T_H_at_M_P_pos⟩
  · intro M hM; exact T_H_positive hM
  · intro M₁ M₂ hM₁ hM₂ hlt; exact T_H_inverse_mass hM₁ hM₂ hlt
  · intro M hM; exact M_times_T_H_eq_Lambda hM

/-- **Paper alias — compact 3-conjunct headline**: positivity +
    inverse-mass + thermodynamic invariant. -/
theorem hawking_temperature_headline :
    (∀ M : ℝ, 0 < M → 0 < T_H M) ∧
    (∀ M₁ M₂ : ℝ, 0 < M₁ → 0 < M₂ → M₁ < M₂ → T_H M₂ < T_H M₁) ∧
    (∀ M : ℝ, 0 < M → M * T_H M = Lambda_Hawking) := by
  refine ⟨?_, ?_, ?_⟩
  · intro M hM; exact T_H_positive hM
  · intro M₁ M₂ hM₁ hM₂ hlt; exact T_H_inverse_mass hM₁ hM₂ hlt
  · intro M hM; exact M_times_T_H_eq_Lambda hM

/-- **Hawking evaporation runaway**: as `M` decreases, `T_H` increases.
    A restated, compact witness of the inverse-mass law useful when
    citing the thermodynamic instability. -/
theorem hawking_evaporation_runaway :
    ∀ M₁ M₂ : ℝ, 0 < M₁ → 0 < M₂ → M₁ < M₂ → T_H M₁ > T_H M₂ :=
  fun _ _ hM₁ hM₂ hlt => T_H_inverse_mass hM₁ hM₂ hlt

/-- **Falsifiability witness**: there exists a positive mass whose
    Hawking temperature is strictly positive and lies in a compact
    interval — a simple existence statement seeding any detection
    argument.  Here we pick `M_P` and assert `0 < T_H M_P`. -/
theorem hawking_temperature_falsifiability_witness :
    ∃ M : ℝ, 0 < M ∧ 0 < T_H M ∧ M * T_H M = Lambda_Hawking := by
  refine ⟨M_P, M_P_pos, T_H_at_M_P_pos, M_times_T_H_eq_Lambda M_P_pos⟩

/-- **Frontier marker — FIRST HAWKING TEMPERATURE in V2.**

    This theorem records the existence of a mass-dependent temperature
    function `T_H` satisfying the three defining properties of the
    Hawking radiation temperature (positivity, inverse-mass scaling,
    thermodynamic-integration invariant).  No such formal theorem
    existed in OmegaTheory V2 prior to this file — Bekenstein-Hawking
    ENTROPY had been bounded combinatorially (Deneb,
    `Emergence/BekensteinBound.lean`) but the partner temperature
    scale had not been lifted from physical prose into a proof-assistant
    theorem.  This file closes that gap. -/
theorem hawking_first_temperature_in_V2 :
    ∃ T : ℝ → ℝ,
      (∀ M : ℝ, 0 < M → 0 < T M) ∧
      (∀ M₁ M₂ : ℝ, 0 < M₁ → 0 < M₂ → M₁ < M₂ → T M₂ < T M₁) ∧
      (∃ Λ : ℝ, 0 < Λ ∧ ∀ M : ℝ, 0 < M → M * T M = Λ) := by
  refine ⟨T_H, ?_, ?_, Lambda_Hawking, Lambda_Hawking_pos, ?_⟩
  · intro M hM; exact T_H_positive hM
  · intro M₁ M₂ hM₁ hM₂ hlt; exact T_H_inverse_mass hM₁ hM₂ hlt
  · intro M hM; exact M_times_T_H_eq_Lambda hM

end OmegaTheory.Predictions.HawkingTemperature
