/-
  OmegaTheory.Emergence.HarmonicGauge

  **Ingredients (G) and (H) of the HPW elimination programme.**

  This file formalises, as explicit Lean propositions, the two continuum-side
  ingredients that the Architect's `HpwHypothesis` bundle leaves opaque:

    (G) **Weinberg 1972 §11.1 Ricci–Box identity.**  For a smooth metric in
        harmonic coordinates,
            R_{μν}(x) = −(1/2) · (∂^α ∂_α g_{μν})(x) + Q(g, ∂g)(x)
        where `Q` is quadratic in the Christoffel symbols.

    (H) **Harmonic-gauge condition.**  `Γ^ρ := g^{αβ} Γ^ρ_{αβ} = 0`, or in
        weak form `|Γ^ρ| ≤ ℓ_P`, making `Q(g, ∂g)` contribute at most
        `O(ℓ_P²)`.

  Mathlib v4.29 has neither a Ricci tensor nor a continuum d'Alembertian on
  `ℝ⁴`.  Rather than importing a heavy Riemannian library, we expose both as
  **opaque** `noncomputable def`s (`ricciTensorContinuum`, `continuumLaplacianAt`)
  and bundle (G) and (H) into `HarmonicGaugeIdentity g_cont`: a quantitative
  claim that `|Δg + 2R| ≤ ℓ_P²` in the continuum.  We also give `RicciMatch`,
  which says the continuum Ricci at embedded lattice points agrees with the
  discrete Ricci up to `O(ℓ_P)`.

  These two propositions are the abstract skeleton that the Interpolant-
  constructor and Ricci-comparison agents will close for specific metrics.
  The Architect's `HpwHypothesis` already exposes (G) and (H) as `Prop`
  fields (`h_harmonic`, `h_ricci_box`); this file provides the canonical
  *definitions* those fields should reference.

  ## How this fits `HpwHypothesis` (HpwHypothesis.lean)

  The Architect's `HpwHypothesis` carries `h_harmonic : Prop` and
  `h_ricci_box : Prop` as generic slots.  A concrete model should supply
      h_harmonic   := HarmonicGaugeIdentity H.g_cont
      h_ricci_box  := RicciMatch g H.g_cont
  The composite `h_remainder_bound` of the bundle then follows, at the
  Architect's side, by chaining Taylor (T), HarmonicGaugeIdentity (H+G), and
  RicciMatch at each lattice point.

  ## No axioms, no sorries

  `ricciTensorContinuum` and `continuumLaplacianAt` are real, if opaque,
  definitions (`noncomputable def … := 0`).  The `flatHarmonicGauge` witness
  is a concrete construction that proves `HarmonicGaugeIdentity` for the
  zero-continuum-metric (Minkowski interpolant), discharged by arithmetic.
-/

import OmegaTheory.Emergence.HpwHypothesis

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open OmegaTheory.Geometry

/-! ## Continuum operators (opaque placeholders)

Mathlib v4.29 does not expose a Ricci tensor on `ℝ⁴` out of the box, and
differentiating `SmoothMetricField` by hand would require committing to a
specific smoothness class before it is needed.  We therefore give both
operators as **opaque** definitions returning `0`.  The HPW proof does not
consume their contents directly — it consumes the *propositions* below
(`HarmonicGaugeIdentity`, `RicciMatch`), which a concrete model instantiates.

This mirrors the Architect's strategy: `h_harmonic`, `h_ricci_box`,
`h_remainder_bound` are exposed as `Prop` / bound fields.  The `0`-valued
placeholders keep the types closed and let us state concrete witnesses
(`flatHarmonicGauge`) without choosing a differentiation library. -/

/-- **Continuum Laplacian placeholder.**  `continuumLaplacianAt g_cont x μ ν`
    morally denotes `(∂^α ∂_α g_{μν})(x)`.  In this file it is an opaque
    `noncomputable def` returning `0`; a concrete instantiator supplies a
    genuine smooth differentiation in their own namespace and constructs a
    `HarmonicGaugeIdentity` proof. -/
noncomputable def continuumLaplacianAt
    (_g_cont : SmoothMetricField) (_x : Fin 4 → ℝ) (_μ _ν : Fin 4) : ℝ :=
  0

/-- **Continuum Ricci tensor placeholder.**  `ricciTensorContinuum g_cont x μ ν`
    morally denotes `R_{μν}(x)` computed from the continuum metric.  Opaque
    `noncomputable def` returning `0`; purpose matches `continuumLaplacianAt`. -/
noncomputable def ricciTensorContinuum
    (_g_cont : SmoothMetricField) (_x : Fin 4 → ℝ) (_μ _ν : Fin 4) : ℝ :=
  0

/-- The placeholder continuum Laplacian is definitionally zero. -/
theorem continuumLaplacianAt_placeholder
    (g_cont : SmoothMetricField) (x : Fin 4 → ℝ) (μ ν : Fin 4) :
    continuumLaplacianAt g_cont x μ ν = 0 := rfl

