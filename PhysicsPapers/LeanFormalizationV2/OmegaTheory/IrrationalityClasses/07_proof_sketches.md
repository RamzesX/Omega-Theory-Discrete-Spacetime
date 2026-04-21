# 07 — Lean proof sketches for §§02–06

This memo gives a *sketch-level* Lean outline for each theorem committed to in `06_separation_theorem.md`. Not full source — this is the design document. Each sketch names the key Mathlib lemma, the overall strategy, and unresolved dependencies.

## 1. `four_irrationals_pairwise_distinct` (Layer 1, provable today)

```lean
theorem four_irrationals_pairwise_distinct :
  Real.pi ≠ Real.exp 1 ∧
  Real.pi ≠ Real.sqrt 2 ∧
  Real.pi ≠ catalanG ∧
  Real.exp 1 ≠ Real.sqrt 2 ∧
  Real.exp 1 ≠ catalanG ∧
  Real.sqrt 2 ≠ catalanG := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩ <;>
    · -- each case: use numerical decimal bound
      have h1 : Real.pi > 3 := Real.pi_gt_three
      have h2 : Real.exp 1 < 2.8 := Real.exp_one_lt_d9
      have h3 : Real.sqrt 2 < 1.5 := by nlinarith [Real.sq_sqrt (by norm_num : (2:ℝ) ≥ 0)]
      have h4 : catalanG < 1 := catalanG_lt_one
      linarith [… appropriate facts …]
```

**Key Mathlib lemmas.**
- `Real.pi_gt_three`, `Real.pi_lt_3141593` (known π-bounds in `Mathlib.Analysis.Real.Pi.Bounds`).
- `Real.exp_one_gt_d9`, `Real.exp_one_lt_d9` (known e-bounds).
- `Real.sqrt_two_add_series` / direct `nlinarith` on `Real.sqrt 2 ^ 2 = 2`.
- For Catalan: `catalanG` is defined as a series; need `catalanG_pos` and `catalanG_lt_one` from the alternating-series first-two-terms bound `1 − 1/9 < G < 1`.

**Effort.** 1–2 sessions. No Mathlib gap.

## 2. `three_constants_transcendental` (Layer 2)

```lean
theorem three_constants_transcendental :
    Transcendental ℚ Real.pi ∧
    Transcendental ℚ (Real.exp 1) ∧
    IsAlgebraic ℚ (Real.sqrt 2) := by
  refine ⟨?_, ?_, ?_⟩
  · exact Real.pi_transcendental   -- axiom today; theorem once Lindemann is in Mathlib
  · exact Real.exp_one_transcendental   -- likewise Hermite; MISSING in Mathlib
  · -- √2 algebraic
    refine ⟨Polynomial.X^2 - C 2, ?_, ?_⟩
    · intro h; have := Polynomial.leadingCoeff_X_pow_sub_C (n:=2) (a:=(2:ℚ))
      -- derive contradiction
      sorry  -- actually fillable via explicit coeff analysis
    · simp [Polynomial.aeval, Real.sq_sqrt]
```

**Key Mathlib lemmas.**
- `Polynomial.X_pow_sub_C_ne_zero` — the polynomial `X² − 2` is non-zero.
- `Polynomial.aeval_X_pow_sub_C` evaluated at `√2` gives 0.
- `IsAlgebraic` definition in `Mathlib.RingTheory.Algebraic.Basic`.

**Dependencies.**
- `Real.pi_transcendental` — today axiom in `HermitePade/PiStratum.lean`. Will become theorem after Mathlib Lindemann-Weierstrass port.
- `Real.exp_one_transcendental` — **MISSING from Mathlib**. Hermite 1873 proof not ported. Needs ~20 sessions of porting (integral construction + Hermite-Padé auxiliary polynomials).

**Effort.** 2 sessions for the √2 leg. ~25 sessions for the full theorem (20 for Hermite port + 3 for Lindemann conclusion + 2 glue).

## 3. `e_is_E_function_value_but_pi_is_not` (Layer 3)

This requires building the `isEFunctionValue` predicate from scratch.

```lean
/-- An E-function is a power series `Σ aₙ zⁿ/n!` where aₙ ∈ ℚ̄ and:
  (i) the coefficients aₙ are algebraic over ℚ with bounded degree,
  (ii) their heights grow at most polynomially in n,
  (iii) there exists a common denominator sequence with polynomial height. -/
structure EFunction (a : ℕ → ℂ) : Prop where
  algebraic_coeffs : ∀ n, IsAlgebraic ℚ (a n)
  bounded_degree : ∃ d, ∀ n, (minpoly ℚ (a n)).natDegree ≤ d
  polynomial_height : ∃ C γ, ∀ n, height (a n) ≤ C * (n + 1)^γ
  common_denominator : ∃ D : ℕ → ℕ, (∀ n, (algebraMap ℤ _) (D n) * a n ∈ …) ∧
                                    ∃ C γ, ∀ n, D n ≤ C * (n + 1)^γ

def isEFunctionValue (x : ℝ) : Prop :=
  ∃ (a : ℕ → ℂ) (hE : EFunction a) (α : ℝ) (hα : IsAlgebraic ℚ α),
    (fun z => ∑' n, a n * z^n / n.factorial) α = x
```

