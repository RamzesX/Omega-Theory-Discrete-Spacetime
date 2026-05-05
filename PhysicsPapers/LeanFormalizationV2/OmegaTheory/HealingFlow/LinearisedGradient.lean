/-
  OmegaTheory.HealingFlow.LinearisedGradient

  **Lion's-Pride Phase 4.1 — linearised healing-flow gradient at
  flat-Minkowski equilibrium.**

  At equilibrium `g_eq = η` (flat) with `D = 0` and `I = Ī` (uniform
  information density), the functional gradient `δF/δg^{μν}(p)` of
  the healing functional `F` (`HealingFlow/Functional.lean`) reduces
  to a linear operator on scalar perturbations `h(p)`:

  `L h(p)  =  − μ_F · Δ_lattice h(p)  +  α_F · h(p)`

  where:

  * `μ_F > 0` is the smoothness coefficient (the "stiffness" of the
    healing flow),
  * `α_F = λ_F + γ_F · ∂I_per_g` is the local curvature of `F`
    around equilibrium (defect penalty + information-density
    contribution),
  * `Δ_lattice` is the discrete Laplacian
    (`Spacetime/Operators.lean::discreteLaplacian`).

  Phase 4.2's spectral analysis
  (`HealingFlow/SpectralLatticeLaplacian.lean`) gives plane-wave
  eigenfunctions of `−Δ_lattice`:
        `−Δ φ_k^μ(p) = (4/ℓ_P²) sin²(k·ℓ_P/2) · φ_k^μ(p)`.
  Combining: plane waves are eigenfunctions of `L` with eigenvalues
        `ω_k² = μ_F · (4/ℓ_P²) sin²(k·ℓ_P/2) + α_F`.

  This is the Phase-4 spectral formula *as a Lean theorem*, derived
  end-to-end from `Real.cos_add` / `Real.sin_sq_eq_half_sub` plus the
  substrate-axiom positivity.

  ## What this file proves

  Tier-A — operator definition + linearity:

  * `linearisedHealingOperator (μ_F α_F : ℝ) (h : ScalarField) (p : LatticePoint) : ℝ
      := −μ_F · Δ h(p) + α_F · h(p)`

  * `linearisedHealingOperator_add` — linearity in `h`.
  * `linearisedHealingOperator_smul` — homogeneity in `h`.
  * `linearisedHealingOperator_zero` — `L 0 = 0`.

  Tier-B — plane-wave eigenvalue:

  * `linearisedHealingOperator_eigenvalue_planeWave1D` — the
    eigenvalue formula:
        `L (latticePlaneWave1D k μ) p
            =  (μ_F · (4/ℓ_P²) sin²(k·ℓ_P/2) + α_F)
               · latticePlaneWave1D k μ p`.

  * `linearisedHealingEigenvalue` — closed-form eigenvalue
    `Eᴸ(k; μ_F, α_F) := μ_F · (4/ℓ_P²) sin²(k·ℓ_P/2) + α_F`.

  Tier-C — positivity and band:

  * `linearisedHealingEigenvalue_nonneg` — for `μ_F ≥ 0, α_F ≥ 0`,
    the eigenvalue is non-negative (mode is stable).

  * `linearisedHealingEigenvalue_in_planck_band` — under `μ_F = c²`
    and `α_F = 0` (free mass-zero mode), the eigenvalue equals the
    substrate dispersion `c² · Ω²(k)`, which is bounded by
    `4 c² / ℓ_P²` (UV ceiling).

  ## Why this is real, not abstract

  The eigenvalue formula `μ_F · (4/ℓ_P²) sin²(k·ℓ_P/2) + α_F` is
  *derived* by:

  1. Plugging the trial eigenfunction `latticePlaneWave1D k μ`
     (cosine plane wave) into `L`.
  2. Using `discreteLaplacian_latticePlaneWave1D` from Phase 4.2:
        `Δ φ_k = −(4/ℓ_P²) sin²(k·ℓ_P/2) · φ_k`.
  3. Calculating `−μ_F · Δ φ_k + α_F · φ_k` directly.

  No tuning, no fit.  All numbers come from the lattice's
  bidirectional-difference structure (the `4` and `2` in
  `(4/ℓ_P²) sin²(k·ℓ_P/2)`).

  ## Citations

  * V2 `HealingFlow/Functional.lean` — the underlying healing
    functional `F` whose linearised gradient gives `L`.
  * V2 `HealingFlow/SpectralLatticeLaplacian.lean` — the plane-wave
    eigenfunction theorem used here.
  * Weinberg, *Gravitation and Cosmology* (1972) §10.1 — the
    linearised-gravity pattern this port follows.

  -- Lion's-Pride Phase 4.1, 2026-05-05.
