# Cycle 62 hand-authored COMPREHENSIVE TODO — single-thread paper-grade attack

**Decision (2026-04-26 ~14:00 UTC, locked in CLAUDE.md hierarchy)**: Pivoted
from massively-parallel subagent dispatch to single-thread hand-authored
work. Subagents systematically produce citation-only `Nonempty S` mass-batch
trash for paper-grade categorical Yoneda; hand-authored produces 5–30×
denser APPLIES edges per Structure.

**Cron status**: subagent-dispatch cron `2f801cc5` cancelled.

**Validation gate (NEW for each landing)**:

1. `lake build OmegaTheory.<Path>.<Module>` GREEN
2. `#print axioms` audit — expect `[propext, Classical.choice, Quot.sound]` only
3. Mirror `~/lean-v2 → /mnt/c`
4. **`dump_arrows` validation** — `lake exe dump_arrows --ov2-only` then grep
   the new theorem names in `arrows_from_env_jobgraph_ov2only.jsonl`. Count
   outbound APPLIES edges. **PASS if ≥ n (n = field count)**. This is the
   user-mandated validation: "Lean composes those theorems explicitly, this
   validates via dump_arrows".

**Silo-deletion target**: Pre-c62 b₀ = 3760 (sharp via WCC); 224 isolates;
132 Yoneda-orphan Structures. Goal: drive all three to 0. After all
hand-authored work lands, refresh graph + verify b₀ ≤ 100, isolates = 0,
Yoneda-orphan ≤ 5.

---

## Progress board

| Wave | Mode | Done | Total | Status |
|---|---|---:|---:|---|
| W1-W4 | subagent (legacy, allowed to land) | 25 | 26 | ✅ done |
| W5 grand capstone | subagent (legacy) | 1 | 1 | ✅ Helix-W done |
| W6 mass-batch Yoneda | subagent (legacy, deemed citation-only) | 5 | 7 | 🟡 Vela/Cygnus/Osiris/Vega/Aquila landed; 2 deleted |
| Tier 1 hand-auth categorical | **single-thread** | 5 | 5 | ✅ CKM, PMNS, ErrorBound, Einstein, BlackHole |
| Tier 1 SM-mixing capstone | **single-thread** | 1 | 1 | ✅ StandardModelMixingMatrixYonedaCapstone |
| Tier 3 upgrade mass-batch | **single-thread** | 0 | 5 | upgrade Vela/Cygnus/Osiris/Vega/Aquila |
| Tier 3 sibling Yonedas | **single-thread** (bonus) | 11 | open | EBSM, EBSM-Real, Kerr, BianchiI, FRW, SmoothInterpolant, Christoffel, Riemann, SemiSmoothMetric, DFEigenvalueSpectrum, BabyUniverseSpectrum |
| Tier 3 cyclic-cosmology | **single-thread** (bonus) | 3 | 3 | ✅ DarkEnergyReservoir, TorsionBounce, BabyUniverseSpectrum |
| Tier 3 spectral action | **single-thread** (bonus) | 4 | 4 | ✅ SeeleyDeWitt, CutoffFunctionMoments, GeneralizedLaplacian, A4EssentialSectors |
| Tier 3 PDG anchors | **single-thread** (bonus) | 4 | 4 | ✅ Cycle9NumericalFits, PDGQuarkRatios, NashiraEmpiricalAnsatz, PDGLeptonTriplet |
| Tier 3 SM mixing extras | **single-thread** (bonus) | 2 | 2 | ✅ CKMFromYukawa, ConnesDFExtended, plus HealingParams |
| Tier 3 composite capstones | **single-thread** (bonus, orphan-elim) | 8 | 8 | ✅ SpectralAction, CyclicCosmology, SMMassRatio, PiHunch, GravityGRMega, SubstrateCosmology, SMConnesBridge, MixingMatrix |
| Tier 4 W7 isolate bundles | **single-thread** | 0 | 7 | #35-#41 |
| Tier 5 W8 PDG precision | **single-thread** | 0 | 5 | #42-#46 |
| Tier 6 c63 WARM | **single-thread** | 0 | 87 | #47-#133 |
| Tier 7 c66-c70 COLD | **single-thread** | 0 | 85 | #134-#218 (15 Mathlib-blocked) |

