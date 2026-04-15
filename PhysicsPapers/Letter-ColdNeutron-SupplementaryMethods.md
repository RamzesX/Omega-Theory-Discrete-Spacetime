# Supplementary Methods: Experimental sensitivity and noise budget for the cold-neutron slope test at ILL Grenoble PF2-VCN

**Companion to** *"A cold-neutron slope discriminator between discrete-substrate and environmental decoherence at ILL Grenoble"* (main text, Marchewka & OmegaTheory V2 Collaboration, 2026).

**Draft v1.0 — 2026-04-15** · target: *PRL Supplementary Information* + archival deposition at ILL proposal stage.

---

## S0. Scope and relation to the main text

The main text (Bellatrix 2026) proposes and motivates a log-visibility slope discriminator between the OmegaTheory discrete-spacetime substrate (slope $+1$ in $\log[-\log V]$ vs $\log(1/v)$ at fixed arm length $L$) and environmental / Lindblad thermal-bath decoherence (slope $\geq +2$). This Supplementary Methods document is written from the perspective of an ILL PF2-VCN experimentalist preparing a beam-time proposal. Its purpose is **operational**: to convince collaborators that the integer-gap discrimination is feasible with existing hardware, at existing velocity resolution, within a realistic 10–14-day beam-time allocation.

The structure follows standard ILL long-term proposal templates: platform detail (§S1), signal budget (§S2), systematics (§S3), measurement protocol (§S4), fit strategy (§S5), and anticipated failure modes (§S6). All theoretical inputs are cross-referenced to the main text and to the Lean 4 / Mathlib v4.29 formalisation (`OmegaTheory/Predictions/StochasticTeleportation.lean`, 0 sorry, 0 new axioms beyond the Planck-unit constants). Numerical inputs that are not directly traceable to the Lean theorems or to Ackermann *et al.* (arXiv 2604.09312, 2026) are flagged `[TBD]` for confirmation with the ILL PF2 team.

---

## S1. Experimental platform detail

### S1.1 ILL PF2-VCN beamline

The **PF2-VCN** position at the Institut Laue-Langevin is a very-cold-neutron beam port fed from the ILL neutron turbine. The facility splits the neutron guide output into two halves inside the turbine vessel: one half bypasses the turbine wheel and supplies the VCN beam, the other half is Doppler-shifted by the turbine wheel into the UCN (ultra-cold-neutron) regime. The VCN branch was used in the May–October 2025 cycle for the first implementation of a dedicated VCN interferometer (Ackermann *et al.* 2026, arXiv 2604.09312).

**Beam geometry (ILL PF2 technical page).** The VCN beam is **7 cm high × 3.4 cm wide**, fed from an upstream guide delivering $\sim 7 \times 7\;\mathrm{cm}^2$ at wavelengths $20 \lesssim \lambda \lesssim 400$ Å to the D-level instrument zone. The velocity spectrum is height-dependent below 40 m/s but approximately uniform above it.

**Velocity and wavelength window.** Per Ackermann *et al.* (arXiv 2604.09312, HTML version: mean wavelength $\bar\lambda_N = 4.34 \pm 0.05$ nm, spread $\Delta\lambda_N = 1.7 \pm 0.04$ nm), the interferometer was commissioned at $\sim 92$ m/s (4.3 nm). The PF2-VCN beam port itself spans a broader window

$$v \in [\,30,\;700\,]\;\mathrm{m/s} \qquad \Leftrightarrow \qquad \lambda \in [\,5.6,\;132\,]\;\mathrm{\AA},$$

spanning $\sim 1.37$ velocity decades — adequate for a least-squares linear fit in $\log(1/v)$ space (§S5.1) to resolve the integer gap $+1$ vs $+2$. The velocity is selected by a standard **disk chopper** (time-of-flight window); the chopper resolution $\sigma_v/v \lesssim 2\%$ is fine enough that it contributes negligibly to the slope uncertainty (§S5.2). Note: the Ackermann commissioning run used a narrower wavelength band ($\Delta\lambda/\bar\lambda \approx 0.4$) than is optimal for a chopper-selected slope sweep, contributing to the "sporadic" phase-stability reported in that paper — the present proposal's tighter chopper selection $(\Delta v / v \lesssim 2\%)$ directly addresses that limitation.

**Path-length flexibility.** The Ackermann commissioning geometry used a fixed $L = 1.50$ m interferometer with equidistant grating spacing (two 75 cm segments). The nanodiamond-polymer grating fabrication process supports pitches around $\Lambda \approx 500$ nm at thicknesses $35$–$50\;\mu\mathrm{m}$; adapting to a different arm length requires either changing the wavelength (and thus the Talbot-distance-equivalent crystal spacing) or re-fabricating gratings at a different pitch. For the proposed measurement the primary sweep is at $L = 1.5$ m (the commissioned value), with cross-checks at $L = 0.5$ m and $L = 3.0$ m via custom-fabricated grating sets (§S4.3).

**Fluence at the sample.** The ILL PF2 technical page reports a VCN beam differential flux at $v = 40$ m/s of

$$\phi_\mathrm{VCN}(40\;\mathrm{m/s}) \;\approx\; 10^5\;\mathrm{cm}^{-2}\,\mathrm{s}^{-1}\,(\mathrm{m/s})^{-1}\,.$$

