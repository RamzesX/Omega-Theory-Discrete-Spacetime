/-
  OmegaTheory.Emergence.QCDRunningCoupling

  **Pathway A, File 1/3 — 1-loop RG running of α_s + Λ_QCD as RG invariant.**

  Mission: formalize the 1-loop β-function of QCD and the RG-invariant
  Λ_QCD as a function of α_s at an arbitrary reference scale.

  Key physics (perturbative QCD, leading order):

    dα/d(ln μ) = -2 b₀ α²          (1-loop β-function)
    b₀ = (33 - 2 N_f) / (12π)       (asymptotic-freedom coefficient)
    1/α(μ) - 1/α(μ₀) = 2 b₀ ln(μ/μ₀)   (integrated form)
    Λ = μ · exp(-1 / (2 b₀ α(μ)))   (RG invariant)

  **Honest scope.** These are the leading-order (1-loop) formulas.
  2-loop and threshold-matching corrections shift Λ_QCD by ~10-20%;
  downstream `ProtonMassFromLambdaQCD.lean` captures this with the
  `k ≈ 4.3` phenomenological coefficient. The 1-loop formulas here are
  mathematically closed and physically meaningful; the numerical
  coincidence with PDG Λ_QCD ≈ 210 MeV needs 2-loop+ corrections.

  No sorry, no new axioms. Author: lambda-qcd-builder (2026-04-19).
-/

import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Tactic

namespace OmegaTheory.Emergence

open Real

/-! ## 1-loop QCD β-function primitives

`b₀(N_f) = (33 - 2 N_f) / (12π)` is the leading asymptotic-freedom
coefficient. For `N_f ≤ 16` (physical range), `b₀ > 0`, so α_s runs
to zero at high energy ("asymptotic freedom"). -/

/-- **1-loop β-coefficient** `b₀ = (33 - 2·N_f)/(12π)`. -/
noncomputable def b0QCD (Nf : ℕ) : ℝ :=
  ((33 : ℝ) - 2 * (Nf : ℝ)) / (12 * Real.pi)

/-- For `N_f ≤ 16` (physical), `b₀ > 0` — asymptotic freedom condition. -/
theorem b0QCD_pos {Nf : ℕ} (hNf : Nf ≤ 16) : 0 < b0QCD Nf := by
  unfold b0QCD
  have h12π : (0 : ℝ) < 12 * Real.pi := by positivity
  have hnum : (0 : ℝ) < 33 - 2 * (Nf : ℝ) := by
    have : (Nf : ℝ) ≤ 16 := by exact_mod_cast hNf
    linarith
  exact div_pos hnum h12π

/-- For physical QCD with `N_f = 5` (between b-quark and M_Z), `b₀ > 0`. -/
theorem b0QCD_pos_Nf5 : 0 < b0QCD 5 := b0QCD_pos (by norm_num : (5 : ℕ) ≤ 16)

/-- Numerical value hint: `b₀(5) = 23/(12π)`. -/
theorem b0QCD_Nf5_eq : b0QCD 5 = 23 / (12 * Real.pi) := by
  unfold b0QCD
  norm_num

/-- The β-coefficient is nonzero for physical N_f ≤ 16. -/
theorem b0QCD_ne_zero {Nf : ℕ} (hNf : Nf ≤ 16) : b0QCD Nf ≠ 0 :=
  ne_of_gt (b0QCD_pos hNf)

/-! ## 1-loop running of α_s

The 1-loop running formula solves `dα/d(ln μ) = -2 b₀ α²` as
`1/α(μ) = 1/α(μ₀) + 2 b₀ ln(μ/μ₀)`, equivalently
`α(μ) = 1 / (1/α(μ₀) + 2 b₀ ln(μ/μ₀))`. -/

/-- **1-loop running** `α_s(μ)` given `α_s(μ₀)`. Uses the integrated
β-equation `1/α(μ) = 1/α(μ₀) + 2·b₀·ln(μ/μ₀)`. -/
noncomputable def runAlphaS_oneLoop
    (mu mu0 alphaS_mu0 : ℝ) (Nf : ℕ := 5) : ℝ :=
  1 / (1 / alphaS_mu0 + 2 * b0QCD Nf * Real.log (mu / mu0))

/-- **Self-consistency at μ = μ₀.** The running formula at the reference
scale returns `α_s(μ₀)` itself — `log(1) = 0` closes the loop. -/
theorem runAlphaS_oneLoop_self
    (mu0 alphaS_mu0 : ℝ) (Nf : ℕ)
    (hmu0 : mu0 ≠ 0) :
    runAlphaS_oneLoop mu0 mu0 alphaS_mu0 Nf = alphaS_mu0 := by
  unfold runAlphaS_oneLoop
  rw [div_self hmu0, Real.log_one, mul_zero, add_zero, one_div_one_div]

/-! ## Λ_QCD as RG invariant

