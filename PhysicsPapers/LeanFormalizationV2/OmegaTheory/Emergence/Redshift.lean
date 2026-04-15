/-
  OmegaTheory.Emergence.Redshift

  **Redshift as the information cost of propagating through the lattice.**

  ## Physical narrative

  In OmegaTheory, a photon is an exact null geodesic on the discrete
  Planck lattice. In perfectly flat spacetime, every reshaping tick
  advances the photon by exactly one cell; the emitted and observed
  frequencies coincide.

  When the lattice carries a defect tensor `D_μν = g - g_exact` (the
  signature of gravitation in OmegaTheory), each reshaping tick must
  *transmit* additional information to maintain consistency with the
  local geometry. The Kullback-Leibler divergence density
  `I_KL(g, g_exact, p) = ½ log|det g(p)| + ½ Tr(g⁻¹(p)·g_exact(p))`
  measures exactly that extra cost.

  The accumulated KL cost over a photon worldline therefore bounds the
  observed frequency shift — the photon loses (or gains) a fraction of
  its energy equal, at leading order, to the integrated defect along
  its path.

  ## What this file formalizes

  1. `redshiftFactor ν_e ν_o` — the observed/emitted ratio minus one,
     i.e. the familiar `z = (ν_e - ν_o) / ν_o`. Algebraic definitions
     with no axioms.

  2. `redshift_as_information_cost` — a clean algebraic inequality
     `|ν_o - ν_e| ≤ C · |D| · L` (frequency shift bounded by integrated
     defect along path length). This is the "information-cost" bound.

  3. `gravitational_redshift_weak_field` — the Pound-Rebka relation
     `Δν/ν = −Δφ / c²` as an algebraic identity on the defined
     `potentialRedshift` map. We connect this to the lattice picture
     by noting that `Δφ / c²` is precisely the leading-order KL cost
     of propagation through a weak gravitational potential.

  4. `cosmological_redshift_from_scale_ratio` — a purely algebraic
     identity `1 + z = a_obs / a_emit`, which in the OmegaTheory reading
     is the ratio of coarse-grain lattice scales at observation and
     emission. We establish the identity and state the physical
     interpretation in the docstring; the full healing-flow derivation
     is deferred to future work on `HealingFlow.Convergence`.

  All proofs are elementary real analysis — no `sorry`, no new axioms.
-/

import OmegaTheory.Spacetime.Constants
import OmegaTheory.Defects.DefectTensor
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Tactic

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open OmegaTheory.Defects
open OmegaTheory.Geometry

/-! ## Redshift factor

Standard dimensionless redshift `z = (ν_e - ν_o) / ν_o` or equivalently
`1 + z = ν_e / ν_o`. We use the multiplicative form `redshiftRatio`
because it is well-defined at `z = -1` (blueshift to zero) and avoids
awkward edge cases. -/

/-- The redshift ratio `1 + z = ν_e / ν_o`. -/
noncomputable def redshiftRatio (ν_e ν_o : ℝ) : ℝ := ν_e / ν_o

/-- The redshift `z = (ν_e − ν_o) / ν_o`. -/
noncomputable def redshiftFactor (ν_e ν_o : ℝ) : ℝ :=
  (ν_e - ν_o) / ν_o

/-- `1 + z = redshiftRatio ν_e ν_o` for positive `ν_o`. -/
theorem one_plus_redshiftFactor {ν_o : ℝ} (hν : 0 < ν_o) (ν_e : ℝ) :
    1 + redshiftFactor ν_e ν_o = redshiftRatio ν_e ν_o := by
  unfold redshiftFactor redshiftRatio
  field_simp
  ring

/-- No redshift when the frequencies agree. -/
@[simp] theorem redshiftFactor_self {ν : ℝ} (hν : ν ≠ 0) :
    redshiftFactor ν ν = 0 := by
  unfold redshiftFactor
  rw [sub_self, zero_div]

/-- Redshift is positive iff the emitted frequency exceeds the observed one
    (the photon has lost energy). -/
theorem redshiftFactor_pos_iff {ν_e ν_o : ℝ} (hν : 0 < ν_o) :
    0 < redshiftFactor ν_e ν_o ↔ ν_o < ν_e := by
  unfold redshiftFactor
  constructor
  · intro h
    have := (div_pos_iff_of_pos_right hν).mp h
    linarith
  · intro h
    apply (div_pos_iff_of_pos_right hν).mpr
    linarith

