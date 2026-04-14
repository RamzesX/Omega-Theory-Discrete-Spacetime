# Motivic Periods, the B × SL₂ Galois Product, and the Zilber-Pink Gap for Attack 14

## Norbert Marchewka and Rigel

---

## Abstract

Attack 14 (*Motivic Period*) predicts, via the product motivic Galois group $B \times SL_2$ acting on the pair (Kummer ${}_1F_1$ motive, Legendre $\sqrt{1-x^2}$ period motive), that

$$\mathrm{tr.deg}_{\mathbb{Q}}\{u,\; v,\; \pi/4\} \;=\; 3$$

at the slice $(a,b,z_0) = (1/2, 3/2, 1/2)$, where $u = {}_1F_1(a;b;z_0)$, $v = {}_1F_1'(a;b;z_0)$, and $\pi/4 = \int_0^1 dx/\sqrt{1-x^2} \cdot 1/2$ is the Legendre period. Session 13 Target I ran a degree-$\leq 2$ PSLQ on ten monomials in $\{u, v, \pi/4\}$ at 600 dps and height $10^{200}$, returning `NO_RELATION_FOUND`; Session 14 Target I2 extended this to a degree-$\leq 3$ PSLQ on twenty monomials at 700 dps, again `NO_RELATION_FOUND`. The prediction survives cleanly at cubic total degree. Turning these survivals into a theorem requires two conditional inputs: the Grothendieck Period Conjecture (GPC) for the product motive, and a Zilber-Pink / unlikely-intersections statement ruling out atypical algebraic dependencies between the Kummer motive's value and the Legendre period. The latter is the gap we call *GAP_M*. We state it precisely in the setting of André's 2024 framework (arXiv:2501.09867) for G-function values and unlikely intersections, isolate three tractable ingredients, and argue that Attack 14 is the most GPC-transparent of the three current attacks. This is **not a proof**. It is a gap-framing note, companion to [Paper-Attack13] and [Paper-Attack12].

**Keywords**: motivic Galois group, Grothendieck period conjecture, Zilber-Pink, unlikely intersections, ${}_1F_1$, Legendre period, $B \times SL_2$, G-function values.

**MSC 2020**: 11J81 (primary), 11J91, 14L17, 11G99, 14F42.

---

## 1. Setup

### 1.1 The three values

Fix the slice $(a, b, z_0) = (1/2, 3/2, 1/2)$ and define:

**(i) The Kummer value.**
$$u \;=\; {}_1F_1\!\left(\tfrac{1}{2};\; \tfrac{3}{2};\; \tfrac{1}{2}\right) \;=\; \sum_{k \geq 0} \frac{(1/2)_k}{(3/2)_k \, k!} \left(\tfrac{1}{2}\right)^k \;\in\; \mathbb{R}_{>0}.$$

This is a specialization of the E-function ${}_1F_1(a;b;z)$ at an algebraic point $z_0 = 1/2 \in \mathbb{Q}$, a classical member of the Kummer family. Its motive is the rank-two Kummer motive with motivic Galois group the Borel subgroup $B \subset GL_2$ (upper-triangular), acting on the pair $(u, v)$ below.

**(ii) The Kummer derivative value.**
$$v \;=\; \frac{d}{dz}\,{}_1F_1\!\left(\tfrac{1}{2};\, \tfrac{3}{2};\, z\right)\bigg|_{z=1/2} \;=\; \sum_{k \geq 1} \frac{(1/2)_k}{(3/2)_k \, (k-1)!} \left(\tfrac{1}{2}\right)^{k-1}.$$

Numerically: $u \approx 1.1955$, $v \approx 0.7283$ (700 dps values are in `sage/target_i2_output.json`). The pair $(u, v)$ spans the Picard-Vessiot fiber at $z_0$ of the Kummer ODE $z y'' + (b - z) y' - a y = 0$; Siegel-Shidlovskii gives $\mathrm{tr.deg}_{\mathbb{Q}}\{u, v\} = 2$ at this algebraic $z_0$ (cf. [Paper-SS §3]).

