/-
  OmegaTheory.Foundations.YukawaHeatKernelExpansion

  **Lion's-Pride Phase 6.5h (2026-05-06)**:
  *Explicit truncated heat-trace expansion of the Yukawa spectral
  triple — the finite-dim version of the Chamseddine-Connes spectral-
  action heat-kernel asymptotic at large cutoff Λ.*

  ## Why this file

  The Connes-Chamseddine spectral action `S = Tr(f(D/Λ))` for smooth
  cutoff f admits, at large Λ, the heat-kernel asymptotic:

      S(D, Λ, f)  ~  Σ_k f_k · Λ^{d-k} · ∫ a_k(D²)        (continuum)

  where `a_k` are the Seeley-DeWitt coefficients (heat-kernel
  asymptotic).  In FINITE DIMENSIONS, the trace `Tr(e^{-tD²})` has
  the Taylor series

      Tr(e^{-tD²})  =  Σ_k (-t)^k / k! · Tr(D^{2k})        (formal Taylor)
                    =  Σ_k (-t)^k / k! · a_k(D²)

  which is EXACT in finite dim (no asymptotic approximation needed,
  the series converges for all t : ℂ).  In Phase 6.4 we shipped
  `truncatedHeatTrace T N t` as the partial sum.

  This file specialises that partial sum to the YUKAWA SPECTRAL
  TRIPLE, where the heat-kernel coefficients reduce to Yukawa power
  sums (Phase 6.5a):

      a_0(yukawaSpectralTriple) = n         (fermion d.o.f.)
      a_1(yukawaSpectralTriple) = Σᵢ y_i²    (Yukawa-square sum)
      a_2(yukawaSpectralTriple) = Σᵢ y_i⁴    (Yukawa-fourth sum)
      a_k(yukawaSpectralTriple) = Σᵢ y_i^{2k} (general)

  Hence at order N:

      truncatedHeatTrace (yukawaSpectralTriple h y) N t
        = Σ_{k=0..N} (-t)^k / k! · Σᵢ y_i^{2k}

  The first three terms give the finite-dim version of the
  Chamseddine-Connes spectral-action asymptotic:

      Tr(e^{-tD_F²})  ≈  n  −  t·(Σ y_i²)  +  t²/2·(Σ y_i⁴)  −  ...

  Setting `t := 1/Λ²` and identifying the substrate UV cutoff
  `Λ_substrate² := 4/ℓ_P²` (from `IRUVDecomposition`) recovers the
  ChamseddineConnes Higgs-mass-squared scaling:

      m_H²(D_F, Λ)  ∝  (Σ y_i²) / Λ²

  ## What this file ships

  | Property                                                | Theorem                                    |
  |---------------------------------------------------------|--------------------------------------------|
  | `truncHeatTrace_yukawa N=0`: `Σ → n`                     | `truncHeatTrace_yukawa_zero`               |
  | `truncHeatTrace_yukawa N=1`: `n − t·Σy²`                 | `truncHeatTrace_yukawa_one`                |
  | `truncHeatTrace_yukawa N=2`: `n − t·Σy² + t²/2·Σy⁴`      | `truncHeatTrace_yukawa_two`                |
  | General formula for any N                                | `truncHeatTrace_yukawa_eq_yukawa_moments`  |
  | Headline 4-conjunct                                      | `yukawa_heat_kernel_expansion_report`      |

  ## Honest scope

  This file ships ONLY the FINITE-DIM truncated-Taylor specialisation
  to Yukawa eigenvalues.  It does NOT ship:

  * The CONTINUUM heat-kernel asymptotic for an actual smooth cutoff
    function (multi-month Vassilevich port for general dimension d).
  * The IDENTIFICATION `t = 1/Λ²` for a specific physical Λ (model
    choice, depends on UV cutoff).
  * Convergence of the full Taylor series as N → ∞ (in finite dim
    this is automatic for `Tr(e^{-tD²})` with bounded D, but requires
    Mathlib's `Matrix.exp` chain to invoke; deferred).

  What it DOES ship: the rigorous algebraic identity at finite N.

  ## Lion's-Pride doctrine applied

  Rule 1: zero `sorry`.  Rule 2: zero new axioms.
  Pure composition via Phase 6.4 truncatedHeatTrace + Phase 6.5a
  yukawaSpectralTriple_ak_eq_sum_pow.  No abstraction towers.

  ## Author

  Lion's-Pride dynamic /loop iteration (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.
-/

import OmegaTheory.Foundations.SpectralActionTruncated
import OmegaTheory.Foundations.YukawaDirac
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.YukawaHeatKernelExpansion

open OmegaTheory.Foundations.FiniteSpectralTriple
open OmegaTheory.Foundations.HeatKernelCoefficients
open OmegaTheory.Foundations.SpectralActionTruncated
open OmegaTheory.Foundations.YukawaDirac

/-! ## 1. Truncated heat trace at order 0 = n -/

/-- **Truncated heat trace at order 0 of yukawaSpectralTriple = n**
    (fermion d.o.f.).  Independent of Yukawa values. -/
theorem truncHeatTrace_yukawa_zero
    {n : ℕ} (h : 0 < n) (y : Fin n → ℝ) (t : ℂ) :
    truncatedHeatTrace (yukawaSpectralTriple h y) 0 t = (n : ℂ) := by
  unfold truncatedHeatTrace
  rw [Finset.sum_range_one]
  simp [Nat.factorial]
  exact yukawaSpectralTriple_a0 h y

/-! ## 2. Truncated heat trace at order 1 = n − t·(Σ y_i²) -/

/-- **Truncated heat trace at order 1 of yukawaSpectralTriple**:
    `truncatedHeatTrace T 1 t = n − t · (Σᵢ y_i²)`. -/
theorem truncHeatTrace_yukawa_one
    {n : ℕ} (h : 0 < n) (y : Fin n → ℝ) (t : ℂ) :
    truncatedHeatTrace (yukawaSpectralTriple h y) 1 t
      = (n : ℂ) - t * ∑ i : Fin n, ((y i : ℂ)) ^ 2 := by
  rw [truncatedHeatTrace_succ, truncHeatTrace_yukawa_zero h y t]
  rw [yukawaSpectralTriple_a1 h y]
  simp [Nat.factorial]
  ring

/-! ## 3. Truncated heat trace at order 2 = n − t·(Σ y²) + t²/2·(Σ y⁴) -/

/-- **Truncated heat trace at order 2 of yukawaSpectralTriple**:
    `truncatedHeatTrace T 2 t = n − t·(Σᵢ y_i²) + t²/2·(Σᵢ y_i⁴)`. -/
theorem truncHeatTrace_yukawa_two
    {n : ℕ} (h : 0 < n) (y : Fin n → ℝ) (t : ℂ) :
    truncatedHeatTrace (yukawaSpectralTriple h y) 2 t
      = (n : ℂ) - t * (∑ i : Fin n, ((y i : ℂ)) ^ 2)
                + t ^ 2 / 2 * (∑ i : Fin n, ((y i : ℂ)) ^ 4) := by
  rw [show (2 : ℕ) = 1 + 1 from rfl]
  rw [truncatedHeatTrace_succ, truncHeatTrace_yukawa_one h y t]
  rw [yukawaSpectralTriple_a2 h y]
  simp [Nat.factorial]

/-! ## 4. General formula via Phase 6.5a yukawaSpectralTriple_ak

    For any N : ℕ, the truncated heat trace expands as the partial
    sum of Yukawa power moments. -/

/-- **General formula**: `truncatedHeatTrace (yukawaSpectralTriple h y) N t
    = Σ_{k=0..N} (-t)^k / k! · (Σᵢ y_i^(2k))`. -/
theorem truncHeatTrace_yukawa_eq_yukawa_moments
    {n : ℕ} (h : 0 < n) (y : Fin n → ℝ) (N : ℕ) (t : ℂ) :
    truncatedHeatTrace (yukawaSpectralTriple h y) N t
      = ∑ k ∈ Finset.range (N + 1),
          (-t) ^ k / (Nat.factorial k : ℂ)
            * (∑ i : Fin n, ((y i : ℂ)) ^ (2 * k)) := by
  unfold truncatedHeatTrace
  apply Finset.sum_congr rfl
  intros k _
  rw [yukawaDirac_ak_eq_sum_pow h y k]

/-! ## 5. Headline composite report -/

/-- **Lion's-Pride Phase 6.5h headline — Yukawa heat-kernel
    expansion report.**

    For Yukawa eigenvalues `y : Fin n → ℝ` (with `0 < n`) and a
    fluctuation parameter `t : ℂ`:

    1. **Order 0 (vacuum)**: `truncHeatTrace_yukawa N=0 = n`.

    2. **Order 1 (Yukawa-mass scale)**:
       `truncHeatTrace_yukawa N=1 = n − t·(Σᵢ y_i²)`.

    3. **Order 2 (Higgs quartic scale)**:
       `truncHeatTrace_yukawa N=2 = n − t·(Σᵢ y_i²) + t²/2·(Σᵢ y_i⁴)`.

    4. **General N**: partial sum of Yukawa-power moments
       `truncHeatTrace_yukawa N = Σ_{k=0..N} (-t)^k/k! · (Σᵢ y_i^{2k})`.

    Setting `t := 1/Λ²` (substrate UV cutoff) recovers the
    Chamseddine-Connes Higgs mass-squared scaling
    `m_H²(D_F, Λ) ∝ (Σ y_i²)/Λ²` from the leading t-coefficient. -/
theorem yukawa_heat_kernel_expansion_report
    {n : ℕ} (h : 0 < n) (y : Fin n → ℝ) (t : ℂ) :
    truncatedHeatTrace (yukawaSpectralTriple h y) 0 t = (n : ℂ) ∧
    truncatedHeatTrace (yukawaSpectralTriple h y) 1 t
      = (n : ℂ) - t * ∑ i : Fin n, ((y i : ℂ)) ^ 2 ∧
    truncatedHeatTrace (yukawaSpectralTriple h y) 2 t
      = (n : ℂ) - t * (∑ i : Fin n, ((y i : ℂ)) ^ 2)
                + t ^ 2 / 2 * (∑ i : Fin n, ((y i : ℂ)) ^ 4) ∧
    (∀ N : ℕ, truncatedHeatTrace (yukawaSpectralTriple h y) N t
      = ∑ k ∈ Finset.range (N + 1),
          (-t) ^ k / (Nat.factorial k : ℂ)
            * (∑ i : Fin n, ((y i : ℂ)) ^ (2 * k))) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact truncHeatTrace_yukawa_zero h y t
  · exact truncHeatTrace_yukawa_one h y t
  · exact truncHeatTrace_yukawa_two h y t
  · intro N; exact truncHeatTrace_yukawa_eq_yukawa_moments h y N t

end OmegaTheory.Foundations.YukawaHeatKernelExpansion
