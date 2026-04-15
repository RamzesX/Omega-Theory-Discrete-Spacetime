/-
  OmegaTheory.Emergence.DispersionBridge

  Bridge between the relativistic mass-shell
      E(p, m) = √((pc)² + (mc²)²)
  (see `Emergence/SpecialRelativity.lean` and
  `Emergence/DispersionFromLattice.lean`) and the *Schrödinger*
  derivation target
      E_nonrel(p, m) = mc² + p²/(2m)
  used by the `schrodinger_prover` workstream.

  The link is the **non-relativistic limit**.  In the regime
  `|p| ≪ mc` the full relativistic energy reduces to the rest energy
  `mc²` plus the classical kinetic term `p²/(2m)`, with a controlled
  error of order `p⁴/(m³c²)`.  This file proves that bound rigorously
  and without any Taylor-series machinery — the argument is purely
  algebraic:

      B := mc² + p²/(2m),      A := relativisticEnergy p m = √((pc)² + (mc²)²)
      B² − A² = p⁴/(4m²),      and  A + B ≥ mc²  (for m > 0),
  hence  0 ≤ B − A = (B² − A²)/(A + B) ≤ p⁴/(4 m³ c²).

  The inequality `A ≤ B` is the well-known statement that the classical
  kinetic energy *over-estimates* the true relativistic kinetic
  energy (because the sqrt is concave after subtracting `mc²`).  The
  gap is fourth order in `p`, which is exactly what a Taylor expansion
  would predict but without the epsilon-delta overhead of Mathlib's
  analytic machinery.

  Deliverables of this file:

  * `nonRelativistic_energy_upper_bound`      — E ≤ mc² + p²/(2m)
  * `nonRelativistic_energy_lower_bound`      — mc² + p²/(2m) − p⁴/(4m³c²) ≤ E
  * `nonRelativistic_energy_approx`           — |E − (mc² + p²/(2m))| ≤ p⁴/(4m³c²)
  * `nonRelativistic_kinetic_term`            — E − mc² is squeezed by p²/(2m) from above
  * `schrodinger_is_nonrel_limit`             — hypothesis-carrying theorem:
      if a bound holds with coefficient `1/(2m)` on p², then it agrees with
      the relativistic mass shell to `O(p⁴)` in the non-relativistic limit.
  * `KleinGordonFromLatticeData`              — Prop-carrying placeholder
      structure for the relativistic Klein-Gordon equation from lattice,
      to be filled in by a later workstream.

  No new axioms.  No `sorry`.  Builds on `Emergence.SpecialRelativity`
  and `Emergence.DispersionFromLattice`.
-/

import OmegaTheory.Emergence.DispersionFromLattice

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime

/-! ## The classical kinetic expression -/

/-- The non-relativistic total energy `E_nonrel(p, m) = mc² + p²/(2m)`.
    This is the sum of rest energy and classical kinetic energy and it
    is the quantity whose operator form underlies Schrödinger's equation. -/
noncomputable def nonRelativisticEnergy (p m : ℝ) : ℝ :=
  m * c ^ 2 + p ^ 2 / (2 * m)

/-- Alias for the classical kinetic term `p²/(2m)`.  This is the
    coefficient slot that appears on the right-hand side of Schrödinger's
    equation; the bridge file below proves that it is exactly the
    non-relativistic limit of `E − mc²`. -/
noncomputable def schrodingerKineticTerm (p m : ℝ) : ℝ :=
  p ^ 2 / (2 * m)

@[simp] theorem nonRelativisticEnergy_eq_rest_plus_kinetic (p m : ℝ) :
    nonRelativisticEnergy p m = m * c ^ 2 + schrodingerKineticTerm p m := rfl

/-! ## Core algebraic identity

    The squared difference between the non-relativistic energy and the
    relativistic energy is exactly `p⁴/(4m²)`.  This is a purely
    elementary algebraic fact — it is the engine of the whole bridge. -/

/-- `(mc² + p²/(2m))² − E² = p⁴ / (4m²)` for `m ≠ 0`.
    This is the key quantitative identity of the file. -/
theorem nonRelativisticEnergy_sq_sub_relativisticEnergy_sq
    {m : ℝ} (hm : m ≠ 0) (p : ℝ) :
    (nonRelativisticEnergy p m) ^ 2 - (relativisticEnergy p m) ^ 2
      = p ^ 4 / (4 * m ^ 2) := by
  unfold nonRelativisticEnergy
  rw [relativisticEnergy_sq_eq]
  have h2m : (2 * m) ≠ 0 := mul_ne_zero two_ne_zero hm
  have hm2 : m ^ 2 ≠ 0 := pow_ne_zero _ hm
  field_simp
  ring

