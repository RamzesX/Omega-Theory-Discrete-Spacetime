# 05 — Catalan's constant G: the OPEN PROBLEM

## Honest status

`G := Σ (−1)ⁿ / (2n+1)² ≈ 0.9159655941772190…` is the **only one of the four OmegaTheory irrationals whose irrationality itself is not proven**. Zudilin (2019, Abh. Math. Sem. Univ. Hamburg 89:45): *"Catalan's constant is arguably the most basic constant whose irrationality, and transcendence, though strongly suspected, remain unproven."*

This memo sets out (a) what IS known, (b) what is conjectural, (c) what OmegaTheory assumes, and (d) how we classify our assumption in the graph.

## What IS known (2026-04-21)

| Property | Value / status | Citation |
|---|---|---|
| Series representation | `G = Σ (−1)ⁿ (2n+1)⁻²` | Catalan 1865 |
| Numerical value | ≈ 0.91596559417721901505… | routine |
| Value of `β(s)` at s=2 where β = Dirichlet beta | definitional | — |
| In rational function field? | not directly stated, but `G` not known rational | — |
| Irrational? | **OPEN** | — |
| Transcendental? | **OPEN** (stronger than irrational, would follow from Mahler S-number membership) | — |
| Best known qualitative result | at least one of `β(2), β(4), …, β(14)` is irrational, and infinitely many of `β(2n)` are irrational | Rivoal–Zudilin 2003 |
| Best known quantitative approximation | Hermite-Padé-style: `dim_ℚ ⟨1, β(2), β(4), …, β(2k)⟩ ≥ c log k / log log k` | Rivoal–Zudilin 2010s |
| Conjectured irrationality measure | μ(G) = 2 (heuristic, empirical) | — |
| Conjectured Mahler class | S-number, if transcendental | — |

## What OmegaTheory assumes

In `Predictions/SterileNeutrinoFromFourthIrrational.lean` and `Emergence/ConnesCalibrationAndFourChannels.lean`, G is used as a truncation-error source for the sterile-neutrino / DM channel. The key quantitative properties consumed are:

1. G > 0 (trivial, follows from alternating-series lower bound).
2. Truncation rate `catalanGTruncError(N) = O(1/(2N+1)²)`, already proved in `catalanGTruncError_O_one_over_N_squared`.
3. G ≠ π, G ≠ e, G ≠ √2, G ≠ any rational we happen to meet — **used for the 4-channel distinction in `channelToGeneration4_catalan_g_eq_three`**.

Item 3 is where the irrationality hypothesis enters:

- G ≠ π follows from numerical bounds (G ≈ 0.916, π ≈ 3.14159, disjoint). Easy.
- G ≠ e similar (e ≈ 2.718). Easy.
- G ≠ √2 (√2 ≈ 1.414). Easy.
- G ≠ any specific rational OmegaTheory names: as long as that rational is *not* 0.91596… exact, easy by decimal bound.
- **G not rational in general** = OPEN classical problem. We don't currently USE this in the Lean corpus — we only need pairwise distinctness from *specific* named reals. So OmegaTheory's current corpus DOES NOT assume G irrational at the Lean level.

But at the **physical-interpretation level** — the 4-channel partition carrying 4 distinct substrate signatures — the claim is that G is *qualitatively* different from a rational. If G turned out rational, the sterile-neutrino channel would collapse into one of the "rational lattice" slots (most likely the √2 or e-adjacent ones, via Connes-DF spectral action degeneracy). This is a physics falsification criterion: a day-1 demonstration that G ∈ ℚ would falsify OmegaTheory's 4-channel structure.

## The Rivoal–Zudilin partial-irrationality tower

The strongest current results on Dirichlet β-values closely parallel the odd-zeta results:

**Theorem (Ball–Rivoal 2001).** `dim_ℚ ⟨1, ζ(3), ζ(5), …, ζ(2k+1)⟩ ≥ (log k) / (1 + log 2) + o(1)`.

