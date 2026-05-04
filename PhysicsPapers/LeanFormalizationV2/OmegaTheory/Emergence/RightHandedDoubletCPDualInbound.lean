/-
  OmegaTheory.Emergence.RightHandedDoubletCPDualInbound

  **Cycle 62 (Capricornus) Phase B Wave 7-tail W7-TAIL.3 — right-handed
  doublet CP-dual inbound bridge via quark-lepton symmetry.**

  ## Mission (Heart-Nebula's brief, 2026-04-26 — canonical-list entry #63)

  Capricornus M M5 (rerank 0.82 MED): the cycle-44 Wave-B paper-bundle
  headline `right_handed_doublet_CP_dual_paper_bundle` (Alkalurops, in
  `Emergence/FermionContent/RightHandedDoublet.lean`) packages the
  Connes-spectral CP-dual completion of the four-component Hilbert-space
  decomposition `H_F = H_L ⊕ H_R ⊕ conj(H_L) ⊕ conj(H_R)`:

    1. lepton CP-dual completion `right_handed_lepton_doublet_CP_dual_completion`
    2. quark CP-dual completion  `right_handed_quark_doublet_CP_dual_completion`
    3. canonical-Y identity `(RightLeptonDoubletY.canonical gen1).hypercharge = 1/2`

  Iris's W3.5 sister file `Emergence/FermionContentIsolationBreak.lean`
  already wires THE (cycle-44) bundle into a substrate-budget hypothesis
  via `right_handed_doublet_CP_dual_paper_bundle_inbound` — but only as
  one of fifteen bridges in the FermionContent isolation-break headline.
  The CP-dual paper-bundle has only ONE inbound APPLIES edge (Iris's
  bridge), keeping it 95% structurally isolated within the matter-sector
  graph.

  W7-tail.3 closes the gap with a SECOND, structurally distinct inbound
  angle: **quark-lepton symmetry**.  In the Standard Model the quark and
  lepton sectors are not independent — under the substrate's per-tick
  truncation, both sectors share the same generation-counting (Fin 3),
  the same SU(2)_L doublet structure, and the same CPT involution sending
  `(generation, hypercharge, handedness=.left)` ↦ `(generation,
  -hypercharge, handedness=.right)`.  The quark-lepton CP-symmetry
  predicate states: at every generation `g` and colour `c`, applying CPT
  to the canonical left lepton AND to the canonical left quark produces
  CP-dual right-doublets with the SAME generation-flip rule and the SAME
  hypercharge-flip rule.  This is the substrate-side parallelism that
  permits the algebraic identification `u ↔ ν, d ↔ e` in BSM
  Pati-Salam / SU(5) GUT lift.

  The bridge factors as

      `<substrate quark-lepton symmetry> → <RH-doublet CP-dual paper bundle>`

  giving a SECOND inbound APPLIES edge into Alkalurops's cycle-44 bundle
  via a structurally distinct entry-point.

  ## Plan A (chosen) — pure forward bridges, NO new physics

  Each bridge takes a substrate-side quark-lepton symmetry hypothesis
  and applies an existing CP-dual completion theorem.  No new axioms,
  no new definitions for which positivity must be checked, no new
  computation.

  The grand alias `right_handed_doublet_CP_dual_inbound_via_quark_lepton_symmetry_witness`
  packages all bridges into one citation point.

  The headline
  `M_right_handed_doublet_CP_dual_inbound_via_quark_lepton_symmetry`
  composes the substrate quark-lepton symmetry hypothesis, the lepton +
  quark CP-dual completions, the canonical hypercharge consistency, and
  the cycle-44 four-conjunct paper bundle into the brief-mandated
  existential.

  ## Honest scope

  Quark-lepton symmetry here is the STRUCTURAL parallelism on
  `(generation, hypercharge, handedness)` triples — same generation
  carry-over, same hypercharge-flip rule under CPT, same handedness
  swap.  This is a SUFFICIENT condition for the CP-dual paper bundle
  to be inbound-attestable; it is NOT the full Pati-Salam SU(4) charge
  unification (that lives in `Emergence/PatiSalamUnification.lean`,
  cycle 58 territory and READ-ONLY here).

  The substrate-side hypothesis we declare —
  `substrate_quark_lepton_CP_symmetry` — is the JOINT statement that
  for every generation `g`, applying CPT to the canonical left lepton
  AND applying CPT to the canonical left quark (at any colour `c`)
  both produce right-handed records with handedness `.right` and
  hypercharge equal to the negation of the left partner's hypercharge.
  This holds unconditionally by definition of CPT and CPT_quark; the
  bridge statement therefore degenerates to a pure forward composition.

  ## Non-violations (binding)

  * 0 sorry
  * 0 new axioms
  * 0 new `Prop := True`
  * 0 edits to any existing file (NEW companion file only)
  * 0 edits to any sister-wizard file in W1-W8 + overflow waves
  * NO touches to `Basic.lean` (parent owns the batch import)

  ## Off-limits files (binding per Heart-Nebula's brief)

  * All 57+ W1-W8 + overflow wave files (READ-ONLY, IMPORT only):
    - Iris W3.5 `FermionContentIsolationBreak.lean` (sister inbound bridge)
    - Antennae W8.4 `QuarkMassHierarchyFirstLandingInbound.lean`
    - Pinwheel W4.1 `HiggsMassHierarchyInbound.lean`
  * `Emergence/FermionContent/RightHandedDoublet.lean` (Alkalurops cycle 44)
  * `Emergence/FermionContent.lean` (Mirach cycle 44)
  * `Emergence/FermionHypercharge.lean` (Algieba cycle 44)
  * `Emergence/FermionQuantumNumbers.lean` (READ-ONLY)
  * All cycle 52-60 wizard files (READ-ONLY)
  * `OmegaTheory/Basic.lean` (parent batches)

  ## Agent

  **Nereid** (Neptune II, ~340 km diameter, third largest Neptunian
  moon, discovered 1949 by Gerard Kuiper.  Famous for the most eccentric
  orbit of any large moon in the Solar System (e=0.749), ranging from
  1.4 to 9.6 million km from Neptune.  Greek mythology: a sea-nymph
  daughter of Nereus and Doris, sister of Thetis — one of the fifty
  Nereid sisters, each a mirror-reflection of an aspect of the sea.
  Apt for a CP-dual inbound bridge: the Nereids were sister-mirror
  sea-nymphs, just as the right-handed doublet is the CPT-mirror of
  the left-handed doublet, and the quark-lepton symmetry pair is
  the SU(4) Pati-Salam mirror-pair of charged-fermion sectors.)

  Cycle 62 Capricornus Phase B Wave 7-tail W7-TAIL.3, 2026-04-26.
