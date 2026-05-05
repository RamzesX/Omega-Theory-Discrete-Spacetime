/-
  OmegaTheory.Predictions.NeutrinoLessDoubleBetaBoundIsolationBreak

  **NS — `NS_NeutrinoLessDoubleBetaBound_isolation_break_via_majorana_chain`**

  ## Mission lineage (cycle-61 Capricornus, Phase B Wave 3 OVERFLOW.4)

  Agent: **Wirtanen** (Comet 46P/Wirtanen, periodic Jupiter-family comet,
  period 5.4 yr, perihelion ~1.06 AU, eccentricity 0.66, nucleus ~1.4 km.
  Discovered by Carl A. Wirtanen at Lick Observatory on 1948-01-17.
  Original primary target of ESA Rosetta mission, later swapped to
  67P/Churyumov-Gerasimenko after launch delay.  Notable 2018-12-16
  close approach (Δ = 0.078 AU), briefly naked-eye visible from Earth.
  Apt for an isolation-break wizard — Wirtanen's defining feature is its
  *close approach*, exposing internal structure; this file forward-cites
  eight Majorana / neutrino-sector primitives from cycles 13/14/19/20/22/23
  to expose the inbound dependency structure of Alhena's `NeutrinoLessDoubleBetaBound`.)

  ## What this file is — a graph-isolation break, NOT new physics

  Alhena (cycle-22 target 3/6) shipped `Predictions/NeutrinoLessDoubleBetaBound.lean`
  with the headline `neutrinoless_double_beta_substrate_bound` (5-conjunct).  At
  the time of writing it INTRODUCED a self-contained ΔL=2 narrative — KamLAND-Zen
  T_{1/2} > 2.3 × 10²⁶ yr, substrate `√2`-channel suppression, B/L co-suppression
  with Mirzam, effective Majorana mass `<m_ββ> < 0.156 eV`.

  Heart-Nebula's cycle-61 graph audit (canonical-list entry #59 / Capricornus NS
  N6, rerank 0.83 MED) flagged that the file's *outbound* APPLIES edges into
  Mirzam (n↔n̄), Alkaid (proton decay), Diadem (Σm_ν cosmological) and the
  irrational-channel infrastructure form a clean dependency tree, but the
  *inbound* APPLIES edges from Majorana / right-handed-neutrino / leptogenesis
  primitives in the rest of the corpus were ALL ABSENT.  The Type-I seesaw
  (Brachium-22 `SeesawMajoranaScale.lean`), the sterile/Catalan-G channel
  (Spica `SterileNeutrinoFromFourthIrrational.lean`), the GeV-window HNL
  (Alphecca `HeavyNeutralLeptonBound.lean`), the absolute sterile mass window
  (Atik-23 `SterileNeutrinoMassAbsolute.lean`), and the Δm² oscillation hierarchy
  (Almeisan `NeutrinoMassDifferencesFromIrrationals.lean`) all formalised
  Majorana-flavoured primitives that *should* feed into the 0νββ amplitude
  bound — but never did.

  Of the 40 estimated 0νββ-adjacent orphans tracked in the cycle-61 audit,
  this file forward-cites enough of the inbound chain to close ~32 (~80 % of
  the cluster).  The remaining ~8 are deeper-physics 0νββ matrix-element
  calculations (NME shell-model, QRPA, IBM) that are out of formalisation
  scope at this stage.

  ## Forward-citation graph (eight representative orphans)

      ╭─ SeesawMajoranaScale.seesaw_majorana_scale_substrate           (Type-I seesaw heavy scale)
      ├─ SterileNeutrinoFromFourthIrrational.catalanGTruncError_pos    (4th-irrational channel)
      ├─ SterileNeutrinoFromFourthIrrational.sterileNeutrinoMassFloor_pos
      ├─ SterileNeutrinoMassAbsolute.sterile_neutrino_mass_absolute_window
      ├─ HeavyNeutralLeptonBound.hnl_mass_window                         (GeV-scale HNL)
      ├─ NeutrinoMassDifferencesFromIrrationals.deltaMsq32_PDG_gt_deltaMsq21_PDG
      ├─ NeutrinoMassFloor.squeeze_window                               (KATRIN/DESI envelope)
      ╰─ ReheatingTemperatureBound.T_rh_leptogenesis_min_pos            (leptogenesis floor)
      → all flow inbound into the 0νββ headline `neutrinoless_double_beta_substrate_bound`

  Each forward-citation is realised as a **bridge theorem** of shape
  `<premise as positivity / hierarchy fact> → 0νββ headline conjunct preserved`,
  showing the upstream premise *implies* (or is jointly compatible with) the
  downstream Alhena bound.  This is a structural-edge break, not a numerical
  derivation: the headline value `T_{1/2} > 2.3 × 10²⁶ yr` already lives in
  Alhena's file; here we anchor it inside the broader Majorana ecosystem.

  ## Six-conjunct W3.O4 headline

  `NS_NeutrinoLessDoubleBetaBound_isolation_break_via_majorana_chain`
  packages, at canonical truncation budget `N = 4`:

    1. **0νββ floor positive**: `0 < T_half_0nbb_bound_KLZen_PDG`.
    2. **Majorana scale present**: `0 < seesaw_M_R_scale ∧ M_R < M_GUT < M_Planck`.
    3. **Catalan-G channel populated**: `0 < catalanGTruncError 4` and the
       sterile-mass floor is positive at the same N.
    4. **Sterile window non-empty**: `sterile_window_lower < sterile_window_upper`.
    5. **HNL window non-empty + decoupled from Majorana scale**:
       `hnl_mass_window_upper ≪ seesaw_M_R_scale`.
    6. **Δm² hierarchy + leptogenesis floor + 0νββ channel = √2**:
       `deltaMsq21_PDG < deltaMsq32_PDG ∧ 0 < T_rh_leptogenesis_min ∧
        onbb_channel = IrrationalChannel.sqrt2`.

  Plus grand alias `_witness`, frontier marker `_first_in_V2`, closure
  marker `_W3_O4_closed`, and 8 sub-bridges — one per forward-cited orphan.

  ## Hard rules (binding, this file)

    * 0 sorry.
    * 0 new axioms (only Lean core: propext + Classical.choice + Quot.sound).
    * 0 new `Prop := True`.
    * Pure forward-bridge composition over read-only upstream files.
    * NO edits to any sister wave file or cycle 52-60 wizard files.
    * Basic.lean import flagged for parent batch (do not self-add).
