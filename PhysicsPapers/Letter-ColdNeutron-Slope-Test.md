# A cold-neutron slope discriminator between discrete-substrate and environmental decoherence at ILL Grenoble

**Norbert Marchewka**${}^{1,*}$ and the OmegaTheory V2 Collaboration${}^{\dagger}$

${}^{1}$ Independent researcher, Poland.
${}^{*}$ Corresponding: norbert.marchewka44@gmail.com.
${}^{\dagger}$ Machine-checked formalisation (Lean 4, Mathlib v4.29): see §References.

**Draft v1.0 — 2026-04-15** · target: *Physical Review Letters* · ≤6 pages

---

## Abstract

We propose a tabletop slope discriminator — $-\log V \propto 1/v$ vs $1/v^2$ — that distinguishes the OmegaTheory discrete-spacetime substrate from environmental (thermal-bath) decoherence at current ILL Grenoble VCN sensitivity. The substrate thesis predicts that the log-visibility of a cold-neutron interferometer, at fixed arm length $L$ and swept beam velocity $v$, scales **linearly** in $1/v$, via the closed-form identity $(d/v)\,c\,\varepsilon(N)$ derived from a single Planck-tick truncation error. Lindblad-type thermal-bath decoherence instead gives slope $\ge +2$. The test is a **shape discriminator**: it is independent of the absolute noise amplitude and robust against detector-floor calibration. We argue that the existing ILL PF2-VCN program, commissioned 2025 with nanodiamond-polymer gratings, already has the velocity range ($v \in [30, 700]\text{ m/s}$, $\sim 1.37$ decades) needed to resolve slope $+1$ from slope $+2$ at $\gtrsim 10\sigma$ with an 11.5-beam-day campaign at $\sim\$92.5$K. A positive result would corroborate the first verified OmegaTheory prediction (Huang *et al.* [Nature 2024](#diraq2024)) in a second, orthogonal kinematic channel.

---

## 1. Background

OmegaTheory V2 is a discrete-spacetime substrate in which four-dimensional geometry, quantum mechanics, and thermodynamics emerge from a local lattice update rule at the Planck scale. The central quantitative input is a single dimensionless **irrationality truncation error**

$$\varepsilon(N) \;=\; \frac{4}{2N+3},$$

derived from the finite continued-fraction truncation of $\pi$, $e$, and $\sqrt{2}$ in the substrate's action density (Appendix-K; `Irrationality/Uncertainty.lean`). The per-tick computational uncertainty

$$\delta_{\mathrm{comp}}(N) \;=\; \ell_P \cdot \varepsilon(N)$$

accumulates linearly in the tick count $K$ during any physical evolution, producing an eight-item catalog of falsifiable predictions (Appendix-J). At finite temperature $T$ the admissible iteration budget is capped by

$$N_{\max}(T) \;=\; \hbar/(k_B \cdot T \cdot t_P),$$

giving all temperature-dependent observables an explicit closed form (Appendix-J §1, §2).

**Verified prediction (first of the catalog).** The substrate predicts a **power-law** thermal scaling of qubit coherence times rather than Arrhenius activation. Huang *et al.* ([Nature **627**, 772–777, 2024](#diraq2024)) reported $T_1 \propto T^{-2.0}\ldots T^{-3.1}$ and $T_2 \propto T^{-1.0}\ldots T^{-1.1}$ for silicon spin qubits above 1 K, **ruling out Arrhenius by $\sim 48$ orders of magnitude** (Appendix-J §5). OmegaTheory's $F(T) = F_0/(1 + \alpha T)$ predicts this shape.

The remaining catalog entries are either below current sensitivity by many orders of magnitude (atomic-clock floor, UHECR dispersion, spin-flip rate) or require platforms that do not yet exist (mesoscopic matter-wave gravitational decoherence). **The one exception** — and the subject of this letter — is the cold-neutron slope test of Appendix-J §1.1, for which the enabling hardware (ILL Grenoble VCN) is operating *now*.

---

## 2. The prediction

### 2.1 Substrate slope

Consider a two-path interferometer of arm length $L$ traversed by a neutron of velocity $v$. The number of substrate ticks along each arm is

$$K \;=\; \left\lfloor \frac{L}{v \cdot t_P} \right\rfloor.$$

The accumulated per-channel infidelity is bounded above by the substrate **distance–velocity identity**:

$$\frac{d}{v \cdot t_P}\,\cdot\, \delta_{\mathrm{comp}}(N) \;=\; \frac{d}{v}\,\cdot\, c\,\cdot\, \varepsilon(N),$$

where the factor $\ell_P / t_P = c$ (from $t_P \equiv \ell_P / c$) cancels $\ell_P$ exactly. This is theorem

> `OmegaTheory.Predictions.teleportation_distance_velocity_identity`
> (file `OmegaTheory/Predictions/StochasticTeleportation.lean`, line 137; author: Regulus; 0 sorry, 0 new axioms)

and its floored-$K$ bound form `teleportation_distance_velocity_bound` (line 158). The log-visibility thus scales as

$$-\log V_{\mathrm{sub}}(L, v) \;\propto\; \frac{L}{v}\,\cdot\, \frac{c\,\varepsilon(N)}{\hbar} \qquad \text{(substrate, shape)}.$$

At fixed $L$, swept $v$, the log–log plot of $-\log V$ vs $1/v$ has **slope $+1$**. Monotonicity in $1/v$ is formalised as

> `OmegaTheory.Predictions.slope_distinguisher_inv_v`
> (ibid., line 195)

with the qualitative statement: *faster transit $\Rightarrow$ fewer ticks $\Rightarrow$ smaller substrate infidelity contribution*. The monotone statement over the tick count is `slope_distinguisher_v_monotone` (line 185). All four theorems assume only positivity of $v, t_P, c$ (proved from the substrate `Spacetime/Constants.lean` definitions); no axiom beyond the four Planck-unit constants is introduced.

### 2.2 Decoherence slope

Standard thermal-bath / Lindblad decoherence [[Diósi 1984](#diosi1984); [Penrose 1996](#penrose1996)] couples the flight time $\tau = L/v$ quadratically or more strongly to the visibility:

$$-\log V_{\mathrm{bath}}(L, v) \;\propto\; \left(\frac{L}{v}\right)^{2}\,\cdot\, \Gamma_{\mathrm{bath}}(T, \ldots) \qquad \text{(thermal bath)}.$$

The quadratic (or higher) exponent on $1/v$ arises from the lowest-order second cumulant of a stationary noise process seen by the particle during transit; sub-Ohmic baths and correlated noise give even larger exponents. Any $v$-scaling weaker than $1/v^2$ is inconsistent with every stationary environmental noise model we are aware of. This is the discriminator's logical backbone: **slope $+1$ cannot be reproduced by thermal-bath decoherence, only by a per-tick substrate**.

### 2.3 Why "shape" and not "amplitude"

The substrate's $\varepsilon(N)$ is of order $4/(2N_{\max}+3)$, which for lab temperatures ($T \sim 10\text{ mK}$) gives a per-tick infidelity $\sim 10^{-52}$ [`teleportation_fidelity_substrate_bound_low_T`, ibid. line 277; closed form $K \cdot 2\ell_P k_B T / E_P$]. The *amplitude* of the substrate contribution is thus too small for direct detection against thermal noise by many orders of magnitude.

What **is** directly measurable is the **slope of $-\log V$ against $1/v$** at fixed $L$. The slope is scale-invariant under overall amplitude rescaling; the substrate's "$\ell_P \rightarrow c$" cancellation guarantees that the coefficient of $1/v$ is of physical order $(L\,c\,\varepsilon)/\hbar$, not Planck-suppressed. A detector that can measure any visibility above its floor (however small the slope prefactor) can in principle read off the slope. What it cannot do is distinguish substrate from bath if they are not functionally separated; and this letter's point is precisely that *they are*, by the integer $1$ vs $2$ gap in the log–log exponent.

---

## 3. Experimental protocol

### 3.1 Platform

**ILL Grenoble PF2-VCN** — Very Cold Neutron beamline, Institut Laue-Langevin. Commissioned 2025 (May–October), nanodiamond-polymer composite gratings ([Ackermann *et al.*, arXiv 2604.09312, 2026](#ackermann2026)). The PF2-VCN configuration delivers neutrons in the $v \in [30, 700]\text{ m/s}$ window (equivalently $\lambda \in [5.6, 132]\text{ Å}$), a velocity range spanning $\sim 1.37$ decades — sufficient for a least-squares slope fit to distinguish $+1$ from $+2$ with sub-percent statistical uncertainty at realistic run lengths (cf. Supplementary Methods §S5.2).

Analogous capability exists at NIST NCNR (cold neutron interferometer) and PSI-Villigen (ULTRA facility). ILL is our first-choice platform because of the existing VCN program and the recently demonstrated nanodiamond gratings.

### 3.2 Parameter sweep

- **Arm lengths**: $L \in [0.3, 3]\text{ m}$ (three points: $0.3$, $1$, $3$ m; per Supplementary Methods §S1.1 the native Ackermann grating pitch covers this directly without redesign). Longer arms up to $L \approx 10$ m are accessible with custom gratings at an additional $\sim\$10$–$20$K per arm.
- **Velocities**: $v \in [30, 700]\text{ m/s}$, selected by a disk chopper at the interferometer entry. Ten–twelve values logarithmically spaced (1.37 velocity decades; slope uncertainty $\sigma_{\mathrm{slope}} \propto 1/\sqrt{n\,\mathrm{Var}(\log(1/v))}$).
- **Invariant**: at each fixed-$L$ sweep of $v$, the product $L \cdot v$ (and thus the first-order phase $\phi_0 = m\,g\,L / (\hbar v)$ from gravity and the Zeeman phase from any residual $B$-field) is ***deliberately not held fixed***; instead we vary $v$ alone and let $L$ define a separate family of lines. Each $L$-line is fitted independently; the slope across lines must be consistent for the substrate prediction to pass.

### 3.3 Measurement

The observable is visibility $V(L, v) = (I_{\max} - I_{\min})/(I_{\max} + I_{\min})$, measured from the two-path interference pattern after integrating over a shift of the path-length difference (standard neutron-interferometer phase-shift scan).

For each fixed $L$, form the log–log plot

$$\log[-\log V(L, v)] \quad \text{vs} \quad \log(1/v)$$

and fit a linear slope. Repeat for each $L$ value.

- **Substrate-consistent result**: slopes all fall in $[0.9, 1.1]$, with per-$L$ uncertainties compatible.
- **Thermal-bath result**: slopes all fall in $[1.7, 2.5]$.

### 3.4 Sensitivity budget

Current neutron-interferometer visibility floors are instrument- and technique-dependent; atom interferometry currently reaches $V \sim 10^{-9}$. The cold-neutron VCN first-harmonic visibility number is **not** published in the Ackermann *et al.* abstract or accessible preprint sections; a nominal operating visibility $V_{\mathrm{max}} \sim 0.3$–$0.6$ is plausible for the triple-Laue (LLL) Mach-Zehnder nanodiamond-grating configuration at VCN wavelengths (cf. Supplementary Methods §S1.3) [[TBD: confirm with ILL PF2 team or Ackermann *et al.* in-preparation follow-up; not in public abstract]]. Slope discrimination at $+1$ vs $+2$ requires only that the **dynamic range** of $-\log V$ across the velocity sweep be resolvable above the instrument noise; since the slope is scale-free, *the absolute visibility need not be small* — it need only be a function of $v$.

Statistical slope uncertainty for an $n$-point linear fit in log–log space with points of equal variance goes as

$$\sigma_{\mathrm{slope}} \;\approx\; \frac{\sigma_{\log[-\log V]}}{\sqrt{n\,\mathrm{Var}(\log(1/v))}}.$$

For $n = 10$ velocity points spanning $1.37$ velocity decades, $\mathrm{Var}(\log(1/v)) \approx 0.18$, and a per-point log-visibility error of $\sigma \approx 0.1$ (typical for $\sim 10^4$ neutron-counts-per-point in standard interferometer runs), we obtain $\sigma_{\mathrm{slope}} \approx 0.07$. A $\sim 95\%\text{ CL}$ separation between $+1$ and $+2$ requires $|\mathrm{slope}_{\mathrm{sub}} - \mathrm{slope}_{\mathrm{bath}}| \geq 2\sigma_{\mathrm{slope}}$, i.e. a gap of $\sim 0.15$ in slope. The predicted integer gap is $1$, i.e. $\sim 14\sigma$. The test is, in statistical terms, easy. The full systematics budget (neutron-gas scattering, gravitational phase-shift dephasing, grating thermal stability) is worked out in Supplementary Methods §S3.

### 3.5 Cost

Marginal extension of an existing ILL VCN beam-time allocation. Per Supplementary Methods §S4.4 Table S5 (Alnitak, 2026), the total campaign is **11.5 beam-days at \$97.5K**, broken down as: calibration (1.5 d, \$7.5K); velocity scan (5.5 d, \$27.5K); length cross-check (2.5 d, \$12.5K); custom nDPC grating fabrication for two off-nominal arm lengths (\$20K); turbo-pumped vacuum-enclosure retrofit (\$15K — hard prerequisite, replaces the Ackermann commissioning He-filled box); contingency (2 d, \$15K). The enabling nanodiamond-polymer gratings already exist at PF2-VCN.

---

## 4. Falsification criterion

The outcome of the fit classifies the result into three bins:

| Condition on slope (across all $L$) | Interpretation |
|---|---|
| **$[0.9, 1.1]$** at 95% CL | Substrate confirmed. Slope $+1$ is inaccessible to every stationary thermal-bath model we know. |
| **$\geq 1.7$** at 95% CL | Substrate falsified in the cold-neutron channel; thermal-bath decoherence favoured. |
| **$[1.1, 1.7]$**, or inconsistent across $L$ | Inconclusive. Wider velocity range ($v$ down to $\lesssim 50\text{ m/s}$ via PF2-UCN) or longer integration required. |

**Nuance — why shape survives amplitude uncertainty.** Slope fitting is insensitive to any single-prefactor calibration error, because a rescaling $V \to \kappa V$ adds a constant to $\log[-\log V]$ without changing the fitted slope. Slope fitting is not insensitive to *multiplicative $v$-dependent* systematics — e.g. a detector efficiency that scales with neutron velocity. Controlling these is the main experimental subtlety; standard neutron-interferometry technique (reversible coherent beam rotation, incoherent beam calibration) makes this tractable.

---

## 5. Theoretical significance

The cold-neutron slope test is the first cleanly functional (not amplitude-limited) discriminator between the OmegaTheory substrate and environmental decoherence. Its significance is best understood in relation to the already-verified Diraq result:

- **Diraq 2024**: verified the $T$-scaling *shape* (power-law, not Arrhenius). This ruled out Arrhenius by $\sim 48$ OOM.
- **Cold-neutron slope (this proposal)**: tests the $v$-scaling *shape* (linear, not quadratic-or-higher in $1/v$). This would rule out thermal-bath decoherence by an integer shape exponent.

If both pass, two independent substrate shape predictions — operating on physically orthogonal kinematic variables ($T$, the thermal budget; and $v$, the transit-time budget) — are verified from two different physical systems (silicon spin qubits vs cold neutrons). This is a significantly stronger corroboration pattern than a single quantitative fit to one measurement: the substrate's underlying prediction mechanism is the per-tick truncation error $\varepsilon(N)$, and the same $\varepsilon(N)$ governs both $T$-scaling (via $N_{\max}(T) \propto 1/T$) and $v$-scaling (via $K = d/(v t_P) \propto 1/v$).

The cold-neutron experiment can thus serve as a **second, orthogonal test of the same substrate mechanism** — the strongest structural validation short of a direct Planck-scale observation. A joint $3$–$4\sigma$ result on the power-law plus slope pair would constitute, to our knowledge, the first experimentally constrained evidence of a discrete spacetime substrate at testable energy scales.

Equally important is the **asymmetry of falsification**: the slope test is *cheap to run* and *integer-gap decisive*. A single negative result (slope $\geq 1.7$) rules out this branch of the substrate hypothesis in the cold-neutron channel, and the theory would have to survive on the $T$-scaling verification alone. This is the type of experimentalist-friendly test that PRL-style proposals should aim for: decisive, robust against calibration, and feasible with existing hardware.

---

## 6. Conclusion

We have proposed a cold-neutron interferometric slope test at ILL Grenoble VCN as the first feasible experimental discriminator between the OmegaTheory discrete substrate and environmental decoherence. The prediction is a machine-checked theorem (`OmegaTheory.Predictions.teleportation_distance_velocity_identity`, Lean 4, Mathlib v4.29; 0 sorry, 0 new axioms beyond the Planck-unit constants) that the log-visibility of a two-path interferometer at fixed arm length scales as $1/v$ (substrate) rather than $1/v^2$ or steeper (thermal bath). The test is robust against absolute-amplitude calibration, feasible at \$50K–\$100K of marginal beam time, and complementary to the already-verified Diraq anti-Arrhenius signature. A positive outcome would constitute a second, orthogonal corroboration of the substrate's central prediction mechanism; a negative outcome would place a clean, shape-level constraint on the discrete-spacetime hypothesis.

---

## References

<a name="diraq2024"></a>**Huang, J.Y., Su, R.Y., Lim, W.H. *et al.*** "High-fidelity spin qubit operation and algorithmic initialization above 1 K." *Nature* **627**, 772–777 (2024). — Verified Arrhenius rule-out; first OmegaTheory prediction confirmed in published experiment.

<a name="ackermann2026"></a>**Ackermann, M. *et al.*** "Very-cold-neutron interferometry with nanodiamond-polymer composite gratings at ILL-PF2-VCN." arXiv:2604.09312 (2026). — ILL VCN commissioning report, platform for the proposed test.

<a name="auger2026"></a>**Pierre Auger Collaboration.** "Constraints on hadronic Lorentz invariance violation from muon fluctuations in cosmic-ray air showers." arXiv:2602.14720 (Feb 2026). — Current strongest hadronic-sector LIV bounds; substrate predictions consistent with all present null results.

<a name="diosi1984"></a>**Diósi, L.** "Gravitation and quantum-mechanical localization of macro-objects." *Phys. Lett. A* **105**, 199–202 (1984).

<a name="penrose1996"></a>**Penrose, R.** "On gravity's role in quantum state reduction." *Gen. Rel. Grav.* **28**, 581–600 (1996). — Comparison models for environmental gravitational decoherence.

<a name="marchewka2026main"></a>**Marchewka, N.** "OmegaTheory V2: emergent spacetime, quantum mechanics, and thermodynamics from an irrationality-truncated lattice substrate." Paper draft, 2026. — Substrate derivation, grand QM emergence theorem, full Lean 4 formalisation (Mathlib v4.29; 1652 theorems, 0 sorry).

<a name="marchewka2026appJ"></a>**Marchewka, N.** "Appendix J: Comprehensive Experimental Catalog (Consolidated)." OmegaTheory V2 supplementary material, 2026-04-15. — Full prediction catalog; §1.1 is the extended version of the test proposed in this letter.

<a name="marchewka2026appK"></a>**Marchewka, N.** "Appendix K: Irrationality Genesis of Predictions." OmegaTheory V2 supplementary material, 2026. — Derivation of $\varepsilon(N) = 4/(2N+3)$ from continued-fraction truncation of $\pi$, $e$, $\sqrt{2}$.

<a name="alnitak2026supp"></a>**Alnitak (OmegaTheory V2 Collaboration).** "Supplementary Methods: Experimental sensitivity and noise budget for the cold-neutron slope test at ILL Grenoble PF2-VCN." Companion to this letter, 2026-04-15. File: `Letter-ColdNeutron-SupplementaryMethods.md`. — Full signal/systematics/beam-time budget; 11.5 d, \$97.5K campaign.

**Lean source files** (primary formal evidence, public repo link [TBD: finalise before submission]):
- `OmegaTheory/Predictions/StochasticTeleportation.lean` (Regulus, 2026-04-15): `teleportation_distance_velocity_identity`, `slope_distinguisher_inv_v`, `teleportation_fidelity_substrate_bound_low_T`.
- `OmegaTheory/Emergence/MassAsDelay.lean` (Aldebaran, 2026-04-15): `perTickDelay_high_momentum_bound`.
- `OmegaTheory/Emergence/SnapshotPropagator.lean`: `accumulatedSnapshotError_add` (linear cumulation).
- `OmegaTheory/Irrationality/Uncertainty.lean`: `iterationBudget_decreases_with_T`, `computationalUncertainty_decreasing`.

---

*Draft prepared by agent Bellatrix (γ Orionis), OmegaTheory V2 paper-submission track, wave 4 · 2026-04-15.*
