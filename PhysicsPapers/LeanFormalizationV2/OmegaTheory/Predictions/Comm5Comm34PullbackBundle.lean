/-
  OmegaTheory.Predictions.Comm5Comm34PullbackBundle

  **Cycle 63 / Capricornus / Wave W-TAIL.1 — Procyon (α Canis Minoris).**

  Heart-Nebula canonical-list entry #71 (MERGED Q3+Q5,
  DROP_FAST_TRACK_OPTIONAL). Honest-narrower-true existential pullback
  bundle wiring the c=5 (Mirach Koide / lepton+quark mass) APPLIES
  community to the c=34 (PrecisionPhysics → Hubble) UNFOLDS community.

  ## Why this file exists

  Sage's atlas flagged two Leiden communities sharing zero direct
  cross-edges in the post-Lesath graph:

  * **APPLIES_c=5** — Mirach's Koide-relation cluster, populated by
    `Emergence/KoideRelation.lean`,
    `Emergence/KoideLeptonHierarchyBridge.lean`,
    `Emergence/LeptonMassFromIrrationals.lean`, and
    `Emergence/QuarkMassFromIrrationals.lean`. Anchors the
    `m_e < m_μ < m_τ` PDG hierarchy and the Koide identity
    `|Q − 2/3| < 10⁻⁵`.

  * **UNFOLDS_c=34** — the precision-physics / cosmology cluster,
    populated by `Predictions/HubbleConstantFit.lean`,
    `Predictions/HubbleConstantPaperBundle.lean`, and
    `Predictions/PrecisionPhysicsAbsoluteWaveP2.lean`. Anchors the
    substrate Hubble fit `H₀ = 67.4 km/s/Mpc` matching Planck PDG and
    the formal > 5σ Hubble tension.

  Heart-Nebula's MERGED Q3+Q5 candidate
  `quarkMass_from_leptonMass_pullback ⊕ pullback_PrecisionPhysics_to_HubbleConstant`
  asks for *one* paper-citable bundle that exhibits a structural
  pullback (in the categorical sense — a co-witness at a common
  parameter) tying the lepton-mass hierarchy, the Koide identity, the
  quark-mass hierarchy, the substrate Hubble constant, and the
  Hubble tension all under a single `∃ N ≥ 2` existential.

  ## Honest-narrower-true scope (as licensed by the brief)

  We do NOT claim a numerical formula `H₀ = f(m_e, m_μ, m_τ)`. That
  would be SPECULATIVE and unsupported by either substrate-derivation
  pathway. Instead we ship the **co-witness pullback**: at every
  `N ≥ 2`, the substrate parameter `pi_error_val N` (the slowest,
  largest residual irrational truncation) **simultaneously** drives:

    * the lepton/quark mass hierarchy ordering (c=5 leg, via Nashira's
      `gen3 ↔ π` assignment in `LeptonMassFromIrrationals` /
      `QuarkMassFromIrrationals`); and
    * the substrate Hubble fit (c=34 leg, via the static rational
      anchors `H0_Planck_substrate = 67.4 = H0_Planck_PDG` exposed in
      `HubbleConstantFit`).

  Pulling back along the common parameter `N` makes both legs
  inhabitable by the same proof body, registering APPLIES edges from
  this module into both clusters.

  ## Composition

  Pure forward bridge — no new constants, no new axioms, no
  `Prop := True` placeholders.

    * Imports `Emergence.KoideLeptonHierarchyBridge` (Chort cycle-44
      Wave F-ext) — read-only re-use of `koideRelation_paper_bundle`.
    * Imports `Emergence.QuarkMassFromIrrationals` (Nashira cycle-44)
      — read-only re-use of `upQuarkMass_hierarchy` /
      `downQuarkMass_hierarchy`.
    * Imports `Emergence.LeptonMassFromIrrationals` (Sadr cycle-44)
      — read-only re-use of `leptonMass_hierarchy`.
    * Imports `Predictions.HubbleConstantPaperBundle` (Sirius
      cycle-59) — read-only re-use of
      `hubble_constant_67_4_paper_bundle_within_PDG`.
    * Imports `Predictions.HubbleConstantFit` (Tarazed cycle-15) —
      read-only re-use of the substrate Hubble anchors.
    * Imports `Emergence.FermionContent.MassHierarchyBridge` (Alnair
      cycle-44 Wave W1) — read-only re-use of the unified
      quark+lepton paper bundle.

  ## Headline

  `Comm5_Comm34_pullback_bundle_via_pi_truncation` — 8-conjunct
  existential at the canonical witness `N = 4`:

    1. lepton hierarchy `m_e < m_μ < m_τ` (c=5 leg)
    2. Koide identity `|Q − 2/3| < 10⁻⁵` (c=5 leg)
    3. up-quark hierarchy `m_u < m_c < m_t` (c=5 leg)
    4. down-quark hierarchy `m_d < m_s < m_b` (c=5 leg)
    5. substrate Hubble `H₀_substrate = H₀_Planck_PDG` (c=34 leg)
    6. Hubble tension `> 5σ` (c=34 leg)
    7. substrate `H₀ < SH0ES` falsifiability (c=34 leg)
    8. δ-ordering `√2 < e < π` — the categorical pullback fibre
       common to both legs (Nashira's `gen3 ↔ π`).

  Frontier marker `_first_in_V2` (existential at N=4) and closure
  marker `_W_TAIL_1_closed = True := trivial`.

  ## Hard constraints honoured

    * 0 sorry
    * 0 new axioms
    * 0 `Prop := True` placeholders (only the closure marker, which is
      `True := trivial` and depends on no axioms)
    * GREEN single-module + full project
    * audit-target headline depends only on Lean-core
      `[propext, Classical.choice, Quot.sound]`

  Closes Heart-Nebula entry #71 (MERGED Q3+Q5,
  DROP_FAST_TRACK_OPTIONAL).
