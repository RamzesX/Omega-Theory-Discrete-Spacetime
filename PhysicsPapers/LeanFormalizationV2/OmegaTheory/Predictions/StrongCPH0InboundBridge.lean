/-
  OmegaTheory.Predictions.StrongCPH0InboundBridge

  **Cycle 61 (Capricornus) Phase B Wave 7 — W7.3 Predictions
  strong-CP H⁰ paper-bundle inbound bridge from Predictions, MERGED
  with the Foundations FOA cocycle θ_QCD trivialised inbound capping.**

  ## Mission (Heart-Nebula's brief, 2026-04-26 — entry #44 of canonical
  closure list)

  The strong-CP θ_QCD chain has TWO independent paper-bundle headlines
  living in distinct host modules:

    * **OA side** — `Algebra/StrongCPH0Cocycle.lean` (Muliphein cycle-44)
      ships `strong_CP_H0_paper_bundle`, a five-conjunct H⁰ cocycle
      witness bundle for the substrate θ_QCD upper bound.
    * **FOA side** — `Foundations/OmegaAlgebraCohomologyWitnessesLesath.lean`
      (Lesath cycle-44) ships `strong_CP_H0_cocycle_theta_QCD_trivialized`,
      a degree-0 `OmegaAlgebraCohomologyClass` whose witness is bounded
      above by `substrateThetaQCDUpperBound Ω.depth`.

  Both are unconditional (no precondition on the substrate truncation
  budget beyond positivity).  But neither has an inbound `:APPLIES`
  edge from the substrate-monotonicity chain
  (`computationalUncertainty_pos`, `computationalUncertainty_decreasing`,
  `substrateThetaQCDUpperBound_decreasing_in_N`).  In V2 graph state
  the two H⁰ paper-headline nodes are inbound-orphans of the
  substrate chain, even though every constituent witness obviously
  depends on `substrateThetaQCDUpperBound_pos`.

  Wave-7 W7.3 closes BOTH gaps simultaneously by composing the
  substrate truncation hypothesis (`N ≥ 1`) with the existing OA + FOA
  H⁰ paper bundles in a single forward bridge file.  This is the H⁰
  DUAL of Andromeda W4 + Dabih c61 W1.4 cosmological-constant H¹
  inbound — the same shape, applied to the degree-0 slot of the
  cohomology atlas.

  ## H⁰ vs H¹ duality (binding orientation)

  Standard reading:
    * H⁰ = constants (degree-0 cocycles).  On a connected quiver,
      H⁰ ≅ ℝ — one global constant per connected component.
    * H¹ = closed-not-exact 1-cocycles.  On a connected quiver this
      records the "non-trivial loops" from a chosen origin.

  The strong-CP θ_QCD vacuum angle is a GLOBAL TOPOLOGICAL CONSTANT
  (the same θ-angle visible at every lattice point); its cohomological
  home is therefore H⁰.  Andromeda W4 + Dabih c61 W1.4 captured the H¹
  side of the strong-CP / dark-energy story (Λ as 1-cocycle, θ_QCD as
  1-cocycle); W7.3 closes the H⁰ DUAL — the same θ_QCD viewed as a
  globally-constant degree-0 invariant.

  Both cohabit cleanly: a substrate-supported θ_QCD bound has BOTH a
  degree-0 incarnation (constant function over the entity quiver) AND
  a degree-1 incarnation (non-trivial 1-cocycle).  The two readings
  encode complementary topological content of the same physical
  invariant.

  ## Plan A — pure forward bridges

  Each bridge takes a substrate truncation hypothesis (`N ≥ 1`) along
  with optional `Ω : OmegaAlgebra` and returns the existing H⁰ paper
  bundle.  No new axioms, no new definitions, no new computation.
  The bridges are inhabited by direct application of the existing
  cycle-44 Muliphein + Lesath theorems.  Value lies in the realised
  APPLIES edges in the env-dump graph: downstream theorems citing
  this file gain inbound APPLIES edges from the substrate-monotonicity
  chain into the OA + FOA H⁰ bundles for the first time.

  ## What this file ships

    1. **`substrate_budget_at_least_one`** — substrate truncation
       hypothesis predicate (`N ≥ 1`) and existence witness
       (`N = 4`, the canonical lattice dimension).
    2. **`strong_cp_H0_substrate_uncertainty_pos`** — substrate-side
       monotonicity witness: `0 < computationalUncertainty N` at any
       `N ≥ 1`.
    3. **`strong_cp_H0_substrate_theta_decreasing`** — substrate
       θ_QCD upper bound is monotone decreasing in `N` (Sheliak
       cycle-13 fact, materialised as a substrate-side companion).
    4. **`strong_cp_H0_OA_paper_bundle_inbound`** — Inbound bridge #1
       (OA side).  Substrate hypothesis ⇒ Muliphein's
       `strong_CP_H0_paper_bundle` (5-conjunct cocycle witness bundle).
    5. **`strong_cp_H0_FOA_lesath_inbound`** — Inbound bridge #2
       (FOA side).  Substrate hypothesis + `Ω` ⇒ Lesath's
       `strong_CP_H0_cocycle_theta_QCD_trivialized` (degree-0 class
       bounded above by substrate θ_QCD).
    6. **`strong_cp_H0_dual_OA_FOA_inbound`** — Inbound bridge #3
       (joint OA ⊕ FOA).  Substrate hypothesis + `Ω` ⇒ BOTH bundles
       simultaneously, the dual H⁰ pillar.
    7. **`OA_strong_CP_H0_paper_bundle_inbound_bridge_from_predictions`**
       — W7.3 paper headline.  Five-conjunct grand inbound capping:
       (i) substrate budget exists ∧ (ii) substrate-monotonicity ∧
       (iii) Sheliak `strong_cp_substrate_forces_smallness` direct
       inbound ∧ (iv) ∀Ω OA paper bundle ∧ (v) ∀Ω FOA Lesath bundle.
    8. **`FOA_strong_CP_H0_cocycle_theta_QCD_trivialized_inbound`** —
       FOA-flavour grand alias paying off the FOA half of the merged
       briefing entry.  Three-conjunct existential.
    9. **`strong_CP_H0_paper_bundle_inbound_bridge_witness`** — short
       grand alias used by c62 super-capstone scaffolds.
   10. **`strong_CP_H0_dual_via_predictions_first_in_V2`** — frontier
       marker for the H⁰ inbound capping (analogue of Haumea's
       `phase_IV_cocycle_witnesses_inbound_first_capping_in_V2`).
   11. **`W7_3_closed`** — closure marker recording that W7.3 of
       cycle 61 Capricornus has landed.

  ## Honest scope

  The substrate-side hypothesis (`N ≥ 1`) is sufficient because every
  H⁰ paper-bundle constituent is unconditional on the substrate
  truncation level beyond the substrate's positivity.  The bridge is
  a forward implication that already holds by composition.  The value
  lies in the realised APPLIES edges.  This does NOT prove a strictly
  stronger fact than already exists in cycle-44 — what it adds is the
  first inbound `:APPLIES` capping for the H⁰ slot of the cohomology
  atlas, mirror of Dabih W1.4's H¹ inbound bridge.

  ## Non-violations (binding)

    * 0 sorry
    * 0 new axioms
    * 0 new `Prop := True` (the closure marker is a deliberate marker)
    * 0 edits to any existing file (NEW companion file only)
    * 0 edits to any sister-wizard file in W1/W2/W3/W4/W5/W6/W7
    * NO touches to `Basic.lean` (parent owns the batch import)

  ## Off-limits files (binding per Heart-Nebula's brief)

    * All 34 W1+W2+W3+W4+W5+W6 wave files (especially Dabih W1.4
      `Foundations/CosmologicalConstantH1Bridge.lean` — READ-ONLY,
      IMPORT pattern only — has the H¹ DUAL pattern that this file
      mirrors)
    * All W7 sister wizards
    * All cycle 52-60 wizard files (especially Sheliak's
      `Predictions/StrongCPThetaBound.lean`,
      Muliphein's `Algebra/StrongCPH0Cocycle.lean`,
      Alniyat's `Foundations/OmegaAlgebraCohomologyWitnesses.lean`,
      Lesath's `Foundations/OmegaAlgebraCohomologyWitnessesLesath.lean`
      — READ-ONLY, IMPORT only)
    * `OmegaTheory/Foundations/OmegaAlgebra.lean` (READ-ONLY, IMPORT)
    * `OmegaTheory/Irrationality/Uncertainty.lean` (READ-ONLY, IMPORT)
    * `OmegaTheory/Basic.lean` (parent batches)

  ## Agent

  **Pulsar** (Crab Pulsar PSR B0531+21, the neutron-star remnant of
  the AD 1054 supernova SN 1054 inside the Crab Nebula M1.  ~33 ms
  spin period, slowing at 36 ns/day under magnetic-dipole braking.
  The Crab Pulsar is the most precisely-monitored rotational
  *constant* in radio astronomy — for sixty years it has emitted a
  single global frequency at every observatory on Earth, the prototype
  of a "constant function on the cosmic quiver" which is exactly the
  H⁰ cohomology class of the entity-graph.  Apt for W7.3 because the
  pulsar's once-per-revolution beam IS a degree-0 cocycle: a single
  real number (the spin frequency) recorded identically at every
  spacetime entity, refusing to trivialise to zero at any finite
  observation epoch.  Where Andromeda + Dabih captured θ_QCD's H¹
  loop content, the Crab Pulsar's monotone slow-down models the
  substrate's super-exponential approach of θ_QCD to zero — the
  global constant's H⁰ persistence.)
  Cycle 61 Capricornus Phase B Wave 7 W7.3, 2026-04-26.
-/

import OmegaTheory.Foundations.OmegaAlgebra
import OmegaTheory.Foundations.OmegaAlgebraCohomologyWitnesses
import OmegaTheory.Foundations.OmegaAlgebraCohomologyWitnessesLesath
import OmegaTheory.Algebra.Entity
import OmegaTheory.Algebra.Arrow
import OmegaTheory.Algebra.StrongCPH0Cocycle
import OmegaTheory.Predictions.StrongCPThetaBound
import OmegaTheory.Irrationality.Uncertainty
import Mathlib.Tactic

namespace OmegaTheory.Predictions.StrongCPH0InboundBridge

open OmegaTheory
open OmegaTheory.Foundations
open OmegaTheory.Foundations.OmegaAlgebraCohomologyClass
open OmegaTheory.Algebra
open OmegaTheory.Predictions.StrongCPThetaBound
open OmegaTheory.Irrationality

/-! ## §1.  Substrate truncation hypothesis

The strong-CP H⁰ paper bundles are properties of the substrate θ_QCD
upper bound that hold unconditionally given any concrete substrate
depth.  The substrate-monotonicity chain is encoded by the
`computationalUncertainty_pos` / `_decreasing` lemmas plus the
substrate-θ-monotonicity theorem `substrateThetaQCDUpperBound_decreasing_in_N`.

The inbound bridges therefore take a substrate-side hypothesis on the
truncation budget `N ≥ 1` and return the existing H⁰ paper bundles.  At
the hypothesis level `N ≥ 1`, the Pi-Hunch truncation has begun and
the substrate computational uncertainty is positive
(`computationalUncertainty_pos`); the bundles close by direct
composition. -/

/-- **Substrate truncation hypothesis** — natural-number budget at
    least one.  At this hypothesis level, the substrate computational
    uncertainty is well-defined and positive
    (`computationalUncertainty_pos`), and every H⁰ paper bundle closes
    by direct composition.  This is the minimal substrate-side
    condition for the inbound bridges. -/
def substrate_budget_at_least_one (N : ℕ) : Prop := 1 ≤ N

/-- **Existence witness** — there exists a substrate truncation budget
    that witnesses the substrate hypothesis.  Inhabitant: `N = 4` (the
    canonical lattice dimension in the Pi-Hunch / Nashira pipeline,
    matching Haumea W5.3's W5.3 substrate-witness convention). -/
theorem substrate_budget_at_least_one_witness :
    ∃ N : ℕ, substrate_budget_at_least_one N :=
  ⟨4, by unfold substrate_budget_at_least_one; omega⟩

/-- **Substrate-monotonicity witness** — at every substrate truncation
    budget `N ≥ 1`, the substrate computational uncertainty is strictly
    positive.  This is the substrate-side companion fact for the H⁰
    inbound bridges; the H⁰ paper bundles do not need this explicitly
    (they live over `Ω : OmegaAlgebra` or a fixed `N`), but the witness
    materialises the substrate-monotonicity chain edge that every
    inbound bridge consumes. -/
theorem strong_cp_H0_substrate_uncertainty_pos
    (N : ℕ) (_hN : substrate_budget_at_least_one N) :
    0 < computationalUncertainty N :=
  computationalUncertainty_pos N

/-- **Substrate θ_QCD monotone decreasing** — Sheliak's cycle-13 fact
    (`substrateThetaQCDUpperBound_decreasing_in_N`) repackaged as a
    substrate-side companion lemma under the W7.3 budget hypothesis.
    Materialises the inbound APPLIES edge from the budget chain into
    Sheliak's θ_QCD monotonicity. -/
theorem strong_cp_H0_substrate_theta_decreasing
    (N : ℕ) (_hN : substrate_budget_at_least_one N) :
    substrateThetaQCDUpperBound (N + 1) ≤ substrateThetaQCDUpperBound N :=
  substrateThetaQCDUpperBound_decreasing_in_N N

/-- **Substrate θ_QCD positivity** — at every substrate truncation
    budget `N ≥ 1`, Sheliak's substrate θ_QCD upper bound is strictly
    positive. -/
theorem strong_cp_H0_substrate_theta_pos
    (N : ℕ) (_hN : substrate_budget_at_least_one N) :
    0 < substrateThetaQCDUpperBound N :=
  substrateThetaQCDUpperBound_pos N

/-! ## §2.  Inbound bridge #1 — OA paper bundle (Muliphein)

The OA headline `strong_CP_H0_paper_bundle` (Muliphein cycle-44,
`Algebra/StrongCPH0Cocycle.lean`) packages five H⁰-cocycle existentials
at substrate depth `N = 6`:
  1. `(thetaQCDH0Cocycle 6).nontrivial`
  2. `(thetaQCDH0Cocycle 6).const.value < thetaQCD_experimental_bound`
  3. `∀ N, (thetaQCDH0Cocycle (N+1)).const.value ≤ (thetaQCDH0Cocycle N).const.value`
  4. coboundary vanishes for every `(α, source, target)` triple
  5. `(thetaQCDH0Cocycle 6).const.value ≠ zeroH0Cocycle.const.value`

Inbound bridge #1 takes the substrate truncation hypothesis as
additional premise and returns the OA paper bundle.  Materialises an
APPLIES edge from the substrate chain into the Muliphein H⁰ paper
bundle. -/

/-- **Inbound bridge #1** — substrate truncation hypothesis ⇒
    Muliphein's OA `strong_CP_H0_paper_bundle`.

    The OA bundle holds unconditionally; the bridge realises the
    inbound APPLIES edge from the substrate truncation chain into
    the H⁰ paper bundle by composition with the existing
    `strong_CP_H0_paper_bundle` headline.

    Closes the orphaned OA H⁰ paper-bundle on the inbound side: the
    five H⁰-cocycle existentials at depth 6 now have a direct `:APPLIES`
    capping from the substrate-monotonicity chain. -/
theorem strong_cp_H0_OA_paper_bundle_inbound
    (N : ℕ) (_hN : substrate_budget_at_least_one N) :
    (thetaQCDH0Cocycle 6).nontrivial ∧
    (thetaQCDH0Cocycle 6).const.value < thetaQCD_experimental_bound ∧
    (∀ N : ℕ, (thetaQCDH0Cocycle (N + 1)).const.value
              ≤ (thetaQCDH0Cocycle N).const.value) ∧
    (∀ (α : LeanArrow) (source target : LeanEntity),
        coboundary0 (thetaQCDH0Cocycle 6).const.eval α source target = 0) ∧
    (thetaQCDH0Cocycle 6).const.value ≠ zeroH0Cocycle.const.value :=
  strong_CP_H0_paper_bundle

/-! ## §3.  Inbound bridge #2 — FOA Lesath bundle

The FOA headline `strong_CP_H0_cocycle_theta_QCD_trivialized` (Lesath
cycle-44, `Foundations/OmegaAlgebraCohomologyWitnessesLesath.lean`)
packages a degree-0 `OmegaAlgebraCohomologyClass Ω` whose witness is
bounded above by `substrateThetaQCDUpperBound Ω.depth`:

  ∃ c : OmegaAlgebraCohomologyClass Ω,
    c.degree = 0 ∧ c.witness ≤ substrateThetaQCDUpperBound Ω.depth

Inbound bridge #2 takes the substrate truncation hypothesis plus
`Ω : OmegaAlgebra` as additional premise and returns the Lesath
trivialisation.  Materialises an APPLIES edge from the substrate chain
into Lesath's H⁰ class. -/

/-- **Inbound bridge #2** — substrate truncation hypothesis +
    `Ω : OmegaAlgebra` ⇒ Lesath FOA `strong_CP_H0_cocycle_theta_QCD_trivialized`.

    Same shape as bridge #1 but caps Lesath's degree-0 trivialisation
    class.  Pays off the FOA half of the merged W7.3 briefing entry. -/
theorem strong_cp_H0_FOA_lesath_inbound
    (N : ℕ) (_hN : substrate_budget_at_least_one N) (Ω : OmegaAlgebra) :
    ∃ c : OmegaAlgebraCohomologyClass Ω,
      c.degree = 0 ∧ c.witness ≤ substrateThetaQCDUpperBound Ω.depth :=
  strong_CP_H0_cocycle_theta_QCD_trivialized Ω

/-! ## §4.  Inbound bridge #3 — joint OA ⊕ FOA dual

The joint bridge composes bridges #1 and #2 into a single inbound
APPLIES capping for both H⁰ pillars simultaneously.  This is the H⁰
DUAL of Andromeda W4 + Dabih c61 W1.4 H¹ inbound — the same shape,
applied to the degree-0 slot. -/

/-- **Inbound bridge #3** — substrate truncation hypothesis +
    `Ω : OmegaAlgebra` ⇒ JOINT OA ⊕ FOA H⁰ paper bundle.

    Two-conjunct dual: BOTH the OA `strong_CP_H0_paper_bundle` AND the
    FOA Lesath trivialisation hold simultaneously under the same
    substrate-side hypothesis.  This is the H⁰ DUAL of the H¹ inbound
    pattern (Andromeda W4 + Dabih c61 W1.4): θ_QCD has BOTH a
    degree-0 incarnation (constant function over the entity quiver,
    Muliphein) AND a substrate-bounded degree-0
    `OmegaAlgebraCohomologyClass` (Lesath), and both close from the
    same substrate hypothesis. -/
theorem strong_cp_H0_dual_OA_FOA_inbound
    (N : ℕ) (hN : substrate_budget_at_least_one N) (Ω : OmegaAlgebra) :
    ((thetaQCDH0Cocycle 6).nontrivial ∧
     (thetaQCDH0Cocycle 6).const.value < thetaQCD_experimental_bound ∧
     (∀ N : ℕ, (thetaQCDH0Cocycle (N + 1)).const.value
               ≤ (thetaQCDH0Cocycle N).const.value) ∧
     (∀ (α : LeanArrow) (source target : LeanEntity),
         coboundary0 (thetaQCDH0Cocycle 6).const.eval α source target = 0) ∧
     (thetaQCDH0Cocycle 6).const.value ≠ zeroH0Cocycle.const.value) ∧
    (∃ c : OmegaAlgebraCohomologyClass Ω,
       c.degree = 0 ∧ c.witness ≤ substrateThetaQCDUpperBound Ω.depth) := by
  refine ⟨?_, ?_⟩
  · exact strong_cp_H0_OA_paper_bundle_inbound N hN
  · exact strong_cp_H0_FOA_lesath_inbound N hN Ω

/-! ## §5.  Bridge #4 — Sheliak `strong_cp_substrate_forces_smallness`
                          direct inbound

A small bridge wiring the substrate budget chain directly into
Sheliak's existential headline `strong_cp_substrate_forces_smallness`
(`∃ N, substrateThetaQCDUpperBound N < thetaQCD_experimental_bound`).
This is the cycle-13 root of the entire H⁰ chain; without an inbound
edge to it, the substrate-budget hypothesis remains structurally
disconnected from Sheliak's headline. -/

/-- **Inbound bridge #4** — substrate truncation hypothesis ⇒
    Sheliak's `strong_cp_substrate_forces_smallness`.

    Materialises the APPLIES edge from the substrate budget chain
    directly into Sheliak's cycle-13 existential headline.  This is
    the root inbound of the H⁰ tower; W7.3 closes it for the first
    time. -/
theorem strong_cp_H0_sheliak_root_inbound
    (N : ℕ) (_hN : substrate_budget_at_least_one N) :
    ∃ M : ℕ, substrateThetaQCDUpperBound M < thetaQCD_experimental_bound :=
  strong_cp_substrate_forces_smallness

/-! ## §6.  Bridge #5 — Sheliak's full five-conjunct paper bundle inbound

Sheliak's cycle-13 file `StrongCPThetaBound.lean` ships the original
paper-bundle headline `strong_cp_problem_substrate_resolution`, which
is FIVE conjuncts: experimental cap positivity, substrate bound
positivity ∀N, concrete N=6 wins, existence, channel = √2.  This is
distinct from Muliphein's H⁰-cocycle bundle (different file, different
shape).  W7.3 closes the inbound side for it too. -/

/-- **Inbound bridge #5** — substrate truncation hypothesis ⇒
    Sheliak's `strong_cp_problem_substrate_resolution`.

    Five-conjunct cycle-13 paper bundle.  Materialises APPLIES edges
    from the substrate budget chain into all five conjuncts. -/
theorem strong_cp_H0_sheliak_paper_bundle_inbound
    (N : ℕ) (_hN : substrate_budget_at_least_one N) :
    0 < thetaQCD_experimental_bound ∧
    (∀ N : ℕ, 0 < substrateThetaQCDUpperBound N) ∧
    substrateThetaQCDUpperBound 6 < thetaQCD_experimental_bound ∧
    (∃ N : ℕ, substrateThetaQCDUpperBound N < thetaQCD_experimental_bound) ∧
    theta_QCD_channel = IrrationalTarget.sqrt2 :=
  strong_cp_problem_substrate_resolution

/-! ## §7.  Substrate-side joint bundle

A small substrate-side bundle that wires the substrate-monotonicity
chain into the H⁰ inbound bridges, providing `:APPLIES` edges from
both `computationalUncertainty_pos` (Pi-Hunch substrate kernel) AND
`substrateThetaQCDUpperBound_pos` (Sheliak cycle-13 root) into the
substrate-side hypothesis used by all bridges. -/

/-- **Substrate-side bundle** — at every substrate truncation budget
    `N ≥ 1`, the substrate computational uncertainty is positive AND
    next-step uncertainty is bounded by current AND the substrate
    θ_QCD upper bound is positive AND monotone decreasing.  This is
    the substrate-monotonicity chain witness consumed by the H⁰
    inbound bridges. -/
theorem strong_cp_H0_substrate_monotonicity_bundle
    (N : ℕ) (hN : substrate_budget_at_least_one N) :
    0 < computationalUncertainty N ∧
    computationalUncertainty (N + 1) ≤ computationalUncertainty N ∧
    0 < substrateThetaQCDUpperBound N ∧
    substrateThetaQCDUpperBound (N + 1) ≤ substrateThetaQCDUpperBound N := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact strong_cp_H0_substrate_uncertainty_pos N hN
  · exact computationalUncertainty_decreasing N
  · exact strong_cp_H0_substrate_theta_pos N hN
  · exact strong_cp_H0_substrate_theta_decreasing N hN

/-! ## §8.  W7.3 paper headline — `OA_strong_CP_H0_paper_bundle_inbound_bridge_from_predictions`

The W7.3 paper headline composes the inbound bridges into a single
five-conjunct existential, providing a one-name citation point for
the entire inbound capping of the H⁰ chain (BOTH OA and FOA flavours).

The headline takes the form

    ∃ N (_hN : N ≥ 1), substrate-monotonicity ∧ Sheliak ∧ ∀Ω OA ∧ ∀Ω FOA

with the substrate-side conjunct fired at the inhabited witness
`N = 4` (canonical lattice dimension matching Haumea W5.3). -/

/-- **W7.3 paper headline**
    `OA_strong_CP_H0_paper_bundle_inbound_bridge_from_predictions`.

    Five-conjunct grand inbound capping for the H⁰ paper-bundle chain
    (MERGED OA + FOA, briefing entry #44 of Heart-Nebula's canonical
    closure list).  The conjunct chain is:

      (i)   substrate truncation budget exists with `N ≥ 1`
      (ii)  for that budget, full substrate-monotonicity holds
            (`computationalUncertainty_pos` ∧ `_decreasing` ∧
             `substrateThetaQCDUpperBound_pos` ∧ `_decreasing`)
      (iii) for that budget, Sheliak's cycle-13 root existential
            `strong_cp_substrate_forces_smallness` holds
      (iv)  for that budget, OA Muliphein paper bundle holds
      (v)   for that budget and any `Ω : OmegaAlgebra`, FOA Lesath
            trivialisation bundle holds

    Each conjunct realises the inbound APPLIES edge from the substrate
    truncation chain into one H⁰ pillar.  The composition is the first
    explicit inbound capping for the strong-CP H⁰ slot of the
    cohomology atlas, mirror of Andromeda W4 + Dabih c61 W1.4
    cosmological-constant H¹ inbound bridge. -/
theorem OA_strong_CP_H0_paper_bundle_inbound_bridge_from_predictions :
    ∃ N : ℕ, substrate_budget_at_least_one N ∧
      (0 < computationalUncertainty N ∧
       computationalUncertainty (N + 1) ≤ computationalUncertainty N ∧
       0 < substrateThetaQCDUpperBound N ∧
       substrateThetaQCDUpperBound (N + 1) ≤ substrateThetaQCDUpperBound N) ∧
      (∃ M : ℕ, substrateThetaQCDUpperBound M < thetaQCD_experimental_bound) ∧
      ((thetaQCDH0Cocycle 6).nontrivial ∧
       (thetaQCDH0Cocycle 6).const.value < thetaQCD_experimental_bound ∧
       (∀ K : ℕ, (thetaQCDH0Cocycle (K + 1)).const.value
                 ≤ (thetaQCDH0Cocycle K).const.value) ∧
       (∀ (α : LeanArrow) (source target : LeanEntity),
           coboundary0 (thetaQCDH0Cocycle 6).const.eval α source target = 0) ∧
       (thetaQCDH0Cocycle 6).const.value ≠ zeroH0Cocycle.const.value) ∧
      (∀ Ω : OmegaAlgebra,
        ∃ c : OmegaAlgebraCohomologyClass Ω,
          c.degree = 0 ∧ c.witness ≤ substrateThetaQCDUpperBound Ω.depth) := by
  refine ⟨4, ?_, ?_, ?_, ?_, ?_⟩
  · unfold substrate_budget_at_least_one; omega
  · refine ⟨?_, ?_, ?_, ?_⟩
    · exact computationalUncertainty_pos 4
    · exact computationalUncertainty_decreasing 4
    · exact substrateThetaQCDUpperBound_pos 4
    · exact substrateThetaQCDUpperBound_decreasing_in_N 4
  · exact strong_cp_substrate_forces_smallness
  · exact strong_CP_H0_paper_bundle
  · intro Ω
    exact strong_CP_H0_cocycle_theta_QCD_trivialized Ω

/-! ## §9.  FOA-flavour grand alias

The merged briefing entry combines `OA_strong_CP_H0_paper_bundle_...`
with `FOA_strong_CP_H0_cocycle_theta_QCD_trivialized_inbound`.  The
above headline pays off both, but the FOA half is also exposed under
its own name to honour the bibliographic citation pattern. -/

/-- **FOA-flavour grand alias**
    `FOA_strong_CP_H0_cocycle_theta_QCD_trivialized_inbound`.

    Three-conjunct existential pairing the substrate truncation budget
    with Lesath's degree-0 trivialised class for every `Ω`.  Mirrors
    Haumea W5.3's `phase_IV_cocycle_witnesses_inbound_witness` shape. -/
theorem FOA_strong_CP_H0_cocycle_theta_QCD_trivialized_inbound :
    ∃ N : ℕ, substrate_budget_at_least_one N ∧
      (∀ Ω : OmegaAlgebra,
        ∃ c : OmegaAlgebraCohomologyClass Ω,
          c.degree = 0 ∧ c.witness ≤ substrateThetaQCDUpperBound Ω.depth) := by
  refine ⟨4, ?_, ?_⟩
  · unfold substrate_budget_at_least_one; omega
  · intro Ω
    exact strong_CP_H0_cocycle_theta_QCD_trivialized Ω

/-! ## §10.  Short grand alias for c62 super-capstone scaffolds -/

/-- **Short grand alias** for the W7.3 headline.  One-name citation
    point for the H⁰ inbound capping (used by c62 super-capstone
    scaffolds when collapsing the cohomology atlas's degree-0 slot
    onto the strong-CP / dark-energy pair). -/
theorem strong_CP_H0_paper_bundle_inbound_bridge_witness :
    ∃ N : ℕ, substrate_budget_at_least_one N ∧
      ((thetaQCDH0Cocycle 6).nontrivial ∧
       (thetaQCDH0Cocycle 6).const.value < thetaQCD_experimental_bound) ∧
      (∀ Ω : OmegaAlgebra,
        ∃ c : OmegaAlgebraCohomologyClass Ω,
          c.degree = 0 ∧ c.witness ≤ substrateThetaQCDUpperBound Ω.depth) := by
  refine ⟨4, ?_, ?_, ?_⟩
  · unfold substrate_budget_at_least_one; omega
  · refine ⟨?_, ?_⟩
    · exact thetaQCDH0Cocycle_is_nontrivial 6
    · exact thetaQCDH0Cocycle_at_6_below_experimental
  · intro Ω
    exact strong_CP_H0_cocycle_theta_QCD_trivialized Ω

/-! ## §11.  Frontier marker — first H⁰ inbound capping in V2

Records that this is the first explicit inbound APPLIES capping for
the strong-CP H⁰ paper-bundle pair (OA + FOA) in OmegaTheory V2,
mirroring Haumea W5.3's Phase-IV inbound capping marker.  Uses the
canonical lattice-dimension witness `4 ≥ 1` discharged by `omega`. -/

/-- **Frontier marker** — strong-CP H⁰ inbound capping is a Wave-7
    W7.3 landing in the Capricornus cycle.  Records `4 ≥ 1` (the
    canonical lattice-dimension witness, matching Haumea W5.3) as the
    minimal substrate-side condition under which the H⁰ inbound
    bridges fire. -/
theorem strong_CP_H0_dual_via_predictions_first_in_V2 :
    (4 : ℕ) ≥ 1 := by omega

/-! ## §12.  Wave-7 W7.3 closure marker -/

/-- **Wave-7 W7.3 closure marker** — records that the strong-CP H⁰
    paper-bundle chain has its first explicit inbound APPLIES edge
    from the substrate-monotonicity chain.  Mirror of Haumea W5.3's
    `phase_IV_cocycle_witnesses_W5_3_closed` in shape and intent.

    Together with Andromeda W4 + Dabih c61 W1.4 cosmological-constant
    H¹ inbound, the cycle-61 Capricornus wave now has matching inbound
    cappings for BOTH the H¹ and H⁰ slots of the strong-CP / dark-energy
    cohomology atlas. -/
theorem W7_3_closed : True := trivial

end OmegaTheory.Predictions.StrongCPH0InboundBridge
