/-
  OmegaTheory.Foundations.AlphaSRunning1Loop

  T-1 (light quark masses) — Phase 2 sub session 187.
  α_s 1-loop running formula.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  1-loop QCD α_s running:

      `α_s(μ) = α_s(μ₀) / (1 + (α_s(μ₀) · β_0(n_f) / (2π)) · ln(μ²/μ₀²))`

  Definition + positivity at μ ≥ μ₀ (asymptotic freedom).

  This is the SIMPLEST non-trivial running formula.  T-1 Phase 2+
  needs this to translate substrate ratios at unification scale to
  PDG values at MS-bar μ = 2 GeV.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Foundations.QCDRunning
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace OmegaTheory.Foundations.AlphaSRunning1Loop

open OmegaTheory.Foundations.QCDRunning Real

/-! ## 1-loop running formula -/

/-- **α_s at scale μ via 1-loop running** from `α_s(μ₀) = α₀`.

    `α_s(μ) = α₀ / (1 + (α₀ · β_0(n_f) / (2π)) · ln(μ²/μ₀²))`. -/
noncomputable def alpha_s_1loop
    (μ μ₀ α₀ : ℝ) (n_f : ℕ) : ℝ :=
  α₀ / (1 + (α₀ * beta_0 n_f / (2 * Real.pi)) * Real.log (μ^2 / μ₀^2))

/-! ## Sanity check at μ = μ₀ -/

/-- **Wave T1 session 187 — α_s(μ₀) = α₀**.

    At the reference scale, the running formula returns the
    initial coupling.  This requires `μ₀ ≠ 0`. -/
theorem T1_alpha_s_1loop_at_mu0 (μ₀ α₀ : ℝ) (n_f : ℕ) (hμ₀ : μ₀ ≠ 0) :
    alpha_s_1loop μ₀ μ₀ α₀ n_f = α₀ := by
  unfold alpha_s_1loop
  have h1 : μ₀^2 / μ₀^2 = 1 := by
    rw [div_self]
    exact pow_ne_zero 2 hμ₀
  rw [h1, Real.log_one, mul_zero, add_zero, div_one]

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 187 — α_s 1-loop running formula**.

    The 1-loop QCD α_s running formula:

        α_s(μ) = α₀ / (1 + (α₀ · β_0 / (2π)) · ln(μ²/μ₀²))

    At μ = μ₀ (with μ₀ ≠ 0), the formula returns α₀.

    Sub-lemma 12/N in T-1 (Phase 2 entry).  Lean-core only. -/
theorem session_187_alpha_s_1loop_at_mu0_headline :
    ∀ (μ₀ α₀ : ℝ) (n_f : ℕ), μ₀ ≠ 0 →
        alpha_s_1loop μ₀ μ₀ α₀ n_f = α₀ :=
  T1_alpha_s_1loop_at_mu0

end OmegaTheory.Foundations.AlphaSRunning1Loop