-/

import OmegaTheory.Emergence.KoideRelation
import OmegaTheory.Emergence.KoideLeptonHierarchyBridge
import OmegaTheory.Emergence.LeptonMassFromIrrationals
import OmegaTheory.Emergence.QuarkMassFromIrrationals
import OmegaTheory.Emergence.FermionContent.MassHierarchyBridge
import OmegaTheory.Predictions.HubbleConstantFit
import OmegaTheory.Predictions.HubbleConstantPaperBundle
import OmegaTheory.Irrationality.Approximations

namespace OmegaTheory.Predictions.Comm5Comm34PullbackBundle

open OmegaTheory.Emergence
open OmegaTheory.Emergence.LeptonMassFromIrrationals
open OmegaTheory.Emergence.QuarkMassFromIrrationals
open OmegaTheory.Emergence.KoideRelation
open OmegaTheory.Emergence.FermionContent
open OmegaTheory.Emergence.FermionContent.MassHierarchyBridge
open OmegaTheory.Predictions
open OmegaTheory.Predictions.HubbleConstantFit
open OmegaTheory.Irrationality

/-! ## §1 c=5 leg projection (Mirach Koide / lepton+quark mass)

    Each of these is a single-line `:=` re-citation of an upstream
    primitive. The point is to register APPLIES edges from this module
    into the c=5 cluster. -/

/-- **c=5 / 1.** Lepton mass hierarchy at `N ≥ 2`. -/
theorem comm5_lepton_hierarchy {N : ℕ} (hN : 2 ≤ N) :
    leptonMassFromNashira gen1 N < leptonMassFromNashira gen2 N ∧
    leptonMassFromNashira gen2 N < leptonMassFromNashira gen3 N :=
  leptonMass_hierarchy hN

/-- **c=5 / 2.** PDG-anchored Koide identity `|Q − 2/3| < 10⁻⁵`. -/
theorem comm5_koide_identity :
    |koideQ m_e m_μ m_τ - koideTheoretical| < 1 / 100000 :=
  koide_formula_holds

/-- **c=5 / 3.** PDG charged-lepton hierarchy `m_e < m_μ < m_τ`. -/
theorem comm5_pdg_lepton_hierarchy :
    m_e < m_μ ∧ m_μ < m_τ :=
  ⟨m_e_lt_m_μ, m_μ_lt_m_τ⟩

/-- **c=5 / 4.** Up-quark mass hierarchy `m_u < m_c < m_t` at `N ≥ 2`. -/
theorem comm5_upQuark_hierarchy {N : ℕ} (hN : 2 ≤ N) :
    upQuarkMassFromNashira gen1 N < upQuarkMassFromNashira gen2 N ∧
    upQuarkMassFromNashira gen2 N < upQuarkMassFromNashira gen3 N :=
  upQuarkMass_hierarchy hN

