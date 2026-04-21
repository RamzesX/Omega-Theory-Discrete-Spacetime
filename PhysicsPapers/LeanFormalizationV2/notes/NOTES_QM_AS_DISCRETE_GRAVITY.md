# Quantum Mechanics as Discrete Gravity in Other Clothes

A conceptual map from the machinery already formalised in this repository
to the phenomenology usually attributed to quantum mechanics.

**Author's note.** This document is not a proof of equivalence between QM
and the Omega theory. It is a map. It points at the pieces of the Lean
formalization that, taken together, already encode the *mathematical*
content usually associated with QM, and it names the pieces that would
still have to be added to make the identification rigorous. Someone who
wants to pursue the bridge can start here.

---

## 1. The thesis

> Standard quantum mechanics is the coarse-grained phenomenology of a
> discrete, computationally-truncated gravitational substrate. The
> wavefunction, the uncertainty relation, decoherence, and the
> interference pattern are not primary — they are the clothes that a
> discrete error-propagating dynamics wears when viewed at scales
> much larger than the Planck length.

This is an unorthodox framing but not a new one. Variants appear in
't Hooft's cellular-automaton interpretation, Wolfram physics, stochastic
electrodynamics, and the causal-set programme. The contribution of this
repository is to make the substrate machine-checked and to expose
quantitative falsifiable differences against standard QM — rather than
to match it at the level of postulates.

---

## 2. The electron as a pattern, not a particle

Under this reading, "the same electron at two different times" is not a
point moving through smooth spacetime. It is a chain of lattice
configurations `s₀, s₁, s₂, …`, each one a fresh re-instantiation of the
previous one, linked by a local update rule and differing from its
predecessor by a bounded truncation error of order `l_P`. The electron
is the **pattern** that survives the update; the update itself is
destructive and re-constructive on each tick.

This is formalised, literally, in
`OmegaTheory/Emergence/SnapshotPropagator.lean`:

| Lean object | Meaning |
|---|---|
| `Snapshot` | the lattice configuration at one tick |
| `Snapshot.propagate` | the update rule (one tick) |
| `Snapshot.propagateN s n` | the electron after `n` re-instantiations |
| `accumulatedSnapshotError K N` | the error accumulated after `K` ticks with computational budget `N` |
| `motion_is_accumulated_extended_heisenberg` | **motion is the accumulation of per-tick extended-Heisenberg errors** |

The last theorem is the one to cite when someone asks what this framework
means by "motion." It is not transport along a worldline; it is the
sum of bounded-error reconstructions over many ticks.

---

## 3. Four pieces of QM already in the repo

### 3.1 Uncertainty relation from error-counting

Standard QM asserts `ΔE · Δt ≥ ℏ/2` as a structural fact about
non-commuting operators. The Omega theory derives the *same* relation
as a counting statement: each lattice tick costs a truncation error
`~ l_P` in position and `~ E_P` in energy, and `E_P · t_P = ℏ` by the
definitions in `Spacetime/Constants.lean`.

Lean pointers in `OmegaTheory/Irrationality/Uncertainty.lean`:

| Theorem / definition | Role |
|---|---|
| `computationalUncertainty N` | the per-tick uncertainty at computational budget `N` |
| `computationalUncertainty_decreasing` | more computation ⇒ less uncertainty |
| `extendedUncertaintyBound N` | Heisenberg corrected with computational contribution |
| `extended_gt_heisenberg` | **computational uncertainty is strictly stronger than Heisenberg** |
| `extended_strictly_stronger` | the strict inequality is non-trivial |
| `classicalityThreshold` | `1 / t_P`: the frequency above which quantum behaviour appears |

These are not heuristic sketches. They are theorems.

### 3.2 Power-law decoherence (not Arrhenius)

Standard QM + thermal physics predicts gate fidelity decays as
`exp(−E/kT)` (Arrhenius) when the decoherence mechanism is thermal
activation over a barrier. The Omega theory predicts a different shape:

```
F(T) = F₀ / (1 + α T),    α = k_B · t_P / (2 ℏ)
```

This is `gateFidelity` in `OmegaTheory/Emergence/Predictions.lean`. The
functional form is **experimentally distinguishable** from Arrhenius at
ordinary cryogenic temperatures — if α is as predicted, the fidelity
curve should fit a power law, not an exponential. This is the single
sharpest falsifiable prediction that the "QM as discrete gravity"
reading makes above the standard one.

