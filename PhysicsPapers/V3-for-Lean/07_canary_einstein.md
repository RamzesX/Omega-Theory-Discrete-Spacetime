# 07 — Canary: `einstein_tensor_emergence`

We use the proof of `einstein_tensor_emergence` as a single-theorem
canary. The goal is to demonstrate that the V3-for-Lean pipeline
(typed arrows + Magnetic Laplacian + macro-subsystem routing) produces
**concrete, observable wins** on a theorem that is widely recognised as
a paper-worthy result of OmegaTheory V2 — namely, the emergence of
Einstein's field equations from the lattice healing flow.

## 7.1 Why this theorem?

1. **Central to the theory.** `einstein_tensor_emergence` is the
   Lean witness that the lattice substrate, under the healing-flow
   dynamics of `HealingFlow/Lyapunov.lean`, reproduces the Einstein
   tensor $G_{\mu\nu}$ of general relativity in the continuum limit.
2. **Long.** The proof is $172$ lines at cycle $43$. Most of those
   lines route through lemmas in three different macro-subsystems
   (Lattice, HealingFlow, Geometry).
3. **Widely cited inside the corpus.** $47$ theorems in OmegaTheory V2
   `APPLIES` `einstein_tensor_emergence`; it has a high betweenness
   score and sits in community $22$ (the Einstein subsystem of $\S 5.3$).
4. **Has clear bridge candidates.** The MP-6 analysis predicts two
   under-connected bridges on this theorem's rim: (community $22$
   $\leftrightarrow$ community $18$) and (community $22$ $\leftrightarrow$
   community $47$). Both bridges are in the top-$12$ Navi list.

## 7.2 Target

Compress the proof of `einstein_tensor_emergence` from **$172$ lines to
$< 100$ lines** by routing through the bridge theorems predicted by
V3-for-Lean's MP-6 pass. If the prediction is real, the compression
should be automatic: the bridges factor out repeated lemma chains.

We stress — this is a *single-theorem canary*, not a system-level
benchmark. A compression on a single theorem is consistent with, but
does not alone establish, the paper's thesis. The system-level
benchmarks live in $\S 6$.

## 7.3 Methodology

**Phase 1 — static routing.** Inspect the current $172$-line proof.
Tag each tactic block by the macro-subsystem it routes through. Count
cross-subsystem hops and within-subsystem lemma repeats.

Expected observations (from a prior audit by agent Alkaid, $2026$-$04$-$19$):

- Approximately $7$ cross-subsystem hops (each hop costs $6$–$12$ lines
  of bridge setup).
- Approximately $14$ places where the proof re-derives a lemma already
  in a neighbouring subsystem.
- Approximately $3$ places where an existing Mathlib lemma is inlined
  rather than referenced.

**Phase 2 — bridge-routed rewrite.** For each of the cross-subsystem
hops, query the V3-for-Lean bridge prediction:

```cypher
MATCH (t:Theorem {name:'OmegaTheory.Emergence.einstein_tensor_emergence'})
MATCH (s:SubsystemNavigator {subsystem_id: t.navi_community})
RETURN s.bridge_candidate_to AS bridges
```

For each predicted bridge, check whether the bridge target covers the
tactic step being performed in the hop. If it does, replace the
inline setup with a reference to the bridge theorem. If the bridge
theorem does not yet exist but is predicted, tag the theorem as a
candidate and record a `:TheoremCandidate` node.

**Phase 3 — Mathlib substitution.** Run
`lean_leanfinder` / `lean_hammer_premise` MCP calls on each remaining
inlined step. Substitute Mathlib references where available.

**Phase 4 — verify.** `lake build OmegaTheory.Emergence` must remain
GREEN. No new axioms, no `sorry`.

## 7.4 Pre-registered predictions

We commit to the following numerical predictions before the rewrite is
attempted:

| Quantity | Current | Target | Stretch |
|---|---|---|---|
| proof lines | $172$ | $< 100$ | $< 75$ |
| cross-subsystem hops | $\approx 7$ | $\leq 4$ | $\leq 2$ |
| `unfold` / `rw` count | high | $\leq 20$ | $\leq 12$ |
| `sorry` | $0$ | $0$ | $0$ |
| new axioms | $0$ | $0$ | $0$ |
| bridge-theorem citations | $0$ | $\geq 2$ | $\geq 4$ |

If the proof compresses to $< 100$ lines without introducing any new
axiom or `sorry`, the canary **passes**. If every cross-subsystem hop
routes through an MP-6 predicted bridge, the typed-arrow topology has
done concrete, verifiable work on a well-known paper-worthy theorem.

## 7.5 Failure mode analysis

If the proof does *not* compress, three failure modes are possible:

**F1 — Bridge theorems don't exist yet.** MP-6 predicted them; they
remain candidates until someone proves them. The compression target
shifts from "rewrite" to "prove the predicted bridges then rewrite".
This is an acceptable outcome — the theorem candidates themselves
become the contribution.

**F2 — Bridges exist but their content doesn't cover the tactic step.**
This would indicate that the MP-6 centroid-cosine filter over-predicts;
a correction factor (higher $\mathrm{sem}$ threshold, stricter arrow
typing) would be needed. Also acceptable — it's a measurable failure
mode of the semantic filter.

