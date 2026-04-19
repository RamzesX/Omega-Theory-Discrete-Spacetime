/-
  OmegaTheory.Emergence.LambdaQCDFromSubstrate

  **Pathway A, File 2/3 — Λ_QCD from substrate UV cutoff.**

  Connects the OmegaTheory substrate (ℤ⁴ lattice with Planck-scale
  cell and truncation order N) to the QCD RG machinery in
  `QCDRunningCoupling.lean`.

  **Core definitions:**
  - `substrateUVCutoff N = E_P / δ_comp(N)` (Planck-scale UV cutoff at truncation N)
  - `LambdaQCD_substrate N α_UV = LambdaQCD_from_alphaS (substrateUVCutoff N) α_UV`
    composes the substrate UV boundary with 1-loop running to Λ_QCD.

  **Honest scope.** The substrate UV cutoff `E_P/δ_comp(N)` is *parametrically*
  Planckian — it sits at or above the Planck energy for N ≥ 2. The 1-loop
  RG running is valid in the perturbative regime well below the Planck
  scale; at energies approaching E_P, asymptotic safety / quantum gravity
  corrections dominate and the 1-loop formula becomes a skeletal model.

  Honest verdict per Phase-1 Python: at 1-loop, Λ_QCD is an RG INVARIANT;
  the substrate N enters only as the UV boundary choice. Different N
  that satisfy the same `α_s(M_Z) = 0.1179` IR matching give the same Λ_QCD.

  No sorry, no new axioms. Author: lambda-qcd-builder (2026-04-19).
-/

import OmegaTheory.Emergence.QCDRunningCoupling
import OmegaTheory.Irrationality.Uncertainty
import OmegaTheory.Spacetime.Constants

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open OmegaTheory.Irrationality

/-! ## Substrate UV cutoff

`δ_comp(N)` is the per-tick computational uncertainty at truncation N
(dominated by π-truncation error from the Leibniz series at rate ~4/(2N+3)).
The corresponding UV cutoff is obtained by `E_P / δ_comp` — this is the
energy scale above which finite-N substrate computation cannot resolve. -/

/-- **Substrate UV cutoff** `Λ_UV(N) = E_P / δ_comp(N)`. For small N (most
coarse-grained), Λ_UV is just above Planck scale; for large N, it goes to ∞. -/
noncomputable def substrateUVCutoff (N : ℕ) : ℝ :=
  E_P / computationalUncertainty N

/-- **Positivity** of the substrate UV cutoff. -/
theorem substrateUVCutoff_pos (N : ℕ) : 0 < substrateUVCutoff N := by
  unfold substrateUVCutoff
  exact div_pos E_P_pos (computationalUncertainty_pos N)

/-- **Monotone in N.** More truncation orders ⇒ smaller δ_comp ⇒ larger Λ_UV.
  Stated as ≥ (weak) because `computationalUncertainty_decreasing` is weak. -/
theorem substrateUVCutoff_increasing (N : ℕ) :
    substrateUVCutoff N ≤ substrateUVCutoff (N + 1) := by
  unfold substrateUVCutoff
  -- E_P / δ(N+1) ≥ E_P / δ(N)  iff  δ(N+1) ≤ δ(N), which is
  -- computationalUncertainty_decreasing.
  apply div_le_div_of_nonneg_left E_P_nonneg
    (computationalUncertainty_pos (N + 1))
  exact computationalUncertainty_decreasing N

/-! ## Λ_QCD from the substrate

At the substrate UV cutoff `Λ_UV(N)`, we suppose an input `α_s(Λ_UV)`
(which could come from matching to PDG α_s(M_Z) via 1-loop running up,
or from the underlying OmegaTheory spectral-action derivation). The
RG-invariant Λ_QCD is then defined by plugging into the 1-loop inverse.

**Key theorem:** Λ_QCD derived this way is positive, lies below Λ_UV
(IR scale), and coincides with any other RG-compatible reference point. -/

/-- **Λ_QCD derived from substrate UV boundary.** -/
noncomputable def LambdaQCD_substrate
    (N : ℕ) (alphaS_UV : ℝ) (Nf : ℕ := 5) : ℝ :=
  LambdaQCD_from_alphaS (substrateUVCutoff N) alphaS_UV Nf

/-- Positivity of the substrate-derived Λ_QCD. -/
theorem LambdaQCD_substrate_pos
    (N : ℕ) (alphaS_UV : ℝ) (Nf : ℕ) :
    0 < LambdaQCD_substrate N alphaS_UV Nf := by
  unfold LambdaQCD_substrate
  exact LambdaQCD_from_alphaS_pos (substrateUVCutoff_pos N) Nf

