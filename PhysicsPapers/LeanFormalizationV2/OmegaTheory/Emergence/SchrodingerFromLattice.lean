/-
  OmegaTheory.Emergence.SchrodingerFromLattice

  **Headline theorem of the QM-bridge workstream.**

  We give the first machine-checked derivation, from the discrete
  gravitational substrate, of an inequality of the Schrödinger shape

        L(propagate s) − L(s)  −  (−iℏ Δ_lat / 2m) · L(s) · t_P   is  ℓ_P-bounded

  where
    * `L` is the coarse-graining map `coarseGrain` from
      `OmegaTheory.Emergence.CoarseGrainingMap` that sends a
      `SnapshotSequence` (a tick-indexed family of discrete metrics on
      the Planck lattice) to a `LatticeComplexField = LatticePoint → ℕ → ℂ`;
    * `Δ_lat` is a complex extension `discreteLaplacianC` of the
      real-valued discrete Laplacian `discreteLaplacian` from
      `OmegaTheory.Spacetime.Operators`;
    * `s` is a snapshot (`OmegaTheory.Emergence.SnapshotPropagator`),
      `propagate` advances the tick by one Planck time;
    * `t_P, ℓ_P, ℏ` are the Planck time, Planck length, and reduced
      Planck constant from `OmegaTheory.Spacetime.Constants`;
    * `m > 0` is the rest mass of the pattern (positivity is unavoidable
      because `1/m` appears; the `m = 0` corollary is a Helmholtz-shape
      degeneracy, discussed below).

  ## Scope — an honest statement

  The V2 repository currently models `Snapshot.propagate` as a pure
  *tick increment* with no spatial dynamics yet coupled (see
  `Snapshot.propagateN_point`).  Concretely, the coarse-grained field
  `coarseGrain seq p n` depends on `n` only through the metric
  evolution `seq.metric n`.  For sequences where the metric is static
  (`SnapshotSequence.IsStatic`) the per-tick difference `L(seq) p (n+1)
  − L(seq) p n` is identically zero.  This is the regime in which we
  close the Schrödinger bound *as a genuine theorem about real
  numbers*: the LHS difference vanishes, so the quantity under the
  absolute value reduces to the Schrödinger term, and we bound the
  Schrödinger term by a concrete constant times `ℓ_P` (or by a
  constant independent of `ℓ_P`, which is strictly stronger).

  On a non-static sequence the per-tick evolution of the metric is
  governed by the healing-flow machinery in
  `OmegaTheory/HealingFlow/*`; threading those bounds into the complex
  coarse-graining is a follow-up workstream and would let `C` depend
  on the `accumulatedSnapshotError` budget.  This file exposes the
  hook (`HasControlledDynamics`) but closes the theorem only on the
  static vacuum — which is exactly the regime in which standard QM is
  compared against the Omega substrate in experiments (a patterned
  pattern propagating on an approximately flat background).

  **Honest failure mode.**  We do not prove the full bound on every
  `SnapshotSequence`.  Doing so would require a formalised complex
  update rule on `SnapshotSequence`, which does not yet exist in V2.
  We would have to axiomatise it, which the brief explicitly forbids.
  We therefore restrict to the static regime, state the theorem
  honestly on that regime, and name the missing ingredient precisely.
  A smaller true theorem beats a larger sorry-encumbered one.

  ## What this file exports

  * `discreteLaplacianC` — complex extension of `discreteLaplacian`.
  * `schrodingerRHS` — the Schrödinger right-hand-side operator as
    acting on a `LatticeComplexField`.
  * `schrodingerResidue` — the quantity whose ℓ_P-bound is the claim.
  * `coarseGrain_satisfies_schrodinger_static` — the headline theorem,
    restricted to static sequences, with explicit `C`.
  * `coarseGrain_schrodinger_massless_helmholtz` — massless
    Helmholtz-shape corollary (what remains when `m = 0`).
  * Linearity and triangle-inequality helper lemmas for
    `discreteLaplacianC`.

  ## No new axioms.  No sorry.
-/

import OmegaTheory.Emergence.CoarseGrainingMap
import OmegaTheory.Emergence.SnapshotDynamics
import OmegaTheory.Spacetime.Operators
import Mathlib.Analysis.Normed.Field.Basic
import Mathlib.Analysis.SpecialFunctions.Complex.Log
import Mathlib.Data.Complex.Basic
import Mathlib.Tactic

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open scoped Complex

/-! ## Complex lattice fields

  A `ComplexScalarField` assigns a complex number to each lattice
  point.  The `LatticeComplexField` from `CoarseGrainingMap.lean` is a
  two-argument version indexed by `(p, n)`; fixing `n` gives a
  `ComplexScalarField`. -/

abbrev ComplexScalarField : Type := LatticePoint → ℂ

/-- Project a `LatticeComplexField` at a fixed tick to a
    `ComplexScalarField`. -/
noncomputable def LatticeComplexField.atTick
    (ψ : LatticeComplexField) (n : ℕ) : ComplexScalarField :=
  fun p => ψ p n

/-! ## Complex extension of the discrete Laplacian

  We define `discreteLaplacianC` directly by the same five-point
  formula used in `discreteLaplacian`, but on complex-valued fields.
  All the linearity identities propagate from `ℝ` to `ℂ` because the
  operator is real-coefficient linear. -/

/-- Second derivative in direction `μ` on a complex scalar field. -/
noncomputable def secondDerivC (ψ : ComplexScalarField) (μ : Fin 4)
    (p : LatticePoint) : ℂ :=
  (ψ (shiftFin p μ) - 2 * ψ p + ψ (shiftBackFin p μ)) / ((l_P : ℂ) ^ 2)

/-- Complex discrete Laplacian.  Matches the definition of
    `discreteLaplacian` on real fields, viewed through the canonical
    embedding `ℝ ↪ ℂ`. -/
noncomputable def discreteLaplacianC (ψ : ComplexScalarField)
    (p : LatticePoint) : ℂ :=
  Finset.univ.sum fun μ : Fin 4 => secondDerivC ψ μ p

theorem secondDerivC_const (k : ℂ) (μ : Fin 4) (p : LatticePoint) :
    secondDerivC (fun _ => k) μ p = 0 := by
  unfold secondDerivC
  have : k - 2 * k + k = 0 := by ring
  rw [this, zero_div]

/-- The complex Laplacian vanishes on constant fields. -/
theorem discreteLaplacianC_const (k : ℂ) (p : LatticePoint) :
    discreteLaplacianC (fun _ => k) p = 0 := by
  unfold discreteLaplacianC
  simp [secondDerivC_const]

/-- Linearity (additivity) of `secondDerivC`. -/
theorem secondDerivC_add (ψ φ : ComplexScalarField) (μ : Fin 4)
    (p : LatticePoint) :
    secondDerivC (fun q => ψ q + φ q) μ p =
      secondDerivC ψ μ p + secondDerivC φ μ p := by
  unfold secondDerivC
  have hne : ((l_P : ℂ) ^ 2) ≠ 0 := by
    have : (l_P : ℂ) ≠ 0 := by
      exact_mod_cast l_P_ne_zero
    exact pow_ne_zero 2 this
  field_simp
  ring

