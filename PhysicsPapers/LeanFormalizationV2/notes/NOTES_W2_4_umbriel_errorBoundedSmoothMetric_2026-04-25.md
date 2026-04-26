# NOTES — W2.4 Umbriel — `L4_errorBoundedSmoothMetric_yoneda_zero_eig_double_witness_paper_bundle`

**Cycle**: 61 (Capricornus) · **Wave**: 2 · **Slot**: W2.4 · **Date**: 2026-04-26 · **Agent**: Umbriel (Uranus II)
**Source brief**: Capricornus L4 #2 (rerank 0.962, HIGH).
**Reference pattern**: Nessus W1.5 `DiracOperatorFDoubleWitness.lean` (concrete physics Structure).

## File landed
`OmegaTheory/Foundations/ErrorBoundedSmoothMetricDoubleWitness.lean` (~370 lines)
- **md5**: `73821b5cf7a739263ffd13325b8af91c` (matches `~/lean-v2` ↔ `/mnt/c`)
- **Build**: 3,291 jobs GREEN single-module (2.0s on `~/lean-v2`, +1 over baseline 3,290)
- **0 sorry · 0 new axioms**

## Headlines + axioms
All headlines depend on `[propext, Classical.choice, Quot.sound]` ONLY (Lean core).
The frontier marker depends on NO axioms.

| Headline | Axioms |
|---|---|
| `L4_errorBoundedSmoothMetric_yoneda_zero_eig_double_witness_paper_bundle` | `[propext, Classical.choice, Quot.sound]` |
| `L4_errorBoundedSmoothMetric_yoneda_zero_eig_double_witness_sevenfold` | `[propext, Classical.choice, Quot.sound]` |
| `L4_errorBoundedSmoothMetric_double_witness_frontier_first_in_V2` | NONE |
| `sharp_witness_difference_zero` | `[propext, Classical.choice, Quot.sound]` |
| `real_zero_pert_difference_zero` | `[propext, Classical.choice, Quot.sound]` |
| `minkowskiEBHPWMetric_difference_zero` | `[propext, Classical.choice, Quot.sound]` |
| `minkowskiEBHPWReal_difference_zero` | `[propext, Classical.choice, Quot.sound]` |
| `sharp_to_real_zero_pert_witness` | `[propext, Classical.choice, Quot.sound]` |

## Strategy — abstract-Structure analog of Nessus W1.5

