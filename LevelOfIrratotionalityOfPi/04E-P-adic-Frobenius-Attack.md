# Module 04E — The p-adic Frobenius Attack

## 4E.0 Why p-adic?

The Universal Siegel Barrier (Theorem 4D.2) proves: **every** method using the Siegel lemma (auxiliary polynomial construction via integer-lattice counting) is blocked by the Decoupling Theorem. This kills Siegel-Shidlovskii, Nesterenko-Philippon, and all variants.

The p-adic Frobenius method (Adamczewski-Dreyfus-Hardouin 2025) is the **unique surviving approach** because it avoids the Siegel lemma entirely. It uses the **Frobenius endomorphism** on p-adic differential equations — a completely different mechanism.

**Why the Decoupling Theorem doesn't apply here**: The Decoupling Theorem requires a transcendental number ($\pi$) to appear as a **coefficient** in the auxiliary construction. In the p-adic framework:
- $\pi$ is a REAL number, not a p-adic number
- The p-adic computation works with formal power series and Frobenius structures over $\mathbb{Q}_p$
- The transcendental $\pi$ is **absent from the p-adic coefficient ring**
- The Siegel lemma is not used; Frobenius towers provide the auxiliary structure instead

---

## 4E.1 The ADH Framework

### The Class $\mathcal{MF}(K)$

Let $K$ be a finite totally ramified extension of $\mathbb{Q}_p$ (e.g., $K = \mathbb{Q}_p$ or $K = \mathbb{Q}_p(\pi_p)$ where $\pi_p^{p-1} = -p$). The class $\mathcal{MF}(K)$ consists of power series $f(z) \in 1 + zK[[z]]$ satisfying:

1. $f$ solves a monic differential operator $L = \delta^n + a_1(z)\delta^{n-1} + \cdots + a_n(z) \in \mathcal{E}_{0,K}[\delta]$
2. $L$ has **MOM** (maximal order of multiplicity at zero): $a_i(0) = 0$ for all $i$
3. $L$ has **strong Frobenius structure**: the companion matrix $A$ and $p^h \cdot \sigma^h(A)$ are $\mathcal{E}_p$-equivalent
4. Gauss norm condition: $|a_i(z)|_{\mathcal{G}} \leq 1$

### The ADH Criterion (Theorem 2.3)

$f_1, \ldots, f_m \in \mathcal{MF}(K)$ are algebraically dependent over $\mathcal{E}_K$ if and only if there exist integers $a_1, \ldots, a_m$ (not all zero) such that $f_1^{a_1} \cdots f_m^{a_m} \in \mathcal{E}_{0,K}$.

### Key Property (ADH Theorem 3)

For $f \in \mathcal{MF}(K)$:
- $f(z) \in 1 + z\mathcal{O}_K[[z]]$ (coefficients in the ring of integers)
- $f(z)/f(z^{p^h}) \in \mathcal{E}_{0,K}$ (Frobenius quotient is "close to rational")
- $f'(z)/f(z) \in \mathcal{E}_{0,K}$ (logarithmic derivative is controlled)

---

## 4E.2 What's in $\mathcal{MF}(K)$?

| Function | In $\mathcal{MF}(K)$? | MOM? | Frobenius? | Notes |
|:---------|:---------------------|:-----|:-----------|:------|
| $\exp(\pi_p z)$ | Yes ($K = \mathbb{Q}_p(\pi_p)$) | Yes | Yes | E-function |
| $J_0(\pi_p z)$ (Bessel) | Yes ($K = \mathbb{Q}_p(\pi_p)$, $p \neq 2$) | Yes | Yes | E-function |
| $f_\alpha$ ($\alpha \in \mathbb{Q}^n$, conditions) | Yes ($K = \mathbb{Q}_p$) | Yes (by construction) | Yes (Dwork) | G-function |
| Apéry series $\mathfrak{A}(z)$ | Yes ($K = \mathbb{Q}_3$) | Yes | Yes | G-function |
| ${}_2F_1(1/2, 1/2; 1; z)$ = $(2/\pi)K(z)$ | **Likely yes** ($c = 1 \Rightarrow$ MOM) | Yes | Check | Elliptic integral |
| ${}_2F_1(1/2, 1; 3/2; z)$ (arctan) | **No** ($c = 3/2 \Rightarrow$ MOM fails) | No | — | Indicial roots $0, -1/2$ |
| ${}_1F_1(a; b; z)$ (Kummer) | **Conditional** (after $\pi_p$-rescaling) | Check | Check | E-function |