The key observation: for any `μ` on the 1-loop running curve,

  `ln(μ/Λ) = 1 / (2 b₀ α(μ))`

so `Λ = μ · exp(-1/(2 b₀ α(μ)))` is **μ-independent** along
the solution curve. -/

/-- **Λ_QCD from α_s(μ).** Defines Λ_QCD as the RG-invariant
mass scale implied by `α_s` at any reference `μ`. -/
noncomputable def LambdaQCD_from_alphaS
    (mu alphaS : ℝ) (Nf : ℕ := 5) : ℝ :=
  mu * Real.exp (- 1 / (2 * b0QCD Nf * alphaS))

/-- Positivity: `Λ_QCD > 0` whenever the input `μ > 0`. -/
theorem LambdaQCD_from_alphaS_pos
    {mu alphaS : ℝ} (hmu : 0 < mu) (Nf : ℕ) :
    0 < LambdaQCD_from_alphaS mu alphaS Nf := by
  unfold LambdaQCD_from_alphaS
  exact mul_pos hmu (Real.exp_pos _)

/-- Nonnegativity corollary. -/
theorem LambdaQCD_from_alphaS_nonneg
    {mu alphaS : ℝ} (hmu : 0 ≤ mu) (Nf : ℕ) :
    0 ≤ LambdaQCD_from_alphaS mu alphaS Nf := by
  unfold LambdaQCD_from_alphaS
  exact mul_nonneg hmu (Real.exp_pos _).le

/-- **Λ_QCD is strictly below μ** whenever `α > 0` and the β-coefficient
is positive — this is asymptotic freedom saying Λ lies in the IR. -/
theorem LambdaQCD_lt_mu
    {mu alphaS : ℝ} (hmu : 0 < mu) (halpha : 0 < alphaS)
    {Nf : ℕ} (hNf : Nf ≤ 16) :
    LambdaQCD_from_alphaS mu alphaS Nf < mu := by
  unfold LambdaQCD_from_alphaS
  have hb0 : 0 < b0QCD Nf := b0QCD_pos hNf
  have h2bα : 0 < 2 * b0QCD Nf * alphaS := by positivity
  -- exp of negative is < 1
  have hneg : - 1 / (2 * b0QCD Nf * alphaS) < 0 := by
    rw [neg_div]
    have : 0 < 1 / (2 * b0QCD Nf * alphaS) := by positivity
    linarith
  have hexp : Real.exp (- 1 / (2 * b0QCD Nf * alphaS)) < 1 :=
    Real.exp_lt_one_iff.mpr hneg
  have := mul_lt_mul_of_pos_left hexp hmu
  linarith [this]

/-! ## Numerical bridge helper

At `μ = M_Z = 91.188 GeV`, PDG 2024 gives `α_s(M_Z) = 0.1179`.
The 1-loop Λ_QCD (Nf=5) at this input is ~87 MeV. The full PDG
Λ_QCD^(MSbar, Nf=5) ≈ 210 MeV requires 2-loop+ corrections.

Downstream consumers of this file should treat `LambdaQCD_from_alphaS`
as a **1-loop skeleton**, to be refined with `k ≈ 4.3` phenomenology
when matching to `m_p ≈ 938 MeV` (see `ProtonMassFromLambdaQCD.lean`). -/

/-- **Reference scale:** M_Z in MeV (PDG 2024). -/
def M_Z_MeV : ℝ := 91188

theorem M_Z_MeV_pos : 0 < M_Z_MeV := by unfold M_Z_MeV; norm_num

/-- **PDG α_s(M_Z)** = 0.1179 (PDG 2024, average). -/
def alphaS_MZ_PDG : ℝ := 0.1179

theorem alphaS_MZ_PDG_pos : 0 < alphaS_MZ_PDG := by
  unfold alphaS_MZ_PDG; norm_num

/-- **PDG reference Λ_QCD^(MSbar, Nf=5)** = 210 MeV. -/
def LambdaQCD_PDG_MeV : ℝ := 210

theorem LambdaQCD_PDG_pos : 0 < LambdaQCD_PDG_MeV := by
  unfold LambdaQCD_PDG_MeV; norm_num

/-- **1-loop prediction from PDG α_s(M_Z).** This is a numeric
object; users should compose with phenomenological corrections
when comparing to PDG 2-loop. -/
noncomputable def LambdaQCD_1loop_from_PDG : ℝ :=
  LambdaQCD_from_alphaS M_Z_MeV alphaS_MZ_PDG 5

theorem LambdaQCD_1loop_from_PDG_pos : 0 < LambdaQCD_1loop_from_PDG := by
  unfold LambdaQCD_1loop_from_PDG
  exact LambdaQCD_from_alphaS_pos M_Z_MeV_pos 5