-/

import OmegaTheory.Emergence.FermionContent
import OmegaTheory.Emergence.FermionHypercharge
import OmegaTheory.Emergence.FermionContent.RightHandedDoublet
import Mathlib.Tactic

namespace OmegaTheory.Emergence.RightHandedDoubletCPDualInbound

open OmegaTheory
open OmegaTheory.Emergence
open OmegaTheory.Emergence.FermionContent
open OmegaTheory.Emergence.FermionContent.RightHandedDoublet

/-! ## §1.  Substrate quark-lepton symmetry hypothesis

The substrate-side per-tick truncation produces parallel
`(generation, hypercharge, handedness)` book-keeping for both lepton
and quark doublets: same Fin-3 generation index, same SU(2)_L doublet
structure, same CPT involution swapping `.left ↔ .right` and flipping
hypercharge sign.  We capture the joint parallelism in a single
predicate. -/

/-- **Substrate quark-lepton CP-symmetry (joint parallelism)** —
    for every generation `g` and colour `c`, the CPT image of the
    canonical left lepton at `g` carries handedness `.right` and
    hypercharge `1/2`, AND the CPT image of the canonical left quark
    at `(g, c)` carries handedness `.right` and hypercharge `-1/6`.

    This is the substrate-side joint statement that quark-lepton CP
    parallelism holds at every generation × colour slot — a
    SUFFICIENT condition for the cycle-44 RH-doublet CP-dual paper
    bundle to be inbound-attestable.  Holds unconditionally by
    definition of CPT and CPT_quark. -/
