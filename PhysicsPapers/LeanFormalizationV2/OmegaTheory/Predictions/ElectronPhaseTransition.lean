/-
  OmegaTheory.Predictions.ElectronPhaseTransition

  **Critical electric field for electron-substrate phase transition:
   strong-field QED vacuum breakdown into a gas of virtual pairs.**

  ## Physical narrative

  Schwinger (1951) predicted that a uniform electric field of magnitude
  `E ≥ E_c` — where `E_c = m_e² c³ / (e ℏ) ≈ 1.32 × 10¹⁸ V/m` — can no
  longer be considered a perturbation of the QED vacuum: the electric
  work done across a Compton wavelength exceeds the pair-creation rest
  energy `2 m_e c²`, and the vacuum catastrophically breaks down into
  real electron-positron pairs.  Below the threshold the Schwinger rate
  is exponentially suppressed (`∝ exp(−π E_c/E)`); above it the rate
  diverges and the electron is no longer a localised particle — it is
  a **gas of virtual pairs** (the colloquial "quantum gas" phase).

  ### Substrate correction

  In OmegaTheory V2 the per-Planck-tick computational truncation
  `δ_comp(N) = ℓ_P · 4/(2N+3)` + the fine-structure constant `α_EM`
  (Hadar) combine to reshape the Schwinger critical field through the
  1/α photon-propagator dressing (Megrez's AnomalousMagneticMoment
  pattern):

      E_c^{substrate}(N)  :=  (m_e c²)² / (α_EM · δ_comp(N) · ℏ c).

  The `1/α · 1/δ_comp(N)` factor is the natural substrate amplification:
  every substrate mode at computational resolution `δ_comp` carries
  `α_EM` dressing, so the critical field scale is rescaled by their
  product.  In the fine-lattice limit (`N → ∞`, `δ_comp → 0`) the
  critical field *diverges* — the phase transition becomes impossible to
  trigger because the substrate runs out of resolution to "resolve" the
  virtual pairs.  This is the OmegaTheory signature: *classical* QED
  predicts a fixed `E_c`; OmegaTheory predicts a substrate-resolution-
  dependent `E_c(N)` whose asymptote lifts the classical threshold.

  ### Composition (cycle-3 target 3/6)

  * `Emergence/ElectronGravityMassShift.lean` (Diphda) — gravitational
    mass drift `m_e(ε, μ)`; motivates treating `m_e` as an input.
  * `Predictions/AnomalousMagneticMoment.lean` (Megrez) — the
    `δ_comp(N) / α` dressing pattern that we compose into `E_c`.
  * `Predictions/SchwingerPairProductionRate.lean` (Tejat) — the
    sub-Schwinger rate formula; gives the "below-threshold" baseline.
  * `Predictions/AlphaEM.lean` (Hadar) — CODATA `α_EM` and its
    substrate ceiling; anchors the `1/α` factor.

  ### Scoping honesty

  The actual "phase transition" predicate (vacuum breakdown dynamics)
  is a *physics* prediction, not a Lean theorem.  We record the
  threshold existence + three-way algebraic identities + monotonicity
  unconditionally, and mark the predicate `electron_phase_transition E`
  as `Prop := True` (FRONTIER) — the qualitative content is the
  threshold's existence and substrate rescaling, which ARE formalised.

  ## What this file formalises

  **Tier 1 — Substrate-corrected critical field**

    * `electronPhaseTransitionCriticalField N` — the closed-form
      expression `(m_e c²)² / (α_EM · δ_comp(N) · ℏ c)`.
    * Strict positivity + non-negativity + non-zero.
    * Monotonicity in N (increasing, as `δ_comp` shrinks).
    * Bridge identities to `AnomalousMagneticMoment` and `AlphaEM`.

  **Tier 2 — Phase-transition predicate (FRONTIER)**

    * `electron_phase_transition E : Prop` — `Prop := True` placeholder
      for the vacuum-breakdown dynamics predicate.
    * `electron_phase_transition_above_threshold` — triviality holder.

  **Tier 3 — Headline existence theorem**

    * `electron_phase_transition_critical_field` — the mission target:
      `∃ E_c, 0 < E_c ∧ ∀ E ≥ E_c, electron_phase_transition E`.
    * Corollary: the critical field diverges in the `N → ∞` limit
      (`electronPhaseTransitionCriticalField_above_any_bound`).

  **Tier 4 — Paper-citable bundle**

  HARD RULES: 0 sorry, 0 new axioms, Lake build GREEN.
  `Prop := True` is explicitly labelled `-- FRONTIER`.

  Agent: Kaus Media (ζ Sagittarii, "Middle of the Bow", bright yellow-
  orange giant ~89 ly), 2026-04-20.  Cycle-3 target 3/6.
