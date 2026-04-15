/-
  OmegaTheory.Irrationality.HermitePade.F50_Contour_Integral

  **Genuine Cauchy contour integral bound** for Attack 19 (Module 11).

  Sister file to `F50_Cauchy.lean`, which uses the Schwarz-aux shortcut.
  This file instead threads the proof through the *direct* contour
  argument: Cauchy's integral formula represents `f(z₀)` as a contour
  integral `(2πi)⁻¹ ∮_{|w|=r} f(w) / (w - z₀) dw`, and the standard
  ML-estimate on the integrand produces the bound.

  The file provides three levels of result, from pointwise estimate on
  the integrand, through the genuine Cauchy ML bound, to a version of
  the F50 decay bound proved *without* Schwarz.

  Byline: Norbert Marchewka and lean-cauchy.
-/

import Mathlib.Analysis.Complex.CauchyIntegral
import Mathlib.MeasureTheory.Integral.CircleIntegral

namespace OmegaTheory.Irrationality.HermitePade

open Complex Metric Set Filter Real
open scoped Topology

/--
**Reverse-triangle estimate on the contour integrand.**

On the circle `|w| = r` (with `0 ≤ |z₀| < r`), the integrand
`f(w) / (w - z₀)` is bounded pointwise by `M / (r - |z₀|)` whenever
`‖f w‖ ≤ M` on the circle.

This is the *main analytic content* of the Cauchy ML bound — the
ingredient that converts a supremum bound for `f` into a supremum
bound for the Cauchy kernel times `f`.
-/
theorem integrand_bound_on_sphere
    {r : ℝ} {z₀ : ℂ} {M : ℝ} {f : ℂ → ℂ}
    (_hrpos : 0 < r)
    (hz₀ : ‖z₀‖ < r)
    (hM : ∀ w ∈ sphere (0 : ℂ) r, ‖f w‖ ≤ M) :
    ∀ w ∈ sphere (0 : ℂ) r,
      ‖(w - z₀)⁻¹ • f w‖ ≤ M / (r - ‖z₀‖) := by
  intro w hw
  -- On the sphere |w - 0| = r, i.e., ‖w‖ = r.
  have hwnorm : ‖w‖ = r := by
    have hd : dist w (0 : ℂ) = r := mem_sphere.mp hw
    simpa [dist_zero_right] using hd
  -- Reverse triangle inequality: ‖w - z₀‖ ≥ ‖w‖ - ‖z₀‖ = r - ‖z₀‖.
  have hdenom_pos : 0 < r - ‖z₀‖ := sub_pos.mpr hz₀
  have hrev : r - ‖z₀‖ ≤ ‖w - z₀‖ := by
    have hnsub := norm_sub_norm_le w z₀
    -- ‖w‖ - ‖z₀‖ ≤ ‖w - z₀‖
    have : r - ‖z₀‖ = ‖w‖ - ‖z₀‖ := by rw [hwnorm]
    linarith
  have hsub_pos : 0 < ‖w - z₀‖ := lt_of_lt_of_le hdenom_pos hrev
  -- Norm bound on f.
  have hfM : ‖f w‖ ≤ M := hM w hw
  have hMnn : 0 ≤ M := le_trans (norm_nonneg _) hfM
  -- Main calculation.
  have hnorm_calc :
      ‖(w - z₀)⁻¹ • f w‖ = ‖f w‖ / ‖w - z₀‖ := by
    rw [norm_smul, norm_inv]
    ring
  rw [hnorm_calc]
  -- Numerator bound: ‖f w‖ ≤ M.
  -- Denominator bound: ‖w - z₀‖ ≥ r - ‖z₀‖ > 0.
  -- Conclusion: ‖f w‖ / ‖w - z₀‖ ≤ M / (r - ‖z₀‖).
  rw [div_le_div_iff₀ hsub_pos hdenom_pos]
  have h1 : ‖f w‖ * (r - ‖z₀‖) ≤ M * (r - ‖z₀‖) :=
    mul_le_mul_of_nonneg_right hfM hdenom_pos.le
  have h2 : M * (r - ‖z₀‖) ≤ M * ‖w - z₀‖ :=
    mul_le_mul_of_nonneg_left hrev hMnn
  linarith

/--
**Cauchy integral representation.**

If `f : ℂ → ℂ` is differentiable on the closed disc of radius `r`
around the origin, and `|z₀| < r`, then Cauchy's formula gives
`f(z₀) = (2πi)⁻¹ · ∮_{|w|=r} f(w)/(w - z₀) dw`.

