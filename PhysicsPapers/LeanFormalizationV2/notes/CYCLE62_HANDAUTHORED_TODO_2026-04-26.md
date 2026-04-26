# Cycle 62 hand-authored paper-grade TODO list

**Decision (2026-04-26)**: Pivoted from massively-parallel subagent dispatch to
single-thread hand-authored work. Quality > quantity. Cron job `2f801cc5`
cancelled. Subagents in flight allowed to land; no new dispatches.

**Rationale**: Mass-batch `Nonempty` Yoneda witnesses (Vega/Aquila/Cygnus/Osiris
+ stuck Vela's twin) are *citation only* — they prove a Structure has at least
one inhabitant. The categorical Yoneda lemma demands EXPLICIT COMPOSITION:
the representable functor `Hom(–, S)` is naturally isomorphic to some
explicit functor ψ.  This is paper-grade and `dump_arrows`-validated: every
field-level composition produces a real APPLIES edge.

## Progress

### ✅ Already landed (paper-grade hand-authored)

1. **`Foundations/CKMAnglesCategoricalYonedaWitness.lean`** (cycle 62 hand-authored)
   - 4-tuple Yoneda bijection `Hom(X, CKMAngles) ≃ (X → ℝ)⁴`
   - `pmns/ckmYonedaForward` + `Inverse` with explicit round-trip identities
   - Composes `ckmExperimental` (PDG anchor) + `jarlskogInvariant` (CP-violation measure)
   - Axioms: `[propext, Classical.choice, Quot.sound]` only (Lean core)
   - Frontier marker `_first_in_V2` depends on no axioms

2. **`Foundations/PMNSAnglesCategoricalYonedaWitness.lean`** (cycle 62 hand-authored)
   - 7-tuple Yoneda bijection `Hom(X, PMNSAngles) ≃ (X → ℝ)⁶ × (X → Bool)`
   - Quark-lepton parallel: `PMNSTuple → CKMTuple` projection + agreement theorem
   - Composes `PMNSAngles.nufit2024` (NuFIT 2024 anchor)
   - Axioms: `[propext, Classical.choice, Quot.sound]` only (Lean core)

## TODO (single-thread, paper-grade, hand-authored)

### Tier 1 — Categorical Yoneda witnesses (replace mass-batch `Nonempty`)

- [ ] `Foundations/EinsteinEmergenceResultCategoricalYonedaWitness.lean`
  - Pair with Tethys c61 W2.7's L4 double-witness
  - 8 ℝ-valued fields → 8-tuple bijection
  - Round-trip through `flatEinsteinEmergenceResult`
- [ ] `Foundations/BlackHoleCategoricalYonedaWitness.lean`
  - Pair with Phoenix c61 W2.8's substrate-physics double-witness
  - Round-trip through `unitBlackHole`
- [ ] `Foundations/ErrorBoundCategoricalYonedaWitness.lean`
  - 1-real + 1-prop bijection (val + nonneg)
  - Pair with Pallas c61 W2.3
- [ ] `Foundations/StandardModelMixingMatrixYonedaCapstone.lean`
  - Compose CKM + PMNS Yoneda witnesses into ONE 11-tuple SM-mixing theorem
  - 4 (CKM) + 6 (PMNS ℝ) + 1 (PMNS Bool) = 11 components
  - This is the categorical paper headline of SM mixing parametrization

### Tier 2 — Replace stuck mass-batch wizards (W6.2 + W6.7 deleted)

- [ ] `Emergence/QMSubstrateCategoricalYonedaPanel.lean`
  - Hand-author: `OmegaSubstrate`, `OmegaPostulates`, `QuantumMechanicsPostulates` — actual categorical bijections
- [ ] `HealingFlow/IsHealingFlowCategoricalCharacterization.lean`
  - Hand-author: characterization of `IsHealingFlow` predicate via constructive witness composition
  - Reuse Pandora c62.W6-ext.2 + Merope c61 W-tail.3 patterns

### Tier 3 — Audit + upgrade existing W6 mass-batch wizards

- [ ] Vela W6.1 (Foundations) → 12 Structures, mostly `Nonempty` only.
  Upgrade `ErrorBoundedSmoothMetric` to genuine categorical Yoneda
- [ ] Cygnus W6.3 (Gauge) → 14 Structures via `Nonempty`.
  Upgrade `GaugeConnection` to functorial witness on the principal fiber bundle
- [ ] Osiris W6.4 (Gravity-GR) → 14 Structures, 7 conditional Yoneda.
  Upgrade conditional 7 (KerrMetricData, BianchiI, FRW, Christoffel, Riemann)
  to concrete witnesses
- [ ] Vega W6.5 (Yukawa) → 13 Structures via `Nonempty`.
  Upgrade `CKMFromYukawa` to use new `ckmAnglesYonedaForward`
- [ ] Aquila W6.6 (Lattice-Spacetime) → 14 Structures via `Nonempty`.
  Upgrade `LatticeHilbertStructure` to functorial witness

### Tier 4 — c62.W7 isolate paper-bundles (#35-#41) hand-authored

- [ ] `Predictions/MassDependentDecoherenceBridge.lean` (#35)
- [ ] `Tensor/ErrorTensorIsolationBreak.lean` (#36)
- [ ] `Emergence/RelativisticSchrodingerLimitBundle.lean` (#37)
- [ ] `Emergence/HpwBianchiIIsolationBreak.lean` (#38)
- [ ] `Geometry/WeylGeneralIsolationBreak.lean` (#39)
- [ ] `Predictions/GrothendieckWave3PostLandingBundle.lean` (#40)
- [ ] `Predictions/InformationSecondLawBundle.lean` (#41)

### Tier 5 — c62.W8 PDG precision sharpenings (#42-#46)

- [ ] `Predictions/ElectronMassPDGPrecisionSharpening.lean` (#42)
- [ ] `Predictions/MuonMassPDGPrecisionSharpening.lean` (#43)
- [ ] `Predictions/TauMassPDGPrecisionSharpening.lean` (#44)
- [ ] `Predictions/CabibboAnglePDGPrecisionSharpening.lean` (#45)
- [ ] `Predictions/JarlskogInvariantPDGPrecisionSharpening.lean` (#46)

### Tier 6 — c63 WARM (#47-#133, 87 wizards) hand-authored

- [ ] All 87 — 13 waves of paper-grade hand-authored work

### Tier 7 — c66-c70 COLD (#134-#218, 85 wizards) hand-authored

- [ ] All 85 — including 15 blocked-on-Mathlib-upstream

### Tier 8 — Validation

- [ ] After each batch of ~10: mirror to /mnt/c, axiom audit, `lake build` full
- [ ] After each tier: refresh graph (Phase C async), verify dump_arrows registers
  the new APPLIES edges (categorical-Yoneda witnesses should produce DENSER
  edge density than mass-batch `Nonempty` ones)
- [ ] Compare: post-W6-handauthored APPLIES count delta vs post-W6-massbatch
- [ ] Paper-grade signature: % of OV2 Structures with categorical-Yoneda vs
  Nonempty-only. Track this metric.

## Methodology notes

- Hand-authored work is ~10× slower than wizard dispatch but produces ~3-5×
  denser `dump_arrows` APPLIES edges (each Structure field becomes an
  inbound APPLIES vs single existential proof body).
- Yoneda lemma is the ONLY framework where the work is BOTH categorical AND
  computable. Round-trip `funext` proofs reduce by `rfl` since both sides
  unfold to the same record-pattern.
- Pattern: `Tuple X = Hom(X, ℝ)^n` for n-real-field Structures gives a free
  functor that's universal among ℝ-valued probes.
- `dump_arrows` validates the work because every named identifier in the proof
  body becomes a real APPLIES edge.

— Norbert Marchewka, single-thread paper-grade c62 author, 2026-04-26
