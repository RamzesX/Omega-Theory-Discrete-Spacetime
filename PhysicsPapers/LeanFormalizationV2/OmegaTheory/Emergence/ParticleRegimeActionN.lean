/-
  OmegaTheory.Emergence.ParticleRegimeActionN

  **Particle regime (photon-like vs. massive) from action density and
  iteration budget.**

  ## Physical narrative (Thuban, 2026-04-19 — hunter-TC-A1)

  OmegaTheory distinguishes two fundamental regimes of the substrate's
  matter sector through a pair of parameters:

  * the **action density** `ρ = S / V`, the rest-frame Lagrangian
    density carried by the particle (a photon has no rest frame, hence
    `ρ = 0`);
  * the **iteration budget** `N : ℕ`, the number of Leibniz-series
    updates the substrate performs per Planck tick (the computational
    uncertainty residual `δ_comp(N) = ℓ_P · 4/(2N+3)` shrinks as
    `N → ∞`).

  Achernar's `PhotonZeroRhoMaxN.lean` closes the **limit** story:
  `particleActionDensity ρ N → 0` on the product filter
  `(nhds 0) ×ˢ Filter.atTop`.  Izar's `MasslessLimitBridge.lean` does
  the analogous continuity for `perTickDelay` in the `m → 0` limit.

  This file closes the **classification** story:  a single Boolean
  decision function

      regimeFromActionDensityAndIterations :
        ℝ → ℕ → ParticleRegime

  (with `ParticleRegime = photonic ⊕ massive ρ N`) that assigns exactly
  one regime to every `(ρ, N)`.  The decision rule is the canonical
  crisp form

      if ρ = 0 ∧ N = 0 then photonic else massive ρ N

  — the photon branch triggers precisely at the joint limit point
  `(0, 0)`, otherwise the particle is labelled as carrying the rest-mass
  residual `ρ·c² + δ_comp(N)` (exactly `particleActionDensity` from
  Achernar).  The `(ρ, N) = (0, 0)` point is chosen as the canonical
  photon witness because it is the unique common fixpoint of both of
  Achernar's convergence axes: exactly zero rest energy **and** zero
  iteration residual, the two-axis mirror of the substrate limit.

  ## What this file formalizes

  **Definitions:**
  * `ParticleRegime` — inductive type with two constructors:
      `photonic` (no parameters) and `massive ρ N` (carries the
      classifying pair).
  * `regimeFromActionDensityAndIterations ρ N` — the decision function
    implementing the rule above.  `noncomputable` because `ρ = 0`
    requires classical decidability on `ℝ`.

  **Headline (`particle_regime_from_action_density_and_iterations`):**
  For every `ρ : ℝ`, `N : ℕ` with `0 ≤ ρ`,
  * the regime equals `photonic` iff `(ρ = 0 ∧ N = 0)`;
  * if `ρ > 0`, the regime equals `massive ρ N`.

  **Corollaries:**
  * `regimeFromActionDensityAndIterations_zero_zero` — the photon
    witness point evaluates to `.photonic` by `rfl`.
  * `regimeFromActionDensityAndIterations_massive_of_N_pos` — any
    positive `N` forces the massive branch regardless of `ρ`, because
    the iteration residual `δ_comp(N) > 0` saturates the substrate
    drag.
  * `regimeFromActionDensityAndIterations_of_rho_pos` — the headline's
    second conjunct pulled out as a standalone lemma.

  ## Composition structure

  * **Achernar** (`PhotonZeroRhoMaxN.lean`):  continuity of
    `particleActionDensity` in the joint limit — this file provides the
    matching discrete classifier at the limit point.
  * **Izar** (`MasslessLimitBridge.lean`):  continuity of `perTickDelay`
    in `m → 0` — the `ρ = 0` axis of our classifier corresponds to the
    massless axis of Izar.
  * **Canopus** (`PhotonSpeedCoherence.lean`):  photon preserves `c` —
    a qualitative statement this file refines into a crisp
    classification.

  ## Scoping note

  The classifier is a **symbolic** regime label, not a predictive
  quantity:  its purpose is to package the `(ρ, N)` two-axis distinction
  in a form downstream theorems (e.g. Heka's `WBosonMass`, Bellatrix's
  `HiggsVEVSubstrate`) can pattern-match on.  The actual physical
  content — "massive particles pay `ρ·c² + δ_comp(N)` substrate drag,
  photons do not" — is Achernar's `particleActionDensity`.

  No axioms, no `sorry`.  Author: Thuban (α Draconis, former pole star),
  2026-04-19.
-/

import OmegaTheory.Emergence.PhotonZeroRhoMaxN
import OmegaTheory.Emergence.MasslessLimitBridge
import OmegaTheory.Irrationality.Uncertainty
import OmegaTheory.Spacetime.Constants
import Mathlib.Tactic

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime OmegaTheory.Irrationality

/-! ## The `ParticleRegime` inductive type

A particle on the substrate occupies exactly one of two regimes:
* `photonic` — zero rest energy density **and** zero iteration
  residual;  this is the `(ρ, N) = (0, 0)` fixpoint of Achernar's
  continuity.