This is a thin wrapper around `DifferentiableOn.circleIntegral_sub_inv_smul`
specialised to centre `0`.
-/
theorem cauchy_representation
    {r : ℝ} {z₀ : ℂ} {f : ℂ → ℂ}
    (hd : DifferentiableOn ℂ f (closedBall (0 : ℂ) r))
    (hz₀ : z₀ ∈ ball (0 : ℂ) r) :
    ((2 * π * I : ℂ)⁻¹ • ∮ w in C((0 : ℂ), r), (w - z₀)⁻¹ • f w) = f z₀ := by
  have hformula := hd.circleIntegral_sub_inv_smul (w := z₀) hz₀
  -- hformula : (∮ w in C(0, r), (w - z₀)⁻¹ • f w) = (2πi) • f z₀
  rw [hformula]
  have h2πi : (2 * π * I : ℂ) ≠ 0 := by
    simp [Real.pi_ne_zero, I_ne_zero]
  -- Now need to prove: (2πi)⁻¹ • (2πi) • f z₀ = f z₀
  rw [smul_smul, inv_mul_cancel₀ h2πi, one_smul]

/--
**Genuine Cauchy ML bound.**

For `f : ℂ → ℂ` differentiable on the closed disc `|z| ≤ r`, with
`‖f w‖ ≤ M` on the boundary circle `|w| = r`, the value `f(z₀)` in
the open disc is bounded by the contour ML estimate:
`‖f z₀‖ ≤ M · r / (r - ‖z₀‖)`.

This is the *direct* contour bound — no Schwarz lemma, no
hypothesis on the vanishing order of `f`. The proof consists of
Cauchy's integral formula plus the ML estimate on the contour.
-/
theorem cauchy_ML_bound
    {r M : ℝ} {z₀ : ℂ} {f : ℂ → ℂ}
    (hrpos : 0 < r)
    (hMnn : 0 ≤ M)
    (hd : DifferentiableOn ℂ f (closedBall (0 : ℂ) r))
    (hM : ∀ w ∈ sphere (0 : ℂ) r, ‖f w‖ ≤ M)
    (hz₀ : z₀ ∈ ball (0 : ℂ) r) :
    ‖f z₀‖ ≤ M * r / (r - ‖z₀‖) := by
  -- |z₀| < r.
  have hz₀norm : ‖z₀‖ < r := by
    have hd0 : dist z₀ (0 : ℂ) < r := mem_ball.mp hz₀
    simpa [dist_zero_right] using hd0
  -- ML estimate on the Cauchy kernel integrand.
  have hML :
      ‖∮ w in C((0 : ℂ), r), (w - z₀)⁻¹ • f w‖
        ≤ 2 * π * r * (M / (r - ‖z₀‖)) := by
    refine circleIntegral.norm_integral_le_of_norm_le_const hrpos.le ?_
    intro w hw
    exact integrand_bound_on_sphere hrpos hz₀norm hM w hw
  -- Cauchy formula: f z₀ = (2πi)⁻¹ • ∮ (w - z₀)⁻¹ • f w dw.
  have hformula : f z₀ = (2 * π * I : ℂ)⁻¹ • ∮ w in C((0 : ℂ), r), (w - z₀)⁻¹ • f w := by
    rw [← cauchy_representation hd hz₀]
  -- Convert the ML bound to a bound on f z₀ via the (2π) factor.
  rw [hformula, norm_smul]
  have hnorm_inv : ‖(2 * π * I : ℂ)⁻¹‖ = (2 * π)⁻¹ := by
    rw [norm_inv]
    simp [Real.pi_pos.le]
  rw [hnorm_inv]
  have h2pipos : 0 < 2 * π := Real.two_pi_pos
  have hdenom_pos : 0 < r - ‖z₀‖ := sub_pos.mpr hz₀norm
  have hMdiv : 0 ≤ M / (r - ‖z₀‖) := div_nonneg hMnn hdenom_pos.le
  -- Apply ML to the scaled norm.
  calc
    (2 * π)⁻¹ * ‖∮ w in C((0 : ℂ), r), (w - z₀)⁻¹ • f w‖
        ≤ (2 * π)⁻¹ * (2 * π * r * (M / (r - ‖z₀‖))) := by
          apply mul_le_mul_of_nonneg_left hML
          exact inv_nonneg.mpr h2pipos.le
    _ = r * (M / (r - ‖z₀‖)) := by
          have hne : (2 * π) ≠ 0 := ne_of_gt h2pipos
          field_simp
    _ = M * r / (r - ‖z₀‖) := by
          rw [mul_div_assoc]; ring

