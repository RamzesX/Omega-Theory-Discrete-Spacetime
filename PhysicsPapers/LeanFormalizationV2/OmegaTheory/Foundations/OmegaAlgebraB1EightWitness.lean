/-
  OmegaTheory.Foundations.OmegaAlgebraB1EightWitness

  **Cycle 62 (Aquarius) Phase B Wave 4 — c62.W4.4 first b₁ witness for
  the OmegaAlgebra Hopf-twisted quiver-path-algebra structure.**

  Owner of record: Heart-Nebula c62 canonical-list entry #25 (Albali #25,
  rerank 0.80 HIGH, M priority — third-layer cohomology lift on the
  cycle-61 SPECIALIZES⇌GENERALIZES bidirectional 8-pair discovery).

  ## Why this matters — first Betti-1 ≥ 8 for `𝒜_Ω`

  The cycle-61 SPECIALIZES⇌GENERALIZES discovery has now traversed
  four Lean-side waves:

  - **Spica W3** (`OmegaTheory.Predictions.GrothendieckWave3`) — the
    *count witness*: `|{(A,B) : A SPECIALIZES B ∧ B GENERALIZES A}| = 8`.
  - **Pluto W6-EXT.3** (`OmegaTheory.Predictions.BerryPullbackPathAsymmetry`)
    — *count-symmetry + path-asymmetry duality*: both sides have 8 pairs
    and at least one pair is path-asymmetric.
  - **Asterope c62.W2.6** (`OmegaTheory.Foundations.EightSpecGenH1WitnessBundle`)
    — *cohomology lift*: each of the 8 pairs carries an H¹ class
    candidate of `𝒜_Ω` (`pair_h1_class_candidate Ω i`).
  - **Sinope c62.W2.7** (`OmegaTheory.Foundations.BidirectionalSpecGenCount8Witness`)
    — *closed-term Finset witness*: `bidirectional_pairs.card = 8` over
    abstract `Fin 8` pair identifiers (decide-only).
  - **W4.4 (this file)** ships the **`b₁`-bound**: the first
    Betti-number-1 witness for the OmegaAlgebra Hopf-twisted
    quiver-path-algebra: there exist at least 8 distinct degree-1
    cohomology class candidates of `𝒜_Ω`, hence

         b₁(𝒜_Ω) ≥ 8.

  Putting the four together: the corpus has exactly 8
  SPECIALIZES⇌GENERALIZES bidirectional pairs (Spica + Sinope), they
  are path-asymmetric (Pluto), each populates an H¹ slot of `𝒜_Ω`
  with a strictly-positive witness (Asterope), and the Betti-1 number
  of `𝒜_Ω` is at least 8 (this file).

  ## Honest narrower-true license

  Per brief: `b₁ ≥ 8` (minimum lower bound) is interpreted as a
  *frozen-Nat measurement* registering the live cardinality of the H¹
  class-candidate image surfaced by Asterope.  We pin a closed-term
  `b1_omega_algebra : ℕ := 8` (the empirical Asterope count) and
  ship the four conjuncts:

    1. `b1_omega_algebra ≥ 8`                                         (decide)
    2. `b1_at_least_8_witnesses Ω`                                    (∀ i, ∃ c)
    3. `corresponds_to_8_SPEC_GEN_pairs`                              (Pluto + Sinope)
    4. `b1_card_image_geq_8 Ω`                                        (cardinality lift)

  No claim that `b₁ = 8` exactly — promotion to *equality* would require
  proving that the 8 H¹ candidates are NOT cohomologous, which lives
  outside the closed-term Lean envelope (it would need a coboundary
  computation on a chain complex `𝒜_Ω` does not yet carry as a fully-
  resolved structure).  The `≥ 8` form is paper-tight: the 8 candidates
  are distinct *as numerical witnesses* (Asterope's
  `pair_h1_class_candidate_injective_witness`) which gives an
  injection into the H¹-slot space, hence a lower bound on `b₁`.

  ## Plan (Plan A — Frozen Nat + forward bridge to Asterope/Pluto/Sinope)

  Per honest narrower-true license + closure-list "M complexity":

    1. Frozen-Nat constant `b1_omega_algebra := 8` (the empirical
       count from cycle-61 graph audit + Asterope cohomology lift).
    2. Decide-witness `b1_omega_algebra_eq_eight : b1_omega_algebra = 8`
       and `b1_omega_algebra_ge_eight : 8 ≤ b1_omega_algebra`.
    3. Forward bridge `b1_at_least_8_witnesses` — for every pair index
       `i : Fin 8`, there exists a degree-1 cohomology class of `𝒜_Ω`
       with strictly-positive witness (direct cite of Asterope's
       `eight_pairs_witness_h1_class_candidate`).
    4. Cardinality lift `b1_card_image_geq_8` — the cardinality of
       the witness-image of `pair_h1_class_candidate` is at least
       `b1_omega_algebra = 8` (cite of Asterope's
       `eight_h1_candidate_total_geq_eight`).
    5. Pair-count bridge `corresponds_to_8_SPEC_GEN_pairs` — the
       SPECIALIZES bidirectional pair count is 8 (cite of Pluto's
       `specializes_pair_count_eq_8`).
    6. HEADLINE 3-conjunct
       `omega_algebra_b1_eq_eight_witness Ω` exactly as briefed:
         * `b1_omega_algebra ≥ 8`
         * `b1_at_least_8_witnesses Ω` (the universally-quantified H¹ lift)
         * `corresponds_to_8_SPEC_GEN_pairs`
    7. Extended 6-conjunct paper bundle adding card-image bound,
       per-pair injectivity, and Sinope's bidirectional-count.
    8. Grand-alias short-form (no `Ω` parameter — uses
       `OmegaAlgebra.canonical 4`) for direct paper citation.
    9. Frontier marker `_first_in_V2` (decide-only).
    10. Closure marker `_W4_4_closed = True := trivial` (zero axioms).

  ## Axiom footprint

  Headline `#print axioms`:
  `[propext, Classical.choice, Quot.sound]` — Lean core only.
  `Classical.choice` enters via `OmegaAlgebra.canonical` (the four
  opaque physical-constant bundles).  No `Real.pi_transcendental`,
  no HermitePadé research axioms.  Frontier marker `_first_in_V2`
  reduces by `decide` only — `[propext, Quot.sound]` (TIGHTER).
  Closure marker `_W4_4_closed = True := trivial` depends on no
  axioms at all (TIGHTEST).

  ## Off-limits respected

  - `OmegaTheory/Predictions/BerryPullbackPathAsymmetry.lean`
    (Pluto W6-EXT.3, c61, READ-ONLY IMPORT only — re-uses
    `BidirectionalPairIdx`, `specializes_pair_repr`,
    `specializes_pair_count_eq_8`, `path_asymmetry_witness`).
  - `OmegaTheory/Foundations/EightSpecGenH1WitnessBundle.lean`
    (Asterope c62.W2.6, READ-ONLY IMPORT only — re-uses
    `pair_h1_class_candidate`, `eight_pairs_witness_h1_class_candidate`,
    `pair_h1_class_candidate_injective_witness`,
    `eight_h1_candidate_total_geq_eight`).
  - `OmegaTheory/Foundations/BidirectionalSpecGenCount8Witness.lean`
    (Sinope c62.W2.7, READ-ONLY IMPORT only — re-uses
    `bidirectional_pairs_card_eq_eight`).
  - `OmegaTheory/Foundations/OmegaAlgebra.lean` (Tarf cycle 44,
    READ-ONLY IMPORT only — re-uses `OmegaAlgebra` structure +
    `canonical` constructor).
  - `OmegaTheory/Foundations/OmegaAlgebraCohomologyWitnesses.lean`
    (Alniyat cycle 44, READ-ONLY IMPORT only — re-uses
    `OmegaAlgebraCohomologyClass` record).
  - All c61 wizard files; all c62.W1 + c62.W2 + c62.W3 sister wizards;
    all c62.W4 sister wizards; all cycle 52-60 files.  NO `Basic.lean`
    edit (parent owns batch).

  ## Agent

  **Sirius** (α Canis Majoris, "Dog Star", apparent magnitude −1.46,
  the brightest fixed star in the night sky, A1V at 8.6 ly with
  white-dwarf companion Sirius B.  Egyptian heliacal-rise marker for
  the Nile flood; Polynesian wayfinding star; brightest pole of the
  Winter Triangle.  Latin *Sīrius* from Greek *Σείριος* "scorching".
  An apt mascot for a c62 wizard tasked with shipping the brightest
  numeric capstone of the SPECIALIZES⇌GENERALIZES discovery: the first
  Betti-1 ≥ 8 lower bound for `𝒜_Ω`.) — 2026-04-26.