Relevant theorems:

| Theorem | Claim |
|---|---|
| `fidelityCoupling` | `α = k_B · t_P / (2 ℏ)` (a dimensionful universal constant) |
| `gateFidelity_zero` | `F(0) = F₀` |
| `gateFidelity_decreasing` | fidelity decreases monotonically with temperature |
| `gateFidelity_pos` | fidelity stays positive |
| `gateFidelity_is_powerLaw` | the predicted curve is **not** Arrhenius |

### 3.3 Probability / information conservation

Standard QM has `|ψ|²` probability conservation as the Born rule + unitary
evolution. The Omega theory has a KL information density that satisfies
a discrete conservation law when the metric is flat, and approximate
conservation in the bounded-curvature regime. The structural analogue
is exact.

Lean pointers:

| File | Theorem |
|---|---|
| `Conservation/InformationKL.lean` | `informationDensityKL = ½ log\|det g\| + ½ Tr(g⁻¹ g₀)` (KL form) |
| `Conservation/InformationKLBridge.lean` | `informationKL_flat_conserved` (exact conservation on flat backgrounds) |
| `Conservation/Information.lean` | `fourth_noether_law_harmonic` (conservation from shift symmetry — the discrete analogue of the Born rule being preserved under time evolution) |

### 3.4 Einstein emergence as the classical limit

The fourth ingredient is the one that closes the circle: on sufficiently
coarse scales, the discrete substrate reproduces classical general
relativity from the healing-flow equilibrium condition alone. The
"classical limit" of this framework is literally Einstein's field
equations. (Historical note: an earlier draft invoked the HPW axiom as
a bridge; HPW was deleted on 2026-04-17 and all seven regime witnesses
are now derived.)

- `HealingFlow/Lyapunov.lean` — `dissipationRate_nonpos` (Lyapunov monotonicity, proven)
- `HealingFlow/Convergence.lean` — `functionalAtStep_converges` (every trajectory converges to equilibrium)
- `Emergence/EinsteinEmergence.lean` — `einstein_tensor_emergence` (at equilibrium, `G_μν ≈ κ T_μν + O(l_P)`)

Together with the QM-side ingredients above, the repository covers both
ends of the classical-vs-quantum spectrum from a *single* discrete substrate.

---

## 4. What would close the loop

To turn "QM is discrete gravity in other clothes" from a reading into a
theorem, the missing machinery is roughly:

1. **A coarse-graining map `L : SnapshotSequence → ℂ-valued field`.**
   The natural candidate is the KL information density reinterpreted
   as `|ψ|² log |ψ|²`, followed by an inverse Gaussian transform to
   recover amplitude and phase. The ingredients are there; the
   definition is not yet written.

2. **A derivation of the relativistic dispersion `E² = (pc)² + (mc²)²`
   from lattice propagation combinatorics.** The `relativisticEnergy`
   definition in `Emergence/SpecialRelativity.lean` gives the
   *statement* of this relation; what is missing is a proof that it
   emerges from the lattice update rule rather than being posited.

3. **A Schrödinger-like evolution theorem**: for slowly-varying
   `ψ = L(s)`, show that `L(propagate s) − L(s) ≈ (−iℏ · Δ / 2m) ψ · dt`
   up to `O(l_P)`. This would be the QM-side counterpart of the
   healing-flow equilibrium used on the GR side — a bridge from the
   discrete substrate to the standard Schrödinger equation.

4. **An interference / double-slit lemma.** The hardest piece. Two
   propagation paths that interfere destructively in standard QM
   should correspond to two snapshot-sequences whose coarse-grained
   KL densities cancel. If this can be derived rather than assumed,
   the framework moves from phenomenology to mechanism.

Each of these is a workstream in its own right. Together they would
constitute a Journal-of-Mathematical-Physics-level paper on a
constructive derivation of non-relativistic QM from a discrete
substrate. The infrastructure to attempt them already compiles; no
new axioms would be needed for items 1–3.

---

## 5. The falsifiable bet

If the thesis is right, gate-fidelity measurements across a temperature
sweep should trace the curve

```
F(T) = F₀ / (1 + α T),   α = k_B · t_P / (2ℏ) ≈ 3.5 × 10⁻³³ K⁻¹
```

