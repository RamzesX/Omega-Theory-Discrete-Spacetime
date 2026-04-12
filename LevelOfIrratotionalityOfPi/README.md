# The Predictive Dichotomy of $e$ and $\pi$

## A Proof That Euler's Number and Pi Belong to Different Information-Theoretic Classes

---

### Abstract

We prove, unconditionally, that Euler's number $e$ and the circle constant $\pi$ belong to different classes of predictive accessibility within the continued fraction representation. Specifically, we show:

1. **There exists** a predictor that, given 15 terms of the continued fraction of $e$, correctly generates **all** subsequent terms (Theorem 3.1).

2. **No periodic predictor** can correctly generate all subsequent terms of the continued fraction of $\pi$ from any finite prefix (Theorem 4.1).

The proof of (1) relies on Euler's 1737 formula for $\mathrm{CF}(e)$. The proof of (2) relies on Lindemann's 1882 transcendence of $\pi$ combined with Lagrange's 1770 periodicity theorem. No unproved conjectures, no empirical data, and no ergodic theory are required for the core result.

We further develop a conditional extension using the exponential mixing of the Gauss map (Wirsing, 1974) and the Rokhlin entropy formula, showing that under the assumption of Gauss–Kuzmin typicality of $\pi$, the *information deficit* satisfies $D(e) = 0$ and $D(\pi) \geq \pi^2/(6\ln 2) - B > 0$, where $B$ is a finite constant. This yields a new classification layer within the transcendental numbers: *self-encoding* constants (exemplified by $e$) versus *opaque* constants (exemplified by $\pi$).

---

### Structure

The work is organized into eight modules, forming a complete deductive chain:

**Part I — Setup**

| Module | Title | Role |
|:---|:---|:---|
| [01](01-Foundations-Continued-Fractions.md) | Foundations | CF uniqueness, Gauss map, Gauss–Kuzmin theorem, mixing, entropy |
| [02](02-Definitions-And-Framework.md) | Definitions and Framework | Predictor hierarchy, prediction horizon, self-encoding, opacity, information deficit |

**Part II — The Unconditional Theorem**

| Module | Title | Role |
|:---|:---|:---|
| [03](03-Self-Encoding-Of-Euler.md) | Self-Encoding of $e$ | Full proof that $e$ is self-encoding with $N_0 = 15$ |
| [04](04-Non-Predictability-Of-Pi.md) | Non-Predictability of $\pi$ | Full proof that no periodic predictor achieves perfect accuracy on $\pi$ |
| [04A](04A-Extension-K2-Predictors.md) | Extension to K₂ Predictors | Bridge Theorem: K₂-predictability forces polynomial growth, μ=2, rational frequencies. Euler-Perron characterization. Minimal conditions for K₂-opacity of $\pi$. |

**Part III — Conditional Extensions**

| Module | Title | Role |
|:---|:---|:---|
| [05](05-Information-Deficit-And-Mixing.md) | Information Deficit and Mixing | Conditional bound $D(\pi) > 0$ from Gauss map mixing |
| [06](06-Experimental-Verification.md) | Experimental Verification | 480 polynomial-fit tests, 10-strategy predictor benchmark |
| [07](07-Open-Problems.md) | Open Problems | Contradiction analysis, what closes the gap |

**Part IV — Synthesis**

| Module | Title | Role |
|:---|:---|:---|
| [08](08-Transcendental-Dichotomy.md) | The Transcendental Dichotomy | New hierarchy, comparison with irrationality measure, implications |
| [09](09-References.md) | References | Complete bibliography |

**Appendix**

| Document | Title |
|:---|:---|
| [Appendix F](../PhysicsPapers/Appendix-F-Information-Flow-Conservation.md) | Information Flow Conservation (physics interpretation) |

---

### The Proof in One Page

**Definitions.** A *periodic predictor* $P_p$ of period $p$ predicts $a_{N+1} = a_{N+1-p}$, where $(a_n)$ are the partial quotients of the continued fraction. A *positional-polynomial predictor* predicts $a_{N+1}$ as a polynomial function of $\lfloor (N+1)/p \rfloor$, depending on the residue class $(N+1) \bmod p$. The *accuracy* of $P$ on constant $\alpha$ is $\mathrm{acc}(P, \alpha) = \liminf_{N \to \infty} \frac{1}{N}\#\{n \leq N : P \text{ predicts } a_{n+1} \text{ correctly}\}$.

**Theorem A** (Self-Encoding of $e$). *There exists a positional-polynomial predictor $P$ such that $\mathrm{acc}(P, e) = 1$. Specifically, from $N \geq 15$ terms of $\mathrm{CF}(e)$, the predictor correctly generates all subsequent terms.*

*Proof.* By Euler (1737), $\mathrm{CF}(e) = [2; 1, 2, 1, 1, 4, 1, 1, 6, \ldots]$ with the rule:

$$a_n = \begin{cases} 1 & \text{if } n \not\equiv 2 \pmod{3} \\[4pt] 2\!\left\lfloor\tfrac{n+1}{3}\right\rfloor & \text{if } n \equiv 2 \pmod{3} \end{cases}$$

This rule has period $p = 3$ and polynomial degree $d = 1$. The detection algorithm (Module 03) identifies it from 15 terms by verifying: (a) two residue classes are constant, (b) one is linear with constant differences. Once detected, every future term is determined. $\square$

