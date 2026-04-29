# T-5 HARD PIVOT — Strategic Memo (2026-04-29)

## Context

User mandate 2026-04-29 verbatim: *"Pivot to HARD direction (Schmidt aux poly construction — multi-day, research-grade). Stop the cron"*.

Cron `1d5d80a9` (heartbeat) + `28d0aa09` (strategic) + `73444ff3` (daily) STOPPED. Bulk parametric-instantiation phase closed at Bundle-LXXI / commit `bbb6a76` (71 bundles, 1081+ lemmas, GREEN 2417 jobs).

## State of T-5 Phase 7

### Already shipped (UNCONDITIONAL)
- **Single-variable scaffolding** (s33-s182): Taylor at root, integer non-vanishing lower bound, Roth-form distance bound (multi-variable indexing already used internally). Generic Roth ALL DEGREES holds for **ε > n - 2**.
- **Quadratic Roth UNCONDITIONAL** (s130-s162): `IsQuadraticAlgebraic α → Roth bound`. ULTRA-V8 mega bundle.
- **3 parametric families** (Bundles XVI / XXIII / XXIV): sqrt-prime, cbrt_nat, kthRootNat — universal statements for any (k, n).
- **Multivariate Schmidt aux poly existence** (ext #16, `T5_Phase7_SchmidtAuxiliaryPolynomial.lean`): for indices `I : J → BoundedMI n d` and uniform eval point `α : Fin n → ℤ` with `card J < (d+1)^n`, multivariate aux poly `p : MvPolynomial (Fin n) ℤ` exists with `p ∈ restrictDegree d`, `vanishingMatrix · polyToCoeffs p = 0`, plus explicit Siegel norm bound `‖c‖ ≤ ((d+1)^n · max 1 |α|^d)^{|J|/((d+1)^n - |J|)}`.

### NAMED but UNDISCHARGED
- **`SchmidtAuxPolyExists`** (single-variable Prop, `T5_Phase7_SchmidtAuxPolyHypothesis.lean`):
  ```
  ∀ α irrational algebraic, ∀ ε > 0,
    ∃ p ∈ ℤ[X], k ∈ ℕ,
      p ≠ 0 ∧ aeval α p = 0 ∧ k(2+ε) > deg(p) ∧
      (∀ i < k, taylor α (p.map cast).coeff i = 0) ∧
      0 < Σ_{i ≥ k} |taylor α (p.map cast).coeff i|.
  ```
  Used by `T5_cubic_roth_conditional_via_schmidt` and downstream conditional capstones.

### KEY OBSERVATION (paper-grade)
The single-variable `SchmidtAuxPolyExists` Prop as stated **CANNOT BE DISCHARGED for n ≥ 3 with ε ∈ (0, n-2]**. Reason: order-`k` vanishing of `p ∈ ℤ[X]` at irrational algebraic α of degree `n` forces `(min poly)^k | p`, so `deg p ≥ nk`. Combined with `k(2+ε) > deg p`, we need `k(2+ε) > nk`, i.e., `2 + ε > n`, i.e., `ε > n - 2`. The single-variable Prop is FALSE outside this regime.

### Existing achievements ARE consistent with this
The "GENERIC ROTH ALL DEGREES with ε > n-2" already-landed result (s173-s177) is exactly the regime where single-variable Schmidt suffices. The HARD work (ε ∈ (0, n-2], n ≥ 3) requires the **multivariate** aux poly.

## What "discharge SchmidtAuxPolyExists" actually means

To close T-5 unconditionally (any ε > 0, any algebraic n), we need to **REPLACE** the single-variable Prop with its multivariate counterpart in the conditional capstones, then PROVE the multivariate version.

### Replacement Prop signature (target)
```
def SchmidtAuxPolyMvExists : Prop :=
  ∀ (α : ℝ), Irrational α → IsAlgebraic ℤ α →
  ∀ (ε : ℝ), 0 < ε →
  ∃ (m d : ℕ) (P : MvPolynomial (Fin m) ℤ) (I : Fin m → ℕ),
    P ≠ 0 ∧
    P ∈ MvPolynomial.restrictDegree (Fin m) ℤ d ∧
    -- High-index zero at diagonal (α, ..., α)
    (∀ J : Fin m → ℕ, (∑ i, (J i : ℝ) / (d : ℝ)) < some_threshold →
      MvPolynomial.eval (fun _ => α) (P.derivative^[J] ?) = 0) ∧
    -- Bounded coefficients (Siegel)
    (some_norm P ≤ explicit_bound m d ε) ∧
    -- Non-vanishing somewhere
    (some_witness ≠ 0)
```

Exact signature TBD — needs alignment with Roth's classical statement (see Schmidt's *Diophantine Approximation* Chapter VI).

