# OmegaTheory V2 — Open Theorems (Prop-marked, needing future work)

**Updated**: 2026-04-20 (cycle 8 → 9 transition, Wasat). Build state: **GREEN at 3285+ jobs** (post-reorg), 0 sorry, 0 new axioms, 8 physical-constant axioms.

## Recent deliverables (cycles 2-8)
The following items from earlier tiers have been formalized and are
*no longer open*:

- **Tier 2 #7 Clifford off-diagonal**: CLOSED by Tureis (Apr 17, 12 cases via 6 pair lemmas + `add_comm`).
- **Tier 2 #5 A_F irreducibility**: partial — `AF_Irreducibility.lean` (Unukalhai Apr 17) replaces `Prop := True` placeholders with real `IsSimpleModule` + `IsSimpleRing` witnesses.
- **Tier 1 #2 Neutrino mass floor W1**: shipped as `NeutrinoMassFloor.lean` + `NeutrinoMassFloorW1.lean`.
- **Tier 1 #3 Mixing angles**: shipped as `MixingAnglesFromIrrationals.lean`.
- **Tier 1 #4 LogarithmicGenerationMap**: ordering verified in `PiHunchMassOrdering.lean`; numerical ratios via `MassRatioNumerical.lean` (muOverE, tauOverMu, tauOverE) with `NashiraEmpiricalAnsatz` witness.
- **Tier 3 #11 Jarlskog**: shipped as `JarlskogFromIrrationals.lean`.
- **Cycle-9 (Wasat, 2026-04-20)**: `NumericalFitsCycle9.lean` — neutron-proton mass diff (1.293 MeV), muon/electron ratio (206.77), Higgs mass (125.10 GeV), bundled `Cycle9NumericalFits` witness.

**Open items retained below are still the active frontier.**

These are theorems currently shipped as `Prop := True` placeholders or conditional hypotheses. All buildable, all honestly scoped. Each represents a future deliverable.

---

## TIER 1: CAPSTONE (HIGH priority)

### 1. Yukawa mass equalities from D_F eigenvalues
**File**: `OmegaTheory/Emergence/YukawaMatrix.lean` (Mirfak)
**Claim**: Yukawa couplings for electron/muon/tau/neutrinos equal specific functions of Connes finite Dirac operator eigenvalues, giving observed masses.
**Blocker**: Needs spectral theory of finite Dirac operator + Connes spectral action expansion.
**Status**: framework shipped with `Prop := True` mass-equalities; structure ready for population.
**Difficulty**: CAPSTONE (months)

### 2. W1: Neutrino mass floor = δ_comp on √2 channel
**File**: `OmegaTheory/Predictions/NeutrinoMassFloor.lean` (to create)
**Claim**: Smallest neutrino mass = ℓ_P · minimum-lattice-delay ≈ 0.01-0.06 eV
**Experimental context**: DESI 2025 + KATRIN show 3σ tension at 0.059-0.064 eV — OmegaTheory's predicted window
**Difficulty**: MEDIUM

### 3. W3: Mixing angles from irrationals (PMNS large, CKM small)
**File**: `OmegaTheory/Predictions/MixingAnglesFromIrrationals.lean` (to create)
**Claim**: PMNS large angles from √2 fast-convergence spreading; CKM small from π slow-convergence locking
**Depends on**: `PMNSMatrix` (Alhena) + `CKMMatrix` (Algol) + `BoundsLemmas`
**Difficulty**: HARD

### 4. LogarithmicGenerationMap (3 irrationals → 3 generations)
**File**: `OmegaTheory/Irrationality/GenerationMap.lean` (to create)
**Claim**: `m_i ∝ ln(1/δ_i)` with Connes spectral weighting — ORDERING verified (π heavy, e middle, √2 light), RATIOS TBD
**Source**: Acamar 2026-04-17 numerical test
**Difficulty**: MEDIUM

---

## TIER 2: ALGEBRAIC GAPS (MED priority)

### 5. Irreducibility of A_F summands
**File**: `OmegaTheory/Emergence/ConnesBimodule.lean` (Alkaid)
**Claim**: ℂ, ℍ, M₃(ℂ) summands of A_F act as simple (irreducible) bimodules on H_F
**Blocker**: Needs Mathlib `Module.IsSimple` + Schur lemma machinery (not imported)
**Difficulty**: HARD

### 6. Full su(3) Jacobi identity (4096 cases)
**File**: `OmegaTheory/Emergence/ErrorGaugeSU3.lean` (Almach + Mizar²)
**Done**: isospin triple (0,1,2) proved
**Open**: 4093 remaining Gell-Mann structure constant combinations
**Blocker**: `native_decide` timeout with `Real.sqrt 3` crossterms
**Approach**: split `su3f = rational + √3·rational`, decide each over ℚ separately
**Difficulty**: MEDIUM