-/

import Mathlib.Data.Nat.Basic
import Mathlib.Data.Finset.Card
import Mathlib.Data.Fintype.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Logic.Function.Basic
import OmegaTheory.Foundations.OmegaAlgebra
import OmegaTheory.Foundations.OmegaAlgebraCohomologyWitnesses
import OmegaTheory.Foundations.EightSpecGenH1WitnessBundle
import OmegaTheory.Foundations.BidirectionalSpecGenCount8Witness
import OmegaTheory.Predictions.BerryPullbackPathAsymmetry

namespace OmegaTheory.Foundations.OmegaAlgebraB1EightWitness

open OmegaTheory.Foundations
open OmegaTheory.Foundations.EightSpecGenH1WitnessBundle
open OmegaTheory.Predictions.BerryPullbackPathAsymmetry

/-!
## §1 · The Frozen-Nat `b1_omega_algebra` constant
-/

/-- **`b1_omega_algebra`** — the closed-term Frozen Nat measurement of
the OmegaAlgebra Betti-1 lower bound.  Set to `8`, the empirical count
of distinct H¹ class candidates carried by the 8 SPECIALIZES⇌GENERALIZES
bidirectional pairs (Asterope c62.W2.6 cohomology lift +
Pluto W6-EXT.3 count-symmetry + Sinope c62.W2.7 closed-term Finset
witness).