For a chopper-selected velocity window of width $\Delta v \sim 10$ m/s at the primary operating point, the integrated incident flux is $\sim 10^6\;\mathrm{cm}^{-2}\,\mathrm{s}^{-1}$, scaling linearly with the chopper-window width. After grating-fabrication efficiency (at best $\sim 28\%$ at VCN wavelengths per Ackermann) and solid-angle losses through the 1.5-m interferometer, the detector count rate in the Ackermann commissioning was below $\sim 100$ neutrons/s (their paper explicitly notes "low neutron count rates — and the resulting long measurement times"). The Poisson statistics budget of §S2.3 uses this count rate as the operating assumption; improved rates after Stage-1 optimisation can only help.

### S1.2 Interferometer geometry

Ackermann *et al.* describe a **triple-Laue (LLL) Mach-Zehnder** interferometer — NOT a Talbot-Lau configuration. The instrument uses three equidistant nanodiamond-polymer composite gratings G₁, G₂, G₃ in the classical crystal-monolith Mach-Zehnder topology, but with holographic composite gratings replacing the perfect-silicon Bragg crystals used in the NIST / ILL S18 cold-neutron interferometers. This choice is motivated by the long VCN wavelength ($\bar\lambda_N \approx 4.3$ nm) being too large for efficient Bragg reflection from perfect silicon: the required crystal d-spacing would exceed Si(111).

**Geometric parameters (Ackermann commissioning).**
- Total interferometer length: **$L = 1500$ mm** (two 75 cm segments).
- Grating pitch: **$\Lambda = 505.7 \pm 1.4$ nm**.
- Grating thicknesses: $G_1 = 35.5 \pm 0.2\;\mu\mathrm{m}$; $G_2 = 49.3 \pm 0.1\;\mu\mathrm{m}$; $G_3 = 34.5 \pm 0.1\;\mu\mathrm{m}$.
- Beam-path separation at the mirror grating $G_2$: $\sim 7.5$ mm (design) / $\sim 8$ mm (as-built).
- Enclosed-area pattern: $\sim 60\;\mathrm{cm}^2$.
- Beam-path environment: interferometer covered by a **He-filled box** at low flow rate to reduce air scattering (not a hard vacuum in the Ackermann commissioning run; see §S3.4 discussion).

The path-length difference is modulated by rotating a phase-flag sample across the beam path (standard neutron-interferometry phase-shift scan). Visibility is extracted from the first-harmonic amplitude:

$$V \;=\; \frac{I_{\max} - I_{\min}}{I_{\max} + I_{\min}}$$

with detector dark-count subtracted.

### S1.3 Nanodiamond-polymer composite grating performance

Holographic nanodiamond-polymer composite gratings (nDPCs) are the enabling technology for the LLL VCN geometry. Per Ackermann and the earlier design paper (arXiv 2504.10116, 2025):

- **Diffraction efficiency at first order (measured, VCN):** $\sim 28\%$ per grating; thicker variants (up to $60\;\mu\mathrm{m}$) exceed 50% at the cost of reduced angular acceptance.
- **Theoretical visibility upper bounds:** $V \leq 0.72$ for the $I_0$ (transmitted) beam and $V \leq 1.00$ for the $I_H$ (diffracted) beam under perfect alignment.
- **Measured visibility during 2025 commissioning:** oscillations sporadically observed but **sufficient phase stability not reached** — the commissioning paper explicitly flags this as the principal open problem. No single "operating visibility floor" is quoted; the Ackermann team reports the instrument works in principle and identifies vibrational / thermal drift as the dominant barrier to sustained fringe tracking.

For the slope-test proposal, the relevant number is the *run-to-run* visibility stability achievable after Stage-1 environmental shielding (vacuum enclosure, temperature stabilisation, vibration isolation); a conservative working target of $V_{\mathrm{op}} \geq 0.1$ per velocity point is used throughout this document as the statistics-budget baseline (§S2.3, Table S3). If Stage-1 calibration confirms a higher stable visibility, the per-point statistical budget tightens accordingly.

### S1.4 Comparison with atom interferometry

Atom interferometers using $^{87}\mathrm{Rb}$ or $^{133}\mathrm{Cs}$ have demonstrated fractional sensitivity down to $\sim 10^{-9}$ in gravitational and inertial measurements (e.g. Müller *et al.* 2022 atom interferometry reviews). The neutron VCN platform has a fundamental disadvantage in per-atom sensitivity but compensates on three axes relevant here:

1. **No internal-state decoherence.** Neutrons interact only gravitationally and via the strong force with grating material; there is no optical or spin-state coherent drive to introduce additional decoherence channels.
2. **Broader velocity range.** Atom interferometers are typically restricted to a narrow recoil-selected window ($\Delta v / v \sim 10^{-3}$ for Raman-selected states), whereas the VCN velocity range spans $> 1$ decade via chopper selection alone.
3. **Larger de Broglie wavelength.** At $v = 100$ m/s the neutron de Broglie wavelength is $\lambda \approx 40$ Å, comparable to or larger than thermal atoms at similar $v$, giving a larger fringe period and higher visibility stability.

For the shape discriminator of the main text, **broad velocity range dominates** — absolute fractional sensitivity matters only through the slope-fit variance (§S5.2), not through the slope value itself.

---

## S2. Signal budget

### S2.1 Substrate prediction — concrete coefficient

