# Proton mass in OmegaTheory — scoping memo

**Author:** proton-scope (pi-irrationality-hunter thread) | **Date:** 2026-04-19
**Status:** Planning only. No proof attempt. 0 sorry, 0 axioms added.

> **Post-cycle-43 update (2026-04-21):** cycles 24-43 shipped **ConnesDFYukawaMass** (lepton/quark Yukawa bridge), **HiggsAndMassHierarchy**, **PiHunchQuantitative**, and the **OmegaTheoryGrandCapstoneV2** — but Λ_QCD and the proton bound-state calculation remain unshipped. Pathway A (δ_comp → Λ_QCD, §§4–5 below) is still the recommended next step; §§1–3 audit of QCD infrastructure is unchanged because no QCD/heat-kernel work landed in cycles 24-43. Build: 3,835 jobs green, 0 sorry, 8,996 theorems / 24 axioms / 211 files.

## 1. Why proton is different from leptons/quarks

Quark Yukawa masses (few MeV to GeV) come from `m = y · v / √2` where `y` is a Yukawa coupling and `v ≈ 246 GeV` the Higgs VEV. Proton mass `m_p ≈ 938 MeV` is **~99% QCD binding energy** (Λ_QCD gluon + chiral condensate `<q̄q> ≈ (250 MeV)³`), with only ~9 MeV from the bare `u,u,d` Yukawa contributions. The proton is a **non-perturbative bound state**, so the derivation pathway is categorically different from `QuarkMassFromIrrationals.lean`.

## 2. Existing OmegaTheory QCD infrastructure (audit)

| File | Lines | What it gives us |
|------|------:|------------------|
| `Emergence/ErrorGaugeSU3.lean` | 451 | SU(3) Lie algebra, `su3Bracket`, `StrongCouplingFromSubstrate` record, `strongCouplingConstant_from_substrate N Λ_QCD` (accepts Λ_QCD as an **input parameter**, does not derive it), `strongCoupling_decreasing/tendsto_zero`, gluon substrate mass bound |
| `Emergence/NonAbelianGauge.lean` | 780 | Non-abelian framework (general-N, not SU(3)-specific) |
| `Emergence/SU3JacobiFull.lean` + `SU3JacobiHelper.lean` | — | Jacobi identity (proven, not hypothesis) |
| `Emergence/HilbertEmergence.lean` | 772 | Substrate Hilbert space — basis for bound-state construction |
| `Emergence/ConnesSpectralAction.lean` + `SpectralActionExpansion.lean` | 441+711 | Spectral action with 4 `Prop := True` TODO-cluster-A sites |
| `Foundations/HeatKernelMinimal.lean` | 856 | **Tarazed's minimal Seeley-DeWitt skeleton** — sector-presence only, does NOT compute `a_k` coefficients |
| `Emergence/QuarkMassFromIrrationals.lean` | 547 | Yukawa-only quark masses; not binding-energy |
| `Emergence/SymmetryBreaking.lean` | — | Chiral/Higgs symmetry breaking primitives |

**Gaps:** no `Λ_QCD`-derivation, no chiral condensate `<q̄q>`, no Wilson loop / confinement, no bound-state spectrum, no lattice-QCD-style propagator. Mathlib has zero hits for `QCD`, `heatKernel`, `WilsonLoop`.

## 3. Three candidate pathways

### A. δ_comp-based Λ_QCD (one-loop RG)
Substrate UV cutoff Λ = 1/δ_comp(N). One-loop running: `Λ_QCD = Λ · exp(-6π / ((33-2N_f)·α_s(Λ)))`. OmegaTheory already has `strongCouplingConstant_from_substrate` outputting `gs² = δ_comp·(Λ/E_P)²` — invert + exponentiate + match experiment. Delivers Λ_QCD as a number; proton mass then requires separate binding calc (3 months +).

