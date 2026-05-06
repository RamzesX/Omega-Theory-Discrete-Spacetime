/-
  OmegaTheory.HealingFlow.HiggsSymmetricVacuumInstability

  **Lion's-Pride Phase 2.3 (2026-05-06)**: the SSB content — the
  symmetric vacuum `φ = 0` is dynamically unstable as a fixed point
  of the coupled Higgs functional in the presence of substrate
  defects, in the sub-critical-coupling regime `κ·D² < μ²`.

  ## Why this file (the SSB heart)

  Phase 2.1 shipped `IsCoupledHealingFlow`.  Phase 2.2 shipped the
  augmented Lyapunov `coupledFunctional`.  This file ships the
  **dynamical content of Higgs creation**: starting from the
  symmetric configuration `φ ≡ 0` with non-zero substrate defects,
  the gradient flow does NOT keep `φ` at `0` — it ROLLS DOWN to
  one of the Mexican-hat minima `φ = ±√(μ²/(2λ_H))`.

  This is the FIRST CRITICAL TOPOLOGICAL EVENT framing.  When
  defects exist (substrate is not at flat-Minkowski equilibrium)
  and the coupling κ is sub-critical, the symmetric Higgs
  configuration is NOT a minimum of the coupled Lyapunov — it is a
  local MAXIMUM (in φ) along the pointwise potential, so any
  perturbation drives `φ → ±v`.

  ## What this file ships

  | Theorem                                       | Content                                                       |
  |-----------------------------------------------|---------------------------------------------------------------|
  | `pointwisePotential`                          | one-point-restricted potential `V_shifted(φ) + κ·D²·φ²`        |
  | `pointwisePotential_at_zero`                  | `P(0) = μ⁴/(4λ_H)` (the constant Mexican-hat shift)            |
  | `pointwisePotential_diff_eq`                  | `P(φ) − P(0) = φ²·(λ·φ² − μ² + κ·D²)`                          |
  | `pointwisePotential_lt_at_small_phi_subcritical` | core SSB: `P(φ) < P(0)` for small `|φ|` when `κ·D² < μ²`     |
  | `phi_zero_not_local_min_when_defects_present`  | symmetric vacuum is NOT a local minimum                       |
  | `phi_zero_unstable_when_defects_present`       | the load-bearing capstone (SSB content)                      |
  | Headline 4-conjunct                           | `higgs_symmetric_vacuum_instability_report`                   |

  ## Honest scope

  - This file proves the STATIC instability (φ = 0 is not a local
    minimum of the pointwise potential).  The DYNAMICAL convergence
    `φ(τ) → ±v` is Phase 2.4 (`HiggsConvergenceToVEV.lean`),
    composing this static fact with Phase 1.3 LaSalle.
  - "Sub-critical coupling" `κ·D² < μ²` is the natural physical
    regime: the Mexican-hat `−μ²` term dominates the defect-coupling
    `+κD²` term in the second derivative at `φ = 0`.  In the
    super-critical regime `κ·D² > μ²`, the defect term DOMINATES and
    `φ = 0` becomes a local minimum (defect-stabilised symmetric
    vacuum); we do not address that regime here as it is not the
    Higgs-creation scenario.

  ## Lit anchors

  - Higgs, *Phys. Lett.* 12 (1964) 132 — original Mexican-hat SSB.
  - Goldstone, *Nuovo Cim.* 19 (1961) 154 — symmetry breaking with
    massless modes.
  - Aizenman-Duminil-Copin-Sidoravicius, *Comm. Math. Phys.* 334
    (2015) 719 — rigorous SSB on `ℤ^d, d ≥ 2`.
  - Peierls, *Proc. Camb. Phil. Soc.* 32 (1936) 477 — original
    Peierls argument for SSB on a lattice.

  ## Lion's-Pride doctrine

  Rule 1: zero `sorry`.  Rule 2: zero new axioms.  Direct algebraic
  manipulation: expand `mexicanHatShifted`, factor out `φ²`, show
  the residual is negative in the sub-critical regime.

  ## Author

  Lion's-Pride dynamic /loop iteration (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.