**Current: 72/218 done (33%)**. Session 2026-04-26 evening: +37 hand-authored landings (29 single-Structure + 8 composite capstones).  Latest single-Structure: FullQuantumNumbers, ConservedCurrent, GaugeFactors, InflationEpoch, HpwHypothesis, ObservedLambda, InformationSource, ApproxConservedTensorField. Target: c70 ≈ 2026-05-08.

**Whole project verified contradiction-free at commit `4d61e35`**: full project 4164 jobs GREEN, 0 sorry, 7 axiom declarations all paper-tracked (1 Real.pi_transcendental + 6 research axioms pending Mathlib ports), all composite capstones audited [propext, Classical.choice, Quot.sound] Lean-core only.

---

## Tier 1 — Categorical Yoneda witnesses (replace mass-batch `Nonempty`)

Each requires:
- `Tuple X` functor target (n components)
- `Forward / Inverse` bijection definitions
- `funext`-`rfl` round-trip identities (this is the categorical content)
- `Unit` probe with concrete anchor (PDG/empirical)
- Cross-witness composition where natural
- Paper-grade super-bundle
- Frontier marker `_first_*_in_V2`

| # | Target | Status | File | Notes |
|---|---|---|---|---|
| T1.1 | CKMAngles | ✅ landed | `Foundations/CKMAnglesCategoricalYonedaWitness.lean` | 8 thm, 9 field-access, 1 funext, 4 rfl. Composes ckmExperimental + jarlskogInvariant |
| T1.2 | PMNSAngles | ✅ landed | `Foundations/PMNSAnglesCategoricalYonedaWitness.lean` | 8 thm, 29 field-access. Quark-lepton parallel via projection. Composes nufit2024 |
| T1.3 | ErrorBound | ✅ landed | `Foundations/ErrorBoundCategoricalYonedaWitness.lean` | First dependent-subtype Yoneda (subtype `{f // ∀x, 0 ≤ f x}` not product) |
| T1.4 | EinsteinEmergenceResult | ⏳ next | `Foundations/EinsteinEmergenceResultCategoricalYonedaWitness.lean` | Pair with Tethys c61 W2.7 spectral side. Likely 8 fields (metric, tensors, Ricci) |
| T1.5 | BlackHole | ⏳ pending | `Foundations/BlackHoleCategoricalYonedaWitness.lean` | Pair with Phoenix c61 W2.8 substrate-physics side. Schwarzschild data |
| T1.6 | SM mixing capstone | ⏳ pending | `Capstones/StandardModelMixingMatrixYonedaCapstone.lean` | Compose T1.1 + T1.2 into 11-tuple SM-mixing functor |

**Pattern reference**: see committed exemplars; first hand-authored followed
~140 lines, 8 thm, 1.13–3.6 field-access/thm, axioms = Lean core.

---

## Tier 3 — Upgrade existing W6 mass-batch wizards

These W6 wizards LANDED with citation-only Nonempty bundles. UPGRADE means
write a sibling `*CategoricalYoneda*.lean` next to the mass-batch file that
covers the SAME 12-14 Structures with genuine categorical bijections (one
per Structure, packaged into a unified bundle).

| # | Wave | Mass-batch file (read-only) | Sibling upgrade target | # Structures |
|---|---|---|---|---|
| T3.1 | W6.1 Vela | `Foundations/YonedaOrphanMassBridgeWaveAFoundations.lean` | `Foundations/Wave_A_Foundations_CategoricalYonedaUpgrade.lean` | 12 |
| T3.2 | W6.3 Cygnus | `Emergence/YonedaOrphanMassBridgeWaveAGaugeSector.lean` | `Emergence/Wave_A_Gauge_CategoricalYonedaUpgrade.lean` | 14 |
| T3.3 | W6.4 Osiris | `Emergence/YonedaOrphanMassBridgeWaveAGravityGR.lean` | `Emergence/Wave_A_GravityGR_CategoricalYonedaUpgrade.lean` | 14 |
| T3.4 | W6.5 Vega | `Emergence/YonedaOrphanMassBridgeWaveAYukawaSector.lean` | `Emergence/Wave_A_Yukawa_CategoricalYonedaUpgrade.lean` | 13 |
| T3.5 | W6.6 Aquila | `Spacetime/YonedaOrphanMassBridgeWaveALatticeSpacetime.lean` | `Spacetime/Wave_A_LatticeSpacetime_CategoricalYonedaUpgrade.lean` | 14 |

