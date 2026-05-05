/-
  OmegaTheory.Predictions.SubstrateDispersion

  **Lion's-Pride Phase 3.2 of the honest graviton-energy plan.**

  Closes inventory gap §D.iv (dispersion side): the substrate's
  lattice second-derivative `secondDeriv f μ p` acts on plane waves
  with eigenvalue `-(4/ℓ_P²) · sin²(k·ℓ_P/2)`, giving the
  characteristic lattice dispersion
      `Ω²(k) = (4/ℓ_P²) · sin²(k·ℓ_P/2)`
  per direction, summed over 4 spacetime indices for the full
  dispersion of the substrate's d'Alembertian.

  ## What this file proves

  Tier-A — the dispersion function and its bounds:

  * `latticeDispersionPerDirection k` — `(4/ℓ_P²) · sin²(k·ℓ_P/2)`,
    the per-direction eigenvalue (in absolute value) of `secondDeriv`
    on a plane wave with wavevector `k`.

  * `latticeDispersionPerDirection_nonneg` — non-negativity (sum of
    squares).

  * `latticeDispersionPerDirection_zero` — vanishes at `k = 0`.

  * **`latticeDispersionPerDirection_le_k_sq`** — the **headline IR bound**:
        `(4/ℓ_P²) · sin²(k·ℓ_P/2) ≤ k²`
    for ALL real k.  Proof: `|sin x| ≤ |x|` (Mathlib
    `Real.abs_sin_le_abs`), hence `sin²(x) ≤ x²`, with `x = k·ℓ_P/2`.

    This says the substrate dispersion is bounded above by the
    continuum dispersion `c² k²` (after dimensional adjustment).
    The lattice never produces "more energy per mode" than the
    continuum at the same wavenumber — UV regularisation.

  * **`latticeDispersionPerDirection_le_uv`** — the **UV ceiling**:
        `(4/ℓ_P²) · sin²(k·ℓ_P/2) ≤ 4/ℓ_P²`
    for ALL real k.  Proof: `sin²(x) ≤ 1`.  This says the
    substrate enforces a Planck-scale UV cutoff: no mode has
    eigenvalue exceeding `4/ℓ_P²`.

  Tier-B — full 4D dispersion via summation:

  * `latticeFullDispersionSpatial k1 k2 k3` — spatial part:
    `Σ_{i=1,2,3} latticeDispersionPerDirection(k_i)`.

  * `latticeFullDispersionSpatial_le_k_sq_sum` — IR bound on the
    spatial part: `≤ k1² + k2² + k3² = |k|²`.

  * `latticeFullDispersionSpatial_le_3uv` — UV ceiling: `≤ 12/ℓ_P²`.

  * `latticeFullDispersionSpatial_nonneg`.

  ## What this file does NOT prove

  * The detailed Taylor-series IR expansion `(4/ℓ_P²) sin²(k·ℓ_P/2) ≈
    k² · (1 - (k·ℓ_P)²/12 + ...)` — defers to
    `Predictions/IRUVDecomposition.lean` (Phase 3.3).
  * The connection to the d'Alembertian eigenvalue equation on
    *concrete* plane-wave fields — defers to a sister theorem
    that uses `secondDeriv f μ p` directly with a `Real.cos`
    plane wave.  The bounds here are sufficient for the Phase-4
    spectral upper-bound argument, which only needs the UV ceiling.

  ## Citations

  * Smolin, *Three Roads to Quantum Gravity* (2001), §3
    — lattice-Laplacian dispersion in discrete-gravity proposals.
  * Susskind-Wilson, lattice gauge theory introduction
    — `(2/a) sin(k·a/2)` per-direction lattice momentum.

  -- Lion's-Pride Phase 3.2, 2026-05-05.
-/

import OmegaTheory.Spacetime.Constants
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Bounds

namespace OmegaTheory.Predictions

open OmegaTheory.Spacetime
open Real

/-! ## Section 1 — The per-direction lattice dispersion -/

/-- **Per-direction lattice dispersion** at wavevector component `k`.

    The substrate's `secondDeriv f μ p` acts on a plane wave
    `f(p) = cos(k·ℓ_P·p)` with eigenvalue
        `λ(k) = (cos(k·ℓ_P) - 1) · 2 / ℓ_P²
              = -(4/ℓ_P²) · sin²(k·ℓ_P/2)`
    (using `1 - cos θ = 2 sin²(θ/2)`).

    The **dispersion function** `Ω²(k)` is the absolute eigenvalue,
    representing the squared frequency contribution per direction
    of the substrate's wave operator. -/