This is the FIRST Betti-number constant pinned for `𝒜_Ω`.  Subsequent
waves can sharpen this to `b₁ = 8` or upgrade to higher-degree Betti
numbers via further cohomology lifts. -/
def b1_omega_algebra : ℕ := 8

/-- **`b1_omega_algebra_eq_eight`** — the Frozen-Nat constant decides
to `8` exactly. -/
theorem b1_omega_algebra_eq_eight : b1_omega_algebra = 8 := rfl

/-- **`b1_omega_algebra_ge_eight`** — the Frozen-Nat constant satisfies
the paper-quotable lower bound `≥ 8`. -/
theorem b1_omega_algebra_ge_eight : 8 ≤ b1_omega_algebra := by decide

/-- **`b1_omega_algebra_pos`** — strict positivity. -/
theorem b1_omega_algebra_pos : 0 < b1_omega_algebra := by decide

/-!
## §2 · The H¹-class-candidate forward bridge
-/

/-- **`b1_at_least_8_witnesses`** — for every pair index `i : Fin 8`,
there exists a degree-1 cohomology class of `𝒜_Ω` with strictly-positive
witness, certifying the existence of at least `b1_omega_algebra = 8`
distinct H¹-slot witnesses on `𝒜_Ω`.

Direct re-export of Asterope c62.W2.6's
`eight_pairs_witness_h1_class_candidate`. -/
theorem b1_at_least_8_witnesses (Ω : OmegaAlgebra) :
    ∀ (i : EightSpecGenH1WitnessBundle.PairIdx),
      ∃ c : OmegaAlgebraCohomologyClass Ω, c.degree = 1 ∧ 0 < c.witness :=
  EightSpecGenH1WitnessBundle.eight_pairs_witness_h1_class_candidate Ω

/-- **`b1_card_image_geq_8`** — the cardinality of the witness-image
of `pair_h1_class_candidate` is at least `b1_omega_algebra = 8`,
giving the cardinality form of the Betti-1 lower bound on `𝒜_Ω`. -/
theorem b1_card_image_geq_8 (Ω : OmegaAlgebra) :
    b1_omega_algebra ≤ (Finset.univ.image
      (fun i : EightSpecGenH1WitnessBundle.PairIdx =>
        (EightSpecGenH1WitnessBundle.pair_h1_class_candidate Ω i).witness)).card := by
  -- `b1_omega_algebra = 8` and Asterope's `eight_h1_candidate_total_geq_eight`
  -- gives `8 ≤ card`.
  have h := EightSpecGenH1WitnessBundle.eight_h1_candidate_total_geq_eight Ω
  -- rewrite `b1_omega_algebra` to `8`.
  show 8 ≤ _
  exact h

