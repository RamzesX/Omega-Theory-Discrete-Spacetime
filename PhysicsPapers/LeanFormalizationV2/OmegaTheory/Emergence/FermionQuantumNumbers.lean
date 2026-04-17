/-
  OmegaTheory.Emergence.FermionQuantumNumbers

  **Full SU(2) × U(1)_Y × SU(3) quantum-number assignments for SM fermions.**

  Builds on:
    * `FermionContent`    — `WeakIsospin`, fermion species bundles
    * `FermionHypercharge` — rational hypercharges Y ∈ ℚ

  We now bundle the *complete* triple of representation labels per species:
      (SU(2) rep, U(1)_Y charge, SU(3) rep)
  and verify the Gell-Mann–Nishijima relation
      Q = T₃ + Y
  (convention matching `FermionHypercharge.lean`, with Y_L_lepton = −1/2)
  for every Standard-Model species, together with the standard electric
  charges (−1, +2/3, −1/3, 0). The alternative convention Q = T₃ + Y/2
  with doubled hypercharges is mentioned in the docs of individual
  species but not used in proofs.

  Everything is numerical: `decide`, `rfl`, `norm_num`. No sorry. No new
  axioms.

  Agent: Merak (β Ursae Majoris), 2026-04-17.
-/

import OmegaTheory.Emergence.FermionContent
import OmegaTheory.Emergence.FermionHypercharge
import Mathlib.Tactic

namespace OmegaTheory.Emergence.FermionQuantumNumbers

open OmegaTheory.Emergence
open OmegaTheory.Emergence.FermionContent

/-! ## 1. SU(2) representations

Only the fundamental and trivial representations appear in the Standard
Model fermion sector. -/

/-- SU(2) representation label restricted to SM fermions. -/
inductive SU2Rep
  /-- The 1-dimensional trivial representation (T = 0). -/
  | Singlet
  /-- The 2-dimensional fundamental representation (T = 1/2). -/
  | Doublet
  deriving DecidableEq, Fintype, Repr

namespace SU2Rep

/-- Dimension of the representation. -/
def dim : SU2Rep → ℕ
  | Singlet => 1
  | Doublet => 2

/-- Total weak isospin T (not T₃) as a rational number. -/
def totalIsospin : SU2Rep → ℚ
  | Singlet => 0
  | Doublet => 1 / 2

@[simp] theorem dim_singlet : dim Singlet = 1 := rfl
@[simp] theorem dim_doublet : dim Doublet = 2 := rfl

theorem card_eq : Fintype.card SU2Rep = 2 := by decide

end SU2Rep

/-! ## 2. SU(3) colour representations

Quarks sit in the fundamental **3**, leptons in the trivial **1**. We do
not need the anti-fundamental or adjoint for this file. -/

/-- SU(3) representation label restricted to SM fermions. -/
inductive SU3Rep
  /-- Colour singlet (trivial, dim 1): leptons. -/
  | ColorSinglet
  /-- Fundamental triplet (dim 3): quarks. -/
  | Triplet
  deriving DecidableEq, Fintype, Repr

namespace SU3Rep

/-- Dimension of the representation. -/
def dim : SU3Rep → ℕ
  | ColorSinglet => 1
  | Triplet      => 3

@[simp] theorem dim_singlet : dim ColorSinglet = 1 := rfl
@[simp] theorem dim_triplet : dim Triplet = 3 := rfl

theorem card_eq : Fintype.card SU3Rep = 2 := by decide

end SU3Rep

/-! ## 3. Bundled quantum numbers -/

/-- The full SU(2) × U(1)_Y × SU(3) quantum numbers of a Standard-Model
    fermion species. The hypercharge `Y` is stored as a rational (it is
    rational for every SM species). -/
structure FullQuantumNumbers where
  /-- SU(2)_L representation. -/
  su2 : SU2Rep
  /-- Weak hypercharge Y ∈ ℚ. Uses the convention Q = T₃ + Y
      (same as `FermionHypercharge.lean`: Y_L_lepton = -1/2, Y_Q_L = 1/6,
      Y_e_R = -1, Y_u_R = 2/3, Y_d_R = -1/3, Y_nu_R = 0). -/
  Y   : ℚ
  /-- SU(3)_c representation. -/
  su3 : SU3Rep
  deriving DecidableEq, Repr

/-! ## 4. Species assignments

Six SM species (the standard minimal content plus a Dirac ν_R): -/

