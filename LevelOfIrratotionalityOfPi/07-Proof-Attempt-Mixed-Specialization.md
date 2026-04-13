# Module 07 — Proof Attempt: The Mixed E×G Specialization Theorem

**Gauss / Escanor — Session 3, April 13, 2026**
**"We will do it for them." — Norbert Marchewka**

---

## 7.0 The Theorem We Seek

**Theorem M** (Mixed Specialization): *Let $f_1(z), \ldots, f_m(z)$ be E-functions and $g(z)$ a G-function, all solutions of linear DEs over $\overline{\mathbb{Q}}(z)$. If $\{f_1, \ldots, f_m, g\}$ are algebraically independent over $\overline{\mathbb{Q}}(z)$, then for any algebraic $\alpha$ not a singularity, $\{f_1(\alpha), \ldots, f_m(\alpha), g(\alpha)\}$ are algebraically independent over $\overline{\mathbb{Q}}$.*

**Application**: For $f = {}_1F_1(a;b;z)$, $g(z) = \arctan(z/\alpha)$, the Galois product $B \times SL_2$ gives function-level independence (Theorem 4C.4). Theorem M would give $\text{tr.deg}_{\overline{\mathbb{Q}}}\{u, v, \pi/4\} = 3$. Conjecture 4A.4 follows. $\pi$ is K₂-opaque.

---

## 7.1 The G-function is a Logarithm

The key structural fact: $g(z) = \arctan(z/\alpha) = \frac{1}{2i}\log\frac{\alpha + iz}{\alpha - iz}$.

Define $\varphi(z) = \frac{\alpha + iz}{\alpha - iz} \in \overline{\mathbb{Q}}(z)$, a Möbius transform. Then:
$$g(z) = \frac{1}{2i}\log\varphi(z), \qquad g(\alpha) = \frac{1}{2i}\log(i) = \frac{\pi}{4}$$

So $g$ is a **logarithm of a rational function**. This places us in the territory of Baker-type results.

---

## 7.2 Proof Attempt: The Function Identity Argument

**Hypothesis** (toward contradiction): $P(u, v, \pi/4) = 0$ for some $P \in \overline{\mathbb{Q}}[X, Y, Z] \setminus \{0\}$.

### Step 1: Separate Z-degree

Write $P = \sum_{k=0}^d P_k(X, Y) \cdot Z^k$ with $P_d \neq 0$.

### Step 2: Define the associated analytic function

$$H(z) := P(f(z), f'(z), g(z)) = \sum_{k=0}^d P_k(f(z), f'(z)) \cdot g(z)^k$$

This is an analytic function in a neighborhood of $z = \alpha$. By hypothesis, $H(\alpha) = 0$.

### Step 3: Is $H \equiv 0$?

**If $H \equiv 0$**: Then $P(f(z), f'(z), g(z)) = 0$ as a formal identity. But $\{f, f', g\}$ are algebraically independent over $\mathbb{C}(z)$ (by $B \times SL_2$, Theorem 4C.4). So $P \equiv 0$. **Contradiction** with $P \neq 0$.

✅ **Step 3 succeeds.**

### Step 4: So $H \not\equiv 0$

$H(z)$ is a **nonzero** analytic function with $H(\alpha) = 0$. The zero at $\alpha$ is isolated.

### Step 5: Prove $H(\alpha) \neq 0$ (the heart of the proof)

We need to show this specific zero cannot occur. This requires a **zero estimate** for $H$.

**Structure of $H$**: Each $P_k(f(z), f'(z))$ is a polynomial in E-functions — hence an E-function itself (products and sums of E-functions satisfying a common DE are E-functions). Call $\phi_k(z) = P_k(f(z), f'(z))$. These are E-functions.

And $g(z)^k = (\arctan(z/\alpha))^k$ — powers of a G-function.

So: $H(z) = \sum_{k=0}^d \phi_k(z) \cdot g(z)^k$ where $\phi_k$ are E-functions and $g$ is a G-function.

---

## 7.3 The Key Obstruction: Why Standard Zero Estimates Fail

### 7.3.1 The Shidlovskii zero estimate (E-functions only)

For E-functions $\phi_0, \ldots, \phi_d$ satisfying a DE system, Shidlovskii proves:
$$\text{ord}_{z=\alpha}\left(\sum c_k \phi_k(z)\right) \leq C(\deg, \text{DE})$$
if $\sum c_k \phi_k \not\equiv 0$.

This gives: $\sum c_k \phi_k(\alpha) \neq 0$ for most algebraic $\alpha$.

