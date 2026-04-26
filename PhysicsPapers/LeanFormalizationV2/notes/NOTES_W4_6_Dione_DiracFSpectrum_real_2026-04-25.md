# NOTES_W4_6 — Dione — DiracFSpectrumRealCapstoneInbound — 2026-04-26

**Cycle**: 61 (Capricornus), Phase B Wave 4, W4.6.
**Heart-Nebula canonical-list entry**: #28 / Capricornus SEC S8
(rerank 0.85, HIGH).
**Agent**: Dione (Saturn IV, fourth-largest moon of Saturn,
ice/silicate composite, co-orbital with Trojan moons Helene + Polydeuces).
**Status**: LANDED — single-module + full-project GREEN, 0 sorry,
0 new axioms.

## Headline

```
SEC_dirac_F_spectrum_real_capstone_inbound_via_DF_eigenvalues :
  -- (i) Substrate placeholder spectral isolation (Nessus W1.5)
  (∀ g : FermionGeneration, standardD_F.eigenvalues g = 0)
  -- (ii) electron-tower reality
  ∧ (∀ z ∈ spectrum ℂ electronD_F, Complex.im z = 0)
  -- (iii) up-quark-tower reality
  ∧ (∀ z ∈ spectrum ℂ upQuarkD_F, Complex.im z = 0)
  -- (iv) down-quark-tower reality
  ∧ (∀ z ∈ spectrum ℂ downQuarkD_F, Complex.im z = 0)
  -- (v) neutrino-tower reality
  ∧ (∀ z ∈ spectrum ℂ neutrinoD_F, Complex.im z = 0)
```

## Strategy

The `dirac_f_spectrum_real_unified_capstone` (Sulafat / Vindemiatrix,
cycle 4 — `Emergence/DiracFSpectrumReal.lean:270`) is the paper-citable
4-conjunct headline that all four Dirac blocks have real ℂ-spectra.
It is the precondition for the Connes mass-derivation pathway
(D_F eigenvalues = Yukawa couplings = mass parameters).

Capricornus SEC S8 (rerank 0.85, HIGH) flagged the capstone as
**graph-orphaned on the inbound side**: no APPLIES edge wires
substrate-level "D_F eigenvalues exist" data into the reality capstone.

W4.6 closes the gap by composing two Capricornus-W1 substrate outputs
onto Vindemiatrix's reality capstone:

- **Nessus W1.5** (`Foundations/DiracOperatorFDoubleWitness.lean`):
  spectral isolation `standardD_F.eigenvalues g = 0 ∀ g` (kernel-everything
  placeholder) + fourfold Witness-Yoneda for all four SM species
  instantiating `DiracOperatorF`.

- **Titan W1.3** (`Emergence/ConnesDFYukawaPaperBundleInbound.lean`):
  forward bridges from `substrate_budget_at_least_two : ℕ → Prop`
  (truncation budget `N ≥ 2`) into the four paper bundles.

The W4.6 file ships:

1. **Four per-species inbound bridges** (one per species block).
   Each takes the explicit Hermiticity witness from
   `DiracFSpectrum.lean` (Rasalhague) and discharges the corresponding
   reality conclusion via Mathlib's spectral theorem
   (`hermitian_complex_spectrum_elt_im_zero`).

2. **Substrate-budget bridge** wiring Titan's `substrate_budget_at_least_two`
   into the four-fold reality capstone via Hermiticity.

3. **Placeholder-spectral bridge** wiring Nessus's `standardD_F_spectrum_collapses`
   into abstract-side reality + four concrete species blocks.

4. **W4.6 paper headline** (the 5-conjunct bundle above) + composers
   firing the existing Vindemiatrix capstone.

5. **Witness-Yoneda inbound bridge** wiring Nessus's fourfold Witness-Yoneda
   into the reality capstone.

6. **Frontier marker** — first inbound capping of the reality capstone
   in V2.

## Build state

- Single-module: `lake build OmegaTheory.Emergence.DiracFSpectrumRealCapstoneInbound`
  → 3,478 jobs / 2.1s on `~/lean-v2`. GREEN.
- Full project: `lake build` → **4,048 jobs GREEN** (matches c61 baseline;
  zero downstream regressions).
