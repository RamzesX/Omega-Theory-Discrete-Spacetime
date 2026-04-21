# 01 — Classical hierarchies of irrationality / transcendence

This memo tabulates the rigorous notions of "irrationality class" that classify **real numbers** by how well they can be approximated by rationals (or algebraics). A separation theorem for OmegaTheory's four constants must land each of them in a distinct cell of one of these hierarchies.

## 1. Rationality and the irrationality measure μ(α)

**Definition.** For α ∈ ℝ, `μ(α) := inf { μ : |α − p/q| > q^(−μ) for all but finitely many (p,q) ∈ ℤ × ℕ⁺ }`. Rationals have μ = 1 by convention. Almost every irrational has μ = 2 (Khinchin). Roth's theorem says every *algebraic irrational* has μ = 2 (Roth 1955, Fields Medal 1958).

## 2. Liouville ladder

**Definition.** α ∈ ℝ is a *Liouville number* iff μ(α) = ∞. Equivalently, for every n ∈ ℕ there exist coprime p, q with 1 < q and `0 < |α − p/q| < 1/qⁿ`.

**Theorem (Liouville 1844).** Every Liouville number is transcendental.

**Mathlib status.** `Mathlib.NumberTheory.Transcendental.Liouville.Basic` defines `Liouville` and proves `Liouville.irrational` + `Liouville.transcendental`. `Mathlib.NumberTheory.Transcendental.Liouville.LiouvilleWith` gives the parameterised ladder `LiouvilleWith p α` = "α is approximable to order p".

**Key fact for OmegaTheory.** π and e are **NOT** Liouville (Mahler 1953; Zudilin–Salikhov bounds: μ(π) ≤ 7.103 (Zeilberger–Zudilin 2020)). √2 is not Liouville (being algebraic). Catalan G: widely conjectured non-Liouville, empirically μ(G) ≈ 2, proof: **open**.

## 3. Roth exponent

**Theorem (Thue–Siegel–Roth 1955).** For every algebraic irrational α and every ε > 0, `|α − p/q| < q^(−(2+ε))` has only finitely many solutions. Equivalently: μ(α) = 2 for algebraic irrational α, and the exponent 2 cannot be lowered.

**Mathlib status.** **Not in Mathlib** as of v4.29.0 (searched 2026-04-21: no `Roth` in `Mathlib.NumberTheory.*`). Would need original formalisation. See §08.

**Classification corollary.** If μ(α) > 2 then α is transcendental. Contrapositive: algebraic ⇒ μ = 2.

## 4. Algebraic vs transcendental

**Definition.** α is *algebraic* iff it is a root of some non-zero P ∈ ℚ[X]. Otherwise *transcendental*.

**Mathlib status.** `Mathlib.RingTheory.Algebraic.Basic.IsAlgebraic` and `Transcendental := ¬ IsAlgebraic`. Lindemann-Weierstrass PARTIAL: `Mathlib.NumberTheory.Transcendental.Lindemann.AnalyticalPart` is in, but the number-theoretic conclusion (π transcendental, e transcendental from Hermite) is NOT yet derived — that's why `Real.pi_transcendental` appears as `axiom` in `HermitePade/PiStratum.lean:45`.

**Status per constant.**
- π: transcendental (Lindemann 1882).
- e: transcendental (Hermite 1873).
- √2: algebraic (degree 2, `x² − 2`).
- Catalan G: **OPEN** — not even known irrational.

## 5. Mahler's classification {A, S, T, U} (1932)

The deepest classical partition of complex numbers. Based on polynomial approximation height.

**Setup.** For α ∈ ℂ and n, H ∈ ℕ define `ω_n(α, H) := min { |P(α)| : P ∈ ℤ[X], deg P ≤ n, 0 < H(P) ≤ H }`, where `H(P)` is the naive height (max |coefficient|). Let `ω_n(α) := limsup_{H→∞} −log ω_n(α, H) / log H`, and `ω(α) := limsup_n ω_n(α) / n`.

**Classification.** α is
- **A-number** iff ω(α) = 0 and every ω_n(α) is finite ⟺ α is **algebraic**.
- **S-number** iff ω(α) < ∞ ⟺ every ω_n(α) ≤ C·n for some C.
- **T-number** iff ω(α) = ∞ but every ω_n(α) < ∞.
- **U-number** iff some ω_n(α) = ∞ ⟺ α is a limit of algebraics of bounded degree (includes all Liouville numbers).

**Key theorems.**
- Mahler 1932: {A, S, T, U} partition ℂ; classes are invariant under algebraic transformations.
- Mahler 1939: almost every real is an S-number (so "S = typical transcendental").
- Koksma 1939: the classification is equivalent to Koksma's {A*, S*, T*, U*} (approximation by algebraics rather than integer polynomials). See Bugeaud, *Approximation by algebraic numbers* (Cambridge, 2004), Ch. 3.
- Baker 1964 (`On Mahler's classification of transcendental numbers`, Acta Math 111): constructs T-numbers explicitly. Before Baker the existence of T-numbers was conjectural.
- Liouville numbers = subset of U-numbers (in fact U₁, using degree-1 polynomials).

