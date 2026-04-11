# Module 03 — Self-Encoding of Euler's Number

## 3.1 The Continued Fraction of $e$

**Theorem 3.1** (Euler, 1737). The simple continued fraction expansion of Euler's number is:

$$e = [2;\; 1, 2, 1, 1, 4, 1, 1, 6, 1, 1, 8, 1, 1, 10, \ldots]$$

The partial quotients obey the closed-form rule: for $n \geq 1$,

$$a_n = \begin{cases} 1 & \text{if } n \not\equiv 2 \pmod{3} \\[6pt] 2\!\left\lfloor\dfrac{n+1}{3}\right\rfloor & \text{if } n \equiv 2 \pmod{3} \end{cases}$$

*Proof.* Euler derived this from the generalized continued fraction expansion of $e^{2/m}$ for integer $m$. A modern proof appears in Cohn [1980] and Olds [1963, Chapter 6]. The formula can be verified computationally to arbitrary depth. $\square$

## 3.2 Detection Algorithm

**Lemma 3.2** (Rule Detection). Given a finite sequence $(a_1, \ldots, a_N)$ with $N \geq 15$, the following algorithm either detects the positional-polynomial rule of Theorem 3.1 or reports failure:

**Algorithm** `DetectPositionalRule`:

1. **For each** candidate period $p = 1, 2, \ldots, \lfloor N/5 \rfloor$:
2. &emsp; Partition the indices $\{1, \ldots, N\}$ into residue classes $S_r = \{n : n \equiv r \pmod{p}\}$.
3. &emsp; **For each** class $S_r$, extract the subsequence of values and test:
   - Is the subsequence **constant** (all values equal)?
   - Is the subsequence **linear** (successive differences constant and nonzero)?
4. &emsp; **If** all $p$ classes are either constant or linear, **return** the detected rule.
5. **Return** "no rule found."

**Lemma 3.3** (Sufficiency of 15 Terms). The algorithm `DetectPositionalRule` correctly identifies the rule of Theorem 3.1 from any prefix of $\mathrm{CF}(e)$ with $N \geq 15$.

*Proof.* With $p = 3$, each residue class contains $\lfloor N/3 \rfloor \geq 5$ elements. Class $S_0$: values $(a_3, a_6, a_9, \ldots) = (1, 1, 1, \ldots)$, constant. Class $S_1$: values $(a_1, a_4, a_7, \ldots) = (1, 1, 1, \ldots)$, constant. Class $S_2$: values $(a_2, a_5, a_8, \ldots) = (2, 4, 6, \ldots)$, linear with difference 2. All three classes are regular. The algorithm detects this at $p = 3$ and returns the rule.

The threshold $N = 15$ ensures 5 elements per class, sufficient to confirm constant behavior (5 identical values) and linear behavior (4 consecutive constant differences) with negligible probability of false detection. $\square$

## 3.3 Main Theorem

**Theorem 3.4** ($e$ Is Self-Encoding). The constant $e$ is self-encoding in the sense of Definition 2.6, with predictor class $\mathcal{K}_2$ and threshold $N_0 = 15$.

*Proof.* Define the predictor $P_e \in \mathcal{K}_2$ as follows: given $(a_1, \ldots, a_N)$ with $N \geq 15$, run `DetectPositionalRule`. By Lemma 3.3, it returns the rule of Theorem 3.1. Apply the rule to compute $a_{N+1}$ from $N+1$.

By Theorem 3.1, the rule produces the correct value of $a_{N+1}$ for every $N$. Hence $H(P_e, e, N) = \infty$ for all $N \geq 15$, and $\mathrm{acc}(P_e, e) = 1$. $\square$

**Corollary 3.5**. The information deficit of $e$ is zero:

$$D(e, N) = 0 \qquad \text{for all } N \geq 15$$

*Proof.* Since $a_{N+1}$ is a deterministic function of $N+1$ (which is computable from $N$, which is the length of the input), the conditional entropy $H(a_{N+1} \mid a_1, \ldots, a_N) = 0$. By the identity $D = H(a_{N+1}) - I(a_{N+1}; a_1, \ldots, a_N) = H(a_{N+1} \mid a_1, \ldots, a_N) = 0$. $\square$

## 3.4 Other Self-Encoding Constants

**Proposition 3.6.** The following constants are self-encoding:

| Constant | CF Structure | Class | $N_0$ |
|:---|:---|:---|---:|
| $\varphi = \tfrac{1+\sqrt{5}}{2}$ | $[1; 1, 1, 1, \ldots]$ — constant | $\mathcal{K}_0$ | 3 |
| $\sqrt{2}$ | $[1; 2, 2, 2, \ldots]$ — constant | $\mathcal{K}_0$ | 3 |
| All quadratic irrationals | Eventually periodic (Lagrange) | $\mathcal{K}_1$ | $2L + P$ |
| $e$ | Period 3, linear growth (Euler) | $\mathcal{K}_2$ | 15 |

Here $L$ denotes the pre-period length and $P$ the period of the CF.

*Proof.* Each follows from the known explicit CF expansion and the appropriate specialization of `DetectPositionalRule`. $\square$

---

*Next: [Module 04 — Non-Predictability of $\pi$](04-Non-Predictability-Of-Pi.md)*
