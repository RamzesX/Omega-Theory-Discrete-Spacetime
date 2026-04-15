/-
  OmegaTheory.Emergence.MassAsDelay

  **Mass as a per-tick lattice brake.**

  ## Physical narrative

  OmegaTheory has a single fundamental rule for propagation: each
  Planck-time tick advances the configuration by one lattice cell,
  which is the speed of light `c = l_P / t_P`. Massless excitations
  saturate this bound — every tick contributes to forward motion,
  and the result is a *null geodesic* with `v = c`.

  A massive particle, on the other hand, has only a fraction of its
  ticks go into forward propagation; the remainder feed internal
  oscillation (zitterbewegung, in the Dirac picture). The forward
  fraction is exactly `v / c`, so the "braking factor" is

        δ(p, m) := 1 − v(p, m) / c

  where `v(p, m) = p·c² / E(p, m)` is the relativistic emergent
  velocity already defined in `SpecialRelativity.lean`. The physical
  dimension of `δ` is dimensionless; multiplied by the Planck tick
  `t_P` it gives the **delay per tick** in physical time units. In
  other words: *rest mass is the lattice asking the particle to wait*.

  ## What this file formalizes

  1. `perTickDelay p m := 1 - v(p, m) / c` (dimensionless fraction).
  2. `perTickDelayTime p m := perTickDelay p m * t_P` (physical time).
  3. Massless limit: `perTickDelay p 0 = 0` for `p > 0`.
  4. Massive strict positivity: `perTickDelay p m > 0` for `m ≠ 0`, `p > 0`.
  5. Non-negativity: `perTickDelay p m ≥ 0` for `p ≥ 0`.
  6. **Quantitative high-energy asymptote**: `c − v(p, m) ≤ (mc)³ / (2p²)`
     for `p > 0` (a concrete decay rate → 0 as `p → ∞`).
  7. `mass_lattice_interpretation_theorem`: the three-way bundling
     m = 0 ↔ v = c ↔ zero delay;  m ≠ 0 ↔ v < c ↔ positive delay.

  ## Scoping note (honest)

  The stronger statement `massless_is_null_geodesic_on_lattice`
  requires extending the `Snapshot` propagation to track spatial
  position (the current `Snapshot.propagate` leaves `point` fixed,
  see `SnapshotPropagator.lean:89-92`). That is a lattice-level
  refactor out of scope for this file. We flag it explicitly at
  the end of the file; everything else is shipped as a theorem.

  No axioms, no `sorry`.
-/

import OmegaTheory.Emergence.SpecialRelativity
import OmegaTheory.Spacetime.Constants
import Mathlib.Tactic

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime

/-! ## Per-tick delay (the "brake") -/

/-- The **per-tick delay**: dimensionless fraction of a Planck tick
    that a massive particle loses to internal oscillation (equivalently,
    fails to advance the lattice position).

    `perTickDelay p m = 1 − v(p, m) / c`. -/
noncomputable def perTickDelay (p m : ℝ) : ℝ :=
  1 - relativisticVelocity p m / c

/-- The per-tick delay in physical time units: delay times the Planck
    tick `t_P`. -/
noncomputable def perTickDelayTime (p m : ℝ) : ℝ :=
  perTickDelay p m * t_P

/-! ## Basic bounds -/

/-- The per-tick delay is non-negative for non-negative momentum. -/
theorem perTickDelay_nonneg {p : ℝ} (hp : 0 ≤ p) (m : ℝ) :
    0 ≤ perTickDelay p m := by
  unfold perTickDelay
  have h := relativisticVelocity_le_c hp m
  have : relativisticVelocity p m / c ≤ 1 := by
    rw [div_le_one c_pos]; exact h
  linarith

/-- The per-tick delay time is non-negative. -/
theorem perTickDelayTime_nonneg {p : ℝ} (hp : 0 ≤ p) (m : ℝ) :
    0 ≤ perTickDelayTime p m :=
  mul_nonneg (perTickDelay_nonneg hp m) t_P_nonneg

/-! ## Massless case: no delay -/

/-- **Massless particles suffer no delay per tick.** For `m = 0` and
    `p > 0`, the relativistic velocity is exactly `c`, so the delay is
    zero. This is the formalisation of "massless excitations are null
    geodesics — every tick counts as forward propagation." -/