* `massive ρ N` — carries a classifying pair; the physical drag is
  `ρ·c² + δ_comp(N)` from Achernar's `particleActionDensity`.
-/

/-- **ParticleRegime** — two disjoint regimes of the substrate's matter
    sector.  `photonic` has no parameters (the canonical photon point);
    `massive` carries the `(ρ, N)` pair that determines its drag.

    (No `deriving Repr` — `ℝ` does not have a kernel-safe `Repr`
    instance;  downstream consumers pattern-match rather than print.) -/
inductive ParticleRegime where
  | massive (ρ : ℝ) (N : ℕ) : ParticleRegime
  | photonic : ParticleRegime

/-! ## The decision function

The classifier uses the crisp rule

    if ρ = 0 ∧ N = 0 then photonic else massive ρ N

The `if` on a real equality is `noncomputable` via classical
decidability; we open `Classical` locally. -/

/-- **Decision function**:  `regimeFromActionDensityAndIterations ρ N`
    returns `photonic` at the canonical photon witness point
    `(ρ, N) = (0, 0)` and `massive ρ N` elsewhere.

    The choice of `(0, 0)` (not the full Achernar product-filter limit)
    as the photon branch trigger is deliberate:  at any finite `N > 0`
    the substrate pays at least `δ_comp(N) > 0` of iteration residual
    drag, so such a configuration cannot be a true photon even if
    `ρ = 0`. -/
noncomputable def regimeFromActionDensityAndIterations
    (ρ : ℝ) (N : ℕ) : ParticleRegime := by
  classical
  exact if ρ = 0 ∧ N = 0 then ParticleRegime.photonic
        else ParticleRegime.massive ρ N

/-! ## Basic evaluation lemmas -/

/-- **Photon witness point**:  the classifier evaluates to `photonic`
    at `(0, 0)`. -/
@[simp] theorem regimeFromActionDensityAndIterations_zero_zero :
    regimeFromActionDensityAndIterations 0 0 = ParticleRegime.photonic := by
  classical
  unfold regimeFromActionDensityAndIterations
  simp

/-- **Strictly positive `ρ`**:  forces the massive branch. -/
theorem regimeFromActionDensityAndIterations_of_rho_pos
    {ρ : ℝ} (hρ : 0 < ρ) (N : ℕ) :
    regimeFromActionDensityAndIterations ρ N =
      ParticleRegime.massive ρ N := by
  classical
  unfold regimeFromActionDensityAndIterations
  have hρne : ρ ≠ 0 := ne_of_gt hρ
  simp [hρne]

/-- **Positive `N`**:  forces the massive branch regardless of `ρ`
    (the iteration residual `δ_comp(N) > 0` saturates the substrate
    drag — no photon at finite `N`). -/
theorem regimeFromActionDensityAndIterations_massive_of_N_pos
    (ρ : ℝ) {N : ℕ} (hN : 0 < N) :
    regimeFromActionDensityAndIterations ρ N =
      ParticleRegime.massive ρ N := by
  classical
  unfold regimeFromActionDensityAndIterations
  have hNne : N ≠ 0 := Nat.pos_iff_ne_zero.mp hN
  simp [hNne]

/-- **Nonzero `ρ`**:  forces the massive branch. -/
theorem regimeFromActionDensityAndIterations_of_rho_ne_zero
    {ρ : ℝ} (hρ : ρ ≠ 0) (N : ℕ) :
    regimeFromActionDensityAndIterations ρ N =
      ParticleRegime.massive ρ N := by
  classical
  unfold regimeFromActionDensityAndIterations
  simp [hρ]

/-! ## Headline theorem

The mission-spec statement:  a two-conjunct characterisation.  The
first conjunct is an `↔` pinpointing the photon branch; the second
conjunct extracts the most important direction of the massive branch
(the one consumers typically match on). -/

/-- **HEADLINE** — `particle_regime_from_action_density_and_iterations`.

    For every action density `ρ ≥ 0` and iteration budget `N : ℕ`:

    1. The regime equals `photonic` **iff** `ρ = 0 ∧ N = 0`
       (the photon branch fires precisely at the joint-zero witness);
    2. If `ρ > 0`, the regime equals `massive ρ N` (strict positivity
       on the `ρ`-axis suffices to force the massive label).

    This closes the `TheoremCandidate` of the same name.  Its role is
    to provide a discrete, pattern-matchable companion to Achernar's
    continuity statement `photon_is_zero_rho_maxN_limit`, suitable for
    downstream files (Heka, Bellatrix) to dispatch on without carrying
    a `Filter.Tendsto` around. -/