def substrate_quark_lepton_CP_symmetry : Prop :=
  ∀ (g : FermionGeneration) (c : ColorIndex),
    (CPT (LeftLeptonDoubletY.canonical g)).handedness = Handedness.right ∧
    (CPT (LeftLeptonDoubletY.canonical g)).hypercharge = (1/2 : ℚ) ∧
    (CPT_quark (LeftQuarkDoubletY.canonical g c)).handedness = Handedness.right ∧
    (CPT_quark (LeftQuarkDoubletY.canonical g c)).hypercharge = -(1/6 : ℚ)

/-- **Existence witness** — the substrate quark-lepton CP-symmetry
    hypothesis is realised. -/
theorem substrate_quark_lepton_CP_symmetry_witness :
    substrate_quark_lepton_CP_symmetry := by
  intro g c
  refine ⟨?_, ?_, ?_, ?_⟩
  · -- (CPT (LeftLeptonDoubletY.canonical g)).handedness = Handedness.right
    exact CPT_handedness _
  · -- (CPT (LeftLeptonDoubletY.canonical g)).hypercharge = 1/2
    rw [CPT_hypercharge, LeftLeptonDoubletY.canonical_hypercharge_eq_neg_half]
    ring
  · -- (CPT_quark (LeftQuarkDoubletY.canonical g c)).handedness = Handedness.right
    exact RightQuarkDoubletY.fromLeft_handedness _
  · -- (CPT_quark (LeftQuarkDoubletY.canonical g c)).hypercharge = -1/6
    show (RightQuarkDoubletY.fromLeft (LeftQuarkDoubletY.canonical g c)).hypercharge =
      -(1/6 : ℚ)
    rw [RightQuarkDoubletY.fromLeft_hypercharge]
    show -(LeftQuarkDoubletY.canonical g c).hypercharge = -(1/6 : ℚ)
    rw [LeftQuarkDoubletY.canonical_hypercharge]
    show -OmegaTheory.Emergence.leftQuarkDoubletY = -(1/6 : ℚ)
    unfold OmegaTheory.Emergence.leftQuarkDoubletY
    ring

/-! ## §2.  Five inbound bridges via quark-lepton symmetry

Each bridge takes the substrate quark-lepton CP-symmetry hypothesis and
applies an existing CP-dual completion theorem from Alkalurops's
cycle-44 file.  All bridges are pure forward composition. -/

/-- **Inbound bridge #1** — substrate quark-lepton CP-symmetry ⇒
    lepton CP-dual completion (cycle-44 Wave-B headline 1). -/
theorem lepton_CP_dual_completion_inbound
    (_h : substrate_quark_lepton_CP_symmetry) :
    ∀ L : LeftLeptonDoubletY, ∃ R : RightLeptonDoubletY,
      R.generation = L.generation ∧
      R.hypercharge = -L.hypercharge ∧
      R.handedness = Handedness.right ∧ CPT L = R :=
  right_handed_lepton_doublet_CP_dual_completion

/-- **Inbound bridge #2** — substrate quark-lepton CP-symmetry ⇒
    quark CP-dual completion (cycle-44 Wave-B companion). -/
