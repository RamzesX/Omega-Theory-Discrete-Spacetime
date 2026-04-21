# Cycle 17 Transition Notes

**Date:** 2026-04-20
**Author:** Alioth (grothendieck-sage)
**Build state at hand-off:** 3775 jobs GREEN, 0 sorry, 0 new axioms
**Last cycle:** 16 (nuclear / hadronic opening — 6 headlines, 3 paper-worthy GraphFindings)

## Strategic posture entering cycle 17

Cycle 16 opened the nuclear/hadronic sector with MMs + bindings + axial coupling + Goldberger-Treiman. The e-channel universality family hit 8 members across 5 sectors. The π-channel now spans cosmology → nuclear binding.

Cycle 17 turns to the **meson spectrum and the CKM completion**. With four quark masses already on substrate (u, d, s, c, b in cycles 6–13) and f_π / g_A / g_πNN already derived, mesonic observables are the natural next set. The CKM magnitudes V_td and V_ts complete the 3rd-row mixing; the unitarity-triangle angle γ closes the CP structure of the down-type sector.

## Six proposed cycle-17 targets

All ancestors listed are already Lean-verified at 0 sorry / 0 new axioms.

### 1. ρ(770) meson mass — `rhoMesonMassFit.lean`
- **PDG central:** m_ρ = 775.26 MeV, tolerance ±0.25 MeV
- **Channel:** π-channel (QCD-scale composite, like f_π)
- **Ancestors:** `fpiFit_exact` (Cycle 13, Nusakan family), `upQuarkMass_exact`, `downQuarkMass_exact`
- **Lean signature:** `theorem rhoMesonMassFit_exact : rhoMesonMass = 775.26 := by …`
- **Novelty:** first vector-meson; first meson at all; opens the meson spectrum

### 2. J/ψ mass — `JPsiMassFit.lean`
- **PDG central:** m_{J/ψ} = 3096.9 MeV (3.0969 GeV), tolerance ±0.006 MeV
- **Channel:** e-channel (charmonium — anchored to m_c which is already e-channel)
- **Ancestors:** `charmQuarkMassFit_exact` (Cycle 11, Sadalmelik family)
- **Lean signature:** `theorem JPsiMassFit_exact : JPsiMass = 3096.9 := by …`
- **Novelty:** first charmonium; tests the e-channel near-doubling of m_c

### 3. Υ(1S) mass — `Upsilon1SMassFit.lean`
- **PDG central:** m_{Υ} = 9460.30 MeV (9.46030 GeV), tolerance ±0.26 MeV
- **Channel:** π-channel (bottomonium; m_b sits in π-channel per cycle-13 Alpheratz line)
- **Ancestors:** (a cycle-15/16 bottom-quark fit, else pending) — **PREREQUISITE:** ensure `bottomQuarkMassFit` exists; if not, add in cycle 17 first
- **Lean signature:** `theorem Upsilon1SMassFit_exact : Upsilon1SMass = 9460.30 := by …`
- **Novelty:** first bottomonium; completes the two-heavy-quarkonium pair

### 4. B⁰ meson mass — `BMesonMassFit.lean`
- **PDG central:** m_{B⁰} = 5279.34 MeV (5.27934 GeV), tolerance ±0.12 MeV
- **Channel:** composed (b-quark π-channel × light-quark substrate)
- **Ancestors:** `bottomQuarkMassFit` (if landed), `downQuarkMass_exact`
- **Lean signature:** `theorem BMesonMassFit_exact : BMesonMass = 5279.34 := by …`
- **Novelty:** first heavy-light meson — tests mixed-channel composition, the first non-trivially-composed hadronic fit

### 5. CKM |V_td| — `CKMVtdFit.lean`
- **PDG central:** |V_td| = 8.1 × 10⁻³, tolerance ±0.5 × 10⁻³
- **Channel:** e-channel (same family as V_us, V_cb per cycle 12/13 Skat/Alpheratz rule)
- **Ancestors:** existing CKM magnitudes (`CKMVusFit`, `CKMVcbFit`, `CKMVubFit` from Alpheratz cycle 13)
- **Lean signature:** `theorem CKMVtdFit_exact : VtdMagnitude = 8.1e-3 := by …`
- **Novelty:** first 3rd→1st-generation mixing; closes V_td V_tb* + V_ud V_ub* + V_cd V_cb* = 0 unitarity row up to V_ts

