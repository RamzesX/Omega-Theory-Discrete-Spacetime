# Matter Sector Research — Acamar (θ Eridani)

**Original date**: 2026-04-17
**Post-cycle-43 audit**: 2026-04-21 — W1, W2, W3 wild connections have all LANDED as Lean theorems; "3 generations" has been refined to "3 SM generations + 1 sterile-ν channel from Catalan-G" (see §4 below).
**Purpose**: Literature scan + creative connections for OmegaTheory matter sector (quarks, leptons, Yukawa, CKM/PMNS, generations).

---

## 1. Five literature findings (2024-2026)

### F1. KATRIN 2025 direct neutrino mass bound
- **Result**: m_ν < 0.45 eV (90% CL), 259 days of tritium data, 36M electrons. Factor-2 tighter than prior bound.
- **Source**: Aker et al., *Science* (2025), DOI 10.1126/science.adq9592.
- **Relevance to OmegaTheory**: Fixes upper bound on the *lightest* δ-scale in the matter sector. Our δ_comp(N) must produce neutrino mass below this.

### F2. DESI DR2 + Planck cosmological neutrino mass
- **Result**: Σm_ν < 0.0642 eV (ΛCDM), in 3σ tension with oscillation lower bound Σm_ν ≥ 0.059 eV (normal ordering).
- **Source**: DESI Collaboration, arXiv:2503.14738 (2025); arXiv:2507.12401 frequentist reanalysis.
- **Relevance**: The "squeeze" between cosmology and oscillations may demand new physics — **OmegaTheory's δ_comp offers a natural cutoff mechanism**.

### F3. PDG 2024 CKM update + first Jarlskog from moduli alone
- **Result**: J_CKM = (3.00 +0.15 -0.09) × 10^-5, determined from |V_ij| moduli in 8 independent ways, demonstrating CKM unitarity self-consistency.
- **Source**: PDG 2024 rev-ckm-matrix (Ceccucci, Ligeti, Sakai); Harrison et al., arXiv:2309.07656.
- **Relevance**: CP-violation scale is extraordinarily small (~10^-5). **Hypothesis**: J ~ (δ_comp/E_P)^k for some k — order-of-magnitude test below.

### F4. T2K + NOvA joint PMNS analysis (2025)
- **Result**: θ₁₂ = 33.4° ± 0.8°, θ₂₃ = 49° ± 1°, θ₁₃ ≈ 8.6°, δ_CP still unresolved. Joint tension remains.
- **Source**: T2K & NOvA Collaborations, *Nature* (2025), DOI 10.1038/s41586-025-09599-3.
- **Relevance**: PMNS angles are LARGE, unlike CKM. This asymmetry needs an explanation — the "√2 hypothesis" below.

### F5. Connes-Chamseddine NCG fermion mass status
- **Result**: Spectral action DOES generate Standard Model + gravity + neutrino mixing + see-saw, but **Yukawa matrices remain free parameters in D_F**. No first-principles mass prediction yet.
- **Source**: JHEP 02 (2019) 068 "Fermion masses... almost commutative geometry"; JHEP 07 (2015) 023 non-associative extension; arXiv:2603.29876 (2026) single-sector rotation approach.
- **Relevance**: OmegaTheory's chance for originality — **derive D_F eigenvalues from δ_comp of the 3 irrationals**.

---

## 2. Three wild connections to OmegaTheory

### W1. ~~[SPECULATIVE]~~ **[CLOSED Apr-21]** Neutrino mass lower bound = computational uncertainty floor
The DESI/KATRIN squeeze suggests Σm_ν sits right at ~0.06 eV. OmegaTheory predicts a minimum mass from δ_comp at the cosmological computational budget N_cosmo ~ (t_univ/t_P) ≈ 10^61.
- **Claim**: m_ν,lightest = ℏ · δ_comp(N_cosmo) / (c² · ℓ_P) for the √2 channel (fastest convergence → lightest).
- **Status**: ~~Follows from existing δ_comp machinery in `Irrationality/Uncertainty.lean`. NOT YET assembled.~~ **CLOSED**: shipped as `Predictions/NeutrinoMassFloorW1.lean` with `W1_consistent_with_DESI` theorem (verified in Neo4j 2026-04-21).
- **Test**: If prediction lands in [0.01, 0.06] eV window, we win.

### W2. ~~[SPECULATIVE]~~ **[CLOSED Apr-21]** J_CKM = (δ_comp,π · δ_comp,e · δ_comp,√2)^(1/3) / E_P normalized
The triple Jarlskog (CKM) ≈ 3×10^-5 and leptonic Jarlskog (PMNS) ≈ 3×10^-2 differ by ~1000× — matching the spread between π-channel and √2-channel convergence rates at moderate N.
- **Claim**: J is a geometric mean of three channel uncertainties; the π-dominated quark sector gets tiny J, the √2-enhanced lepton sector gets large J.
- **Status**: ~~Speculative analogy — needs formal product rule in ErrorHopf. Difficulty: weeks.~~ **CLOSED**: shipped as `Predictions/JarlskogFromIrrationals.lean`.

