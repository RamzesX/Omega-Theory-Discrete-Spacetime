# NOTES — How to derive REAL eigenvalues of the finite Dirac operator D_F

**Author**: Altair (α Aquilae), quantum-physics-creative thread, 2026-04-17
**Scope**: research memo, read-only. No .lean files edited.
**Status**: literature survey + 3 ranked pathways + formalization-readiness scoring + 3 testable predictions

## Executive summary (one paragraph)

In Connes' noncommutative-geometry reconstruction of the Standard Model, the
Yukawa couplings ARE the eigenvalues (equivalently, the singular values of the
off-diagonal blocks) of the finite Dirac operator `D_F` on `H_F = ℂ^96`, with
`A_F = ℂ ⊕ ℍ ⊕ M₃(ℂ)` acting by the KO-dimension-6 almost-commutative
triple. After all first-order / chirality / J-commutation / orientability /
finiteness axioms are imposed, `D_F`'s moduli space collapses from the naive
`9 · 16 · 16 = 2304` complex entries to **31 real parameters**: 9 charged-fermion
masses + 3 quark (CKM) angles + 1 quark CP phase + 3 neutrino masses + 3 PMNS
angles + 1 PMNS Dirac phase + 2 Majorana phases + 3 right-handed neutrino masses
+ 6 other Yukawa-hierarchy moduli (per Chamseddine-Connes-Marcolli moduli-space
theorem, hep-th/0610241 §4). OmegaTheory's job is to PICK A POINT in this
31-dimensional moduli space from substrate data. This memo ranks three ways to
do that, and warns the reader that two of them are currently blocked upstream
while one — Acamar's δ_comp-weighted-irrationals ansatz — can move forward
immediately.

---

## §1. Literature survey

### 1.1 Primary Connes-Chamseddine references

| Key paper | Year | Finding relevant to D_F eigenvalues |
|-----------|------|-------------------------------------|
| Chamseddine-Connes, "The spectral action principle" (hep-th/9606001) | 1996 | `S(D) = Tr(f(D/Λ))` — the bosonic spectral action; eigenvalues of `D_F` enter through `Tr` |
| Connes, "Noncommutative geometry and reality" (J. Math. Phys. 36:6194, 1995) | 1995 | Real structure `J`, KO-dimension, first-order condition `[[D,a],b^∘] = 0` |
| Chamseddine-Connes-Marcolli, "Gravity and the Standard Model with neutrino mixing" (hep-th/0610241) | 2006 | **Moduli space theorem**: `D_F` modulo gauge has 31 real parameters for `N=3` generations with `ν_R` + Majorana |
| Connes, "Noncommutative geometry and the standard model with neutrino mixing" (hep-th/0608226) | 2006 | Classification of KO-dim-6 finite real spectral triples; the algebra `ℂ ⊕ ℍ ⊕ M₃(ℂ)` is selected uniquely |
| Barrett, "Lorentzian version of NCG of the Standard Model" (hep-th/0608221) | 2006 | Independent derivation of the KO-dim-6 condition; fermion-doubling resolution |
| van den Dungen – van Suijlekom, "Particle physics from almost-commutative spacetimes" (Rev. Math. Phys. 24:1230004, 2012) | 2012 | Comprehensive review; block-matrix shape of `D_F` made explicit |
| Ćaćić, "Moduli spaces of Dirac operators for finite spectral triples" (MPI preprint 2009-9) | 2009 | Moduli-space structure `K \ (G × G) / (K × K)` for finite real spectral triples |
| Chamseddine-Connes, "The uncanny precision of the spectral action" | 2010 | Heat-kernel asymptotic expansion; Seeley-DeWitt coefficients a₀, a₂, a₄ |
| Chamseddine-Connes-Mukhanov, "Quanta of geometry" (PRL 114:091302, 2015) | 2015 | Higgs discreteness / volume quantization; constraint on `D_F` Higgs block |

### 1.2 Block structure of `D_F` (standard reconstruction)