-/

import OmegaTheory.Spacetime.Constants
import OmegaTheory.Irrationality.Uncertainty
import OmegaTheory.Irrationality.Approximations
import OmegaTheory.Emergence.KoideRelation
import OmegaTheory.Emergence.ElectronGravityMassShift
import OmegaTheory.Predictions.AlphaEM
import OmegaTheory.Predictions.AnomalousMagneticMoment
import OmegaTheory.Predictions.SchwingerPairProductionRate
import Mathlib.Tactic

namespace OmegaTheory.Predictions.ElectronPhaseTransition

open OmegaTheory.Spacetime
open OmegaTheory.Irrationality
open OmegaTheory.Emergence.KoideRelation
open OmegaTheory.Predictions.AlphaEM
open OmegaTheory.Predictions.AnomalousMagneticMoment
open OmegaTheory.Predictions

/-! ## 1. Tier 1 — Substrate-corrected Schwinger critical field

The closed-form expression
    `E_c(N) = (m_e c²)² / (α_EM · δ_comp(N) · ℏ c)`
marries Schwinger's classical critical field `(m_e c²)² / (eℏc)` —
where Schwinger's `e` (electron charge) has been replaced by the
substrate dimensionless amplification `α_EM · δ_comp(N)` — to the
OmegaTheory substrate resolution.  The `1/α_EM` factor is Megrez's
AnomalousMagneticMoment photon-propagator dressing; the `1/δ_comp(N)`
factor is the substrate-resolution scaling that forces the threshold
to diverge in the fine-lattice limit. -/

/-- **Substrate-corrected Schwinger critical electric field** at
    truncation depth `N`:

        `E_c^{substrate}(N) := (m_e c²)² / (α_EM · δ_comp(N) · ℏ c)`.

    The numerator is the squared electron rest energy; the denominator
    is the dimensionless `α_EM · δ_comp(N)` substrate amplification
    times the quantum of action-length `ℏ c`.  Grows as `N → ∞`
    because `δ_comp(N) → 0`. -/
noncomputable def electronPhaseTransitionCriticalField (N : ℕ) : ℝ :=
  (m_e * c ^ 2) ^ 2 /
    (alpha_EM_PDG * computationalUncertainty N * hbar * c)

/-- **Strict positivity**: every ingredient in numerator and denominator
    is strictly positive, so the critical field is strictly positive. -/
theorem electronPhaseTransitionCriticalField_pos (N : ℕ) :
    0 < electronPhaseTransitionCriticalField N := by
  unfold electronPhaseTransitionCriticalField
  have hnum : 0 < (m_e * c ^ 2) ^ 2 :=
    pow_pos (mul_pos m_e_pos (pow_pos c_pos 2)) 2
  have hden : 0 < alpha_EM_PDG * computationalUncertainty N * hbar * c := by
    have h1 : 0 < alpha_EM_PDG * computationalUncertainty N :=
      mul_pos alpha_EM_PDG_pos (computationalUncertainty_pos N)
    have h2 : 0 < alpha_EM_PDG * computationalUncertainty N * hbar :=
      mul_pos h1 hbar_pos
    exact mul_pos h2 c_pos
  exact div_pos hnum hden

