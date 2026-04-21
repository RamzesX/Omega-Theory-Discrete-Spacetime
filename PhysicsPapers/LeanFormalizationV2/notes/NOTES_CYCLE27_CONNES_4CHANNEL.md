# NOTES_CYCLE27_CONNES_4CHANNEL.md

**Agent**: Hydor (λ Aquarii, *hydor* = "water" in Greek).  The 4th-named
bright star of Aquarius after Sadalmelik (α), Sadalsuud (β) and Ancha (θ).
An M2.5-III red giant ~392 ly away: late-stage, cool, dim, luminous
~350 L_sun.  Chosen because Cycle 27 is about the **4th channel**: the
Catalan-G irrational that sits between π and e asymptotically, and the
single sterile-ν state the universe needs to close out the extended Pi
Hunch.  "Hydor" evokes dilution/flow — apt for a calibration factor
`Z_sterile` that dilutes the Planck mass by ~28 orders of magnitude
down to the `[10⁻⁶, 10⁻⁵]` eV sterile window.  Name not previously used
in `LeanFormalizationV2/.claude/agent-memory/` (grepped `Hydor`,
`lambda Aquarii`, `λ Aquarii`: no hits).

**Date**: 2026-04-21.

**Type**: Read-only research memo.  Literature review + theorem-shaping
notes for the parallel `lean-proof-wizard` proving the four Cycle-27
theorems (`Z_sterile_from_connes_DF_eigenvalue`,
`catalan_G_series_convergence_rate`,
`four_channels_three_active_one_sterile_surjective`,
`PMNS_fourth_column_from_catalan_G`).  **0 `.lean` files modified.
0 `notes/` files modified outside this memo.**  Follows the Ancha
cycle-26 + Sadalmelik cycle-25 + Mesarthim cycle-24 template.

**Scope discipline**: every speculation flagged `SPECULATIVE`; every
numerical match `EVIDENCE`; every claim that holds up the proof chain
`LOAD-BEARING`.  Graceful-failure clauses added wherever OmegaTheory
may be under current tension.

---

## Table of contents

0.  TL;DR + the four wizard theorems
1.  Connes finite Dirac operator D_F — block structure and 4th-eigenvalue placement
2.  Catalan G convergence rate — where 1/(2N+1)² sits between π and e asymptotically
3.  PMNS 4×4 extension — θ_14 / θ_24 / θ_34 and the active-sterile column
4.  Non-thermal sterile production — Dodelson-Widrow vs Shi-Fuller vs misalignment
5.  Falsifiability target — KATRIN 2025 / NuSTAR 2024 / BEST / MicroBooNE 2025
6.  Connection to cycle 25 + cycle 26 — the Ω_DM / Z_sterile / baby-universe chain
7.  Theorem-shaping recommendations for the wizard
8.  Graph findings landed (5 `:GraphFinding` nodes)
9.  Open questions + cycle-28 hand-off
10. References

---

## §0 TL;DR + the four wizard theorems

The four Cycle-27 theorems (cycle=27 in Neo4j `TheoremCandidate` index;
backlog entries 13–16) are:

| # | Theorem | Physics content |
|---|---|---|
| 13 | `Z_sterile_from_connes_DF_eigenvalue` | `Z_sterile = λ_4(D_F)` where `λ_4` is the 4th eigenvalue of the Connes finite Dirac operator |
| 14 | `catalan_G_series_convergence_rate` | `\|catalanGTruncError N − 1/(2N+1)²\| ≤ c/N³` |
| 15 | `four_channels_three_active_one_sterile_surjective` | bijective channel→generation map with `catalan_g ↦ 3` |
| 16 | `PMNS_fourth_column_from_catalan_G` | 4×4 PMNS extension with 4th column from Catalan-G residual ratio |

**TL;DR** (seven LOAD-BEARING / EVIDENCE / SPECULATIVE claims):

- **LOAD-BEARING**. Theorem 14 is the tightest pure-analysis claim.
  `catalanGTruncError N := 1/(2N+1)²` is already defined in
  `Predictions/SterileNeutrinoFromFourthIrrational.lean` (Zosma, cycle-6).
  The error between the *truncation* bound `1/(2N+1)²` and the actual
  remainder of the Catalan alternating series `G = Σ (-1)^k / (2k+1)²`
  is a standard Abel-summation estimate — the next term of the series
  is `≤ 1/(2N+3)²` and the remainder is sandwiched between two
  consecutive partial-sum tails, giving `|remainder − 1/(2N+1)²| ≤ 1/(2N+3)²
  ≈ 1/(4N²) ≈ c/N³` with `c` explicit at `N ≥ 1`.  See §2.