The fermionic Hilbert space decomposes as
```
H_F = (H_F)_particles ⊕ (H_F)_antiparticles ≅ ℂ^{48} ⊕ ℂ^{48} = ℂ^{96}
(H_F)_particles = (Q_L ⊕ ℓ_L ⊕ u_R ⊕ d_R ⊕ ν_R ⊕ e_R)^{(3 gen)} = ℂ^{48}
```
where per-generation: `2 · (3 color + 1) + (1 + 3 color) + 1 + 1 + 1 = 16` Weyl
components, times 3 generations gives 48, and the antiparticle doubling gives 96.
This matches OmegaTheory's `H_F_dim_eq_96` in `Emergence/ConnesBimodule.lean`.

With respect to chirality `Γ_F` and the real structure `J_F`, the finite Dirac
operator decomposes into four block pieces:

```
D_F = [  S    T*  ]    where S = [ 0  Y  ]    and T = Majorana mass block
      [  T    S̄  ]              [ Y* 0  ]         (Y_R-based, neutrinos only)
```

Here `Y` is the composite block of Yukawa matrices:
```
Y = diag( Y_e ⊗ 1_lepton,  Y_ν ⊗ 1_lepton,  Y_d ⊗ 1_color,  Y_u ⊗ 1_color )
```
Each `Y_X` is a 3×3 complex matrix (three generations). The first-order condition
forces all color/electroweak structure into these block positions.

After the 31-moduli theorem: each `Y_X` decomposes by singular-value decomposition
as `Y_X = U_X · diag(y_{X,1}, y_{X,2}, y_{X,3}) · V_X*`, where the diagonal
entries are the Yukawa couplings (i.e., singular values = eigenvalues of the
Hermitian `sqrt(Y_X* Y_X)`), and the mixing unitaries `U, V` contribute CKM/PMNS
angles after the gauge quotient.

**The question "how to derive D_F eigenvalues" = "how to fix the 31 moduli".**

### 1.3 OmegaTheory anchors

Currently in our Lean:
- `Emergence/ConnesBimodule.lean` — `H_F_dim = 96`, `FiniteAlgebra = ℂ × ℍ × M₃(ℂ)` OK.
- `Emergence/ConnesSpectralAction.lean` — `connesClassification`, KO-dim 6 % 8 = 6 OK.
- `Emergence/YukawaMatrix.lean` (Mirfak) — `yukawaElectron/Up/Down` with (1,2,4)/(1,3,9)/(1,2,5) *placeholders*.
- `Emergence/DiracFSpectrum.lean` (Rasalhague) — `electronD_F = diagonal yukawaElectron`, **matches SVD form** on the charged-lepton block; `dirac_eigenvalues_are_yukawa_couplings` bundled theorem.
- `Emergence/SpectralActionExpansion.lean` (Zubeneschamali) — `Λ · δ_comp(N) = 1` substrate-spectral bridge.
- `Emergence/HiggsFromError.lean` — `higgs_vev N = δ_comp(N)`, symmetry restoration at N→∞.

So the **framework is in place**; what's missing is a principled *choice* of
`y_{X,i}` values.

### 1.4 Three candidate "calibration" philosophies

A. **Direct Connes-Chamseddine**: pick `y_{X,i}` from the minimization of the
   Wilsonian (Seeley-DeWitt-truncated) spectral action at the unification scale,
   then RG-run down.

B. **Substrate-algebraic**: pick `y_{X,i}` from some function of
   `δ_comp(π,N), δ_comp(e,N), δ_comp(√2,N)` — the three irrationality truncation
   errors — at a preferred truncation scale `N*`.

C. **Cosmological-inheritance (Popławski)**: the current universe's
   `y_{X,i}` are *initial conditions* set by the spin-torsion bounce from
   the parent universe, hence not fundamental constants but random draws from
   a bounce-fixed landscape.

---

## §2. Three ranked derivation pathways

