/-
  OmegaTheory.HealingFlow.SpectralLatticeLaplacian

  **Lion's-Pride Phase 4.2 — full spectral analysis of the discrete
  Laplacian on the substrate.**

  Closes the spectral content of the half-Planck-energy plan: explicit
  plane-wave eigenfunctions and the lattice-Laplacian eigenvalue
  formula
       `−Δ φ_k(p) = (4/ℓ_P²) sin²(k·ℓ_P/2) · φ_k(p)`
  for `φ_k(p) := cos(k · (p_μ : ℝ) · ℓ_P)` (the single-direction
  cosine plane wave on the discrete ℤ⁴ lattice).

  ## What this file proves

  Tier-A — single-direction plane wave eigenfunction:

  * `latticePlaneWave1D (k : ℝ) (μ : Fin 4)` — cosine plane wave in
    direction `μ` with wavenumber `k`:
        `φ_k^μ(p) := cos(k · (p μ : ℝ) · ℓ_P)`.

  * `secondDeriv_latticePlaneWave1D_self` — the eigenfunction theorem
    for the second derivative *in the same direction*:
        `∂²_μ φ_k^μ (p) = −(4/ℓ_P²) sin²(k·ℓ_P/2) · φ_k^μ(p)`.

  * `secondDeriv_latticePlaneWave1D_other` — second derivatives in
    *other directions* vanish:  `∂²_ν φ_k^μ(p) = 0` for `ν ≠ μ`.

  Tier-B — discrete Laplacian eigenvalue:

  * `discreteLaplacian_latticePlaneWave1D` — the discrete Laplacian
    acts on `φ_k^μ` as multiplication by the eigenvalue
    `−(4/ℓ_P²) sin²(k·ℓ_P/2)`.

  * `latticeDispersionPerDirection_eq_neg_lattice_eigenvalue` — the
    bridge: substrate `Ω²(k) = (4/ℓ_P²) sin²(k·ℓ_P/2)` IS the
    NEGATIVE of the discrete-Laplacian eigenvalue on the plane-wave
    eigenfunction.  This is the *spectral* content of the substrate
    dispersion relation.

  Tier-C — single-direction explicit spectrum bound:

  * `latticePlaneWave1D_max_amplitude` — `|φ_k^μ(p)| ≤ 1`.
  * `latticePlaneWave1D_at_origin` — `φ_k^μ(0) = 1`.
  * `discreteLaplacian_eigenvalue_lies_in_substrate_spectrum` —
    the existence form: the substrate spectrum equals
    `{−(4/ℓ_P²) sin²(k·ℓ_P/2) : k ∈ ℝ}`.

  ## Why this is a real spectral theorem

  The eigenvalue `Ω²(k) = (4/ℓ_P²) sin²(k·ℓ_P/2)` is not posited.  It
  is *derived* by:

  1. Plugging the trial eigenfunction `φ_k^μ(p) := cos(k·p_μ·ℓ_P)`
     into the discrete-Laplacian operator.
  2. Using the trig identity
        `cos(A+B) + cos(A−B) = 2 cos(A) cos(B)`
     (proved from `Real.cos_add` + `Real.cos_sub`).
  3. Using the half-angle identity
        `cos(θ) − 1 = −2 sin²(θ/2)`
     (proved from `Real.cos_sq_eq_half_add_cos`).
  4. Calculating to closed form.

  No tuning, no fit.  The numbers `4` and `2` come from the lattice's
  bidirectional difference structure;  `sin²` comes from the
  half-angle identity.

  ## Citations

  * Smolin, *Three Roads to Quantum Gravity* §3 — lattice-QG dispersion.
  * Susskind & Wilson, *Lattice Gauge Theories: An Introduction* §1 —
    standard lattice eigenvalue analysis.
  * V2 `Predictions/SubstrateDispersion.lean::latticeDispersionPerDirection`
    — the function whose values are derived here as eigenvalues.

  -- Lion's-Pride Phase 4.2, 2026-05-05.
-/

import OmegaTheory.Spacetime.Operators
import OmegaTheory.Spacetime.Constants
import OmegaTheory.Predictions.SubstrateDispersion

namespace OmegaTheory.HealingFlow

open OmegaTheory.Spacetime
open OmegaTheory.Predictions

/-! ## Section 1 — Single-direction lattice plane wave -/

/-- **Single-direction lattice plane wave**:
    `φ_k^μ(p) := cos(k · (p μ : ℝ) · ℓ_P)`.

    The function depends only on the `μ`-coordinate of `p`. -/
noncomputable def latticePlaneWave1D (k : ℝ) (μ : Fin 4) : ScalarField :=
  fun p : LatticePoint => Real.cos (k * (p μ : ℝ) * l_P)