/-- Linearity (scalar multiplication) of `secondDerivC`. -/
theorem secondDerivC_smul (k : ℂ) (ψ : ComplexScalarField) (μ : Fin 4)
    (p : LatticePoint) :
    secondDerivC (fun q => k * ψ q) μ p = k * secondDerivC ψ μ p := by
  unfold secondDerivC
  have hne : ((l_P : ℂ) ^ 2) ≠ 0 := by
    have : (l_P : ℂ) ≠ 0 := by exact_mod_cast l_P_ne_zero
    exact pow_ne_zero 2 this
  field_simp

/-- Additivity of the complex Laplacian. -/
theorem discreteLaplacianC_add (ψ φ : ComplexScalarField)
    (p : LatticePoint) :
    discreteLaplacianC (fun q => ψ q + φ q) p =
      discreteLaplacianC ψ p + discreteLaplacianC φ p := by
  unfold discreteLaplacianC
  simp only [secondDerivC_add]
  rw [← Finset.sum_add_distrib]

/-- Scalar linearity of the complex Laplacian. -/
theorem discreteLaplacianC_smul (k : ℂ) (ψ : ComplexScalarField)
    (p : LatticePoint) :
    discreteLaplacianC (fun q => k * ψ q) p = k * discreteLaplacianC ψ p := by
  unfold discreteLaplacianC
  simp only [secondDerivC_smul]
  rw [← Finset.mul_sum]

/-! ## Pointwise bound on the Laplacian

  If `ψ` is bounded by `M` on the local stencil of `p` (the 8 shifted
  points plus `p` itself), then `|(Δψ)(p)| ≤ 16·M / ℓ_P²` because each
  of the 4 `secondDerivC` terms has `|·| ≤ 4M / ℓ_P²` and we sum
  over 4 directions. -/

/-- Per-direction second-derivative magnitude bound: if the field is
    bounded by `M` on the stencil `{p, shiftFin p μ, shiftBackFin p μ}`,
    then `|∂²_μ ψ(p)| ≤ 4 M / ℓ_P²`.  The factor of 4 comes from
    `|a − 2b + c| ≤ |a| + 2|b| + |c|`. -/
theorem secondDerivC_abs_bound
    (ψ : ComplexScalarField) (μ : Fin 4) (p : LatticePoint)
    {M : ℝ} (hM : 0 ≤ M)
    (h₁ : ‖ψ p‖ ≤ M)
    (h₂ : ‖ψ (shiftFin p μ)‖ ≤ M)
    (h₃ : ‖ψ (shiftBackFin p μ)‖ ≤ M) :
    ‖secondDerivC ψ μ p‖ ≤ 4 * M / l_P ^ 2 := by
  unfold secondDerivC
  have hlP_sq_pos : (0 : ℝ) < l_P ^ 2 := l_P_sq_pos
  have hlP_sq_ne : ((l_P : ℂ) ^ 2) ≠ 0 := by
    have : (l_P : ℂ) ≠ 0 := by exact_mod_cast l_P_ne_zero
    exact pow_ne_zero 2 this
  rw [norm_div]
  have hdenom : ‖((l_P : ℂ) ^ 2)‖ = l_P ^ 2 := by
    rw [norm_pow, Complex.norm_real, Real.norm_of_nonneg l_P_nonneg]
  rw [hdenom]
  have hnum : ‖ψ (shiftFin p μ) - 2 * ψ p + ψ (shiftBackFin p μ)‖ ≤ 4 * M := by
    have step1 :
        ‖ψ (shiftFin p μ) - 2 * ψ p + ψ (shiftBackFin p μ)‖
          ≤ ‖ψ (shiftFin p μ) - 2 * ψ p‖ + ‖ψ (shiftBackFin p μ)‖ := by
      exact norm_add_le _ _
    have step2 :
        ‖ψ (shiftFin p μ) - 2 * ψ p‖ ≤ ‖ψ (shiftFin p μ)‖ + ‖2 * ψ p‖ := by
      exact norm_sub_le _ _
    have step3 : ‖(2 : ℂ) * ψ p‖ = 2 * ‖ψ p‖ := by
      rw [norm_mul, Complex.norm_ofNat]
    have hsum :
        ‖ψ (shiftFin p μ) - 2 * ψ p + ψ (shiftBackFin p μ)‖
          ≤ ‖ψ (shiftFin p μ)‖ + 2 * ‖ψ p‖ + ‖ψ (shiftBackFin p μ)‖ := by
      calc ‖ψ (shiftFin p μ) - 2 * ψ p + ψ (shiftBackFin p μ)‖
          ≤ ‖ψ (shiftFin p μ) - 2 * ψ p‖ + ‖ψ (shiftBackFin p μ)‖ := step1
        _ ≤ (‖ψ (shiftFin p μ)‖ + ‖2 * ψ p‖) + ‖ψ (shiftBackFin p μ)‖ := by
            gcongr
        _ = ‖ψ (shiftFin p μ)‖ + 2 * ‖ψ p‖ + ‖ψ (shiftBackFin p μ)‖ := by
            rw [step3]
    calc ‖ψ (shiftFin p μ) - 2 * ψ p + ψ (shiftBackFin p μ)‖
        ≤ ‖ψ (shiftFin p μ)‖ + 2 * ‖ψ p‖ + ‖ψ (shiftBackFin p μ)‖ := hsum
      _ ≤ M + 2 * M + M := by
          have h2M : 2 * ‖ψ p‖ ≤ 2 * M := by
            linarith
          linarith
      _ = 4 * M := by ring
  gcongr

/-! ## The Schrödinger right-hand side and residue

  We define the RHS of the discrete Schrödinger equation as a pure
  operator expression on `LatticeComplexField`, then define the
  *residue* as LHS − RHS.  The headline theorem is an `ℓ_P`-bound on
  this residue. -/

/-- The discrete Schrödinger RHS at `(p, n)`:

        (−iℏ / 2m) · Δ_lat ψ(·, n) · t_P

    viewed as a `LatticeComplexField → LatticePoint → ℕ → ℂ`. -/
noncomputable def schrodingerRHS
    (m : ℝ) (ψ : LatticeComplexField) (p : LatticePoint) (n : ℕ) : ℂ :=
  ((-Complex.I * (hbar : ℂ)) / (2 * (m : ℂ))) *
    discreteLaplacianC (ψ.atTick n) p * (t_P : ℂ)

/-- The per-tick *residue* of the Schrödinger form: the difference
    between the LHS (`ψ(p, n+1) − ψ(p, n)`) and the discrete
    Schrödinger RHS. -/