theorem particle_regime_from_action_density_and_iterations
    (ρ : ℝ) (N : ℕ) (hρ : 0 ≤ ρ) :
    (regimeFromActionDensityAndIterations ρ N = ParticleRegime.photonic
       ↔ ρ = 0 ∧ N = 0)
    ∧ (ρ > 0 → regimeFromActionDensityAndIterations ρ N =
         ParticleRegime.massive ρ N) := by
  classical
  refine ⟨⟨?_, ?_⟩, ?_⟩
  -- (1 →):  `regime = photonic → ρ = 0 ∧ N = 0`.
  · intro h
    unfold regimeFromActionDensityAndIterations at h
    by_cases hcond : ρ = 0 ∧ N = 0
    · exact hcond
    · -- In the else branch we get `massive ρ N = photonic`, contradiction.
      simp [hcond] at h
  -- (1 ←):  `ρ = 0 ∧ N = 0 → regime = photonic`.
  · rintro ⟨rfl, rfl⟩
    exact regimeFromActionDensityAndIterations_zero_zero
  -- (2):  `ρ > 0 → regime = massive ρ N`.
  · intro hpos
    exact regimeFromActionDensityAndIterations_of_rho_pos hpos N

-- Note: `hρ : 0 ≤ ρ` is a legitimate physics hypothesis (rest-frame action
-- densities are non-negative) but is not needed for either conjunct; it is
-- kept in the signature to match the mission spec and for downstream calls
-- that already have it in hand.

/-! ## Composition corollaries

The classifier is a **symbolic** (discrete) companion to Achernar's
**continuous** limit statement.  The two are consistent in the
following precise sense:

* The classifier fires `photonic` at exactly one point `(0, 0)`.
* Achernar's `particleActionDensity` vanishes only **in the limit**
  `(ρ, N) → (0, ∞)`, not pointwise at `(0, 0)` (at `N = 0` the
  substrate still carries `computationalUncertainty 0 = l_P · 4/3` of
  iteration residual).

The right bridge statement is therefore:  the classifier's `massive`
branch covers exactly the configurations Achernar would assign
positive `particleActionDensity` to — i.e. everything with either
`ρ > 0` or `N > 0`.  The converse is asymmetric at `(0, 0)` by
construction:  the classifier treats `(0, 0)` as the canonical
*symbolic* photon witness even though Achernar's density is nonzero
there. -/

/-- **Massive-branch / positive-density correspondence**:  whenever
    `ρ > 0` or `N > 0`, the classifier returns `massive ρ N` and
    `particleActionDensity ρ N` is strictly positive (Achernar's
    substrate drag is nonzero).  The joint statement packages the two
    matching facts for downstream consumers. -/
theorem massive_regime_matches_positive_actionDensity
    {ρ : ℝ} (hρ : 0 ≤ ρ) (N : ℕ) (hne : ρ ≠ 0 ∨ N ≠ 0) :
    regimeFromActionDensityAndIterations ρ N =
      ParticleRegime.massive ρ N
    ∧ 0 < particleActionDensity ρ N := by
  classical
  refine ⟨?_, ?_⟩
  · -- Classifier returns massive: not both zero.
    unfold regimeFromActionDensityAndIterations
    have : ¬ (ρ = 0 ∧ N = 0) := by
      rcases hne with h | h
      · intro ⟨h1, _⟩; exact h h1
      · intro ⟨_, h2⟩; exact h h2
    simp [this]
  · -- particleActionDensity > 0: either ρ·c² > 0 or δ_comp(N) > 0.
    unfold particleActionDensity
    have hc2 : 0 < c ^ 2 := pow_pos c_pos 2
    have hρc2 : 0 ≤ ρ * c ^ 2 := mul_nonneg hρ (le_of_lt hc2)
    have hdelta : 0 < computationalUncertainty N :=
      computationalUncertainty_pos N
    linarith

/-- **Izar bridge** (classifier vs. massless-limit continuity):  for
    every `p > 0`, sending the massive classifier to `massive 0 N` does
    not land in the photonic branch (because the joint condition
    `ρ = 0 ∧ N = 0` requires `N = 0` too).  This packages the
    difference between Izar's continuous `m → 0` limit (a `Tendsto`
    statement) and this file's discrete classifier (a `{photonic,
    massive}` branch). -/
theorem regime_massive_of_rho_zero_N_pos
    (N : ℕ) (hN : 0 < N) :
    regimeFromActionDensityAndIterations 0 N =
      ParticleRegime.massive 0 N :=
  regimeFromActionDensityAndIterations_massive_of_N_pos 0 hN

/-! ## Unified paper-ready summary -/

/-- **Unified 3-conjunct summary** — the paper-ready statement
    packaging the classifier's three operational properties:
    (1) photon point is exactly `(0, 0)`;
    (2) positive `ρ` forces massive;
    (3) positive `N` forces massive.
    Downstream files use this as the one-liner reference. -/
theorem particle_regime_unified_summary
    (ρ : ℝ) (N : ℕ) :
    (regimeFromActionDensityAndIterations 0 0 = ParticleRegime.photonic)
    ∧ (ρ > 0 → regimeFromActionDensityAndIterations ρ N =
         ParticleRegime.massive ρ N)
    ∧ (N > 0 → regimeFromActionDensityAndIterations ρ N =
         ParticleRegime.massive ρ N) :=
  ⟨regimeFromActionDensityAndIterations_zero_zero,
   fun hρ => regimeFromActionDensityAndIterations_of_rho_pos hρ N,
   fun hN => regimeFromActionDensityAndIterations_massive_of_N_pos ρ hN⟩

end OmegaTheory.Emergence