/-! ## Upper bound: classical kinetic energy over-estimates the true energy

    Because the squared gap is non-negative, the non-relativistic energy
    is never smaller than the relativistic energy.  This is the familiar
    qualitative statement that `p²/(2m)` over-counts kinetic energy at
    large momenta. -/

/-- `E ≤ mc² + p²/(2m)` for `m > 0`.  The non-relativistic kinetic term
    over-estimates the relativistic kinetic energy. -/
theorem nonRelativistic_energy_upper_bound
    {m : ℝ} (hm : 0 < m) (p : ℝ) :
    relativisticEnergy p m ≤ nonRelativisticEnergy p m := by
  have hm_ne : m ≠ 0 := hm.ne'
  -- non-negativity of both sides
  have hE_nn : 0 ≤ relativisticEnergy p m := relativisticEnergy_nonneg p m
  have hB_nn : 0 ≤ nonRelativisticEnergy p m := by
    unfold nonRelativisticEnergy
    have h1 : 0 ≤ m * c ^ 2 := mul_nonneg hm.le (sq_nonneg _)
    have h2 : 0 ≤ p ^ 2 / (2 * m) :=
      div_nonneg (sq_nonneg _) (by positivity)
    linarith
  -- squared inequality
  have hsq : (relativisticEnergy p m) ^ 2 ≤ (nonRelativisticEnergy p m) ^ 2 := by
    have hgap : (nonRelativisticEnergy p m) ^ 2 - (relativisticEnergy p m) ^ 2
        = p ^ 4 / (4 * m ^ 2) :=
      nonRelativisticEnergy_sq_sub_relativisticEnergy_sq hm_ne p
    have hgap_nn : 0 ≤ p ^ 4 / (4 * m ^ 2) :=
      div_nonneg (by positivity) (by positivity)
    linarith
  exact abs_le_of_sq_le_sq' hsq hB_nn |>.2

/-! ## Lower bound via the `B² − A² = (B−A)(B+A)` factorisation

    Combined with `A + B ≥ mc²` (which follows from `E ≥ 0` and
    `mc² ≤ B`), we get an explicit upper bound on the gap `B − A`. -/

/-- `mc² ≤ mc² + p²/(2m)` — trivial lower bound on the non-relativistic
    energy by the rest energy, valid for `m > 0`. -/
theorem rest_energy_le_nonRelativistic {m : ℝ} (hm : 0 < m) (p : ℝ) :
    m * c ^ 2 ≤ nonRelativisticEnergy p m := by
  unfold nonRelativisticEnergy
  have : 0 ≤ p ^ 2 / (2 * m) :=
    div_nonneg (sq_nonneg _) (by positivity)
  linarith

/-- `0 < mc² + p²/(2m)` for `m > 0`.  Used to make `(A+B)` positive. -/
theorem nonRelativisticEnergy_pos {m : ℝ} (hm : 0 < m) (p : ℝ) :
    0 < nonRelativisticEnergy p m := by
  have hrest : 0 < m * c ^ 2 := mul_pos hm (pow_pos c_pos 2)
  have := rest_energy_le_nonRelativistic hm p
  linarith

/-- `mc² ≤ E + (mc² + p²/(2m))` — a convenient denominator bound for the
    `(B²−A²)/(A+B)` factorisation.  Uses `0 ≤ E`. -/
theorem rest_energy_le_sum {m : ℝ} (hm : 0 < m) (p : ℝ) :
    m * c ^ 2 ≤ relativisticEnergy p m + nonRelativisticEnergy p m := by
  have hE_nn : 0 ≤ relativisticEnergy p m := relativisticEnergy_nonneg p m
  have hrest : m * c ^ 2 ≤ nonRelativisticEnergy p m :=
    rest_energy_le_nonRelativistic hm p
  linarith

/-- **The quantitative non-relativistic bound (lower side).**

    For `m > 0`,
        mc² + p²/(2m) − p⁴/(4 m³ c²)  ≤  E(p, m).

    This is the matching lower bound for
    `nonRelativistic_energy_upper_bound`: the classical energy
    over-estimates `E` by at most `p⁴/(4 m³ c²)`. -/