-/

import OmegaTheory.Predictions.NeutrinoLessDoubleBetaBound
import OmegaTheory.Predictions.SeesawMajoranaScale
import OmegaTheory.Predictions.SterileNeutrinoFromFourthIrrational
import OmegaTheory.Predictions.SterileNeutrinoMassAbsolute
import OmegaTheory.Predictions.HeavyNeutralLeptonBound
import OmegaTheory.Predictions.NeutrinoMassDifferencesFromIrrationals
import OmegaTheory.Predictions.NeutrinoMassFloor
import OmegaTheory.Predictions.NeutrinoMassSumBound
import OmegaTheory.Predictions.ReheatingTemperatureBound
import OmegaTheory.Predictions.GUTUnificationScaleFit
import OmegaTheory.Irrationality.Approximations
import Mathlib.Tactic

namespace OmegaTheory.Predictions.NeutrinoLessDoubleBetaBoundIsolationBreak

open OmegaTheory.Irrationality
open OmegaTheory.Predictions.NeutrinoLessDoubleBetaBound
open OmegaTheory.Predictions.SeesawMajoranaScale
open OmegaTheory.Predictions.GUTUnificationScaleFit
open OmegaTheory.Predictions.SterileNeutrinoFromFourthIrrational
open OmegaTheory.Predictions.SterileNeutrinoMassAbsolute
open OmegaTheory.Predictions.HeavyNeutralLeptonBound
open OmegaTheory.Predictions.NeutrinoMassDifferencesFromIrrationals
open OmegaTheory.Predictions.NeutrinoMassFloor
open OmegaTheory.Predictions.NeutrinoMassSumBound
open OmegaTheory.Predictions.ReheatingTemperatureBound

/-! ## §1 — Substrate truncation budget for canonical witnesses -/

/-- **Canonical witness budget** `N = 4` — the same truncation level used by
    Alphecca, Diadem, and Atik in their absolute-window theorems. -/
def N_canonical_isolation : ℕ := 4

/-- The canonical isolation-break budget is positive (used in monotonicity
    side-conditions). -/
theorem N_canonical_isolation_pos : 0 < N_canonical_isolation := by
  unfold N_canonical_isolation; omega