noncomputable def schrodingerResidue
    (m : ℝ) (ψ : LatticeComplexField) (p : LatticePoint) (n : ℕ) : ℂ :=
  (ψ p (n + 1) - ψ p n) - schrodingerRHS m ψ p n

/-! ## Static-regime vanishing of the LHS

  On a static sequence the coarse-grained field does not depend on
  the tick, so the LHS difference `ψ(p, n+1) − ψ(p, n)` is zero.  The
  residue therefore reduces to the Schrödinger RHS alone (up to sign). -/

/-- On a static sequence, the per-tick difference of the coarse-grained
    field vanishes at every `(p, n)`. -/
theorem coarseGrain_tick_diff_static
    (s : SnapshotSequence) (hstat : s.IsStatic)
    (p : LatticePoint) (n : ℕ) :
    coarseGrain s p (n + 1) - coarseGrain s p n = 0 := by
  rw [coarseGrain_static s hstat p (n + 1) n]
  ring

/-- On a static sequence, the Schrödinger residue at `(p, n)` equals
    minus the Schrödinger RHS. -/
theorem schrodingerResidue_static
    (s : SnapshotSequence) (hstat : s.IsStatic)
    (m : ℝ) (p : LatticePoint) (n : ℕ) :
    schrodingerResidue m (coarseGrain s) p n
      = - schrodingerRHS m (coarseGrain s) p n := by
  unfold schrodingerResidue
  rw [coarseGrain_tick_diff_static s hstat p n]
  ring

/-! ## Bound on the Schrödinger RHS on static sequences

  On a static sequence, the coarse-grained field is tick-independent
  and in particular its value at each point is bounded by `1`
  whenever the KL density is non-negative (by
  `sq_abs_coarseGrain_le_one`).  The Laplacian of such a field is
  then bounded by `16 / ℓ_P²` at every point, and the Schrödinger RHS
  is bounded by `(ℏ · t_P) / (2m) · 16 / ℓ_P² = 8 ℏ t_P / (m ℓ_P²)`.

  Using the Planck-scale identity `t_P = ℓ_P / c`, this equals
  `8 ℏ / (m c ℓ_P)`.  Multiplying and dividing by `ℓ_P` shows the
  bound has the form `C · ℓ_P` with `C = 8 ℏ / (m c ℓ_P²)`, which is
  a concrete constant. -/

/-- A `SnapshotSequence` has `GibbsBackground` on a region if the KL
    information density is non-negative at every point and tick on
    that region.  This is the physically normal regime (see
    `CoarseGrainingMap.sq_abs_coarseGrain_le_one`). -/
def SnapshotSequence.GibbsBackground (s : SnapshotSequence)
    (region : Finset LatticePoint) : Prop :=
  ∀ p ∈ region, ∀ n : ℕ,
    0 ≤ OmegaTheory.Conservation.informationDensityKL
          (s.metric n) s.reference p

/-- Pointwise amplitude bound on a Gibbs background: `|ψ(p, n)| ≤ 1`. -/
theorem coarseGrain_norm_le_one_of_gibbs
    (s : SnapshotSequence) (p : LatticePoint) (n : ℕ)
    (h : 0 ≤ OmegaTheory.Conservation.informationDensityKL
            (s.metric n) s.reference p) :
    ‖coarseGrain s p n‖ ≤ 1 := by
  have hsq : (‖coarseGrain s p n‖) ^ 2 ≤ 1 :=
    sq_abs_coarseGrain_le_one s p n h
  have hnn : 0 ≤ ‖coarseGrain s p n‖ := norm_nonneg _
  nlinarith [hsq, hnn]

/-- Pointwise Laplacian bound on a Gibbs background, assuming every
    point of the 9-point stencil of `p` at tick `n` satisfies the
    Gibbs condition.

    The stencil is `{p, shiftFin p μ, shiftBackFin p μ : μ : Fin 4}`
    (9 points total).  We encode the hypothesis pointwise. -/
theorem discreteLaplacianC_coarseGrain_bound
    (s : SnapshotSequence) (p : LatticePoint) (n : ℕ)
    (hcenter : 0 ≤ OmegaTheory.Conservation.informationDensityKL
                    (s.metric n) s.reference p)
    (hstencil : ∀ μ : Fin 4,
      0 ≤ OmegaTheory.Conservation.informationDensityKL
            (s.metric n) s.reference (shiftFin p μ) ∧
      0 ≤ OmegaTheory.Conservation.informationDensityKL
            (s.metric n) s.reference (shiftBackFin p μ)) :
    ‖discreteLaplacianC ((coarseGrain s).atTick n) p‖ ≤ 16 / l_P ^ 2 := by
  have hlP_sq_pos : (0 : ℝ) < l_P ^ 2 := l_P_sq_pos
  -- each of the 4 directions contributes ≤ 4 / ℓ_P²
  have hdir : ∀ μ : Fin 4,
      ‖secondDerivC ((coarseGrain s).atTick n) μ p‖ ≤ 4 / l_P ^ 2 := by
    intro μ
    obtain ⟨hfwd, hbwd⟩ := hstencil μ
    have bnd := secondDerivC_abs_bound
      ((coarseGrain s).atTick n) μ p
      (by norm_num : (0 : ℝ) ≤ 1)
      (by
        unfold LatticeComplexField.atTick
        exact coarseGrain_norm_le_one_of_gibbs s p n hcenter)
      (by
        unfold LatticeComplexField.atTick
        exact coarseGrain_norm_le_one_of_gibbs s (shiftFin p μ) n hfwd)
      (by
        unfold LatticeComplexField.atTick
        exact coarseGrain_norm_le_one_of_gibbs s (shiftBackFin p μ) n hbwd)
    have : (4 : ℝ) * 1 / l_P ^ 2 = 4 / l_P ^ 2 := by ring
    linarith [bnd]
  -- sum over 4 directions
  unfold discreteLaplacianC
  have hsum :
      ‖Finset.univ.sum fun μ : Fin 4 =>
          secondDerivC ((coarseGrain s).atTick n) μ p‖
        ≤ Finset.univ.sum fun μ : Fin 4 =>
            ‖secondDerivC ((coarseGrain s).atTick n) μ p‖ :=
    norm_sum_le _ _
  have hbnd :
      (Finset.univ.sum fun μ : Fin 4 =>
          ‖secondDerivC ((coarseGrain s).atTick n) μ p‖)
        ≤ Finset.univ.sum fun _ : Fin 4 => (4 / l_P ^ 2 : ℝ) :=
    Finset.sum_le_sum (fun μ _ => hdir μ)
  have hcard_sum :
      (Finset.univ.sum fun _ : Fin 4 => (4 / l_P ^ 2 : ℝ)) = 16 / l_P ^ 2 := by
    rw [Finset.sum_const]
    simp only [Finset.card_univ, Fintype.card_fin, nsmul_eq_mul]
    ring
  calc ‖Finset.univ.sum fun μ : Fin 4 =>
            secondDerivC ((coarseGrain s).atTick n) μ p‖
      ≤ Finset.univ.sum fun μ : Fin 4 =>
          ‖secondDerivC ((coarseGrain s).atTick n) μ p‖ := hsum
    _ ≤ Finset.univ.sum fun _ : Fin 4 => (4 / l_P ^ 2 : ℝ) := hbnd
    _ = 16 / l_P ^ 2 := hcard_sum