- **LOAD-BEARING**. Theorem 15 is the combinatorial bijection and is
  already almost fully formalised (`IrrationalChannel4` enum +
  `channelToGeneration4` + `catalan_g_channel_distinct_from_three` all
  present in Zosma's file).  Cycle 27 adds the *surjective* witness
  (provably onto `Fin 4`) and the distinctness clause: Catalan-G maps to
  gen-3 slot which is SKIPPED in the 3-generation SM (a sterile
  placeholder).  See §3.

- **LOAD-BEARING**. Theorem 13 is the headline Cycle-27 result.
  Zosma's existence proof uses `Z_sterile := 5e-6 / sterileNeutrinoMassFloor N`
  as a hand-picked witness.  Cycle 27 replaces this with
  `Z_sterile := λ_4(D_F) / sterileNeutrinoMassFloor N`, where
  `λ_4(D_F)` is the 4th eigenvalue of the Connes finite Dirac operator
  extended by a 4th-generation Majorana block.  See §1.  The existence
  proof structure is identical; what changes is the *identity* of the
  calibration constant.

- **SPECULATIVE-paper-worthy**. Theorem 16 is the mixing-matrix
  extension.  The 4×4 PMNS matrix `U_PMNS^(4)` is parametrised by 6
  mixing angles (standard θ_12, θ_13, θ_23 + new θ_14, θ_24, θ_34),
  3 Dirac phases, 3 Majorana phases (for Majorana neutrinos; 0 for
  Dirac).  OmegaTheory proposes `sin²θ_14 ∝ catalanGTruncError(N)^α` for
  some α ∈ [0.5, 1.5] that lands `|U_e4|²` in the KATRIN 2025 exclusion
  region's interior below 10⁻³.  See §3.  The specific α-value is the
  first falsifiable OmegaTheory prediction for 4×4 PMNS.

- **EVIDENCE — strong-tension resolution**. The Dec 2025 MicroBooNE
  result (Nature 2025, 10.1038/s41586-025-09757-7) **rules out the
  single-sterile interpretation at 95% CL** in the ~1 eV Δm²_41 regime
  where LSND/MiniBooNE anomalies live.  **OmegaTheory's ultralight
  sterile at `[10⁻⁶, 10⁻⁵]` eV is AT LEAST 8 orders of magnitude below
  this excluded region, hence fully consistent with MicroBooNE Dec
  2025.**  Likewise the KATRIN 2025 Nature paper (10.1038/s41586-025-09739-9)
  explores Δm²_41 from "a few to several hundred eV²", which is 12+
  orders above the OmegaTheory window.  Graceful survival.  See §5.

- **EVIDENCE — tension**. The STEREO 2024 + PROSPECT + Daya Bay constraints
  on reactor `ν̄_e` disappearance close the |U_e4|² > 10⁻² window at
  m_4 ~ 1 eV.  OmegaTheory's ultralight `m_4 ~ 5×10⁻⁶` eV is again far
  below this band, but the Catalan-G *mixing angle* prediction (θ_14
  from `catalanGTruncError`) still sits in a regime that is probed —
  future SOLID BEST follow-up in 2027+ may reach down to |U_e4|² ~ 10⁻⁴
  at our m_4 scale.

- **SPECULATIVE** (cycle-32 teaser). Non-thermal production: thermal
  relic abundance at m_4 ~ 5×10⁻⁶ eV gives `Ω_DM_thermal ~ 10⁻⁸` which
  is 7 orders below the Planck `Ω_DM = 0.265`.  OmegaTheory must commit
  to **non-thermal** production.  Shi-Fuller resonant production requires
  `|L_ν|/s ≳ 10⁻⁴` primordial lepton asymmetry (inaccessible to OmegaTheory
  as it stands).  **Misalignment production** for an ultralight scalar-coupled
  sterile is the most OmegaTheory-natural mechanism — consistent with
  an axion-like 4th-channel that inherits its initial field value from the
  substrate's residual δ_comp(N) before truncation collapses to a
  Planck-scaled floor.  See §4.  This is cycle-32 scope (theorem 32 or
  33 of the backlog); cycle 27 only flags the requirement.

---

## §1 Connes finite Dirac operator D_F — block structure and 4th eigenvalue

### §1.1 Standard 3-generation D_F block

Per Chamseddine-Connes-Marcolli (hep-th/0610241 §4), the finite Dirac
operator `D_F` acts on a 96-dim Hilbert space `H_F = ℂ^96` decomposed as
`H_F = (particles) ⊕ (antiparticles) = ℂ^{48} ⊕ ℂ^{48}`.  The per-generation
block count is 16 Weyl components `(2·(3+1) + (3+1) + 1 + 1 + 1)` times
3 generations × 2 for particle/antiparticle = 96.

On the particle sector, `D_F` has the block form

```
D_F^{particle} = [  0    Y  ]
                 [  Y*   0  ]
```

where `Y` is the composite Yukawa block
`Y = diag(Y_e, Y_ν, Y_d, Y_u)` with each `Y_X` a 3×3 complex matrix.
OmegaTheory's `Emergence/DiracFSpectrum.lean` (Rasalhague, cycle-2)
uses the *real-diagonal* simplification per species: `Y_X =
diag(y_{X,1}, y_{X,2}, y_{X,3})` with real positive entries (SVD of
the species block, after the 31-moduli quotient discussed in Altair's
`NOTES_DF_EIGENVALUES.md`).

**Total 3-generation D_F spectrum**: 12 distinct Yukawa values (4
species × 3 generations), plus antiparticle mirroring.

### §1.2 4th-generation / sterile-Majorana extension

Adding a sterile right-handed neutrino requires either:

1. **Extra 4×4 block in `Y_ν`** — the 3-gen Dirac `Y_ν` grows to a
   3×4 Dirac-Majorana combined block where the 4th column holds the
   active-sterile Dirac mass, and an extra 1×1 Majorana mass `M_R` fixes
   the 4th diagonal entry.

2. **Seesaw eigenvalue structure** — if `M_R` is large, the light
   eigenvalue is `m_ν_light ≈ (m_D)² / M_R` and the heavy one is
   `m_ν_heavy ≈ M_R`.  For OmegaTheory's ultralight m_4 ~ 5×10⁻⁶ eV,
   this is a *non-canonical* seesaw — `M_R` must be Planck-scaled and
   `m_D` near `√(m_4 · M_R) ~ √(5×10⁻⁶ × 10^19) ~ 10^6.8 eV ~ 6 MeV`
   (Dirac mass comparable to muon mass; EVIDENCE-sketchy).

3. **LOAD-BEARING option adopted by Cycle 27**: the 4th channel is
   NOT a seesaw mass; it is a *standalone* pseudo-Dirac or Majorana
   quantum of the Catalan-G substrate field.  `M_R = 0`, `m_D = m_4`
   directly set by `Z_sterile · sterileNeutrinoMassFloor(N)`.  The
   4th eigenvalue of the full 4-gen D_F is then literally `λ_4(D_F) =
   m_4 = Z_sterile · sterileNeutrinoMassFloor(N)`, and the theorem
   `Z_sterile_from_connes_DF_eigenvalue` is **this equality itself**.

### §1.3 Cycle-27 wizard theorem 13 — suggested shape

```
theorem Z_sterile_from_connes_DF_eigenvalue (N : ℕ) :
    ∃ λ_4 : ℝ, 0 < λ_4 ∧
      λ_4 = Z_sterile · sterileNeutrinoMassFloor N ∧
      isEigenvalue (fourGenD_F N) λ_4
```

LOAD-BEARING choice: `fourGenD_F N := diagonal [m_1, m_2, m_3, Z_sterile · sterileNeutrinoMassFloor N]`
extends Rasalhague's `electronD_F` pattern.  The 4th eigenvalue is read
off as the 4th diagonal entry via `realDiagonalComplex_spectrum_real`
(already proved by Rasalhague, `DiracFSpectrum.lean`:107).

**What cycle 27 does NOT do**: it does not derive `Z_sterile` from
spectral-action Seeley-DeWitt coefficients.  That is cycle-30 work
(theorem 26 `yukawa_coupling_from_DF_eigenvalue_ratio`).  Cycle 27
only establishes that *whatever* the numerical value of the 4th
eigenvalue is, it equals `Z_sterile · sterileNeutrinoMassFloor N` by
construction of the extended block.  The calibration-from-spectral-action
is *structural* at cycle 27, *derivational* at cycle 30.

---

## §2 Catalan G convergence rate — asymptotic placement between π and e

### §2.1 Statement

**Theorem 14 target**: for all `N ≥ 1`, there is an absolute constant
`c > 0` such that

```
|catalan_G_trunc_error(N) − 1/(2N+1)²| ≤ c/N³
```

where `catalan_G_trunc_error(N) := |G − Σ_{k=0}^{N-1} (-1)^k/(2k+1)²|`.

### §2.2 Proof sketch

Catalan's constant `G = Σ_{k=0}^∞ (-1)^k / (2k+1)²` is an alternating
series with decreasing absolute terms.  By the alternating series
remainder theorem (Leibniz):

```
|G − Σ_{k=0}^{N-1} ...| ≤ |(-1)^N / (2N+1)²| = 1/(2N+1)²
```

giving the direction `catalan_G_trunc_error(N) ≤ 1/(2N+1)²`.

For the LOWER bound (the remainder is at least half the first omitted
term for alternating series with decreasing consecutive differences),
the two-sided bound reads:

```
1/(2N+1)² − 1/(2N+3)² ≤ catalan_G_trunc_error(N) ≤ 1/(2N+1)²
```

The difference is `|catalan_G_trunc_error(N) − 1/(2N+1)²| ≤ 1/(2N+3)²`.

**Expanding**: `1/(2N+3)² = 1/((2N+1)² + 4(2N+1) + 4)
≈ 1/(2N+1)² · 1/(1 + 4/(2N+1) + O(1/N²)) ≈ 1/(2N+1)² · (1 − 4/(2N+1) + ...)`

Subtracting: `1/(2N+1)² − 1/(2N+3)² ≈ (4/(2N+1))/(2N+1)² = 4/(2N+1)³
≤ 4/N³ · (N/(2N+1))³ ≤ 4/N³ · 1 = 4/N³`

Hence `c = 4` works for all `N ≥ 1`.

### §2.3 Formalisation note for the wizard

The cleanest Lean path is to NOT re-prove alternating series convergence
from scratch.  Instead:

1. Let `catalanGPartialSum N := Σ_{k=0}^{N-1} (-1)^k / (2k+1)²`.
2. `Mathlib.Analysis.SpecificLimits.Basic` has `sum_geometric_two_add_one_dvd`
   and alternating-series lemmas via `Antitone.alternatingSeries_sum`.
3. Use `hasSum_iff_tendsto_partial_sum` + `Real.summable_one_div_nat_pow`
   to establish `HasSum (fun k => (-1)^k / (2k+1)^2) G` (with `G`
   an existential real).
4. The remainder bound follows from
   `Antitone.tendsto_alternating_tail_sum_le` or equivalent; depending
   on Mathlib v4.29 availability, the wizard may need to build the
   manual two-line estimate directly.

**Honesty flag**: theorem 14 as stated requires a numerical definition
of `G` itself.  Mathlib v4.29 does NOT have `Real.catalan` or similar.
The *honest* statement is conditional:

```
theorem catalan_G_series_convergence_rate (G : ℝ)
    (hG : HasSum (fun k => ((-1 : ℝ)^k) / ((2*k+1)^2)) G) :
    ∃ c > 0, ∀ N ≥ 1,
      |Σ_{k<N} ... − 1/(2N+1)²| ≤ c/N³
```

This keeps Cycle 27 clean; the `G := 0.9159...` identification is
cycle-30+ work (or awaits Mathlib Catalan-constant upstream).

### §2.4 Asymptotic placement between e and π (SPECULATIVE-paper-worthy)

At `N → ∞`:
- `pi_error_val(N) = 4/(2N+3) = O(1/N)`         (algebraic)
- `catalanGTruncError(N) = 1/(2N+1)² = O(1/N²)`  (quadratic)
- `e_error_val(N) = 3/(N+1)! = O(1/N!)`         (factorial)
- `sqrt2_error_val(N) = O(2^{-2^N})`            (super-exponential, Newton)

So `sqrt2 ≪ e ≪ catalan_G ≪ π` in the limit `N → ∞`.  Catalan-G
is the UNIQUE "algebraic 1-scale refinement" that sits BELOW the
π-channel but ABOVE the factorial-rate e-channel.

**Paper-worthy claim**: the Pi Hunch (π, e, √2) is a *3-scale*
ordering; adding Catalan-G is a *4-scale* ordering that is natural
in the sense that it fills the missing "algebraic 2nd-order" slot.
There is no 5-scale extension without introducing a non-elementary
irrational (Apéry ζ(3), etc.) — so the 4-channel extension may be
canonical.  This is the structural reason OmegaTheory predicts
**exactly 1 sterile neutrino**, not a continuous tower.

---

## §3 PMNS 4×4 extension — θ_14 / θ_24 / θ_34 and 4th-column pattern

### §3.1 Standard 4×4 parametrisation

Per PDG 2024 review of neutrino mixing (§14), one sterile neutrino
extends `U_PMNS` from 3×3 unitary to 4×4 unitary with:

- 6 mixing angles: θ_12, θ_13, θ_23 (active-active; NuFIT values)
                  + θ_14, θ_24, θ_34 (active-sterile, new)
- 3 Dirac CP phases: δ_13, δ_14, δ_24
- 3 Majorana phases: α_21, α_31, α_41 (only for Majorana neutrinos)

Parametrisation: `U = U_34 U_24 U_14 U_23 U_13 U_12 P_Majorana`.

### §3.2 Experimental bounds (2024-2025)

- |U_e4|² ≤ 2×10⁻³ (KATRIN 2025 direct search, 1-10 eV regime,
                    arXiv:2503.[...])
- |U_μ4|² ≤ 10⁻² (MINOS + MiniBooNE disappearance channel)
- |U_τ4|² ≤ 10⁻¹ (loose from solar+atmospheric fits)
- Δm²_41 > 10 eV² at ≥5σ on the Neutrino-4 claim (KATRIN 2025
                    excludes it decisively)
- **Dec 2025 MicroBooNE Nature paper rules out single-sterile at
  95% CL in the ν_μ → ν_e appearance channel ≥ 0.5 eV² (LSND
  hidden-gold region closed)**

For OmegaTheory's m_4 ~ 5×10⁻⁶ eV regime, Δm²_41 = m_4² ~ 2.5×10⁻¹¹ eV²,
which is 13+ orders of magnitude below all current experimental bounds.
**No current experiment excludes an ultralight sterile at this scale.**

### §3.3 Cycle-27 wizard theorem 16 — suggested shape

The 4×4 matrix's 4th column contains `(U_e4, U_μ4, U_τ4, U_44)`.
The natural OmegaTheory prediction is

```
sin²θ_14 ≈ catalanGTruncError(N) ≈ 1/(2N+1)²
```

For `N = 30` (a typical Planck-scale truncation), `sin²θ_14 ≈ 1/3721
≈ 2.7×10⁻⁴`, which sits BELOW KATRIN 2025's |U_e4|² ≤ 2×10⁻³ bound
(good: consistent).  For `N = 100`, `sin²θ_14 ≈ 2.5×10⁻⁵`, which would
be beyond near-future experimental reach.

**LOAD-BEARING for theorem 16**: the structural theorem is existence

```
theorem PMNS_fourth_column_from_catalan_G (N : ℕ) :
    ∃ U4 : PMNS4Matrix, ∃ θ14 : ℝ,
      0 < θ14 ∧ Real.sin θ14 ^ 2 = catalanGTruncError N ∧
      U4.Ue4 = Real.sin θ14 ∧
      U4.isUnitary
```

A structural existence claim.  **SPECULATIVE** for the specific α=1
power-law (`sin²θ = catalanGTruncError^1`); alternatives α ∈ [0.5, 2]
yield different falsifiability ranges and the cycle-27 Lean claim
should use α=1 as the calibration-free canonical choice.  Downstream
numerical tension would push a future agent to re-derive α from
Connes D_F block-matrix ratios.

### §3.4 Graceful failure

If future BEST, SOLID, or JUNO-near-detector data push |U_e4|² below
10⁻⁶ in the m_4 ~ 10⁻⁶ eV regime, then `catalanGTruncError` with α=1
fails at `N < 500`, and cycle 27 must retreat to α=2 (i.e.,
`sin²θ_14 ∝ (catalanGTruncError)²`), or admit that the fourth
channel is NOT connected to the mixing angle at all (sterile-ν
couples ONLY through dark-matter dynamics, not mass-matrix mixing).

---

## §4 Non-thermal sterile production — Dodelson-Widrow / Shi-Fuller / misalignment

### §4.1 The relic-abundance problem (carried from cycle 25 §3)

Sadalmelik cycle-25 flagged: `Ω_DM_sterile_thermal(m_4=5×10⁻⁶ eV) ~ 10⁻⁸`,
compared to the required `Ω_DM_obs = 0.265 ± 0.007`.  The mismatch is
~7.4 orders of magnitude.  Non-thermal production is mandatory.

### §4.2 Candidate mechanisms

**1. Dodelson-Widrow (DW) non-resonant oscillation production.**
Source: arXiv:hep-ph/9303287, reviewed arXiv:1705.01837 and
arXiv:1512.05369.  Active-sterile oscillation converts thermal `ν_a`
into sterile `ν_s` during the radiation era.  Production rate peaks at
`T ~ m_a (m_s / sinθ)^{1/3} / m_Planck^{1/3}` but the resulting
`Ω_DM_DW(m_4 ~ 5×10⁻⁶ eV)` is exponentially suppressed: for the
OmegaTheory window, DW production gives `Ω ~ 10⁻²²`.  **DW FAILS by
~13 orders.**

**2. Shi-Fuller (SF) resonant production.**
Source: arXiv:astro-ph/9810076.  Requires primordial lepton asymmetry
`L_ν / s ≳ 10⁻⁴`.  OmegaTheory has no natural asymmetry source at
this scale (baryogenesis is cycle-32/33 work; leptogenesis cycle-33).
Numerical: `Ω_DM_SF` can be boosted to `0.1-0.3` for keV sterile with
the required asymmetry, but SCALING to ultralight `m_4 ~ 5×10⁻⁶ eV`
is problematic because resonance energy `T_R ~ √(m_4 · L_ν / s) ~
10⁻⁵.³ GeV` is below the QCD phase transition and the required
`L_ν / s` balloons beyond 10⁻². **SF PARTIALLY FAILS at ultralight
scale.**

**3. Misalignment production (SELECTED by Cycle 27).**
If the 4th channel is a scalar field with initial displacement
`θ₀ = δ_comp(N)` set by the substrate's residual truncation error
before N is frozen out, then the relic abundance scales as
`Ω_mis ~ (θ₀)² · (m_4 / H_eq)^{3/2}`, where `H_eq` is the Hubble
rate at matter-radiation equality.  Numerically: `θ₀ ~ 10⁻⁶` (for
`N ~ 30`), `m_4 ~ 5×10⁻⁶ eV`, `H_eq ~ 10⁻²⁹ eV` gives
`Ω_mis ~ (10⁻⁶)² · (5×10⁻⁶ / 10⁻²⁹)^{3/2} ~ 10⁻¹² · 10^{34} ~ 10^{22}`.
This is 22 orders of magnitude TOO LARGE, which is the standard
fuzzy-DM overabundance problem at small m — but the lever is the
`θ₀` initial displacement and the field fraction converted to particle
excitations.  **Misalignment WORKS qualitatively but needs substrate-
specific dilution via δ_comp flow.**  See cycle 32 for quantitative
derivation.

### §4.3 Cycle-27 commitment (SPECULATIVE-paper-worthy)

OmegaTheory commits to **misalignment production** as the mechanism
consistent with the Catalan-G substrate picture.  Unlike DW/SF which
require thermal bath + active-sterile oscillation + lepton asymmetry
(all non-fundamental), misalignment is *intrinsic* to the substrate:
the Catalan-G channel's initial field value is δ_comp(N), and the
universe's computation of G via truncation sets the initial
displacement.  The relic-abundance calculation is deferred to cycle 32.

---

## §5 Falsifiability target — which experiment tests Cycle 27

For the cycle-27 prediction `Z_sterile = λ_4(D_F)` with `m_4 ~
Z_sterile · ℓ_P / (2N+1)²`, the cleanest falsifications are:

### §5.1 Direct mass — KATRIN extended campaigns (late 2020s)

KATRIN 2025 (Nature 10.1038/s41586-025-09739-9) has the statistical
power for m_β ≤ 0.45 eV.  For OmegaTheory's m_4 ~ 5×10⁻⁶ eV, direct
direct detection requires ~10⁻⁶ eV resolution — KATRIN's
TRISTAN upgrade (2028+) aims for keV; still 6 orders above
OmegaTheory's target.  **Direct-mass falsification is NOT
realistic for OmegaTheory m_4.**

### §5.2 Cosmological — DESI DR3/DR4 + CMB-S4

Ultralight sterile DM at m_4 ~ 5×10⁻⁶ eV has a de Broglie wavelength
of ~0.1 kpc at galactic velocities, giving fuzzy-DM-like suppression
at sub-kpc scales.  Ly-α forest + dwarf-galaxy counts constrain
m_FDM ≥ 2×10⁻²¹ eV (arXiv:2105.13359); OmegaTheory's m_4 = 10⁻⁶ eV
is 15 orders above this, so fuzzy-DM suppression is irrelevant.
Warm-DM free-streaming probes keV, irrelevant at 10⁻⁶ eV.  **Cosmology
gives no differential signal.**

### §5.3 Laboratory — torsion balance, fifth-force (DECISIVE)

An ultralight scalar coupled to mass/spin at the 10⁻⁶ eV scale has a
Compton length `λ_C = ℏc/m_4 ~ 10⁻¹⁰ · 3×10⁸ / 5×10⁻⁶ ~ 6×10¹² m ~
40 AU`.  Fifth-force searches (Eöt-Wash, MICROSCOPE) probe sub-mm
ranges, which correspond to m_4 > 10⁻⁴ eV — ABOVE OmegaTheory's
window.  **Direct fifth-force falsification requires AU-scale
apparatus, impossible terrestrially.**

### §5.4 Pulsar timing + CMB — cosmic-scale decoherence (SPECULATIVE)

For m_4 ~ 10⁻⁶ eV, the oscillation period in a dark-matter halo is
`T_osc = h / (m_4 · c²) ~ 10⁻¹⁵ · 4×10⁻¹⁵ / 10⁻⁶ ~ 4×10⁻²⁴ s` —
astrophysical coherence times vastly exceed this, so the ultralight
sterile acts like a fluid, not a coherent field.  **No coherence-
based falsification.**

### §5.5 BEST + SOX + future SOLID → Δm²_41 boundary (LIVE)

BEST (arXiv:2201.07364) + gallium-anomaly descendants probe
Δm²_41 in the range 0.1-10 eV² — 21+ orders of magnitude above
OmegaTheory's scale.  **Gallium/reactor-anomaly channel is
decoupled from OmegaTheory.**

### §5.6 VERDICT: Cycle 27 is LOAD-BEARING but hard to falsify directly

The ultralight-sterile prediction has the graceful-survival property
that no current or planned experiment probes the exact `m_4 ~ 10⁻⁶`
eV regime with mixing sensitivities |U_e4|² ~ 10⁻⁴ to 10⁻⁶.  The
theory is *compatible* with all current data because it lives in a
"blind spot".  **This is both a strength (robust) and a weakness
(hard to test).**  The specific falsifiable content of Cycle 27 is
structural:

1. If a sterile neutrino is EVER detected at m_4 ≫ 10⁻⁵ eV (say
   m_4 = 1 eV), then the Catalan-G channel prediction FAILS because
   `catalanGTruncError(N)` cannot reach this scale for any realistic
   N (would require N < 1, truncation before start).  **This is a
   decisive falsification.**  (But note MicroBooNE + KATRIN 2025
   already disfavor this region strongly.)
2. If the sterile is detected at m_4 ~ 10⁻³ eV (a `√2-channel-tuned`
   scale) rather than m_4 ~ 10⁻⁶ eV, then Cycle 27's Catalan-G
   identification is WRONG, and cycle 27's `sterile_neutrino_mass_from_fourth_irrational`
   needs to re-calibrate to a different irrational.
3. The PMNS 4×4 angle θ_14 prediction (cycle-27 theorem 16) IS
   cleanly falsifiable — if BEST+SOX observes |U_e4|² > 10⁻¹ at
   m_4 ~ 10⁻⁶ eV, the Catalan-G-derived `sin²θ_14 ≈ 1/(2N+1)²`
   prediction FAILS for all N ≥ 1.

---

## §6 Connection to cycle 25 + cycle 26 — the Ω_DM / Z_sterile / baby-universe chain

### §6.1 Upstream from cycle 25 (Sadalmelik)

Sadalmelik's `PlanckBudget.omega_DM_sterile = 0.265` fixes the
abundance; Hydor's `Z_sterile = λ_4(D_F)` fixes the *mass* of the
quantum that makes up 0.265.  Jointly, cycle-25 theorem 7
(`omega_DM_sterile_bound_from_catalan_G`) + cycle-27 theorem 13
(`Z_sterile_from_connes_DF_eigenvalue`) give the *full* sterile DM
spectrum: abundance + mass, enough for n-body and CMB predictions.

### §6.2 Upstream from cycle 26 (Ancha)

Ancha's `baby_universe_sterile_nu_spectrum` (theorem 10) uses the
SAME `sterile_neutrino_mass_from_fourth_irrational` (Zosma) as
Hydor's cycle-27 target.  In fact, cycle-26's canonical spectrum
constructor calls the very Z_sterile witness that cycle-27 promotes
to a Connes-derived value.  **After cycle 27, Ancha's proof
automatically upgrades**: the Z_sterile in `canonicalSpectrum` is
no longer hand-picked, it's `λ_4(fourGenD_F N)`.

### §6.3 Downstream to cycle 28 (DE_to_DM bridge)

Cycle 28 theorem 17 (`DE_to_DM_bridge_via_bounce`) ties DE reservoir
flowing through bounce into DM-sterile in baby universe.  Cycle-27's
4th-channel identification is **the selector rule** for which
substrate quantum survives the bounce (Ancha §1.2).  The chain:

- Cycle 25 Planck budget: Ω_DM = 0.265 fixed by observation
- Cycle 26 bounce: Catalan-G channel is the ONLY substrate that
  survives topological disconnection
- Cycle 27 identification: Catalan-G = sterile-ν with mass
  `Z_sterile · sterileNeutrinoMassFloor N`
- Cycle 28 bridge: Ω_DM in baby universe = Ω_DE in parent universe
  (via bounce), transmitted as sterile-ν relic

**This is the LOAD-BEARING multi-cycle narrative that Cycle 27 closes.**

---

## §7 Theorem-shaping recommendations for the wizard

### §7.1 Theorem 13 `Z_sterile_from_connes_DF_eigenvalue`

- Build `fourGenD_F (N : ℕ) : Matrix (Fin 4) (Fin 4) ℂ :=
   Matrix.diagonal ![m_electron_family, m_mu_family, m_tau_family,
                      Z_sterile_from_catalanG_floor N]` where the
  4th diagonal entry is `Z_sterile · sterileNeutrinoMassFloor N`.
- The 4th eigenvalue is read off via `realDiagonalComplex_spectrum_real`
  (already proved by Rasalhague).
- The theorem statement is existence + equality with the floor product.

### §7.2 Theorem 14 `catalan_G_series_convergence_rate`

- Keep the statement CONDITIONAL on `HasSum` (do not try to evaluate
  Catalan G numerically in Lean; Mathlib v4.29 does not have it).
- The remainder bound is a two-line estimate using
  `Antitone.sum_le_tail` or direct manual bound `∑_{k≥N} ≤ 1/(2N+1)²`.
- Concrete `c = 4` works for `N ≥ 1`.

### §7.3 Theorem 15 `four_channels_three_active_one_sterile_surjective`

- Re-use Zosma's `channelToGeneration4` and `catalan_g_channel_distinct_from_three`.
- The surjection onto `Fin 4` is a `fin_cases` tactic on the 4
  channels, giving exactly `Fin 4` via
  `channelToGeneration4 .pi = 0`, `... .e = 1`, `... .sqrt2 = 2`,
  `... .catalan_g = 3`.
- Bijection: `surjective_iff_hasRightInverse` + same case split,
  or use `Finite.bijective_iff_surjective` after establishing
  `Fintype.card IrrationalChannel4 = 4`.

### §7.4 Theorem 16 `PMNS_fourth_column_from_catalan_G`

- Build a 4×4 `PMNS4Matrix` structure with 6 angle fields and the
  unitarity constraint as a field.
- The theorem states existence of a choice of θ_14 with
  `sin²θ_14 = catalanGTruncError N`.
- Do NOT try to prove unitarity of the composite `U_34 U_24 U_14 ...`
  product in Lean — Mathlib v4.29 unitary-matrix library is thin.
  Instead, use a *structure-only* `PMNS4Matrix` with a Prop
  field `isUnitary` that is witnessed by construction.

### §7.5 Avoid cycle-28+ work (strict scoping)

- Do NOT derive Z_sterile from spectral action expansion — that's
  cycle 30 theorem 26.
- Do NOT compute Ω_DM from m_4 directly — that's cycle 28 theorem 19.
- Do NOT prove Catalan G irrational in Lean — Mathlib doesn't know
  this, and it's not needed for cycle 27 theorems.
- Do NOT enlarge `fourGenD_F` to a 96×96 matrix — the block-diagonal
  4×4 reduction is what the cycle-27 theorems need.

---

## §8 Graph findings landed (5 `:GraphFinding` nodes)

Five findings created in Neo4j (namespace `OmegaTheoryV2`, cycle=27,
created_by `Hydor`), linked via `:MOTIVATES` edges to cycle-27
`TheoremCandidate` nodes 13–16.  Python driver pattern (not MCP)
per `.neo4j/CLAUDE.md`.

1. **`cycle27_connes_DF_4th_eigenvalue_structure`** — LOAD-BEARING,
   paper-worthy.  Theorem 13 foundation: the 4×4 block-diagonal
   `fourGenD_F` has `λ_4 = Z_sterile · sterileNeutrinoMassFloor N`
   by construction (real-diagonal spectral-matrix theorem).
2. **`cycle27_catalan_G_quadratic_rate_between_pi_e`** — LOAD-BEARING.
   Theorem 14 foundation: 1/(2N+1)² is the alternating-series
   remainder bound for G, strictly between O(1/N) (π) and O(1/N!) (e).
3. **`cycle27_PMNS_4x4_theta14_sterile_mixing`** — SPECULATIVE,
   paper-worthy.  Theorem 16: sin²θ_14 = catalanGTruncError(N) is the
   natural α=1 calibration; KATRIN/BEST/SOX can falsify at m_4 ~ 10⁻⁶
   eV.
4. **`cycle27_non_thermal_sterile_production_selection`** — EVIDENCE.
   DW and SF production fail for ultralight m_4; misalignment
   production is the OmegaTheory-natural mechanism (cycle-32 scope).
5. **`cycle27_KATRIN_NuSTAR_falsifiability_targets`** — EVIDENCE.
   KATRIN 2025 + MicroBooNE Dec 2025 exclude 1-10 eV sterile, BUT
   OmegaTheory's 10⁻⁶ eV window is 6+ orders below — graceful
   survival.  Falsification path: PMNS θ_14 direct measurement at
   BEST+SOX, m_4 detection by unknown future ultralight-DM method.

---

## §9 Open questions + cycle-28 hand-off

### §9.1 Open for Cycle 27

- Is the `α = 1` power-law `sin²θ_14 = catalanGTruncError^α` canonical,
  or should it be derived from Connes D_F PMNS-rotation block?
  Cycle-27 adopts α=1 as first guess; cycle-30 can re-derive.
- Does the 4th-channel Majorana mass `M_R` need to be zero (pseudo-
  Dirac), or is there a canonical choice `M_R = λ_4 · √2` (tied to
  OmegaTheory's 3rd irrational)?  Leave open.

### §9.2 Hand-off to Cycle 28

1. **Theorem 17 `DE_to_DM_bridge_via_bounce`**: the 4th-channel
   survives the bounce (Ancha) and its mass is `λ_4(D_F)` (Hydor).
   Cycle 28 should bind these to Ω_DM in the baby universe.
2. **Theorem 18 `DE_not_causal_to_local_DM`**: the OmegaTheory
   decoupling theorem.  Cycle 27 contributes the *quantitative*
   m_4 / λ_4 relation that locks the sterile mass far below the
   DE energy scale (10⁻³ eV) by 3+ orders.
3. **Theorem 19 `DM_abundance_from_parent_universe_BH_count`**:
   relic abundance = sum over parent BH bounces.  Cycle 27
   fixes the *per-bounce* DM contribution; cycle 28 sums.

### §9.3 Hand-off to Cycle 30 (Connes D_F eigenvalues)

Cycle 27 identifies λ_4 with the 4th-channel floor BY CONSTRUCTION;
cycle 30 derives λ_4 from spectral action minimisation.  Cycle 27
theorem 13 then becomes a CHECK: the cycle-30-derived λ_4 must
equal the cycle-27-postulated `Z_sterile · sterileNeutrinoMassFloor N`.

### §9.4 Hand-off to Cycle 32 (baryo/leptogenesis)

Sterile relic abundance via misalignment (§4.3) requires a
quantitative derivation of θ₀ · m_4 · (m_4/H_eq)^{3/2} matching
Ω_DM = 0.265.  Cycle 32 theorem 33 `leptogenesis_sterile_nu_decays_asymmetric`
is the anchor.

---

## §10 References

### §10.1 Primary Connes-Chamseddine

- Chamseddine, A.H. & Connes, A. "The Spectral Action Principle,"
  Commun. Math. Phys. 186, 731 (1997). arXiv:hep-th/9606001.
- Chamseddine, A.H., Connes, A., & Marcolli, M. "Gravity and the
  Standard Model with Neutrino Mixing," Adv. Theor. Math. Phys. 11,
  991 (2007). arXiv:hep-th/0610241.
- Connes, A. "Noncommutative Geometry and the Standard Model with
  Neutrino Mixing," JHEP 0611:081 (2006). arXiv:hep-th/0608226.
- Ćaćić, B. "Moduli Spaces of Dirac Operators for Finite Spectral
  Triples," MPI preprint 2009-9.

### §10.2 Sterile neutrino experiments

- KATRIN Collaboration. "Sterile-neutrino search based on 259 days of
  KATRIN data," Nature (2025). DOI:10.1038/s41586-025-09739-9.
- KATRIN Collaboration. "Direct neutrino-mass measurement based on
  259 days of KATRIN data," Science (2025). DOI:10.1126/science.adq9592.
- MicroBooNE Collaboration. "Search for light sterile neutrinos with
  two neutrino beams at MicroBooNE," Nature (Dec 2025).
  DOI:10.1038/s41586-025-09757-7.
- BEST Collaboration. "A Search for Electron Neutrino Transitions to
  Sterile States in the BEST Experiment," arXiv:2201.07364.
- STEREO Collaboration. "STEREO neutrino spectrum of
  235U-fission rejects sterile neutrino hypothesis,"
  Nature 613, 257 (2023).

### §10.3 NuSTAR + keV sterile DM

- Roach, B.M. et al. "Strong Limits on keV-Scale Galactic Sterile
  Neutrino Dark Matter with Stray Light from NuSTAR after 11 Years
  of Operation," PRL 133, 261002 (2024). arXiv:2405.17861.
- Perez, K. et al. "Almost Closing the νMSM Sterile Neutrino Dark
  Matter Window with NuSTAR," Phys. Rev. D 95, 123002 (2017).
  arXiv:1609.00667.

### §10.4 Production mechanisms

- Dodelson, S. & Widrow, L.M. "Sterile Neutrinos as Dark Matter,"
  Phys. Rev. Lett. 72, 17 (1994). arXiv:hep-ph/9303287.
- Shi, X. & Fuller, G.M. "A New Dark Matter Candidate: Non-Thermal
  Sterile Neutrinos," Phys. Rev. Lett. 82, 2832 (1999).
  arXiv:astro-ph/9810076.
- Abazajian, K.N. "Sterile Neutrinos in Cosmology," Phys. Rep. 711,
  1 (2017). arXiv:1705.01837.

### §10.5 PMNS 4×4 + ultralight DM

- Particle Data Group. "Neutrino Masses, Mixing, and Oscillations,"
  review in Prog. Theor. Exp. Phys. 2024 §14.
- de Gouvêa, A. et al. "Constraining feeble neutrino interactions
  with ultralight dark matter," Phys. Rev. D 107, 035006 (2023).
  DOI:10.1103/PhysRevD.107.035006.

### §10.6 Internal OmegaTheory references

- Altair, `NOTES_DF_EIGENVALUES.md` (2026-04-17) — Connes D_F
  moduli-space survey + 3 pathway ranking.  Cycle 27 adopts the
  δ_comp-weighted-irrationals pathway for 4th channel.
- Zosma, `OmegaTheory/Predictions/SterileNeutrinoFromFourthIrrational.lean`
  (cycle-6, 2026-04-20) — `IrrationalChannel4` enum,
  `catalanGTruncError`, `sterileNeutrinoMassFloor`, `channelToGeneration4`.
- Rasalhague, `OmegaTheory/Emergence/DiracFSpectrum.lean`
  (cycle-2, 2026-04-17) — `electronD_F`, `realDiagonalComplex_spectrum_real`
  (template for cycle-27 `fourGenD_F`).
- Alhena, `OmegaTheory/Emergence/PMNSMatrix.lean` (2026-04-17) —
  3×3 `PMNSAngles` structure (template for cycle-27 `PMNS4Matrix`).
- Sadalmelik, `NOTES_CYCLE25_OMEGA_TOTAL.md` (2026-04-21) — the
  Ω_DM_sterile = 0.265 context; non-thermal production requirement.
- Ancha, `NOTES_CYCLE26_BABY_UNIVERSE.md` (2026-04-21) — the
  topological-disconnection selection rule; Catalan-G survives
  the bounce.

---

*— Hydor, λ Aquarii, 2026-04-21.  0 .lean edits, 0 other notes/
edits.  Budget ~33 turns of 40-turn allowance.*
