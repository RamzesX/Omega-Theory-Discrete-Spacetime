/-
  OmegaTheory.Geometry.Weyl

  Weyl tensor (conformally invariant part of Riemann) in n=4.

  Physical meaning:
    The Weyl tensor captures "tidal" / conformal curvature — the part
    of the geometry that survives in vacuum. Gravitational waves and
    massless particle propagation live in C_{ρσμν}.

  Coefficient convention (canonical n-dimensional form at n=4;
  identical to Wikipedia, Wald §3.2, Carroll §3.7):
    C_{ρσμν} = R_{ρσμν}
      − (1/(n−2)) · (g_{ρμ} R_{σν} − g_{ρν} R_{σμ} − g_{σμ} R_{ρν} + g_{σν} R_{ρμ})
      + (1/((n−1)(n−2))) · R · (g_{ρμ} g_{σν} − g_{ρν} g_{σμ})

  In n=4: 1/(n−2) = 1/2 and 1/((n−1)(n−2)) = 1/6.

  V1 (and an earlier draft of this file) used (1, 1/3) — double
  the canonical values. That convention is NOT trace-free even in
  the continuum: a direct hand calculation of `Σ_{ρμ} g^{ρμ} C_{ρσμν}`
  returns `−R_{σν}` instead of 0. Fixed on 2026-04-11 after three
  parallel code-crawler audits agreed on the discrepancy.

  With the canonical (1/2, 1/6) coefficients and the Ricci index
  positions in the canonical order `R_{σν}, R_{σμ}, R_{ρν}, R_{ρμ}`,
  the trace-free property `Σ_{ρμ} g^{ρμ} C_{ρσμν} = 0` is EXACT on
  the discrete lattice under metric symmetry + nondegeneracy.
  No epsilon slack is required.
-/

import OmegaTheory.Geometry.Curvature
import Mathlib.Tactic

namespace OmegaTheory.Geometry

open OmegaTheory.Spacetime

/-! ## Definition -/

/-- Lowered Weyl tensor C_{ρσμν} in n=4 with canonical coefficients. -/
noncomputable def weylTensor (g : DiscreteMetric) (ρ σ μ ν : Fin 4)
    (p : LatticePoint) : ℝ :=
  riemannLower g ρ σ μ ν p
  - (1 / 2 : ℝ) * ((g p) ρ μ * ricciTensor g σ ν p
     - (g p) ρ ν * ricciTensor g σ μ p
     - (g p) σ μ * ricciTensor g ρ ν p
     + (g p) σ ν * ricciTensor g ρ μ p)
  + (1 / 6 : ℝ) * scalarCurvature g p
      * ((g p) ρ μ * (g p) σ ν - (g p) ρ ν * (g p) σ μ)

/-! ## Flat vanishing -/

