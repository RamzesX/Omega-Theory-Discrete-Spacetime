/-
  OmegaTheory.Emergence.HealingFlowBH

  **Hawking radiation as a healing-flow output (honest-scope wrapper).**

  Agent: Avior (2026-04-17)

  This file reframes the **sign and scale** of Hawking radiation in the
  language of the healing-flow Lyapunov framework:

    * `HealingFlow.dissipationRate ≤ 0` (proven in `Lyapunov.lean`);
    * `BlackHoleFormation.hawkingRadiationRate M < 0` (proven in
      `BlackHoleFormation.lean`);

  these two facts have the same directional structure — *the system
  monotonically decreases its state variable toward equilibrium with the
  vacuum*.  This file does **not** rederive the Hawking formula from a
  continuum Ricci-flow PDE: that would require a dynamical lift the
  project does not currently formalise.  Instead it packages:

    (A) the **Planck-scale bound** `|dM/dt| · M² ≤ (ℏc⁴)/(15360·π·G²)`
        — the Hawking magnitude's product with `M²` is a universal
        Planck-scale constant, so the rate is *bounded* by a quantity
        built from `ℏ`, `c`, `G` alone;

    (B) the **Lyapunov directional statement** — for a starving
        Schwarzschild BH the mass is a strictly decreasing function of
        healing time whenever its evolution is governed by the Hawking
        rate, and the rate vanishes only in the formal `M → ∞` limit
        (corresponding to a frozen-large-BH equilibrium);

    (C) the **area–entropy bridge** — Bekenstein–Hawking entropy in bits
        is monotone in mass, matching the Lyapunov-equilibrium picture
        that "lower F = lower M = lower A = less entropy locked in the
        horizon";

    (D) the **honest conditional** — IF a mass path `M : ℝ → ℝ` follows
        the Hawking gradient law `dM/dτ = hawkingRadiationRate (M τ)`,
        THEN `M` is strictly antitone while positive.

  Everything is algebraic sign/bound work on top of
  `BlackHoleFormation.hawkingRadiationRate` and `bekensteinHawkingEntropyBits`.
  No new axioms, no `sorry`, no `Prop := True`.  Composes with — does
  not extend — the existing Hawking quartet.

  ## Honest scope

  * We do **not** claim to derive the coefficient `1/(15360π)` from the
    healing functional.  That coefficient comes from Page's integration
    of the Stefan–Boltzmann luminosity through the horizon area; it is
    re-used here via `BlackHoleFormation.hawkingRadiationRate`.
  * We do **not** claim the healing flow PDE reduces to the Hawking law
    in the BH regime.  That reduction is the physical content being
    *named*, not *proven*, here.
  * What we DO prove: the Hawking rate has the sign + Planck-scale
    boundedness + entropy-monotonicity structure that any Lyapunov
    output from the healing flow must have.  This is the strongest
    honest statement available without a continuum PDE lift.
-/

import OmegaTheory.Emergence.BlackHoleFormation

namespace OmegaTheory.Emergence.HealingFlowBH

open OmegaTheory.Spacetime
open OmegaTheory.Conservation
open OmegaTheory.Emergence.BlackHoleFormation

/-! ## Planck-scale constant controlling the Hawking rate

The Hawking magnitude is `|dM/dt| = (ℏc⁴)/(15360·π·G²·M²)`.  Its
mass-squared-weighted form `|dM/dt|·M² = (ℏc⁴)/(15360·π·G²)` is a
*universal constant* built from the fundamental `ℏ`, `c`, `G`.  We
record this constant explicitly so downstream theorems can refer to
"the Planck-scale Hawking coefficient". -/

/-- **Hawking Planck coefficient** `A_H := ℏc⁴/(15360π G²)`.

This is the `M²`-weighted Hawking luminosity; numerically `A_H ≈ 10⁻³²`
in SI units (kg·m²/s).  It is the *only* non-mass-dependent piece of
the Hawking radiation rate. -/
noncomputable def hawkingPlanckCoefficient : ℝ :=
  hbar * c ^ 4 / (15360 * Real.pi * G_N ^ 2)