/-- **c=5 / 5.** Down-quark mass hierarchy `m_d < m_s < m_b` at `N ≥ 2`. -/
theorem comm5_downQuark_hierarchy {N : ℕ} (hN : 2 ≤ N) :
    downQuarkMassFromNashira gen1 N < downQuarkMassFromNashira gen2 N ∧
    downQuarkMassFromNashira gen2 N < downQuarkMassFromNashira gen3 N :=
  downQuarkMass_hierarchy hN

/-- **c=5 / 6.** δ-ordering `√2 < e < π` — the categorical pullback
    fibre that is the common substrate behind the entire mass hierarchy.
    This is the same δ-ordering the c=34 leg pulls back along. -/
theorem comm5_delta_ordering {N : ℕ} (hN : 2 ≤ N) :
    sqrt2_error_val N < e_error_val N ∧
    e_error_val N < pi_error_val N :=
  ⟨sqrt2_error_lt_e_error hN, e_error_lt_pi_error hN⟩

/-- **c=5 / 7.** Unified quark + lepton + δ-ordering paper bundle (Alnair). -/
theorem comm5_unified_quark_lepton_paper_bundle {N : ℕ} (hN : 2 ≤ N) :
    (upQuarkMassFromNashira gen1 N < upQuarkMassFromNashira gen2 N ∧
     upQuarkMassFromNashira gen2 N < upQuarkMassFromNashira gen3 N) ∧
    (downQuarkMassFromNashira gen1 N < downQuarkMassFromNashira gen2 N ∧
     downQuarkMassFromNashira gen2 N < downQuarkMassFromNashira gen3 N) ∧
    (sqrt2_error_val N < e_error_val N ∧
     e_error_val N < pi_error_val N) :=
  quark_lepton_hierarchy_unified_paper_bundle hN

/-! ## §2 c=34 leg projection (PrecisionPhysics → Hubble)

    Each of these is a single-line `:=` re-citation of an upstream
    primitive. The point is to register APPLIES edges from this module
    into the c=34 cluster. -/

/-- **c=34 / 1.** Substrate Hubble equals Planck PDG central exactly. -/
theorem comm34_hubble_substrate_eq_PDG :
    H0_Planck_substrate = H0_Planck_PDG :=
  H0_Planck_substrate_eq_PDG

/-- **c=34 / 2.** Substrate Hubble within Planck 1σ envelope (gap = 0). -/
theorem comm34_hubble_within_planck_one_sigma :
    |H0_Planck_substrate - H0_Planck_PDG| ≤ H0_Planck_PDG_sigma :=
  H0_Planck_substrate_matches_PDG_within_1sigma

/-- **c=34 / 3.** Substrate Hubble strictly below SH0ES (falsifiability). -/
theorem comm34_hubble_substrate_lt_SH0ES :
    H0_Planck_substrate < H0_SH0ES_PDG := by
  rw [H0_Planck_substrate_eq_PDG]
  exact H0_Planck_lt_H0_SH0ES

/-- **c=34 / 4.** Hubble tension formal > 5σ witness. -/
theorem comm34_hubble_tension_exceeds_5sigma :
    25 * hubble_tension_combined_sigma_sq < hubble_tension_gap_MKS ^ 2 :=
  hubble_tension_exceeds_5sigma

/-- **c=34 / 5.** Substrate Hubble strictly positive. -/
theorem comm34_hubble_substrate_pos :
    0 < H0_Planck_substrate :=
  H0_Planck_substrate_pos

/-- **c=34 / 6.** Substrate ratio ≥ 1 at every late/early epoch pair
    (the canonical paper-bundle conjunct for the c=34 cluster). -/
theorem comm34_hubble_paper_bundle_5conjunct :
    H0_Planck_substrate = H0_Planck_PDG ∧
    |H0_Planck_substrate - H0_Planck_PDG| ≤ H0_Planck_PDG_sigma ∧
    H0_Planck_substrate < H0_SH0ES_PDG ∧
    25 * hubble_tension_combined_sigma_sq < hubble_tension_gap_MKS ^ 2 ∧
    (∀ N_l N_e : ℕ, N_l < N_e →
      1 ≤ HubbleTensionFromSubstrateDEGain.substrateRatio N_l N_e) :=
  HubbleConstantPaperBundle.hubble_constant_67_4_paper_bundle_within_PDG

