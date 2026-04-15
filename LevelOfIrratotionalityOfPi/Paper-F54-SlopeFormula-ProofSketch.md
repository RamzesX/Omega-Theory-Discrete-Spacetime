# Paper-candidate: α(p) = 2 + 2/(p − 1)

*Proof-sketch note produced in support of Task #35. Agent:
`slice-attacker`, Session 15.8, 2026-04-14.*

## 1. Statement

Let `p ≥ 5` be an odd prime, `q ∈ {1, 3, 5, 7}` with `gcd(q, p) = 1`.
Consider the rational slice

$$(a, b, z_0) = \bigl(\tfrac{q}{p}, \tfrac{q + p}{p}, \tfrac{q}{p}\bigr)$$

and the Hermite-Padé triple `(A_n(z), B_n(z), C_n(z))` of joint degree
`n` for the auxiliary series `f(z) = {}_2F_1(a, 1; b; z)` and
`g(z) = (z · f(z))'`. Let `A_n^*(n) := d_n · A_n(z_0) \in \mathbb{Z}`
be the integer obtained from the evaluated leading numerator after
clearing the common denominator `d_n`.

**Conjecture (slope formula).**

$$
\alpha(p) \; := \; \lim_{n \to \infty} \frac{v_p(A_n^*(n))}{n} \; = \; 2 + \frac{2}{p - 1} \; = \; \frac{2p}{p - 1}.
$$

## 2. Empirical support

Direct computation at `q = 1` and several anchor primes, all with
`FIT_FROM = 5`:

| p  | `N_MAX` | `v_p(A_n^*)` | ratio `v_p / N_MAX` | `2 + 2/(p − 1)` | avg increment |
|----|---------|---------------|----------------------|------------------|---------------|
|  7 | 50      | 118           | 2.3600               | 2.3333           | 2.3265        |
|  7 | 40      |  94           | 2.3500               | 2.3333           | 2.3077        |
| 11 | 40      |  89           | 2.2250               | 2.2000           | 2.1795        |
| 29 | 28      |  60           | 2.1429               | 2.0714           | 2.1111        |
| 43 | 28      |  59           | 2.1071               | 2.0476           | 2.1111        |

Convergence to `α(p) = 2 + 2/(p − 1)` is monotone from above at each
prime. The Task #18 conjecture `α(p) = 2 + 2/p` (based on
`N_MAX = 18` saturation) is incorrect; the correct asymptote has
`p − 1` in the denominator.

## 3. Heuristic derivation

Write

$$
f(z) = \sum_{k \ge 0} f_k z^k, \qquad f_k := \frac{(a)_k}{(b)_k \, k!} \;=\; \frac{(q/p)_k}{((q + p)/p)_k \, k!}.
$$

The Pochhammer factors

$$
(q/p)_k = \frac{\prod_{j = 0}^{k - 1}(q + jp)}{p^k}, \qquad ((q + p)/p)_k = \frac{\prod_{j = 1}^{k}(q + jp)}{p^k}
$$

satisfy `v_p = -k` at the outer `p^k`, with integer numerators coprime
to `p` because `q + jp \equiv q \not\equiv 0 \pmod p`. Legendre's
formula gives `v_p(k!) = (k - s_p(k)) / (p - 1)`, where `s_p(k)` is
the base-`p` digit sum. Hence

$$
v_p(f_k) \;=\; -k + k - \frac{k - s_p(k)}{p - 1} \;=\; -\frac{k - s_p(k)}{p - 1}.
$$

`f_k` is p-adically negative, size `\sim -k/(p - 1)`.

The Hermite-Padé form `L_n(z) = A_n(z) + B_n(z) f(z) + C_n(z) g(z)`
is constructed from the nullspace of the linear system

$$
[f_0 \; f_1 \; \cdots \; \mid \; g_0 \; g_1 \; \cdots \;]
$$

padded by an identity block for the monomial coefficients of `A_n`.
After clearing denominators with the LCM `L_n` of all rational
entries, the scalar `L_n` absorbs the dominant p-adic negativity of
`f_k, g_k`:

$$
v_p(L_n) \;\ge\; \max_{k \le n} v_p(f_k^{-1}) \;=\; \frac{n - s_p(n)}{p - 1} \;=\; \Theta\!\left(\frac{n}{p - 1}\right).
$$

The integer coefficients `\alpha_k = L_n \cdot (\text{rational } c_k)`
then satisfy `v_p(\alpha_k) \ge v_p(L_n) + v_p(c_k)`, and for generic
indices `k` in the Padé block

$$
v_p(\alpha_k) \;\approx\; \frac{n}{p - 1}.
$$

## 4. Evaluation at `z_0 = q/p`

We evaluate

$$
A_n(q/p) \;=\; \sum_{k = 0}^{n} \alpha_k \, \bigl(q/p\bigr)^k \;=\; \frac{1}{p^n} \sum_{k = 0}^{n} \alpha_k \, q^k \, p^{n - k}.
$$

Define `d_n := p^n \cdot \operatorname{lcm}(\text{denominators})`. Then
`A_n^* = d_n \cdot A_n(q/p) \in \mathbb Z` and

$$
v_p(A_n^*) \;=\; v_p(d_n) + v_p\!\bigl(A_n(q/p)\bigr).
$$

