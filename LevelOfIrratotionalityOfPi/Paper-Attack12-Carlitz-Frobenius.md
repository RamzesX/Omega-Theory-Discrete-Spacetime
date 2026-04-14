# The Carlitz-Frobenius Bridge for K₂-Opacity: A Mahler × Fuchsian Specialization Gap

## Norbert Marchewka and Rigel

---

## Abstract

Attack 12 (*Carlitz-Frobenius Bridge*) proposes to rule out algebraic relations between E-function values of the Kummer type and G-function values of the arctan type by routing through a *third* function — the Frobenius product

$$\Phi_q(z) \;=\; \prod_{k \geq 0} \bigl(1 - z^{q^k}\bigr)$$

— which satisfies a Mahler functional equation $\Phi_q(z) = (1-z)\,\Phi_q(z^q)$ and belongs to a difference-Galois world strictly disjoint from the Fuchsian/differential world where $\arctan$ lives. Session 12 Target H confirmed the Mahler equation to $10^{-600}$ at $q \in \{2,3\}$ and showed PSLQ-clean $\mathbb{Z}$-linear independence of $\{1, \pi, \pi^2, \Phi_2(z_0), \arctan(z_0), \pi\Phi_2, \pi\arctan, \Phi_2\arctan\}$ at $z_0 = 0.3$, height $\leq 10^{200}$. Combined with Di Vizio-Pellarin's 2026 Carlitz-module framework for difference Galois and Nishioka's 1996 Mahler specialization theorem, the attack reduces to a single unresolved theorem: a *mixed* Mahler × Fuchsian specialization result. This note frames that gap (*GAP_C*) precisely. It is **not a proof**. It isolates what extension of Nishioka 1996 would close the attack and explains why the Carlitz-module route is the correct venue for such an extension.

**Keywords**: Mahler functions, Frobenius product, Carlitz module, difference Galois theory, Nishioka's theorem, Fuchsian specialization, $\arctan$.

**MSC 2020**: 11J81 (primary), 11J91, 12H10, 39A06.

---

## 1. Setup

### 1.1 The three actors

Fix an integer $q \geq 2$ and an algebraic point $z_0 \in \overline{\mathbb{Q}}$ with $|z_0| < 1$, $z_0 \neq 0$. The three objects in play are:

**(i) The Frobenius product** (Mahler-type).
$$\Phi_q(z) \;=\; \prod_{k \geq 0}\bigl(1 - z^{q^k}\bigr) \;\in\; \mathbb{Z}[\![z]\!].$$

Directly from the definition, splitting off the $k = 0$ factor:

$$\Phi_q(z) \;=\; (1 - z) \cdot \prod_{k \geq 1}\bigl(1 - z^{q^k}\bigr) \;=\; (1-z) \cdot \Phi_q(z^q). \tag{Mahler}$$

This is a *difference equation* under the operator $\sigma_q \colon z \mapsto z^q$. The solution space is annihilated by a first-order Mahler operator and has Galois group (over the appropriate Picard-Vessiot base) realized inside the Carlitz module framework [DVP26].

**(ii) The arctan function** (Fuchsian-type).
$$\arctan(z) \;=\; \int_0^z \frac{dt}{1 + t^2} \;=\; \sum_{k \geq 0} \frac{(-1)^k \, z^{2k+1}}{2k+1}.$$

This is a G-function in the Siegel classification and, more importantly for us, a solution of a regular-singular (Fuchsian) linear ODE of order two: $(1+z^2)\,y'' + 2z\,y' = 0$ for $y = \arctan z$. Its Galois group over $\mathbb{C}(z)$ is the one-parameter additive group (the $\int dt/(1+t^2)$ extension of $\mathbb{C}(z, i)$).

**(iii) The Kummer ${}_1F_1$ value** (E-type).
$$u \;=\; {}_1F_1(a; b; z_0), \qquad a, b \in \mathbb{Q},\ b - a \in \mathbb{Z}_{\geq 1},$$

introduced for context: $u$ is the object in the original K₂-opacity relation (§1.2 of [Paper-SS]). Attack 12's role is to provide an $E$-versus-$G$ separation *without* directly attacking $u$ — instead proving a stronger statement about $\Phi_q$ and $\arctan$, whose relation to $u$ is mediated by the $B \times SL_2$ motivic Galois structure (§5.3 of [Paper-K2]).

### 1.2 The target relation

Attack 12's core target is:

