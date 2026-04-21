# OmegaTheory V2 — Style Guide (Same Language)

**Purpose**: all theorems, definitions, and proofs speak the SAME language so they
compose cleanly. Post-cycle-43 revision: adds the patterns observed across
cycles 24–43 (Mekbuda backlog + Polaris grand capstone) on top of the cycle-2–23
conventions already in force.

**Verified against** the 60-theorem Mekbuda backlog (cycles 24–43), the
Grand Capstone V2 quartet (Polaris), and the full `OmegaTheory/Emergence/*.lean`
tree (132 files) as of 2026-04-21 (~211 total OmegaTheory files; 8,996 OWN
theorems on top of the 175,137-theorem Mathlib integration).

---

## 1. Naming conventions

### Theorems — base patterns (cycle 2–23 core)
```
<entity>_<property>              e.g., computationalUncertainty_pos
<entity>_<property>_of_<hyp>     e.g., ricciSymmetric_of_weinbergIdentity
<predicate>_iff_<predicate>      e.g., isEquilibrium_iff_fixedPoint
<quantity>_eq_<closed_form>      e.g., repairQuantumEnergy_eq_log5_pi
<thing>_tendsto_<limit>          e.g., substrateHopfError_tendsto_zero
<thing>_decreasing / _pos / _nonneg   standard suffixes
```

### Theorems — cycles 24–43 observed patterns (derived physics)
```
substrate_<physics>_<scope>
  e.g. substrate_electroweak_unification_theorem              (Castor 24)
  e.g. substrate_electroweak_unification_at_planck
  e.g. substrate_CHSH_violation

<quantity>_from_<source>
  e.g. SU3_color_from_three_irrationals                       (Tiaki 29)
  e.g. CKM_hierarchy_from_pi_e_sqrt2_ordering
  e.g. Z_sterile_from_connes_DF_eigenvalue                    (Hydor 27)
  e.g. U1_Y_from_photon_repair
  e.g. higgs_vev_from_substrate_scale
  e.g. dirac_vs_majorana_from_bounce_topology

<ratio>_<channel-pair>_from_<rule>_channel_ratio
  e.g. mass_ratio_e_mu_from_sqrt2_e_channel_ratio             (Avior 30)

<observable>_substrate_<numerical_qualifier>
  e.g. higgs_vev_substrate_eq_PDG
  e.g. higgs_vev_substrate_close_to_PDG
  e.g. higgs_vev_substrate_pos
  e.g. higgs_vev_substrate_headline
  e.g. sin2_theta_W_substrate_is_onshell
  e.g. sin2_theta_W_substrate_numerical_bounds

<A>_over_<B>_eq_<formula>        e.g. mW_over_mZ_eq_cos_thetaW
<A>_eq_<B>_times_<C>             e.g. mW_eq_mZ_times_cos_thetaW
<cosmology>_<witness>_<positivity>
  e.g. Ω_b_witness_nonneg, Ω_Λ_witness_nonneg, Ω_R_witness_nonneg
  (Greek ω/Ω are fine in identifiers per Lean 4)
```

### Theorems — paper-citation suffixes (cycle-23+ convention)
```
<topic>_paper_bundle             conjunction of the exportable facts for a paper §
  e.g. electroweak_unification_paper_bundle
  e.g. higgs_and_mass_hierarchy_paper_bundle
  e.g. connes_DF_yukawa_mass_paper_bundle

<topic>_headline                 one-line citation form used in the manuscript
  e.g. higgs_vev_substrate_headline
  e.g. higgs_and_mass_hierarchy_headline
  e.g. top_electron_ratio_headline
  e.g. higgs_mass_squared_substrate_headline

<topic>_first_<kind>_in_V2       "first" milestone marker — reserved
  e.g. connes_DF_yukawa_mass_first_matter_capstone_in_V2
  e.g. higgs_mass_hierarchy_first_bundle_in_V2
  e.g. SU3_color_first_channel_count_in_V2
```

### Theorems — grand-capstone naming (cycle 43, RESERVED)
```
grand_capstone_v2_substrate_<scope>
  Only one instance of this pattern is allowed per V2 arc:
    grand_capstone_v2_substrate_SM_plus_gravity_plus_DM_plus_DE

<theory>_<property>_are_exactly_<numeral>
  e.g. omega_theory_minimal_constants_are_exactly_eight

<theory>_<artefact>_witness_panel
  e.g. omega_theory_falsifiability_witness_panel

<numeral>_<kind>_necessary_and_sufficient
  e.g. four_irrationals_necessary_and_sufficient

<theory>_v<N>_final_meta_capstone
  e.g. omega_theory_v2_final_meta_capstone
  (reserved — do not overload; if a V3 arc begins, use v3_… etc.)
```