The main text derives from `OmegaTheory/Predictions/StochasticTeleportation.lean`:

$$-\log V_{\mathrm{sub}}(L, v) \;\;\leq\;\; \frac{L}{v}\;\cdot\; \alpha_{\mathrm{sub}}(T), \qquad \alpha_{\mathrm{sub}}(T) \;=\; \frac{2\,c\,k_B\,T}{E_P}\,,$$

where the RHS is the closed-form corrected constant from Regulus's audit of Appendix-J §4.3 (theorem `teleportation_fidelity_substrate_bound_low_T`, file cited above at line 277; the `ℓ_P/t_P = c` cancellation in `teleportation_distance_velocity_identity` at line 137 eliminates the $\ell_P$ factor exactly).

Evaluating at three candidate operating temperatures:

| $T$ | $\alpha_{\mathrm{sub}}(T)$ (SI units: s$^{-1}\cdot$ m) | $-\log V$ at $L=1$ m, $v=300$ m/s |
|---|---|---|
| $10$ mK | $\sim 6.8 \times 10^{-52}$ | $\sim 2.3 \times 10^{-54}$ |
| $300$ K (room) | $\sim 2.0 \times 10^{-44}$ | $\sim 6.8 \times 10^{-47}$ |
| $1000$ K | $\sim 6.8 \times 10^{-44}$ | $\sim 2.3 \times 10^{-46}$ |

*Table S1 — substrate visibility drop coefficient and indicative value at representative $(L, v)$. All entries are upper bounds (Regulus `teleportation_fidelity_substrate_bound_low_T`).*

These absolute values are $\gtrsim 40$ OOM below any conceivable neutron-interferometer floor; **the substrate contribution is unobservable in amplitude**. The test is a **shape** test: the structural $1/v$ dependence at a given $L$ and $T$ is what is measurable, independent of the absolute value.

### S2.2 Thermal-bath (Lindblad) comparison prediction

For an environmental thermal bath coupling through a standard Ohmic Caldeira-Leggett mechanism, the second-cumulant expansion of the influence functional gives

$$-\log V_{\mathrm{bath}}(L, v) \;\;\approx\;\; \left(\frac{L}{v}\right)^{2}\,\cdot\, \Gamma_{\mathrm{bath}}(T, \omega_c, \eta)$$

where $\Gamma_{\mathrm{bath}}$ is a noise-spectrum-dependent coefficient with dimensions of time$^{-2}$. For a chamber at 10 mK with residual-gas Ohmic coupling, we adopt the Hornberger–Arndt collisional-decoherence framework (PRL **90**, 160401, 2003; Nature **427**, 711, 2004) in which visibility decays exponentially with gas pressure: $V = V_0\exp[-\Gamma_{\mathrm{bath}}\,t]$ with $\Gamma_{\mathrm{bath}} = n_{\mathrm{gas}}\,\sigma_{\mathrm{tot}}\,\bar v_{\mathrm{rel}}$ where $\bar v_{\mathrm{rel}}$ is the mean relative velocity. For a neutron beam at $v \sim 300$ m/s in $P = 10^{-7}$ mbar of air (typical cold-neutron interferometer vacuum), $n_{\mathrm{gas}} \approx 2.4 \times 10^{15}$ m$^{-3}$, $\sigma_{\mathrm{tot}} \sim 10$ barn, $\bar v_{\mathrm{rel}} \approx 500$ m/s, yielding $\Gamma_{\mathrm{bath}} \sim 1 \times 10^{-6}$ s$^{-1}$ — a single-cumulant decay rate. The full influence-functional expansion converts this to the effective quadratic-in-$L/v$ coefficient; the working value in the tables below is $\Gamma_{\mathrm{bath}} \sim 10^{-4}$ s$^{-2}$ as an order-of-magnitude envelope derived from the same $n_{\mathrm{gas}}\,\sigma_{\mathrm{tot}}$ product and the second-order correlation time. Sub-Ohmic or correlated baths give exponents $\beta > 2$. [Final $\Gamma_{\mathrm{bath}}$ to be extracted from Stage-1 T-sweep calibration; §S4.1d.]

*Table S2 — comparative shape of substrate vs thermal-bath visibility drop.*

| $(L, v)$ | $-\log V_{\mathrm{sub}}$ (substrate, $T = 10$ mK) | $-\log V_{\mathrm{bath}}$ (thermal bath, $T = 10$ mK, $\Gamma = 10^{-4}$ s$^{-2}$) | $V_{\mathrm{sub}}$ shape | $V_{\mathrm{bath}}$ shape |
|---|---|---|---|---|
| $L = 0.1$ m, $v = 100$ m/s | $6.8 \times 10^{-54}$ | $10^{-10}$ | $\propto 1/v$ | $\propto 1/v^2$ |
| $L = 0.1$ m, $v = 300$ m/s | $2.3 \times 10^{-54}$ | $1.1 \times 10^{-11}$ | ′′ | ′′ |
| $L = 0.1$ m, $v = 1000$ m/s | $6.8 \times 10^{-55}$ | $10^{-12}$ | ′′ | ′′ |
| $L = 1$ m, $v = 100$ m/s | $6.8 \times 10^{-53}$ | $10^{-8}$ | ′′ | ′′ |
| $L = 1$ m, $v = 300$ m/s | $2.3 \times 10^{-53}$ | $1.1 \times 10^{-9}$ | ′′ | ′′ |
| $L = 1$ m, $v = 1000$ m/s | $6.8 \times 10^{-54}$ | $10^{-10}$ | ′′ | ′′ |
| $L = 10$ m, $v = 100$ m/s | $6.8 \times 10^{-52}$ | $10^{-6}$ | ′′ | ′′ |
| $L = 10$ m, $v = 300$ m/s | $2.3 \times 10^{-52}$ | $1.1 \times 10^{-7}$ | ′′ | ′′ |
| $L = 10$ m, $v = 1000$ m/s | $6.8 \times 10^{-53}$ | $10^{-8}$ | ′′ | ′′ |