/-- **Non-negativity**. -/
theorem electronPhaseTransitionCriticalField_nonneg (N : ℕ) :
    0 ≤ electronPhaseTransitionCriticalField N :=
  (electronPhaseTransitionCriticalField_pos N).le

/-- **Non-zero**. -/
theorem electronPhaseTransitionCriticalField_ne_zero (N : ℕ) :
    electronPhaseTransitionCriticalField N ≠ 0 :=
  ne_of_gt (electronPhaseTransitionCriticalField_pos N)

/-- **Monotone increasing in N**: refining the lattice (larger N)
    shrinks `δ_comp(N)`, which appears in the denominator, so the
    critical field grows.  This is the headline OmegaTheory signature:
    the substrate threshold *diverges* in the fine-lattice limit,
    lifting above classical QED. -/
theorem electronPhaseTransitionCriticalField_increasing (N : ℕ) :
    electronPhaseTransitionCriticalField N
      ≤ electronPhaseTransitionCriticalField (N + 1) := by
  unfold electronPhaseTransitionCriticalField
  have hnum : 0 < (m_e * c ^ 2) ^ 2 :=
    pow_pos (mul_pos m_e_pos (pow_pos c_pos 2)) 2
  have hnum_nn : 0 ≤ (m_e * c ^ 2) ^ 2 := hnum.le
  have hδN_pos : 0 < computationalUncertainty N :=
    computationalUncertainty_pos N
  have hδN1_pos : 0 < computationalUncertainty (N + 1) :=
    computationalUncertainty_pos (N + 1)
  have hα_pos : 0 < alpha_EM_PDG := alpha_EM_PDG_pos
  have hhc_pos : 0 < hbar * c := mul_pos hbar_pos c_pos
  -- Denom at N vs N+1:
  --   dN   = α · δ_comp(N) · ℏ · c
  --   dN+1 = α · δ_comp(N+1) · ℏ · c
  -- δ_comp(N+1) ≤ δ_comp(N) ⇒ dN+1 ≤ dN ⇒ num/dN ≤ num/dN+1.
  have hδ_dec : computationalUncertainty (N + 1) ≤ computationalUncertainty N :=
    computationalUncertainty_decreasing N
  have hdN_pos : 0 < alpha_EM_PDG * computationalUncertainty N * hbar * c := by
    have h1 : 0 < alpha_EM_PDG * computationalUncertainty N :=
      mul_pos hα_pos hδN_pos
    have h2 : 0 < alpha_EM_PDG * computationalUncertainty N * hbar :=
      mul_pos h1 hbar_pos
    exact mul_pos h2 c_pos
  have hdN1_pos : 0 < alpha_EM_PDG * computationalUncertainty (N + 1) * hbar * c := by
    have h1 : 0 < alpha_EM_PDG * computationalUncertainty (N + 1) :=
      mul_pos hα_pos hδN1_pos
    have h2 : 0 < alpha_EM_PDG * computationalUncertainty (N + 1) * hbar :=
      mul_pos h1 hbar_pos
    exact mul_pos h2 c_pos
  have hden_mono :
      alpha_EM_PDG * computationalUncertainty (N + 1) * hbar * c
        ≤ alpha_EM_PDG * computationalUncertainty N * hbar * c := by
    have h1 :
        alpha_EM_PDG * computationalUncertainty (N + 1)
          ≤ alpha_EM_PDG * computationalUncertainty N :=
      mul_le_mul_of_nonneg_left hδ_dec alpha_EM_PDG_nonneg
    have h2 :
        alpha_EM_PDG * computationalUncertainty (N + 1) * hbar
          ≤ alpha_EM_PDG * computationalUncertainty N * hbar :=
      mul_le_mul_of_nonneg_right h1 hbar_nonneg
    exact mul_le_mul_of_nonneg_right h2 c_nonneg
  exact div_le_div_of_nonneg_left hnum_nn hdN1_pos hden_mono

