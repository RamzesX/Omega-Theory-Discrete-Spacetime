/-
  OmegaTheory.Emergence.DeBroglieEquipartition

  **TheoremCandidate T-β.**  The de Broglie wavelength equals the
  (reduced) Compton wavelength precisely at the kinematic regime
  where the tick-counting fractions equipartition: exactly half of
  the ticks advance the pattern forward, exactly half feed the
  zitterbewegung rest-energy sector.

  Physical narrative.  The two natural length scales associated with
  a massive quantum particle are
  ```
      λ_dB  = ℏ / p        (de Broglie)
      λ_C   = ℏ / (m c)    (Compton, reduced)
  ```
  Their ratio is `λ_dB / λ_C = m c / p`.  In the tick-counting picture
  of `Emergence/DispersionFromLattice.lean` the forward-fraction
  satisfies
  ```
      (forwardFraction p m)² = (p c)² / E²
                             = (p c)² / ((p c)² + (m c²)²).
  ```
  Now the condition `λ_dB = λ_C` unfolds to `p = m c`, equivalently
  `p c = m c²`, i.e. the translation-sector energy equals the
  rest-energy sector.  Substituting,
  ```
      (forwardFraction)² = (p c)² / (2 (p c)²) = 1/2,
  ```
  and conversely `(forwardFraction)² = 1/2` forces `(p c)² = (m c²)²`
  which, for positive quantities, is exactly `p = m c`.

  The identity is therefore the statement **"de Broglie equals Compton
  iff the tick-counting is equipartitioned"**: an equivalence between
  a relation between emergent wavelengths and a symmetry between the
  two channels (forward advance vs. zitterbewegung reshuffle) of the
  discrete substrate.

  Key exports:

  * `deBroglieWavelength p`                         — `ℏ / p`
  * `deBroglieWavelength_pos`                       — positivity lemma
  * `deBroglie_equals_compton_iff_momentum`         — `λ_dB = λ_C ↔ p = m c`
  * `deBroglie_equals_compton_iff_equipartition`    — headline T-β theorem

  No new axioms are introduced.

  Author: Antares (α Scorpii, "rival of Mars" — Arabic *qalb al-ʿaqrab*
  "heart of the scorpion"; Greek *antārēs* "rival of Arēs").  The red
  supergiant M1.5Iab at ~550 ly chosen for its rivalry-as-balance
  connotation, fitting the equipartition theme of this file.
-/

import OmegaTheory.Emergence.DispersionFromLattice
import OmegaTheory.Conservation.Correspondence

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime OmegaTheory.Conservation

/-! ## De Broglie wavelength

    We adopt the *reduced* convention `λ_dB = ℏ / p`, matching the
    already-existing `comptonWavelength m = ℏ / (m c)` in
    `Conservation/Correspondence.lean`.  Both wavelengths are then
    expressed in terms of the same single Planck constant `hbar`,
    so the equality `λ_dB = λ_C` is a clean statement about the
    single ratio `m c / p` with no extraneous factors of `2π`. -/

/-- Reduced de Broglie wavelength `λ_dB = ℏ / p`. -/
noncomputable def deBroglieWavelength (p : ℝ) : ℝ := hbar / p

/-- De Broglie wavelength is positive at positive momentum. -/
theorem deBroglieWavelength_pos {p : ℝ} (hp : 0 < p) :
    0 < deBroglieWavelength p :=
  div_pos hbar_pos hp

/-- De Broglie wavelength is antimonotone in momentum. -/
theorem deBroglieWavelength_antimono {p₁ p₂ : ℝ} (hp₁ : 0 < p₁)
    (_hp₂ : 0 < p₂) (h : p₁ < p₂) :
    deBroglieWavelength p₂ < deBroglieWavelength p₁ := by
  unfold deBroglieWavelength
  exact div_lt_div_of_pos_left hbar_pos hp₁ h

/-! ## The momentum criterion

    Before the headline equivalence we prove the intermediate step:
    the two wavelengths coincide iff `p = m c`.  This isolates the
    algebra of clearing `ℏ` from both sides. -/

/-- `λ_dB = λ_C` is equivalent to `p = m c`.  Both sides involve
    a factor of `ℏ` which cancels because `ℏ > 0`; the remaining
    identity is a straightforward cross-multiplication. -/