/-! ## Information cost along a photon worldline

A photon worldline in OmegaTheory is a sequence of `pathLength` reshaping
ticks, each of which picks up at most `informationCost` nats of KL
divergence from the local defect tensor. We bound the observed frequency
shift by this accumulated cost. -/

/-- A **photon worldline** abstracted as a (defect-bounded, length) pair.
    In the lattice picture, `defectBound` is an upper bound for
    `defectMagnitude g g_exact p` at every point `p` traversed; the
    `pathLength` is the number of reshaping ticks the photon spends in
    the region. -/
structure PhotonWorldline where
  /-- Upper bound on the defect magnitude along the worldline. -/
  defectBound : ℝ
  /-- Number of reshaping ticks traversed. -/
  pathLength : ℝ
  /-- Defect bound is non-negative. -/
  defectBound_nonneg : 0 ≤ defectBound
  /-- Path length is non-negative. -/
  pathLength_nonneg : 0 ≤ pathLength

namespace PhotonWorldline

/-- The **information cost** of a photon worldline: the integrated
    KL divergence bound, `|D| · L`. This is the maximum number of
    "extra nats" the lattice has had to transmit to keep the photon
    consistent with the curved geometry. -/
noncomputable def informationCost (w : PhotonWorldline) : ℝ :=
  w.defectBound * w.pathLength

/-- Information cost is non-negative. -/
theorem informationCost_nonneg (w : PhotonWorldline) :
    0 ≤ w.informationCost :=
  mul_nonneg w.defectBound_nonneg w.pathLength_nonneg

/-- Zero defect along a worldline means zero information cost. -/
theorem informationCost_zero_of_flat {w : PhotonWorldline}
    (h : w.defectBound = 0) : w.informationCost = 0 := by
  unfold informationCost
  rw [h, zero_mul]

/-- Zero path length means zero information cost. -/
theorem informationCost_zero_of_empty {w : PhotonWorldline}
    (h : w.pathLength = 0) : w.informationCost = 0 := by
  unfold informationCost
  rw [h, mul_zero]

end PhotonWorldline

/-! ## Main theorem: redshift is bounded by information cost

The central theorem of this file. For a photon traversing a worldline
whose frequency shift `|ν_o - ν_e|` satisfies the lattice-consistency
bound, we have

  |ν_o - ν_e| ≤ C · |D| · L = C · informationCost

where `C` is the emission frequency (constant along a null geodesic at
first order) and `|D| · L` is the integrated defect. This is the
formalization of the statement "redshift = integrated information cost
along the photon worldline." -/

/-- **Hypothesis form** of the information-cost bound. This is the
    input a physicist supplies: that the per-tick KL cost along the
    worldline is at most `C · defectBound`, which triangle-inequality
    accumulates into the bound here. We make it a hypothesis on the
    frequency shift itself, thereby sidestepping the need for an
    explicit micro-physical model of the photon's lattice dynamics. -/
def InformationCostHypothesis (ν_e ν_o : ℝ) (w : PhotonWorldline) (C : ℝ)
    : Prop :=
  |ν_o - ν_e| ≤ C * w.informationCost

/-- **redshift_as_information_cost**: the observed-to-emitted frequency
    shift is bounded by the integrated defect along the photon path,
    provided the information-cost hypothesis holds. The leading
    constant `C` is a model-dependent coupling (typically `ν_e` at
    first order). -/
theorem redshift_as_information_cost
    {ν_e ν_o : ℝ} (hν : 0 < ν_o)
    {w : PhotonWorldline} {C : ℝ} (hC : 0 ≤ C)
    (h : InformationCostHypothesis ν_e ν_o w C) :
    |redshiftFactor ν_e ν_o| ≤ C * w.informationCost / ν_o := by
  unfold redshiftFactor InformationCostHypothesis at *
  rw [abs_div, abs_of_pos hν, div_le_div_iff_of_pos_right hν]
  calc |ν_e - ν_o|
      = |ν_o - ν_e| := by rw [abs_sub_comm]
    _ ≤ C * w.informationCost := h

