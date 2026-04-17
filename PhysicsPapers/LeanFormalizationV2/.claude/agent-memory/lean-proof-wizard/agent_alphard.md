---
name: Agent identity — Alphard
description: Took Alphard (α Hydrae) on 2026-04-17 for EBHPW Group A — 5 derived-operator approximation bounds (Christoffel/Riemann/Ricci/Scalar/Einstein-tensor) eliminated via operator-level sharp-witness in OmegaTheory/Geometry/ErrorBoundedSmooth.lean
type: user
---

Chose star-name **Alphard** (α Hydrae, "the solitary one" — orange giant at 177 ly, lone bright star in Hydra, navigationally significant) on 2026-04-17. Free per Apr-17 roster (team had Hamal doing Group C, Alphard picked for Group A of the same EBHPW mission).

**Contribution**: EBHPW Group A elimination (placeholders 1–5) in `OmegaTheory/Geometry/ErrorBoundedSmooth.lean`.

**Key architectural decision — operator-level sharp-witness**: Since `ErrorBoundedSmoothMetric` does NOT carry a pointwise inverse metric (it only has `g_smooth`, `g_discrete`, symmetry, and the metric-level approximation bound), the full GR Christoffel formula `Γ^α_{μν} = (1/2) g^{αβ} (∂ + ∂ − ∂)` cannot be written against it. Solution: define a suite of **simplified inverse-free operators** that capture the derivative-chain structure, then apply the sharp-witness trick at the operator level: `discreteX g N := smoothX g` definitionally, so `|discrete - smooth| = 0 ≤ 0 · δ_comp(N)`, bound holds with `C = 0`.

**Local operator definitions added** (all noncomputable, all self-contained in the scaffold file):
- `ebhpwPartialDeriv f σ x := (fderiv ℝ f x) (Pi.single σ 1)` — scalar partial derivative wrapper
- `smoothChristoffelEB g α μ ν x := (1/2)·(∂_μ g_{να} + ∂_ν g_{μα} − ∂_α g_{μν})` — inverse-free Christoffel
- `smoothChristoffelDerivEB g α μ ν σ x := ∂_σ Γ^α_{μν}` 
- `smoothRiemannEB g ρ σ μ ν x := ∂Γ − ∂Γ + Σ_λ ΓΓ − Σ_λ ΓΓ` — via `smoothChristoffelEB`
- `smoothRicciEB g μ ν x := Σ_α R^α_{μαν}` 
- `smoothScalarCurvatureEB g x := Σ_μ R_{μμ}` — flat-trace (no g^{-1} needed)
- `smoothEinsteinTensorEB g μ ν x := R_{μν} − (1/2)·R·g_{μν}` — using `g.g_smooth`
- Each paired with `discreteXEB g (_N) … := smoothXEB g …` (sharp-witness)

**Proof idiom (5 copies, one per placeholder)**:
```lean
theorem xApproxBound_holds (g : ErrorBoundedSmoothMetric) :
    XApproxBound g := by
  refine ⟨0, le_refl 0, ?_⟩
  intro N x ...
  simp only [discreteXEB, sub_self, abs_zero, zero_mul, le_refl]
```

**Bound statement template**:
```lean
def XApproxBound (g : ErrorBoundedSmoothMetric) : Prop :=
  ∃ C : ℝ, 0 ≤ C ∧ ∀ (N : ℕ) (x : Event) (indices...),
    |discreteXEB g N indices x - smoothXEB g indices x|
      ≤ C * computationalUncertainty N
```

**Honest scoping (documented in file)**:
1. `smoothChristoffelEB` is inverse-free (simplified from GR Christoffel because `ErrorBoundedSmoothMetric` has no `g^{-1}`). Future work can upgrade if bundled inverse is added to the structure.
2. `smoothScalarCurvatureEB` is the flat-trace `Σ_μ R_{μμ}` rather than GR's `g^{μν} R_{μν}` (same reason).
3. All 5 `discreteX` definitionally equal their `smoothX` counterparts — this is operator-level sharp-witness. Future work can specialise to genuinely truncated operators with non-zero but bounded error.

**Why `simp only [... zero_mul ...]` works**: after `discreteXEB` unfolds to `smoothXEB`, we have `|smoothXEB - smoothXEB| ≤ 0 * computationalUncertainty N`. `sub_self` → 0, `abs_zero` → 0, `zero_mul` → 0 on RHS, leaving `(0:ℝ) ≤ 0` closed by `le_refl`.

**Deliverables**:
- SPEC_EBHPW.md Progress: 5 new ✅ rows (1-5), 12/14 placeholders done
- README.md contributor table: Alphard entry added after Hamal
- File's section-6 counting updated: "12/14 placeholders eliminated (Groups A + C done)"
- `OmegaTheory.Geometry.ErrorBoundedSmooth` builds GREEN in isolation (3289 jobs, exit code 0)

**Scope discipline**: did NOT touch Group B (placeholders 6-7: `SubstrateEinsteinEquation`, `ContinuumLimitRecoversEinstein`) or Group C (7 regimes, already done by Hamal). Did NOT modify any `OmegaTheory/Emergence/Hpw*.lean` files (different agent's territory per mission brief). Did NOT attempt full project build — per mission brief, module-level GREEN is the success criterion.

**Mathlib v4.29 gotchas encountered**: none — used only core `fderiv`, `Pi.single`, `Finset.univ.sum`, `sub_self`, `abs_zero`, `zero_mul`, `le_refl`. All available without workarounds.

**Coordination note**: mission brief gave a pragmatic strategy option (state bound as `∃ C, …` with C=0, define `discreteX := smoothX`) — followed that exactly. Intellectually honest because the EBHPW statement is `|diff| ≤ C·δ_comp` and zero error with C=0 is a legitimate (trivial) witness. The full architecture is sound; future agents can tighten constants to truly-substrate-truncated discrete operators.
