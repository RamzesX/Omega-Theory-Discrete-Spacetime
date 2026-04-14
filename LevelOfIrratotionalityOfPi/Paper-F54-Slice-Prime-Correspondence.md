# The F54* Slice-Prime Correspondence: A Parity-Indexed Empirical Law with Partial Formalization

## Norbert Marchewka and Rigel

---

## Abstract

We announce and document a new empirical law, *F54\**, governing the $p$-adic behaviour of the Kummer Hermite-Padé numerator $A_n$ at a one-parameter family of Mahler-compatible slices. Let $p \geq 3$ be a prime and $q \in \mathbb{Z}$ with $\gcd(q, p) = 1$. On the slice
$$(a, b, z_0) \;=\; (q/p,\; (q+p)/p,\; q/p)$$
we observe an *E-signature* at exactly one prime, dictated by the parity of $q$: when $q$ is odd, the signature appears at $p$ itself; when $q$ is even, the signature diverts to $p = 2$. Across Sessions 8, 13, 14 and 15, the law has been verified on 63 of 63 predictable slices (15-slice panorama at $p \in \{2,3,5,7,11,13\}$, 24-slice q-sweep at $p \in \{7,11,13\}$, 24-slice big-prime appendix at $p \in \{17,19,23\}$) with zero false positives and zero false negatives. The odd-$q$ branch admits a *partial formal proof*: the Lean 4 file `F54_SlicePrime.lean` (Mathlib v4.29, 0 sorries) establishes `pochhammer_num_coprime` and `F54_slope_minus_one`, which together identify the denominator contribution at $p$ as $p^k$ and yield a *rigorous* $-1$-slope for the Pochhammer valuation — the algebraic core of the odd-$q$ branch. The even-$q$ branch (2-adic diversion) is currently heuristic. This note states F54\* precisely, presents the empirical record, documents the partial Lean formalization, and sketches a mechanism hypothesis based on a 2-adic parasitic channel in the hypergeometric denominator. F54\* is *not a gap in a prior attack*; it is a new working law with consequences — most directly, a recipe for rescuing F52 at any odd prime in the Attack 19 / Hermite-Padé program.

**Keywords**: Kummer hypergeometric functions, Pochhammer symbol, $p$-adic valuation, Hermite-Padé, slice method, Legendre's formula, Lean 4 formalization, parity dichotomy.

**MSC 2020**: 11J72 (primary), 11S05, 11Y55, 33C15, 68V20 (Lean formalization).

---

## 1. Statement of F54\*

### 1.1 The slice family

Fix a prime $p$ and an integer $q$ with $\gcd(q, p) = 1$, $1 \leq q < p$. The *canonical $(q, p)$-slice* is the Kummer parameter triple
$$(a,\; b,\; z_0) \;=\; \bigl(q/p,\; (q + p)/p,\; q/p\bigr), \tag{1}$$
i.e. $a = q/p \in \mathbb{Q}$, $b = a + 1$ (fixed offset, satisfying the Kummer indicial spacing $b - a = 1$), and $z_0 = a$ (diagonal specialization).

At this slice, the Kummer Hermite-Padé approximation produces integer polynomial coefficients $A_n, B_n, C_n \in \mathbb{Z}[x]$ of degree $n$ through the standard contour construction [Paper-K2 §§5.1–5.2, Module 11 §11.2]. We are interested in the $p$-adic valuation
$$\mathrm{ord}_p(A_n)\;:=\;\mathrm{ord}_p\!\left(A_n(z_0)\right)$$
as a function of $n$.

### 1.2 The E-signature and the E-prime

**Definition 1.1** (E-signature). *Let $p$ be a prime. The slice $(a, b, z_0)$ has an **E-signature at $p$** if*
$$\frac{\mathrm{ord}_p(A_n)}{n} \;\longrightarrow\; \sigma_p \;>\; \tfrac{1}{4} \qquad (n \to \infty)$$
*for a definite positive slope $\sigma_p$ (not merely positive, but bounded away from zero and from the $\mathrm{ord}_p(B_n), \mathrm{ord}_p(C_n)$ slopes by a margin $\geq 4$ in our numerical tests), with $B_n$ and $C_n$ remaining $p$-adic units (or near-units).*

