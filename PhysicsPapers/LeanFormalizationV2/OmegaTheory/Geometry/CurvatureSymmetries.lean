/-
  OmegaTheory.Geometry.CurvatureSymmetries

  Curvature symmetries: both bounded and exact.

  Classical GR has EXACT symmetries: pair swap, Ricci symmetry, Bianchi.
  On the discrete lattice with defects, these hold APPROXIMATELY
  with deviations bounded by ε (the defect magnitude).

  Classification:
  - EXACT: antisym34, first Bianchi (in Curvature.lean)
  - BOUNDED: pair swap, Ricci symmetry, contracted Bianchi (this file)
  - EXACT (general): antisym12, Ricci symmetry given exact pair swap (this file)
  - DERIVED: pair_swap_bounded from Valued pipeline (this file)
-/

import OmegaTheory.Geometry.Curvature
import OmegaTheory.Defects.DefectTensor
import OmegaTheory.Tensor.ValuedCurvature
import Mathlib.Tactic

namespace OmegaTheory.Geometry

open OmegaTheory.Spacetime
open OmegaTheory.Defects

/-! ## Bounded Symmetry Metric

A metric where symmetry deviations are bounded by constants times ε. -/

/-- A semi-smooth metric with bounded symmetry deviations.
    Pair swap and second Bianchi hold up to C·ε.
    This captures: "symmetries are approximate on the discrete lattice,
    but the deviations are controlled by the defect magnitude." -/
structure BoundedSymmetryMetric extends SemiSmoothMetric where
  /-- The metric is symmetric at every point. -/
  symmetric : g.IsEverywhereSymmetric
  /-- The metric is nondegenerate at every point. -/
  nondegenerate : ∀ p, IsNondegenerate (g p)
  /-- Pair swap deviation constant. -/
  C_pair_swap : ℝ
  C_pair_swap_pos : 0 < C_pair_swap
  /-- |R_{ρσμν} - R_{μνρσ}| ≤ C_ps · ε. -/
  pair_swap_bounded : ∀ ρ σ μ ν p,
    |riemannLower g ρ σ μ ν p - riemannLower g μ ν ρ σ p| ≤
    C_pair_swap * epsilon
  /-- Uniform bound on inverse metric components.
      Required for error-bounded Ricci symmetry: when we contract
      pair-swap error with g^{ρσ} over the 16 index pairs, the total
      error grows linearly in this bound. -/
  M_inv : ℝ
  M_inv_nonneg : 0 ≤ M_inv
  /-- |g^{ρσ}(p)| ≤ M_inv for all points and indices. -/
  inv_metric_bounded : ∀ p ρ σ, |(inverseMetric (g p)) ρ σ| ≤ M_inv
  /-- Uniform bound on (lowered) metric components.
      Required for bounded Weyl pair-swap: the Ricci-bracket piece of
      C_{ρσμν} - C_{μνρσ} has four cross-terms of shape g_{ij}·(R_{ab} - R_{ba}),
      and bounding them needs both `ricci_symmetric_bounded` (Ricci antisymmetry)
      and a uniform bound on the lower metric components. -/
  M_g : ℝ
  M_g_nonneg : 0 ≤ M_g
  /-- |g_{ρσ}(p)| ≤ M_g for all points and indices. -/
  metric_bounded : ∀ p ρ σ, |(g p) ρ σ| ≤ M_g

namespace BoundedSymmetryMetric

/-! ## Derived Bounded Symmetries -/

/-- Antisymmetry in first two indices is BOUNDED.
    |R_{ρσμν} + R_{σρμν}| ≤ 2·C_ps·ε.

    Proof chain:
    R_{ρσμν} ≈ R_{μνρσ} (pair swap, ≤ C·ε)
    R_{σρμν} ≈ R_{μνσρ} (pair swap, ≤ C·ε)
    R_{μνρσ} + R_{μνσρ} = 0 (exact antisym34)
    Total: ≤ 2C·ε -/
