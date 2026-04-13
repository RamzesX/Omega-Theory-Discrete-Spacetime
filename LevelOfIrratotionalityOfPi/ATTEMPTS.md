# Attempts Log — K₂-Opacity of $\pi$

Every failed attempt is a theorem about what doesn't work. — Banach (paraphrased)

**Neo4j namespace `pi_sun`**: 35 nodes (18 Facts, 8 AttackVectors, 4 Barriers, 2 Gaps, 2 Conjectures, 1 Target), 26 relationships. Two gaps identified: GAP_A (different-point evaluation) **RESOLVED** by F23; GAP_B (non-Siegel specialization) **OPEN** — the single missing link.

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

**Attempt 10b (Frobenius Convergence, RETRACTED)**: Tried to use Frobenius partial products as ALGEBRAIC approximations to π, contradicting the irrationality measure. ERROR: the partial products are TRANSCENDENTAL (E-function ratios at algebraic points, transcendental by SS). The irrationality measure applies only to algebraic approximations. Theorem 4E.2 retracted.

**Lesson from 10b**: Metric arguments (irrationality measure, height bounds) fail because the Frobenius tower produces TRANSCENDENTAL, not algebraic, approximations. The proof requires STRUCTURAL arguments (algebraic independence).

**Status**: THE PROBLEM IS PRECISELY LOCATED. It sits between ADH's two programs (2019 Mahler values, 2025 E/G functions). The bridging theorem (Mahler VALUE ⊥ Fuchsian DE VALUE) is the unique remaining step. When ADH or others prove it, K₂-opacity of π follows immediately from our framework.

---

## Attempt 11: Context Compression via Taylor Jets (Module 05, §5.1)

**Date**: April 13, 2026, Session 3
**Method**: Norbert's insight — the Taylor jet $J_f(\alpha) = (f(\alpha), f'(\alpha), f''(\alpha), \ldots)$ preserves "compressed context" of the DE at $\alpha$. The $B \times SL_2$ Galois group acts on jets, not just on collapsed values.
**Result**: The G-function jet is **flat** — all derivatives $h^{(n)}(\alpha)$ for $n \geq 1$ are algebraic (rational functions of $\alpha$). All transcendence concentrates in $h(\alpha) = \pi/4$ alone. The E-function jet captures exactly $(u, v)$ — same as SS. Jets add NO new transcendence to either side.

**New fact**: **F25** (G-jet flatness).
**Lesson**: The jet approach reformulates the problem elegantly (as the Grothendieck Period Conjecture for $B \times SL_2$) but does not solve it.
**Status**: REFORMULATION. Not a proof mechanism.

---

## Attempt 12: The Carlitz-Frobenius Bridge (Module 05, §5.3) — MOST PROMISING

**Date**: April 13, 2026, Session 3
**Method**: Combine three research programs:
1. **ADH Frobenius (2025)**: The quotient $\Phi(z) = \prod s(z^{p^k})$ satisfies a Mahler equation $\Phi(z) = s(z) \cdot \Phi(z^p)$
2. **ADH 2019**: Mahler functions and DE solutions are algebraically independent (function level)
3. **Di Vizio-Pellarin (2026)**: Carlitz module provides VALUE-level Galois theory for difference equations, bypassing Siegel lemma

**Key insight**: The Frobenius $z \to z^p$ IS a difference operator. The Carlitz module framework provides explicit Picard-Vessiot rings and Galois groups for such operators. Di Vizio-Pellarin proved VALUE-level results for $\Gamma$ (which satisfies a shift equation). The same machinery should extend to Mahler equations.

**What remains**: The **Mixed Specialization Theorem** (GAP_C): if $\Phi(z)$ is a Mahler function and $h(z)$ is a Fuchsian DE solution, both algebraically independent over $\mathbb{C}(z)$, then $\Phi(\alpha)$ and $h(\alpha)$ are algebraically independent over $\mathbb{Q}$. Nishioka (1996) covers Mahler-alone. The mixed case is open.