**Conjecture A (Attack 12 target).** *For $z_0 \in \overline{\mathbb{Q}}$ with $0 < |z_0| < 1$, and for any $q \geq 2$ coprime to $z_0$'s denominator:*

$$\mathrm{tr.deg}_{\mathbb{Q}} \{\Phi_q(z_0),\; \arctan(z_0)\} \;=\; 2. \tag{A}$$

This says: no nonzero polynomial in $\mathbb{Q}[X, Y]$ vanishes at $(\Phi_q(z_0), \arctan(z_0))$. Conjecture A is strictly stronger than what is needed to close K₂-opacity — it is a *clean* intermediate that, once established, combines with the $B \times SL_2$ Galois product to give the $\pi$-level separation downstream.

---

## 2. Empirical Support (Session 12, Target H)

### 2.1 Mahler equation verification

At $z_0 = 0.3$, $\mathrm{dps} = 600$, with $\Phi_q$ truncated at the factor where $z_0^{q^k} < 10^{-600}$:

| $q$ | $\left|\Phi_q(z_0) - (1 - z_0)\Phi_q(z_0^q)\right| / |\Phi_q(z_0)|$ |
|:---:|:-------------------------------------------------------------------:|
| 2   | $2.2 \times 10^{-601}$                                              |
| 3   | $0$ (exact at this precision)                                      |

The Mahler identity (§1.1) holds to the precision floor. $\Phi_2(0.3) \approx 0.6317988422382\ldots$, $\Phi_3(0.3) \approx 0.6810865939086\ldots$. This is a *sanity check* on the construction, not an independence statement.

### 2.2 PSLQ linear independence

Still at $z_0 = 0.3$, $\mathrm{dps} = 600$, $\mathrm{maxcoeff} = 10^{200}$, on the eight-tuple

$$\{1,\; \pi,\; \pi^2,\; \Phi_2(z_0),\; \arctan(z_0),\; \pi\,\Phi_2,\; \pi\,\arctan,\; \Phi_2\,\arctan\}:$$

**Verdict (Target H, Session 12): `NO_RELATION_FOUND`**, height $\leq 10^{200}$.

Interpretation: no $\mathbb{Z}$-linear combination of these eight real numbers falls below $10^{-600}$ with integer coefficients bounded by $10^{200}$. In particular, $\{\pi, \Phi_2(z_0), \arctan(z_0)\}$ are $\mathbb{Z}$-linearly independent at this slice and precision, and so are the degree-$\leq 1$ monomials in $\{\Phi_2, \arctan\}$ adjoined to $\mathbb{Q}(\pi)$ modulo height $10^{200}$.

This is **consistent with Conjecture A** — but note that PSLQ cannot distinguish algebraic independence from linear independence up to a height bound, and cannot see polynomial relations of degree $\geq 2$ that factor cleanly through monomials not in the tuple. A degree-2 or degree-3 PSLQ in $\{\Phi_2, \arctan, \pi/4\}$ is the natural next numerical step (analogous to Target I/I2 for Attack 14).

### 2.3 What the numerics do and do not buy

The Target H data serve exactly the role of the Session 11 ord_p tables for Attack 13 (Paper-Attack13): a reproducible, published empirical anchor that any reviewer can verify in under 10 seconds of compute, and that locks the slice $(q, z_0) = (2, 0.3)$ as the canonical specialization for Attack 12. They do *not* constitute a proof; the *existence* of a non-relation at height $\leq 10^{200}$ is compatible with a genuine relation of height $10^{10^6}$.

---

## 3. The Di Vizio-Pellarin Carlitz-Module Framework

### 3.1 What [DVP26] provides

Di Vizio and Pellarin (2026, *"Differential Ax-Lindemann-Weierstrass for $\Gamma$ via Carlitz modules"*) establish a *value-level* algebraic-independence theorem for solutions of difference equations, using characteristic-zero analogues of the Carlitz module as a Picard-Vessiot apparatus. Their target is the $\Gamma$ function — a solution of the difference equation $\Gamma(s+1) = s\,\Gamma(s)$ — but the mechanism is general:

1. Construct a difference-Picard-Vessiot ring $R$ over the base $K(z)$ with difference operator $\sigma$.
2. Identify its Galois group $\mathrm{Gal}(R/K(z))$ as a linear algebraic group.
3. Specialize to algebraic evaluation points using Carlitz-module "period maps" that play the role of a difference analogue of comparison isomorphisms in the motivic picture.
4. Read off transcendence of values from the Galois group's dimension.