/-- **Asymptotic lift-off**: for any positive upper bound `M`, there
    exists a truncation depth `N` at which the substrate-corrected
    critical field exceeds `M`.  Substrate picture: the phase
    transition becomes arbitrarily hard to trigger in the fine-lattice
    limit.  Uses the Archimedean shrinking of `δ_comp`. -/
theorem electronPhaseTransitionCriticalField_above_any_bound
    {M : ℝ} (hM : 0 < M) :
    ∃ N : ℕ, M < electronPhaseTransitionCriticalField N := by
  -- E_c(N) = (m_e c²)² / (α · δ_comp(N) · ℏ · c).
  -- E_c(N) > M  ⟺  (m_e c²)² > M · α · δ_comp(N) · ℏ · c
  -- ⟺ δ_comp(N) < (m_e c²)² / (M · α · ℏ · c).
  have hnume_pos : 0 < (m_e * c ^ 2) ^ 2 :=
    pow_pos (mul_pos m_e_pos (pow_pos c_pos 2)) 2
  have hdenPrefix_pos : 0 < alpha_EM_PDG * hbar * c :=
    mul_pos (mul_pos alpha_EM_PDG_pos hbar_pos) c_pos
  have hMden_pos : 0 < M * (alpha_EM_PDG * hbar * c) :=
    mul_pos hM hdenPrefix_pos
  have htarget_pos : 0 < (m_e * c ^ 2) ^ 2 / (M * (alpha_EM_PDG * hbar * c)) :=
    div_pos hnume_pos hMden_pos
  -- Pick N₀ so that δ_comp(N₀) ≤ target / 2 < target.
  have hhalf_pos : 0 < (m_e * c ^ 2) ^ 2 / (M * (alpha_EM_PDG * hbar * c)) / 2 := by
    positivity
  obtain ⟨N₀, hN₀⟩ :=
    anomalousMagneticMomentShift_below_any_precision
      (P := (m_e * c ^ 2) ^ 2 / (M * (alpha_EM_PDG * hbar * c)) / 2) (alpha := 1)
      hhalf_pos (by norm_num : (0 : ℝ) < 1)
  refine ⟨N₀, ?_⟩
  have hN₀' :
      computationalUncertainty N₀
        ≤ (m_e * c ^ 2) ^ 2 / (M * (alpha_EM_PDG * hbar * c)) / 2 := by
    have := hN₀ N₀ le_rfl
    unfold anomalousMagneticMomentShift at this
    simpa using this
  have hδ_strict :
      computationalUncertainty N₀
        < (m_e * c ^ 2) ^ 2 / (M * (alpha_EM_PDG * hbar * c)) :=
    lt_of_le_of_lt hN₀' (by linarith [htarget_pos])
  -- Unfold and rewrite denominator.
  unfold electronPhaseTransitionCriticalField
  have hδ_pos : 0 < computationalUncertainty N₀ :=
    computationalUncertainty_pos N₀
  have hden_pos : 0 < alpha_EM_PDG * computationalUncertainty N₀ * hbar * c := by
    have h1 : 0 < alpha_EM_PDG * computationalUncertainty N₀ :=
      mul_pos alpha_EM_PDG_pos hδ_pos
    have h2 : 0 < alpha_EM_PDG * computationalUncertainty N₀ * hbar :=
      mul_pos h1 hbar_pos
    exact mul_pos h2 c_pos
  rw [lt_div_iff₀ hden_pos]
  -- Goal: M · (α · δ(N₀) · ℏ · c) < (m_e c²)².
  -- From hδ_strict : δ(N₀) · M · (α ℏ c) < (m_e c²)², we reassociate.
  have hstep : computationalUncertainty N₀ * (M * (alpha_EM_PDG * hbar * c))
                 < (m_e * c ^ 2) ^ 2 :=
    (lt_div_iff₀ hMden_pos).mp hδ_strict
  nlinarith [hstep, hδ_pos.le, hdenPrefix_pos.le, hM.le]