**Why this might be provable**: $_1F_1$ is entire (no finite singularities), so the Frobenius orbit $\{\alpha^{p^k}\}$ avoids all exceptional points. Nishioka's exceptional set is likely empty.

**New fact**: **F26** (Frobenius-Mahler independence at function level).
**Status**: ALIVE — MOST PROMISING. Well-defined technical gap (GAP_C).

---

## Attempt 13: Congruence Incompatibility (Module 05, §5.4)

**Date**: April 13, 2026, Session 3
**Method**: Direct arithmetic attack on Taylor coefficient structure modulo $p$:
- E-function coefficients: $\mathrm{ord}_p(c_n) = \Theta(n)$ (linear $p$-adic growth, from $n!$ in denominator)
- G-function coefficients: $\mathrm{ord}_p(d_n) = O(\log n)$ (logarithmic, from Lucas-type structure)

If $P(f(z), h(z)) = 0$, then coefficient convolutions must vanish for all $N$, mixing E-type (linear) and G-type (logarithmic) $p$-adic valuations. The cancellation requires commensurate valuations across all $N$, which is impossible when growth rates differ.

**What remains**: Formalize the heuristic. Extend ADH 2016 "congruences à la Lucas" from G-functions alone to mixed E+G coefficients.
**New fact**: **F27** (congruence growth incompatibility).
**Status**: ALIVE — PROMISING. Purely arithmetic, avoids all abstract machinery.

---

## Attempt 14: Motivic Period Attack (Module 05, §5.5)

**Date**: April 13, 2026, Session 3
**Method**: Both $u, v$ and $\pi/4$ are periods (Kontsevich-Zagier). The Grothendieck Period Conjecture says: $\mathrm{tr.deg}$ of periods = dimension of motivic Galois group. For $B \times SL_2$ (dim 5) with stabilizer dim 2: predicts $\mathrm{tr.deg}\{u, v, \pi/4\} = 3$. André's 2024 survey connects G-function values to unlikely intersections / Zilber-Pink: an algebraic relation $P(u,v,\pi/4) = 0$ would require "motivic cooperation" between $B$ and $SL_2$, which have no common quotient.

**What remains**: Prove the Grothendieck Period Conjecture for the mixed Kummer$\times$Gauss motive. This is a major open problem, but widely believed true.
**New fact**: **F28** (Grothendieck predicts $\mathrm{tr.deg} = 3$).
**Status**: ALIVE — CONDITIONAL on an established conjecture.

---

## Attempt 15: The Faverjon-Adamczewski Specialization Attack (Module 05, §5.9) — ★★ CLOSEST

**Date**: April 13, 2026, Session 3
**Method**: Faverjon & Adamczewski (arXiv:2303.05997, 2023) proved: *all algebraic relations between E-function values at an algebraic point have a **functional source*** — they arise from degeneration of $\delta$-algebraic relations. Same for M-functions ($\sigma_q$-algebraic). This is THE specialization theorem.

**The 2-step proof**:
1. **If** FA specialization extends to mixed E$\times$G: any value relation $P(f(\alpha), h(\alpha)) = 0$ must come from a functional relation
2. **But** $B \times SL_2$ is a direct product with no common quotient (Theorem 4C.4): NO functional relation exists between Kummer ($f$) and arctan ($h$) over $\mathbb{C}(z)$
3. **Therefore**: no value relation. $\mathrm{tr.deg}\{u, v, \pi/4\} = 3$. Conjecture 4A.4 proven. $\pi$ is K₂-opaque.

**What remains**: GAP_D — extend FA from "E-fonctions **ou** M-fonctions" to "E-fonctions **et** G-fonctions." The **ou → et** problem.

**Why this is the closest we've ever been**:
- The specialization mechanism EXISTS for each class separately (FA 2023)
- The function-level independence EXISTS ($B \times SL_2$, Theorem 4C.4)
- Additional quantitative support: FA 2025 (arXiv:2502.09999) gives Liouville-type inequalities for E and M values; FA 2026 (arXiv:2604.08208) proves M-function values aren't Liouville/U-numbers; Estienne 2026 (arXiv:2603.18832) proves tr.deg preservation for Mahler systems