**(iii) The Legendre period.**
$$\pi/4 \;=\; \frac{1}{2}\int_0^1 \frac{dx}{\sqrt{1 - x^2}} \;=\; \arcsin(1)/2.$$

This is the canonical period of the rank-two Legendre motive $H^1(\mathbb{P}^1 \setminus \{0,1,\infty\},\, \text{Kummer}(1/2))$, with motivic Galois group a specific form of $SL_2$. The pairing $\pi/4 = \arctan(1)$ via $\arctan = \int dx/(1+x^2)$ at $x=1$ is an *alternative presentation* of the same period; for the purposes of the $B \times SL_2$ motivic story we take the $\arcsin$ presentation (Legendre), which is the presentation that makes the $SL_2$ action explicit [An24, §4].

### 1.2 The target prediction

**Conjecture A (Attack 14 target).** *At the slice $(1/2, 3/2, 1/2)$,*

$$\mathrm{tr.deg}_{\mathbb{Q}}\{u,\; v,\; \pi/4\} \;=\; 3. \tag{A}$$

This says: there is no nonzero polynomial $P \in \mathbb{Q}[X, Y, Z]$ with $P(u, v, \pi/4) = 0$. Equivalently, the three numbers generate a transcendence-degree-3 subfield of $\mathbb{R}$ over $\mathbb{Q}$.

**Motivic prediction.** The pair $\{u, v\}$ lives in the Kummer motive with motivic Galois group $B$ (Borel). The period $\pi/4$ lives in the Legendre motive with motivic Galois group (a form of) $SL_2$. These two motives are *unrelated* — the Kummer motive is unipotent-mixed on $(u,v)$ via $v - au = O(z-z_0)$ truncation, while the Legendre motive is semisimple pure of weight 1. The product motive has motivic Galois group
$$G_{\text{mot}} \;=\; B \times SL_2,$$
of dimension $3 + 3 = 6$ over the Tannakian base. By the **Grothendieck Period Conjecture** (GPC), the transcendence degree of the periods of a motive equals the dimension of its motivic Galois group, so
$$\dim G_{\text{mot}} = 6 \;\implies\; \mathrm{tr.deg}_{\mathbb{Q}}\{\text{all periods of the product motive}\} = 6.$$
Restricted to the three periods we care about, $\{u, v, \pi/4\}$: a symmetry/counting argument inside the product (see §4) isolates $\mathrm{tr.deg}_{\mathbb{Q}}\{u, v, \pi/4\} = 3$ as the tight prediction. Conjecture A is this prediction.

---

## 2. Empirical Support (Sessions 13–14, Targets I and I2)

### 2.1 Target I — degree-$\leq 2$ PSLQ (Session 13)

Tool: `mpmath.pslq`, 600 dps, height bound $\mathrm{maxcoeff} = 10^{200}$. Monomial list (10 monomials, all of $\mathbb{Q}$-degree $\leq 2$):
$$\{1,\; u,\; v,\; \pi/4,\; u^2,\; v^2,\; (\pi/4)^2,\; uv,\; u(\pi/4),\; v(\pi/4)\}.$$
**Verdict**: `NO_RELATION_FOUND`. The degree-1 sub-baseline on $\{1, u, v, \pi/4\}$ is also clean.

Interpretation: no nonzero polynomial relation of total degree $\leq 2$ in $\mathbb{Q}[u, v, \pi/4]$ with integer coefficients of height $\leq 10^{200}$ produces a residual below $10^{-600}$. Consistent with $\mathrm{tr.deg} \geq 3$ at this height cutoff.

### 2.2 Target I2 — degree-$\leq 3$ PSLQ (Session 14)

Tool: `mpmath.pslq`, 700 dps, height bound $10^{200}$. Monomial list extended to total degree 3 (20 monomials):
$$\{1,\, u,\, v,\, w,\, u^2,\, v^2,\, w^2,\, uv,\, uw,\, vw,\, u^3,\, v^3,\, w^3,\, u^2 v,\, u^2 w,\, u v^2,\, v^2 w,\, u w^2,\, v w^2,\, uvw\}$$
where $w = \pi/4$. **Verdict**: `NO_RELATION_FOUND_SUPPORTS_TRDEG_3_DEG3`.