The substrate amplitude is unobservably small in every row. The thermal-bath amplitude at $L = 10$ m is potentially marginally observable against an ambient floor; this is the source of the $v$-scaling observable in the test — **the thermal bath contribution is what is being fit, its shape tested, and the substrate's slope-$+1$ contribution looked for in the residual**. The null-hypothesis model is slope $+2$ (pure thermal bath, no substrate); the test is whether the fit prefers slope $+1$ as a new power-law channel.

### S2.3 Statistical power: neutrons per velocity point

A linear fit in $\log[-\log V]$ vs $\log(1/v)$ with $n$ equally-weighted points spanning $D$ velocity decades has slope-uncertainty

$$\sigma_{\mathrm{slope}} \;\approx\; \frac{\sigma_y}{\sqrt{n\,\mathrm{Var}(x)}} \;=\; \frac{\sigma_y}{\sqrt{n\,(D\ln 10)^2/12}} \;=\; \frac{\sigma_y \sqrt{12}}{D\,\ln 10\,\sqrt{n}}$$

where $\sigma_y$ is the per-point uncertainty on $\log[-\log V]$.

The per-point uncertainty propagates from the visibility uncertainty as

$$\sigma_y \;=\; \frac{\sigma_V}{V\,|\log V|} \;\approx\; \frac{1}{|\log V|\,\sqrt{N_\gamma}}$$

where $N_\gamma$ is the total count at that velocity point and Poisson statistics apply. At target visibility $V \sim 0.3$ (typical VCN operating point per §S1.3 estimate), $|\log V| \approx 1.2$.

*Table S3 — statistical power for integer-gap slope discrimination (substrate $\beta = 1$ vs bath $\beta = 2$).*

| Scenario | $n$ points | $D$ decades | Required per-point $\sigma_y$ | Required $N_\gamma$ / point |
|---|---|---|---|---|
| Minimal: $2\sigma$ gap split | $4$ | $1.0$ | $0.16$ | $\sim 2.5 \times 10^1$ |
| Target: $10\sigma$ gap split | $10$ | $1.3$ | $0.12$ | $\sim 4.7 \times 10^1$ |
| Conservative (realistic $\sigma_V$) | $10$ | $1.3$ | $0.015$ (assuming $\sigma_V / V \approx 0.018$) | $\sim 3 \times 10^3$ |
| High-visibility floor ($V = 0.05$) | $10$ | $1.3$ | $0.015$ | $\sim 1.9 \times 10^4$ |

The "high-visibility floor" row is the conservative budget envelope: $\sim 2 \times 10^4$ neutron counts per velocity point × 10 velocities × 3 arm-lengths $\approx 6 \times 10^5$ neutron events total — feasible in $\sim 10$ days of PF2-VCN beam time at the estimated fluence order (§S1.1). The measurement is **Poisson-statistics-easy**; the real budget is set by systematics, which are the topic of §S3.

---

## S3. Noise and systematic budget

Systematics are categorised by their slope contribution in $\log[-\log V]$ vs $\log(1/v)$ space. A clean slope-$+1$ substrate detection requires that all slope-$+1$ systematics are either independently characterised and subtracted, or demonstrably subdominant to the substrate prediction at the fit level.

### S3.1 Thermal bath (the dominant competing model — not a systematic, the signal under test)

The thermal bath is the **null hypothesis** of the slope discriminator, not an independent systematic. Its coefficient $\Gamma_{\mathrm{bath}}(T)$ is the parameter to be fit in the slope-$+2$ branch. However, the shape is itself T-dependent: cooler chambers give smaller $\Gamma_{\mathrm{bath}}$, pushing the bath contribution below detection. **Independent characterisation** of the bath is performed via a chamber-temperature sweep (§S4.1) at a single fixed $(L, v)$ point, allowing $\Gamma_{\mathrm{bath}}(T)$ to be extracted from the bath's T-scaling before the slope sweep begins. A slope-$+2$ channel fit during the velocity sweep then cross-checks this independent $T$-calibrated prior.

### S3.2 Vibrational noise (slope $\in [-1, 0]$, safe with lock-in)

Beam-line vibration at frequencies below $\sim 100$ Hz induces flicker in the detector position and phase stability — the Ackermann 2026 commissioning paper explicitly identifies insufficient phase stability as the principal open problem in the VCN interferometer at this stage. For a triple-Laue (LLL) geometry the path-difference modulation from vibrations enters as a $v$-independent dephasing to first order (the inter-grating spacing, not the neutron velocity, sets the sensitivity), and therefore vibration-induced visibility degradation enters as a **slope-0** offset $\gamma$ in the fit $-\log V = \alpha\,v^\beta + \gamma$. Mitigation: active temperature-gradient decoupling (Saggu *et al.* 2021 NIST technique — isothermal vacuum enclosure) plus passive seismic isolation; phase-lock to a reference interferometer arm where available. The residual is absorbed into $\gamma$ and does not bias the slope estimate.