### W3. ~~[FOLLOWS FROM ALGEBRA — strong]~~ **[CLOSED Apr-21]** PMNS large angles = √2 channel dominance in lepton sector
CKM angles are small (Cabibbo θ_C ≈ 13°, θ₂₃ ≈ 2°), PMNS are large (33°, 49°). In OmegaTheory, mixing ∝ ratio of adjacent δ_comp channels.
- **Claim**: Lepton sector couples to √2-channel (fast convergence, large relative variation between iterations N, N+1 before asymptotic regime) → large mixing. Quark sector couples to π-channel (slow 1/N convergence → small inter-iteration ratio) → small mixing.
- **Status**: ~~Quantifiable from BoundsLemmas.lean; would produce a *formula* relating Cabibbo angle to truncation orders. Difficulty: session-scale for the formula, days for a numerical hit.~~ **CLOSED**: shipped as `Predictions/MixingAnglesFromIrrationals.lean`.

---

## 4. [Apr-21 update] The 4th irrational: Catalan-G as sterile-ν channel

Post-cycle-27 (Alsafi + ConnesCalibrationAndFourChannels) the hypothesis has been
**generalized from 3 to 4 irrationals**. The 4th irrational (Catalan's constant
G ≈ 0.91596...) has convergence rate `O(1/N²)` — between π (O(1/N)) and √2
(O(2⁻²ᴺ)) — and does NOT generate a 4th SM generation. Instead, it couples
to a **sterile-neutrino dark-matter channel**:

| Constant | δ_comp(N) rate | Channel role |
|---|---|---|
| π (Leibniz) | `O(1/N)` — largest δ | heavy SM gen (3rd) |
| e (Taylor) | `O(1/N!)` | middle SM gen (2nd) |
| Catalan-G | `O(1/N²)` — between π, √2 | sterile ν / DM |
| √2 (Newton) | `O(2⁻²ᴺ)` — smallest δ | light SM gen (1st) |

Formalization: `Predictions/SterileNeutrinoFromFourthIrrational.lean`
(31 catalan theorems), `Emergence/ConnesCalibrationAndFourChannels.lean`,
`channelToGeneration4_bijective`, `sterile_neutrino_mass_window_witness`.
A backward-compat theorem `original_three_in_three_channels` preserves the
earlier 3-generation mapping.

**Important**: the 4 channels are **fibered over ~14 Leiden subsystems**, not
a flat partition of the corpus — see GROTHENDIECK_MATH_PUZZLE.md MP-5.

---

## 3. Numerical test: 3-irrationals ↔ 3 generations

**Convergence rates** (residual at iteration N):
| Channel | Formula | N=3 | N=5 | N=7 |
|---------|---------|-----|-----|-----|
| δ_π | 4/(2N+3) | 0.444 | 0.308 | 0.235 |
| δ_e | 1/N! | 0.167 | 8.3×10⁻³ | 2.0×10⁻⁴ |
| δ_√2 | 2^(-2^N) | 3.9×10⁻³ | 2.3×10⁻¹⁰ | 5.4×10⁻³⁹ |

**Ratios δ_heavy/δ_light** (larger δ ↔ heavier, since mass = per-tick delay):
| N | δ_π/δ_e | δ_e/δ_√2 |
|---|---------|----------|
| 3 | 2.67 | 42.7 |
| 5 | 37.0 | 3.6×10⁷ |
| 7 | 1175 | 3.7×10³⁴ |

**Observed lepton mass ratios** (PDG):
- m_τ/m_μ ≈ **16.8**
- m_μ/m_e ≈ **207**

**Verdict**: At **N ≈ 4**, the ratios are δ_π/δ_e ≈ 8–15 and δ_e/δ_√2 ≈ 10³–10⁴. The π/e ratio is the right order of magnitude for τ/μ, but the e/√2 ratio overshoots μ/e by 10-100×. This means:
- **√2 channel converges TOO FAST** for electron mass if straight inverse mapping.
- **Correction needed**: perhaps the channels couple to generations via *log* of δ, not δ directly. log(δ_π) ≈ -1, log(δ_e) ≈ -2, log(δ_√2) ≈ -5 at N=3 → linear gap ~1:2:5 not 1:17:207·17 either.
- **Best fit hypothesis**: m_i ∝ ln(1/δ_i) × (π-normalization) — **warrants a session to fit**.

**Conclusion**: The raw convergence rates are NOT a direct match, but the *ordering* (π=heavy, e=middle, √2=light) and the rough *log-separation* are consistent. A Connes-style spectral triple weighting could bridge the gap. **Recommended next step**: propose `fermion_mass_from_truncation_channel` theorem signature in `Irrationality/GenerationMap.lean`.

---

## Sources
- [KATRIN Science 2025](https://www.science.org/doi/10.1126/science.adq9592)
- [DESI DR2 arXiv:2503.14738](https://arxiv.org/abs/2503.14738)
- [Cosmological ν-mass frequentist review arXiv:2507.12401](https://arxiv.org/abs/2507.12401)
- [PDG 2024 CKM review](https://pdg.lbl.gov/2024/reviews/rpp2024-rev-ckm-matrix.pdf)
- [Jarlskog from moduli arXiv:2309.07656](https://arxiv.org/abs/2309.07656)
- [T2K+NOvA Nature 2025](https://www.nature.com/articles/s41586-025-09599-3)
- [JUNO PMNS rotation arXiv:2603.29876](https://arxiv.org/html/2603.29876)
- [Connes NCG + ν-mixing hep-th/0608226](https://arxiv.org/abs/hep-th/0608226)
- [Fermion masses almost commutative JHEP 02(2019)068](https://link.springer.com/article/10.1007/JHEP02(2019)068)
- [Sedenion S₃ three generations EPJC 2023](https://link.springer.com/article/10.1140/epjc/s10052-023-11923-y)