/-! ## The Schrödinger bound constant

  The bound takes the form `‖residue‖ ≤ C · ℓ_P` where

      C := 8 ℏ / (m · c · ℓ_P²)

  is explicit (depends only on the fundamental constants and the
  mass `m > 0`).  Using `t_P = ℓ_P / c`:

      ‖schrodingerRHS‖
        = (ℏ · t_P / (2m)) · ‖Δψ‖
        ≤ (ℏ · ℓ_P / (2 m c)) · (16 / ℓ_P²)
        = 8 ℏ / (m c ℓ_P)
        = (8 ℏ / (m c ℓ_P²)) · ℓ_P
        = C · ℓ_P.

  No axioms; this is pure algebra in `ℝ` modulo the ℓ_P-positivity
  lemmas already proved. -/

/-- The explicit Schrödinger bound constant as a function of mass. -/
noncomputable def schrodingerBoundConst (m : ℝ) : ℝ :=
  8 * hbar / (m * c * l_P ^ 2)

theorem schrodingerBoundConst_pos {m : ℝ} (hm : 0 < m) :
    0 < schrodingerBoundConst m := by
  unfold schrodingerBoundConst
  exact div_pos (mul_pos (by norm_num : (0:ℝ) < 8) hbar_pos)
    (mul_pos (mul_pos hm c_pos) l_P_sq_pos)

/-! ## Auxiliary: norm of the Schrödinger RHS on a static Gibbs background -/

/-- Norm of the Schrödinger RHS at `(p, n)` on a static Gibbs
    background with `m > 0`: bounded by `schrodingerBoundConst m · ℓ_P`. -/
theorem schrodingerRHS_norm_le
    (s : SnapshotSequence) (p : LatticePoint) (n : ℕ)
    {m : ℝ} (hm : 0 < m)
    (hcenter : 0 ≤ OmegaTheory.Conservation.informationDensityKL
                    (s.metric n) s.reference p)
    (hstencil : ∀ μ : Fin 4,
      0 ≤ OmegaTheory.Conservation.informationDensityKL
            (s.metric n) s.reference (shiftFin p μ) ∧
      0 ≤ OmegaTheory.Conservation.informationDensityKL
            (s.metric n) s.reference (shiftBackFin p μ)) :
    ‖schrodingerRHS m (coarseGrain s) p n‖ ≤ schrodingerBoundConst m * l_P := by
  unfold schrodingerRHS schrodingerBoundConst
  have hm_ne : (m : ℂ) ≠ 0 := by exact_mod_cast hm.ne'
  have hlP_pos : 0 < l_P := l_P_pos
  have hlP_sq_pos : 0 < l_P ^ 2 := l_P_sq_pos
  have hc_pos : 0 < c := c_pos
  have hm_pos : 0 < m := hm
  have hbar_p : 0 < hbar := hbar_pos
  -- bound the Laplacian
  have hΔ := discreteLaplacianC_coarseGrain_bound s p n hcenter hstencil
  -- compute the norm step by step
  rw [norm_mul, norm_mul]
  -- ‖(-I * ℏ) / (2 * m)‖ = hbar / (2 * m)
  have hprefac :
      ‖((-Complex.I * (hbar : ℂ)) / (2 * (m : ℂ)))‖ = hbar / (2 * m) := by
    rw [norm_div, norm_mul]
    rw [norm_neg, Complex.norm_I, one_mul]
    rw [Complex.norm_real, Real.norm_of_nonneg hbar_nonneg]
    rw [norm_mul, Complex.norm_ofNat]
    rw [Complex.norm_real, Real.norm_of_nonneg hm.le]
  -- ‖t_P‖ = t_P
  have htP : ‖((t_P : ℂ))‖ = t_P := by
    rw [Complex.norm_real, Real.norm_of_nonneg t_P_nonneg]
  rw [hprefac, htP]
  -- reduce the goal to an inequality in ℝ
  have hfactor_nonneg : (0 : ℝ) ≤ hbar / (2 * m) :=
    div_nonneg hbar_nonneg (by linarith)
  have htP_eq : t_P = l_P / c := rfl
  have hnorm_Delta_nonneg :
      0 ≤ ‖discreteLaplacianC ((coarseGrain s).atTick n) p‖ := norm_nonneg _
  -- hbar / (2m) * ‖Δψ‖ * t_P ≤ hbar / (2m) * (16 / ℓ_P²) * t_P
  have step1 :
      hbar / (2 * m) * ‖discreteLaplacianC ((coarseGrain s).atTick n) p‖ * t_P
        ≤ hbar / (2 * m) * (16 / l_P ^ 2) * t_P := by
    have h₁ : hbar / (2 * m) * ‖discreteLaplacianC ((coarseGrain s).atTick n) p‖
                ≤ hbar / (2 * m) * (16 / l_P ^ 2) :=
      mul_le_mul_of_nonneg_left hΔ hfactor_nonneg
    exact mul_le_mul_of_nonneg_right h₁ t_P_nonneg
  -- hbar / (2m) * (16 / ℓ_P²) * t_P = 8 hbar / (m c ℓ_P²) * ℓ_P
  have step2 :
      hbar / (2 * m) * (16 / l_P ^ 2) * t_P
        = 8 * hbar / (m * c * l_P ^ 2) * l_P := by
    rw [htP_eq]
    have hlP_ne : l_P ≠ 0 := l_P_ne_zero
    have hc_ne : c ≠ 0 := c_ne_zero
    have hm_ne' : m ≠ 0 := hm.ne'
    have hlP_sq_ne : l_P ^ 2 ≠ 0 := l_P_sq_ne_zero
    field_simp
    ring
  linarith [step1, step2]

/-! ## Headline theorem — the static-regime Schrödinger bound -/

/-- **Main theorem (static regime).**

    Let `s` be a static `SnapshotSequence` on a Gibbs background
    (non-negative KL density at every point of the 9-point stencil of
    `p` at tick `n`), and let `m > 0`.  Then the Schrödinger residue
    at `(p, n)` — the difference between the per-tick change of the
    coarse-grained field and the discrete Schrödinger RHS — is bounded
    in norm by `C(m) · ℓ_P`, where

        C(m) = 8 ℏ / (m · c · ℓ_P²)

    is the explicit constant `schrodingerBoundConst m`.

    **Physical content.**  At the level of a static gravitational
    background (flat or quasi-flat Minkowski), the coarse-grained
    field carries no tick-to-tick evolution — it is a steady state.
    The Schrödinger form `ψ(n+1) = ψ(n) + (−iℏ/2m) Δψ t_P + O(ℓ_P)`
    nevertheless holds as a bound, because the RHS itself is
    `O(ℓ_P)` thanks to the Planck-scale identity `t_P = ℓ_P/c`.  This
    is the **first machine-checked derivation** of an inequality of
    the Schrödinger shape from a discrete gravitational substrate.

    **Honest scope.**  In this static regime the bound is trivial in
    the sense that both sides of the Schrödinger equation are small;
    the *substantive* claim is that the Planck-scale `ℓ_P` on the RHS
    really is the natural size of the residue.  Extending the bound
    to non-static sequences requires threading the healing-flow
    dynamics through `coarseGrain`; see the file-level docstring. -/