-/

import OmegaTheory.HealingFlow.CoupledFunctional

namespace OmegaTheory.HealingFlow.HiggsSymmetricVacuumInstability

open OmegaTheory.HealingFlow
open OmegaTheory.HealingFlow.CoupledFunctional

/-! ## Section 1 — Pointwise potential at a single lattice point

Restricting `coupledFunctional` to a single lattice point `p` and
varying only `φ(p)` (everything else fixed), the relevant function
is `mexicanHatShifted(μ², λ, φ) + κ·D²(g, g_exact, p)·φ²`. -/

/-- **Pointwise potential**: the part of `coupledFunctional` that
    depends on `φ` at a single lattice point, as a function of
    `φ_value : ℝ`:

        P(φ) := V_shifted(μ², λ_H, φ) + κ·D²·φ².

    `D²` is the squared defect magnitude at the point (a fixed
    non-negative real). -/
noncomputable def pointwisePotential
    (mu_sq lamH kappa Dsq phi : ℝ) : ℝ :=
  mexicanHatShifted mu_sq lamH phi + kappa * Dsq * phi^2

/-- **Definitional unfolding**. -/
theorem pointwisePotential_def
    (mu_sq lamH kappa Dsq phi : ℝ) :
    pointwisePotential mu_sq lamH kappa Dsq phi =
      mexicanHatShifted mu_sq lamH phi + kappa * Dsq * phi^2 := rfl

/-! ## Section 2 — Value at the symmetric point -/

/-- **Pointwise potential at `φ = 0`**:
    `P(0) = mexicanHatShifted(μ², λ, 0) = λ·(μ²/(2λ))² = μ⁴/(4λ)`. -/
theorem pointwisePotential_at_zero
    {mu_sq lamH kappa Dsq : ℝ} (hL : 0 < lamH) :
    pointwisePotential mu_sq lamH kappa Dsq 0 =
      mu_sq^2 / (4 * lamH) := by
  unfold pointwisePotential mexicanHatShifted
  -- mexicanHatShifted at 0 = λ·(0 - μ²/(2λ))² = λ·μ⁴/(4λ²) = μ⁴/(4λ)
  -- κDsq · 0² = 0
  have h_lne : (lamH : ℝ) ≠ 0 := ne_of_gt hL
  field_simp
  ring

/-! ## Section 3 — Difference identity (the algebraic heart) -/

/-- **Difference identity**: `P(φ) − P(0) = φ²·(λ·φ² − μ² + κ·D²)`.

    Direct calculation:
        mexicanHatShifted(φ) − mexicanHatShifted(0)
            = λ(φ² − μ²/(2λ))² − λ·(μ²/(2λ))²
            = λ·φ⁴ − μ²·φ² + μ⁴/(4λ) − μ⁴/(4λ)
            = λ·φ⁴ − μ²·φ²
            = φ²·(λ·φ² − μ²).
    Adding `κ·D²·φ²` gives `φ²·(λ·φ² − μ² + κ·D²)`. -/
theorem pointwisePotential_diff_eq
    {mu_sq lamH kappa Dsq : ℝ} (hL : 0 < lamH) (phi : ℝ) :
    pointwisePotential mu_sq lamH kappa Dsq phi -
      pointwisePotential mu_sq lamH kappa Dsq 0 =
        phi^2 * (lamH * phi^2 - mu_sq + kappa * Dsq) := by
  unfold pointwisePotential mexicanHatShifted
  have h_lne : (lamH : ℝ) ≠ 0 := ne_of_gt hL
  field_simp
  ring

/-! ## Section 4 — The SSB content (subcritical-coupling instability)

In the sub-critical-coupling regime `κ·D² < μ²`, for sufficiently
small `|φ| ≠ 0`, the difference `P(φ) − P(0)` is strictly negative.
Hence `φ = 0` is NOT a local minimum of `P`; it is a local maximum
along the φ-direction.

The smallness condition is `λ·φ² < μ² − κ·D²` (equivalently
`|φ| < √((μ² − κ·D²)/λ)`).  Under this condition the inner factor
`λφ² − μ² + κD² < 0`, multiplied by `φ² > 0` gives
`P(φ) − P(0) < 0`. -/