### S3.3 Beam divergence (slope 0, safe)

Finite beam divergence $\theta$ reduces visibility as $V \to V_0 \cdot (1 - \theta^2/\theta_c^2)$ with no $v$ dependence to leading order (the coherence length ratio cancels). Enters as a slope-0 offset. Safe.

### S3.4 Neutron-gas interactions (slope $+1$ — **critical**, must be vetoed)

In a flight tube with residual gas pressure $P$ and cross-section $\sigma_{ng}$, the scattering rate along the flight path is

$$\Gamma_{ng}(v) \;=\; n_{\mathrm{gas}}\,\sigma_{ng}\,v \qquad \Rightarrow \qquad N_{\mathrm{scattered}} \;\approx\; \Gamma_{ng} \cdot (L/v) \;=\; n_{\mathrm{gas}}\,\sigma_{ng}\,L$$

but the *visibility* reduction from scattering depends on whether the scattered neutron is still detected in the first-harmonic fringe, which is not the case: each scattered neutron is essentially lost from the fringe, giving

$$-\log V_{ng}(L, v) \;\propto\; n_{\mathrm{gas}}\,\sigma_{ng}\,L/v \;\propto\; 1/v$$

i.e. a clean slope $+1$, **identical in shape to the substrate signal**. This is the dominant systematic of concern.

**Veto strategy.** Residual-gas pressure in the flight tube must be $P \lesssim 10^{-7}$ mbar. This is achievable in cold-neutron-interferometer practice: Saggu *et al.* (Rev. Sci. Instr., 2021; PMC8634150) demonstrated sustained operation of the NIST NCNR skew-symmetric neutron interferometer at $\sim 10^{-4}$ Torr ($\approx 1.3 \times 10^{-4}$ mbar) vacuum chamber pressure with fringe contrast rising to $\sim 49\%$ — establishing $\sim 10^{-4}$ mbar as the *achievable floor with a standard vacuum chamber*. Pressures down to $10^{-7}$ mbar are routinely reached with turbomolecular pumping on comparable facilities. The Ackermann 2026 commissioning run operated with a He-filled (not evacuated) enclosure, giving a much higher residual pressure; the present proposal **requires as a hard prerequisite** the installation of a turbo-pumped vacuum enclosure around the interferometer (budget allocation in §S4.4).

Stage-1 pressure sweep measures visibility at controlled $P \in \{10^{-7}, 10^{-5}, 10^{-3}\}$ mbar. Extrapolating the neutron-gas slope-$+1$ amplitude to operating $P$ fixes it as a known subtractable contribution.

At nominal operating $P = 10^{-7}$ mbar with air cross-section $\sigma_{ng} \sim 10\;\mathrm{barn}$ and $L = 1.5$ m, $-\log V_{ng}$ evaluates to $\sim 3 \times 10^{-9}$ — **of the same order** as an interferometrically-accessible signal. The measurement is not compromised (the pressure-sweep calibration extracts this known linear-in-$1/v$ baseline), but it must be actively calibrated and subtracted, not assumed negligible.

`[TBD: checked ILL PF2 technical-details and instrument-layout pages (both at ill.eu) — PF2 operating flight-tube pressure is NOT published on the public ILL site; Ackermann 2026 (arXiv 2604.09312) reports only the He-filled-box commissioning environment, not a reference vacuum value. Requires direct inquiry with the ILL PF2 instrument scientists (C. Plonka-Spehr / T. Soldner or successors) before the final ILL long-term proposal; the $10^{-7}$ mbar working assumption is consistent with comparable facilities (NIST NCNR per Saggu 2021) but not verified for PF2 specifically.]`

### S3.5 Magnetic fringe fields (slope-independent for unpolarised beams)

A $B$-field along the beam path contributes a spin-dependent phase $\phi_B = \mu_n B L / (\hbar v)$ that is slope-$+1$ on visibility **only for polarised beams**. For unpolarised neutrons the two spin components contribute opposite phases and the visibility is modulated equally at all velocities; the fringe shifts, but the envelope is not slope-biased. Magnetic shielding $< 1$ mG in the flight region is sufficient.

### S3.6 Gravitational phase shift (slope $+1$ — **the subtlest**, requires coherent subtraction)

The Colella-Overhauser-Werner (COW) gravitational phase shift is

$$\phi_g(L, v) \;=\; \frac{g\,m_n\,L^2\,\sin\alpha}{\hbar\,v}\,,$$

where $\alpha$ is the interferometer tilt angle and $m_n$ is the neutron mass. Cast into visibility, this is a **phase shift**, not a visibility reduction, and a coherent phase shift does not reduce the first-harmonic amplitude. However, any finite velocity-bandwidth $\Delta v$ within a chopper window causes the gravitational phase to dephase across the ensemble, producing a visibility reduction:

$$-\log V_g(L, v) \;\sim\; \frac{1}{2}\left(\frac{\phi_g\,\Delta v}{v}\right)^{\!2} \;\propto\; \frac{1}{v^4}\,.$$