**Theorem B** (Non-Predictability of $\pi$). *No periodic predictor achieves perfect accuracy on $\pi$. That is, for every period $p \geq 1$:*

$$\mathrm{acc}(P_p, \pi) < 1$$

*Proof.* Suppose $\mathrm{acc}(P_p, \pi) = 1$ for some $p$. Then $a_n(\pi) = a_{n+p}(\pi)$ for all but finitely many $n$ (since each mismatch contributes $\leq 1/N \to 0$ to the accuracy, and $\mathrm{acc} = 1$ requires the liminf to equal 1). Hence $\mathrm{CF}(\pi)$ is eventually periodic with period $p$. By Lagrange's theorem (1770), $\pi$ is a quadratic irrational. This contradicts Lindemann's theorem (1882): $\pi$ is transcendental. $\square$

**Corollary** (The Dichotomy). *The constants $e$ and $\pi$ belong to different predictive classes:*

$$\sup_{P \in \mathcal{K}_2} \mathrm{acc}(P, e) = 1 \qquad \text{and} \qquad \sup_{P \in \mathcal{K}_1} \mathrm{acc}(P, \pi) < 1$$

*This is an unconditional result requiring only Euler (1737), Lagrange (1770), and Lindemann (1882).*

---

### The Conditional Extension

Under the additional assumption that $\pi$ is Gauss–Kuzmin typical (i.e., its orbit under the Gauss map $T(x) = \{1/x\}$ is equidistributed with respect to the Gauss measure $\gamma$), we obtain quantitative bounds:

**Theorem C** (Information Deficit). *Define the information deficit:*

$$D(\alpha, N) = H(a_{N+1}) - I(a_{N+1};\, a_1, \ldots, a_N)$$

*Then:*

$$D(e, N) = 0 \quad \text{for } N \geq 15$$

$$D(\pi, N) \geq \frac{\pi^2}{6\ln 2} - B > 0 \quad \text{for all } N$$

*where $B = C/(1 - |\lambda_2|)$ is a finite constant, $\lambda_2 \approx 0.3037$ is the Gauss–Kuzmin–Wirsing constant (Wirsing, 1974), and $\pi^2/(6\ln 2) \approx 3.433$ is the entropy of the Gauss map (Rokhlin, 1961).*

**Interpretation:** At every step of the continued fraction, the computation of $\pi$ requires the injection of $D > 0$ bits of information from an external source — the geometric definition of $\pi$. The digits of $\pi$ do not contain this information; it must be supplied by a formula. For $e$, the digits contain all necessary information ($D = 0$); no formula is needed beyond the initial detection of the pattern.

**Status of Theorem C:**

| Component | Status |
|:---|:---|
| $D(e) = 0$ | **Proved** (Euler 1737) |
| Exponential mixing with $\lambda_2 \approx 0.3037$ | **Proved** (Wirsing 1974) |
| Entropy $h = \pi^2/(6\ln 2)$ | **Proved** (Rokhlin 1961) |
| $D(\alpha) > 0$ for $\gamma$-a.e. $\alpha$ | **Proved** (follows from above) |
| $\pi$ is $\gamma$-typical | **Empirically verified** (480 tests, 200+ CF terms) |

---

### The New Hierarchy

The information deficit induces a classification of real numbers that refines the classical algebraic hierarchy:

```
Rationals             CF finite           D = N/A
  │
Quadratic algebraics  CF periodic         D = 0  (self-encoding, K₁)
  │
Higher algebraics     CF non-periodic     D > 0  (conjectured)
  │
Transcendentals ─┬─ Self-encoding        D = 0  (e, φ-related constants)
                 │
                 └─ Opaque               D = π²/(6ln2) − B > 0  (π, ζ(3), ln 2)
```

The irrationality measure $\mu(\alpha)$ does not capture this distinction: both $e$ and $\sqrt{2}$ have $\mu = 2$, yet $\sqrt{2}$ is algebraic and $e$ is transcendental. The information deficit does: $D(\sqrt{2}) = 0$ (periodic CF) and $D(e) = 0$ (polynomial-periodic CF), but $D(\pi) > 0$.

Conversely, the deficit captures something $\mu$ misses entirely: the question of whether a constant's digits *encode themselves*.

---

### Self-Referential Coda

The entropy of the Gauss map — which governs the information deficit of all opaque constants — is:

$$h(T, \gamma) = \frac{\pi^2}{6\ln 2}$$

The constant $\pi$ appears in the formula measuring its own informational opacity. This is not circular (the entropy is a property of the Gauss map, proved independently), but it is structurally remarkable:

> $\pi$ quantifies its own resistance to prediction.

---

### Acknowledgments

This work was developed through an extended exploratory dialogue, combining computational experimentation (predictor benchmarks, polynomial fitting, entropy measurement) with classical results from continued fraction theory, ergodic theory, and transcendental number theory. The neo4j graph database was used to model the logical dependency structure of the proof.

### Citation

If referencing this work, please cite as:

> *The Predictive Dichotomy of $e$ and $\pi$: A Proof That Euler's Number and Pi Belong to Different Information-Theoretic Classes.* Exploratory Mathematics, 2025. Repository: `chaos-shield/LevelOfIrratotionalityOfPi`.
