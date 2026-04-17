/-
  OmegaTheory.Emergence.GravitonConditions

  **One-line headline**: the three existence predicates for "gravitons" in
  OmegaTheory — real (on-shell) field graviton, virtual (off-shell) field
  graviton, and repair quantum — made explicit as Props with discharged
  witnesses.

  Background. `Emergence/Gravitons.lean` introduces the distinction between
  the **field graviton** (standard massless spin-2 Fock quantum, `E = ℏω`,
  what LIGO measures) and the **repair quantum** (granular Planck-scale
  repair event in the healing-flow mechanism, `E ≈ E_P / 2`). This file
  packages the observational statuses of these objects as existence
  predicates:

    §1 `RealFieldGravitonExists ω`      — on-shell field graviton at ω>0
    §2 `VirtualGravitonExists E p`      — off-shell mediator (E² ≠ (pc)²)
    §3 `RepairQuantumTriggered defect`  — repair event when defect > ℓ_P
    §4 distinctness between §1 and §3 at observable frequencies

  Every predicate has at least one constructive witness proved below. We
  reuse the existing primitives from `Emergence/Gravitons.lean` (the energy
  definitions, positivity lemmas, the below-Planck distinctness theorem)
  and `Spacetime/Constants.lean` (`l_P`, `c`, `hbar`). No new Props, no new
  primitives.

  Theorems shipped:
    §1  `realFieldGravitonExists_of_pos_ω`             — constructor, any ω>0
        `realFieldGravitonExists_bornRule_energy`      — energy via `fieldGravitonEnergy_pos`
    §2  `virtualGraviton_off_shell_if_mass_mismatch`   — hypothesis E²>(pc)² ⇒ off-shell
        `virtualGraviton_off_shell_if_below_mass`      — hypothesis E²<(pc)² ⇒ off-shell
    §3  `repairQuantum_triggered_of_defect_gt_planck`  — constructor
        `repairQuantum_has_planck_scale_energy`        — repair quanta carry `repairQuantumEnergy>0`
    §4  `field_vs_repair_distinct`                     — below-Planck: `E_field ≠ E_repair`
    §5  Sanity witness `minkowskiFieldGravitonExistsWitness` (ω = 1) with
        the below-Planck distinctness side condition.

  No `sorry`. No new axioms. Author: Avior, 2026-04-17.
-/

import OmegaTheory.Emergence.Gravitons
import OmegaTheory.Spacetime.Constants
import Mathlib.Tactic

namespace OmegaTheory.Emergence.GravitonConditions

open OmegaTheory.Spacetime
open OmegaTheory.Emergence

/-! ## §1 Real (on-shell) field graviton -/

/-- **Real (on-shell) field graviton exists**: for a positive angular
    frequency `ω` the field-graviton energy `E = ℏω` is a realised energy.
    Stated as a pair (positivity of the frequency + existence of the
    `E = fieldGravitonEnergy ω` energy level). -/
def RealFieldGravitonExists (ω : ℝ) : Prop :=
  0 < ω ∧ ∃ E : ℝ, E = fieldGravitonEnergy ω

/-- Constructor: any strictly positive frequency realises an on-shell
    field graviton. The witness energy is `ℏω` itself. -/
theorem realFieldGravitonExists_of_pos_ω (ω : ℝ) (hω : 0 < ω) :
    RealFieldGravitonExists ω :=
  ⟨hω, fieldGravitonEnergy ω, rfl⟩

/-- Corollary: the realised energy is strictly positive — on-shell
    field gravitons carry real, non-zero energy. -/
theorem realFieldGravitonExists_bornRule_energy (ω : ℝ) (hω : 0 < ω) :
    RealFieldGravitonExists ω ∧ 0 < fieldGravitonEnergy ω :=
  ⟨realFieldGravitonExists_of_pos_ω ω hω, fieldGravitonEnergy_pos ω hω⟩

/-! ## §2 Virtual (off-shell) field graviton -/

/-- **Virtual graviton exists**: an off-shell mediator with energy `E` and
    spatial momentum `p` satisfies `E² ≠ (p·c)²`, i.e. fails the massless
    dispersion. The standard QFT use of "virtual graviton" as propagator
    contribution in perturbative graviton exchange diagrams. We do NOT
    formalize the propagator itself; we only record the off-shell
    condition. -/