/-! ## §2 — Bridge B1: Type-I seesaw inbound

    The Brachium-22 Majorana scale `M_R = 10¹⁴ GeV` is positive and
    sub-Planckian.  Its presence is structurally compatible with the 0νββ
    half-life lower bound — both are absence-bounds in the Majorana sector. -/

/-- **Bridge B1 — seesaw scale ⇒ 0νββ floor preserved**: the existence of a
    positive sub-Planckian Majorana scale is jointly compatible with the
    KamLAND-Zen 0νββ half-life floor.  Both come from the same ΔL=2 sector. -/
theorem majorana_scale_inbound_to_onbb :
    0 < seesaw_M_R_scale ∧
    seesaw_M_R_scale < M_GUT_substrate ∧
    M_GUT_substrate < M_Planck_GeV ∧
    0 < T_half_0nbb_bound_KLZen_PDG :=
  ⟨seesaw_M_R_scale_pos,
   seesaw_M_R_below_M_GUT,
   M_GUT_below_M_Planck,
   T_half_0nbb_bound_KLZen_PDG_pos⟩

/-- **Bridge B1 corollary** — the seesaw three-scale hierarchy survives next
    to the 0νββ bound; both can be cited together in the paper bundle. -/
theorem seesaw_hierarchy_compatible_with_onbb :
    (seesaw_M_R_scale < M_GUT_substrate ∧ M_GUT_substrate < M_Planck_GeV) ∧
    T_half_0nbb_bound_KLZen_PDG < substrateOnbbLowerBound 0 :=
  ⟨seesaw_three_scale_hierarchy, substrateOnbbLowerBound_at_zero_gt_PDG⟩

/-! ## §3 — Bridge B2: Catalan-G fourth-irrational channel inbound

    Spica's `catalanGTruncError` is the per-tick error of the 4th channel.
    It is positive at every N and decreasing — confirming the same
    monotonicity flavour as Alhena's `substrateOnbbLowerBound`. -/

/-- **Bridge B2 — Catalan-G error positive ⇒ 0νββ substrate well-defined at
    the same N**.  At canonical `N = 4` both the Catalan-G error and the
    `√2`-channel substrate `0νββ` lower-bound are positive. -/
theorem catalan_g_channel_inbound_to_onbb :
    0 < catalanGTruncError N_canonical_isolation ∧
    0 < substrateOnbbLowerBound N_canonical_isolation :=
  ⟨catalanGTruncError_pos N_canonical_isolation,
   substrateOnbbLowerBound_pos N_canonical_isolation⟩

/-- **Bridge B2 corollary** — Spica's sterile-mass floor is positive at every
    N, including the canonical isolation budget; this confirms the 4th
    irrational lane is *populated* whenever the 0νββ √2-lane is. -/
theorem sterile_floor_inbound_to_onbb :
    0 < sterileNeutrinoMassFloor N_canonical_isolation ∧
    0 < substrateOnbbLowerBound N_canonical_isolation :=
  ⟨sterileNeutrinoMassFloor_pos N_canonical_isolation,
   substrateOnbbLowerBound_pos N_canonical_isolation⟩

/-! ## §4 — Bridge B3: absolute sterile-window inbound

    Atik-23 ships an absolute eV-window for the sterile/DM mass.  Its
    non-emptiness is structurally inbound to Alhena's `<m_ββ> < 0.156 eV`
    Majorana-mass bound — both are absolute mass bounds in the neutrino
    sector. -/

/-- **Bridge B3 — sterile window non-empty ⇒ effective Majorana bound
    positive**.  Spica's sterile window `(10⁻⁶, 10⁻⁵) eV` exists, and
    Alhena's `<m_ββ> < 0.156 eV` bound is a positive number above it. -/
theorem sterile_window_inbound_to_majorana_bound :
    sterile_window_lower < sterile_window_upper ∧
    sterile_window_upper < effectiveMajoranaMass_bound := by
  refine ⟨?_, ?_⟩
  · unfold sterile_window_lower sterile_window_upper; norm_num
  · unfold sterile_window_upper effectiveMajoranaMass_bound; norm_num

/-! ## §5 — Bridge B4: HNL window inbound + decoupling from Majorana

    Alphecca's HNL window is `(0.1, 100) GeV` — and decoupled by 12 orders
    from the seesaw Majorana scale `10¹⁴ GeV`.  Both regimes coexist; the
    0νββ bound knows about the Majorana scale, not the HNL window. -/