### Steps to discharge (multi-day plan)

#### Step A: Multivariate Taylor at integer point
Given `α : Fin m → ℤ` and `P ∈ MvPolynomial (Fin m) ℤ`, expand `P(X)` around `α` via multi-index Taylor:
```
P(α + (X - α)) = Σ_J (1 / J!) · (multiIteratedPDeriv J P)(α) · (X - α)^J
```
Project already has `multiIteratedPDeriv` vocabulary (T5_Phase3-Phase6). Need closed form at integer `α`.

#### Step B: Schmidt index function
Define index of P at α relative to weights `R : Fin m → ℕ`:
```
indexAt α R P = inf { Σ J i / R i : (multiIteratedPDeriv J P)(α) ≠ 0 }
```
And show: high index ⇒ all multi-derivatives ≤ that index vanish.

#### Step C: Siegel index bound
Given the multivariate aux poly from ext #16 (Siegel construction), it has high index ≥ θ(m, ε, n) at (α, ..., α) where `θ → m/2 - ε` as `m → ∞`.

#### Step D: Roth's lemma (Wronskian / index reduction)
Show: if rationals `q_1, ..., q_m` are sufficiently close to α with bounded denominators, then index of P at (q_1, ..., q_m) is at most θ + δ for some controlled δ. This is the HARDEST piece (Wronskian construction, Roth's lemma, multi-day work).

#### Step E: Integer non-vanishing
At (q_1, ..., q_m) with denominators d_1, ..., d_m, the value `P(q_1, ..., q_m) · ∏ d_i^{R_i}` is an integer of bounded size. By Step D, this is small unless zero. By Step B + sufficient closeness, it's nonzero. Contradiction → Roth bound on individual |q_i - α|.

#### Step F: Compose with infinite-rationals pigeonhole
Given infinitely many q with |q - α| < q.den^{-(2+ε)} (the assumption violating Roth), pick `m` of them with sufficiently spread denominators. Apply Steps A-E to derive contradiction.

#### Step G: Bridge to existing T-5 Conditional
Wire the unconditional multivariate Roth to `RothTheorem` Prop and existing conditional capstones.

### Effort estimate
- **Step A**: 1-2 days (composition of existing s33-s35 + new MvPolynomial Taylor expansion)
- **Step B**: 1 day (definitional + key lemmas)
- **Step C**: 1-2 days (specialization of ext #16 with explicit weight choice)
- **Step D**: 4-7 days (HARDEST, Wronskian / index reduction)
- **Step E**: 2-3 days (integer non-vanishing chain)
- **Step F**: 2-3 days (pigeonhole + composition)
- **Step G**: 1 day (Prop bridge + capstone re-routing)

**Total: 12-19 days single-thread**. Aligns with T-4 precedent (Lindemann-Weierstrass: 1 day intense, ~3000 lines, but T-5 is structurally larger with Wronskian).

## Concrete first move (this fire)

Define `Polynomial.indexAt` for single-variable Polynomial (already partially used in s183 / Phase 7 ENTRY work) — extending it to MvPolynomial multi-index form. This is foundational for Steps A and B.

Output file: `T5_Phase7_MvPolyIndexFunction.lean` (this fire — first piece).

## References (literature)
- **Roth (1955)** — original paper: "Rational approximations to algebraic numbers". *Mathematika* 2.
- **Schmidt (1971)** — *Lectures on Diophantine Approximations*. Chapter VI.
- **Bombieri & Gubler (2006)** — *Heights in Diophantine Geometry*. Chapter 6 (Roth's theorem proof).
- **Cassels (1957)** — *An Introduction to Diophantine Approximation*. (Earlier exposition.)

## Honest accounting

The bulk parametric instantiation (Bundles I-LXXI) provides **comprehensive concrete witnesses** but **does not advance the unconditional T-5 closure**. Each new bulk bundle is a 1-line `T5_isAlgebraicOfDegree_kthRootNat k n (by norm_num)` instantiation.

The HARD pivot here is necessary for genuine T-5 closure. Effort committed: research-grade, multi-day, Roth-Schmidt-Wirsing-Bombieri-Gubler chain.

Per Escanor-Pride / Erdős-Primarch: Pride forbids citation-only proofs. Slim is antipattern. Full prove mode only.