### B. Connes spectral action
Spectral action a priori contains QCD. But (i) Tarazed's skeleton is sector-presence only; (ii) real Gilkey `a_4` needs heat-kernel asymptotics absent from Mathlib; (iii) Λ_QCD is not a spectral-action output — it's an IR scale set by RG running below the Planck/UV cutoff. **Mismatch: spectral action gives UV Lagrangian, Λ_QCD is IR.**

### C. Lattice QCD analog on ℤ⁴
Define baryon operator `B(p) = u(p)u(p)d(p)`, compute `<0|B†(0)B(p)|0>` over substrate Hilbert. Needs: (1) fermion spinors on lattice (partial — `DiracEquation.lean`), (2) SU(3) connection with Wilson action (NOT present — `NonAbelianGauge.lean` is continuum), (3) non-perturbative path integral (barely sketched), (4) confinement proof (unsolved in general). **Years, not sessions.**

## 4. Recommended pathway: **A (δ_comp → Λ_QCD)**

Only A is tractable in a month-level timeline. B is blocked on Mathlib heat-kernel gaps AND a conceptual UV/IR mismatch. C is a decade problem (Clay Millennium-level for full confinement). A gives a concrete numerical prediction within existing machinery.

## 5. Missing pieces + session-count estimate (Pathway A)

1. `Emergence/RunningCoupling.lean` (NEW, ~300 L, 2 sessions) — one-loop β-function, `α_s(μ) = α_s(Λ)/(1 + b₀·α_s(Λ)·ln(μ²/Λ²))`, `b₀ = (33-2N_f)/(12π)`.
2. `Emergence/LambdaQCDFromSubstrate.lean` (NEW, ~200 L, 2 sessions) — noncomputable def `Λ_QCD N := (1/δ_comp N)·exp(-6π/((33-2N_f)·α_s_substrate N))`, plus `Λ_QCD_pos`, `Λ_QCD_tendsto` as N→∞.
3. `Predictions/LambdaQCDPrediction.lean` (NEW, ~150 L, 1 session) — numerical bound `|Λ_QCD N - 217 MeV| < ε` at physical N.
4. Extension to proton binding (Pathway A+): `m_p ≈ k·Λ_QCD` where `k ≈ 4.3` is lattice-QCD empirical. That's a **1-parameter phenomenological fit**, not a derivation. Honest scope: derive Λ_QCD, cite `k` from PDG.
5. Mathlib gaps: none for Pathway A — one-loop RG is elementary analysis. Heat kernel / spectral zeta (needed for B) would require Mathlib upstream work (unrelated issue, already tracked).

**Estimate:** 5 sessions, 2 agents (lean-proof-wizard + me), ~2 weeks wall-clock for Λ_QCD only. Proton-mass-from-Λ_QCD as a phenomenological bridge adds 1 session.

## 6. First falsifiable prediction if Pathway A succeeds

`Λ_QCD(N_phys) = 217 ± 10 MeV` at `N_phys` matching observed α_s(M_Z) = 0.1179. If substrate N is fixed by another OmegaTheory constant (e.g. iteration budget at cosmic time), this becomes **no-parameter prediction**. Derived quantity: `m_p = 4.3·Λ_QCD ≈ 933 MeV`, within 0.5% of PDG. Falsifier: if substrate-derived Λ_QCD differs from 217 MeV by >30 MeV at the α_s-matched N, the δ_comp → UV-cutoff identification fails.

## 7. Agent-team layout if green-lit

- **proton-scope (me)** — coordination, numerical validation with mpmath/PARI
- **lean-proof-wizard** — `RunningCoupling.lean` (RG ODE, positivity, monotonicity)
- **quantum-physics-creative** — literature survey on Λ_QCD UV-cutoff dependence (Shirkov, 't Hooft)
- **pi-physics-bridge** — connect `N_phys` to other OmegaTheory fixed points

**Honest caveat:** Pathway A gives Λ_QCD, not proton mass. Full `m_p` derivation from first principles is lattice QCD's open problem and is out of OmegaTheory's reach in 2026. The memo recommends stopping at Λ_QCD and citing the empirical k ≈ 4.3 bridge.
