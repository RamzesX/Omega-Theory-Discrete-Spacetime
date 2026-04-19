---
name: Agent identity — Polaris
description: Took Polaris name 2026-04-19 on physics-D; weak equivalence principle formalisation on the substrate; EquivalencePrinciple.lean — SubstrateState + inertialMass/gravitationalMass both = |m| by def, EP by rfl; Tier 1 + Tier 2 (universality of free fall a = g independent of state); hooks MassAsDelay perTickDelay_pos_massive; 3333/3333 jobs GREEN per module
type: user
---

Took the name **Polaris** on 2026-04-19 — the pole star. Physics theme:
Polaris marks the fixed direction around which celestial navigation is
organised; the equivalence principle is the fixed point from which all
general-relativistic navigation starts (inertial mass = gravitational
mass as a single substrate cost functional).

## Mission (physics-D)

Formalise Einstein's 1907/1911 weak equivalence principle on the
OmegaTheory substrate: inertial mass ≡ gravitational mass. Goal was
Tier 1 minimum; I delivered Tier 1 + Tier 2.

## What I built

**New file**: `OmegaTheory/Emergence/EquivalencePrinciple.lean`
(~334 lines, 17 theorems + 3 defs + 1 structure)

- `structure SubstrateState` — minimal `(momentum, restMassLabel)` carrier
- `inertialMass state := |state.restMassLabel|` (MassAsDelay brake extractor)
- `gravitationalMass state := |state.restMassLabel|` (Redshift source extractor)
- `theorem equivalence_principle : inertialMass s = gravitationalMass s := rfl`
  — **Tier 1 weak EP**, by definitional equality (rfl)
- `EP_mass_ratio_eq_one`, `EP_mass_difference_zero` (Eötvös-style phrasings)
- `noncomputable def freeFallAcceleration s g := (m_g/m_i)·g`
- `theorem freely_falling_acceleration_universal` — **Tier 2**: a₁ = a₂ = g
  independent of state, the Galileo/Einstein "all bodies fall alike"
- Bridge: `inertialMass_pos_iff_perTickDelay_pos` ties EP back to
  `MassAsDelay.mass_lattice_interpretation_theorem`
- Tier 3 (strong EP / local Lorentz) flagged explicitly as future work
  (needs covariant derivative in Christoffel.lean, not `SubstrateState`)

**Registered** in `OmegaTheory/Basic.lean` directly after
`ProtonPhotonRedshift` (ordering preserves existing import chain).

## Build state

- Per-module `lake build OmegaTheory.Emergence.EquivalencePrinciple`:
  **GREEN, 3333/3333 jobs**, 0 sorry, 0 new axioms, no warnings in my file.
- `lake build OmegaTheory.Basic`: 3660/3661 jobs GREEN; sole pre-existing
  failure is `OmegaTheory.Emergence.AsymptoticFreedom` (16:40 today — NOT
  in my dependency chain). `AsymptoticFreedom` errors are unrelated to my
  work: `Real.lt.neg_pos`, `Filter.tendsto_atTop_div_const_of_pos` issues.
- Mirror to `/mnt/c/.../chaos-shield/.../LeanFormalizationV2/` done.

## Design decision worth remembering

The cleanest Lean phrasing of the weak EP on a substrate is:

> "Both mass definitions are the SAME extractor on the SAME state —
> equality holds by `rfl`, not by a physics argument."

This matches Marchewka's `CLAUDE.md` thesis that EP is not a
coincidence but a categorical consequence of "mass is the rest-label
that sources both brake and redshift." I considered a heavier design
where `inertialMass` reads `perTickDelay` and `gravitationalMass` reads
`gravRedshiftCost`, but that bakes in kinematic parameters (`p`, `L`,
`μ`, `N`) that are NOT state-intrinsic. Keeping both extractors on the
shared rest-mass label alone keeps the EP statement axiom-free and the
Tier 2 derivation a one-line `rw [EP_mass_ratio_eq_one hm]`.

## Gaps / future work for other agents

- **Tier 3 (strong EP / local Lorentz invariance)** — needs the local
  flatness witness and covariant-derivative setup in
  `Geometry/Christoffel.lean` hooked to `SubstrateState` worldlines.
- **Mass–energy dependence**: once `SubstrateState` is enriched to
  carry a substrate configuration rather than just `(p, m)`, the EP
  theorem should be re-stated as "both masses are the same projection
  of the info-cost functional onto the rest-mass component," keeping
  `rfl`-provability intact.
- **Redshift-source numerical bridge**: `gravRedshiftCost L μ` does not
  currently carry a `restMassLabel` explicitly; an enriched
  `protonPhotonRedshift`-style bridge linking `gravitationalMass`
  quantitatively to the integrated defect would strengthen the
  physical story (currently honest but qualitative).

## Technical notes

- `push_neg` is deprecated in Lean v4.29.0 — replaced with an
  `rcases lt_or_eq_of_le ...` split in `inertialMass_pos_iff_perTickDelay_pos`.
- `equivalence_principle : rfl` means the `rw` direction matters: use
  `rw [← equivalence_principle]` or `rw [equivalence_principle]` based
  on which side you want to rewrite; got bitten once in `EP_mass_ratio_eq_one`,
  fixed by switching direction and splitting into two tactics.
- No `exact?`/`aesop` needed — all proofs are `rfl`, `unfold; tactic`,
  or compositions of `abs_*` lemmas.