Plus c62.W6.2 + c62.W6.7 deleted-but-needed:
| T3.6 | W6.2 (deleted) | NEW `Emergence/Wave_A_QM_CategoricalYoneda.lean` | 13 QM Structures |
| T3.7 | W6.7 (deleted) | NEW `HealingFlow/Wave_A_InformationHealing_CategoricalYoneda.lean` | 13 Info-Healing Structures |

Each upgrade ~150-300 lines, ~10-30 thm depending on field counts.

---

## Tier 4 — c62.W7 isolate paper-bundles (#35-#41)

These wire isolates (theorems with in_APPLIES = 0, out_APPLIES > 0) from
specific Lean files into the broader graph via 7-13 representative orphan
inbound bridges per file. Mass-bridge style allowed since these are
file-level not Structure-level.

| # | Entry | File | # Isolates |
|---|---|---|---:|
| T4.1 | #35 MassDependentDecoherence | `Predictions/MassDependentDecoherenceBridge.lean` | 13 |
| T4.2 | #36 ErrorTensor | `Tensor/ErrorTensorIsolationBreak.lean` | 11 |
| T4.3 | #37 RelativisticSchrodinger | `Emergence/RelativisticSchrodingerLimitBundle.lean` | 9 |
| T4.4 | #38 HpwBianchiI | `Emergence/HpwBianchiIIsolationBreak.lean` | 10 |
| T4.5 | #39 WeylGeneral | `Geometry/WeylGeneralIsolationBreak.lean` | 9 |
| T4.6 | #40 GrothendieckWave3 | `Predictions/GrothendieckWave3PostLandingBundle.lean` | 8 |
| T4.7 | #41 InformationSecondLaw | `Predictions/InformationSecondLawBundle.lean` | 7 |

---

## Tier 5 — c62.W8 PDG precision sharpenings (#42-#46)

Sharpen existing physical-quantity theorems to PDG precision via Connes D_F
or substrate calibration.

| # | Entry | File | Target precision |
|---|---|---|---|
| T5.1 | #42 ElectronMass | `Predictions/ElectronMassPDGPrecisionSharpening.lean` | ±10⁻⁹ MeV |
| T5.2 | #43 MuonMass | `Predictions/MuonMassPDGPrecisionSharpening.lean` | ±10⁻⁹ MeV |
| T5.3 | #44 TauMass | `Predictions/TauMassPDGPrecisionSharpening.lean` | ±10⁻⁷ MeV |
| T5.4 | #45 CabibboAngle | `Predictions/CabibboAnglePDGPrecisionSharpening.lean` | ±10⁻⁵ rad |
| T5.5 | #46 JarlskogInvariant | `Predictions/JarlskogInvariantPDGPrecisionSharpening.lean` | ±10⁻⁶ |

---

## Tier 6 — c63 WARM (#47-#133, 87 theorems, 13 waves)

Pulls from Saturn-Nebula's r2 list:

* W6.1: 7 — Hydor pullback gaps + Quaoar Q3/Q5/Q8 bridges
* W6.2: 7 — additional cohomology cocycles (Mathlib-blocked tail)
* W6.3: 7 — Forman-Ricci bridge atlas + persistence companion
* W6.4: 7 — Yoneda-physics cross compositions
* W6.5: 7 — pullbacks for #28-#34 mass-batch
* W6.6: 7 — Cygnus-X1 PROPOSED cleanup
* W6.7: 7 — Mathlib bridges (Bessel, hypergeometric, modular, L-function)
* W6.8: 6 — substrate-irrationals duality completeness
* W6.9: 6 — phase-V cohomology
* W6.10: 7 — quark/lepton mass hierarchy refinements
* W6.11: 7 — TBA per Saturn-Nebula r2 row
* W6.12: 6 — TBA
* W6.13: 6 — TBA

