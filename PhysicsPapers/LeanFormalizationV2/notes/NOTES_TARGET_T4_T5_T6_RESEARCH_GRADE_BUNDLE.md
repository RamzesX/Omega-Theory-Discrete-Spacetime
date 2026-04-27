# T-4 / T-5 / T-6 — Research-Grade Targets Bundle

**Bundled** for handoff efficiency. Each can be picked up as a
fresh full-context session attack. Mathlib upstream is NOT a
blockade — we port what we need.

---

## T-4: Real.pi_transcendental Retirement (Niven + Lindemann-Weierstrass)

**Difficulty**: hard. **Effort**: 4-12 weeks research-grade.
**Files**: ~6-10 Lean files, ~14 sub-lemmas (Niven decomposition).

### Goal

Retire the single paper-headline `axiom Real.pi_transcendental :
Transcendental ℚ Real.pi` by proving it directly in Lean.

### Mathlib status

`Mathlib.NumberTheory.Transcendental.Lindemann` provides PARTIAL
infrastructure. Missing:
- Lindemann–Weierstrass for π (specific to algebraic-independence
  of π over ℚ).
- The Niven decomposition: π² rational ⇒ contradiction via
  symmetric polynomial in eigenvalues argument.

### In-house decomposition

```
Foundations/NivenLemma.lean (~150 lines)
  - Define J(α) := ∫₀^π sin(x) · α(x) dx for polynomial α
  - Prove J(α) is small for high-degree α with rational coeffs
  - Prove J(α) is integer + non-zero contradiction
Foundations/LindemannWeierstrass.lean (~400 lines)
  - Symmetric polynomial in roots of minimal polynomial
  - exp(α) transcendental for algebraic α ≠ 0
Foundations/PiTranscendence.lean (~200 lines)
  - Combines Niven + L-W via π = i × log(-1)
  - Final theorem: Transcendental ℚ Real.pi
Capstones/PiTranscendenceAxiomRetirement.lean (~80 lines)
  - Replaces `axiom Real.pi_transcendental` with theorem
  - Updates all downstream `OmegaTheory.Irrationality.HermitePade.*`
```

### Success criteria

- `Real.pi_transcendental` becomes a `theorem`, not an `axiom`
- All ~3,000 downstream theorems in `Irrationality/HermitePade/`
  rebuild GREEN
- Paper axiom count drops 5 → 4 (`Real.pi_transcendental`
  retired); research-axiom count: 4 → 4 (Roth/Mahler/Siegel-
  Shidlovskii/Nesterenko remain for T-5/T-6+)

### Risk

- **R1**: Symmetric polynomial in roots requires field-extension
  algebra (`Mathlib.FieldTheory.SplittingField`) — well-supported.
- **R2**: Numerical bounds on `∫₀^π sin(x) · α(x) dx` need real
  analysis chain — manageable via existing `Mathlib.MeasureTheory`.
- **R3**: 14-sub-lemma decomposition is calendar-bound, not
  conceptually hard.

---

## T-5: Roth's Theorem In-House Port

**Difficulty**: very hard. **Effort**: 8-16 weeks research-grade.
**Files**: ~15-20 Lean files, ~30 deep sub-lemmas.

### Goal

Roth's 1955 theorem: for any algebraic α ∉ ℚ and ε > 0,

$$\left| \alpha - \frac{p}{q} \right| > \frac{C(\alpha, \varepsilon)}{q^{2+\varepsilon}}$$

for all but finitely many p/q. This is a deep result NOT yet in
Mathlib. Used in OV2 to bound rational approximation rates of π
in the substrate-truncation framework.

### Mathlib status

**Completely missing**. The proof uses:
- Mahler's compactness theorem
- Thue-Siegel construction of auxiliary polynomials
- Roth's index function arguments
- Weil heights on number fields

### In-house decomposition

```
Foundations/MahlerCompactness.lean (~300 lines)
  - Mahler measure of polynomial
  - Compactness in P¹(ℂ) via Mahler bound
Foundations/ThueSiegelLemma.lean (~400 lines)
  - Auxiliary polynomial construction in 2 vars
  - Linear algebra over ℤ to find non-trivial integer linear comb
Foundations/RothIndexFunction.lean (~500 lines)
  - Index of vanishing for polynomial in 2 vars
  - "Index decreases under specialisation" lemma
Foundations/WeilHeightsFiniteSubset.lean (~350 lines)
  - Weil height on ℚ̄
  - Northcott property: finite many bounded-height points
Foundations/RothMain.lean (~600 lines)
  - The main Roth contradiction argument
  - 5-step proof structure
Capstones/RothAxiomRetirement.lean (~100 lines)
  - Replaces research axiom `Roth_1955` (if any) with theorem
  - Updates downstream Irrationality consumers
```