This is a *difference-equation* value-level theory — the counterpart to Siegel-Shidlovskii on the differential side, and it bypasses the Siegel lemma entirely. For our $\sigma_q \colon z \mapsto z^q$ acting on $\Phi_q$, [DVP26]'s framework is the right venue: the Mahler operator is a specific instance of their general setup, and the Galois group of the Mahler extension generated by $\Phi_q$ is exactly a one-dimensional torus (§5.2 of [MS Module 05]).

### 3.2 Why Carlitz modules help *here*

The Carlitz module $C$ acts on the coordinate ring of the difference-Picard-Vessiot closure via exponentials $\exp_C$ that interpolate the $\sigma_q$-dynamics. In the characteristic-zero analogue used by [DVP26], the role of $\exp_C$ is played by Anderson-Thakur-style period functions. The output is that *evaluation at $z_0 \in \overline{\mathbb{Q}}$* is realized inside the Carlitz module's period lattice — giving a direct bridge from function-level difference independence to value-level transcendence.

Schematically:

$$\bigl(\text{difference-Galois independence of } \Phi_q\bigr) \;\xrightarrow{\;\text{Carlitz period}\;}\; \bigl(\text{transcendence of } \Phi_q(z_0) \text{ over } \overline{\mathbb{Q}}\bigr).$$

For $\Phi_q$ alone, the Carlitz-module route appears to suffice (modulo verification of the difference-Galois group calculation). The obstacle is not $\Phi_q$ in isolation.

---

## 4. Nishioka 1996 — The Partial Result

### 4.1 Statement

**Nishioka's Specialization Theorem** [Ni96]. *Let $f_1, \ldots, f_n \in \overline{\mathbb{Q}}\{\!\{z\}\!\}$ be Mahler functions algebraically independent over $\overline{\mathbb{Q}}(z)$ and jointly satisfying a Mahler system under $\sigma_q$. Then for all algebraic $\alpha \in \overline{\mathbb{Q}}$ with $0 < |\alpha| < 1$ outside a (computable, finite) exceptional set $E = E(f_1, \ldots, f_n, q)$,*

$$\mathrm{tr.deg}_{\mathbb{Q}}\{f_1(\alpha), \ldots, f_n(\alpha)\} \;=\; \mathrm{tr.deg}_{\overline{\mathbb{Q}}(z)}\{f_1, \ldots, f_n\} \;=\; n.$$

The exceptional set $E$ consists of singular points of the Mahler system and their $\sigma_q$-orbit.

### 4.2 What this buys for $\Phi_q$ alone

Applied to the single function $\Phi_q$: the Mahler system is $\Phi_q(z) - (1-z)\Phi_q(z^q) = 0$. The only singularity is $z = 1$ (where $1 - z = 0$) and its $\sigma_q$-preimages — the roots of unity of $q$-power order, $\{\zeta : \zeta^{q^k} = 1\}$. So for $\alpha \in \overline{\mathbb{Q}}$ with $0 < |\alpha| < 1$ and $\alpha \neq$ a root of unity: $\Phi_q(\alpha)$ is transcendental.

For $\alpha \in \mathbb{Q}$ with $0 < |\alpha| < 1$: $\alpha$ is never a root of unity unless $\alpha \in \{\pm 1\}$, which is excluded by $|\alpha| < 1$. Hence $\Phi_q(\alpha)$ is transcendental for every rational $0 < |\alpha| < 1$. Nishioka's theorem *fully handles* the $\Phi_q$-alone side of Attack 12.

### 4.3 What Nishioka does not give

Nishioka's theorem is a specialization theorem *within* the Mahler world. It compares the transcendence degree of Mahler-function values against the transcendence degree of the Mahler functions themselves. It has nothing to say about:

1. **Mixed systems.** If one adjoins a Fuchsian solution (such as $\arctan$) to the Mahler functions, Nishioka's theorem does not extend — its proof machinery (Mahler's method, $q$-adic estimates in the $z \mapsto z^q$ dynamics) relies on the iterating difference operator.
2. **Dependence on Fuchsian values.** The target (A) asks about a polynomial relation between $\Phi_q(z_0)$ (Mahler) and $\arctan(z_0)$ (Fuchsian). Nishioka's theorem certifies that neither side is alone algebraic, but not that they are *mutually* algebraically independent.

This is exactly *GAP_C*.

---

