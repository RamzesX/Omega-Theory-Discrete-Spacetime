# Module 02 — Definitions and Framework

## 2.1 Predictor Classes

**Definition 2.1** (Predictor). A *predictor* is an algorithm $P: \bigcup_{N=1}^{\infty} \mathbb{N}^N \to \mathbb{N}$ that, given a finite sequence $(a_1, \ldots, a_N)$ of positive integers, outputs a prediction for $a_{N+1}$. The predictor has access **only** to the sequence values and the length $N$ — not to any external definition of the number $\alpha$ whose CF expansion is $(a_n)$.

**Definition 2.2** (Predictor Hierarchy). We define the following classes, ordered by expressive power:

$$\mathcal{K}_0 \subset \mathcal{K}_1 \subset \mathcal{K}_2 \subset \mathcal{K}_3 \subset \mathcal{K}_4 \subset \mathcal{K}_5$$

| Class | Formal Definition | Intuition |
|:---|:---|:---|
| $\mathcal{K}_0$ | $P(\mathbf{a}) = c$ for a fixed constant $c$ | Always guesses the same value |
| $\mathcal{K}_1$ | $P(\mathbf{a}) = f(N \bmod p)$ for fixed $p, f$ | Repeats a periodic pattern |
| $\mathcal{K}_2$ | $P(\mathbf{a}) = f_r\!\left(\lfloor N/p \rfloor\right)$ where $r = N \bmod p$ and each $f_r$ is a polynomial | Positional rule with polynomial growth |
| $\mathcal{K}_3$ | $P$ is computed by a finite automaton reading $(a_1, \ldots, a_N)$ | Bounded-memory rule |
| $\mathcal{K}_4$ | $P$ uses empirical frequencies, $n$-grams, or Markov models of $(a_1, \ldots, a_N)$ | Statistical prediction |
| $\mathcal{K}_5$ | $P$ is any Turing machine running in $\mathrm{poly}(N)$ time on input $(a_1, \ldots, a_N)$ | General efficient predictor |

**Remark 2.3.** The hierarchy captures increasing computational power. $\mathcal{K}_0$–$\mathcal{K}_2$ are "structural" predictors that exploit patterns in the sequence. $\mathcal{K}_3$–$\mathcal{K}_5$ are "computational" predictors that may use complex analysis of the data. The key distinction is: all classes $\mathcal{K}_0$–$\mathcal{K}_5$ operate on the sequence alone, without importing the identity or definition of $\alpha$.

## 2.2 Accuracy and Prediction Horizon

**Definition 2.4** (Accuracy). The *long-run accuracy* of predictor $P$ on constant $\alpha$ is:

$$\mathrm{acc}(P, \alpha) = \liminf_{N \to \infty} \frac{1}{N} \sum_{n=1}^{N} \mathbf{1}\big[P(a_1, \ldots, a_n) = a_{n+1}\big]$$

**Definition 2.5** (Prediction Horizon). The *prediction horizon* of $P$ for $\alpha$ at training size $N$ is:

$$H(P, \alpha, N) = \max\{h \geq 0 : P \text{ correctly predicts } a_{N+1}, a_{N+2}, \ldots, a_{N+h} \text{ consecutively}\}$$

where each correct prediction is appended to the input before predicting the next.

## 2.3 Self-Encoding and Opacity

**Definition 2.6** (Self-Encoding). A constant $\alpha$ is *self-encoding* if:

$$\exists\, P \in \mathcal{K}_2,\; \exists\, N_0 \in \mathbb{N}: \quad \forall\, N \geq N_0:\; H(P, \alpha, N) = \infty$$

A finite prefix of the CF, processed by a positional-polynomial rule, suffices to generate the entire infinite tail.

**Definition 2.7** (Opacity). A constant $\alpha$ is *opaque with respect to class $\mathcal{K}$* if:

$$\forall\, P \in \mathcal{K}:\; \mathrm{acc}(P, \alpha) < 1$$

No predictor in $\mathcal{K}$ achieves perfect accuracy.

**Remark 2.8.** Self-encoding is an existential statement (a good predictor *exists*). Opacity is a universal statement (no good predictor *exists*). The dichotomy theorem (Module 04) establishes: $e$ is self-encoding, and $\pi$ is opaque with respect to $\mathcal{K}_1$.

## 2.4 Information Deficit

**Definition 2.9** (Information Deficit). For a constant $\alpha$ with CF partial quotients $(a_n)$, the *information deficit at position $N$* is:

$$D(\alpha, N) = H(a_{N+1}) - I(a_{N+1};\; a_1, \ldots, a_N)$$

where $H(\cdot)$ is Shannon entropy and $I(\cdot\,;\,\cdot)$ is mutual information, both computed with respect to the Gauss–Kuzmin measure $\gamma$ on the space of CF expansions.

**Interpretation.** The deficit $D$ measures how many bits of information about $a_{N+1}$ are *absent* from the sequence $(a_1, \ldots, a_N)$ and must be supplied by an external source — the defining formula of $\alpha$.

- If $D = 0$: the sequence contains all necessary information. No external formula needed.
- If $D > 0$: the sequence is missing $D$ bits per step. A formula must *pump* in fresh information.

---

*Next: [Module 03 — Self-Encoding of Euler's Number](03-Self-Encoding-Of-Euler.md)*