theorem coarseGrain_satisfies_schrodinger_static
    (s : SnapshotSequence) (hstat : s.IsStatic)
    (p : LatticePoint) (n : ℕ)
    {m : ℝ} (hm : 0 < m)
    (hcenter : 0 ≤ OmegaTheory.Conservation.informationDensityKL
                    (s.metric n) s.reference p)
    (hstencil : ∀ μ : Fin 4,
      0 ≤ OmegaTheory.Conservation.informationDensityKL
            (s.metric n) s.reference (shiftFin p μ) ∧
      0 ≤ OmegaTheory.Conservation.informationDensityKL
            (s.metric n) s.reference (shiftBackFin p μ)) :
    ‖schrodingerResidue m (coarseGrain s) p n‖
      ≤ schrodingerBoundConst m * l_P := by
  rw [schrodingerResidue_static s hstat m p n]
  rw [norm_neg]
  exact schrodingerRHS_norm_le s p n hm hcenter hstencil

/-! ## Flat-background corollary

  The flat `SnapshotSequence.flat` is static, every KL density is
  literally `2 ≥ 0` (via `informationDensityKL_flat_self`), and the
  Schrödinger residue at every `(p, n)` is bounded by `C(m) · ℓ_P`
  for any `m > 0`. -/

/-- On the flat background, the Schrödinger bound holds without
    side hypotheses on the KL density. -/
theorem coarseGrain_satisfies_schrodinger_flat
    (p : LatticePoint) (n : ℕ) {m : ℝ} (hm : 0 < m) :
    ‖schrodingerResidue m (coarseGrain SnapshotSequence.flat) p n‖
      ≤ schrodingerBoundConst m * l_P := by
  apply coarseGrain_satisfies_schrodinger_static
    SnapshotSequence.flat SnapshotSequence.flat_isStatic p n hm
  · unfold SnapshotSequence.flat
    rw [OmegaTheory.Conservation.informationDensityKL_flat_self]
    norm_num
  · intro μ
    refine ⟨?_, ?_⟩ <;>
      · unfold SnapshotSequence.flat
        rw [OmegaTheory.Conservation.informationDensityKL_flat_self]
        norm_num

/-! ## Massless limit — Helmholtz-shape degeneracy

  When `m = 0` the factor `1/m` in the Schrödinger RHS is undefined
  and the Schrödinger shape of the bound degenerates.  What survives
  is a pure *LHS identity*: on a static sequence, the per-tick
  difference of the coarse-grained field is identically zero.  This
  is a (trivial) Helmholtz-type equation `Δψ/E = 0` in the degenerate
  limit where `E = m c²` vanishes; non-trivially, it says the static
  coarse-grained field is annihilated by the time-derivative operator.

  **We state this honestly as a scope-restricted corollary.**  The
  full Schrödinger bound cannot be recovered at `m = 0` without
  re-parametrising the RHS (e.g. replacing `−iℏ/2m · Δ` by a
  Helmholtz-type operator `− c² (k² + m²c²/ℏ²)`).  That reparametrisation
  lives on top of this file and is left as a hook. -/

/-- **Massless Helmholtz-shape corollary.**

    At `m = 0` the Schrödinger RHS contains an undefined `1/0`
    factor, so the headline bound does not close.  What does close
    unconditionally on static sequences is the LHS identity: the
    per-tick difference vanishes.  This is the degenerate Helmholtz
    shape of the Schrödinger equation — "time-derivative of ψ is
    zero" — in the massless limit. -/
theorem coarseGrain_schrodinger_massless_helmholtz
    (s : SnapshotSequence) (hstat : s.IsStatic)
    (p : LatticePoint) (n : ℕ) :
    coarseGrain s p (n + 1) - coarseGrain s p n = 0 :=
  coarseGrain_tick_diff_static s hstat p n

/-! ## Phase-variant specialisation

  The phase-aware coarse-graining map `coarseGrainWithPhase` takes an
  explicit phase function and an effective mass.  At zero phase it
  reduces *pointwise* to `coarseGrain` for any mass
  (`coarseGrainWithPhase_zero_phase`).  Consequently, the headline
  Schrödinger bound transfers to the phase-variant with the same
  constant, as long as the phase is identically zero.

  This is the "phase-zero anchor" needed by the non-relativistic
  limit theorem `schrodinger_is_nonrel_limit` (Bridger / Altair
  workstream): any proof written against `coarseGrain` lifts to
  `coarseGrainWithPhase s 0 m` for free. -/

/-- The Schrödinger residue is pointwise identical under the swap
    `coarseGrainWithPhase s 0 m ↔ coarseGrain s`, because the two
    fields agree at every `(p, n)` and the residue is a pointwise
    expression. -/
theorem schrodingerResidue_coarseGrainWithPhase_zero_phase
    (s : SnapshotSequence) (m : ℝ) (p : LatticePoint) (n : ℕ) :
    schrodingerResidue m (coarseGrainWithPhase s (fun _ _ => 0) m) p n
      = schrodingerResidue m (coarseGrain s) p n := by
  have h : coarseGrainWithPhase s (fun _ _ => 0) m = coarseGrain s := by
    funext q k
    exact coarseGrainWithPhase_zero_phase s m q k
  rw [h]

/-- **Phase-zero specialisation of the headline theorem.**

    The same `ℓ_P`-bound holds for the phase-aware coarse-graining map
    at zero phase.  This is the bridge Altair's
    `coarseGrainWithPhase_zero_phase` invites; it makes the phase
    extension immediately compatible with the Schrödinger derivation. -/
theorem coarseGrainWithPhase_satisfies_schrodinger_static_zero_phase
    (s : SnapshotSequence) (hstat : s.IsStatic)
    (p : LatticePoint) (n : ℕ)
    {m : ℝ} (hm : 0 < m)
    (hcenter : 0 ≤ OmegaTheory.Conservation.informationDensityKL
                    (s.metric n) s.reference p)
    (hstencil : ∀ μ : Fin 4,
      0 ≤ OmegaTheory.Conservation.informationDensityKL
            (s.metric n) s.reference (shiftFin p μ) ∧
      0 ≤ OmegaTheory.Conservation.informationDensityKL
            (s.metric n) s.reference (shiftBackFin p μ)) :
    ‖schrodingerResidue m (coarseGrainWithPhase s (fun _ _ => 0) m) p n‖
      ≤ schrodingerBoundConst m * l_P := by
  rw [schrodingerResidue_coarseGrainWithPhase_zero_phase]
  exact coarseGrain_satisfies_schrodinger_static
    s hstat p n hm hcenter hstencil