### Structures
```
<Name>Data        — bundle of parameters              e.g., FRWScaleFactorData
<Name>Bound       — upper/lower bound type            e.g., ErrorBound
<Name>Hypothesis  — Prop-valued assumption bundle     e.g., HpwHypothesis
<Name>Class       — typeclass                         e.g., ErrorLieBracket, ErrorLieAlgebra
<Name>Spectrum    — indexed-family bundle             e.g., DFEigenvalueSpectrum        (cycles 30+)
<Name>Channel     / <Name>Channel4
                  — enum of channels (e.g. generation slots)
                                                      e.g., IrrationalChannel4, SU3ColorChannel
<Name>Kind        — labelled variant                  e.g., FermionMassKind (dirac | majorana)
<Name>Bundle      — capstone / paper bundle structure
                                                      e.g., OmegaCapstoneV2Bundle
```

### Predictions
Every file in `Predictions/` follows:
```
<prediction>Substrate                         — the substrate's formula
<prediction>StandardQM                        — the SM/QM baseline (often = 0)
<prediction>_strictly_exceeds_standard_QM     — the distinguisher
<prediction>_pos / _nonneg / _monotone        — structural properties
<prediction>_closed_form                      — explicit formula reminder
```

### Enum/Channel projections (cycles 26–35)
```
<enum>ToGeneration<N>, channelToGeneration4   — surjections onto generation slots
<enum>_distinct_from_<other>                  — non-collision lemma
<enum>_bijective                              — bijection lemma
massKindOfChannel4_<channel>                  — per-channel kind projection
```

---

## 2. Shared primitives (USE these, don't re-invent)

| Concept | Primitive | File |
|---|---|---|
| Planck constants | `l_P`, `t_P`, `hbar`, `c`, `G_N`, `k_B`, `E_P`, `M_P` | `Spacetime/Constants.lean` |
| Positivity | `l_P_pos`, `t_P_pos`, `hbar_pos`, `c_pos`, `E_P_pos` | same |
| Nonnegativity | `l_P_nonneg`, etc. | same |
| Ne_zero | `l_P_ne_zero`, `c_ne_zero`, `t_P_ne_zero`, `hbar_ne_zero` | same |
| Substrate error | `computationalUncertainty N`, `dominantErrorBound N` | `Irrationality/Uncertainty.lean` |
| Error bound | `ErrorBound` (val + nonneg fields) | `Foundations/ErrorAlgebra.lean` |
| Lie bracket error | `substrateLieBracketError N` | `Foundations/ErrorLieAlgebra.lean` |
| Hopf error | `substrateHopfError N` | `Foundations/ErrorHopfStructure.lean` |
| Form error | `ErrorForm0/1/2/3` | `Foundations/ErrorForms.lean` |
| HPW bundle | `HpwHypothesis g` | `Emergence/HpwHypothesis.lean` |
| HPW regime class | `[HpwEliminableRegime g]` | `Emergence/HpwElimSummary.lean` |
| Smooth metric | `SmoothMetric` (Mizar) | `Geometry/SmoothMetric.lean` |
| Iteration budget | `iterationBudget T` | `Irrationality/Uncertainty.lean` |
| Mass-as-delay | `perTickDelay p m` | `Emergence/MassAsDelay.lean` |
| **4-channel irrational enum** | `IrrationalChannel4` | `Predictions/SterileNeutrinoFromFourthIrrational.lean` |
| **4-channel generation projection** | `channelToGeneration4` (+ `_bijective`) | same |
| **SU(3) color enum** | `SU3ColorChannel` (+ `.all`, `.all_nodup`) | `Emergence/SU3ColorAndNonAbelianF.lean` |
| **Connes finite spectrum** | `DFEigenvalueSpectrum`, `canonicalDFSpectrum` | `Emergence/ConnesDFYukawaMass.lean` |
| **Higgs VEV substrate** | `higgs_vev_substrate N` | `Emergence/HiggsVEVSubstrate.lean` |
| **Mass-kind labels** | `FermionMassKind` (`.dirac` \| `.majorana`) | `Emergence/HiggsAndMassHierarchy.lean` |
| **Catalan G truncation** | `catalanGTruncError N = 1/(2N+1)²` | `Irrationality/Approximations.lean` |
| **Sterile-ν calibration** | `Z_sterile`, `sterileNeutrinoMassFloor N` | `Predictions/SterileNeutrinoFromFourthIrrational.lean` |
| **Ω cosmology witnesses** | `Ω_b_witness`, `Ω_Λ_witness`, `Ω_R_witness`, `Ω_DMsterile_witness`, `Ω_K_witness` | `Emergence/OmegaTotalClosure.lean` |
| **Capstone V2 bundle** | `OmegaCapstoneV2Bundle` | `Predictions/OmegaTheoryGrandCapstoneV2.lean` |