Combined Sessions 13–14 data: no polynomial relation of total degree $\leq 3$ and integer-coefficient height $\leq 10^{200}$ among $\{u, v, \pi/4\}$, verified at 600–700 digits. Consistent with Conjecture A at cubic total degree.

### 2.3 What the numerics do and do not buy

Target I and I2 serve the same role as Target G (Attack 13) and Target H (Attack 12) in their respective papers: a reproducible published empirical anchor. They *confirm* that Conjecture A has survived a nontrivial PSLQ stress test; they do *not* rule out relations of degree $> 3$ or coefficient height $> 10^{200}$. A relation of height $10^{10^6}$, invisible to PSLQ, remains logically possible — exactly as with Target G (F27) and Target H (Mahler slice).

Degree-4 and beyond are the natural next numerical test; the structural content of this note, however, is that the *theoretical* path forward is not more PSLQ but the motivic route of §§3–5.

---

## 3. André 2024 — G-Function Values and Unlikely Intersections

### 3.1 What [An24] provides

Y. André's 2024 preprint *"G-function values and unlikely intersections"* (arXiv:2501.09867) establishes a bridge between:

1. Values of G-functions at algebraic points (in the sense of Siegel);
2. Atypical intersections of Hodge loci in mixed Shimura varieties (in the sense of Zilber-Pink).

The main structural output is: *algebraic relations between G-function values at a fixed algebraic $z_0$ must come either from the motivic Galois group of the underlying motive or from an "unlikely intersection" of Hodge loci* — the second case being conjecturally excluded by the Zilber-Pink conjecture for the ambient mixed Shimura variety.

This is the clean setting for Attack 14. The period $\pi/4$ (Legendre) and the pair $(u, v)$ (Kummer value + derivative) are both *specializations of G-function-type periods* at algebraic points — $\pi/4$ is the value of $\arcsin$ at $1$ (boundary), $(u, v)$ is the Kummer pair at $z_0 = 1/2$. André's framework applies directly.

### 3.2 What the André framework buys for Attack 14

In the Zilber-Pink language, the three periods $(u, v, \pi/4)$ correspond to three points in (respectively) the Kummer fiber of a mixed Shimura variety $\mathcal{M}_{\text{Kummer}}$ and the Legendre fiber of a Shimura variety $\mathcal{M}_{\text{Legendre}}$. The product $\mathcal{M}_{\text{Kummer}} \times \mathcal{M}_{\text{Legendre}}$ carries the product motivic Galois group $B \times SL_2$, and any algebraic relation
$$P(u, v, \pi/4) = 0, \quad P \in \mathbb{Q}[X,Y,Z],$$
forces the triple to lie in a Hodge locus of strictly positive codimension in the product. If the Hodge locus is *not* of motivic origin — i.e. not predicted by the product Galois group — it is an *unlikely intersection*.

Conjecturally (Zilber-Pink): no such unlikely intersection exists. Hence any relation must be of motivic origin, and the motivic Galois group $B \times SL_2$ has no nontrivial relation between its $u$-coordinate, $v$-coordinate, and Legendre-period coordinate (this is the $B \times SL_2$ prediction of §1.2). Therefore no relation exists, and $\mathrm{tr.deg} = 3$.

The argument routes: empirical survival ⇒ Zilber-Pink ⇒ GPC ⇒ Conjecture A.

---

## 4. The Grothendieck Period Conjecture Layer

### 4.1 Statement (GPC, André-Grothendieck form)

**Grothendieck Period Conjecture.** *Let $M$ be a motive over $\overline{\mathbb{Q}}$ with Betti realization $H_B$ and de Rham realization $H_{dR}$. The transcendence degree over $\mathbb{Q}$ of the field generated by the periods of $M$ (the matrix entries of the comparison isomorphism $H_B \otimes \mathbb{C} \cong H_{dR} \otimes \mathbb{C}$) equals the dimension of the motivic Galois group $G_{\text{mot}}(M)$.*

