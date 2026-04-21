---
title: "Letter: Cold Neutron Slope Test (Executive Summary)"
description: "PRL submission package executive summary for the cold-neutron g-time-dilation experiment"
category: "Letters"
order: 60
---

# Executive Summary — ILL PF2-VCN slope-discriminator proposal

**For:** ILL beam-time committee chair · **2026-04-15** · **Companions:** *Letter-ColdNeutron-Slope-Test.md* (Bellatrix) · *Letter-ColdNeutron-SupplementaryMethods.md* (Alnitak)

---

**The question.** Does cold-neutron visibility loss come from (a) a discrete-spacetime substrate (OmegaTheory V2) or (b) standard thermal-bath decoherence? They differ by an **integer exponent** in $-\log V$ vs $1/v$ at fixed arm length: substrate slope $+1$ (machine-checked Lean 4 theorem [`teleportation_distance_velocity_identity`](https://github.com/RamzesX/chaos-shield/blob/main/PhysicsPapers/LeanFormalizationV2/OmegaTheory/Predictions/StochasticTeleportation.lean#L137), 0 sorry, derived from $\ell_P/t_P = c$; build 2026-04-21: **3,835 jobs GREEN, 8 physical axioms, 8,996 `:Theorem` nodes in `OmegaTheoryV2` graph**) vs thermal-bath slope $\geq +2$ (standard second-cumulant expansion). **Shape test, not amplitude test** — no absolute sensitivity floor needed.

**Why 16σ.** Slope-fit uncertainty $\sigma_{\hat\beta} = \sigma_y\sqrt{12}/(D\,\ln 10\,\sqrt n) \approx 0.064$ for $n=8$ velocity points across $D=1.07$ decades with per-point $\sigma_y \approx 0.12$ (achievable at $\sim 2\times 10^4$ counts/point). Integer gap: $(2-1)/0.064 \approx 15.6\sigma$. Pilot / target / stretch tiers are $\sim 6\sigma / 16\sigma / 24\sigma$ (Supplementary §S5.4, Table S6).

**The ask.** **11.5 beam-days, ~\$97.5K total.** Breakdown: 1.5d Stage-1 calibration + 5.5d Stage-2 velocity scan + 2.5d Stage-3 length cross-check + 2d contingency (~\$62.5K beam time); plus ~\$20K custom nDPC gratings for 2 off-nominal arm lengths; plus ~\$15K turbo-pumped vacuum enclosure retrofit. Platform: ILL PF2-VCN commissioned 2025 with the Ackermann *et al.* (arXiv 2604.09312) triple-Laue nDPC interferometer, $L = 1500$ mm, pitch 505.7 nm, $v \approx 92$ m/s. Public PF2 spec: $\phi(40\text{ m/s}) \approx 10^5$ cm$^{-2}$s$^{-1}$(m/s)$^{-1}$, beam 7 × 3.4 cm.

**Primary risk — neutron-gas slope-$+1$ systematic.** Residual-gas scattering gives visibility drop $\propto L/v$, functionally indistinguishable from substrate. At $P = 10^{-7}$ mbar, $L = 1.5$ m: $-\log V_{ng} \sim 3\times10^{-9}$, same order as the measurable residual — must be actively subtracted. *Mitigation:* Stage-1 pressure sweep ($P \in \{10^{-7}, 10^{-5}, 10^{-3}\}$ mbar) fits the gas coefficient directly. NIST NCNR (Saggu *et al.* 2021) operates comparable interferometers at this vacuum with ~49% contrast — the technique is proven.

**Secondary risks.** (i) Gravitational asymmetry (slope $+1$) vetoed by $180°$ rotation test; (ii) vibrational dephasing (the open problem in Ackermann 2026) addressed by the vacuum retrofit + Saggu-style isothermal shielding; (iii) thermal bath is the null hypothesis (not a systematic), extracted from Stage-1 T-sweep. Full 7-source budget in Supplementary Table S4.

**Unresolved.** ILL PF2 flight-tube operating pressure is not on the public ILL pages (verified 2026-04-15); requires PF2-instrument-scientist confirmation. Working $10^{-7}$ mbar assumption is consistent with comparable facilities.

**Go / no-go.** **Go** if Stage-1 calibration confirms: (1) sustained $V_0 \geq 0.1$ at Ackermann nominal $(L,v)$ — closes the open Ackermann phase-stability problem; (2) pressure-sweep fit on $A_{ng}$ converges with $\leq 10\%$ uncertainty; (3) $180°$ rotation agreement $V_{0°}/V_{180°} = 1 \pm 0.02$. Decision at 1–2 beam-days in; Stages 2 and 3 commit only on Stage-1 success. **No-go** — or hardware revision — if any prerequisite fails.

**Scientific payoff.** A positive 95% CL result is the second orthogonal shape-level verification of the OmegaTheory substrate mechanism (after Huang *et al. Nature* **627**, 772, 2024 anti-Arrhenius T-scaling) and one of the few tabletop Planck-scale discriminator tests available today at existing ILL facilities.

---

*Alnitak (ζ Orionis), OmegaTheory V2 wave-4 · 2026-04-15. Every numerical claim traces to the Supplementary Methods TBD-resolution audit (§S7) or to the Lean 4 formalisation in the main text.*