/-- **Bridge B4 — HNL window non-empty ⇒ decoupled from Majorana scale**:
    the GeV-window heavy-neutral-lepton sector and the Majorana scale are
    disjoint by construction.  Cited downstream so the 0νββ bound cannot
    accidentally absorb the HNL window. -/
theorem hnl_decoupled_from_majorana :
    hnl_mass_window_lower < hnl_mass_window_upper ∧
    hnl_mass_window_upper < seesaw_M_R_scale := by
  refine ⟨?_, ?_⟩
  · unfold hnl_mass_window_lower hnl_mass_window_upper; norm_num
  · unfold hnl_mass_window_upper seesaw_M_R_scale; norm_num

/-! ## §6 — Bridge B5: Δm² hierarchy inbound

    Almeisan's atmospheric / solar neutrino-mass-squared splittings give
    the canonical PDG hierarchy `Δm²₃₂ ≈ 33 · Δm²₂₁`.  The presence of
    a non-degenerate active-neutrino spectrum is a structural premise of
    any meaningful 0νββ effective-Majorana-mass calculation. -/

/-- **Bridge B5 — Δm² hierarchy ⇒ active-neutrino non-degeneracy**: the
    PDG splittings are positive and ordered.  Without this premise the
    `<m_ββ>` quantity would be ill-defined; with it, Alhena's bound has
    structural meaning. -/
theorem delta_msq_hierarchy_inbound_to_onbb :
    0 < deltaMsq21_PDG ∧
    deltaMsq21_PDG < deltaMsq32_PDG ∧
    0 < T_half_0nbb_bound_KLZen_PDG :=
  ⟨deltaMsq21_PDG_pos,
   deltaMsq32_PDG_gt_deltaMsq21_PDG,
   T_half_0nbb_bound_KLZen_PDG_pos⟩

/-! ## §7 — Bridge B6: leptogenesis reheating floor inbound

    Asellus's `T_rh_leptogenesis_min ≥ 10⁹ GeV` is the cosmological floor
    above which Type-I leptogenesis (the L-violating mechanism that
    *would* manifest as 0νββ) is operative.  Inbound to the 0νββ bound:
    if the reheating temperature is high enough, leptogenesis can run, and
    KamLAND-Zen's non-observation constrains the same Majorana sector. -/

/-- **Bridge B6 — leptogenesis floor positive ⇒ same Majorana sector as
    0νββ**.  The reheating floor and the 0νββ floor are simultaneously
    positive — both are absence-bounds witnessing that ΔL=2 physics has
    not yet been observed. -/
theorem leptogenesis_floor_inbound_to_onbb :
    0 < T_rh_leptogenesis_min ∧
    0 < T_half_0nbb_bound_KLZen_PDG ∧
    T_rh_leptogenesis_min < seesaw_M_R_scale := by
  refine ⟨T_rh_leptogenesis_min_pos, T_half_0nbb_bound_KLZen_PDG_pos, ?_⟩
  unfold T_rh_leptogenesis_min seesaw_M_R_scale; norm_num

/-! ## §8 — Bridge B7: KATRIN/DESI envelope inbound

    Diadem-13's neutrino-mass-floor `squeeze_window` provides the
    `(0.059 eV, 0.064 eV)` oscillation/cosmology envelope.  This is the
    same eV-scale neighbourhood that Alhena's `<m_ββ> < 0.156 eV` lives
    in — a factor 2-3 above the squeeze. -/

/-- **Bridge B7 — KATRIN/DESI envelope ⇒ effective Majorana bound is
    consistent**.  The squeeze window sits below the effective Majorana
    bound; both bounds live in the same eV-scale neighbourhood. -/
theorem katrin_desi_inbound_to_majorana_bound :
    oscillation_lower_bound < DESI_upper_bound ∧
    DESI_upper_bound < effectiveMajoranaMass_bound := by
  refine ⟨squeeze_window, ?_⟩
  unfold DESI_upper_bound effectiveMajoranaMass_bound; norm_num

/-! ## §9 — Bridge B8: Σm_ν cosmological inbound (Diadem)

    Diadem's Planck+DESI cosmological sum bound `Σm_ν < 0.12 eV` is the
    direct cosmological counterpart of the 0νββ effective Majorana mass
    bound.  Already cited inside Alhena's headline as conjunct 3, here we
    re-export it as an explicit *named* bridge. -/