noncomputable def latticeDispersionPerDirection (k : ℝ) : ℝ :=
  (4 / l_P ^ 2) * (Real.sin (k * l_P / 2)) ^ 2

theorem latticeDispersionPerDirection_nonneg (k : ℝ) :
    0 ≤ latticeDispersionPerDirection k := by
  unfold latticeDispersionPerDirection
  apply mul_nonneg
  · apply div_nonneg (by norm_num : (0 : ℝ) ≤ 4)
    exact sq_nonneg l_P
  · exact sq_nonneg _

theorem latticeDispersionPerDirection_zero :
    latticeDispersionPerDirection 0 = 0 := by
  unfold latticeDispersionPerDirection
  simp

/-! ## Section 2 — Helper: sin²(x) ≤ x² -/

/-- For any real `x`, `sin² x ≤ x²`.

    Proof: `|sin x| ≤ |x|` (Mathlib `Real.abs_sin_le_abs`),
    so `(sin x)² = |sin x|² ≤ |x|² = x²`. -/
theorem sin_sq_le_sq (x : ℝ) : (Real.sin x) ^ 2 ≤ x ^ 2 := by
  have habs : |Real.sin x| ≤ |x| := Real.abs_sin_le_abs
  -- Square both sides (both non-negative since absolute values).
  have hpow : |Real.sin x| ^ 2 ≤ |x| ^ 2 :=
    pow_le_pow_left₀ (abs_nonneg _) habs 2
  rw [sq_abs, sq_abs] at hpow
  exact hpow

/-! ## Section 3 — The IR bound: dispersion ≤ k² -/

/-- **IR bound** (the headline for the Phase-3 substrate-dispersion result):
    `(4/ℓ_P²) · sin²(k·ℓ_P/2) ≤ k²`.

    Proof: by `sin_sq_le_sq` with argument `x = k·ℓ_P/2`,
    `sin²(k·ℓ_P/2) ≤ (k·ℓ_P/2)² = k²·ℓ_P²/4`.  Multiplying by
    `4/ℓ_P²` gives `(4/ℓ_P²) · sin²(...) ≤ k²`. -/
theorem latticeDispersionPerDirection_le_k_sq (k : ℝ) :
    latticeDispersionPerDirection k ≤ k ^ 2 := by
  unfold latticeDispersionPerDirection
  -- Step 1: sin²(k·ℓ_P/2) ≤ (k·ℓ_P/2)².
  have hsin_le : (Real.sin (k * l_P / 2)) ^ 2 ≤ (k * l_P / 2) ^ 2 :=
    sin_sq_le_sq _
  -- Step 2: multiply both sides by (4/ℓ_P²) ≥ 0.
  have hfac_nonneg : 0 ≤ 4 / l_P ^ 2 :=
    div_nonneg (by norm_num) (sq_nonneg _)
  have h1 : (4 / l_P ^ 2) * (Real.sin (k * l_P / 2)) ^ 2 ≤
            (4 / l_P ^ 2) * (k * l_P / 2) ^ 2 :=
    mul_le_mul_of_nonneg_left hsin_le hfac_nonneg
  -- Step 3: simplify (4/ℓ_P²) · (k·ℓ_P/2)² to k².
  have hl : l_P ≠ 0 := l_P_ne_zero
  have hsimp : (4 / l_P ^ 2) * (k * l_P / 2) ^ 2 = k ^ 2 := by
    field_simp
    ring
  linarith [hsimp ▸ h1]

/-! ## Section 4 — The UV ceiling -/

/-- `sin²(x) ≤ 1` for all real `x`. -/
theorem sin_sq_le_one (x : ℝ) : (Real.sin x) ^ 2 ≤ 1 := by
  have habs : |Real.sin x| ≤ 1 := Real.abs_sin_le_one x
  have hpow : |Real.sin x| ^ 2 ≤ 1 ^ 2 :=
    pow_le_pow_left₀ (abs_nonneg _) habs 2
  rw [sq_abs] at hpow
  simpa using hpow

