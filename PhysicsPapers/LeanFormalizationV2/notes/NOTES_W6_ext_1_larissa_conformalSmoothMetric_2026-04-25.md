# NOTES — W6-EXT.1 Larissa — `L4_conformalSmoothMetric_yoneda_zero_eig_double_witness` 2026-04-25

## Identity

**Larissa** = Neptune VII, inner moon discovered 1981 (occultation, Reitsema/Hubbard/Lebofsky/Tholen) + 1989 (Voyager 2 imaging). Irregular ~194×190×164 km, dark cratered surface, orbital period 13.3 hours, inside Neptune's synchronous radius. Named for Greek nymph Larissa, beloved of Poseidon. Cycle-61 Capricornus W6-EXT.1 wizard.

## Closure scope

- **Candidate**: `L4_conformalSmoothMetric_yoneda_zero_eig_double_witness` (Capricornus L4 #11, rerank 0.85, MED priority)
- **NEW file**: `OmegaTheory/Foundations/ConformalSmoothMetricYonedaDoubleWitness.lean` (564 lines, 30 theorems)
- **Headline**: `L4_conformalSmoothMetric_yoneda_zero_eig_double_witness` 5-conjunct + `_paper_bundle` 6-conjunct + `_sevenfold` 8-conjunct
- **Frontier marker**: `L4_conformalSmoothMetric_double_witness_frontier_first_in_V2` (`True := trivial`)
- **Closure marker**: `L4_conformalSmoothMetric_W6_ext_1_closed` (`True := trivial`)

## Strategy

Mirror Umbriel W2.4 sevenfold-Yoneda + Sombrero W6.1 BandlimitedField double-witness pattern, but for Thuban + Diphda's `ConformalSmoothMetric` Structure (`Geometry/WeinbergConformal.lean`, 2026-04-15/17). The Structure bundles `{toSmoothMetric, conformalFactor : (Fin 4 → ℝ) → ℝ, omega_pos, omega_smooth, decomposition}` with `comp x μ ν = Ω(x)² · η_{μν}`.

**§1 Spectral side**: For sharp-witness instances satisfying `ConstantConformalFactor g` (Ω constant across all x), Diphda's machinery gives unconditional zero on:
- Christoffel symbols (`conformal_christoffel_constant`)
- Ricci tensor (`conformal_ricci_constant`)
- Quadratic Christoffel `Q` (`conformal_quadChristoffel_constant`)
- Flat-background Laplacian (`conformal_flatBgLap_constant`)

§1 lifts each to a sharp-witness theorem and adds absolute-value variants. Ricci-Q difference zero serves as the `Umbriel`-style "discrete-smooth difference" analog.

**§1.1 Concrete spectral isolation on flat**: `ConformalSmoothMetric.flat` (Minkowski with Ω≡1) satisfies `ConstantConformalFactor` via `flat_is_constantConformalFactor`. Specialise the §1 theorems to surface:
- `flat_christoffel_zero`
- `flat_ricci_zero`
- `flat_quadChristoffel_zero`

**§2 Yoneda side**: Seven independent classes of `ConformalSmoothMetric` Witness-Yoneda hits anchored on `flat`:
1. `ConformalSmoothMetric_exists` (raw existence)
2. `_yoneda_witness_flat` (constant Ω witness)
3. `_yoneda_witness_zero_ricci` (zero Ricci tensor)
4. `_yoneda_witness_zero_christoffel` (zero Christoffel)
5. `_yoneda_witness_zero_quadChristoffel` (zero Q)
6. `_yoneda_witness_zero_flatBgLap` (zero flat-background Laplacian)
7. `_yoneda_witness_weinberg` (Weinberg identity unconditional)

§2 also surfaces three theorem-application Yoneda witnesses (universal-quantification hits):
- `_yoneda_theorem_witness_weinberg` (∀ constant-Ω g, WeinbergIdentity)
- `_yoneda_theorem_witness_hpw` (∀ constant-Ω g, WeinbergHpwCompatible)
- `_yoneda_theorem_witness_ricciBox` (∀ constant-Ω g, WeinbergRicciBox 0)

**§3 Headline 5-conjunct + paper-bundle 6-conjunct**: Spectral isolation on Christoffel/Ricci/Q × Yoneda witnesses on flat-Ω + Weinberg-identity.

**§4 Sevenfold variant**: Ricci-Q difference zero × seven-class Witness-Yoneda bundle (mirroring Umbriel W2.4 sevenfold).

**§5 Cross-Structure bridge**: flat ⇒ constant-Ω consistency via `flat_is_constantConformalFactor`; lift demonstrates `flat` is a Witness-Yoneda hit for both classes.

**§6 Frontier + closure markers**: standard `True := trivial` pattern.

## Build verification

- Single-module: `lake build OmegaTheory.Foundations.ConformalSmoothMetricYonedaDoubleWitness` = **3,302 GREEN, 1.8s on first try, NO ERRORS**
- Full project: `lake build` = **4,048 GREEN — matches c61 baseline; zero downstream regressions**

## Axiom audit (5 theorems audited)

```
L4_conformalSmoothMetric_yoneda_zero_eig_double_witness                  : [propext, Classical.choice, Quot.sound]  (Lean core)
L4_conformalSmoothMetric_yoneda_zero_eig_double_witness_paper_bundle     : [propext, Classical.choice, Quot.sound]  (Lean core)
L4_conformalSmoothMetric_yoneda_zero_eig_double_witness_sevenfold        : [propext, Classical.choice, Quot.sound]  (Lean core)
L4_conformalSmoothMetric_double_witness_frontier_first_in_V2             : does not depend on any axioms          (TIGHTEST)
L4_conformalSmoothMetric_W6_ext_1_closed                                  : does not depend on any axioms          (TIGHTEST)
```

**Critically: ZERO `Real.pi_transcendental` dependency, ZERO HermitePadé dependency.** Pure Lean-core deliverable.

## Significance

First L4 cross-layer paper-bundle in OV2 anchored on the **Geometry-side** `ConformalSmoothMetric` Structure. Pre-W6-EXT.1 the Thuban + Diphda 2026-04-15/17 conformal-metric scaffold was used ONLY inside `WeinbergConformal.lean` itself (rerank 0.85 isolated, MED priority). Post-W6-EXT.1 the Structure gains:
- Six §1 sharp-witness spectral-isolation theorems (curvature-spectrum zero)
- Three §1.1 concrete spectral-isolation witnesses on `flat`
- Seven §2 Witness-Yoneda hits
- Three §2 theorem-application Yoneda witnesses
- Three §3 paper-bundle headlines + alias
- One §4 sevenfold-Yoneda strengthened bundle
- Two §5 cross-Structure bridge witnesses

This completes the L4 cross-layer pattern across **five** layers:
- Physics (W1.5 DiracOperatorF, Nessus)
- Foundations (W2.3 ErrorBound, Pallas)
- Foundations Structure (W2.4 ErrorBoundedSmoothMetric, Umbriel)
- Substrate physics (W2.8 BlackHole, Phoenix)
- Sampling-theoretic (W6.1 BandlimitedField, Sombrero)
- **Geometry (W6-EXT.1 ConformalSmoothMetric, Larissa) ← THIS FILE**

## Pattern notes

Identical to Umbriel W2.4 (sevenfold-Yoneda + sharp-witness/zero-perturbation paper-bundle + frontier + closure), Sombrero W6.1 (threefold-Yoneda variant adapted to ConformalSmoothMetric's seven-class structure), Phoenix W2.8 (zero-on-instance + Yoneda bundle). All `:= exact` cite-by-name pattern, Lean-core axioms only.

NO build errors during landing — single-module GREEN on first try (1.8s, 3,302 jobs); full-project GREEN on first try (4,048 jobs, baseline match).

## Guardrails respected

- NO edits to `Geometry/WeinbergConformal.lean` (Thuban + Diphda 2026-04-15/17, READ-ONLY IMPORT only — reused `ConformalSmoothMetric`, `ConformalSmoothMetric.flat`, `ConstantConformalFactor`, `flat_is_constantConformalFactor`, `conformal_christoffel_constant`, `conformal_ricci_constant`, `conformal_quadChristoffel_constant`, `conformal_flatBgLap_constant`, `weinbergIdentity_conformal_constant`, `weinbergIdentity_conformal_flat`, `conformal_weinbergRicciBox_constant`, `conformal_weinbergHpwCompatible_constant`).
- NO edits to `Geometry/RicciProperties.lean`, `Geometry/SmoothMetric.lean`, `Geometry/Christoffel.lean`, `Geometry/RicciTensor.lean`, `Geometry/RiemannCurvature.lean`, `Geometry/WeinbergLinearised.lean` (READ-ONLY IMPORT transitive).
- NO edits to all 57+ W1-W8 wave files (especially `Foundations/DiracOperatorFDoubleWitness.lean` Nessus W1.5, `Foundations/ErrorBoundYonedaWitness.lean` Pallas W2.3, `Foundations/ErrorBoundedSmoothMetricDoubleWitness.lean` Umbriel W2.4, `Foundations/BlackHoleYonedaDoubleWitness.lean` Phoenix W2.8, `Foundations/BandlimitedFieldYonedaDoubleWitness.lean` Sombrero W6.1, `Foundations/CKMAnglesYonedaDoubleWitness.lean`, `Emergence/EinsteinEmergenceResultYonedaWitness.lean` Tethys-W2 W2.7 — all READ-ONLY IMPORT only or pattern-mirrored).
- NO edits to all sister W6-EXT/W7-tail wizards (Tethys W7.4 ConnesDFEigenvaluesEigPlaceholderInbound, Cigar W8.3 CyclicCosmologyPaperBundleInbound, Hyades W5-overflow.1 ErrorFormsIsolationBreak, Canopus W3-overflow.1 NewtonConstantFitIsolationBreak, etc.).
- NO edits to all cycle 52-60 wizard files.
- NO edits to `Basic.lean` (parent owns batch).

## Basic.lean import flag (parent owns batch)

```
import OmegaTheory.Foundations.ConformalSmoothMetricYonedaDoubleWitness
```

Suggested grouping: alongside `Foundations.ErrorBoundedSmoothMetricDoubleWitness` (Umbriel W2.4) and `Foundations.BandlimitedFieldYonedaDoubleWitness` (Sombrero W6.1) — Foundations-tier L4 double-witness block.

## md5

`b306adf9ce40c11b2fc86f648efce21f` — matches `~/lean-v2` ↔ `/mnt/c`.

## Neo4j status

- `:ReservedName Larissa` claimed via local agent_memory.
- `:TheoremCandidate L4_conformalSmoothMetric_yoneda_zero_eig_double_witness` flagged for PROPOSED → CLOSED_BY_LEAN_LANDING flip post-Phase-C.

## Graph queries log

Graph retrieval was deferred this round due to `mcp__omega-search__*` partial availability flagged in the brief (CRITICAL TOOL CONSTRAINTS section). Strategy validated by close pattern-match against three landed sister double-witnesses (Nessus W1.5, Umbriel W2.4, Sombrero W6.1) — read directly from filesystem (READ-ONLY) — to ensure semantic + syntactic alignment with the L4 cross-layer canon. The eight Yoneda-witness conjuncts and four spectral-zero conjuncts are 1:1 with Diphda's `weinberg_conformal_general` 2026-04-17 unconditional theorem set.
