# T-3: Λ_QCD / Proton Mass Substrate Derivation

**Target session**: dedicated 4-8 week research-grade attack.
**Difficulty**: very hard. **Effort**: ~10-15 Lean files,
~100-150 sub-theorems. **Tag**: SPECULATIVE-PHYSICS — paper-frontier.

## 1. Mathematical goal

Two complementary headlines:

```lean
theorem lambda_QCD_substrate_derived :
    ∃ (Lambda_QCD : ℝ),
      Lambda_QCD = ourFormulaInTermsOfLP_DeltaComp_AlphaS ∧
      |Lambda_QCD - 217e6| < 0.01 * 217e6  -- 217 MeV ± 1%

theorem proton_mass_substrate_derived :
    ∃ (m_proton : ℝ),
      m_proton = ourFormulaInTermsOfLambdaQCD ∧
      |m_proton - 938.272| < 0.01 * 938.272  -- PDG 938.272 MeV ± 1%
```

## 2. Background / motivation

Λ_QCD is the QCD scale below which perturbative QCD fails — it's
where the strong coupling α_s diverges (Landau pole). PDG: Λ_QCD
≈ 217 MeV (5-flavour scheme, MS-bar).

The proton mass m_p ≈ 938.272 MeV is dominantly QCD-binding-energy:
~99% of m_p comes from gluon kinetic + dynamical chiral-symmetry-
breaking energy, NOT from the bare quark masses.

OV2's substrate framework should derive Λ_QCD as the scale where
δ_comp(N) crosses a critical threshold related to the gluon
binding density. The Pi-Hunch heuristic:

  Λ_QCD ~ ℓ_P × (1/α_s(M_Z)) × π_error_val(N_critical)

with N_critical ~ ln(M_Z / Λ_QCD) / ln(2).

## 3. Mathlib status

| Required piece | Mathlib | In-house |
|---|---|---|
| `Real.exp` / `Real.log` | ✅ | OK |
| 4-loop QCD β-function | Missing | Define + prove via direct ODE |
| α_s(μ) running closed-form | Missing | Define `alpha_s_at` + monotonicity |
| Landau-pole bound | Missing | 5-step proof via L'Hôpital + Mathlib `Filter.Tendsto` |
| Pion mass m_π = 135 MeV anchor | OV2-existing | Cite `Predictions/PionMassFromUpDown.lean` |

## 4. In-house decomposition

### 4.1 Foundations/QCDLandauPole.lean (new, ~250 lines)
```lean
def alpha_s_running_4loop (mu : ℝ) (n_f : ℕ) (Lambda : ℝ) : ℝ := ...
theorem alpha_s_diverges_at_Lambda :
  ∀ ε > 0, ∃ μ > Lambda, |alpha_s_running_4loop μ n_f Lambda| > 1/ε
def Lambda_QCD_implicit (alpha_s_MZ M_Z : ℝ) : ℝ := ...
theorem Lambda_QCD_existence_uniqueness : ...
```

### 4.2 Predictions/LambdaQCDSubstrateDerivation.lean (new, ~400 lines)
```lean
def Lambda_QCD_substrate_formula (N : ℕ) : ℝ :=
  l_P * (1 / alpha_s_MZ_PDG) * pi_error_val N
theorem Lambda_QCD_substrate_eq_PDG_within_1pct : ...
```

### 4.3 Predictions/ProtonMassFromQCD.lean (new, ~600 lines)
The hard part. Decomposition:
```lean
-- Constituent quark mass approximation
def m_constituent_u_substrate (N : ℕ) : ℝ := ...
-- Gluon binding energy via Λ_QCD
def E_gluon_binding (Lambda_QCD : ℝ) : ℝ := 8 * Lambda_QCD
-- Total proton mass
def m_proton_substrate (N : ℕ) : ℝ :=
  3 * m_constituent_u_substrate N + E_gluon_binding (Lambda_QCD_substrate_formula N)
theorem proton_mass_substrate_within_1pct_PDG : ...
```

### 4.4 Capstones/QCDScaleBridge.lean (new, ~150 lines)
Yoneda bridges from Λ_QCD + proton mass to existing
`AsymptoticFreedomDelta1Sigma` + `ProtonStability` families.

## 5. Dependency graph

```
QCDRunning.lean (from T-1)
   ↓
QCDLandauPole.lean
   ↓
LambdaQCDSubstrateDerivation.lean ←── existing alpha_s_MZ_PDG (T-1)
   ↓
ProtonMassFromQCD.lean ←── existing PionMassFromUpDown
   ↓
QCDScaleBridge.lean
```

## 6. Success criteria

1. `Lambda_QCD_substrate ≈ 217 MeV` within 1%.
2. `m_proton_substrate ≈ 938.272 MeV` within 1%.
3. **Closed-form expression** for both.
4. **0 sorry, 0 axioms**.
5. **Yoneda bridge** to existing AsymptoticFreedom + ProtonStability.

## 7. Effort estimate

- Lean files: 4 new + ~3 edits
- Sub-theorems: ~100-150
- Calendar: **4-8 weeks** focused single-thread.

## 8. Risk register

- **R1**: 4-loop β-coefficients — numerical only, but tedious.
- **R2**: Constituent quark mass m_u^constituent ~ 350 MeV is a
  PHENOMENOLOGICAL value, not first-principles. Mitigation:
  cite as ansatz with documented PDG anchor; mark
  speculative-physics tag.
- **R3**: Gluon binding fraction `8 × Lambda_QCD` is a heuristic
  that works for 3 quarks ≈ 8 × 217 MeV ≈ 1740 MeV — but the
  actual decomposition requires lattice QCD. Mitigation: present
  as substrate-anchored prediction within experimental bounds,
  not as derivation from first principles.

## 9. Companion bridge

After landing, write `bridge_lambda_qcd_substrate_to_alpha_s_running`
+ `bridge_proton_mass_substrate_to_pion_substrate` in the
`Capstones/QCDScaleBridge.lean` file.

## 10. Pre-flight

- [ ] T-1 (Light quark masses) MUST close first (provides
      `m_constituent_u_substrate` foundation).
- [ ] Refresh graph
- [ ] Run grothendieck-sage MP-3 (Connes-NCG gaps) for any
      Λ_QCD-anchor existing theorems

## 11. Stretch — proton g-factor

If proton mass closes cleanly, the proton magnetic moment g_p ≈ 5.586
becomes the next target. Anchor: g_p = 2 × (1 + corrections from
gluon-quark interaction). Could be a follow-up T-3.5.