theorem nonRelativistic_energy_lower_bound
    {m : ℝ} (hm : 0 < m) (p : ℝ) :
    nonRelativisticEnergy p m - p ^ 4 / (4 * m ^ 3 * c ^ 2)
      ≤ relativisticEnergy p m := by
  set A := relativisticEnergy p m with hA
  set B := nonRelativisticEnergy p m with hB
  have hm_ne : m ≠ 0 := hm.ne'
  have hA_nn : 0 ≤ A := relativisticEnergy_nonneg p m
  have hB_pos : 0 < B := nonRelativisticEnergy_pos hm p
  have hAB_pos : 0 < A + B := by linarith
  -- (B - A)(A + B) = B² - A² = p⁴/(4m²)
  have hdiff_sq : B ^ 2 - A ^ 2 = p ^ 4 / (4 * m ^ 2) :=
    nonRelativisticEnergy_sq_sub_relativisticEnergy_sq hm_ne p
  have hprod : (B - A) * (A + B) = p ^ 4 / (4 * m ^ 2) := by
    have : (B - A) * (A + B) = B ^ 2 - A ^ 2 := by ring
    rw [this, hdiff_sq]
  -- hence  B - A = p⁴/(4m² (A + B))
  have hB_sub_A : B - A = p ^ 4 / (4 * m ^ 2) / (A + B) := by
    field_simp at hprod ⊢
    linarith
  -- denominator bound:  A + B ≥ mc²
  have hrest_pos : 0 < m * c ^ 2 := mul_pos hm (pow_pos c_pos 2)
  have hrest_le : m * c ^ 2 ≤ A + B := rest_energy_le_sum hm p
  -- numerator is p⁴ / (4m²) ≥ 0
  have hnum_nn : 0 ≤ p ^ 4 / (4 * m ^ 2) :=
    div_nonneg (by positivity) (by positivity)
  -- compare  p⁴ / (4m² (A+B))  ≤  p⁴ / (4m² · mc²) = p⁴ / (4 m³ c²)
  have hbound :
      p ^ 4 / (4 * m ^ 2) / (A + B) ≤ p ^ 4 / (4 * m ^ 2) / (m * c ^ 2) := by
    apply div_le_div_of_nonneg_left hnum_nn hrest_pos hrest_le
  have hsimp : p ^ 4 / (4 * m ^ 2) / (m * c ^ 2) = p ^ 4 / (4 * m ^ 3 * c ^ 2) := by
    have hm3 : m ^ 3 ≠ 0 := pow_ne_zero _ hm_ne
    have hc_ne : c ≠ 0 := c_pos.ne'
    field_simp
  -- stitch:  B - A ≤ p⁴ / (4 m³ c²)
  have : B - A ≤ p ^ 4 / (4 * m ^ 3 * c ^ 2) := by
    rw [hB_sub_A]; rw [hsimp] at hbound; exact hbound
  linarith

/-- **Packaged two-sided bound.**  For `m > 0`,

        |E(p, m) − (mc² + p²/(2m))|  ≤  p⁴ / (4 m³ c²).

    This is the formal statement that the Schrödinger rest+kinetic
    expression `mc² + p²/(2m)` is the relativistic energy up to a
    quartic remainder.  It is the quantitative form of "the
    1/(2m)-kinetic term is the non-relativistic limit of the
    relativistic mass shell". -/
theorem nonRelativistic_energy_approx
    {m : ℝ} (hm : 0 < m) (p : ℝ) :
    |relativisticEnergy p m - nonRelativisticEnergy p m|
      ≤ p ^ 4 / (4 * m ^ 3 * c ^ 2) := by
  have hU : relativisticEnergy p m ≤ nonRelativisticEnergy p m :=
    nonRelativistic_energy_upper_bound hm p
  have hL : nonRelativisticEnergy p m - p ^ 4 / (4 * m ^ 3 * c ^ 2)
            ≤ relativisticEnergy p m :=
    nonRelativistic_energy_lower_bound hm p
  rw [abs_le]
  refine ⟨?_, ?_⟩
  · -- -(p⁴/…) ≤ E - B
    linarith
  · -- E - B ≤ 0 ≤ p⁴/(4m³c²)
    have hnn : 0 ≤ p ^ 4 / (4 * m ^ 3 * c ^ 2) := by
      apply div_nonneg (by positivity)
      have hm3 : 0 < m ^ 3 := pow_pos hm 3
      have hc2 : 0 < c ^ 2 := pow_pos c_pos 2
      positivity
    linarith

