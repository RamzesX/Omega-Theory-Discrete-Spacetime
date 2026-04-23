# Constant Chain Audit — Predictions/ Files

**Auditor**: Mimosa (wave 7, 2026-04-15)
**Scope**: All `OmegaTheory/Predictions/` files except `StochasticTeleportation.lean` (already audited by Regulus in wave 2).

---

## Audit Table

| File | Theorem / Def | Lean constant | Paper constant (Appendix-J section) | Match? | Notes |
|------|--------------|--------------|--------------------------------------|--------|-------|
| **HermiticityDefect.lean** | `hermiticity_defect_bound` | Residue `<= 2 * computationalUncertainty N` = `2 * l_P * 4/(2N+3)` | No explicit numerical constant in Appendix-J (qualitative envelope) | YES | Bound is qualitative; `2 * delta_comp(N)` is internal. No paper constant to mismatch. |
| **HermiticityDefect.lean** | `clock_precision_floor` | `2 * l_P * k_B * T / (hbar * c)` | Appendix-J SS1.2: `2 * l_P * k_B * T / (hbar * c)` | YES | Exact match. |
| **HermiticityDefect.lean** | `mach_zehnder_phase_floor` | `sqrt(L / (c * t_P)) * delta_comp(floor(N_max)) / hbar` | Appendix-J SS3.2: `sqrt(L/(c*t_P)) * delta_comp(N) / hbar` | YES | Structural match. The `N = floor(qubitIterationBudget 1 T)` substitution is consistent with Uncertainty.lean. |
| **HermiticityDefect.lean** | `spin_flip_strictly_positive` | `(delta_comp(floor(N_max)) / hbar)^2 > 0` | Appendix-J SS3.2: qualitative `Gamma_sub > 0` | YES | Qualitative statement only; positivity proven. SpinFlipRate.lean gives the closed form. |
| **HermiticityDefect.lean** | `isometric_defect_bound` | `0 <= defect <= Gamma_perturb * t_P` | Appendix-J SS4: qualitative `O(t_P)` envelope | YES | Honest envelope, scoped correctly. |
| **RedshiftFloor.lean** | `vacuumResidualInformationCost` | `(l_P / (2 * mu)) * L` | Appendix-J SS2.2: `l_P * L / (2 * mu)` | YES | Algebraically identical. |
| **RedshiftFloor.lean** | `redshift_floor_hubble` | `l_P * L_Hubble / 2` | Appendix-J SS2.2: `l_P * L_Hubble / 2` (mu=1, C=nu_o) | YES | Exact match; yields `~10^-9` for `L_Hubble ~ 1.3e26 m`. |
| **RedshiftFloor.lean** | `cosmological_redshift_floor_from_vacuum_curvature` | `C * vacuumResidualInformationCost L mu / nu_o` | Appendix-J SS2.2: `C * (l_P * L / (2*mu)) / nu_o` | YES | Structural match via `vacuumResidualInformationCost`. |
| **GravDecoherenceTScaling.lean** | `gravDecoherenceRateSubstrate` | `G^2 * M^4 * Dx^4 * k_B^2 * T^2 * l_P^2 / (hbar^2 * c^12 * t_P^5)` | Appendix-J SS2.1: `M^4 * Dx^4 * k_B^2 * T^2 * l_P^2 / (hbar^2 * c^12 * t_P^5)` (proportional, `G^2` implicit in "proportional to") | YES | Paper uses `proportional to` notation; Lean has the full `G^2` prefactor. Consistent. |
| **GravDecoherenceTScaling.lean** | `grav_decoherence_T_squared_scaling` | `Gamma(2T) = 4 * Gamma(T)` | Appendix-J SS2.1: `T^2` scaling | YES | Direct algebraic corollary of the `T^2` factor. |
| **GravDecoherenceTScaling.lean** | `grav_decoherence_substrate_vanishes_at_zero_T` | `Gamma(T=0) = 0` | Appendix-J SS2.1: substrate vanishes at T=0 vs DP positive | YES | |
| **GravDecoherenceTScaling.lean** | `gravDecoherenceRateDiosiPenrose` | `G * M^2 / (hbar * Dx)` | Appendix-J SS2.1: `G * M^2 / (hbar * Dx)` | YES | Exact match for comparator. |
| **GravDecoherenceTScaling.lean** | `decoherence_linear_N_env_bound` | `B <= N_env * C^2 * exp(-2*alpha*N)` | Appendix-J SS2.1: linear in `N_env` | YES | Structural (existential witness). |
| **UHECRDispersion.lean** | `uhecr_velocity_dispersion_mass_bound` | `c - v(p,m) <= (m*c)^2 * c / (2*p^2)` | Appendix-J SS3.1: `(mc)^2 * c / (2*p^2)` | YES | Exact match. Traces to `MassAsDelay.massive_asymptotes_to_null_at_high_E`. |
| **UHECRDispersion.lean** | `defectInducedDispersionBound` | `kappa * eps^2 / tau^2` | Appendix-J SS3.1: `kappa * eps^2 / tau^2` | YES | Exact match. |
| **UHECRDispersion.lean** | `uhecr_dispersion_composite_bound` | `(m*c)^2 * c / (2*p^2) + kappa * eps^2 / tau^2` | Appendix-J SS3.1: `(mc)^2*c/(2p^2) + kappa*eps^2/tau^2` | YES | Exact match; sum of two contributions. |
| **ChristoffelSparsity.lean** | `christoffel_hot_spot_proxy_bound` | `defectFraction <= eps^2 / tau^2` | No explicit Appendix-J constant (structural prediction) | YES | Traces cleanly to `Defects.Sparsity.defectFraction_le`. Markov/Chebyshev bound `eps^2/tau^2` is universal. |
| **ChristoffelSparsity.lean** | `christoffel_hot_spot_proxy_exp_bound` | `<= C^2 * exp(-2*alpha*N) / tau^2` | No explicit Appendix-J constant | YES | Lifted from `defectFraction_exp_bound`. |
| **ChristoffelSparsity.lean** | `christoffelError_decomp` | `2*(3*(M_inv+eps_inv)/l_P)*eps + 2*(3*M_deriv*eps_inv)` | No explicit Appendix-J constant | YES | Internal structural decomposition. Linear-in-eps coefficient `6*(M_inv+eps_inv)/l_P` checked against `ValuedGeometry.lean` definition. |
| **SpinFlipRate.lean** | `spinFlipRateSubstrate` | `4 * l_P^2 * k_B^2 * T^2 / (hbar^2 * c^2 * t_P)` | Appendix-J SS3.2: `4 * l_P^2 * k_B^2 * T^2 / (hbar^2 * c^2 * t_P)` | YES | Exact match. |
| **SpinFlipRate.lean** | `spinFlipRateSubstrate_simplified_form` | `4 * t_P * k_B^2 * T^2 / hbar^2` | Appendix-J SS3.2 (implicit via `l_P = c * t_P`) | YES | Algebraic simplification; proven via `t_P = l_P / c`. Chain: `l_P^2 / (c^2 * t_P) = (c*t_P)^2 / (c^2*t_P) = t_P`. Correct. |
| **GammaRayDispersion.lean** | `gammaRayDispersionSubstrate` | `(E / E_P) * (4 / (2*N + 3))` | Appendix-J SS2.3: `(E/E_P) * eps(N)` where `eps(N) = 4/(2N+3)` | YES | Exact match. The `4/(2N+3)` is `pi_error_val N` from Approximations.lean. |
| **GammaRayDispersion.lean** | `gammaRayDispersionSubstrate_below_any_positive_bound` | For any B>0, exists N0 s.t. dispersion <= B for N >= N0 | Appendix-J SS2.3: "substrate consistent with all current null results" | YES | Lean proves the Archimedean property of the bound. |
| **GammaRayDispersion.lean** | `substrate_vs_pure_LV_distinguisher` | Substrate < pure-LV `kappa*(E/E_P)` for N >= N0 | Appendix-J SS2.3: substrate has N-dependence, pure-LV does not | YES | Structural distinguisher proven via `pure_LV_is_constant_in_N`. |

---

## Summary

**Discrepancies found: 0**

All 24 audited constant expressions across 7 files trace cleanly through the constant chain:
- `l_P = sqrt(hbar * G_N / c^3)` (Constants.lean:43)
- `t_P = l_P / c` (Constants.lean:46)
- `E_P = hbar / t_P` (Constants.lean:49)
- `computationalUncertainty N = l_P * pi_error_val N` where `pi_error_val N = 4/(2N+3)` (Uncertainty.lean:33, Approximations.lean:153)
- `iterationBudget T = hbar / (k_B * T * t_P)` (Uncertainty.lean:104)
- `defectFraction <= eps^2 / tau^2` (Sparsity.lean:151)

No bookkeeping artifacts of the type Regulus caught in Appendix-J SS4.3 (the `8 -> 2` correction) were found in the remaining files. Every closed-form constant in Lean matches the corresponding Appendix-J statement, or (for structural/qualitative predictions) is internally consistent with the upstream definitions. The constant-chain health is clean.
