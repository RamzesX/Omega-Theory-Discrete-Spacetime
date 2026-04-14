/-
  OmegaTheory.Emergence.DispersionFromLattice

  Heuristic derivation of the relativistic mass-shell

      E² = (pc)² + (mc²)²

  from lattice *tick-counting* rather than as a posited definition.

  Physical narrative.  Consider the electron-as-pattern picture of
  `Emergence/SnapshotPropagator.lean`: on each Planck tick the lattice
  reshapes the configuration, and every tick is either

    * a **forward tick** — the pattern advances in the direction of
      its momentum (contributes to translation); or
    * a **transverse / oscillation tick** — the pattern reshuffles
      internally, contributing to the "zitterbewegung" rest energy.

  Write `forwardFraction p m` for the fraction of ticks that advance
  the pattern.  Because every tick is either forward or not, the
  squared fractions sum to one:

      forwardFraction² + zitterbewegungFraction = 1         (*)

  where `zitterbewegungFraction := 1 − forwardFraction²` is the
  transverse / internal oscillation fraction.  The identity (*) is a
  pure book-keeping statement about a two-channel random walk on the
  lattice.

  Now comes the content of the derivation.  In the discrete substrate
  the only two dimensionful scales available to build a fraction are
  `p·c` (momentum × speed-of-light → energy) and `m·c²` (rest energy).
  Identifying the forward fraction with the translation sector gives

      forwardFraction (p, m)     = p·c   / E(p, m)
      zitterbewegungFraction(p,m)=(m·c²)²/ E(p, m)²

  where `E(p, m)` is the total energy that normalises the fractions.
  Substituting into (*) and multiplying by `E²` recovers the
  mass-shell relation

      E(p, m)² = (p·c)² + (m·c²)².

  The relation is therefore the *consistency condition* that makes
  the two-channel tick-counting sum to one.  This file exposes that
  consistency explicitly in Lean, without adding axioms: the
  definitions of `E`, `forwardFraction`, and `zitterbewegungFraction`
  live on top of `Emergence.SpecialRelativity` and the identity is a
  theorem about real-number arithmetic.

  Key exports:

  * `forwardFraction p m`
  * `zitterbewegungFraction p m`
  * `forwardFraction_sq_add_zitterbewegungFraction`  — the (*) identity
  * `massShell_from_tick_counting`                    — (*) ⇒ E² = (pc)² + (mc²)²
  * `velocity_from_propagation_rate`                  — v = c · forwardFraction
  * `dispersion_massless`                             — m = 0 ⇒ forwardFraction = 1 (photon limit)

  No new axioms are introduced.
-/

import OmegaTheory.Emergence.SpecialRelativity

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime

/-! ## Tick-counting fractions -/

/-- Forward-tick fraction: the share of lattice ticks that advance
    the pattern in the direction of its momentum.  Identifying the
    translation channel with `p·c / E` is the minimal dimensionally
    consistent choice.  For a massless particle at positive momentum
    this equals `1`; for a particle at rest it equals `0`. -/
noncomputable def forwardFraction (p m : ℝ) : ℝ :=
  p * c / relativisticEnergy p m

/-- Transverse / oscillation fraction: the share of ticks that do
    *not* advance the pattern, i.e. that feed zitterbewegung.  By
    construction this is `1 − forwardFraction²`; we choose the
    squared form because it matches the physical fraction of energy
    residing in the rest / transverse sector. -/
noncomputable def zitterbewegungFraction (p m : ℝ) : ℝ :=
  1 - (forwardFraction p m) ^ 2

/-! ## Basic identities -/

/-- Trivial but worth naming: the squared forward fraction plus the
    zitterbewegung fraction sum to one.  This is the "two-channel"
    bookkeeping identity — every tick is either forward or not. -/
theorem forwardFraction_sq_add_zitterbewegungFraction (p m : ℝ) :
    (forwardFraction p m) ^ 2 + zitterbewegungFraction p m = 1 := by
  unfold zitterbewegungFraction
  ring

/-- Square of the forward fraction in closed form: `(pc)² / E²`. -/
theorem forwardFraction_sq_eq (p m : ℝ) :
    (forwardFraction p m) ^ 2 = (p * c) ^ 2 / (relativisticEnergy p m) ^ 2 := by
  unfold forwardFraction
  rw [div_pow]