/-! ## The kinetic term is the bridge to Schrödinger

    Below, "kinetic" is `E − mc²`.  The next two theorems say it is
    bounded *above* by `p²/(2m)` exactly (upper Taylor bound for
    √(1+x)) and *below* by `p²/(2m) − p⁴/(4m³c²)` (lower Taylor bound).

    This is the quantitative `1/(2m)` coefficient matching that the
    Schrödinger derivation relies on. -/

/-- `E − mc² ≤ p² / (2m)`  for  `m > 0`. -/
theorem relativisticKineticEnergy_le_classical
    {m : ℝ} (hm : 0 < m) (p : ℝ) :
    relativisticEnergy p m - m * c ^ 2 ≤ p ^ 2 / (2 * m) := by
  have := nonRelativistic_energy_upper_bound hm p
  unfold nonRelativisticEnergy at this
  linarith

/-- `p² / (2m) − p⁴ / (4 m³ c²) ≤ E − mc²`  for  `m > 0`. -/
theorem classical_le_relativisticKineticEnergy_plus_remainder
    {m : ℝ} (hm : 0 < m) (p : ℝ) :
    p ^ 2 / (2 * m) - p ^ 4 / (4 * m ^ 3 * c ^ 2)
      ≤ relativisticEnergy p m - m * c ^ 2 := by
  have := nonRelativistic_energy_lower_bound hm p
  unfold nonRelativisticEnergy at this
  linarith

/-- **The non-relativistic kinetic term.**  For `m > 0`,

        |(E − mc²) − p²/(2m)|  ≤  p⁴ / (4 m³ c²).

    This is the exact statement consumed by the Schrödinger
    derivation: the quantity that behaves like the eigenvalue of the
    Schrödinger Hamiltonian `p²/(2m)` differs from the relativistic
    kinetic energy by a p⁴ remainder. -/
theorem nonRelativistic_kinetic_term
    {m : ℝ} (hm : 0 < m) (p : ℝ) :
    |(relativisticEnergy p m - m * c ^ 2) - p ^ 2 / (2 * m)|
      ≤ p ^ 4 / (4 * m ^ 3 * c ^ 2) := by
  have h := nonRelativistic_energy_approx hm p
  have heq : (relativisticEnergy p m - m * c ^ 2) - p ^ 2 / (2 * m)
      = relativisticEnergy p m - nonRelativisticEnergy p m := by
    unfold nonRelativisticEnergy
    ring
  rw [heq]
  exact h

/-! ## Matching the Schrödinger bound

    The `schrodinger_prover` workstream produces a bound of the shape
        "the Schrödinger Hamiltonian has eigenvalue ≈ p²/(2m)".
    The bridge lemma below packages the statement that that `1/(2m)`
    coefficient is exactly the non-relativistic limit of the relativistic
    energy — in the form "if you have any approximation `K ≈ p²/(2m)`,
    then `K ≈ E − mc²` up to a p⁴ remainder".

    The theorem is stated with an explicit hypothesis on the
    Schrödinger-side approximation so that it remains usable even
    before a full derivation of that side is available. -/

/-- **The Schrödinger kinetic term is the non-relativistic limit of the
    relativistic kinetic energy.**

    If a Schrödinger-side derivation produces an eigenvalue-type
    quantity `K(p, m)` obeying `|K − p²/(2m)| ≤ ε` for some `ε ≥ 0`,
    then `K` agrees with the relativistic kinetic energy `E − mc²`
    up to a combined error

        |K − (E − mc²)|  ≤  ε  +  p⁴ / (4 m³ c²).

    The first summand is the Schrödinger-side approximation error
    (supplied by `schrodinger_prover`); the second is the intrinsic
    non-relativistic-expansion remainder proved here.  Taking
    `ε → 0` and `|p| ≪ mc` recovers exact agreement. -/