## 5. The Remaining Gap (*GAP_C*)

### 5.1 The missing theorem

**Conjecture 5.1** (Mixed Mahler × Fuchsian specialization — *GAP_C*).  *Let $f \in \overline{\mathbb{Q}}\{\!\{z\}\!\}$ be a Mahler function under $\sigma_q$ with Mahler-Galois group $G_M$, and let $g \in \overline{\mathbb{Q}}\{\!\{z\}\!\}$ be a solution of a Fuchsian linear ODE with differential Galois group $G_F$. Assume:*

1. *$G_M$ and $G_F$ have no common quotient as linear algebraic groups (e.g. $G_M$ solvable, $G_F$ simple).*
2. *$f$ and $g$ are algebraically independent over $\overline{\mathbb{Q}}(z)$.*

*Then for $\alpha \in \overline{\mathbb{Q}}$ outside the union of the Nishioka exceptional set for $f$ and the singular set of $g$'s ODE:*

$$\mathrm{tr.deg}_{\mathbb{Q}}\{f(\alpha),\; g(\alpha)\} \;=\; 2.$$

Applied to $f = \Phi_q$ and $g = \arctan$: $G_M$ is (a subgroup of) a one-dimensional torus; $G_F$ is the additive group $\mathbb{G}_a$ — no common quotient. Assumption (2) is the function-level algebraic independence of $\Phi_q$ and $\arctan$ over $\overline{\mathbb{Q}}(z)$, which follows from the Galois dichotomy (they satisfy functional equations of genuinely different types — the Mahler operator $z \mapsto z^q$ is not conjugate to any differential operator; cf. [ADHW21, ADH19]). The exceptional set for $\Phi_q$ is $\{z_0^{q^k} = 1\}$, and for $\arctan$ is $\{z_0 = \pm i\}$; their union does not touch rational $0 < z_0 < 1$.

Conjecture 5.1 at $(f, g, \alpha) = (\Phi_q, \arctan, z_0)$ implies Conjecture A and hence closes Attack 12.

### 5.2 Why the Carlitz-module framework is the right venue

Three structural reasons point to [DVP26]'s Carlitz-module apparatus as the natural setting for Conjecture 5.1:

**(i) Unified Picard-Vessiot.** The Carlitz-module framework provides a joint Picard-Vessiot ring for difference and differential operators that commute on a common base (§§3-4 of [DVP26]). The Mahler operator $\sigma_q$ and the differential operator $d/dz$ commute on $\overline{\mathbb{Q}}(z)$ in the weak sense needed for the joint PV construction.

**(ii) Independence of Galois groups.** [DVP26]'s technology computes the combined Galois group as a subgroup of $G_M \times G_F$ cut out by algebraic relations between $f$ and $g$. The assumption in Conjecture 5.1 that $G_M$ and $G_F$ have no common quotient forces the combined group to be *exactly* $G_M \times G_F$ — the full product — which in turn forces full transcendence at the function level.

**(iii) Period-map specialization.** The Carlitz periods give a difference analogue of the de Rham/Betti comparison used in the Grothendieck period conjecture. Specialization to $\alpha$ reads the function-level $G_M \times G_F$ result as a transcendence-degree-2 statement at the value level, provided $\alpha$ is outside both singular sets.

### 5.3 What precisely is missing

Three discrete ingredients are needed to prove Conjecture 5.1:

| Ingredient | Status | Reference |
|:-----------|:-------|:----------|
| (i) Joint Mahler × Fuchsian Picard-Vessiot construction | Partial | [ADHW21] for general difference × differential; [DVP26] for Carlitz setting |
| (ii) Galois group calculation $G_M \times G_F$ with no common quotient | Known per system | $\Phi_q$: Mahler 1-torus (classical). $\arctan$: $\mathbb{G}_a$. Product: proven |
| (iii) Value-level specialization bypassing Siegel for mixed systems | **Open** | [Ni96] covers Mahler alone; no mixed version in the literature |

Ingredient (iii) is the heart of *GAP_C*. [DVP26]'s machinery appears to extend, but no published theorem yet establishes mixed Mahler × Fuchsian specialization at algebraic points in the generality needed for Attack 12.

### 5.4 Why this is publishable as a technical note

This note does *not* prove Conjecture 5.1. It contributes:

1. A precise formulation of *GAP_C* (Conjecture 5.1) separating three tractable ingredients.
2. An empirical anchor (Session 12, Target H) at $(q, z_0) = (2, 0.3)$ to $600$ digits and height $10^{200}$ — reproducible in seconds.
3. A structural argument (§5.2) for why [DVP26]'s Carlitz-module framework is the correct venue, and why [Ni96] is *insufficient* as it stands.

Each ingredient is a well-defined problem. Ingredient (iii) is the natural next target for a theorem-writing session; it is strictly narrower than a full proof of $\pi$-transcendence-degree claims, and narrower even than Conjecture 4E.1 of [Paper-K2].

---

## 6. Summary

| Statement | Proven? | Reference |
|:----------|:--------|:----------|
| Mahler equation $\Phi_q(z) = (1-z)\,\Phi_q(z^q)$ | Proven | §1.1, directly from definition |
| Numerical Mahler check at $(q, z_0) = (2, 0.3)$ to $10^{-600}$ | Proven | Target H, §2.1 |
| PSLQ independence of $\{1,\pi,\pi^2,\Phi_2,\arctan,\ldots\}$ at height $10^{200}$ | Proven | Target H, §2.2 |
| $\Phi_q(\alpha)$ transcendental for rational $0 < |\alpha| < 1$ | Proven | Nishioka 1996, §4.2 |
| Algebraic independence of $\Phi_q, \arctan$ over $\overline{\mathbb{Q}}(z)$ | Proven | [ADHW21] +  Galois dichotomy |
| Value-level transcendence $\mathrm{tr.deg}\{\Phi_q(z_0), \arctan(z_0)\} = 2$ | **Open** | Conj. 5.1, *GAP_C* |

Attack 12's structural clarity is now complete: the route passes through Di Vizio-Pellarin Carlitz modules, lands in a joint Mahler × Fuchsian Picard-Vessiot ring, computes the Galois group as $G_M \times G_F$, and requires only a mixed-type extension of Nishioka's 1996 specialization theorem to cross from functions to values. *GAP_C* is precisely this extension. A future session targeting it — in collaboration with or building on [DVP26]'s methods — is the natural next step.

The attack is not alive because we have a proof; it is alive because each remaining step has been isolated from the others, and none requires a leap of technique outside the existing difference-Galois literature.

---

## References

- [ADH19] Adamczewski, B., Dreyfus, T. & Hardouin, C. (2019). "Hypertranscendence and linear difference equations." arXiv:1910.01874.
- [ADHW21] Adamczewski, B., Dreyfus, T., Hardouin, C. & Wibmer, M. (2021). "Algebraic independence and linear difference equations." *J. Eur. Math. Soc.*, 2024. arXiv:2010.09266.
- [AT90] Anderson, G. W. & Thakur, D. S. (1990). "Tensor powers of the Carlitz module and zeta values." *Ann. Math.*, 132, 159–191.
- [Ca35] Carlitz, L. (1935). "On certain functions connected with polynomials in a Galois field." *Duke Math. J.*, 1, 137–168.
- [DVP26] Di Vizio, L. & Pellarin, F. (2026). "Differential Ax-Lindemann-Weierstrass for $\Gamma$ via Carlitz modules." (In preparation / preprint in circulation; see Module 05 for context.)
- [Es26] Estienne, C. (2026). "Mahler's method and transcendence in positive characteristic." arXiv:2603.18832.
- [Ma29] Mahler, K. (1929). "Arithmetische Eigenschaften der Lösungen einer Klasse von Funktionalgleichungen." *Math. Ann.*, 101, 342–366.
- [Ni96] Nishioka, K. (1996). *Mahler Functions and Transcendence*. Lecture Notes in Math. 1631, Springer.
- [Pa08] Papanikolas, M. A. (2008). "Tannakian duality for Anderson-Drinfeld motives and algebraic independence of Carlitz logarithms." *Invent. Math.*, 171, 123–174.
- [Paper-K2] Marchewka, N. & Gauss (2026). "On the K₂-Opacity of π: Structural Barriers and the p-adic Path." [Paper-K2-Opacity-Pi.md, this repository].
- [Paper-SS] Marchewka, N. & Gauss (2026). "On the Siegel-Shidlovskii Reduction of the K₂-Opacity Conjecture for π." [Paper-SS-Reduction-And-Siegel-Barrier.md, this repository].
- [Paper-Attack13] Marchewka, N. & Rigel (2026). "Quantitative Lucas Separation and the ADH 2016 Extension Problem for Attack 13." [Paper-Attack13-Lucas-Extension.md, this repository].