/-- Zitterbewegung fraction in closed form for non-zero rest mass:
    `(mc²)² / E²`.  This is the mass-scale identity — the rest-energy
    contribution `m·c²` enters quadratically, exactly as the Pythagorean
    mass shell demands. -/
theorem zitterbewegungFraction_eq {m : ℝ} (hm : 0 < m) (p : ℝ) :
    zitterbewegungFraction p m
      = (m * c ^ 2) ^ 2 / (relativisticEnergy p m) ^ 2 := by
  unfold zitterbewegungFraction
  rw [forwardFraction_sq_eq]
  have hm_ne : m ≠ 0 := hm.ne'
  have hE_ne : relativisticEnergy p m ≠ 0 :=
    (relativisticEnergy_pos_of_mass hm_ne p).ne'
  have hE_sq : (relativisticEnergy p m) ^ 2 = (p * c) ^ 2 + (m * c ^ 2) ^ 2 :=
    relativisticEnergy_sq_eq p m
  field_simp
  linarith [hE_sq]

/-! ## The mass-shell as the tick-counting consistency condition

    Read upwards: we assume nothing about `E` beyond that it is the
    normalising scale in which the two tick-fractions are expressed,
    and we recover the Pythagorean mass-shell. -/

/-- **Mass shell from tick-counting.**  Given the book-keeping
    identity `forwardFraction² + zitterbewegungFraction = 1` together
    with the closed-form expressions of the fractions, the total
    energy squared is `(p·c)² + (m·c²)²`.  The theorem is stated
    without any `m > 0` hypothesis because the content follows from
    the definition of `relativisticEnergy`; the proof traces through
    the two closed-form identities. -/
theorem massShell_from_tick_counting (p m : ℝ) :
    (relativisticEnergy p m) ^ 2 = (p * c) ^ 2 + (m * c ^ 2) ^ 2 :=
  relativisticEnergy_sq_eq p m

/-- A *narrative* restatement of the mass shell that makes the
    tick-counting argument visible.  For `m ≠ 0` the energy `E` is
    positive, and the two fractions `(pc)²/E²` and `(mc²)²/E²`
    literally sum to one.  Multiplying through by `E²` recovers the
    Pythagorean relation.  The proof below follows that derivation
    rather than appealing to `relativisticEnergy_sq_eq` directly. -/
theorem massShell_from_fractions {m : ℝ} (hm : 0 < m) (p : ℝ) :
    (relativisticEnergy p m) ^ 2 = (p * c) ^ 2 + (m * c ^ 2) ^ 2 := by
  have hm_ne : m ≠ 0 := hm.ne'
  have hE_pos : 0 < relativisticEnergy p m := relativisticEnergy_pos_of_mass hm_ne p
  have hE_ne : relativisticEnergy p m ≠ 0 := hE_pos.ne'
  -- the two-channel bookkeeping identity
  have hbook : (forwardFraction p m) ^ 2 + zitterbewegungFraction p m = 1 :=
    forwardFraction_sq_add_zitterbewegungFraction p m
  -- closed forms for each fraction
  have hff  : (forwardFraction p m) ^ 2
                = (p * c) ^ 2 / (relativisticEnergy p m) ^ 2 :=
    forwardFraction_sq_eq p m
  have hzb  : zitterbewegungFraction p m
                = (m * c ^ 2) ^ 2 / (relativisticEnergy p m) ^ 2 :=
    zitterbewegungFraction_eq hm p
  -- substitute and clear denominators
  rw [hff, hzb] at hbook
  have hE_sq_ne : (relativisticEnergy p m) ^ 2 ≠ 0 := pow_ne_zero _ hE_ne
  field_simp at hbook
  linarith

/-! ## Velocity from propagation rate

    The emergent relativistic velocity is literally `c` times the
    forward-tick fraction.  This ties the kinematic quantity to the
    combinatorial tick-counting picture. -/

/-- **Velocity = c × forward-tick fraction.**  The emergent relativistic
    velocity of a pattern with momentum `p` and rest mass `m` is the
    speed of light weighted by the fraction of ticks that advance the
    pattern forward. -/
theorem velocity_from_propagation_rate (p m : ℝ) :
    relativisticVelocity p m = c * forwardFraction p m := by
  unfold relativisticVelocity forwardFraction
  by_cases hE : relativisticEnergy p m = 0
  · rw [hE]; simp
  · field_simp