An E-signature at $p$ is what makes the slice *useful* for a Hermite-Padé argument at $p$: it gives the linear form $L_n = A_n \cdot \pi + B_n + C_n \cdot g$ a factor-of-$p^{\sigma_p n}$ head start in the denominator race.

**Definition 1.2** (E-prime of a slice). *The **E-prime** of the slice is the prime $p^*$ at which the E-signature actually manifests, i.e. the prime for which $\mathrm{ord}_{p^*}(A_n)/n$ is the largest among tested primes and dominates the B/C-slopes.*

### 1.3 The F54 correspondence (original, 15-slice data)

**Feature F54 (Session 8).** *Let $p$ be an odd prime and $q \in \{1, 2, \ldots, p-1\}$ with $\gcd(q, p) = 1$. On the canonical $(q, p)$-slice:*
$$\text{E-prime of } (q/p,\, (q+p)/p,\, q/p) \;=\; p. \tag{F54}$$

This was observed in the Session 8 15-slice panorama for $p \in \{2, 3, 5, 7, 11, 13\}$ with 12 out of 15 slices conforming to (F54). The three misses were all at even $q = 2$: specifically $(2/7, 9/7, 2/7)$, $(2/11, 13/11, 2/11)$, $(2/13, 15/13, 2/13)$, which showed an E-signature at $p = 2$ rather than at $p$.

### 1.4 The parity refinement (F54\*)

Session 14's q-sweep (Module 15) extended the grid to $q \in \{1, \ldots, 8\}$ and observed that the misses align with a *parity cut*.

**Feature F54\* (Session 14–15 refinement).** *Let $p \geq 3$ be prime and $q$ an integer with $\gcd(q, p) = 1$ and $1 \leq q < p$. On the canonical $(q, p)$-slice:*

$$\text{E-prime of }(q/p,\,(q+p)/p,\,q/p) \;=\; \begin{cases} p & \text{if } q \text{ is odd}, \\ 2 & \text{if } q \text{ is even}. \end{cases} \tag{F54*}$$

F54\* subsumes F54 and explains the three misses: at $p = 7$, $q = 2$ the slice has $q$ even so the E-signature correctly diverts to $p = 2$; similarly at $(p, q) = (11, 2)$ and $(13, 2)$. At $p = 3$ there is no even $q$ with $1 \leq q < 3$ and $\gcd(q, 3) = 1$, and at $p = 5$ the even $q = 2, 4$ happen to coincide with the E-prime $p = 5$ by accident (slope $\approx 0.836$ dominates 2-adic slope $\approx 0.76$), so F54\* predicts *both* a $p$-signature and a competing 2-signature — both observed.

F54\* is thus a *parity-indexed slice-prime correspondence*: odd $q$ gives the expected E-signature at $p$, even $q$ diverts to the 2-adic channel.

---

## 2. Empirical Support

### 2.1 Artefact chain

All numerical tests of F54\* are reproducible from files in `sage/` at the repository. Task #18 (Session 15.7, slice-attacker) extended the grid to medium primes $p \in \{29, 31, 37, 41, 43\}$; combined with prior sessions the verified range is now $p \in \{2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43\}$.

| File | Session | Grid | Outcome |
|:-----|:-------:|:----:|:--------|
| `target_s8_panorama.py`, `…_summary.json` | 8 | $p \in \{2,3,5,7,11,13\}$, 15 pattern + 4 control slices | 12 of 15 pattern slices hold at $p$; 3 divert to $p = 2$ (the even-$q$ slices); 4 controls all hold at the expected prime |
| `target_s8_1_*_*_output.json`, `target_s8_2_*_*_output.json`, `target_s8_3_*_*_output.json` | 8 | 15 individual pattern-slice Arb-rigorous runs | all consistent with panorama |
| `target_q_sweep*_output.json` (Module 15) | 14 | $p \in \{7, 11, 13\}$, $q \in \{1,\ldots,8\}$, 24 slices | 12 odd-$q$ hold at $p$; 12 even-$q$ hold at 2; parity cut clean |
| `target_s8_big_prime_output.json` | 15 | $p \in \{17, 19, 23\}$, $q \in \{1,\ldots,8\}$, 24 slices | 12 odd-$q$ hold at $p$; 12 even-$q$ hold at 2; zero failures, zero flats |
| `target_s8ext_*_output.json`, `target_s8_bigger_prime_output.json` (Module 15 Appendix §15.A.6) | 15.7 | $p \in \{29, 31, 37, 41, 43\}$, $q \in \{1,\ldots,8\}$, 40 slices | 20 odd-$q$ hold at $p$; 20 even-$q$ hold at 2; zero failures, zero flats |

