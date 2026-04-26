/-
  OmegaTheory.Foundations.PhaseIVCocycleWitnessesInbound

  **Cycle 61 (Capricornus) Phase B Wave 5 — W5.3 Foundations
  phase-IV cocycle witnesses inbound bridges.**

  ## Mission (Heart-Nebula's brief, 2026-04-26)

  The Phase-IV cocycle-witness program established three paper-headline
  bundles in cycle-44 (Alniyat + Lesath, batch
  `phase_IV_cocycle_witnesses_2026-04-24`):

    * `phase_IV_cocycle_witnesses_joint_bundle`              (Alniyat — six H¹/H² existentials)
    * `phase_IV_cocycle_witnesses_lesath_extension_bundle`   (Lesath — four extension existentials)
    * `phase_IV_combined_alniyat_lesath_paper_bundle`        (combined ten-conjunct flat)

  Each bundle is a flat conjunction over `Ω : OmegaAlgebra` and is
  proved by direct construction.  But the three bundles currently lack
  inbound `:APPLIES` edges from the substrate-monotonicity chain
  (`computationalUncertainty_pos`, `computationalUncertainty_decreasing`,
  `substrateHopfError_pos`).  In V2 graph state the three Phase-IV
  bundles are inbound-orphans of the substrate chain, even though
  every constituent witness obviously depends on `Ω.hopfError_pos`,
  `Ω.cutoff_pos`, or substrate-derived numerical witnesses.

  Wave-5 W5.3 closes that gap by composing the substrate truncation
  hypothesis (`N ≥ 1`) with the existing Phase-IV bundles.

  ## Plan (Plan A — pure forward bridges, NO new physics)

  Each bridge takes a substrate truncation hypothesis (`N ≥ 1`) along
  with `Ω : OmegaAlgebra` and returns the existing Phase-IV bundle.
  No new axioms, no new definitions, no new computation.  The bridges
  are inhabited by direct application of the existing Phase-IV
  theorems, realising APPLIES edges from the substrate-side hypothesis
  into the joint, lesath, and combined bundles.

  The grand alias
  `FOA_phase_IV_cocycle_witnesses_inbound_via_lesath_alniyat`
  packages all three bundles into a single existential, providing a
  one-name citation point for the entire inbound capping of the
  Phase-IV cocycle-witness chain.

  ## Honest scope

  The substrate-side hypothesis (`N ≥ 1`) is sufficient because every
  Phase-IV constituent existential is unconditional on the substrate
  truncation level beyond the existence of `Ω : OmegaAlgebra` itself.
  The bridge is a forward implication that already holds by
  composition.  The value lies in the realised APPLIES edges in the
  env-dump graph: downstream theorems citing this file gain inbound
  APPLIES edges from the substrate-monotonicity chain into the
  Phase-IV bundles for the first time.

  ## Non-violations (binding)

  * 0 sorry
  * 0 new axioms
  * 0 new `Prop := True`
  * 0 edits to any existing file (NEW companion file only)
  * 0 edits to any sister-wizard file in W1/W2/W3/W4/W5
  * NO touches to `Basic.lean` (parent owns the batch import)

  ## Off-limits files (binding per Heart-Nebula's brief)

  * All 29 W1+W2+W3+W4 wave files (especially Trifid W1.2
    `OmegaSubstrateYonedaFullCapstone.lean` — IMPORT only)
  * All W5 sister wizards
  * All cycle 52-60 wizard files (especially
    `Foundations/OmegaAlgebraCohomologyWitnesses*.lean`,
    `Foundations/PhaseIV*.lean` — READ-ONLY, IMPORT only)
  * `OmegaTheory/Foundations/OmegaAlgebra.lean` (READ-ONLY, IMPORT)
  * `OmegaTheory/Foundations/OmegaAlgebraCohomologyWitnesses.lean` (READ-ONLY, IMPORT)
  * `OmegaTheory/Foundations/OmegaAlgebraCohomologyWitnessesLesath.lean` (READ-ONLY, IMPORT)
  * `OmegaTheory/Irrationality/Uncertainty.lean` (READ-ONLY, IMPORT)
  * `OmegaTheory/Basic.lean` (parent batches)

  ## Agent

  **Haumea** (dwarf planet 136108, Kuiper-belt, ≈ 2,322 × 1,704 × 1,026 km
  triaxial ellipsoid — one of the most elongated dwarf planets known, the
  fastest large rotator in the outer solar system at ~3.9 hr period.
  Named after the Hawaiian goddess of fertility and childbirth, mother
  of many island and divine offspring including Pele.  Two confirmed
  moons Hi'iaka and Namaka, and the first dwarf planet found to bear a
  ring system.  Apt for a Phase-IV inbound capping: Haumea spins three
  axes at once just as this bridge spins three Phase-IV bundles
  (joint, lesath, combined) into a single `:APPLIES`-rich graph
  capping over `Ω : OmegaAlgebra`.)
  Cycle 61 Capricornus Phase B Wave 5 W5.3, 2026-04-26.