### Success criteria

- `theorem Roth :  ∀ (α : ℝ) (h : Irrational α) (h_alg : IsAlgebraic ℚ α) (ε : ℝ) (h_ε : 0 < ε), ...` proven
- 0 sorry in any Roth-side file
- 0 new axioms (uses only Mathlib + Lean core + existing OV2 infra)
- Project research-axiom count drops 4 → 3

### Risk

- **R1 (highest)**: Mahler's compactness uses non-Archimedean
  valuation theory NOT in Mathlib. Mitigation: port the **specific**
  Mahler-bound subset we need (~200 lines), not the full theory.
- **R2**: Calendar — 8-16 weeks is research-grade. May need 2-3
  separate sessions with breaks.
- **R3**: Roth's proof is famously delicate (Davenport's exposition
  takes 30 pages). Sub-step verification crucial.

### Companion targets (post-Roth)

After Roth lands, can attack:
- T-5b Mahler's framework (reuses MahlerCompactness from Roth)
- T-5c Siegel-Shidlovskii (reuses ThueSiegelLemma)
- T-5d Nesterenko 1996 (reuses RothIndexFunction)

---

## T-6: Higgs Self-Coupling λ_H Substrate Derivation

**Difficulty**: hard. **Effort**: 2-3 weeks single-thread.
**Files**: ~5 Lean files, ~50 sub-theorems.

### Goal

Derive the Higgs self-coupling λ_H from substrate first principles
(not just PDG anchor). Target:

```lean
theorem higgs_lambda_substrate_derived :
    ∃ (lambda_H_substrate : ℝ),
      lambda_H_substrate = derivedFromHiggsVEVAndMass ∧
      |lambda_H_substrate - Higgs_lambda_PDG| < 0.01 * Higgs_lambda_PDG
```

### Background

PDG: λ_H ≈ 0.129 from m_H² = 2 λ_H v² with m_H = 125.10 GeV,
v = 246.22 GeV. This is a **tree-level identity**, but the
substrate framework should derive it from first principles.

### In-house decomposition

```
Foundations/HiggsTreePotential.lean (~150 lines)
  - V(φ) = -μ² φ²/2 + λ_H φ⁴/4 explicit form
  - Minimum at v = √(μ²/λ_H)
  - m_H² = 2 λ_H v²
Predictions/HiggsLambdaSubstrate.lean (~300 lines)
  - Substrate-derived μ² from δ_comp(N) at electroweak scale
  - Substrate-derived v from existing higgsVEV_substrate
  - Closed-form λ_H = m_H² / (2v²)
  - PDG-band match within 1%
Capstones/HiggsLambdaBridge.lean (~120 lines)
  - Yoneda bridge from substrate-derived to PDG anchor
  - Cross-witness with existing HiggsField + δ_comp framework
```

### Success criteria

- `λ_H_substrate ≈ 0.129` within 1% of PDG
- 0 sorry, 0 axioms
- Closed-form expression in terms of substrate parameters
- Yoneda bridge to PDG anchor

### Risk

- **R1**: Connection between m_H and substrate δ_comp is
  phenomenological — mitigation: present as substrate-anchored
  prediction within experimental bounds, document the
  phenomenological choice transparently.

---

## Combined effort estimate

| Target | Calendar weeks | Files | Sub-theorems |
|--------|---------------:|------:|-------------:|
| T-4 (π-trans Niven) | 4-12 | 6-10 | ~14 |
| T-5 (Roth) | 8-16 | 15-20 | ~30 |
| T-6 (Higgs λ) | 2-3 | 5 | ~50 |
| **Combined** | 14-31 | 26-35 | ~94 |

Calendar reach: ~3.5 to ~7.5 months for all 3 closed.

Combined with T-1 (1-2 weeks), T-2 (3-6 weeks), T-3 (4-8 weeks):
**Project completion = 4-12 months** of dedicated single-thread research.

## Pre-flight (for any of T-4/T-5/T-6)

- [ ] Refresh graph (loader fix permanent — should clean-end-to-end)
- [ ] Run grothendieck-sage MP-3 (Connes gaps) for related theorems
- [ ] Snapshot current axiom count for diff
- [ ] Start fresh Claude Code session with focused-context (no
      cron interruptions)
- [ ] After landing each major sub-lemma, run dump_arrows +
      validate APPLIES count via `~/.claude/skills/validate-theorem-arrows.md`