/-- Left-handed lepton doublet L = (ν_L, e_L). -/
def QN_L_lepton : FullQuantumNumbers :=
  { su2 := SU2Rep.Doublet, Y := -1 / 2, su3 := SU3Rep.ColorSinglet }

/-- Right-handed charged lepton e_R. -/
def QN_eR : FullQuantumNumbers :=
  { su2 := SU2Rep.Singlet, Y := -1, su3 := SU3Rep.ColorSinglet }

/-- Right-handed neutrino ν_R (Dirac). -/
def QN_nuR : FullQuantumNumbers :=
  { su2 := SU2Rep.Singlet, Y := 0, su3 := SU3Rep.ColorSinglet }

/-- Left-handed quark doublet Q_L = (u_L, d_L). -/
def QN_Q_L : FullQuantumNumbers :=
  { su2 := SU2Rep.Doublet, Y := 1 / 6, su3 := SU3Rep.Triplet }

/-- Right-handed up-type quark u_R. -/
def QN_uR : FullQuantumNumbers :=
  { su2 := SU2Rep.Singlet, Y := 2 / 3, su3 := SU3Rep.Triplet }

/-- Right-handed down-type quark d_R. -/
def QN_dR : FullQuantumNumbers :=
  { su2 := SU2Rep.Singlet, Y := -1 / 3, su3 := SU3Rep.Triplet }

/-- Sanity: L_lepton hypercharge matches `FermionHypercharge.leftLeptonDoubletY`. -/
theorem QN_L_lepton_Y_matches : QN_L_lepton.Y = leftLeptonDoubletY := rfl

/-- Sanity: Q_L hypercharge matches `FermionHypercharge.leftQuarkDoubletY`. -/
theorem QN_Q_L_Y_matches : QN_Q_L.Y = leftQuarkDoubletY := rfl

/-- Sanity: e_R hypercharge matches. -/
theorem QN_eR_Y_matches : QN_eR.Y = rightElectronY := rfl

/-- Sanity: u_R hypercharge matches. -/
theorem QN_uR_Y_matches : QN_uR.Y = rightUpQuarkY := rfl

/-- Sanity: d_R hypercharge matches. -/
theorem QN_dR_Y_matches : QN_dR.Y = rightDownQuarkY := rfl

/-- Sanity: ν_R hypercharge matches. -/
theorem QN_nuR_Y_matches : QN_nuR.Y = rightNeutrinoY := rfl

/-! ## 5. Gell-Mann–Nishijima: Q = T₃ + Y

Using the convention matching `FermionHypercharge.lean`:
  Q = T₃ + Y    with    Y_L_lepton = -1/2, Y_e_R = -1, etc.
(equivalently, if one wants the "doubled-hypercharge" form Q = T₃ + Y'/2
then Y' = 2Y; we choose the `Y` convention to stay aligned with the
existing hypercharge file).

For each species we pick the physically correct T₃ (upper vs lower
component of a doublet, or 0 for a singlet) and verify that
  Q = T₃ + Y
reproduces the standard electric charge. -/

/-- Electric charge of the upper component of the lepton doublet
    (neutrino, T₃ = +1/2). -/
def Q_nu_L : ℚ := 1 / 2 + QN_L_lepton.Y
/-- Electric charge of the lower component of the lepton doublet
    (electron, T₃ = -1/2). -/
def Q_e_L : ℚ := -1 / 2 + QN_L_lepton.Y
/-- Electric charge of the upper component of the quark doublet
    (up, T₃ = +1/2). -/
def Q_u_L : ℚ := 1 / 2 + QN_Q_L.Y
/-- Electric charge of the lower component of the quark doublet
    (down, T₃ = -1/2). -/
def Q_d_L : ℚ := -1 / 2 + QN_Q_L.Y
/-- Electric charge of e_R: singlet ⇒ T₃ = 0. -/
def Q_eR : ℚ := 0 + QN_eR.Y
/-- Electric charge of ν_R: singlet ⇒ T₃ = 0. -/
def Q_nuR : ℚ := 0 + QN_nuR.Y
/-- Electric charge of u_R: singlet ⇒ T₃ = 0. -/
def Q_uR : ℚ := 0 + QN_uR.Y
/-- Electric charge of d_R: singlet ⇒ T₃ = 0. -/
def Q_dR : ℚ := 0 + QN_dR.Y

/-! ### Gell-Mann–Nishijima for each species -/

/-- Left-handed neutrino is electrically neutral. -/
theorem gell_mann_nishijima_nu_L : Q_nu_L = 0 := by
  unfold Q_nu_L QN_L_lepton; norm_num