-/

import OmegaTheory.HealingFlow.SpectralLatticeLaplacian
import OmegaTheory.Spacetime.Operators
import OmegaTheory.Spacetime.Constants

namespace OmegaTheory.HealingFlow

open OmegaTheory.Spacetime
open OmegaTheory.Predictions

/-! ## Section 1 — The linearised healing operator -/

/-- **Linearised healing operator** at flat-Minkowski equilibrium.

    `L h(p) := −μ_F · Δ_lattice h(p) + α_F · h(p)`,
    where `μ_F` is the smoothness coefficient and
    `α_F = λ_F + γ_F · ∂I_per_g` is the local-curvature constant
    of the healing functional at equilibrium.

    The operator is local: the value at `p` depends only on `h`
    at `p` and its lattice-Laplacian neighbourhood. -/
noncomputable def linearisedHealingOperator
    (μ_F α_F : ℝ) (h : ScalarField) (p : LatticePoint) : ℝ :=
  - μ_F * discreteLaplacian h p + α_F * h p

/-- **Vanishing on zero scalar field**: `L 0 = 0`. -/
theorem linearisedHealingOperator_zero (μ_F α_F : ℝ) (p : LatticePoint) :
    linearisedHealingOperator μ_F α_F (fun _ => 0) p = 0 := by
  unfold linearisedHealingOperator
  rw [discreteLaplacian_const]
  simp

/-- **Additivity** in `h`: `L (h1 + h2) = L h1 + L h2`. -/
theorem linearisedHealingOperator_add
    (μ_F α_F : ℝ) (h1 h2 : ScalarField) (p : LatticePoint) :
    linearisedHealingOperator μ_F α_F (fun q => h1 q + h2 q) p =
      linearisedHealingOperator μ_F α_F h1 p +
      linearisedHealingOperator μ_F α_F h2 p := by
  unfold linearisedHealingOperator
  -- Δ(h1 + h2) = Δ h1 + Δ h2 (linearity of Δ).
  have h_disc : discreteLaplacian (fun q => h1 q + h2 q) p =
                discreteLaplacian h1 p + discreteLaplacian h2 p := by
    have := discreteLaplacian_add h1 h2 p
    simpa [scalarField_add_apply] using this
  rw [h_disc]; ring

/-- **Homogeneity** in `h`: `L (k · h) = k · L h`. -/
theorem linearisedHealingOperator_smul
    (μ_F α_F k : ℝ) (h : ScalarField) (p : LatticePoint) :
    linearisedHealingOperator μ_F α_F (fun q => k * h q) p =
      k * linearisedHealingOperator μ_F α_F h p := by
  unfold linearisedHealingOperator
  -- Δ(k · h) = k · Δ h.
  have h_disc : discreteLaplacian (fun q => k * h q) p =
                k * discreteLaplacian h p := by
    have := discreteLaplacian_smul k h p
    simpa [scalarField_smul_apply] using this
  rw [h_disc]; ring

/-! ## Section 2 — Eigenvalue closed form -/

/-- **Closed-form eigenvalue** of `L` on a plane-wave eigenfunction:
    `Eᴸ(k; μ_F, α_F) := μ_F · (4/ℓ_P²) · sin²(k·ℓ_P/2) + α_F`. -/
noncomputable def linearisedHealingEigenvalue
    (k μ_F α_F : ℝ) : ℝ :=
  μ_F * ((4 / l_P ^ 2) * (Real.sin (k * l_P / 2)) ^ 2) + α_F

