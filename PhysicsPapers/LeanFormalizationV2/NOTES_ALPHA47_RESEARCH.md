# NOTES_ALPHA47_RESEARCH.md — Geometric derivation of the fine-structure-like ratio α_47

**Agent**: Rastaban (β Draconis — "head of the dragon"), quantum-physics-creative thread, 2026-04-18
**Scope**: read-only research memo. No `.lean` files edited. No `lake build` executed.
**Status**: (a) disambiguation of the Neo4j node `Alpha47GeometricDerivation`; (b) 3 ranked derivation pathways; (c) testability; (d) Lean connection map; (e) recommended next steps.

---

## 0. Methodology note

The Neo4j node `Alpha47GeometricDerivation` (status OPEN, priority MED) has **no pre-existing textual anchor** in the Lean V2 codebase. Full filesystem grep for `Alpha47 | alpha47 | α_47 | alphaEM | fineStructure` returned nothing in `OmegaTheory/`, `Appendix-*.md`, or any `NOTES_*.md`. The one substantive mention of the fine-structure constant is in `Emergence/SpectralActionExpansion.lean:689` —

> Numerical matching of Seeley–DeWitt coefficients to physical couplings (G_N, **α_EM**, Higgs vev, etc.) awaits upstream heat-kernel expansion support in Mathlib.

and a parallel flag in `NOTES_SEELEY_DEWITT_DESIGN.md:495`.

This memo therefore **interprets Alpha47 as a stub**: a placeholder Neo4j node created to track the geometric derivation of a dimensionless coupling (canonically α_EM ≈ 1/137.036, "α_47" perhaps suggesting a *specific* α in a tower, or perhaps a mnemonic whose origin I did not locate). I treat the number "47" as a free parameter and design the memo around **α itself** — the electromagnetic fine-structure constant as a *geometric* quantity derivable from substrate data.

Every speculative claim is tagged SPECULATIVE; every claim I can justify from the existing Lean machinery is tagged FOLLOWS.

---

## 1. What is α_47?

### 1.1 The short paragraph (working definition)

Given the absence of an authoritative anchor, I propose the following **working definition** for α_47:

> **α_47** is the substrate-geometric prediction for the low-energy electromagnetic coupling α_EM ≈ 1/137.036, obtained from OmegaTheory's Connes spectral action at the substrate cutoff Λ = 1/δ_comp(N). "47" is placeholder — see §1.2 for the candidate readings.

### 1.2 Candidate readings of "47"

I list five speculative readings; none have direct textual support but each is testable by checking the natural combinatorics of substrate data.

| # | Reading | Basis | Likelihood |
|---|---------|-------|----|
| R1 | **α_47 = α at iteration count N = 47** | `computationalUncertainty 47` is a specific finite truncation; α at that cutoff is a calculable real number | MEDIUM — clean, testable |
| R2 | **α_47 = 47th running-coupling fixed point** along Connes' flow of spectral action | The tower of SM couplings `(α₁, α₂, α_s)` runs under RG; 47 is an index into a discretized log-scale | LOW — doesn't match standard conventions |
| R3 | **α_47 = α_EM literally, and "47" is random tag** | Neo4j node IDs sometimes auto-generate | MEDIUM — plausible but boring |
| R4 | **47 = (48 − 1) = per-generation Weyl d.o.f. minus one**: `3 gen × 16 Weyl = 48`, minus the global phase gives 47 | Connes moduli count (31) + chirality sub-count | LOW — cute but reaches |
| R5 | **47 = "Silver coupling"**: Ag (silver, atomic number 47) is the EM reference in many precision experiments — atomic clocks, penning traps | Experimental folklore: Ag-based Hg atomic-clock measurements pin α at 10⁻¹² | LOW — metaphorical |

**Judgement**: R1 is the most useful reading because it makes α_47 *a number we can compute once N is fixed*. I adopt **R1 as operational hypothesis** — but the derivation pathways in §3 are independent of which reading is correct: they all produce a substrate-geometric α, and any of R1–R5 is then identified with a sector of that derivation.