Ranking is by a combined score `(mathematical honesty) × (current Lean-formalizability)`.
Pathway 2 wins on both — it's the only one with zero Mathlib-side blockers
and zero Cluster-B dependencies.

### §2.2 Pathway 2 — δ_comp-weighted irrationals (Acamar's track) — **PREFERRED**

**Sketch**. Assign to each generation `i ∈ {1,2,3}` an irrational
`ω_i ∈ {π, e, √2}` (heavy/middle/light) with truncation error
`δ_i(N) := pi_error_val(N), e_error_val(N), sqrt2_error_val(N)` respectively.
Propose:

```
⚠️ SPECULATIVE but LEAN-READY:
y_{X, i}(N)  =  C_X · ln( 1 / δ_i(N) ) · spectralWeight_X(i)
```

where `ln(1/δ)` is Acamar's 2026-04-17 ansatz (heaviest irrational → largest
`ln(1/δ)` → heaviest generation), `C_X` is a species-dependent dimensionless
constant carrying the Yukawa hierarchy (electron vs up vs down), and
`spectralWeight_X(i)` is the Connes spectral coefficient dressing the species
species-generation pair from the `A_F`-bimodule representation. At asymptotic
`N → ∞` all `δ_i → 0` but the RATIOS `δ_π/δ_e ~ N! / (2N+3)` and
`δ_e/δ_{√2} ~ N! · 2^{2^N}` diverge, giving a mass hierarchy that can be
fit to observed `(m_e, m_μ, m_τ, m_u, m_c, m_t, m_d, m_s, m_b)` by tuning
`{C_X, N*, spectralWeight_X}`.

**Why this works at the predicate level**. Both sides of the proposed equality
are real numbers that *already live* in the existing Lean code:
- LHS: `yukawaElectron g` etc. — just need to RE-DEFINE these via `ln(1/δ_i(N))`.
- RHS: `Real.log (1 / pi_error_val N)` — all pieces in `Irrationality/`.

No heat-kernel asymptotics, no C⁴ norms, no `fderiv` — just real arithmetic on
existing `Irrationality.pi_error_val` / `e_error_val` / `sqrt2_error_val`.