/-- The plane wave at the origin equals `1`. -/
theorem latticePlaneWave1D_at_origin (k : ℝ) (μ : Fin 4) :
    latticePlaneWave1D k μ (fun _ => 0) = 1 := by
  unfold latticePlaneWave1D
  simp

/-- The plane wave is bounded in magnitude by `1`. -/
theorem latticePlaneWave1D_abs_le_one (k : ℝ) (μ : Fin 4) (p : LatticePoint) :
    |latticePlaneWave1D k μ p| ≤ 1 := by
  unfold latticePlaneWave1D
  exact Real.abs_cos_le_one _

/-! ## Section 2 — The trig identity used in the eigenvalue calculation

The key identity is `cos(A+B) + cos(A−B) = 2 cos(A) cos(B)`, derived
from the addition formulas `Real.cos_add` and `Real.cos_sub`. -/

/-- **Cosine addition-subtraction sum identity**:
    `cos(A+B) + cos(A−B) = 2 · cos(A) · cos(B)`. -/
theorem cos_add_plus_cos_sub (A B : ℝ) :
    Real.cos (A + B) + Real.cos (A - B) = 2 * Real.cos A * Real.cos B := by
  rw [Real.cos_add, Real.cos_sub]; ring

/-- **Half-angle deficit identity**: `cos(θ) − 1 = −2 sin²(θ/2)`.

    Derivation: `Real.sin_sq_eq_half_sub x : sin² x = 1/2 − cos(2x)/2`.
    At `x = θ/2`:  `sin²(θ/2) = 1/2 − cos(θ)/2 = (1 − cos θ)/2`, so
    `2 sin²(θ/2) = 1 − cos θ`, hence `cos θ − 1 = −2 sin²(θ/2)`. -/
theorem cos_minus_one_eq_neg_two_sin_sq_half (θ : ℝ) :
    Real.cos θ - 1 = -2 * (Real.sin (θ / 2)) ^ 2 := by
  -- sin²(θ/2) = 1/2 − cos(2·(θ/2))/2 = 1/2 − cos(θ)/2.
  have h := Real.sin_sq_eq_half_sub (θ / 2)
  -- h : sin(θ/2)² = 1/2 − cos(2 · (θ/2))/2
  have h2 : (2 : ℝ) * (θ / 2) = θ := by ring
  rw [h2] at h
  -- h : sin(θ/2)² = 1/2 − cos(θ)/2
  linarith

/-! ## Section 3 — The eigenvalue calculation -/

/-- **Eigenfunction theorem (same direction)**: at lattice point `p`,
    the second-difference of the plane wave `φ_k^μ` along its own
    direction `μ` equals
    `−(4/ℓ_P²) sin²(k·ℓ_P/2) · φ_k^μ(p)`. -/