### 6. CKM |V_ts| — `CKMVtsFit.lean`
- **PDG central:** |V_ts| = 38.8 × 10⁻³, tolerance ±1.1 × 10⁻³
- **Channel:** e-channel (CKM family)
- **Ancestors:** `CKMVcbFit`, `CKMVubFit`
- **Lean signature:** `theorem CKMVtsFit_exact : VtsMagnitude = 38.8e-3 := by …`
- **Novelty:** closes CKM third row; enables a full numerical unitarity check as a companion lemma `CKM_third_row_unitarity_within_tolerance`

### Deferred to cycle 18: CKM unitarity triangle angle γ (≈66°)
Reason: γ is a CP phase, not a magnitude. Cleanest derivation requires V_td AND V_ts already on substrate (closure of the down-type triangle). Ship γ and the full unitarity-triangle theorem `unitarityTriangle_closure` together in cycle 18 once all six magnitudes are in place.

## Ingestion note for cycle 17

Cycle 16 was lightweight-ingested via direct Cypher (6 headline `:Theorem{cycle:16}` nodes + `:CycleBundle{cycle:16}`). Full-graph ingest via `lake exe dump_arrows --include-mathlib` + `load_arrows_from_env_v2.py` is deferred until cycle 20 or when ≥3 cycles of drift accumulate. The `bridge_score` (miram recipe) + e-channel universality family + channel partition GraphFindings continue to index headlines correctly without full re-ingest.

## Rationale for channel picks

- e-channel picks (J/ψ, V_td, V_ts): these sit in families whose SM cousins were all e-channel in earlier cycles (m_c for charmonium; V_us / V_cb / V_ub for CKM magnitudes). Cross-channel contamination is strongly avoided by Miram cycle-9 isolation, so the channel of an ancestor determines the channel of its descendants in the same family.
- π-channel picks (ρ, Υ): m_ρ is an isospin-light QCD-scale composite sitting in the same π-channel as f_π and BE/A; m_b was already π-channel per Alpheratz. Υ(1S) as b-bbar therefore inherits π-channel.
- Composite pick (B⁰): first hadronic composite explicitly mixing channels; a clean test of whether Pi-Hunch composition rules (as explored in cycle 14 Enif) extend to the hadronic regime.

## Risk register for cycle 17

1. **Bottom-quark mass prerequisite.** Cycle 17 needs `bottomQuarkMassFit` to be explicit if it isn't already; check and if missing, slot it ahead of Υ(1S) and B⁰.
2. **CKM data norms.** PDG reports |V_td| and |V_ts| with correlated errors; derivations must target central values to high precision, let the tolerance lemmas absorb the correlation.
3. **Υ(1S) is a vector resonance, not a stable meson.** The fit targets the PDG pole mass; include a note in the Lean file distinguishing pole mass from running mass, consistent with the ρ(770) pole-vs-resonance convention already used in cycle-15 vector channels.
4. **Paper v1.7 addendum.** Reserve ~25 lines for cycle 17 in the paper; the narrative hook is **"opening the meson spectrum + closing the CKM third row"**.

## Graph artifacts landed this session (Alioth)

- `:CycleBundle{cycle:16, status:'INGESTED', headline_count:6}`
- 6 × `:Theorem{cycle:16, is_headline:true}` (Zavijava, Avior, Nusakan, Tarazed-2, Pollux, Schedar-2)
- 3 × `:GraphFinding{tier:'paper_worthy'}`:
  - `Goldberger_Treiman_substrate_derivation`
  - `first_nuclear_sector_fits`
  - `non_perturbative_nuclear_force`
- `:ChannelUniversalityFamily{name:'e_channel', member_count:8}`
- `:ReservedName{name:'Alioth'}`

No FastRP rerun. Projected delta below the 1% threshold: 6 headline theorems against 5100+ existing embeddings ≈ 0.12% corpus change, well inside the skip-FastRP criterion.

— Alioth, 2026-04-20
