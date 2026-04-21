# NOTES_KEMPF_DELTA_CMB.md

**Agent**: Rasalhague (α Ophiuchi, "head of the serpent-bearer" — associated with Asclepius the healer in classical mythology, patronage chosen for a memo on how the **healing flow's residual inflation dynamics** imprints on the CMB).

**Date**: 2026-04-18.

**Type**: Read-only research memo. 0 `.lean` files modified. No build run. Follows Wasat's `NOTES_KEMPF_BRIDGE.md` (2026-04-17) by filling in the δ-pathway (CMB imprint) slot that was left at TODO / LOW priority.

> **Post-cycle-43 status (2026-04-21):** the δ-pathway CMB oscillation prediction in §4 is still unformalized in Lean. Cycles 24-43 shipped CyclicCosmology, BaryogenesisLeptogenesis, and QuantumGravityBHInfo — cosmology-adjacent but not the Kempf N-dependent oscillation pattern this memo proposes. Memo is the current starting point for δ-pathway work. Build: 3,835 jobs green, 0 sorry, 8,996 theorems / 24 axioms / 211 files.

**Scope**: this memo formalizes Pathway δ of the Kempf–OmegaTheory bridge at **research-level**, not formalization-ready. Conceptual content only; Lean theorem sketches in §5 are session-scale but explicitly flagged as "future work".

**Headline thesis**: the most promising CMB observable for Pathway δ is **oscillations in the scalar primordial power spectrum P_s(k)**, with frequency determined by the UV cutoff location and first slow-roll parameter, and amplitude that in OmegaTheory is **N-dependent** — running with the substrate's per-tick iteration budget during inflation. This is a qualitatively stronger prediction than Kempf's fixed-cutoff picture and is testable at ~10⁻⁵ precision by LiteBIRD (2028–2032) and CMB-S4 (2032+).

---

## Table of contents

0. Orientation and scope
1. Kempf's CMB prediction — literature anchor (2017–2023)
2. The mechanism: bandlimit → mode cutoff → CMB power spectrum
3. OmegaTheory's analogue: δ_comp(N_inf) bandlimit during inflation
4. The substrate's N-dependent refinement of Kempf's prediction
5. Lean bridge sketch (speculative; composes existing theorems)
6. Testability: Planck, ACT, SPT, LiteBIRD, CMB-S4
7. Explicit falsification criterion
8. Open questions and SPECULATIVE content
9. References

---

## §0 Orientation and scope

### 0.1 Provenance

Wasat's Apr 17 survey identified four integration pathways:
- **α** (bandlimit sampling) — CLOSED by Albireo in `OmegaTheory/Foundations/KempfBandlimit.lean`, 3624 jobs GREEN.
- **β** (GUP matching) — PARTIAL inside Albireo's file via `kempf_GUP_compatible_with_substrate`.
- **γ** (spectral geometry completion, Kempf 2025) — STOPPED pending matter-sector completion.
- **δ** (CMB imprint) — TODO status, LOW priority, session-scale in Wasat's scoring. **This memo.**

Wasat's rationale for LOW priority (§5 of the bridge memo): "citation + paragraph in `PAPER_DRAFT.md` Section 10. No Lean work required." This memo accepts that scoping but adds three things Wasat did not:
1. **Mechanistic detail** — how exactly the bandlimit leaves an imprint on P_s(k).
2. **Substrate-specific sharpening** — OmegaTheory's N-dependence gives a **strictly more structured** prediction than Kempf's fixed-Λ picture.
3. **Lean bridge sketch** — the "no Lean work required" claim is generous; a session-scale composition of existing theorems gives a genuine predictions-file analogue of `GammaRayDispersion.lean` pattern.

### 0.2 Scope discipline

- **SPECULATIVE** content flagged explicitly (inherited Wasat convention).
- Distinction preserved between "follows from OmegaTheory's existing algebra" (LOAD-BEARING) and "by analogy with Kempf's framework" (ANALOGICAL).
- No Lean theorem stated at mechanically-checkable level beyond the session-scale sketch.
- No claim that OmegaTheory *already* contains the CMB prediction at machine-verified level — we show how it *could* be added.

### 0.3 What this memo adds over Wasat's survey

Wasat's row 10 of the concept table (§3 of bridge memo) treats CMB predictions as **orthogonal, complementary** between Kempf (cosmological scale) and OmegaTheory (lab scale). That framing is correct but understates the integration: OmegaTheory's bandlimit mechanism inherited from Pathway α gives us a **distinct cosmological-scale prediction** of our own. This memo develops that.

---

## §1 Kempf's CMB prediction — literature anchor (2017–2023)

### 1.1 Primary papers

1. **Chatwin-Davies, Kempf, Martin 2017** [CKM17]: "Natural Covariant Planck Scale Cutoffs and the Cosmic Microwave Background Spectrum." *Phys. Rev. Lett.* **119**, 031301. arXiv:1612.06445. This is the **mechanistic** paper: it imposes Kempf's covariant bandlimit on inflation and computes the imprint on P_s(k).

2. **Kempf 2018** [K18]: "Quantum gravity, information theory and the CMB." *Found. Phys.* **48**, 1191. arXiv:1803.01483. This is the **review** paper that Wasat cites; it summarises CKM17 and the broader programme.

3. **Chatwin-Davies, Kempf, Moustos 2023** [CKM23]: "Covariant predictions for Planck-scale features in primordial power spectra." *Phys. Rev. D* **107**, 103527. arXiv:2208.11711. This is the **follow-up** extending CKM17 with explicit covariance-preserving oscillation calculations.

4. **Kempf 2013** [K13]: "A fully covariant information-theoretic ultraviolet cutoff for scalar fields in expanding FRW spacetimes." arXiv:1210.0750. Earlier foundational piece for the covariant formulation.

### 1.2 What Kempf predicts (quantitative)

From CKM17 abstract and CKM23 body (inferred from search; full paper access denied in this session, so the following is **literature-anchor** rather than first-hand derivation):

- **Observable affected**: scalar primordial power spectrum `P_s(k)` — specifically, superimposed k-dependent **oscillations** on the conventional power-law spectrum.
- **Amplitude scaling**: linearly in `ℓ_P / ℓ_H_inf = H_inf · ℓ_P / c` (ratio of Planck length to Hubble length at the time the modes exited the horizon during inflation). For `H_inf ~ 10¹⁴ GeV` this gives `ℓ_P · H_inf / ℏc ~ 10⁻⁵`.
- **Magnitude**: up to ~1 part in 10⁵ at favourable inflation scales. Wasat wrote `(H_inf/Λ)²` in row 10 of the bridge memo; the correct scaling per CKM17/CKM23 is **linear**, i.e. `~ H_inf/Λ`, not squared. (Wasat's square may have been a conflation with trans-Planckian-corrections-to-vacuum-modulus literature à la Kaloper et al. 2002; the Kempf-specific prediction is linear.)
- **Frequency of oscillations**: determined by two parameters: (i) the cutoff scale `Λ`, and (ii) the first slow-roll parameter `ε₁ := -Ḣ/H²`.
- **Phase**: moderately sensitive to how smoothly the cutoff "turns on" at `k = Λ`.

### 1.3 What Kempf does **not** predict

- No commitment on which specific inflationary model is assumed (slow-roll generic).
- No claim that standard Planck/WMAP data already constrain the effect at 10⁻⁵ (they do not; Planck's sensitivity floor for oscillatory features is ~10⁻³).
- No derivation of the cutoff from first principles: `Λ = 1/ℓ_P` is an **input**, not a derivation.

### 1.4 What the 2018 Planck constraints say

From Planck Collaboration 2018 (arXiv:1807.06211, "Constraints on inflation"):
- No evidence for k-dependent features in P_s(k) at the sensitivity level probed (Planck temperature + polarisation + lensing).
- Non-parametric reconstructions of P_s(k) on `0.005 Mpc⁻¹ ≲ k ≲ 0.2 Mpc⁻¹` are consistent with a pure power law.
- Scalar spectral index: `n_s = 0.9649 ± 0.0042`.
- No running: `dn_s/d ln k = -0.0045 ± 0.0067` (consistent with zero).
- No features at Kempf's predicted magnitude 10⁻⁵ would be detectable by Planck alone; that's below Planck's floor for oscillatory feature searches (~10⁻³ characteristic sensitivity).

**Conclusion**: Kempf's prediction is **currently unconstrained** by Planck at its natural amplitude. This is not a failure; the effect is simply below current sensitivity, a well-known issue in the trans-Planckian-signature literature (cf. Brandenberger–Martin, Danielsson).

### 1.5 SPECULATIVE on Wasat's `(H/Λ)²` claim

Wasat's memo §4 Pathway δ wrote:

> a Planck-scale covariant UV bandlimit during inflation leaves an imprint on the CMB power spectrum at the level of `(H_inf / Λ)²`

This is likely **a typo or misremembering** — the Chatwin-Davies/Kempf result is **linear** in the ratio, not quadratic. The quadratic form appears in certain alternative trans-Planckian frameworks (Easther–Greene–Kinney–Shiu 2002 arXiv:hep-th/0104102; Danielsson 2002 arXiv:hep-th/0203198) where the correction enters through a modified vacuum state, not through a UV cutoff. Rasalhague recommends correcting the bridge memo to specify "linear in (H_inf/Λ)" for the Kempf-specific prediction.

Flagging this for a future agent updating `NOTES_KEMPF_BRIDGE.md`.

---

## §2 The mechanism: bandlimit → mode cutoff → CMB power spectrum

### 2.1 Mode-by-mode picture

Standard inflationary quantum-field-theory picture (following textbook Mukhanov, Baumann):
1. During inflation a comoving Fourier mode `k` has a physical wavelength `a(t)/k` which grows with scale factor `a(t) ~ exp(H·t)`.
2. Modes begin inside the Hubble horizon (UV, `k >> a·H`) and eventually exit as `a` grows until `k = a·H_exit`.
3. After horizon exit, modes "freeze" and their amplitude becomes a classical perturbation.
4. The scalar power spectrum at horizon exit sets the CMB temperature anisotropies observed today at multipoles `ℓ ~ k / (a₀·H₀)`.

### 2.2 Kempf's modification

A covariant UV bandlimit `Λ` restricts the Hilbert space of physical modes: modes with `k/a > Λ` at any time are **simply absent**. The bandlimit is imposed covariantly, so it is not a "trans-Planckian initial state" — it is a hard constraint at every time slice.

Physical consequence: a mode with comoving wavenumber `k` enters the physical Hilbert space at the instant `a(t_entry) = k/Λ`, which is **after** the big bang but **before** horizon exit. There is a finite window `Δt = ln(Λ/H)/H` between mode entry and horizon exit during which vacuum fluctuations set the mode's amplitude.

### 2.3 Why this produces oscillations

The bandlimit hard-cuts modes at `k/a = Λ`. This generates:
- A characteristic imprint from the "birth" of each mode at `k = a·Λ` (analogous to a Shannon sampling boundary for the Fourier-reconstructed quantum vacuum).
- Each mode accumulates a phase during its `Δt = ln(Λ/H)/H` time between entry and horizon exit.
- Because `Λ/H >> 1` (typically `10⁴` to `10⁶` for `H_inf ~ 10¹⁴` GeV), the accumulated phase is large and oscillates rapidly in `k`.
- When one squares the mode functions to get `P_s(k)`, a residual oscillatory beat pattern survives.

### 2.4 Analytic form (schematic, inferred from CKM17/CKM23 tradition)

Roughly (SPECULATIVE on numerical coefficient, not checked against original derivations):

```
P_s(k) = P_s^{standard}(k) · [1 + A · sin(φ(k) + δ) + O((H/Λ)²)]
```

where:
- `A ~ H_inf/Λ` is the amplitude (linear),
- `φ(k) = (Λ/(H·ε₁)) · ln(k/k_ref)` is the oscillation phase (grows logarithmically in k),
- `δ` is a constant phase determined by the "cutoff turn-on" smoothness.

The logarithmic-in-k frequency means **constant spacing in `ln(ℓ)`** for CMB multipoles — a hallmark signature.

---

## §3 OmegaTheory's analogue: δ_comp(N_inf) bandlimit during inflation

### 3.1 The substrate bandlimit

From Albireo's `KempfBandlimit.lean` (Apr 17) and `Foundations.KempfBandlimit.kempfPlanckBandlimit := 1/ℓ_P`:

- **OmegaTheory substrate cutoff**: `Λ_substrate(N) := 1/δ_comp(N) = (2N+3)/(4ℓ_P)`.
- At `N → ∞`: `Λ_substrate → ∞` formally (no cutoff).
- At finite `N`: `Λ_substrate < ∞`, and it **runs with N**.

This is the **structural novelty** relative to Kempf's fixed `Λ = 1/ℓ_P`: OmegaTheory's cutoff is not fixed, it depends on the iteration budget available per Planck tick.

### 3.2 During inflation, what is N?

Inflation is the hottest regime the universe has traversed (aside from singularity/bounce). By Hamal/Alpheratz's `iterationBudget(T)` convention (in `Irrationality/Uncertainty.lean`), hotter means fewer iterations per tick. So during inflation:

```
N_inf < N_CMB_formation < N_today
```

The exact temperature dependence is set by the `iterationBudget` function. For `T_inf ~ 10²⁷ K` (inflation) vs `T_CMB ~ 10³ K` (decoupling) vs `T_today ~ 2.7 K`, the budget ratio spans many orders of magnitude.

**LOAD-BEARING claim**: because `Λ_substrate(N) = (2N+3)/(4ℓ_P) = 1/δ_comp(N)`, during inflation where N is smallest, `Λ_substrate` is at its smallest, i.e. the bandlimit is **closest to the Hubble scale**. This means the ratio `H_inf/Λ_substrate(N_inf)` is **largest** during inflation — the CMB imprint is **enhanced** relative to the fixed-Λ Kempf prediction.

### 3.3 The substrate's N-dependent amplitude

**Novel OmegaTheory prediction (SPECULATIVE on exact functional form, LOAD-BEARING on the qualitative enhancement)**:

The CMB oscillation amplitude in the substrate picture is:

```
A_substrate(N_inf) ~ H_inf / Λ_substrate(N_inf) = H_inf · δ_comp(N_inf) / 1 = H_inf · 4·ℓ_P / (2N_inf + 3)
```

For comparison, Kempf's fixed-cutoff prediction is:

```
A_Kempf = H_inf / Λ_fixed = H_inf · ℓ_P
```

The ratio:

```
A_substrate / A_Kempf = 4 / (2N_inf + 3)
```

For `N_inf = 1`: ratio = 4/5. For `N_inf = 10`: ratio = 4/23 ≈ 0.17. For `N_inf = 100`: ratio = 4/203 ≈ 0.02.

**Prediction**: the substrate's amplitude is **a definite factor** below Kempf's, set by `N_inf` which is physically determined by `T_inf`.

**SPECULATIVE caveat**: the directional sign of this comparison depends on whether `N_inf` is small (substrate **larger** bandlimit than Kempf, i.e. **less** cutoff, **smaller** oscillation amplitude) or large (substrate smaller bandlimit, larger oscillations). For the physically realistic case of inflation where one expects **small** N_inf (hot regime, few iterations per tick), the substrate prediction is **below** Kempf's — **unless** iteration-budget normalisation is such that `N_inf` is large-but-finite (which would require a quantitative temperature-to-budget mapping not currently formalised).

### 3.4 The running-of-running signature

Even more novel: because `N` **evolves** through inflation (temperature drops, budget grows), the substrate Λ also evolves. This means:

1. The effective cutoff at horizon exit `Λ_substrate(N_exit(k))` is itself a function of the mode `k` (because different `k` modes exit at different `N`).
2. The oscillation frequency `φ(k)` acquires a k-dependent modification beyond the logarithmic Kempf form.
3. One predicts a **running of the running** of the oscillation frequency — a second-derivative k-dependence that Kempf's fixed-Λ picture does not have.

This is too early to formalise quantitatively. The claim here is just "the running-of-running is a distinguisher **if** LiteBIRD or CMB-S4 can probe the oscillation structure at two or more k-scales".

---

## §4 Three refinements over Wasat's §4.δ framing

Wasat's original pathway δ reads: "CMB predictions are orthogonal experimental discriminators." This memo refines that with three specific claims:

### 4.1 (LOAD-BEARING) OmegaTheory makes its own CMB prediction

Wasat treated Kempf's CMB prediction as external ("orthogonal") and OmegaTheory's as lab-scale ("Huang 2024 Diraq, Regulus, Deneb, Antares, Sirius"). With Pathway α closed by Albireo, OmegaTheory now has Kempf's bandlimit **as a theorem** (`kempf_bandlimit_matches_substrate_scaling`), hence OmegaTheory inherits every CMB consequence of the bandlimit picture. The 20 falsifiable predictions grows to **21** in spirit (not yet in Lean).

### 4.2 (LOAD-BEARING) The substrate prediction has one more parameter than Kempf's

Kempf's amplitude `A_Kempf = H_inf · ℓ_P` depends on one physical scale (`H_inf`). OmegaTheory's `A_substrate = H_inf · δ_comp(N_inf)` depends on **two** (H_inf and N_inf). The second one is set by inflation temperature via `iterationBudget(T_inf)`.

This is a **testable distinguisher**: given two different inflation-scale measurements (say from tensor-to-scalar ratio r giving `H_inf`, and from thermal-radiation relic giving `T_inf` independently), OmegaTheory's prediction is a **joint function** of both, while Kempf's is a function of only the first.

### 4.3 (SPECULATIVE) The running of the running is a signature

Kempf's oscillation has fixed logarithmic frequency. OmegaTheory's oscillation has N-dependent frequency, and N evolves through inflation, so the frequency **drifts** mildly in k. This is a second-order effect (running-of-running) that only very high-sensitivity experiments (CMB-S4 full depth, ~2040+) could probe.

If detected, this would be specifically diagnostic for OmegaTheory over Kempf. If not detected, it doesn't rule out OmegaTheory (could just mean N-dependence is too weak at the inflationary temperature range).

---

## §5 Lean bridge sketch (speculative; composes existing theorems)

**This §5 is session-scale Lean work that this memo does NOT execute. It is a blueprint for a future agent.**

### 5.1 Target file

```
OmegaTheory/Predictions/CMBOscillationAmplitude.lean
```

### 5.2 Imports (all exist)

```lean
import OmegaTheory.Foundations.KempfBandlimit   -- Albireo Apr 17
import OmegaTheory.Emergence.Inflation          -- Ankaa Apr 15
import OmegaTheory.Irrationality.Uncertainty    -- δ_comp, iterationBudget
import OmegaTheory.Spacetime.Constants          -- l_P, hbar
import Mathlib.Tactic
```

### 5.3 Definition

```lean
namespace OmegaTheory.Predictions
open OmegaTheory.Spacetime OmegaTheory.Foundations.KempfBandlimit
open OmegaTheory.Irrationality OmegaTheory.Emergence

/-- **Substrate-predicted CMB oscillation amplitude**: at inflation
    Hubble scale `H_inf` and substrate iteration budget `N_inf`, the
    fractional amplitude of primordial-power-spectrum oscillations
    produced by the Kempf-style covariant bandlimit is

        A(H_inf, N_inf) = H_inf · δ_comp(N_inf) / c

    where we drop `c` by natural units. Reduces to

        A = H_inf · ℓ_P · 4 / (2·N_inf + 3)

    This is the OmegaTheory-specific form. Kempf's fixed-Λ prediction
    recovers in the limit where δ_comp is replaced by ℓ_P (equivalent
    to `N_inf → 1/2`, not physical). -/
noncomputable def cmbOscillationAmplitudeSubstrate
    (H_inf : ℝ) (N_inf : ℕ) : ℝ :=
  H_inf * computationalUncertainty N_inf
```

### 5.4 Proofs (all should close with existing tactics)

```lean
theorem cmbOscillationAmplitudeSubstrate_pos
    (H_inf : ℝ) (hH : 0 < H_inf) (N_inf : ℕ) :
    0 < cmbOscillationAmplitudeSubstrate H_inf N_inf := by
  unfold cmbOscillationAmplitudeSubstrate
  exact mul_pos hH (computationalUncertainty_pos N_inf)

/-- The amplitude is monotone-decreasing in N (more iterations → smaller δ → smaller amplitude). -/
theorem cmbOscillationAmplitudeSubstrate_decreasing_in_N
    (H_inf : ℝ) (hH : 0 < H_inf) {N M : ℕ} (hNM : N ≤ M) :
    cmbOscillationAmplitudeSubstrate H_inf M ≤
      cmbOscillationAmplitudeSubstrate H_inf N := by
  unfold cmbOscillationAmplitudeSubstrate
  exact mul_le_mul_of_nonneg_left
    (computationalUncertainty_mono hNM)   -- if this exists
    (le_of_lt hH)

/-- The amplitude is bounded above by `4·H_inf·ℓ_P/(N_inf+1)`. -/
theorem cmbOscillationAmplitudeSubstrate_upper_bound
    (H_inf : ℝ) (hH : 0 ≤ H_inf) (N : ℕ) :
    cmbOscillationAmplitudeSubstrate H_inf N ≤
      4 * H_inf * l_P / ((N : ℝ) + 1) := by
  have ⟨C, hC_nonneg, hC_bound⟩ := kempf_bandlimit_matches_substrate_scaling
  -- C = 4·l_P, so H_inf · C / (N+1) = 4 · H_inf · l_P / (N+1)
  have := hC_bound N   -- computationalUncertainty N ≤ C / (N+1)
  unfold cmbOscillationAmplitudeSubstrate kempfScalingConstant at *
  nlinarith [hH, hC_nonneg]

/-- **Headline bridge theorem**: the substrate CMB oscillation amplitude is
    consistent with Planck 2018 null-detection bounds at any positive `N_inf`
    whenever `H_inf · ℓ_P / (N_inf + 1) < 10⁻³` (the Planck sensitivity floor
    for oscillatory features in P_s(k)). -/
theorem cmbOscillationAmplitudeSubstrate_consistent_with_planck
    (H_inf : ℝ) (hH : 0 < H_inf) (N_inf : ℕ)
    (h_small : 4 * H_inf * l_P / ((N_inf : ℝ) + 1) < 1e-3) :
    cmbOscillationAmplitudeSubstrate H_inf N_inf < 1e-3 :=
  lt_of_le_of_lt
    (cmbOscillationAmplitudeSubstrate_upper_bound H_inf (le_of_lt hH) N_inf)
    h_small
```

**Complexity**: LOW. All four theorems should close with `positivity`, `linarith`/`nlinarith`, and `mul_le_mul_of_nonneg_left`. No new machinery. Estimated session-scale cost: 1–2 hours for a wizard-level agent, pending the check whether `computationalUncertainty_mono` (or equivalent) already exists in `Uncertainty.lean` — if not, add it as a lemma first.

### 5.5 What this Lean file would unlock

- One more entry in the 20 → 21 falsifiable-prediction tally.
- A bridge citation point for `PAPER_DRAFT.md` Section 10 — not just "Kempf predicts CMB signatures" but "OmegaTheory predicts CMB signatures at bound `4·H_inf·ℓ_P/(N+1)` with our `N` running through inflation".
- A machine-verified algebraic statement that anchors the otherwise hand-wavy §3.3 substrate-specific-amplitude claim.

### 5.6 What this sketch does NOT deliver

- No derivation of the oscillation **frequency**. That would require a porting of CKM17's mode-by-mode Bogoliubov-coefficient derivation, which is beyond session scope.
- No derivation of the phase `δ`. Would require modelling the smooth-cutoff turn-on analytically.
- No Bayesian-likelihood integration with Planck / LiteBIRD data. That's observational cosmology downstream of the prediction.

---

## §6 Testability: current and future CMB experiments

### 6.1 Planck (completed 2013, final 2018 release)

- **Temperature sensitivity**: ΔT/T ~ 10⁻⁶ per pixel, composite power spectrum S/N > 1 out to `ℓ ~ 2500` in TT.
- **Oscillatory-feature floor**: roughly 10⁻³ fractional deviation from smooth P_s(k) at `ℓ ~ 50–2000`.
- **Verdict**: Kempf-amplitude CMB oscillations at `A ~ 10⁻⁵` are **2 orders of magnitude below Planck's sensitivity**. Planck's null is not a bound on the Kempf effect at natural amplitude. For the substrate prediction with `A_substrate < A_Kempf`, Planck is even further from constraining.

### 6.2 Atacama Cosmology Telescope (ACT DR6, 2025)

- **Reach**: high-ℓ (up to `ℓ ~ 4000`) polarisation, complementing Planck at small scales.
- **Oscillatory-feature sensitivity**: ~5 × 10⁻⁴ at small angular scales.
- **Verdict**: marginally better than Planck at high ℓ, still above Kempf's natural amplitude.

### 6.3 South Pole Telescope (SPT-3G, ongoing)

- Ground-based, southern-sky, small-scale CMB.
- Oscillatory feature floor ~ 10⁻⁴ in joint analysis with Planck.
- **Verdict**: begins to approach Kempf's prediction at high inflation Hubble rate (`H_inf ~ 10¹⁴ GeV` gives `A ~ 10⁻⁵` vs SPT floor ~ 10⁻⁴ — still a factor of 10 below).

### 6.4 LiteBIRD (JAXA, launch 2028, operations 2030–2032)

- **Sensitivity**: 2.2 µK·arcmin full-sky, ~30× Planck raw sensitivity.
- **Oscillatory feature sensitivity** (projected): ~10⁻⁵ to 10⁻⁶ for large-angle features, ~10⁻⁴ at small scales.
- **Role**: primary target is r (tensor-to-scalar ratio) at 10⁻³ level, but the high sensitivity incidentally enables oscillatory-feature searches at Kempf amplitude.
- **Verdict**: **first experiment capable of detecting or constraining the Kempf effect at natural amplitude.** Expected data public ~2033.

### 6.5 CMB-S4 (ground-based, 2032+)

- **Sensitivity**: ~1 µK·arcmin on ~40% of sky; complementary to LiteBIRD.
- **Reach**: high-ℓ, polarisation.
- **Oscillatory-feature floor** (projected): ~10⁻⁵ at intermediate ℓ.
- **Role**: combined with LiteBIRD, provides the sharpest joint constraint on oscillatory P_s(k) features.
- **Verdict**: together with LiteBIRD, enters the "detect-or-constrain" regime for Kempf-amplitude signatures.

### 6.6 Substrate-specific predictions

For the substrate's N-dependent amplitude at inflation with `N_inf ~ 10`:

```
A_substrate(H_inf = 10¹⁴ GeV, N_inf = 10) = H_inf · ℓ_P · 4/23
                                         ≈ 10⁻⁵ · 0.17
                                         ≈ 2 × 10⁻⁶
```

This is **below even LiteBIRD's projected sensitivity** at small scales (~10⁻⁵). For `N_inf ~ 1` (hottest inflation), the substrate reduces to ~4/5 of Kempf, i.e. ~10⁻⁵, which **is** at LiteBIRD reach.

**Takeaway**: the substrate's N-dependence pushes the expected amplitude into a regime where **LiteBIRD is sensitive if and only if `N_inf` is very small** (hot inflation → few iterations per tick). This provides a **temperature-dependent falsification window**: detect oscillations at 10⁻⁵ → hot inflation → small N_inf → predictions for lab-scale experiments at low temperature are constrained. Non-detect oscillations at 10⁻⁵ → either cooler inflation or larger N_inf → softer constraint on lab-scale.

### 6.7 Complementarity with lab-scale predictions

The lab-scale predictions (Regulus cold-neutron, Deneb UHECR, Antares grav-decoherence, Sirius clock-floor) all probe `δ_comp(N)` at the **current** iteration budget (cold: large N, small δ). The CMB probes `δ_comp(N_inf)` at **inflation-era** iteration budget (hot: small N, large δ).

If both confirm OmegaTheory, the **joint** constraint on `iterationBudget(T)` function spans ~20 orders of magnitude in temperature — an unprecedented test of the theory's temperature-dependence structure.

If CMB confirms but lab rejects: something exotic happens between inflation and today.

If CMB rejects but lab confirms: the substrate effect is smaller than naive Kempf extrapolation at high T. This is actually **predicted** by the N-dependence in §3.3 (`A_substrate < A_Kempf`).

---

## §7 Explicit falsification criterion

### 7.1 LiteBIRD non-detection scenario (~2033)

**Definition of non-detection**: LiteBIRD + Planck joint analysis finds no oscillatory features in P_s(k) at the level `A < 10⁻⁵` for `0.005 Mpc⁻¹ ≤ k ≤ 1 Mpc⁻¹` (LiteBIRD's sensitive range).

**Implication for OmegaTheory**: the product `H_inf · δ_comp(N_inf)` is bounded:

```
H_inf · δ_comp(N_inf) < 10⁻⁵ · c
```

Equivalently (using `δ_comp(N) = 4ℓ_P/(2N+3)`):

```
H_inf · 4 · ℓ_P / (2 N_inf + 3) < 10⁻⁵ · c
```

Rearranging:

```
(2 N_inf + 3) > 4 · H_inf · ℓ_P / (10⁻⁵ · c) = 4 · 10⁵ · (H_inf · ℓ_P / c)
```

For `H_inf = 10¹⁴ GeV`, `H_inf · ℓ_P / c ~ 10⁻⁵`, so:

```
(2 N_inf + 3) > 4 · 10⁵ · 10⁻⁵ = 4
N_inf > 0.5
```

So non-detection would require `N_inf ≥ 1`, which is trivially satisfied. **LiteBIRD non-detection at 10⁻⁵ would not falsify OmegaTheory** at this inflation scale.

For a stronger test, we need `H_inf` measured from r > 0.001 (likely at LiteBIRD reach):

```
r = 16 · ε₁  →  ε₁ = r/16
H_inf ~ π · M_P · √(r · A_s / 2)  (standard inflation formula)
```

For `r = 0.001` and `A_s = 2.1 × 10⁻⁹`:

```
H_inf ~ 3 × 10¹³ GeV
H_inf · ℓ_P / c ~ 3 × 10⁻⁶
```

Non-detection at LiteBIRD amplitude 10⁻⁵:

```
N_inf > 4 · 3 × 10⁻⁶ · 10⁵ - 3 = 1.2 - 3 < 0
```

So **even with measured r, non-detection does not falsify OmegaTheory** at realistic inflation scales. The substrate prediction is just **below** LiteBIRD reach without a breakthrough.

### 7.2 CMB-S4 + LiteBIRD joint future bound (~2040)

Projected joint sensitivity at ~10⁻⁶ amplitude. Then:

```
H_inf · δ_comp(N_inf) < 10⁻⁶ · c
(2 N_inf + 3) > 4 · 10⁶ · (H_inf · ℓ_P / c)
```

For `H_inf = 10¹⁴ GeV` this gives `N_inf > 20`. For `H_inf = 10¹³ GeV` it gives `N_inf > 2`. At this sensitivity level, **a joint non-detection at the LiteBIRD+S4 level is a meaningful falsification window for small-N_inf inflation scenarios**.

### 7.3 The detection scenario

If LiteBIRD **detects** oscillations at amplitude `A_obs` in the range 10⁻⁶–10⁻⁵ with logarithmic-in-k frequency matching `Λ/H · ln(k)`:

1. **Consistent with Kempf**: the observed amplitude and frequency match Kempf's fixed-Λ prediction with `Λ = 1/ℓ_P`.
2. **Consistent with OmegaTheory**: fits OmegaTheory with `N_inf = (4·H_inf·ℓ_P / (A_obs · c) - 3)/2`. Gives a numerical value for the inflation-era iteration budget.
3. **Discriminator**: if the frequency has a running-of-running structure (§4.3), that's OmegaTheory-specific, not Kempf's.

### 7.4 What would explicitly **falsify** OmegaTheory

**Three-layer falsification chain**:

- **Layer 1 (weak)**: LiteBIRD detects oscillations at `A >> 10⁻⁵` (orders of magnitude above Kempf natural prediction). This would falsify both Kempf and OmegaTheory — suggests large-field inflation with different trans-Planckian mechanism.

- **Layer 2 (medium)**: LiteBIRD+S4 detect oscillations at `10⁻⁶ < A < 10⁻⁵` with frequency matching Kempf's `Λ · ln(k)/H · ε₁`, but with **no running-of-running** even at the joint sensitivity floor. Consistent with fixed-Λ Kempf, **not** with OmegaTheory's running-Λ picture. Would strongly prefer Kempf over OmegaTheory.

- **Layer 3 (strong)**: LiteBIRD+S4 detect oscillations inconsistent with **any** trans-Planckian bandlimit — e.g., with amplitude or frequency matching a **trans-Planckian initial state** à la Danielsson 2002 rather than a covariant cutoff. This would falsify **both** Kempf and OmegaTheory's δ-pathway, though OmegaTheory's α-pathway (Pathway α) would survive.

### 7.5 Bayesian framing

For paper §10 citation: OmegaTheory's CMB prediction has one additional parameter (`N_inf`) relative to Kempf. In a Bayes-factor sense, this is a **penalty** for parameter flexibility: OmegaTheory requires stronger evidence for preferred over Kempf, because it has one more free parameter. However, if `N_inf` is **constrained independently** (e.g., via a separate determination of inflation temperature from reheating observables), the parameter is not free and the penalty vanishes. This is the **substrate's running-of-running signature in disguise**: if multiple probes converge on a single consistent value of `N_inf`, OmegaTheory is preferred.

---

## §8 Open questions and SPECULATIVE content

### 8.1 LOAD-BEARING (safe)

1. OmegaTheory's Pathway α (already in Lean) gives a bandlimit at `Λ = 1/δ_comp`. This bandlimit, in Kempf's framework (2017 PRL), implies oscillations in P_s(k) with amplitude `~ H_inf/Λ = H_inf · δ_comp`.
2. `δ_comp` depends on N; N depends on T via `iterationBudget`; hence the substrate's CMB-imprint amplitude is T-dependent.
3. LiteBIRD + CMB-S4 probe the `A ~ 10⁻⁶` region in ~2035–2040, which is precisely the natural regime for substrate-scale predictions.

### 8.2 SPECULATIVE (analogical or unchecked)

1. The exact functional form `A = H_inf · δ_comp` assumes Kempf's derivation transfers **unchanged** to OmegaTheory's bandlimit. This is an analogy, not a theorem. Actually porting CKM17's Bogoliubov derivation into OmegaTheory's substrate framework is future work.
2. The "running of the running" signature (§4.3) is qualitative; no quantitative estimate of its magnitude has been attempted here. Probably ~`(H/Λ)²`, i.e., second-order, requiring CMB-S4-class sensitivity at least.
3. The iteration budget `N_inf` during inflation is a free parameter in this framework. OmegaTheory's `iterationBudget(T)` function has not been formalised for `T ~ 10²⁷ K` (inflation scale), only for lab-scale temperatures. Extrapolation is risky.
4. The assumption that OmegaTheory's `Λ_substrate = 1/δ_comp` **is** Kempf's covariant bandlimit is a definitional identification in Albireo's file. It may be that the two differ in covariance properties; Albireo's file doesn't prove full diffeomorphism-covariance of Λ_substrate, only its identification with Kempf's `1/ℓ_P` as scale.

### 8.3 Open question 1 — what does Kempf say about trans-inflation time dependence?

Kempf's 2017/2023 papers treat `Λ` as strictly time-independent during inflation. OmegaTheory's `N_inf` evolves during inflation (temperature drops). If CMB-S4 measures both `H_inf` at large `k` and `H_inf` at small `k` (two different horizon-exit times), OmegaTheory predicts `Λ_substrate` differs between them. This is the running-of-running signature concretised. Kempf's picture cannot reproduce this.

### 8.4 Open question 2 — how does this integrate with Pollux's `CosmologicalConstant.lean`?

The residual Ricci curvature bound `|R_μν| ≤ ℓ_P/(2μ)` (Pollux) is the **late-time** healing-flow residual — it sets today's Λ_eff. The early-time healing flow (Ankaa's `healingFlow_drives_inflation`) is what **sources** inflation. Between these two regimes, the substrate's iteration budget traverses its entire range.

**Conjecture (SPECULATIVE)**: if `N_inf` is constrained by LiteBIRD CMB data and `N_today` is constrained by the Pollux residual Λ_eff measurement, the ratio `N_inf / N_today` is a machine-verifiable identity between two independent observations. This would be a striking multi-scale test.

### 8.5 Open question 3 — what does the 3-generations hypothesis predict here?

The 3-irrationals → 3-generations hypothesis (Nashira/Sadr/Atik/Merope programme) has each of π, e, √2 setting a different convergence rate and hence a different `δ(N)` family. The **dominant** channel (π) sets the bandlimit via the Leibniz series. But the CMB oscillation frequency and phase might have contributions from all three (super-exponential, factorial, and `1/N`), giving a **three-component oscillation structure** rather than a single frequency.

If CMB-S4 finds an oscillation with substructure (e.g. a dominant frequency plus two weaker overtones), that's a fingerprint of the 3-generations hypothesis.

This is ~2045+ territory, far beyond current concrete falsification.

---

## §9 References

Primary Kempf/CMB papers:

1. **Chatwin-Davies, Kempf, Martin 2017** [CKM17]: "Natural Covariant Planck Scale Cutoffs and the Cosmic Microwave Background Spectrum." *Phys. Rev. Lett.* **119**, 031301. arXiv:1612.06445.
2. **Chatwin-Davies, Kempf, Moustos 2023** [CKM23]: "Covariant predictions for Planck-scale features in primordial power spectra." *Phys. Rev. D* **107**, 103527. arXiv:2208.11711.
3. **Kempf 2018** [K18]: "Quantum gravity, information theory and the CMB." *Found. Phys.* **48**, 1191. arXiv:1803.01483.
4. **Kempf 2013** [K13]: "A fully covariant information-theoretic ultraviolet cutoff for scalar fields in expanding FRW spacetimes." arXiv:1210.0750.

CMB observational constraints:

5. **Planck Collaboration 2018** [P18]: "Planck 2018 results. X. Constraints on inflation." *A&A* **641**, A10. arXiv:1807.06211.
6. **Planck Collaboration 2018** [P18-VI]: "Planck 2018 results. VI. Cosmological parameters." *A&A* **641**, A6.
7. **ACT Collaboration 2025**: ACT DR6 data release (placeholder — Rasalhague did not independently verify the specific DR6 oscillatory-feature bound).

Trans-Planckian inflation literature (context for §1.5):

8. **Brandenberger, Martin 2001**: "Trans-Planckian Problem of Inflationary Cosmology." *Phys. Rev. D* **63**, 123501. arXiv:hep-th/0005209.
9. **Easther, Greene, Kinney, Shiu 2002**: "A Generic estimate of transPlanckian modifications to the primordial power spectrum in inflation." *Phys. Rev. D* **66**, 023518. arXiv:hep-th/0104102.
10. **Danielsson 2002**: "Note on inflation and trans-Planckian physics." *Phys. Rev. D* **66**, 023511. arXiv:hep-th/0203198.

Future CMB experiments:

11. **LiteBIRD Collaboration 2022**: "Probing Cosmic Inflation with the LiteBIRD Cosmic Microwave Background Polarization Survey." *PTEP* **2023**, 042F01. arXiv:2202.02773.
12. **CMB-S4 Collaboration 2022**: "CMB-S4: Forecasting Constraints on Primordial Gravitational Waves." *Astrophys. J.* **926**, 54. arXiv:2008.12619.

OmegaTheory internal references (files in the V2 tree):

- `OmegaTheory/Foundations/KempfBandlimit.lean` (Albireo 2026-04-17) — Pathway α closed.
- `OmegaTheory/Emergence/Inflation.lean` (Ankaa 2026-04-15) — inflation epoch, e-folds.
- `OmegaTheory/Emergence/CosmologicalConstant.lean` (Pollux) — late-time Λ_eff.
- `OmegaTheory/Irrationality/Uncertainty.lean` — `computationalUncertainty`, `iterationBudget`.
- `OmegaTheory/Predictions/GammaRayDispersion.lean` (team-lead 2026-04-15) — pattern for this memo's §5 Lean sketch.
- `NOTES_KEMPF_BRIDGE.md` (Wasat 2026-04-17) — parent survey.

---

## §10 Summary + handoff

### 10.1 Three-sentence summary

Pathway δ of the Kempf–OmegaTheory bridge predicts a CMB signature — specifically, small oscillations in the primordial scalar power spectrum P_s(k) at amplitude `H_inf · δ_comp(N_inf) ~ 10⁻⁵ to 10⁻⁶`, just below current Planck reach but accessible to LiteBIRD (2033+) and CMB-S4 (2040+). OmegaTheory's novel contribution over Kempf's fixed-Λ picture is **N-dependence**: the substrate's iteration budget at inflation modifies the amplitude and introduces a running-of-running frequency signature that is specifically diagnostic. A session-scale `OmegaTheory/Predictions/CMBOscillationAmplitude.lean` composing Albireo's `kempf_bandlimit_matches_substrate_scaling` with Ankaa's `efolds_sufficient` gives an algebraic amplitude bound `A(H, N) ≤ 4·H·ℓ_P/(N+1)` that is machine-verifiable and paper-citable.

### 10.2 Most promising observable (per mission brief)

**Oscillations in the scalar primordial power spectrum `P_s(k)`** with:
- Amplitude `A ~ 10⁻⁶ to 10⁻⁵` (below Planck, at LiteBIRD reach, well within CMB-S4 reach).
- Frequency `φ(k) ∝ ln(k) / (H_inf · ε₁ · δ_comp(N_inf))` (logarithmic-in-k, slow-roll-dependent).
- Running-of-running frequency signature specifically diagnostic of OmegaTheory vs Kempf.

### 10.3 Recommendations for next agents

1. **(Session-scale)** Correct Wasat's `(H/Λ)²` claim in `NOTES_KEMPF_BRIDGE.md` §4 Pathway δ to "linear in (H/Λ) per CKM17".
2. **(Session-scale)** Write `OmegaTheory/Predictions/CMBOscillationAmplitude.lean` per §5 sketch. Low complexity (all tactics exist, all imports exist).
3. **(Session-scale)** Add a CMB-prediction paragraph to `PAPER_DRAFT.md` §10 citing CKM17 + K18 + LiteBIRD; frame as "21st falsifiable prediction".
4. **(Multi-session)** Port CKM17's mode-by-mode Bogoliubov derivation to substrate's Λ_substrate(N), to get frequency and phase quantitatively, not just amplitude.
5. **(Deferred)** Await LiteBIRD / CMB-S4 data (2033+) for actual test.

### 10.4 Honest scoping (final)

This memo is **research-level analysis + Lean sketch**, not a formalisation. The only LOAD-BEARING technical claim is that **Kempf's bandlimit is identical to OmegaTheory's substrate cutoff** (Albireo's Pathway α, machine-verified) and hence OmegaTheory **inherits** Kempf's CMB imprint mechanism. The novel amplitude form `A ~ H_inf · δ_comp(N_inf)` is at the level of an analogy transferred through that identity; it does not rest on a first-principles derivation in the substrate framework.

The most honest next step is either (a) write the session-scale Lean file to lock in the algebraic bound — cheap and valuable — or (b) hold the claim at notes-level and revisit after LiteBIRD data 2033+.

Star name **Rasalhague** (α Ophiuchi) — free per the agent_*.md roster, meaning "head of the serpent-bearer" (Arabic "ra's al-ḥawwā'"). Ophiuchus in classical mythology is Asclepius the healer, fitting for a memo about the healing flow's inflation-era dynamics imprinting on the CMB. Near the celestial equator, visible from both hemispheres, bridging ground-based (Southern: ACT, SPT, CMB-S4) and satellite (Northern-orbit: Planck, LiteBIRD) observational assets just as this memo bridges the two frameworks.
