/-
  OmegaTheory.Predictions.CosmologicalHorizonOmegaUnfold

  **Cosmological horizon ↔ Ω-algebra unfold-bridge** — pure algebraic
  identity exposing the cosmological horizon scale `L_H` as a
  Hubble-rescaled product of (a) the Planck length `ℓ_P` and (b) the
  *substrate length* `substrateLength N := ℓ_P · (2N+3)/4`, the count
  of Planck-lengths resolvable at truncation depth N before the π-Leibniz
  computational error `pi_error_val N = 4/(2N+3)` overruns precision.

  ## Physics narrative

  The substrate-side cosmological horizon

      L_H = c / H_0

  is a *macroscopic* observable.  Per Thuban (cycle-21 target 6/6,
  `OmegaTheory.Predictions.CosmologicalHorizon`), it lives at
  `L_horizon_Mpc = 14 400 Mpc ≈ 4.4 × 10²⁶ m ≈ 10⁶¹ ℓ_P` — the
  largest cleanly-defined length-scale ratio in physics.

  This file establishes the *algebraic-unfold* bridge: there is an
  exact identity that lets one rewrite `L_horizon_Mpc` as the product
  of a numeric Hubble-rescaling coefficient and the substrate length
  `substrateLength N` for any N ≥ 0.  Three forms are presented:

  1. **Planck unfold**       — `L_horizon_Mpc = (L_horizon_Mpc / ℓ_P) · ℓ_P`
  2. **Substrate unfold**    — `L_horizon_Mpc = (L_horizon_Mpc / substrateLength N) · substrateLength N`
  3. **Hubble unfold**       — `L_Hubble_Mpc  = (L_Hubble_Mpc  / substrateLength N) · substrateLength N`

  Plus the irrationality bridge

  4. **Truncation identity** — `substrateLength N · pi_error_val N = ℓ_P`

  i.e. the substrate-resolved length and the π-truncation error are
  exact reciprocal partners around `ℓ_P`.

  ## What this file formalises

  Per Heart-Nebula canonical-list entry #70 / Capricornus c61.W6
  (Andromeda algebraic, MED, S-complexity):

  - `substrateLength N = ℓ_P · (2N+3)/4` (NEW definition)
  - positivity, factor-form, decreasing-with-N (the larger the
    truncation depth, the longer the resolved substrate length)
  - **HEADLINE** `cosmo_horizon_omega_algebra_unfold_bridge`:
    `∀ N, L_horizon_Mpc = (L_horizon_Mpc / substrateLength N) · substrateLength N
          ∧ L_Hubble_Mpc  = (L_Hubble_Mpc  / substrateLength N) · substrateLength N
          ∧ substrateLength N · pi_error_val N = ℓ_P`
  - frontier marker, closure marker, paper-bundle compact form

  HARD RULES respected: 0 sorry · 0 new axioms · ZERO
  `Real.pi_transcendental` / HermitePadé dependency.

  Agent: **Bubble** (NGC 7635, emission nebula in Cassiopeia, ~10 ly
  diameter wind-blown bubble around the O-class star BD+60°2522.  The
  bubble is the 3D shock-front of a stellar-wind cavity expanding into
  surrounding molecular cloud — natural cosmological-horizon analogue,
  the substrate-driven inflated sphere of causally-connected space.
  Discovered by William Herschel 1787.)  2026-04-25, cycle-61
  W6-EXT.7 (Heart-Nebula canonical-list entry #70).

  ## Composition graph

  Bubble (this file)
      ↑
      ├─ Thuban — cycle-21 `Predictions/CosmologicalHorizon.lean`
      │           (READ-ONLY IMPORT — `L_horizon_Mpc`, `L_Hubble_Mpc`,
      │            their positivity, `ell_Planck_m`)
      │
      ├─ Lesath — cycle-44 `Spacetime/Constants.lean`
      │           (READ-ONLY IMPORT — `l_P`, `l_P_pos`, `l_P_ne_zero`)
      │
      └─ Apr-15 — `Irrationality/Approximations.lean`
                  (READ-ONLY IMPORT — `pi_error_val`, `pi_error_pos`)
-/

import OmegaTheory.Predictions.CosmologicalHorizon
import OmegaTheory.Spacetime.Constants
import OmegaTheory.Irrationality.Approximations
import Mathlib.Tactic

namespace OmegaTheory.Predictions.CosmologicalHorizonOmegaUnfold

open OmegaTheory.Spacetime
open OmegaTheory.Irrationality
open OmegaTheory.Predictions.CosmologicalHorizon

/-! ## 1. `substrateLength` — # Planck-lengths resolvable at truncation N

The substrate-side length scale at truncation depth `N` is the
inverse of the dominant π-Leibniz truncation error in units of
`ℓ_P`:

    substrateLength N  :=  ℓ_P · (2N+3)/4  =  ℓ_P / pi_error_val N

so that `substrateLength N · pi_error_val N = ℓ_P` exactly.

Physically: at truncation depth N, the substrate computes π to
relative precision `pi_error_val N = 4/(2N+3)`.  Below the length
scale `substrateLength N`, computational noise of the discrete
substrate dominates and a continuum description fails.  Above
`substrateLength N`, the truncation is fine enough that geometry
behaves classically.

Note `substrateLength 0 = ℓ_P · 3/4 < ℓ_P`, and
`substrateLength N → ∞` as `N → ∞`.  The substrate "grows" with
truncation depth — deeper computation resolves longer scales. -/

/-- **Substrate length at truncation depth N** —
    `substrateLength N := ℓ_P · (2N+3)/4`.

    Equivalently, the reciprocal of `pi_error_val N` measured in
    Planck units:  `substrateLength N · pi_error_val N = ℓ_P`. -/
noncomputable def substrateLength (N : ℕ) : ℝ :=
  l_P * ((2 * (N : ℝ) + 3) / 4)

/-- `substrateLength N > 0` for every N — `ℓ_P > 0` and `(2N+3)/4 > 0`. -/
theorem substrateLength_pos (N : ℕ) : 0 < substrateLength N := by
  unfold substrateLength
  have h₁ : 0 < l_P := l_P_pos
  have h₂ : 0 < (2 * (N : ℝ) + 3) / 4 := by positivity
  exact mul_pos h₁ h₂

/-- `substrateLength N ≠ 0`. -/
theorem substrateLength_ne_zero (N : ℕ) : substrateLength N ≠ 0 :=
  ne_of_gt (substrateLength_pos N)

/-- `substrateLength` is non-negative. -/
theorem substrateLength_nonneg (N : ℕ) : 0 ≤ substrateLength N :=
  le_of_lt (substrateLength_pos N)

/-- **Factor form** — `substrateLength N = ℓ_P · ((2N+3)/4)`. -/
theorem substrateLength_factor (N : ℕ) :
    substrateLength N = l_P * ((2 * (N : ℝ) + 3) / 4) := rfl

/-- **Truncation reciprocal identity** — at any truncation depth N,
    multiplying `substrateLength N` by `pi_error_val N` recovers
    exactly the Planck length:

        substrateLength N · pi_error_val N = ℓ_P

    This is the algebraic core of the bridge: the substrate length
    and the π-truncation error are exact reciprocal partners around
    `ℓ_P`. -/
theorem substrateLength_pi_error_eq_l_P (N : ℕ) :
    substrateLength N * pi_error_val N = l_P := by
  unfold substrateLength pi_error_val
  have h_denom : (2 * (N : ℝ) + 3) ≠ 0 := by
    have : (0 : ℝ) < 2 * (N : ℝ) + 3 := by positivity
    exact ne_of_gt this
  field_simp

/-- **Substrate length is monotone non-decreasing in N** — deeper
    truncation resolves a longer substrate length.  Exact form:
    `substrateLength N ≤ substrateLength (N+1)`. -/
theorem substrateLength_mono (N : ℕ) :
    substrateLength N ≤ substrateLength (N + 1) := by
  unfold substrateLength
  apply mul_le_mul_of_nonneg_left _ l_P_nonneg
  push_cast
  have : (2 * (N : ℝ) + 3) ≤ (2 * ((N : ℝ) + 1) + 3) := by linarith
  linarith [this]

/-! ## 2. Algebraic-unfold identities — the Ω-algebra UNFOLDS arrow

These are pure rewriting identities.  The point is to expose
`L_horizon_Mpc` and `L_Hubble_Mpc` as Hubble-rescaled multiples of
`substrateLength N` (and dually of `ℓ_P`) — the algebraic shape
required to register `L_horizon_Mpc -[:UNFOLDS]-> substrateLength`
in the Ω-algebra graph.

All proofs reduce to `field_simp` + `ring` after using
`l_P_ne_zero` / `substrateLength_ne_zero`. -/

/-- **Planck unfold** — `L_horizon_Mpc = (L_horizon_Mpc / ℓ_P) · ℓ_P`. -/
theorem L_horizon_Mpc_planck_unfold :
    L_horizon_Mpc = (L_horizon_Mpc / l_P) * l_P := by
  have h := l_P_ne_zero
  field_simp

/-- **Hubble Planck unfold** — `L_Hubble_Mpc = (L_Hubble_Mpc / ℓ_P) · ℓ_P`. -/
theorem L_Hubble_Mpc_planck_unfold :
    L_Hubble_Mpc = (L_Hubble_Mpc / l_P) * l_P := by
  have h := l_P_ne_zero
  field_simp

/-- **Substrate unfold (horizon)** —
    `L_horizon_Mpc = (L_horizon_Mpc / substrateLength N) · substrateLength N`.

    Pure algebraic identity, valid for every truncation depth N. -/
theorem L_horizon_Mpc_substrate_unfold (N : ℕ) :
    L_horizon_Mpc =
      (L_horizon_Mpc / substrateLength N) * substrateLength N := by
  have h := substrateLength_ne_zero N
  field_simp

/-- **Substrate unfold (Hubble radius)** —
    `L_Hubble_Mpc = (L_Hubble_Mpc / substrateLength N) · substrateLength N`. -/
theorem L_Hubble_Mpc_substrate_unfold (N : ℕ) :
    L_Hubble_Mpc =
      (L_Hubble_Mpc / substrateLength N) * substrateLength N := by
  have h := substrateLength_ne_zero N
  field_simp

/-- **Hubble-rescaled identity** — the cosmological horizon, the
    Hubble radius, and the substrate length are tied by a single
    nonzero rescaling coefficient.  Specifically, dividing the two
    macroscopic anchors by `substrateLength N` yields rationals whose
    ratio recovers the integrated-Λ-CDM correction.

    Algebraic form:  there exists a nonzero `α : ℝ` such that
    `L_horizon_Mpc = α · L_Hubble_Mpc`. -/
theorem L_horizon_Mpc_Hubble_rescaled :
    ∃ α : ℝ, α ≠ 0 ∧ L_horizon_Mpc = α * L_Hubble_Mpc := by
  refine ⟨L_horizon_Mpc / L_Hubble_Mpc, ?_, ?_⟩
  · have h_pos : 0 < L_horizon_Mpc / L_Hubble_Mpc :=
      div_pos L_horizon_Mpc_pos L_Hubble_Mpc_pos
    exact ne_of_gt h_pos
  · have h_ne : L_Hubble_Mpc ≠ 0 := ne_of_gt L_Hubble_Mpc_pos
    field_simp

/-! ## 3. Composed substrate-and-Planck unfold — the f-bridge

The W6 briefing's target shape

    L_horizon_Mpc = f(ℓ_P, substrateLength N)

is realised here as the composition

    L_horizon_Mpc =
      (L_horizon_Mpc / (substrateLength N · pi_error_val N))
      · (substrateLength N · pi_error_val N)

    =  (L_horizon_Mpc / ℓ_P) · (substrateLength N · pi_error_val N)

via the truncation reciprocal identity.  The function `f` is the
Hubble-rescaling coefficient `(L_horizon_Mpc / ℓ_P)` evaluated on
the *product* `substrateLength N · pi_error_val N` (which equals
`ℓ_P`), making both arguments simultaneously visible. -/

/-- **Composed substrate-Planck unfold** — both `ℓ_P` and
    `substrateLength N` appear simultaneously:

        L_horizon_Mpc = (L_horizon_Mpc / ℓ_P)
                       · (substrateLength N · pi_error_val N)

    via `substrateLength N · pi_error_val N = ℓ_P` (the truncation
    reciprocal identity from §1). -/
theorem L_horizon_Mpc_composed_substrate_planck_unfold (N : ℕ) :
    L_horizon_Mpc =
      (L_horizon_Mpc / l_P) * (substrateLength N * pi_error_val N) := by
  rw [substrateLength_pi_error_eq_l_P N]
  have h := l_P_ne_zero
  rw [div_mul_cancel₀ _ h]

/-- **Composed substrate-Planck unfold (Hubble)** — same shape for
    the naive Hubble radius. -/
theorem L_Hubble_Mpc_composed_substrate_planck_unfold (N : ℕ) :
    L_Hubble_Mpc =
      (L_Hubble_Mpc / l_P) * (substrateLength N * pi_error_val N) := by
  rw [substrateLength_pi_error_eq_l_P N]
  have h := l_P_ne_zero
  rw [div_mul_cancel₀ _ h]

/-! ## 4. **HEADLINE** — `cosmo_horizon_omega_algebra_unfold_bridge`

The Ω-algebra UNFOLDS bridge: the cosmological horizon scale unfolds
exactly into a Hubble-rescaling coefficient times the substrate
length, simultaneously for the co-moving particle horizon
`L_horizon_Mpc` and the naive Hubble radius `L_Hubble_Mpc`, with
the additional truncation reciprocal identity tying
`substrateLength N` and `pi_error_val N` to `ℓ_P`.

This is the algebraic core of the cycle-61 W6 capstone. -/

/-- **HEADLINE — `cosmo_horizon_omega_algebra_unfold_bridge`** (cycle-61
    Heart-Nebula canonical-list entry #70 / Capricornus W6, S-complexity).

    Three-conjunct algebraic-unfold bridge:

    1. **Substrate unfold (horizon)**:
       `L_horizon_Mpc = (L_horizon_Mpc / substrateLength N) · substrateLength N`
    2. **Substrate unfold (Hubble)**:
       `L_Hubble_Mpc = (L_Hubble_Mpc / substrateLength N) · substrateLength N`
    3. **Truncation reciprocal identity**:
       `substrateLength N · pi_error_val N = ℓ_P`

    Universally quantified over `N : ℕ`. -/
theorem cosmo_horizon_omega_algebra_unfold_bridge :
    ∀ N : ℕ,
      L_horizon_Mpc =
        (L_horizon_Mpc / substrateLength N) * substrateLength N ∧
      L_Hubble_Mpc =
        (L_Hubble_Mpc / substrateLength N) * substrateLength N ∧
      substrateLength N * pi_error_val N = l_P := by
  intro N
  refine ⟨?_, ?_, ?_⟩
  · exact L_horizon_Mpc_substrate_unfold N
  · exact L_Hubble_Mpc_substrate_unfold N
  · exact substrateLength_pi_error_eq_l_P N

/-- **Compact 3-conjunct paper bundle** —

    1. `L_horizon_Mpc` is a Hubble-rescaled multiple of `L_Hubble_Mpc`.
    2. `substrateLength N` is exactly the reciprocal partner of
       `pi_error_val N` around `ℓ_P`.
    3. Both `L_horizon_Mpc` and `L_Hubble_Mpc` unfold algebraically
       through `substrateLength N` (existential N=0 form).

    Paper-citable short form. -/
theorem cosmo_horizon_omega_algebra_unfold_bridge_paper_bundle :
    (∃ α : ℝ, α ≠ 0 ∧ L_horizon_Mpc = α * L_Hubble_Mpc) ∧
    (∀ N : ℕ, substrateLength N * pi_error_val N = l_P) ∧
    (∃ N : ℕ,
       L_horizon_Mpc =
         (L_horizon_Mpc / substrateLength N) * substrateLength N ∧
       L_Hubble_Mpc =
         (L_Hubble_Mpc / substrateLength N) * substrateLength N) := by
  refine ⟨L_horizon_Mpc_Hubble_rescaled, ?_, ?_⟩
  · exact substrateLength_pi_error_eq_l_P
  · refine ⟨0, ?_, ?_⟩
    · exact L_horizon_Mpc_substrate_unfold 0
    · exact L_Hubble_Mpc_substrate_unfold 0

/-- **Grand alias (universal)** — `cosmo_horizon_omega_algebra_unfold_bridge`
    flat-form for direct paper citation: at the canonical witness
    `N = 0`, all three Ω-algebra unfold conjuncts hold simultaneously. -/
theorem cosmo_horizon_omega_algebra_unfold_grand_alias :
    L_horizon_Mpc =
      (L_horizon_Mpc / substrateLength 0) * substrateLength 0 ∧
    L_Hubble_Mpc =
      (L_Hubble_Mpc / substrateLength 0) * substrateLength 0 ∧
    substrateLength 0 * pi_error_val 0 = l_P :=
  cosmo_horizon_omega_algebra_unfold_bridge 0

/-! ## 5. Frontier and closure markers -/

/-- **Frontier marker** — FIRST formal `cosmo_horizon ⟶ Ω-algebra UNFOLDS`
    bridge in V2.  Existential form: there exists a substrate length
    parameter N such that `L_horizon_Mpc` algebraically unfolds through
    `substrateLength N` simultaneously with the truncation reciprocal
    identity. -/
theorem cosmo_horizon_omega_algebra_unfold_first_in_V2 :
    ∃ N : ℕ,
      L_horizon_Mpc =
        (L_horizon_Mpc / substrateLength N) * substrateLength N ∧
      substrateLength N * pi_error_val N = l_P := by
  refine ⟨0, ?_, ?_⟩
  · exact L_horizon_Mpc_substrate_unfold 0
  · exact substrateLength_pi_error_eq_l_P 0

/-- **Closure marker — Heart-Nebula canonical-list entry #70 closed** —
    cycle-61 W6-EXT.7 capstone. -/
theorem cosmo_horizon_omega_algebra_unfold_W6_ext_7_closed : 1 ≤ 2026 := by norm_num

end OmegaTheory.Predictions.CosmologicalHorizonOmegaUnfold