### 7. Clifford off-diagonal anticommutators (12 cases) — **CLOSED**
**File**: `OmegaTheory/Emergence/DiracEquation.lean` (Tureis)
**Done**: Diagonal `{γ^μ, γ^μ} = 2η^{μμ}·I` (4 cases proved, `gammaClifford_sq`)
**Done**: Off-diagonal `{γ^μ, γ^ν} = 0` for μ≠ν (all 12 cases proved, `gammaClifford_offDiagonal`)
**How**: 6 unique pair theorems `gamma{i}_gamma{j}_anticomm` via `ext i j; fin_cases i <;> fin_cases j <;> simp [gammaI, gammaJ, Matrix.mul_apply, Matrix.of_apply, Fin.sum_univ_four, Matrix.add_apply] <;> ring`, then `first | exact pair_lemma | (rw [add_comm]; exact pair_lemma)` for the 6 reversed pairs. `gammaClifford_anticommutator_full` gives the unconditional full Clifford relation. `diracSquaredIsKG_unconditional` D²=KG bundle inhabited. Verified Apr-17 by Dubhe (full project build GREEN 3544 jobs).

### 8. Non-abelian Bianchi identity DF = 0
**File**: `OmegaTheory/Emergence/NonAbelianGauge.lean` (Menkar)
**Done**: Abelian case proved via d²=0
**Open**: `DF = 0` where `D = d + [A,·]` for non-abelian gauge
**Blocker**: Needs Jacobi identity + cyclic bracket expansion
**Difficulty**: MEDIUM

### 9. Weinberg identity for general conformal Ω
**File**: `OmegaTheory/Geometry/WeinbergConformal.lean` (Thuban)
**Done**: Flat conformal (Ω=1) proved
**Open**: `R_μν = -½□g_μν + Q` for general Ω²·η_μν
**Blocker**: Leibniz rule expansion through Christoffel products via fderiv
**Effort**: 3-5 day computation
**Difficulty**: MEDIUM

---

## TIER 3: PREDICTIONS TO FORMALIZE (MED priority)

### 10. Mass-dependent decoherence (Γ ∝ m²)
**File**: `OmegaTheory/Predictions/MassDependentDecoherence.lean` (to create)
**Claim**: Γ_decoherence(m) ∝ (m/m_e)² · Γ_e at matched energy
**Source**: Implicit in `MassAsDelay.lean` + extended Heisenberg, not yet formalized
**Difficulty**: MEDIUM

### 11. W2: Jarlskog from geometric mean of irrationals
**File**: `OmegaTheory/Predictions/JarlskogFromIrrationals.lean` (to create)
**Claim**: J_CKM = geometric mean of three-channel δ_comp products
**Difficulty**: HARD

### 12. Anomalous magnetic moment g-2 substrate correction
**File**: `OmegaTheory/Predictions/AnomalousMagneticMoment.lean` (to create)
**Claim**: Substrate shifts electron g-2 by δ_comp/α
**Difficulty**: MEDIUM

### 13-15. More creative predictions
- Vacuum birefringence from ErrorForms
- Graviton detection impossibility (BekensteinBound + Gravitons)
- Information 2nd law with explicit ℓ_P·k_B·T ceiling

---

## TIER 4: PI RESEARCH TRACK (research-grade, months+)

From Neo4j (separate from Physics):
- **GAP_B** Non-Siegel specialization of E-function values (OPEN)
- **GAP_C** Mahler × Fuchsian specialization (OPEN, Attack 12)
- **GAP_D** "ou" → "et" for mixed E+G (BLOCKED by Decoupling)
- **GAP_E** Explicit HP with heights (OPEN, Attack 18)
- **GAP_H** Sabbah-Yu irregular Hodge comparison (OPEN, Attack 20)
- **GAP_L** Mixed-type function-level independence (OPEN, Attack 13)
- **GAP_M** Grothendieck Period Conj B × SL₂ motive (OPEN, Attack 14)
- **GAP_N** Effective multiplicity on C[E₄,E₆][E₂] (OPEN, Attack 21)
- **Conj_4A4_EG_Separation** (OPEN, Attacks 19/20/21 ALIVE)

---

## Insights from Acamar's research (2026-04-17)

### Experimental convergence
- **DESI DR2 + Planck**: Σm_ν < 0.064 eV, **3σ tension** with oscillation lower bound 0.059 eV
- **KATRIN 2025**: m_ν < 0.45 eV
- **PDG 2024 CKM**: J = 3.00×10⁻⁵
- **T2K+NOvA 2025 PMNS**: θ₁₂=33.4°, θ₂₃=49°

### Numerical test: 3-irrationals → 3-generations
- **Raw ratio matching FAILS** (√2 converges too fast at low N)
- **ORDERING IS CORRECT** (π=heavy, e=middle, √2=light) ✅
- **Best-fit**: `m_i ∝ ln(1/δ_i)` with Connes spectral weighting
- Pivot from linear ratio hypothesis to logarithmic map

---

## Queries to run on Neo4j

```cypher
-- All open theorems by priority
MATCH (t:OpenTheorem {namespace: 'OmegaTheoryV2'})
RETURN t.name, t.priority, t.difficulty, t.target_file
ORDER BY t.priority DESC, t.difficulty

-- All proposed predictions
MATCH (p:Prediction {namespace: 'OmegaTheoryV2'})
WHERE p.status = 'PROPOSED'
RETURN p.name, p.priority, p.target_file
```
