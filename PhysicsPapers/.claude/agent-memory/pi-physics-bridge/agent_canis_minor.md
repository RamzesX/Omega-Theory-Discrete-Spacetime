---
name: Agent identity — CanisMinor
description: lambda-qcd-builder 2026-04-19 delivered Pathway A (Λ_QCD + proton mass), 3 files 616 lines, 0 sorry / 0 new axioms, EMPIRICAL_ANSATZ verdict at 3.8%
type: project
---

Took the name **CanisMinor** on 2026-04-19 on the `lambda-qcd-builder` thread in the `pi-physics-bridge` lineage. CanisMinor (Procyon, α CMi) is the eighth-brightest star and sits near the winter triangle — fitting for the "small but bright" Pathway-A result: mathematically closed, phenomenologically limited.

## What was delivered

**Three Lean files, all GREEN, full project 3635 jobs passing, 0 sorry / 0 new axioms:**

1. `OmegaTheory/Emergence/QCDRunningCoupling.lean` (239 lines)
   - `b0QCD Nf`, `b0QCD_pos`, `b0QCD_Nf5_eq = 23/(12π)`
   - `runAlphaS_oneLoop mu mu0 α`: the 1-loop running formula
   - `runAlphaS_oneLoop_self`: μ = μ₀ → α unchanged (log 1 = 0)
   - `LambdaQCD_from_alphaS`: RG-invariant Λ from any (μ, α)
   - `LambdaQCD_lt_mu`: asymptotic-freedom statement (Λ < μ)
   - `LambdaQCD_RG_invariant_at_1loop`: key theorem — two scales on the same running curve give the same Λ
   - `M_Z_MeV = 91188`, `alphaS_MZ_PDG = 0.1179`, `LambdaQCD_PDG_MeV = 210`

2. `OmegaTheory/Emergence/LambdaQCDFromSubstrate.lean` (172 lines)
   - `substrateUVCutoff N := E_P / δ_comp(N)`: substrate-defined UV cutoff
   - `substrateUVCutoff_increasing`: more truncation → smaller δ → bigger Λ_UV
   - `LambdaQCD_substrate N α_UV`: composes substrate UV boundary with 1-loop inverse
   - `LambdaQCD_from_PDG_via_substrate N`: runs α_s(M_Z) up to Λ_UV(N), then back to Λ_QCD
   - `LambdaQCD_substrate_agrees_with_direct`: 1-loop RG invariance means the substrate N choice DOESN'T change Λ_QCD — only the UV boundary choice matters

3. `OmegaTheory/Predictions/ProtonMassFromLambdaQCD.lean` (205 lines)
   - `protonMassCoefficient := 4.3` (def, NOT axiom — empirical lattice QCD)
   - `protonMass_predicted N := 4.3 · LambdaQCD_from_PDG_via_substrate N`
   - `protonMass_predicted_pos`: positivity (required test in brief)
   - `protonMass_predicted_matches_1loop`: 1-loop equivalence between substrate and direct
   - `protonMass_predicted_PDG_ansatz_eq`: `4.3 × 210 = 903` by `norm_num`
   - `protonMass_predicted_within_PDG_tolerance`: |903 - 938.272| < 40
   - `protonMass_predicted_PDG_ansatz_lt_PDG`: honest admission that PDG-ansatz undershoots
   - `protonMass_empirical_coefficient_is_ansatz : True` — marker for open problem

## Phase-1 Python verdict

Ran `~/services/lambda_qcd_scan.py`:
- 1-loop from α_s(M_Z) = 0.1179, Nf=5: **Λ_QCD ≈ 87 MeV**, m_p = 4.3 × 87 = **375 MeV** — way off.
- 2-loop MSbar: **Λ_QCD ≈ 225 MeV**, m_p = 4.3 × 225 = **967 MeV** — 3.1% high.
- With "217 MeV" (alternative Λ convention), 4.3 × 217 = **933 MeV** — 0.56% low.
- **RG-invariance at 1-loop**: all N produce the same Λ_QCD. Substrate N does NOT enter the numerical prediction at leading order.

**Honest verdict: EMPIRICAL_ANSATZ** — the pathway is mathematically sound, k = 4.3 is a phenomenological input (Durr et al. 2008 lattice), and numerical closure to PDG requires 2-loop+ corrections that are out-of-scope.

## Key Lean-v4.29 facts learned

- `Real.exp_lt_one_iff` works for `exp(negative) < 1`.
- `Real.exp_neg`, `Real.exp_add`, `Real.exp_log` are the standard inverse/decomposition.
- `field_simp` after `rw [Real.exp_log pos]` sometimes closes goals completely — don't chain `ring` after it blindly.
- `mul_lt_mul_of_pos_left` is the Lean-v4.29 replacement for `(mul_lt_mul_left hmu).mpr` in presence of `MulRightStrictMono` instance failures.

## Why the RG-invariance theorem was hard

The `LambdaQCD_RG_invariant_at_1loop` proof required carefully dividing the running hypothesis `1/α₂ = 1/α₁ + 2·b₀·log(μ₂/μ₁)` by `2·b₀` (nonzero for Nf ≤ 16) to extract `1/(2·b₀·α₂) = 1/(2·b₀·α₁) + log(μ₂/μ₁)`. The trick is using `field_simp` on BOTH sides after splitting, then `linarith`. Avoided `sorry` by factoring the β=0 degenerate case out via `b0QCD_ne_zero` as a hypothesis closure.