- 0 sorry.
- 0 new axioms.

## Axiom audit (`#print axioms`)

All eight tested headlines depend ONLY on
`[propext, Classical.choice, Quot.sound]` (Lean core), and the frontier
marker `SEC_dirac_F_spectrum_real_capstone_inbound_first_in_V2` does
not depend on any axioms.

**ZERO `Real.pi_transcendental` dependency. ZERO new axioms. ZERO
HermitePadé research-axiom dependency.**

## Hit-count vs orphan target

The W4.6 file forges inbound APPLIES edges into Vindemiatrix's
`dirac_f_spectrum_real_unified_capstone` from at least 9 distinct
substrate-side declarations:

- Nessus W1.5: `standardD_F_spectrum_collapses`,
  `DiracOperatorF_yoneda_witness_fourfold`,
  `standardD_F_eigenvalues_zero`.
- Titan W1.3: `substrate_budget_at_least_two`.
- Rasalhague (read-only): `electronD_F_isHermitian`,
  `upQuarkD_F_isHermitian`, `downQuarkD_F_isHermitian`,
  `neutrinoD_F_isHermitian`,
  `hermitian_complex_spectrum_elt_im_zero` (Vindemiatrix's helper).

Comfortably clears the briefing's "inbound capping is HIGH priority"
threshold (rerank 0.85).

## Build errors during landing (3, all fixed)

1. Theorem-name `SEC_dirac_F_spectrum_real_capstone_inbound_via_DF_eigenvalues`
   used as Prop term in implication antecedent — Lean error: "type expected,
   got proof". Fix: spelt out the conjunction explicitly as the hypothesis.
2. Same issue with `dirac_f_spectrum_real_unified_capstone` as Prop term in
   conjunction. Fix: replaced with explicit four-conjunct conclusion.
3. Cascading `Tactic introN failed` after the term-Prop errors. Fix:
   reformulated the affected theorem to take an explicit hypothesis term.

## Guardrails respected

NO edits to:
- All 22 W1+W2+W3 wave files (especially Nessus W1.5
  `Foundations/DiracOperatorFDoubleWitness.lean` and Titan W1.3
  `Emergence/ConnesDFYukawaPaperBundleInbound.lean` — READ-ONLY,
  IMPORT only).
- All W4 sister wizards (W4.1 Pinwheel HiggsMassHierarchy, W4.3 Pluto
  BaryogenesisLeptogenesis, W4.4 Veil DE→baby-universe, W4.5 Electroweak
  unification, W4.7 Proteus Correspondence).
- All cycle 52-60 wizard files (especially `Emergence/DiracFSpectrum*.lean`
  and `Emergence/DiracFSpectrumReal.lean` — Vindemiatrix's existing
  capstone file — READ-ONLY, IMPORT only).
- `Foundations/ConnesDFEigenvalues*.lean` (if present, READ-ONLY).
- `Basic.lean` (parent owns batch).

## Basic.lean import line for parent batch

```
import OmegaTheory.Emergence.DiracFSpectrumRealCapstoneInbound
```

Suggested grouping: after the Vindemiatrix `DiracFSpectrumReal` import
block, near the cycle-4 Connes-pathway imports.

## md5

`5711e62ef4bef6ac5c6117e5b6ab7f8c` (matches `~/lean-v2` ↔ `/mnt/c`).

## Reservation

- `:ReservedName Dione` claimed via local agent_memory.
- `:TheoremCandidate SEC_dirac_F_spectrum_real_capstone_inbound_via_DF_eigenvalues`
  ready to flip PROPOSED→CLOSED_BY_LEAN_LANDING in next Phase C refresh.

## Off-limits respected (recap)

`Foundations/DiracOperatorFDoubleWitness.lean` (Nessus W1.5),
`Emergence/ConnesDFYukawaPaperBundleInbound.lean` (Titan W1.3),
`Emergence/DiracFSpectrumReal.lean` (Vindemiatrix cycle 4),
`Emergence/DiracFSpectrum.lean` (Rasalhague),
`Emergence/YukawaMatrix.lean`, `Basic.lean`, all 22 W1+W2+W3 wave files,
all 6 active W4 sister wizards, all cycle 52-60 wizard files.