theorem deBroglie_equals_compton_iff_momentum
    {m : ℝ} (hm : 0 < m) {p : ℝ} (hp : 0 < p) :
    deBroglieWavelength p = comptonWavelength m ↔ p = m * c := by
  unfold deBroglieWavelength comptonWavelength
  have hp_ne    : p ≠ 0 := hp.ne'
  have hm_ne    : m ≠ 0 := hm.ne'
  have hc_ne    : c ≠ 0 := c_pos.ne'
  have hmc_ne   : m * c ≠ 0 := mul_ne_zero hm_ne hc_ne
  have hhbar_ne : hbar ≠ 0 := hbar_pos.ne'
  rw [div_eq_div_iff hp_ne hmc_ne]
  constructor
  · intro h
    -- `hbar * (m * c) = hbar * p` ⇒ `m * c = p` ⇒ `p = m * c`.
    have : m * c = p := mul_left_cancel₀ hhbar_ne h
    linarith
  · intro h
    rw [h]

/-! ## Headline theorem: de Broglie = Compton iff equipartition

    We now assemble the main result.  Using `forwardFraction_sq_eq`
    to rewrite the fraction into closed form, the equivalence becomes
    a purely algebraic manipulation of `(pc)² / ((pc)² + (mc²)²)`. -/

/-- **TheoremCandidate T-β — de Broglie equals Compton iff
    tick-counting is equipartitioned.**

    For a massive particle at positive momentum, the reduced de Broglie
    wavelength `ℏ/p` equals the reduced Compton wavelength `ℏ/(m c)`
    if and only if the squared forward-tick fraction equals exactly
    `1/2`, i.e. half of the ticks advance the pattern forward and
    half feed the zitterbewegung rest-energy sector.

    The result links an equation between emergent *wavelengths*
    (`λ_dB`, `λ_C`) with a symmetry between the two *channels*
    (forward-advance vs. internal oscillation) of the discrete
    substrate.  Read through the lens of `Emergence/DispersionFromLattice`,
    equipartition of tick-fractions is the kinematic fingerprint of
    the de-Broglie=Compton regime. -/