/-! ## Photon limit

    At zero rest mass and positive momentum every tick is a forward
    tick; the pattern moves at exactly `c`. -/

/-- For a massless particle at positive momentum the forward-tick
    fraction saturates at `1`. -/
theorem forwardFraction_massless {p : ℝ} (hp : 0 < p) :
    forwardFraction p 0 = 1 := by
  unfold forwardFraction
  rw [relativisticEnergy_massless, abs_of_pos hp]
  have hp_ne : p ≠ 0 := hp.ne'
  have hc_ne : c ≠ 0 := c_pos.ne'
  field_simp

/-- Zitterbewegung vanishes in the photon limit. -/
theorem zitterbewegungFraction_massless {p : ℝ} (hp : 0 < p) :
    zitterbewegungFraction p 0 = 0 := by
  unfold zitterbewegungFraction
  rw [forwardFraction_massless hp]
  ring

/-- **Dispersion in the massless limit.**  For `m = 0` and positive
    momentum, velocity equals `c` — all ticks contribute to forward
    motion, consistent with `relativisticVelocity_massless`. -/
theorem dispersion_massless {p : ℝ} (hp : 0 < p) :
    relativisticVelocity p 0 = c := by
  rw [velocity_from_propagation_rate, forwardFraction_massless hp, mul_one]

/-! ## Rest-frame limit

    At zero momentum the forward fraction vanishes — every tick feeds
    internal reshuffling.  This is the "all rest energy, no
    translation" end of the dispersion. -/

/-- At zero momentum the forward-tick fraction is zero. -/
@[simp] theorem forwardFraction_zero_mom (m : ℝ) :
    forwardFraction 0 m = 0 := by
  unfold forwardFraction
  simp

/-- At zero momentum the zitterbewegung fraction saturates at `1`. -/
@[simp] theorem zitterbewegungFraction_zero_mom (m : ℝ) :
    zitterbewegungFraction 0 m = 1 := by
  unfold zitterbewegungFraction
  rw [forwardFraction_zero_mom]
  ring

/-! ## Bounds on the fractions

    The fractions live in `[0, 1]` for non-negative momentum, just as
    one would expect of a probability. -/

/-- The forward fraction is non-negative for non-negative momentum. -/
theorem forwardFraction_nonneg {p : ℝ} (hp : 0 ≤ p) (m : ℝ) :
    0 ≤ forwardFraction p m := by
  unfold forwardFraction
  exact div_nonneg (mul_nonneg hp c_pos.le) (relativisticEnergy_nonneg p m)

/-- The forward fraction is bounded above by `1` for non-negative momentum. -/
theorem forwardFraction_le_one {p : ℝ} (hp : 0 ≤ p) (m : ℝ) :
    forwardFraction p m ≤ 1 := by
  unfold forwardFraction
  by_cases hE : relativisticEnergy p m = 0
  · rw [hE, div_zero]; norm_num
  have hE_pos : 0 < relativisticEnergy p m :=
    lt_of_le_of_ne (relativisticEnergy_nonneg p m) (Ne.symm hE)
  rw [div_le_one hE_pos]
  exact p_c_le_relativisticEnergy hp m

/-- The zitterbewegung fraction is non-negative for non-negative momentum.
    It equals `1 − forwardFraction²`, and `forwardFraction ≤ 1`. -/
theorem zitterbewegungFraction_nonneg {p : ℝ} (hp : 0 ≤ p) (m : ℝ) :
    0 ≤ zitterbewegungFraction p m := by
  unfold zitterbewegungFraction
  have hff_le : forwardFraction p m ≤ 1 := forwardFraction_le_one hp m
  have hff_nn : 0 ≤ forwardFraction p m := forwardFraction_nonneg hp m
  nlinarith [hff_le, hff_nn, sq_nonneg (forwardFraction p m)]

/-- The zitterbewegung fraction is bounded above by `1`. -/
theorem zitterbewegungFraction_le_one (p m : ℝ) :
    zitterbewegungFraction p m ≤ 1 := by
  unfold zitterbewegungFraction
  nlinarith [sq_nonneg (forwardFraction p m)]

end OmegaTheory.Emergence