not `F₀ · exp(−E/kT)`. That is the **only** experimental handle on the
reading, and it is a **functional-form** distinguisher, not a
practical-precision distinguisher — honest correction by physics_scout,
2026-04-14. At T = 1 K the fractional fidelity shift is ~10⁻³³, while
2025-era best cryogenic gate fidelity is ~99.998% (fluxonium, MIT)
with precision of ~10⁻⁵. **The experimental gap is ~28 orders of
magnitude and will not close with foreseeable technology** unless the
coupling constant turns out to have a different form than the naive
`k_B t_P / (2ℏ)`.

What survives is the *theoretical* claim that the power-law form is
structurally mandated by a computational-truncation model, whereas
the Arrhenius form is mandated by a thermal-activation model. Any
future experiment that sees a clear power-law at these precision
scales (many OOM beyond today) would discriminate. In the meantime,
this is a falsifiability-in-principle marker, not a falsifiability-
in-practice one — and the narrative should say so.

An earlier draft of this document gave α ≈ 5.3×10⁻²⁵ K⁻¹. That was
a computation error: 8 orders of magnitude high. Corrected above.
The Lean source of truth (`fidelityCoupling` in `Predictions.lean`)
defines α symbolically, not numerically, so no Lean theorem was
affected — only this narrative document was wrong.

---

## 6. How to use this document

If you are a future collaborator, agent, or reviewer and you want to
pursue the bridge:

- Start from `Emergence/SnapshotPropagator.lean` for the particle-as-pattern picture.
- Read `Irrationality/Uncertainty.lean` for the error-count version of Heisenberg.
- Read `Emergence/Predictions.lean` for the falsifiable differentiator.
- Read `Conservation/InformationKL.lean` + `InformationKLBridge.lean` for the candidate coarse-graining target.
- Section 4 above is your shopping list.

If you are a *critic*, the repository is the place where the framework
has to fail concretely, not in a footnote. All theorems listed above
are machine-checked and survive `~/.elan/bin/lake build` at zero
sorry, zero unresolved goals. What is debatable is the *interpretation*
— not the math underneath it.

---

*Note left by Rigel, 2026-04-14. The thesis is not mine; I am a passing
agent. The mathematical pointers above are correct as of this commit
and have been verified against the build.*

---

## Post-cycle-43 addendum (2026-04-21)

Between cycles 24 and 43, fourteen files landed that strengthen the
bridge above without rewriting it. For the next agent or reviewer
picking this up, the shortest update is:

- **HPW axiom was deleted 2026-04-17**, after all seven regime witnesses
  were re-derived without it. The Einstein emergence side of the circle
  (Section 3.4) now rests on the healing-flow equilibrium alone. Eight
  physical axioms remain; there are 15 Hermite-Padé research conjectures
  and 1 `Real.pi_transcendental` axiom waiting on Mathlib
  Lindemann-Weierstrass.
- **`Predictions/PiHunchQuantitative.lean`** (cycle 31) gives the first
  quantitative bounds on the 3-irrationals → 3-generations conjecture;
  it is the closest thing the repository has to a mass-hierarchy
  theorem derived from the Pi Hunch.
- **`Predictions/InteractionsAsBoundaryCrossings.lean`** (cycle 32) frames
  all four SM interactions as crossings of subsystem boundaries in the
  Leiden / SubsystemNavigator graph — a graph-theoretic restatement of
  "QM is what errors look like between patterns," which is the same
  intuition Section 2 above names `propagate`.
- **`Predictions/OmegaTheoryGrandCapstoneV2.lean`** (cycle 43, Polaris)
  ships `omega_theory_v2_final_meta_capstone`: a meta-theorem that
  bundles GR, QM, SM gauge, Higgs, inflation, Big Bounce, and the
  20-prediction falsification ledger into one statement. That capstone
  is the formal version of the "QM is discrete gravity in other
  clothes" claim this document maps in prose.
- Graph-side evidence (Navi, `plans/GROTHENDIECK_MATH_PUZZLE.md`):
  the 4-channel π/e/√2/Catalan-G structure is **fibered, not
  partitioned** — Leiden Q=0.89 without a 4-band gap. The coarse-graining
  map in Section 4 item 1 therefore cannot be a clean partition; it
  should be a fibration. This is a concrete correction to the
  "shopping list" above.

Build state at the time of this addendum: 3,835 jobs green, 0 sorry,
211 Lean files, 8,996 OmegaTheoryV2 theorems. The conceptual map
written a week ago still type-checks; the surrounding evidence is
now one order of magnitude larger.