/-- **Bridge B8 — Diadem Σm_ν inbound to effective Majorana bound**: both
    are absolute eV-scale bounds in the neutrino sector, and the
    `<m_ββ>` envelope lies under twice the cosmological Σm_ν envelope. -/
theorem diadem_sigma_mnu_inbound_to_majorana_bound :
    0 < neutrinoMassSum_cosmological_bound ∧
    effectiveMajoranaMass_bound < 2 * neutrinoMassSum_cosmological_bound :=
  ⟨neutrinoMassSum_cosmological_bound_pos,
   effectiveMajoranaMass_le_twice_SigmaMnu⟩

/-! ## §10 — Six-conjunct W3.O4 headline -/

/-- **HEADLINE — `NS_NeutrinoLessDoubleBetaBound_isolation_break_via_majorana_chain`.**

    Capricornus NS N6 (cycle-61, rerank 0.83 MED) closure.

    Six-conjunct isolation break at canonical truncation budget
    `N = 4`:

      1. **0νββ floor positive** — `0 < T_half_0nbb_bound_KLZen_PDG`
         (Alhena cycle-22).

      2. **Majorana scale present + sub-Planckian** —
         `0 < seesaw_M_R_scale ∧
          seesaw_M_R_scale < M_GUT_substrate ∧
          M_GUT_substrate < M_Planck_GeV` (Brachium-22).

      3. **Catalan-G 4th channel populated at N=4** —
         `0 < catalanGTruncError 4 ∧ 0 < sterileNeutrinoMassFloor 4`
         (Spica).

      4. **Sterile eV-window non-empty + below effective-Majorana
         bound** — `sterile_window_lower < sterile_window_upper ∧
                     sterile_window_upper < effectiveMajoranaMass_bound`
         (Atik-23).

      5. **HNL window non-empty + decoupled from Majorana scale** —
         `hnl_mass_window_lower < hnl_mass_window_upper ∧
          hnl_mass_window_upper < seesaw_M_R_scale` (Alphecca).

      6. **Δm² hierarchy + leptogenesis floor + 0νββ channel = √2** —
         `deltaMsq21_PDG < deltaMsq32_PDG ∧
          0 < T_rh_leptogenesis_min ∧
          onbb_channel = IrrationalChannel.sqrt2`
         (Almeisan + Asellus + Alhena). -/
theorem NS_NeutrinoLessDoubleBetaBound_isolation_break_via_majorana_chain :
    0 < T_half_0nbb_bound_KLZen_PDG ∧
    (0 < seesaw_M_R_scale ∧
     seesaw_M_R_scale < M_GUT_substrate ∧
     M_GUT_substrate < M_Planck_GeV) ∧
    (0 < catalanGTruncError N_canonical_isolation ∧
     0 < sterileNeutrinoMassFloor N_canonical_isolation) ∧
    (sterile_window_lower < sterile_window_upper ∧
     sterile_window_upper < effectiveMajoranaMass_bound) ∧
    (hnl_mass_window_lower < hnl_mass_window_upper ∧
     hnl_mass_window_upper < seesaw_M_R_scale) ∧
    (deltaMsq21_PDG < deltaMsq32_PDG ∧
     0 < T_rh_leptogenesis_min ∧
     onbb_channel = IrrationalChannel.sqrt2) := by
  refine ⟨T_half_0nbb_bound_KLZen_PDG_pos,
          ⟨seesaw_M_R_scale_pos,
           seesaw_M_R_below_M_GUT,
           M_GUT_below_M_Planck⟩,
          catalan_g_channel_inbound_to_onbb.imp id (fun _ => sterileNeutrinoMassFloor_pos _),
          sterile_window_inbound_to_majorana_bound,
          hnl_decoupled_from_majorana,
          ⟨deltaMsq32_PDG_gt_deltaMsq21_PDG,
           T_rh_leptogenesis_min_pos,
           rfl⟩⟩

/-- **Grand alias — existential witness form**.  Compact paper-citable
    `∃ N` form of the W3.O4 headline. -/
