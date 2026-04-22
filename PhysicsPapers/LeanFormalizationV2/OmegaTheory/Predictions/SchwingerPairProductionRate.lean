/-
  OmegaTheory.Predictions.SchwingerPairProductionRate

  **Schwinger tunnel rate for sub-Schwinger magnetic fields.**

  ## Physical narrative

  Schwinger (1951) derived that in an external field of magnitude `B`,
  the vacuum pair-production rate per unit four-volume is

      Γ_pair(B)  =  (B / B_crit)²  ·  exp(−π · B_crit / B)  ·  m_e² c³ / ℏ²

  where `B_crit = m_e² c³ / (eℏ) ≈ 4.414 × 10⁹ T` is the Schwinger
  critical magnetic field (Dschubba's `B_Schwinger`).  The **sub-
  Schwinger regime** `B ≪ B_crit` is dominated by the exponential
  suppression factor `exp(−π B_crit / B)`, which drives the rate to
  zero as `B → 0⁺` far faster than any polynomial can compensate.
  Every realistic laboratory magnetic field (even the strongest
  neutron-star magnetars at `B ≲ 10¹¹ T`) is sub-Schwinger by at least
  one order of magnitude, so the exponential suppression is the *only*
  prediction experimental programs (PVLAS, BMV, IXPE, future HIAF
  laser-electron collisions) can hope to constrain at present.

  The Ferro et al. 2025 (arXiv:2501.11080) GRB photon-delay context
  probes the sub-Schwinger rate *cumulatively* along GRB sight-lines:
  even a tiny non-zero `Γ_pair` integrated over 10⁹ light-years picks
  up a measurable spectral footprint.  The substrate model agrees with
  the QED prediction in the sub-Schwinger regime (both are dominated
  by `exp(−π B_crit/B)`) and only departs for `N`-dependent
  computational uncertainty regimes covered in
  `Emergence/SchwingerPairProduction.lean` (Luffy).

  ## What this file formalises

  * `schwingerPairRate (B B_crit : ℝ) : ℝ`  — the Schwinger tunnel
    rate formula as a real function of field `B` and critical field
    `B_crit`.  Signature matches the mission brief exactly:

        schwingerPairRate B B_crit
          :=  (B / B_crit)²  ·  exp(−π · B_crit / B)  ·  m_e² c³ / ℏ².

  * **Non-negativity** `schwingerPairRate_nonneg` — for `0 < B` and
    `0 < B_crit`, the rate is non-negative.  Proof by `positivity`.

  * **Strict positivity** `schwingerPairRate_pos` — for `0 < B` and
    `0 < B_crit`, the rate is strictly positive.  This is the
    Schwinger prediction's honest content: *however small* the field
    is above zero, the tunneling rate is non-zero.  (The cumulative
    effect along GRB-scale sight-lines is the falsifiable tail.)

  * **Sub-Schwinger exponential suppression**
    `schwingerPairRate_sub_schwinger_exp_suppressed` — when
    `B ≤ B_crit / 10`, the exponential factor is bounded above by
    `exp(−10π)`, giving the explicit upper bound

        Γ_pair(B)  ≤  (B/B_crit)² · exp(−10π) · (m_e² c³ / ℏ²).

    This is the quantitative content of "ten-fold sub-critical field
    gives e^{−10π} ≈ 2 × 10⁻¹⁴ suppression".

  * **Vanishing limit at zero field**  `schwingerPairRate_tendsto_zero_at_zero_B`
    — as `B → 0⁺`, `Γ_pair(B) → 0`.  The proof uses the fact that
    `B² · exp(−π B_crit / B)` is bounded above by `B² · exp(0) = B²`
    on `(0, ∞)` (since `−π B_crit / B < 0`), and `B² → 0` at zero.

  ## Scoping honesty

  The formula above is the one-loop Schwinger-Nikishov result for the
  *leading* term (no sum over `n ≥ 1` Landau levels).  The higher
  terms carry an additional suppression of `exp(−n π B_crit/B)` and
  are subdominant in the sub-Schwinger regime (where even the leading
  `n=1` term is negligible).  This file states the leading-term
  prediction only; it makes no claim about the full sum.  The
  exponential-suppression bound holds *a fortiori* for the full sum
  (every term has the same structural form).

  No `sorry`, no new axioms.
  Author: Tejat (2026-04-19).
  Composes on: Dschubba's `B_Schwinger` (MagnetarProtonCritical.lean)
               and Tureis/Diphda's `m_e` (KoideRelation.lean) and
               `c`, `hbar` (Spacetime.Constants).
-/

import OmegaTheory.Spacetime.Constants
import OmegaTheory.Emergence.KoideRelation
import OmegaTheory.Predictions.MagnetarProtonCritical
import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Tactic

namespace OmegaTheory.Predictions

open OmegaTheory.Spacetime
open OmegaTheory.Emergence.KoideRelation
open OmegaTheory.Predictions.MagnetarProtonCritical

/-! ## 1. The Schwinger tunnel-rate formula

The canonical Schwinger (1951) expression for the vacuum pair-
production rate in a uniform magnetic field of strength `B`, with
critical field scale `B_crit = m_e² c³ / (eℏ)`:

    Γ_pair(B)  =  (B/B_crit)²  ·  exp(−π B_crit / B)  ·  (m_e² c³ / ℏ²).

We expose this as a real-valued function of `B` and `B_crit`, keeping
the critical field as a parameter so that the formula composes with
Dschubba's concrete `B_Schwinger` constant or with any future
substrate-corrected critical scale. -/

/-- **Schwinger tunnel rate** at field `B` with critical field `B_crit`:

        Γ_pair(B, B_crit)  =  (B/B_crit)²  ·  exp(−π · B_crit / B)  ·  m_e² c³ / ℏ².

    The prefactor `(B/B_crit)²` is the polynomial suppression from the
    tunneling density of states; the exponent `exp(−π B_crit/B)` is
    the WKB tunneling probability; the overall scale `m_e²c³/ℏ²` has
    dimensions of inverse four-volume (rate per volume per time). -/
noncomputable def schwingerPairRate (B B_crit : ℝ) : ℝ :=
  (B / B_crit) ^ 2 * Real.exp (-Real.pi * B_crit / B) * (m_e ^ 2 * c ^ 3 / hbar ^ 2)

/-- **Schwinger rate is non-negative.**  For `0 < B` and `0 < B_crit`,
    the formula gives a non-negative real.  Proof: each factor
    is non-negative (square, `exp` non-negative, `m_e² c³ / ℏ²` positive). -/
theorem schwingerPairRate_nonneg
    (B B_crit : ℝ) (_hB : 0 < B) (_hBc : 0 < B_crit) :
    0 ≤ schwingerPairRate B B_crit := by
  unfold schwingerPairRate
  have hm : 0 < m_e ^ 2 * c ^ 3 / hbar ^ 2 :=
    div_pos (mul_pos (pow_pos m_e_pos 2) (pow_pos c_pos 3))
            (pow_pos hbar_pos 2)
  positivity

/-- **Schwinger rate is strictly positive.**  For `0 < B` and
    `0 < B_crit`, the formula gives a strictly positive real.  This
    is the honest Schwinger content: *any* non-zero field produces a
    non-zero tunneling rate.  The GRB sight-line cumulative spectral
    footprint is precisely this positivity integrated over
    cosmological distances. -/
theorem schwingerPairRate_pos
    (B B_crit : ℝ) (hB : 0 < B) (hBc : 0 < B_crit) :
    0 < schwingerPairRate B B_crit := by
  unfold schwingerPairRate
  have h1 : 0 < (B / B_crit) ^ 2 := pow_pos (div_pos hB hBc) 2
  have h2 : 0 < Real.exp (-Real.pi * B_crit / B) := Real.exp_pos _
  have h3 : 0 < m_e ^ 2 * c ^ 3 / hbar ^ 2 :=
    div_pos (mul_pos (pow_pos m_e_pos 2) (pow_pos c_pos 3))
            (pow_pos hbar_pos 2)
  exact mul_pos (mul_pos h1 h2) h3

/-! ## 2. Sub-Schwinger regime: exponential suppression bound

In the physically relevant sub-Schwinger regime `B ≪ B_crit`, the
exponential factor `exp(−π B_crit/B)` dominates the rate's behaviour.
The quantitative form: if `B ≤ B_crit / 10`, then `B_crit / B ≥ 10`,
so `−π B_crit/B ≤ −10π`, so `exp(−π B_crit/B) ≤ exp(−10π)`.  The
result is an explicit bound on the full rate. -/

/-- **Sub-Schwinger suppression — explicit exponential bound.**

    When the applied field is at least ten times smaller than the
    Schwinger critical field (`B ≤ B_crit / 10`), the Schwinger rate
    is bounded above by

        Γ_pair(B)  ≤  (B/B_crit)² · exp(−10π) · (m_e² c³ / ℏ²).

    Numerical reading: `exp(−10π) ≈ 2.5 × 10⁻¹⁴`, so a ten-fold
    sub-critical field gives a suppression of ~14 orders of magnitude
    below the naive polynomial `(B/B_crit)²` alone.  This is why
    laboratory Schwinger searches have found nothing so far.

    The proof is a direct monotonicity chain on the exponential: as
    `B` shrinks, `B_crit / B` grows, `−π B_crit/B` becomes more
    negative, and `exp(·)` shrinks. -/
theorem schwingerPairRate_sub_schwinger_exp_suppressed
    (B B_crit : ℝ) (hB : 0 < B) (hBc : 0 < B_crit)
    (hRatio : B ≤ B_crit / 10) :
    schwingerPairRate B B_crit ≤
      (B / B_crit) ^ 2 * Real.exp (-10 * Real.pi) * (m_e ^ 2 * c ^ 3 / hbar ^ 2) := by
  -- Strategy: bound the exp factor above by exp(-10π), keep the rest equal.
  unfold schwingerPairRate
  have h_prefactor_nonneg : 0 ≤ (B / B_crit) ^ 2 :=
    sq_nonneg _
  have h_scale_pos : 0 < m_e ^ 2 * c ^ 3 / hbar ^ 2 :=
    div_pos (mul_pos (pow_pos m_e_pos 2) (pow_pos c_pos 3))
            (pow_pos hbar_pos 2)
  have h_scale_nonneg : 0 ≤ m_e ^ 2 * c ^ 3 / hbar ^ 2 := h_scale_pos.le
  -- Main arithmetic: show -π · B_crit / B ≤ -10 · π.
  have h_ratio_ge_ten : (10 : ℝ) ≤ B_crit / B := by
    rw [le_div_iff₀ hB]
    linarith
  have hpi_nonneg : 0 ≤ Real.pi := Real.pi_nonneg
  have h_exp_arg_le :
      -Real.pi * B_crit / B ≤ -10 * Real.pi := by
    have : -(Real.pi * (B_crit / B)) ≤ -(Real.pi * 10) := by
      have := mul_le_mul_of_nonneg_left h_ratio_ge_ten hpi_nonneg
      -- this : π * 10 ≤ π * (B_crit / B)
      linarith
    -- rewrite -π · B_crit / B as -(π · (B_crit/B))
    have h_rw : -Real.pi * B_crit / B = -(Real.pi * (B_crit / B)) := by
      field_simp
    rw [h_rw]
    linarith
  have h_exp_mono : Real.exp (-Real.pi * B_crit / B) ≤ Real.exp (-10 * Real.pi) :=
    Real.exp_le_exp.mpr h_exp_arg_le
  -- Combine: multiply both sides by the non-negative prefactor and scale.
  have h_step1 :
      (B / B_crit) ^ 2 * Real.exp (-Real.pi * B_crit / B) ≤
        (B / B_crit) ^ 2 * Real.exp (-10 * Real.pi) :=
    mul_le_mul_of_nonneg_left h_exp_mono h_prefactor_nonneg
  exact mul_le_mul_of_nonneg_right h_step1 h_scale_nonneg

/-! ## 3. The vanishing limit at zero field

As `B → 0⁺`, `Γ_pair(B) → 0`.  The proof is a sandwich between `0`
and the majorant `(B/B_crit)² · 1 · (m_e²c³/ℏ²)` (using
`exp(·) ≤ 1` for non-positive exponents), and then `(B/B_crit)² → 0`
at zero.  This is the operational content of "no field, no pair
production" — the Schwinger rate respects the vacuum stability of
QED at `B = 0`. -/

/-- **Vanishing limit** — `schwingerPairRate → 0` as `B → 0⁺`.
    Proof by squeeze: `0 ≤ Γ_pair(B) ≤ (B/B_crit)² · (m_e²c³/ℏ²)`
    (using `exp(−π B_crit/B) ≤ 1` on `(0, ∞)` since the exponent is
    non-positive), and the RHS tends to `0` as `B → 0⁺`. -/
theorem schwingerPairRate_tendsto_zero_at_zero_B
    (B_crit : ℝ) (hBc : 0 < B_crit) :
    Filter.Tendsto (fun B => schwingerPairRate B B_crit)
      (nhdsWithin 0 (Set.Ioi 0)) (nhds 0) := by
  -- Scale factor is a positive constant; pull it out.
  set K : ℝ := m_e ^ 2 * c ^ 3 / hbar ^ 2 with hK_def
  have hK_pos : 0 < K :=
    div_pos (mul_pos (pow_pos m_e_pos 2) (pow_pos c_pos 3))
            (pow_pos hbar_pos 2)
  -- Squeeze upper bound: Γ(B) ≤ (B/B_crit)² · K   on   B > 0.
  have h_upper :
      ∀ᶠ B in nhdsWithin (0 : ℝ) (Set.Ioi 0),
        schwingerPairRate B B_crit ≤ (B / B_crit) ^ 2 * K := by
    filter_upwards [self_mem_nhdsWithin] with B hB
    have hB_pos : 0 < B := hB
    -- exp(-π · B_crit / B) ≤ 1
    have h_exp_arg_nonpos : -Real.pi * B_crit / B ≤ 0 := by
      have hpi_nonneg : 0 ≤ Real.pi := Real.pi_nonneg
      have h_num_nonpos : -Real.pi * B_crit ≤ 0 := by
        have : 0 ≤ Real.pi * B_crit := mul_nonneg hpi_nonneg hBc.le
        linarith
      exact div_nonpos_of_nonpos_of_nonneg h_num_nonpos hB_pos.le
    have h_exp_le_one : Real.exp (-Real.pi * B_crit / B) ≤ 1 := by
      have := Real.exp_le_one_iff.mpr h_exp_arg_nonpos
      exact this
    -- Prefactor is non-negative, K is non-negative.
    have h_prefactor_nonneg : 0 ≤ (B / B_crit) ^ 2 := sq_nonneg _
    have hK_nonneg : 0 ≤ K := hK_pos.le
    calc schwingerPairRate B B_crit
        = (B / B_crit) ^ 2 * Real.exp (-Real.pi * B_crit / B) * K := by
          unfold schwingerPairRate; rw [hK_def]
      _ ≤ (B / B_crit) ^ 2 * 1 * K := by
          apply mul_le_mul_of_nonneg_right _ hK_nonneg
          exact mul_le_mul_of_nonneg_left h_exp_le_one h_prefactor_nonneg
      _ = (B / B_crit) ^ 2 * K := by ring
  -- Squeeze lower bound: 0 ≤ Γ(B).
  have h_lower :
      ∀ᶠ B in nhdsWithin (0 : ℝ) (Set.Ioi 0),
        (0 : ℝ) ≤ schwingerPairRate B B_crit := by
    filter_upwards [self_mem_nhdsWithin] with B hB
    exact schwingerPairRate_nonneg B B_crit hB hBc
  -- Majorant: (B/B_crit)² · K → 0 as B → 0 within (0, ∞)
  have h_majorant :
      Filter.Tendsto (fun B : ℝ => (B / B_crit) ^ 2 * K)
        (nhdsWithin 0 (Set.Ioi 0)) (nhds 0) := by
    have h1 : Filter.Tendsto (fun B : ℝ => (B / B_crit) ^ 2) (nhds (0 : ℝ)) (nhds 0) := by
      have hf : Filter.Tendsto (fun B : ℝ => B / B_crit) (nhds (0 : ℝ)) (nhds 0) := by
        have h_c : Filter.Tendsto (fun B : ℝ => B / B_crit) (nhds (0 : ℝ)) (nhds (0 / B_crit)) :=
          (continuous_id.div_const B_crit).tendsto 0
        simpa [zero_div] using h_c
      have hp :
          Filter.Tendsto (fun B : ℝ => (B / B_crit) ^ 2)
            (nhds (0 : ℝ)) (nhds ((0 : ℝ) ^ 2)) := hf.pow 2
      simpa using hp
    have h1_within :
        Filter.Tendsto (fun B : ℝ => (B / B_crit) ^ 2) (nhdsWithin 0 (Set.Ioi 0)) (nhds 0) :=
      h1.mono_left nhdsWithin_le_nhds
    -- multiply by constant K
    have := h1_within.mul_const K
    simpa [zero_mul] using this
  -- Apply the squeeze.
  exact tendsto_of_tendsto_of_tendsto_of_le_of_le'
    (tendsto_const_nhds : Filter.Tendsto (fun _ : ℝ => (0 : ℝ)) _ _)
    h_majorant h_lower h_upper

/-! ## 4. Canonical specialisation to the physical critical field

The formula `schwingerPairRate B B_Schwinger` gives the canonical
Schwinger rate at the QED critical scale `B_Schwinger ≈ 4.414 × 10⁹ T`.
We expose small specialisations. -/

/-- **Canonical rate** — `schwingerPairRate B B_Schwinger` is the
    Schwinger pair-production rate at the QED-standard critical field.
    Strict positivity for any `B > 0`. -/
theorem schwingerPairRate_at_B_Schwinger_pos
    (B : ℝ) (hB : 0 < B) :
    0 < schwingerPairRate B B_Schwinger :=
  schwingerPairRate_pos B B_Schwinger hB B_Schwinger_pos

/-- **Canonical sub-Schwinger bound** — at any field below
    `B_Schwinger / 10 ≈ 4.414 × 10⁸ T`, the rate is bounded above by
    `(B/B_Schwinger)² · exp(−10π) · (m_e² c³ / ℏ²)`. -/
theorem schwingerPairRate_at_B_Schwinger_sub_suppressed
    (B : ℝ) (hB : 0 < B) (hRatio : B ≤ B_Schwinger / 10) :
    schwingerPairRate B B_Schwinger ≤
      (B / B_Schwinger) ^ 2 * Real.exp (-10 * Real.pi) * (m_e ^ 2 * c ^ 3 / hbar ^ 2) :=
  schwingerPairRate_sub_schwinger_exp_suppressed B B_Schwinger hB B_Schwinger_pos hRatio

/-! ## 5. Packaged summary

One theorem tying the three facts together, for downstream paper-
bundle files. -/

/-- **Packaged summary** — the Schwinger rate in the sub-Schwinger
    regime is (i) non-negative, (ii) strictly positive, and (iii)
    bounded above by the exponentially-suppressed majorant. -/
theorem schwinger_suppression_rate_formalization
    {B B_crit : ℝ} (hB : 0 < B) (hBc : 0 < B_crit)
    (hRatio : B ≤ B_crit / 10) :
    0 ≤ schwingerPairRate B B_crit
    ∧ 0 < schwingerPairRate B B_crit
    ∧ schwingerPairRate B B_crit ≤
        (B / B_crit) ^ 2 * Real.exp (-10 * Real.pi) * (m_e ^ 2 * c ^ 3 / hbar ^ 2) :=
  ⟨schwingerPairRate_nonneg B B_crit hB hBc,
   schwingerPairRate_pos B B_crit hB hBc,
   schwingerPairRate_sub_schwinger_exp_suppressed B B_crit hB hBc hRatio⟩

end OmegaTheory.Predictions
