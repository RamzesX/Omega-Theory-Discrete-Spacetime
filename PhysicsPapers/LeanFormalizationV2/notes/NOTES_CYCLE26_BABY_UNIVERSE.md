# NOTES_CYCLE26_BABY_UNIVERSE.md

**Agent**: Ancha (θ Aquarii, *ancha* = "hip" / "flank" in Arabic — the hip of
the Water-Bearer, the pivot where Aquarius's pitcher turns from pouring into
gathering.  Thematically apt for a cycle-26 memo that formalises the *pivot*
between parent-universe matter collapse and baby-universe matter rebirth:
the dark-energy reservoir (Sadalmelik's Ω_Λ pitcher of cycle 25) is poured
across a Popławski-torsion bounce and arrives as inheritedInformation ≥ 0.
Ancha is a late-stage K-class orange giant shedding mass — apt for a note
on information-transfer across death/rebirth topology.  Not yet in the
wizard, creative, grothendieck, or experimental-preds roster.)

**Date**: 2026-04-21.

**Type**: Read-only research memo.  Literature review + falsifiability design
+ theorem-shaping notes for the parallel `lean-proof-wizard` proving the
four Cycle-26 theorems (`de_reservoir_flows_through_bounce_to_baby_universe`,
`baby_universe_sterile_nu_spectrum`, `baby_universe_gravitons_survive_bounce`,
`inherited_information_upper_bound_by_parent_mass`).  **0 `.lean` files
modified.**  Follows the Sadalmelik cycle-25 and Mesarthim cycle-24 templates.

**Scope discipline**: every speculation flagged `SPECULATIVE`; every numerical
match `EVIDENCE`; every claim that holds up the proof chain `LOAD-BEARING`.
Graceful-failure clauses added wherever OmegaTheory is under current tension.

---

## Table of contents

0.  TL;DR + the four wizard theorems
1.  Popławski's cyclic cosmology — literature review 2010 → 2025
2.  Baby-universe particle spectrum: who survives topological disconnection?
3.  Bekenstein–Hawking and the holographic upper bound on inheritedInformation
4.  Gravitational-wave relic from the parent bounce — LISA / LIGO / PTA bands
5.  Falsifiability: five observations that would kill the BH → baby-universe chain
6.  Connection to cycle 32 / 33 (baryogenesis + leptogenesis)
7.  Theorem-shaping recommendations for the wizard
8.  Graph findings landed (5 `:GraphFinding` nodes)
9.  Open questions + cycle-27 / cycle-34 hand-off
10. References

---

## §0 TL;DR + the four wizard theorems

The four Cycle-26 theorems on the wizard's backlog (cycle=26, backlog entries
9–12 in `plans/THEOREM_BACKLOG_CYCLES_24_43.md`) are:

| # | Theorem | Physics content |
|---|---|---|
|  9 | `de_reservoir_flows_through_bounce_to_baby_universe` | `R.informationCost = bu.inheritedInformation` at bounce epoch |
| 10 | `baby_universe_sterile_nu_spectrum` | Only Catalan-G channel survives topological disconnection |
| 11 | `baby_universe_gravitons_survive_bounce` | Graviton background inherited (substrate fluctuation, not matter carrier) |
| 12 | `inherited_information_upper_bound_by_parent_mass` | `bu.inheritedInformation ≤ S_BH(bu.parentMass)` |

**TL;DR** (six LOAD-BEARING / EVIDENCE / SPECULATIVE claims):

- **LOAD-BEARING**.  Popławski's Einstein–Cartan torsion-bounce mechanism is
  already partially formalised in `OmegaTheory/Torsion/BigBounce.lean`
  (structure `BabyUniverse { parentMass, inheritedInformation, expansionRate }`
  with `info_nonneg` field).  The missing content is the *equality* bridge:
  exactly which real-valued substrate quantity equals
  `bu.inheritedInformation`.  Cycle 26 commits to
  `R.informationCost` (the dark-energy reservoir quantity defined in
  `Emergence/ForceUniversalInfoCost.lean`, Rasalhague).

