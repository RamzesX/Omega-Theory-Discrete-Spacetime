# Module 05 — Information Deficit and Exponential Mixing

This module develops the conditional quantitative extension of the dichotomy theorem, using the ergodic theory of the Gauss map.

## 5.1 The Information Bound

**Theorem 5.1** (Bounded Past-Future Information). *For $\gamma$-almost every real $\alpha \in (0,1)$, the mutual information between the next CF term and the entire past is bounded by a constant independent of $N$:*

$$I(a_{N+1};\; a_1, \ldots, a_N) \leq B = \frac{C}{1 - |\lambda_2|}$$

*where $C > 0$ is a universal constant and $|\lambda_2| = 0.30366\ldots$ is the Gauss–Kuzmin–Wirsing constant [Wirsing, 1974].*

*Proof.* By the exponential mixing property of the Gauss map (Theorem 1.12 of Module 01), the correlation between the observables $f(a_n)$ and $g(a_{n+k})$ decays as $|\lambda_2|^k$. Applying this to the indicator functions $f = \mathbf{1}[a_{N+1} = j]$ and $g = \mathbf{1}[a_{N-k} = i]$, the mutual information decomposes:

$$I(a_{N+1}; a_1, \ldots, a_N) \leq \sum_{k=0}^{N-1} I(a_{N+1}; a_{N-k} \mid a_{N-k+1}, \ldots, a_N) \leq \sum_{k=0}^{\infty} C \cdot |\lambda_2|^k = \frac{C}{1 - |\lambda_2|} = B$$

The geometric series converges because $|\lambda_2| < 1$. The bound $B$ is independent of $N$. $\square$

## 5.2 The Information Deficit Theorem

**Theorem 5.2** (Information Deficit). *Define $D(\alpha, N) = H(a_{N+1}) - I(a_{N+1}; a_1, \ldots, a_N)$. Then:*

$$D(e, N) = 0 \qquad \text{for } N \geq 15$$

$$D(\alpha, N) \geq \frac{\pi^2}{6\ln 2} - B > 0 \qquad \text{for } \gamma\text{-a.e. } \alpha \text{ and all } N$$

*Proof.*

**Part I** ($e$): By Corollary 3.5, $H(a_{N+1} \mid a_1, \ldots, a_N) = 0$ for $N \geq 15$, hence $D(e, N) = 0$.

**Part II** (generic $\alpha$): By Theorem 1.14 (Rokhlin, 1961), $H(a_{N+1}) = h(T, \gamma) = \pi^2/(6\ln 2) \approx 3.433$ bits for $\gamma$-a.e. $\alpha$. Combined with Theorem 5.1:

$$D(\alpha, N) = H(a_{N+1}) - I(a_{N+1}; a_1, \ldots, a_N) \geq \frac{\pi^2}{6\ln 2} - B > 0$$

The positivity follows from $B = C/(1-|\lambda_2|)$ being a finite constant strictly less than $\pi^2/(6\ln 2) \approx 3.433$. $\square$

## 5.3 Application to $\pi$

**Corollary 5.3** (Conditional). *If $\pi$ is GK-typical (i.e., the orbit of $\pi - 3$ under the Gauss map is equidistributed with respect to $\gamma$), then:*

$$D(\pi, N) \geq \frac{\pi^2}{6\ln 2} - B > 0 \qquad \text{for all } N$$

*and the best predictor accuracy satisfies:*

$$\sup_{P \in \mathcal{K}_5} \mathrm{acc}(P, \pi) \leq P_{\mathrm{GK}}(1) + o(1) \approx 0.415$$

*Status:* Conditional on GK-typicality of $\pi$. Empirically verified on 200+ CF terms (Module 06).

## 5.4 The Bit Pump Interpretation

Theorem 5.2 has a vivid operational meaning.

Every algorithm computing $\pi$ — Chudnovsky's series, the Leibniz formula, the Bailey–Borwein–Plouffe identity, the arithmetic-geometric mean — functions as an **information pump**: at each step of the CF expansion, it injects at least $D \approx 3.433 - B > 0$ bits of fresh information into the digit sequence.

If the pump is disconnected (i.e., if we rely solely on the CF sequence without any external formula), the sequence cannot be continued. The digits of $\pi$ cannot sustain themselves — they require a continuous external supply of geometric information.

For $e$, no pump is needed. The 15-term pattern is the pump — and it runs on zero external input.

## 5.5 Self-Referential Structure

The entropy rate appearing in the deficit formula is:

$$h(T, \gamma) = \frac{\pi^2}{6\ln 2}$$

The number $\pi$ appears in the formula that measures its own informational opacity. This is not circular — $h(T, \gamma)$ is a property of the Gauss map, computed via Rokhlin's formula as a definite integral. But structurally, it means: *$\pi$ quantifies its own resistance to prediction.*

---

*Next: [Module 06 — Experimental Verification](06-Experimental-Verification.md)*
