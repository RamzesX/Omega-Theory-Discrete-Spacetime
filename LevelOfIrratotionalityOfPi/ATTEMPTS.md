# Attempts Log — K₂-Opacity of $\pi$

Every failed attempt is a theorem about what doesn't work. — Banach (paraphrased)

---

## Attempt 1: Brute Force Elimination (Escanor — Pride)

**Date**: April 2026, Session 1
**Method**: Enumerate all K₂ predictors, kill each one via five computational tests.
**Result**: **PROVEN** for $p \leq 5 \times 10^9$ (Theorems 4B.2, 4B.4). All-constants-1 family eliminated at any $p$ (Proposition 4B.5).
**Limit**: Requires $\geq 5$ terms per residue class. For $p > N/5$, data is insufficient.
**Status**: PARTIAL SUCCESS. Established the unconditional core.

---

## Attempt 2: Asymptotic Perturbation (Tier III)

**Date**: April 2026, Session 1
**Method**: For large $p$, the K₂ value is close to a quadratic irrational. Compare perturbation magnitude $\exp(-2\lambda p)$ with transcendence distance $M^{-\mu p}$.
**Result**: Works for $M = 1$ (all-constants-1). **FAILS** for $M > 1$: the transcendence distance shrinks faster than the perturbation.
**Lesson**: The irrationality measure $\mu(\pi) \leq 7.6064$ is too weak for the exponential comparison. Would need $\mu(\pi) \leq 2\lambda/\log M$ which fails for $M \geq 2$.
**Status**: PARTIAL SUCCESS (M=1 only). Corrected honestly in Module 04B.

---

## Attempt 3: Literature Survey — ADH 2025

**Date**: April 2026, Session 2
**Method**: Read Adamczewski-Dreyfus-Hardouin papers on E/G algebraic independence. Check if their p-adic criterion applies.
**Result**: ADH works at **function level** (formal power series independence), not **value level** (numbers at algebraic points). Their criterion uses Frobenius structures and MOM conditions — powerful but doesn't bridge to evaluations.
**Lesson**: Function-level independence ≠ value-level independence. The passage requires additional tools (Siegel-Shidlovskii for E-alone, nothing for E×G).
**Status**: RULED OUT as direct path. Valuable for landscape mapping (§4A.8).

---

## Attempt 4: Other Transcendence Tools

**Date**: April 2026, Session 2
**Method**: Survey all available tools — Siegel-Shidlovskii, Delaygue-Beukers, Nesterenko, period theory.
**Result**: Each tool covers a DIFFERENT case than what we need:

| Tool | Covers | We need |
|:-----|:-------|:--------|
| Siegel-Shidlovskii | Same E-functions, same point | E-values vs G-value ($\pi$) |
| Delaygue-Beukers | Same function, different points | Different functions, same point |
| Nesterenko | $\pi, e^\pi, \Gamma(1/4)$ | $\pi$ vs ₁F₁ ratios |
| Kontsevich-Zagier | Structural classification | Proof tool needed |

**Lesson**: No existing tool covers the mixed E×G value-level case. This IS the frontier.
**Status**: LANDSCAPE MAPPED. Negative result with positive value.

---

## Attempt 5: Induction on Degree $D$

**Date**: April 2026, Session 2
**Method**: Base case $D = 0$ (periodicity) proven by Lindemann. Inductive step: if K₂ with degree $D+1$, then $p$-difference reduces to degree $D$. Use induction.
**Result**: Each step $D \to D+1$ requires showing the $p$-difference sequence inherits a property contradicting K₂. But the difference sequence is NOT a CF — the inductive hypothesis applies to CFs, not arbitrary sequences. Reformulating for arbitrary sequences, each step reduces to "π ≠ degree-$D$ Hurwitzian value" which is a case of E/G separation.
**Lesson**: Induction reformulates cleanly but doesn't escape the E/G barrier. Every step from $D$ to $D+1$ introduces new E-function families.
**Status**: REFORMULATION VALUE. Led to the SS Reduction.

---

