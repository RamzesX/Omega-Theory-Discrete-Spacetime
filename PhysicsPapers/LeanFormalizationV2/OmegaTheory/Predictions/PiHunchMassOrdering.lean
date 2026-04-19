/-
  OmegaTheory.Predictions.PiHunchMassOrdering

  **Pi Hunch capstone: three-generation mass ordering from δ_comp.**

  This is the first OmegaTheory theorem that links the irrationality of
  (π, e, √2) DIRECTLY to fermion mass ordering.

  Chain (taken for granted as CLAUDE.md "Pi Hunch"):
    • π via Leibniz has O(1/N) truncation error ── slowest → *largest* δ
    • e via Taylor  has O(1/N!) truncation error ── factorial → middle δ
    • √2 via Newton has O(2^{-2^N}) truncation error ── super-exp → *smallest* δ

  The Apr-17 convention-correction (`NOTES_PI_ORDERING_CORRECTION.md`) states:
  "hardest to compute" = MOST residual error, not least.  Any strictly
  monotone Yukawa-δ mapping `m = f(δ_comp)` therefore translates this δ
  ordering into the published fermion mass ordering
  `heavy > middle > light`, identifying

        heavy  ↔ π-channel        (largest δ, hardest to truncate)
        middle ↔ e-channel        (factorial convergence)
        light  ↔ √2-channel       (super-exponential convergence)

  **Scope of this file.**  We package the strict δ-ordering as two public
  theorems:

    1. `pi_hunch_delta_ordering`         — bare (unit-less) per-target δ
    2. `pi_hunch_mass_ordering`          — ℓ_P-weighted δ_comp form

  and supply the Yukawa consequence under the monotone-kernel hypothesis:

    3. `fermion_mass_ordering_from_delta`     — unit-less mass ordering
    4. `fermion_mass_ordering_from_delta_comp` — ℓ_P-weighted variant

  The concrete arithmetic is delegated to Sadr's `e_error_lt_pi_error` and
  `sqrt2_error_lt_e_error` lemmas (`OmegaTheory/Emergence/LeptonMassFromIrrationals.lean`).
  The capstone contribution here is to (a) give the three canonical names
  `delta_pi` / `delta_e` / `delta_sqrt2`, (b) introduce a single threshold
  `N_threshold := 2`, (c) state the ordering as one public theorem, and
  (d) package the Yukawa-δ consequence under a strictly monotone kernel.

  **HARD RULES**: 0 sorry, 0 new axioms, 0 `Prop := True`.

  Agent: pi-capstone (claimed name below on first successful build).
  2026-04-19.
-/

import OmegaTheory.Irrationality.Approximations
import OmegaTheory.Irrationality.Uncertainty
import OmegaTheory.Irrationality.BoundsLemmas
import OmegaTheory.Emergence.LeptonMassFromIrrationals

namespace OmegaTheory.Predictions

open OmegaTheory.Irrationality
open OmegaTheory.Emergence.LeptonMassFromIrrationals
open OmegaTheory.Spacetime

/-! ## 1. Canonical δ names and the universal threshold

The mission brief asks for `delta_pi`, `delta_e`, `delta_sqrt2` as the
three per-tick truncation errors.  We reuse the proven primitives from
`Approximations.lean` and rename them at this level.

We also fix the universal threshold at which the strict ordering kicks in:

    N_threshold := 2

For `N ≥ 2` all three δ values live in `(0, 1)`, so any strictly
monotone kernel `f : (0,1) → ℝ` preserves the ordering. -/

/-- The universal N threshold at which the Pi-hunch δ ordering is strict
    and all three δ values sit in the unit interval. -/
def N_threshold : ℕ := 2

/-- **π-channel δ**: Leibniz residual `4/(2N+3)`. O(1/N) — slowest. -/
noncomputable def delta_pi (N : ℕ) : ℝ := pi_error_val N

/-- **e-channel δ**: Taylor residual `3/(N+1)!`. O(1/N!) — factorial. -/
noncomputable def delta_e (N : ℕ) : ℝ := e_error_val N

/-- **√2-channel δ**: Newton-Raphson residual `1/2^{2^N}`.
    O(2^{-2^N}) — super-exponential. -/
noncomputable def delta_sqrt2 (N : ℕ) : ℝ := sqrt2_error_val N

/-! ## 2. Positivity and unit-interval control for `N ≥ N_threshold` -/