theorem LambdaQCD_1loop_from_PDG_lt_MZ :
    LambdaQCD_1loop_from_PDG < M_Z_MeV := by
  unfold LambdaQCD_1loop_from_PDG
  exact LambdaQCD_lt_mu M_Z_MeV_pos alphaS_MZ_PDG_pos (by norm_num : (5 : ℕ) ≤ 16)

/-! ## RG-invariance witness

The key physical content: `Λ_QCD` computed from `α_s(μ)` on the
1-loop running curve is μ-independent. We state a **local reformulation**
conditional on the running relation holding between two scales. -/

/-- **Local RG-invariance witness.** If two reference points
`(μ₁, α₁)`, `(μ₂, α₂)` satisfy the 1-loop running relation, they
produce the same Λ_QCD. -/
theorem LambdaQCD_RG_invariant_at_1loop
    (mu1 mu2 alpha1 alpha2 : ℝ)
    {Nf : ℕ} (hNf : Nf ≤ 16)
    (hmu1 : 0 < mu1) (hmu2 : 0 < mu2)
    (halpha1 : alpha1 ≠ 0) (halpha2 : alpha2 ≠ 0)
    (hrun : 1 / alpha2 = 1 / alpha1 + 2 * b0QCD Nf * Real.log (mu2 / mu1)) :
    LambdaQCD_from_alphaS mu1 alpha1 Nf =
      LambdaQCD_from_alphaS mu2 alpha2 Nf := by
  -- The identity is algebraic once we unfold:
  --   μ₂ · exp(-1/(2b₀α₂)) = μ₂ · exp(-1/(2b₀α₁) - ln(μ₂/μ₁))
  --                         = μ₂ · exp(-1/(2b₀α₁)) · exp(-ln(μ₂/μ₁))
  --                         = μ₂ · exp(-1/(2b₀α₁)) · (μ₁/μ₂)
  --                         = μ₁ · exp(-1/(2b₀α₁))
  unfold LambdaQCD_from_alphaS
  have hb0_pos : 0 < b0QCD Nf := b0QCD_pos hNf
  have hb0_ne : b0QCD Nf ≠ 0 := ne_of_gt hb0_pos
  have h2b0_ne : (2 : ℝ) * b0QCD Nf ≠ 0 := mul_ne_zero two_ne_zero hb0_ne
  have h2b0α1_ne : (2 * b0QCD Nf * alpha1) ≠ 0 := mul_ne_zero h2b0_ne halpha1
  have h2b0α2_ne : (2 * b0QCD Nf * alpha2) ≠ 0 := mul_ne_zero h2b0_ne halpha2
  have hratio_pos : 0 < mu2 / mu1 := div_pos hmu2 hmu1
  -- Step 1: derive `1/(2b₀α₂) = 1/(2b₀α₁) + ln(μ₂/μ₁)` from `hrun`.
  have hdiv :
      1 / (2 * b0QCD Nf * alpha2)
        = 1 / (2 * b0QCD Nf * alpha1) + Real.log (mu2 / mu1) := by
    -- Starting hypothesis:
    -- 1/α₂ = 1/α₁ + 2·b0 · log
    -- Divide both sides by 2·b0 (nonzero).
    have hkey : (1 / alpha2) / (2 * b0QCD Nf)
                  = ((1 / alpha1) + 2 * b0QCD Nf * Real.log (mu2 / mu1))
                    / (2 * b0QCD Nf) := by
      rw [hrun]
    -- Now simplify both sides:
    -- LHS = 1/(α₂·2b0) = 1/(2b0·α₂) (commuting factors)
    -- RHS = 1/(α₁·2b0) + log(μ₂/μ₁)
    have hlhs : (1 / alpha2) / (2 * b0QCD Nf) = 1 / (2 * b0QCD Nf * alpha2) := by
      field_simp
    have hrhs : ((1 / alpha1) + 2 * b0QCD Nf * Real.log (mu2 / mu1))
                  / (2 * b0QCD Nf)
                  = 1 / (2 * b0QCD Nf * alpha1) + Real.log (mu2 / mu1) := by
      field_simp
    linarith [hlhs, hrhs, hkey]
  -- Step 2: rewrite exponents.
  have hfrac :
      - 1 / (2 * b0QCD Nf * alpha2)
        = (- 1 / (2 * b0QCD Nf * alpha1)) + (- Real.log (mu2 / mu1)) := by
    have : -(1 / (2 * b0QCD Nf * alpha2))
            = -(1 / (2 * b0QCD Nf * alpha1)) + -(Real.log (mu2 / mu1)) := by
      linarith [hdiv]
    rw [neg_div, neg_div]
    linarith [this]
  rw [hfrac, Real.exp_add, Real.exp_neg, Real.exp_log hratio_pos]
  -- Goal: mu1 * exp(-1/(2b0α1)) = mu2 * (exp(-1/(2b0α1)) * (mu2/mu1)⁻¹)
  field_simp

end OmegaTheory.Emergence