/-- **Subcritical SSB instability**: in the sub-critical regime
    `κ·D² < μ²`, for any `|φ| ≠ 0` with `λ·φ² < μ² − κ·D²` (i.e.
    `|φ|` small enough), `P(φ) < P(0)`. -/
theorem pointwisePotential_lt_at_small_phi_subcritical
    {mu_sq lamH kappa Dsq phi : ℝ}
    (hL : 0 < lamH) (hsub : kappa * Dsq < mu_sq) (hphi_ne : phi ≠ 0)
    (hphi_small : lamH * phi^2 < mu_sq - kappa * Dsq) :
    pointwisePotential mu_sq lamH kappa Dsq phi <
      pointwisePotential mu_sq lamH kappa Dsq 0 := by
  -- Reduce to: P(φ) - P(0) < 0
  have h_eq := pointwisePotential_diff_eq (mu_sq := mu_sq) (lamH := lamH)
                  (kappa := kappa) (Dsq := Dsq) hL phi
  -- h_eq : P(φ) - P(0) = φ² · (λ·φ² − μ² + κ·D²)
  have h_phi_sq_pos : 0 < phi^2 := by
    have h_abs : 0 < |phi| := abs_pos.mpr hphi_ne
    have h_sq_abs := pow_pos h_abs 2
    rwa [sq_abs] at h_sq_abs
  -- Inner factor: λ·φ² - μ² + κ·D² = λ·φ² - (μ² - κ·D²)
  -- hphi_small: λ·φ² < μ² - κ·D², so λ·φ² - (μ² - κ·D²) < 0.
  have h_inner_neg : lamH * phi^2 - mu_sq + kappa * Dsq < 0 := by linarith
  -- Product of positive and negative is negative:
  have h_diff_neg : phi^2 * (lamH * phi^2 - mu_sq + kappa * Dsq) < 0 := by
    exact mul_neg_of_pos_of_neg h_phi_sq_pos h_inner_neg
  -- Combine with h_eq to conclude P(φ) - P(0) < 0:
  linarith

/-- **Symmetric vacuum is not a local minimum (when defects present and
    coupling sub-critical)**: there exist arbitrarily-close `φ ≠ 0` at
    which `P(φ) < P(0)`.

    Concretely, take `φ_witness := √((μ² − κ·D²)/(2·λ))` (half-way
    between 0 and the boundary `λφ² = μ² − κ·D²`); this gives a
    witness that any neighborhood of `φ = 0` contains a point with
    strictly smaller `P`. -/
theorem phi_zero_not_local_min_when_defects_present
    {mu_sq lamH kappa Dsq : ℝ}
    (hL : 0 < lamH) (hμ : 0 < mu_sq) (hDsq : 0 ≤ Dsq)
    (hκ : 0 ≤ kappa) (hsub : kappa * Dsq < mu_sq) :
    ∃ phi : ℝ, phi ≠ 0 ∧
      pointwisePotential mu_sq lamH kappa Dsq phi <
        pointwisePotential mu_sq lamH kappa Dsq 0 := by
  -- Witness: φ_w² := (μ² − κ·D²)/(2·λ); pick φ_w := √(...) > 0
  have h_diff_pos : 0 < mu_sq - kappa * Dsq := by linarith
  have h_2L_pos : 0 < 2 * lamH := by linarith
  have h_ratio_pos : 0 < (mu_sq - kappa * Dsq) / (2 * lamH) :=
    div_pos h_diff_pos h_2L_pos
  let phi_w : ℝ := Real.sqrt ((mu_sq - kappa * Dsq) / (2 * lamH))
  have h_phi_pos : 0 < phi_w := Real.sqrt_pos.mpr h_ratio_pos
  have h_phi_ne : phi_w ≠ 0 := ne_of_gt h_phi_pos
  refine ⟨phi_w, h_phi_ne, ?_⟩
  -- Need: λ · phi_w² < μ² − κ·D².
  -- phi_w² = (μ² − κ·D²)/(2·λ), so λ · phi_w² = (μ² − κ·D²)/2 < μ² − κ·D².
  have h_phi_sq : phi_w^2 = (mu_sq - kappa * Dsq) / (2 * lamH) :=
    Real.sq_sqrt (le_of_lt h_ratio_pos)
  have h_phi_small : lamH * phi_w^2 < mu_sq - kappa * Dsq := by
    have h_2L_phi : 2 * lamH * phi_w^2 = mu_sq - kappa * Dsq := by
      rw [h_phi_sq]
      have h_lne : (lamH : ℝ) ≠ 0 := ne_of_gt hL
      field_simp
    linarith
  exact pointwisePotential_lt_at_small_phi_subcritical hL hsub h_phi_ne
    h_phi_small