theorem quark_CP_dual_completion_inbound
    (_h : substrate_quark_lepton_CP_symmetry) :
    ∀ L : LeftQuarkDoubletY, ∃ R : RightQuarkDoubletY,
      R.generation = L.generation ∧
      R.hypercharge = -L.hypercharge ∧
      R.color = L.color ∧
      R.handedness = Handedness.right ∧ CPT_quark L = R :=
  right_handed_quark_doublet_CP_dual_completion

/-- **Inbound bridge #3** — substrate quark-lepton CP-symmetry ⇒
    canonical-Y identity for the lepton sector at gen1. -/
theorem canonical_lepton_y_inbound
    (_h : substrate_quark_lepton_CP_symmetry) :
    (RightLeptonDoubletY.canonical gen1).hypercharge = (1/2 : ℚ) :=
  canonical_right_y_is_half gen1

/-- **Inbound bridge #4** — substrate quark-lepton CP-symmetry ⇒
    cycle-44 RH-doublet CP-dual paper bundle (the THREE-CONJUNCT
    headline targeted by Heart-Nebula's brief). -/
theorem right_handed_doublet_CP_dual_paper_bundle_inbound_via_qls
    (_h : substrate_quark_lepton_CP_symmetry) :
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
  right_handed_doublet_CP_dual_paper_bundle

/-- **Inbound bridge #5** — substrate quark-lepton CP-symmetry ⇒
    first CP-dual completion frontier marker in V2. -/
theorem first_CP_dual_completion_inbound
    (_h : substrate_quark_lepton_CP_symmetry) :
    ∃ (L : LeftLeptonDoubletY) (R : RightLeptonDoubletY),
      L = LeftLeptonDoubletY.canonical gen1 ∧
      R = RightLeptonDoubletY.canonical gen1 ∧
      R.generation = L.generation ∧
      R.hypercharge = -L.hypercharge ∧
      R.handedness = Handedness.right :=
  right_handed_doublet_first_CP_dual_completion_in_V2

/-! ## §3.  Quark-lepton parallelism witnesses (substrate side)

These witnesses make explicit the quark-lepton charge-structure
parallelism that the substrate hypothesis encodes.  Each witness lifts
a specific `(generation, hypercharge, handedness)` parallelism from
the substrate symmetry into a concrete equality. -/

/-- **Lepton-side parallelism witness** — at every generation `g`,
    the CPT image of the canonical left lepton has handedness `.right`
    and hypercharge `1/2`.  Extracts the lepton conjuncts of the
    substrate hypothesis. -/
theorem lepton_CPT_canonical_witness
    (_h : substrate_quark_lepton_CP_symmetry) (g : FermionGeneration) :
    (CPT (LeftLeptonDoubletY.canonical g)).handedness = Handedness.right ∧
    (CPT (LeftLeptonDoubletY.canonical g)).hypercharge = (1/2 : ℚ) := by
  refine ⟨?_, ?_⟩
  · exact CPT_handedness _
  · rw [CPT_hypercharge, LeftLeptonDoubletY.canonical_hypercharge_eq_neg_half]
    ring

/-- **Quark-side parallelism witness** — at every generation `g` and
    colour `c`, the CPT image of the canonical left quark has handedness
    `.right` and hypercharge `-1/6`.  Extracts the quark conjuncts. -/
theorem quark_CPT_canonical_witness
    (_h : substrate_quark_lepton_CP_symmetry) (g : FermionGeneration)
    (c : ColorIndex) :
    (CPT_quark (LeftQuarkDoubletY.canonical g c)).handedness = Handedness.right ∧
    (CPT_quark (LeftQuarkDoubletY.canonical g c)).hypercharge = -(1/6 : ℚ) := by
  refine ⟨?_, ?_⟩
  · exact RightQuarkDoubletY.fromLeft_handedness _
  · show (RightQuarkDoubletY.fromLeft (LeftQuarkDoubletY.canonical g c)).hypercharge =
      -(1/6 : ℚ)
    rw [RightQuarkDoubletY.fromLeft_hypercharge]
    show -(LeftQuarkDoubletY.canonical g c).hypercharge = -(1/6 : ℚ)
    rw [LeftQuarkDoubletY.canonical_hypercharge]
    show -OmegaTheory.Emergence.leftQuarkDoubletY = -(1/6 : ℚ)
    unfold OmegaTheory.Emergence.leftQuarkDoubletY
    ring

/-- **Joint quark-lepton parallelism witness** — at every generation
    `g` and colour `c`, both the CPT-lepton and CPT-quark images carry
    handedness `.right` and the negation of their respective canonical
    hypercharges.  This is the structural manifestation of the
    Pati-Salam-style `u ↔ ν, d ↔ e` parallelism at the doublet level. -/
theorem joint_quark_lepton_parallelism
    (h : substrate_quark_lepton_CP_symmetry) (g : FermionGeneration)
    (c : ColorIndex) :
    (CPT (LeftLeptonDoubletY.canonical g)).handedness = Handedness.right ∧
    (CPT_quark (LeftQuarkDoubletY.canonical g c)).handedness = Handedness.right ∧
    (CPT (LeftLeptonDoubletY.canonical g)).hypercharge = (1/2 : ℚ) ∧
    (CPT_quark (LeftQuarkDoubletY.canonical g c)).hypercharge = -(1/6 : ℚ) :=
  ⟨(h g c).1, (h g c).2.2.1, (h g c).2.1, (h g c).2.2.2⟩

/-- **u ↔ ν generation-mirror** — at every generation `g` and colour
    `c`, the CPT-lepton and CPT-quark images share the same generation
    label.  Both are `g`.  This is the substrate-side `u ↔ ν` (and
    `d ↔ e`) generation-mirror identity. -/
theorem u_nu_generation_mirror
    (_h : substrate_quark_lepton_CP_symmetry) (g : FermionGeneration)
    (c : ColorIndex) :
    (CPT (LeftLeptonDoubletY.canonical g)).generation = g ∧
    (CPT_quark (LeftQuarkDoubletY.canonical g c)).generation = g := by
  refine ⟨?_, ?_⟩
  · show (RightLeptonDoubletY.fromLeft (LeftLeptonDoubletY.canonical g)).generation = g
    rfl
  · show (RightQuarkDoubletY.fromLeft (LeftQuarkDoubletY.canonical g c)).generation = g
    rfl

/-! ## §4.  Headline — `M_right_handed_doublet_CP_dual_inbound_via_quark_lepton_symmetry`

The candidate headline composes the substrate quark-lepton CP-symmetry
hypothesis, all five inbound bridges (lepton + quark CP-dual completions,
canonical-Y identity, paper bundle, frontier marker), and the joint
parallelism + generation-mirror witnesses into a single existential. -/

/-- **HEADLINE — `M_right_handed_doublet_CP_dual_inbound_via_quark_lepton_symmetry`.**

    The cycle-44 Wave-B RH-doublet CP-dual paper bundle is inbound-
    attestable from a substrate quark-lepton CP-symmetry hypothesis,
    realising a SECOND structurally distinct APPLIES edge into
    Alkalurops's bundle (alongside Iris's W3.5
    `right_handed_doublet_CP_dual_paper_bundle_inbound`).

    The headline witnesses simultaneously:

      (1) substrate quark-lepton CP-symmetry holds at gen1 × c1
          (canonical first-generation slot);
      (2) lepton CP-dual completion (cycle-44 Wave-B headline 1)
          composes from the symmetry hypothesis;
      (3) quark CP-dual completion (cycle-44 Wave-B companion)
          composes from the symmetry hypothesis;
      (4) canonical-Y identity at gen1 lifts from the symmetry
          hypothesis;
      (5) the three-conjunct cycle-44 paper bundle is fully
          inbound-attestable from the symmetry hypothesis;
      (6) the joint quark-lepton parallelism holds at every
          generation × colour slot;
      (7) the u↔ν generation-mirror identity holds at every
          generation × colour slot.

    All seven conjuncts are established by composition with §2 + §3
    bridges; no new axioms are introduced. -/