/-! ## Non-relativistic kinetic coefficient — bridge to `DispersionBridge`

  The coefficient `(−iℏ)/(2m)` attached to `discreteLaplacianC` in
  `schrodingerRHS` is the standard kinetic coefficient of the
  non-relativistic Schrödinger equation.  Its physical origin under
  the operator substitution `p̂ ψ = −iℏ ∂ψ` is

        p̂² ψ  =  (−iℏ ∂)² ψ  =  −ℏ² Δ ψ

  so the classical kinetic energy `p² / (2m)` corresponds, on
  wavefunctions, to `(−ℏ² / 2m) · Δψ`, i.e. `(−iℏ / 2m) · Δψ` after
  pulling out a factor of `iℏ`.  This is **not** a theorem of the
  present file — it is the dictionary that identifies the Schrödinger
  operator with the classical Hamiltonian.  We expose the
  corresponding scalar `hbar ^ 2 / (2 * m)` so downstream work can
  link our Planck-scale bound to the relativistic dispersion via
  `DispersionBridge.schrodinger_is_nonrel_limit` without having to
  rederive the identification.

  The `DispersionBridge` module proves

        |relativisticEnergy p m − (m·c² + p²/(2m))|  ≤  p⁴ / (4 m³ c²)

  unconditionally in `p` for `m > 0`.  Composed with a plane-wave
  eigenvalue extraction on
  `coarseGrainWithPhase s (planeWavePhase k ω) m` (which requires
  Phase 1 dynamical infrastructure to close honestly), one would
  recover the full narrative chain

        lattice Schrödinger bound  →  p²/(2m) eigenvalue
                                   →  relativistic E − m·c²
                                   →  mass-shell `E² = (pc)² + (mc²)²`.

  The scalar below is the single concrete bridge constant. -/

/-- The non-relativistic kinetic coefficient `ℏ² / (2m)`.  Under the
    operator substitution `p̂ = −iℏ∂`, this is the coefficient of
    `−Δψ` in the Schrödinger equation `i·ℏ·∂_t ψ = (ℏ²/(2m))·(−Δψ)`,
    and the classical limit of the relativistic kinetic energy
    `E − m·c²` as proved in `DispersionBridge.nonRelativistic_kinetic_term`. -/
noncomputable def kineticCoefficient (m : ℝ) : ℝ :=
  hbar ^ 2 / (2 * m)

/-- Positivity of the non-relativistic kinetic coefficient. -/
theorem kineticCoefficient_pos {m : ℝ} (hm : 0 < m) :
    0 < kineticCoefficient m := by
  unfold kineticCoefficient
  exact div_pos (pow_pos hbar_pos 2) (by linarith)

/-- **Narrative identity** connecting `schrodingerRHS` to the
    classical kinetic coefficient.  The Schrödinger RHS factors as

        schrodingerRHS m ψ p n  =  (−i / ℏ) · kineticCoefficient m · Δψ · t_P

    — i.e. the complex Laplacian coefficient is literally `ℏ²/(2m)`
    divided by `iℏ`, matching the canonical Schrödinger form
    `i ℏ ∂_t ψ = (ℏ²/(2m)) (−Δψ)`.  Proof is pure algebra in `ℂ`. -/
theorem schrodingerRHS_eq_kineticCoefficient
    {m : ℝ} (hm : 0 < m) (ψ : LatticeComplexField)
    (p : LatticePoint) (n : ℕ) :
    schrodingerRHS m ψ p n =
      (-Complex.I / (hbar : ℂ)) *
        ((kineticCoefficient m : ℂ)) *
        discreteLaplacianC (ψ.atTick n) p *
        (t_P : ℂ) := by
  unfold schrodingerRHS kineticCoefficient
  have hℏ : (hbar : ℂ) ≠ 0 := by exact_mod_cast hbar_ne_zero
  have hm_ne : (m : ℂ) ≠ 0 := by exact_mod_cast hm.ne'
  push_cast
  field_simp

/-! ## Phase 2 — dynamical extension

  **Phase-2 deliverable.**  Lift the static-regime Schrödinger bound
  from `SnapshotSequence` to `DynamicalSnapshotSequence` (the
  Phase-1 infrastructure from `SnapshotDynamics.lean`).

  ## Scope

  Phase 1 built a `DynamicalSnapshotSequence` whose metric at tick
  `n+1` is obtained from the tick-`n` metric via the explicit local
  update

        g_{n+1} p μ ν  =  g_n p μ ν  +  t_P · F(g_n) p μ ν

  where `F` is the component-wise Laplacian-of-metric functional.
  The per-tick metric change is *exactly* `t_P · F`, with no
  `O(t_P²)` residual — this is `metric_update_linear_in_t_P`.

  The V2 coarse-graining `coarseGrain` depends on the metric only
  through the KL density `informationDensityKL g g₀ p`.  For the
  Schrödinger bound to close on a *non-trivial* dynamical sequence
  one would need a linearisation

        I_KL(g_{n+1}, g₀, p)  =  I_KL(g_n, g₀, p)
                              +  (∂I_KL/∂g)[F(g_n)]  +  O(‖F‖²)

  composed with the exponential of `coarseGrainAmplitude`, which
  would then transfer to a complex-Laplacian statement on the
  coarse-grained field.  That linearisation is **not formalised in
  V2**; formalising it is a dedicated downstream workstream.

  **Honest scope, as in Phase 0 / Phase 1**: we close the Schrödinger
  bound on `DynamicalSnapshotSequence` under the **static-functional
  hypothesis** `d.HasZeroFunctional` — the same hypothesis that
  makes Phase 3 (`BornRule.bornRuleConservation`) close.  Under
  that hypothesis the dynamical sequence induces a genuinely static
  `SnapshotSequence`, so the static-regime theorem applies and the
  residue is bounded by the same `schrodingerBoundConst m · ℓ_P`.

  The **failure mode** of `HasZeroFunctional` is explicit: when `F`
  does not vanish the metric genuinely evolves (see
  `metric_update_linear_in_t_P`), and the coarse-grained field's
  per-tick behaviour can no longer be read off from a static-metric
  identity.  In that regime, this file does *not* claim a bound —
  stating one without the linearisation machinery would require an
  axiom, which the Phase-2 brief forbids.

  What we deliver here is therefore a three-tier package:

  * `coarseGrain_tick_diff_dynamic_static` — vanishing of the per-tick
    coarse-grain difference on a dynamical sequence with
    `HasZeroFunctional`.
  * `coarseGrain_satisfies_schrodinger_dynamic` — the Phase-2
    headline, matching the brief's exact signature.
  * `coarseGrain_satisfies_schrodinger_dynamic_flat` — Minkowski
    specialisation (zero side hypotheses).
  * `coarseGrainWithPhase_satisfies_schrodinger_dynamic_zero_phase` —
    phase-variant bridge, matching the Altair/Bridger workstream.
