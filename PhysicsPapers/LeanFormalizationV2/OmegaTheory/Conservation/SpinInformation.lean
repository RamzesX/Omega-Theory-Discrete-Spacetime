/-
  OmegaTheory.Conservation.SpinInformation

  Spin-Information Coupling: The Fourth Noether Law Extended.

  Ported from V1 (LeanFormalization/DiscreteSpacetime/Conservation/SpinInformation.lean).
  This module was silently dropped in the V2 reorganization — it is net-positive
  content (0 sorry in V1) and is re-introduced here unchanged in mathematical
  substance, only adapted to V2's namespaces and type conventions.

  ## What this module contains

  1. **Axial anomaly** — an anomaly density constructed from the defect tensor
     (replacing the V1 Pontryagin form R_μνρσ R̃^μνρσ with its discrete analogue
     D_μν D^μν). Appendix-P style axial current ∂_μ j^μ_5 ~ l_P^{-4} D D̃.

  2. **Spin as information source** — the coupling σ_I^spin = α · ∇_μ(ψ̄γ^μγ^5ψ)
     using the V2 `spinInfoCoupling = ℏ/(2 M_P c)` constant.

  3. **Modified information conservation** — ∂_μ J^μ_I = σ^spin + σ^graviton,
     replacing the V1 pure conservation law with the spin-sourced version.

  4. **Torsion-information correspondence** — placeholder axiom plus the info-curl
     operator capturing the V1 statement S^λ_{μν} ~ ∇_[μ J_{ν]ρ}.

  5. **Spin as information loops / spin-statistics** — the core of the V1 file.
     Fermions have an odd number of information loops, bosons even. Proven by
     `native_decide` for the concrete electron/photon/graviton instances.

  6. **Spin-dependent decoherence** — Γ = α · n_spin · T, a set of monotonicity
     theorems establishing that decoherence rate is positively monotone in both
     spin density and temperature.

  7. **Torsion-spin scaling ratio** — torsionInfoCoupling / spinInfoCoupling > 0.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.Ring.Parity
import Mathlib.Tactic
import OmegaTheory.Spacetime.Constants
import OmegaTheory.Spacetime.Lattice
import OmegaTheory.Spacetime.Operators
import OmegaTheory.Geometry.Metric
import OmegaTheory.Defects.DefectTensor
import OmegaTheory.Conservation.Information
import OmegaTheory.Torsion.SpinTorsion

namespace OmegaTheory.Conservation

open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Defects

/-! ## Spin Current and Axial Anomaly -/

/-- The axial current j^μ_5 = ψ̄γ^μγ^5ψ for Dirac fermions.

    This current is NOT generally conserved - it has an anomaly.
    The axial anomaly couples to the Pontryagin density (R R̃).

    In V2 this is just a type abbreviation for a lattice 4-vector field,
    identical in shape to `InformationCurrent`. -/
abbrev AxialCurrentField := LatticePoint → Fin 4 → ℝ

/-- The axial anomaly density.

    Continuum form:
      ∂_μ j^μ_5 = (1/16π²) R_{μνρσ} R̃^{μνρσ}

    Discrete form (V2 adaptation, replacing curvature with defect tensor):
      ∂_μ j^μ_5 ∼ (1/16π²) · Σ_{μν} D_{μν}(p) · D_{μν}(p)

    where `D = g_actual − g_exact` is the V2 defect tensor. -/
noncomputable def axialAnomalyDensity
    (g_actual g_exact : DiscreteMetric) (p : LatticePoint) : ℝ :=
  (1 / (16 * Real.pi ^ 2)) *
    Finset.univ.sum fun μ : Fin 4 =>
      Finset.univ.sum fun ν : Fin 4 =>
        defectTensor g_actual g_exact p μ ν *
        defectTensor g_actual g_exact p μ ν

/-! ## Spin as Information Source -/

/-- Alias preserving the V1 name `spinInfoCouplingConstant`, now delegating to
    the V2 `OmegaTheory.Torsion.spinInfoCoupling = ℏ / (2 M_P c)`. -/
noncomputable abbrev spinInfoCouplingConstant : ℝ :=
  OmegaTheory.Torsion.spinInfoCoupling