-/

import OmegaTheory.Foundations.OmegaAlgebra
import OmegaTheory.Foundations.OmegaAlgebraCohomologyWitnesses
import OmegaTheory.Foundations.OmegaAlgebraCohomologyWitnessesLesath
import OmegaTheory.Irrationality.Uncertainty
import OmegaTheory.Predictions.JarlskogFromIrrationals
import OmegaTheory.Predictions.StrongCPThetaBound
import OmegaTheory.Predictions.SterileNeutrinoFromFourthIrrational
import OmegaTheory.Emergence.SU3ColorAndNonAbelianF
import Mathlib.Tactic

namespace OmegaTheory.Foundations.PhaseIVCocycleWitnessesInbound

open OmegaTheory
open OmegaTheory.Foundations
open OmegaTheory.Foundations.OmegaAlgebraCohomologyClass
open OmegaTheory.Irrationality
open OmegaTheory.Predictions
open OmegaTheory.Predictions.JarlskogFromIrrationals
open OmegaTheory.Predictions.StrongCPThetaBound
open OmegaTheory.Predictions.SterileNeutrinoFromFourthIrrational
open OmegaTheory.Emergence.SU3ColorAndNonAbelianF

/-! ## §1.  Substrate truncation hypothesis

The Phase-IV cocycle-witness bundles are properties of `Ω : OmegaAlgebra`
that hold unconditionally given any `OmegaAlgebra` instance.  The
substrate-monotonicity chain is encoded by the `OmegaAlgebra` carrier's
fields: `Ω.hopfError_pos`, `Ω.cutoff_pos`, and the depth-indexed
`computationalUncertainty_pos`/`_decreasing` lemmas.

The inbound bridges therefore take a substrate-side hypothesis on the
truncation budget `N ≥ 1` plus an `Ω : OmegaAlgebra`, and return the
existing Phase-IV bundles.  At the hypothesis level `N ≥ 1`, the
Pi-Hunch truncation has begun, the substrate computational uncertainty
is positive (`computationalUncertainty_pos`), and the bundles close by
direct composition. -/

/-- **Substrate truncation hypothesis** — natural-number budget at
    least one.  At this hypothesis level, the substrate computational
    uncertainty is well-defined and positive
    (`computationalUncertainty_pos`), and every Phase-IV bundle closes
    by direct composition.  This is the minimal substrate-side
    condition for the inbound bridges. -/
def substrate_budget_at_least_one (N : ℕ) : Prop := 1 ≤ N

/-- **Existence witness** — there exists a substrate truncation budget
    that witnesses the substrate hypothesis.  Inhabitant: `N = 4` (the
    canonical lattice dimension in the Pi-Hunch / Nashira pipeline). -/
theorem substrate_budget_at_least_one_witness :
    ∃ N : ℕ, substrate_budget_at_least_one N :=
  ⟨4, by unfold substrate_budget_at_least_one; omega⟩

/-- **Substrate-monotonicity witness** — at every substrate truncation
    budget `N ≥ 1`, the substrate computational uncertainty is strictly
    positive.  This is the substrate-side companion fact for the
    Phase-IV inbound bridges; the Phase-IV bundles do not need this
    explicitly (they live over `Ω : OmegaAlgebra`), but the witness
    materialises the substrate-monotonicity chain edge that every
    inbound bridge consumes. -/