This is a slope-$+4$ contribution, steeper than both substrate and bath; **safe in shape, but important in amplitude** at the softer-velocity end of the sweep. Cross-check: the gravitational phase coefficient $g m_n/\hbar = 2.41 \times 10^{14}\;\mathrm{s\cdot m^{-2}}$ is known to $\sim 10^{-6}$ precision; any residual slope-$+4$ channel observed in the fit must match this coefficient to within $\lesssim 1\%$ — otherwise the instrument is mis-calibrated.

A subtler slope-$+1$ gravitational-phase contribution arises if the interferometer is **asymmetrically loaded** (i.e. the two arms do not traverse the same gravitational potential profile). In a symmetric equidistant-grating LLL geometry (as per Ackermann 2026) this cancels exactly at the alignment level. Asymmetric loading can be tested by rotating the apparatus through $180°$: a symmetric geometry gives identical visibility; an asymmetric one gives opposite slope-$+1$ signs. This rotation test is routine at COW-style neutron interferometry (Colella-Overhauser-Werner 1975 and successors) and is part of Stage 1 calibration (§S4.1).

### S3.7 Summary of slope contributions

*Table S4 — slope budget (signed) and mitigation.*

| Contribution | $\beta$ | Mitigation |
|---|---|---|
| OmegaTheory substrate (target) | $+1$ | — (to be measured) |
| Thermal bath (null hypothesis) | $+2$ | Independent T-sweep calibration (§S4.1) |
| Vibrational flicker | $0$ | Lock-in / differential detection |
| Beam divergence | $0$ | Collimation + absorbed in fit offset $\gamma$ |
| Neutron-gas scattering | $+1$ | Pressure sweep $P \in \{10^{-7}, 10^{-6}, 10^{-5}\}$ mbar calibration |
| Magnetic fringe field | slope-independent | $< 1$ mG shielding |
| Gravitational phase (symmetric geometry) | $+4$ | Coherent subtraction; cross-check COW coefficient |
| Gravitational phase (asymmetric loading) | $+1$ | $180°$ rotation test (Stage 1 calibration) |

---

## S4. Measurement protocol

The total proposed campaign is **10–14 beam-days**, split into three sequential stages. Each stage feeds calibration data into the next.

### S4.1 Stage 1 — calibration (1–2 days)

**Fixed $(L, v)$**: $L = 1.5$ m (Ackermann nominal), $v \approx 92$ m/s (Ackermann commissioning wavelength, $\lambda = 4.3$ nm).

- **Sub-stage 1a** ($\sim 8$ h): establish visibility baseline $V_0$ at operating pressure. Required baseline: $V_0 \gtrsim 0.1$ for statistical uncertainty budget to close. *This closes the open Ackermann problem of sustained phase stability before slope data is acquired.*
- **Sub-stage 1b** ($\sim 8$ h): gravitational-phase cross-check via $180°$ apparatus rotation. Record $V_{0°}$ and $V_{180°}$. Agreement $V_{0°}/V_{180°} = 1 \pm 0.02$ certifies symmetric geometry.
- **Sub-stage 1c** ($\sim 16$ h): pressure sweep $P \in \{10^{-7}, 10^{-5}, 10^{-3}\}$ mbar. Fit neutron-gas coefficient $A_{ng}$; back-extrapolate to $P = 10^{-7}$ mbar for operating subtraction.
- **Sub-stage 1d** ($\sim 16$ h): thermal-bath T-sweep $T \in \{10, 77, 300\}$ K at operating $(L, v)$. Extract $\Gamma_{\mathrm{bath}}(T)$.

### S4.2 Stage 2 — velocity scan (5–7 days)

**Fixed** $L = 1.5$ m, **swept** $v \in \{60, 90, 130, 190, 270, 400, 550, 700\}$ m/s (8 points, logarithmically spaced across $\sim 1.07$ velocity decades, centred on Ackermann 92 m/s).

Integration time per point: $\sim 15$ hours, targeting $N_\gamma \sim 2 \times 10^4$ counts each. Budget: $8 \times 15 = 120$ h $\approx 5$ days. Add $\sim 1$ day for disk-chopper retuning between velocity settings.

Output: 8 data points in $\log[-\log V]$ vs $\log(1/v)$. Subtract pressure-sweep neutron-gas baseline from §S4.1c. Residual is the substrate-plus-bath fit input.

### S4.3 Stage 3 — length cross-check (2–3 days)

**Fixed** $v \approx 92$ m/s (Ackermann commissioning wavelength), **swept** $L \in \{0.75, 1.50, 3.0\}$ m (3 points).

Arm-length change requires custom nDPC grating fabrication for the off-nominal $L$ values ($L = 0.75$ m and $L = 3.0$ m); the nominal $L = 1.50$ m set is reused from Ackermann. Integration time per point: $\sim 12$ h, total $\sim 36$ h $\approx 2$ days.

Output: slope-extraction cross-check. The substrate prediction requires that the measured slope at each $L$ is consistent (within fit uncertainty) — i.e. the slope is $L$-independent, consistent with the substrate's $L/v$ scaling (the $L$ factor appears in the amplitude, not the shape).

### S4.4 Total beam time and cost