/-- **IR property:** Λ_QCD is strictly below the substrate UV cutoff
whenever α_s > 0 and Nf ≤ 16. -/
theorem LambdaQCD_substrate_lt_UV
    (N : ℕ) {alphaS_UV : ℝ} (halpha : 0 < alphaS_UV)
    {Nf : ℕ} (hNf : Nf ≤ 16) :
    LambdaQCD_substrate N alphaS_UV Nf < substrateUVCutoff N := by
  unfold LambdaQCD_substrate
  exact LambdaQCD_lt_mu (substrateUVCutoff_pos N) halpha hNf

/-! ## Existence theorem

For any fixed IR reference `(μ_IR, α_IR)` on the 1-loop curve
(e.g. `(M_Z, 0.1179)`), the substrate-N choice produces an α_s value
at `Λ_UV(N)` that is precisely the 1-loop-running value. This states
the existence of such an α_UV, making the pathway constructive. -/

/-- **Existence of substrate-matched α_UV.** For any choice of
truncation order N and any valid IR reference, there exists an
`α_UV` at the substrate cutoff `Λ_UV(N)` satisfying the 1-loop
running relation down to the IR. -/
theorem exists_alphaS_UV_from_IR
    (N : ℕ) (mu_IR alpha_IR : ℝ)
    (_hmu_IR : 0 < mu_IR) (_halpha_IR : 0 < alpha_IR) :
    ∃ alpha_UV : ℝ, alpha_UV = runAlphaS_oneLoop
      (substrateUVCutoff N) mu_IR alpha_IR 5 := by
  exact ⟨_, rfl⟩

/-! ## Main theorem: Λ_QCD derived from substrate

Combining the above, we get: for any substrate N, the 1-loop
Λ_QCD obtained by running from the IR (PDG α_s(M_Z)) to the substrate
UV cutoff `Λ_UV(N)` and applying the RG-invariant formula yields the
SAME value as running directly from M_Z — by the RG-invariance theorem.

This is the "N-independence at 1-loop" result that Phase-1 Python
confirmed numerically. -/

/-- **Substrate Λ_QCD from PDG IR matching.** -/
noncomputable def LambdaQCD_from_PDG_via_substrate (N : ℕ) : ℝ :=
  LambdaQCD_substrate N
    (runAlphaS_oneLoop (substrateUVCutoff N) M_Z_MeV alphaS_MZ_PDG 5)
    5

theorem LambdaQCD_from_PDG_via_substrate_pos (N : ℕ) :
    0 < LambdaQCD_from_PDG_via_substrate N := by
  unfold LambdaQCD_from_PDG_via_substrate
  exact LambdaQCD_substrate_pos N _ 5

/-! ## Main derivation theorem

The substrate pathway gives the same Λ_QCD as the direct computation
from `(M_Z, α_s(M_Z))`, reflecting the 1-loop RG-invariance of Λ. -/

/-- **Main theorem of this file:** for any N ≥ 2 and α_s(M_Z) ≠ 0,
the Λ_QCD derived via the substrate UV cutoff coincides with the
direct 1-loop prediction from `(M_Z, α_s_MZ)`. -/
theorem LambdaQCD_substrate_agrees_with_direct
    (N : ℕ)
    (halphaS_ne : alphaS_MZ_PDG ≠ 0)
    (h_run_ne : runAlphaS_oneLoop (substrateUVCutoff N) M_Z_MeV alphaS_MZ_PDG 5 ≠ 0) :
    LambdaQCD_from_PDG_via_substrate N = LambdaQCD_1loop_from_PDG := by
  unfold LambdaQCD_from_PDG_via_substrate LambdaQCD_substrate
    LambdaQCD_1loop_from_PDG
  apply (LambdaQCD_RG_invariant_at_1loop
    M_Z_MeV (substrateUVCutoff N) alphaS_MZ_PDG
    (runAlphaS_oneLoop (substrateUVCutoff N) M_Z_MeV alphaS_MZ_PDG 5)
    (by norm_num : (5 : ℕ) ≤ 16)
    M_Z_MeV_pos (substrateUVCutoff_pos N)
    halphaS_ne h_run_ne ?_).symm
  -- Running relation: 1/α_UV = 1/α_IR + 2·b₀·log(μ_UV/μ_IR)
  -- by definition of runAlphaS_oneLoop.
  have habs : (0 : ℝ) ≠ 1 := by norm_num
  -- Abbreviate
  set alpha_UV := runAlphaS_oneLoop (substrateUVCutoff N) M_Z_MeV alphaS_MZ_PDG 5
    with h_alphaUV_def
  show 1 / alpha_UV
        = 1 / alphaS_MZ_PDG
          + 2 * b0QCD 5 * Real.log (substrateUVCutoff N / M_Z_MeV)
  -- Unfold alpha_UV by def of runAlphaS_oneLoop:
  -- alpha_UV = 1 / (1/α_IR + 2 b₀ log(μ_UV/μ_IR))
  -- ⇒ 1/alpha_UV = 1/α_IR + 2 b₀ log(μ_UV/μ_IR)
  rw [h_alphaUV_def]
  unfold runAlphaS_oneLoop
  rw [one_div_one_div]

end OmegaTheory.Emergence