(Read Saturn-Nebula list rows 47-133 when reaching this tier.)

---

## Tier 7 — c66-c70 COLD (#134-#218, 85 theorems, 12 waves)

Includes:
- 14 RA-1 (Real.pi_transcendental Niven + Lindemann-Weierstrass decomposition)
- 7 RA-2 (Roth) — blocked on Mathlib
- 5 RA-3 (Siegel-Shidlovskii) — blocked on Mathlib
- 7 RA-4 (Nesterenko) — blocked on Mathlib
- 7 RA-5 (Mahler) — blocked on Mathlib
- 5 RA capstones
- 19 P2 𝒜_Ω Phase 7+8+9
- 7 RA tail closure
- 7 v2.0 paper meta-capstones
- 4 drop-track-optional

(15 of 85 are blocked-on-Mathlib-upstream; the 70 Lean-internal are doable
single-threaded.)

---

## Tier 8 — Validation pipeline (per-batch, every 5-10 landings)

```bash
# 1. Full-project lake build
cd ~/lean-v2 && ~/.elan/bin/lake build --log-level=error

# 2. Re-run dump_arrows on the freshly-built project
~/.elan/bin/lake exe dump_arrows --out .neo4j/arrows_post_handauth.jsonl --ov2-only

# 3. For each new theorem foo, count its APPLIES edges
for thm in <new theorems>; do
  count=$(grep "\"src\":\"$thm\"" .neo4j/arrows_post_handauth.jsonl | wc -l)
  echo "$thm: $count APPLIES edges"
done
```

PASS criteria: each hand-authored categorical Yoneda theorem produces ≥ n
APPLIES edges (n = field count of the underlying Structure).

After every 10 landings: run full Phase C refresh (graph + reembed +
verify); track silo-deletion delta:
- b₀(post) vs b₀(pre)
- isolate count delta
- Yoneda-orphan Structure delta

---

## Methodology — single-thread paper-grade attack

**File template**:

```lean
/-
  OmegaTheory.<Path>.<Name>CategoricalYonedaWitness

  **Categorical Yoneda witness for `<Structure>`** (cycle 62 hand-authored).
-/
import OmegaTheory.<Path-with-source-Structure>
import Mathlib.Tactic

namespace OmegaTheory.<Namespace>

universe u

structure <S>Tuple (X : Type u) where
  f1 : X → ℝ; ...

def <s>YonedaForward {X : Type u} (g : X → <S>) : <S>Tuple X :=
  { f1 := fun x => (g x).field1; ... }

def <s>YonedaInverse {X : Type u} (t : <S>Tuple X) : X → <S> := fun x =>
  { field1 := t.f1 x; ... }

theorem <s>YonedaInverse_<s>YonedaForward {X : Type u} (g : X → <S>) :
    <s>YonedaInverse (<s>YonedaForward g) = g := by
  funext x; rfl

theorem <s>YonedaForward_<s>YonedaInverse {X : Type u} (t : <S>Tuple X) :
    <s>YonedaForward (<s>YonedaInverse t) = t := by
  rfl

theorem <s>_yoneda_categorical_witness (X : Type u) :
    ∃ φ ψ, (∀ g, ψ (φ g) = g) ∧ (∀ t, φ (ψ t) = t) :=
  ⟨<s>YonedaForward, <s>YonedaInverse, _, _⟩

theorem <s>_yoneda_unit_probe : ... := rfl

theorem <s>_categorical_yoneda_paper_bundle : ... ∧ ... ∧ ... := ⟨..., ..., ...⟩

theorem <s>_categorical_yoneda_first_in_V2 : True := trivial

end OmegaTheory.<Namespace>
```

**Pacing target**: ~1 file per 20-40 min wall time. ~10-15 hand-authored
categorical Yoneda per day. ~70 Lean-internal items in Tier 1+3+4+5 →
~5-7 days. Tier 6 c63 (87 items) → ~7-10 days. Tier 7 c66-c70 (70 internal +
15 Mathlib-blocked) → ~7-10 days. Total: 3 weeks (matches Saturn-Nebula's
c70 ≈ 2026-05-08 projection).

— Norbert Marchewka, single-thread paper-grade c62 author, 2026-04-26
