/-
  OmegaTheory.Foundations.PhotonInformationSignature

  **Phase C step 2 (2026-05-06)**:
  *The PHOTON's specific informational signature in the healing-flow
  spacetime, matched both ways: substrate `gaugeInformation` and
  standard physics `(1/2)(|E|² + |B|²)`. The first concrete
  particle-signature-match theorem of the bridging program.*

  ## Why this file (the user's signature-match framework, 2026-05-06)

  > *"all the forces / particles, will have their specific events in
  > the healing flow spacetime, I mean they can be matched by
  > informational signature for given specific informationTensor
  > signature, and those signatures, we can derive in second way
  > using the standard physics, showing the match."*

  Each SM particle / force has a specific informational signature
  in the substrate.  That signature can be derived in TWO ways:
  (i) from the substrate's own `informationStressEnergyTensor`
  framework (Phase C step 1's `gaugeInformation`), (ii) from
  STANDARD PHYSICS (textbook stress-energy tensor for that field).

  The MATCH theorem connecting the two derivations IS the bridge.

  This file ships the FIRST particle-signature-match theorem: the
  PHOTON.  Substrate side: `gaugeInformation gc p = (1/2)·Σ F²`
  (Phase C step 1).  Standard physics side: the textbook
  electromagnetic energy density `u_EM = (1/2)(|E|² + |B|²)`,
  obtained by decomposing `F_{μν}` into electric and magnetic
  components per Landau-Lifshitz vol 2 §27 / Jackson §11.

  Match: `gaugeInformationPointwise gc p = |E|² + |B|² = 2 · u_EM`.

  The factor of 2 is a units convention choice; the substrate's
  natural sum-of-squares form differs from textbook density by an
  overall normalization that's calibrated, not derived.

  ## What this file ships

  | Property                                            | Theorem                              |
  |-----------------------------------------------------|--------------------------------------|
  | `electricFieldComponent gc p i` (E_i = F_{0i})       | def                                  |
  | `magneticFieldComponent gc p k` (B_k from F_{ij})    | def                                  |
  | `electricFieldNormSq gc p` (|E|² = Σ E_i²)           | def                                  |
  | `magneticFieldNormSq gc p` (|B|² = Σ B_k²)           | def                                  |
  | `photonEnergyDensityStandard gc p`                   | def: `(1/2)(|E|² + |B|²)`            |
  | `gaugeInformation_eq_E_sq_plus_B_sq`                 | match thm: substrate = E²+B²         |
  | `photon_signature_substrate_eq_2x_standard`          | match thm: substrate = 2 · standard  |
  | Headline                                             | `photon_information_signature_match` |

  ## Honest scope

  Pure linear-algebra decomposition of the antisymmetric 2-form
  `F_{μν}` into 6 components: 3 electric (`F_{0i}`, i = 1,2,3)
  + 3 magnetic (`F_{ij}` with i < j, identified with cyclic `ε_{ijk}·B_k`).

  This file does NOT formalize:
  * Maxwell's equations as substrate dynamics (Phase C step 5+).
  * The full continuum-Lorentz invariance (substrate is Euclidean
    discrete; Lorentz scalars require continuum machinery).
  * Photon polarization or spin-1 transverse modes (Phase C step 3+).

  What it DOES formalize: the photon's `(1/2)(E² + B²)` energy
  signature in the substrate, matched algebraically to the
  sum-of-F²-squared form.

  ## Lion's-Pride doctrine

  Rule 1: zero `sorry`.  Rule 2: zero new axioms.

  ## Author

  Single-thread Opus 4.7 [1M context]. Phase C step 2 of the
  signature-match framework (REVISED 2026-05-06).
-/

import OmegaTheory.Emergence.GaugeInformationDensity
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.PhotonInformationSignature

open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Emergence.ErrorGaugeField
open OmegaTheory.Emergence.GaugeInformationDensity

/-! ## 1. Electric-field components from F

    Standard EM decomposition: `E_i := F_{0i}` for `i = 1, 2, 3`.
    These are the time-space components of the antisymmetric F. -/

/-- **Electric-field component** at lattice point `p`: `E_i = F_{0i}`.

    Index `i : Fin 3` ranges over the 3 spatial directions; we
    embed into `Fin 4` via `Fin.succ` (so spatial 0 ↦ time-space 1,
    spatial 1 ↦ time-space 2, spatial 2 ↦ time-space 3). -/
noncomputable def electricFieldComponent
    (gc : GaugeConnection) (p : LatticePoint) (i : Fin 3) : ℝ :=
  (gaugeCurvature gc).form p 0 i.succ

/-- **Squared norm of the electric field** `|E|² = Σ_i E_i²`. -/
noncomputable def electricFieldNormSq
    (gc : GaugeConnection) (p : LatticePoint) : ℝ :=
  ∑ i : Fin 3, (electricFieldComponent gc p i) ^ 2

/-- **Non-negativity** of `|E|²`. -/
theorem electricFieldNormSq_nonneg
    (gc : GaugeConnection) (p : LatticePoint) :
    0 ≤ electricFieldNormSq gc p := by
  unfold electricFieldNormSq
  apply Finset.sum_nonneg
  intro i _
  exact sq_nonneg _

/-! ## 2. Magnetic-field components from F

    Standard EM decomposition: `B_k = (1/2)·ε_{ijk}·F_{ij}` or
    explicitly `B_1 = F_{23}, B_2 = F_{31} = -F_{13}, B_3 = F_{12}`.

    For simplicity (and matching the substrate's natural F²
    sum), we define the magnetic components as the F_{ij} with
    `i < j` directly — yielding 3 distinct components. -/

/-- **Magnetic-field component** at lattice point `p`: indexed by
    a pair `(i, j)` with `i < j` ranging over `{(1,2), (1,3), (2,3)}`.

    Concretely: `B 0 = F_{12}, B 1 = F_{13}, B 2 = F_{23}`. -/
noncomputable def magneticFieldComponent
    (gc : GaugeConnection) (p : LatticePoint) (k : Fin 3) : ℝ :=
  match k with
  | 0 => (gaugeCurvature gc).form p 1 2
  | 1 => (gaugeCurvature gc).form p 1 3
  | 2 => (gaugeCurvature gc).form p 2 3

/-- **Squared norm of the magnetic field** `|B|² = Σ_k B_k²`. -/
noncomputable def magneticFieldNormSq
    (gc : GaugeConnection) (p : LatticePoint) : ℝ :=
  ∑ k : Fin 3, (magneticFieldComponent gc p k) ^ 2

/-- **Non-negativity** of `|B|²`. -/
theorem magneticFieldNormSq_nonneg
    (gc : GaugeConnection) (p : LatticePoint) :
    0 ≤ magneticFieldNormSq gc p := by
  unfold magneticFieldNormSq
  apply Finset.sum_nonneg
  intro k _
  exact sq_nonneg _

/-! ## 3. Standard-physics photon energy density

    Textbook EM energy density (Gaussian units without `1/4π`):
    `u_EM := (1/2)(|E|² + |B|²)`. -/

/-- **Photon energy density (standard physics)**:
    `u_EM := (1/2)(|E|² + |B|²)`.

    This is the textbook electromagnetic field energy density
    (Landau-Lifshitz vol 2 §27, Jackson §11). -/
noncomputable def photonEnergyDensityStandard
    (gc : GaugeConnection) (p : LatticePoint) : ℝ :=
  (1 / 2) * (electricFieldNormSq gc p + magneticFieldNormSq gc p)

/-- **Non-negativity** of standard photon energy density. -/
theorem photonEnergyDensityStandard_nonneg
    (gc : GaugeConnection) (p : LatticePoint) :
    0 ≤ photonEnergyDensityStandard gc p := by
  unfold photonEnergyDensityStandard
  have hE := electricFieldNormSq_nonneg gc p
  have hB := magneticFieldNormSq_nonneg gc p
  linarith

/-! ## 4. The signature-match theorem

    The substrate-derived `gaugeInformation gc p = (1/2)·Σ F²` and
    the standard-physics `photonEnergyDensityStandard gc p =
    (1/2)(|E|² + |B|²)` are connected by a precise factor.

    Concretely: on the Euclidean lattice, the antisymmetric `F`
    has 6 distinct components (3 electric + 3 magnetic).  The
    full `Σ_{μ,ν} F²` double-counts (since `F_{νμ} = -F_{μν}`,
    and `(-x)² = x²`), giving `2·(|E|² + |B|²)` once we account
    for the diagonal entries `F_{μμ} = 0`.

    Hence:
      gaugeInformationPointwise gc p
        = (1/2)·Σ_{μ,ν} F²
        = (1/2)·(2·(|E|² + |B|²))
        = |E|² + |B|²
        = 2 · photonEnergyDensityStandard gc p. -/

/-- **Bookkeeping helper**: `F_{μμ} = 0` on the diagonal (antisymmetry
    forces it). -/
theorem gaugeCurvature_diag_zero
    (gc : GaugeConnection) (p : LatticePoint) (μ : Fin 4) :
    (gaugeCurvature gc).form p μ μ = 0 := by
  rw [gaugeCurvature_form]
  exact (d1_antisymmetric gc.potential).diag_zero p μ

/-- **Headline match theorem (rough form)**:
    `gaugeInformationPointwise gc p = 2 · photonEnergyDensityStandard gc p`.

    The substrate's natural sum-of-squares density is exactly twice
    the textbook electromagnetic energy density.  The factor of 2
    is a units convention; both densities are non-negative and
    vanish iff the field is zero.  The match shows the substrate
    encoding REDUCES TO standard EM physics under the natural
    decomposition. -/
theorem photon_signature_substrate_eq_2x_standard
    (gc : GaugeConnection) (p : LatticePoint) :
    gaugeInformationPointwise gc p =
      electricFieldNormSq gc p + magneticFieldNormSq gc p := by
  unfold gaugeInformationPointwise electricFieldNormSq magneticFieldNormSq
        electricFieldComponent magneticFieldComponent
  -- Goal: (1/2)·Σ_{μν} F² = Σ_i (F_{0i.succ})² + Σ_k B_k²
  -- where the 4×4 sum has 16 terms; subtracting 4 diagonals = 0
  -- leaves 12 = 2 × 6 (3 electric + 3 magnetic) double-counted.
  -- Reduce: F_{0,1}² + F_{0,2}² + F_{0,3}² (electric) twice
  --        + F_{1,2}² + F_{1,3}² + F_{2,3}² (magnetic) twice
  --        + F_{0,0}² + F_{1,1}² + F_{2,2}² + F_{3,3}² = 0
  have h00 := gaugeCurvature_diag_zero gc p 0
  have h11 := gaugeCurvature_diag_zero gc p 1
  have h22 := gaugeCurvature_diag_zero gc p 2
  have h33 := gaugeCurvature_diag_zero gc p 3
  -- Antisymmetry: F_νμ = -F_μν, so F_νμ² = F_μν²
  have ha := d1_antisymmetric gc.potential
  rw [show (1 : Fin 4) = (0 : Fin 3).succ from rfl,
      show (2 : Fin 4) = (1 : Fin 3).succ from rfl,
      show (3 : Fin 4) = (2 : Fin 3).succ from rfl]
  have h10 : (gaugeCurvature gc).form p 1 0 =
              -(gaugeCurvature gc).form p 0 1 := by
    rw [gaugeCurvature_form]; exact ha p 1 0
  have h20 : (gaugeCurvature gc).form p 2 0 =
              -(gaugeCurvature gc).form p 0 2 := by
    rw [gaugeCurvature_form]; exact ha p 2 0
  have h30 : (gaugeCurvature gc).form p 3 0 =
              -(gaugeCurvature gc).form p 0 3 := by
    rw [gaugeCurvature_form]; exact ha p 3 0
  have h21 : (gaugeCurvature gc).form p 2 1 =
              -(gaugeCurvature gc).form p 1 2 := by
    rw [gaugeCurvature_form]; exact ha p 2 1
  have h31 : (gaugeCurvature gc).form p 3 1 =
              -(gaugeCurvature gc).form p 1 3 := by
    rw [gaugeCurvature_form]; exact ha p 3 1
  have h32 : (gaugeCurvature gc).form p 3 2 =
              -(gaugeCurvature gc).form p 2 3 := by
    rw [gaugeCurvature_form]; exact ha p 3 2
  -- Expand both sides
  simp [Fin.sum_univ_four, Fin.sum_univ_three, h00, h11, h22, h33,
        h10, h20, h30, h21, h31, h32]
  ring

/-- **Substrate density equals 2× textbook density** (cleaner form). -/
theorem gaugeInformationPointwise_eq_two_times_standard
    (gc : GaugeConnection) (p : LatticePoint) :
    gaugeInformationPointwise gc p = 2 * photonEnergyDensityStandard gc p := by
  unfold photonEnergyDensityStandard
  rw [photon_signature_substrate_eq_2x_standard]
  ring

/-! ## 5. Headline composite — first particle-signature match -/

/-- **Phase C step 2 headline — photon information signature match.**

    Five-conjunct establishing the photon's specific signature both
    ways:

    1. **Electric-field non-negativity**: `0 ≤ |E|² = Σ_i (F_{0i})²`.

    2. **Magnetic-field non-negativity**: `0 ≤ |B|² = Σ_k B_k²`.

    3. **Substrate-side match**: `gaugeInformationPointwise gc p
       = |E|² + |B|²`.  The substrate's natural sum-of-squares form
       reduces to the textbook electric + magnetic decomposition.

    4. **Substrate = 2 × standard**: `gaugeInformationPointwise =
       2 · photonEnergyDensityStandard`.  The factor of 2 is a
       units convention.

    5. **Standard density non-negativity**: `0 ≤ photonEnergyDensityStandard`.

    This is the FIRST particle-signature-match theorem in the
    bridging program.  Subsequent files will do the gluon (Phase C
    step 3), the EM force coupling current (Phase C step 4), and
    the charged-particle interaction (Phase C step 5+). -/
theorem photon_information_signature_match
    (gc : GaugeConnection) (p : LatticePoint) :
    0 ≤ electricFieldNormSq gc p ∧
    0 ≤ magneticFieldNormSq gc p ∧
    gaugeInformationPointwise gc p =
      electricFieldNormSq gc p + magneticFieldNormSq gc p ∧
    gaugeInformationPointwise gc p =
      2 * photonEnergyDensityStandard gc p ∧
    0 ≤ photonEnergyDensityStandard gc p := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact electricFieldNormSq_nonneg gc p
  · exact magneticFieldNormSq_nonneg gc p
  · exact photon_signature_substrate_eq_2x_standard gc p
  · exact gaugeInformationPointwise_eq_two_times_standard gc p
  · exact photonEnergyDensityStandard_nonneg gc p

end OmegaTheory.Foundations.PhotonInformationSignature
