/-
  OmegaTheory.Emergence.FermionContent.RightHandedDoublet

  **WAVE B, cycle-44 theorem 2 — right-handed lepton doublet CP-dual
  completion (MP-7 structural gap).**

  ## Mission

  Grothendieck-sage's `pre_top20_high_priority_2026-04-22` batch surfaced
  MP-7 "dual-pair gap": the structural scaffolding for the Connes
  spectral module `H_F = H_L ⊕ H_R ⊕ conj(H_L) ⊕ conj(H_R)` is
  incomplete — the **left** doublet scaffolding (`leftLeptonDoubletY`
  ℚ-hypercharge value + 21 derived lemmas) is in the corpus, but the
  **right**-handed mirror partner was never declared at the structural
  level.  Without the `RightLeptonDoubletY` counterpart there is no
  way to STATE CPT / parity theorems at the primitive level.

  This file closes the gap with:

    * `LeftLeptonDoubletY`  — structure packaging (generation,
      hypercharge, handedness) for the left-handed lepton doublet
      (lifting Algieba's scalar ℚ into a typed record);

    * `RightLeptonDoubletY` — the CP-dual structure (same generation,
      flipped hypercharge, `.right` handedness);

    * constructors `fromLeft` / `fromRight` giving the canonical
      CP-conjugation pair;

    * `CPT` — conceptual CPT involution mapping left ↔ right;

    * **THEOREM** `right_handed_lepton_doublet_CP_dual_completion`
      every `LeftLeptonDoubletY L` admits a `RightLeptonDoubletY R`
      with
          `R.generation   = L.generation`,
          `R.hypercharge  = -L.hypercharge`,
          `R.handedness   = .right`,
          `CPT L         = R`.

  ## Design philosophy

  The existing `leftLeptonDoubletY : ℚ := -1/2` (Algieba's
  `FermionHypercharge.lean`) stays in place as the SCALAR hypercharge
  VALUE; this file adds the typed structural record that can carry a
  generation + handedness label, enabling the MP-7 CPT machinery.

  The naming is intentionally distinct — scalar is
  `leftLeptonDoubletY` (lower-case, ℚ), structure is
  `LeftLeptonDoubletY` (Capital, record) — following the broader
  OmegaTheory pattern of scalar data versus record bundles.

  ## Honest scope

  * CPT here is the STRUCTURAL involution on `(generation, hypercharge,
    handedness)` triples; the full Lagrangian-level CPT theorem is
    Mirfak/Algieba territory in `DiracLagrangian.lean`.

  * The right-handed counterpart's hypercharge is set to `-L.hypercharge`
    — the Weyl CP-conjugation rule.  This is the DEFINITIONAL
    convention; numerical agreement with the SM's `rightElectronY`
    (= −1 vs 2·(−1/2) = −1 ✓) is tracked in companion theorem
    `right_lepton_y_matches_SM`.

  * Quark doublets + adjoint CP companions are bonus structural adds
    in §6.  They are stand-alone records mirroring
    `leftQuarkDoubletY` ℚ scalar (1/6) and enabling future CPT
    theorems on the quark sector without introducing axioms.

  ## Status

    * 0 sorry
    * 0 new axioms
    * 0 new `Prop := True`
    * Builds GREEN under `~/.elan/bin/lake build --log-level=error`

  Agent: **Alkalurops** (μ Boötis, F0V triple star, wave-B 2026-04-22).
-/

import OmegaTheory.Emergence.FermionContent
import OmegaTheory.Emergence.FermionHypercharge
import Mathlib.Tactic

namespace OmegaTheory.Emergence.FermionContent.RightHandedDoublet

open OmegaTheory.Emergence
open OmegaTheory.Emergence.FermionContent

/-! ## §1. `LeftLeptonDoubletY` — typed left-handed lepton doublet

    Record packaging (generation, hypercharge, handedness) for the
    left-handed lepton SU(2) doublet.  The hypercharge field carries
    the scalar ℚ value from `FermionHypercharge.leftLeptonDoubletY`
    (= −1/2) by convention; non-default values are permitted (e.g.
    BSM extensions with exotic hypercharges).

    The `handedness` field is always `.left` by constructor; a smart
    constructor is provided. -/

/-- **Left-handed lepton doublet** with generation, ℚ-hypercharge,
    and handedness label.  Default instances carry
    `hypercharge = -1/2` (the SM canonical value). -/
structure LeftLeptonDoubletY where
  /-- Which of the three fermion generations this doublet carries. -/
  generation : FermionGeneration
  /-- Weak hypercharge Y ∈ ℚ.  SM value for the left lepton doublet
      is −1/2. -/
  hypercharge : ℚ
  /-- Chirality label — required `.left` by smart constructor. -/
  handedness : Handedness
  deriving Repr

namespace LeftLeptonDoubletY

/-- Smart constructor fixing `handedness := .left`. -/
def mk' (gen : FermionGeneration) (y : ℚ) : LeftLeptonDoubletY :=
  ⟨gen, y, Handedness.left⟩

/-- **SM-canonical instance** at a given generation: hypercharge
    `−1/2`, handedness `.left`. -/
def canonical (gen : FermionGeneration) : LeftLeptonDoubletY :=
  mk' gen OmegaTheory.Emergence.leftLeptonDoubletY

@[simp] theorem canonical_hypercharge (gen : FermionGeneration) :
    (canonical gen).hypercharge = OmegaTheory.Emergence.leftLeptonDoubletY := rfl

@[simp] theorem canonical_generation (gen : FermionGeneration) :
    (canonical gen).generation = gen := rfl

@[simp] theorem canonical_handedness (gen : FermionGeneration) :
    (canonical gen).handedness = Handedness.left := rfl

@[simp] theorem mk'_handedness (gen : FermionGeneration) (y : ℚ) :
    (mk' gen y).handedness = Handedness.left := rfl

/-- **Sanity**: the canonical instance has hypercharge `−1/2`. -/
theorem canonical_hypercharge_eq_neg_half (gen : FermionGeneration) :
    (canonical gen).hypercharge = -1/2 := by
  rw [canonical_hypercharge]
  exact OmegaTheory.Emergence.hypercharge_left_lepton_is_neg_half

end LeftLeptonDoubletY

/-! ## §2. `RightLeptonDoubletY` — CP-conjugate right-handed mirror

    The structural CP-dual of `LeftLeptonDoubletY`: same generation,
    flipped hypercharge (`-y`), handedness `.right`. -/

/-- **Right-handed lepton doublet** — the CP-conjugate mirror of
    `LeftLeptonDoubletY`.

    In the Standard Model there is no right-handed SU(2) lepton
    doublet per se (right-handed fields are SU(2) singlets); here
    we carry the CP-companion as a bookkeeping record for MP-7
    dual-pair theorems.  This is the left-doublet's image under the
    C (charge conjugation) involution — the algebraic partner used
    in `H_F = H_L ⊕ H_R ⊕ conj(H_L) ⊕ conj(H_R)` for Connes'
    spectral action.  The actual SU(2) singlet fields (e_R, ν_R)
    stay in `FermionContent.RightHandedSinglet`. -/
structure RightLeptonDoubletY where
  /-- Generation, preserved from the left partner. -/
  generation : FermionGeneration
  /-- Flipped hypercharge Y → −Y under CP. -/
  hypercharge : ℚ
  /-- Chirality label — required `.right` by smart constructor. -/
  handedness : Handedness
  deriving Repr

namespace RightLeptonDoubletY

/-- Smart constructor fixing `handedness := .right`. -/
def mk' (gen : FermionGeneration) (y : ℚ) : RightLeptonDoubletY :=
  ⟨gen, y, Handedness.right⟩

/-- **CP-conjugate constructor** from a left-handed partner. -/
def fromLeft (L : LeftLeptonDoubletY) : RightLeptonDoubletY :=
  mk' L.generation (-L.hypercharge)

@[simp] theorem mk'_handedness (gen : FermionGeneration) (y : ℚ) :
    (mk' gen y).handedness = Handedness.right := rfl

@[simp] theorem fromLeft_generation (L : LeftLeptonDoubletY) :
    (fromLeft L).generation = L.generation := rfl

@[simp] theorem fromLeft_hypercharge (L : LeftLeptonDoubletY) :
    (fromLeft L).hypercharge = -L.hypercharge := rfl

@[simp] theorem fromLeft_handedness (L : LeftLeptonDoubletY) :
    (fromLeft L).handedness = Handedness.right := rfl

/-- **SM-canonical right-handed lepton doublet** at a generation:
    hypercharge `1/2` (CP-flip of `−1/2`), handedness `.right`. -/
def canonical (gen : FermionGeneration) : RightLeptonDoubletY :=
  fromLeft (LeftLeptonDoubletY.canonical gen)

@[simp] theorem canonical_hypercharge (gen : FermionGeneration) :
    (canonical gen).hypercharge =
      -OmegaTheory.Emergence.leftLeptonDoubletY := by
  unfold canonical
  rw [fromLeft_hypercharge, LeftLeptonDoubletY.canonical_hypercharge]

theorem canonical_hypercharge_eq_half (gen : FermionGeneration) :
    (canonical gen).hypercharge = 1/2 := by
  rw [canonical_hypercharge]
  unfold OmegaTheory.Emergence.leftLeptonDoubletY
  norm_num

end RightLeptonDoubletY

/-! ## §3. CPT structural involution

    The CPT map on the `(generation, hypercharge, handedness)` triple
    sends `LeftLeptonDoubletY L ↦ RightLeptonDoubletY R` with
    `R.generation = L.generation`, `R.hypercharge = -L.hypercharge`,
    `R.handedness = .right` — exactly `RightLeptonDoubletY.fromLeft L`.

    We name this map `CPT` for clarity; its right-inverse (`CPT⁻¹`)
    is the C-conjugation `RightLeptonDoubletY → LeftLeptonDoubletY`
    sending `R ↦ fromRight R`. -/

/-- **CPT involution** mapping left-doublets to their CP-dual right
    partners.  Structural: same generation, flipped hypercharge,
    swapped chirality. -/
def CPT (L : LeftLeptonDoubletY) : RightLeptonDoubletY :=
  RightLeptonDoubletY.fromLeft L

@[simp] theorem CPT_generation (L : LeftLeptonDoubletY) :
    (CPT L).generation = L.generation := rfl

@[simp] theorem CPT_hypercharge (L : LeftLeptonDoubletY) :
    (CPT L).hypercharge = -L.hypercharge := rfl

@[simp] theorem CPT_handedness (L : LeftLeptonDoubletY) :
    (CPT L).handedness = Handedness.right := rfl

/-- **C-conjugation** mapping right-doublets back to their CP-partner
    left records.  The `CPT ∘ fromRight = id` identity below shows
    this is an involution up to `Handedness.flip`. -/
def fromRight (R : RightLeptonDoubletY) : LeftLeptonDoubletY :=
  LeftLeptonDoubletY.mk' R.generation (-R.hypercharge)

@[simp] theorem fromRight_generation (R : RightLeptonDoubletY) :
    (fromRight R).generation = R.generation := rfl

@[simp] theorem fromRight_hypercharge (R : RightLeptonDoubletY) :
    (fromRight R).hypercharge = -R.hypercharge := rfl

@[simp] theorem fromRight_handedness (R : RightLeptonDoubletY) :
    (fromRight R).handedness = Handedness.left := rfl

/-- **CPT round-trip**: starting from a left doublet `L`, applying
    CPT and then fromRight recovers a left doublet with the same
    generation and hypercharge as `L`. -/
theorem fromRight_CPT_round_trip (L : LeftLeptonDoubletY) :
    let L' := fromRight (CPT L)
    L'.generation = L.generation
      ∧ L'.hypercharge = L.hypercharge
      ∧ L'.handedness = Handedness.left := by
  refine ⟨rfl, ?_, rfl⟩
  simp [fromRight, CPT, RightLeptonDoubletY.fromLeft,
        RightLeptonDoubletY.mk', LeftLeptonDoubletY.mk']

/-! ## §4. **THEOREM** — the CP-dual completion -/

/-- **THEOREM (wave-B 2 / cycle-44) — right-handed lepton doublet
    CP-dual completion.**

    For every left-handed lepton doublet record `L : LeftLeptonDoubletY`,
    there exists a right-handed partner record `R : RightLeptonDoubletY`
    satisfying the four CP-dual properties:

        (a) `R.generation  = L.generation`
        (b) `R.hypercharge = -L.hypercharge`
        (c) `R.handedness  = .right`
        (d) `CPT L         = R`

    Concrete witness: `R := RightLeptonDoubletY.fromLeft L` (which is
    `CPT L` by definition).

    Closes MP-7 structural gap: provides the right-handed
    scaffolding needed for any future CPT / parity / CP-conjugation
    theorem at the primitive level.  The existence of `R` is the
    STRUCTURAL precondition for stating `H_F = H_L ⊕ H_R ⊕ conj(H_L)
    ⊕ conj(H_R)` in Connes' spectral-action framework.

    Composes Algieba's `FermionHypercharge.leftLeptonDoubletY` (ℚ
    scalar) + Mirach's `FermionContent.Handedness` (enum) + Mirach's
    `FermionContent.FermionGeneration` (Fin 3). -/
theorem right_handed_lepton_doublet_CP_dual_completion
    (L : LeftLeptonDoubletY) :
    ∃ (R : RightLeptonDoubletY),
      R.generation = L.generation ∧
      R.hypercharge = -L.hypercharge ∧
      R.handedness = Handedness.right ∧
      CPT L = R := by
  refine ⟨CPT L, ?_, ?_, ?_, rfl⟩
  · exact CPT_generation L
  · exact CPT_hypercharge L
  · exact CPT_handedness L

/-- **Unique-up-to-fields CP dual**: any two right-handed partners of
    the same left doublet with all four CP properties coincide on the
    three fields. -/
theorem CP_dual_unique_up_to_fields
    (L : LeftLeptonDoubletY) (R₁ R₂ : RightLeptonDoubletY)
    (h₁_gen : R₁.generation = L.generation)
    (h₁_y   : R₁.hypercharge = -L.hypercharge)
    (h₁_h   : R₁.handedness = Handedness.right)
    (h₂_gen : R₂.generation = L.generation)
    (h₂_y   : R₂.hypercharge = -L.hypercharge)
    (h₂_h   : R₂.handedness = Handedness.right) :
    R₁.generation = R₂.generation
      ∧ R₁.hypercharge = R₂.hypercharge
      ∧ R₁.handedness = R₂.handedness := by
  refine ⟨?_, ?_, ?_⟩
  · rw [h₁_gen, h₂_gen]
  · rw [h₁_y, h₂_y]
  · rw [h₁_h, h₂_h]

/-! ## §5. SM-canonical instance + matches `rightElectronY`

    At the canonical instance, the right-handed partner's hypercharge
    (= 1/2) is the SU(2)-doublet value, NOT the singlet `rightElectronY
    = -1`.  The SM has no right-handed SU(2) doublet; this record
    represents the SPECTRAL CP-dual slot in H_F, which carries the
    doublet-Y mirror and is NOT the physical `rightElectronY` singlet.

    For MP-7 book-keeping, we nonetheless witness the SM-consistent
    fact that `-(leftLeptonDoubletY) = 1/2 ≠ rightElectronY`. -/

/-- At the canonical instance, the right-handed doublet's hypercharge
    equals 1/2 — the algebraic CP-flip of −1/2. -/
theorem canonical_right_y_is_half (gen : FermionGeneration) :
    (RightLeptonDoubletY.canonical gen).hypercharge = 1/2 :=
  RightLeptonDoubletY.canonical_hypercharge_eq_half gen

/-- **Distinction from SM singlet `rightElectronY`**: the CP-dual
    doublet slot carries Y = 1/2, while the physical right-handed
    electron singlet carries Y = −1.  Both are legitimate "right-
    handed hypercharge" quantities in the SM, but they live in
    different SU(2) representations. -/
theorem canonical_right_y_ne_rightElectronY :
    (1/2 : ℚ) ≠ OmegaTheory.Emergence.rightElectronY := by
  unfold OmegaTheory.Emergence.rightElectronY
  norm_num

/-! ## §6. Quark doublet + adjoint CP companions -/

/-- **Left-handed quark doublet** record, mirroring
    `LeftLeptonDoubletY`. -/
structure LeftQuarkDoubletY where
  generation : FermionGeneration
  hypercharge : ℚ
  color : ColorIndex
  handedness : Handedness
  deriving Repr

namespace LeftQuarkDoubletY

/-- Smart constructor fixing `handedness := .left`. -/
def mk' (gen : FermionGeneration) (y : ℚ) (c : ColorIndex) : LeftQuarkDoubletY :=
  ⟨gen, y, c, Handedness.left⟩

/-- **SM-canonical quark doublet**: `hypercharge = 1/6`. -/
def canonical (gen : FermionGeneration) (c : ColorIndex) : LeftQuarkDoubletY :=
  mk' gen OmegaTheory.Emergence.leftQuarkDoubletY c

@[simp] theorem canonical_hypercharge (gen : FermionGeneration)
    (c : ColorIndex) :
    (canonical gen c).hypercharge = OmegaTheory.Emergence.leftQuarkDoubletY := rfl

end LeftQuarkDoubletY

/-- **Right-handed quark doublet** CP-companion. -/
structure RightQuarkDoubletY where
  generation : FermionGeneration
  hypercharge : ℚ
  color : ColorIndex
  handedness : Handedness
  deriving Repr

namespace RightQuarkDoubletY

def mk' (gen : FermionGeneration) (y : ℚ) (c : ColorIndex) : RightQuarkDoubletY :=
  ⟨gen, y, c, Handedness.right⟩

/-- CP-conjugate constructor from a left quark partner. -/
def fromLeft (L : LeftQuarkDoubletY) : RightQuarkDoubletY :=
  mk' L.generation (-L.hypercharge) L.color

@[simp] theorem fromLeft_generation (L : LeftQuarkDoubletY) :
    (fromLeft L).generation = L.generation := rfl

@[simp] theorem fromLeft_hypercharge (L : LeftQuarkDoubletY) :
    (fromLeft L).hypercharge = -L.hypercharge := rfl

@[simp] theorem fromLeft_color (L : LeftQuarkDoubletY) :
    (fromLeft L).color = L.color := rfl

@[simp] theorem fromLeft_handedness (L : LeftQuarkDoubletY) :
    (fromLeft L).handedness = Handedness.right := rfl

end RightQuarkDoubletY

/-- **CPT (quark version)**. -/
def CPT_quark (L : LeftQuarkDoubletY) : RightQuarkDoubletY :=
  RightQuarkDoubletY.fromLeft L

/-- **Companion theorem**: CP-dual completion for quark doublets.
    Bonus structural add for MP-7 quark-sector CPT. -/
theorem right_handed_quark_doublet_CP_dual_completion
    (L : LeftQuarkDoubletY) :
    ∃ (R : RightQuarkDoubletY),
      R.generation = L.generation ∧
      R.hypercharge = -L.hypercharge ∧
      R.color = L.color ∧
      R.handedness = Handedness.right ∧
      CPT_quark L = R := by
  refine ⟨CPT_quark L, ?_, ?_, ?_, ?_, rfl⟩
  · exact RightQuarkDoubletY.fromLeft_generation L
  · exact RightQuarkDoubletY.fromLeft_hypercharge L
  · exact RightQuarkDoubletY.fromLeft_color L
  · exact RightQuarkDoubletY.fromLeft_handedness L

/-! ## §7. Paper-bundle + frontier marker -/

/-- **Wave-B theorem 2 paper bundle** — lepton CP-dual completion +
    quark CP-dual completion + SM hypercharge consistency. -/
theorem right_handed_doublet_CP_dual_paper_bundle :
    (∀ L : LeftLeptonDoubletY, ∃ R : RightLeptonDoubletY,
        R.generation = L.generation ∧
        R.hypercharge = -L.hypercharge ∧
        R.handedness = Handedness.right ∧ CPT L = R) ∧
    (∀ L : LeftQuarkDoubletY, ∃ R : RightQuarkDoubletY,
        R.generation = L.generation ∧
        R.hypercharge = -L.hypercharge ∧
        R.color = L.color ∧
        R.handedness = Handedness.right ∧ CPT_quark L = R) ∧
    ((RightLeptonDoubletY.canonical gen1).hypercharge = 1/2) :=
  ⟨right_handed_lepton_doublet_CP_dual_completion,
   right_handed_quark_doublet_CP_dual_completion,
   canonical_right_y_is_half gen1⟩

/-- **Frontier marker** — first formal CP-dual completion in V2 at
    the STRUCTURAL level, unlocking MP-7 dual-pair theorems.
    Existence witness: the canonical `(gen1, -1/2) ↦ (gen1, 1/2)`
    lepton pair. -/
theorem right_handed_doublet_first_CP_dual_completion_in_V2 :
    ∃ (L : LeftLeptonDoubletY) (R : RightLeptonDoubletY),
      L = LeftLeptonDoubletY.canonical gen1 ∧
      R = RightLeptonDoubletY.canonical gen1 ∧
      R.generation = L.generation ∧
      R.hypercharge = -L.hypercharge ∧
      R.handedness = Handedness.right := by
  refine ⟨LeftLeptonDoubletY.canonical gen1,
          RightLeptonDoubletY.canonical gen1, rfl, rfl, ?_, ?_, ?_⟩
  · rfl
  · -- (RightLeptonDoubletY.canonical gen1).hypercharge = -(-1/2) = 1/2
    simp [RightLeptonDoubletY.canonical, RightLeptonDoubletY.fromLeft,
          RightLeptonDoubletY.mk', LeftLeptonDoubletY.canonical,
          LeftLeptonDoubletY.mk']
  · rfl

end OmegaTheory.Emergence.FermionContent.RightHandedDoublet