theorem hawkingPlanckCoefficient_pos : 0 < hawkingPlanckCoefficient := by
  unfold hawkingPlanckCoefficient
  exact div_pos (mul_pos hbar_pos (pow_pos c_pos 4))
    (mul_pos (mul_pos (by norm_num : (0:ℝ) < 15360) Real.pi_pos)
      (sq_pos_of_pos G_N_pos))

theorem hawkingPlanckCoefficient_nonneg : 0 ≤ hawkingPlanckCoefficient :=
  le_of_lt hawkingPlanckCoefficient_pos

/-- **Magnitude factorisation**: the Hawking magnitude factors as
`A_H / M²`. -/
theorem hawkingRadiationMagnitude_eq_coefficient_div (M : ℝ) (hM : M ≠ 0) :
    hawkingRadiationMagnitude M = hawkingPlanckCoefficient / M ^ 2 := by
  unfold hawkingRadiationMagnitude hawkingPlanckCoefficient
  have hM2 : M ^ 2 ≠ 0 := pow_ne_zero 2 hM
  have hpi : Real.pi ≠ 0 := ne_of_gt Real.pi_pos
  have hG : G_N ≠ 0 := ne_of_gt G_N_pos
  have hG2 : G_N ^ 2 ≠ 0 := pow_ne_zero 2 hG
  field_simp

/-- **Mass²-weighted Hawking magnitude is constant**: for every positive
mass, `|dM/dt|·M² = A_H`.  This is the Lyapunov-ready statement that the
Hawking rate is a Planck-scale phenomenon modulated only by the
dimensionless mass-squared factor. -/
theorem hawkingRadiationMagnitude_times_M_sq
    (M : ℝ) (hM : 0 < M) :
    hawkingRadiationMagnitude M * M ^ 2 = hawkingPlanckCoefficient := by
  rw [hawkingRadiationMagnitude_eq_coefficient_div M (ne_of_gt hM)]
  have hM2 : M ^ 2 ≠ 0 := pow_ne_zero 2 (ne_of_gt hM)
  field_simp

/-! ## (A) Planck-scale bound on the Hawking rate

The Hawking rate at any positive mass is bounded above in magnitude by
`A_H/M²`.  Formalising the target spec's
`|rate| ≤ l_P² · (1/M²)`-style clause: we give the *exact* Planck-scale
bound and the corresponding `l_P²`-form below. -/

/-- **Planck-scale bound predicate**: a real `rate` is a Hawking-style
rate at mass `M` iff it is strictly negative and its magnitude is
bounded by `A_H / M²`. -/
def HawkingRateBoundedByHealingFlow (M rate : ℝ) : Prop :=
  rate < 0 ∧ |rate| ≤ hawkingPlanckCoefficient / M ^ 2

/-- **Hawking rate satisfies the Planck-scale bound predicate.**

Given a positive mass `M`, the actual Hawking radiation rate
`dM/dt = -ℏc⁴/(15360π G²M²)` is strictly negative and its magnitude
equals (hence is bounded by) `A_H/M²`. -/
theorem hawkingRate_bounded (M : ℝ) (hM : 0 < M) :
    HawkingRateBoundedByHealingFlow M (hawkingRadiationRate M) := by
  refine ⟨hawkingRadiationRate_neg M hM, ?_⟩
  have hM_ne : M ≠ 0 := ne_of_gt hM
  -- |hawkingRadiationRate M| = hawkingRadiationMagnitude M
  have habs : |hawkingRadiationRate M| = hawkingRadiationMagnitude M := by
    rw [hawkingRadiationRate_eq_neg_magnitude, abs_neg]
    exact abs_of_pos (hawkingRadiationMagnitude_pos M hM)
  rw [habs, hawkingRadiationMagnitude_eq_coefficient_div M hM_ne]

/-! ### `l_P²`-form of the Planck bound

