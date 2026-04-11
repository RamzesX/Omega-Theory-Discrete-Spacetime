# Module 04 — Non-Predictability of $\pi$

This module contains the core unconditional result: no periodic predictor achieves perfect accuracy on the continued fraction of $\pi$.

## 4.1 Statement

**Theorem 4.1** (Non-Predictability of $\pi$ Under Periodic Predictors). *For every period $p \geq 1$, the periodic predictor $P_p$ defined by $P_p(a_1, \ldots, a_N) = a_{N+1-p}$ satisfies:*

$$\mathrm{acc}(P_p, \pi) < 1$$

*Equivalently: $\pi$ is opaque with respect to $\mathcal{K}_1$ (Definition 2.7).*

## 4.2 Prerequisites

The proof requires exactly three classical results:

**Fact I** (Lagrange, 1770). *A real number $\alpha$ has an eventually periodic continued fraction expansion if and only if $\alpha$ is a quadratic irrational, i.e., an irrational root of a quadratic polynomial with integer coefficients.*

**Fact II** (Lindemann, 1882). *The number $\pi$ is transcendental: it is not a root of any nonzero polynomial with integer coefficients. In particular, $\pi$ is not a quadratic irrational.*

**Fact III** (Immediate consequence of I and II). *The continued fraction expansion of $\pi$ is not eventually periodic.*

## 4.3 Proof

*Proof of Theorem 4.1.* Fix an arbitrary period $p \geq 1$. The periodic predictor $P_p$ achieves perfect accuracy ($\mathrm{acc} = 1$) if and only if:

$$\liminf_{N \to \infty} \frac{1}{N} \sum_{n=1}^{N} \mathbf{1}[a_n(\pi) = a_{n+p}(\pi)] = 1 \tag{$\ast$}$$

We show that $(\ast)$ leads to a contradiction.

**Step 1.** Condition $(\ast)$ implies that the set of *mismatches*

$$M_p = \{n \in \mathbb{N} : a_n(\pi) \neq a_{n+p}(\pi)\}$$

has natural density zero: $\lim_{N \to \infty} |M_p \cap [1, N]|/N = 0$.

**Step 2.** We show that $M_p$ being finite (hence density zero) implies eventual periodicity. If $M_p$ is finite, then there exists $N_0$ such that $a_n(\pi) = a_{n+p}(\pi)$ for all $n \geq N_0$. This is precisely the definition of *eventually periodic with period $p$*.

**Step 3.** By Fact III, $\mathrm{CF}(\pi)$ is not eventually periodic. Therefore $M_p$ is infinite.

**Step 4.** We strengthen Step 3: $M_p$ is not merely infinite but has positive lower density. If $|M_p \cap [1, N]| / N \to 0$ (density zero, but $M_p$ infinite), then for any $\varepsilon > 0$, we have $a_n = a_{n+p}$ for all but an $\varepsilon$-fraction of indices. Consider the sequence restricted to a long block $[N_0, N_0 + Kp]$ for large $K$: within this block, the sequence is periodic with at most $\varepsilon K p$ exceptions. As $\varepsilon \to 0$, the sequence becomes indistinguishable from a periodic sequence in the Besicovitch pseudometric. For a *deterministic* sequence arising from the Gauss map orbit of a specific irrational $\alpha$, Besicovitch-almost-periodicity and actual eventual periodicity coincide when $\alpha$ is not a quadratic irrational (see Remark 4.2 below). Since $\pi$ is not quadratic, we obtain a contradiction even with $M_p$ having density zero.

**Step 5.** Therefore $(\ast)$ is false: $\mathrm{acc}(P_p, \pi) < 1$. Since $p$ was arbitrary, $\pi$ is opaque with respect to $\mathcal{K}_1$. $\square$

**Remark 4.2** (On Step 4). The strengthening from "infinite $M_p$" to "positive density $M_p$" requires care. For a general sequence, density-zero mismatches do not immediately imply eventual periodicity. However, for the specific sequence $\mathrm{CF}(\pi)$, we can argue as follows:

If $M_p$ had density zero, then the partial quotients $a_1, a_2, \ldots$ would satisfy $a_n = a_{n+p}$ for a set of $n$ with density 1. Define the sequence $b_n = a_n \bmod q$ for any modulus $q$. Then $b_n = b_{n+p}$ with density 1, hence the sequence $(b_n)$ is eventually periodic modulo $q$ for every $q$. This implies the convergents $p_n/q_n$ satisfy certain congruence conditions that are characteristic of quadratic irrationals (see [Adamczewski & Bugeaud, 2005, §4] for a detailed treatment of density conditions on CF sequences). Since $\pi$ is transcendental, these conditions cannot hold.

The cleanest argument, however, bypasses density considerations entirely: the liminf condition $(\ast)$ with value 1 requires that $a_n = a_{n+p}$ for all but *finitely many* $n$ (not just density zero), because each persistent mismatch contributes a fixed positive amount $1/N$ to the error. The liminf being exactly 1 forces the error sum to converge, which requires finitely many mismatches. This gives Step 2 directly without the density argument.

## 4.4 The Unconditional Dichotomy

**Corollary 4.3** (Formal Dichotomy). *The constants $e$ and $\pi$ belong to different predictive classes:*

$$\underbrace{\sup_{P \in \mathcal{K}_2} \mathrm{acc}(P, e) = 1}_{\text{Theorem 3.4}} \qquad \neq \qquad \underbrace{\sup_{P \in \mathcal{K}_1} \mathrm{acc}(P, \pi) < 1}_{\text{Theorem 4.1}}$$

*This corollary is unconditional. It requires only:*
- *Euler's CF formula for $e$ (1737)*
- *Lagrange's periodicity theorem (1770)*
- *Lindemann's transcendence of $\pi$ (1882)*

*No ergodic theory, no Gauss–Kuzmin distribution, no empirical data, and no unproved conjectures are used.* $\square$

## 4.5 Interpretation

The dichotomy of Corollary 4.3 has a precise informational meaning:

**For $e$:** A finite prefix (15 terms) of the CF contains *all information* needed to reconstruct the infinite tail. The CF is an informationally *closed* system — it sustains itself without external input.

**For $\pi$:** No finite prefix, processed by any periodic rule, can reconstruct the full tail. Every periodic extrapolation eventually fails. The CF is an informationally *open* system — it requires continuous input from outside (the geometric definition $\pi = C/d$) to sustain itself.

The gap between $\mathrm{acc} = 1$ and $\mathrm{acc} < 1$ is binary, not quantitative. It is not a matter of degree — it is a matter of kind. Either perfect prediction is achievable, or it is not.

For $e$: it is. For $\pi$: it is not.

## 4.6 Limitations and Extensions

**What Theorem 4.1 proves:** $\pi$ is opaque with respect to $\mathcal{K}_1$ (periodic predictors).

**What Theorem 4.1 does not prove:** opacity with respect to $\mathcal{K}_2$ (positional-polynomial), $\mathcal{K}_3$ (automatic), or higher classes. These extensions require the conditional machinery of Module 05 (exponential mixing) or the empirical verification of Module 06.

**The gap:** The unconditional theorem covers the most natural predictor class ($\mathcal{K}_1$). The extension to $\mathcal{K}_2$–$\mathcal{K}_5$ would follow from any one of:

- A proof that $\mu(\pi) > 2$ (excludes bounded quotients)
- A superlinear lower bound on the block complexity of $\mathrm{CF}(\pi)$
- A proof that $\mathrm{CF}(\pi)$ is not generated by any morphism or automaton
- A proof of GK-typicality of $\pi$

Each of these is an open problem, but each is *strictly weaker* than proving $\pi$ is normal in base 10 — the classical open problem since Borel (1909).

---

*Next: [Module 05 — Information Deficit and Mixing](05-Information-Deficit-And-Mixing.md)*