**Theorem (Rivoal–Zudilin 2003, Math. Ann. 326:705-721).** For Dirichlet β:
(i) `dim_ℚ ⟨1, β(2), β(4), …, β(2k)⟩ ≥ c · log k / log log k` for some c > 0;
(ii) Infinitely many β(2n) are irrational;
(iii) At least one of β(2), β(4), β(6), β(8), β(10), β(12), β(14) is irrational.

Note what (iii) does NOT say: it does not identify WHICH one. β(2) = G, so the statement is consistent with G being rational and β(4), …, β(14) carrying the irrationality.

**Heuristic evidence.** Empirical computation of continued fractions for G shows no Liouville-like partial-quotient blow-ups; Khinchin-level statistics look "generic", consistent with μ(G) = 2. But heuristic is not proof.

## What Lean needs from us

### Short-term (this cycle, statement-only)
1. `catalan_G_irrationality_conjecture : Prop` — the bare statement `Irrational G`, declared as `def` (not axiom), for citation.
2. `catalan_G_transcendence_conjecture : Prop` — same for `Transcendental ℚ G`.
3. `rivoal_zudilin_2003 : Prop` — statement of the known theorem; potentially an axiom pending Mathlib port.

### Medium-term (research-frontier)
4. A port of Rivoal–Zudilin 2003 would give us the qualitative result "∞-many β(2n) irrational" without singling out G. Effort: probably 60+ sessions, needs Padé-approximant infrastructure and specific construction.

### Long-term (classical open problem)
5. Proof of `Irrational G` itself. No credible path in 2026. The best attempts use:
- Hypergeometric Nesterenko-style constructions.
- Modular-forms approaches (Yang et al 2022).
- Contour-integral "Beukers-type" constructions tied to `K(k)` elliptic integrals.

None of these has reached the threshold `δ_N > 0` over a sharp enough denominator to prove irrationality.

## Classification decision for OmegaTheory

We register G with the following status in the graph:

```
:TheoremCandidate {
  name: 'catalan_G_irrationality_conjecture',
  namespace: 'OmegaTheoryV2',
  status: 'CONJECTURAL',                  -- classically open
  class_target: 'Mahler S-number',         -- what we'd want if we could prove it
  difficulty: 'open_problem',              -- not in any theorem prover
  mathlib_gap: ['Rivoal-Zudilin 2003', 'Beukers K-integrals', 'Irrationality']
}
```

## Counter-factual: if G is rational

A 2-sentence summary of what breaks:
- 4-channel partition reduces to 3-channel. `channelToGeneration4_catalan_g_eq_three` would still type-check in Lean (it's a data bijection, not a structural claim about G being transcendental), but the *physics interpretation* that G-channel carries a sterile-ν distinct from the other three loses force: we'd need a different 4th constant.
- Backup 4th constants: ζ(3) Apéry (proved irrational 1978); γ Euler–Mascheroni (irrationality OPEN but conjectured); ln 2 Gauss (irrational, transcendental via Lindemann–Weierstrass).

Cycle 27 (Hydor) consciously picked Catalan G over these because its truncation rate `O(1/(2N+1)²)` — quadratic — is nicely intermediate between √2 (super-exp) and e (factorial) at fixed N. ζ(3) is alternating-like and has a less clean truncation; γ is barely known.

## Action items (summary)

| # | Task | Sessions | Blocker |
|---|---|---|---|
| 1 | Statement-level `catalan_G_irrationality_conjecture` in Lean | 1 | none |
| 2 | Wire to existing `catalanGTruncError` framework | 2 | none |
| 3 | Port Rivoal–Zudilin 2003 qualitative result | 60+ | Hermite-Padé in Mathlib |
| 4 | Prove `Irrational G` | ∞ (open problem) | classical mathematics |

Items 1–2 go into `:TheoremCandidate` register. Items 3–4 flagged as blocked/open.
