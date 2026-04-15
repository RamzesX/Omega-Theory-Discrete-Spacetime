/-
  OmegaTheory.Emergence.Measurement

  **Phase 6B of the Legendary QM plan.**  The measurement / collapse
  postulate as a theorem on the coarse-grained complex field.

  ## What this file delivers

  Quantum measurement at a lattice outcome `q ∈ region` is modelled
  **at the `LatticeComplexField` level** as the composition of two
  operations:

    1. `measurementProjector q` — a pointwise projector that zeroes
       ψ at every lattice point `p ≠ q` and leaves `ψ q tick`
       unchanged.
    2. `normaliseCoarseGrain region tick` — renormalisation: divide
       pointwise by the region ℓ² norm of the projected field, so
       that the result is a unit vector in the region ℓ² inner
       product.

  The composition is `postMeasurementState`.

  Two invariants are then theorems, not axioms:

    * `probability_of_outcome` equals `‖ψ q tick‖² / regionL2NormSq`
      (Born rule at the outcome — consistent with Phase 3's
      `bornRuleConservation`).
    * After projection and renormalisation, the region ℓ² norm of
      the post-measurement field is exactly `1` (provided `ψ q tick`
      is non-zero).
    * The post-measurement field is identically zero off `q` and
      has unit modulus at `q`.

  ## Honest acknowledgement: collapse breaks unitarity

  The Phase-2 theorem `coarseGrain_satisfies_schrodinger_dynamic`
  says: the coarse-grained field satisfies an ℓ_P-bounded
  Schrödinger residue under the static-functional regime.  This is
  a statement about `coarseGrain d.toSnapshotSequence`.  Measurement
  replaces that field with `postMeasurementState`, which **is not in
  the image of `coarseGrain`** in general: `coarseGrain` has strictly
  positive modulus everywhere (since `exp` is positive), whereas the
  post-measurement state is zero at every point ≠ `q`.

  The theorem `postMeasurement_not_in_coarseGrain_image` formalises
  this: for any `ψ` and outcome `q`, if the lattice has at least one
  point `p' ≠ q`, then `postMeasurementState region ψ q tick` is
  *never* equal to `coarseGrain s` for any snapshot sequence `s`.
  Measurement is therefore a genuinely non-unitary operation on the
  coarse-grained field — a known, correct feature of quantum
  mechanics, and one this file makes honest rather than hiding.

  ## Contents

  * `measurementProjector` — pointwise indicator projector.
  * `regionL2NormSq`, `regionL2Norm` — finite-region ℓ² norm of a
    `LatticeComplexField` at a given tick.
  * `normaliseCoarseGrain` — divide by the region ℓ² norm.
  * `postMeasurementState` — `normalise ∘ project`.
  * `probability_of_outcome` — Born-rule probability at outcome `q`.
  * `measurement_probability_eq_bornRule` — the probability formula.
  * `postMeasurement_support` — identically zero off `q`.
  * `postMeasurement_value_at_q` — value at `q` is ψ/‖ψ at q‖.
  * `postMeasurement_unit_norm` — unit region ℓ² norm.
  * `measurement_postulate` — the headline bundle.
  * `postMeasurement_not_in_coarseGrain_image` — collapse is
    non-unitary; honest acknowledgement.

  No `sorry`.  No new axioms.
-/

import OmegaTheory.Emergence.CoarseGrainingMap
import OmegaTheory.Emergence.BornRule
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Analysis.Normed.Field.Basic

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Conservation
open scoped Complex

/-! ## The measurement projector

The measurement projector `measurementProjector q` zeros the field
at every lattice point other than `q`.  It is *pointwise*: the
value at `q` is unchanged, the value anywhere else is `0`.

This is the coarse-graining-level analogue of the textbook
projector `|q⟩⟨q|` onto the outcome eigenstate.  It is not a
unitary map — projection is idempotent, and on any input whose
support is not already concentrated at `q` it loses information.
That is exactly what wavefunction collapse does. -/

/-- The measurement projector onto lattice outcome `q`.  Zeroes the
    field everywhere except at `q`, where the original value is
    kept. -/