Nessus W1.5 lands the L4 double-witness on a **concrete physics Structure** (Connes' `DiracOperatorF` — `standardD_F` placeholder with zero eigenvalues + four `_packed` Yoneda witnesses for SM species).

Umbriel W2.4 lands the **same shape** on the **abstract Foundations Structures** (`ErrorBoundedSmoothMetric` and `ErrorBoundedSmoothMetricReal` from `Geometry/`):

| Side | Nessus W1.5 (concrete) | Umbriel W2.4 (abstract) |
|---|---|---|
| **(S) spectral isolation** | `standardD_F.eigenvalues g = 0` | `g.g_discrete N x μ ν - g.g_smooth x μ ν = 0` for sharp-witness instances |
| **(S-out) abs-flux out** | `\|standardD_F.eigenvalues g\| = 0` | `\|g.g_discrete N x μ ν - g.g_smooth x μ ν\| = 0` |
| **(S-in) abs-flux in** | `yukawa_from_D_F standardD_F` reduces to species default | `\|g.g_smooth x μ ν - g.g_discrete N x μ ν\| = 0` |
| **(W) Yoneda existence** | 4 species `_packed` witnesses (`electronD_F_packed`, etc.) | 7 sharp-witness HPW regimes (Minkowski, Linearised, Schwarzschild, FRW, Bianchi I, de Sitter, Kerr) + substantive Minkowski |
| **(D) double conjunction** | `DiracOperatorF_yoneda_zero_eig_double_witness` | `L4_errorBoundedSmoothMetric_yoneda_zero_eig_double_witness_paper_bundle` |
| **(W-fold) tighter form** | fourfold (4 SM species) | sevenfold (7 HPW regimes) + 1 substantive |

The empirical claim from Capricornus L4 #2 (`total_in = 0 ∧ total_out = 0 ∧ rank_2_eigenvalue_contribution = 0`) is realised by:
1. Sharp-witness instances (`constEBHPW M`) where `g_discrete := g_smooth`.
2. Real-EBHPW instances with `g_perturbation := 0` (Adhara `ofSharpWitness`).

Both patterns yield zero discrete-smooth difference, the abstract-Structure analog of zero eigenvalue.

## Cross-Structure bridge
Two bridge theorems link the sharp-witness ↔ substantive Real-EBHPW Structures:
- `sharp_to_real_zero_pert_witness`: every sharp-witness lifts to a real-EBHPW with zero perturbation.
- `sharp_to_real_round_trip_g_discrete`: the lifted real-EBHPW has the same discrete metric as the sharp original.

These extend the double-witness across the bridge — together with the universally-quantified theorem-application witnesses (`christoffelApproxBound_holds` for the sharp side, `g_approx_bound` for the substantive side), they form a Witness-Yoneda completion at the Foundations layer.

## Build details
- Reuses `ErrorBoundedSmoothMetric` (`g_smooth`, `g_discrete`, fields), `ErrorBoundedSmoothMetricReal` (`g_smooth`, `g_perturbation`, derived `g_discrete`, `g_discrete_component`), `minkowskiEBHPWMetric`, `minkowskiEBHPWReal`, `constEBHPW_sharp`, `minkowskiEBHPWReal_perturbation_zero`, `ChristoffelApproxBound`, `christoffelApproxBound_holds`, `ErrorBoundedSmoothMetricReal.ofSharpWitness`, `ofSharpWitness_perturbation_zero`, `ofSharpWitness_g_discrete_eq` (all read-only).
- Imports: `Geometry.ErrorBoundedSmooth`, `Geometry.ErrorBoundedSmoothReal`, `Irrationality.Uncertainty` (for `computationalUncertainty`), `Mathlib.Tactic`.
- One initial build error fixed: `computationalUncertainty` not in scope without `Irrationality.Uncertainty` import + `open OmegaTheory.Irrationality`.

## Off-limits respected
- NO edits to `ErrorBoundedSmooth.lean`, `ErrorBoundedSmoothReal.lean`, `ErrorAlgebra.lean` (Geometry/Foundations base).
- NO edits to W1.5 `DiracOperatorFDoubleWitness.lean` (Nessus reference, READ-ONLY).
- NO edits to sister W2.* files (W2.3 `ErrorBoundYonedaWitness.lean` not yet landed; distinct Structure `ErrorBound`, no overlap).
- NO edits to W1.* sister wizard files (W1.1 PiTranscendentalBlastRadiusBundle, W1.2 OmegaSubstrateYonedaFullCapstone, W1.3 ConnesDFYukawaPaperBundleInbound, W1.4 CosmologicalConstantH1Bridge, W1.5 DiracOperatorFDoubleWitness, W1.6 LatticePointUniversalBaseSiteDominance, W1.7 FermionGenerationCompositeBaseSiteWitness).
- NO edits to all cycle 52-60 wizard files.
- DID NOT EDIT `Basic.lean` — flagged for parent batch:
  ```
  import OmegaTheory.Foundations.ErrorBoundedSmoothMetricDoubleWitness
  ```

## Significance
First L4 double-witness in OV2 anchored on **abstract Foundations Structures** rather than physics-side Structures. With Nessus W1.5 covering the concrete-physics layer (`DiracOperatorF`), this file completes the L4 cross-layer pattern: every empirical "spectral isolation × Yoneda witness" double-witness from the 4-sage synthesis now has a Lean home.

The substantive bridge theorems (`sharp_to_real_zero_pert_witness`, `sharp_to_real_round_trip_g_discrete`) elevate the result above static Yoneda completion — the double-witness extends naturally across the sharp ↔ substantive Real-EBHPW projection, matching Adhara/Izar's Composition (not Inheritance) design from cycle-44.