theorem delta_pi_pos (N : ℕ) : 0 < delta_pi N := pi_error_pos N
theorem delta_e_pos (N : ℕ) : 0 < delta_e N := e_error_pos N
theorem delta_sqrt2_pos (N : ℕ) : 0 < delta_sqrt2 N := sqrt2_error_pos N

theorem delta_pi_lt_one {N : ℕ} (hN : N_threshold ≤ N) : delta_pi N < 1 :=
  pi_error_lt_one hN

theorem delta_e_lt_one {N : ℕ} (hN : N_threshold ≤ N) : delta_e N < 1 :=
  e_error_lt_one hN

theorem delta_sqrt2_lt_one {N : ℕ} (hN : N_threshold ≤ N) : delta_sqrt2 N < 1 :=
  sqrt2_error_lt_one (by unfold N_threshold at hN; omega)

/-! ## 3. Pi-Hunch δ-ordering (bare form) — the capstone statement

    For every `N ≥ N_threshold = 2`, the three per-tick truncation
    errors are *strictly* ordered

        δ_√2(N)  <  δ_e(N)  <  δ_π(N)

    with π at the top because its convergence is slowest.  This is the
    Pi Hunch in its sharpest purely-arithmetic form. -/

/-- **Pi Hunch strict ordering, bare (unit-less) form.**

    For every lattice truncation `N ≥ N_threshold`, the three
    per-tick irrational truncation errors satisfy

        δ_π(N)  >  δ_e(N)  >  δ_√2(N).

    This is the algebraic content of *"π is hardest to compute,
    √2 is easiest"* — slowest convergence ⇒ largest residual error.

    Proof: delegate to `e_error_lt_pi_error` and `sqrt2_error_lt_e_error`
    from `LeptonMassFromIrrationals` (Sadr 2026-04-17). -/
theorem pi_hunch_delta_ordering {N : ℕ} (hN : N_threshold ≤ N) :
    delta_pi N > delta_e N ∧ delta_e N > delta_sqrt2 N := by
  unfold delta_pi delta_e delta_sqrt2
  exact ⟨e_error_lt_pi_error hN, sqrt2_error_lt_e_error hN⟩

/-! ## 4. ℓ_P-weighted δ_comp form

    The substrate's physical per-tick uncertainty is
    `δ_comp(N) = ℓ_P · ε(N)` where ε is the dominant truncation error
    (π by default).  For the Pi-hunch we weight *each* channel by ℓ_P
    to get the three physical-units δ scales. -/

/-- Planck-weighted π-channel uncertainty: `ℓ_P · δ_π(N)`. -/
noncomputable def delta_comp_pi (N : ℕ) : ℝ := l_P * delta_pi N

/-- Planck-weighted e-channel uncertainty: `ℓ_P · δ_e(N)`. -/
noncomputable def delta_comp_e (N : ℕ) : ℝ := l_P * delta_e N

/-- Planck-weighted √2-channel uncertainty: `ℓ_P · δ_√2(N)`. -/
noncomputable def delta_comp_sqrt2 (N : ℕ) : ℝ := l_P * delta_sqrt2 N

theorem delta_comp_pi_pos (N : ℕ) : 0 < delta_comp_pi N :=
  mul_pos l_P_pos (delta_pi_pos N)

theorem delta_comp_e_pos (N : ℕ) : 0 < delta_comp_e N :=
  mul_pos l_P_pos (delta_e_pos N)

theorem delta_comp_sqrt2_pos (N : ℕ) : 0 < delta_comp_sqrt2 N :=
  mul_pos l_P_pos (delta_sqrt2_pos N)

/-- **Pi Hunch capstone theorem, ℓ_P-weighted form.**

    For every lattice truncation `N ≥ N_threshold`, the three
    Planck-weighted per-tick computational uncertainties obey

        δ_comp,π(N)  >  δ_comp,e(N)  >  δ_comp,√2(N).

    This is the substrate-level three-generation hierarchy prior to any
    Yukawa identification.  Multiplication by `ℓ_P > 0` is
    order-preserving, so this follows from `pi_hunch_delta_ordering` by a
    single `mul_lt_mul_of_pos_left`. -/
theorem pi_hunch_mass_ordering {N : ℕ} (hN : N_threshold ≤ N) :
    delta_comp_pi N > delta_comp_e N ∧ delta_comp_e N > delta_comp_sqrt2 N := by
  obtain ⟨h1, h2⟩ := pi_hunch_delta_ordering hN
  refine ⟨?_, ?_⟩
  · exact mul_lt_mul_of_pos_left h1 l_P_pos
  · exact mul_lt_mul_of_pos_left h2 l_P_pos