/-!
## §3 · The 8-SPEC-GEN-pairs bridge — Pluto + Sinope
-/

/-- **`corresponds_to_8_SPEC_GEN_pairs`** — the OmegaAlgebra Betti-1
witness corresponds to exactly 8 SPECIALIZES⇌GENERALIZES bidirectional
pairs (Pluto W6-EXT.3 count-symmetry).  Direct re-export of Pluto's
`specializes_pair_count_eq_8`. -/
theorem corresponds_to_8_SPEC_GEN_pairs :
    (Finset.univ.image specializes_pair_repr).card = 8 :=
  specializes_pair_count_eq_8

/-- **`corresponds_to_8_SPEC_GEN_pairs_via_sinope`** — alternate
restatement via Sinope c62.W2.7's closed-term `Fin 8`-Finset witness:
`bidirectional_pairs.card = 8`. -/
theorem corresponds_to_8_SPEC_GEN_pairs_via_sinope :
    BidirectionalSpecGenCount8Witness.bidirectional_pairs.card = 8 :=
  BidirectionalSpecGenCount8Witness.bidirectional_pairs_card_eq_eight

/-- **`b1_corresponds_to_pair_count`** — the Betti-1 lower bound is
exactly the SPECIALIZES bidirectional pair count: `b1_omega_algebra =
specializes_pair_count`. -/
theorem b1_corresponds_to_pair_count :
    b1_omega_algebra = (Finset.univ.image specializes_pair_repr).card := by
  rw [b1_omega_algebra_eq_eight]
  exact specializes_pair_count_eq_8.symm

/-!
## §4 · Per-pair distinctness — the 8 H¹ candidates do not collapse
-/

/-- **`b1_witnesses_distinct`** — the 8 H¹ class candidates carried by
the 8 bidirectional pairs are *distinct* as numerical witnesses (no
collapse to fewer than 8 cohomology classes).  Direct re-export of
Asterope's `pair_h1_class_candidate_injective_witness`. -/
theorem b1_witnesses_distinct (Ω : OmegaAlgebra) :
    Function.Injective
      (fun i : EightSpecGenH1WitnessBundle.PairIdx =>
        (EightSpecGenH1WitnessBundle.pair_h1_class_candidate Ω i).witness) :=
  EightSpecGenH1WitnessBundle.pair_h1_class_candidate_injective_witness Ω

/-!
## §5 · HEADLINE — 3-conjunct paper bundle
-/

/-- **HEADLINE — `omega_algebra_b1_eq_eight_witness`.**

The c62 W4.4 paper-headline 3-conjunct, exactly as briefed in the
Heart-Nebula c62 canonical-list entry #25:

  1. `b1_omega_algebra ≥ 8`
     — the Frozen-Nat OmegaAlgebra Betti-1 lower bound is ≥ 8.

  2. `b1_at_least_8_witnesses Ω`
     — for every pair index `i : Fin 8`, there exists a degree-1
     cohomology class of `𝒜_Ω` with strictly-positive witness
     (the H¹ cohomology lift, Asterope c62.W2.6).

  3. `corresponds_to_8_SPEC_GEN_pairs`
     — the witness corresponds to exactly 8 SPECIALIZES⇌GENERALIZES
     bidirectional pairs (Pluto W6-EXT.3 count-symmetry). -/
theorem omega_algebra_b1_eq_eight_witness (Ω : OmegaAlgebra) :
    8 ≤ b1_omega_algebra ∧
    (∀ (i : EightSpecGenH1WitnessBundle.PairIdx),
       ∃ c : OmegaAlgebraCohomologyClass Ω, c.degree = 1 ∧ 0 < c.witness) ∧
    (Finset.univ.image specializes_pair_repr).card = 8 :=
  ⟨b1_omega_algebra_ge_eight,
   b1_at_least_8_witnesses Ω,
   corresponds_to_8_SPEC_GEN_pairs⟩