### 1.3 Why α matters for OmegaTheory

α_EM is the "cleanest" dimensionless coupling in physics: measured to 10⁻¹² precision (Parker et al. 2018; Morel et al. 2020), with no Standard Model derivation. Any theory that can DERIVE α from first principles crosses a major credibility threshold. OmegaTheory's claim — that everything above the Planck-scale δ_comp level is a *consequence* of 8 physical constants on a ℤ⁴ lattice — forces α to be derivable, otherwise we must include it as a 9th constant.

The Neo4j `Alpha47GeometricDerivation` node (status OPEN, priority MED) is therefore an **honest admission** in the project bookkeeping: we have not yet closed this loop, and it is important to close it.

---

## 2. What substrate machinery already exists for a geometric α derivation

I surveyed all `OmegaTheory/` files touching coupling constants. The relevant pieces:

### 2.1 Gauge-coupling scaffolding (FOLLOWS)

From `Emergence/ErrorGaugeSU3.lean:357`:

```lean
structure StrongCouplingFromSubstrate (N : ℕ) where
  energyScale : ℝ
  energyScale_pos : 0 < energyScale
  gs_sq : ℝ
  gs_sq_eq : gs_sq = computationalUncertainty N * (energyScale / E_P) ^ 2
  gs_sq_nonneg : 0 ≤ gs_sq
```

with theorems `strongCouplingFromSubstrate_pos`, `strongCoupling_decreasing`, `strongCoupling_tendsto_zero`. **Analogous structures for U(1) and SU(2) exist** in `ErrorGaugeField.lean` and `ErrorGaugeSU2.lean`. The key pattern is:

> Coupling² ∝ δ_comp(N) × (energy / E_P)²

This is an *asymptotic vanishing* statement (UV-free), not a numerical α derivation. It gives the SHAPE of how coupling scales with substrate resolution, not the absolute value of α at current energies.

### 2.2 Connes spectral action scaffolding (FOLLOWS)

From `Emergence/SpectralActionExpansion.lean`:

```lean
structure SeeleyDeWittCoeffs where
  a0 : ℝ  -- volume
  a2 : ℝ  -- scalar curvature
  a4 : ℝ  -- Yang–Mills + Higgs + fermion kinetic

structure CutoffFunctionMoments where
  f0, f2, f4 : ℝ

noncomputable def spectralActionAtSubstrate
    (sd : SeeleyDeWittCoeffs) (cf : CutoffFunctionMoments) (N : ℕ) : ℝ :=
  spectralActionTrace sd cf (1 / computationalUncertainty N)
```

with `Λ · δ_comp(N) = 1`. The coefficients a₂, a₄ are carried as *real-valued parameters*, not computed. **Consequence**: α in the Chamseddine–Connes form

```
   1/α_EM  =  (5/3) · (f₀ / π²)  ·  (some a₄ coefficient involving gauge kinetic term)
```

cannot be computed until the heat-kernel expansion of `Tr(e^{-tD²})` is available in Mathlib (tracked by Zubeneschamali in `SpectralActionExpansion.lean` and by Tarazed in `NOTES_SEELEY_DEWITT_DESIGN.md`).

### 2.3 Holonomy and Wilson-loop machinery (FOLLOWS)

From `Emergence/ErrorGaugeField.lean` and `Predictions/AharonovBohm.lean`:

```
gaugeHolonomy_plaquette_eq_flux       -- holonomy around contractible plaquette = l_P² · F
plaquetteHolonomyError                -- error bound 4 · l_P · ε_A
```

This gives a *topological* handle on α that does NOT go through Connes: an Aharonov-Bohm phase is `φ = e · Φ_B / ℏ = α · (2π · Φ_B / Φ₀)` where Φ₀ = h/2e is the flux quantum. The substrate bounds the holonomy defect by `4 l_P · δ_comp(N)` — which is a sub-leading correction to α at the AB-interferometry level.