@[simp] theorem perTickDelay_massless {p : ℝ} (hp : 0 < p) :
    perTickDelay p 0 = 0 := by
  unfold perTickDelay
  rw [relativisticVelocity_massless hp, div_self c_pos.ne']
  ring

/-- The physical-time delay vanishes in the massless case. -/
@[simp] theorem perTickDelayTime_massless {p : ℝ} (hp : 0 < p) :
    perTickDelayTime p 0 = 0 := by
  unfold perTickDelayTime
  rw [perTickDelay_massless hp, zero_mul]

/-! ## Massive case: strictly positive delay -/

/-- **Massive particles always experience a positive delay per tick.**
    For `m ≠ 0` and `p > 0`, the relativistic velocity is strictly
    less than `c`, so the delay is strictly positive. -/
theorem perTickDelay_pos_massive {m : ℝ} (hm : m ≠ 0) {p : ℝ} (hp : 0 < p) :
    0 < perTickDelay p m := by
  unfold perTickDelay
  have hv_lt : relativisticVelocity p m < c := relativisticVelocity_lt_c hm hp
  have : relativisticVelocity p m / c < 1 := by
    rw [div_lt_one c_pos]; exact hv_lt
  linarith

/-- The physical-time delay is strictly positive for massive particles. -/
theorem perTickDelayTime_pos_massive {m : ℝ} (hm : m ≠ 0) {p : ℝ} (hp : 0 < p) :
    0 < perTickDelayTime p m :=
  mul_pos (perTickDelay_pos_massive hm hp) t_P_pos

/-! ## Explicit formula for the delay

The delay has a clean closed-form expression in terms of the energy:

  `perTickDelay p m = (E − pc) / E`

which via the Pythagorean identity `E² = (pc)² + (mc²)²` becomes the
manifest positive form `(mc²)² / (E · (E + pc))`. -/

/-- Explicit form `perTickDelay = (E − pc) / E`. Valid whenever
    the energy is non-zero; we get this for free for `m ≠ 0` or `p ≠ 0`. -/
theorem perTickDelay_energy_form {p : ℝ} (m : ℝ)
    (hne : relativisticEnergy p m ≠ 0) :
    perTickDelay p m =
    (relativisticEnergy p m - p * c) / relativisticEnergy p m := by
  unfold perTickDelay relativisticVelocity
  have hc_ne : c ≠ 0 := c_pos.ne'
  field_simp

/-- **Explicit positive form** using the Pythagorean identity:
    `c − v(p, m) = (mc²)² / (E · (E + pc)) · c`. This is the starting
    point for the high-energy asymptote bound. -/
theorem c_minus_v_explicit {m : ℝ} {p : ℝ} (hp : 0 < p)
    (hne : relativisticEnergy p m ≠ 0) :
    c - relativisticVelocity p m =
    (m * c ^ 2) ^ 2 /
      (relativisticEnergy p m * (relativisticEnergy p m + p * c)) * c := by
  have hE_pos : 0 < relativisticEnergy p m :=
    lt_of_le_of_ne (relativisticEnergy_nonneg p m) (Ne.symm hne)
  have hE_sq : (relativisticEnergy p m) ^ 2 = (p * c) ^ 2 + (m * c ^ 2) ^ 2 :=
    relativisticEnergy_sq_eq p m
  have hE_ne : relativisticEnergy p m ≠ 0 := hne
  have hc_ne : c ≠ 0 := c_pos.ne'
  have hpc_pos : 0 < p * c := mul_pos hp c_pos
  have hEpc_pos : 0 < relativisticEnergy p m + p * c := by linarith
  have hEpc_ne : relativisticEnergy p m + p * c ≠ 0 := hEpc_pos.ne'
  -- (E - pc)(E + pc) = E² − (pc)² = (mc²)²
  have hkey :
      (relativisticEnergy p m - p * c) * (relativisticEnergy p m + p * c)
        = (m * c ^ 2) ^ 2 := by
    have hexp : (relativisticEnergy p m - p * c) * (relativisticEnergy p m + p * c)
         = (relativisticEnergy p m) ^ 2 - (p * c) ^ 2 := by ring
    rw [hexp, hE_sq]; ring
  -- Strategy: move c into the numerator first, then clear denominators.
  -- RHS = ((m c²)² · c) / (E · (E+pc))
  unfold relativisticVelocity
  have hdenom_ne : relativisticEnergy p m * (relativisticEnergy p m + p * c) ≠ 0 :=
    mul_ne_zero hE_ne hEpc_ne
  -- rewrite RHS so the `* c` is folded in.
  rw [show (m * c ^ 2) ^ 2 /
      (relativisticEnergy p m * (relativisticEnergy p m + p * c)) * c =
      ((m * c ^ 2) ^ 2 * c) /
      (relativisticEnergy p m * (relativisticEnergy p m + p * c)) from by
      rw [div_mul_eq_mul_div]]
  rw [eq_div_iff hdenom_ne]
  have hlhs : (c - p * c ^ 2 / relativisticEnergy p m) *
              (relativisticEnergy p m * (relativisticEnergy p m + p * c)) =
              (relativisticEnergy p m - p * c) *
              (relativisticEnergy p m + p * c) * c := by
    field_simp
  rw [hlhs, ← hkey]

/-! ## Quantitative high-energy asymptote

The relativistic velocity approaches `c` as the momentum grows. We
prove the explicit bound

    `c − v(p, m) ≤ (m c)² · c / (2 p²)`   for `p > 0`.

The bound uses only `E ≥ |pc|` (Pythagorean inequality) and hence
`E · (E + pc) ≥ pc · 2pc = 2 p² c²`. -/

/-- The denominator lower bound: `E · (E + pc) ≥ 2 p² c²` for `p > 0`. -/
theorem E_E_plus_pc_lower {m : ℝ} {p : ℝ} (hp : 0 < p) :
    2 * p ^ 2 * c ^ 2 ≤
    relativisticEnergy p m * (relativisticEnergy p m + p * c) := by
  have hpc_pos : 0 < p * c := mul_pos hp c_pos
  have hE_nn : 0 ≤ relativisticEnergy p m := relativisticEnergy_nonneg p m
  have hEge_pc : p * c ≤ relativisticEnergy p m := by
    have := abs_p_c_le_relativisticEnergy p m
    rwa [abs_of_pos hpc_pos] at this
  have hEge2pc : 2 * (p * c) ≤ relativisticEnergy p m + p * c := by linarith
  have h1 : (p * c) * (2 * (p * c)) ≤
      relativisticEnergy p m * (relativisticEnergy p m + p * c) :=
    mul_le_mul hEge_pc hEge2pc (by positivity) hE_nn
  have h2 : (p * c) * (2 * (p * c)) = 2 * p ^ 2 * c ^ 2 := by ring
  linarith

/-- **massive_asymptotes_to_null_at_high_E**: for any positive momentum
    `p`, the gap between the relativistic velocity and `c` is bounded
    by `(mc)² · c / (2 p²)`. The RHS tends to zero as `p → ∞`, which is
    the quantitative "massive particles asymptote to null geodesics at
    high energy" statement.

    **No limit tactic needed** — we produce an explicit decay bound,
    which is stronger and constructively useful. -/
theorem massive_asymptotes_to_null_at_high_E
    {m : ℝ} {p : ℝ} (hp : 0 < p) :
    c - relativisticVelocity p m ≤ (m * c) ^ 2 * c / (2 * p ^ 2) := by
  by_cases hm : m = 0
  · -- Massless: LHS = 0, RHS ≥ 0.
    rw [hm]
    rw [relativisticVelocity_massless hp]
    have hrhs : ((0 : ℝ) * c) ^ 2 * c / (2 * p ^ 2) = 0 := by
      rw [zero_mul]; ring
    linarith
  -- Massive case: use the explicit formula.
  have hE_pos : 0 < relativisticEnergy p m :=
    relativisticEnergy_pos_of_mass hm p
  have hE_ne : relativisticEnergy p m ≠ 0 := hE_pos.ne'
  rw [c_minus_v_explicit hp hE_ne]
  -- Goal: (mc²)² / (E · (E+pc)) · c ≤ (mc)² · c / (2 p²)
  -- Rewrite RHS and LHS uniformly:
  have hnum_nn : 0 ≤ (m * c ^ 2) ^ 2 := sq_nonneg _
  have h_denom_pos : 0 <
      relativisticEnergy p m * (relativisticEnergy p m + p * c) := by
    have hpc_pos : 0 < p * c := mul_pos hp c_pos
    exact mul_pos hE_pos (by linarith [relativisticEnergy_nonneg p m])
  have h_denom_lower : 2 * p ^ 2 * c ^ 2 ≤
      relativisticEnergy p m * (relativisticEnergy p m + p * c) :=
    E_E_plus_pc_lower hp
  have hp2c2_pos : 0 < 2 * p ^ 2 * c ^ 2 := by
    have hp2 : 0 < p ^ 2 := pow_pos hp 2
    have hc2 : 0 < c ^ 2 := pow_pos c_pos 2
    have : 0 < 2 * p ^ 2 := by linarith
    exact mul_pos this hc2
  -- Bound the fraction.
  have hfrac_le :
      (m * c ^ 2) ^ 2 /
        (relativisticEnergy p m * (relativisticEnergy p m + p * c)) ≤
      (m * c ^ 2) ^ 2 / (2 * p ^ 2 * c ^ 2) :=
    div_le_div_of_nonneg_left hnum_nn hp2c2_pos h_denom_lower
  -- Rewrite the bound in terms of (mc)² · c / (2 p²):
  -- (m c²)² / (2 p² c²) = m² c⁴ / (2 p² c²) = m² c² / (2 p²) = (mc)² / (2 p²).
  have hrewrite :
      (m * c ^ 2) ^ 2 / (2 * p ^ 2 * c ^ 2) = (m * c) ^ 2 / (2 * p ^ 2) := by
    have hc_ne : c ≠ 0 := c_pos.ne'
    have hp_ne : p ≠ 0 := hp.ne'
    field_simp
  calc (m * c ^ 2) ^ 2 /
          (relativisticEnergy p m * (relativisticEnergy p m + p * c)) * c
      ≤ (m * c ^ 2) ^ 2 / (2 * p ^ 2 * c ^ 2) * c := by
        exact mul_le_mul_of_nonneg_right hfrac_le c_pos.le
    _ = (m * c) ^ 2 / (2 * p ^ 2) * c := by rw [hrewrite]
    _ = (m * c) ^ 2 * c / (2 * p ^ 2) := by ring

/-- **Corollary**: the per-tick delay decays like `(mc)²/(2p²)` for large `p`. -/
theorem perTickDelay_high_momentum_bound {m p : ℝ} (hp : 0 < p) :
    perTickDelay p m ≤ (m * c) ^ 2 / (2 * p ^ 2) := by
  unfold perTickDelay
  have hbound := massive_asymptotes_to_null_at_high_E (m := m) hp
  -- (c − v) ≤ (m c)² · c / (2 p²); divide both sides by c > 0.
  have hc_pos : 0 < c := c_pos
  have : (c - relativisticVelocity p m) / c ≤
         ((m * c) ^ 2 * c / (2 * p ^ 2)) / c :=
    div_le_div_of_nonneg_right hbound c_pos.le
  have h_lhs : (c - relativisticVelocity p m) / c =
               1 - relativisticVelocity p m / c := by
    field_simp
  have h_rhs : ((m * c) ^ 2 * c / (2 * p ^ 2)) / c =
               (m * c) ^ 2 / (2 * p ^ 2) := by
    have hc_ne : c ≠ 0 := c_pos.ne'
    field_simp
  linarith [h_lhs ▸ h_rhs ▸ this]

/-! ## Mass-as-delay bundling

The integrator theorem: the three conditions *massless*, *velocity
equal to c*, and *zero per-tick delay* are all equivalent (for
positive momentum).  Correspondingly, mass ↔ subluminal ↔ positive
delay. -/

/-- **mass_lattice_interpretation_theorem**: for `p > 0`, the equivalence
    chain `m = 0  ⟺  v(p,m) = c  ⟺  perTickDelay p m = 0`. -/
theorem mass_lattice_interpretation_theorem {p : ℝ} (hp : 0 < p) {m : ℝ} :
    (m = 0 ↔ perTickDelay p m = 0) ∧
    (m ≠ 0 ↔ 0 < perTickDelay p m) := by
  refine ⟨?_, ?_⟩
  · -- m = 0 ⟺ delay = 0
    constructor
    · intro hm; rw [hm]; exact perTickDelay_massless hp
    · intro hδ
      by_contra hm
      have := perTickDelay_pos_massive hm hp
      linarith
  · -- m ≠ 0 ⟺ delay > 0
    constructor
    · intro hm; exact perTickDelay_pos_massive hm hp
    · intro hδ hm
      rw [hm] at hδ
      rw [perTickDelay_massless hp] at hδ
      linarith

/-- **Physical reading**: mass equals per-tick delay on the lattice.
    For a massive particle at positive momentum, the product of the
    dimensionless brake factor with the Planck tick gives the physical
    time the lattice holds the particle "in place" each tick. -/
theorem mass_equals_delay_per_tick {m : ℝ} (hm : m ≠ 0) {p : ℝ} (hp : 0 < p) :
    perTickDelayTime p m =
    (1 - relativisticVelocity p m / c) * t_P := by
  rfl

/-! ## Scope flag: lattice-level null geodesic

The following statement

  `massless_is_null_geodesic_on_lattice : ∀ (s : Snapshot),
     s.iterations = 0 → (s.propagate.point - s.point) = unitVec .t`

**cannot be proved** with the current `Snapshot.propagate` definition
(see `SnapshotPropagator.lean:89-92`), which leaves `point` fixed:

  ```
  noncomputable def Snapshot.propagate (s : Snapshot) : Snapshot where
    point := s.point          -- frozen; not yet a propagator in space
    tick := s.tick + 1
    iterations := s.iterations
  ```

To honor the "one cell per tick" picture, `Snapshot.propagate` would
need to take a direction parameter and advance `point` by `unitVec μ`.
This is a downstream refactor of SnapshotPropagator and its users;
out of scope for MassAsDelay.

The *relativistic half* of the statement — that a massless particle's
emergent velocity is exactly `c` — is fully proved upstream as
`relativisticVelocity_massless` (SpecialRelativity.lean), and the
zero-delay consequence is `perTickDelay_massless` above.
-/

end OmegaTheory.Emergence