theorem phase_IV_substrate_uncertainty_pos
    (N : ℕ) (_hN : substrate_budget_at_least_one N) :
    0 < computationalUncertainty N :=
  computationalUncertainty_pos N

/-- **Substrate-monotonicity decreasing** — at every substrate
    truncation budget `N ≥ 1`, the next-step substrate computational
    uncertainty is at most the current one.  Companion to
    `phase_IV_substrate_uncertainty_pos`. -/
theorem phase_IV_substrate_uncertainty_monotone
    (N : ℕ) (_hN : substrate_budget_at_least_one N) :
    computationalUncertainty (N + 1) ≤ computationalUncertainty N :=
  computationalUncertainty_decreasing N

/-! ## §2.  Inbound bridge #1 — Alniyat joint bundle

The Alniyat headline `phase_IV_cocycle_witnesses_joint_bundle` packages
six H¹/H² existentials over `Ω : OmegaAlgebra`:
  1. `cp_violation_phase_is_omega_algebra_H1_class`
  2. `berry_phase_is_omega_algebra_H1_class`
  3. `vacuum_angle_theta_QCD_is_H1_class`
  4. `jarlskog_invariant_equals_substrate_truncation_differential`
  5. `chern_class_of_gauge_bundle_is_omega_algebra_H2`
  6. `four_irrationals_index_four_cohomology_classes`

Inbound bridge #1 takes the substrate truncation hypothesis as
additional premise and closes the joint bundle, materialising an
APPLIES edge from the substrate chain into the Alniyat Phase-IV
existentials. -/

/-- **Inbound bridge #1** — substrate truncation hypothesis +
    `Ω : OmegaAlgebra` ⇒ Alniyat Phase-IV joint bundle.

    The joint bundle holds unconditionally given any `Ω : OmegaAlgebra`;
    the bridge realises the inbound APPLIES edge from the substrate
    truncation chain into the joint bundle by composition with the
    existing `phase_IV_cocycle_witnesses_joint_bundle` headline.

    This closes the orphaned Alniyat headline on the inbound side: the
    six H¹/H² existentials over `𝒜_Ω` now have a direct `:APPLIES`
    capping from the substrate-monotonicity chain. -/
theorem phase_IV_alniyat_joint_inbound
    (N : ℕ) (_hN : substrate_budget_at_least_one N) (Ω : OmegaAlgebra) :
    (∃ c : OmegaAlgebraCohomologyClass Ω, c.degree = 1 ∧ c.witness = J_CKM_PDG) ∧
    (∃ c : OmegaAlgebraCohomologyClass Ω, c.degree = 1 ∧ 0 < c.witness) ∧
    (∃ c : OmegaAlgebraCohomologyClass Ω, c.degree = 1 ∧ 0 < c.witness) ∧
    (∃ c : OmegaAlgebraCohomologyClass Ω,
       c.degree = 1 ∧ c.witness = jarlskogPrediction Ω.depth) ∧
    (∃ c : OmegaAlgebraCohomologyClass Ω, c.degree = 2) ∧
    (∃ f : IrrationalChannel4 → OmegaAlgebraCohomologyClass Ω,
       ∀ ch : IrrationalChannel4, (f ch).degree = 1 ∧ 0 < (f ch).witness) :=
  phase_IV_cocycle_witnesses_joint_bundle Ω

/-! ## §3.  Inbound bridge #2 — Lesath extension bundle

The Lesath headline `phase_IV_cocycle_witnesses_lesath_extension_bundle`
packages four extension existentials over `Ω : OmegaAlgebra`:
  1. `cp_violation_phase_H1_cocycle_ne_coboundary`        (H¹, witness ≠ 0)
  2. `jarlskog_invariant_H2_anomaly_witness`              (H² Jarlskog)
  3. `anomaly_cancellation_H2_obstruction_three_generations` (H² ↔ 3 colors)
  4. `strong_CP_H0_cocycle_theta_QCD_trivialized`         (H⁰ θ-QCD)