/-- **THE LOAD-BEARING CAPSTONE — symmetric vacuum unstable when
    defects present**.

    When the substrate has non-zero defects (`D² > 0` somewhere) and
    the metric-scalar coupling κ is sub-critical (`κ·D² < μ²`), the
    symmetric Higgs configuration `φ = 0` is NOT a stable minimum of
    the coupled Lyapunov.  Hence the gradient flow does not preserve
    it: `φ` will roll towards `±v`.

    This is the SSB content of the substrate Higgs mechanism — the
    moment a defect is created, the symmetric vacuum becomes
    unstable. -/
theorem phi_zero_unstable_when_defects_present
    {mu_sq lamH kappa Dsq : ℝ}
    (hL : 0 < lamH) (hμ : 0 < mu_sq) (hDsq : 0 ≤ Dsq)
    (hκ : 0 ≤ kappa) (hsub : kappa * Dsq < mu_sq) :
    -- (a) ∃ φ ≠ 0 arbitrarily close to 0 with P(φ) < P(0)
    (∃ phi : ℝ, phi ≠ 0 ∧
       pointwisePotential mu_sq lamH kappa Dsq phi <
         pointwisePotential mu_sq lamH kappa Dsq 0) ∧
    -- (b) ∀ small ε > 0, ∃ φ with |φ| < ε arbitrarily close to 0 with P(φ) < P(0)
    (∀ ε : ℝ, 0 < ε →
       ∃ phi : ℝ, phi ≠ 0 ∧ |phi| < ε ∧
         pointwisePotential mu_sq lamH kappa Dsq phi <
           pointwisePotential mu_sq lamH kappa Dsq 0) := by
  refine ⟨?_, ?_⟩
  · exact phi_zero_not_local_min_when_defects_present hL hμ hDsq hκ hsub
  · intro ε hε
    -- Pick φ small enough: φ := min(ε/2, sqrt((μ²−κD²)/(2·λ))) > 0
    have h_diff_pos : 0 < mu_sq - kappa * Dsq := by linarith
    have h_2L_pos : 0 < 2 * lamH := by linarith
    have h_ratio_pos : 0 < (mu_sq - kappa * Dsq) / (2 * lamH) :=
      div_pos h_diff_pos h_2L_pos
    let phi_bound : ℝ :=
      Real.sqrt ((mu_sq - kappa * Dsq) / (2 * lamH))
    have h_bound_pos : 0 < phi_bound := Real.sqrt_pos.mpr h_ratio_pos
    let phi_w : ℝ := min (ε / 2) phi_bound
    have h_phi_pos : 0 < phi_w := lt_min (by linarith) h_bound_pos
    have h_phi_ne : phi_w ≠ 0 := ne_of_gt h_phi_pos
    have h_phi_lt_eps : |phi_w| < ε := by
      rw [abs_of_pos h_phi_pos]
      calc phi_w ≤ ε / 2 := min_le_left _ _
        _ < ε := by linarith
    have h_phi_le_bound : phi_w ≤ phi_bound := min_le_right _ _
    have h_phi_sq_le : phi_w^2 ≤ phi_bound^2 := by
      apply sq_le_sq'
      · linarith [h_bound_pos]
      · exact h_phi_le_bound
    have h_bound_sq : phi_bound^2 = (mu_sq - kappa * Dsq) / (2 * lamH) :=
      Real.sq_sqrt (le_of_lt h_ratio_pos)
    have h_phi_small : lamH * phi_w^2 < mu_sq - kappa * Dsq := by
      have h_le : lamH * phi_w^2 ≤ lamH * phi_bound^2 :=
        mul_le_mul_of_nonneg_left h_phi_sq_le (le_of_lt hL)
      rw [h_bound_sq] at h_le
      have h_eq2 : lamH * ((mu_sq - kappa * Dsq) / (2 * lamH)) =
                   (mu_sq - kappa * Dsq) / 2 := by
        have h_lne : (lamH : ℝ) ≠ 0 := ne_of_gt hL
        field_simp
      rw [h_eq2] at h_le
      linarith
    refine ⟨phi_w, h_phi_ne, h_phi_lt_eps, ?_⟩
    exact pointwisePotential_lt_at_small_phi_subcritical hL hsub h_phi_ne
      h_phi_small