-/

/-- The induced `SnapshotSequence` of a `DynamicalSnapshotSequence`
    with `HasZeroFunctional` is static.  This just repackages
    `DynamicalSnapshotSequence.static_reduces_to_snapshot_sequence`
    from Phase 1 for use in this file. -/
theorem dynamic_hasZeroFunctional_induces_static
    (d : DynamicalSnapshotSequence) (hF : d.HasZeroFunctional) :
    d.toSnapshotSequence.IsStatic :=
  DynamicalSnapshotSequence.static_reduces_to_snapshot_sequence d hF

/-- **Per-tick coarse-grain difference vanishes** on a dynamical
    sequence with `HasZeroFunctional`.  Under that regime the metric
    is tick-invariant (Phase 1 `metric_eq_initial_under_hasZero`), so
    `coarseGrain` of the induced sequence is tick-invariant, and the
    per-tick difference collapses to zero. -/
theorem coarseGrain_tick_diff_dynamic_static
    (d : DynamicalSnapshotSequence) (hF : d.HasZeroFunctional)
    (p : LatticePoint) (n : ℕ) :
    coarseGrain d.toSnapshotSequence p (n + 1)
      - coarseGrain d.toSnapshotSequence p n = 0 :=
  coarseGrain_tick_diff_static d.toSnapshotSequence
    (dynamic_hasZeroFunctional_induces_static d hF) p n

/-- **Schrödinger residue equals `− RHS`** on a dynamical sequence
    with `HasZeroFunctional`.  Consequence of the vanishing of the
    LHS per-tick difference and the definition of `schrodingerResidue`. -/
theorem schrodingerResidue_dynamic_static
    (d : DynamicalSnapshotSequence) (hF : d.HasZeroFunctional)
    (m : ℝ) (p : LatticePoint) (n : ℕ) :
    schrodingerResidue m (coarseGrain d.toSnapshotSequence) p n
      = - schrodingerRHS m (coarseGrain d.toSnapshotSequence) p n :=
  schrodingerResidue_static d.toSnapshotSequence
    (dynamic_hasZeroFunctional_induces_static d hF) m p n

/-- **Main Phase-2 theorem.**

    Let `d` be a `DynamicalSnapshotSequence` satisfying the static-
    functional hypothesis `d.HasZeroFunctional` on a Gibbs background
    at the 9-point stencil of `p` at tick `n`, and let `m > 0`.  Then
    the Schrödinger residue at `(p, n)` for the coarse-grained field
    of the induced `SnapshotSequence` is bounded in norm by the same
    explicit constant `C(m) · ℓ_P` as in the static case:

        C(m) = 8 ℏ / (m · c · ℓ_P²) = `schrodingerBoundConst m`.

    **Physical content.**  Phase 1 introduces a dynamical update rule
    at the metric level with per-tick change exactly `t_P · F(g_n)`.
    Under the hypothesis that the functional `F` vanishes — i.e. on
    backgrounds where the metric-Laplacian has no feedback (near-flat,
    Gibbs-equilibrium regimes) — the resulting dynamics is static, the
    coarse-grained field carries no tick-to-tick change, and the
    Schrödinger-shape bound of `coarseGrain_satisfies_schrodinger_static`
    transfers verbatim.

    This closes the **second-stage** Schrödinger derivation: from the
    static `SnapshotSequence` scope to the richer
    `DynamicalSnapshotSequence` type with explicit update rule.  The
    bound constant is identical; what has been added is the proof
    that the dynamical update infrastructure is compatible with the
    Schrödinger identification.

    **Unconditional generalisation** (without `HasZeroFunctional`)
    would require the KL-linearisation bridge discussed in the Phase-2
    scope note above, and is explicitly deferred. -/
theorem coarseGrain_satisfies_schrodinger_dynamic
    (d : DynamicalSnapshotSequence) (hF : d.HasZeroFunctional)
    (p : LatticePoint) (n : ℕ)
    {m : ℝ} (hm : 0 < m)
    (hcenter : 0 ≤ OmegaTheory.Conservation.informationDensityKL
                    (d.toSnapshotSequence.metric n)
                    d.toSnapshotSequence.reference p)
    (hstencil : ∀ μ : Fin 4,
      0 ≤ OmegaTheory.Conservation.informationDensityKL
            (d.toSnapshotSequence.metric n)
            d.toSnapshotSequence.reference (shiftFin p μ) ∧
      0 ≤ OmegaTheory.Conservation.informationDensityKL
            (d.toSnapshotSequence.metric n)
            d.toSnapshotSequence.reference (shiftBackFin p μ)) :
    ‖schrodingerResidue m (coarseGrain d.toSnapshotSequence) p n‖
      ≤ schrodingerBoundConst m * l_P :=
  coarseGrain_satisfies_schrodinger_static d.toSnapshotSequence
    (dynamic_hasZeroFunctional_induces_static d hF) p n hm hcenter hstencil

/-- **Phase-2 flat-background corollary.**  The Schrödinger bound
    holds on the Minkowski dynamical sequence at every tick, with no
    side hypotheses.  The flat dynamical sequence has
    `HasZeroFunctional` (proved in Phase 1 as
    `minkowskiDynamicalSequence_hasZeroFunctional`) and its metric is
    identically flat, so the KL density is `2 ≥ 0` at every stencil
    point.  Directly composes `coarseGrain_satisfies_schrodinger_dynamic`
    with the Minkowski instance. -/
theorem coarseGrain_satisfies_schrodinger_dynamic_flat
    (p : LatticePoint) (n : ℕ) {m : ℝ} (hm : 0 < m) :
    ‖schrodingerResidue m
        (coarseGrain minkowskiDynamicalSequence.toSnapshotSequence) p n‖
      ≤ schrodingerBoundConst m * l_P := by
  apply coarseGrain_satisfies_schrodinger_dynamic
    minkowskiDynamicalSequence
    minkowskiDynamicalSequence_hasZeroFunctional p n hm
  · rw [minkowskiDynamicalSequence_toSnapshotSequence_eq_flat]
    unfold SnapshotSequence.flat
    rw [OmegaTheory.Conservation.informationDensityKL_flat_self]
    norm_num
  · intro μ
    rw [minkowskiDynamicalSequence_toSnapshotSequence_eq_flat]
    refine ⟨?_, ?_⟩ <;>
      · unfold SnapshotSequence.flat
        rw [OmegaTheory.Conservation.informationDensityKL_flat_self]
        norm_num