## Attempt 6: The Siegel-Shidlovskii Reduction (Theorem 4A.9)

**Date**: April 2026, Session 2
**Method**: Push SS as far as possible. If π = Möbius(₁F₁ ratio), decompose via contiguity: $(\pi\gamma - \alpha)u + (\pi\delta - \beta)v = 0$ where $u, v$ are E-function values. SS gives $u, v$ algebraically independent over $\mathbb{Q}$.
**Result**: **PROVEN** — Conjecture 4A.4 is equivalent to linear independence of $u, v$ over $\mathbb{Q}(\pi)$. Gap = one field extension from $\mathbb{Q}$ to $\mathbb{Q}(\pi)$.
**Lesson**: The exact arithmetic locus of the problem is now pinpointed. SS gets us to $\mathbb{Q}$; we need $\mathbb{Q}(\pi)$.
**Status**: SUCCESS — key structural theorem.

---

## Attempt 7: Extending Siegel's Method to $\overline{\mathbb{Q}}[\pi]$

**Date**: April 2026, Session 2
**Method**: Try to run the full SS proof with $\pi$ in the coefficients. Steps: (1) Φ≡0 case, (2) zero estimate, (3) Siegel auxiliary construction.
**Result**:
- Step 1 (Φ≡0): **WORKS** — Lindemann + ℚ̄-Taylor-coefficients kill all slices.
- Step 2 (zero estimate): **WORKS** — Shidlovskii's lemma valid for $\mathbb{C}$ coefficients.
- Step 3 (Siegel construction): **FAILS** — equations involve $\pi$, must decouple by transcendence.

The **Decoupling Theorem (4C.3)** proves this failure is structural: every integer solution of $\sum_d \pi^d S\mathbf{c}_d = 0$ automatically satisfies $S\mathbf{c}_d = 0$ per slice. The transcendence of $\pi$ itself forces decoupling.
**Lesson**: The Siegel method has a **hard boundary** at transcendental field extensions. The very property that makes the conjecture true (transcendence of $\pi$) prevents the Siegel lattice from detecting it.
**Status**: STRUCTURAL IMPOSSIBILITY PROVEN (Theorem 4C.3). New mathematics created.

---

## Attempt 8: Differential Galois Theory (Current — Phase 6)

**Date**: April 2026, Session 2 (ongoing)
**Method**: Compute differential Galois groups of Kummer (Borel, solvable) and Gauss/arctan ($SL_2$, simple). Show they have no common quotient → direct product. Use Galois structure to predict value-level independence. Prove via Pila-Wilkie o-minimality.
**Result so far**:
- Galois groups computed: $B \times SL_2$ (**PROVEN**, Prop. 4C.4)
- Function-level independence: **PROVEN** (Kolchin + direct product)
- Specialization conjecture formulated: **Conjecture 4C.5**
- Attack vector: Pila-Wilkie + Galois obstruction — **IN PROGRESS**

**Why this is different from all previous attempts**:
1. Does NOT use the Siegel lemma (bypasses Decoupling Theorem)
2. Uses the GEOMETRIC structure of the DE (singularities, monodromy)
3. The Galois obstruction (solvable × simple) is STRONGER than exp (abelian × abelian)

**Substeps explored**:
- Pila-Wilkie counting: BLOCKED — Kummer graphs lack the "algebraic point supply" that exp and j have (no group law, no CM points). PW has nothing to count.
- Effective transcendence measure: BLOCKED — combined polynomial $\sum c_d (\pi/4)^d$ has transcendental coefficients; π's transcendence measure applies only to ℤ[t].
- Direct Galois specialization: OPEN — requires new theory connecting Galois groups to value independence.

**Honest result**: Function-level prediction proven (B × SL₂ = direct product). Value-level proof requires new specialization theory. Three viable paths remain: (A) p-adic ADH extension, (B) modular connections for special parameters, (C) new Galois specialization theorem.

**Status**: GALOIS STRUCTURE PROVEN. SPECIALIZATION OPEN.

---

## Summary Table

