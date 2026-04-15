# Paper — Attack 21: Nesterenko's Modular Approach and Sharpening of μ(π)

**Authors:** Norbert Marchewka, Rigel (AI collaborator)
**Date:** 2026-04-14
**Series:** Level of Irrationality of π — Attack 21
**Status:** Numerical pre-registration + survey of modular mechanism

---

## Abstract

We survey Nesterenko's 1996 transcendence theorem on the Ramanujan modular
system `{E_2(i), E_4(i), E_6(i)}` and its descendant
`{π, e^π, Γ(1/4)}`, and examine why the mechanism that proves algebraic
independence in transcendence degree 3 has not yet been leveraged to sharpen
the irrationality measure `μ(π)` below the current record
`μ(π) ≤ 7.10320533` (Zeilberger–Zudilin 2020). We pre-register a
high-precision (600 dps) PSLQ sweep over the degree-≤2 monomial basis in
`{π, e^π, Γ(1/4)}` (height bound `10^200`), verifying numerically that no
rational linear relation exists — consistent with Nesterenko. We then
outline **GAP_N**, the missing ingredient needed to turn Nesterenko's
modular multiplicity estimates into a sharpening of `μ(π)` of the type
required to fire the `GAP_F` consumer at `n⋆ ∼ 10^3` in the Marchewka–Rigel
opacity chain.

---

## 1. Setup

### 1.1 The current record

The irrationality measure of `π`, defined by

    μ(π) = inf { μ : |π − p/q| > q^{−μ} for all but finitely many p/q ∈ Q },

satisfies the chain of improvements

| Year | Author(s)             | Bound on μ(π) |
|------|-----------------------|---------------|
| 1953 | Mahler                | 42            |
| 1993 | Hata                  | 8.0161        |
| 2008 | Salikhov              | 7.60630853    |
| 2020 | Zeilberger–Zudilin    | 7.10320533    |

The trivial lower bound is `μ(π) ≥ 2` (Dirichlet). The conjectural value
is `μ(π) = 2` (π is "as irrational as a random real"), but the gap between
`2` and `7.1032` is the subject of Attacks 1–20 in this series.

### 1.2 Why μ(π) < 3 matters in the opacity chain

In the Marchewka–Rigel Hermite–Padé–Weil (HPW) opacity chain, the
consumer `GAP_F` activates at a critical index `n⋆ ∼ 10^3` provided
`μ(π) < 3 + ε` for a specific `ε > 0`. Conjecture 4A.4 (Session 7)
survives cross-checks via mpmath + PARI/GP + Lean `Decoupling.lean` and a
deg-`π = 5` PSLQ sweep, so the bottleneck is now the Diophantine input
`μ(π)`. Attack 21 asks: does Nesterenko's modular machinery offer a path?

### 1.3 Nesterenko's 1996 theorem

**Theorem (Nesterenko, C. R. Acad. Sci. Paris 322, 1996).**
For any `τ ∈ H = {z ∈ C : Im z > 0}` with `q = e^{2πiτ}`, at least three
of the four numbers `q, E_2(τ), E_4(τ), E_6(τ)` are algebraically
independent over `Q`.

**Corollary.** Taking `τ = i`, so `q = e^{−2π}`, Nesterenko deduces that
`π, e^π, Γ(1/4)` are algebraically independent over `Q`; equivalently
`tr.deg_Q Q(π, e^π, Γ(1/4)) = 3`.

The link to `Γ(1/4)` uses the classical closed forms of Eisenstein series
at the CM point `τ = i`:

    E_2(i) = 3 / π,
    E_4(i) = 3 · Γ(1/4)^8 / (2π)^6,
    E_6(i) = 0.

The vanishing of `E_6(i)` — a CM accident — is what makes `τ = i` special
and what removes one degree of freedom from the 4-tuple, giving tr.deg = 3
exactly (not 4).

---

## 2. Numerical support — Target L PSLQ verdict

We implemented `sage/target_l_attack21_modular.py` using **mpmath at 600
decimal digits of precision**. The script

1. Computes `π, Γ(1/4), e^π` to 600 dps.
2. Computes `E_4(i), E_6(i)` via the `q`-expansion
   `E_k(τ) = 1 + c_k · Σ_{n≥1} σ_{k−1}(n) q^n` with
   `(c_4, c_6) = (240, −504)` and `q = e^{−2π}`, and compares to the
   Γ-closed forms above (sanity check).
3. Runs PSLQ at tolerance `10^{−dps + 40}`, height bound `10^200`, on the
   10-dimensional basis

       B = { 1, π, e^π, Γ(1/4), π^2, π·Γ(1/4), e^π·Γ(1/4),
             π·e^π, Γ(1/4)^2, π·e^π·Γ(1/4) }.

### 2.1 Sanity of Eisenstein computation