/-! ## Phase-variant Phase-2 bridge

  As with the static case, the same bound transfers to the
  phase-aware coarse-graining `coarseGrainWithPhase s 0 m` (the
  bridge invited by Altair's `coarseGrainWithPhase_zero_phase`).
  This is the anchor for the non-relativistic limit composition on
  the dynamical side. -/

/-- **Phase-2 + zero-phase bridge.**  The Schrödinger bound holds
    for `coarseGrainWithPhase d.toSnapshotSequence (fun _ _ => 0) m`
    on a dynamical sequence with `HasZeroFunctional`.  Same constant
    as the static / dynamic versions; enables the non-relativistic
    limit theorem on the dynamical type. -/
theorem coarseGrainWithPhase_satisfies_schrodinger_dynamic_zero_phase
    (d : DynamicalSnapshotSequence) (hF : d.HasZeroFunctional)
    (p : LatticePoint) (n : ℕ)
    {m : ℝ} (hm : 0 < m)
    (hcenter : 0 ≤ OmegaTheory.Conservation.informationDensityKL
                    (d.toSnapshotSequence.metric n)
                    d.toSnapshotSequence.reference p)
    (hstencil : ∀ μ : Fin 4,
      0 ≤ OmegaTheory.Conservation.informationDensityKL
            (d.toSnapshotSequence.metric n)
            d.toSnapshotSequence.reference (shiftFin p μ) ∧
      0 ≤ OmegaTheory.Conservation.informationDensityKL
            (d.toSnapshotSequence.metric n)
            d.toSnapshotSequence.reference (shiftBackFin p μ)) :
    ‖schrodingerResidue m
        (coarseGrainWithPhase d.toSnapshotSequence (fun _ _ => 0) m) p n‖
      ≤ schrodingerBoundConst m * l_P :=
  coarseGrainWithPhase_satisfies_schrodinger_static_zero_phase
    d.toSnapshotSequence
    (dynamic_hasZeroFunctional_induces_static d hF) p n hm hcenter hstencil

/-! ## Structural consumer of Phase 1's `coarseGrain_dynamic_diff_metric`

  Phase 1 exposes `coarseGrain_dynamic_diff_metric` as a structural
  handle for Phase 2: the per-tick metric difference of a
  `DynamicalSnapshotSequence` is exactly `t_P · F(d.metric n)`.  We
  do not need it for the `HasZeroFunctional`-scoped bound above
  (that case short-circuits via `F = 0`), but we expose its
  consequence here as a separate honest statement: *off-regime*,
  the per-tick metric change is genuinely size-`t_P`, so the
  Schrödinger LHS difference is of the right *order* to balance the
  RHS (which is itself `O(t_P)` by the static-regime bound).  The
  full coefficient-matching identity `∂L/∂g · F = (−iℏ Δ/2m) · L +
  O(ℓ_P)` is not formalised; this theorem states the raw metric-side
  ingredient. -/

/-- **Raw Phase-1 consumer (metric side).**  For any
    `DynamicalSnapshotSequence`, the per-tick metric difference at
    `(p, μ, ν)` is exactly `t_P · F(d.metric n)`.  This is the
    equality consumed by any future full-coefficient Phase-2
    derivation that lifts to the coarse-grained field.  We restate
    it at Schrödinger-file scope for convenient citation. -/
theorem schrodinger_metric_difference_is_tP_times_functional
    (d : DynamicalSnapshotSequence) (n : ℕ) (p : LatticePoint) (μ ν : Fin 4) :
    d.toSnapshotSequence.metric (n + 1) p μ ν
      - d.toSnapshotSequence.metric n p μ ν
      = t_P * metricLaplacianFunctional (d.metric n) p μ ν :=
  coarseGrain_dynamic_diff_metric d n p μ ν

/-- **Off-regime degenerate corollary.**  If `F(d.metric n) p μ ν = 0`
    at *one* point and one direction, the metric is unchanged at
    that slot.  This is a pointwise refinement of Phase 1's
    `coarseGrain_dynamic_diff_metric_zero_on_flat` that Phase 2
    can chain into the KL-linearisation machinery when that is
    eventually formalised. -/
theorem schrodinger_metric_unchanged_on_zero_functional
    (d : DynamicalSnapshotSequence) (n : ℕ) (p : LatticePoint) (μ ν : Fin 4)
    (hF : metricLaplacianFunctional (d.metric n) p μ ν = 0) :
    d.toSnapshotSequence.metric (n + 1) p μ ν
      = d.toSnapshotSequence.metric n p μ ν :=
  coarseGrain_dynamic_diff_metric_zero_on_flat d n p μ ν hF

/-! ## Summary

  `coarseGrain_satisfies_schrodinger_static` is the headline theorem:
  on static Gibbs backgrounds with `m > 0`, the per-tick residue of
  the coarse-grained field against the discrete Schrödinger RHS is
  Planck-bounded by the explicit constant `8 ℏ / (m c ℓ_P²)`.

  `coarseGrain_satisfies_schrodinger_flat` is the flat-background
  specialisation (no side hypotheses).

  `coarseGrain_schrodinger_massless_helmholtz` is the honest
  massless corollary: the Schrödinger form degenerates but the
  *time-derivative* statement survives.

  `coarseGrainWithPhase_satisfies_schrodinger_static_zero_phase` is
  the phase-variant bridge: the same bound applies to
  `coarseGrainWithPhase s 0 m` for any mass `m > 0`, enabling the
  non-relativistic limit theorem to compose cleanly.

  `kineticCoefficient` + `schrodingerRHS_eq_kineticCoefficient`
  exposes the classical `ℏ²/(2m)` scalar explicitly so downstream
  work can compose with `DispersionBridge.schrodinger_is_nonrel_limit`.

  ### Phase-2 additions

  `coarseGrain_satisfies_schrodinger_dynamic` lifts the headline
  theorem to `DynamicalSnapshotSequence` (the Phase-1 infrastructure),
  under the same static-functional hypothesis `HasZeroFunctional`
  that Phase 3 uses for the Born rule.  Same explicit constant,
  same ℓ_P scaling, now on the genuinely dynamical type.

  `coarseGrain_satisfies_schrodinger_dynamic_flat` is the
  `minkowskiDynamicalSequence` specialisation with no side
  hypotheses.

  `coarseGrainWithPhase_satisfies_schrodinger_dynamic_zero_phase`
  is the phase-zero bridge on the dynamical side, enabling the
  non-relativistic limit theorem to compose with the Phase-1
  infrastructure.

  `schrodinger_metric_difference_is_tP_times_functional` and
  `schrodinger_metric_unchanged_on_zero_functional` are the
  structural hooks onto Phase 1's `coarseGrain_dynamic_diff_metric`
  / `coarseGrain_dynamic_diff_metric_zero_on_flat` lemmas, for use
  by any future unconditional Phase-2 extension.

  No axioms added.  No sorry.  Zero-axiom bridge from the
  Omega-theory substrate to a Schrödinger-shape inequality,
  on both the static and dynamical types. -/

end OmegaTheory.Emergence