/-! ## Section 3 — Plane wave is eigenfunction of `L` -/

/-- **Plane-wave eigenvalue theorem** for the linearised healing
    operator.  The plane wave `φ_k^μ(p) := cos(k · p_μ · ℓ_P)`
    is an eigenfunction of `L` with eigenvalue
    `μ_F · (4/ℓ_P²) sin²(k·ℓ_P/2) + α_F`.

    Proof: from `discreteLaplacian_latticePlaneWave1D` (Phase 4.2),
    `Δ φ_k = −(4/ℓ_P²) sin²(k·ℓ_P/2) · φ_k`.  Plug into
    `L φ_k = −μ_F · Δ φ_k + α_F · φ_k`. -/
theorem linearisedHealingOperator_eigenvalue_planeWave1D
    (μ_F α_F k : ℝ) (μ : Fin 4) (p : LatticePoint) :
    linearisedHealingOperator μ_F α_F (latticePlaneWave1D k μ) p =
      linearisedHealingEigenvalue k μ_F α_F * latticePlaneWave1D k μ p := by
  unfold linearisedHealingOperator linearisedHealingEigenvalue
  rw [discreteLaplacian_latticePlaneWave1D]
  ring

/-! ## Section 4 — Spectrum positivity and bounds -/

/-- **Eigenvalue is non-negative** when `μ_F ≥ 0, α_F ≥ 0`.
    Stable healing flow → all linearised modes have non-negative
    energy. -/
theorem linearisedHealingEigenvalue_nonneg
    (k μ_F α_F : ℝ) (hμ : 0 ≤ μ_F) (hα : 0 ≤ α_F) :
    0 ≤ linearisedHealingEigenvalue k μ_F α_F := by
  unfold linearisedHealingEigenvalue
  have h_lP : 0 < l_P ^ 2 := pow_pos l_P_pos 2
  have h_4lP : 0 ≤ (4 : ℝ) / l_P ^ 2 := by positivity
  have h_sin_sq : 0 ≤ (Real.sin (k * l_P / 2)) ^ 2 := sq_nonneg _
  have h_first : 0 ≤ μ_F * ((4 / l_P ^ 2) * (Real.sin (k * l_P / 2)) ^ 2) := by
    apply mul_nonneg hμ
    exact mul_nonneg h_4lP h_sin_sq
  linarith

/-- **UV bound on the dispersion eigenvalue** (free mass-zero mode):
    when `μ_F = c²` and `α_F = 0`, the eigenvalue equals
    `c² · Ω²(k)` and is bounded above by `4 c² / ℓ_P²`. -/
theorem linearisedHealingEigenvalue_in_planck_band
    (k : ℝ) :
    linearisedHealingEigenvalue k (c ^ 2) 0 =
      c ^ 2 * latticeDispersionPerDirection k ∧
    linearisedHealingEigenvalue k (c ^ 2) 0 ≤ 4 * c ^ 2 / l_P ^ 2 := by
  refine ⟨?_, ?_⟩
  · -- The closed form: μ_F · (4/ℓ_P²) sin²(k ℓ_P/2) + 0 = c² · Ω²(k).
    unfold linearisedHealingEigenvalue latticeDispersionPerDirection
    ring
  · -- UV bound: c² · Ω²(k) ≤ c² · (4/ℓ_P²) since sin² ≤ 1.
    unfold linearisedHealingEigenvalue
    have h_sin_sq : (Real.sin (k * l_P / 2)) ^ 2 ≤ 1 := by
      have h := Real.abs_sin_le_one (k * l_P / 2)
      have h2 : (Real.sin (k * l_P / 2)) ^ 2 = |Real.sin (k * l_P / 2)| ^ 2 := by
        rw [sq_abs]
      rw [h2]
      have h_abs_nn : 0 ≤ |Real.sin (k * l_P / 2)| := abs_nonneg _
      nlinarith
    have h_lP : 0 < l_P ^ 2 := pow_pos l_P_pos 2
    have h_4lP_nn : 0 ≤ (4 : ℝ) / l_P ^ 2 := by positivity
    have h_c2_nn : 0 ≤ c ^ 2 := by positivity
    -- Goal: c² · ((4/ℓ_P²) · sin²) + 0 ≤ 4c² / ℓ_P²
    -- = c² · (4/ℓ_P²) · sin²
    -- ≤ c² · (4/ℓ_P²) (since sin² ≤ 1)
    -- = 4c²/ℓ_P²
    have key : c ^ 2 * ((4 / l_P ^ 2) * (Real.sin (k * l_P / 2)) ^ 2) ≤
               c ^ 2 * (4 / l_P ^ 2) := by
      apply mul_le_mul_of_nonneg_left
      · calc (4 / l_P ^ 2) * (Real.sin (k * l_P / 2)) ^ 2
            ≤ (4 / l_P ^ 2) * 1 := by
              apply mul_le_mul_of_nonneg_left h_sin_sq h_4lP_nn
          _ = 4 / l_P ^ 2 := by ring
      · exact h_c2_nn
    have h_eq : c ^ 2 * (4 / l_P ^ 2) = 4 * c ^ 2 / l_P ^ 2 := by ring
    linarith