/-- Left-handed electron has charge -1. -/
theorem gell_mann_nishijima_e_L : Q_e_L = -1 := by
  unfold Q_e_L QN_L_lepton; norm_num

/-- Left-handed up quark has charge +2/3. -/
theorem gell_mann_nishijima_u_L : Q_u_L = 2 / 3 := by
  unfold Q_u_L QN_Q_L; norm_num

/-- Left-handed down quark has charge -1/3. -/
theorem gell_mann_nishijima_d_L : Q_d_L = -1 / 3 := by
  unfold Q_d_L QN_Q_L; norm_num

/-- Right-handed electron has charge -1. -/
theorem gell_mann_nishijima_eR : Q_eR = -1 := by
  unfold Q_eR QN_eR; norm_num

/-- Right-handed neutrino is electrically neutral. -/
theorem gell_mann_nishijima_nuR : Q_nuR = 0 := by
  unfold Q_nuR QN_nuR; norm_num

/-- Right-handed up quark has charge +2/3. -/
theorem gell_mann_nishijima_uR : Q_uR = 2 / 3 := by
  unfold Q_uR QN_uR; norm_num

/-- Right-handed down quark has charge -1/3. -/
theorem gell_mann_nishijima_dR : Q_dR = -1 / 3 := by
  unfold Q_dR QN_dR; norm_num

/-! ## 6. Left-right consistency: same species ⇒ same Q -/

/-- Electrons (L and R) have the same electric charge. -/
theorem electron_Q_consistent : Q_e_L = Q_eR := by
  unfold Q_e_L Q_eR QN_L_lepton QN_eR; norm_num

/-- Up quarks (L and R) have the same electric charge. -/
theorem up_quark_Q_consistent : Q_u_L = Q_uR := by
  unfold Q_u_L Q_uR QN_Q_L QN_uR; norm_num

/-- Down quarks (L and R) have the same electric charge. -/
theorem down_quark_Q_consistent : Q_d_L = Q_dR := by
  unfold Q_d_L Q_dR QN_Q_L QN_dR; norm_num

/-- Neutrinos (L and R) are both neutral. -/
theorem neutrino_Q_consistent : Q_nu_L = Q_nuR := by
  unfold Q_nu_L Q_nuR QN_L_lepton QN_nuR; norm_num

/-! ## 7. Standard electric charges -/

/-- **Electron charge is −1**, up-quark is +2/3, down-quark is −1/3.
    Bundled headline theorem. -/
theorem electric_charges_standard :
    Q_eR = -1 ∧ Q_uR = 2 / 3 ∧ Q_dR = -1 / 3 ∧ Q_nuR = 0 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact gell_mann_nishijima_eR
  · exact gell_mann_nishijima_uR
  · exact gell_mann_nishijima_dR
  · exact gell_mann_nishijima_nuR

/-! ## 8. Sum of SM species charges per generation (without ν_R)

A classic sanity check:
  Σ_species Q × (SU(3) dim) = 0
over one generation (with colour multiplicity). Counting Weyl fields:
  L_lepton: (ν_L, e_L) → 0 + (-1)          = -1
  Q_L     : 3 colours × (u_L + d_L)        = 3 × (2/3 - 1/3) = 1
  e_R                                       = -1
  u_R     : 3 colours × 2/3                = 2
  d_R     : 3 colours × (-1/3)             = -1
  Total                                     = 0.
-/

/-- Colour-weighted electric-charge sum over one generation (no ν_R). -/
def generationChargeSum : ℚ :=
  (Q_nu_L + Q_e_L)                                  -- lepton doublet
  + (3 : ℚ) * (Q_u_L + Q_d_L)                        -- quark doublet × 3 colours
  + Q_eR                                             -- right electron
  + (3 : ℚ) * Q_uR                                   -- right up × 3 colours
  + (3 : ℚ) * Q_dR                                   -- right down × 3 colours

/-- The electric charges of one SM generation sum to zero (with colour
    multiplicity and no ν_R). This is a standard anomaly-adjacent
    consistency check. -/
theorem generation_charge_sum_zero : generationChargeSum = 0 := by
  unfold generationChargeSum
    Q_nu_L Q_e_L Q_u_L Q_d_L Q_eR Q_uR Q_dR
    QN_L_lepton QN_Q_L QN_eR QN_uR QN_dR
  norm_num

end OmegaTheory.Emergence.FermionQuantumNumbers