theorem antisym_12_bounded (bsm : BoundedSymmetryMetric)
    (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    |riemannLower bsm.g ρ σ μ ν p + riemannLower bsm.g σ ρ μ ν p| ≤
    2 * bsm.C_pair_swap * bsm.epsilon := by
  have h1 := bsm.pair_swap_bounded ρ σ μ ν p
  have h2 := bsm.pair_swap_bounded σ ρ μ ν p
  have h3 : riemannLower bsm.g μ ν ρ σ p + riemannLower bsm.g μ ν σ ρ p = 0 :=
    by linarith [riemannLower_antisym_34 bsm.g μ ν ρ σ p]
  -- R_{ρσμν} + R_{σρμν}
  --   = (R_{ρσμν} - R_{μνρσ}) + (R_{σρμν} - R_{μνσρ}) + (R_{μνρσ} + R_{μνσρ})
  --   = err1 + err2 + 0
  have key : riemannLower bsm.g ρ σ μ ν p + riemannLower bsm.g σ ρ μ ν p =
    (riemannLower bsm.g ρ σ μ ν p - riemannLower bsm.g μ ν ρ σ p) +
    (riemannLower bsm.g σ ρ μ ν p - riemannLower bsm.g μ ν σ ρ p) +
    (riemannLower bsm.g μ ν ρ σ p + riemannLower bsm.g μ ν σ ρ p) := by ring
  rw [key, h3, add_zero]
  calc |_ + _|
      ≤ |riemannLower bsm.g ρ σ μ ν p - riemannLower bsm.g μ ν ρ σ p| +
        |riemannLower bsm.g σ ρ μ ν p - riemannLower bsm.g μ ν σ ρ p| :=
        abs_add_le _ _
    _ ≤ bsm.C_pair_swap * bsm.epsilon + bsm.C_pair_swap * bsm.epsilon :=
        add_le_add h1 h2
    _ = 2 * bsm.C_pair_swap * bsm.epsilon := by ring

/-- At zero defect, pair swap becomes exact. -/
theorem pair_swap_exact_at_zero (bsm : BoundedSymmetryMetric)
    (hε : bsm.epsilon = 0) (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    riemannLower bsm.g ρ σ μ ν p = riemannLower bsm.g μ ν ρ σ p := by
  have h := bsm.pair_swap_bounded ρ σ μ ν p
  rw [hε, mul_zero] at h
  have h2 := abs_nonneg (riemannLower bsm.g ρ σ μ ν p - riemannLower bsm.g μ ν ρ σ p)
  have h3 : |riemannLower bsm.g ρ σ μ ν p - riemannLower bsm.g μ ν ρ σ p| = 0 := by linarith
  linarith [abs_eq_zero.mp h3]

/-- At zero defect, antisym12 becomes exact. -/
theorem antisym_12_exact_at_zero (bsm : BoundedSymmetryMetric)
    (hε : bsm.epsilon = 0) (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    riemannLower bsm.g ρ σ μ ν p = -riemannLower bsm.g σ ρ μ ν p := by
  have hps := pair_swap_exact_at_zero bsm hε
  calc riemannLower bsm.g ρ σ μ ν p
      = riemannLower bsm.g μ ν ρ σ p := hps ρ σ μ ν p
    _ = -riemannLower bsm.g μ ν σ ρ p := riemannLower_antisym_34 bsm.g μ ν ρ σ p
    _ = -riemannLower bsm.g σ ρ μ ν p := by rw [hps σ ρ μ ν p]

/-- The defect in pair swap is controlled by the defect magnitude.
    This is the physical content: larger defects → larger symmetry violations. -/
theorem pair_swap_controlled_by_defect (bsm : BoundedSymmetryMetric)
    (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    |riemannLower bsm.g ρ σ μ ν p - riemannLower bsm.g μ ν ρ σ p| ≤
    bsm.C_pair_swap * bsm.epsilon :=
  bsm.pair_swap_bounded ρ σ μ ν p

/-! ## Bounded Ricci Symmetry

Ricci symmetry holds up to an error proportional to ε:
  |R_{μν} - R_{νμ}| ≤ 16 · M_inv · C_pair_swap · ε.

## Strategy

From the metric-contracted form:
  `R'_{μν} = Σ_{ρσ} g^{ρσ} R_{ρμσν}`
  `R'_{νμ} = Σ_{ρσ} g^{ρσ} R_{ρνσμ}`

Rewrite R'_{νμ} by relabeling dummy indices ρ ↔ σ and using g^{σρ} = g^{ρσ}:
  `R'_{νμ} = Σ_{ρσ} g^{ρσ} R_{σνρμ}`

Therefore:
  `R'_{μν} - R'_{νμ} = Σ_{ρσ} g^{ρσ} (R_{ρμσν} - R_{σνρμ})`

Each bracketed term is `R_{abcd} - R_{cdab}` with (a,b,c,d) = (ρ,μ,σ,ν), which
is exactly the shape of `pair_swap_bounded`: ≤ C_ps · ε. With 16 pairs and the
uniform bound |g^{ρσ}| ≤ M_inv, the total bound is 16 · M_inv · C_ps · ε. -/

/-- Rewriting: ricciTensor' with μ,ν swapped equals the double sum
    Σ_{ρσ} g^{ρσ} R_{σνρμ} (via dummy-index relabel and g symmetry). -/
private lemma ricciTensor'_swap_form (bsm : BoundedSymmetryMetric)
    (μ ν : Fin 4) (p : LatticePoint) :
    ricciTensor' bsm.g ν μ p =
    Finset.univ.sum (fun ρ =>
      Finset.univ.sum fun σ =>
        (inverseMetric (bsm.g p)) ρ σ * riemannLower bsm.g σ ν ρ μ p) := by
  unfold ricciTensor'
  -- Start: Σ_ρ Σ_σ g^{ρσ} R_{ρνσμ}
  -- Goal:  Σ_ρ Σ_σ g^{ρσ} R_{σνρμ}
  -- Swap summation order (ρ ↔ σ name):
  rw [Finset.sum_comm]
  -- Now: Σ_σ Σ_ρ g^{ρσ} R_{ρνσμ}
  -- Rename summation variables (ρ becomes σ', σ becomes ρ'):
  apply Finset.sum_congr rfl; intro σ' _
  apply Finset.sum_congr rfl; intro ρ' _
  -- Goal: g^{σ'ρ'} * R_{σ'νρ'μ} = g^{ρ'σ'} * R_{σ'νρ'μ}
  -- Apply inverse-metric symmetry: g^{σ'ρ'} = g^{ρ'σ'}
  rw [inverseMetric_symm (bsm.g p) (bsm.symmetric p) σ' ρ']

/-- Per-term bound on the pair-swap contribution:
    |g^{ρσ} · (R_{ρμσν} - R_{σνρμ})| ≤ M_inv · C_ps · ε. -/
private lemma ricci_pair_swap_term_bound (bsm : BoundedSymmetryMetric)
    (μ ν : Fin 4) (p : LatticePoint) (ρ σ : Fin 4) :
    |(inverseMetric (bsm.g p)) ρ σ *
      (riemannLower bsm.g ρ μ σ ν p - riemannLower bsm.g σ ν ρ μ p)| ≤
    bsm.M_inv * (bsm.C_pair_swap * bsm.epsilon) := by
  rw [abs_mul]
  have hg := bsm.inv_metric_bounded p ρ σ
  have hr := bsm.pair_swap_bounded ρ μ σ ν p
  exact mul_le_mul hg hr (abs_nonneg _) bsm.M_inv_nonneg

/-- Ricci' symmetry deviation: term-by-term bound using `pair_swap_bounded`.
    |R'_{μν} - R'_{νμ}| ≤ 16 · M_inv · C_pair_swap · ε. -/
lemma ricciTensor'_symmetric_bounded (bsm : BoundedSymmetryMetric)
    (μ ν : Fin 4) (p : LatticePoint) :
    |ricciTensor' bsm.g μ ν p - ricciTensor' bsm.g ν μ p| ≤
    16 * bsm.M_inv * bsm.C_pair_swap * bsm.epsilon := by
  -- Step 1: rewrite R'_{νμ} into the swapped form via dummy-relabel + g-symmetry.
  rw [ricciTensor'_swap_form bsm μ ν p]
  -- Step 2: unfold ricciTensor' on the LHS (the one not yet swapped).
  show |ricciTensor' bsm.g μ ν p -
    Finset.univ.sum (fun ρ => Finset.univ.sum fun σ =>
      (inverseMetric (bsm.g p)) ρ σ * riemannLower bsm.g σ ν ρ μ p)| ≤
    16 * bsm.M_inv * bsm.C_pair_swap * bsm.epsilon
  unfold ricciTensor'
  -- Step 3: combine the two double sums into a single double sum of differences.
  rw [← Finset.sum_sub_distrib]
  have hfactor : ∀ ρ,
      (Finset.univ.sum fun σ =>
          (inverseMetric (bsm.g p)) ρ σ * riemannLower bsm.g ρ μ σ ν p) -
      (Finset.univ.sum fun σ =>
          (inverseMetric (bsm.g p)) ρ σ * riemannLower bsm.g σ ν ρ μ p) =
      Finset.univ.sum (fun σ =>
        (inverseMetric (bsm.g p)) ρ σ *
          (riemannLower bsm.g ρ μ σ ν p - riemannLower bsm.g σ ν ρ μ p)) := by
    intro ρ
    rw [← Finset.sum_sub_distrib]
    apply Finset.sum_congr rfl; intro σ _; ring
  simp_rw [hfactor]
  -- Step 4: apply triangle inequality twice (outer sum, then inner sum)
  -- and bound each term by M_inv · C_ps · ε.
  have hcε_nn : 0 ≤ bsm.M_inv * (bsm.C_pair_swap * bsm.epsilon) :=
    mul_nonneg bsm.M_inv_nonneg
      (mul_nonneg (le_of_lt bsm.C_pair_swap_pos) bsm.epsilon_nonneg)
  have hsum_le :
      |Finset.univ.sum (fun ρ : Fin 4 => Finset.univ.sum fun σ : Fin 4 =>
          (inverseMetric (bsm.g p)) ρ σ *
          (riemannLower bsm.g ρ μ σ ν p - riemannLower bsm.g σ ν ρ μ p))|
      ≤ 16 * bsm.M_inv * bsm.C_pair_swap * bsm.epsilon := by
    calc |Finset.univ.sum (fun ρ : Fin 4 => Finset.univ.sum fun σ : Fin 4 =>
            (inverseMetric (bsm.g p)) ρ σ *
            (riemannLower bsm.g ρ μ σ ν p - riemannLower bsm.g σ ν ρ μ p))|
        ≤ Finset.univ.sum (fun ρ : Fin 4 => |Finset.univ.sum fun σ : Fin 4 =>
            (inverseMetric (bsm.g p)) ρ σ *
            (riemannLower bsm.g ρ μ σ ν p - riemannLower bsm.g σ ν ρ μ p)|) :=
            Finset.abs_sum_le_sum_abs _ _
      _ ≤ Finset.univ.sum (fun ρ : Fin 4 => Finset.univ.sum fun σ : Fin 4 =>
            |(inverseMetric (bsm.g p)) ρ σ *
             (riemannLower bsm.g ρ μ σ ν p - riemannLower bsm.g σ ν ρ μ p)|) := by
            apply Finset.sum_le_sum; intro ρ _
            exact Finset.abs_sum_le_sum_abs _ _
      _ ≤ Finset.univ.sum (fun _ρ : Fin 4 => Finset.univ.sum fun _σ : Fin 4 =>
            bsm.M_inv * (bsm.C_pair_swap * bsm.epsilon)) := by
            apply Finset.sum_le_sum; intro ρ _
            apply Finset.sum_le_sum; intro σ _
            exact ricci_pair_swap_term_bound bsm μ ν p ρ σ
      _ = 16 * bsm.M_inv * bsm.C_pair_swap * bsm.epsilon := by
            simp only [Finset.sum_const, Finset.card_univ, Fintype.card_fin,
              nsmul_eq_mul, Nat.cast_ofNat]
            ring
  exact hsum_le

/-- Ricci symmetry holds up to an error bound proportional to ε.
    |R_{μν} - R_{νμ}| ≤ 16 · M_inv · C_pair_swap · ε.
    This is the main bounded-symmetry result for BoundedSymmetryMetric. -/
theorem ricci_symmetric_bounded (bsm : BoundedSymmetryMetric)
    (μ ν : Fin 4) (p : LatticePoint) :
    |ricciTensor bsm.g μ ν p - ricciTensor bsm.g ν μ p| ≤
    16 * bsm.M_inv * bsm.C_pair_swap * bsm.epsilon := by
  rw [ricciTensor_eq_ricciTensor' bsm.g bsm.symmetric bsm.nondegenerate μ ν p,
      ricciTensor_eq_ricciTensor' bsm.g bsm.symmetric bsm.nondegenerate ν μ p]
  exact ricciTensor'_symmetric_bounded bsm μ ν p

/-! ## First Bianchi Identity for BoundedSymmetryMetric

Since `BoundedSymmetryMetric.symmetric` gives exact metric symmetry,
the existing exact `first_bianchi` from `Curvature.lean` applies. We
wrap it here as a convenience method on the structure, and derive a
corresponding cyclic identity for the lowered Riemann. -/

/-- First Bianchi identity for BSM (exact, because metric symmetry is exact). -/
theorem first_bianchi_exact (bsm : BoundedSymmetryMetric)
    (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    riemannTensor bsm.g ρ σ μ ν p + riemannTensor bsm.g ρ μ ν σ p +
    riemannTensor bsm.g ρ ν σ μ p = 0 :=
  first_bianchi bsm.g bsm.symmetric ρ σ μ ν p

/-- First Bianchi identity for lowered Riemann on BSM (exact). -/
theorem first_bianchi_lower_exact (bsm : BoundedSymmetryMetric)
    (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    riemannLower bsm.g ρ σ μ ν p + riemannLower bsm.g ρ μ ν σ p +
    riemannLower bsm.g ρ ν σ μ p = 0 :=
  first_bianchi_lower bsm.g bsm.symmetric ρ σ μ ν p

/-- Ricci antisymmetric part is the trace of the first-two-index contraction,
    which is bounded by the pair-swap-derived Ricci symmetry bound. This is a
    convenient restatement of `ricci_symmetric_bounded` in Σ form. -/
theorem ricci_antisym_bounded_sum (bsm : BoundedSymmetryMetric)
    (μ ν : Fin 4) (p : LatticePoint) :
    |Finset.univ.sum (fun ρ =>
      riemannTensor bsm.g ρ μ ρ ν p - riemannTensor bsm.g ρ ν ρ μ p)| ≤
    16 * bsm.M_inv * bsm.C_pair_swap * bsm.epsilon := by
  -- This is exactly |ricciTensor g μ ν - ricciTensor g ν μ| by definition.
  have h := ricci_symmetric_bounded bsm μ ν p
  unfold ricciTensor at h
  rwa [← Finset.sum_sub_distrib] at h

end BoundedSymmetryMetric

/-! ## Abstract Derivation of pair_swap_bounded

In the current `BoundedSymmetryMetric` structure, `pair_swap_bounded` is a
field (assumption). The theorem below shows how it WOULD be derived from
two more primitive inputs:

  1. **Exact pair swap on a reference metric** `g_exact` — the smooth
     classical identity R_{ρσμν}[g_exact] = R_{μνρσ}[g_exact], which is
     a theorem of classical GR (assuming metric symmetry + torsion-free).

  2. **A Riemann-difference bound** — |R[g_actual] - R[g_exact]| ≤ Δ per
     component, where Δ is the (possibly constant-multiplied) metric defect
     magnitude. This bound is what the error-propagation machinery of
     `Tensor/Operations.lean` + the product rule `abs_mul_sub_mul_bound`
     would establish from `component_bounded`.

This decomposes the "pair_swap_bounded as a theorem" question into one
algebraic fact (exact pair swap on g_exact) and one analytic fact (Riemann
Lipschitz-in-metric). The analytic fact requires regularity assumptions on
`g_exact` (bounded inverse metric, bounded second derivatives), which is
the reason V1 also kept `pair_swap` as an axiom rather than deriving it. -/

/-- Pair swap bound from a reference metric identity + a Riemann-difference bound.
    If R_exact has exact pair swap AND |R_actual - R_exact| ≤ Δ per component,
    then R_actual has pair swap up to 2Δ. -/
theorem pair_swap_bounded_from_riemann_diff
    (g g_exact : DiscreteMetric)
    (h_exact : ∀ ρ σ μ ν p,
      riemannLower g_exact ρ σ μ ν p = riemannLower g_exact μ ν ρ σ p)
    (Δ : ℝ) (_hΔ : 0 ≤ Δ)
    (h_diff : ∀ ρ σ μ ν p,
      |riemannLower g ρ σ μ ν p - riemannLower g_exact ρ σ μ ν p| ≤ Δ) :
    ∀ ρ σ μ ν p,
      |riemannLower g ρ σ μ ν p - riemannLower g μ ν ρ σ p| ≤ 2 * Δ := by
  intro ρ σ μ ν p
  -- Strategy: add and subtract R(g_exact)_{μνρσ}, then use h_exact on the
  -- inserted term to match it against R(g_exact)_{ρσμν} in the first diff.
  have h_exact_eq := h_exact ρ σ μ ν p
  have d1 := h_diff ρ σ μ ν p
  have d2 := h_diff μ ν ρ σ p
  have hdec : riemannLower g ρ σ μ ν p - riemannLower g μ ν ρ σ p =
      (riemannLower g ρ σ μ ν p - riemannLower g_exact ρ σ μ ν p) +
      (riemannLower g_exact μ ν ρ σ p - riemannLower g μ ν ρ σ p) := by
    -- After adding and subtracting R(g_exact)_{μνρσ} and using h_exact_eq:
    linarith [h_exact_eq]
  rw [hdec]
  calc |(riemannLower g ρ σ μ ν p - riemannLower g_exact ρ σ μ ν p) +
         (riemannLower g_exact μ ν ρ σ p - riemannLower g μ ν ρ σ p)|
      ≤ |riemannLower g ρ σ μ ν p - riemannLower g_exact ρ σ μ ν p| +
        |riemannLower g_exact μ ν ρ σ p - riemannLower g μ ν ρ σ p| := abs_add_le _ _
    _ = |riemannLower g ρ σ μ ν p - riemannLower g_exact ρ σ μ ν p| +
        |riemannLower g μ ν ρ σ p - riemannLower g_exact μ ν ρ σ p| := by
          rw [abs_sub_comm (riemannLower g_exact μ ν ρ σ p)]
    _ ≤ Δ + Δ := add_le_add d1 d2
    _ = 2 * Δ := by ring

/-! ## Covariant Derivative of (0,2) Tensors and Contracted Bianchi

The classical contracted Bianchi identity ∇^μ G_{μν} = 0 holds exactly
in smooth GR. On the discrete lattice with defects, it holds up to O(l_P):
  |∇^μ G_{μν}(p)| ≤ C · l_P.

This is Appendix D Lemma 2.2 of the Omega-Theory paper. The full derivation
from first principles requires discrete covariant calculus infrastructure
that V2 does not yet have (and V1's derivation itself had a `sorry` at this
point). We adopt the approach of V1's `Axioms/Bianchi.lean`: take the
Bianchi bound as a structure field on a dedicated metric type, derive the
contracted version forwarding through the covariant derivative operator.

### Note on honesty

Making `contracted_bianchi_bound` a structure field (rather than a theorem)
is the honest V2 analog of V1's `second_bianchi_axiom`. The physical content
— that discrete Einstein is approximately divergence-free — is preserved,
but the *derivation* of this bound from more primitive assumptions remains
future work requiring substantial error-propagation machinery. -/

/-- Covariant derivative of a (0,2) tensor field:
    ∇_α T_{μν} = ∂_α T_{μν} - Γ^λ_{αμ} T_{λν} - Γ^λ_{αν} T_{μλ}. -/
noncomputable def covariantDeriv02 (g : DiscreteMetric)
    (T : LatticePoint → Fin 4 → Fin 4 → ℝ) (α μ ν : Fin 4)
    (p : LatticePoint) : ℝ :=
  symmetricDiff (fun q => T q μ ν) α p -
  Finset.univ.sum (fun lam => christoffelSymbol g lam α μ p * T p lam ν) -
  Finset.univ.sum (fun lam => christoffelSymbol g lam α ν p * T p μ lam)

/-- Divergence of the Einstein tensor: ∇^μ G_{μν} = g^{αμ} ∇_α G_{μν}. -/
noncomputable def einsteinDivergence (g : DiscreteMetric) (ν : Fin 4)
    (p : LatticePoint) : ℝ :=
  Finset.univ.sum fun α =>
    Finset.univ.sum fun μ =>
      (inverseMetric (g p)) α μ *
      covariantDeriv02 g (fun q μ' ν' => einsteinTensor g μ' ν' q) α μ ν p

/-- `BianchiMetric` extends `BoundedSymmetryMetric` with a bound on the
    divergence of the Einstein tensor. The bound is parameterized by a
    constant `C_bianchi` and scales with `l_P` (Planck length), encoding
    the physical claim that discrete gravity violates conservation only
    at the Planck scale.

    This is the V2 analog of V1's `second_bianchi_axiom`: accepted as a
    structural assumption on the metric, to be justified by future work
    on discrete covariant calculus. -/
structure BianchiMetric extends BoundedSymmetryMetric where
  /-- Constant appearing in the contracted Bianchi bound. -/
  C_bianchi : ℝ
  C_bianchi_pos : 0 < C_bianchi
  /-- |∇^μ G_{μν}| ≤ C_bianchi · l_P — Appendix D Lemma 2.2. -/
  contracted_bianchi_assumption : ∀ ν p,
    |einsteinDivergence g ν p| ≤ C_bianchi * l_P

namespace BianchiMetric

/-- The contracted Bianchi identity for a `BianchiMetric`: the divergence
    of the Einstein tensor is O(l_P). This is stated as a theorem (with
    the bound coming from the structure field), to parallel V1's
    `contracted_bianchi_discrete`. -/
theorem contracted_bianchi (bm : BianchiMetric) (ν : Fin 4) (p : LatticePoint) :
    |einsteinDivergence bm.g ν p| ≤ bm.C_bianchi * l_P :=
  bm.contracted_bianchi_assumption ν p

/-- Corollary: the contracted Bianchi bound is nonneg.
    (Trivially, since it's a magnitude.) -/
theorem contracted_bianchi_nonneg (bm : BianchiMetric) (ν : Fin 4)
    (p : LatticePoint) : 0 ≤ bm.C_bianchi * l_P :=
  le_of_lt (mul_pos bm.C_bianchi_pos l_P_pos)

/-- In the zero-defect limit (ε → 0), the Einstein divergence is still
    bounded by C·l_P. This captures the claim that even in vacuum,
    discrete gravity carries a Planck-scale residual. -/
theorem contracted_bianchi_zero_defect (bm : BianchiMetric)
    (_hε : bm.epsilon = 0) (ν : Fin 4) (p : LatticePoint) :
    |einsteinDivergence bm.g ν p| ≤ bm.C_bianchi * l_P :=
  bm.contracted_bianchi_assumption ν p

end BianchiMetric

/-! ## Exact Curvature Symmetries for General Metrics

Classical GR result: for any symmetric nondegenerate metric with exact pair swap,
the full symmetry chain follows algebraically:

  pair swap (hypothesis) → antisym12 → Ricci symmetry

This complements the BOUNDED versions above. Smooth metrics get exact symmetry;
lattice metrics with defects get bounded symmetry (proportional to ε).
At ε → 0 the bounded versions reduce to these — see `pair_swap_exact_at_zero`.

The pair swap hypothesis is the discrete analog of ∂_μ∂_ν = ∂_ν∂_μ
(smooth second derivatives commute). On the lattice it must be postulated
for the reference metric; the actual metric satisfies it only approximately. -/

/-- Exact antisymmetry in first two indices: R_{ρσμν} = -R_{σρμν}.

    Proof chain: pair swap + antisym34 + pair swap.
    R_{ρσμν} = R_{μνρσ}   (pair swap)
             = -R_{μνσρ}  (exact antisym34)
             = -R_{σρμν}  (pair swap applied to R_{σρμν}) -/
theorem riemann_lower_antisym_12_exact (g : DiscreteMetric)
    (h_pair_swap : ∀ ρ σ μ ν p,
      riemannLower g ρ σ μ ν p = riemannLower g μ ν ρ σ p)
    (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    riemannLower g ρ σ μ ν p = -riemannLower g σ ρ μ ν p := by
  calc riemannLower g ρ σ μ ν p
      = riemannLower g μ ν ρ σ p := h_pair_swap ρ σ μ ν p
    _ = -riemannLower g μ ν σ ρ p := riemannLower_antisym_34 g μ ν ρ σ p
    _ = -riemannLower g σ ρ μ ν p := by rw [h_pair_swap σ ρ μ ν p]

/-- Exact Ricci' symmetry (metric-contracted form): R'_{μν} = R'_{νμ}.

    Proof: rewrite R_{ρμσν} = R_{σνρμ} via pair swap, exchange summation
    order (ρ ↔ σ dummy relabel), apply inverse metric symmetry g^{ρσ} = g^{σρ}. -/
theorem ricci'_symmetric_exact (g : DiscreteMetric)
    (hsym : g.IsEverywhereSymmetric)
    (h_pair_swap : ∀ ρ σ μ ν p,
      riemannLower g ρ σ μ ν p = riemannLower g μ ν ρ σ p)
    (μ ν : Fin 4) (p : LatticePoint) :
    ricciTensor' g μ ν p = ricciTensor' g ν μ p := by
  unfold ricciTensor'
  -- Apply pair swap: R_{ρμσν} = R_{σνρμ}
  simp_rw [h_pair_swap _ μ _ ν _]
  -- Now LHS = Σ_{ρσ} g^{ρσ} R_{σνρμ}, RHS = Σ_{ρσ} g^{ρσ} R_{ρνσμ}
  -- Exchange sum order (dummy relabel ρ ↔ σ)
  rw [Finset.sum_comm]
  -- Now LHS = Σ_{σρ} g^{ρσ} R_{ρνσμ} — need g^{ρσ} = g^{σρ}
  apply Finset.sum_congr rfl; intro σ _
  apply Finset.sum_congr rfl; intro ρ _
  rw [inverseMetric_symm (g p) (hsym p) ρ σ]

/-- Exact Ricci symmetry: R_{μν} = R_{νμ}.

    Bridge through ricciTensor': both definitions agree (proven in Curvature.lean),
    and the metric-contracted form is symmetric by the pair-swap argument above. -/
theorem ricci_symmetric_exact (g : DiscreteMetric)
    (hsym : g.IsEverywhereSymmetric) (hnd : ∀ p, IsNondegenerate (g p))
    (h_pair_swap : ∀ ρ σ μ ν p,
      riemannLower g ρ σ μ ν p = riemannLower g μ ν ρ σ p)
    (μ ν : Fin 4) (p : LatticePoint) :
    ricciTensor g μ ν p = ricciTensor g ν μ p := by
  calc ricciTensor g μ ν p
      = ricciTensor' g μ ν p := ricciTensor_eq_ricciTensor' g hsym hnd μ ν p
    _ = ricciTensor' g ν μ p := ricci'_symmetric_exact g hsym h_pair_swap μ ν p
    _ = ricciTensor g ν μ p := (ricciTensor_eq_ricciTensor' g hsym hnd ν μ p).symm

/-- Exact Einstein symmetry: G_{μν} = G_{νμ}.

    Proof: G = R - (1/2)gR. Ricci is symmetric (exact), metric is symmetric,
    scalar curvature is a scalar. So G inherits symmetry. -/
theorem einstein_symmetric_exact (g : DiscreteMetric)
    (hsym : g.IsEverywhereSymmetric) (hnd : ∀ p, IsNondegenerate (g p))
    (h_pair_swap : ∀ ρ σ μ ν p,
      riemannLower g ρ σ μ ν p = riemannLower g μ ν ρ σ p)
    (μ ν : Fin 4) (p : LatticePoint) :
    einsteinTensor g μ ν p = einsteinTensor g ν μ p := by
  unfold einsteinTensor
  rw [ricci_symmetric_exact g hsym hnd h_pair_swap μ ν p]
  have hg : (g p) μ ν = (g p) ν μ := by
    have := congrFun (congrFun (hsym p) ν) μ
    simp only [Matrix.transpose_apply] at this; exact this
  rw [hg]

/-! ## Pair Swap Bounded as THEOREM from Valued Pipeline

The `BoundedSymmetryMetric` structure has `pair_swap_bounded` as a field.
The theorem below derives it from:

1. The Valued error-propagation pipeline (ValuedCurvature.lean):
   `|R_{ρσμν}[g] - R_{ρσμν}[g_exact]| ≤ riemannLowerError`

2. Exact pair swap on the reference metric g_exact:
   `R_{ρσμν}[g_exact] = R_{μνρσ}[g_exact]`

3. Triangle decomposition (`pair_swap_bounded_from_riemann_diff`):
   exact + bounded difference → bounded pair swap

This converts `pair_swap_bounded` from an assumption to a consequence
of the metric's error structure. -/

open OmegaTheory.Tensor

/-- Pair swap bounded derived from the Valued pipeline.

    Given a `SemiSmoothMetric` with `RiemannErrorData`, bounds on the actual
    metric and exact Riemann, and exact pair swap on the reference metric,
    the actual metric has bounded pair swap with bound `2 · riemannLowerError`.

    This is the theorem that makes `BoundedSymmetryMetric.pair_swap_bounded`
    derivable rather than assumed. -/
theorem pair_swap_from_valued_pipeline
    (ssm : SemiSmoothMetric) (red : RiemannErrorData ssm)
    (M_g M_R : ℝ) (hMg : 0 ≤ M_g) (hMR : 0 ≤ M_R)
    (hg_bounded : ∀ p ρ σ, |(ssm.g p) ρ σ| ≤ M_g)
    (hR_bounded : ∀ ρ σ μ ν p,
      |riemannTensor ssm.g_exact ρ σ μ ν p| ≤ M_R)
    (h_exact_pair_swap : ∀ ρ σ μ ν p,
      riemannLower ssm.g_exact ρ σ μ ν p =
      riemannLower ssm.g_exact μ ν ρ σ p) :
    ∀ ρ σ μ ν p,
      |riemannLower ssm.g ρ σ μ ν p -
       riemannLower ssm.g μ ν ρ σ p| ≤
      2 * riemannLowerError M_g M_R red :=
  pair_swap_bounded_from_riemann_diff ssm.g ssm.g_exact
    h_exact_pair_swap
    (riemannLowerError M_g M_R red)
    (riemannLowerError_nonneg M_g M_R hMg hMR red)
    (fun ρ σ μ ν p =>
      riemannLower_perturbation_bound ssm red M_g M_R
        hg_bounded hR_bounded ρ σ μ ν p)

end OmegaTheory.Geometry