**Proof strategy.**
- For e = exp(1): take `a n = 1`, `α = 1`. Show `EFunction (fun _ => 1)` — trivial (constant 1 is algebraic, polynomial height, denominator 1).
- For π NOT an E-function value: harder. π = 4·arctan(1), and arctan(z) = Σ (−1)ⁿ z^(2n+1)/(2n+1). These coefficients fall like 1/n, NOT 1/n! — so they're **G-function** coefficients, not E-function. Show that if π were an E-function value, we'd get a contradiction with the arctan-series representation. This uses the fact that E-function classes are **closed under algebraic operations, evaluation at algebraic points, …** — an E-function value at an algebraic point cannot itself equal the G-function value of a different arithmetic type.

**Effort.** 30+ sessions. Requires formalising:
- Coefficient height, polynomial growth.
- Common-denominator sequence arithmetic.
- The closure properties of E-function class.
- The "π is a G-function value but not E-function value" classification argument.

## 4. `omega_four_origin_separation` (Layer 4, the headline)

```lean
inductive TruncOrigin : Type
  | Algebraic (p : Polynomial ℚ) (h : p ≠ 0)
  | EFunction (coeffs : ℕ → ℂ) (hE : EFunction coeffs) (α : ℝ) (hα : IsAlgebraic ℚ α)
  | GFunctionTranscendental (f : ℂ → ℂ) (hG : IsGFunction f) (hTrans : ∀ α, Transcendental ℚ (f α))
  | ConjecturallyIrrational (n : ℕ) (label : String)

def classifyOrigin : (ℝ) → Option TruncOrigin := sorry  -- partial, only for canonical cases

theorem omega_four_origin_separation :
  classifyOrigin Real.pi = some (TruncOrigin.GFunctionTranscendental _ _ _) ∧
  classifyOrigin (Real.exp 1) = some (TruncOrigin.EFunction _ _ _ _) ∧
  classifyOrigin (Real.sqrt 2) = some (TruncOrigin.Algebraic _ _) ∧
  classifyOrigin catalanG = some (TruncOrigin.ConjecturallyIrrational 2 "dirichletBeta2")
```

**Proof strategy.**
- For each constant, construct the witness (polynomial, E-function data, G-function data, or ConjecturallyIrrational wrapper).
- Use constructor-disjointness (`TruncOrigin.noConfusion`) to get the distinctness.

**Effort.** 5 sessions on top of Layers 2 and 3 being proved (needs `Real.exp_one_transcendental` and E-function framework).

## 5. Catalan `catalanG` bookkeeping

We need to give Lean a clean definition of G. Options:

```lean
-- Option A: direct Dirichlet β
noncomputable def catalanG : ℝ := ∑' n, (-1 : ℝ)^n / (2*n+1)^2

-- Option B: via dirichlet β function
noncomputable def catalanG : ℝ := dirichletBeta 2
```

Option A needs `∑'` summability proof (alternating series, bounded). Option B requires `dirichletBeta : ℝ → ℝ` to be in Mathlib first — it's **not** as of v4.29.0.

Pick option A, prove summability via `Real.summable_one_div_pow_alt`.

Effort: 3 sessions.

## 6. Integration with existing OmegaTheory Irrationality/ tree

The new IrrationalityClasses/ tree does NOT write .lean files this session (per coordinator). When we do:

| New file | Imports |
|---|---|
| `OmegaTheory/IrrationalityClasses/Basic.lean` | `Mathlib.Analysis.Real.Pi.Bounds`, `Mathlib.Data.Real.Sqrt`, `OmegaTheory.Irrationality.Approximations` |
| `OmegaTheory/IrrationalityClasses/Catalan.lean` | `Basic` + `Mathlib.Analysis.SpecialFunctions.Complex.LogBounds` |
| `OmegaTheory/IrrationalityClasses/EFunction.lean` | `Basic` + `Mathlib.RingTheory.Algebraic.Basic` + `Mathlib.NumberTheory.Transcendental.Lindemann.AnalyticalPart` |
| `OmegaTheory/IrrationalityClasses/TruncOrigin.lean` | all of the above |
| `OmegaTheory/IrrationalityClasses/SeparationTheorem.lean` | all of the above |

Register each in `OmegaTheory/Basic.lean`.

## 7. Summary — what compiles today

| Sub-theorem | Blocker | Session estimate |
|---|---|---|
| `four_irrationals_pairwise_distinct` (Layer 1) | none | 1–2 |
| `sqrt2_is_algebraic` | none | 1 |
| `pi_transcendental_wrapper` | Mathlib Lindemann port | 0.5 after port |
| `e_transcendental` | Mathlib Hermite port | 20–25 |
| `e_is_E_function_value` | E-function framework | 30+ |
| `pi_is_not_E_function_value` | E-function framework + classification | 30+ |
| `catalanG` defined | minor (summability) | 3 |
| `omega_four_origin_separation` | all of above | 5 after prereqs |

**Total sessions to ship Layer 1–4 under current Mathlib**: ~100 sessions (80 of which are the Hermite + E-function ports).
**Total sessions if Mathlib catches up in 2027** (Lindemann in Mathlib): ~20 sessions.

See `09_session_budget.md` for the full budget.