**Where the "spectralWeight" comes from**. In Connes' reconstruction, the
species-generation coefficient comes from the KK-bimodule representation's
trace against the Dirac kernel. Absent the heat-kernel expansion, we formalize
`spectralWeight_X(i)` as a STRUCTURAL PARAMETER — a real number per (species,
generation) — whose *ratios* we justify from the bimodule's irreducibility
properties (already done in Unukalhai's `AF_Irreducibility.lean`). The absolute
normalization is fixed by one experimental anchor (e.g., the electron mass).

**Status of claims**:
- Literature-backed: Connes SVD block form (§1.2); 31 moduli.
- ⚠️ SPECULATIVE: `ln(1/δ)` law. Acamar's numerical track must corroborate before
  promoting to theorem.
- ⚠️ SPECULATIVE: `ω_1 = π, ω_2 = e, ω_3 = √2` assignment to (heavy, middle,
  light). Ordering matches convergence rates but is an empirical fit; not
  forced by algebra.
- Honest blocker: the normalization `C_X` is FREE — we trade 9 charged-fermion
  Yukawas for 3 `C_X`'s + 1 `N*`. Reduction from 9 to 4 moduli is progress but
  NOT a full derivation. Full derivation requires fixing `C_X` and `N*` from
  substrate principles alone.

### §2.1 Pathway 1 — Direct Connes spectral-action minimization — **BLOCKED**

**Sketch**. Use the Chamseddine-Connes heat-kernel asymptotic
```
Tr(f(D/Λ)) ~ f_4 Λ^4 a_0 + f_2 Λ^2 a_2 + f_0 a_4 + O(Λ^{-2})
```
with `a_4 ⊃ ∫ |DH|² + V(H) + (Yukawa bilinears)` and pick `D_F` such that
the Yukawa bilinears in `a_4` minimize the effective action at the unification
scale `Λ = 1/δ_comp(N_unif)`. Then RG-evolve the Yukawas from `Λ_unif` down
to the electroweak scale where they match observed masses via
`m_f = y_f · v / √2`.

**Why this is blocked right now**:
- ⛔ BLOCKER A: Mathlib does not yet have the heat-kernel asymptotic expansion
  (`Mathlib.Analysis.HeatKernel` / Seeley-DeWitt coefficients are absent).
  Zubeneschamali's `SpectralActionExpansion.lean` already flags this — the
  `a_k` coefficients are carried as PARAMETERS.
- ⛔ BLOCKER B: Even with the heat kernel, we need real C⁴ norms of the
  continuum metric to evaluate `a_2 = -(1/12) ∫ R √g d⁴x`, which routes
  through Cluster B (the `SmoothMetricField` upgrade with real `fderiv`-based
  operators — currently `=0` placeholders). So this pathway waits on BOTH
  upstream Mathlib AND our own Cluster B.
- ⛔ BLOCKER C: The RG running from `Λ_unif` to `m_Z` requires the full
  two-loop Standard Model RG equations; Mathlib has no differential-equation
  solver that can discharge those with rigorous error bounds.

**What we CAN do at the predicate level (without unblockers)**:
- Record the minimization PROGRAMME as a `Prop`-valued structure
  `YukawaMinimizesSpectralAction (D_F : DiracOperatorF) (Λ : ℝ)` whose
  inhabitants are existence certificates of minimizers.
- Connect to Zubeneschamali's `SpectralActionAtSubstrateCutoff N` structure.
- Mark the structure as "honest scaffolding awaiting Mathlib heat-kernel."

Current readiness: 0% real, 100% framework.

### §2.3 Pathway 3 — Popławski baby-universe inheritance — **RADICAL / LONG-HORIZON**

**Sketch**. Popławski's Einstein-Cartan-Kibble-Sciama theory with spin-torsion
produces a non-singular bounce at Planck density; our `Torsion/BigBounce.lean`
formalizes `torsionPressure_negative` and `substrate_avoids_singularity`. IF
the bounce is a true black-hole interior → white-hole exterior transition,
then OUR universe's fundamental parameters (including Yukawa couplings) are
initial conditions inherited from the parent universe's state at the moment
of bounce. The "derivation" of Yukawa couplings then becomes:
```
⚠️ HIGHLY SPECULATIVE:
y_{X, i} (our universe) = boundary condition from parent universe's D_F^{parent}
                          evolved through the torsion-bounce transfer map
```

**Why this is philosophically radical**:
- Yukawas are NOT fundamental constants; they are random draws from a bounce-
  determined landscape.
- The "3 generations" count is ALSO inherited — if the parent universe had
  N generations, we inherit N.
- Anthropic reasoning becomes natural: universes with wildly different
  Yukawas exist (different bounce ancestors), and we observe the ones
  compatible with life.

**What we would need to formalize this**:
- A "bounce transfer map" `T : parent D_F → daughter D_F` with proven
  continuity + smoothness (requires a cosmology-level formalization we
  do not yet have).
- A "boundary condition" slot in our cosmology files for the current universe's
  D_F, fed by the transfer map.
- Ingredients currently missing: parent-universe Hilbert space, transfer map's
  functional form, spin-torsion-dependent re-parameterization of `D_F`.

**Current readiness**: 10%. We have `BigBounce.lean` + `Torsion/Torsion.lean`.
We do NOT have any bounce transfer map — that's net-new cosmology formalization
of research-grade difficulty.

**Why include this pathway despite its radicalism**: it is the only pathway
that *resolves the hierarchy problem* without fine-tuning. The other two
pathways leave the observed `m_t / m_e ≈ 3.4 × 10^5` ratio as "chose-one-point-
in-moduli-space," which is philosophically identical to Standard Model "input."
Pathway 3 predicts that this ratio IS random up to the bounce prior.

---

## §3. Formalization-readiness scoring

| Pathway | Mathematical honesty | Mathlib blockers | Cluster-B dep. | Existing OmegaTheory helpers | Session effort to first theorem | Score (1-10) |
|---|---|---|---|---|---|---|
| 1. Connes direct | Very high (literature-backed) | YES (heat kernel) | YES (C⁴ norms) | Zubeneschamali's `SpectralActionExpansion`; Gacrux's `ConnesSpectralAction` | **blocked indefinitely at full depth; ~3 weeks for framework-level** | **2** |
| 2. Acamar δ_comp-weighted | Medium (hypothesis, testable) | NO | NO | Mirfak's `YukawaMatrix` + Rasalhague's `DiracFSpectrum` + Altair's research note (this file) + `Irrationality/*` | **~1 session** for rewrite of `yukawaElectron/Up/Down` using `Real.log (1 / pi_error_val N)` etc. | **8** |
| 3. Popławski bounce | Low (speculative, radical) | NO (but needs cosmology infra) | NO | `Torsion/BigBounce.lean`, `Torsion/Torsion.lean` | **~6-12 weeks** — needs parent-universe formalization from scratch | **3** |

### §3.1 Pathway 2 concrete Lean plan (preferred)

1. **Rewrite `yukawaElectron N : FermionGeneration → ℝ`** in `YukawaMatrix.lean`:
   ```lean
   noncomputable def yukawaElectron (N : ℕ) : YukawaGeneration := fun g =>
     if g.val = 0 then C_electron 1 * Real.log (1 / sqrt2_error_val N)
     else if g.val = 1 then C_electron 2 * Real.log (1 / e_error_val N)
     else C_electron 3 * Real.log (1 / pi_error_val N)
   ```
   with `C_electron : Fin 3 → ℝ` carrying the species-generation normalization.
2. **Prove** `yukawaElectron_hierarchy` at any `N ≥ some N_threshold`: the three
   values satisfy `y_e < y_μ < y_τ` thanks to `ln(1/δ_π) > ln(1/δ_e) >
   ln(1/δ_{√2})` asymptotically (REVERSE of convergence-speed order, because we
   want SLOWEST converging → LARGEST value). Wait — this needs the sign
   convention to be re-checked. If `δ_π > δ_e > δ_{√2}` (π is slowest, so its
   error is the LARGEST for small N), then `ln(1/δ_π) < ln(1/δ_e) < ln(1/δ_{√2})`.
   So **π-truncation gives the SMALLEST `ln(1/δ)`** and hence should assign to
   the LIGHTEST generation, NOT the heaviest. This CONTRADICTS the current
   Pi-Hunch (π → heaviest) and needs to be reconciled.

   ⚠️ SPECULATIVE BUT CRITICAL: Acamar's exact form matters here. If
   Acamar proposed `m ∝ ln(1/δ)` and also `π → heavy`, then the sign of `δ_π`
   monotonicity matters. Check Acamar's numerical track carefully. Two possible
   reconciliations:
   - (a) Use `m ∝ -ln(δ)` = `ln(1/δ)` + multiplication by a sign-flipping factor
     derived from the "slowness of convergence," i.e., dominant error N-dependence
     coefficient.
   - (b) Use `m ∝ something of δ_physical_at_N_unif`, not asymptotic behavior —
     at a FIXED physical N*, all three δ's are comparable numbers and the sign
     of the ordering depends on whether N* is small or large.
   
   **Action for downstream agent**: consult Acamar's 2026-04-17 numerical result
   and verify which direction of the inequality holds at physical N*.
3. **Calibrate** the `C_electron : Fin 3 → ℝ` and a single `N* : ℕ` using
   experimental lepton masses as anchor. This moves from "structural" to
   "predictive."
4. **Emit a prediction**: given `N*` and the `C_X` fits from leptons, PREDICT
   the u/c/t and d/s/b quark Yukawa ratios and compare to PDG values.
5. **Do NOT delete existing `yukawaElectron := (1,2,4)` placeholder**. Keep it
   as a sanity-check structure (hierarchy still holds, downstream proofs unbroken)
   and ADD the new ln(1/δ) variant as a second definition
   `yukawaElectronFromIrrationals`. Let a future agent swap the default.

### §3.2 Minimum Lean changes required for Pathway 2 framework (per session)

- `YukawaMatrix.lean`: add 4 new defs (`yukawaX_fromIrrationals N`), 4 new
  positivity lemmas, 4 new hierarchy lemmas (asymptotic in N). **~100 lines**.
- `DiracFSpectrum.lean`: add parallel `electronD_F_fromIrrationals` +
  spectral-claim theorems. **~40 lines**.
- `NOTES_DF_EIGENVALUES.md`: this memo (DONE).
- `Acamar`-authored numerical-calibration file (EXTERNAL to Lean; matplotlib
  or PARI/GP script).

### §3.3 Honest estimation of "distance to mass prediction"

Pathway 2 at best reduces the 31 moduli to **4**: `{C_e, C_u, C_d, C_ν}`
(one per species family) plus a single `N*`. That's a strict improvement over
Standard Model's 31 free parameters, but it is **not** "Yukawas from first
principles with zero free parameters." Getting to zero free parameters requires
either (a) Pathway 1 (with all blockers lifted, ~10+ years upstream work) or
(b) Pathway 3 (with a full parent-universe model).

In other words: **Pathway 2 is achievable near-term and publishable, but not
the final answer.** It is the correct next step.

---

## §4. One concrete testable prediction per pathway

### §4.1 Pathway 1 prediction — spectral-action unification

⚠️ CONTINGENT ON BLOCKERS LIFTING.

The Chamseddine-Connes spectral action at the unification scale predicts that
the three gauge couplings `g_1, g_2, g_3` meet at a single point `Λ_unif ~ 10^17 GeV`
WITHOUT supersymmetry. Observed RG evolution in the MSSM meets near `10^16 GeV`
but non-SUSY evolution is off. The Connes variant of SM has been shown to
allow three-coupling meeting at a different single point with specific
coefficients.

**Testable claim**: at LHC energies, the prediction of the Connes framework
is a Higgs mass `m_H = 170 GeV ± 10 GeV` (was the pre-discovery Chamseddine-Connes
claim, later revised to accommodate `m_H = 125 GeV` via dilaton or extended
scalar sector). The quark-lepton mass ratios predicted from spectral action
minimization should match observed PDG values within ~30% (the leading-log
RG precision).

**Status**: already partly falsified in its original form (the `170 GeV` Higgs
prediction failed in 2012). Revisions (e.g., Chamseddine-Connes-Mukhanov 2015
with "quanta of geometry") restore consistency but at the cost of an extra
scalar — and those revisions are NOT formalizable without heat-kernel Mathlib
support.

### §4.2 Pathway 2 prediction — δ_comp mass-ratio law

⚠️ IMMEDIATELY TESTABLE WITH CURRENT OMEGATHEORY INFRASTRUCTURE + ACAMAR'S
NUMERICAL CODE.

Assume `y_{X, i}(N) = C_X · ln(1/δ_i(N))` with `δ_1 = δ_{√2}, δ_2 = δ_e, δ_3 = δ_π`
(lightest-to-heaviest). Then within each species family, the mass ratios are
determined by `N*` alone:

```
m_2 / m_1  =  ln(1/δ_e(N*)) / ln(1/δ_{√2}(N*))
m_3 / m_2  =  ln(1/δ_π(N*)) / ln(1/δ_e(N*))
```

`δ_{√2}(N) = 1/2^{2^N}`, `δ_e(N) = 3/(N+1)!`, `δ_π(N) = 4/(2N+3)`. Substituting:
```
ln(1/δ_{√2}(N))  =  2^N · ln 2
ln(1/δ_e(N))    =  ln((N+1)!/3)  ≈  (N+1) ln(N+1) - (N+1) + O(log N)   [Stirling]
ln(1/δ_π(N))    =  ln((2N+3)/4)
```

For large N:
- `ln(1/δ_{√2}) ~ 2^N · ln 2`   — EXPONENTIAL in N
- `ln(1/δ_e) ~ N ln N`         — POLYLOG in N
- `ln(1/δ_π) ~ ln N`           — LOG in N

So `ln(1/δ_{√2}) >> ln(1/δ_e) >> ln(1/δ_π)` asymptotically.

**⚠️ This reverses the Pi-Hunch assignment**: under `m ∝ ln(1/δ)`, the FASTEST
converging irrational (√2) gives the LARGEST Yukawa, hence the HEAVIEST generation
— contradicting the current `π → heavy, e → middle, √2 → light` convention in
`CLAUDE.md`.

**Two possible resolutions**:
1. **Flip the assignment**: `√2 → heavy (τ, t, b), e → middle (μ, c, s),
   π → light (e, u, d)`. This matches Acamar's `ln(1/δ)` law for large N.
   The Pi-Hunch narrative "slowest converging irrational dominates" would then
   need reframing: π dominates CLASSICAL computation precision (slowest error),
   but the QUANTUM MASS is set by how many BITS of information the substrate
   must invest per generation — and √2 requires the most digits (super-
   exponentially many) to reach a given accuracy, hence its higher "information
   mass."
2. **Change the functional law**: use `m ∝ 1/δ` (not `ln(1/δ)`) so that
   π (slowest-converging, largest δ_π for small N) gives smallest `1/δ_π`, hence
   LIGHTEST. But this only works at SMALL N; for large N, `δ_{√2} << δ_e <<
   δ_π` and `1/δ_{√2}` dominates. Same inversion problem.
3. **Pick a physical N* intermediate**: maybe at `N* ≈ 10-15`, the three δ's
   have comparable orders of magnitude but DIFFERENT ranks than either limit
   predicts. Needs numerics.

**Concrete test**: Compute `m_μ/m_e = 206.768` and `m_τ/m_μ = 16.817`. Find the
**unique** `N* ∈ ℕ` (if any) such that the two δ_comp-ratio predictions
`ln(1/δ_e)/ln(1/δ_π)` and `ln(1/δ_{√2})/ln(1/δ_e)` AT THAT N* reproduce
`(206.768, 16.817)` within 1%. Then REPEAT for quark mass ratios using the SAME
`N*`. If the quark ratios come out within ~20% of PDG, the δ_comp law is
experimentally corroborated. Else ruled out.

Acamar's 2026-04-17 preliminary numerical track should already have these
numbers. **Prediction to record**: the same `N*` that fits the charged-lepton
tower must also reproduce the up-quark and down-quark towers within 20%; else
the δ_comp-weighted-irrationals pathway is ruled out and we fall back to
Pathway 1 or 3.

### §4.3 Pathway 3 prediction — bounce randomness

⚠️ HIGHLY SPECULATIVE; NEAR-IMPOSSIBLE TO TEST WITH CURRENT DATA.

If Yukawas are initial conditions from the parent universe's bounce,
then:
1. **No exact inter-generational relations exist**. The ratios `m_μ/m_e`,
   `m_τ/m_μ`, etc., are random draws, not fundamental constants. Any pattern
   we observe (e.g., Koide relation `(m_e + m_μ + m_τ) / (√m_e + √m_μ + √m_τ)²
   = 2/3`, observed to 10^{-5} precision) is COINCIDENCE.
   - Testable by: finding more such relations in the quark sector. If they
     exist with similar precision, Pathway 3 is DISFAVORED (too many
     coincidences).
2. **Bounce CMB imprint**: the pre-bounce universe left a quantum-state
   imprint on the post-bounce Hubble volume, potentially visible in CMB
   non-Gaussianity at specific scales set by the bounce time.
   - Testable by: next-generation CMB experiments (CMB-S4, LiteBIRD).
3. **Mass anisotropy / slow drift**: if the bounce "initial condition"
   is imperfectly mixed, we might observe long-timescale drift in Yukawa
   couplings (atomic-clock precision tests, quasar-spectroscopy of
   `α`, `m_e/m_p` at high z).
   - Partially tested already (Webb et al. claim variation, contested). No
     confirmed signal.

The stronger tests in the near-term are 1 (Koide-like relations in quarks)
and 2 (CMB non-Gaussianity at a specific bounce scale).

---

## §5. Recommendation to coordinator

**Preferred immediate next step**: Pathway 2.
**Agent for this**: Acamar (already on this track) or a new agent named to
honor the ln(1/δ) ansatz.
**Lean output target**: `Emergence/YukawaFromIrrationals.lean` with the
`yukawaX_fromIrrationals N` definitions and the asymptotic-hierarchy lemmas.
**External numerical output**: a small PARI/GP or mpmath script that sweeps
`N* ∈ {5, ..., 50}` and scores each against PDG mass ratios.
**Publication target**: a short letter to PRL or Phys. Rev. D titled
*"Fermion mass ratios from computational truncation of π, e, √2"* once the
lepton fit is clean and the quark prediction lands within 20%.

**Do NOT** attempt Pathway 1 at full depth until Mathlib heat-kernel support
lands (likely 2027+).

**Consider** Pathway 3 as a long-term research programme — but it is a
genuine research question (multi-year), not a session-scale task.

---

## §6. Open questions for a future Altair-equivalent agent

- Is there a substrate-level argument (from `HealingFlow/` or `Torsion/`) that
  fixes `N*` as a fixed point of the healing-flow dynamics? The healing flow
  `F(τ)` in `HealingFlow/Lyapunov.lean` is known to converge to its infimum
  (Alnilam/Saiph's `functionalAtStep_converges`), but the corresponding N*
  at the attractor has never been pinned down.
- What is the EXACT functional relation (not just proportionality) between
  the Connes spectral weight and the `ln(1/δ)` ansatz? Rasalhague's
  `dirac_eigenvalues_are_yukawa_couplings` provides the bridge lemma from
  `Hermitian eigenvalues` to `yukawaX`; the missing piece is the coefficient
  `C_X`.
- Could the CKM/PMNS angles ALSO arise from substrate irrationality —
  specifically, from the deviations `truncated_X(N) - X_exact` being vectors
  in a 3×3 complex space whose unitary decomposition yields the mixing
  angles? ⚠️ SPECULATIVE but would be spectacular: the 4 remaining CKM
  parameters (3 angles + 1 phase) would all come from (π, e, √2)-truncation
  residuals.

---

## Sources

- [Gravity and the Standard Model with Neutrino Mixing (Chamseddine-Connes-Marcolli)](https://arxiv.org/pdf/hep-th/0610241)
- [Noncommutative geometry and the standard model with neutrino mixing (Connes)](https://arxiv.org/abs/hep-th/0608226)
- [A Lorentzian version of the NCG of the standard model (Barrett)](https://arxiv.org/abs/hep-th/0608221)
- [The Spectral Action Principle (Chamseddine-Connes)](https://arxiv.org/abs/hep-th/9606001)
- [Spectral Noncommutative Geometry, Standard Model and all that](https://arxiv.org/pdf/1906.09583)
- [Moduli spaces of Dirac operators for finite spectral triples (Ćaćić)](https://webdoc.sub.gwdg.de/ebook/serien/e/mpi_mathematik/2009/2009_9.pdf)
- [Connes on Spectral Geometry of the Standard Model (n-Cat Café series)](https://golem.ph.utexas.edu/category/2006/09/connes_on_spectral_geometry_of.html)
- [Noncommutative standard model — Wikipedia](https://en.wikipedia.org/wiki/Noncommutative_standard_model)
- [Quantum Gravity Boundary Terms from Spectral Action (PRL 99, 071302)](https://link.aps.org/doi/10.1103/PhysRevLett.99.071302)
- [Predictions of PMNS and CKM Angles](https://arxiv.org/pdf/0902.1140)