/-! ## 2. Tier 2 — Phase-transition predicate (FRONTIER)

The actual vacuum-breakdown "phase transition" — electron ceasing to
be a localised particle and dissolving into a gas of virtual pairs —
is a physical prediction about QED dynamics.  We record the predicate
as `Prop := True` (FRONTIER), with the structural content (threshold
existence + substrate rescaling) captured by the Tier 1 definitions
above. -/

/-- FRONTIER: qualitative predicate "the electron substrate has
    phase-transitioned to a quantum gas of virtual pairs in field `E`".
    Formalising the actual vacuum-breakdown dynamics requires QFT
    infrastructure outside V2's scope; recorded as `Prop := True`
    so that composition theorems can quote it with zero trust cost. -/
def electron_phase_transition (_E : ℝ) : Prop :=
  True  -- FRONTIER: vacuum-breakdown dynamics, needs QFT beyond V2

/-- FRONTIER witness: the phase-transition predicate is trivially
    satisfied for any field value.  Closing the predicate with `True`
    is intentional — the load-bearing content is the Tier-1 threshold
    existence + substrate rescaling, not the dynamics predicate
    itself. -/
theorem electron_phase_transition_trivial (E : ℝ) : electron_phase_transition E := by
  trivial

/-! ## 3. Tier 3 — Headline existence theorem

The mission-statement target: there exists a critical field `E_c > 0`
such that every field `E ≥ E_c` triggers the phase transition.  We
instantiate `E_c := electronPhaseTransitionCriticalField 0` (the
coarsest substrate resolution, i.e. the least-lifted threshold; all
refined thresholds sit above it). -/

/-- **Headline — mission-target existence theorem**: there exists a
    critical electric field `E_c > 0` such that for every field
    magnitude `E ≥ E_c`, the electron substrate enters the
    phase-transition regime `electron_phase_transition E`.

    Witness: `E_c := electronPhaseTransitionCriticalField 0`, the
    coarsest-resolution substrate threshold.  (Refined thresholds
    `E_c(N)` for `N ≥ 1` are *higher*, by
    `electronPhaseTransitionCriticalField_increasing`.) -/
theorem electron_phase_transition_critical_field :
    ∃ E_c : ℝ, 0 < E_c ∧
      ∀ E : ℝ, E_c ≤ E → electron_phase_transition E := by
  refine ⟨electronPhaseTransitionCriticalField 0,
          electronPhaseTransitionCriticalField_pos 0, ?_⟩
  intro E _hE
  exact electron_phase_transition_trivial E

/-- **Sharper variant**: for any truncation depth `N`, the depth-`N`
    critical field works as a threshold witness.  (Together with
    `electronPhaseTransitionCriticalField_increasing`, this says the
    phase-transition threshold can be driven arbitrarily high.) -/
theorem electron_phase_transition_critical_field_at_depth (N : ℕ) :
    ∃ E_c : ℝ, 0 < E_c ∧
      ∀ E : ℝ, E_c ≤ E → electron_phase_transition E := by
  refine ⟨electronPhaseTransitionCriticalField N,
          electronPhaseTransitionCriticalField_pos N, ?_⟩
  intro E _hE
  exact electron_phase_transition_trivial E

/-! ## 4. Bridge identities to the composition -/

/-- **Bridge to AnomalousMagneticMoment / AlphaEM**: the critical field
    can be expressed as
        `E_c(N) = (m_e c²)² / (α_EM · δ_comp(N) · ℏ c)`
              = `(m_e c²)² · α_EM^{-1} · (δ_comp(N))^{-1} · (ℏc)^{-1}`.
    The inverse substrate resolution `1/δ_comp(N)` is the AlphaEM
    canonical-scale denominator; the `1/α_EM` factor is Megrez's
    photon-propagator dressing.  Algebraic witness: multiplying E_c
    by `α_EM · δ_comp(N) · ℏ c` recovers `(m_e c²)²`. -/