/-- **UV ceiling**: `latticeDispersionPerDirection k ≤ 4/ℓ_P²`
    for all real `k`. -/
theorem latticeDispersionPerDirection_le_uv (k : ℝ) :
    latticeDispersionPerDirection k ≤ 4 / l_P ^ 2 := by
  unfold latticeDispersionPerDirection
  have hsin_le := sin_sq_le_one (k * l_P / 2)
  have hfac_nonneg : 0 ≤ 4 / l_P ^ 2 :=
    div_nonneg (by norm_num) (sq_nonneg _)
  calc (4 / l_P ^ 2) * (Real.sin (k * l_P / 2)) ^ 2
      ≤ (4 / l_P ^ 2) * 1 := mul_le_mul_of_nonneg_left hsin_le hfac_nonneg
    _ = 4 / l_P ^ 2 := by ring

/-! ## Section 5 — Full 4D spatial dispersion -/

/-- **Full spatial lattice dispersion**: sum over the 3 spatial
    directions of the per-direction dispersion. -/
noncomputable def latticeFullDispersionSpatial (k1 k2 k3 : ℝ) : ℝ :=
  latticeDispersionPerDirection k1 +
    latticeDispersionPerDirection k2 +
    latticeDispersionPerDirection k3

theorem latticeFullDispersionSpatial_nonneg (k1 k2 k3 : ℝ) :
    0 ≤ latticeFullDispersionSpatial k1 k2 k3 := by
  unfold latticeFullDispersionSpatial
  have h1 := latticeDispersionPerDirection_nonneg k1
  have h2 := latticeDispersionPerDirection_nonneg k2
  have h3 := latticeDispersionPerDirection_nonneg k3
  linarith

theorem latticeFullDispersionSpatial_zero :
    latticeFullDispersionSpatial 0 0 0 = 0 := by
  unfold latticeFullDispersionSpatial latticeDispersionPerDirection
  simp

/-- **IR bound on full spatial dispersion**: `≤ k1² + k2² + k3² = |k|²`.

    The substrate's spatial dispersion is bounded above by the
    continuum spatial dispersion at the same wavevector. -/
theorem latticeFullDispersionSpatial_le_k_sq_sum (k1 k2 k3 : ℝ) :
    latticeFullDispersionSpatial k1 k2 k3 ≤ k1 ^ 2 + k2 ^ 2 + k3 ^ 2 := by
  unfold latticeFullDispersionSpatial
  have h1 := latticeDispersionPerDirection_le_k_sq k1
  have h2 := latticeDispersionPerDirection_le_k_sq k2
  have h3 := latticeDispersionPerDirection_le_k_sq k3
  linarith

/-- **UV ceiling on full spatial dispersion**: `≤ 12/ℓ_P²`.

    Three directions, each with UV ceiling `4/ℓ_P²`, give the
    Planck-scale UV cutoff for the spatial part of the substrate
    wave operator. -/
theorem latticeFullDispersionSpatial_le_3uv (k1 k2 k3 : ℝ) :
    latticeFullDispersionSpatial k1 k2 k3 ≤ 12 / l_P ^ 2 := by
  unfold latticeFullDispersionSpatial
  have h1 := latticeDispersionPerDirection_le_uv k1
  have h2 := latticeDispersionPerDirection_le_uv k2
  have h3 := latticeDispersionPerDirection_le_uv k3
  -- Sum the three: 3 · (4/l_P²) = 12/l_P².
  have hsum : (4 : ℝ) / l_P ^ 2 + 4 / l_P ^ 2 + 4 / l_P ^ 2 = 12 / l_P ^ 2 := by
    have hl : l_P ^ 2 ≠ 0 := ne_of_gt (sq_pos_of_pos l_P_pos)
    field_simp
    ring
  linarith

/-! ## Section 6 — Audit hook

NO `def OmegaConjecture` in this file.  All declarations are real
trigonometric / algebraic inequalities derived from Mathlib's
`Real.abs_sin_le_abs` (classical `|sin x| ≤ |x|`) and `Real.abs_sin_le_one`
(`|sin x| ≤ 1`).

Direct `#print axioms` on every theorem returns
`[propext, Classical.choice, Quot.sound]`. -/

end OmegaTheory.Predictions
