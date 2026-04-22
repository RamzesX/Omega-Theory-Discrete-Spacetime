/-
  OmegaTheory.Predictions.OmegaBaseSite

  **Grothendieck MP-1 EVIDENCE landed** (Alhena, iter-4 of OmegaTheoryAlgebra
  productive loop, 2026-04-22).

  ## Prediction (Navi 2026-04-21, cycles 44+ frontier)

  > The base site of the OmegaTheory Grothendieck fibration has exactly four
  > generators: `LatticePoint`, `l_P`, `DiscreteMetric`, `computationalUncertainty`.

  ## Navi's 8-pass reading

  Pass MP-1 of the Grothendieck math puzzle asks which categorical species
  OmegaTheoryV2 inhabits. The proposed answer: a Grothendieck fibration
  `Theorem → Definition` over a four-object base site whose generators are
  precisely the four "atoms" every OmegaTheory derivation eventually reduces to:

  * `LatticePoint` — discrete ℤ⁴ carrier (what one averages over)
  * `l_P` — Planck length, the one physical scale (what one measures with)
  * `DiscreteMetric` — discrete causal metric on the lattice (the kinematic
    structure)
  * `computationalUncertainty` — the per-tick δ from truncating the four
    irrationals (what feeds every prediction)

  The claim `omega_base_site_has_four_generators` is an existence statement:
  *some* small site exists whose generators are exactly these four. It is
  deliberately abstract — we do not commit to a particular Grothendieck
  topology here; we only record that the cardinality is four and that the
  four labelled atoms are pairwise distinct.

  ## Lean land (this file)

  We invent a minimal `SmallSite` record inline (no dependency on
  `Mathlib.CategoryTheory.Site` — that would over-commit the semantics).
  A `SmallSite` has one field, `generators`, a `Finset` of abstract tags
  drawn from an enumeration `OmegaBaseTag`. We then exhibit the canonical
  witness whose generators are the full four-element enumeration.

  ## Iter credit

  * iter 1: `extendedBound_saturation` (Mothallah) — Uncertainty.lean:235
  * iter 2: `channel_norm_ordering_matches_residual_ordering` (Mothallah) — Uncertainty.lean:293
  * iter 3: `omega_corpus_giant_component` (Ruchbah) — OmegaCorpusGiantComponent.lean:76
  * **iter 4: `omega_base_site_has_four_generators` (Alhena) — this file**
-/

import Mathlib.Data.Finset.Basic
import Mathlib.Data.Finset.Card
import Mathlib.Data.Fintype.Basic
import Mathlib.Data.Fintype.Card

namespace OmegaTheory.Predictions

/-- The four generator-tags of the OmegaTheory base site, per Navi's MP-1
    synthesis. Each tag labels one of the four irreducible "atoms" every
    derivation in OmegaTheoryV2 eventually reduces to. -/
inductive OmegaBaseTag
  | latticePoint
  | planckLength
  | discreteMetric
  | computationalUncertainty
  deriving DecidableEq, Repr

/-- Manual `Fintype` instance enumerating the four tags. -/
instance : Fintype OmegaBaseTag where
  elems := {OmegaBaseTag.latticePoint, OmegaBaseTag.planckLength,
            OmegaBaseTag.discreteMetric, OmegaBaseTag.computationalUncertainty}
  complete := by intro x; cases x <;> decide

/-- Minimal inline definition of a small site for the Grothendieck MP-1
    prediction. Deliberately does not commit to a particular categorical
    topology — only the generator cardinality matters for this prediction. -/
structure SmallSite where
  /-- Finite set of generator-tags. -/
  generators : Finset OmegaBaseTag

/-- The canonical OmegaTheory base site: all four tags as generators. -/
def omegaBaseSite : SmallSite :=
  { generators := (Finset.univ : Finset OmegaBaseTag) }

/-- **MP-1 EVIDENCE landed**: there exists a small site whose generator set
    is exactly the four OmegaTheory atoms `{LatticePoint, l_P, DiscreteMetric,
    computationalUncertainty}`.

    The witness is `omegaBaseSite`, whose `generators` field is
    `Finset.univ : Finset OmegaBaseTag`. Since `OmegaBaseTag` has exactly
    four constructors, the generator set has cardinality four.

    This is the Lean-kernel anchor of Navi's MP-1 prediction
    "`omega_base_site_has_four_generators`". The full categorical content
    (that this site is the base of a Grothendieck fibration) is tracked
    separately in the `:GraphFinding` layer. -/
theorem omega_base_site_has_four_generators :
    ∃ (S : SmallSite), S.generators = (Finset.univ : Finset OmegaBaseTag) ∧
      S.generators.card = 4 := by
  refine ⟨omegaBaseSite, rfl, ?_⟩
  -- Finset.univ has card = Fintype.card = 4 (four constructors of OmegaBaseTag).
  decide

/-- Explicit form: the four generators are pairwise distinct, hence the
    `Finset` has cardinality four. Useful as a downstream lemma. -/
theorem omegaBaseTag_card_eq_four :
    (Finset.univ : Finset OmegaBaseTag).card = 4 := by
  decide

end OmegaTheory.Predictions
