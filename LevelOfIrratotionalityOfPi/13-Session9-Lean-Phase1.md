# Module 13 — Lean Formalization Phase 1 (Session 9)

**Claude (Opus 4.6, 1M context) — Session 9, April 14 2026**

---

## 13.0 Purpose

The diary's three barrier theorems and the core F49–F53 facts were written
informally across Modules 04C, 04D, 11. Session 9 begins **Phase 1 of the
formalisation program** (ROADMAP §4) by porting the two theorems most central
to the π K₂-opacity argument into Lean 4 + Mathlib v4.29.

After Session 9, any claim in the diary of the form "Siegel-style method is
blocked at this step" has a machine-verified foundation.

---

## 13.1 File inventory

New files under `PhysicsPapers/LeanFormalizationV2/OmegaTheory/Irrationality/HermitePade/`:

| File | Theorem(s) | Lines | Status |
|---|---|---|---|
| `Decoupling.lean` | `decoupling_scalar`, `decoupling`, `decoupling_matrix` | 177 | **BUILDS, 0 sorries** |
| `PiStratum.lean`  | `pi_stratum_integer`, `pi_stratum_vector`         | 95  | **BUILDS, 0 sorries** |

Both files use Mathlib v4.29 and the project toolchain `leanprover/lean4:v4.29.0`.

---

## 13.2 `Decoupling.lean` — Theorem 4C.3

### Statement

```lean
theorem decoupling
    {K : Type*} [Field K] [Algebra ℚ K]
    {θ : K} (hθ : Transcendental ℚ θ)
    {D T : ℕ} (v : Fin (D + 1) → Fin T → ℚ)
    (h : ∀ i : Fin T,
        ∑ d : Fin (D + 1), θ ^ (d : ℕ) * algebraMap ℚ K (v d i) = 0) :
    ∀ d i, v d i = 0
```

### Proof sketch

The scalar version `decoupling_scalar` assembles the polynomial
`p := ∑ d, C(a d) · X^d ∈ ℚ[X]`, shows `aeval θ p = 0`, and uses transcendence
of θ to conclude `p = 0`. Extraction of the `d`-th coefficient yields `a d = 0`.

The vector form reduces component-by-component to the scalar version. The
matrix corollary specialises to `v_d := S *ᵥ c_d` where `c_d ∈ ℤ^N` and
`S` is a rational matrix — the precise form used by Siegel-style attacks.

### Role in the diary

Every "BLOCKED_BY_DECOUPLING" verdict (Attacks 7, 8, 15) now traces, in
machine-verified form, to this theorem. The informal argument "transcendence
of π forces componentwise vanishing" is no longer a narrative claim — it is
a `theorem` citation.

### Technical notes

- Import fix: Mathlib v4.29 renamed `Mathlib.Algebra.BigOperators.Group.Finset`
  to `Mathlib.Algebra.BigOperators.Group.Finset.Basic`. Was missed on first
  compile; fixed in Session 9.
- Proof gotcha: the `Finset.sum_eq_single` branch requires a *symmetric* `Ne`
  (the `if`-condition `↑d = ↑k` vs the hypothesis `↑k ≠ ↑d`). Session 9's
  first patch used `Ne.symm`.

---

## 13.3 `PiStratum.lean` — Fact F53

### Statement

```lean
theorem pi_stratum_integer
    {D : ℕ} (c : Fin (D + 1) → ℤ)
    (h : ∑ k : Fin (D + 1),
        (c k : ℝ) * (Real.pi : ℝ) ^ (k : ℕ) = 0) :
    ∀ k, c k = 0
```

### Proof sketch

Direct specialisation of `decoupling_scalar` at `θ = π` in ℝ, casting integer
coefficients through ℚ. The ℚ-conclusion lifts to ℤ by injectivity of the
ℤ → ℚ cast.

### Role in the diary

F53 is the "π-stratum separation" step of Attack 19 (Module 11 §11.4). If a
hypothetical ℤ[π]-linear relation among `{1, u, v}` existed, its π-degree-0
component would be a ℤ-linear relation; F53 guarantees we can isolate and
contradict that component separately.

### Axiom

This file declares

```lean
axiom Real.pi_transcendental : Transcendental ℚ (Real.pi : ℝ)
```

with the citation **Lindemann (1882)**. Mathlib v4.29 ships
`Mathlib.NumberTheory.Transcendental.Lindemann.AnalyticalPart` but has not
yet derived this corollary. When Mathlib completes the Lindemann derivation,
the axiom becomes a theorem re-exported from Mathlib with no other change.

---

## 13.4 Remaining Phase-1 targets (ROADMAP §4)

| Theorem | File | Cost est. | Status |
|---|---|---|---|
| F49 Hermite-Padé existence | `F49_Existence.lean` | ~50 lines | PLANNED (Session 14) |
| F50 super-exponential decay | `F50_Decay.lean`     | ~100 lines | PLANNED (needs contour integral setup) |
| F51 denominator bound | `F51_Denominator.lean` | ~100 lines | PLANNED |
| F54 slice-prime correspondence | `F54_SlicePrime.lean` | ~80 lines | FUTURE (after informal proof) |
| F27 ord_p dichotomy | `F27_OrdpDichotomy.lean` | ~60 lines | FUTURE (Legendre + Pochhammer) |
| Universal Siegel Barrier 4D.2 | `UniversalBarrier.lean` | ~150 lines | PLANNED (depends on Decoupling) |

Each file is standalone; build incrementally with
`lake build OmegaTheory.Irrationality.HermitePade.<name>`.

---

## 13.5 Axioms used so far

Only one:

```
Real.pi_transcendental : Transcendental ℚ Real.pi   -- Lindemann 1882
```

Cited with full bibliographic attribution. Removable once Mathlib derives it.

No other axioms beyond Mathlib itself. No sorries. The two theorems combined
are **~90 lines of proof** plus comments; a reviewer can audit the claim in
an afternoon.