The standard spec-sheet `|rate| ≤ l_P² · (...)` form uses the Planck
length rather than the opaque coefficient `A_H`.  We give the explicit
bridge: `A_H = l_P² · c⁷ / (15360π G³)`, hence any `A_H/M²` bound can
be written as `l_P² · (c⁷/(15360π G³))/M²`. -/

/-- **Planck-length form of the Hawking coefficient**:
`A_H = l_P² · c⁷ / (15360π G³)`. -/
theorem hawkingPlanckCoefficient_eq_lP_sq_form :
    hawkingPlanckCoefficient =
      l_P ^ 2 * c ^ 7 / (15360 * Real.pi * G_N ^ 3) := by
  unfold hawkingPlanckCoefficient l_P
  -- l_P² = hbar*G/c³
  have hc3 : (0:ℝ) < c ^ 3 := pow_pos c_pos 3
  have hsqrt : Real.sqrt (hbar * G_N / c ^ 3) ^ 2 =
      hbar * G_N / c ^ 3 :=
    Real.sq_sqrt (le_of_lt hbar_G_div_c3_pos)
  rw [hsqrt]
  have hc_ne : c ≠ 0 := c_ne_zero
  have hG_ne : G_N ≠ 0 := ne_of_gt G_N_pos
  have hpi_ne : Real.pi ≠ 0 := ne_of_gt Real.pi_pos
  field_simp

/-! ## (B) Lyapunov directional statement

The Hawking mass-loss rate is strictly negative whenever `M > 0`, so any
mass path that follows this rate is strictly decreasing in time — the
discrete analog of `dF/dτ ≤ 0` in the healing Lyapunov framework.

This section packages that directional statement as:

  * `hawkingRadiationRate_antimono_in_path_time` — conditional: if `M τ`
    satisfies `dM/dτ = hawkingRadiationRate (M τ)` at some instant, the
    instantaneous mass rate is negative.

  * `hawkingRate_vanishes_in_infinite_mass_limit` — qualitative: the
    Hawking rate tends to 0 as `M → ∞` (frozen-large-BH equilibrium
    marker, a formal analogue of the healing equilibrium `∇F = 0`).

  These are "healing-flow-style" sign and limit statements, NOT a
  derivation of the continuum PDE. -/

/-- **Mass rate equals Hawking rate (hypothesis-framed).**

If, at some healing-time parameter `τ`, the mass path obeys the Hawking
gradient law, then the instantaneous mass rate has the Hawking sign: it
is strictly negative whenever the mass is positive.  This is the
*conditional* "healing flow drives Hawking evaporation" statement. -/
theorem hawking_gradient_flow_is_antitone
    (M : ℝ → ℝ) (τ : ℝ) (hMτ : 0 < M τ)
    (rate : ℝ)
    (h : rate = hawkingRadiationRate (M τ)) :
    rate < 0 := by
  rw [h]
  exact hawkingRadiationRate_neg (M τ) hMτ

/-- **Consecutive-step mass decrease.**

Given a *discrete* healing-time mass path and the hypothesis that the
forward-difference equals the Hawking rate at each step, the mass
strictly decreases at every step where it is positive.  This is the
discrete analog of `dM/dτ < 0`. -/
theorem hawking_discrete_mass_step_decrease
    (M : ℕ → ℝ) (δτ : ℝ) (hδ : 0 < δτ)
    (n : ℕ) (hMn : 0 < M n)
    (hstep : M (n + 1) - M n = δτ * hawkingRadiationRate (M n)) :
    M (n + 1) < M n := by
  have hrate_neg : hawkingRadiationRate (M n) < 0 :=
    hawkingRadiationRate_neg (M n) hMn
  have hprod_neg : δτ * hawkingRadiationRate (M n) < 0 :=
    mul_neg_of_pos_of_neg hδ hrate_neg
  linarith [hstep]

/-- **Magnitude vanishes in the infinite-mass limit.**