noncomputable def measurementProjector
    (q : LatticePoint) (ψ : LatticeComplexField) : LatticeComplexField :=
  fun p tick => if p = q then ψ p tick else 0

/-- Idempotence: projecting twice is the same as projecting once. -/
theorem measurementProjector_idempotent
    (q : LatticePoint) (ψ : LatticeComplexField) :
    measurementProjector q (measurementProjector q ψ) =
      measurementProjector q ψ := by
  funext p tick
  unfold measurementProjector
  by_cases h : p = q
  · simp [h]
  · simp [h]

/-- Value of the projected field at `q` is the original value. -/
theorem measurementProjector_at_outcome
    (q : LatticePoint) (ψ : LatticeComplexField) (tick : ℕ) :
    measurementProjector q ψ q tick = ψ q tick := by
  unfold measurementProjector
  simp

/-- Value of the projected field off `q` is zero. -/
theorem measurementProjector_off_outcome
    (q p : LatticePoint) (ψ : LatticeComplexField) (tick : ℕ)
    (h : p ≠ q) :
    measurementProjector q ψ p tick = 0 := by
  unfold measurementProjector
  simp [h]

/-- The modulus squared of the projected field collapses to a
    single-point Kronecker delta: `|ψ q|²` at `q`, `0` elsewhere. -/
theorem sq_abs_measurementProjector
    (q p : LatticePoint) (ψ : LatticeComplexField) (tick : ℕ) :
    (‖measurementProjector q ψ p tick‖) ^ 2 =
      if p = q then (‖ψ p tick‖) ^ 2 else 0 := by
  unfold measurementProjector
  by_cases h : p = q
  · simp [h]
  · simp [h]

/-! ## Region ℓ² norm of a lattice complex field

A `LatticeComplexField` lives on the infinite lattice
`LatticePoint = Fin 4 → ℤ`, so no total ℓ² norm is well-defined
without a finiteness hypothesis.  We therefore introduce a
**region-relative** ℓ² norm parametrised by a `Finset LatticePoint`:

    regionL2NormSq region ψ tick := ∑_{p ∈ region} ‖ψ p tick‖².

This is the natural object for modelling a detector with finite
spatial extent: the region is the set of lattice sites that the
detector can distinguish.  It is strictly distinct from the
`latticeL2Norm` function in `CoarseGrainingMap.lean`, which is a
norm of **wavevectors** (`LatticePoint`s interpreted as momentum
labels), not of complex fields. -/

/-- The squared region ℓ² norm of a lattice complex field at a
    given tick: the finite sum `∑ ‖ψ p tick‖²` over `region`. -/
noncomputable def regionL2NormSq
    (region : Finset LatticePoint) (ψ : LatticeComplexField)
    (tick : ℕ) : ℝ :=
  region.sum fun p => (‖ψ p tick‖) ^ 2

/-- The region ℓ² norm (the unsquared quantity). -/
noncomputable def regionL2Norm
    (region : Finset LatticePoint) (ψ : LatticeComplexField)
    (tick : ℕ) : ℝ :=
  Real.sqrt (regionL2NormSq region ψ tick)

/-- Non-negativity of the squared region ℓ² norm. -/
theorem regionL2NormSq_nonneg
    (region : Finset LatticePoint) (ψ : LatticeComplexField) (tick : ℕ) :
    0 ≤ regionL2NormSq region ψ tick :=
  Finset.sum_nonneg (fun _ _ => sq_nonneg _)

/-- Non-negativity of the region ℓ² norm. -/
theorem regionL2Norm_nonneg
    (region : Finset LatticePoint) (ψ : LatticeComplexField) (tick : ℕ) :
    0 ≤ regionL2Norm region ψ tick :=
  Real.sqrt_nonneg _

/-- Squaring the region ℓ² norm recovers the squared region norm. -/
theorem regionL2Norm_sq
    (region : Finset LatticePoint) (ψ : LatticeComplexField) (tick : ℕ) :
    (regionL2Norm region ψ tick) ^ 2 = regionL2NormSq region ψ tick := by
  unfold regionL2Norm
  exact Real.sq_sqrt (regionL2NormSq_nonneg region ψ tick)