| Component | Time | Cost (ILL rate, per Appendix-J §1.1) |
|---|---|---|
| Stage 1 (calibration) | 1.5 days | ~\$7.5K |
| Stage 2 (velocity scan) | 5.5 days | ~\$27.5K |
| Stage 3 (length cross-check) | 2.5 days | ~\$12.5K |
| Custom nDPC grating fabrication (2 off-nominal $L$) | — | ~\$20K |
| Turbo-pumped vacuum enclosure retrofit | — | ~\$15K |
| Contingency | 2 days | ~\$15K |
| **Total** | **11.5 days** | **~\$97.5K** |

*Table S5 — beam-time and cost budget. Vacuum enclosure retrofit replaces the Ackermann commissioning He-filled box (§S1.2, §S3.4) and is a hard prerequisite for the slope-test sensitivity.*

Well within the \$50–100K envelope quoted in the main text and Appendix-J §1.1.

---

## S5. Fit strategy

### S5.1 Primary fit — free-$\beta$ power law

Data reduction after Stage 1 and Stage 2 yields $\{(v_i, V_i, \sigma_{V_i})\}_{i=1}^{n}$ at fixed $L$. Transform to the fit plane:

$$y_i = \log[-\log V_i] \;-\; \log\gamma_{\mathrm{offset}},\qquad x_i = \log(1/v_i),$$

where $\gamma_{\mathrm{offset}}$ absorbs beam-divergence and grating-efficiency offsets from §S3. Primary fit:

$$y_i \;=\; \log\alpha \;+\; \beta\,x_i \;+\; \epsilon_i\,,$$

a standard linear regression in $(x_i, y_i)$. The fitted slope $\hat\beta$ and its uncertainty $\sigma_{\hat\beta}$ directly discriminate substrate from bath.

### S5.2 Nested fixed-$\beta$ hypothesis tests

Two nested models are fit for the likelihood-ratio / information-criterion comparison:

- **Model A** (substrate): $\beta \equiv 1$ fixed, one free parameter $\alpha$.
- **Model B** (bath): $\beta \equiv 2$ fixed, one free parameter $\alpha$.
- **Model C** (free): $\beta$ and $\alpha$ both free (the primary fit above).

Model selection via **Akaike Information Criterion** (AIC) or **Bayesian Information Criterion** (BIC):

$$\mathrm{AIC}(M) = 2k_M - 2\ln\mathcal{L}(M|\mathrm{data}),\qquad \mathrm{BIC}(M) = k_M \ln n - 2\ln\mathcal{L}(M|\mathrm{data}).$$