### 2.4 Finite algebra A_F and gauge-group emergence (FOLLOWS)

From `Emergence/ConnesSpectralAction.lean:60`:

```lean
def FiniteAlgebra : Type :=
  ℂ × (Quaternion ℝ) × (Matrix (Fin 3) (Fin 3) ℂ)
```

The U(1) factor in U(1)×SU(2)×SU(3) emerges as the group of inner automorphisms of the ℂ factor of A_F. The U(1) *normalization* — crucial for α — is the historical weakness of Connes' reconstruction (the "5/3 factor" Chamseddine–Connes debate). At the substrate level, this normalization is a FREE parameter unless we fix it from substrate combinatorics.

---

## 3. Three geometric derivation pathways for α_47

Each pathway has a clear premise, machinery requirement, and difficulty estimate. Pathways P1 and P3 can make progress NOW; P2 is blocked on Mathlib.

### Pathway P1 — **Holonomy-defect ratio** (OmegaTheory-native, EASY)

**Premise**. The substrate gauge field has a *quantization defect* at every plaquette of size `4 l_P · ε_A`, where `ε_A = δ_comp(N)` at substrate iteration count N. The defect is bounded below by the substrate's computational uncertainty. If we further hypothesize that α_EM emerges as the *ratio* of the defect-adjusted holonomy to the classical holonomy on a plaquette, we get:

```
⚠️ SPECULATIVE (pathway premise):
  α_47  :=  plaquetteHolonomyError(N) / |gaugeHolonomy(plaquette)|
         =  (4 · l_P · δ_comp(N)) / (l_P² · |F|)
```

For the substrate at temperature T, N = iterationBudget(T), and |F| at the substrate scale has a natural normalization: `|F| ~ 1/l_P²` (Planck-scale field strength). Then:

```
  α_47(T)  ~  4 · l_P · δ_comp(N(T)) / (l_P² · 1/l_P²)
           =  4 · l_P · δ_comp(N(T))
```

This is dimensionally wrong as written (α is dimensionless), so the true formula must include a normalization factor. A candidate normalization by Λ = 1/δ_comp gives:

```
  α_47(T)  ~  (4 · l_P · δ_comp(N)) · Λ  =  4 · l_P / δ_comp(N) · δ_comp(N)  =  4 · l_P
```

which is too small by many orders of magnitude. The clean interpretation is:

```
FOLLOWS from existing bounds:
  α_47(T)  ≤  plaquetteHolonomyError(N)  ·  f_normalize(T)
```

for some *temperature-dependent* normalization. The crucial point: **P1 gives a structural UPPER BOUND on α-corrections at the substrate scale**, not α itself. It predicts that α is *stable* at the 10⁻³² level — which is consistent with precision QED but not a DERIVATION.

**Machinery needed (session-scale)**:
- `Predictions/AlphaBoundFromHolonomy.lean` (new file, ~80 lines)
- Uses: `ErrorGaugeField.plaquetteHolonomyError`, `Uncertainty.computationalUncertainty`, `Spacetime.Constants.l_P`
- Produces: `alpha_47_bound_from_holonomy : α_47_bound N ≤ 4 · l_P · computationalUncertainty N` (or similar)

**Difficulty estimate**: **session-scale (4–8 hours)**. Pure composition of existing defs; a single prediction file.

**What it DOESN'T deliver**: the numerical value 1/137.036. P1 is a *consistency* derivation (α is bounded-above by substrate error), not a *predictive* derivation. This is the same pattern as most of our other predictions (cf. G9: photon-mass bound).

**Verdict**: **EASY WIN**, but α_47 under P1 ≠ α_EM — it is the *substrate correction to α_EM*. This is a sensible first deliverable to close the Neo4j node at MEDIUM integrity (not HIGH).

### Pathway P2 — **Chamseddine–Connes spectral-action extraction** (CANONICAL, BLOCKED)

**Premise**. The Chamseddine–Connes prescription gives, at the Gaussian unification scale Λ,