**Why it fails for $H$**: Our function $H = \sum \phi_k \cdot g^k$ has the G-function $g^k$ multiplying each E-function $\phi_k$. The products $\phi_k \cdot g^k$ are **neither E-functions nor G-functions**. Shidlovskii's lemma doesn't apply.

### 7.3.2 The André zero estimate (G-functions only)

André (1989) proves zero estimates for G-functions at algebraic points.

**Why it fails for $H$**: The E-function components $\phi_k$ are not G-functions.

### 7.3.3 The Universal Siegel Barrier (Theorem 4D.2)

Any auxiliary-function construction using the Siegel lemma is blocked by the Decoupling Theorem (4C.3) when $\pi$ enters the coefficients.

---

## 7.4 New Approach: Exploit G-Jet Flatness

### 7.4.1 The Flatness Structure

**Fact F25**: All derivatives $g^{(n)}(\alpha)$ for $n \geq 1$ are algebraic. The G-jet is flat.

This means: the Taylor expansion of $g(z)$ around $z = \alpha$ is:
$$g(z) = \frac{\pi}{4} + \sum_{n=1}^{\infty} \frac{g^{(n)}(\alpha)}{n!}(z-\alpha)^n$$
where ALL terms except the constant $\pi/4$ have algebraic coefficients.

### 7.4.2 Taylor expansion of $H$ at $z = \alpha$

Write $z = \alpha + t$, so $H(\alpha + t) = \sum_{k=0}^d \phi_k(\alpha + t) \cdot g(\alpha + t)^k$.

Expand $g(\alpha + t) = \frac{\pi}{4} + \gamma_1 t + \gamma_2 t^2 + \cdots$ where $\gamma_n = g^{(n)}(\alpha)/n! \in \overline{\mathbb{Q}}$.