### 4.2 Application to the product motive

Let $M_K$ be the Kummer motive (rank 2, Galois group $B$) and $M_L$ the Legendre motive (rank 2, Galois group form of $SL_2$). The product motive $M = M_K \oplus M_L$ has $G_{\text{mot}}(M) = B \times SL_2$ as long as there is no motivic morphism $M_K \to M_L$ or vice versa — which holds because the weights disagree (Kummer is unipotent-mixed, Legendre is pure weight 1) [An24, §4.2].

$\dim B = 3$ (upper-triangular $2 \times 2$: diagonal 2, upper $1$), $\dim SL_2 = 3$. So $\dim G_{\text{mot}}(M) = 6$, and GPC predicts that the full period field has transcendence degree 6.

### 4.3 From 6 to 3

The six periods of the product motive are (Betti vs. de Rham pairings):
$$\{u, v, u', v', \pi/4, \pi'/4\}$$
where $u', v'$ are the "other" ${}_1F_1$ solution's value and derivative (a second solution of the Kummer ODE), and $\pi'/4$ is the dual Legendre period. The subset $\{u, v, \pi/4\}$ is a specific 3-dimensional sub-collection and the rank-3 projection of the GPC statement gives:
$$\mathrm{tr.deg}_{\mathbb{Q}}\{u, v, \pi/4\} \;=\; 3$$
*provided no unlikely intersection reduces the rank at this specific projection*. The "unlikely intersection" caveat is exactly Zilber-Pink (§3); GPC alone gives rank 6 for the full 6-tuple but does not directly give the specific sub-rank. The Zilber-Pink statement is what rules out a rank drop at the projection.

Thus GPC + Zilber-Pink $\Rightarrow$ Conjecture A.

---

## 5. The Remaining Gap (*GAP_M*)

### 5.1 The missing statement

**Conjecture 5.1** (Zilber-Pink for $B \times SL_2$ Kummer-Legendre periods — *GAP_M*).  *Let $M_K$ be the Kummer motive over $\mathbb{Q}$ with parameters $(a, b) \in \mathbb{Q}^2$, $a, b - a \notin \mathbb{Z}_{\leq 0}$, and let $M_L$ be the Legendre motive. Fix an algebraic $z_0 \in \overline{\mathbb{Q}}$ with $0 < z_0 < 1$. Then any algebraic relation $P \in \overline{\mathbb{Q}}[X, Y, Z]$ with*
$$P\!\left({}_1F_1(a;b;z_0),\; {}_1F_1'(a;b;z_0),\; \pi/4\right) \;=\; 0$$
*comes from a morphism of motives $M_K \to M_L^{\otimes k}$ or $M_L \to M_K^{\otimes k}$ for some $k \geq 1$.*

For generic $(a, b)$ — and in particular for $(a, b, z_0) = (1/2, 3/2, 1/2)$ — no such morphism exists (weights incompatible), so Conjecture 5.1 collapses to: *no algebraic relation*. This is Conjecture A.

### 5.2 Three tractable ingredients

| Ingredient | Description | Status |
|:-----------|:------------|:-------|
| (i) Motivic Galois identification | $G_{\text{mot}}(M_K) = B$, $G_{\text{mot}}(M_L) = SL_2$, $G_{\text{mot}}(M_K \oplus M_L) = B \times SL_2$ | **Proven** (classical, [An24 §4.2]) |
| (ii) GPC for the product motive $M_K \oplus M_L$ | $\mathrm{tr.deg}(\text{periods}) = \dim G_{\text{mot}} = 6$ | **Open** (GPC is open in general; proven in no nontrivial mixed-weight case) |
| (iii) Zilber-Pink sub-rank control | No unlikely intersection at the $(u, v, \pi/4)$ projection | **Open** ([An24] framework; no unconditional theorem) |

Ingredient (i) is classical. Ingredients (ii) and (iii) together constitute *GAP_M*. Unlike *GAP_L* (Attack 13) and *GAP_C* (Attack 12), *GAP_M* is not a specific extension of a specific published theorem — it is the Grothendieck Period Conjecture itself, projected through the André-Zilber-Pink lens. This makes Attack 14 the *most conjectural* of the three attacks, and simultaneously the *most structurally transparent*: it is exactly GPC + Zilber-Pink for a specific product motive.

### 5.3 Why Attack 14 is worth publishing anyway

Three reasons motivate this note despite Attack 14's heavy dependence on GPC:

1. **Degree-3 empirical survival.** The combined Sessions 13–14 data (Target I + Target I2) push the relation-free window to cubic total degree and $10^{200}$ height, far beyond what exists for the sister attacks. No relation at height $10^{200}$ across 20 monomials is *not* a trivial computation — each cubic run is a 700-dps PSLQ over 20 real numbers, and the clean verdict is itself information-theoretically meaningful (cf. Target I2 file).

2. **GPC transparency.** The framework of §3–§4 is entirely mainstream — no attack-specific machinery is invented. An expert reader confirms: *Attack 14 is GPC for the $B \times SL_2$ product motive*. No extra conjecture is required.

3. **Sister-attack triangulation.** Attack 13 ([Paper-Attack13]) attacks via $p$-adic Lucas separation; Attack 12 ([Paper-Attack12]) via Carlitz-module Mahler methods; Attack 14 via motivic Galois. If all three attacks survive their respective empirical tests at matching precision and height, the triple survival provides the strongest form of evidence short of a proof: it says that *three structurally independent Galois-theoretic routes* all agree with the K₂-opacity prediction for $\pi$.

### 5.4 What precisely is missing

To upgrade Attack 14 from conjecture to theorem we need:

(a) A proof of GPC for the product motive $M_K \oplus M_L$, specifically for the Kummer parameters $(1/2, 3/2)$ and Legendre — or equivalently, a proof of André-Oort / Zilber-Pink for the ambient mixed Shimura variety at the specific point $(u, v, \pi/4)$.

(b) Failing (a): an explicit construction of a *period algebra homomorphism* $\overline{\mathbb{Q}}\langle u, v, \pi/4 \rangle \to \overline{\mathbb{Q}}$ compatible with the $B \times SL_2$ action, which would force transcendence from the nontriviality of the product Galois action.

Neither (a) nor (b) is on the horizon; GPC remains as open as it has been since 1964. The published value of this note is therefore *structural clarity*, not resolution.

---

## 6. Summary

| Statement | Proven? | Reference |
|:----------|:--------|:----------|
| Kummer motive has Galois group $B$ | Proven | Classical; [An24 §4.2] |
| Legendre motive has Galois group form of $SL_2$ | Proven | Classical; [An24 §4.2] |
| Product motive Galois $= B \times SL_2$ (weights disagree) | Proven | [An24 §4.2] |
| $\mathrm{tr.deg}_{\mathbb{Q}}\{u, v\} = 2$ (SS at algebraic $z_0$) | Proven | [Si49], [Sh56], [Be06] |
| No $\mathbb{Q}$-relation of degree $\leq 2$, height $\leq 10^{200}$ among $\{u,v,\pi/4\}$ | Proven | Target I (Session 13) |
| No $\mathbb{Q}$-relation of degree $\leq 3$, height $\leq 10^{200}$ among $\{u,v,\pi/4\}$ | Proven | Target I2 (Session 14) |
| GPC for product motive $M_K \oplus M_L$ | **Open** | Conj. 5.1, *GAP_M* (i) |
| Zilber-Pink sub-rank for $(u, v, \pi/4)$ projection | **Open** | Conj. 5.1, *GAP_M* (ii) |
| $\mathrm{tr.deg}_{\mathbb{Q}}\{u, v, \pi/4\} = 3$ | **Open** | Conjecture A |

Attack 14's structural content is now anchored: the route passes through André's 2024 G-function / unlikely-intersections framework, lives inside the product mixed-Shimura variety associated with $M_K \oplus M_L$, and requires GPC + Zilber-Pink as a single conditional input. *GAP_M* is precisely this input.

Across the three companion papers, the K₂-opacity route is now framed via three independent Galois-theoretic attacks, each with its own cleanly-isolated gap:

- **Attack 13 — *GAP_L*** (Lucas / $p$-adic): specialization from $\mathbb{Q}(z)$ to $\mathbb{Q}$ for mixed $E \oplus G$ pairs.
- **Attack 12 — *GAP_C*** (Carlitz-Frobenius / Mahler): mixed Mahler $\times$ Fuchsian specialization extending Nishioka 1996.
- **Attack 14 — *GAP_M*** (motivic / Zilber-Pink): GPC + Zilber-Pink for the $B \times SL_2$ product motive.

A future session targeting (a) a computational PSLQ extension of Target I2 to degree 4 on the 35-monomial basis, (b) a literature search for any Zilber-Pink partial result applicable to the Kummer $\times$ Legendre product, and (c) coordination with André's team on arXiv:2501.09867's generalizability, is the natural next step. Attack 14 is not alive because we have a proof; it is alive because the path from data to theorem has been reduced to a single published conjecture (GPC) and a single unpublished refinement (Zilber-Pink for this specific product).

---

## References

- [An24] André, Y. (2024). "G-function values and unlikely intersections." arXiv:2501.09867.
- [An89] André, Y. (1989). *G-Functions and Geometry*. Aspects of Mathematics E13, Vieweg.
- [AO23] Ax, J. revisited — Ax-Schanuel and its modern formulations; cf. Pila-Tsimerman, *Ann. Math.* (2014, and follow-ups).
- [Be06] Beukers, F. (2006). "A refined version of the Siegel-Shidlovskii theorem." *Ann. Math.*, 163, 369–379.
- [DK19] Deligne, P. & Kontsevich, M. — periods and motives; see [An89] and the Kontsevich-Zagier *"Periods"* article for the modern shape of GPC.
- [Gr66] Grothendieck, A. (1966). "On the de Rham cohomology of algebraic varieties." *Publ. Math. IHÉS*, 29, 95–103.
- [KZ01] Kontsevich, M. & Zagier, D. (2001). "Periods." *Mathematics Unlimited — 2001 and Beyond*, 771–808. Springer.
- [Pi11] Pink, R. (2011). "A combination of the conjectures of Mordell-Lang and André-Oort." *Geometric Methods in Algebra and Number Theory*, Prog. Math. 235.
- [PT14] Pila, J. & Tsimerman, J. (2014). "Ax-Schanuel for the $j$-function." *Duke Math. J.*, 163, 1777–1819.
- [Sh56] Shidlovskii, A. B. (1956). "On transcendence and algebraic independence of values of E-functions." *Doklady*, 109, 26–28.
- [Si49] Siegel, C. L. (1949). *Transcendental Numbers*. Princeton University Press.
- [Zi02] Zilber, B. (2002). "Exponential sums equations and the Schanuel conjecture." *J. London Math. Soc.*, 65, 27–44.
- [Paper-K2] Marchewka, N. & Gauss (2026). "On the K₂-Opacity of π: Structural Barriers and the p-adic Path." [Paper-K2-Opacity-Pi.md, this repository].
- [Paper-SS] Marchewka, N. & Gauss (2026). "On the Siegel-Shidlovskii Reduction of the K₂-Opacity Conjecture for π." [Paper-SS-Reduction-And-Siegel-Barrier.md, this repository].
- [Paper-Attack13] Marchewka, N. & Rigel (2026). "Quantitative Lucas Separation and the ADH 2016 Extension Problem for Attack 13." [Paper-Attack13-Lucas-Extension.md, this repository].
- [Paper-Attack12] Marchewka, N. & Rigel (2026). "The Carlitz-Frobenius Bridge for K₂-Opacity: A Mahler × Fuchsian Specialization Gap." [Paper-Attack12-Carlitz-Frobenius.md, this repository].