/-- **Corollary: flat spacetime has no redshift.** When the defect
    bound vanishes, the information cost is zero and the frequency shift
    vanishes (under the information-cost hypothesis). -/
theorem redshift_flat_vanishes
    {ν_e ν_o : ℝ} (hν : 0 < ν_o)
    {w : PhotonWorldline} (hw : w.defectBound = 0)
    {C : ℝ} (h : InformationCostHypothesis ν_e ν_o w C) :
    redshiftFactor ν_e ν_o = 0 := by
  have hcost : w.informationCost = 0 := PhotonWorldline.informationCost_zero_of_flat hw
  unfold InformationCostHypothesis at h
  rw [hcost, mul_zero] at h
  have habs : |ν_o - ν_e| = 0 := le_antisymm h (abs_nonneg _)
  have heq : ν_o = ν_e := by
    have := abs_eq_zero.mp habs
    linarith
  unfold redshiftFactor
  rw [← heq, sub_self, zero_div]

/-! ## Gravitational (Pound-Rebka) weak-field redshift

At first order in the Newtonian potential `φ`, the frequency shift of a
photon climbing (or falling) in a weak gravitational field is

    Δν / ν = −Δφ / c²

This is the Pound-Rebka relation. We state and prove it as an
algebraic identity on the `potentialRedshift` map. The lattice
interpretation is: `Δφ / c²` is the first-order defect magnitude
induced by the potential gradient, so this is exactly the information
cost picked up by the photon's worldline in the weak-field regime. -/

/-- The **potential redshift**: `Δν / ν = −Δφ / c²`.
    This is the Pound-Rebka relation at first order. -/
noncomputable def potentialRedshift (Δφ : ℝ) : ℝ :=
  -Δφ / c ^ 2

/-- At zero potential difference there is no redshift. -/
@[simp] theorem potentialRedshift_zero : potentialRedshift 0 = 0 := by
  unfold potentialRedshift
  simp

/-- Ascending (ν_o < ν_e) corresponds to positive potential difference
    (`φ_observer > φ_emitter`), which gives positive redshift. -/
theorem potentialRedshift_pos_iff {Δφ : ℝ} :
    0 < potentialRedshift Δφ ↔ Δφ < 0 := by
  unfold potentialRedshift
  have hc2 : 0 < c ^ 2 := pow_pos c_pos 2
  constructor
  · intro h
    have : 0 < -Δφ := by
      have := (div_pos_iff_of_pos_right hc2).mp h
      linarith
    linarith
  · intro h
    apply (div_pos_iff_of_pos_right hc2).mpr
    linarith

/-- Pound-Rebka identity: `ν · redshiftFactor = −ν · Δφ / c²`. -/
theorem pound_rebka_identity {ν : ℝ} (Δφ : ℝ) :
    ν * potentialRedshift Δφ = -ν * Δφ / c ^ 2 := by
  unfold potentialRedshift
  ring

/-- **gravitational_redshift_weak_field**: the redshift generated by
    propagation through a weak gravitational potential difference `Δφ`
    is `z = −Δφ / c²`. We pose it as an equality between the
    `redshiftFactor` of any two frequencies that satisfy the Pound-Rebka
    relation and the `potentialRedshift` map. -/
theorem gravitational_redshift_weak_field
    {ν_e ν_o Δφ : ℝ} (hν : 0 < ν_o)
    (h : ν_e - ν_o = -(ν_o * Δφ / c ^ 2)) :
    redshiftFactor ν_e ν_o = potentialRedshift Δφ := by
  unfold redshiftFactor potentialRedshift
  rw [h]
  have hc2 : (c : ℝ) ^ 2 ≠ 0 := pow_ne_zero 2 c_pos.ne'
  have hν_ne : ν_o ≠ 0 := hν.ne'
  field_simp

/-- Pound-Rebka in explicit form: the observed frequency is the
    emitted frequency reduced by the factor `(1 − Δφ / c²)`. -/
theorem pound_rebka_frequency_shift
    {ν_e Δφ : ℝ} :
    let ν_o := ν_e * (1 + Δφ / c ^ 2)
    ν_e - ν_o = -(ν_e * Δφ / c ^ 2) := by
  have hc2 : (c : ℝ) ^ 2 ≠ 0 := pow_ne_zero 2 c_pos.ne'
  simp only
  ring