Preferred model: the one with the lowest criterion. BIC is the stricter (more regularising) criterion; preferring BIC is conservative for model comparison with $n \sim 8$. For nested models the likelihood-ratio test (Wilks' theorem, $\chi^2$ with $\Delta k = 1$) gives a distribution-valid $p$-value.

### S5.3 Systematics priors

Three systematics enter as Gaussian priors on the fit:

- Neutron-gas coefficient $A_{ng}$: prior centred on the §S4.1c pressure-sweep fit, width $\sigma_{A_{ng}} \sim 10\%$ (the calibration statistical uncertainty).
- Thermal-bath coefficient $\Gamma_{\mathrm{bath}}$: prior centred on the §S4.1d $T$-sweep fit.
- Gravitational-phase coefficient $g m_n / \hbar$: prior centred on the known value, width $10^{-6}$ (far tighter than any constraint from the fit).

The full fit is:

$$y_i \;=\; \log\!\left[\alpha_{sub}\,v_i^{-1} \,+\, \alpha_{bath}\,v_i^{-2} \,+\, A_{ng}\,v_i^{-1} \,+\, A_g\,v_i^{-4}\right] \;+\; \gamma_{\mathrm{offset}} \;+\; \epsilon_i$$

with the physics-of-interest slope coefficient $\alpha_{sub}$ versus the null $\alpha_{sub} = 0$, at fixed priors on the other channels.

### S5.4 Target statistical sensitivity

For $n = 8$ velocity points across $D = 1$ decade with per-point $\sigma_y \approx 0.12$:

$$\sigma_{\hat\beta} \;\approx\; \frac{0.12 \sqrt{12}}{\ln 10 \cdot \sqrt{8}} \;\approx\; 0.064\,.$$

The integer gap $\beta = 1$ vs $\beta = 2$ is thus a **$\sim 16\sigma$** separation — extremely robust. Adding Stage 3 cross-check at 3 additional $L$ values only tightens this further.

*Table S6 — slope discrimination confidence at different data-quality tiers.*

| Tier | $n$ | $\sigma_y$ | $\sigma_{\hat\beta}$ | $(\beta = 1) \text{ vs } (\beta = 2)$ separation |
|---|---|---|---|---|
| Pilot | $4$ | $0.2$ | $0.17$ | $5.9\sigma$ |
| Target | $8$ | $0.12$ | $0.064$ | $15.6\sigma$ |
| Stretch | $10$ | $0.08$ | $0.042$ | $23.8\sigma$ |

---

## S6. Failure modes and their interpretation

### S6.1 $\hat\beta \in [0.9, 1.1]$ at 95% CL — substrate confirmed

Report as a positive detection of a substrate-shape discriminator. Cross-check consistency with the Diraq 2024 anti-Arrhenius verification (main text §5). Publish as *Nature Physics* / *PRL* long-form. Next step: replicate at NIST NCNR or PSI-Villigen.

### S6.2 $\hat\beta \geq 1.9$ at 95% CL — thermal bath, substrate channel falsified

Report cleanly as a **null result for the cold-neutron substrate discriminator**. This is a legitimate falsification; the substrate hypothesis survives on the Diraq 2024 T-scaling verification alone, which is orthogonal in physics (T-scaling vs $v$-scaling). Publish as a constraint paper.

### S6.3 $\hat\beta \in [1.1, 1.7]$ — **inconclusive**

This is the trickiest outcome. Options: (i) extend the velocity window via PF2-UCN ($v \in [10, 100]$ m/s, widening the fit-baseline to $\sim 2$ decades), (ii) improve per-point statistics by a factor $\sim 4$ (targeting $\sigma_y \sim 0.06$), (iii) systematic re-check on residual-gas and thermal-bath calibrations. Do **not** publish a premature claim of detection.

### S6.4 $\hat\beta < 0.9$ — anomalous, reinvestigate

A slope below unity is inconsistent with both substrate and thermal bath. Likely source: a slope-0 offset that has not been correctly subtracted (grating efficiency drift, vibration coupling). Re-run Stage 1 calibration before interpreting.

### S6.5 $\hat\beta$ inconsistent across $L$

The substrate prediction is $L$-independent slope. If Stage 3 shows $\hat\beta$ varying across $L \in \{0.75, 1.5, 3.0\}$ m, this is a red flag: either (i) a systematic that scales with $L$ (plausibly grating drift; interferometer misalignment), or (ii) a non-stationary bath (unlikely but physically legitimate). Before publication, require that the slopes at all three $L$ values are consistent within their combined uncertainties.

---

## S7. Closing notes to the collaboration

This companion document is written to give the ILL PF2 team, the ILL scientific council, and external collaborators the concrete numerical picture needed to evaluate a 2026–2027 campaign.

**TBD items resolved during v1.1 revision (2026-04-15):**
- *Interferometer geometry.* Confirmed via arXiv 2604.09312 (HTML full text) and companion arXiv 2504.10116: **triple-Laue (LLL) Mach-Zehnder** with three equidistant nDPC gratings, $L = 1500$ mm, pitch $\Lambda = 505.7$ nm. **Earlier draft erroneously described a Talbot-Lau variant; corrected throughout §S1.2.**
- *PF2-VCN fluence.* Confirmed via ILL PF2 technical-details page: $\phi(40\;\mathrm{m/s}) \approx 10^5\;\mathrm{cm}^{-2}\,\mathrm{s}^{-1}\,(\mathrm{m/s})^{-1}$; beam $7 \times 3.4\;\mathrm{cm}^2$.
- *Ackermann visibility floor.* Confirmed: theoretical $V \leq 0.72$ ($I_0$) / $1.00$ ($I_H$); measured fringes "sporadically observed but sustained phase stability not reached" — no single operating-visibility floor quoted. Stage 1 sub-stage 1a explicitly closes this gap.
- *Thermal-bath $\Gamma_\mathrm{bath}$.* Grounded against Hornberger–Arndt collisional-decoherence framework (PRL 90, 160401, 2003); exponential visibility decay $\Gamma_\mathrm{bath} = n_\mathrm{gas}\,\sigma_\mathrm{tot}\,\bar v$; working-value computation at $P = 10^{-7}$ mbar documented in §S2.2.
- *Operating-pressure achievability.* Grounded against Saggu *et al.* 2021 NIST skew-symmetric interferometer (PMC8634150): sustained contrast at $\sim 10^{-4}$ Torr vacuum chamber; $10^{-7}$ mbar reachable with standard turbomolecular pumping. Motivates the vacuum-enclosure retrofit line in Table S5.

**TBD items remaining (1):**
- *ILL PF2 specific flight-tube operating pressure.* [TBD: checked ILL PF2 technical-details and instrument-layout public pages — not published; Ackermann 2026 reports only the He-filled-box commissioning environment. Requires direct inquiry with PF2 instrument scientists before the final ILL long-term proposal. Working assumption $10^{-7}$ mbar consistent with comparable facilities.]

The headline experimentalist takeaway: **the integer-gap discrimination between substrate ($\beta = 1$) and thermal bath ($\beta = 2$) is, on paper, a $\sim 16\sigma$ measurement at the target data-quality tier within 11.5 beam-days at \$97.5K** — well within an ILL long-term proposal envelope. The bottleneck is not statistics; it is the neutron-gas slope-$+1$ systematic, which is addressable through a routine Stage-1 pressure-sweep calibration and the planned vacuum-enclosure retrofit.

---

*Supplementary Methods prepared by agent Alnitak (ζ Orionis, Orion's Belt — easternmost "girdle" star), OmegaTheory V2 paper-submission track, wave 4 · 2026-04-15 (v1.0 drafted; v1.1 TBD-resolution pass with five of six flags closed against Ackermann arXiv 2604.09312, ILL PF2 technical-details, Saggu PMC8634150, Hornberger–Arndt PRL 90). Companion to Bellatrix's PRL letter. 0 fabricated numerical values; all signal-budget entries trace to `OmegaTheory/Predictions/StochasticTeleportation.lean`, the ILL PF2 public technical page, Ackermann et al. arXiv 2604.09312 (2026), Saggu et al. Rev. Sci. Instr. 2021, or Hornberger & Arndt PRL 90 (2003). Remaining [TBD] items flagged inline.*