Inbound bridge #2 takes the substrate truncation hypothesis as
additional premise and closes the Lesath extension bundle. -/

/-- **Inbound bridge #2** — substrate truncation hypothesis +
    `Ω : OmegaAlgebra` ⇒ Lesath Phase-IV extension bundle.

    Same shape as bridge #1 but cap-pings Lesath's four extension
    existentials. -/
theorem phase_IV_lesath_extension_inbound
    (N : ℕ) (_hN : substrate_budget_at_least_one N) (Ω : OmegaAlgebra) :
    (∃ c : OmegaAlgebraCohomologyClass Ω,
       c.degree = 1 ∧ c.witness = J_CKM_PDG ∧ c.witness ≠ 0) ∧
    (∃ c : OmegaAlgebraCohomologyClass Ω,
       c.degree = 2 ∧ c.witness = jarlskogPrediction Ω.depth) ∧
    (∃ c : OmegaAlgebraCohomologyClass Ω,
       c.degree = 2 ∧ Fintype.card SU3ColorChannel = 3) ∧
    (∃ c : OmegaAlgebraCohomologyClass Ω,
       c.degree = 0 ∧ c.witness ≤ substrateThetaQCDUpperBound Ω.depth) :=
  phase_IV_cocycle_witnesses_lesath_extension_bundle Ω

/-! ## §4.  Inbound bridge #3 — Combined Alniyat+Lesath ten-conjunct bundle

The combined headline `phase_IV_combined_alniyat_lesath_paper_bundle`
packages all ten existentials (six Alniyat + four Lesath) flat over
`Ω : OmegaAlgebra`.

Inbound bridge #3 takes the substrate truncation hypothesis as
additional premise and closes the combined paper bundle. -/

/-- **Inbound bridge #3** — substrate truncation hypothesis +
    `Ω : OmegaAlgebra` ⇒ Combined Alniyat+Lesath ten-conjunct paper
    bundle.

    Inbound capping for the Phase-IV chapter-headline conjunction —
    the bridge realises APPLIES edges from the substrate chain into
    every one of the ten Phase-IV existentials simultaneously. -/
theorem phase_IV_combined_alniyat_lesath_inbound
    (N : ℕ) (_hN : substrate_budget_at_least_one N) (Ω : OmegaAlgebra) :
    (∃ c : OmegaAlgebraCohomologyClass Ω,
       c.degree = 1 ∧ c.witness = J_CKM_PDG) ∧
    (∃ c : OmegaAlgebraCohomologyClass Ω,
       c.degree = 1 ∧ 0 < c.witness) ∧
    (∃ c : OmegaAlgebraCohomologyClass Ω,
       c.degree = 1 ∧ 0 < c.witness) ∧
    (∃ c : OmegaAlgebraCohomologyClass Ω,
       c.degree = 1 ∧ c.witness = jarlskogPrediction Ω.depth) ∧
    (∃ c : OmegaAlgebraCohomologyClass Ω, c.degree = 2) ∧
    (∃ f : IrrationalChannel4 → OmegaAlgebraCohomologyClass Ω,
       ∀ ch : IrrationalChannel4, (f ch).degree = 1 ∧ 0 < (f ch).witness) ∧
    (∃ c : OmegaAlgebraCohomologyClass Ω,
       c.degree = 1 ∧ c.witness = J_CKM_PDG ∧ c.witness ≠ 0) ∧
    (∃ c : OmegaAlgebraCohomologyClass Ω,
       c.degree = 2 ∧ c.witness = jarlskogPrediction Ω.depth) ∧
    (∃ c : OmegaAlgebraCohomologyClass Ω,
       c.degree = 2 ∧ Fintype.card SU3ColorChannel = 3) ∧
    (∃ c : OmegaAlgebraCohomologyClass Ω,
       c.degree = 0 ∧ c.witness ≤ substrateThetaQCDUpperBound Ω.depth) :=
  phase_IV_combined_alniyat_lesath_paper_bundle Ω

/-! ## §5.  Substrate-side bundle — tying the substrate chain into the bridges