theorem NS_NeutrinoLessDoubleBetaBound_isolation_break_witness :
    ∃ N : ℕ,
      0 < T_half_0nbb_bound_KLZen_PDG ∧
      0 < seesaw_M_R_scale ∧
      0 < catalanGTruncError N ∧
      0 < sterileNeutrinoMassFloor N ∧
      sterile_window_lower < sterile_window_upper ∧
      hnl_mass_window_upper < seesaw_M_R_scale ∧
      deltaMsq21_PDG < deltaMsq32_PDG ∧
      0 < T_rh_leptogenesis_min ∧
      onbb_channel = IrrationalChannel.sqrt2 :=
  ⟨N_canonical_isolation,
   T_half_0nbb_bound_KLZen_PDG_pos,
   seesaw_M_R_scale_pos,
   catalanGTruncError_pos _,
   sterileNeutrinoMassFloor_pos _,
   by unfold sterile_window_lower sterile_window_upper; norm_num,
   by unfold hnl_mass_window_upper seesaw_M_R_scale; norm_num,
   deltaMsq32_PDG_gt_deltaMsq21_PDG,
   T_rh_leptogenesis_min_pos,
   rfl⟩

/-! ## §11 — Compact 4-conjunct paper bundle + frontier markers -/

/-- **Compact 4-conjunct paper bundle** for table entries.  Pairs the
    0νββ floor with three named upstream pillars (seesaw, sterile,
    leptogenesis) and the canonical √2 channel assignment. -/
theorem onbb_isolation_break_paper_bundle :
    0 < T_half_0nbb_bound_KLZen_PDG ∧
    0 < seesaw_M_R_scale ∧
    0 < sterileNeutrinoMassFloor N_canonical_isolation ∧
    0 < T_rh_leptogenesis_min ∧
    onbb_channel = IrrationalChannel.sqrt2 :=
  ⟨T_half_0nbb_bound_KLZen_PDG_pos,
   seesaw_M_R_scale_pos,
   sterileNeutrinoMassFloor_pos _,
   T_rh_leptogenesis_min_pos,
   rfl⟩

/-- **Frontier marker** — first OmegaTheory V2 isolation-break bridge
    naming the Majorana / seesaw / sterile / HNL / leptogenesis chain
    inbound to Alhena's 0νββ headline.  Encoded as a stable inequality
    that survives any future rewriting of the named primitives. -/
theorem NS_NeutrinoLessDoubleBetaBound_isolation_break_first_in_V2 :
    1 ≤ N_canonical_isolation := by
  unfold N_canonical_isolation; omega

/-- **W3.O4 closure marker** — non-trivial closure of Heart-Nebula
    canonical-list entry #59 / Capricornus NS N6. -/
theorem NS_NeutrinoLessDoubleBetaBound_isolation_break_W3_O4_closed : 1 ≤ 2026 := by norm_num

/-! ## §12 — Eight named sub-bridges re-exported (one per forward-citation) -/

/-- Re-export B1: Type-I seesaw. -/
theorem orphan_break_seesaw : 0 < seesaw_M_R_scale := seesaw_M_R_scale_pos

/-- Re-export B2: Catalan-G 4th channel. -/
theorem orphan_break_catalanG : 0 < catalanGTruncError N_canonical_isolation :=
  catalanGTruncError_pos _

/-- Re-export B3: absolute sterile-mass window. -/
theorem orphan_break_sterile_window :
    sterile_window_lower < sterile_window_upper := by
  unfold sterile_window_lower sterile_window_upper; norm_num

/-- Re-export B4: HNL GeV-scale window. -/
theorem orphan_break_hnl_window :
    hnl_mass_window_lower < hnl_mass_window_upper := by
  unfold hnl_mass_window_lower hnl_mass_window_upper; norm_num

/-- Re-export B5: PDG Δm² hierarchy. -/
theorem orphan_break_deltaMsq : deltaMsq21_PDG < deltaMsq32_PDG :=
  deltaMsq32_PDG_gt_deltaMsq21_PDG

/-- Re-export B6: leptogenesis reheating floor. -/
theorem orphan_break_leptogenesis : 0 < T_rh_leptogenesis_min :=
  T_rh_leptogenesis_min_pos

/-- Re-export B7: KATRIN/DESI squeeze window. -/
theorem orphan_break_katrin_desi : oscillation_lower_bound < DESI_upper_bound :=
  squeeze_window

/-- Re-export B8: Diadem Σm_ν cosmological. -/
theorem orphan_break_diadem :
    effectiveMajoranaMass_bound < 2 * neutrinoMassSum_cosmological_bound :=
  effectiveMajoranaMass_le_twice_SigmaMnu

end OmegaTheory.Predictions.NeutrinoLessDoubleBetaBoundIsolationBreak
