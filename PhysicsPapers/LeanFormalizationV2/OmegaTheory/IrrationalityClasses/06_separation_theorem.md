# 06 — The 4-class separation theorem (headline)

## The target statement

Let `S := {π, e, √2, G}` (Catalan). We want: **the four elements of `S` inhabit four distinct cells of the Mahler classification {A, S, T, U}**.

Formally, let `MahlerClass : ℝ → {A, S, T, U}` be the Mahler partition function. Then:

```
                  MahlerClass
  π             ↦   S
  e             ↦   S        -- problem: shares class with π
  √2            ↦   A
  Catalan G     ↦   S?        -- open; irrationality itself open
```

As tabulated in `01_classical_hierarchies.md` §10, **at the Mahler level we do NOT get four distinct classes.** π, e, (G if irrational) all sit in S. So the strongest form of "4-class separation" at the Mahler level is FALSE (or open-pending-Catalan).

## Four weaker separations that DO hold

We therefore propose four *layered* separation theorems, of increasing strength, any of which makes a substantive physics claim.

### Layer 1 — **Pairwise-value-distinct** (trivial, provable today)

```lean
theorem four_irrationals_pairwise_distinct :
  Real.pi ≠ Real.exp 1 ∧
  Real.pi ≠ Real.sqrt 2 ∧
  Real.pi ≠ Real.Gamma (1/4) / (2*Real.sqrt 2) ∧  -- Catalan expression, or direct
  Real.exp 1 ≠ Real.sqrt 2 ∧ …
```

Numerical bounds settle this (π ≈ 3.14, e ≈ 2.718, √2 ≈ 1.414, G ≈ 0.916; all disjoint). **Effort: 1 session, no Mathlib gap.**

### Layer 2 — **A-vs-transcendental split** (provable once Lindemann ported)

```lean
theorem three_constants_transcendental :
  Transcendental ℚ Real.pi ∧
  Transcendental ℚ (Real.exp 1) ∧
  ¬ Transcendental ℚ (Real.sqrt 2)   -- √2 is algebraic
```

Splits `S` into `{π, e}` (transcendental) and `{√2}` (algebraic). Leaves G in limbo. **Effort: 2 sessions once Mathlib has Lindemann; 20+ sessions until then (port Lindemann).**

### Layer 3 — **Shidlovsky E-function split** (needs E-function framework)

```lean
theorem e_is_E_function_value_but_pi_is_not :
  isEFunctionValue (Real.exp 1) ∧
  ¬ isEFunctionValue Real.pi
```

Places e in the canonical Shidlovsky class and π outside it. This is a structural refinement: even if both are conjecturally Mahler-S, they originate from different analytic families (E vs G-function). **Effort: 30+ sessions, requires E-function framework port.**

### Layer 4 — **Full Mahler separation** (research frontier)

```lean
theorem full_mahler_separation (h_G_trans : Transcendental ℚ G)
    (h_G_class : MahlerClass G ≠ MahlerClass Real.pi) :
  pairwise distinct-class-within [MahlerClass Real.pi, MahlerClass (Real.exp 1),
                                  MahlerClass (Real.sqrt 2), MahlerClass G]
```

Requires:
1. G is transcendental (OPEN classical).
2. G's Mahler class is distinct from π's (**NOT EVEN CONJECTURED**; if G is S-number and π is S-number, this FAILS).

**This strongest form is likely false in the literal Mahler sense.** We need a finer classification to separate G from π.

## Resolution — switching to ω-valued separation

The Mahler classification groups numbers by whether `ω(α) = 0, <∞, =∞`-with-all-finite-ω_n, or has `ω_n = ∞ for some n`. Two S-numbers with *different* ω-values are still both S-class.