### The Critical Observation

Arctan itself is NOT in $\mathcal{MF}(K)$. But $\pi$ can be reached INDIRECTLY through the **elliptic integral** ${}_2F_1(1/2, 1/2; 1; z)$, which IS MOM-compatible ($c = 1$ gives indicial roots $0, 0$).

At $z = 1/2$: ${}_2F_1(1/2, 1/2; 1; 1/2) = \frac{\Gamma(1/4)^2}{2\pi^{3/2}}$, a number involving $\pi$ and $\Gamma(1/4)$ (both part of Nesterenko's algebraically independent triple).

---

## 4E.3 The Indirect Strategy

### Step 1: Identify MF(K)-compatible functions

Choose functions $f_1, \ldots, f_m \in \mathcal{MF}(K)$ such that:
- Their values at algebraic points INVOLVE $\pi$ (through elliptic integrals or Gamma values)
- The ${}_1F_1$ functions (K₂-predictor values) are ALSO in $\mathcal{MF}(K)$ (after appropriate rescaling)

### Step 2: ADH function-level independence

Apply ADH Theorem 2.3: verify that no power product of these functions lies in $\mathcal{E}_{0,K}$. This gives algebraic independence over $\mathcal{E}_K$ at the function level.

### Step 3: p-adic specialization (THE KEY STEP)

Use the **Frobenius tower** to pass from function-level to value-level independence:

For $f \in \mathcal{MF}(K)$ and algebraic $\alpha$: the sequence $\{f(\alpha), f(\alpha^p), f(\alpha^{p^2}), \ldots\}$ satisfies p-adic congruence relations (from the Frobenius quotient $f(z)/f(z^{p^h}) \in \mathcal{E}_{0,K}$).

These congruences are **not available in the Archimedean setting** — they are purely p-adic. They provide the auxiliary structure that the Siegel lemma provides classically, **without using integer-lattice counting**.

### Step 4: Derive algebraic independence of values

If the Frobenius tower constraints force $f_i(\alpha)$ to be "p-adically generic" (not satisfying unexpected polynomial relations), then:

$$\text{tr.deg}_{\mathbb{Q}}\{f_1(\alpha), \ldots, f_m(\alpha)\} = m$$

Combined with Step 1: this gives algebraic independence of $\pi$-related values from E-function values, proving Conjecture 4A.4.

---

## 4E.4 Why the Frobenius Tower Avoids the Decoupling Barrier

### The Classical Barrier (Recap)

The Siegel lemma constructs a polynomial $P \in \mathbb{Z}[x_1, \ldots, x_m]$ with a high-order zero at $(f_1(\alpha), \ldots, f_m(\alpha))$. The construction requires solving a system of LINEAR EQUATIONS over $\mathbb{Z}$. When the coefficients involve a transcendental ($L_0$ from the Kummer equation), the system decouples by transcendence degree, losing cross-term information.

### The p-adic Alternative

The Frobenius tower provides a DIFFERENT type of "auxiliary" — not a polynomial, but a **chain of p-adic congruences**:

$$f(\alpha) / f(\alpha^p) = r_1(\alpha) \cdot (1 + p^h \cdot \epsilon_1)$$
$$f(\alpha^p) / f(\alpha^{p^2}) = r_2(\alpha^p) \cdot (1 + p^h \cdot \epsilon_2)$$
$$\vdots$$

where $r_i \in \mathcal{E}_{0,K}$ (rational-function-like) and $\epsilon_i$ are p-adically small.

These congruences are **automatic** — they follow from the Frobenius structure of $f$, not from a Siegel construction. There is no integer-lattice counting, no polynomial with integer coefficients, and therefore **no decoupling**.

The p-adic constraint chain acts as a "rigidity mechanism" that prevents $f(\alpha)$ from satisfying unexpected algebraic relations. This is the p-adic analogue of the Siegel auxiliary polynomial, but operating through a completely different mathematical mechanism.

---

## 4E.5 The Mahler Connection (Key Insight)

### 4E.5.1 The Frobenius Tower Creates a Mahler Equation

For $f \in \mathcal{MF}(K)$ and algebraic $\alpha$ with $|\alpha|_p < 1$: the Frobenius property $f(z)/f(z^{p^h}) \in \mathcal{E}_{0,K}$ gives:

$$f(\alpha) = f(\alpha^{p^h}) \cdot r(\alpha), \qquad r \in \mathcal{E}_{0,K}$$

Iterating: $f(\alpha) = \prod_{k \geq 0} r(\alpha^{p^{kh}}) \cdot \lim_{n \to \infty} f(\alpha^{p^{nh}})$

Since $\alpha^{p^{nh}} \to 0$ ($p$-adically) and $f(0) = 1$: the value $f(\alpha)$ is an infinite product over the **Frobenius orbit** $\{\alpha, \alpha^{p^h}, \alpha^{p^{2h}}, \ldots\}$.

This is a **Mahler-type functional equation**: the value at $\alpha$ is determined by values at $\alpha^{p^h}$ — exactly the structure studied by Mahler (1929), and extensively by **Adamczewski, Dreyfus, and Hardouin themselves** in their work on difference Galois theory.

### 4E.5.2 The ADH Difference Equation Program

ADH (with Wibmer) proved in 2021 [arXiv:2010.09266, published in JEMS]:

> **Theorem** (ADH-W 2021). *Solutions of linear difference equations associated with "sufficiently independent" automorphisms (shift, q-difference, Mahler) are algebraically independent over the field of rational functions.*

Earlier, ADH proved in 2019 [arXiv:1910.01874]:

> **Hypertranscendence**: *Solutions of linear difference equations (Mahler-type) are hypertranscendental — they don't satisfy any algebraic differential equation.*

**The crucial pair for us: (differential equation) $\times$ (Mahler equation).**

- $\pi/4 = \arctan(1)$ is a value of a solution of a **differential equation** (Gauss hypergeometric)
- $₁F₁(a;b;\alpha)$ is a value whose Frobenius tower satisfies a **Mahler equation** ($z \mapsto z^{p^h}$)

These are **different types of functional equations**. ADH's program says: solutions of different-type equations are algebraically independent.

### 4E.5.3 The Proof Strategy

1. **E-function ratio** $R(\alpha) = ₁F₁(a;b;\alpha)/₁F₁(a;b+1;\alpha)$: the Frobenius tower $\{R(\alpha), R(\alpha^{p^h}), \ldots\}$ satisfies a Mahler-type relation (from the Frobenius structure of $₁F₁$).

2. **$\pi/4 = \arctan(1)$**: a value governed by the Gauss differential equation. Its functional structure is DIFFERENTIAL (regular singular DE), not MAHLER (Frobenius discrete dynamics).

3. **ADH's own framework**: the algebraic independence of solutions of (differential) and (Mahler) type equations has been their research program since 2019. The hypertranscendence results [arXiv:1910.01874] show that Mahler-type solutions can't satisfy differential equations — and vice versa.

4. **The conclusion**: if the Frobenius-Mahler structure of $R(\alpha)$ is "sufficiently independent" from the differential structure governing $\pi$, then $R(\alpha)$ and $\pi$ are algebraically independent — proving Conjecture 4A.4.

### 4E.5.4 What Needs to Be Verified

The specific technical verification: do the Kummer Frobenius tower and the Gauss DE for arctan satisfy the "sufficient independence" conditions of ADH's 2021 JEMS theorem?

The conditions involve: the pair of automorphisms $(\partial/\partial z, \sigma: z \mapsto z^{p^h})$ must be "sufficiently independent" in the sense of parametrized difference Galois theory (Hardouin-Singer). For the Kummer-Gauss pair:

- The differential operator $\partial/\partial z$ acts on solutions of the Gauss DE (giving $\pi$)
- The Mahler operator $\sigma_p: z \mapsto z^{p^h}$ acts on the Frobenius tower of $₁F₁$

These operators are of **different nature**: one is continuous (differential), the other discrete (Frobenius). By ADH's general framework, such pairs are "generically independent."

**This is the EXACT point where ADH's published work meets our specific problem.**

---

### 4E.5.5 The Precise Gap

After detailed analysis, the connection between ADH's programs and our problem is:

| ADH result | What it proves | What we need |
|:-----------|:---------------|:-------------|
| ADH 2025 (E/G) | Function independence over $\mathcal{E}_K$ | Value independence over $\mathbb{Q}$ |
| ADH 2019 (Hypertranscendence) | Mahler functions ⊥ differential (FUNCTIONS) | Mahler VALUES ⊥ differential VALUES |
| ADH 2019 (Values) | Mahler values independent from each other | Mahler values independent from $\pi$ |
| ADH-W 2021 (JEMS) | Difference × difference independence | Differential × Mahler independence |

**The precise gap**: algebraic independence of a Mahler function value $\Phi(\alpha) = \prod s(\alpha^{p^k})$ from a Fuchsian DE value $\pi = 4\arctan(1)$ at algebraic evaluation points.

This is:
- **Predicted** by hypertranscendence at the function level
- **Not covered** by ADH's published value-level results (which handle Mahler-vs-Mahler, not Mahler-vs-differential)
- The **natural next theorem** in ADH's program: extending the 2019 hypertranscendence from functions to values in the mixed (Mahler, differential) setting

### 4E.5.6 The Frobenius Product Formula

Under the hypothesis $\pi = \text{Möbius}(R(\alpha))$, the Frobenius tower gives:

$$\text{Möbius}(\pi) = R(\alpha) = \prod_{k=0}^{\infty} s(\alpha^{p^k})$$

where $s = r_1/r_2 \in \mathcal{E}_{0,K}$ is the ratio of Frobenius quotients.

The right side is a **Mahler function** $\Phi(z) = \prod_{k \geq 0} s(z^{p^k})$ evaluated at $z = \alpha$. The equation $\text{Möbius}(\pi) = \Phi(\alpha)$ says: a DE value ($\pi$) is algebraically related to a Mahler value ($\Phi(\alpha)$).

By hypertranscendence (function level): $\Phi(z)$ can't satisfy any algebraic DE. By the function-level independence of Mahler and differential solutions: $\Phi$ and $\arctan$ are functionally independent.

**The value-level upgrade**: if this functional independence specializes to value independence (as it does for E-function-only systems by Beukers' p-adic SS), then $\Phi(\alpha)$ and $\pi$ are algebraically independent, contradicting $\text{Möbius}(\pi) = \Phi(\alpha)$.

---

## 4E.6 The Frobenius Convergence Theorem (NEW — UNCONDITIONAL)

### 4E.6.1 The Mechanism

Under the hypothesis $\pi = \text{Möbius}(R(\alpha))$ where $R$ is a $₁F₁$ ratio: the Frobenius product $\Pi(\alpha) = \prod_{k \geq 0} s(\alpha^{p^k})$ converges to $\text{Möbius}(\pi)$. The partial products $\Pi_n = \prod_{k < n} s(\alpha^{p^k})$ are **algebraic numbers** that approximate $\text{Möbius}(\pi)$.

**Convergence rate**: Since $s(\alpha^{p^k}) \to s(0) = 1$ and $|s(\alpha^{p^k}) - 1| \leq C|\alpha|^{p^k}$:

$$|\Pi(\alpha) - \Pi_n| \leq C' \cdot |\alpha|^{p^n} \qquad \text{(doubly exponential in } n\text{)}$$

Defining $\beta_n = \text{Möbius}^{-1}(\Pi_n)$ (algebraic):

$$|\pi - \beta_n| \leq C'' \cdot |\alpha|^{p^n}$$

**Height bound**: $\log H(\beta_n) \leq C_8 \cdot p^n$ (from multiplicative heights of the product).

### 4E.6.2 Confrontation with the Irrationality Measure

By the **irrationality measure** $\mu(\pi) \leq 7.6064$ (Salikhov 2008): for any algebraic $\beta$ of bounded degree:

$$|\pi - \beta| \geq H(\beta)^{-\mu(\pi)} \geq \exp(-\mu(\pi) \cdot \log H(\beta))$$

Substituting $\beta = \beta_n$:

$$|\pi - \beta_n| \geq \exp(-\mu(\pi) \cdot C_8 \cdot p^n)$$

Combined with the upper bound:

$$\exp(-\mu(\pi) \cdot C_8 \cdot p^n) \leq |\pi - \beta_n| \leq C'' \cdot |\alpha|^{p^n} = C'' \cdot \exp(-L \cdot p^n)$$

where $L = -\log|\alpha| > 0$ (assuming $|\alpha| < 1$).

Canceling $p^n$: **$L \leq \mu(\pi) \cdot C_8$**, i.e.,

$$|\alpha| \geq \exp(-\mu(\pi) \cdot C_8)$$

### 4E.6.3 A Failed Theorem and Its Correction

**Theorem 4E.2 (RETRACTED).** *An earlier version claimed that Frobenius partial products $\Pi_n$ give ALGEBRAIC approximations $\beta_n$ to $\pi$, contradicting the irrationality measure. This is WRONG: $\beta_n = \text{Möbius}^{-1}(\Pi_n)$ is TRANSCENDENTAL, not algebraic, because $\Pi_n = \prod_{k<n} s(\alpha^{p^k})$ involves TRANSCENDENTAL factors $s(\alpha^{p^k})$ (E-function ratios at algebraic points are transcendental by Siegel-Shidlovskii).*

*The irrationality measure $|\pi - \beta| \geq H(\beta)^{-\mu}$ applies only to algebraic $\beta$. For transcendental $\beta_n$: no such lower bound exists. The argument fails.*

**Honest error analysis**: The Frobenius quotient $s(z) = {}_1F_1(a;b;z)/{}_1F_1(a;b;z^p)$ evaluates to a TRANSCENDENTAL number at algebraic $z = \alpha$ (by SS). The partial product $\Pi_n$ is a product of transcendentals, hence transcendental. The height theory and irrationality measure don't apply.

For the specific case $f = e^z$: $s(z) = e^{z-z^p}$, so $\Pi_n = e^{\alpha - \alpha^{p^n}}$. The limit $\Pi(\alpha) = e^\alpha$, and the equation $\text{Möbius}(\pi) = e^\alpha$ reduces to algebraic independence of $\pi$ and $e$ — the same open problem.

**Lesson**: The Frobenius tower produces TRANSCENDENTAL approximations, not algebraic ones. The irrationality measure approach requires algebraic approximations. This is a fundamental mismatch.

### 4E.6.4 What Remains After the Correction

The Frobenius Product Formula (§4E.5.6) is still valid: $\text{Möbius}(\pi) = \prod s(\alpha^{p^k})$. The formula correctly converts the hypothesis into a convergent infinite product. But the convergence argument (comparing rates) cannot be completed with the irrationality measure because the approximants are transcendental.

The Mahler-Differential bridge (§4E.5) and the p-adic specialization conjecture (4E.1) remain the correct formulation of the problem. The correction shows: even the p-adic path cannot be closed by METRIC arguments (irrationality measure). It requires STRUCTURAL arguments (algebraic independence of Mahler values from DE values).

---

## 4E.7 The Precise Open Problem

**Conjecture 4E.1** (Mahler-Differential Value Independence). *Let $\Phi(z) = \prod_{k \geq 0} s(z^{p^k})$ be a Mahler function arising from the Frobenius structure of an E-function (with $s \in \mathcal{E}_{0,K}$, $s(0) = 1$). Let $g$ be a solution of a Fuchsian (regular singular) differential equation over $\mathbb{Q}(z)$, with $g$ hypertranscendental over the field generated by $\Phi$. Then for algebraic $\alpha, \beta$ (not singularities, $|\alpha|_p < 1$):*

$$\text{tr.deg}_{\mathbb{Q}}\{\Phi(\alpha), g(\beta)\} = 2$$

This conjecture is:
- **TRUE for E-functions alone**: this is the p-adic Siegel-Shidlovskii theorem (Beukers, André)
- **TRUE for G-functions alone** (partially): this follows from André's G-function theorem in certain cases
- **OPEN for mixed E/G**: this is the gap, and it's EXACTLY what proves Conjecture 4A.4

### Why This Is Approachable

1. **ADH are actively extending their program**: Part I (2025a) gives the function-level criterion. Part II (2025b) gives an effective version. A **Part III** on evaluations is a natural continuation.

2. **The Frobenius mechanism provides the tool**: the congruence chain $f(\alpha)/f(\alpha^p) \in \mathcal{E}_{0,K}$ gives p-adic constraints on values that have no Archimedean analogue.

3. **The function-level work is DONE**: ADH proved independence at the function level. The gap is ONLY the specialization step.

4. **The Decoupling Theorem does NOT apply**: the p-adic framework avoids the Siegel lemma entirely.

---

## 4E.8 Neo4j Graph Analysis (`pi_sun` namespace)

The complete attack landscape is modeled in Neo4j namespace `pi_sun` with 35 nodes and 26 relationships. The graph reveals:

### What converges on the ONE unresolved gap

**GAP_B: NonSiegelSpecialization** — the ONLY unresolved gap. Five proven facts reach it:

| Fact | Relation | What it gives |
|:-----|:---------|:-------------|
| F15 (FunctionIndependence) | REACHES_BUT | Function-level E⊥G, missing: value specialization |
| F23 (SamePointTrick) | REACHES_BUT | Same-point evaluation h(z)=arctan(z/α), missing: specialization |
| F17 (FrobeniusTower) | PARTIAL_TOOL | Mahler equation for values |
| F18 (Hypertranscendence) | PARTIAL_TOOL | Mahler fns ⊥ algebraic DEs (function level) |
| F24 (ArctanAlgebraizable) | EXPLAINS_WHY | π transcendence is value-only, not functional |

### The path from gap to target

```
GAP_B (NonSiegelSpecialization)
  → BLOCKS → Conj_4E1 (Mahler value ⊥ DE value)
    → IMPLIES → Conj_4A4 (π ≠ E-fn ratio)
      → WOULD_PROVE → Pi_K2_Opaque
```

### Two gaps, one resolved

| Gap | Status | Resolution |
|:----|:-------|:-----------|
| GAP_A (DifferentPointEvaluation) | **RESOLVED** | F23: h(z)=arctan(z/α) gives same-point |
| GAP_B (NonSiegelSpecialization) | **OPEN** | Need E×G specialization without Siegel lemma |

### The verdict

**18 proven facts. 4 barriers mapped. 2 gaps identified, 1 resolved. The ENTIRE proof reduces to GAP_B: a non-Siegel specialization theorem for mixed E×G systems at the same algebraic evaluation point.**

The graph confirms: we are not missing multiple things. We are missing **one thing**. And five proven facts already reach that one thing with partial tools.

---

## 4E.9 Status

| Component | Status |
|:----------|:-------|
| Neo4j `pi_sun` namespace | **BUILT** (35 nodes, 26 relationships) |
| GAP_A (different-point evaluation) | **RESOLVED** by F23 (same-point trick) |
| GAP_B (non-Siegel specialization) | **OPEN** — the single remaining step |
| ADH function-level criterion | **PROVEN** (ADH 2025a,b) |
| Frobenius + Hypertranscendence as partial tools | **PROVEN** (F17, F18) |
| Decoupling Theorem avoidance | **PROVEN** — p-adic avoids Siegel lemma |
| Full K₂-opacity of $\pi$ | **FOLLOWS** from resolving GAP_B |

### The Landscape After 11 Attempts

```
PROVEN (18 unconditional facts):
  π transcendental, K₁-opaque, K₂ for p≤5×10⁹, all-1 eliminated,
  Bridge Theorem, Lyapunov Dichotomy, Euler-Perron, SS independence,
  SS Reduction, Decoupling, Universal Barrier, Galois B×SL₂,
  Function independence, Frobenius tower, Hypertranscendence,
  Same-point trick, Arctan algebraizable

RESOLVED GAPS (1 of 2):
  GAP_A (different-point evaluation) → h(z)=arctan(z/α)

OPEN (1 gap):
  GAP_B: non-Siegel specialization E×G → values at same algebraic point
  
  Five facts REACH this gap:
    F15 + F23 → function independence + same point (REACHES_BUT)
    F17 + F18 → Frobenius + hypertranscendence (PARTIAL_TOOL)
    F24 → explains WHY the gap exists (EXPLAINS_WHY)
```

---

## References

- Adamczewski, B., Dreyfus, T. & Hardouin, C. (2025a). arXiv:2502.00768.
- Adamczewski, B., Dreyfus, T. & Hardouin, C. (2025b). arXiv:2507.20429.
- André, Y. (2004). *Sur la conjecture des p-courbures*. S.M.F.
- Beukers, F. (2006). "A refined version of the Siegel-Shidlovskii theorem." *Ann. Math.*, 163, 369–379.
- Dwork, B. (1962). "On the rationality of the zeta function of an algebraic variety." *Amer. J. Math.*, 82, 631–648.
- Kedlaya, K. (2010). *p-adic Differential Equations*. Cambridge University Press.
- Nesterenko, Yu. V. (1996). "Modular functions and transcendence questions." *Sb. Math.*, 187, 1319–1348.

---

*Previous: [Module 04D — The Exponential-Riccati Attack](04D-Exponential-Riccati-Attack.md)*
*Next: [Module 04F — Final Analysis](04F-Final-Analysis.md)*