**Rule**: if a primitive exists, USE it. Don't redefine under a new name.

---

## 3. Proof automation (try in order)

```lean
-- 1. First try AUTOMATED SEARCH
exact?              -- 30s Mathlib + local search
apply?              -- lemma application search
rw?                 -- rewrite search

-- 2. Then try MULTI-STEP automation
aesop               -- white-box best-first
grind               -- SMT solver (4.22+)
simp?               -- simp lemma discovery

-- 3. Then DOMAIN-SPECIFIC solvers
positivity          -- 0 < x or 0 ≤ x
ring                -- ring equalities
field_simp          -- clear denominators (then ring)
linarith            -- linear arithmetic
nlinarith           -- nonlinear
omega               -- integer arithmetic
decide              -- finite enumeration
native_decide       -- compiled enumeration
norm_num            -- numerics
push_cast           -- coercion pushing
fin_cases           -- case split on Fin n
gcongr              -- generalized congruence / monotonicity
fun_prop            -- continuity / differentiability

-- 4. Only AFTER automation fails, manual proof
```

### Cycle-24–43 bundle-proof idiom (paper_bundle / headline)
Reserved for **compositional** capstones. The rule of thumb from the Mekbuda arc:
```lean
/-- Paper bundle: composes already-proven upstream headlines. -/
theorem <topic>_paper_bundle (...) :
    <conjunction_or_structure> := by
  refine ⟨?_, ?_, ?_⟩
  · exact upstream_lemma_1 ...
  · exact upstream_lemma_2 ...
  · exact upstream_lemma_3 ...
```
The Grand Capstone V2 (`grand_capstone_v2_substrate_SM_plus_gravity_plus_DM_plus_DE`)
uses the `Inhabited <Bundle>` pattern instead — `noncomputable abbrev` of a
witness bundle structure plus `refine ⟨_, _, _, _, _, _, _⟩` unpacking directly
into cycle-24–42 theorem names. **Do not re-prove** any upstream numerical fit
inside a paper_bundle — compositional aliasing only.

---

## 4. Docstring pattern

Every theorem has a docstring:

```lean
/-- **Name in words** (one sentence).

    Longer explanation if needed: 2–3 sentences about what it means,
    why it matters, and how it connects to other theorems in the project.

    Cites: [Predictions §N / Appendix-X §Y] if paper-referenced.
    No `sorry`, no new axioms. -/
theorem my_theorem ...
```

### Capstone-class docstring (Polaris convention)
Capstones additionally declare:
- **PAPER HEADLINE** in bold
- A bullet list of conjuncts with their upstream citations (cycle + agent + theorem name)
- A "Design philosophy" paragraph marking it as a **propositional bundle** (no re-proof)

See `OmegaTheory/Predictions/OmegaTheoryGrandCapstoneV2.lean` for the template.

---

## 5. File header pattern

```lean
/-
  OmegaTheory.<Module>.<Name>

  **One-line headline**: what this file establishes.

  Background context (2-3 paragraphs).

  Theorems shipped:
    §1. `theorem_1` — one-liner
    §2. `theorem_2` — one-liner
    ...

  No `sorry`. No new axioms. Author: <star_name>, 2026-04-XX.
-/

import ...

namespace OmegaTheory.<Module>

open OmegaTheory.Spacetime
-- other opens
```

### Post-cycle-24 star-agent attribution
Cycle-24 onward files (Mekbuda backlog) customarily add:
- `**Agent**: <star> (<Bayer designation>, <spectral/distance note>).  Chosen
  because <thematic tie to the cycle topic>.`
- A `## Mission — cycle-NN entries X.Y–X.Y` section naming each theorem shipped.
- A `## Paper citation` stub giving the manuscript-side form.

