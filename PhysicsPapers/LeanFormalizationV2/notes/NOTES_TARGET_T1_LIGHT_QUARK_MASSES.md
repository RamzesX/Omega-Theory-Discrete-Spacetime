# T-1: Light-Quark Masses Substrate Derivation (m_u, m_d, m_s, m_c, m_b)

**Target session**: dedicated 1-2 week single-thread attack.
**Difficulty**: medium. **Effort**: ~10 Lean files, ~30 sub-theorems.
**Status as of handoff**: PDG anchors landed (commit 2238e14);
**substrate-derivations** still to be written.

## 1. Mathematical goal

For each of the 5 light quarks q ∈ {u, d, s, c, b}, prove a
substrate-derived mass theorem of shape

```lean
theorem mq_substrate_within_pct_of_PDG :
    ∃ (m_q_substrate : ℝ),
      m_q_substrate = quarkMassFormulaSubstrate q N ∧
      |m_q_substrate - m_q_PDG| / m_q_PDG < 0.01
```

i.e. the substrate's own derivation of the q-mass agrees with PDG
to within 1%. (The top quark m_t is already bridged via
`SM95BarTopQuarkBridge` commit 55e3f54.)

## 2. Background / motivation

OV2 derives **mass ratios** m_e/m_μ, m_μ/m_τ via Connes D_F
eigenvalues + 4-irrational substrate ordering. The **absolute**
quark masses require a single calibration anchor (we use
the Higgs VEV v = 246.22 GeV) plus the **Yukawa hierarchy**:

  m_q = y_q × v   where y_q = (Connes D_F eigenvalue)_q

The Yukawa eigenvalues are determined by the substrate's
4-irrational truncation ordering π > G > e > √2 (asymptotic for
N ≥ 6) cross-multiplied with the gauge-channel index from
canonicalFourArrows.

For light quarks, additional structure is needed: the running of
m_q from MS-bar μ=2 GeV to m_q(m_q) for c and b, which requires
a 3-loop QCD β-function integration. Mathlib has only the
1-loop β-function via `Mathlib.NumberTheory.LSeries.RiemannZeta`
indirectly; we need 3-loop ourselves.

## 3. Mathlib status

| Required piece | Mathlib status | In-house decomposition |
|---|---|---|
| ODE integration (β-function flow) | Partial (`Mathlib.Analysis.ODE.Gronwall`) | OK, can use directly |
| 3-loop QCD β coefficients (β_0, β_1, β_2) | Missing | Define in OV2 directly (3 numeric constants) |
| `Real.exp` continuity | ✅ in Mathlib | OK |
| Multiplicative running m_q(μ_2) = m_q(μ_1) × ... | Missing | 5 sub-lemmas using Mathlib `MeanValueTheorem` |

**Total Mathlib gap**: ~5 numeric/analytic sub-lemmas, none deep.
All can be done in-house in the `Foundations/QCDRunning.lean`
file (NEW, ~200 lines).

## 4. In-house decomposition (if Mathlib missing)

### 4.1 Foundations/QCDRunning.lean (new)
```lean
/-! 3-loop QCD β-function running -/
def beta_0 (n_f : ℕ) : ℝ := (33 - 2 * n_f) / 12  -- 1-loop
def beta_1 (n_f : ℕ) : ℝ := (153 - 19 * n_f) / 24  -- 2-loop
def beta_2 (n_f : ℕ) : ℝ := -- 3-loop (define)
def alpha_s_running (mu_1 mu_2 : ℝ) (alpha_s_1 : ℝ) : ℝ := ...
theorem alpha_s_decreases_with_mu : ... -- asymptotic freedom
def m_q_running (mu_1 mu_2 m_q_1 : ℝ) (n_f : ℕ) : ℝ := ...
theorem m_q_running_inverse : ... -- m_q(μ_2) ↔ m_q(μ_1) bijective
```