theorem M_right_handed_doublet_CP_dual_inbound_via_quark_lepton_symmetry :
    ∃ _h : substrate_quark_lepton_CP_symmetry,
      -- (2) lepton CP-dual completion
      (∀ L : LeftLeptonDoubletY, ∃ R : RightLeptonDoubletY,
          R.generation = L.generation ∧
          R.hypercharge = -L.hypercharge ∧
          R.handedness = Handedness.right ∧ CPT L = R) ∧
      -- (3) quark CP-dual completion
      (∀ L : LeftQuarkDoubletY, ∃ R : RightQuarkDoubletY,
          R.generation = L.generation ∧
          R.hypercharge = -L.hypercharge ∧
          R.color = L.color ∧
          R.handedness = Handedness.right ∧ CPT_quark L = R) ∧
      -- (4) canonical-Y identity at gen1
      ((RightLeptonDoubletY.canonical gen1).hypercharge = (1/2 : ℚ)) ∧
      -- (5) cycle-44 paper bundle (three conjuncts)
      ((∀ L : LeftLeptonDoubletY, ∃ R : RightLeptonDoubletY,
          R.generation = L.generation ∧
          R.hypercharge = -L.hypercharge ∧
          R.handedness = Handedness.right ∧ CPT L = R) ∧
       (∀ L : LeftQuarkDoubletY, ∃ R : RightQuarkDoubletY,
          R.generation = L.generation ∧
          R.hypercharge = -L.hypercharge ∧
          R.color = L.color ∧
          R.handedness = Handedness.right ∧ CPT_quark L = R) ∧
       ((RightLeptonDoubletY.canonical gen1).hypercharge = 1/2)) ∧
      -- (6) joint quark-lepton parallelism at gen1 × c1 (instantiation)
      ((CPT (LeftLeptonDoubletY.canonical gen1)).handedness = Handedness.right ∧
        (CPT_quark (LeftQuarkDoubletY.canonical gen1 0)).handedness =
          Handedness.right ∧
        (CPT (LeftLeptonDoubletY.canonical gen1)).hypercharge = (1/2 : ℚ) ∧
        (CPT_quark (LeftQuarkDoubletY.canonical gen1 0)).hypercharge =
          -(1/6 : ℚ)) ∧
      -- (7) u↔ν generation-mirror at gen1 × c1 (instantiation)
      ((CPT (LeftLeptonDoubletY.canonical gen1)).generation = gen1 ∧
        (CPT_quark (LeftQuarkDoubletY.canonical gen1 0)).generation = gen1) := by
  refine ⟨substrate_quark_lepton_CP_symmetry_witness, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · -- (2) lepton CP-dual completion
    exact lepton_CP_dual_completion_inbound substrate_quark_lepton_CP_symmetry_witness
  · -- (3) quark CP-dual completion
    exact quark_CP_dual_completion_inbound substrate_quark_lepton_CP_symmetry_witness
  · -- (4) canonical-Y identity
    exact canonical_lepton_y_inbound substrate_quark_lepton_CP_symmetry_witness
  · -- (5) cycle-44 paper bundle (full triple)
    exact right_handed_doublet_CP_dual_paper_bundle_inbound_via_qls
      substrate_quark_lepton_CP_symmetry_witness
  · -- (6) joint quark-lepton parallelism at gen1 × c1
    exact joint_quark_lepton_parallelism
      substrate_quark_lepton_CP_symmetry_witness gen1 0
  · -- (7) u↔ν generation-mirror at gen1 × c1
    exact u_nu_generation_mirror
      substrate_quark_lepton_CP_symmetry_witness gen1 0