theorem schrodinger_is_nonrel_limit
    {m : ℝ} (hm : 0 < m) (p : ℝ)
    (K ε : ℝ) (hε : 0 ≤ ε)
    (hK : |K - p ^ 2 / (2 * m)| ≤ ε) :
    |K - (relativisticEnergy p m - m * c ^ 2)|
      ≤ ε + p ^ 4 / (4 * m ^ 3 * c ^ 2) := by
  -- split via triangle inequality through the Schrödinger kinetic
  have h_bridge : |(relativisticEnergy p m - m * c ^ 2) - p ^ 2 / (2 * m)|
      ≤ p ^ 4 / (4 * m ^ 3 * c ^ 2) := nonRelativistic_kinetic_term hm p
  -- |K − (E − mc²)| = |(K − p²/(2m)) + (p²/(2m) − (E − mc²))|
  have heq : K - (relativisticEnergy p m - m * c ^ 2)
      = (K - p ^ 2 / (2 * m)) + (p ^ 2 / (2 * m) - (relativisticEnergy p m - m * c ^ 2)) := by
    ring
  rw [heq]
  have htri := abs_add_le
      (K - p ^ 2 / (2 * m))
      (p ^ 2 / (2 * m) - (relativisticEnergy p m - m * c ^ 2))
  -- rewrite second summand's absolute value via `abs_sub_comm`
  have h_bridge' :
      |p ^ 2 / (2 * m) - (relativisticEnergy p m - m * c ^ 2)|
        ≤ p ^ 4 / (4 * m ^ 3 * c ^ 2) := by
    rw [abs_sub_comm]; exact h_bridge
  linarith

/-! ## Klein-Gordon stub

    The fully relativistic quantum equation is the Klein-Gordon
    equation.  Its lattice derivation is a multi-session workstream of
    its own and is not attempted here; we merely expose a
    *Prop-carrying structure* that records what the promised theorem
    must say, so that downstream files and the paper can reference the
    statement.

    The structure bundles three relations:
    * a `wave_equation` predicate on a lattice propagator function,
    * the mass-shell consistency at each momentum,
    * the non-relativistic-limit agreement with the Schrödinger side.

    A later workstream must produce an actual inhabitant — this file
    only ensures the language exists. -/

/-- Placeholder data for a Klein-Gordon derivation from the lattice.

    `waveEquation` abstractly represents "the lattice field obeys the
    Klein-Gordon equation" as a predicate on real-valued fields on the
    (continuum limit of the) lattice.

    `massShellConsistent` is the statement `E² = (pc)² + (mc²)²`, which
    is already a theorem of this repository
    (`massShell_from_tick_counting`).

    `nonRelativisticLimit` is the statement that the Klein-Gordon
    spectrum reduces to `mc² + p²/(2m)` plus an `O(p⁴)` remainder as
    `|p| ≪ mc` — this is precisely `nonRelativistic_energy_approx`.

    By construction an inhabitant of `KleinGordonFromLatticeData`
    requires *only* the two derived facts and one hypothesis about the
    lattice-field wave equation, which a later workstream may supply. -/
structure KleinGordonFromLatticeData where
  /-- Lattice field type (kept abstract here — a specific choice is
      made by the downstream derivation). -/
  Field : Type
  /-- The lattice field obeys a Klein-Gordon-type wave equation.  This
      is the only piece left to a later workstream. -/
  waveEquation : Field → Prop
  /-- Mass-shell consistency: `E² = (pc)² + (mc²)²`.  Already a
      theorem — any inhabitant can supply `fun p m => relativisticEnergy_sq_eq p m`. -/
  massShellConsistent :
    ∀ (p m : ℝ), (relativisticEnergy p m) ^ 2 = (p * c) ^ 2 + (m * c ^ 2) ^ 2
  /-- Non-relativistic limit: for `m > 0`, the relativistic energy
      reduces to `mc² + p²/(2m)` up to a quartic remainder.  Already a
      theorem — any inhabitant can supply `fun hm p => nonRelativistic_energy_approx hm p`. -/
  nonRelativisticLimit :
    ∀ {m : ℝ}, 0 < m → ∀ (p : ℝ),
      |relativisticEnergy p m - nonRelativisticEnergy p m|
        ≤ p ^ 4 / (4 * m ^ 3 * c ^ 2)

/-- **Partial inhabitant** of `KleinGordonFromLatticeData`.  Two of the
    three fields are already theorems of the repository; only the
    `waveEquation` field is left abstract (here instantiated with the
    trivially-true predicate `fun _ => True` on the `Unit` field type
    as a placeholder).  A later workstream replaces `Unit`/`True` with
    the genuine lattice field theory. -/
noncomputable def kleinGordonFromLattice_partial : KleinGordonFromLatticeData where
  Field := Unit
  waveEquation := fun _ => True
  massShellConsistent := fun p m => relativisticEnergy_sq_eq p m
  nonRelativisticLimit := fun hm p => nonRelativistic_energy_approx hm p

end OmegaTheory.Emergence