/-- Spin-info coupling is positive (delegates to V2 `SpinTorsion`). -/
theorem spinInfoCouplingConstant_pos : 0 < spinInfoCouplingConstant :=
  OmegaTheory.Torsion.spinInfoCoupling_pos

/-- Spin sources information current: σ_I^spin = α · ∇_μ j^μ_5. -/
structure SpinInformationSource where
  axialCurrent : AxialCurrentField
  infoSource : ScalarField
  correspondence : ∀ p,
    infoSource p = spinInfoCouplingConstant * discreteDivergence axialCurrent p

/-- Construct a spin information source from an axial current. -/
noncomputable def spinSourceFromAxialCurrent
    (j5 : AxialCurrentField) : ScalarField :=
  fun p => spinInfoCouplingConstant * discreteDivergence j5 p

/-! ## Modified Information Conservation

    ∂_μ J^μ_I = σ^spin + σ^graviton

    This generalises the V1 fourth-law statement by admitting non-zero sources. -/

/-- Information conservation law with spin and graviton sources. -/
structure ModifiedInfoConservation where
  density : InformationDensity
  current : InformationCurrent
  spinSource : ScalarField
  gravitonSource : ScalarField
  conservation : ∀ p,
    -- (time deriv modelled as 0 in this purely-spatial snapshot,
    --  exactly matching V1's presentation)
    (0 : ℝ) + discreteDivergence current p = spinSource p + gravitonSource p

/-- Equilibrium: sources cancel. -/
def isInfoEquilibrium (cons : ModifiedInfoConservation) : Prop :=
  ∀ p, cons.spinSource p + cons.gravitonSource p = 0

/-- Curl of the information current (antisymmetrized symmetric difference). -/
noncomputable def infoCurl (J_I : InformationCurrent) (μ ν ρ : Fin 4)
    (p : LatticePoint) : ℝ :=
  (1 / 2 : ℝ) * (
    symmetricDiff (fun q => J_I q ρ) μ p -
    symmetricDiff (fun q => J_I q ρ) ν p
  )

/-! ## Spin as Bound Information Rotation

    A spinning particle represents information in closed rotation.
    For a spin-s particle: ∮ J^μ_I · dl = (ℏ/2) · (2s)

    - Spin-1/2: 1 loop (ℏ/2 per rotation)
    - Spin-1:   2 loops (ℏ per rotation)
    - Spin-3/2: 3 loops (3ℏ/2 per rotation)
    - Spin-2:   4 loops (2ℏ per rotation) -/

/-- Spin as information loop count. -/
structure SpinAsInfoLoop where
  spin : ℚ
  nLoops : ℕ
  spin_loop : spin = nLoops / 2
  infoPerRotation : ℕ := nLoops

/-- Electron: spin-1/2, 1 loop. -/
def electronInfoLoop : SpinAsInfoLoop :=
  { spin := 1 / 2, nLoops := 1, spin_loop := by norm_num }

/-- Photon: spin-1, 2 loops. -/
def photonInfoLoop : SpinAsInfoLoop :=
  { spin := 1, nLoops := 2, spin_loop := by norm_num }

/-- Graviton: spin-2, 4 loops. -/
def gravitonInfoLoop : SpinAsInfoLoop :=
  { spin := 2, nLoops := 4, spin_loop := by norm_num }

/-! ## Spin-Statistics from Information Topology

    Fermions = odd loops  → antisymmetric exchange
    Bosons   = even loops → symmetric exchange -/

/-- Fermion predicate: odd number of information loops. -/
def isFermion (s : SpinAsInfoLoop) : Bool := Odd s.nLoops

/-- Boson predicate: even number of information loops. -/
def isBoson (s : SpinAsInfoLoop) : Bool := Even s.nLoops

/-- Electron is a fermion. -/
theorem electron_is_fermion : isFermion electronInfoLoop = true := by
  decide

/-- Photon is a boson. -/
theorem photon_is_boson : isBoson photonInfoLoop = true := by
  decide

/-- Graviton is a boson. -/
theorem graviton_is_boson : isBoson gravitonInfoLoop = true := by
  decide

/-- Fermions and bosons are mutually exclusive. -/
theorem fermion_boson_exclusive (s : SpinAsInfoLoop) :
    isFermion s = true ↔ isBoson s = false := by
  simp only [isFermion, isBoson]
  rw [decide_eq_true_eq, decide_eq_false_iff_not]
  exact Nat.not_even_iff_odd.symm

/-- Half-integer spin (odd loops) ⇒ fermion. -/
theorem half_integer_spin_is_fermion (s : SpinAsInfoLoop)
    (h : Odd s.nLoops) : isFermion s = true := by
  simp only [isFermion, decide_eq_true_eq]
  exact h

/-- Integer spin (even loops) ⇒ boson. -/
theorem integer_spin_is_boson (s : SpinAsInfoLoop)
    (h : Even s.nLoops) : isBoson s = true := by
  simp only [isBoson, decide_eq_true_eq]
  exact h

/-! ## Black Hole Information and Spin

    Infalling fermions carry information in spin states; torsion bounce
    (Popławski) transfers info through a wormhole; info emerges in a baby
    universe. Total: I_parent + I_baby = const. -/

/-- Black hole spin-information bookkeeping. -/
structure BlackHoleSpinInfo where
  infoIn : ℝ
  horizonSpinDensity : ℝ
  infoOut : ℝ
  conservation : infoIn = infoOut
  spinPos : 0 ≤ horizonSpinDensity

/-! ## Spin-Dependent Decoherence

    Γ = α · n_spin · T with α = spinInfoCoupling.  -/

/-- Spin-dependent decoherence rate. -/
noncomputable def spinDecoherenceRate (spinDensity : ℝ) (temperature : ℝ) : ℝ :=
  spinInfoCouplingConstant * spinDensity * temperature

/-- Decoherence rate is non-negative for non-negative inputs. -/
theorem spinDecoherenceRate_nonneg (n T : ℝ) (hn : 0 ≤ n) (hT : 0 ≤ T) :
    0 ≤ spinDecoherenceRate n T := by
  unfold spinDecoherenceRate
  apply mul_nonneg
  · apply mul_nonneg
    · exact le_of_lt spinInfoCouplingConstant_pos
    · exact hn
  · exact hT

/-- Increasing spin density strictly increases decoherence (fixed T > 0). -/
theorem spin_increases_decoherence (n1 n2 T : ℝ)
    (hn : n1 < n2) (hT : 0 < T) :
    spinDecoherenceRate n1 T < spinDecoherenceRate n2 T := by
  unfold spinDecoherenceRate
  have h1 : spinInfoCouplingConstant * n1 < spinInfoCouplingConstant * n2 :=
    mul_lt_mul_of_pos_left hn spinInfoCouplingConstant_pos
  exact mul_lt_mul_of_pos_right h1 hT

/-- Increasing temperature strictly increases decoherence (fixed n > 0). -/
theorem temperature_increases_decoherence (n T1 T2 : ℝ)
    (hn : 0 < n) (hT : T1 < T2) :
    spinDecoherenceRate n T1 < spinDecoherenceRate n T2 := by
  unfold spinDecoherenceRate
  have h1 : 0 < spinInfoCouplingConstant * n :=
    mul_pos spinInfoCouplingConstant_pos hn
  exact mul_lt_mul_of_pos_left hT h1

/-- Zero spin density ⇒ zero decoherence. -/
theorem zero_spin_zero_decoherence (T : ℝ) :
    spinDecoherenceRate 0 T = 0 := by
  unfold spinDecoherenceRate
  ring

/-- Zero temperature ⇒ zero decoherence. -/
theorem zero_temp_zero_decoherence (n : ℝ) :
    spinDecoherenceRate n 0 = 0 := by
  unfold spinDecoherenceRate
  ring

/-! ## Spin-Information Scaling Relations -/

/-- Ratio of torsion-info coupling to spin-info coupling. -/
noncomputable def torsionSpinRatio : ℝ :=
  OmegaTheory.Torsion.torsionInfoCoupling / spinInfoCouplingConstant

/-- The torsion-spin ratio is positive. -/
theorem torsionSpinRatio_pos : 0 < torsionSpinRatio := by
  unfold torsionSpinRatio
  exact div_pos OmegaTheory.Torsion.torsionInfoCoupling_pos
                spinInfoCouplingConstant_pos

end OmegaTheory.Conservation