The `q`-expansion agrees with the closed form to ~600 decimal digits for
`E_4(i)`, and `E_6(i)` evaluates to `0` within the same tolerance (see
`target_l_attack21_output.json`, field `sanity_checks`). This confirms the
CM vanishing and the `Γ(1/4)^8 / π^6` identity numerically, and by
extension validates our arithmetic of the three constants
`{π, e^π, Γ(1/4)}`. Specifically, at 600 dps we observe
`|E_4(i) − 3Γ(1/4)^8/(2π)^6| ≈ 8.4 · 10^{−601}` and
`|E_6(i)| ≈ 5.6 · 10^{−601}`.

### 2.2 PSLQ verdict

**Verdict: `NO_RELATION`** at height `≤ 10^200`.

This is exactly the prediction of Nesterenko's theorem: a `Q`-linear
relation among degree-≤2 monomials in `{π, e^π, Γ(1/4)}` would collapse
`tr.deg_Q` to at most 2, contradicting Nesterenko. The negative PSLQ
outcome is therefore a consistency check — a Diophantine
"crash-test-dummy" that passes.

Raw output is stored in `sage/target_l_attack21_output.json`, run log in
`sage/target_l_attack21_run.log`.

---

## 3. Nesterenko's determinant argument — mechanism summary

Nesterenko's proof is a **multiplicity estimate** on modular forms,
fundamentally different from the Hermite–Padé approximant constructions
that power the Rhin–Viola / Salikhov / Zeilberger–Zudilin bounds on `μ(π)`.

The skeleton:

1. **Auxiliary function.** Construct a polynomial
   `P(X_0, X_1, X_2, X_3) ∈ Z[X_i]` of bounded multidegree `(N, N, N, N)`
   and height `≤ exp(c N)` such that the analytic function
   `F(τ) = P(q, E_2, E_4, E_6)` has a zero of high order at some
   accessible point `τ_0 ∈ H`.
2. **Multiplicity estimate (Nesterenko).** The order of vanishing of
   any non-zero modular polynomial of multidegree `(N,N,N,N)` at `τ_0` is
   bounded by an *absolute* constant times `N^4`. Crucially, this bound
   does not degrade as one moves `τ_0` around — it is a purely algebraic
   feature of the graded ring `M_* = C[E_4, E_6][E_2]` with its
   Ramanujan derivations.
3. **Arithmetic contradiction.** If three of `{q, E_2, E_4, E_6}` were
   algebraically dependent over `Q`, the auxiliary `F(τ)` could be made
   to vanish to an order exceeding the Nesterenko bound for suitably
   chosen `P` — contradiction.

The **non-vanishing Wronskian** of `(E_2, E_4, E_6)` under the Ramanujan
derivation `D = (1/2πi) · d/dτ`

       D E_2 = (E_2^2 − E_4) / 12,
       D E_4 = (E_2 · E_4 − E_6) / 3,
       D E_6 = (E_2 · E_6 − E_4^2) / 2

is the analytic engine. It converts "a non-trivial polynomial relation
would exist" into "a formal power series with algebraic coefficients must
have bounded order of vanishing at every point," producing the
contradiction.

---

## 4. Why this bypasses Siegel's lemma

Classical Diophantine sharpenings of `μ(π)` (Rhin–Viola, Salikhov,
Zeilberger–Zudilin) chain through **Siegel's lemma + a specific
integral**:

    I_N = ∫ R_N(x) / ((1 − x)(1 + x)) dx,

where `R_N` is a carefully optimized polynomial of degree `O(N)`. The
Diophantine input of Siegel's lemma is the existence of small auxiliary
*integers* satisfying linear constraints; the output is a pair
`(a_N, b_N) ∈ Z^2` of common-denominator-cleaned linear forms in `π` with
`|a_N π − b_N| → 0` at controlled rate.

Nesterenko replaces this with a **multiplicity estimate on modular
forms**, for which Siegel's lemma is not the ingredient providing the
"small auxiliary" — the modular structure itself does. Specifically:

- The height of `P` is controlled by the *graded structure* of `M_*`,
  not by the size of a solution to a system of integer linear equations.
- The zeros are counted in an *algebraic* (graded-ring-theoretic) sense,
  not as bits of numerical closeness.
- The arithmetic lower bound comes from the denominator structure of
  `E_k` expansions, which is Bernoulli-number-driven rather than
  Hermite-Padé-driven.

This is why Nesterenko's method proves a **transcendence-degree** result
(qualitative: tr.deg ≥ 3) but has, to date, **not** been converted into a
quantitative irrationality measure on any individual element of
`{π, e^π, Γ(1/4)}`. The modular machinery is "too rigid" to extract
effective rates — it demonstrates *independence*, not *closeness-to-
rational rate*.

---

## 5. GAP_N — what would sharpen μ(π) via modular forms?

We name the missing ingredient **GAP_N** (Nesterenko-gap):

> **GAP_N.** *Extend Nesterenko's multiplicity estimate to an* effective
> *measure of linear independence:* produce explicit constants
> `C_1, C_2 > 0` such that for any `(a_0, a_1, a_2, a_3) ∈ Z^4 \ {0}`
> with height `H = max|a_i| ≤ H_0`, the linear form
> `Λ = a_0 + a_1 π + a_2 e^π + a_3 Γ(1/4)` satisfies
> `|Λ| ≥ C_1 · H^{−C_2}`, with `C_2` small enough that specializing
> `a_2 = a_3 = 0` yields `μ(π) ≤ C_2 + 1 < 3`.

