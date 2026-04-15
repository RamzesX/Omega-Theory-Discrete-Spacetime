# Cover letter to the Editors of *Physical Review Letters*

**Manuscript**: *A cold-neutron slope discriminator between discrete-substrate and environmental decoherence at ILL Grenoble*

**Authors**: Norbert Marchewka and the OmegaTheory V2 Collaboration

**Companion material**: *Supplementary Methods: Experimental sensitivity and noise budget for the cold-neutron slope test at ILL Grenoble PF2-VCN* (Alnitak, companion file `Letter-ColdNeutron-SupplementaryMethods.md`).

---

Dear Editors,

We submit this letter because it proposes — to our knowledge — the first experimental test that discriminates a discrete-spacetime substrate from environmental decoherence by *functional shape* rather than absolute amplitude, feasible with current ILL Grenoble hardware at a marginal-cost scale accessible to an ILL long-term proposal.

The proposed test is directly motivated by a recent verified result. Huang *et al.* (*Nature* **627**, 772–777, 2024) reported silicon spin-qubit coherence times scaling as $T^{-1.0}\ldots T^{-3.1}$ above 1 K — a clean power law that rules out Arrhenius thermal activation by $\sim 48$ orders of magnitude, in agreement with the OmegaTheory V2 substrate's per-tick computational-uncertainty prediction $F(T) = F_0/(1 + \alpha T)$. This is the first OmegaTheory prediction with published experimental support, and the present letter argues that a second, orthogonal shape test is now within reach: at fixed arm length, the log-visibility of a cold-neutron interferometer scales as $1/v$ under the substrate (a closed-form consequence of the $\ell_P/t_P = c$ cancellation in the distance-velocity identity), vs $1/v^2$ or steeper under standard Lindblad thermal-bath decoherence. The integer-gap discriminator is robust against absolute-amplitude calibration and statistically easy ($\gtrsim 10\sigma$ at the target data quality).

The feasibility case is concrete. ILL PF2-VCN was commissioned in 2025 (May–October) with nanodiamond-polymer composite gratings (Ackermann *et al.*, arXiv 2604.09312, 2026), delivering the $v \in [30, 700]$ m/s window required. The companion Supplementary Methods file (Alnitak, §S4.4 Table S5) details an 11.5 beam-day campaign at \$97.5K, broken into calibration (1.5 d, \$7.5K), velocity scan (5.5 d, \$27.5K), length cross-check (2.5 d, \$12.5K), custom nDPC grating fabrication for two off-nominal arm lengths (\$20K), turbo-pumped vacuum-enclosure retrofit (\$15K, hard prerequisite), and contingency (2 d, \$15K) — well within an ILL long-term proposal envelope.

The theoretical prediction underpinning this letter is formalized in Lean 4 / Mathlib v4.29 as part of the OmegaTheory V2 project (1652 theorems, 0 `sorry`, 9 axioms; theorems `teleportation_distance_velocity_identity`, `slope_distinguisher_inv_v`, `teleportation_fidelity_substrate_bound_low_T` in `OmegaTheory/Predictions/StochasticTeleportation.lean`). The machine-checked formalization is the authoritative source; public repository permalink [TBD: permalink to be added on submission].

We believe the paper fits PRL's scope: a concrete, shape-level, integer-gap discriminator between a candidate foundational theory and established decoherence physics, testable on existing hardware at modest cost.

Respectfully,

**Norbert Marchewka**
Independent researcher, Poland
norbert.marchewka44@gmail.com

*On behalf of the OmegaTheory V2 Collaboration*
*2026-04-15*