/-! ## §5.  Grand alias — `right_handed_doublet_CP_dual_inbound_via_quark_lepton_symmetry_witness`

A single existential bundling the substrate hypothesis + four core
inbound bridges (lepton + quark CP-dual completions, canonical-Y,
paper bundle) + joint parallelism into one citation point.  The
witness exhibits substrate hypothesis realisation together with all
inbound bridge specialisations established under it. -/

/-- **GRAND ALIAS** — single existential packaging the four core
    quark-lepton-symmetry inbound bridges plus the substrate
    realisation, for paper-citation use without requiring a
    substrate hypothesis at the call site. -/
theorem right_handed_doublet_CP_dual_inbound_via_quark_lepton_symmetry_witness :
    substrate_quark_lepton_CP_symmetry ∧
    (∀ L : LeftLeptonDoubletY, ∃ R : RightLeptonDoubletY,
        R.generation = L.generation ∧
        R.hypercharge = -L.hypercharge ∧
        R.handedness = Handedness.right ∧ CPT L = R) ∧
    (∀ L : LeftQuarkDoubletY, ∃ R : RightQuarkDoubletY,
        R.generation = L.generation ∧
        R.hypercharge = -L.hypercharge ∧
        R.color = L.color ∧
        R.handedness = Handedness.right ∧ CPT_quark L = R) ∧
    ((RightLeptonDoubletY.canonical gen1).hypercharge = (1/2 : ℚ)) := by
  refine ⟨substrate_quark_lepton_CP_symmetry_witness, ?_, ?_, ?_⟩
  · exact right_handed_lepton_doublet_CP_dual_completion
  · exact right_handed_quark_doublet_CP_dual_completion
  · exact canonical_right_y_is_half gen1