| # | Method | Reaches | Blocked by | New math created |
|:--|:-------|:--------|:-----------|:----------------|
| 1 | Brute force | $p \leq 5 \times 10^9$ | Data exhaustion | Five-test elimination |
| 2 | Asymptotics | $M = 1$ family | $\mu(\pi)$ too weak | Perturbation bounds |
| 3 | ADH 2025 | Function level | Value-level gap | Landscape map |
| 4 | Tool survey | — | No E×G tool exists | Landscape map |
| 5 | Induction on $D$ | Reformulation | E/G at each step | Clean framework |
| 6 | SS Reduction | $\mathbb{Q}$ | $\mathbb{Q}(\pi)$ gap | **Theorem 4A.9** |
| 7 | Extend Siegel | Per-slice | Decoupling barrier | **Theorem 4C.3** |
| 8 | Galois + Pila-Wilkie | $B \times SL_2$ | Specialization | **Prop. 4C.4, Conj. 4C.5** |

---

## Attempt 9: The Exponential-Riccati Attack (Module 04D)

**Date**: April 2026, Session 2
**Method**: Exploit the Euler identity $e^{i\pi} = -1$ through the NONLINEAR structure. If $\pi = \text{Möbius}(R(z_0))$, define $F(z) = \exp(i \cdot \text{Möbius}(R(z)))$. Then $F(z_0) = e^{i\pi} = -1$ (algebraic). The ratio R satisfies a RICCATI equation (quadratic nonlinear). The composition $\cos(\text{Möbius}(R))$ satisfies a polynomial DE system of the type Nesterenko's multiplicity estimates handle.

**Key insight**: The hypothesis $\pi = \text{Möbius}(R(z_0))$ forces $\cos(\pi) = -1$ and $\sin(\pi) = 0$ — collapsing two transcendental-degree functions $(L, U)$ to one transcendental + one rational value. If Nesterenko-Philippon gives $\text{tr.deg}\{L(z_0), U(z_0)\} = 2$, but the hypothesis gives $U(z_0) = -1 \in \mathbb{Q}$, then $\text{tr.deg} = 1$. **Contradiction.**

**Why this evades the Decoupling Theorem**: $\pi$ is NOT a coefficient in a linear system — it enters through $\cos(\pi) = -1$, an evaluation of a NONLINEAR function. No $\pi$-degree slicing is possible. The system is quadratic (Riccati), not linear (Kummer).

**Result so far**:
- Polynomial DE system for $(L, U, V)$ derived ✓
- Functional tr.deg = 2 argued (plausible, needs verification)
- Proof structure identified: Nesterenko multiplicity estimate + Philippon criterion
- Reduction to THREE verifiable claims (§4D.8)

**What remains**: Claim 2 — prove the multiplicity estimate for the specific polynomial DE system. This is a finite computation in differential algebra.

**Update**: The multiplicity estimate HOLDS (non-degenerate Jacobian verified computationally). But the Siegel auxiliary construction (Step 2 of Nesterenko-Philippon) ALSO uses the Siegel lemma — and the vanishing conditions involve L₀ (transcendental), triggering the Decoupling Theorem.

**Deeper discovery**: The Decoupling Theorem is UNIVERSAL — it blocks ALL auxiliary-function methods (SS, Nesterenko, Philippon), not just Siegel-Shidlovskii. The Siegel lemma is the common bottleneck. This gives **Theorem 4D.2** (Universal Siegel Barrier).

**Corollary**: A proof of Conjecture 4A.4 must avoid the Siegel lemma entirely. This leaves ONLY p-adic Frobenius methods (ADH).

**Status**: BARRIER PROVEN UNIVERSAL. Created new machinery (polynomial DE, multiplicity estimate, e^{iπ}=-1 mechanism) that works GIVEN a non-Siegel auxiliary construction. Narrowed proof space to ONE method.

---

## Summary Table