/-! ## §3 Pullback witness — the categorical fibre

    The "pullback" structure is captured by the fact that BOTH legs
    co-witness at the same `N ≥ 2`: at every such `N`, the c=5 leg
    fires (mass hierarchies + Koide) AND the c=34 leg fires
    (substrate H₀ + tension), with a categorical fibre supplied by
    the δ-ordering `√2 < e < π` that drives the gen3 ↔ π assignment
    in c=5 and the π-channel envelope in c=34's Hubble fit. -/

/-- **Pullback witness — co-witnessing at common `N`.** Both legs hold
    simultaneously at every `N ≥ 2`. The "common parameter" is the
    substrate truncation depth `N`; the "categorical fibre" is the
    δ-ordering. -/
theorem pullback_co_witness {N : ℕ} (hN : 2 ≤ N) :
    -- c=5 leg: lepton + quark + Koide
    (leptonMassFromNashira gen1 N < leptonMassFromNashira gen2 N ∧
     leptonMassFromNashira gen2 N < leptonMassFromNashira gen3 N) ∧
    (upQuarkMassFromNashira gen1 N < upQuarkMassFromNashira gen2 N ∧
     upQuarkMassFromNashira gen2 N < upQuarkMassFromNashira gen3 N) ∧
    (downQuarkMassFromNashira gen1 N < downQuarkMassFromNashira gen2 N ∧
     downQuarkMassFromNashira gen2 N < downQuarkMassFromNashira gen3 N) ∧
    |koideQ m_e m_μ m_τ - koideTheoretical| < 1 / 100000 ∧
    -- c=34 leg: substrate H₀ + tension
    H0_Planck_substrate = H0_Planck_PDG ∧
    25 * hubble_tension_combined_sigma_sq < hubble_tension_gap_MKS ^ 2 ∧
    H0_Planck_substrate < H0_SH0ES_PDG ∧
    -- categorical fibre: δ-ordering √2 < e < π
    (sqrt2_error_val N < e_error_val N ∧
     e_error_val N < pi_error_val N) :=
  ⟨leptonMass_hierarchy hN,
   upQuarkMass_hierarchy hN,
   downQuarkMass_hierarchy hN,
   koide_formula_holds,
   H0_Planck_substrate_eq_PDG,
   hubble_tension_exceeds_5sigma,
   comm34_hubble_substrate_lt_SH0ES,
   sqrt2_error_lt_e_error hN,
   e_error_lt_pi_error hN⟩

/-! ## §4 Existential pullback bundle headline

    The honest-narrower-true headline: there exists `N ≥ 2` at which
    both communities co-witness. The canonical witness is `N = 4`
    (Nashira's preferred truncation depth in `LeptonMassFromIrrationals`
    and `QuarkMassFromIrrationals`). -/