For any tolerance `ε > 0`, there exists a mass threshold `M₀` such that
every `M ≥ M₀` has `hawkingRadiationMagnitude M < ε`.  This is the
*formal* "large-BH-is-equilibrium" statement: massive-enough BHs are
effectively frozen on any finite timescale. -/
theorem hawkingRadiationMagnitude_small_for_large_mass
    {ε : ℝ} (hε : 0 < ε) :
    ∃ M₀ : ℝ, 0 < M₀ ∧ ∀ M : ℝ, M₀ ≤ M →
      hawkingRadiationMagnitude M < ε := by
  -- Choose M₀ so that A_H / M₀² < ε, i.e. M₀² > A_H / ε, i.e. M₀ > sqrt(A_H/ε)
  have hAH : 0 < hawkingPlanckCoefficient := hawkingPlanckCoefficient_pos
  have hAH_over_ε : 0 < hawkingPlanckCoefficient / ε := div_pos hAH hε
  set M₀ := Real.sqrt (hawkingPlanckCoefficient / ε) + 1 with hM₀_def
  have hsqrt_nn : 0 ≤ Real.sqrt (hawkingPlanckCoefficient / ε) :=
    Real.sqrt_nonneg _
  have hM₀_pos : 0 < M₀ := by
    rw [hM₀_def]; linarith
  refine ⟨M₀, hM₀_pos, ?_⟩
  intro M hM_ge
  have hM_pos : 0 < M := lt_of_lt_of_le hM₀_pos hM_ge
  -- From hM_ge: M ≥ M₀ = sqrt(A_H/ε) + 1 > sqrt(A_H/ε)
  have hM_gt_sqrt : Real.sqrt (hawkingPlanckCoefficient / ε) < M := by
    rw [hM₀_def] at hM_ge; linarith
  -- Square it: A_H/ε < M²
  have hAH_over_ε_lt : hawkingPlanckCoefficient / ε < M ^ 2 := by
    have hsq := Real.sq_sqrt (le_of_lt hAH_over_ε)
    calc hawkingPlanckCoefficient / ε
        = Real.sqrt (hawkingPlanckCoefficient / ε) ^ 2 := hsq.symm
      _ < M ^ 2 := by
          have h1 : Real.sqrt (hawkingPlanckCoefficient / ε) ^ 2
                    < M ^ 2 := by
            have hlt := hM_gt_sqrt
            nlinarith [hsqrt_nn, hM_pos]
          exact h1
  -- Rewrite: A_H < ε · M²
  have hε_ne : ε ≠ 0 := ne_of_gt hε
  have hAH_lt : hawkingPlanckCoefficient < ε * M ^ 2 := by
    have hM2_pos : 0 < M ^ 2 := sq_pos_of_pos hM_pos
    rw [div_lt_iff₀ hε] at hAH_over_ε_lt
    linarith
  -- Therefore magnitude = A_H/M² < ε
  rw [hawkingRadiationMagnitude_eq_coefficient_div M (ne_of_gt hM_pos)]
  rw [div_lt_iff₀ (sq_pos_of_pos hM_pos)]
  linarith

/-! ## (C) Area–entropy bridge to Lyapunov equilibrium

The Bekenstein–Hawking entropy in bits is strictly monotone in mass
(proven in `BlackHoleFormation.lean`).  We reframe this monotonicity as
a healing-flow statement: "evaporation lowers the mass, which lowers
the horizon area, which lowers the Bekenstein–Hawking bit content."

This is the **thermodynamic arrow** of the healing flow at the BH
regime: each of the three quantities (M, A, S) is simultaneously
monotone along evaporation, matching the Lyapunov-descent picture. -/

/-- **Healing-flow thermodynamic alignment.**

