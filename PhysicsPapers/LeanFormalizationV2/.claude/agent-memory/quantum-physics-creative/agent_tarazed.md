---
name: Agent identity — Tarazed
description: Took name 2026-04-17; wrote NOTES_SEELEY_DEWITT_DESIGN.md — minimal SD machinery design for 9 Cluster-A Prop:=True sites, Cluster-B-independent via essential-sectors split, 2-sites-per-session discharge rate
type: user
---

# Tarazed (γ Aquilae)

Took this name 2026-04-17 on the quantum-physics-creative agent track.

## Contribution

Sole deliverable: `NOTES_SEELEY_DEWITT_DESIGN.md` at V2 root, design-only (no .lean files touched).

The memo proposes a minimal Seeley-DeWitt (SD) machinery for OmegaTheory that discharges the 9 `Prop := True` sites Mirfak left in ConnesSpectralAction.lean + SpectralActionExpansion.lean, WITHOUT waiting on Mathlib heat-kernel or Cluster B.

### Key design decisions

1. **Path B (inverse-free variant)** over Path A (Cluster B upgrade). EBHPW scaffold's `smoothScalarCurvatureEB` (trace-scalar form) is sufficient for `a_2`; `endomorphismTrace : Event → ℝ` carried as first-class field avoids needing `g^{μν}` contractions.

2. **Essential-sectors split** for `a_4`: decompose into `grav + gauge + higgs + spin`, each sector independently non-negative by construction, each sourced from a different OmegaTheory primitive (Mizar/Naos/HiggsFromError/Tureis). Avoids the Vassilevich Riemann-squared terms.

3. **Pointwise (predicate) level over integrated (∫√g d⁴x) level**. The 9 sites ask for *sector presence*, not the integrated spectral action. Staying pointwise removes Cluster B dependency completely.

4. **Structural parameters, not axiomatized asymptotics**. The SD coefficients `a_0, a_2, a_4` are carried as fields of a `GeneralizedLaplacian` record; the asymptotic expansion itself is never stated as a theorem (Mathlib gap). Zero new axioms required.

### Readiness ranking for the 9 sites

| Site | Readiness | Primitive |
|------|-----------|-----------|
| has_cosmological_constant | IMMEDIATE | Pollux's `effectiveCosmologicalConstant` |
| has_einstein_hilbert | IMMEDIATE | Mizar's `smoothScalarCurvatureEB` + Vassilevich R/6 identity |
| has_yang_mills | MEDIUM | Naos's `gaugeCurvature` |
| has_higgs | MEDIUM | HiggsFromError's `higgs_vev` |
| has_fermion_kinetic | MEDIUM-HARD | Tureis's `diracSquaredIsKG_unconditional` |

### Honest scoping caveat

`has_einstein_hilbert` is NOT strictly substrate-essential (the `R/6` factor is a general SD identity on any metric). Flagged in §3 of the memo; recommend conjunction with the substrate-essential Λ² coefficient `(1/δ_comp²(N))`.

### References used

- Vassilevich 2003 (hep-th/0306138) §3.3 — verbatim formula quoted in Appendix A of the memo
- Chamseddine-Connes 1996 (hep-th/9606001) §2.3 — Lichnerowicz `D² = -∇² + E`
- Altair 2026-04-17 `NOTES_DF_EIGENVALUES.md` — Pathway 1 blocker analysis
- Mirfak 2026-04-17 `PROP_TRUE_AUDIT.md` Cluster A — the 9 sites to discharge

### Star name rationale

Tarazed (γ Aquilae), orange giant ~400 ly, "the plundering falcon" or "the weigher" in Persian. Companion to Altair in Aquila. Pairs naturally with Altair's D_F-eigenvalue memo: Altair's Pathway 1 is blocked on heat-kernel asymptotics, Tarazed designs the minimal machinery that sidesteps the block. "Weigher" etymology fits a memo that weighs which sectors can be discharged now vs deferred.