theorem deBroglie_equals_compton_iff_equipartition
    {m : ℝ} (hm : 0 < m) {p : ℝ} (hp : 0 < p) :
    deBroglieWavelength p = comptonWavelength m ↔
    forwardFraction p m ^ 2 = 1 / 2 := by
  -- Reduce left-hand side to the momentum criterion.
  rw [deBroglie_equals_compton_iff_momentum hm hp]
  -- Closed form for the forward-fraction squared.
  rw [forwardFraction_sq_eq]
  -- Useful positivity facts.
  have hm_ne  : m ≠ 0 := hm.ne'
  have hp_ne  : p ≠ 0 := hp.ne'
  have hc_pos : 0 < c := c_pos
  have hc_ne  : c ≠ 0 := hc_pos.ne'
  have hpc_pos : 0 < p * c := mul_pos hp hc_pos
  have hmc_pos : 0 < m * c := mul_pos hm hc_pos
  have hmc2_pos : 0 < m * c ^ 2 := by positivity
  have hE_pos : 0 < relativisticEnergy p m :=
    relativisticEnergy_pos_of_mass hm_ne p
  have hE_ne  : relativisticEnergy p m ≠ 0 := hE_pos.ne'
  have hE_sq_pos : 0 < (relativisticEnergy p m) ^ 2 := by positivity
  have hE_sq_ne  : (relativisticEnergy p m) ^ 2 ≠ 0 := hE_sq_pos.ne'
  -- Explicit value of `E²`.
  have hE_sq : (relativisticEnergy p m) ^ 2 = (p * c) ^ 2 + (m * c ^ 2) ^ 2 :=
    relativisticEnergy_sq_eq p m
  -- Now unfold to arithmetic: `p = m c ↔ (pc)² / E² = 1/2`.
  constructor
  · -- Forward direction: `p = m c` ⇒ `(pc)²/E² = 1/2`.
    intro hpmc
    -- At `p = m c` we have `(pc)² = (mc²)² = m²c⁴`, so
    -- `E² = 2·(pc)²`, i.e. `(pc)²/E² = 1/2`.
    have hpc_eq : p * c = m * c ^ 2 := by
      rw [hpmc]; ring
    have hE_sq_split : (relativisticEnergy p m) ^ 2 = 2 * (p * c) ^ 2 := by
      rw [hE_sq]
      rw [show (m * c ^ 2) ^ 2 = (p * c) ^ 2 from by rw [hpc_eq]]
      ring
    rw [hE_sq_split]
    have hpc_sq_pos : 0 < (p * c) ^ 2 := by positivity
    have hpc_sq_ne  : (p * c) ^ 2 ≠ 0 := hpc_sq_pos.ne'
    field_simp
  · -- Reverse direction: `(pc)²/E² = 1/2` ⇒ `p = m c`.
    intro hfrac
    -- Clear the denominator: `2(pc)² = E²`, hence `(pc)² = (mc²)²`.
    have h2 : 2 * (p * c) ^ 2 = (relativisticEnergy p m) ^ 2 := by
      have : (p * c) ^ 2 = (1/2) * (relativisticEnergy p m) ^ 2 := by
        have hE_sq_ne' : (relativisticEnergy p m) ^ 2 ≠ 0 := hE_sq_ne
        field_simp at hfrac
        linarith
      linarith
    have hpc_sq_eq_mc2_sq : (p * c) ^ 2 = (m * c ^ 2) ^ 2 := by
      have : 2 * (p * c) ^ 2 = (p * c) ^ 2 + (m * c ^ 2) ^ 2 := by
        rw [h2, hE_sq]
      linarith
    -- At positive quantities, equality of squares ⇒ equality.
    have hpc_eq_mc2 : p * c = m * c ^ 2 := by
      have h1 := sq_nonneg (p * c - m * c ^ 2)
      have h2 := sq_nonneg (p * c + m * c ^ 2)
      have expand1 : (p * c - m * c ^ 2) ^ 2
                      = (p * c) ^ 2 - 2 * (p * c) * (m * c ^ 2)
                        + (m * c ^ 2) ^ 2 := by ring
      -- We know both `p·c > 0` and `m·c² > 0`; from equality of squares
      -- over positive quantities, the base must be equal.
      have : (p * c - m * c ^ 2) * (p * c + m * c ^ 2) = 0 := by
        have : (p * c) ^ 2 - (m * c ^ 2) ^ 2 = 0 := by
          rw [hpc_sq_eq_mc2_sq]; ring
        linarith [this,
          show (p * c - m * c ^ 2) * (p * c + m * c ^ 2)
                = (p * c) ^ 2 - (m * c ^ 2) ^ 2 from by ring]
      -- The sum `p c + m c²` is strictly positive, so it is nonzero.
      have hsum_pos : 0 < p * c + m * c ^ 2 := by linarith [hpc_pos, hmc2_pos]
      have hsum_ne  : p * c + m * c ^ 2 ≠ 0 := hsum_pos.ne'
      -- Hence the first factor is zero.
      have hdiff : p * c - m * c ^ 2 = 0 := by
        rcases mul_eq_zero.mp this with h | h
        · exact h
        · exact absurd h hsum_ne
      linarith
    -- Final step: `p c = m c²` ⇒ `p = m c`.
    have : p * c = (m * c) * c := by rw [hpc_eq_mc2]; ring
    have hp_eq : p = m * c := by
      have := mul_right_cancel₀ hc_ne this
      exact this
    exact hp_eq

/-! ## Corollaries

    Two immediate consequences of the headline equivalence that make
    the physics clearer.  First, at the equipartition point the
    zitterbewegung fraction also equals `1/2` (complementary to the
    forward fraction).  Second, the common wavelength value at the
    crossing is `λ_dB = λ_C = ℏ / (m c)`. -/

/-- At the equipartition regime the zitterbewegung fraction is also
    exactly `1/2` — the two channels carry equal energy shares. -/
theorem zitterbewegungFraction_at_equipartition
    {m : ℝ} (hm : 0 < m) {p : ℝ} (hp : 0 < p)
    (h : deBroglieWavelength p = comptonWavelength m) :
    zitterbewegungFraction p m = 1 / 2 := by
  have hff_sq : forwardFraction p m ^ 2 = 1 / 2 :=
    (deBroglie_equals_compton_iff_equipartition hm hp).mp h
  unfold zitterbewegungFraction
  linarith [hff_sq]

/-- At the de-Broglie=Compton crossing the common wavelength value
    is `ℏ / (m c)` — the Compton wavelength itself.  This is the
    "natural length" at which quantum (wave) and rest-mass (particle)
    character coincide for a given mass. -/
theorem deBroglieWavelength_at_equipartition
    {m : ℝ} (_hm : 0 < m) {p : ℝ} (_hp : 0 < p)
    (h : deBroglieWavelength p = comptonWavelength m) :
    deBroglieWavelength p = hbar / (m * c) := by
  rw [h]
  rfl

end OmegaTheory.Emergence