/-! ## 5. Fermion-mass ordering under a monotone Yukawa kernel

    Under the hypothesis that the Yukawa-δ mapping `m = f(δ_comp)` is
    strictly increasing (to be established by the ConnesBimodule /
    DiracFSpectrum derivations), the δ ordering transfers directly to
    the fermion mass ordering

        m_{heavy}  >  m_{middle}  >  m_{light}

    with the physical identification

        heavy  ↔ π-channel     ↔ τ / top
        middle ↔ e-channel     ↔ μ / charm
        light  ↔ √2-channel    ↔ e / up

    This is STRICTLY CONDITIONAL on `StrictMono f` — no new mass axioms. -/

/-- **Fermion mass ordering (unit-less form).**

    Given any strictly monotone Yukawa kernel `f : ℝ → ℝ`, the δ ordering
    of §3 transfers to `f`-image values:

        f(δ_π)  >  f(δ_e)  >  f(δ_√2).

    This is the substrate-level statement that *any* strictly increasing
    mass-from-δ law reproduces the empirical mass hierarchy. -/
theorem fermion_mass_ordering_from_delta
    {f : ℝ → ℝ} (hf_mono : StrictMono f)
    {N : ℕ} (hN : N_threshold ≤ N) :
    f (delta_pi N) > f (delta_e N) ∧ f (delta_e N) > f (delta_sqrt2 N) := by
  obtain ⟨h1, h2⟩ := pi_hunch_delta_ordering hN
  exact ⟨hf_mono h1, hf_mono h2⟩

/-- **Fermion mass ordering (ℓ_P-weighted form).**

    The Planck-weighted analogue of `fermion_mass_ordering_from_delta`,
    using the physical-units `δ_comp,·(N)` scales as inputs to a strictly
    monotone kernel.  Also conditional on `StrictMono f`. -/
theorem fermion_mass_ordering_from_delta_comp
    {f : ℝ → ℝ} (hf_mono : StrictMono f)
    {N : ℕ} (hN : N_threshold ≤ N) :
    f (delta_comp_pi N) > f (delta_comp_e N) ∧
    f (delta_comp_e N) > f (delta_comp_sqrt2 N) := by
  obtain ⟨h1, h2⟩ := pi_hunch_mass_ordering hN
  exact ⟨hf_mono h1, hf_mono h2⟩

/-! ## 6. Sanity check at the lattice dimension

    The ℤ⁴ lattice has spacetime dimension `N = 4`.  Instantiating the
    capstone at `N = 4` is the concrete statement that the Pi Hunch
    applies at the lattice-dimension truncation level used throughout
    the project (Nashira's preferred N for the phenomenological fit). -/

/-- **Pi Hunch ordering at the lattice dimension N = 4.** -/
theorem pi_hunch_delta_ordering_at_4 :
    delta_pi 4 > delta_e 4 ∧ delta_e 4 > delta_sqrt2 4 :=
  pi_hunch_delta_ordering (by unfold N_threshold; omega)

/-- **Pi Hunch ℓ_P-weighted ordering at the lattice dimension N = 4.** -/
theorem pi_hunch_mass_ordering_at_4 :
    delta_comp_pi 4 > delta_comp_e 4 ∧ delta_comp_e 4 > delta_comp_sqrt2 4 :=
  pi_hunch_mass_ordering (by unfold N_threshold; omega)

/-! ## 7. Summary

    * `N_threshold = 2` — the smallest N at which all three δ values
      live in `(0, 1)` and the strict ordering kicks in.
    * `pi_hunch_delta_ordering`        — bare δ strict ordering.
    * `pi_hunch_mass_ordering`         — ℓ_P-weighted strict ordering.
    * `fermion_mass_ordering_from_delta`      — conditional mass consequence.
    * `fermion_mass_ordering_from_delta_comp` — conditional mass consequence
                                                 in physical units.

    Paired with Sadr's concrete Nashira kernel
    `nashiraKernel_strictMono` from `LeptonMassFromIrrationals.lean`,
    the conditional consequence specializes to the explicit
    lepton-mass hierarchy `m_e < m_μ < m_τ` for `N ≥ 2`. -/

end OmegaTheory.Predictions
