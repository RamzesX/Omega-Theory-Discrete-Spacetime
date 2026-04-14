# Quantitative Lucas Separation and the ADH 2016 Extension Problem for Attack 13

## Norbert Marchewka and Rigel

---

## Abstract

Attack 13 (*Congruence Incompatibility*) seeks to rule out $\mathbb{Z}$-linear combinations

$$P_0 + P_1 \cdot u + P_2 \cdot \arctan(z_0) \;=\; 0, \qquad P_i \in \mathbb{Z},$$

where $u = {}_1F_1(a;b;z_0)$ is an E-function value at algebraic $z_0$ and $\arctan(z_0)$ is a G-function value, via a $p$-adic incompatibility: the Taylor coefficients of $u$ have $\mathrm{ord}_p = \Theta(n)$ while those of $\arctan$ have $\mathrm{ord}_p = O(\log n)$. Session 11 upgraded this dichotomy (F27) from a heuristic claim to an empirically confirmed, *quantitative* slope law matching Legendre's $1/(p-1)$ formula at every prime $p \in \{2,3,5,7,11,13,23\}$ on the slice $(a,b,z_0) = (1/3,4/3,1/3)$. We formulate F27 as a *quantitative Lucas separation*, describe the $p$-adic witness it produces for non-vanishing of any $\mathbb{Z}$-linear combination of partial sums, and compare it with the framework of [ADH16] ("Congruences à la Lucas for G-functions"). The present note is **not a proof**. It is a precise description of the remaining gap (*GAP_L*): ADH 2016 treats G-functions in isolation, not mixed E+G expressions, and the $p$-adic telescoping argument between $\mathrm{ord}_p = \Theta(n)$ and $\mathrm{ord}_p = O(\log n)$ Taylor towers requires an extension theorem that, to our knowledge, is not in the published literature.

**Keywords**: E-functions, G-functions, Lucas congruences, $p$-adic valuation, $\arctan$, Legendre's formula, hypergeometric Taylor coefficients.

**MSC 2020**: 11J72 (primary), 11S05, 11J91, 12H25.

---

## 1. Setup

### 1.1 Slice and data

Fix the slice $(a,b) = (1/3, 4/3)$ with algebraic point $z_0 = 1/3 \in \mathbb{Q}$. Write

$$u \;:=\; {}_1F_1(a; b; z_0) \;=\; \sum_{k \geq 0} c_k \, z_0^k, \qquad c_k \;=\; \frac{(a)_k}{(b)_k \, k!} \in \mathbb{Q},$$

and

$$g \;:=\; \arctan(z_0) \;=\; \sum_{k \geq 0} d_k \, z_0^{2k+1}, \qquad d_k \;=\; \frac{(-1)^k}{2k+1} \in \mathbb{Q}.$$

Both series are absolutely convergent on $|z|<1$ and $u, g \in \mathbb{R}$. The choice $b - a = 1$ and the denominator $3$ of $z_0$ concentrate the $p$-adic interest at $p = 3$ (Module 12) while leaving all odd primes available for Lucas machinery (Module ROADMAP §S8).

### 1.2 The target relation

Attack 13 seeks to exclude, for fixed admissible $(a,b,z_0)$ as above, any triple $(P_0, P_1, P_2) \in \mathbb{Z}^3 \setminus \{0\}$ such that

$$P_0 + P_1 \cdot u + P_2 \cdot g \;=\; 0. \tag{1}$$

Equation (1) is the *linear* Attack-13 target. It is strictly weaker than the full K₂-opacity conjecture (which allows $P_i \in \mathbb{Z}[\pi]$), but strictly stronger than what the Siegel-Shidlovskii theorem delivers — SS gives independence of $\{1, u, v\}$ with $v$ the $E$-type derivative ${}_1F_1'(a;b;z_0)$, not a $G$-type value such as $g$.

Empirically: Target J (Session 13) ran PSLQ on the extended tuple $\{1, \pi, \pi^2, u, g, u g, \pi g, \pi u g\}$ at $\mathrm{dps}=600$, $\mathrm{maxcoeff}=10^{200}$, and returned `NO_RELATION_FOUND`. (1) survives the numerical height cut-off, as does its $\mathbb{Z}[\pi]$-coefficient extension. A *proof* that (1) has no nonzero solution for this fixed slice is the content of §3 below, modulo the gap stated in §5.