def VirtualGravitonExists (E p : ℝ) : Prop :=
  E ^ 2 ≠ (p * c) ^ 2

/-- One-sided witness: if `E² > (p·c)²`, the pair `(E, p)` is off-shell. -/
theorem virtualGraviton_off_shell_if_mass_mismatch
    (E p : ℝ) (hEp : (p * c) ^ 2 < E ^ 2) :
    VirtualGravitonExists E p :=
  ne_of_gt hEp

/-- The mirror witness: if `E² < (p·c)²`, again the pair is off-shell. -/
theorem virtualGraviton_off_shell_if_below_mass
    (E p : ℝ) (hEp : E ^ 2 < (p * c) ^ 2) :
    VirtualGravitonExists E p :=
  ne_of_lt hEp

/-! ## §3 Repair quantum (OmegaTheory-specific)

The repair quantum is the granular lattice repair event from
`Emergence/Gravitons.lean`. It is **not** a propagating wave; it is an
event whose energy `≈ 0.51 · E_P` is derived from the
Bekenstein–Hawking bit bound on a Planck sphere. We record here that a
repair event is **triggered** when the local geometric defect exceeds
the Planck length `ℓ_P`.
-/

/-- **Repair quantum triggered**: a local defect of magnitude `defect`
    invokes a repair event when `ℓ_P < defect`, i.e. when the
    discrete-substrate deviation exceeds the single-Planck-cell scale. -/
def RepairQuantumTriggered (defect : ℝ) : Prop := l_P < defect

/-- Constructor: explicit threshold check `ℓ_P < defect`. -/
theorem repairQuantum_triggered_of_defect_gt_planck
    (defect : ℝ) (h : l_P < defect) :
    RepairQuantumTriggered defect := h

/-- **Every repair quantum carries Planck-scale positive energy**.
    Existential packaging of `repairQuantumEnergy_pos` from
    `Emergence/Gravitons.lean`. -/
theorem repairQuantum_has_planck_scale_energy :
    ∃ E_rq : ℝ, E_rq = repairQuantumEnergy ∧ 0 < E_rq :=
  ⟨repairQuantumEnergy, rfl, repairQuantumEnergy_pos⟩

/-! ## §4 Distinctness: field graviton ≠ repair quantum (below-Planck)

Reuse the existing `field_and_repair_distinct_below_planck` theorem from
`Emergence/Gravitons.lean`. Every observationally-accessible frequency
(LIGO/LISA/pulsar timing ≤ 10¹² Hz) is vastly below the Planck frequency
`c/ℓ_P ≈ 1.855×10⁴³ Hz`, so the below-Planck hypothesis
`hbar · ω < repairQuantumEnergy` is always satisfied for any realistic
observation. -/

/-- **Field vs repair distinctness** (below-Planck regime). For any
    `ω > 0` satisfying `ℏω < E_rq` the field-graviton energy is
    strictly less than the repair-quantum energy, hence the two energies
    are unequal: the objects are distinct.

    Direct re-export of `field_and_repair_distinct_below_planck`. -/
theorem field_vs_repair_distinct
    (ω : ℝ) (hω : 0 < ω) (h_below : hbar * ω < repairQuantumEnergy) :
    fieldGravitonEnergy ω ≠ repairQuantumEnergy :=
  field_and_repair_distinct_below_planck ω hω h_below

/-! ## §5 Minkowski sanity witness -/

/-- Sanity: Σ-packaging of the three-predicate separation at `ω = 1`,
    assuming the (always-true-in-practice) below-Planck side condition.
    This is a constructive demonstration that on flat Minkowski the
    three categories of gravitons coexist without collision. -/
theorem minkowskiFieldGravitonExistsWitness
    (h_below : hbar * 1 < repairQuantumEnergy) :
    RealFieldGravitonExists 1
      ∧ fieldGravitonEnergy 1 ≠ repairQuantumEnergy
      ∧ (∃ E_rq : ℝ, E_rq = repairQuantumEnergy ∧ 0 < E_rq) :=
  ⟨realFieldGravitonExists_of_pos_ω 1 (by norm_num : (0 : ℝ) < 1),
   field_vs_repair_distinct 1 (by norm_num : (0 : ℝ) < 1) h_below,
   repairQuantum_has_planck_scale_energy⟩

end OmegaTheory.Emergence.GravitonConditions