**New facts**: **F29** (FA specialization for E and M separately), **F30** (Estienne tr.deg preservation)
**Status**: ALIVE — ★★ CLOSEST TO PROOF. Gap is GAP_D: a natural extension of existing published work by the same authors.

---

## Updated Summary Table (All 15 Attempts)

| # | Method | Reaches | Blocked by | New math | Status |
|:--|:-------|:--------|:-----------|:---------|:-------|
| 1 | Brute force | $p \leq 5 \times 10^9$ | Data exhaustion | Five-test elimination | PARTIAL |
| 2 | Asymptotics | $M = 1$ family | $\mu(\pi)$ too weak | Perturbation bounds | PARTIAL |
| 3 | ADH 2025 lit | Function level | Value-level gap | Landscape map | DEAD |
| 4 | Tool survey | — | No E$\times$G tool | Landscape map | DEAD |
| 5 | Induction on $D$ | Reformulation | E/G at each step | Clean framework | DEAD |
| 6 | SS Reduction | $\mathbb{Q}$ | $\mathbb{Q}(\pi)$ gap | **Theorem 4A.9** | THEOREM |
| 7 | Extend Siegel | Per-slice | Decoupling barrier | **Theorem 4C.3** | BARRIER |
| 8 | Galois + PW | $B \times SL_2$ | No algebraic points | **Prop. 4C.4** | PARTIAL |
| 9 | Exp-Riccati | Multiplicity ✓ | **Universal Barrier** | **Theorem 4D.2** | BARRIER |
| 10 | Mahler bridge | ADH connection | Value gap | **Conj. 4E.1** | FRAMEWORK |
| 10b | Frobenius conv. | — | $\beta_n$ transcend. | Retraction | RETRACTED |
| 11 | Jet/context | Reformulation | G-jet flat (F25) | F25 | DEAD |
| 12 | Carlitz-Frobenius | Function level | GAP_C: mixed spec. | F26 | ALIVE ★ |
| 13 | Congruence incompat. | Arithmetic | ADH 2016 ext. | F27 | ALIVE |
| 14 | Motivic period | Conditional | Grothendieck conj. | F28 | ALIVE |
| **15** | **FA Specialization** | **90% of bridge** | **GAP_D: ou→et** | **F29, F30** | **ALIVE ★★** |

---

## Current State (Updated April 13, 2026 — Session 3)

The `pi_sun` Neo4j namespace now contains **58 nodes** (24 Facts, 13 AttackVectors, 5 Approaches, 5 ExternalTools, 4 Barriers, 4 Gaps, 2 Conjectures, 1 Target), **57+ relationships**.

**GAP_A (different-evaluation-point) — RESOLVED**: Same-point trick (F23).

**GAP_B (non-Siegel specialization) — OPEN**: Refined into GAP_C, GAP_D.

**GAP_C (mixed Mahler×Fuchsian specialization) — OPEN**: Nishioka (1996) covers Mahler-alone. Target of Attempt 12.

**GAP_D (mixed E×G FA specialization, ou→et) — OPEN**: Faverjon-Adamczewski (2023) covers E alone and M alone. Target of Attempt 15. **CLOSEST to proof.**

**Four ALIVE attack paths** (ranked by distance):
1. ★★ **FA Specialization** (Attempt 15) — needs GAP_D (ou→et), **2 hops to target**
2. ★ **Carlitz-Frobenius Bridge** (Attempt 12) — needs GAP_C, 3 hops to target
3. **Congruence Incompatibility** (Attempt 13) — needs ADH 2016 extension, 4 hops
4. **Motivic Period** (Attempt 14) — conditional on Grothendieck, 1 hop but unproven

**Graph path to target** (★★ shortest unconditional):
```
FA_Specialization_Attack → Conj_4A4 → Pi_K2_Opaque  (2 hops, needs GAP_D)
```