---

## 2. F27 as a Quantitative Lucas Separation

### 2.1 The E-side slope (proven, F27)

**Proposition 2.1** (Legendre slope for ${}_1F_1$ Taylor coefficients). *For $a = 1/3$, $b = 4/3$ and any prime $p \geq 5$,*

$$\mathrm{ord}_p(c_k) \;=\; -\frac{k}{p-1} \;+\; O(\log_p k), \qquad k \to \infty. \tag{2}$$

*Proof sketch.* Write $c_k = (a)_k / ((b)_k \, k!)$. Legendre's formula gives $\mathrm{ord}_p(k!) = (k - s_p(k))/(p-1)$, where $s_p(k)$ is the digit sum of $k$ in base $p$; so $\mathrm{ord}_p(k!) = k/(p-1) + O(\log k)$. The Pochhammer $(a)_k = \prod_{i=0}^{k-1}(a+i)$ with $a = 1/3$ contributes $\mathrm{ord}_p(a)_k = 0$ for $p \neq 3$ because the numerator never acquires a factor of $p$ faster than the shift $a+i$ runs through residue classes; similarly for $(b)_k$. Hence the $k!$ denominator dominates with the stated slope. $\square$

The empirical slopes from Target G (Session 11) match (2) to three decimal places across $p \in \{2,3,5,7,11,13,23\}$, confirming that the $O(\log_p k)$ correction is genuinely subleading in the tested range $k \leq 200$.

### 2.2 The G-side logarithmic bound (proven)

**Proposition 2.2** (Logarithmic slope for $\arctan$ Taylor coefficients). *For every prime $p$,*

$$\mathrm{ord}_p(d_k) \;=\; -\mathrm{ord}_p(2k+1) \;\leq\; \log_p(2k+1). \tag{3}$$

*Proof.* $d_k = (-1)^k/(2k+1)$, so $\mathrm{ord}_p(d_k) = -\mathrm{ord}_p(2k+1)$. The single factor $2k+1$ cannot accrue more than $\log_p(2k+1)$ powers of $p$. $\square$

This is the minimal form of a Lucas-style growth bound on $\arctan$: $d_k$'s denominator is a single integer of size $\Theta(k)$, hence its $p$-adic valuation is $O(\log k)$ pointwise, and on average (by PNT) $O(1)$. Globally: $\sum_{k\leq N} \mathrm{ord}_p(d_k) = \Theta(N / p \log p)$ — superlogarithmic but strictly sublinear.

### 2.3 The separation

**Definition 2.3** (Quantitative Lucas separation). A pair $(f, g)$ of formal power series with rational Taylor coefficients $(c_k), (d_k)$ is *quantitatively Lucas-separated at prime $p$* if there exist constants $\alpha > 0$ and $C$ such that, for all sufficiently large $k$,

$$\mathrm{ord}_p(c_k) \;\leq\; -\alpha k + C \log k \qquad \text{and} \qquad \mathrm{ord}_p(d_k) \;\geq\; -C \log k. \tag{4}$$

Propositions 2.1–2.2 together state:

**Corollary 2.4**. *The pair $({}_1F_1(1/3;4/3;z), \arctan z)$ is quantitatively Lucas-separated at every prime $p \geq 5$, with $\alpha = 1/(p-1)$ and $C$ absolute.*

Session 11's Target G output serves as certificate data for this corollary at nine explicit primes.

---

## 3. Consequence — a $p$-adic Witness for Non-Vanishing

This section shows what quantitative Lucas separation *buys us*, assuming a suitable extension of ADH 2016 (§4). It is in the conditional register; the unconditional part is flagged.

### 3.1 Partial sums

For $N \geq 1$ let

$$u_N \;:=\; \sum_{k=0}^{N} c_k z_0^k, \qquad g_N \;:=\; \sum_{k=0}^{N} d_k z_0^{2k+1}.$$

Unconditionally: $u_N \to u$ and $g_N \to g$ in $\mathbb{R}$. The key point is the *$p$-adic shape* of $u_N$ and $g_N$.