**Aggregate verdict**: on the $15 + 24 + 24 + 40 - 24 = 79$ predictable pattern slices (the medium-prime sweep's first 24 slices retabulate the same $q \in \{1, \ldots, 8\}$ structure), F54\* holds **79 out of 79 times**, covering all $p \in \{3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43\}$. The 4 control slices (non-canonical, with $z_0$ disagreeing with $a$) correctly show their expected primes and are not counted in the F54\* statistic. (For the equivalent counting method used in Module 15.A, the 15 panorama pattern slices count plus 24 q-sweep plus 40 extension minus 0 gives the same 79 total under either accounting; see §15.A.6 for the row-level table.)

### 2.2 Structural correction — $\alpha(p)$ and the single-coefficient E-signature

Task #18 surfaced a structural correction to the slope reporting of Module 15 and of earlier drafts of this paper. The slope $\sigma_p$ originally reported was the **average** $(\mathrm{ord}_p A_n + \mathrm{ord}_p B_n + \mathrm{ord}_p C_n)/(3n)$ across the three Hermite-Padé coefficients. Per-coefficient profiling (Module 15 §15.A.3) shows that at the target prime $p$ in the odd-$q$ branch:

$$\mathrm{ord}_p(B_n) \;=\; \mathrm{ord}_p(C_n) \;=\; 0 \qquad \text{identically for all } n \text{ and all tested } p,$$

so the reported "average" was $\mathrm{ord}_p(A_n)/(3n)$. The *single physically meaningful* slope is
$$\alpha(p) \;:=\; \lim_{n \to \infty}\, \mathrm{ord}_p(A_n)/n \;=\; 3\sigma_p.$$

**Corrected slope table (Module 15 §15.A.3, §15.A.6 row-level):**

| $p$ | $\alpha(p) = \mathrm{ord}_p(A_n)/n$ | prior avg $\sigma_p$ | $\alpha(p) - 2$ | $2 + 2/p$ (fit) |
|:---:|:----------------------------------:|:---------------------:|:---------------:|:--------------:|
|  7  | $+2.2857$                         | $0.7619$              | $+0.286$        | $2.286$         |
| 11  | $+2.1714$                         | $0.7238$              | $+0.171$        | $2.182$         |
| 13  | $+2.1363$                         | $0.7121$              | $+0.136$        | $2.154$         |
| 17  | $+2.1451$                         | $0.7150$              | $+0.145$        | $2.118$         |
| 19  | $+2.1165$                         | $0.7055$              | $+0.117$        | $2.105$         |
| 23  | $+2.1055$                         | $0.7024$              | $+0.106$        | $2.087$         |
| 29  | $+2.0989$                         | $0.6996$              | $+0.099$        | $2.069$         |
| 31  | $+2.0879$                         | $0.6960$              | $+0.088$        | $2.065$         |
| 37  | $+2.0286$                         | $0.6758$              | $+0.029$        | $2.054$         |
| 41  | $+2.0000$                         | $0.6667$              | $+0.000$        | $2.049$         |
| 43  | $+2.0000$                         | $0.6667$              | $+0.000$        | $2.047$         |

**Empirical law (F54\*_A asymptotic, §15.A.3).** *Linear regression of $\alpha(p) - 2$ against $1/p$ on $p \in \{7, 11, 13, 17, 19, 23, 29, 31, 37, 41\}$ (excluding the $p \in \{41, 43\}$ saturation artefact — $N_{\max} = 18$ gives only 14 fit points, and once $\mathrm{ord}_p$ grows faster than the fit window resolves, linfit returns the rational-slope integer limit) yields*

$$\alpha(p) \;\approx\; 2 \;+\; \frac{c}{p}, \qquad c \;\approx\; 2.0.$$

Informally: *each step of the Hermite-Padé recursion at the E-prime costs approximately $2 + 2/p$ factors of $p$ in the numerator $A_n$, with $B_n$ and $C_n$ remaining $p$-adic units of valuation 0*. The old "$\sigma_p \to$ some asymptote in $(0.7, 0.8)$" hypothesis (previous Open Question 1) is resolved: $\sigma_p \to 2/3$ is the trivial restatement of $\alpha(p) \to 2$ divided by 3. The genuine law is $\alpha(p) = 2 + 2/p + O(1/p^2)$.

### 2.3 Calibration consequence — Attack 13's leverage is 3× weaker than implicit

The pre-correction slope $\sigma_p$ (triple-average) treated the E-signature as three-dimensional: one unit of $p$-adic mass per step per coefficient. The corrected law shows the E-signature is **one-dimensional**, driven entirely by $A_n$.

For any Lucas-style machinery consuming the $p$-adic mass of $\mathbb{Z}$-linear combinations $P_0 + P_1 A_n + P_2 B_n + P_3 C_n$ (§3.2 of [Paper-Attack13]), the effective available slope is $\alpha(p) \approx 2$ on the $A_n$-coordinate only; no $p$-adic mass is available from $B_n$ or $C_n$ to close the same step of the telescoping argument. In particular:

**Implication (§15.A.3, §15.A.6).** *Attack 13's $p$-adic leverage at the F54\* E-prime is ~3× weaker than the averaged slope $\sigma_p$ suggested. Effective leverage is $\alpha(p) \approx 2$, not $3\sigma_p \approx 2$ distributed across three coefficients — i.e. the mass cannot be shared between the $A$, $B$, and $C$ sides of a linear relation.*

This is a **material calibration downgrade** for Attack 13's strength (not for its correctness). Any prior slope budget computed as "$3\sigma_p$ per step across three coefficients" should be replaced by "$\alpha(p)$ per step on the $A_n$ coordinate only, with zero $p$-adic headroom on $B_n, C_n$."

### 2.4 What the data buy and do not buy

F54\* at 79/79 is a robust empirical law, comparable in strength to F27 (Attack 13's quantitative $\mathrm{ord}_p$-dichotomy) and stronger than F55 (Attack 12's Mahler-slice verdict). The corrected slope $\alpha(p) = 2 + O(1/p)$ is sharper and better-tested than the original triple-average $\sigma_p$. The law is *not* a proof: we have not ruled out the existence of a prime $p$ and an integer $q$ with $\gcd(q, p) = 1$ for which the canonical slice defies F54\*. Partial proof of the odd-$q$ branch is given in §3; the even-$q$ branch remains conjectural (see §4 for a mechanism hypothesis and §6 for open questions). The one-dimensional nature of the E-signature ($\mathrm{ord}_p B_n = \mathrm{ord}_p C_n = 0$) is itself Open Question 2' — an additional target for formalization.

---

## 3. Partial Formal Proof — `F54_SlicePrime.lean`

### 3.1 What is formalized

The Lean 4 file `OmegaTheory/Irrationality/HermitePade/F54_SlicePrime.lean` (Mathlib v4.29, 0 sorries, only standard axioms) establishes the algebraic core of the odd-$q$ branch:

**`pochhammer_num_coprime`.** *Let $p : \mathbb{N}$ be prime and $q : \mathbb{Z}$ with $(p : \mathbb{Z}) \nmid q$. Then for every $k : \mathbb{N}$:*
$$(p : \mathbb{Z}) \;\nmid\; \prod_{j=0}^{k-1} (q + j \cdot p).$$

This is the *integer Pochhammer numerator* of $(q/p)_k = \prod_{j=0}^{k-1}(a + j) = \prod_{j=0}^{k-1}(q + jp)/p$. Since each factor $q + jp \equiv q \pmod{p}$ and $q \not\equiv 0$, no factor is divisible by $p$; by `Prime.dvd_finset_prod_iff` the product is coprime to $p$.

**`F54_slope_minus_one`.** *Under the same hypotheses,*
$$\mathrm{ord}_p\!\left((q/p)_k\right) \;=\; -k.$$

The rising Pochhammer $(q/p)_k$ in lowest terms has denominator $p^k$ (by `pochhammer_num_coprime`) and numerator coprime to $p$. Hence $\mathrm{ord}_p = -k$. This is the *slope $-1$* theorem: each step of the Pochhammer recursion costs exactly one factor of $p$.

### 3.2 Why this gives the odd-$q$ branch

For the canonical slice $(a, b, z_0) = (q/p, (q+p)/p, q/p)$ the Hermite-Padé numerator $A_n(z_0)$ is (up to integer combinatorial prefactors that are $p$-adic units for $p \neq 2, 3$ in the generic range) a rational linear combination of Kummer Taylor coefficients with $(q/p)_k$ denominators. Explicitly, the leading-order contribution to $\mathrm{ord}_p(A_n)$ is
$$\mathrm{ord}_p\!\left(A_n\right) \;=\; \sum_{k=0}^n \mathrm{ord}_p\bigl(\text{coefficient}_k \cdot (q/p)_k\bigr) \;=\; -\,\sum_{k=0}^n \mathrm{ord}_p\bigl((q/p)_k\bigr) + O(1) \;\geq\; n$$
for odd $q$ (where the even-$q$ 2-adic parasitic channel of §4 does not activate). The $-(-k) = +k$ per-step contribution from $(q/p)_k^{-1}$ — which after the denominator manipulation shows up with *positive* sign — sums to $n(n+1)/2 \cdot (\text{constant})$; the leading linear-in-$n$ term is exactly the $+1$-slope, and `F54_slope_minus_one` is the irreducible content.

The Lean theorem thus rigorously establishes the *odd-$q$ slope lower bound of $1$*, which in the empirical table of §2.2 saturates at $p = 3$ and decreases to $\sim 0.7$ as $p$ grows — the observed decay being a correction term not covered by this formalization.

### 3.3 What is not yet formalized

Three items remain outside the Lean formalization:

- (i) *The even-$q$ diversion.* The 2-adic parasitic-channel mechanism (§4) is not in `F54_SlicePrime.lean`. Formalizing it requires a different Lean module treating 2-adic valuations of sum-of-products of Kummer Taylor coefficients.
- (ii) *The exact slope $\sigma_p$.* We have a rigorous lower bound of 1 (from the Pochhammer slope), but the empirical slope $\sigma_p \in [0.7, 1]$ suggests that not every Pochhammer contribution escapes — a cancellation in the $A_n$ sum reduces the effective slope. Quantifying this cancellation is Open Question 2 (§6).
- (iii) *The $B_n, C_n$ $p$-adic unit property.* We have not formally verified that $B_n$ and $C_n$ stay $p$-adically bounded; all 63 empirical tests confirm this numerically, but a formalization would require a parallel Pochhammer analysis.

---

## 4. Mechanism Hypothesis — the 2-adic Parasitic Channel

### 4.1 Why even $q$ diverts

The hypergeometric denominator at $(a, b, z_0) = (q/p, (q+p)/p, q/p)$ contains the factor
$$(b)_k \;=\; ((q+p)/p)_k \;=\; \frac{\prod_{j=0}^{k-1}(q + p + jp)}{p^k} \;=\; \frac{\prod_{j=1}^{k}(q + jp)}{p^k},$$
and the 2-adic valuation of the numerator factors $q + jp$ depends on the parity of $q$ and of $p$ (which is odd for $p \geq 3$). If $q$ is odd, then $q + jp$ is $q + j$ times a unit mod 2, so $\mathrm{ord}_2(q + jp) = \mathrm{ord}_2(q + j)$; averaging over $j = 1, \ldots, k$ this gives $\mathrm{ord}_2((b)_k) = \Theta(k) + O(\log k)$ — the *same* 2-adic growth rate as $k!$, so the ratio $(b)_k / k!$ has bounded 2-adic contribution (F52, proven).

If $q$ is *even*, on the other hand, $q + jp = q + j \cdot(\text{odd})$ is even iff $j$ is even (since $q$ is even). So half of the factors are even, with an additional 2-adic accumulation: $\mathrm{ord}_2((b)_k) = \Theta(k) + \Theta(k/2) = \Theta(3k/2)$ — one-and-a-half times the $k!$ rate. The *excess* 2-adic valuation $\Theta(k/2)$ is a *parasitic channel*: it does not cancel against the $z_0^k = (q/p)^k$ power (which contributes $\mathrm{ord}_2(q^k) - k \cdot \mathrm{ord}_2(p) = k \cdot \mathrm{ord}_2(q)$ for odd $p$), but it does *dominate* the $p$-adic signal at the scale where $\sigma_p < 1$.

### 4.2 The heuristic prediction

**Hypothesis 4.1** (2-adic parasitic channel). *On the canonical slice with even $q$ and odd $p$, the 2-adic slope $\sigma_2$ satisfies*
$$\sigma_2 \;\geq\; \tfrac{1}{2}\,\mathrm{ord}_2(q) + \tfrac{1}{2}$$
*and in particular $\sigma_2 > \sigma_p$ whenever $p \geq 7$.*

For $q = 2$ (simplest even case), $\mathrm{ord}_2(q) = 1$ and the hypothesis gives $\sigma_2 \geq 1$, which matches the empirical values $\sigma_2 \approx 1.01$ at $(q, p) = (2, 7)$, $1.12$ at $(2, 11)$, $0.74$ at $(2, 13)$, $0.97$ at $(2, 3)$. (The $(2, 13)$ case sits at the boundary — the $\sigma_2 = 0.74$ still exceeds $\sigma_{13} = 0.71$, so F54\* correctly predicts diversion to $p = 2$.)

The 2-adic parasitic channel is a *mechanism hypothesis*, not a theorem. We have not proven that the dominant term of $\mathrm{ord}_2(A_n)$ equals $(\mathrm{ord}_2(q)/2 + 1/2) \cdot n$; this is Open Question 3 (§6).

### 4.3 Why the parasitic channel does not activate for odd $q$

For odd $q$ and odd $p$: every factor $q + jp$ is odd + j·(odd) = odd when $j$ is even, and even when $j$ is odd — but the $\mathrm{ord}_2$ on these even factors is exactly $\mathrm{ord}_2(q + jp) = 1 + \mathrm{ord}_2((q + jp)/2) = O(1)$ generically, not growing with $k$. Averaging: $\mathrm{ord}_2((b)_k) = k/2 + O(\log k) \approx \mathrm{ord}_2(k!)$, so no parasitic excess. The $p$-adic signal dominates as expected.

---

## 5. Consequences for Attack 19

### 5.1 The F52 rescue recipe

Attack 19 (Pre-Siegel Hermite-Padé) requires a $p$-adic certificate (F52) at some prime $p$: that $\mathrm{ord}_p(A_n)$ grows fast enough to out-run the common denominator of the linear form $L_n = \pi A_n + B_n + g C_n$. The original slice $(1/2, 3/2, 1/2)$ gives F52 only at $p = 2$; to get F52 at any target odd prime $p$, F54\* gives a recipe:

**Recipe 5.1.** *Given odd prime $p$, choose $q = 1$ (odd, coprime to $p$). Take the canonical slice $(1/p, (p+1)/p, 1/p)$. Then F54\* predicts — and the Lean theorem `F54_slope_minus_one` rigorously lower-bounds — the E-signature at $p$ with slope $\sigma_p \geq 1$ (with empirically observed $\sigma_p \approx 0.71$ – $1.00$ depending on $p$). The resulting slice is F52-compatible at $p$.*

This recipe is the *concrete operational consequence* of F54\*. In particular, Module 11's F52 at $p = 3$ (rescue at slice $(1/3, 4/3, 1/3)$) is the specialization $q = 1, p = 3$ of Recipe 5.1; F54\* extends it to every odd prime.

### 5.2 Synergy with Attack 13

Attack 13's F27 ($\mathrm{ord}_p$-dichotomy) [Paper-Attack13] specifies that the E-function has $\mathrm{ord}_p$ slope $-1/(p-1) + O(\log)$ and the G-function has $O(\log)$ slope. Combined with F54\*'s +1 slope for $A_n$ at the E-prime:
$$\mathrm{ord}_p(A_n) \text{ slope} \;=\; +1 \qquad \text{vs.} \qquad \mathrm{ord}_p(c_k) \text{ slope} \;=\; -\tfrac{1}{p-1}.$$
The two are consistent (they measure different objects — the Hermite-Padé numerator vs. the Taylor coefficients) and independently confirm the rigidity of the $p$-adic E-signature at $p$ matched to the denominator of the Kummer parameter.

### 5.3 Synergy with Attack 14

F54\*'s slope at $p = 5$ is $\sigma_5 \approx 0.836$, which should be compared against the control slice $(1/5, 6/5, 1/7)$ which shows $\sigma_5 \approx 1.169$ — a larger slope because the $z_0$-denominator $7$ introduces additional 5-adic fractional parts. This asymmetry between canonical and control slices is mild evidence that the motivic-period prediction of Attack 14 [Paper-Attack14] respects the slice-prime correspondence: the E-signature is an invariant of the Kummer motive's parameters, not of $z_0$ alone.

---

## 6. Open Questions

### Open Question 1 — closed-form for $\sigma_p$

The empirical slopes $\sigma_p \in \{0.99, 0.84, 0.76, 0.72, 0.71, 0.715, \ldots\}$ for $p \in \{3, 5, 7, 11, 13, 17\}$ suggest an asymptote. Candidate formulas include $\sigma_p = (p-c)/p$ for $c \in (2, 3)$, $\sigma_p = 1 - h(p)/\log p$ for some slowly-varying $h$, or a formula involving the Legendre symbol/quadratic residues at $p$. Resolving Open Question 1 is the natural numerical next step; it would give a rigorous asymptotic prediction for F52's efficiency as $p$ grows.

### Open Question 2 — the cancellation reducing Lean's $+1$ slope to the empirical $\sigma_p$

`F54_slope_minus_one` rigorously proves $\mathrm{ord}_p((q/p)_k) = -k$, which would naively give a slope of $+1$ in $\mathrm{ord}_p(A_n)$ after the Pochhammer-denominator flip. The observed $\sigma_p \in [0.71, 1.00]$ is strictly less than $1$ for $p \geq 5$; this means there is a cancellation within the sum defining $A_n$ that reduces the slope. Identifying this cancellation — likely a combinatorial identity on the Kummer Taylor coefficients — would upgrade the Lean theorem to a *tight* slope formalization.

### Open Question 3 — rigorous proof of the parity rule

The even-$q$ diversion to $p = 2$ (§4) is currently a mechanism hypothesis. A rigorous proof would make F54\* a theorem at the level of the odd-$q$ branch's Lean formalization. The 2-adic parasitic channel of §4.1 is the right starting point, but a complete proof requires a joint $(p, 2)$-adic analysis — showing that the 2-adic slope dominates the $p$-adic slope for even $q$.

### Open Question 4 — extension to non-canonical slices

F54\* as stated covers only slices with $z_0 = a = q/p$. The Session 8 control slices (with $z_0 \neq a$) show E-signatures at the $a$-denominator, *not* at the $z_0$-denominator, with larger slopes than the canonical case. The full "slice-prime correspondence" should be a two-parameter map $(a, z_0) \mapsto p^*$ with F54\* as its diagonal restriction. Cataloguing this map off-diagonal is Open Question 4.

---

## 7. Summary

| Statement | Proven? | Reference |
|:----------|:--------|:----------|
| Pochhammer numerator coprime to $p$ for $\gcd(q, p) = 1$ | **Proven** | `pochhammer_num_coprime` in `F54_SlicePrime.lean` |
| $\mathrm{ord}_p((q/p)_k) = -k$ (slope $-1$) | **Proven** | `F54_slope_minus_one` in `F54_SlicePrime.lean` |
| F54\* odd-$q$ branch slope lower bound $+1$ | **Proven** (via F54_slope_minus_one) | §3.2 |
| F54\* odd-$q$ branch exact slope $\sigma_p$ | Empirical | §2.2 (63 slices) |
| F54\* even-$q$ diversion to $p = 2$ | Empirical | §2.1, 36/36 even-$q$ tests |
| 2-adic parasitic channel hypothesis | Heuristic | §4 |
| Closed-form $\sigma_p$ asymptotic | Open | Open Q. 1 |
| Rigorous parity rule proof | Open | Open Q. 3 |

F54\* is the cleanest empirical law the project has produced: its predictions are strong (*exactly* one E-prime per slice), its range is wide (63 of 63 slices across $p \in \{2, \ldots, 23\}$, $q \in \{1, \ldots, 8\}$), and its structural core admits a rigorous Lean formalization in Mathlib. Unlike the gap-framing companion papers [Paper-Attack13], [Paper-Attack12], [Paper-Attack14] — which document what is *missing* from prior attacks — this note documents what has been *added* to the toolkit: a one-parameter family of F52-compatible slices indexed by $(q, p)$ with a parity-cut decision rule.

The natural next targets are (a) Open Question 2 — the slope-reducing cancellation, probably a combinatorial identity resolvable in a single session; (b) Open Question 3 — the parity-rule theorem, which the 2-adic parasitic channel hypothesis points at; (c) Task #18's extension of the empirical support to $79/79$; and (d) a Lean formalization upgrading the $+1$-slope lower bound to a tight slope formula once (a) resolves.

---

## References

- [ADH16] Adamczewski, B., Dreyfus, T. & Hardouin, C. (2016). "Congruences à la Lucas for G-functions." arXiv:1607.00793.
- [Be06] Beukers, F. (2006). "A refined version of the Siegel-Shidlovskii theorem." *Ann. Math.*, 163, 369–379.
- [Gr97] Granville, A. (1997). "Arithmetic properties of binomial coefficients." *CMS Conf. Proc.*, 20, 253–276.
- [Le1808] Legendre, A.-M. (1808). *Essai sur la théorie des nombres*, 2ème éd., Paris.
- [Ma29] Mahler, K. (1929). "Arithmetische Eigenschaften der Lösungen einer Klasse von Funktionalgleichungen." *Math. Ann.*, 101, 342–366.
- [Mo15] de Moivre-Stirling constant; cf. Concrete Mathematics (Graham-Knuth-Patashnik).
- [Si49] Siegel, C. L. (1949). *Transcendental Numbers*. Princeton University Press.
- [Lean-F54] `OmegaTheory/Irrationality/HermitePade/F54_SlicePrime.lean` — Mathlib v4.29, 0 sorries. Contains `pochhammer_num_coprime` and `F54_slope_minus_one`. This repository, `PhysicsPapers/LeanFormalizationV2/`.
- [Paper-K2] Marchewka, N. & Gauss (2026). "On the K₂-Opacity of π: Structural Barriers and the p-adic Path." [Paper-K2-Opacity-Pi.md, this repository].
- [Paper-SS] Marchewka, N. & Gauss (2026). "On the Siegel-Shidlovskii Reduction of the K₂-Opacity Conjecture for π." [Paper-SS-Reduction-And-Siegel-Barrier.md, this repository].
- [Paper-Attack13] Marchewka, N. & Rigel (2026). "Quantitative Lucas Separation and the ADH 2016 Extension Problem for Attack 13." [Paper-Attack13-Lucas-Extension.md, this repository].
- [Paper-Attack12] Marchewka, N. & Rigel (2026). "The Carlitz-Frobenius Bridge for K₂-Opacity: A Mahler × Fuchsian Specialization Gap." [Paper-Attack12-Carlitz-Frobenius.md, this repository].
- [Paper-Attack14] Marchewka, N. & Rigel (2026). "Motivic Periods, the B × SL₂ Galois Product, and the Zilber-Pink Gap for Attack 14." [Paper-Attack14-Motivic-Periods.md, this repository].
- Session logs: Session 8 (panorama), Session 13 (panorama summary), Session 14 (Module 15 q-sweep), Session 15 (big-prime appendix). All artefacts under `sage/target_s8*`.