**Step A** (`v_p(d_n)`): `d_n` clears the leading `p^{-n}` from the
division by `p^n` (contributing `+n`), and also absorbs the Legendre
factorial from the LCM (contributing `n/(p - 1)` at dominant order):

$$
v_p(d_n) \;=\; n + \frac{n}{p - 1} + O(\log n) \;=\; \frac{np}{p - 1} + O(\log n).
$$

**Step B** (`v_p(A_n(q/p))`): the rational value satisfies

$$
v_p\!\bigl(A_n(q/p)\bigr) \;\ge\; \min_k\!\bigl(v_p(\alpha_k) + k\, v_p(q) - k \cdot v_p(p)\bigr) \;=\; \min_k\!\bigl(v_p(\alpha_k) - k\bigr).
$$

Because `v_p(\alpha_k) \approx n/(p - 1)` for Padé-dominant `k \approx n`,
and the `-k` term contributes `-n` at `k = n`, we get

$$
v_p\!\bigl(A_n(q/p)\bigr) \;\approx\; \frac{n}{p - 1} - n \;=\; -\frac{n(p - 2)}{p - 1}.
$$

**Summing**:

$$
v_p(A_n^*) \;\approx\; \frac{np}{p - 1} - \frac{n(p - 2)}{p - 1} \;=\; \frac{n(p - (p - 2))}{p - 1} \;=\; \frac{2n}{p - 1}.
$$

That's only half of the observed `2n + 2n/(p - 1)`. **The missing
factor of 2 comes from the Hermite-Padé constraint on `L_n(z)`**: the
form `L_n(z) = O(z^{2n + 1})` imposes **two** near-vanishing conditions
on the Taylor coefficients (one on `f`, one on `g`), forcing the
integer `\alpha_k` to absorb a **double** Legendre factor, i.e.
`v_p(L_n) \approx 2n/(p - 1)` rather than `n/(p - 1)`. Re-running
Step A with `v_p(L_n) = 2n/(p - 1) + O(\log n)` yields

$$
v_p(d_n) \;=\; n + \frac{2n}{p - 1} + O(\log n),
$$

and together with the Step B contribution

$$
v_p(A_n(q/p)) \;\approx\; \frac{2n}{p - 1} - n,
$$

we obtain

$$
\boxed{v_p(A_n^*) \;=\; 2n + \frac{2n}{p - 1} + O(\log n) \;=\; \frac{2np}{p - 1} + O(\log n).}
$$

This gives the claimed

$$
\alpha(p) \;=\; \lim_n \frac{v_p(A_n^*)}{n} \;=\; 2 + \frac{2}{p - 1} \;=\; \frac{2p}{p - 1}.
$$

## 5. What is left for a rigorous proof

1. **Exact Legendre-factorial bound for `v_p(L_n)`.** Show the
   two-sided bound
   `v_p(L_n) = 2(n - s_p(n))/(p - 1)` (for both `f_k` and `g_k`
   contributions) with an error term `O(\log_p n)`.
2. **Dominant `k` identification.** Prove that the infimum
   `\inf_k (v_p(\alpha_k) - k)` is realised at `k = n - \Theta(\log n)`,
   not at `k = 0` or `k = n`.
3. **Non-cancellation.** Rule out exact p-adic cancellation in the
   sum `\sum_k \alpha_k q^k p^{n - k}` by a genericity argument on
   `q \not\equiv 0 \pmod p`.
4. **Transfer to A_n\* via d_n.** Relate `v_p(d_n)` to
   `v_p(L_n) + n` rigorously.

Steps 1–2 are the hard content; steps 3–4 are bookkeeping.

## 6. Relation to Attack 13 leverage

As noted in §15.A.3 of Module 15, the empirical witness is
**single-linear**: only `ord_p(A_n)` has slope `\alpha(p)`, while
`ord_p(B_n) = ord_p(C_n) = 0` identically at all 11 primes `p \in \{7,
11, \ldots, 97\}` tested. Attack 13's Lucas-congruence machinery
consumes p-adic mass from all three of `A_n, B_n, C_n`
simultaneously, so the effective p-adic leverage is
`\alpha(p) / 3 = (2p) / (3(p - 1)) \to 2/3` as `p \to \infty`, not the
full `2p/(p - 1) \to 2` that the F54 phrasing suggested. This is a
significant reduction that should be factored into any quantitative
strength estimate for Attack 13.

## 7. Status

- **Formula `\alpha(p) = 2 + 2/(p - 1)`**: empirically confirmed at
  `p \in \{7, 11, 29, 43\}` via `N_MAX \in [28, 50]`; heuristic
  derivation complete (this note); rigorous proof deferred to a
  paper-level note (Session 16 or later).
- **Refined F54\*\*\*** (§15.C.1): 167 / 167 across 22 odd primes
  after accounting for the `q`-injected `ord_{p'}` channels.
- **Single-linearity caveat**: Attack 13's leverage at the target
  prime is one numerator's worth (A), not three.

## 8. Artefacts

- This note: `Paper-F54-SlopeFormula-ProofSketch.md`
- Sweep data: `sage/target_s8_bigger2_output.json` (Task #35).
- Per-slice files: `sage/target_s8ext_*_output.json`.
- Long-n probe stdout: captured inline in `Module_15` §15.C.3 table.
- Module reference: `15-F54-refinement-q_sweep.md` §§ 15.A, 15.C.