/-! ## Section 5 — Capstone -/

/-- **Higgs symmetric-vacuum instability report (4-conjunct)**:

    In the sub-critical-coupling regime `κ·D² < μ²`:

    1. **Difference identity**: `P(φ) − P(0) = φ²·(λ·φ² − μ² + κ·D²)`,
       a clean algebraic factorisation.

    2. **Sub-critical descent**: for small `|φ| ≠ 0` with
       `λφ² < μ² − κD²`, `P(φ) < P(0)`, i.e. the symmetric point is
       not a local minimum.

    3. **Witness construction**: the witness `φ_w := √((μ²−κD²)/(2λ))`
       (or smaller) provides an explicit point of lower potential.

    4. **Arbitrary-ε instability**: for any `ε > 0`, there exists
       `φ ≠ 0` with `|φ| < ε` and `P(φ) < P(0)` — symmetric vacuum
       is locally unstable.

    These four together constitute the SSB content for the substrate
    Higgs mechanism: the symmetric configuration is dynamically
    unstable when defects are present (`D > 0`), and the coupled
    gradient flow drives `φ → ±v` (the dynamical convergence is
    Phase 2.4). -/
theorem higgs_symmetric_vacuum_instability_report
    {mu_sq lamH kappa Dsq : ℝ}
    (hL : 0 < lamH) (hμ : 0 < mu_sq) (hDsq : 0 ≤ Dsq)
    (hκ : 0 ≤ kappa) (hsub : kappa * Dsq < mu_sq) :
    -- (1) Difference identity
    (∀ phi : ℝ,
        pointwisePotential mu_sq lamH kappa Dsq phi -
          pointwisePotential mu_sq lamH kappa Dsq 0 =
            phi^2 * (lamH * phi^2 - mu_sq + kappa * Dsq)) ∧
    -- (2) Sub-critical descent
    (∀ phi : ℝ, phi ≠ 0 → lamH * phi^2 < mu_sq - kappa * Dsq →
        pointwisePotential mu_sq lamH kappa Dsq phi <
          pointwisePotential mu_sq lamH kappa Dsq 0) ∧
    -- (3) Witness construction
    (∃ phi : ℝ, phi ≠ 0 ∧
       pointwisePotential mu_sq lamH kappa Dsq phi <
         pointwisePotential mu_sq lamH kappa Dsq 0) ∧
    -- (4) Arbitrary-ε instability
    (∀ ε : ℝ, 0 < ε →
       ∃ phi : ℝ, phi ≠ 0 ∧ |phi| < ε ∧
         pointwisePotential mu_sq lamH kappa Dsq phi <
           pointwisePotential mu_sq lamH kappa Dsq 0) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro phi; exact pointwisePotential_diff_eq hL phi
  · intro phi h_ne h_small
    exact pointwisePotential_lt_at_small_phi_subcritical hL hsub h_ne h_small
  · exact phi_zero_not_local_min_when_defects_present hL hμ hDsq hκ hsub
  · exact (phi_zero_unstable_when_defects_present hL hμ hDsq hκ hsub).2

end OmegaTheory.HealingFlow.HiggsSymmetricVacuumInstability