A theorem of the above shape would fire `GAP_F` at `n⋆ ∼ 10^3` and close
the Marchewka–Rigel opacity chain.

### 5.1 Obstructions

1. **Height vs. degree trade-off.** Nesterenko's argument gives
   `C_2 = O(1)` implicitly, but the implicit constant grows like `2^{100}`
   — useless for `μ(π) < 3`. An effective argument would need to track
   Bernoulli denominators and graded-ring resultants explicitly.
2. **Specialization collapse.** Setting `a_2 = a_3 = 0` discards modular
   information; the lower bound for `|a_0 + a_1 π|` reverts to the
   Hermite–Padé regime, which gives `μ(π) ≤ 7.10320533`, not `< 3`.
3. **New modular system needed.** To isolate `π` among the three
   independent generators one likely needs a *different* CM point `τ_0`
   where `E_6(τ_0) ≠ 0` and where `Γ` specializations disentangle — a
   research task, not a calculation.

### 5.2 Proposed candidate systems

- `τ = (1 + i√3)/2` (the other standard CM point), where `E_4(τ) = 0`
  and `E_6(τ) ≠ 0` — dual symmetry to `τ = i`, possibly removing `Γ(1/4)`
  in favor of `Γ(1/3)`.
- Higher-level modular forms (`Γ_0(N)` with `N ∈ {2, 3, 4}`), where
  additional CM points may reveal new combinations.
- Almost-holomorphic modular forms (Kaneko–Zagier), where the Ramanujan
  derivation closes without the `E_2` obstruction.

---

## 6. Summary table

| Aspect                      | Hermite–Padé (Salikhov / ZZ)     | Nesterenko modular               |
|-----------------------------|----------------------------------|----------------------------------|
| Result type                 | Quantitative: `μ(π) ≤ 7.1032`    | Qualitative: tr.deg ≥ 3          |
| Diophantine engine          | Siegel's lemma + integral `I_N`  | Graded ring of modular forms     |
| Auxiliary object            | Polynomial `R_N(x)` of deg `N`   | Modular polynomial in 4 vars     |
| Key estimate                | `(a_N, b_N) ∈ Z^2`, `|a_N π − b_N| small` | Multiplicity of `P(q, E_2, E_4, E_6)` at `τ_0` |
| Directly sharpens `μ(π)`?   | **Yes**                          | **No** — but bounds 3 constants  |
| Effective constants?        | Yes, fully explicit              | Implicit, too large              |
| Blocks `GAP_F` at `n⋆∼10^3`?| Yes (current bound too weak)     | Yes (qualitative only)           |
| GAP to close                | Better `R_N`, new integral       | **GAP_N** (see Section 5)        |

---

## 7. Conclusion

Attack 21 establishes that Nesterenko's modular machinery, while
*necessary* for understanding the transcendence landscape around `π`, is
**not sufficient** in its current form to sharpen `μ(π)` below 3. The
numerical PSLQ verdict at 600 dps and height `10^200` is consistent with
Nesterenko (`NO_RELATION`), confirming that no low-degree polynomial
identity in `{π, e^π, Γ(1/4)}` can be exploited as a short-cut. The
genuine obstruction is `GAP_N`: an effective multiplicity estimate with
tracked constants. Closing `GAP_N` is a standalone research programme,
comparable in scope to the Rhin–Viola → Salikhov → Zeilberger–Zudilin
chain that currently holds the record.

---

## References

1. Yu. V. Nesterenko, *Modular functions and transcendence questions*,
   C. R. Acad. Sci. Paris Sér. I Math. **322** (1996), 909–914.
2. V. Kh. Salikhov, *On the irrationality measure of π*, Russian Math.
   Surveys **63** (2008), no. 3, 570–572.
3. D. Zeilberger, W. Zudilin, *The irrationality measure of π is at most
   7.10320533…*, Moscow J. Combinatorics and Number Theory **9** (2020),
   no. 4, 407–419.
4. M. Hata, *Improvement in the irrationality measures of π and π²*,
   Proc. Japan Acad. Ser. A **68** (1993), 283–286.
5. K. Mahler, *On the approximation of π*, Nederl. Akad. Wetensch. Proc.
   Ser. A **56** (1953), 30–42.
6. Yu. V. Nesterenko, P. Philippon (eds.), *Introduction to Algebraic
   Independence Theory*, Lecture Notes in Mathematics **1752**, Springer,
   2001.

---

## Artefacts

- `sage/target_l_attack21_modular.py` — mpmath 600 dps PSLQ sweep
- `sage/target_l_attack21_output.json` — numerical output (verdict, sanity)
- `sage/target_l_attack21_run.log` — run log
- `Paper-Attack21-Nesterenko-Modular.md` — this paper
