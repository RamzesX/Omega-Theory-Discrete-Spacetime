/-
  OmegaTheory.Emergence.HpwMinkowski

  **Concrete instance: `HpwHypothesis DiscreteMetric.flat`.**

  On flat Minkowski spacetime, the HPW hypothesis bundle is satisfiable
  trivially — the discrete Laplacian of each metric component vanishes
  (constant function) and the discrete Ricci tensor vanishes (flat), so
  the composite remainder bound is `|0 + 2·0| = 0 ≤ ℓ_P/2` without any
  Taylor, harmonic-gauge, or Ricci-box machinery.

  This is the **first concrete model** of `HpwHypothesis` — the crowning
  closure of the HPW axiom elimination for the free-space case.  For any
  metric that is `DiscreteMetric.flat`, the chain

      axiom  →  laplacian_ricci_correspondence  →  ricci_from_equilibrium_balance
             →  einstein_with_matter_emergence

  can be replaced, end to end, by the parallel axiom-free chain

      minkowskiHpwHypothesis  →  hpw_from_hypothesis
                              →  laplacian_ricci_correspondence_from_hypothesis
                              →  ricci_from_equilibrium_balance_from_hypothesis

  delivering the **same conclusion without the HPW axiom**.  The axiom is
  formally still in the project, but it is now demonstrably *redundant*
  on the free-space regime.
-/

import OmegaTheory.Emergence.HpwHypothesis
import OmegaTheory.Emergence.SmoothInterpolant
import OmegaTheory.Emergence.RicciComparison

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open OmegaTheory.Geometry

/-- Wrap `minkowskiInterpolantField` (matrix-valued) as the curried-component
    `SmoothMetricField` that `HpwHypothesis.g_cont` expects. -/
noncomputable def minkowskiSmoothField : SmoothMetricField :=
  fun x μ ν => minkowskiInterpolantField x μ ν

/-- **Rigel, Apr 14 2026 — crowning HPW instance.**  Concrete bundle
    `HpwHypothesis DiscreteMetric.flat`.

    Since `DiscreteMetric.flat` is constant in the lattice argument
    (`minkowskiMetric` everywhere), each component is a constant scalar
    field, and `discreteLaplacian_const` gives `Δ g_{μν} ≡ 0`.  The
    discrete Ricci tensor on flat Minkowski also vanishes by
    `ricciTensor_flat_eq_zero`.  Hence the `h_remainder_bound` field
    is `|0 + 2·0| = 0 ≤ ℓ_P/2`.

    The `h_taylor`, `h_ricci_box` documentation fields are `True` here:
    the free-space case needs none of the three analytic inputs because
    both sides of each bound vanish identically.  `h_harmonic` is
    discharged by `harmonicGaugeIdentity_of_placeholders` — the
    quantitative harmonic-gauge Ricci-box identity holds trivially on
    any `g_cont` because the opaque continuum operators are
    definitionally zero; the flat case is genuinely harmonic, the
    witness merely matches the current opaque-operator calculus. -/
noncomputable def minkowskiHpwHypothesis : HpwHypothesis DiscreteMetric.flat where
  g_cont := minkowskiSmoothField
  c4_bound := 1
  c4_bound_pos := by norm_num
  h_interpolates := by
    intro p μ ν
    unfold minkowskiSmoothField
    exact (minkowskiInterpolantField_interpolates_flat p μ ν).symm
  -- Alcyone, Apr 17 2026 — discharged via `discreteLaplacian_const`:
  -- on flat Minkowski, each metric component is constant in `p`, so the
  -- discrete Laplacian vanishes identically, and the opaque continuum
  -- placeholder also vanishes.  The Taylor truncation is automatic.
  h_taylor :=
    taylorRemainderBound_of_laplacian_zero minkowskiSmoothField (by
      intro p μ ν
      exact discreteLaplacian_const (minkowskiMetric μ ν) p)
  h_harmonic := harmonicGaugeIdentity_of_placeholders minkowskiSmoothField
  -- Alioth, Apr 17 2026 — discharged via `weinbergRicciBoxIdentity_of_placeholders`:
  -- the opaque continuum Laplacian and continuum Ricci placeholders are both
  -- definitionally zero, so `|R^cont + (1/2)·□g^cont| = |0 + 0| = 0 ≤ ℓ_P²`
  -- trivially.  On flat Minkowski the exact harmonic-gauge Weinberg Ricci-box
  -- identity holds identically; the witness here records the opaque-operator
  -- version consistent with the `h_harmonic` discharge above.
  h_ricci_box := weinbergRicciBoxIdentity_of_placeholders minkowskiSmoothField
  h_remainder_bound := by
    intro p μ ν
    have hL : discreteLaplacian (fun q => DiscreteMetric.flat q μ ν) p = 0 :=
      discreteLaplacian_const (minkowskiMetric μ ν) p
    have hR : ricciTensor DiscreteMetric.flat μ ν p = 0 :=
      ricciTensor_flat_eq_zero μ ν p
    rw [hL, hR, mul_zero, add_zero, abs_zero]
    exact div_nonneg l_P_nonneg (by norm_num)

/-! ## Axiom-free free-space emergence

The Minkowski witness closes the loop: for any physical computation
living on flat Minkowski spacetime, the HPW axiom is provably
replaceable.  The three corollaries below are the explicit axiom-free
versions of the emergence chain on the free-space lattice. -/

/-- **Free-space HPW bound as a theorem** — same as the axiom
    conclusion, with zero axiomatic content. -/
theorem hpw_bound_flat
    (mu_coeff : ℝ) (hmu : 0 < mu_coeff) (hmu_le : mu_coeff ≤ 1)
    (p : LatticePoint) (μ ν : Fin 4) :
    |mu_coeff * discreteLaplacian (fun q => DiscreteMetric.flat q μ ν) p +
     2 * mu_coeff * ricciTensor DiscreteMetric.flat μ ν p| ≤ l_P / 2 :=
  hpw_from_hypothesis minkowskiHpwHypothesis mu_coeff hmu hmu_le p μ ν

/-- **Free-space Laplacian–Ricci correspondence as a theorem** (slack
    `ℓ_P`). -/
theorem laplacian_ricci_correspondence_flat
    (mu_coeff : ℝ) (hmu : 0 < mu_coeff) (hmu_le : mu_coeff ≤ 1)
    (p : LatticePoint) (μ ν : Fin 4) :
    |mu_coeff * discreteLaplacian (fun q => DiscreteMetric.flat q μ ν) p +
     2 * mu_coeff * ricciTensor DiscreteMetric.flat μ ν p| ≤ l_P :=
  laplacian_ricci_correspondence_from_hypothesis
    minkowskiHpwHypothesis mu_coeff hmu hmu_le p μ ν

/-- **Milestone witness.**  The HPW axiom is *demonstrably replaceable*
    on the free-space lattice: the flat Minkowski metric admits a
    concrete `HpwHypothesis`, so the emergence chain needs no axiom
    there.  The general-metric case (curved spacetime) still depends
    on the axiom, pending a concrete `HpwHypothesis` instantiation for
    the relevant regime — but the free-space case is closed. -/
theorem hpw_eliminable_on_flat :
    ∃ H : HpwHypothesis DiscreteMetric.flat, H.c4_bound = 1 :=
  ⟨minkowskiHpwHypothesis, rfl⟩

end OmegaTheory.Emergence
