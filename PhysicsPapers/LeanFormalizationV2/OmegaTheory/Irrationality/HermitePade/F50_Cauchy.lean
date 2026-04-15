/-
  OmegaTheory.Irrationality.HermitePade.F50_Cauchy

  Cauchy contour form of the F50 decay bound for Attack 19 (Module 11).

  Companion to `F50_Decay.lean` (Taylor-tail form). Uses the
  Schwarz-Pick style machinery from Mathlib's
  `Mathlib.Analysis.Complex.Schwarz` to give the multiplicative Cauchy
  estimate `‖f z‖ ≤ M (‖z‖/R)^N` for analytic `f : ℂ → ℂ` vanishing to
  order ≥ N at 0.

  Byline: Norbert Marchewka and Rigel.
-/

import Mathlib.Analysis.Complex.Schwarz

namespace OmegaTheory.Irrationality.HermitePade

open Complex Metric Set Filter Asymptotics

/--
**F50 Cauchy bound (Schwarz-aux form).**

If `f : ℂ → ℂ` is differentiable on the open disc of radius `R` around
0, maps that disc into the closed disc of radius `M`, vanishes at 0,
and has `f` = o((·)^(N-1)) at 0, then for every `z` in the open disc:
`‖f z‖ ≤ M · (‖z‖/R)^N`.

This is a direct corollary of `Complex.schwarz_aux`.
-/
theorem cauchy_bound_order_ge
    {f : ℂ → ℂ} {R M : ℝ} {N : ℕ}
    (hN : 1 ≤ N)
    (hdiff : DifferentiableOn ℂ f (ball (0 : ℂ) R))
    (hmaps : MapsTo f (ball (0 : ℂ) R) (closedBall (0 : ℂ) M))
    (hf0 : f 0 = 0)
    (hvanish : f =o[𝓝 (0 : ℂ)] (fun w => w ^ (N - 1)))
    {z : ℂ} (hz : z ∈ ball (0 : ℂ) R) :
    ‖f z‖ ≤ M * (‖z‖ / R) ^ N := by
  set n := N - 1 with hn_def
  have hNn : N = n + 1 := by
    omega
  -- rewrite hypotheses in terms of `n` and the centre `c = 0`
  have hz' : z - 0 ∈ ball (0 : ℂ) R := by simpa using hz
  have hvanish' : (fun w => f (w + 0) - f 0) =o[𝓝 (0 : ℂ)] (fun w => w ^ n) := by
    simpa [hf0] using hvanish
  have := Complex.schwarz_aux (c := (0 : ℂ)) (n := n)
            (hd := by simpa using hdiff)
            (hz := hz')
            (hd' := by
              -- MapsTo f (ball 0 R) (closedBall 0 M); schwarz_aux asks
              -- for f(ball c R) ⊆ closedBall (f c) M after recentring,
              -- which coincides with our `hmaps` since c = 0 and f 0 = 0.
              simpa [hf0] using hmaps)
            (hf0' := by simpa [hf0] using hvanish')
  -- `schwarz_aux` gives `‖f (z + 0) - f 0‖ ≤ M / R ^ (n+1) * ‖z‖ ^ (n+1)`
  -- We rewrite to match our goal.
  calc ‖f z‖
      = ‖f (z + 0) - f 0‖ := by simp [hf0]
    _ ≤ M / R ^ (n + 1) * ‖z‖ ^ (n + 1) := this
    _ = M * (‖z‖ / R) ^ (n + 1) := by
        rcases le_or_lt R 0 with hR | hRpos
        · -- degenerate case: ball is empty, but hz gave us z ∈ ball 0 R, contradiction
          exfalso
          have : ‖z‖ < R := by simpa [Complex.dist_eq] using hz
          linarith [norm_nonneg z]
        · field_simp
          ring
    _ = M * (‖z‖ / R) ^ N := by rw [← hNn]

/--
**F50 Cauchy specialisation for Attack 19.**

With `N = 3n + 2`, this is the Cauchy-integral form of the contour
bound F50: Attack 19's Padé remainder `R_n(z)` satisfies the decay
`‖R_n(z₀)‖ ≤ M · (|z₀|/R)^{3n+2}` once `R_n` vanishes to order ≥ 3n+2
at the origin.
-/
theorem F50_Cauchy_decay
    {f : ℂ → ℂ} {R M : ℝ} (n : ℕ)
    (hdiff : DifferentiableOn ℂ f (ball (0 : ℂ) R))
    (hmaps : MapsTo f (ball (0 : ℂ) R) (closedBall (0 : ℂ) M))
    (hf0 : f 0 = 0)
    (hvanish : f =o[𝓝 (0 : ℂ)] (fun w => w ^ (3 * n + 1)))
    {z : ℂ} (hz : z ∈ ball (0 : ℂ) R) :
    ‖f z‖ ≤ M * (‖z‖ / R) ^ (3 * n + 2) := by
  have hN : 1 ≤ 3 * n + 2 := by omega
  have : (3 * n + 2 : ℕ) - 1 = 3 * n + 1 := by omega
  have hvanish' : f =o[𝓝 (0 : ℂ)] (fun w => w ^ ((3 * n + 2) - 1)) := by
    simpa [this]
  exact cauchy_bound_order_ge hN hdiff hmaps hf0 hvanish' hz

end OmegaTheory.Irrationality.HermitePade