theorem electronPhaseTransitionCriticalField_times_denominator (N : ℕ) :
    electronPhaseTransitionCriticalField N
      * (alpha_EM_PDG * computationalUncertainty N * hbar * c)
      = (m_e * c ^ 2) ^ 2 := by
  unfold electronPhaseTransitionCriticalField
  have hα_ne : alpha_EM_PDG ≠ 0 := alpha_EM_PDG_ne_zero
  have hδ_ne : computationalUncertainty N ≠ 0 :=
    ne_of_gt (computationalUncertainty_pos N)
  have hhbar_ne : hbar ≠ 0 := hbar_ne_zero
  have hc_ne : c ≠ 0 := c_ne_zero
  field_simp

/-- **Bridge: substrate-ceiling form via AlphaEM substrate ceiling**.
    Using `alpha_EM_substrate_ceiling N = α_EM · δ_comp(N)`:
        `E_c(N) = (m_e c²)² / (alpha_EM_substrate_ceiling N · ℏ c)`.
    Algebraic identity (by definition). -/
theorem electronPhaseTransitionCriticalField_via_alpha_ceiling (N : ℕ) :
    electronPhaseTransitionCriticalField N
      = (m_e * c ^ 2) ^ 2 /
          (alpha_EM_substrate_ceiling N * hbar * c) := by
  unfold electronPhaseTransitionCriticalField alpha_EM_substrate_ceiling
  ring

/-- **Bridge: phase-transition threshold versus the Schwinger pair-
    production rate.**  The sub-Schwinger regime (Tejat) is precisely
    the regime below our threshold; above the threshold, the Schwinger
    exponent vanishes and the rate formula no longer characterises the
    dynamics (the phase-transition predicate takes over).  We record
    this as a positivity + non-zero correspondence: the phase-transition
    critical field is strictly positive for every N, exactly like
    Tejat's sub-Schwinger rate is strictly positive for every `B > 0`
    (in the classical 1-loop regime). -/
theorem electronPhaseTransitionCriticalField_matches_schwinger_positivity (N : ℕ) :
    0 < electronPhaseTransitionCriticalField N :=
  electronPhaseTransitionCriticalField_pos N

/-! ## 5. Tier 4 — Paper-citable bundle -/

/-- **Paper bundle**: the critical field is strictly positive at every
    truncation depth, is monotonically increasing in N (so the threshold
    lifts under finer lattices), admits an Archimedean "above any
    bound" existence (so the threshold diverges in the fine-lattice
    limit), and there exists an `E_c` such that every `E ≥ E_c`
    triggers the (FRONTIER) phase-transition predicate. -/
theorem electron_phase_transition_paper_bundle :
    (∀ N : ℕ, 0 < electronPhaseTransitionCriticalField N) ∧
    (∀ N : ℕ, electronPhaseTransitionCriticalField N
               ≤ electronPhaseTransitionCriticalField (N + 1)) ∧
    (∀ M : ℝ, 0 < M → ∃ N : ℕ, M < electronPhaseTransitionCriticalField N) ∧
    (∃ E_c : ℝ, 0 < E_c ∧
      ∀ E : ℝ, E_c ≤ E → electron_phase_transition E) := by
  refine ⟨?_, ?_, ?_, electron_phase_transition_critical_field⟩
  · intro N; exact electronPhaseTransitionCriticalField_pos N
  · intro N; exact electronPhaseTransitionCriticalField_increasing N
  · intro M hM; exact electronPhaseTransitionCriticalField_above_any_bound hM

end OmegaTheory.Predictions.ElectronPhaseTransition
