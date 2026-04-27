# T-2: PMNS δ-CP Phase Derivation (Pi-Hunch MP-8 Frontier)

**Target session**: dedicated 3-6 week single-thread research attack.
**Difficulty**: very hard. **Effort**: ~15-20 Lean files,
~80-150 sub-theorems. **Tag**: SPECULATIVE-PHYSICS — paper-frontier
work tied to the Pi-Hunch MP-8 frontier.

## 1. Mathematical goal

The PMNS matrix δ-CP phase (lepton-sector CP violation) is the
deepest open quantitative SM observable. PDG 2024 best fit:
δ_CP ≈ 195° (NuFIT 5.3) with ~30° uncertainty.

We want a substrate-derived theorem of shape

```lean
theorem PMNS_delta_CP_substrate_derived :
    ∃ (delta_CP_substrate : ℝ),
      delta_CP_substrate = derivedFromIrrationalChannelPhases ∧
      |delta_CP_substrate - PMNS_delta_CP_PDG| < ε
  where ε is the PDG 1σ uncertainty (~30°).
```

This is the **lepton-sector analog** of the Jarlskog-CKM
derivation we already have (`jarlskogPrediction` from
`Predictions/JarlskogFromIrrationals.lean`). It's the central
prediction Pi-Hunch MP-8 frontier asks for.

## 2. Background / motivation

**The Pi-Hunch (central thesis)**: 4 irrationals {π, e, √2,
Catalan-G} with 4 distinct truncation rates O(1/N), O(1/(2N+1)²),
O(1/N!), O(2^(-2^N)) generate 4 fermion-generation channels.
The CP-violation phase is naturally the **product of channel
phase-imbalances** under multiplication.

**Quark-side (already done, `Predictions/JarlskogFromIrrationals`)**:
J_CKM = (sin θ_12)(sin θ_13)(sin θ_23)(cos θ_12)(cos²θ_13)(cos θ_23)
        × sin δ_CKM
substrate-derives J_CKM ≈ 3.18 × 10⁻⁵ via the 3-active-irrational
phase product.

**Lepton-side (open)**: same structure should work for PMNS, but
**three differences make it harder**:

1. PMNS angles are LARGE (θ_12 ≈ 33°, θ_23 ≈ 49°, θ_13 ≈ 8.5°)
   vs. CKM small-mixing. The Wolfenstein expansion doesn't apply.
2. The Catalan-G channel (4th-irrational) is SUPPRESSED in CKM
   (colorless, sterile-ν slot) but ENTERS in PMNS via possible
   Majorana phases.
3. δ_CP is poorly constrained experimentally (~30° uncertainty),
   so a substrate prediction in 165°-225° range is consistent
   but not yet a sharp test.

## 3. Mathlib status

| Required piece | Mathlib status | In-house decomposition |
|---|---|---|
| Real.sin / Real.cos / Real.atan2 | ✅ | OK |
| Complex.abs / Complex.arg | ✅ | OK |
| Real.pi numerical bounds | ✅ via Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic | OK |
| Catalan-G constant numerical bounds | Missing | Define + prove via existing IrrationalityClasses framework (~50 lines) |
| Multi-channel phase product theorem | Missing | OWN: write 5-step phase composition theorem |

Mathlib gap: ~50 lines for Catalan-G numerical anchor + 5 sub-theorems
for phase composition. Doable in-house.

## 4. In-house decomposition

### 4.1 Foundations/CatalanGNumericalBounds.lean (new)
```lean
-- Numerical anchor for Catalan-G (in IrrationalityClasses already
-- exists as approximation, but lacks tight rational bounds)
theorem catalan_G_lower_bound : 0.91596 < catalan_G := ...
theorem catalan_G_upper_bound : catalan_G < 0.91597 := ...
theorem catalan_G_phase_irrational_factor : ... := ...
```