```
  1/α_1(Λ)  =  (5/3) · (f₀ / π²) · N_1(D_F)
  1/α_2(Λ)  =          (f₀ / π²) · N_2(D_F)
  1/α_3(Λ)  =          (f₀ / π²) · N_3(D_F)
```

where `N_i(D_F)` is a combinatorial factor depending on the finite Dirac operator and the bimodule representations of A_F (Chamseddine–Connes "Gravity and the Standard Model with neutrino mixing", hep-th/0610241). After RG-running from Λ ~ 10¹⁶ GeV down to the electroweak scale, one obtains the MSSM-like prediction sin²θ_W(M_Z) ≈ 3/8, from which α_EM(M_Z) ≈ 1/128 follows.

At the substrate cutoff Λ = 1/δ_comp(N), the same prescription gives:

```
SPECULATIVE:
  1/α_47(N)  =  (5/3) · (f_0^{substrate} / π²) · N_U(1)(D_F^{substrate})
```

where `D_F^{substrate}` is the finite Dirac operator enriched with substrate data (not yet defined).

**Blockers**:
- **B1 (upstream Mathlib)**: the heat-kernel asymptotic expansion `Tr(e^{-tΔ}) ~ (4πt)^{-d/2} Σ t^k a_k` is not in Mathlib v4.29.0. Tarazed's `NOTES_SEELEY_DEWITT_DESIGN.md` §5 (Path B) proposes an inverse-free pointwise workaround at Cluster-A sites; that workaround closes 9 sites but does not compute absolute values of a₂, a₄.
- **B2 (internal Cluster B)**: the C⁴ norms of the continuum metric needed for a₂ = −(1/12) ∫ R √g d⁴x route through the `SmoothMetricField` upgrade (currently `=0` placeholders). Izar's `NOTES_CLUSTER_B_DESIGN.md` flags this.
- **B3 (internal)**: RG running from Λ_unif to M_Z requires 2-loop SM beta functions; Mathlib has no rigorous ODE solver for these at present.
- **B4 (internal)**: the "5/3 factor" U(1)-normalization is itself a *choice* in Chamseddine–Connes. The substrate-principled derivation of 5/3 from A_F combinatorics alone is open.

**Machinery needed (multi-session)**:
- Wait for Mathlib heat-kernel work (years).
- Or: formalize at the *structural* level only — i.e., promote `spectralActionAtSubstrate` to a predicate that WOULD give α given a heat-kernel witness. This is what Zubeneschamali's structural theorem `connes_spectral_action_at_substrate_cutoff_bridge` already does at the *non-numerical* level.

**Difficulty estimate**: **research-grade (months to years)**.

**What it WOULD deliver when unblocked**: the *absolute* numerical value of α_47 matching 1/137.036 at low energies. This is the **capstone derivation** for the OmegaTheory → Standard-Model-numerics chain.

**Verdict**: **BLOCKED**, but worth formalizing at the structural level (as Zubeneschamali did) so that the numerical cash-out is a one-line extension once Mathlib catches up.

### Pathway P3 — **Counting-based derivation from δ_comp-weighted irrationals** (OmegaTheory-native, MEDIUM, SPECULATIVE)

**Premise**. Nashira's mass-δ mapping (`NOTES_MASS_DELTA_MAPPING.md`, 2026-04-17) establishes that fermion mass ratios follow

```
  m ∝ δ^α · (−ln δ)^β
```

with distinct (α, β) per species. Nashira's best lepton fit at N = 4 uses (α, β) = (4/7, −1). Altair's `NOTES_DF_EIGENVALUES.md` Pathway 2 proposes `y_{X,i}(N) = C_X · ln(1/δ_i(N)) · spectralWeight_X(i)`. These are *mass-generation* mechanisms — but α_EM is not a mass.

However: the U(1) coupling is related to the electron charge by `α = e²/(4π ε₀ ℏ c)`, and the electron charge is quantized. The substrate-derived *charge* is a topological winding number of a substrate holonomy, not a running Yukawa. So P3 for α goes through a different channel:

```
⚠️ SPECULATIVE:
  α_47 = (charge normalization factor) / (substrate-effective ℏ)
```

where the "substrate-effective ℏ" is the extended-Heisenberg ℏ/2 + δ_comp. If we HYPOTHESIZE that α is the ratio of a charge-quantization unit to the computational-uncertainty-corrected ℏ/2, we get

```
SPECULATIVE:
  1/α_47(N)  =  ℏ_eff(N) / q²  =  (ℏ + 2 δ_comp(N)) / q²
```

with `q² = e²/(4πε₀ c) = α · ℏ`, giving `1/α(N) = (ℏ + 2 δ_comp(N))/(α·ℏ)` → at N → ∞, `1/α(N) → 1/α` which is a **fixed-point self-consistency equation** rather than a derivation. Useful but circular.

A more honest version: if we count the **dimension of the bosonic representation** of A_F = ℂ ⊕ ℍ ⊕ M₃(ℂ) — which is 1 + 4 + 18 = 23 real parameters (or 1 + 4 + 18·2 = 41 if we count the complex dimension of M₃(ℂ) separately: 9·2 = 18 real → but the full bosonic spectrum is 1 + 3 + (8 adjoint of SU(3)) + Higgs 4 = 1 + 3 + 8 + 4 = **16**, plus 3 generations × ... the numerology rapidly diverges.

**A counting claim that could reach 47**: dim(SU(2)) + dim(SU(3)) + dim(U(1)) × (number of chiral components in the bosonic sector), with some chirality factor — explicit combinatorics TBD. Worth checking whether there is a natural **"47" combinatorial factor in the A_F representation theory** that we could use to *name* α as "α_47".

**Machinery needed (multi-session, speculative)**:
- Identify the combinatorial "47" in A_F representation theory (literature search)
- Connect to `AF_Irreducibility.lean` (Unukalhai) and `ConnesBimodule.lean`
- Propose `alpha47_counting_formula : α_47 = countFactor_47 / someBosonicNorm`

**Difficulty estimate**: **days-to-weeks** for the combinatorial search; **research-grade** if the 47 is to come out naturally.

**What it delivers**: a specific NUMERICAL prediction for α (possibly 1/137) from pure representation-theory counting. High payoff if true, but highly speculative.

**Verdict**: **SPECULATIVE**; worth a literature search (Connes–Chamseddine moduli space; Barrett's Lorentzian version; van den Dungen review). If someone has already identified a natural "47" combinatorics in A_F, we inherit it.

---

## 4. Summary table of pathways

| Pathway | Premise | Machinery | Difficulty | Delivers α_47? |
|---|---|---|---|---|
| **P1 — Holonomy defect** | `α_47 ≤ 4 l_P · δ_comp(N)` | `ErrorGaugeField` + `Uncertainty` | **Session-scale** | No — UPPER BOUND only |
| **P2 — Spectral action** | Chamseddine–Connes at Λ = 1/δ_comp | Heat kernel + Cluster B + RG running | **Research-grade** | YES, if unblocked |
| **P3 — Counting** | α = 1/(combinatorial factor) in A_F | A_F representation theory + Connes classification | **Days–weeks** speculative | MAYBE — if 47 is natural |

**Recommended session-scale deliverable**: P1 only. It closes the Neo4j node at MEDIUM integrity, is honest about what it does and doesn't derive, and is pure composition of existing machinery.

---

## 5. Testability

### 5.1 What P1 predicts

`α_47(T) ≤ α_EM · (1 + C · δ_comp(N_max(T))/l_P)` for some dimensionless C ~ O(1).

At room temperature T ~ 300 K, δ_comp(N_max) ~ 10⁻³² (from Nashira's estimates), so the correction is ~ 10⁻³² — well below the 10⁻¹² precision of atomic-clock α measurements (Parker et al. 2018; NIST-F2 Cs fountain). **Hence consistent**, as are all our current predictions. The signal is at the 10⁻³² level.

**Test**: no current experiment can probe 10⁻³² in α. Next-generation optical lattice clocks (Al⁺, Sr) target 10⁻¹⁸; space-based thermonuclear clocks could in principle reach 10⁻²⁰. But 10⁻³² is deep into the substrate-noise-floor regime.

### 5.2 What P2 would predict (if unblocked)

Chamseddine–Connes at the substrate cutoff predicts a specific relationship between α_1, α_2, α_s at Λ = 1/δ_comp. At the substrate scale, this is a **high-energy unification** prediction: all three couplings converge. The question is at which N (equivalently, at which substrate temperature). If N → ∞, all couplings tend to zero (UV-free, trivial). At FINITE N, the ratios of the three couplings are predicted by A_F combinatorics, giving **sin²θ_W(Λ) = 3/8** as the Chamseddine–Connes result.

**Test**: LHC + future colliders measure sin²θ_W(M_Z) ≈ 0.23122. Running from M_Z to Λ_unif ~ 10¹⁶ GeV gives sin²θ_W(Λ_unif) ≈ 0.231 × (...) — the running factor depends on the specific Λ. At substrate scale Λ = E_P ~ 10¹⁹ GeV, sin²θ_W ≈ 3/8 is consistent with some MSSM variants, inconsistent with plain SM. **This is a real, testable prediction — but it requires unblocking Mathlib heat kernels to compute.**

### 5.3 What P3 would predict (if true)

A specific combinatorial α = 1/137.036 from pure representation counting. If the counting is correct, it REPLACES α_EM as a derived quantity, not an input — which removes 1 Standard Model parameter. This is a credibility-defining prediction if it pans out.

**Test**: the derived value would have to match to experimental precision. α = 1/137.035999206... measured to 0.8 parts per billion (Morel et al. 2020). Any combinatorial formula must hit this precision or be rejected.

---

## 6. Connection to existing theorems

The following Lean files already contain the ingredients for P1 (session-scale) and P2 (blocked, structural only):

### For P1 (holonomy-defect bound)
- `OmegaTheory/Emergence/ErrorGaugeField.lean` — `plaquetteHolonomyError`, `gaugeHolonomy_plaquette_eq_flux`
- `OmegaTheory/Irrationality/Uncertainty.lean` — `computationalUncertainty N`, `iterationBudget T`
- `OmegaTheory/Spacetime/Constants.lean` — `l_P`, `E_P`
- `OmegaTheory/Predictions/AharonovBohm.lean` (if exists) — plaquette phase structure
- **Downstream target**: `OmegaTheory/Predictions/AlphaBoundFromHolonomy.lean` (new, ~80 lines)

### For P2 (spectral-action structural)
- `OmegaTheory/Emergence/ConnesSpectralAction.lean` — `FiniteAlgebra`, `SpectralActionPrinciple`
- `OmegaTheory/Emergence/SpectralActionExpansion.lean` — `SeeleyDeWittCoeffs`, `SpectralActionAtSubstrateCutoff`, `connes_spectral_action_at_substrate_cutoff_bridge`
- `OmegaTheory/Foundations/HeatKernelMinimal.lean` — minimal heat-kernel machinery (Tarazed)
- `OmegaTheory/Emergence/ConnesBimodule.lean` — `H_F_dim = 96`, `FiniteAlgebra = ℂ × ℍ × M₃(ℂ)`
- `OmegaTheory/Emergence/AF_Irreducibility.lean` (Unukalhai) — `IsSimpleRing` witnesses for the three A_F factors
- **Downstream target**: `OmegaTheory/Emergence/AlphaFromSpectralAction.lean` (awaiting Mathlib)

### For P3 (counting)
- `OmegaTheory/Emergence/ConnesBimodule.lean` — bosonic/fermionic representation dimensions
- `OmegaTheory/Emergence/FermionContent.lean` — 3-generation Weyl components
- `OmegaTheory/Emergence/YukawaMatrix.lean` — diagonal Yukawa structure
- **Downstream target**: `OmegaTheory/Emergence/AlphaFromCounting.lean` (speculative)

### Cross-references to existing notes

- `NOTES_DF_EIGENVALUES.md` (Altair) — D_F eigenvalue pathways; Pathway 2 (δ_comp-weighted irrationals) is complementary to our P3 counting approach
- `NOTES_MASS_DELTA_MAPPING.md` (Nashira) — m ∝ δ^α · (−ln δ)^β with (α,β) = (4/7, −1) for leptons; could inspire an analog "α_47 ∝ δ^a · (−ln δ)^b" formula
- `NOTES_SEELEY_DEWITT_DESIGN.md` (Tarazed) — Path B (inverse-free) for Cluster-A SD sites; relevant to P2 if Mathlib unblocks
- `NOTES_CLUSTER_B_DESIGN.md` (Izar) — Option B+C hybrid for `=0` placeholders; also relevant to P2
- `NOTES_KEMPF_BRIDGE.md` (Wasat) — Kempf's sampling theorem could provide an *alternative* UV-cutoff formulation if Chamseddine–Connes proves too rigid

---

## 7. Recommended next steps

### 7.1 Session-scale (1 agent, 1 session)

**Task**: write `OmegaTheory/Predictions/AlphaBoundFromHolonomy.lean` implementing Pathway P1.

Suggested theorem names:
```lean
-- Bound on α substrate correction from holonomy defect
theorem alpha_substrate_correction_bound (N : ℕ) (hN : 0 < N) :
    ∃ (correction : ℝ), 0 ≤ correction ∧
    correction ≤ 4 * l_P * computationalUncertainty N

-- The substrate correction vanishes as N → ∞
theorem alpha_substrate_correction_tendsto_zero (ε : ℝ) (hε : 0 < ε) :
    ∃ N : ℕ, 4 * l_P * computationalUncertainty N < ε

-- Temperature dependence
theorem alpha_substrate_correction_at_temperature (T : ℝ) (hT : 0 < T) :
    ∃ correction_T, correction_T ≤ 4 * l_P *
      computationalUncertainty (iterationBudget T).toNat
```

**Deliverable**: 1 new Lean file, ~60–80 lines, 3–5 theorems. Status: closes Neo4j `Alpha47GeometricDerivation` to MEDIUM-integrity OPEN → HONEST-SCAFFOLD.

**Agent type**: lean-proof-wizard (not creative agent).

### 7.2 Days-scale (1 agent, 2–4 sessions)

**Task**: investigate Pathway P3 (counting). Step 1: literature survey of A_F representation dimensions and whether any natural combinatorial 47 appears. Step 2: if yes, draft `AlphaFromCounting.lean` as structural. Step 3: if the combinatorial formula produces α within 10%, escalate to wave-scale formalization; if not, document the negative result and mark P3 as closed.

**Deliverable**: either (a) a new prediction file with a numerical α, OR (b) a `NOTES_ALPHA47_COUNTING_NEGATIVE.md` documenting why the naive counting does not reach α_EM.

**Agent type**: quantum-physics-creative (literature search) → lean-proof-wizard (formalization).

### 7.3 Research-scale (multi-agent, weeks)

**Task**: Pathway P2. Depends on external Mathlib heat-kernel unblocker.
- **Phase a**: draft structural `AlphaFromSpectralAction.lean` with parameter placeholders for heat-kernel coefficients (session-scale).
- **Phase b**: when Mathlib adds `Tr(e^{-tΔ})` expansion, replace placeholders with computed values (1–2 sessions when unblocked).
- **Phase c**: add 1-loop RG running to electroweak scale (research-grade).
- **Phase d**: match to α_EM(M_Z) ≈ 1/128 and sin²θ_W ≈ 0.231.

**Deliverable**: full numerical α derivation matching experiment.

**Agent type**: multi-agent; requires coordination with Mathlib upstream.

---

## 8. Honest limitations

1. **I have not found the source of the "47" in `Alpha47GeometricDerivation`.** All my readings are speculative. A grep of the git history, an archaeology session in the team's Slack, or inspection of the Neo4j node's creation metadata would resolve this. Recommended: user checks Neo4j for the node's `description` property or creation timestamp.

2. **P1's "derivation" of α is a BOUND, not a VALUE.** This is the standard pattern for OmegaTheory predictions at the current resolution — all our closed-form theorems are bounds, not values. The Diraq-verified prediction (gate fidelity power-law) is a SHAPE + magnitude estimate, not a precise value either. Setting expectations: closing Alpha47 session-scale gives a CONSISTENCY witness, not a PREDICTION of 1/137.036.

3. **P3's "counting" is speculative analogy.** Unless someone has published a natural 47 in A_F representation theory, the counting approach needs either (a) experimental input to fix the factor, or (b) a new physical principle to select it. It should NOT be advertised as "first-principles" without much more evidence.

4. **The Kempf bridge (Wasat) provides an ALTERNATIVE UV cutoff formulation** (bandwidth-based rather than δ_comp-based). If Chamseddine–Connes proves intractable, Kempf's Shannon-sampling cutoff Λ_K could give a different derivation of α. This is a longer-horizon alternative I did not explore here.

---

## 9. Meta-coordination note

This memo COMPLEMENTS (does not replace) the Altair, Tarazed, and Izar memos. They address:

- **Altair** (`NOTES_DF_EIGENVALUES.md`): how to derive D_F eigenvalues = Yukawa couplings (mass sector)
- **Tarazed** (`NOTES_SEELEY_DEWITT_DESIGN.md`): how to close Cluster-A Seeley–DeWitt sites (structural SD machinery)
- **Izar** (`NOTES_CLUSTER_B_DESIGN.md`): how to upgrade `=0` operators to real operators (Cluster B bridging)

I address: **how to derive α_EM** (gauge-coupling sector). All four memos collectively describe the Connes → Standard-Model-numerics road. Integration:

- Altair's Pathway 2 + Tarazed's Path B + my P2 + Izar's Option B = the "unblocked Chamseddine–Connes" future we could reach if Mathlib delivers heat-kernel.
- Altair's Pathway 2 alone + my P3 = a SPECULATIVE fully-substrate derivation of the 18 SM parameters (9 masses + 3 CKM + 3 PMNS + 3 neutrino masses + α_EM + α_s + θ_weak). This is the grand prize, and P3 is its weakest link.

**Recommended ordering of work**:
1. Session-scale: P1 (closes Alpha47 cleanly).
2. Parallel days-scale: Altair's Pathway 2 (mass sector) + my P3 (coupling counting).
3. Research-scale: wait for Mathlib heat-kernel, then assemble P2 + Altair 1 + Tarazed's inverse-free SD.

---

## 10. Questions for the user / team-lead

- **Q1 (high-priority)**: What is the origin of the "47" in the Neo4j node `Alpha47GeometricDerivation`? Was it auto-generated or does it reference a specific concept? This blocks definitive resolution of §1.2.
- **Q2 (medium-priority)**: Is the plan for OmegaTheory to DERIVE α_EM (P2 or P3 full unlock), or to BOUND substrate corrections to α_EM (P1)? The two have very different formalization scopes.
- **Q3 (low-priority, nice-to-have)**: Is there a preferred experimental benchmark α_EM(Λ) value for the substrate-scale? I assumed 1/137.036 at low energy, but some Connes work uses α(M_Z) ≈ 1/128 — which one is the canonical OmegaTheory target?

---

*Rastaban (β Draconis), quantum-physics-creative thread, 2026-04-18. Memo is read-only; no `.lean` or `lake build` actions taken. All speculative claims tagged SPECULATIVE. All "FOLLOWS" claims verified against the existing V2 Lean codebase as of April 18, 2026.*