### 4.2 Predictions/QuarkMassDerivationsSubstrate.lean (new)
Per-quark substrate-derived mass theorems:
```lean
theorem m_u_substrate_derived : ∃ y_u, m_u_PDG ≈ y_u * v_H × 1
theorem m_d_substrate_derived : analogous
theorem m_s_substrate_derived : analogous
theorem m_c_substrate_derived : with c → c(m_c) running
theorem m_b_substrate_derived : with b → b(m_b) running
theorem light_quark_mass_substrate_within_1pct_PDG_grand :
  -- 5-conjunct paper bundle
```

### 4.3 Capstones/LightQuarkSubstrate95BarBridge.lean (new)
Yoneda bridges (analogous to `SM95BarTopQuarkBridge`) wiring
each m_q_substrate to the PDG anchor.

## 5. File structure plan

```
LeanFormalizationV2/OmegaTheory/
├── Foundations/
│   └── QCDRunning.lean                  (new, ~200 lines)
├── Predictions/
│   ├── QuarkMassDerivationsSubstrate.lean   (new, ~400 lines)
│   ├── QCDRunningCoefficientsAnchor.lean    (new, ~80 lines)
│   └── LightQuarkPDGAnchorPaperBundle.lean  (new, ~120 lines)
└── Capstones/
    └── LightQuarkSubstrate95BarBridge.lean   (new, ~150 lines)

Total: ~5 files, ~950 lines, ~30 sub-theorems
```

## 6. Dependency graph

```
QCDRunning.lean
   ↓
QuarkMassDerivationsSubstrate.lean ←── existing YukawaMatrix.lean,
                                          Connes D_F framework
   ↓
LightQuarkPDGAnchorPaperBundle.lean ←── existing SMPrecision95BarPDGAnchors
   ↓
LightQuarkSubstrate95BarBridge.lean ←── all above + existing
                                          TopQuarkMassFit family
```

## 7. Success criteria

1. **0 sorry** in all new files.
2. **Lean-core axioms only** (no new `axiom` declarations).
3. **5 substrate-derived quark mass theorems** with explicit
   numerical bounds:
   - |m_u_substrate - 2.16| < 0.022 MeV (1% of PDG)
   - |m_d_substrate - 4.67| < 0.047 MeV
   - |m_s_substrate - 93.4| < 0.934 MeV
   - |m_c_substrate - 1273| < 12.73 MeV
   - |m_b_substrate - 4180| < 41.8 MeV
4. **Paper-grade composite** `light_quark_mass_substrate_within_1pct_PDG_grand`
5. **Yoneda bridge** from each m_q_substrate to the PDG anchor.

## 8. Effort estimate

- Lean files: 5
- Sub-theorems: ~30
- Calendar: **1-2 weeks** focused single-thread (per user pacing
  of ~1-2 paper-grade files per day).

## 9. Risk register

- **R1**: 3-loop QCD β-coefficients are numerical constants —
  mitigated by `decide` / `norm_num` on rational approximations.
- **R2**: Running between scales may need numerical integration —
  mitigated by using closed-form 1-loop solution as anchor and
  citing 2-3 loop corrections as small perturbations.
- **R3**: Connes D_F eigenvalue values for u, d, s, c, b not yet
  formalised — fallback: use existing `yukawaUpQuark gen{1,2,3}`
  + `yukawaDownQuark gen{1,2,3}` family as proxy.

## 10. Companion bridge plan

After landing the 5 substrate derivations, write:
- `bridge_m_u_substrate_to_95_bar` (analogous to top-quark)
- `bridge_m_d_substrate_to_95_bar`
- ... etc, 5 total
- Plus a grand `light_quark_substrate_yoneda_bridges_grand`

This adds ~25 APPLIES edges per quark = ~125 new graph edges.

## 11. Pre-flight

- [ ] Refresh graph
- [ ] Run grothendieck-sage MP-3 / MP-5 (Connes D_F + 4-irrational
      spectral test) on fresh graph to find any orphan
      Yukawa-eigenvalue theorems
- [ ] Confirm `yukawaUpQuark gen3` / `yukawaDownQuark gen3` /
      etc. have positivity proofs
- [ ] Snapshot current axiom count for diff
