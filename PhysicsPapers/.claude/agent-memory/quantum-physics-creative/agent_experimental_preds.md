---
name: Agent identity — experimental-preds
description: Took task 2026-04-19 to formalize W1 / ILL-VCN / DESI experimental predictions; shipped 3 files + 1059 lines GREEN
type: project
---

## Agent: experimental-preds (2026-04-19)

### Mission
Formalize three falsifiable experimental predictions:
1. W1 — Neutrino mass floor from δ_comp (Connes-sector coupling)
2. ILL-VCN — Ackermann 2026 cold-neutron test (arXiv:2604.09312)
3. DESI — dark-energy w(z) running from healing-flow residual

### Result: GREEN
3 files shipped (1059 lines), 0 sorry, 0 new axioms, full `lake build` 3640 jobs GREEN.

**Why:** All three predictions needed a Pierre-Auger-style "consistent-with-experiment-for-sufficiently-large-N" theorem, plus a distinguisher from competing models (LV, quintessence). This pattern is well-established in OmegaTheory (see `GammaRayDispersion.lean`, `UHECRDispersion.lean`).

**How to apply:** When adding experimental-preds files in the future:
- Copy the `Predictions/GammaRayDispersion.lean` skeleton as template
- Always include: (a) positivity, (b) decreasing-in-N, (c) below-any-positive-bound (Archimedean), (d) distinguisher vs alt model
- For numerical eV predictions, use `Spacetime.UnitConversions` as unit bridge; don't add numerical axioms for c, ℏ, G_N
- `unfold_let` is NOT a standard tactic — use plain `let` or just substitute values directly

### Key files
- `OmegaTheory/Predictions/NeutrinoMassFloorW1.lean` (286 L) — W1 with Connes coupling f_ν
- `OmegaTheory/Predictions/ColdNeutronILL_VCN.lean` (355 L) — ILL cold-neutron ε(N) = 4/(2N+3)
- `OmegaTheory/Predictions/DESISubstrateSignature.lean` (418 L) — w(z) = -1 + δ_comp(N)·z/(1+z)

### Neo4j Prediction nodes updated
- `W1_NeutrinoMassFloor`: FORMALIZED → `W1_consistent_with_DESI`
- `ILL_VCN_ColdNeutron`: FORMALIZED → `coldNeutronSubstrate_consistent_with_Ackermann_2026`
- `DESI_SubstrateSignature`: FORMALIZED → `DESI_substrate_consistent_uniform`

### Honest caveats
1. **f_ν (W1) is a free positive parameter**, not derived from first principles — specific eV fit awaits Connes D_F eigenvalue machinery (see `NOTES_DF_EIGENVALUES.md`, Altair 2026-04-17).
2. **ε_substrate(N, z) for DESI in SI numerics is ~10⁻⁵⁵** — trivially below DESI's 5% bound. If DESI's tentative w≠-1 hint crystallises, OmegaTheory needs ~30 orders-of-magnitude enhancement (matter-sector coupling? error in iterationBudget(T) extrapolation?).
3. **T_ILL → N_ILL mapping requires numerical c, ℏ, G_N** — which V2 deliberately doesn't have (8-axiom invariant).

All three files produce Pierre-Auger-style consistency theorems ("there exists N₀ such that for all N ≥ N₀..."), which is the strongest form of consistency provable without numerical axioms.