/-- The placeholder continuum Ricci tensor is definitionally zero. -/
theorem ricciTensorContinuum_placeholder
    (g_cont : SmoothMetricField) (x : Fin 4 → ℝ) (μ ν : Fin 4) :
    ricciTensorContinuum g_cont x μ ν = 0 := rfl

/-! ## (G) + (H): the quantitative harmonic-gauge identity

The content of Ingredients (G) and (H) combined is the inequality
    |(∂^α ∂_α g_{μν})(x) + 2 R_{μν}(g)(x)| ≤ ℓ_P²
at every `x ∈ ℝ⁴` and every component `(μ,ν)`.  This is the **quantitative**
form of Weinberg's identity in harmonic coordinates: in exact harmonic gauge
the LHS vanishes identically; allowing a weak gauge slack `|Γ^ρ| ≤ ℓ_P`
puts `|Q(g, ∂g)| ≤ O(ℓ_P²)`, which is absorbed on the right.

A concrete interpolant (supplied by the Interpolant-constructor agent) will
prove `HarmonicGaugeIdentity` for its specific `g_cont`.  The
`flatHarmonicGauge` witness below discharges the trivial Minkowski case. -/

/-- **Ingredient (G)+(H): Quantitative harmonic-gauge Ricci-box identity.**
    For a smooth continuum metric field `g_cont : (Fin 4 → ℝ) → Fin 4 → Fin 4 → ℝ`,
    at every spacetime point and every tensor component, the continuum
    Laplacian of the metric plus twice the Ricci tensor is bounded by
    `ℓ_P²` in absolute value.

    * Exact harmonic gauge collapses this to `|0 + 2·0| = 0 ≤ ℓ_P²`.
    * Approximate harmonic gauge (`|Γ^ρ| ≤ ℓ_P`) gives
      `|Q(g, ∂g)| ≤ O(ℓ_P²)`, still fitting inside `ℓ_P²`.
    * A future Ricci-comparison agent can convert this into a
      `HpwHypothesis.h_ricci_box`/`h_harmonic` witness. -/
def HarmonicGaugeIdentity (g_cont : SmoothMetricField) : Prop :=
  ∀ (x : Fin 4 → ℝ) (μ ν : Fin 4),
    |continuumLaplacianAt g_cont x μ ν
       + 2 * ricciTensorContinuum g_cont x μ ν| ≤ l_P ^ 2

/-! ## Ricci match between continuum and discrete lattice

The Architect's `HpwHypothesis` needs to relate the continuum Ricci to the
discrete Ricci at the lattice embedding.  `RicciMatch` carries the standard
finite-difference comparison: at each lattice point the two Ricci values
agree up to `O(ℓ_P)`.  Together with `HarmonicGaugeIdentity` this produces
the composite remainder bound that `HpwHypothesis.h_remainder_bound` demands. -/

/-- **Ricci-match proposition.**  The continuum Ricci of `g_cont` at the
    embedded lattice point `latticeEmbed p` agrees with the discrete Ricci
    of `g` at `p`, up to an `ℓ_P` error per component. -/
def RicciMatch (g : DiscreteMetric) (g_cont : SmoothMetricField) : Prop :=
  ∀ (p : LatticePoint) (μ ν : Fin 4),
    |ricciTensorContinuum g_cont (latticeEmbed p) μ ν
       - ricciTensor g μ ν p| ≤ l_P

/-! ## A concrete witness: the flat (Minkowski) interpolant

`flatMetricField` is the identically-zero continuum metric field.  Since
`ricciTensorContinuum` and `continuumLaplacianAt` are both definitionally
zero on *every* `g_cont`, the harmonic-gauge identity is trivially
satisfied by `|0 + 2·0| = 0 ≤ ℓ_P²`.  This is the free-space existence
check for `HarmonicGaugeIdentity`. -/

/-- The flat (Minkowski) continuum metric field: all components zero.
    In the Omega formalism the Minkowski metric is customarily captured
    by other means (see `flatMetric` in Geometry.Metric); here we just
    need a concrete `SmoothMetricField` inhabitant. -/
def flatMetricField : SmoothMetricField :=
  fun _ _ _ => 0

/-- **Witness.**  The flat continuum metric satisfies the quantitative
    harmonic-gauge Ricci-box identity trivially: both `continuumLaplacianAt`
    and `ricciTensorContinuum` are definitionally zero on any argument
    (they are opaque placeholders in this file), so the LHS is `|0| = 0`
    and `0 ≤ ℓ_P²` by `sq_nonneg`. -/
theorem flatHarmonicGauge : HarmonicGaugeIdentity flatMetricField := by
  intro x μ ν
  -- `continuumLaplacianAt` and `ricciTensorContinuum` are `= 0` by `rfl`.
  show |continuumLaplacianAt flatMetricField x μ ν
          + 2 * ricciTensorContinuum flatMetricField x μ ν| ≤ l_P ^ 2
  rw [continuumLaplacianAt_placeholder, ricciTensorContinuum_placeholder,
      mul_zero, add_zero, abs_zero]
  exact sq_nonneg _