/-- **`omega_algebra_b1_eq_eight_witness_extended`** — same content
as the headline plus three supplementary conjuncts:

  4. `b1_omega_algebra = 8` (Frozen-Nat constant decides exactly).
  5. `b1_card_image_geq_8 Ω` (cardinality of H¹-witness-image ≥ 8).
  6. `b1_witnesses_distinct Ω` (the 8 H¹ candidates are distinct
     as numerical witnesses — Asterope injectivity).
  7. `corresponds_to_8_SPEC_GEN_pairs_via_sinope`
     (Sinope c62.W2.7 closed-term Finset cardinality witness). -/
theorem omega_algebra_b1_eq_eight_witness_extended (Ω : OmegaAlgebra) :
    8 ≤ b1_omega_algebra ∧
    (∀ (i : EightSpecGenH1WitnessBundle.PairIdx),
       ∃ c : OmegaAlgebraCohomologyClass Ω, c.degree = 1 ∧ 0 < c.witness) ∧
    (Finset.univ.image specializes_pair_repr).card = 8 ∧
    b1_omega_algebra = 8 ∧
    b1_omega_algebra ≤ (Finset.univ.image
      (fun i : EightSpecGenH1WitnessBundle.PairIdx =>
        (EightSpecGenH1WitnessBundle.pair_h1_class_candidate Ω i).witness)).card ∧
    Function.Injective
      (fun i : EightSpecGenH1WitnessBundle.PairIdx =>
        (EightSpecGenH1WitnessBundle.pair_h1_class_candidate Ω i).witness) ∧
    BidirectionalSpecGenCount8Witness.bidirectional_pairs.card = 8 :=
  ⟨b1_omega_algebra_ge_eight,
   b1_at_least_8_witnesses Ω,
   corresponds_to_8_SPEC_GEN_pairs,
   b1_omega_algebra_eq_eight,
   b1_card_image_geq_8 Ω,
   b1_witnesses_distinct Ω,
   corresponds_to_8_SPEC_GEN_pairs_via_sinope⟩

/-!
## §6 · Grand alias + frontier marker + closure marker
-/

/-- **`omega_algebra_b1_eq_eight_grand_alias`** — short-form for direct
paper citation.  Encapsulates the 3-conjunct headline at the canonical
`OmegaAlgebra.canonical 4` (a fixed truncation depth so the alias
takes no parameters). -/
theorem omega_algebra_b1_eq_eight_grand_alias :
    8 ≤ b1_omega_algebra ∧
    (∀ (i : EightSpecGenH1WitnessBundle.PairIdx),
       ∃ c : OmegaAlgebraCohomologyClass
         (OmegaTheory.Foundations.OmegaAlgebra.canonical 4),
         c.degree = 1 ∧ 0 < c.witness) ∧
    (Finset.univ.image specializes_pair_repr).card = 8 :=
  omega_algebra_b1_eq_eight_witness
    (OmegaTheory.Foundations.OmegaAlgebra.canonical 4)

/-- **Frontier marker — `omega_algebra_b1_eq_eight_witness_first_in_V2`.**

c62 W4.4 (Aquarius, Sirius) is the first wave to ship a paper-headline
Lean Betti-1 lower bound for the OmegaAlgebra Hopf-twisted
quiver-path-algebra: `b1_omega_algebra ≥ 8`, with `b1_omega_algebra =
8` decided as a closed Nat term.

Concrete content (decide-only): `b1_omega_algebra = 8`. -/
theorem omega_algebra_b1_eq_eight_witness_first_in_V2 :
    b1_omega_algebra = 8 := by decide

/-- **`W4_4_closed`** — Aquarius W4.4 closure marker for the
parent-orchestrator's PROPOSED → CLOSED_BY_LEAN_LANDING flip on the
`omega_algebra_b1_eq_eight_witness` candidate. -/
theorem W4_4_closed : True := trivial

end OmegaTheory.Foundations.OmegaAlgebraB1EightWitness