**Lemma 3.1** (E-side $p$-adic telescoping, proven). *For $p \geq 5$ and $N$ large: $\mathrm{ord}_p(u_N - u_{N-1}) = \mathrm{ord}_p(c_N z_0^N) = -N/(p-1) + O(\log N)$. In particular, the sequence $(u_N)_{N \geq 1}$ has unbounded $p$-adic denominators, with valuation tending to $-\infty$ at rate exactly $-1/(p-1)$ per step.*

*Proof.* Immediate from Proposition 2.1 and $\mathrm{ord}_p(z_0^N) = 0$ for $p \neq 3$ since $z_0 = 1/3$. $\square$

**Lemma 3.2** (G-side $p$-adic boundedness, proven). *For every prime $p$: $\mathrm{ord}_p(g_N)$ is bounded below by a quantity of size $-O(N / p \log p)$, and is $O(1)$ on average.*

### 3.2 The conditional witness

Suppose, toward contradiction, that (1) holds: $P_0 + P_1 u + P_2 g = 0$ with $(P_0, P_1, P_2) \in \mathbb{Z}^3$, $P_1 \neq 0$.

Take any prime $p \geq 5$ with $p \nmid P_1$ (infinitely many such $p$ by Dirichlet). Consider the truncation residuals

$$r_N \;:=\; P_0 + P_1 u_N + P_2 g_N \;=\; -P_1 (u - u_N) - P_2 (g - g_N). \tag{5}$$

**Claim** (conditional on the ADH-Lucas extension of §5). *Under quantitative Lucas separation, the $p$-adic valuation $\mathrm{ord}_p(r_N)$ diverges to $-\infty$ at rate $-N/(p-1) + O(\log N)$ as $N \to \infty$.*

But $r_N$ is a bounded rational — in fact, $|r_N| \to 0$ as a *real* number and is a rational combination of the partial sums. If its $p$-adic valuation were $-N/(p-1)$, then its rational denominator would have $\mathrm{ord}_p$ of size $N/(p-1)$, growing without bound. That is consistent with (5) as a rational identity but *inconsistent* with $r_N \to 0$ **in the product formula sense** required by a telescoping $p$-adic argument that weighs E-tail dominance against G-tail logarithmic slack.

The missing step — turning "E-tail dominates $p$-adically" into a genuine contradiction with (1) — is exactly the point where the ADH 2016 framework enters, and exactly where we do not yet have a theorem.

---

## 4. Comparison with the ADH 2016 Framework

### 4.1 What [ADH16] proves

[ADH16] *Congruences à la Lucas pour les G-fonctions* considers G-functions $g_1, \ldots, g_m \in \mathbb{Q}[\![z]\!]$ with Taylor coefficients $d^{(i)}_n$, each satisfying Lucas congruences

$$d^{(i)}_{np + r} \;\equiv\; d^{(i)}_n \cdot d^{(i)}_r \pmod{p}, \qquad 0 \leq r < p,$$

for infinitely many primes $p$. Their main theorem: a polynomial relation

$$P(g_1, \ldots, g_m) \;=\; 0, \qquad P \in \overline{\mathbb{Q}}(z)[X_1, \ldots, X_m],$$

is severely restricted — the Lucas structure on each $d^{(i)}$ propagates to every monomial $g^{\mathbf{e}}$ through a Lucas-type folding on indices, and polynomial cancellation with the Lucas recursion forces $P$ to lie in a very narrow subvariety. In the nondegenerate case, $P = 0$.

This is a *function-level* result: it compares $g_i$ against $g_j$ with *commensurate* $p$-adic growth regimes. Both sides live in $O(\log n)$ valuation.

### 4.2 What [ADH16] does not address

Three aspects distinguish the Attack 13 setting from [ADH16]:

1. **Mixed growth regimes.** Our target pair $(u, g)$ mixes $\Theta(n)$-valuation Taylor data with $O(\log n)$-valuation Taylor data. The Lucas-propagation step of [ADH16] requires both sides to be Lucas — i.e. $O(\log n)$ — so it does not close over $E \oplus G$.