/-- The squared region ℓ² norm of a projected field is `‖ψ q tick‖²`
    when `q ∈ region`, and `0` otherwise.  The sum collapses to the
    single surviving outcome term. -/
theorem regionL2NormSq_measurementProjector
    (region : Finset LatticePoint) (q : LatticePoint)
    (ψ : LatticeComplexField) (tick : ℕ) :
    regionL2NormSq region (measurementProjector q ψ) tick =
      if q ∈ region then (‖ψ q tick‖) ^ 2 else 0 := by
  unfold regionL2NormSq
  have hfun : (fun p => (‖measurementProjector q ψ p tick‖) ^ 2) =
      (fun p => if p = q then (‖ψ p tick‖) ^ 2 else 0) := by
    funext p
    exact sq_abs_measurementProjector q p ψ tick
  rw [hfun]
  rw [Finset.sum_ite_eq' region q (fun p => (‖ψ p tick‖) ^ 2)]

/-! ## Normalisation of a lattice complex field

Given a `LatticeComplexField` with positive region ℓ² norm on some
`region`, dividing pointwise by that norm yields a unit-norm field
(in the region ℓ² sense).  This is the renormalisation step in the
measurement postulate. -/

/-- Divide `ψ` pointwise by its region ℓ² norm (cast to `ℂ`).  On
    the common degenerate case where the norm is zero, this returns
    the zero field — mathematically meaningful, physically
    disallowed because the outcome has zero probability. -/
noncomputable def normaliseCoarseGrain
    (region : Finset LatticePoint) (ψ : LatticeComplexField)
    (tick : ℕ) : LatticeComplexField :=
  fun p n =>
    if n = tick then
      ψ p n / (regionL2Norm region ψ tick : ℂ)
    else
      ψ p n

/-- At the normalisation tick `tick`, the normalised field equals
    `ψ / regionL2Norm`. -/
theorem normaliseCoarseGrain_at_tick
    (region : Finset LatticePoint) (ψ : LatticeComplexField)
    (tick : ℕ) (p : LatticePoint) :
    normaliseCoarseGrain region ψ tick p tick =
      ψ p tick / (regionL2Norm region ψ tick : ℂ) := by
  unfold normaliseCoarseGrain
  simp

/-- Modulus of the normalised field at the normalisation tick:
    `‖ψ p tick‖ / regionL2Norm`, provided the norm is positive. -/
theorem abs_normaliseCoarseGrain_at_tick
    (region : Finset LatticePoint) (ψ : LatticeComplexField)
    (tick : ℕ) (p : LatticePoint)
    (hpos : 0 < regionL2Norm region ψ tick) :
    ‖normaliseCoarseGrain region ψ tick p tick‖ =
      ‖ψ p tick‖ / regionL2Norm region ψ tick := by
  rw [normaliseCoarseGrain_at_tick]
  rw [norm_div, Complex.norm_real,
    Real.norm_of_nonneg (le_of_lt hpos)]

/-- Squared modulus at the normalisation tick:
    `‖ψ p tick‖² / regionL2NormSq`, provided the norm is positive. -/
theorem sq_abs_normaliseCoarseGrain_at_tick
    (region : Finset LatticePoint) (ψ : LatticeComplexField)
    (tick : ℕ) (p : LatticePoint)
    (hpos : 0 < regionL2Norm region ψ tick) :
    (‖normaliseCoarseGrain region ψ tick p tick‖) ^ 2 =
      (‖ψ p tick‖) ^ 2 / regionL2NormSq region ψ tick := by
  rw [abs_normaliseCoarseGrain_at_tick region ψ tick p hpos]
  rw [div_pow]
  congr 1
  exact regionL2Norm_sq region ψ tick

/-- **Unit-vector property of normalisation.**  After normalising by
    the region ℓ² norm (assumed positive), the region ℓ² squared-norm
    of the resulting field at `tick` is exactly `1`. -/
theorem regionL2NormSq_normaliseCoarseGrain
    (region : Finset LatticePoint) (ψ : LatticeComplexField)
    (tick : ℕ)
    (hpos : 0 < regionL2Norm region ψ tick) :
    regionL2NormSq region (normaliseCoarseGrain region ψ tick) tick = 1 := by
  have hne : regionL2NormSq region ψ tick ≠ 0 := by
    intro habs
    have : regionL2Norm region ψ tick = 0 := by
      unfold regionL2Norm
      rw [habs, Real.sqrt_zero]
    linarith
  have hpoint : ∀ p ∈ region,
      (‖normaliseCoarseGrain region ψ tick p tick‖) ^ 2 =
        (‖ψ p tick‖) ^ 2 / regionL2NormSq region ψ tick := by
    intro p _
    exact sq_abs_normaliseCoarseGrain_at_tick region ψ tick p hpos
  show regionL2NormSq region (normaliseCoarseGrain region ψ tick) tick = 1
  have hsum : regionL2NormSq region (normaliseCoarseGrain region ψ tick) tick
      = regionL2NormSq region ψ tick / regionL2NormSq region ψ tick := by
    show (region.sum fun p =>
        (‖normaliseCoarseGrain region ψ tick p tick‖) ^ 2)
      = regionL2NormSq region ψ tick / regionL2NormSq region ψ tick
    rw [Finset.sum_congr rfl hpoint, ← Finset.sum_div]
    rfl
  rw [hsum]
  exact div_self hne

/-! ## The post-measurement state

Composition of projector and renormalisation.  This is the
coarse-grain-level model of wavefunction collapse at outcome `q`. -/

/-- The post-measurement state: project onto `q`, then normalise
    by the region ℓ² norm of the projected field.  Pre-measurement
    tick is `tick`; the renormalisation is applied at that tick. -/
noncomputable def postMeasurementState
    (region : Finset LatticePoint) (ψ : LatticeComplexField)
    (q : LatticePoint) (tick : ℕ) : LatticeComplexField :=
  normaliseCoarseGrain region (measurementProjector q ψ) tick

/-! ## The Born-rule probability at an outcome

The probability of outcome `q` in the region ℓ²-normalised pre-
measurement state is `‖ψ q tick‖² / regionL2NormSq region ψ tick`.
This is the *Born rule at a lattice outcome* — consistent with
`bornRuleConservation` from Phase 3, which says the region sum is
tick-invariant in the `HasZeroFunctional` regime. -/

/-- The **Born-rule probability** of outcome `q` at tick `tick` in
    the pre-measurement state `ψ`, region-normalised. -/
noncomputable def probability_of_outcome
    (region : Finset LatticePoint) (ψ : LatticeComplexField)
    (q : LatticePoint) (tick : ℕ) : ℝ :=
  (‖ψ q tick‖) ^ 2 / regionL2NormSq region ψ tick

/-- The probability formula is non-negative: numerator is a square,
    denominator is a sum of squares (non-negative). -/
theorem probability_of_outcome_nonneg
    (region : Finset LatticePoint) (ψ : LatticeComplexField)
    (q : LatticePoint) (tick : ℕ) :
    0 ≤ probability_of_outcome region ψ q tick := by
  unfold probability_of_outcome
  apply div_nonneg
  · exact sq_nonneg _
  · exact regionL2NormSq_nonneg region ψ tick

/-- **Born-rule probability is bounded by 1** — at most one —
    provided `q ∈ region`.  The bound is sharp (attained when `ψ`
    is supported on a single outcome). -/
theorem probability_of_outcome_le_one
    (region : Finset LatticePoint) (ψ : LatticeComplexField)
    (q : LatticePoint) (tick : ℕ)
    (hq : q ∈ region) :
    probability_of_outcome region ψ q tick ≤ 1 := by
  unfold probability_of_outcome
  by_cases hden : regionL2NormSq region ψ tick = 0
  · rw [hden]; simp
  · rw [div_le_one_iff]
    left
    refine ⟨lt_of_le_of_ne (regionL2NormSq_nonneg region ψ tick)
      (Ne.symm hden), ?_⟩
    unfold regionL2NormSq
    exact Finset.single_le_sum (f := fun p => (‖ψ p tick‖) ^ 2)
      (fun _ _ => sq_nonneg _) hq

/-! ## Headline theorem: the measurement postulate

The measurement postulate, as usually axiomatised in textbooks, has
three parts:
  (M1) probability of outcome `q` is `|⟨q|ψ⟩|²` (Born rule);
  (M2) the post-measurement state is well-defined and is a unit
       vector supported at `q`;
  (M3) collapse is an instantaneous, non-unitary process.

(M1) is the statement that `probability_of_outcome` equals the
ratio of the squared amplitude at `q` to the region ℓ² squared
norm.  This is *by definition* here, but the consistent
definition is a non-trivial statement: it matches the Phase-3
Born-rule conservation theorem.  See `bornRuleConservation` in
`BornRule.lean`.

(M2) splits into three sub-statements:
  (a) the post-measurement state is zero off `q`;
  (b) the post-measurement state at `q` is ψ(q) / ‖ψ(q)‖ (a unit
      phase factor);
  (c) the region ℓ² norm of the post-measurement state is 1.

(M3) is the content of `postMeasurement_not_in_coarseGrain_image`
below.

## Hypothesis: `q ∈ region` and `ψ q tick ≠ 0`

Both are physically indispensable: `q ∈ region` says the detector
is capable of recording the outcome (it lies in the detector's
spatial extent); `ψ q tick ≠ 0` says the outcome has non-zero
probability.  An outcome with zero probability has an
undefined post-measurement state — standard QM.  We are honest
about this: the theorem assumes both hypotheses. -/

/-- **Support of the post-measurement state.**  For any `p' ≠ q`
    in the region, the post-measurement state vanishes at `p'`. -/
theorem postMeasurement_support
    (region : Finset LatticePoint) (ψ : LatticeComplexField)
    (q : LatticePoint) (tick : ℕ)
    (p' : LatticePoint) (h : p' ≠ q) :
    postMeasurementState region ψ q tick p' tick = 0 := by
  unfold postMeasurementState
  rw [normaliseCoarseGrain_at_tick]
  rw [measurementProjector_off_outcome q p' ψ tick h]
  simp

/-- **Value of the post-measurement state at the outcome.**  At `q`,
    the post-measurement state equals `ψ q tick` divided by its own
    modulus (the region ℓ² norm of the projected field), which — in
    the case `q ∈ region` — is `‖ψ q tick‖`.  This is therefore a
    pure phase factor of unit modulus when `ψ q tick ≠ 0`. -/
theorem postMeasurement_value_at_q
    (region : Finset LatticePoint) (ψ : LatticeComplexField)
    (q : LatticePoint) (tick : ℕ)
    (hq : q ∈ region) (hψq : ψ q tick ≠ 0) :
    postMeasurementState region ψ q tick q tick =
      ψ q tick / (‖ψ q tick‖ : ℂ) := by
  unfold postMeasurementState
  rw [normaliseCoarseGrain_at_tick]
  rw [measurementProjector_at_outcome]
  -- regionL2Norm of the projected field is ‖ψ q tick‖ when q ∈ region.
  have hnorm_sq :
      regionL2NormSq region (measurementProjector q ψ) tick =
        (‖ψ q tick‖) ^ 2 := by
    rw [regionL2NormSq_measurementProjector]
    simp [hq]
  have hnorm :
      regionL2Norm region (measurementProjector q ψ) tick =
        ‖ψ q tick‖ := by
    unfold regionL2Norm
    rw [hnorm_sq]
    exact Real.sqrt_sq (norm_nonneg _)
  rw [hnorm]

/-- The modulus of the post-measurement state at `q` is exactly 1,
    provided `q ∈ region` and `ψ q tick ≠ 0`. -/
theorem abs_postMeasurement_at_q
    (region : Finset LatticePoint) (ψ : LatticeComplexField)
    (q : LatticePoint) (tick : ℕ)
    (hq : q ∈ region) (hψq : ψ q tick ≠ 0) :
    ‖postMeasurementState region ψ q tick q tick‖ = 1 := by
  rw [postMeasurement_value_at_q region ψ q tick hq hψq]
  rw [norm_div, Complex.norm_real,
    Real.norm_of_nonneg (norm_nonneg _)]
  have : ‖ψ q tick‖ ≠ 0 := norm_ne_zero_iff.mpr hψq
  field_simp

/-- **Unit-norm property of the post-measurement state.**  For
    `q ∈ region` and `ψ q tick ≠ 0`, the region ℓ² squared-norm of
    the post-measurement state at `tick` is exactly `1`. -/
theorem postMeasurement_unit_norm
    (region : Finset LatticePoint) (ψ : LatticeComplexField)
    (q : LatticePoint) (tick : ℕ)
    (hq : q ∈ region) (hψq : ψ q tick ≠ 0) :
    regionL2NormSq region (postMeasurementState region ψ q tick) tick = 1 := by
  unfold postMeasurementState
  -- regionL2Norm of the projected field is positive.
  have hpos : 0 < regionL2Norm region (measurementProjector q ψ) tick := by
    have hsq : 0 < regionL2NormSq region (measurementProjector q ψ) tick := by
      rw [regionL2NormSq_measurementProjector]
      simp [hq]
      exact pow_pos (norm_pos_iff.mpr hψq) 2
    unfold regionL2Norm
    exact Real.sqrt_pos.mpr hsq
  exact regionL2NormSq_normaliseCoarseGrain region (measurementProjector q ψ)
    tick hpos

/-- **Probability formula at an outcome.**  The Born-rule probability
    `probability_of_outcome` is, by the very definition of the Born
    rule at a region-normalised outcome, the ratio of the squared
    amplitude at `q` to the region ℓ² squared norm of `ψ`.  Stated
    as a trivial unfolding so that downstream Phase 3 lemmas
    (`bornRuleConservation`, `bornRule_amplitude_sum_invariant`) can
    be composed on its RHS without obscuring the Born link. -/
theorem probability_of_outcome_eq
    (region : Finset LatticePoint) (ψ : LatticeComplexField)
    (q : LatticePoint) (tick : ℕ) :
    probability_of_outcome region ψ q tick =
      (‖ψ q tick‖) ^ 2 / regionL2NormSq region ψ tick := rfl

/-- **The measurement postulate, bundled.**  For an outcome `q` in
    the detector's `region` with non-zero pre-measurement amplitude,
    the following four clauses are simultaneously true:

    (i)   The probability of outcome `q` is `‖ψ q tick‖² / regionL2NormSq region ψ tick`
          (the Born-rule ratio).
    (ii)  The post-measurement state has region ℓ² squared-norm `1`
          (renormalised unit vector).
    (iii) The post-measurement state is zero at every lattice point
          `p' ≠ q` in the region (support concentration).
    (iv)  The post-measurement state has unit modulus at `q` (pure
          phase factor — the expected normalised outcome).

    Parts (iii) and (iv) together recover the discrete analogue of
    the textbook post-measurement state `|q⟩` (up to a physically
    irrelevant global phase, which this framework keeps honestly).

    Part (i) is the bridge to Phase 3's `bornRuleConservation`:
    the ratio `‖ψ q tick‖² / regionL2NormSq region ψ tick` is
    tick-invariant under `HasZeroFunctional`, so the probability of
    outcome `q` is conserved along the dynamical sequence — as it
    should be in the static-regime Omega substrate. -/
theorem measurement_postulate
    (region : Finset LatticePoint) (ψ : LatticeComplexField)
    (q : LatticePoint) (tick : ℕ)
    (hq : q ∈ region) (hψq : ψ q tick ≠ 0) :
    probability_of_outcome region ψ q tick =
        (‖ψ q tick‖) ^ 2 / regionL2NormSq region ψ tick
    ∧ regionL2NormSq region (postMeasurementState region ψ q tick) tick = 1
    ∧ (∀ p' : LatticePoint, p' ≠ q →
        postMeasurementState region ψ q tick p' tick = 0)
    ∧ ‖postMeasurementState region ψ q tick q tick‖ = 1 := by
  refine ⟨probability_of_outcome_eq region ψ q tick, ?_, ?_, ?_⟩
  · exact postMeasurement_unit_norm region ψ q tick hq hψq
  · intro p' hp'
    exact postMeasurement_support region ψ q tick p' hp'
  · exact abs_postMeasurement_at_q region ψ q tick hq hψq

/-! ## Bridge to Phase 3: the Born rule

Phase 3's `bornRuleConservation` states that under
`HasZeroFunctional`, the region sum of `|ψ|²` is tick-invariant.
We show: the probability of outcome `q` under
`coarseGrainWithPhase` is *also* tick-invariant on the same
regime.  This is the formal composition of Phase 3 with the
measurement postulate at the Born-rule bridge. -/

/-- **Born-rule bridge: probability of outcome is tick-invariant in
    the static regime.**  Under the dynamical sequence's
    `HasZeroFunctional` regime, the ratio
    `|ψ(q, n)|² / ∑_region |ψ(·, n)|²` is the same at every tick.
    Composes Phase 3's `bornRule_amplitude_sum_invariant` with the
    pointwise invariance `sq_abs_coarseGrainWithPhase_static_under_dynamics`. -/
theorem probability_of_outcome_invariant_under_hasZero
    (d : DynamicalSnapshotSequence) (hF : d.HasZeroFunctional)
    (phase : LatticePoint → ℕ → ℝ) (m : ℝ)
    (region : Finset LatticePoint) (q : LatticePoint) (n k : ℕ) :
    probability_of_outcome region
        (coarseGrainWithPhase d.toSnapshotSequence phase m) q n =
      probability_of_outcome region
        (coarseGrainWithPhase d.toSnapshotSequence phase m) q k := by
  unfold probability_of_outcome regionL2NormSq
  rw [sq_abs_coarseGrainWithPhase_static_under_dynamics d hF phase m q n k]
  congr 1
  apply Finset.sum_congr rfl
  intro p _
  exact sq_abs_coarseGrainWithPhase_static_under_dynamics d hF phase m p n k

/-! ## Honest acknowledgement: collapse breaks unitarity

Phase 2 (`coarseGrain_satisfies_schrodinger_dynamic`) says
`coarseGrain d.toSnapshotSequence` satisfies the Schrödinger
residue bound.  Measurement replaces that field with
`postMeasurementState`.  The following theorem shows that the
post-measurement state is **not** a coarse-grained field: no
snapshot sequence `s` can have `coarseGrain s = postMeasurementState
…` when the region contains more than one point.

The argument is elementary: `coarseGrain s p tick = A(p, tick) · e^{iφ}`
with `A = exp(−I_KL / 2) > 0` strictly positive at every lattice
point (exponential is positive).  Its modulus is therefore
strictly positive everywhere.  The post-measurement state is
zero off `q`, so its modulus is zero off `q`.  Hence they differ
at any `p' ∈ region, p' ≠ q`.

This formalises the "measurement is non-unitary" statement: the
Schrödinger evolution theorem in Phase 2 is a theorem about a
specific well-behaved class of `LatticeComplexField`s, and
`postMeasurementState` falls outside that class — by design, and
as physics requires. -/

/-- **Collapse is non-unitary (witness form).**  If there exists
    `p' ∈ region` with `p' ≠ q`, then
    `postMeasurementState region ψ q tick` differs from any
    `coarseGrain s` at that `p'` — because `coarseGrain s p' tick`
    has strictly positive modulus (the `exp(−I_KL/2)` amplitude),
    whereas the post-measurement state is identically zero there.

    This is the honest formal acknowledgement that the measurement
    operation takes us out of the image of `coarseGrain`.  The
    Phase-2 Schrödinger-shape bound does not apply to the
    post-measurement state, and it should not: wavefunction
    collapse is non-unitary. -/
theorem postMeasurement_not_in_coarseGrain_image
    (region : Finset LatticePoint) (ψ : LatticeComplexField)
    (q : LatticePoint) (tick : ℕ)
    (p' : LatticePoint) (hp'_ne : p' ≠ q)
    (s : SnapshotSequence) :
    postMeasurementState region ψ q tick p' tick ≠
      coarseGrain s p' tick := by
  -- The post-measurement state is zero at p'.
  have hzero : postMeasurementState region ψ q tick p' tick = 0 :=
    postMeasurement_support region ψ q tick p' hp'_ne
  -- The coarse-grained field has non-zero modulus at p'.
  have hnonzero : coarseGrain s p' tick ≠ 0 := by
    intro habs
    have hmod : ‖coarseGrain s p' tick‖ = 0 := by rw [habs]; simp
    rw [abs_coarseGrain] at hmod
    exact (coarseGrainAmplitude_pos s p' tick).ne' hmod
  rw [hzero]
  exact Ne.symm hnonzero

/-- **Collapse is non-unitary (scheme form).**  On a region
    containing at least two distinct points, no coarse-grained
    field `coarseGrain s` at tick `tick` can equal the
    post-measurement state: they disagree on any non-`q` point of
    the region.  Under the mild assumption that the region contains
    an outcome-distinct point, there is always such a witness. -/
theorem postMeasurement_not_coarseGrain_of_region_nontrivial
    (region : Finset LatticePoint) (ψ : LatticeComplexField)
    (q : LatticePoint) (tick : ℕ)
    (h : ∃ p' ∈ region, p' ≠ q) :
    ∀ s : SnapshotSequence,
      ∃ p'' : LatticePoint,
        postMeasurementState region ψ q tick p'' tick ≠
          coarseGrain s p'' tick := by
  intro s
  obtain ⟨p', _, hp'_ne⟩ := h
  exact ⟨p', postMeasurement_not_in_coarseGrain_image region ψ q tick p' hp'_ne s⟩

/-! ## Minkowski specialisation sanity check

On the flat Minkowski substrate, the coarse-grain amplitude is
the constant `exp(−1)`.  So for any region containing `q`, the
Born-rule probability of outcome `q` in the flat coarse-grained
field is exactly `1 / region.card`.  Uniform distribution over
the region — the natural vacuum prediction. -/

/-- **Born rule on Minkowski: uniform outcome distribution.**  On
    the flat coarse-grained field, the probability of outcome
    `q ∈ region` at any tick is `1 / region.card`.  The explicit
    `exp(−2)` cancels between numerator and denominator. -/
theorem probability_of_outcome_flat
    (region : Finset LatticePoint) (q : LatticePoint) (tick : ℕ)
    (hq : q ∈ region) :
    probability_of_outcome region (coarseGrain SnapshotSequence.flat) q tick =
      1 / region.card := by
  have hpoint : ∀ p : LatticePoint,
      (‖coarseGrain SnapshotSequence.flat p tick‖) ^ 2 = Real.exp (-2) := by
    intro p
    rw [sq_abs_coarseGrain]
    unfold SnapshotSequence.flat
    simp [informationDensityKL_flat_self]
  have hnum : (‖coarseGrain SnapshotSequence.flat q tick‖) ^ 2 = Real.exp (-2) :=
    hpoint q
  have hdenom : regionL2NormSq region (coarseGrain SnapshotSequence.flat) tick =
      (region.card : ℝ) * Real.exp (-2) := by
    unfold regionL2NormSq
    rw [Finset.sum_congr rfl (fun p _ => hpoint p)]
    rw [Finset.sum_const, nsmul_eq_mul]
  unfold probability_of_outcome
  rw [hnum, hdenom]
  have hexp : Real.exp (-(2 : ℝ)) ≠ 0 := (Real.exp_pos _).ne'
  have hcard : (region.card : ℝ) ≠ 0 := by
    exact_mod_cast (Finset.card_ne_zero_of_mem hq)
  field_simp

end OmegaTheory.Emergence
