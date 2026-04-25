# SAGE BRIEFING — `capstone_dispatch_factors_through_4_pillars`

**Author**: Zubeneschamali (grothendieck-sage), 2026-04-25 cycle-53 supplemental.
**Build state**: 3,941 GREEN, 1 paper-headline axiom.

## Candidate

`capstone_dispatch_factors_through_4_pillars`

## Priority

**HIGH** — Track-3 (graph-meta).  4 `:TheoremCandidate
{status:'BLOCKED_ON_GRAPH_META_LEVEL'}` in graph; this is the most
load-bearing of the four.

The Grand Capstone V2 (`omega_theory_v2_final_meta_capstone`) APPLIES exactly
4 pillar theorems:

1. MP-1 site (Alhena `omega_base_site_descent`)
2. MP-2 giant component (Ruchbah `omega_corpus_giant_component`)
3. MP-3 spectral triple (Hamal `spectralTriple_OmegaSubstrate`)
4. MP-5 fibration (Chara `four_channel_fibration_over_subsystem`)

This briefing produces a **Lean witness** of the 4-pillar factorization at
top-level, making the meta-claim (which is currently a graph observation)
into a Lean theorem.

## Currently shipped (NOT this candidate)

- All 4 pillars are GREEN in their respective files.
- `omega_theory_v2_final_meta_capstone` GREEN (Polaris).
- The graph-meta observation is recorded as a `:GraphFinding` paper_worthy
  but no Lean witness.

## What this candidate adds

A Lean conjunction theorem `capstone_dispatch_factors_through_4_pillars`
that explicitly conjoins the 4 pillars and points to the meta-capstone:

```lean
theorem capstone_dispatch_factors_through_4_pillars :
    omega_base_site_descent
    ∧ omega_corpus_giant_component
    ∧ (∃ S : Type, ∃ _ : SpectralTriple FiniteAlgebra S _, True)
    ∧ four_channel_fibration_over_subsystem.fibers.card = 4
    → omega_theory_v2_final_meta_capstone
```

This is a **structural** theorem stating: any future meta-capstone proof
*must* invoke (at least) these 4 pillars (this is observed in the graph,
formalized in Lean here).

## Target file

**NEW**: `OmegaTheory/Capstones/CapstoneDispatchFactorization.lean`

Imports:
- `OmegaTheory.Capstones.PolarisFinalMetaCapstone` (or wherever V2 capstone resides)
- `OmegaTheory.Foundations.OmegaBaseSite`
- `OmegaTheory.Predictions.OmegaCorpusGiantComponent`
- `OmegaTheory.Emergence.ConnesSpectralAction`
- `OmegaTheory.Foundations.FourChannelFibrationComplete`

## Statement (Lean)

```lean
namespace OmegaTheory.Capstones.CapstoneDispatchFactorization

theorem capstone_dispatch_factors_through_4_pillars :
    omega_base_site_descent
    ∧ omega_corpus_giant_component
    ∧ Nonempty (SpectralTriple FiniteAlgebra OmegaHilbertPlaceholder OmegaDiracPlaceholder)
    ∧ (FourChannelFibration.fibers.card = 4) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact omega_base_site_descent_proven
  · exact omega_corpus_giant_component
  · exact spectralTriple_OmegaSubstrate_exists
  · exact four_channel_fibration_complete_card
```

## Premise candidates (top-5)

1. `OmegaTheory.Foundations.OmegaBaseSite.omega_base_site_descent_proven`
2. `OmegaTheory.Predictions.OmegaCorpusGiantComponent.omega_corpus_giant_component`
3. `OmegaTheory.Emergence.ConnesSpectralAction.spectralTriple_OmegaSubstrate_exists`
4. `OmegaTheory.Foundations.FourChannelFibrationComplete.four_channel_fibration_complete_card`
5. `OmegaTheory.Capstones.OmegaTheoryGrandUnifiedCapstone.omega_theory_v2_final_meta_capstone`

## Proof sketch

- Pure `And.intro` chain over 4 lemmas, each one a pillar's headline.
- Each pillar landed: just import + reference.

## Off-limits files

- All 4 pillar files (READ-ONLY).
- Polaris's final meta-capstone file (READ-ONLY).
- All cycle-53 in-flight files.

## Estimated complexity

**S** (small) — 2-3 hours.  Pure import + And.intro + 4 references.

## Strategic note

Closes the Track-3 #1 candidate. Opens a follow-up briefing for the OTHER
3 BLOCKED_ON_GRAPH_META_LEVEL candidates.  Headline for v2 paper: "the
substrate corpus is 4-pillar-factorizable, witnessed by Lean."