/-- **Existence of an eigenmode in the half-Planck band**:
    there exists a wavenumber `k` and an eigenfunction `φ` such that
    the linearised-healing eigenvalue equals `c²/(4 ℓ_P²)`,
    corresponding to a frequency `ω = c/(2 ℓ_P)` with energy
    `ℏ ω = E_P/2`.  This is the spectral identification of the
    Phase-4.4 capstone witness. -/
theorem linearisedHealingOperator_has_half_planck_eigenmode :
    ∃ (k : ℝ) (φ : ScalarField) (p : LatticePoint),
      φ p ≠ 0 ∧
      linearisedHealingOperator (c ^ 2) 0 φ p = (c ^ 2 / (4 * l_P ^ 2)) * φ p := by
  refine ⟨2 * Real.arcsin (1/4) / l_P, latticePlaneWave1D (2 * Real.arcsin (1/4) / l_P) 0,
         fun _ => 0, ?_, ?_⟩
  · -- φ at origin = 1 ≠ 0.
    rw [latticePlaneWave1D_at_origin]
    norm_num
  · -- Eigenvalue: from theorem above with μ_F = c², α_F = 0:
    --   eigenvalue = c² · (4/ℓ_P²) · sin²(arcsin(1/4)) = c² · (4/ℓ_P²) · (1/16) = c²/(4 ℓ_P²).
    rw [linearisedHealingOperator_eigenvalue_planeWave1D]
    -- Now reduce eigenvalue closed form.
    unfold linearisedHealingEigenvalue
    -- Goal: (c² · (4/ℓ_P²) · sin²(k₀ ℓ_P/2) + 0) · φ p = (c²/(4 ℓ_P²)) · φ p
    have h_arg : (2 * Real.arcsin (1/4) / l_P) * l_P / 2 = Real.arcsin (1/4) := by
      have hl : l_P ≠ 0 := ne_of_gt l_P_pos
      field_simp
    rw [h_arg]
    have h14 : (-1 : ℝ) ≤ 1/4 ∧ (1 : ℝ)/4 ≤ 1 := ⟨by norm_num, by norm_num⟩
    rw [Real.sin_arcsin h14.1 h14.2]
    -- (c² · (4/ℓ_P²) · (1/4)² + 0) · φ p = (c²/(4 ℓ_P²)) · φ p.
    have hl : l_P ≠ 0 := ne_of_gt l_P_pos
    have hl2 : l_P ^ 2 ≠ 0 := pow_ne_zero 2 hl
    field_simp
    ring

/-! ## Section 5 — Audit hook

NO `def OmegaConjecture` in this file.  Direct `#print axioms` on
every theorem returns `[propext, Classical.choice, Quot.sound]`.

Phase 4.1 deliverable: linearised-healing operator with closed-form
plane-wave eigenvalue; spectrum non-negativity; explicit half-Planck
eigenmode (the spectral grounding for the Phase-4.4 capstone). -/

end OmegaTheory.HealingFlow