---

## 6. Registration discipline

Every new file MUST be registered in `OmegaTheory/Basic.lean` (currently 3,292
lines, 9 layers) under the correct layer:

```
Layer 0: Foundations  (ErrorAlgebra, ErrorLieAlgebra, ErrorForms, ErrorHopf, TaylorBound)
Layer 1: Spacetime    (Lattice, Constants, Operators, CausalLattice)
Layer 2: Tensor       (ErrorTensor, Operations, ValuedGeometry, ValuedCurvature)
Layer 3: Geometry     (Metric, Connection, Curvature, DiscreteForms, ...)
Layer 5: Defects      (DefectTensor, Sparsity)
Layer 6: Conservation (Information, Noether, StressEnergy, Correspondence)
Layer 7: HealingFlow  (Functional, Flow, Lyapunov, Periodic, Convergence)
Layer 8: Emergence    (Einstein, HPW regimes, QM, Gauge theories, Cosmology,
                       Matter sector, Connes bridges — now 132 files)
Layer 9: Predictions  (falsifiable claims with specific formulas, grand capstones)
Layer 10: Torsion     (SpinTorsion, BigBounce, BabyUniverse)
Layer 11: Irrationality (Approximations, Uncertainty, PredictionsBridge, HermitePade)
Layer 12: Variational (GraphAction, DiscreteNoether)
Layer 13: Paper       (headline aliases for manuscript citation)
```

---

## 7. The "connect don't duplicate" rule

Before writing a new theorem:
1. **Grep** for similar names (`grep -rn "similar_name" OmegaTheory/`)
2. **exact?** search in a scratch Lean file
3. **Consult the graph**: Neo4j `(:Theorem {namespace:'OmegaTheoryV2'})` has 8,996
   OWN nodes + 175,137 Mathlib nodes — a kNN query via
   `lean_retriever_embedding_theorem` returns the 10 closest lemmas in milliseconds.
   See `.neo4j/CLAUDE.md` for queries.
4. Check the open **`:TheoremCandidate`** set (84 open post-cycle-43) and the
   **44 paper_worthy `:GraphFinding`** nodes — the graph may already predict a
   missing bridge with a target signature. Closing one of those earns a paper citation.
5. If already proven, CITE it. If close but not exact, COMPOSE.
6. Only write new if the gap is genuine.

---

## 8. Hard rules (enforced globally)

1. **0 sorry** — absolutely never
2. **0 new axioms** — the 8 physical constants (c, ℏ, G_N, k_B + their 4 positivities)
   are the complete axiom list. The 15 HermitePadé research conjectures and the
   1 π-transcendental axiom are tracked separately and do NOT license fresh adds.
3. **Must compile GREEN** — `~/.elan/bin/lake build --log-level=error`
4. **Register in Basic.lean** — no orphan files
5. **Quality over speed** — iterate until clean
6. **Speak the same language** — use primitives from §2, naming from §1
7. **No re-proof of numerical fits inside paper_bundle / headline theorems** —
   compositional aliasing only (Polaris capstone rule)
8. **Capstone-class names (`grand_capstone_v2_…`, `*_final_meta_capstone`)
   are reserved** — do not overload
9. **No edits to `.lean` outside `OmegaTheory/`** and no edits to
   `OmegaTheoryAlgebra/` or `V3-for-Lean/` (those are separate workflows)

---

## 9. Post-cycle-43 forward style (for cycles 44+)

Cycles 44+ close the remaining 84 `:TheoremCandidate` nodes and the 44 paper_worthy
`:GraphFinding` nodes. Expected new patterns that conform to this guide:

- `<mass>_absolute_from_connes_DF_<eigenvalue>` — for absolute particle-mass pinning
- `CP_phase_from_pi_truncation_time_reversal_asymmetry` — baryogenesis CP derivation
- `<prediction>_withinPercent_<N>_of_PDG` — explicit 1-% tightening claims
- `hermite_pade_<conjecture_id>_closed` — each HermitePadé conjecture closure

When in doubt, consult `OmegaTheoryAlgebra/GROTHENDIECK_MATH_PUZZLE.md` (Navi,
2026-04-21) — it names the MP-1 through MP-8 frontiers and, for each, predicts
1–3 target signatures in OmegaTheoryV2 naming style.

---

*Original team-lead draft: 2026-04-17. Post-cycle-43 revision: Polaris cycle,
2026-04-21. Update when new primitives emerge.*