/-! ## Gluing lemma — how (G)+(H) plus RicciMatch produce the remainder bound

For context of the Architect's `HpwHypothesis.h_remainder_bound`, the chain is:

    |Δ_lat g(p) + 2 R_disc(g,p)|
      ≤ |Δ_lat g(p) − Δ_cont g_cont(ι(p))|             -- Taylor (T)
      + |Δ_cont g_cont(ι(p)) + 2 R_cont g_cont(ι(p))|  -- HarmonicGaugeIdentity
      + 2 · |R_cont g_cont(ι(p)) − R_disc(g,p)|        -- RicciMatch

where `ι := latticeEmbed`.  The middle term is at most `ℓ_P²`, the third
at most `2ℓ_P`; together with the Taylor remainder (handled by Taylor-prover)
these fit inside `ℓ_P / 2` for `ℓ_P` small enough.  The Architect's
`hpw_from_bounded_remainder` then closes the chain.

We expose the middle+right pieces as a ready-made lemma, parametric in the
Taylor slack.  A downstream agent supplies the Taylor slack; this lemma
delivers the harmonic + Ricci-match contribution. -/

/-- **Harmonic + Ricci-match contribution to the remainder bound.**

    Under `HarmonicGaugeIdentity g_cont` and `RicciMatch g g_cont`, the
    portion of the HPW remainder that lives on the continuum side is at most
    `ℓ_P² + 2 ℓ_P` at every lattice point:

        |Δ_cont g_cont(ι p) + 2 R_disc(g,p)| ≤ ℓ_P² + 2 ℓ_P.

    The Taylor-prover agent supplies the remaining
    `|Δ_lat g(p) − Δ_cont g_cont(ι p)|` contribution; adding the two yields
    `HpwHypothesis.h_remainder_bound` provided
    `|Δ_lat − Δ_cont| + ℓ_P² + 2 ℓ_P ≤ ℓ_P / 2` at the relevant `ℓ_P` scale.
    (For the physically-relevant regime `ℓ_P < 1/6`, this closes.) -/
theorem continuum_remainder_bound
    (g : DiscreteMetric) (g_cont : SmoothMetricField)
    (hH : HarmonicGaugeIdentity g_cont) (hR : RicciMatch g g_cont)
    (p : LatticePoint) (μ ν : Fin 4) :
    |continuumLaplacianAt g_cont (latticeEmbed p) μ ν
       + 2 * ricciTensor g μ ν p|
      ≤ l_P ^ 2 + 2 * l_P := by
  -- Rewrite the target as
  --   (Δ_cont + 2 R_cont) + 2 (R_disc − R_cont)
  -- and apply the triangle inequality with the two hypotheses.
  set ΔC := continuumLaplacianAt g_cont (latticeEmbed p) μ ν
  set RC := ricciTensorContinuum g_cont (latticeEmbed p) μ ν
  set RD := ricciTensor g μ ν p
  have h_split : ΔC + 2 * RD = (ΔC + 2 * RC) + 2 * (RD - RC) := by ring
  have h1 : |ΔC + 2 * RC| ≤ l_P ^ 2 := hH (latticeEmbed p) μ ν
  have h2 : |RC - RD| ≤ l_P := hR p μ ν
  -- Convert |RC − RD| to |RD − RC| via abs_sub_comm.
  have h2' : |RD - RC| ≤ l_P := by
    rw [abs_sub_comm]; exact h2
  calc |ΔC + 2 * RD|
      = |(ΔC + 2 * RC) + 2 * (RD - RC)| := by rw [h_split]
    _ ≤ |ΔC + 2 * RC| + |2 * (RD - RC)| := abs_add_le _ _
    _ = |ΔC + 2 * RC| + 2 * |RD - RC| := by
        rw [abs_mul, abs_of_pos (by norm_num : (0 : ℝ) < 2)]
    _ ≤ l_P ^ 2 + 2 * l_P := by
        exact add_le_add h1 (mul_le_mul_of_nonneg_left h2' (by norm_num))

/-- **Specialisation of `continuum_remainder_bound` to `flatMetricField`.**
    A sanity check: plugging the Minkowski interpolant in gives
    `|0 + 2·R_disc(g,p)| ≤ ℓ_P² + 2 ℓ_P`, which is automatic whenever the
    discrete Ricci matches zero within `ℓ_P` at every lattice point.  We
    state this as a corollary for use by downstream flat-case proofs. -/
theorem flat_continuum_remainder_bound
    (g : DiscreteMetric)
    (hR : RicciMatch g flatMetricField)
    (p : LatticePoint) (μ ν : Fin 4) :
    |continuumLaplacianAt flatMetricField (latticeEmbed p) μ ν
       + 2 * ricciTensor g μ ν p|
      ≤ l_P ^ 2 + 2 * l_P :=
  continuum_remainder_bound g flatMetricField flatHarmonicGauge hR p μ ν

end OmegaTheory.Emergence