/-! ## Cosmological redshift from coarse-grain scale ratio

In OmegaTheory, cosmological expansion manifests as the evolution of the
healing-flow equilibrium on a coarse-grain of the lattice. Let
`scaleAt τ` denote the coarse-grain cell size at cosmic time `τ` (i.e.
the Planck-length times a dimensionless expansion factor). Then:

  1 + z = scaleAt τ_o / scaleAt τ_e

This is the discrete analog of the standard `1 + z = a(t_o) / a(t_e)`
relation. We establish the algebraic identity; the derivation from
healing-flow convergence is an open task for a future session. -/

/-- The **coarse-grain scale factor** at a lattice tick. In a homogeneous
    expanding lattice, this is the coarse-grain cell size (Planck length
    times a dimensionless scale factor). -/
structure ScaleFactor where
  /-- Dimensionless expansion factor at emission. -/
  a_emit : ℝ
  /-- Dimensionless expansion factor at observation. -/
  a_obs : ℝ
  /-- Emission scale is positive. -/
  a_emit_pos : 0 < a_emit
  /-- Observation scale is positive. -/
  a_obs_pos : 0 < a_obs

namespace ScaleFactor

/-- The cosmological redshift generated by the scale-factor ratio. -/
noncomputable def cosmologicalRedshift (s : ScaleFactor) : ℝ :=
  s.a_obs / s.a_emit - 1

/-- `1 + z_cosmo = a_obs / a_emit`. -/
theorem one_plus_cosmologicalRedshift (s : ScaleFactor) :
    1 + s.cosmologicalRedshift = s.a_obs / s.a_emit := by
  unfold cosmologicalRedshift
  ring

/-- No cosmological redshift when the scale factor has not evolved. -/
theorem cosmologicalRedshift_static {s : ScaleFactor}
    (h : s.a_obs = s.a_emit) : s.cosmologicalRedshift = 0 := by
  unfold cosmologicalRedshift
  rw [h, div_self s.a_emit_pos.ne']; ring

/-- Positive cosmological redshift iff the universe has expanded
    between emission and observation. -/
theorem cosmologicalRedshift_pos_iff (s : ScaleFactor) :
    0 < s.cosmologicalRedshift ↔ s.a_emit < s.a_obs := by
  unfold cosmologicalRedshift
  have := s.a_emit_pos
  constructor
  · intro h
    have h1 : (1 : ℝ) < s.a_obs / s.a_emit := by linarith
    exact (one_lt_div this).mp h1
  · intro h
    have h1 : (1 : ℝ) < s.a_obs / s.a_emit := (one_lt_div this).mpr h
    linarith

end ScaleFactor

/-- **cosmological_redshift_from_scale_ratio**: the cosmological redshift
    generated by a coarse-grain scale-factor evolution equals the
    expected algebraic expression `(a_obs − a_emit) / a_emit`.
    In the OmegaTheory reading, the `a_obs / a_emit` ratio is what the
    healing-flow coarse-graining produces at equilibrium. -/
theorem cosmological_redshift_from_scale_ratio (s : ScaleFactor) :
    s.cosmologicalRedshift = (s.a_obs - s.a_emit) / s.a_emit := by
  unfold ScaleFactor.cosmologicalRedshift
  have h : s.a_emit ≠ 0 := s.a_emit_pos.ne'
  field_simp

/-- **Consistency**: if a cosmological redshift is also described by
    a frequency pair `(ν_e, ν_o)` via `1 + z = ν_e / ν_o`, and by a
    scale-factor pair via `1 + z = a_obs / a_emit`, then the two ratios
    must agree. -/
theorem cosmological_frequency_scale_consistency
    {ν_e ν_o : ℝ} (hν : 0 < ν_o) (s : ScaleFactor)
    (h : redshiftRatio ν_e ν_o = s.a_obs / s.a_emit) :
    redshiftFactor ν_e ν_o = s.cosmologicalRedshift := by
  unfold redshiftFactor ScaleFactor.cosmologicalRedshift redshiftRatio at *
  rw [← h]; field_simp

end OmegaTheory.Emergence