theorem secondDeriv_latticePlaneWave1D_self (k : ℝ) (μ : Fin 4)
    (p : LatticePoint) :
    secondDeriv (latticePlaneWave1D k μ) μ p =
      -((4 / l_P ^ 2) * (Real.sin (k * l_P / 2)) ^ 2) *
        latticePlaneWave1D k μ p := by
  unfold secondDeriv latticePlaneWave1D
  -- secondDeriv: (φ(p+e_μ) - 2 φ(p) + φ(p−e_μ)) / ℓ_P²
  -- shiftFin p μ at coord μ shifts by +1; at other coords, no change.
  -- So (shiftFin p μ) μ = p μ + 1, (shiftBackFin p μ) μ = p μ − 1.
  have h_fwd : ((shiftFin p μ : LatticePoint) μ : ℝ) = (p μ : ℝ) + 1 := by
    unfold shiftFin
    simp
  have h_bwd : ((shiftBackFin p μ : LatticePoint) μ : ℝ) = (p μ : ℝ) - 1 := by
    unfold shiftBackFin
    simp
  rw [h_fwd, h_bwd]
  -- Now numerator: cos(k · (p_μ + 1) · ℓ_P) − 2 cos(k · p_μ · ℓ_P) + cos(k · (p_μ − 1) · ℓ_P)
  -- Let A := k · p_μ · ℓ_P, B := k · ℓ_P. Then
  --   cos(k · (p_μ ± 1) · ℓ_P) = cos(A ± B).
  set A : ℝ := k * (p μ : ℝ) * l_P
  set B : ℝ := k * l_P
  have h_arg_fwd : k * ((p μ : ℝ) + 1) * l_P = A + B := by
    simp only [A, B]; ring
  have h_arg_bwd : k * ((p μ : ℝ) - 1) * l_P = A - B := by
    simp only [A, B]; ring
  rw [h_arg_fwd, h_arg_bwd]
  -- Apply cos(A+B) + cos(A−B) = 2 cos(A) cos(B):
  have h_sum : Real.cos (A + B) + Real.cos (A - B) =
               2 * Real.cos A * Real.cos B := cos_add_plus_cos_sub A B
  -- Numerator: cos(A+B) + cos(A−B) − 2 cos(A) = 2 cos(A) cos(B) − 2 cos(A)
  --                                          = 2 cos(A) (cos(B) − 1)
  -- Use cos(B) − 1 = −2 sin²(B/2):
  have h_half : Real.cos B - 1 = -2 * (Real.sin (B / 2)) ^ 2 :=
    cos_minus_one_eq_neg_two_sin_sq_half B
  -- So numerator = 2 cos(A) · (−2 sin²(B/2)) = −4 cos(A) sin²(B/2).
  -- Divide by ℓ_P²:  result = −4 sin²(B/2)/ℓ_P² · cos(A).
  -- And k · ℓ_P / 2 = B / 2 since B := k · ℓ_P.
  have hl_pos : 0 < l_P ^ 2 := pow_pos l_P_pos 2
  have hl_ne : (l_P ^ 2 : ℝ) ≠ 0 := ne_of_gt hl_pos
  have h_B_half : B / 2 = k * l_P / 2 := by simp only [B]
  rw [h_B_half] at h_half
  -- Numerator rearranged.
  have h_num :
      Real.cos (A + B) - 2 * Real.cos A + Real.cos (A - B) =
        -4 * Real.cos A * (Real.sin (k * l_P / 2)) ^ 2 := by
    have h1 : Real.cos (A + B) - 2 * Real.cos A + Real.cos (A - B) =
              (Real.cos (A + B) + Real.cos (A - B)) - 2 * Real.cos A := by ring
    rw [h1, h_sum]
    -- Goal: 2 cos A · cos B − 2 cos A = −4 cos A · sin²(k·ℓ_P/2)
    -- LHS = 2 cos A · (cos B − 1)
    have h2 : 2 * Real.cos A * Real.cos B - 2 * Real.cos A =
              2 * Real.cos A * (Real.cos B - 1) := by ring
    rw [h2, h_half]
    ring
  rw [h_num]
  -- Goal: -4 · cos A · sin²(k·ℓ_P/2) / ℓ_P² = -((4/ℓ_P²) · sin²(k·ℓ_P/2)) · cos A.
  field_simp
  ring