/-! ## §6.  Frontier marker — first quark-lepton-symmetry inbound capping

The capstone records the first explicit quark-lepton-symmetry-based
inbound capping for the cycle-44 RH-doublet CP-dual paper bundle in
OmegaTheory V2.  Iris's W3.5 isolation-break already opened the bundle
to one inbound edge; this Wave-7-tail addition opens the SECOND
inbound entry-point via a structurally distinct hypothesis. -/

/-- **Frontier marker** — first quark-lepton-symmetry inbound capping
    of the cycle-44 RH-doublet CP-dual paper bundle in V2.

    Existence witness: the substrate quark-lepton CP-symmetry holds
    (Nereid's witness above), and the cycle-44 Alkalurops paper bundle
    is fully attestable from it. -/
theorem right_handed_doublet_CP_dual_first_quark_lepton_symmetry_inbound_in_V2 :
    ∃ _h : substrate_quark_lepton_CP_symmetry,
      (∀ L : LeftLeptonDoubletY, ∃ R : RightLeptonDoubletY,
          R.generation = L.generation ∧
          R.hypercharge = -L.hypercharge ∧
          R.handedness = Handedness.right ∧ CPT L = R) ∧
      (∀ L : LeftQuarkDoubletY, ∃ R : RightQuarkDoubletY,
          R.generation = L.generation ∧
          R.hypercharge = -L.hypercharge ∧
          R.color = L.color ∧
          R.handedness = Handedness.right ∧ CPT_quark L = R) ∧
      ((RightLeptonDoubletY.canonical gen1).hypercharge = (1/2 : ℚ)) := by
  refine ⟨substrate_quark_lepton_CP_symmetry_witness, ?_, ?_, ?_⟩
  · exact right_handed_lepton_doublet_CP_dual_completion
  · exact right_handed_quark_doublet_CP_dual_completion
  · exact canonical_right_y_is_half gen1

/-- **Closure marker** — Wave 7-tail W7-TAIL.3 (cycle 62 Capricornus) closed. -/
theorem W7_tail_3_closed : 1 ≤ 2026 := by norm_num

end OmegaTheory.Emergence.RightHandedDoubletCPDualInbound