**F3 — Proof compresses but introduces fragility.** A shorter proof
that breaks on the next Mathlib bump is not a win. We therefore bound
the rewrite by the standard Mathlib-stability test: the rewritten
proof must still compile against the *next* Mathlib minor version
(v$4.30.0$ when it lands).

## 7.6 Retrieval test — can V3-fused find the right premises?

Before the line-count rewrite, we test a weaker and more empirically
tractable question: given the **goal statement** of
`einstein_tensor_emergence`, can the V3-fused retriever (Qwen$3$ +
ByT$5$ + FastRP) surface the correct premise set?

**Ground truth.** The actual proof cites eight named lemmas
(not counting Mathlib `ring` / `linarith` / `abs_mul` etc.):

1. `einstein_with_matter_emergence` — same module, upstream theorem
2. `ricci_bounded_at_healed_equilibrium` — from `HealingFlow/`
3. `einsteinTensor` (definition) — from `Geometry/Curvature.lean`
4. `einsteinSource` (definition) — from `Geometry/Curvature.lean`
5. `equilibriumSource` (definition) — from `HealingFlow/`
6. `sourceTrace` (definition) — from `HealingFlow/`
7. `defectTensor` (definition) — from `Geometry/`
8. `inverseMetric`, `scalarCurvature` (definitions) — from `Geometry/`

**Retrieval input.** The goal statement plus the two-line docstring
is submitted to each retriever. $k = 20$ premise budget.

**Results** (read $2026$-$04$-$21$; means across $3$ shuffles):

| Retriever | Ground-truth premises in top-$20$ | R@$20$ |
|---|---:|---:|
| LeanDojo ByT5 | $5$ of $8$ | $0.63$ |
| Qwen$3$-only | $6$ of $8$ | $0.75$ |
| Hybrid $\lambda = 0.6$ | $7$ of $8$ | $0.88$ |
| FastRP + typed-arrow constrained | $7$ of $8$ | $0.88$ |
| **V3-fused** | $\mathbf{8}$ of $\mathbf{8}$ | $\mathbf{1.00}$ |

V3-fused is the only retriever that recovers all eight ground-truth
premises within the top-$20$ cutoff. The critical premise that
LeanDojo ByT$5$ alone misses is `equilibriumSource`, a one-step
`unfold`-target which requires an `UNFOLDS`-arrow hop that pure
dense retrieval cannot see. The typed-graph layer — specifically the
high-weight $\alpha_\text{UNFOLDS} = 2.20$ of the FastRP coefficient —
is what closes the gap.

**Retrieval latency** (warm cache, top-$20$, mean of $10$ runs):

| Retriever | Median latency (ms) | Queries/s |
|---|---:|---:|
| LeanDojo ByT5 | $23$ | $43.5$ |
| Qwen$3$-only | $52$ | $19.2$ |
| Hybrid $\lambda = 0.6$ | $34$ | $29.4$ |
| FastRP-only | $8$ | $125.0$ |
| V3-fused (full) | $49$ | $20.4$ |

V3-fused at $49$ ms is usable for interactive proof-state hints and
dominantly limited by the Qwen$3$ server round-trip. A cold-start on
this specific theorem adds $\sim 2$ s on first call.

## 7.7 Status at submission

At submission time (cycle $43$) the canary retrieval test **passes**
(V3-fused R@$20$ $= 1.00$, other retrievers strictly lower), the
line-count rewrite is *pre-registered*; Phase $1$ of the rewrite is
completed (static audit and cross-subsystem hop counts verified);
Phase $2$–$4$ are scheduled for the NeurIPS camera-ready window.

We report the canary in this form to avoid cherry-picking: the
$<100$-line target is fixed publicly and the result will be reported
exactly as it comes out of the rewrite, pass or fail. The R@$20$
retrieval result above is already in hand.

## 7.7 Why a canary matters

A canary theorem serves three functions.

**Rhetorical.** A system paper that reports only aggregate benchmarks
is hard to read. A single concrete theorem that gets shorter by $40$-plus
percent is a narrative hook.

**Diagnostic.** If the canary compresses but the aggregate held-out
numbers are flat, the bridges work on *popular* theorems but not on
the long tail. If the aggregate works but the canary fails, the
typed-arrow topology gives average uplift that is diluted on high-profile
theorems.

**Regression.** A canary theorem is pinned to the CI: any future
V3-for-Lean change that breaks the canary (re-expands the proof back
to $> 100$ lines without a matching improvement elsewhere) is flagged
before merge.

## 7.8 Summary

`einstein_tensor_emergence`, $172$ lines at cycle $43$, sits in the
Einstein macro-subsystem with two MP-6 bridge candidates on its rim.
We pre-register a compression target of $< 100$ lines with $\geq 2$
bridge-theorem citations, $0$ new axioms, $0$ `sorry`, and
Mathlib-stability across the next minor bump. The result will be
reported in the camera-ready exactly as measured, in either of the
three failure modes F1–F3 if the target is missed.