**Mathlib status.** **Not in Mathlib.** This is the largest porting debt in §08. Requires ω_n, ω functions, Mahler classification lemma, partition-completeness, Baker existence. Estimate: 20–40 sessions on top of a 3–5 session Bugeaud-ch3 porting effort.

**Status per constant.**
- π: **conjectured S-number with ω(π) ≤ (μ(π)−2)/2 ≈ 2.55** (non-rigorous upper bound using μ(π) ≤ 7.103). Proof of "π ∈ S" would also require Mahler classification machinery. OPEN modulo machinery.
- e: **S-number**, with ω(e) = 1 — classical, Mahler 1932 as a direct calculation using Hermite's construction.
- √2: **A-number**. Trivial (algebraic ⟹ A).
- Catalan G: **OPEN** — not even known irrational; if irrational, widely conjectured to be S.

## 6. Siegel–Shidlovsky E-function class

**Definition.** `E(z) = Σ aₙ zⁿ / n!` with aₙ algebraic is an *E-function* iff (i) `E` satisfies a linear ODE with coefficients in `ℚ(z)`; (ii) the aₙ are bounded in height polynomially in n; (iii) same for a common denominator of `a₀, …, aₙ`.

**Theorem (Siegel 1929, Shidlovsky 1956).** Let `E₁, …, E_m` be E-functions satisfying a linear ODE system. If they are algebraically independent over `ℚ(z)`, then for any algebraic `α ≠ 0` outside the finite "exceptional set", the values `E₁(α), …, E_m(α)` are algebraically independent over `ℚ`.

**Why e fits.** `E(z) = e^z` is an E-function (ODE `E' = E`). Applied at `z = 1`: `e` is transcendental and the Mahler ω(e) = 1 classification follows.

**Why π does NOT directly fit.** `π = 4·arctan(1)`, and `arctan` as a power series `Σ (−1)ⁿ z^(2n+1)/(2n+1)` has coefficients falling like `1/n` — these are **G-function** coefficients (`Σ aₙ zⁿ` with aₙ algebraic, bounded height polynomially in n — **no 1/n!**). π transcendence via Lindemann is proved by a different route: Hermite–Lindemann on `e^(iπ) + 1 = 0`. So: **e** lives in the E-function class natively; **π** only lives in it via the `e^(iα)` composition.

**Mathlib status.** `Mathlib.NumberTheory.Transcendental.Lindemann.AnalyticalPart` has Hermite's integral construction for e^α. The full Siegel-Shidlovsky theorem is **not** in Mathlib. We declare it as axiom in `HermitePade/SSReduction.lean#L* (siegel_shidlovskii)`.

## 7. Baker's theorem on linear forms in logarithms

**Theorem (Baker 1966, Fields 1970).** If `α₁, …, α_n` are algebraic, non-zero, with `log α₁, …, log α_n` linearly independent over ℚ, then `1, log α₁, …, log α_n` are linearly independent over `ℚ(algebraic)`.