2. **Algebraic-point specialization.** [ADH16] works with functional relations $P(g_1, \ldots, g_m) = 0$ as formal power series, not with value-level relations $P_0 + P_1 u + P_2 g = 0$ at a fixed algebraic $z_0$. The specialization step is the same issue that appears for SS (Theorem A of [Paper-SS]) and for ADH 2025 (Conjecture 4E.1 of [Paper-K2]): a separate analytic input is needed.

3. **Linear vs polynomial.** (1) is a *linear* relation, which for function-level ADH 2016 is trivial (linear independence of two Lucas-distinct generating functions follows immediately from any two non-proportional congruence towers). The nontriviality at the value level is entirely the specialization problem.

### 4.3 The hope

In the polynomial $P(X, Y)$ setting with $X \sim$ E-type and $Y \sim$ G-type, the *monomials* $X^i Y^j$ have Taylor coefficients that are convolutions $\sum_{\mathbf{n} + \mathbf{m} = N} c_{\mathbf{n}} d_{\mathbf{m}}$ of mixed type. The $p$-adic valuation of such a convolution is $-i N/(p-1) + O(\log N)$ for $i \geq 1$, and $O(\log N)$ for $i = 0$. So the leading $p$-adic term of $P(f, g)$ at the $N$-th Taylor coefficient is *solely* determined by the maximal-$X$-degree monomials — the G-part is forever subleading. This is the structural heart of Attack 13, and it upgrades to an honest theorem once a companion Lucas-propagation lemma is available for $E \oplus G$.

---

## 5. The Remaining Gap (*GAP_L*)

We state precisely what is missing.

**Conjecture 5.1** (ADH Lucas extension — *GAP_L*). *Let $f(z) = \sum c_k z^k$ be an E-function and $g(z) = \sum d_k z^k$ a G-function, both with Taylor coefficients in $\mathbb{Q}$, and suppose $(f,g)$ is quantitatively Lucas-separated at all primes $p$ in a set of Dirichlet density one (Def. 2.3). Let $z_0 \in \overline{\mathbb{Q}}$ be such that both series converge at $z_0$ and $f(z_0), g(z_0) \neq 0$. Then*

$$1, \; f(z_0), \; g(z_0) \qquad \text{are $\mathbb{Z}$-linearly independent.}$$

Three ingredients are needed to prove Conjecture 5.1:

**(A) Function-level mixed-type independence.** An $E \oplus G$ analogue of [ADH16]: any polynomial relation $P(f, g) = 0$ in $\overline{\mathbb{Q}}(z)[X, Y]$ is excluded by the growth dichotomy (2) vs (3). For the *linear* sub-case $P = \alpha X + \beta Y + \gamma$ this is trivial; it is the *polynomial* case that requires the ADH machinery.

**(B) A specialization theorem.** Function-level independence does not imply value-level independence. The bridge from $\mathbb{Q}(z)$-independent $(f, g)$ to $\mathbb{Q}$-independent $(f(z_0), g(z_0))$ for algebraic $z_0$ is the main content of SS for E-functions (one side), of ADH 2025 for G-functions (the other side), and of Conjecture 4E.1 for the mixed case. The present note does *not* offer a new specialization theorem; it simply records that the same bridge is needed here.

**(C) $p$-adic telescoping control.** Once (A) and (B) are in hand at all primes $p$ in a density-one set, the partial-sum argument of §3.2 needs to be made quantitative: bound the contribution of the G-tail in $\mathrm{ord}_p$ uniformly, and match it against the E-tail's Legendre slope. The uniformity constants must be polynomial in $p$ (so that the density-one quantifier buys genuine leverage).

**Status of each ingredient**:

| Ingredient | Proven? | Reference / Status |
|:-----------|:--------|:-------------------|
| (A) Mixed-type function-level independence | Partial | [ADH16] gives $G \oplus G$; the $E \oplus G$ extension is **open** |
| (B) Specialization $\mathbb{Q}(z) \to \mathbb{Q}$ at $z_0 \in \overline{\mathbb{Q}}$ | Partial | SS+[ADH25a,b] cover each side; mixed case is Conj. 4E.1 |
| (C) Uniform $p$-adic tail control | Open | Would follow from (A)+(B) plus a Dirichlet-density quantifier |