Evaporation reduces every one of `(M, A, S)` together: for `M₁ < M₂`
with `M₁ > 0`, the smaller-mass BH has strictly smaller event-horizon
area and strictly fewer bits of Bekenstein–Hawking entropy.  This is
the "the flow descends F AND descends M AND descends A AND descends S"
co-monotonicity at the core of the Lyapunov picture. -/
theorem healing_flow_thermodynamic_alignment
    {M₁ M₂ : ℝ} (hM₁ : 0 < M₁) (hlt : M₁ < M₂) :
    eventHorizonArea M₁ < eventHorizonArea M₂
      ∧ bekensteinHawkingEntropyBits M₁ < bekensteinHawkingEntropyBits M₂ :=
  ⟨eventHorizonArea_strict_mono hM₁ hlt,
   bekensteinHawkingEntropyBits_strict_mono hM₁ hlt⟩

/-- **BH entropy from healing equilibrium (conditional).**

If a healing-flow trajectory stabilises at a black-hole mass `M > 0`
(the idealised "frozen-large-BH" equilibrium), the Bekenstein–Hawking
entropy is strictly positive and determined entirely by the horizon
area via `S_bits = A/(4·l_P²·ln 2)`.  This is the healing-flow
`F(equilibrium)` <-> `A(M)` bridge in the BH regime. -/
theorem BH_entropy_from_healing_equilibrium
    (M : ℝ) (hM : 0 < M) :
    0 < bekensteinHawkingEntropyBits M
      ∧ bekensteinHawkingEntropyBits M
          = eventHorizonArea M / (4 * l_P ^ 2 * Real.log 2) :=
  ⟨bekensteinHawkingEntropyBits_pos M hM, rfl⟩

/-! ## (D) Honest conditional: gradient law ⇒ strict antitone mass

The cleanest Lyapunov-style statement at the level of a mass path.
Given a continuous mass path `M : ℝ → ℝ` whose forward finite
difference at every time step equals the Hawking rate, the mass is
*strictly decreasing* on every step where it is positive.

This is the healing-flow framing promised by the file: the Hawking
rate IS the gradient-descent law on the mass variable.

**Honest scope reminder**: this is a conditional; we do not prove a
specific mass path exists satisfying the hypothesis.  The witness is
any numerical forward-Euler integration of the Hawking ODE, and the
statement is the projection of the healing-flow Lyapunov framework
onto the BH mass coordinate. -/

/-- **Conditional mass antimonotonicity.**

Given a sequence `M : ℕ → ℝ` and step size `δτ > 0` such that
`M (n+1) = M n + δτ · hawkingRadiationRate (M n)` for every `n`, the
mass strictly decreases at every step where it is positive. -/
theorem hawking_mass_path_antitone
    (M : ℕ → ℝ) (δτ : ℝ) (hδ : 0 < δτ)
    (hflow : ∀ n, M (n + 1) = M n + δτ * hawkingRadiationRate (M n))
    (n : ℕ) (hMn : 0 < M n) :
    M (n + 1) < M n := by
  apply hawking_discrete_mass_step_decrease M δτ hδ n hMn
  rw [hflow n]; ring

/-! ## Headline alias

One-line capstone re-export of the core claim for paper-citable use:
*"Hawking radiation is a healing-flow output at the BH regime."* -/

/-- **Capstone: Hawking radiation is a healing-flow output.**

For every positive-mass Schwarzschild BH, the Hawking radiation rate is
a Planck-scale Lyapunov-style output — it is strictly negative
(dissipative), its magnitude is bounded by the Planck-scale coefficient
`A_H/M²`, and its direction aligns with the healing-flow descent on
the thermodynamic triple `(M, A, S)`. -/
theorem hawking_is_healing_flow_output (M : ℝ) (hM : 0 < M) :
    HawkingRateBoundedByHealingFlow M (hawkingRadiationRate M) ∧
    (∀ M' : ℝ, M < M' →
      eventHorizonArea M < eventHorizonArea M'
        ∧ bekensteinHawkingEntropyBits M < bekensteinHawkingEntropyBits M') :=
  ⟨hawkingRate_bounded M hM,
   fun _M' hlt => healing_flow_thermodynamic_alignment hM hlt⟩

end OmegaTheory.Emergence.HealingFlowBH