**Corollary (qualitative).** Gelfond–Schneider (Hilbert's 7th): α algebraic ≠ 0, 1, β algebraic irrational ⟹ α^β transcendental. Gives us `e^π = (e^(iπ))^(−i) = (−1)^(−i)` transcendental.

**Mathlib status.** Not in Mathlib. Large porting target. Baker's theorem already has an informal proof ported in Carneiro's blueprint but not merged.

**Use in OmegaTheory.** We don't directly use Baker's theorem today. But `e^π` appearing in Nesterenko's triple (§7 below) is a Baker/Gelfond–Schneider consequence.

## 8. Nesterenko's 1996 theorem

**Theorem (Nesterenko 1996, *C. R. Acad. Sci. Paris* 322:909–914).** `π`, `e^π`, `Γ(1/4)` are algebraically independent over `ℚ`. Transcendence degree 3 over ℚ.

**Corollary.** Each of π, e^π, Γ(1/4) is transcendental; no polynomial relation among them.

**Mathlib status.** Not in Mathlib. Declared axiom `Nesterenko_1996` in `HermitePade/GAP_N_Conjecture.lean:68`.

**Use in OmegaTheory.** The effective sharpening `GAP_N` is the diary's attack on μ(π) ≤ 3+ε. Not yet a separation witness for the four constants, but supplies transcendence as a by-product.

## 9. Zudilin–Rivoal tower for Dirichlet β-values

**Theorem (Ball–Rivoal 2001).** Infinitely many ζ(2n+1) are irrational. **Theorem (Rivoal–Zudilin 2003).** Analogous result for Dirichlet β(2n); specifically, at least one of β(2), β(4), …, β(14) is irrational; infinitely many β(2n) are irrational.

**Why Catalan G is hard.** G = β(2). The Rivoal–Zudilin family shows *some* even β(2n) is irrational, but does not single out β(2) itself. No Apéry-style rational approximations of G are yet sharp enough to force irrationality (Zudilin 2019: "β(2) irrationality is arguably the most basic constant whose irrationality, though strongly suspected, remains unproven").

**Best explicit partial results (Zudilin + Rivoal 2010s):**
- Infinitely many of `β(2), β(4), …` are irrational.
- `dim_ℚ ⟨1, β(2), β(4), …, β(2k)⟩ ≥ c · log k / log log k` for a constant c > 0.
- Hermite-Padé / Nesterenko-type quantitative bounds on linear forms in β-values.

**Mathlib status.** Apéry's theorem (`ζ(3)` irrational) is NOT in Mathlib; a Coq (Rocq) formalisation exists (Mahboubi–Sibut-Pinote 2014). Catalan G irrationality: not only not in Mathlib — not in any theorem prover, because unproven in classical mathematics.

## 10. Summary table — where each OmegaTheory irrational sits

| Class | π | e | √2 | Catalan G |
|---|---|---|---|---|
| Rational? | no | no | no | no (conjectured) |
| Liouville? | no (μ<∞) | no (μ=2) | no (algebraic) | conjectured no |
| Algebraic? | NO (Lindemann) | NO (Hermite) | YES (deg 2) | conjectured NO (OPEN) |
| Roth exponent | μ = 2 (conjectured) | μ = 2 (proved) | μ = 2 (by Roth) | μ = 2 (conjectured) |
| Mahler class | S (conj.) | S (proved) | A (trivial) | S (conj. if irrational) |
| Shidlovsky E-function | no (arctan is G-function) | YES (exp is E-function) | no (algebraic) | no |
| Nesterenko 1996 witness | YES (component 0) | no directly | no | no |
| Open at 2026-04-21 | none | none | none | irrationality itself |

**Conclusion.** At the Mahler classification level, (π, e, √2, G) hit classes {S, S, A, S-or-open}. That's not four distinct classes — π and e share class S, and G is either S or open. **A stronger separation is needed.** See `06_separation_theorem.md` for how we strengthen this.

## Canonical bibliography

1. Mahler, *Zur Approximation der Exponentialfunktion und des Logarithmus I, II*, J. Reine Angew. Math. 166 (1932).
2. Koksma, *Über die Mahlersche Klasseneinteilung der transzendenten Zahlen*, Monatsh. Math. Phys. 48 (1939).
3. Shidlovsky, *Transcendental Numbers*, de Gruyter 1989 (the book).
4. Baker, *On Mahler's classification of transcendental numbers*, Acta Math. 111 (1964).
5. Baker, *Linear forms in logarithms of algebraic numbers I–IV*, Mathematika 13–15 (1966–1968).
6. Thue 1909, Siegel 1921, Roth 1955 — exponent-2 chain.
7. Lindemann, *Über die Zahl π*, Math. Ann. 20 (1882).
8. Hermite, *Sur la fonction exponentielle*, C. R. Acad. Sci. Paris 77 (1873).
9. Nesterenko, *On the measure of algebraic independence of values of Ramanujan functions*, C. R. Acad. Sci. Paris Sér. I 322 (1996), 909–914.
10. Nesterenko, *Modular functions and transcendence questions*, Sb. Math. 187 (1996).
11. Rivoal, *La fonction zêta de Riemann prend une infinité de valeurs irrationnelles aux entiers impairs*, C. R. Acad. Sci. Paris Sér. I 331 (2000).
12. Rivoal & Zudilin, *Diophantine properties of numbers related to Catalan's constant*, Math. Ann. 326 (2003), 705–721.
13. Zeilberger & Zudilin, *The irrationality measure of π is at most 7.103205334137…*, Moscow J. Combin. Number Theory 9 (2020), 407–419. arXiv:1912.06345.
14. Salikhov, *On the measure of irrationality of the number π*, Math. Notes 88 (2010), 563–573.
15. Bugeaud, *Approximation by Algebraic Numbers*, Cambridge Tracts 160 (2004) — best survey of Mahler/Koksma/Baker classification at textbook level.
16. Zudilin, *Arithmetic of Catalan's constant and its relatives*, Abh. Math. Sem. Univ. Hamburg 89 (2019).
17. Apéry 1978 / Beukers 1979 / Mahboubi–Sibut-Pinote Coq 2014 — ζ(3) irrationality.
18. Nesterenko 1996 Ramanujan-functions paper (algebraic independence of π, e^π, Γ(1/4)) — OmegaTheory's axiom `Nesterenko_1996`.