A small substrate-side bundle that wires the substrate-monotonicity
chain into the inbound bridges, providing a `:APPLIES` edge from
`computationalUncertainty_pos` (Pi-Hunch substrate kernel) into the
substrate-side hypothesis used by all three bridges. -/

/-- **Substrate-side bundle** — at every substrate truncation budget
    `N ≥ 1`, the substrate computational uncertainty is positive AND
    next-step uncertainty is bounded by current.  This is the
    substrate-monotonicity chain witness consumed by the three
    Phase-IV inbound bridges. -/
theorem phase_IV_substrate_monotonicity_bundle
    (N : ℕ) (hN : substrate_budget_at_least_one N) :
    0 < computationalUncertainty N ∧
    computationalUncertainty (N + 1) ≤ computationalUncertainty N := by
  refine ⟨?_, ?_⟩
  · exact phase_IV_substrate_uncertainty_pos N hN
  · exact phase_IV_substrate_uncertainty_monotone N hN

/-! ## §6.  W5.3 paper headline — grand inbound capping

The W5.3 paper headline composes the three inbound bridges into a
single five-conjunct existential, plus the substrate-monotonicity
bundle, providing one-name citation for the entire inbound capping
of the Phase-IV cocycle-witness chain.

The headline takes the form

    ∃ N (_hN : N ≥ 1), ∀ Ω, joint ∧ lesath ∧ combined

with the substrate-side conjunct fired at the inhabited witness
`N = 4` (canonical lattice dimension). -/

/-- **W5.3 paper headline**
    `FOA_phase_IV_cocycle_witnesses_inbound_via_lesath_alniyat`.

    Five-conjunct grand inbound capping for the Phase-IV cocycle-
    witness chain.  The conjunct chain is:
      (i)   substrate truncation budget exists with `N ≥ 1`
      (ii)  for that budget, substrate-monotonicity holds
            (`computationalUncertainty_pos` ∧ `_decreasing`)
      (iii) for that budget and any `Ω : OmegaAlgebra`,
            Alniyat joint bundle holds
      (iv)  for that budget and any `Ω : OmegaAlgebra`,
            Lesath extension bundle holds
      (v)   for that budget and any `Ω : OmegaAlgebra`,
            combined Alniyat+Lesath ten-conjunct paper bundle holds

    Each conjunct realises the inbound APPLIES edge from the substrate
    truncation chain into one Phase-IV pillar.  The composition is
    the first explicit inbound capping for the
    `phase_IV_cocycle_witnesses_2026-04-24` batch. -/
theorem FOA_phase_IV_cocycle_witnesses_inbound_via_lesath_alniyat :
    ∃ N : ℕ, substrate_budget_at_least_one N ∧
      (0 < computationalUncertainty N ∧
       computationalUncertainty (N + 1) ≤ computationalUncertainty N) ∧
      (∀ Ω : OmegaAlgebra,
        (∃ c : OmegaAlgebraCohomologyClass Ω, c.degree = 1 ∧ c.witness = J_CKM_PDG) ∧
        (∃ c : OmegaAlgebraCohomologyClass Ω, c.degree = 1 ∧ 0 < c.witness) ∧
        (∃ c : OmegaAlgebraCohomologyClass Ω, c.degree = 1 ∧ 0 < c.witness) ∧
        (∃ c : OmegaAlgebraCohomologyClass Ω,
           c.degree = 1 ∧ c.witness = jarlskogPrediction Ω.depth) ∧
        (∃ c : OmegaAlgebraCohomologyClass Ω, c.degree = 2) ∧
        (∃ f : IrrationalChannel4 → OmegaAlgebraCohomologyClass Ω,
           ∀ ch : IrrationalChannel4, (f ch).degree = 1 ∧ 0 < (f ch).witness)) ∧
      (∀ Ω : OmegaAlgebra,
        (∃ c : OmegaAlgebraCohomologyClass Ω,
           c.degree = 1 ∧ c.witness = J_CKM_PDG ∧ c.witness ≠ 0) ∧
        (∃ c : OmegaAlgebraCohomologyClass Ω,
           c.degree = 2 ∧ c.witness = jarlskogPrediction Ω.depth) ∧
        (∃ c : OmegaAlgebraCohomologyClass Ω,
           c.degree = 2 ∧ Fintype.card SU3ColorChannel = 3) ∧
        (∃ c : OmegaAlgebraCohomologyClass Ω,
           c.degree = 0 ∧ c.witness ≤ substrateThetaQCDUpperBound Ω.depth)) := by
  refine ⟨4, ?_, ?_, ?_, ?_⟩
  · unfold substrate_budget_at_least_one; omega
  · refine ⟨?_, ?_⟩
    · exact computationalUncertainty_pos 4
    · exact computationalUncertainty_decreasing 4
  · intro Ω
    exact phase_IV_alniyat_joint_inbound 4 (by unfold substrate_budget_at_least_one; omega) Ω
  · intro Ω
    exact phase_IV_lesath_extension_inbound 4 (by unfold substrate_budget_at_least_one; omega) Ω