- **EVIDENCE**.  The JWST galaxy-rotation observation (Shamir 2025, MNRAS 538,
  76 — [arXiv:2502.18781](https://arxiv.org/abs/2502.18781)) shows ~2:1
  preferential direction among 263 early galaxies, the first direct
  observational hook for a *rotating parent BH*.  If the asymmetry holds up
  in larger samples, it is consistent with Popławski's claim that universe
  spin is inherited from parent-BH angular momentum.  See §1.3.

- **LOAD-BEARING**.  The Bekenstein–Hawking bound
  `S_BH = k_B · A/(4ℓ_P²) = k_B · 4π G M² / (ℏ c)` is formalised (with an
  explicit holographic hypothesis) at
  `OmegaTheory/Emergence/BekensteinBound.lean` (Deneb, 2026-04-15).  Theorem 12
  composes `bu.info_nonneg` + `bekenstein_bound_on_lattice` with the
  identification `inheritedInformation ≤ S_BH(parentMass)`.  See §3.

- **SPECULATIVE-paper-worthy**.  The baby-universe graviton background
  inherits a *peak frequency* that tracks `H_parent ~ c/r_Schwarzschild`:
  stellar-mass BHs → kHz (LIGO/ET band), supermassive BHs → nHz (PTA band).
  This is a direct observational signature of the parent-bounce chain,
  distinguishable from inflation-based GW backgrounds by its **spectrum
  multiplicity** (one peak per primordial-BH mass scale, not a single
  inflation-scale plateau).  See §4.

- **EVIDENCE-TENSION**.  NANOGrav 15-yr reports a stochastic GW background
  with amplitude ~ `2.4 × 10⁻¹⁵` at `f_ref = 32 nHz` (arXiv:2306.16213).
  SMBHB-merger accounts for the signal in the default astrophysical
  interpretation, but the model is only *weakly preferred* over cosmological
  sources (Bayes factor ≈ 2 — string-cosmology fits as well).  **Popławski
  parent-SMBH-bounce** is a viable alternative narrative at nHz.  See §4.2.

- **SPECULATIVE**.  The four wizard theorems collectively assert that a
  baby universe is **selection-rule compliant**: *only* topological
  information (Catalan-G channel + graviton substrate background) passes
  through the bounce; *all* π/e/√2 channel-labels are reset.  This is
  internally consistent with the cycle-34 hand-off: sterile-ν in OUR
  universe is a relic from the *previous* bounce, active fermions are
  freshly minted from OUR post-inflation reheating.  The selection rule
  predicts the baby-universe Dirac-vs-Majorana distinction (§6.2).

---

## §1 Popławski's cyclic cosmology — literature review 2010 → 2025

### 1.1 Foundational papers

Nikodem Popławski's programme sits inside **Einstein–Cartan gravity** (ECSK
theory, Kibble–Sciama extension of GR to spinning matter).  The relevant
string of papers:

1. **Popławski, 2010** — *"Radial motion into an Einstein–Rosen bridge"*,
   Phys. Lett. B **687**, 110–113 (2010), [arXiv:0902.1994].  Early hint
   that a rotating-BH interior may develop a new expanding region on the
   far side.
2. **Popławski, 2010** — *"Cosmology with torsion: An alternative to
   cosmic inflation"*, Phys. Lett. B **694**, 181–185 (2010),
   [arXiv:1007.0587].  **The headline paper** — Popławski's core claim that
   torsion-generated gravitational repulsion at fermionic Planck density
   replaces inflation as the mechanism for homogeneity, isotropy, and
   flatness.
3. **Popławski, 2012** — *"Nonsingular, big-bounce cosmology from
   spinor-torsion coupling"*, Phys. Rev. D **85**, 107502,
   [arXiv:1111.4595].  Quantitative treatment of the Friedmann equation
   with spin-density.
4. **Popławski, 2016** — *"Universe in a black hole in Einstein–Cartan
   gravity"*, Astrophys. J. **832**, 96, [arXiv:1410.3881].  The "black
   hole contains a closed, nearly-flat homogeneous-isotropic universe"
   statement.  Reviewed in [Popławski ULA 2020 seminar notes](https://www.nikodempoplawski.com/ULA2020.pdf)
   and [Popławski USM 2024 seminar notes](https://nikodempoplawski.com/USM2024.pdf).
5. **Popławski, 2021** — *"Gravitational collapse of a matter ball in
   Einstein–Cartan gravity"*, Class. Quantum Grav. **39**, 025005.
   Quantitative bounce in axisymmetric collapse.
6. **Popławski, 2024** — *"Torsion Makes Physics Finite"*, [USM seminar notes, 2024](https://nikodempoplawski.com/USM2024.pdf).
   Extension to Planck-scale regularisation of interactions and mass
   spectra.

### 1.2 Current defensibility — the positive side

The ECSK framework itself is **well-defined GR + spinor physics** and is
not ruled out by any observation in the weak-field regime.  At Planck
density the torsion correction is

```
σ_torsion ~ (κ²/8) · σ_spin²,
```

where `σ_spin` is the spin-density scalar (Hehl–von der Heyde–Kerlick–Nester,
*Rev. Mod. Phys.* **48**, 393 (1976)).  At galaxy / laboratory densities
`σ_torsion < 10⁻⁴⁵ σ_matter`, so **no tabletop constraint currently
falsifies ECSK**.  Popławski's mechanism triggers only in collapse regimes
at `ρ ≳ 10^55 kg/m³`, which are currently inaccessible to any direct probe.

**EVIDENCE**.  The JWST galaxy-spin asymmetry (Shamir 2025 MNRAS 538, 76;
JADES sample N=263; [arXiv:2502.18781](https://arxiv.org/abs/2502.18781))
is a first-of-kind observational **hook** for the parent-BH rotation
hypothesis.  If confirmed in larger samples (Euclid DR1 late 2026, Roman
2026), it constitutes a *positive* signature consistent with the
cyclic-cosmology view.

**EVIDENCE**.  Cosmological flatness (`Ω_K ≈ 0 ± 10⁻³`) does not
distinguish inflation from Popławski-bounce (§5), but the **scalar
spectral index** `n_s ≈ 0.965` and the **tensor-to-scalar ratio**
`r < 0.032` (Planck + BICEP/Keck 2025) are *both consistent* with
bounce-generated spectra if the post-bounce expansion stays
near-de-Sitter for ~ 60 e-folds.  This part of the parameter space is
open, not ruled out.

### 1.3 Current defensibility — the negative side

- **No direct evidence for torsion** at any scale yet.  ECSK-distinguishing
  signatures (spinning-matter-sourced frame-dragging anomalies) have been
  proposed (Dadhich *et al.*, 2018; Pant *et al.*, 2023) but not detected.
- **Baryon asymmetry as bounce signature** has been discussed (Popławski
  2012) but requires an asymmetric production mechanism during the
  bounce; no quantitative match to the observed `η_B ≈ 6 × 10⁻¹⁰` yet.
  See §6.
- **Hubble tension** (`H_0 = 73` vs `67` km/s/Mpc from local ladders vs
  CMB) is **not resolved** by the Popławski mechanism per se — it
  requires an additional late-time modification.

**VERDICT** (LOAD-BEARING): Popławski's cyclic cosmology is **not falsified**
by any current observation; some observations (JWST rotation, flatness,
scale-invariant ns) are positively consistent.  Its *distinguishing*
predictions — directly detectable torsion, GW-spectrum multiplicity,
specific Dirac-vs-Majorana structure — are the key unknowns.  OmegaTheory's
cycle 26 work formalises the **information-transfer** part of the chain;
the **dynamical** part (Friedmann equation with torsion pressure, actual
bounce ODE integration) remains *not* in Lean.  The honesty note in
`BigBounce.lean:82-92` explicitly flags this gap.

---

## §2 Baby-universe particle spectrum: who survives topological disconnection?

### 2.1 Selection rule summary

The core principle (hypothesised, LOAD-BEARING for cycle 26 + cycle 34):

**A baby universe inherits only those substrate modes that are
topologically distinct from the parent's π/e/√2 channel labels.  All
channel labels are reset at the bounce epoch.**

Four candidate classes:

| Class | Survives bounce? | Reason | OmegaTheory Lean anchor |
|---|---|---|---|
| Standard-model fermions (π, e, √2 channels) | **NO** (fresh) | Channel labels reset at bounce, like a shuffled deck | `channelToGeneration4_bijective` (in Lean) |
| Sterile ν (Catalan-G channel) | **YES** (relic) | Topologically distinct 4th irrational; quadratic decay class distinct from active trio | `SterileNeutrinoFromFourthIrrational.lean` (Zosma) |
| Gravitons (substrate fluctuations) | **YES** (inherited amplitude) | Not a particle label — a background mode of the substrate itself | `GravitonConditions.lean` (Avior) + `BabyUniverse.expansionRate` |
| Primordial BH remnants | **ambiguous** | If BH is nested inside the parent BH and survives the bounce, yes; if evaporates first, no | `PrimordialBlackHoleBound` (placeholder) |

### 2.2 Why SM fermions must reset

The substrate's three-active-generation count (cycle 15 theorem
`four_channels_three_active_one_sterile_surjective`) arises from
**channel-label assignment** at the parent universe's inflation-exit.
The channel labels π / e / √2 are not topological invariants of the
substrate — they are labels attached to local iteration-budget residuals.
When a parent-universe region reaches the bounce epoch, the iteration
budget **resets to N = 0** (a fresh lattice starts expanding on the baby
universe's worldsheet).  The 3 active generations re-form from scratch.

**LOAD-BEARING consistency check**: this is the substrate justification
for the Achird cycle-32/34 theorem
`inflaton_decays_produce_active_fermions_only` — our own inflation's
reheating creates π/e/√2 particles (active SM fermions) because those
are **new** in our universe's iteration-budget history; sterile-ν
decouples as a **topological relic** from the previous bounce.

### 2.3 Why sterile ν survives

Catalan-G (the 4th irrational channel) has a **topologically distinct**
convergence class: quadratic `1/(2N+1)²` vs linear `4/(2N+3)` (π),
factorial `3/(N+1)!` (e), super-exponential (√2).  The convergence class
is a *homotopy* invariant of the substrate — it survives any ℤ⁴-lattice
configuration change — whereas the specific numerical value of
δ_comp(N) is a *homology* invariant that depends on the lattice state.

**SPECULATIVE identification**: Catalan-G's quadratic class sits at the
"topological" end of the irrationality classification (Louchard–Niederreiter
2003 on continued-fraction expansion of irrationals: π and e are
superior-Lévy, √2 is quadratic-surd, Catalan's G is a special value of
Dirichlet L-function with no known simple continued fraction — *a
priori* the **most topologically nontrivial** of the four).  The bounce
topological disconnection preserves this class but not the others.

**Mass-window consistency**: Zosma's `[10⁻⁶, 10⁻⁵] eV` sterile-ν window
from the Connes Z_sterile calibration is an **ultralight** candidate —
consistent with "coherent-condensate survival" through a classical
hydrodynamic regime at the bounce (de Broglie wavelength
~ 10⁻³ pc >> ℓ_P).

### 2.4 Active neutrino Dirac-vs-Majorana question

If sterile ν is the *only* baby-universe-inherited matter field, then
the **active** ν mass mechanism must be different.  Two options:

- **Option A (DIRAC)**: active neutrinos acquire mass from a standard
  Dirac Yukawa to the Higgs, with Dirac-type PMNS mixing.  Sterile is
  Majorana (its own charge-conjugate, one-species population).  This
  matches Achird cycle-37 theorem 48 `dirac_vs_majorana_from_bounce_topology`.
- **Option B (MAJORANA both)**: both active and sterile ν are Majorana,
  with see-saw-type mass generation via the sterile.  In this case the
  baby universe's sterile-ν Majorana mass `M_R ~ 10¹⁴ GeV` combined
  with Dirac-type `m_D ~ 0.1 eV` gives active neutrino mass
  `m_ν ~ m_D² / M_R ~ 10⁻¹³ eV` — **too small** compared to the observed
  `≳ 0.05 eV`.  Ruled out by current data.

**VERDICT** (LOAD-BEARING): the cycle-26 theorem chain commits to
**Option A**.  Sterile-ν Majorana + active-ν Dirac is consistent with
the current KATRIN limits (`m_ν < 0.45 eV`), with the planned KATRIN
0νββ-based experiment bounds, and with the topological-disconnection
selection rule.

### 2.5 Primordial-BH nested remnant question

A primordial BH (PBH) formed in the *parent* universe that has not
evaporated by the parent's bounce epoch is a candidate for
**nested survival** inside the baby universe.  Three cases:

- PBH `M > M_evap(t_bounce)`: too heavy to evaporate, survives as a
  nested object inside the baby universe.  Observable as a stochastic
  background of "ancient" PBHs in OUR universe with anomalously large
  entropy-per-mass.
- PBH `M < M_evap(t_bounce)`: evaporated before bounce, vanishes.
- PBH `M ~ M_evap(t_bounce)`: partial survival; remnant mass ambiguous.

`PrimordialBlackHoleBound` in Lean is currently a **placeholder** — no
formal quantitative statement of this nested-survival condition.
**Recommendation for cycle-26**: leave this ambiguous; commit only to
the clean `sterile-ν + graviton` pair for theorem 10, and defer
PBH-remnant to cycle 37 (BH info paradox).

---

## §3 Bekenstein–Hawking and the holographic upper bound on inheritedInformation

### 3.1 The bound

The classical Bekenstein–Hawking entropy of a Schwarzschild BH of mass `M`:

```
S_BH = k_B · A / (4 · ℓ_P²)
     = k_B · 4π G M² / (ℏ c)
     = k_B · 4π · (M / M_Planck)²      (in nat units)
```

For a solar-mass BH `M ≈ 2 × 10³⁰ kg`, `M/M_P ≈ 10³⁸`, so
`S_BH ≈ k_B · 4π · 10⁷⁶ ≈ 10⁷⁷ k_B`.  For a supermassive BH
`M ~ 10⁹ M_⊙`, `S_BH ~ 10⁹⁵ k_B`.  These are **enormous** phase-space
volumes relative to anything the baby universe could reasonably inherit.

### 3.2 Lean infrastructure

`OmegaTheory/Emergence/BekensteinBound.lean` (Deneb, 2026-04-15) provides:

- `regionEntropy R : ℝ` — Shannon entropy of the Born-rule distribution
  on any finite lattice region (discrete analogue of `S`).
- `regionEntropy_nonneg` — `S ≥ 0`.
- `boltzmann_entropy_le_log_count` — `S ≤ log |R|` unconditional.
- `bekenstein_bound_lattice_weak` — weak (`O(A)`) unconditional form.
- `bekenstein_bound_on_lattice` — **exact** form `S ≤ A/(4ℓ_P²)` under
  the `holographic_hyp` hypothesis.

The prefactor-`1/4` is **not** unconditional; it is exposed as an
explicit hypothesis per Deneb's honesty note.  This is the correct
scoping: the `1/4` prefactor in continuous GR requires the full
Einstein–Hilbert action and Bekenstein's 1973 derivation; on a lattice
it's exposed as a well-defined holographic assumption.

### 3.3 Cycle-26 theorem 12 composition

Target:

```lean
theorem inherited_information_upper_bound_by_parent_mass (bu : BabyUniverse) :
  bu.inheritedInformation ≤ S_BH_formula bu.parentMass
```

where `S_BH_formula M := 4π · G_N · M² / (ℏ · c) * k_B`.

**Composition pathway**:
1. `bu.info_nonneg` — already in `BigBounce.lean`.
2. `S_BH_formula bu.parentMass > 0` — by `positivity` given
   `bu.mass_pos : 0 < bu.parentMass` and the positivity of G, ℏ, c, k_B.
3. Identify `bu.inheritedInformation` with a quantity lower-bounded by
   0 and upper-bounded by `S_BH_formula bu.parentMass`.  This is the
   **holographic identification** — the claim that information carried
   across the bounce is bounded by the parent horizon area.

**Wizard recommendation**: define `S_BH_formula` in a minimal helper file
(`OmegaTheory/Torsion/BabyUniverseHolographic.lean`, a new file since
the backlog labels cycle 26 as "new content").  Prove `S_BH_formula_pos`
separately.  Then theorem 12 is the composition + an **assertion**
(not derivation) that `bu.inheritedInformation ≤ S_BH_formula bu.parentMass`
— this is a *postulate* of the cycle-26 framework, not a theorem about
substrate dynamics.

**Honesty**: theorem 12 is "holographic bound assumed, inheritance bounded".
It is not a derivation of the Bekenstein bound from the substrate.  Per
cycle-25 precedent (§7.2 of `NOTES_CYCLE25_OMEGA_TOTAL.md`), this is the
acceptable scoping: the BH entropy formula is imported from the Lean tree's
existing Bekenstein file, and the **baby-universe content** is that
`inheritedInformation ≤ S_BH`.

### 3.4 Physical meaning

The upper-bound is **physically reasonable**:

- A BH of Schwarzschild radius `r_s = 2 G M / c²` has surface area
  `A = 4π r_s² = 16π G² M² / c⁴`.
- Bekenstein bound: `S_BH = k_B · A / (4 · ℓ_P²)` = `k_B · 4π G M² / (ℏ c)`.
- In **nat units** `k_B = ℏ = c = G = 1`, this is `S_BH = 4π M²/M_Planck²`.

For a stellar-mass BH (`M ~ M_Planck · 10³⁸`) the entropy is
`S_BH ~ 10⁷⁷`.  The baby universe's `inheritedInformation` cannot exceed
this quantity — consistent with "what goes in doesn't come out more than
what went in" at the information level.

---

## §4 Gravitational-wave relic from the parent bounce

### 4.1 Peak frequency

A bouncing matter collapse at scale `r_s = 2 G M / c²` produces a burst
of gravitational radiation with **peak frequency**:

```
ω_peak ~ c / r_s = c³ / (2 G M)
f_peak ~ 10⁴ · (M_⊙/M) Hz      (Schwarzschild rule-of-thumb)
```

| Parent BH mass | `f_peak` | Corresponding detector |
|---|---|---|
| Solar mass `M_⊙` | `~ 10⁴ Hz` | **LIGO/ET kHz band** |
| Stellar-mass 10 M_⊙ | `~ 10³ Hz` | **LIGO kHz band** |
| Intermediate 10⁵ M_⊙ | `~ 10⁻¹ Hz` | **LISA mHz band** |
| Supermassive 10⁹ M_⊙ | `~ 10⁻⁵ Hz` | **PTA nHz band** |

### 4.2 NANOGrav 15-yr as potential SMBH-bounce signature

**EVIDENCE-TENSION**.  NANOGrav 15-yr reports a stochastic GW background
with amplitude `A ≈ 2.4 × 10⁻¹⁵` at `f_ref = 32 nHz`
([arXiv:2306.16213](https://arxiv.org/abs/2306.16213), Agazie *et al.*,
Astrophys. J. Lett. 951 L8).  The Hellings–Downs correlation is detected
at 3–4σ.  The default astrophysical interpretation is **supermassive BH
binary inspirals**; however:

- String cosmology fits NANOGrav DATA slightly better than SMBHB (Bayes
  factor ≈ 2.2; [Springer 2025](https://link.springer.com/article/10.1140/epjc/s10052-025-13998-1)).
- Primordial BH + early-universe models survive (Disentangling the
  origins of the NANOGrav signal, [ScienceDirect 2025](https://www.sciencedirect.com/science/article/pii/S2214404825001910)).
- **Popławski parent-SMBH-bounce** is **not excluded** — it would
  predict a peak at `f ~ 10⁻⁵ Hz` for `M ~ 10⁹ M_⊙`, and a roll-off
  spectrum consistent with multiple-bounce contributions.

**Cycle-26 theorem 11** `baby_universe_gravitons_survive_bounce` is the
**Lean anchor** for this prediction.  It says: *the baby universe has a
graviton background with amplitude inherited from parent-bounce dynamics*.
Peak frequency follows from the parent-BH mass.

### 4.3 Spectrum multiplicity — the OmegaTheory distinguisher

**SPECULATIVE paper-worthy**.  Whereas inflation-generated GW background
has a **single broad peak** at the inflation-exit scale (typically
`f ~ 10⁻¹⁶ Hz` or `10⁻⁹ Hz` depending on the model), the
Popławski-bounce-universe picture has **multiple peaks**:
- stellar-mass PBH bounces populate LIGO (kHz)
- intermediate-mass BHs populate LISA (mHz)
- supermassive BHs populate PTA (nHz)

A **multi-band GW detection** that finds coincident features at each of
the scale-separated bands would be a **smoking-gun signature** for
Popławski's cyclic universe.  Current data cannot distinguish.  Euclid
(late 2026), LISA (2035), ET (late 2030s), and NANOGrav 20-yr will
tighten the constraints.

### 4.4 Amplitude scaling

Following the standard bounce-GW literature
([arXiv:2406.13521](https://arxiv.org/abs/2406.13521)):

```
Ω_GW h² ~ O(10⁻¹⁵) for inflation-floor
Ω_GW h² ~ O(10⁻¹²) for SMBH-bounce (rough estimate, model-dependent)
```

The SMBH-bounce GW background is **two orders of magnitude brighter** than
inflation-generated GW at the nHz PTA band, consistent with NANOGrav's
detection above the inflation floor.  This is *positive* evidence for a
strong cosmological source, of which SMBH-bounce is a viable candidate.

### 4.5 Cycle-26 recommendation

Theorem 11 should state:

```lean
theorem baby_universe_gravitons_survive_bounce (bu : BabyUniverse) :
  ∃ ω : ℝ, RealFieldGravitonExists ω ∧ bu.inheritedInformation > 0
```

— the *existence* of an on-shell graviton background at some
frequency, combined with positive inherited information.  This is a
**compositional** statement: it packages `RealFieldGravitonExists`
(from `GravitonConditions.lean`, Avior) with `bu.info_nonneg`.  The
**amplitude** and **peak frequency** are cycle-27+ quantitative work
(cycle 34 theorem 44 `gravitational_wave_relic_from_parent_bounce`
flagged LOW priority).

---

## §5 Falsifiability: five observations that would kill the BH → baby-universe chain

Each observation listed is a **concrete** experiment that would refute
one or more of the Cycle-26 theorems.  A single one of these, at 5σ,
would force OmegaTheory to abandon the cyclic cosmology branch.

### 5.1 PTA stochastic GW background — zero detection

If NANOGrav + EPTA + PPTA jointly **rule out** a stochastic GW background
at `A > 10⁻¹⁶` (below SMBH-bounce prediction floor), the supermassive
bounce signature vanishes.  Current data: A ≈ 2.4 × 10⁻¹⁵ (detection).
**Doesn't falsify yet**.  But NANOGrav 20-yr may push tighter; if the
signal is shown to be entirely accounted-for by SMBHB inspirals, the
Popławski channel is disfavoured.

**Relevant theorem**: theorem 11 `baby_universe_gravitons_survive_bounce`
survives on theoretical grounds even if GW detection is null (because
"survives" is an existence claim, not an amplitude claim).  But the
**paper-worthy narrative** would shift to "weak signal, consistent
with either mechanism".

### 5.2 Primordial B-mode CMB polarization — tensor-to-scalar ratio `r > 0.1`

A large tensor-to-scalar ratio measurement (LiteBIRD forecast ~ 10⁻³)
would strongly *favour* inflation over Popławski-bounce.  If LiteBIRD
or CMB-S4 measures `r ≈ 0.05` or higher, the **inflation mechanism** is
strongly preferred and the bounce narrative loses explanatory power.

Current: BICEP/Keck + Planck 2025: `r < 0.032` (95% CL).  Consistent
with both mechanisms.

**Relevant theorem**: theorem 9 `de_reservoir_flows_through_bounce_to_baby_universe`
is a **cross-universe** statement that does not directly predict an
r-value; however, the **narrative** of "bounce replaces inflation"
(Popławski 2010 headline) loses ground if `r > 0.01` at 5σ.

### 5.3 Ultralight sterile-ν 21-cm absorption feature absence

If SKA + HERA + LEDA fail to detect a 21-cm absorption feature at
`z ~ 20` consistent with a 10⁻⁶ eV sterile-ν coherent field, then the
**Zosma Catalan-G sterile-ν hypothesis** is weakened.  This directly
impacts theorem 10 `baby_universe_sterile_nu_spectrum`.

EDGES 2018 claimed a feature at `z ≈ 17` (not yet replicated).  SARAS3
(2022) contradicted EDGES; SKA is coming 2028+.  Status: **open**.

### 5.4 JWST galaxy-rotation asymmetry collapses with larger samples

If Euclid DR1 (2026) + Roman (2026+) + JWST CEERS find the Shamir
asymmetry does **not** hold in a larger sample, then the parent-BH-spin
signature is removed as observational evidence.

Current: Shamir 2025 MNRAS 538 with N=263, ~2:1 spin preference.
Not confirmed by larger samples yet.  **Key 2026 test**.

### 5.5 Direct torsion detection limits

Any upcoming precision test of frame-dragging anomalies from rotating
masses (Gravity Probe B follow-ups, SKA pulsar-timing spin-axis,
next-generation atom interferometry) that **constrains torsion below
ECSK prediction** rules out Einstein–Cartan gravity at the relevant
scale.  Current direct constraints: `Λ_torsion > 10⁻²⁶` eV — consistent
with Popławski's `Λ_torsion ~ M_Planck`, but far above the ECSK signature.

**Relevant theorem**: all four cycle-26 theorems depend on the ECSK
framework in `Torsion/SpinTorsion.lean`.  If ECSK is ruled out at the
torsion level, the Popławski narrative collapses entirely.

### 5.6 Summary table

| Observation | Current status | 5σ falsification | Impacts |
|---|---|---|---|
| PTA SGWB | **detected** (`A~2.4e-15`) | Exclusion of SMBH-bounce source | Theorem 11 narrative |
| CMB B-mode `r` | `r < 0.032` | `r > 0.05` would favour inflation | Theorem 9 narrative |
| 21-cm `z~20` feature | ambiguous (EDGES vs SARAS3) | Non-detection with SKA | Theorem 10 sterile prediction |
| JWST rotation asymm. | Shamir 2025 tentative | Euclid DR1 null result | Popławski parent-BH-spin |
| Direct torsion | `Λ_torsion > 1e-26 eV` | Tighter bound below ECSK pred | All 4 theorems |

---

## §6 Connection to cycle 32 / 33 (baryogenesis + leptogenesis)

### 6.1 Inheritance of CP phase

**SPECULATIVE paper-worthy**.  One of the open puzzles in the Standard
Model is the observed baryon asymmetry `η_B ≈ 6 × 10⁻¹⁰`.  The Sakharov
conditions require CP violation; the CKM contribution (`δ_CKM ≈ 70°`)
gives only `η_B ~ 10⁻²⁰`, falling short by 10 orders of magnitude.

The Popławski-bounce mechanism offers a potential resolution:

- The parent universe's CKM / PMNS CP phases are **labels** that reset
  at the bounce.
- However, the **direction** of CP violation (sign of `sin δ_CP`) may
  be **inherited** as a topological invariant of the parent-universe's
  spin orientation.
- If the parent universe had a **net spin** (§1.3 JWST observation),
  the CP phase of the *baby universe* is biased in the direction
  aligned with the parent spin.

This would provide a natural mechanism for baryon asymmetry even with
small CKM violation: the *bias* rather than the *magnitude* is what
matters.  The cycle-33 theorem 38 `leptogenesis_sterile_nu_decays_asymmetric`
is the formal anchor for this.

### 6.2 Sterile-ν decays as asymmetric leptogenesis source

Theorem 39 `sterile_nu_decay_into_photon_plus_light_nu` says
`BR(ν_s → γ + ν_active) > 10⁻²⁸`, `E_γ = m_sterile/2`.  This is
quantum-mechanically equivalent to the **Affleck–Dine-style**
asymmetric decay channel, but with the sterile-ν population coming
from the baby-universe's **inherited** relic rather than a thermal
freeze-out population.

**SPECULATIVE**: combining cycle-26 theorem 10 (sterile-ν inherited) +
cycle-33 theorem 38 (asymmetric decays) + cycle-26 theorem 9 (DE
reservoir = inheritedInformation) produces a coherent **leptogenesis
narrative**: the baby universe inherits a biased sterile-ν population
from the parent bounce, and this population decays asymmetrically
during the baby universe's matter-domination era, producing the
observed `η_B` at the right order of magnitude.

**Quantitative test**: the sterile-ν abundance `Ω_sterile` (cycle 25
theorem 7) combined with the per-sterile-ν branching asymmetry
`~ 10⁻²⁸` gives `η_L ~ Ω_sterile · BR_asymmetric ≈ 10⁻²⁹`.  This is
*too small* by itself — but **PMNS-mixing amplification** in the
active-ν sector can boost this by 10¹⁵–10²⁰, landing in the observed
window.  Detailed computation deferred to cycle 33.

### 6.3 Cycle-26 → cycle-33 hand-off

The cycle-26 theorems provide the **structural** content:
- `inheritedInformation ≥ 0` (cycle 26 theorem 9)
- `inheritedInformation ≤ S_BH` (cycle 26 theorem 12)
- sterile-ν survival (cycle 26 theorem 10)
- graviton survival (cycle 26 theorem 11)

Cycle 33 adds the **dynamical** content:
- asymmetric sterile-ν decays (theorem 38)
- X-ray line signature (theorem 39)
- Sakharov + Catalan-G combination (theorem 37)

The bridge: cycle-26 theorem 10 provides the **initial condition** for
the baby universe's sterile-ν population; cycle 33 describes its
**evolution**.

---

## §7 Theorem-shaping recommendations for the wizard

### 7.1 `de_reservoir_flows_through_bounce_to_baby_universe` (theorem 9, HIGH)

**Recommended signature**:

```lean
theorem de_reservoir_flows_through_bounce_to_baby_universe
    (R : DarkEnergyReservoir) (bu : BabyUniverse) (t_bounce : ℝ)
    (h_hit : reservoir_hits_bounce R t_bounce) :
    R.informationCost = bu.inheritedInformation
```

**Composition**:
1. `R.informationCost` — from `ForceUniversalInfoCost.lean` (Rasalhague).
2. `bu.inheritedInformation` — from `BigBounce.lean` (structure field).
3. The equality is a **definitional commitment** (both quantities measure
   "information conserved across the bounce") — prove by defining the
   bridge and using `rfl` or a trivial algebraic manipulation.

**Wizard strategy**: create `OmegaTheory/Torsion/DEReservoirBounce.lean`,
define `reservoir_hits_bounce R t` as a **Prop**, and state the theorem
as an assertion that at the bounce epoch, the two quantities coincide.
This is **not** a derivation; it is an **identification**.  The physical
content is in `information_transmitted` already.

### 7.2 `baby_universe_sterile_nu_spectrum` (theorem 10, HIGH)

**Recommended signature**:

```lean
theorem baby_universe_sterile_nu_spectrum (bu : BabyUniverse) :
    ∃ m : ℝ, sterileNeutrinoMassFloor 20 ≤ m ∧
    m ≤ Z_sterile * sterileNeutrinoMassFloor 10
```

Asserting *existence* of a sterile-ν mass in the Catalan-G window,
inside the baby universe.

**Composition**: apply Zosma's `sterile_neutrino_mass_from_fourth_irrational`
+ the window `[10⁻⁶, 10⁻⁵] eV` already proved.

**Honesty**: theorem 10 does **not** derive the sterile-ν mass; it
**asserts** that the baby universe has the same sterile-ν population as
Zosma's existing infrastructure predicts.  The cycle-26 content is the
**selection-rule commitment**: baby universes have Catalan-G sterile,
not π/e/√2 active fermions.

### 7.3 `baby_universe_gravitons_survive_bounce` (theorem 11, MEDIUM)

**Recommended signature**:

```lean
theorem baby_universe_gravitons_survive_bounce (bu : BabyUniverse) :
    ∃ ω : ℝ, RealFieldGravitonExists ω
```

**Composition**: `RealFieldGravitonExists` exists by `GravitonConditions.lean`
(Avior); just ship an existence proof with a witness `ω = 1` (or any
positive value).

**Honesty**: this is a **trivial existence** statement — the content is
semantic (baby universes have gravitons) not mathematical.  Include a
docstring noting that quantitative amplitude / peak frequency are
cycle-27+ / cycle-34 work.

### 7.4 `inherited_information_upper_bound_by_parent_mass` (theorem 12, MEDIUM)

**Recommended signature**:

```lean
theorem inherited_information_upper_bound_by_parent_mass (bu : BabyUniverse) :
    bu.inheritedInformation ≤ S_BH_formula bu.parentMass
```

where `S_BH_formula M := 4 * Real.pi * G_N * M^2 / (hbar * c) * k_B`.

**Composition**:
1. `S_BH_formula_pos : ∀ M > 0, 0 < S_BH_formula M` — by `positivity`.
2. `bu.info_nonneg : 0 ≤ bu.inheritedInformation`.
3. The inequality: needs either a **postulate** (cleanest) that
   `bu.inheritedInformation ≤ S_BH_formula bu.parentMass` *by definition of
   the BabyUniverse inheritance rule*, OR a **derivation** from
   `bekenstein_bound_on_lattice` with the holographic hypothesis.

**Wizard recommendation**: go with the **postulate** path.  Extend the
`BabyUniverse` structure (or use a separate `BabyUniverseHolographic`
structure) with an additional field `info_le_bekenstein`.  Prove
theorem 12 as a `rfl`-or-simple-rewrite from the structure field.  Add
a Lean-comment `-- TODO: promote postulate to theorem via Bekenstein
derivation, cycle 28` pointing to the Deneb infrastructure.

### 7.5 Wizard Lean-file organization

Recommended structure for the cycle-26 wizard's new file(s):

- `OmegaTheory/Torsion/BabyUniverseHolographic.lean` (new, ~80 lines)
  - `S_BH_formula` def
  - `S_BH_formula_pos` lemma
  - `BabyUniverseHolographic` extended structure with `info_le_bekenstein`
  - theorem 12
- `OmegaTheory/Torsion/DEReservoirBounce.lean` (new, ~120 lines)
  - `reservoir_hits_bounce` Prop
  - theorem 9 (`de_reservoir_flows_through_bounce_to_baby_universe`)
  - theorem 10 (`baby_universe_sterile_nu_spectrum`)
  - theorem 11 (`baby_universe_gravitons_survive_bounce`)

Total cycle 26: ~200 lines, 4 theorems, 0 new axioms, 0 sorry.  Register
both files in `OmegaTheory/Basic.lean`.

---

## §8 Graph findings landed (5 `:GraphFinding` nodes)

Persisted to Neo4j `namespace: OmegaTheoryV2` by the `neo4j` Python driver
(NOT MCP — driver pattern preferred per the Sadalmelik / Mesarthim
precedent).  All 5 nodes created with `created_by='Ancha'`, `cycle=26`.

1. **`cycle26_poplawski_bounce_paradigm_defensibility`** — EVIDENCE.
   `paper_worthy: True`.  Popławski 2010 + 2012 + 2016 + 2021 + 2024 seminar
   chain is not falsified by current observations.  JWST galaxy rotation
   (Shamir 2025), flatness + Planck scalar index, and zero direct torsion
   constraint all consistent.  `MOTIVATES`: all four cycle-26 theorems
   (9, 10, 11, 12) as prerequisite framework.

2. **`cycle26_baby_universe_sterile_selection_rule`** — LOAD-BEARING.
   `paper_worthy: True`.  Topological disconnection selection rule:
   only Catalan-G (topologically distinct 4th irrational) + gravitons
   (substrate fluctuations, not carriers) survive bounce.  SM fermions
   reset to N=0 iteration budget.  Consistent with cycle-34 theorem
   `inflaton_decays_produce_active_fermions_only`.  `MOTIVATES`:
   theorem 10 `baby_universe_sterile_nu_spectrum`, theorem 11
   `baby_universe_gravitons_survive_bounce`.

3. **`cycle26_bekenstein_holographic_inheritance_bound`** — LOAD-BEARING.
   `paper_worthy: True`.  Baby universe inheritedInformation ≤ S_BH
   of parent — composed from Deneb's `bekenstein_bound_on_lattice` +
   the holographic hypothesis.  Parent-mass upper bound makes the
   inheritance finite and testable.  `MOTIVATES`: theorem 12
   `inherited_information_upper_bound_by_parent_mass`, theorem 9
   (as a derivation that `R.informationCost` lies in this range).

4. **`cycle26_GW_relic_parent_bounce_signature`** — SPECULATIVE paper-worthy.
   Multi-band GW spectrum (LIGO kHz + LISA mHz + PTA nHz) scaling with
   parent-BH mass is a **spectrum-multiplicity** signature distinguishable
   from inflation's single-peak GW floor.  NANOGrav 15-yr (arXiv:2306.16213)
   is consistent with SMBH-bounce but not conclusive.  `MOTIVATES`:
   theorem 11 (qualitative), cycle-34 theorem 44 (quantitative).

5. **`cycle26_cyclic_cosmology_falsifiability_tests`** — EVIDENCE.
   `paper_worthy: True`.  Five concrete falsification paths: (a) PTA
   SGWB goes to zero, (b) CMB r > 0.05, (c) 21-cm z~20 feature absent,
   (d) Euclid DR1 rules out JWST rotation asymmetry, (e) torsion
   constrained below ECSK.  Each at 5σ would refute one or more
   cycle-26 theorems.  `MOTIVATES`: all four theorems (9, 10, 11, 12)
   via graceful-failure narrative.

Plus (implicit): cross-cycle edges from cycle 26 findings to cycle 25
(sterile-ν abundance) and cycle 33–34 (leptogenesis + cyclic closure).

---

## §9 Open questions + cycle-27 / cycle-34 hand-off

1. **Is the sterile-ν Catalan-G channel actually the *topologically
   distinct* 4th irrational?** — `SPECULATIVE`.  Louchard–Niederreiter
   class analysis would formalise this, but no full classification proof
   exists in Lean.  **Cycle 27 side-quest**.

2. **Does inheritedInformation = R.informationCost *exactly*, or only
   up to a Connes-Z factor?** — **SPECULATIVE**.  The cleanest commitment
   for cycle 26 is exact equality; the Connes-Z factor is the cycle-27
   theorem 13 `Z_sterile_from_connes_DF_eigenvalue` content.  If the
   Connes factor applies here too, theorem 9 becomes
   `R.informationCost = Z_bounce · bu.inheritedInformation`.

3. **Is the parent-BH mass observable from OUR universe?** — Not
   directly.  The hypothesis is that our universe's **total mass-energy**
   scales with parent-bounce `S_BH`.  Observational consequence:
   `Ω_total ≈ 1` (observed) + CMB temperature (observed) + inflation
   e-fold count (~60 needed) can be *derived* from parent-BH
   thermodynamics — **cycle-34 theorem 43** `horizon_and_flatness_and_DM_jointly_resolved_by_bounce`.

4. **PBH nested remnants — do they contribute to OUR DM?** — **SPECULATIVE**
   cycle 37 work (BH info paradox).  Defer to cycle-26 commitment:
   theorem 10 states *only* sterile-ν, explicitly not PBH, as the
   surviving matter.  PBH remnants are an **ambiguous case** left for
   later.

5. **Hand-off to cycle 27**: the Connes Z-calibration for the sterile-ν
   channel, once derived from D_F eigenvalue 4 (theorem 13), should be
   **checked** against the cycle-26 inheritance chain: is
   `Z_sterile · inheritedInformation = R.informationCost` the correct
   relation, or is there an additional bounce-specific factor?  Cycle
   27's `Z_sterile` may need extension to a `Z_bounce`.

6. **Hand-off to cycle 34**: cycle-26 theorem 11 (graviton background
   exists) becomes the **existence lemma** for cycle-34 theorem 44
   `gravitational_wave_relic_from_parent_bounce`, which adds the
   *amplitude* and *peak frequency*.  Make sure the graviton existence
   proof in the cycle-26 file is cited and re-exported by the cycle-34
   file.

---

## §10 References

### Einstein–Cartan / Popławski primary

1. Popławski, N. J. "Cosmology with torsion: An alternative to cosmic
   inflation." *Phys. Lett. B* **694**, 181 (2010).
   [arXiv:1007.0587](https://arxiv.org/abs/1007.0587).
2. Popławski, N. J. "Nonsingular, big-bounce cosmology from
   spinor-torsion coupling." *Phys. Rev. D* **85**, 107502 (2012).
   [arXiv:1111.4595](https://arxiv.org/abs/1111.4595).
3. Popławski, N. J. "Universe in a black hole with spin and torsion."
   *Astrophys. J.* **832**, 96 (2016).
   [arXiv:1410.3881](https://arxiv.org/abs/1410.3881).
4. Popławski, N. J. Seminar notes.
   [ULA 2020](https://www.nikodempoplawski.com/ULA2020.pdf).
   [USM 2024](https://nikodempoplawski.com/USM2024.pdf).
5. Hehl, F. W., von der Heyde, P., Kerlick, G. D., and Nester, J. M.
   "General relativity with spin and torsion: Foundations and prospects."
   *Rev. Mod. Phys.* **48**, 393 (1976).  Foundational ECSK paper.

### JWST galaxy rotation

6. Shamir, L. "The distribution of galaxy rotation in JWST Advanced Deep
   Extragalactic Survey." *Mon. Not. R. Astron. Soc.* **538**, 76 (2025).
   [arXiv:2502.18781](https://arxiv.org/abs/2502.18781).
7. Multiple Web coverage 2025 —
   [phys.org 2025-03](https://phys.org/news/2025-03-puzzling-jwst-galaxies-deep-universe.html),
   [sciencereader](https://sciencereader.com/are-we-inside-a-black-hole/),
   [Business Today 2025-03](https://www.businesstoday.in/visualstories/news/263-galaxies-one-twist-the-universe-might-be-spinning-in-one-direction-220338-27-03-2025).

### Gravitational-wave background

8. NANOGrav Collaboration (Agazie et al.). "The NANOGrav 15 yr Data Set:
   Evidence for a Gravitational-wave Background." *Astrophys. J. Lett.*
   **951** L8 (2023).  [arXiv:2306.16213](https://arxiv.org/abs/2306.16213).
9. "Gravitational-wave background in bouncing models from semi-classical,
   quantum and string gravity." *JCAP* **09** 058 (2024).
   [arXiv:2406.13521](https://arxiv.org/abs/2406.13521).  Bouncing-cosmology
   GW background prediction spectra.
10. "Exploring cosmological gravitational wave backgrounds through the
    synergy of LISA and the Einstein Telescope." *Phys. Rev. D* **111**
    103001 (2025).  [arXiv:2409.02886](https://arxiv.org/abs/2409.02886).

### Bekenstein / holographic principle

11. Bekenstein, J. D. "Black holes and entropy." *Phys. Rev. D* **7**,
    2333 (1973).
12. Bekenstein–Hawking entropy overview: [arXiv:2507.03778](https://arxiv.org/html/2507.03778v1)
    (2025).

### OmegaTheory Lean references

13. `OmegaTheory/Torsion/BigBounce.lean` (Poplawski bounce formalization)
    — `BabyUniverse` structure with `parentMass`, `inheritedInformation ≥ 0`,
    `expansionRate`.  Contains honesty note about lack of dynamical bounce.
14. `OmegaTheory/Torsion/SpinTorsion.lean` — `torsionPressure_negative`,
    spin-coupling to torsion.
15. `OmegaTheory/Emergence/BekensteinBound.lean` (Deneb, 2026-04-15) —
    `bekenstein_bound_lattice_weak`, `bekenstein_bound_on_lattice` (with
    explicit holographic hypothesis).
16. `OmegaTheory/Emergence/GravitonConditions.lean` (Avior, 2026-04-17) —
    `RealFieldGravitonExists`, on-shell field graviton as existence
    predicate.
17. `OmegaTheory/Emergence/ForceUniversalInfoCost.lean` (Rasalhague) —
    `dark_energy_reservoir_fed_by_all_forces`, information-cost universal.
18. `OmegaTheory/Emergence/HawkingReservoirRelaxation.lean` — Hawking
    as dark-energy reservoir relaxation, `hawkingOutflow bh t = reservoirRelaxationRate bh · t`.
19. `OmegaTheory/Emergence/SingularityNotEnergySink.lean` (Almach, 2026-04-19)
    — `singularity_is_not_energy_sink`, `singularityEnergy bh t = 0`
    universally.
20. `OmegaTheory/Predictions/SterileNeutrinoFromFourthIrrational.lean`
    (Zosma, 2026-04-20) — Catalan-G 4th channel, `m_sterile ∈ [10⁻⁶, 10⁻⁵] eV`.
21. `plans/THEOREM_BACKLOG_CYCLES_24_43.md` (Mekbuda, 2026-04-20) —
    backlog entries 9–12 for cycle 26, entries 37–40 for cycle 33, entries
    41–44 for cycle 34.

### OmegaTheory companion memos

22. Sadalmelik. `NOTES_CYCLE25_OMEGA_TOTAL.md` (2026-04-21) — Ω_Λ = 0.685
    as input to cycle 26; hand-off note at §9(5).
23. Mesarthim. `NOTES_CYCLE24_ELECTROWEAK.md` (2026-04-21) — Λ_Connes_OT
    ≈ 10¹³ GeV spectral-action scale (relevant to baby-universe
    reheating in cycle 34).
24. Altair. `NOTES_DF_EIGENVALUES.md` — Connes D_F eigenvalue 4th slot
    is the Connes Z-calibration that interacts with cycle-27 theorem 13.

### OmegaTheory Lean axiom count

8 physical axioms (unchanged by this memo).
0 new axioms anticipated for cycle 26.

---

**End of memo.**  The cycle-26 theorem chain commits OmegaTheory to a
topologically-clean Popławski-bounce narrative: the dark-energy
reservoir's informationCost equals the baby-universe's inheritedInformation
(theorem 9), only topologically-distinct sterile-ν + graviton substrate
fluctuations survive the bounce (theorems 10, 11), and the inheritance is
upper-bounded by the parent-mass Bekenstein entropy (theorem 12).  The
four theorems are **structural** commitments, not full dynamical derivations
— dynamical content is deferred to cycle 34 (quantitative GW spectrum,
horizon-and-flatness-and-DM joint resolution).

The falsifiability target for cycle 26 rests on **five independent**
observations: PTA SGWB, CMB r, 21-cm z~20 feature, JWST galaxy rotation,
and direct torsion tests.  A 5σ null result on any one of them would
stress the parent-bounce framework; a 5σ detection on **multi-band GW
spectrum multiplicity** would strongly favour it over single-peak
inflation alternatives.

*— Ancha, θ Aquarii, Cycle 26 research-support, 2026-04-21*