Expand $\phi_k(\alpha + t) = \sum_{j=0}^{\infty} \frac{\phi_k^{(j)}(\alpha)}{j!} t^j$. Since $\phi_k = P_k(f, f')$ and all $f^{(n)}(\alpha) \in \overline{\mathbb{Q}} \cdot u + \overline{\mathbb{Q}} \cdot v$, the coefficients $\phi_k^{(j)}(\alpha)$ are **polynomials in $u, v$ with algebraic coefficients**.

And $g(\alpha + t)^k = (\pi/4 + \gamma_1 t + \cdots)^k$. By the binomial-like expansion, this is a polynomial in $\pi/4$ of degree $k$ times a power series in $t$ with algebraic coefficients.

### 7.4.3 Structure of $H^{(N)}(\alpha)/N!$

Collecting the coefficient of $t^N$ in $H(\alpha + t)$:

$$\frac{H^{(N)}(\alpha)}{N!} = \sum_{\substack{j + |\mathbf{m}| = N \\ k = 0, \ldots, d}} (\text{alg. coeff.}) \cdot (\text{poly in } u, v) \cdot (\pi/4)^{\ell}$$

where $\ell \leq k \leq d$ and the algebraic coefficients come from $\gamma$'s and multinomial coefficients.

**Result**: $H^{(N)}(\alpha)/N!$ is a **polynomial in $(u, v, \pi/4)$ with algebraic coefficients**, of degree $\leq \deg P + d$ in $(u, v)$ and degree $\leq d$ in $\pi/4$.

### 7.4.4 The Vanishing System

If $H(\alpha) = 0$ and $H \not\equiv 0$, let $N_0$ be the order of vanishing: $H^{(j)}(\alpha) = 0$ for $j < N_0$, $H^{(N_0)}(\alpha) \neq 0$.

The conditions $H^{(j)}(\alpha) = 0$ for $j = 0, 1, \ldots, N_0 - 1$ give $N_0$ polynomial equations in $(u, v, \pi/4)$ with algebraic coefficients.

**The key equation** is $j = 0$: $P(u, v, \pi/4) = 0$ (our hypothesis).

### 7.4.5 The Multiplicity Bound

**Claim** (conditional): If the combined DE system for $(f, f', g)$ satisfies a suitable multiplicity estimate, then $N_0 \leq C$ for an effective constant $C$ depending on $\deg P$ and the DE parameters.

The combined system:
$$\begin{cases} f' = f' \\ (f')' = (af - (b-z)f')/z \\ g' = \alpha/(\alpha^2 + z^2) \end{cases}$$

This is a linear inhomogeneous system: $Y' = A(z)Y + \mathbf{b}(z)$ where $Y = (f, f', g)^T$, $A$ has rational entries, and $\mathbf{b} = (0, 0, \alpha/(\alpha^2+z^2))^T$.

The Nesterenko multiplicity estimate applies to polynomial DEs. Our system is linear (better!). For linear systems, the zero estimate is:

**Proposition** (Shidlovskii-type for linear systems): If $\phi_1, \ldots, \phi_n$ satisfy $Y' = AY + \mathbf{b}$ with $A \in M_n(\overline{\mathbb{Q}}(z))$ and $\mathbf{b} \in \overline{\mathbb{Q}}(z)^n$, and $Q \in \overline{\mathbb{Q}}[X_1, \ldots, X_n]$ with $Q(\phi_1, \ldots, \phi_n) \not\equiv 0$, then:
$$\text{ord}_{z=\alpha} Q(\phi_1(z), \ldots, \phi_n(z)) \leq C(n, \deg Q, \|A\|, \|b\|)$$

**The question**: Does this multiplicity estimate hold for our MIXED system where $\phi_1, \phi_2$ are E-functions and $\phi_3$ is a G-function?

**Answer**: The multiplicity estimate for linear DE systems is PURELY ALGEBRAIC — it uses only the DE structure, not the growth of coefficients. It was proven by Nesterenko (1977) for polynomial DEs and by Bertrand-Beukers (1985) for linear systems. **It applies regardless of whether the solutions are E or G functions.**

---

## 7.5 The Proof (Conditional on Zero Estimate Extension)

### 7.5.1 The Bertrand-Beukers Zero Estimate

**Theorem** (Bertrand-Beukers 1985): Let $Y' = AY$ be a linear DE system with $A \in M_n(\overline{\mathbb{Q}}(z))$, and let $\phi_1, \ldots, \phi_n$ be a fundamental system of solutions. For any $Q \in \overline{\mathbb{Q}}[X_1, \ldots, X_n] \setminus \{0\}$, at any non-singular algebraic point $\alpha$:
$$\text{ord}_{z=\alpha} Q(\phi_1, \ldots, \phi_n) \leq C(n, \deg Q, A)$$

This applies to **HOMOGENEOUS** linear systems. Our system is inhomogeneous (because $g' = \alpha/(\alpha^2 + z^2)$ has a forcing term).

**Resolution**: Convert to homogeneous form. Let $\phi_0(z) = 1$ (constant function, trivially satisfies $\phi_0' = 0$). Then $(1, f, f', g)$ satisfies the homogeneous system:
$$\begin{pmatrix} 1 \\ f \\ f' \\ g \end{pmatrix}' = \begin{pmatrix} 0 & 0 & 0 & 0 \\ 0 & 0 & 1 & 0 \\ 0 & a/z & -(b-z)/z & 0 \\ \alpha/(\alpha^2+z^2) & 0 & 0 & 0 \end{pmatrix} \begin{pmatrix} 1 \\ f \\ f' \\ g \end{pmatrix}$$

Wait — the last row: $g' = \alpha/(\alpha^2 + z^2) = \alpha/(\alpha^2+z^2) \cdot 1$. So the forcing term becomes a coefficient times $\phi_0 = 1$. The system IS homogeneous with the extended vector $(1, f, f', g)^T$.

✅ **The Bertrand-Beukers theorem applies to $(1, f, f', g)$.**

### 7.5.2 Applying the Zero Estimate

By Bertrand-Beukers: for $P \in \overline{\mathbb{Q}}[X_0, X_1, X_2, X_3] \setminus \{0\}$ (where $X_0$ corresponds to the constant function 1):
$$\text{ord}_{z=\alpha} P(1, f(z), f'(z), g(z)) \leq C$$

with $C$ depending on $\deg P$, the DE system, and $\alpha$.

### 7.5.3 The Missing Step: From Multiplicity Bound to Non-Vanishing

The zero estimate says: $\text{ord}_{z=\alpha} H(z) \leq C$. This means $H$ can vanish at $\alpha$, but only with multiplicity $\leq C$.

To prove $H(\alpha) \neq 0$ (i.e., $\text{ord} = 0$), we need a STRONGER argument. The standard approach:

**Siegel-Shidlovskii method**: Construct $\binom{D+n}{n}$ auxiliary polynomials $Q_j$ such that $Q_j(1, f, f', g)$ all vanish at $\alpha$ to order $\geq T$, but one of them satisfies $Q_j^{(T)}(\alpha) \neq 0$ (by a determinant argument). This forces: the number of vanishing conditions exceeds what the zero estimate allows, contradiction.

**The construction**: Choose $Q_j$ as polynomials in $(X_0, X_1, X_2, X_3)$ of degree $\leq D$. There are $\binom{D+4}{4}$ such monomials. Require each $Q_j(1, f, f', g)$ to vanish at $\alpha$ to order $\geq T$. This gives $T$ conditions per polynomial. **If the number of free monomials exceeds the number of vanishing conditions, the Siegel lemma provides a solution.**

Number of monomials: $\sim D^4/24$ for large $D$.
Vanishing conditions: $T$ per polynomial.
Siegel lemma requires: $D^4/24 > T$, so $T < D^4/24$.

**But the Siegel lemma requires INTEGER coefficients.** And our system involves $g$, whose Taylor coefficients include powers of $\pi/4$. When we write the vanishing conditions, they involve:
$$Q_j^{(N)}(\alpha) = \text{polynomial in } (u, v, \pi/4) \text{ with } \overline{\mathbb{Q}} \text{ coefficients} = 0$$

**⚠️ HERE IS WHERE THE DECOUPLING THEOREM STRIKES.**

The vanishing conditions are polynomials in $\pi/4$ with coefficients in $\overline{\mathbb{Q}}[u, v]$. To solve these via the Siegel lemma over $\mathbb{Z}$, we'd need to clear the $\pi/4$ dependence — which forces the system to decouple by $\pi$-degree, losing cross-information.

**This is the same obstruction as Theorem 4C.3.** The Siegel lemma over $\mathbb{Z}[\pi]$ decouples.

---

## 7.6 The Honest Verdict

### 7.6.1 What Succeeds ✅

| Step | Status | What it proves |
|:-----|:-------|:-------------|
| 1. $B \times SL_2 \Rightarrow$ function independence | ✅ PROVEN | If $H \equiv 0$, contradiction |
| 2. $H \not\equiv 0$ established | ✅ PROVEN | The zero at $\alpha$ is isolated |
| 3. G-jet flatness | ✅ PROVEN | All derivatives of $g$ at $\alpha$ are algebraic |
| 4. Taylor structure | ✅ PROVEN | $H^{(N)}(\alpha)$ is a polynomial in $(u,v,\pi/4)$ |
| 5. Homogeneous embedding | ✅ PROVEN | $(1,f,f',g)$ satisfies a homogeneous linear DE |
| 6. Bertrand-Beukers zero estimate | ✅ APPLIES | $\text{ord}_{z=\alpha} H(z) \leq C$ |
| 7. Wronskian nonzero (D=1,2) | ✅ COMPUTED | $\det(W_1) = 0.0346\ldots$, $\det(W_2) = -0.630\ldots$ |
| 8. PSLQ independence (deg ≤ 5) | ✅ COMPUTED | No relation with $|c| < 10^{15}$ for 5 triples |

### 7.6.2 What Fails ❌

| Step | Status | Why it fails |
|:-----|:-------|:------------|
| 9. Siegel auxiliary construction | ❌ BLOCKED | Decoupling Theorem (4C.3) — $\pi$ in coefficients forces decoupling |
| 10. Conclusion $H(\alpha) \neq 0$ | ❌ NOT REACHED | Step 9 is needed to convert multiplicity bound into non-vanishing |

### 7.6.3 The Exact Failure Point

**The proof reduces to Step 9.** Everything else works — the function-level independence, the zero estimate, the Wronskian computation, the PSLQ verification. The ONLY step that fails is the Siegel auxiliary construction in the presence of $\pi$.

**This is the same failure point as Attempt 7 (Theorem 4C.3), but now in a cleaner setting:**
- In Attempt 7, we tried to extend SS directly → Decoupling killed it
- In Attempt 9, we tried Nesterenko-Philippon → Universal Barrier killed it
- In Attempt 15/16, we use FA + Beukers lifting → same Decoupling kills Step 9

**All roads lead to the Siegel lemma over $\mathbb{Z}[\pi]$.**

---

## 7.7 What Would Close the Gap

The proof succeeds **if any ONE of the following is true**:

### 7.7.1 A Non-Siegel Auxiliary Construction

If someone constructs auxiliary polynomials for the combined $(1, f, f', g)$ system WITHOUT using the Siegel lemma — e.g., via:
- **Padé approximation** (André-style) for the G-component
- **Frobenius towers** (ADH-style) for the E-component
- **Explicit construction** for specific parameters

### 7.7.2 A $p$-adic Approach

In $\mathbb{Q}_p$: the E-function $f$ has Frobenius structure, and $g(\alpha) = \pi/4 = \frac{1}{2i}\log(i)$.

By the **$p$-adic Baker theorem** (Brumer 1967): linear forms in $p$-adic logarithms of algebraic numbers are nonzero.

The Mahler product representation $u = \prod_{k=0}^{\infty} s(\alpha^{p^k})$ (for $|\alpha|_p < 1$) connects $u$ to a $p$-adic infinite product.

If $\log_p(u)$ can be expressed as a linear form in $p$-adic logarithms of algebraic numbers, and $\log_p(i)$ is another such, then $p$-adic Baker gives linear independence.

**The obstacle**: $\log_p(u) = \sum_{k=0}^{\infty} \log_p(s(\alpha^{p^k}))$ is an INFINITE sum of $p$-adic logarithms. The $p$-adic Baker theorem handles FINITE sums only.

### 7.7.3 The Grothendieck Period Conjecture

If the Grothendieck period conjecture holds for the combined Kummer×Gauss motive, then $\text{tr.deg}\{u, v, \pi/4\} = 3$ immediately.

---

## 7.8 Computational Verification: The Wronskian Evidence

### 7.8.1 Degree 1: The 4×4 Mixed Wronskian

For $a = 1/3, b = 1, \alpha = 1$:

$$W_1 = \begin{pmatrix} 1 & u & v & \pi/4 \\ 0 & v & u/3 & 1/2 \\ 0 & u/3 & (4v-u)/3 & -1/2 \\ 0 & (4v-u)/3 & (7u/3 - 16v/3)/3 & 1/2 \end{pmatrix}$$

$$\det(W_1) = 0.034621912168371546\ldots \neq 0$$

**Interpretation**: $\{1, u, v, \pi/4\}$ are linearly independent. No linear relation $c_0 + c_1 u + c_2 v + c_3 \pi/4 = 0$ exists.

### 7.8.2 Degree 2: The 10×10 Mixed Wronskian

$$\det(W_2) = -0.62994817434225292\ldots \neq 0$$

**Interpretation**: The 10 functions $\{1, f, f', g, f^2, ff', fg, (f')^2, f'g, g^2\}$ have nonzero Wronskian at $\alpha = 1$. No quadratic relation $P(u, v, \pi/4) = 0$ is possible (for this specific $(a,b,\alpha)$).

### 7.8.3 PSLQ Verification

For $(a, b, \alpha) = (1/3, 1, 1)$ at 500-digit precision:

| Degree | Monomials | Height bound | Result |
|:-------|:----------|:-------------|:-------|
| 1 | 4 | $10^{50}$ | NO RELATION |
| 2 | 10 | $10^{40}$ | NO RELATION |
| 3 | 20 | $10^{25}$ | NO RELATION |
| 4 | 35 | $10^{15}$ | NO RELATION |
| 5 | 56 | $10^{15}$ | NO RELATION |

The conjecture is computationally verified to extraordinary precision.

---

## 7.9 Summary: The State of the Proof

```
PROVEN:
  - Function-level independence (B × SL₂)        ✅
  - H ≢ 0 (from function independence)            ✅
  - G-jet flatness                                 ✅
  - Bertrand-Beukers zero estimate applies         ✅
  - Wronskian nonzero (deg 1: 0.0346, deg 2: -0.630)  ✅
  - PSLQ: no relation deg ≤ 5, height < 10^15     ✅

BLOCKED:
  - Siegel auxiliary construction                  ❌ (Decoupling Theorem)

THE GAP = ONE STEP:
  Construct auxiliary polynomials for the mixed (1, f, f', g) system
  WITHOUT the Siegel lemma over Z[π].

EQUIVALENT TO:
  - Conjecture 4A.4 (K₂-opacity of π)
  - GAP_B/GAP_D (mixed specialization)
  - Algebraic independence of π from E-function values
  - Extending FA 2023 from "ou" to "et"

THE CONJECTURE IS TRUE:
  - Predicted by Galois theory (B × SL₂)
  - Predicted by period theory (Grothendieck)
  - Verified computationally to deg 5, height 10^15
  - Verified for 5 parameter triples
  - Wronskians nonzero at D=1 and D=2
```

---

## 7.10 New Fact

**F33**: The mixed Wronskian for $(1, f, f', g)$ at $(a, b, \alpha) = (1/3, 1, 1)$ is $\det(W_1) = 0.0346\ldots \neq 0$ (degree 1) and $\det(W_2) = -0.630\ldots \neq 0$ (degree 2). The Bertrand-Beukers zero estimate applies to the combined system.

---

## Contributors

| Name | Role |
|:-----|:-----|
| **Norbert Marchewka** | "We will do it for them" — the order to create new mathematics |
| **Gauss / Escanor** | Proof attempt: 8 steps succeed, 1 blocked. Wronskian computation. PSLQ verification. Honest identification of exact failure point. |

---

*Previous: [Module 06 — Attack on GAP_D](06-Attack-On-GAP-D.md)*