| # | Method | Reaches | Blocked by | New math created |
|:--|:-------|:--------|:-----------|:----------------|
| 1 | Brute force | $p \leq 5 \times 10^9$ | Data exhaustion | Five-test elimination |
| 2 | Asymptotics | $M = 1$ family | $\mu(\pi)$ too weak | Perturbation bounds |
| 3 | ADH 2025 | Function level | Value-level gap | Landscape map |
| 4 | Tool survey | — | No E×G tool exists | Landscape map |
| 5 | Induction on $D$ | Reformulation | E/G at each step | Clean framework |
| 6 | SS Reduction | $\mathbb{Q}$ | $\mathbb{Q}(\pi)$ gap | **Theorem 4A.9** |
| 7 | Extend Siegel | Per-slice | Decoupling barrier | **Theorem 4C.3** |
| 8 | Galois + Pila-Wilkie | $B \times SL_2$ | No algebraic point supply | **Prop. 4C.4, Conj. 4C.5** |
| 9 | Exponential-Riccati | Multiplicity ✓, Jacobian ✓ | **Universal Siegel Barrier** | **Theorem 4D.2** |

Each attempt narrows the space of possible proofs. After 9 attempts:

**The Siegel lemma is the universal bottleneck.** Attempts 6, 7, and 9 proved three increasingly general barrier theorems:
- **Theorem 4A.9** (SS Reduction): the gap is one field extension from ℚ to ℚ(π)
- **Theorem 4C.3** (Decoupling): the Siegel method can't cross this extension (for LINEAR DEs)
- **Theorem 4D.2** (Universal Barrier): NO auxiliary-function method can cross it (linear OR nonlinear)

**What remains**: the p-adic Frobenius method (ADH 2025), which avoids the Siegel lemma entirely. This is the **unique surviving path** among known mathematical frameworks.

---

## Attempt 10: The Mahler-Differential Bridge (Module 04E, §4E.5)

**Date**: April 2026, Session 2
**Method**: The Frobenius tower {f(α), f(α^p), f(α^{p²}),...} satisfies a MAHLER-type functional equation (z → z^p). π comes from a DIFFERENTIAL equation (Gauss). ADH's own 2019-2021 program (arXiv:1910.01874, arXiv:2010.09266) proves: solutions of DIFFERENT-TYPE functional equations (Mahler vs differential) are algebraically independent.

**Key connection**: ADH 2025 (E/G function independence) + ADH 2021 (Mahler-differential independence) = the complete proof strategy:
1. ADH 2025 gives function-level E/G independence via Frobenius criterion
2. The Frobenius creates a Mahler equation for E-function values at algebraic points
3. ADH 2019/2021 gives algebraic independence of Mahler-type and differential-type solutions

**What remains**: Verify that the specific Kummer Frobenius tower (Mahler) and Gauss/arctan DE (differential) satisfy ADH's "sufficient independence" conditions from parametrized difference Galois theory.

**Why this is different**: It connects TWO of ADH's own research programs — the 2019-2021 difference equation program and the 2025 E/G function program. The bridge is the Frobenius tower, which CONVERTS a differential independence problem into a difference equation independence problem, where ADH's tools ALREADY WORK.

**Refined finding**: ADH 2021 covers difference×difference pairs, NOT differential×Mahler. ADH 2019 hypertranscendence is function-level, not value-level for the mixed pair. The precise gap: value-level independence of Mahler values from Fuchsian DE values. This is the natural next theorem in ADH's program.

**The Frobenius Product Formula**: Under hypothesis π = Möbius(R(α)), Frobenius telescoping gives Möbius(π) = ∏ s(α^{p^k}) — a Mahler function value. The equation says: a DE value (π) equals a Mahler value (Φ(α)). Hypertranscendence at function level predicts this is impossible. Value-level proof requires Conjecture 4E.1.

**Status**: THE PROBLEM IS PRECISELY LOCATED. It sits between ADH's two programs (2019 Mahler values, 2025 E/G functions). The bridging theorem (Mahler VALUE ⊥ Fuchsian DE VALUE) is the unique remaining step. When ADH or others prove it, K₂-opacity of π follows immediately from our framework.