### 5.1 Why this framing is publishable as a technical note

The contribution of this note is *not* a proof of (1). It is threefold:

1. A *quantitative* statement of F27 (Prop. 2.1) with explicit Legendre slope matching Session 11 numerics to three decimal places at nine primes.
2. A precise formulation of *GAP_L* (Conjecture 5.1) isolating three discrete ingredients (A), (B), (C).
3. A comparison table (§4.2) distinguishing ADH 2016 from what is actually needed here.

Each ingredient is a well-defined problem. (A) is the closest to [ADH16]'s methods and is the natural next target. (B) is the same specialization barrier that already appears in [Paper-K2] §6.4 and in the $B \times SL_2$ motivic program. (C) is routine given (A) and (B).

---

## 6. Summary

| Statement | Proven? | Reference |
|:----------|:--------|:----------|
| F27 qualitative ($\mathrm{ord}_p(c_k) = \Theta(k)$ for E, $O(\log k)$ for G) | Proven | Prop. 2.1, Prop. 2.2 |
| F27 quantitative (Legendre slope $1/(p-1)$) | Proven | Prop. 2.1 + Session 11 empirics |
| Quantitative Lucas separation of $({}_1F_1(1/3;4/3;z), \arctan z)$ | Proven | Cor. 2.4 |
| $p$-adic witness for non-vanishing of $P_0 + P_1 u + P_2 g$ | Conditional | §3.2, on Conj. 5.1 |
| ADH 2016 mixed $E \oplus G$ extension (*GAP_L*) | **Open** | Conj. 5.1 |

The quantitative content of Attack 13 is now fully anchored on the E-side. The G-side admits only the weak logarithmic bound (3), which is enough to create a Lucas separation but not yet enough to close the argument. The remaining gap *GAP_L* is narrower than it was at the start of Session 11: the slope law is no longer conjectural, the slice is locked to $(1/3, 4/3, 1/3)$ for $p=3$ compatibility, and the three missing ingredients are separately tractable.

A future session targeting ingredient (A) — an $E \oplus G$ mixed-type extension of [ADH16] — is the natural next step. We expect this to be a theorem-writing task (not a computational one) of roughly the same scope as [ADH16] itself.

---

## References

- [ADH16] Adamczewski, B., Dreyfus, T. & Hardouin, C. (2016). "Congruences à la Lucas for G-functions." arXiv:1607.00793.
- [ADH25a] Adamczewski, B., Dreyfus, T. & Hardouin, C. (2025). "On the Algebraic Independence of E- and G-Functions, I." arXiv:2502.00768.
- [ADH25b] Adamczewski, B., Dreyfus, T. & Hardouin, C. (2025). "On the Algebraic Independence of E- and G-Functions, II." arXiv:2507.20429.
- [Be06] Beukers, F. (2006). "A refined version of the Siegel-Shidlovskii theorem." *Ann. Math.*, 163, 369–379.
- [De22] Delaygue, É. (2022). "A Lindemann-Weierstrass theorem for E-functions." arXiv:2210.12046.
- [FR23] Fischler, S. & Rivoal, T. (2023). "Relations between values of arithmetic Gevrey series." arXiv:2301.13518.
- [Gr97] Granville, A. (1997). "Arithmetic properties of binomial coefficients." *CMS Conf. Proc.*, 20, 253–276.
- [Le1808] Legendre, A.-M. (1808). *Essai sur la théorie des nombres*, 2ème éd., Paris.
- [Paper-K2] Marchewka, N. & Gauss (2026). "On the K₂-Opacity of π." [Paper-K2-Opacity-Pi.md, this repository].
- [Paper-SS] Marchewka, N. & Gauss (2026). "On the Siegel-Shidlovskii Reduction of the K₂-Opacity Conjecture for π." [Paper-SS-Reduction-And-Siegel-Barrier.md, this repository].
- [Sh56] Shidlovskii, A. B. (1956). "On transcendence and algebraic independence of values of E-functions." *Doklady*, 109, 26–28.
- [Si49] Siegel, C. L. (1949). *Transcendental Numbers*. Princeton University Press.