/--
**F50 Cauchy-contour decay bound.**

If `f` is analytic on the closed disc of radius `r`, bounded by `M` on
the boundary, and vanishes to order ≥ `N` at the origin (so that the
auxiliary function `g(w) = f(w)/w^N` extends analytically and is also
bounded by `M/r^N` on the boundary), then applying the Cauchy ML
bound to `g` and multiplying by `|z₀|^N` gives
`‖f z₀‖ ≤ M · (|z₀|/r)^N · r/(r - |z₀|)`.

We state here the cleaner *rationalised* form, which is what is used
in Attack 19's contour argument:
`(r - |z₀|) · ‖f z₀‖ ≤ M · r · (|z₀|/r)^N`
is an immediate rearrangement and avoids a division.

The dependence on the vanishing order is *packaged* into the input
hypothesis `hauxM`, which gives the supremum bound on the auxiliary
function `f(w)/w^N` — this matches how the bound is applied in
`F52_P3_Rescue` and downstream modules.
-/
theorem cauchy_decay_rationalised
    {r M : ℝ} {z₀ : ℂ} (N : ℕ) {f g : ℂ → ℂ}
    (hrpos : 0 < r)
    (hMnn : 0 ≤ M)
    (hgd : DifferentiableOn ℂ g (closedBall (0 : ℂ) r))
    (hauxM : ∀ w ∈ sphere (0 : ℂ) r, ‖g w‖ ≤ M / r ^ N)
    (hrel : ∀ w, w ≠ 0 → f w = w ^ N * g w)
    (hz₀ : z₀ ∈ ball (0 : ℂ) r)
    (hz₀ne : z₀ ≠ 0) :
    ‖f z₀‖ * (r - ‖z₀‖) ≤ M * (‖z₀‖ / r) ^ N * r := by
  have hz₀norm : ‖z₀‖ < r := by
    have hd0 : dist z₀ (0 : ℂ) < r := mem_ball.mp hz₀
    simpa [dist_zero_right] using hd0
  have hrN_pos : 0 < r ^ N := pow_pos hrpos N
  have hrN_ne : r ^ N ≠ 0 := ne_of_gt hrN_pos
  have hMrN_nn : 0 ≤ M / r ^ N := div_nonneg hMnn hrN_pos.le
  have hz₀nn : 0 ≤ ‖z₀‖ := norm_nonneg _
  have hz₀N_nn : 0 ≤ ‖z₀‖ ^ N := pow_nonneg hz₀nn N
  have hdenom_pos : 0 < r - ‖z₀‖ := sub_pos.mpr hz₀norm
  -- Apply Cauchy ML bound to `g` with auxiliary bound `M / r^N`.
  have hg_bound : ‖g z₀‖ ≤ M / r ^ N * r / (r - ‖z₀‖) :=
    cauchy_ML_bound hrpos hMrN_nn hgd hauxM hz₀
  -- Convert via f z₀ = z₀^N * g z₀.
  have hfeq : f z₀ = z₀ ^ N * g z₀ := hrel z₀ hz₀ne
  have hf_norm : ‖f z₀‖ = ‖z₀‖ ^ N * ‖g z₀‖ := by
    rw [hfeq, norm_mul, norm_pow]
  -- Multiply the bound on ‖g z₀‖ by ‖z₀‖^N.
  have hstep : ‖z₀‖ ^ N * ‖g z₀‖ ≤ ‖z₀‖ ^ N * (M / r ^ N * r / (r - ‖z₀‖)) :=
    mul_le_mul_of_nonneg_left hg_bound hz₀N_nn
  -- Multiply by (r - ‖z₀‖).
  have hstep' :
      ‖z₀‖ ^ N * ‖g z₀‖ * (r - ‖z₀‖)
        ≤ ‖z₀‖ ^ N * (M / r ^ N * r / (r - ‖z₀‖)) * (r - ‖z₀‖) :=
    mul_le_mul_of_nonneg_right hstep hdenom_pos.le
  -- Simplify the RHS: the (r - ‖z₀‖) factors cancel.
  have hne_denom : (r - ‖z₀‖) ≠ 0 := ne_of_gt hdenom_pos
  have hrhs_eq :
      ‖z₀‖ ^ N * (M / r ^ N * r / (r - ‖z₀‖)) * (r - ‖z₀‖)
        = M * (‖z₀‖ / r) ^ N * r := by
    rw [div_pow]
    field_simp
  rw [hf_norm, ← hrhs_eq]
  exact hstep'

end OmegaTheory.Irrationality.HermitePade