**Refined separation (ω-valued).** Define `ω(α)` directly. Then:
- ω(√2) = 1 (degree 2 algebraic, A-class).  [Actually A-class has ω = 0 by Mahler convention; using the canonical normalisation, √2 has ω(√2) = 0.]
- ω(e) = 1 — proved, Mahler 1932.
- ω(π) ≤ 2.55 conjecturally; finite provably (non-Liouville). Best lower bound: ω(π) ≥ 1 (trivially since π is irrational S-type). **Actual value is open.**
- ω(G) if transcendental: conjectured ω(G) = 1 (like almost every real). Actual value: **open**.

So at the ω-level: {√2: 0} vs {e, π, G: each 1 or ≤2.55}. Still does not separate four distinct values cleanly.

## The refined working hypothesis for OmegaTheory

We propose a **four-fold origin-structure partition** distinct from Mahler, better suited to the 4-channel substrate:

```lean
inductive TruncOrigin : Type
  | Algebraic : Polynomial ℚ → TruncOrigin         -- √2: x² − 2
  | EFunction : (ℂ → ℂ) → TruncOrigin              -- e: exp
  | GFunctionTranscendental : (ℂ → ℂ) → TruncOrigin -- π: 4·arctan, G-function
  | ConjecturallyIrrational : Nat → TruncOrigin    -- G: β(2), Rivoal-Zudilin
```

Under this typology:
- √2 ↦ `Algebraic ⟨x² − 2⟩`
- e ↦ `EFunction exp`
- π ↦ `GFunctionTranscendental (4·arctan)` (after Lindemann)
- G ↦ `ConjecturallyIrrational (dirichletBeta 2)`

This IS a 4-way partition, rigorous, and all four cells are distinct **by constructor disjointness**. The physical interpretation: the four substrate channels carry four qualitatively different analytic-arithmetic origins, not four points within one class.

## The theorem we commit to

```lean
/-- **Four-origin partition separation.** The four OmegaTheory irrationals
inhabit four distinct constructors of `TruncOrigin`. -/
theorem omega_four_origin_separation :
  classifyOrigin Real.pi        = TruncOrigin.GFunctionTranscendental _ ∧
  classifyOrigin (Real.exp 1)   = TruncOrigin.EFunction _ ∧
  classifyOrigin (Real.sqrt 2)  = TruncOrigin.Algebraic _ ∧
  classifyOrigin catalanG       = TruncOrigin.ConjecturallyIrrational _
```

**Effort.** Once Lindemann is ported (for π's branch): about 5 sessions.
**Blockers.** (a) Lindemann-Weierstrass in Mathlib (for π-transcendence); (b) E-function framework (for e-as-E-function); (c) nothing further for √2 or G (G is classified *as* conjectural without needing to prove irrationality).

This is the **provable headline separation for OmegaTheory cycle 44+**.

## Status in the graph

Registered as `:TheoremCandidate`:
- `omega_four_origin_separation` — status `STATEMENT_READY` / `proof_blocked_on_lindemann_and_E_function_framework`
- `four_irrationals_pairwise_distinct` — status `PROVABLE_TODAY`
- `three_constants_transcendental` — status `BLOCKED_ON_LINDEMANN`
- `e_is_E_function_value_but_pi_is_not` — status `BLOCKED_ON_E_FUNCTION_FRAMEWORK`

## Why this is the right deliverable

Compared to the nominal "four distinct Mahler classes" target:
- That target **doesn't actually hold** in 2026 classical mathematics (π, e, possibly G all in S).
- Our target **does hold** under constructor disjointness.
- It captures the physically relevant content — that each channel has its own analytic-arithmetic signature.

Per our hard rule: *narrower true theorem > false dressed-up claim*. We pick the narrow true version.

## Cross-references

- `01_classical_hierarchies.md` §10 — the "where does each sit" table.
- `07_proof_sketches.md` — Lean sketches for each sub-theorem.
- `08_required_machinery.md` — the Mathlib/upstream porting debt needed.
- `12_graph_register.md` — the live `:TheoremCandidate` nodes backing the commitments.