/-- Weyl tensor vanishes on flat metric. -/
theorem weyl_flat (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    weylTensor DiscreteMetric.flat ρ σ μ ν p = 0 := by
  unfold weylTensor
  simp only [riemannLower, riemann_flat, ricci_flat, scalar_flat,
    mul_zero, zero_mul, Finset.sum_const_zero, sub_zero, zero_sub, neg_zero,
    zero_add, add_zero]

/-! ## Exact antisymmetry in last two indices

Under μ↔ν, every term of the Weyl tensor flips sign:
  • the Riemann part flips by `riemannLower_antisym_34`
  • the metric-Ricci bracket flips by permutation of its four terms
  • the scalar-curvature bracket flips by permutation of its two terms

Hence `C_{ρσμν} + C_{ρσνμ} = 0` exactly. -/

theorem weyl_antisym_34 (g : DiscreteMetric)
    (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    weylTensor g ρ σ μ ν p + weylTensor g ρ σ ν μ p = 0 := by
  unfold weylTensor
  have hR := riemannLower_antisym_34 g ρ σ μ ν p
  linarith

/-- Equivalent form: `C_{ρσμν} = −C_{ρσνμ}`. -/
theorem weyl_antisym_34' (g : DiscreteMetric)
    (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    weylTensor g ρ σ μ ν p = -weylTensor g ρ σ ν μ p := by
  linarith [weyl_antisym_34 g ρ σ μ ν p]

/-! ## Auxiliary identity used for the bounded 12-antisymmetry

Under ρ↔σ swap with a *symmetric* metric, the non-Riemann parts of the
Weyl tensor cancel pointwise, so
  `C_{ρσμν} + C_{σρμν} = R_{ρσμν} + R_{σρμν}`.
This reduces Weyl's 12-antisymmetry to Riemann's — which is bounded in V2. -/

theorem weyl_antisym_12_reduces_to_riemann
    (g : DiscreteMetric)
    (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    weylTensor g ρ σ μ ν p + weylTensor g σ ρ μ ν p =
    riemannLower g ρ σ μ ν p + riemannLower g σ ρ μ ν p := by
  -- With the canonical (1/2, 1/6) coefficients AND canonical Ricci index order,
  -- the Ricci-bracket and scalar-bracket each cancel pointwise under ρ↔σ by pure
  -- ℝ commutativity — no metric symmetry needed.
  unfold weylTensor
  ring

/-! ## Contraction table for trace-free proof

The Weyl trace-free property requires four distinct metric / inverse-metric
contractions. We prove each as a private helper, then assemble. All are
EXACT identities under metric symmetry + nondegeneracy. -/

/-- Pointwise metric symmetry extracted from the `IsEverywhereSymmetric` field. -/
private lemma metric_pointwise_symm (g : DiscreteMetric)
    (hsym : g.IsEverywhereSymmetric) (p : LatticePoint) (i j : Fin 4) :
    (g p) i j = (g p) j i := by
  have h := congrFun (congrFun (hsym p) j) i
  simpa [Matrix.transpose_apply] using h

/-- `Σ_μ g^{ρμ} g_{μσ} = δ^ρ_σ` — direct from `inverse_mul_metric`. -/
private lemma inverse_contract_right (g : DiscreteMetric)
    (hnd : ∀ p, IsNondegenerate (g p)) (p : LatticePoint) (ρ σ : Fin 4) :
    (Finset.univ.sum fun μ => (inverseMetric (g p)) ρ μ * (g p) μ σ) =
    (if ρ = σ then (1 : ℝ) else 0) := by
  have h := congrFun (congrFun (inverse_mul_metric (g p) (hnd p)) ρ) σ
  simpa [Matrix.mul_apply, Matrix.one_apply] using h

/-- `Σ_ρ g^{ρμ} g_{ρν} = δ^μ_ν` — needs metric symmetry to swap
    the first index of `g^{ρμ}` and the second of `g_{ρν}`. -/
private lemma inverse_contract_left (g : DiscreteMetric)
    (hsym : g.IsEverywhereSymmetric) (hnd : ∀ p, IsNondegenerate (g p))
    (p : LatticePoint) (μ ν : Fin 4) :
    (Finset.univ.sum fun ρ => (inverseMetric (g p)) ρ μ * (g p) ρ ν) =
    (if μ = ν then (1 : ℝ) else 0) := by
  have h_eq :
      (Finset.univ.sum fun ρ => (inverseMetric (g p)) ρ μ * (g p) ρ ν) =
      (Finset.univ.sum fun ρ => (inverseMetric (g p)) μ ρ * (g p) ρ ν) := by
    apply Finset.sum_congr rfl
    intro ρ _
    rw [inverseMetric_symm (g p) (hsym p) ρ μ]
  rw [h_eq]
  exact inverse_contract_right g hnd p μ ν

/-- `Σ_μ g^{ρμ} g_{σμ} = δ^ρ_σ` — needs metric symmetry to swap the
    second index of the lower metric factor. -/
private lemma inverse_contract_right_lower_swap (g : DiscreteMetric)
    (hsym : g.IsEverywhereSymmetric) (hnd : ∀ p, IsNondegenerate (g p))
    (p : LatticePoint) (ρ σ : Fin 4) :
    (Finset.univ.sum fun μ => (inverseMetric (g p)) ρ μ * (g p) σ μ) =
    (if ρ = σ then (1 : ℝ) else 0) := by
  have h_eq :
      (Finset.univ.sum fun μ => (inverseMetric (g p)) ρ μ * (g p) σ μ) =
      (Finset.univ.sum fun μ => (inverseMetric (g p)) ρ μ * (g p) μ σ) := by
    apply Finset.sum_congr rfl
    intro μ _
    rw [metric_pointwise_symm g hsym p σ μ]
  rw [h_eq]
  exact inverse_contract_right g hnd p ρ σ

/-! ## Exact trace-free property (under metric symmetry + nondegeneracy)

  `Σ_{ρμ} g^{ρμ} · C_{ρσμν} = 0`

Proof strategy. Expand `weylTensor` into three pieces:
  • Riemann: `Σ_{ρμ} g^{ρμ} R_{ρσμν} = R_{σν}`  (via `ricciTensor_eq_ricciTensor'`)
  • Ricci bracket (four terms): `2·R_{σν} + R·g_{σν}`
  • Scalar bracket: `(1/6)·R·3·g_{σν} = (R/2)·g_{σν}`

Combine: `R_{σν} − (1/2)·(2·R_{σν} + R·g_{σν}) + (R/2)·g_{σν} = 0`. -/

/-- Inner shorthand used only in the tracefree proof. -/
private lemma metric_frobenius_four
    (g : DiscreteMetric) (hsym : g.IsEverywhereSymmetric)
    (hnd : ∀ p, IsNondegenerate (g p)) (p : LatticePoint) :
    (Finset.univ.sum fun ρ => Finset.univ.sum fun μ =>
      (inverseMetric (g p)) ρ μ * (g p) ρ μ) = 4 := by
  have h_step1 :
      (Finset.univ.sum fun ρ => Finset.univ.sum fun μ =>
        (inverseMetric (g p)) ρ μ * (g p) ρ μ) =
      (Finset.univ.sum fun ρ => Finset.univ.sum fun μ =>
        (inverseMetric (g p)) ρ μ * (g p) μ ρ) := by
    apply Finset.sum_congr rfl; intro ρ _
    apply Finset.sum_congr rfl; intro μ _
    rw [metric_pointwise_symm g hsym p ρ μ]
  rw [h_step1]
  have h_step2 :
      (Finset.univ.sum fun ρ => Finset.univ.sum fun μ =>
        (inverseMetric (g p)) ρ μ * (g p) μ ρ) =
      (Finset.univ.sum fun _ : Fin 4 => (1 : ℝ)) := by
    apply Finset.sum_congr rfl; intro ρ _
    have h := inverse_contract_right g hnd p ρ ρ
    rw [h]
    simp
  rw [h_step2]
  simp

/-- Exact trace-free property of the Weyl tensor under metric symmetry + nondegeneracy. -/
theorem weyl_tracefree (g : DiscreteMetric)
    (hsym : g.IsEverywhereSymmetric) (hnd : ∀ p, IsNondegenerate (g p))
    (σ ν : Fin 4) (p : LatticePoint) :
    (Finset.univ.sum fun ρ => Finset.univ.sum fun μ =>
      (inverseMetric (g p)) ρ μ * weylTensor g ρ σ μ ν p) = 0 := by
  -- Riemann contraction equals the Ricci tensor (positions {1,3}).
  have h_riemann :
      (Finset.univ.sum fun ρ => Finset.univ.sum fun μ =>
        (inverseMetric (g p)) ρ μ * riemannLower g ρ σ μ ν p) =
      ricciTensor g σ ν p := by
    rw [ricciTensor_eq_ricciTensor' g hsym hnd σ ν p]
    rfl
  -- Sub-sum 1: Σ g^{ρμ} g_{ρμ} R_{σν} = 4 · R_{σν}.
  have h_brk1 :
      (Finset.univ.sum fun ρ => Finset.univ.sum fun μ =>
        (inverseMetric (g p)) ρ μ * ((g p) ρ μ * ricciTensor g σ ν p)) =
      4 * ricciTensor g σ ν p := by
    have h_reshape :
        (Finset.univ.sum fun ρ => Finset.univ.sum fun μ =>
          (inverseMetric (g p)) ρ μ * ((g p) ρ μ * ricciTensor g σ ν p)) =
        (Finset.univ.sum fun ρ => Finset.univ.sum fun μ =>
          ((inverseMetric (g p)) ρ μ * (g p) ρ μ) * ricciTensor g σ ν p) := by
      apply Finset.sum_congr rfl; intro ρ _
      apply Finset.sum_congr rfl; intro μ _
      ring
    rw [h_reshape]
    have h_pull :
        (Finset.univ.sum fun ρ => Finset.univ.sum fun μ =>
          ((inverseMetric (g p)) ρ μ * (g p) ρ μ) * ricciTensor g σ ν p) =
        (Finset.univ.sum fun ρ => Finset.univ.sum fun μ =>
          (inverseMetric (g p)) ρ μ * (g p) ρ μ) * ricciTensor g σ ν p := by
      rw [Finset.sum_mul]
      apply Finset.sum_congr rfl; intro ρ _
      rw [Finset.sum_mul]
    rw [h_pull, metric_frobenius_four g hsym hnd p]
  -- Sub-sum 2: Σ g^{ρμ} g_{ρν} R_{σμ} = R_{σν}.
  have h_brk2 :
      (Finset.univ.sum fun ρ => Finset.univ.sum fun μ =>
        (inverseMetric (g p)) ρ μ * ((g p) ρ ν * ricciTensor g σ μ p)) =
      ricciTensor g σ ν p := by
    have h_reshape :
        (Finset.univ.sum fun ρ => Finset.univ.sum fun μ =>
          (inverseMetric (g p)) ρ μ * ((g p) ρ ν * ricciTensor g σ μ p)) =
        (Finset.univ.sum fun μ => ricciTensor g σ μ p *
          (Finset.univ.sum fun ρ => (inverseMetric (g p)) ρ μ * (g p) ρ ν)) := by
      rw [Finset.sum_comm]
      apply Finset.sum_congr rfl; intro μ _
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl; intro ρ _
      ring
    rw [h_reshape]
    have h_inner : ∀ μ : Fin 4,
        (Finset.univ.sum fun ρ => (inverseMetric (g p)) ρ μ * (g p) ρ ν) =
        (if μ = ν then (1:ℝ) else 0) :=
      fun μ => inverse_contract_left g hsym hnd p μ ν
    conv_lhs =>
      rhs
      ext μ
      rw [h_inner μ]
    simp
  -- Sub-sum 3: Σ g^{ρμ} g_{σμ} R_{ρν} = R_{σν}.
  have h_brk3 :
      (Finset.univ.sum fun ρ => Finset.univ.sum fun μ =>
        (inverseMetric (g p)) ρ μ * ((g p) σ μ * ricciTensor g ρ ν p)) =
      ricciTensor g σ ν p := by
    have h_reshape :
        (Finset.univ.sum fun ρ => Finset.univ.sum fun μ =>
          (inverseMetric (g p)) ρ μ * ((g p) σ μ * ricciTensor g ρ ν p)) =
        (Finset.univ.sum fun ρ => ricciTensor g ρ ν p *
          (Finset.univ.sum fun μ => (inverseMetric (g p)) ρ μ * (g p) σ μ)) := by
      apply Finset.sum_congr rfl; intro ρ _
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl; intro μ _
      ring
    rw [h_reshape]
    have h_inner : ∀ ρ : Fin 4,
        (Finset.univ.sum fun μ => (inverseMetric (g p)) ρ μ * (g p) σ μ) =
        (if ρ = σ then (1:ℝ) else 0) :=
      fun ρ => inverse_contract_right_lower_swap g hsym hnd p ρ σ
    conv_lhs =>
      rhs
      ext ρ
      rw [h_inner ρ]
    simp
  -- Sub-sum 4: Σ g^{ρμ} g_{σν} R_{ρμ} = g_{σν} · S.
  have h_brk4 :
      (Finset.univ.sum fun ρ => Finset.univ.sum fun μ =>
        (inverseMetric (g p)) ρ μ * ((g p) σ ν * ricciTensor g ρ μ p)) =
      (g p) σ ν * scalarCurvature g p := by
    have h_reshape :
        (Finset.univ.sum fun ρ => Finset.univ.sum fun μ =>
          (inverseMetric (g p)) ρ μ * ((g p) σ ν * ricciTensor g ρ μ p)) =
        (g p) σ ν * (Finset.univ.sum fun ρ => Finset.univ.sum fun μ =>
          (inverseMetric (g p)) ρ μ * ricciTensor g ρ μ p) := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl; intro ρ _
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl; intro μ _
      ring
    rw [h_reshape]
    -- The inner double sum is definitionally scalarCurvature g p.
    rfl
  -- Scalar-bracket sub-sum (i): Σ g^{ρμ} g_{ρμ} g_{σν} = 4 · g_{σν}.
  have h_scal1 :
      (Finset.univ.sum fun ρ => Finset.univ.sum fun μ =>
        (inverseMetric (g p)) ρ μ * ((g p) ρ μ * (g p) σ ν)) =
      4 * (g p) σ ν := by
    have h_reshape :
        (Finset.univ.sum fun ρ => Finset.univ.sum fun μ =>
          (inverseMetric (g p)) ρ μ * ((g p) ρ μ * (g p) σ ν)) =
        (Finset.univ.sum fun ρ => Finset.univ.sum fun μ =>
          ((inverseMetric (g p)) ρ μ * (g p) ρ μ) * (g p) σ ν) := by
      apply Finset.sum_congr rfl; intro ρ _
      apply Finset.sum_congr rfl; intro μ _
      ring
    rw [h_reshape]
    have h_pull :
        (Finset.univ.sum fun ρ => Finset.univ.sum fun μ =>
          ((inverseMetric (g p)) ρ μ * (g p) ρ μ) * (g p) σ ν) =
        (Finset.univ.sum fun ρ => Finset.univ.sum fun μ =>
          (inverseMetric (g p)) ρ μ * (g p) ρ μ) * (g p) σ ν := by
      rw [Finset.sum_mul]
      apply Finset.sum_congr rfl; intro ρ _
      rw [Finset.sum_mul]
    rw [h_pull, metric_frobenius_four g hsym hnd p]
  -- Scalar-bracket sub-sum (ii): Σ g^{ρμ} g_{ρν} g_{σμ} = g_{σν}.
  have h_scal2 :
      (Finset.univ.sum fun ρ => Finset.univ.sum fun μ =>
        (inverseMetric (g p)) ρ μ * ((g p) ρ ν * (g p) σ μ)) =
      (g p) σ ν := by
    have h_reshape :
        (Finset.univ.sum fun ρ => Finset.univ.sum fun μ =>
          (inverseMetric (g p)) ρ μ * ((g p) ρ ν * (g p) σ μ)) =
        (Finset.univ.sum fun μ => (g p) σ μ *
          (Finset.univ.sum fun ρ => (inverseMetric (g p)) ρ μ * (g p) ρ ν)) := by
      rw [Finset.sum_comm]
      apply Finset.sum_congr rfl; intro μ _
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl; intro ρ _
      ring
    rw [h_reshape]
    have h_inner : ∀ μ : Fin 4,
        (Finset.univ.sum fun ρ => (inverseMetric (g p)) ρ μ * (g p) ρ ν) =
        (if μ = ν then (1:ℝ) else 0) :=
      fun μ => inverse_contract_left g hsym hnd p μ ν
    conv_lhs =>
      rhs
      ext μ
      rw [h_inner μ]
    simp
  -- Pointwise decomposition of the Weyl expression.
  have h_pt : ∀ (ρ μ : Fin 4),
      (inverseMetric (g p)) ρ μ * weylTensor g ρ σ μ ν p =
        (inverseMetric (g p)) ρ μ * riemannLower g ρ σ μ ν p
        - (1/2 : ℝ) * ((inverseMetric (g p)) ρ μ * ((g p) ρ μ * ricciTensor g σ ν p))
        + (1/2 : ℝ) * ((inverseMetric (g p)) ρ μ * ((g p) ρ ν * ricciTensor g σ μ p))
        + (1/2 : ℝ) * ((inverseMetric (g p)) ρ μ * ((g p) σ μ * ricciTensor g ρ ν p))
        - (1/2 : ℝ) * ((inverseMetric (g p)) ρ μ * ((g p) σ ν * ricciTensor g ρ μ p))
        + (1/6 : ℝ) * scalarCurvature g p *
            ((inverseMetric (g p)) ρ μ * ((g p) ρ μ * (g p) σ ν))
        - (1/6 : ℝ) * scalarCurvature g p *
            ((inverseMetric (g p)) ρ μ * ((g p) ρ ν * (g p) σ μ)) := by
    intros ρ μ
    unfold weylTensor
    ring
  -- Apply pointwise under the double sum.
  have h_outer :
      (Finset.univ.sum fun ρ => Finset.univ.sum fun μ =>
        (inverseMetric (g p)) ρ μ * weylTensor g ρ σ μ ν p) =
      (Finset.univ.sum fun ρ => Finset.univ.sum fun μ =>
        ((inverseMetric (g p)) ρ μ * riemannLower g ρ σ μ ν p
         - (1/2 : ℝ) * ((inverseMetric (g p)) ρ μ *
            ((g p) ρ μ * ricciTensor g σ ν p))
         + (1/2 : ℝ) * ((inverseMetric (g p)) ρ μ *
            ((g p) ρ ν * ricciTensor g σ μ p))
         + (1/2 : ℝ) * ((inverseMetric (g p)) ρ μ *
            ((g p) σ μ * ricciTensor g ρ ν p))
         - (1/2 : ℝ) * ((inverseMetric (g p)) ρ μ *
            ((g p) σ ν * ricciTensor g ρ μ p))
         + (1/6 : ℝ) * scalarCurvature g p *
            ((inverseMetric (g p)) ρ μ * ((g p) ρ μ * (g p) σ ν))
         - (1/6 : ℝ) * scalarCurvature g p *
            ((inverseMetric (g p)) ρ μ * ((g p) ρ ν * (g p) σ μ)))) := by
    apply Finset.sum_congr rfl; intro ρ _
    apply Finset.sum_congr rfl; intro μ _
    exact h_pt ρ μ
  rw [h_outer]
  simp only [Finset.sum_add_distrib, Finset.sum_sub_distrib, ← Finset.mul_sum]
  rw [h_riemann, h_brk1, h_brk2, h_brk3, h_brk4, h_scal1, h_scal2]
  ring

end OmegaTheory.Geometry