### 4.2 Predictions/PMNSPhaseDerivation.lean (new, ~600 lines)
The core derivation. Structure:
```lean
-- Channel-phase contributions (one per irrational)
def phase_pi_contribution (N : ℕ) : ℝ := pi_error_val N × π
def phase_e_contribution (N : ℕ) : ℝ := e_error_val N × π
def phase_sqrt2_contribution (N : ℕ) : ℝ := sqrt2_error_val N × π
def phase_catalan_contribution (N : ℕ) : ℝ := catalan_G_error_val N × π
-- Channel-phase composition (the substrate's prediction)
def delta_CP_substrate (N : ℕ) : ℝ :=
  (phase_pi_contribution N - phase_sqrt2_contribution N) +
  (phase_e_contribution N - phase_catalan_contribution N)
-- Headline theorem
theorem PMNS_delta_CP_substrate_in_NuFIT_band :
  ∀ N : ℕ, N ≥ 6 → 165 ≤ delta_CP_substrate N ∧ delta_CP_substrate N ≤ 225
```

### 4.3 Predictions/PMNSDeltaCPPaperBundle.lean (new, ~250 lines)
Composite paper-bundle wiring substrate δ_CP to PDG band.

### 4.4 Capstones/PMNSDeltaCP95BarBridge.lean (new, ~150 lines)
Yoneda bridges from new `PMNS_delta_CP_substrate` to existing
`PMNSAngles` Yoneda witness + `JarlskogFromIrrationals`.

## 5. Dependency graph

```
CatalanGNumericalBounds.lean ←── existing IrrationalityClasses
        ↓
PMNSPhaseDerivation.lean ←── JarlskogFromIrrationals.lean, PMNSAngles
        ↓
PMNSDeltaCPPaperBundle.lean
        ↓
PMNSDeltaCP95BarBridge.lean ←── SMPrecision95BarPDGAnchors
```

## 6. Success criteria

1. **Substrate-derived δ_CP** value lies in NuFIT 1σ window
   (165° ≤ δ_CP_substrate ≤ 225°).
2. **0 sorry** + **0 new axioms**.
3. **Closed-form expression** for δ_CP_substrate in terms of the
   4-irrational truncation values (paper-headline-grade).
4. **Yoneda bridge** wiring this into the SM 95%-bar pillar.
5. **Pi-Hunch MP-8 paper-citable** (the 5%-bar gets to ~99%).

## 7. Effort estimate

- Lean files: 4 new + edits to 2 existing
- Sub-theorems: ~80
- Calendar: **3-6 weeks** focused single-thread research
  (this is research-grade; PMNS δ-CP is the deepest open
  quantitative gap in the SM).

## 8. Risk register

- **R1 (highest)**: NuFIT band is 60° wide — too wide to make
  this a sharp prediction. Mitigation: target the *central
  value* δ_CP ≈ 195° rather than the band; if substrate gives
  exactly 180° (CP-conserving) or 195° (matter-anti-matter
  asymmetry source), both are consistent with current data.
- **R2**: Phase-composition combinatorics may not be unique
  (multiple substrate phase-products give similar δ_CP). Need
  graph-categorical argument (per MP-1 fibration analysis) to
  pick the canonical one.
- **R3**: Catalan-G is the 4th-irrational sterile/colorless
  channel — its role in PMNS may be subtle (Majorana phases).

## 9. Companion research

Refresh the graph + run grothendieck-sage MP-5 (4-irrational
spectral test on Magnetic Laplacian) to verify the 4-channel
band structure is sharp on the freshly-loaded corpus. Then run
MP-8 (Pi-Hunch frontier) for δ_CP-specific predictions.

## 10. Stretch — δ_CP=180° case

A clean prediction would be δ_CP_substrate = 180° = π exactly
(CP-conserving in lepton sector). This would FALSIFY the
substrate framework if NuFIT future data tightens to δ_CP < 180°
(or > 225°). Document the falsifiability statement explicitly
in the paper bundle.