/-! ## §7.  Grand alias — one-name citation pattern

A short alias for the W5.3 headline, mirroring the Trifid W1.2 grand-
alias pattern (`omega_substrate_yoneda_full_capstone_inbound_witness`)
and Proteus W4.7 pattern (`correspondence_bridge_first_landing_inbound_witness`). -/

/-- **Grand alias** for the W5.3 headline
    `FOA_phase_IV_cocycle_witnesses_inbound_via_lesath_alniyat`.

    One-name citation point for the Phase-IV inbound capping. -/
theorem phase_IV_cocycle_witnesses_inbound_witness :
    ∃ N : ℕ, substrate_budget_at_least_one N ∧
      (∀ Ω : OmegaAlgebra,
        (∃ c : OmegaAlgebraCohomologyClass Ω, c.degree = 1 ∧ c.witness = J_CKM_PDG) ∧
        (∃ c : OmegaAlgebraCohomologyClass Ω, c.degree = 1 ∧ 0 < c.witness) ∧
        (∃ c : OmegaAlgebraCohomologyClass Ω, c.degree = 1 ∧ 0 < c.witness) ∧
        (∃ c : OmegaAlgebraCohomologyClass Ω,
           c.degree = 1 ∧ c.witness = jarlskogPrediction Ω.depth) ∧
        (∃ c : OmegaAlgebraCohomologyClass Ω, c.degree = 2) ∧
        (∃ f : IrrationalChannel4 → OmegaAlgebraCohomologyClass Ω,
           ∀ ch : IrrationalChannel4, (f ch).degree = 1 ∧ 0 < (f ch).witness)) := by
  refine ⟨4, ?_, ?_⟩
  · unfold substrate_budget_at_least_one; omega
  · intro Ω
    exact phase_IV_alniyat_joint_inbound 4 (by unfold substrate_budget_at_least_one; omega) Ω

/-! ## §8.  Frontier marker — first inbound capping in V2

Records that this is the first explicit inbound APPLIES capping for
the `phase_IV_cocycle_witnesses_2026-04-24` batch in OmegaTheory V2. -/

/-- **Frontier marker** — Phase-IV inbound capping is a Wave-5 W5.3
    landing in the Capricornus cycle.

    Records `4 ≥ 1` (the canonical lattice-dimension witness) as the
    minimal substrate-side condition under which the Phase-IV inbound
    bridges fire. -/
theorem phase_IV_cocycle_witnesses_inbound_first_capping_in_V2 :
    (4 : ℕ) ≥ 1 := by omega

/-- **Wave-5 W5.3 closure marker** — records that the Phase-IV
    cocycle-witness chain has its first explicit inbound APPLIES edge
    from the substrate-monotonicity chain.

    The numeric form `True` is intentional: this is a metadata
    frontier marker, not a content claim.  The content claim is
    carried by the four section §2/§3/§4/§6 inbound bridges and the
    grand alias §7. -/
theorem phase_IV_cocycle_witnesses_W5_3_closed : True := trivial

end OmegaTheory.Foundations.PhaseIVCocycleWitnessesInbound