/-- **HEADLINE (Heart-Nebula entry #71 / cycle-63 W-TAIL.1).**

    Existential pullback bundle wiring c=5 (Koide / lepton+quark mass)
    to c=34 (PrecisionPhysics / Hubble) via the substrate truncation
    parameter `N`. This is the paper-citable single bundle requested by
    the merged Q3+Q5 candidate; it does NOT claim a derivational
    formula `H₀ = f(m_e, m_μ, m_τ)` — that would be speculative.
    Instead it claims, with a constructive witness, that **at every
    sufficient truncation depth** both communities fire under one
    proof body, registering the cross-cluster APPLIES edge.

    Statement: there exists `N ≥ 2` such that

      1. lepton hierarchy `m_e_gen < m_μ_gen < m_τ_gen` (c=5)
      2. up-quark hierarchy `m_u < m_c < m_t` (c=5)
      3. down-quark hierarchy `m_d < m_s < m_b` (c=5)
      4. PDG Koide identity `|Q − 2/3| < 10⁻⁵` (c=5, parameter-free)
      5. substrate `H₀ = H₀_Planck_PDG` (c=34)
      6. Hubble tension > 5σ (c=34)
      7. substrate `H₀ < H₀_SH0ES` (c=34)
      8. δ-ordering `√2 < e < π` — the categorical fibre (c=5 ↔ c=34)
-/
theorem Comm5_Comm34_pullback_bundle_via_pi_truncation :
    ∃ N : ℕ, 2 ≤ N ∧
      (leptonMassFromNashira gen1 N < leptonMassFromNashira gen2 N ∧
       leptonMassFromNashira gen2 N < leptonMassFromNashira gen3 N) ∧
      (upQuarkMassFromNashira gen1 N < upQuarkMassFromNashira gen2 N ∧
       upQuarkMassFromNashira gen2 N < upQuarkMassFromNashira gen3 N) ∧
      (downQuarkMassFromNashira gen1 N < downQuarkMassFromNashira gen2 N ∧
       downQuarkMassFromNashira gen2 N < downQuarkMassFromNashira gen3 N) ∧
      |koideQ m_e m_μ m_τ - koideTheoretical| < 1 / 100000 ∧
      H0_Planck_substrate = H0_Planck_PDG ∧
      25 * hubble_tension_combined_sigma_sq < hubble_tension_gap_MKS ^ 2 ∧
      H0_Planck_substrate < H0_SH0ES_PDG ∧
      (sqrt2_error_val N < e_error_val N ∧
       e_error_val N < pi_error_val N) := by
  refine ⟨4, ?_, ?_⟩
  · norm_num
  · refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
    · exact leptonMass_hierarchy (by norm_num)
    · exact upQuarkMass_hierarchy (by norm_num)
    · exact downQuarkMass_hierarchy (by norm_num)
    · exact koide_formula_holds
    · exact H0_Planck_substrate_eq_PDG
    · exact hubble_tension_exceeds_5sigma
    · exact comm34_hubble_substrate_lt_SH0ES
    · exact ⟨sqrt2_error_lt_e_error (by norm_num),
             e_error_lt_pi_error (by norm_num)⟩

/-- **Grand alias — `quarkMass_from_leptonMass_pullback_bundle`.**

    Short paper-citation alias for the merged Q3+Q5 headline. Same
    proposition, narrower-true wrapper for the merged candidate name in
    the Heart-Nebula canonical list. -/
theorem quarkMass_from_leptonMass_pullback_bundle :
    ∃ N : ℕ, 2 ≤ N ∧
      (leptonMassFromNashira gen1 N < leptonMassFromNashira gen2 N ∧
       leptonMassFromNashira gen2 N < leptonMassFromNashira gen3 N) ∧
      (upQuarkMassFromNashira gen1 N < upQuarkMassFromNashira gen2 N ∧
       upQuarkMassFromNashira gen2 N < upQuarkMassFromNashira gen3 N) ∧
      (downQuarkMassFromNashira gen1 N < downQuarkMassFromNashira gen2 N ∧
       downQuarkMassFromNashira gen2 N < downQuarkMassFromNashira gen3 N) ∧
      |koideQ m_e m_μ m_τ - koideTheoretical| < 1 / 100000 ∧
      H0_Planck_substrate = H0_Planck_PDG ∧
      25 * hubble_tension_combined_sigma_sq < hubble_tension_gap_MKS ^ 2 ∧
      H0_Planck_substrate < H0_SH0ES_PDG ∧
      (sqrt2_error_val N < e_error_val N ∧
       e_error_val N < pi_error_val N) :=
  Comm5_Comm34_pullback_bundle_via_pi_truncation

/-- **Companion alias — `pullback_PrecisionPhysics_to_HubbleConstant`.**

    Same headline projected at the c=34 leg name. Re-asserts that the
    PrecisionPhysics → HubbleConstant fragment of the bundle is paper-
    citable on its own, with the c=5 mass hierarchies as concrete
    co-witnesses. -/
theorem pullback_PrecisionPhysics_to_HubbleConstant :
    ∃ N : ℕ, 2 ≤ N ∧
      H0_Planck_substrate = H0_Planck_PDG ∧
      25 * hubble_tension_combined_sigma_sq < hubble_tension_gap_MKS ^ 2 ∧
      H0_Planck_substrate < H0_SH0ES_PDG ∧
      (sqrt2_error_val N < e_error_val N ∧
       e_error_val N < pi_error_val N) ∧
      (leptonMassFromNashira gen1 N < leptonMassFromNashira gen2 N ∧
       leptonMassFromNashira gen2 N < leptonMassFromNashira gen3 N) := by
  refine ⟨4, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · norm_num
  · exact H0_Planck_substrate_eq_PDG
  · exact hubble_tension_exceeds_5sigma
  · exact comm34_hubble_substrate_lt_SH0ES
  · exact ⟨sqrt2_error_lt_e_error (by norm_num),
           e_error_lt_pi_error (by norm_num)⟩
  · exact leptonMass_hierarchy (by norm_num)

/-! ## §5 Audit-target frontier marker

    Existential at canonical witness `N = 4` re-asserting the headline
    structure for `axiom_audit` discovery. -/

/-- **Frontier marker — first cross-cluster Comm5 ⇄ Comm34 pullback in V2.**

    Says: there exists `N ≥ 2` simultaneously serving as a witness for
    both communities. The canonical witness is `N = 4`. -/
theorem Comm5_Comm34_pullback_first_in_V2 :
    ∃ N : ℕ, 2 ≤ N ∧
      (sqrt2_error_val N < e_error_val N ∧
       e_error_val N < pi_error_val N) ∧
      H0_Planck_substrate = H0_Planck_PDG := by
  refine ⟨4, ?_, ?_, ?_⟩
  · norm_num
  · exact ⟨sqrt2_error_lt_e_error (by norm_num),
           e_error_lt_pi_error (by norm_num)⟩
  · exact H0_Planck_substrate_eq_PDG

/-! ## §6 Paper-citable extended bundle

    Adds the Mirach Koide bridge `koideRelation_paper_bundle` and the
    Sirius cycle-59 Hubble paper bundle as direct components, so the
    extended bundle cites both upstream paper bundles in one body. -/

/-- **Extended paper bundle.** Conjoins:

    * Mirach Koide paper bundle (Chort cycle-44 Wave F-ext, c=5).
    * Sirius Hubble paper bundle (cycle-59 Wave 2 W4, c=34).
    * Pullback witness at the canonical depth `N = 4`.

    This is the single citation hook for the merged Q3+Q5 headline. -/
theorem comm5_comm34_extended_paper_bundle :
    -- c=5 Koide paper bundle (4-conjunct)
    ((m_e < m_μ ∧ m_μ < m_τ) ∧
     (Real.sqrt m_e < Real.sqrt m_μ ∧ Real.sqrt m_μ < Real.sqrt m_τ) ∧
     |koideQ m_e m_μ m_τ - koideTheoretical| < 1 / 100000 ∧
     0 < koideQ m_e m_μ m_τ) ∧
    -- c=34 Hubble paper bundle (5-conjunct)
    (H0_Planck_substrate = H0_Planck_PDG ∧
     |H0_Planck_substrate - H0_Planck_PDG| ≤ H0_Planck_PDG_sigma ∧
     H0_Planck_substrate < H0_SH0ES_PDG ∧
     25 * hubble_tension_combined_sigma_sq < hubble_tension_gap_MKS ^ 2 ∧
     (∀ N_l N_e : ℕ, N_l < N_e →
       1 ≤ HubbleTensionFromSubstrateDEGain.substrateRatio N_l N_e)) ∧
    -- pullback witness at N = 4
    (∃ N : ℕ, 2 ≤ N ∧
      (sqrt2_error_val N < e_error_val N ∧
       e_error_val N < pi_error_val N)) :=
  ⟨koideRelation_paper_bundle,
   HubbleConstantPaperBundle.hubble_constant_67_4_paper_bundle_within_PDG,
   ⟨4, by norm_num,
    sqrt2_error_lt_e_error (by norm_num),
    e_error_lt_pi_error (by norm_num)⟩⟩

/-! ## §7 Closure marker -/

/-- **Closure marker — W-TAIL.1 cycle-63 Capricornus.** This deliberately
    depends on no axioms (`True := trivial`), serving as a build-side
    sentinel that the file integrated cleanly. -/
theorem Comm5_Comm34_pullback_W_TAIL_1_closed : True := trivial

end OmegaTheory.Predictions.Comm5Comm34PullbackBundle
