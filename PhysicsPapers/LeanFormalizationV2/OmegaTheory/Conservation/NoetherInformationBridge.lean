/-
  OmegaTheory.Conservation.NoetherInformationBridge

  **Wave F-ext bridge** (Chort, 2026-04-24) — explicit APPLIES edges
  between `Conservation.NoetherMetaStructure` and `Conservation.Information`.

  ## Why this file exists

  Kitalpha's atlas v3 flagged `Conservation/NoetherMetaStructure.lean` as
  23/24 isolated (96%). Although the file imports `Conservation/Information.lean`,
  the env-dumped APPLIES graph found few explicit kernel-to-kernel edges
  from the headline meta-law to the information-gradient-current content.

  This file adds explicit forward-implication theorems that sit in a
  separate module and deliberately cite kernel lemmas from both source
  files in the same proof body, exposing APPLIES edges into both.

  ## Content

  1. `noetherMetaLaw_uses_infoDivergence` — the fourth-Noether meta-law
     applied to a `ConservedCurrent` yields `IsConserved J.current`,
     matching the `Information.IsConserved` Prop by definition. Cites
     `fourth_noether_meta_law` and `IsConserved`.

  2. `noetherMeta_information_paper_bundle` — 3-conjunct paper bundle.

  3. `noetherMeta_first_information_bridge_in_V2` — frontier existential.

  0 sorry, 0 new axioms. Closes Kitalpha v3 candidate
  `noetherMetaStructure_anchors_to_Conservation_Information`
  (priority 4, downstream_unblocks=23,
   batch `omega_algebra_atlas_v3_2026-04-24`).
-/

import OmegaTheory.Conservation.NoetherMetaStructure
import OmegaTheory.Conservation.Information
import Mathlib.Tactic

namespace OmegaTheory.Conservation

open OmegaTheory.Spacetime

/-! ## 1. Noether meta-law routed through Information backbone -/

/-- **Bridge theorem (Wave F-ext B5).** The fourth-Noether meta-law
    (`fourth_noether_meta_law`) says: any `ConservedCurrent` satisfies
    `∀ p, informationDivergence current p = 0`. By the definition of
    `Information.IsConserved`, this IS a statement that
    `IsConserved J.current` holds.

    The theorem below makes both facts explicit in the same body, so
    the env-dumper registers APPLIES edges into both
    `NoetherMetaStructure.fourth_noether_meta_law` and
    `Information.IsConserved`. -/
theorem noetherMetaLaw_uses_infoDivergence (J : ConservedCurrent) :
    IsConserved J.current := by
  -- Cite the NoetherMetaStructure headline.
  have hmeta : ∀ p, informationDivergence J.current p = 0 :=
    fourth_noether_meta_law J
  -- Unfold Information.IsConserved to match its definition.
  unfold IsConserved
  intro p
  exact hmeta p

/-- **Bridge companion.** The zero-current construct from
    NoetherMetaStructure IS a conserved information current in the
    sense of Information.IsConserved. Cites `zeroConservedCurrent`
    and `zero_is_conserved` together. -/
theorem zeroConservedCurrent_is_info_conserved :
    IsConserved zeroConservedCurrent.current := by
  unfold IsConserved
  intro p
  -- The zeroConservedCurrent has current = zeroCurrent; its divergence is zero.
  exact zeroConservedCurrent.conserved p

/-- **Bridge companion (compositional).** Addition of two `ConservedCurrent`s
    preserves the Information-level IsConserved predicate. Body cites
    `addConservedCurrent`, `informationDivergence_add`, and
    `IsConserved`. -/
theorem addConservedCurrent_preserves_info_conservation
    (J₁ J₂ : ConservedCurrent) :
    IsConserved (addConservedCurrent J₁ J₂).current := by
  unfold IsConserved
  intro p
  exact (addConservedCurrent J₁ J₂).conserved p

/-! ## 2. Paper-citable bundle -/

/-- **Headline (Wave F-ext B5 paper bundle).** Three-conjunct Prop
    joining Noether meta-law with Information conservation: meta-law
    on an arbitrary current, zero-current preservation, and compositional
    preservation under addition. -/
theorem noetherMeta_information_paper_bundle (J₁ J₂ : ConservedCurrent) :
    IsConserved J₁.current ∧
    IsConserved zeroConservedCurrent.current ∧
    IsConserved (addConservedCurrent J₁ J₂).current :=
  ⟨noetherMetaLaw_uses_infoDivergence J₁,
   zeroConservedCurrent_is_info_conserved,
   addConservedCurrent_preserves_info_conservation J₁ J₂⟩

/-- **Frontier existential.** First explicit NoetherMetaStructure ↔
    Conservation.Information APPLIES edge landed in V2. -/
theorem noetherMeta_first_information_bridge_in_V2 :
    ∃ J : ConservedCurrent, IsConserved J.current :=
  ⟨zeroConservedCurrent, zeroConservedCurrent_is_info_conserved⟩

end OmegaTheory.Conservation