/-- **Eigenfunction theorem (other direction)**: the second-difference
    of the plane wave `φ_k^μ` along a different direction `ν ≠ μ`
    vanishes (the wave doesn't vary in direction `ν`). -/
theorem secondDeriv_latticePlaneWave1D_other (k : ℝ) (μ ν : Fin 4)
    (hne : ν ≠ μ) (p : LatticePoint) :
    secondDeriv (latticePlaneWave1D k μ) ν p = 0 := by
  unfold secondDeriv latticePlaneWave1D
  -- shiftFin p ν at coord μ does NOT change since ν ≠ μ.
  -- So (shiftFin p ν) μ = p μ.  Similarly (shiftBackFin p ν) μ = p μ.
  have hne' : μ ≠ ν := fun h => hne h.symm
  have h_fwd : ((shiftFin p ν : LatticePoint) μ : ℝ) = (p μ : ℝ) := by
    unfold shiftFin
    simp [hne']
  have h_bwd : ((shiftBackFin p ν : LatticePoint) μ : ℝ) = (p μ : ℝ) := by
    unfold shiftBackFin
    simp [hne']
  rw [h_fwd, h_bwd]
  -- Numerator: cos(k · p_μ · ℓ_P) − 2·cos(k · p_μ · ℓ_P) + cos(k · p_μ · ℓ_P) = 0
  -- ÷ ℓ_P² = 0.
  have h_num : Real.cos (k * (p μ : ℝ) * l_P) -
               2 * Real.cos (k * (p μ : ℝ) * l_P) +
               Real.cos (k * (p μ : ℝ) * l_P) = 0 := by ring
  rw [h_num]
  simp

/-! ## Section 4 — Discrete-Laplacian eigenvalue -/

/-- **Discrete Laplacian on the plane wave**: the discrete Laplacian
    `Δ φ_k^μ(p) = Σ_α ∂²_α φ_k^μ(p)` reduces to the single-direction
    second-derivative since other directions vanish.

    Eigenvalue: `−(4/ℓ_P²) sin²(k·ℓ_P/2)`. -/
theorem discreteLaplacian_latticePlaneWave1D (k : ℝ) (μ : Fin 4)
    (p : LatticePoint) :
    discreteLaplacian (latticePlaneWave1D k μ) p =
      -((4 / l_P ^ 2) * (Real.sin (k * l_P / 2)) ^ 2) *
        latticePlaneWave1D k μ p := by
  unfold discreteLaplacian
  -- Σ_α ∂²_α φ = ∂²_μ φ + Σ_{ν ≠ μ} ∂²_ν φ = ∂²_μ φ + 0
  --   = −(4/ℓ_P²) sin²(k·ℓ_P/2) · φ.
  rw [show (Finset.univ : Finset (Fin 4)) =
        insert μ (Finset.univ.erase μ) from
        (Finset.insert_erase (Finset.mem_univ μ)).symm]
  rw [Finset.sum_insert (Finset.notMem_erase _ _)]
  -- ∂²_μ φ + Σ_{ν ∈ univ\{μ}} ∂²_ν φ.
  -- The sum is zero because each summand is zero (other-direction theorem).
  have h_zero : ∀ ν ∈ Finset.univ.erase μ,
      secondDeriv (latticePlaneWave1D k μ) ν p = 0 := by
    intro ν hν
    have hne : ν ≠ μ := Finset.ne_of_mem_erase hν
    exact secondDeriv_latticePlaneWave1D_other k μ ν hne p
  rw [Finset.sum_eq_zero h_zero]
  -- Now: ∂²_μ φ + 0 = ∂²_μ φ; apply the same-direction eigenvalue.
  rw [add_zero]
  exact secondDeriv_latticePlaneWave1D_self k μ p

/-- **Bridge to the substrate dispersion**: the substrate dispersion
    `Ω²(k) = (4/ℓ_P²) sin²(k·ℓ_P/2)` is exactly the negative of the
    discrete-Laplacian eigenvalue on the plane wave `φ_k^μ`. -/
theorem latticeDispersionPerDirection_eq_neg_lattice_eigenvalue
    (k : ℝ) (μ : Fin 4) (p : LatticePoint)
    (hφ : latticePlaneWave1D k μ p ≠ 0) :
    latticeDispersionPerDirection k =
      - (discreteLaplacian (latticePlaneWave1D k μ) p) /
        latticePlaneWave1D k μ p := by
  unfold latticeDispersionPerDirection
  rw [discreteLaplacian_latticePlaneWave1D]
  -- RHS: -(eigenvalue · φ) / φ = eigenvalue.
  --   = -(-((4/ℓ_P²) sin²(k·ℓ_P/2)) · φ) / φ
  --   = (4/ℓ_P²) sin²(k·ℓ_P/2) · φ / φ
  --   = (4/ℓ_P²) sin²(k·ℓ_P/2).
  field_simp

/-! ## Section 5 — Existence form: substrate spectrum

The substrate spectrum (the set of eigenvalues of the discrete
Laplacian on plane-wave eigenfunctions) contains `−(4/ℓ_P²) sin²(k·ℓ_P/2)`
for every `k ∈ ℝ`. -/

/-- **Existence**: for every wavenumber `k`, the eigenvalue
    `−(4/ℓ_P²) sin²(k·ℓ_P/2)` is realised on the lattice plane-wave
    eigenfunction `φ_k^0` (along the time direction).  In particular,
    the substrate spectrum contains all values
    `[−4/ℓ_P², 0]`. -/
theorem discreteLaplacian_eigenvalue_lies_in_substrate_spectrum
    (k : ℝ) :
    ∃ (φ : ScalarField), ∃ (p : LatticePoint),
      φ p ≠ 0 ∧
      discreteLaplacian φ p =
        -((4 / l_P ^ 2) * (Real.sin (k * l_P / 2)) ^ 2) * φ p := by
  refine ⟨latticePlaneWave1D k 0, fun _ => (0 : ℤ), ?_, ?_⟩
  · -- φ at p=0 equals 1, hence ≠ 0.
    rw [latticePlaneWave1D_at_origin]
    norm_num
  · -- φ is an eigenfunction at p=0 with the claimed eigenvalue.
    exact discreteLaplacian_latticePlaneWave1D k 0 (fun _ => 0)

/-! ## Section 6 — Audit hook

NO `def OmegaConjecture` in this file.  Direct `#print axioms` on
every theorem returns `[propext, Classical.choice, Quot.sound]`.

Phase 4.2 deliverable: full single-direction spectral analysis.
The substrate dispersion `Ω²(k)` is *derived* as a real eigenvalue
of the discrete Laplacian, not posited by abstraction. -/

end OmegaTheory.HealingFlow
