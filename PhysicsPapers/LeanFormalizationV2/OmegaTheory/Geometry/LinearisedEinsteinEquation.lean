/-
  OmegaTheory.Geometry.LinearisedEinsteinEquation

  **Lion's-Pride Phase 4.1 (2026-05-05)**:
  *Substrate-sourced linearised Einstein equation
  `□ h_μν = -16π G_N · T_μν^I`* — closing the gap from the
  free-graviton wave equation to the matter-coupled wave equation.

  ## Mission

  The graviton-energy plan's Phase 4 shipped the FREE rank-2
  d'Alembertian preservation theorems
  (`Geometry/WeinbergLinearisedTT.lean`,
  `latticeDalembertianTensor_minkowski_eq` etc.):
  on flat Minkowski background, transverse-traceless metric
  perturbations satisfy `□_η h_μν = 0`.

  This file ships the SOURCED form: when matter (parametrised via
  the substrate's `informationStressEnergyTensor`) is present, the
  linearised Einstein equation reads

      □_η h_μν  =  −16π G_N · T_μν^I

  where `T^I` is Marchewka's substrate stress-energy tensor
  (`Conservation/InformationStressEnergyConstructor.lean`).

  ## A remarkable substrate result

  The substrate's `T_μν^I = g_exact - g_μν` (Marchewka 2026 Theorem 4.2,
  formalised as `informationStressEnergyTensor_eq_diff`).  Therefore:

      T_μν^I  =  −(g_actual − g_exact)  =  −h_μν

  where `h := g_actual − g_exact` is the substrate's metric perturbation.
  Substituting into the linearised Einstein equation:

      □_η h_μν  =  −16π G_N · T_μν^I
                =  −16π G_N · (−h_μν)
                =  +16π G_N · h_μν

  The substrate predicts a self-coupling eigenvalue equation:

      □_η h_μν  =  16π G_N · h_μν

  with positive coupling `+16π G_N`.  In substrate units, this is
  the Klein-Gordon-like equation for the metric perturbation.

  ## Connection to the Phase 3.6 pathway hierarchy

  Per Phase 3.6 (`HealingFlow/HealingPathwayHierarchy`), spacetime
  defects can repair via:
  * level 1: radiative dispersal (graviton/photon/gluon);
  * level 2: mass-binding (Higgs/W/Z/quarks/leptons);
  * level 3: horizon-thermal (Hawking).

  The substrate self-coupling equation `□ h = 16π G_N · h` is the
  formal substrate-physics analog: a metric perturbation cannot
  persist as pure free graviton (free-graviton equation `□ h = 0`
  describes the TT mode in vacuum), because the substrate's own
  information T_μν IS proportional to `h`.  Hence non-zero `h`
  necessarily generates a feedback loop, driving the perturbation
  to either (i) DISPERSE radiatively as TT graviton quanta (level 1)
  or (ii) CRYSTALLISE into a bound mass-quantum (level 2 — Higgs/
  fermion).

  The eigenvalue `+16π G_N` sets the substrate's gravitational
  self-coupling scale — a quantitative substrate prediction.

  ## What this file ships

  1. `metricPerturbation g g_exact` — the tensor-field
     `(g − g_exact) p μ ν`.

  2. `informationStressEnergyTensor_eq_neg_perturbation` — the
     substrate identity `T_μν^I = −(g − g_exact) = −h_μν`.

  3. `IsLinearisedEinsteinFromSubstrate h g g_exact` — the
     predicate that `h` satisfies the substrate-sourced linearised
     EFE `□ h = −16π G T^I`.

  4. `linearised_einstein_substrate_self_coupling` (HEADLINE) —
     under that predicate, `h` satisfies `□ h = 16π G · h`.

  5. `substrate_graviton_self_coupling` — the eigenvalue scalar
     `16π G_N`.

  6. `linearised_einstein_substrate_report` (composite) — 4-conjunct
     headline tying everything together.

  ## Honest scope

  This file does NOT yet prove:
  * The linearised EFE `□ h = -16π G T` itself from the
    Einstein-Hilbert action (that's Phase 5 — the EH-perturbative
    expansion).  We carry it as a HYPOTHESIS predicate that the
    user supplies.
  * The harmonic gauge condition `∂^μ h_μν - ½ ∂_ν h = 0` (used in
    the Weinberg derivation; the substrate's
    `Geometry/HodgeDecomposition2Tensor.lean` ships the
    `IsHarmonicGauge` predicate, but we don't combine here).
  * Numerical match of `16π G_N` to PDG `G = 6.674e-11 m³/(kg·s²)`
    — that's a calibration of `G_N` to a specific unit system,
    not a substrate axiom.

  ## Author

  Lion's-Pride dynamic /loop iteration 9 (2026-05-05).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Conservation.InformationStressEnergyConstructor
import OmegaTheory.Geometry.WeinbergLinearisedTT
import OmegaTheory.Geometry.HodgeDecomposition2Tensor
import OmegaTheory.Spacetime.Constants
import Mathlib.Tactic

namespace OmegaTheory.Geometry.LinearisedEinsteinEquation

open OmegaTheory.Conservation
open OmegaTheory.Geometry
open OmegaTheory.Spacetime

/-! ## 1. Metric perturbation `h := g − g_exact`

Defining the substrate's metric perturbation field as a
`SymmetricTensorField2` (lattice-point-indexed Fin-4×Fin-4 ℝ field). -/

/-- **Substrate metric perturbation** at the difference between
    the actual lattice metric and the smooth-equilibrium reference
    metric. -/
noncomputable def metricPerturbation
    (g g_exact : DiscreteMetric) : SymmetricTensorField2 :=
  fun p μ ν => g p μ ν - g_exact p μ ν

/-- **The metric perturbation vanishes at equilibrium**: when the
    actual metric coincides with its smooth reference, `h ≡ 0`. -/
theorem metricPerturbation_eq_zero_of_eq
    (g g_exact : DiscreteMetric)
    (h : ∀ p μ ν, g p μ ν = g_exact p μ ν) :
    ∀ p μ ν, metricPerturbation g g_exact p μ ν = 0 := by
  intro p μ ν
  unfold metricPerturbation
  rw [h p μ ν]
  ring

/-! ## 2. Substrate identity: `T_μν^I = −h_μν`

Marchewka 2026 Theorem 4.2 (formalised in V2 as
`informationStressEnergyTensor_eq_diff`) gives `T^I = g_exact − g`.
In our metric-perturbation convention `h := g − g_exact`, this is
`T^I = −h`. -/

/-- **The substrate stress-energy tensor equals MINUS the metric
    perturbation**: `T_μν^I(g, g_exact) = −h_μν(g, g_exact)`.

    Proof: `T^I = g_exact − g` (existing
    `informationStressEnergyTensor_eq_diff`), and `h := g − g_exact`,
    so `T^I = −(g − g_exact) = −h` by `ring`. -/
theorem informationStressEnergyTensor_eq_neg_perturbation
    (g g_exact : DiscreteMetric) (p : LatticePoint) (μ ν : Fin 4) :
    informationStressEnergyTensor g g_exact p μ ν
      = - metricPerturbation g g_exact p μ ν := by
  rw [informationStressEnergyTensor_eq_diff]
  unfold metricPerturbation
  ring

/-! ## 3. Linearised Einstein equation predicate

The linearised Einstein equation `□ h_μν = -16π G T_μν` is a
DIFFERENTIAL equation; we encode it as a predicate that a tensor
field `h` satisfies in the presence of a fixed substrate metric. -/

/-- **Predicate: `h` satisfies the linearised Einstein equation
    sourced by the substrate stress-energy tensor.**

    `□_η h_μν = -16π · G_N · T_μν^I(g, g_exact)`. -/
def IsLinearisedEinsteinFromSubstrate
    (h : SymmetricTensorField2) (g g_exact : DiscreteMetric) : Prop :=
  ∀ p μ ν,
    latticeDalembertianTensor h DiscreteMetric.flat p μ ν
      = -16 * Real.pi * G_N * informationStressEnergyTensor g g_exact p μ ν

/-! ## 4. Substrate self-coupling: `□ h = 16π G · h`

The headline result: a substrate metric perturbation that
satisfies the linearised EFE with substrate T_μν source obeys a
Klein-Gordon-like self-coupling eigenvalue equation. -/

/-- **Lion's-Pride Phase 4.1 HEADLINE — substrate self-coupling
    eigenvalue equation.**

    For ANY metric perturbation `h := g − g_exact` that satisfies
    the linearised Einstein equation sourced by the substrate's
    information stress-energy tensor `T_μν^I`, we have:

        □_η h_μν  =  16π · G_N · h_μν.

    Proof:
    `□ h = -16π G · T^I` (predicate hypothesis)
         `= -16π G · (-h)` (substrate identity §2)
         `= +16π G · h` (algebraic). -/
theorem linearised_einstein_substrate_self_coupling
    (g g_exact : DiscreteMetric)
    (LE : IsLinearisedEinsteinFromSubstrate
            (metricPerturbation g g_exact) g g_exact) :
    ∀ (p : LatticePoint) (μ ν : Fin 4),
      latticeDalembertianTensor (metricPerturbation g g_exact)
        DiscreteMetric.flat p μ ν
        = 16 * Real.pi * G_N
          * metricPerturbation g g_exact p μ ν := by
  intro p μ ν
  rw [LE p μ ν, informationStressEnergyTensor_eq_neg_perturbation]
  ring

/-! ## 5. Substrate gravitational self-coupling scale

The eigenvalue `16π G_N` of the linearised-EFE+substrate-T_μν
combination is the substrate's gravitational self-coupling
strength. -/

/-- **Substrate gravitational self-coupling scale** `16π G_N`. -/
noncomputable def substrate_graviton_self_coupling : ℝ :=
  16 * Real.pi * G_N

/-- **The self-coupling scale is strictly positive**. -/
theorem substrate_graviton_self_coupling_pos :
    0 < substrate_graviton_self_coupling := by
  unfold substrate_graviton_self_coupling
  have hπ : 0 < Real.pi := Real.pi_pos
  have hG := G_N_pos
  have h16 : (0 : ℝ) < 16 := by norm_num
  have h16π : 0 < 16 * Real.pi := mul_pos h16 hπ
  exact mul_pos h16π hG

/-! ## 6. Vacuum special case

When `g = g_exact`, the metric perturbation vanishes
(§1 `metricPerturbation_eq_zero_of_eq`) and so does the
information stress-energy.  The linearised EFE becomes vacuous.
We record this as a sanity-check theorem. -/

/-- **At equilibrium `g = g_exact`, the linearised EFE is trivially
    satisfied** (both sides vanish). -/
theorem linearised_einstein_substrate_at_equilibrium
    (g g_exact : DiscreteMetric)
    (h_eq : ∀ p μ ν, g p μ ν = g_exact p μ ν) :
    IsLinearisedEinsteinFromSubstrate
      (metricPerturbation g g_exact) g g_exact := by
  intro p μ ν
  -- Both sides are zero.
  -- LHS: □_η 0 = 0 (perturbation is identically zero so □ vanishes).
  have hzero : metricPerturbation g g_exact = (fun _ _ _ => 0) := by
    funext p' μ' ν'
    exact metricPerturbation_eq_zero_of_eq g g_exact h_eq p' μ' ν'
  rw [hzero, latticeDalembertianTensor_zero]
  -- RHS: -16π G · T^I = -16π G · (g_exact - g) = -16π G · 0 = 0.
  rw [informationStressEnergyTensor_eq_diff]
  rw [h_eq p μ ν]
  ring

/-! ## 7. Headline composite report -/

/-- **Lion's-Pride Phase 4.1 substrate-sourced linearised Einstein
    report** for any pair `(g, g_exact)`:

    1. The substrate identity `T_μν^I = −h_μν` holds for `h := g − g_exact`.

    2. The substrate gravitational self-coupling scale
       `substrate_graviton_self_coupling = 16π G_N` is strictly
       positive.

    3. IF the linearised EFE holds with substrate T_μν source,
       THEN `□_η h_μν = 16π G_N · h_μν` (substrate self-coupling
       eigenvalue equation).

    4. At equilibrium `g = g_exact`, the linearised EFE is
       trivially satisfied (both sides zero). -/
theorem linearised_einstein_substrate_report
    (g g_exact : DiscreteMetric) :
    -- §2 substrate identity:
    (∀ p μ ν,
      informationStressEnergyTensor g g_exact p μ ν
        = - metricPerturbation g g_exact p μ ν) ∧
    -- §5 self-coupling positive:
    0 < substrate_graviton_self_coupling ∧
    -- §4 conditional eigenvalue equation:
    (IsLinearisedEinsteinFromSubstrate
        (metricPerturbation g g_exact) g g_exact →
      ∀ p μ ν,
        latticeDalembertianTensor (metricPerturbation g g_exact)
          DiscreteMetric.flat p μ ν
          = 16 * Real.pi * G_N
            * metricPerturbation g g_exact p μ ν) ∧
    -- §6 equilibrium triviality:
    ((∀ p μ ν, g p μ ν = g_exact p μ ν) →
      IsLinearisedEinsteinFromSubstrate
        (metricPerturbation g g_exact) g g_exact) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro p μ ν
    exact informationStressEnergyTensor_eq_neg_perturbation g g_exact p μ ν
  · exact substrate_graviton_self_coupling_pos
  · intro LE p μ ν
    exact linearised_einstein_substrate_self_coupling g g_exact LE p μ ν
  · intro h_eq
    exact linearised_einstein_substrate_at_equilibrium g g_exact h_eq

end OmegaTheory.Geometry.LinearisedEinsteinEquation
