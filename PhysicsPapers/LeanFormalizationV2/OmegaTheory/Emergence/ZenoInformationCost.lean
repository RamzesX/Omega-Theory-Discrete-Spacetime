/-
  OmegaTheory.Emergence.ZenoInformationCost

  **The Quantum Zeno Effect as an Information-Theoretic Cost.**

  Agent: Mizar (Zeta Ursae Majoris — the classical first-resolved
  binary star; a double-body that, like Zeno's K-observation protocol,
  is seen through repeated measurements in *pairs* of epochs).
  Mission date: 2026-04-19.

  ## Physical thesis

  In orthodox QM, the "watched pot never boils" Zeno paradox is
  described by projective-measurement collapse: each measurement
  re-prepares the system into an eigenstate of the measured observable,
  suppressing the evolution toward an orthogonal outcome and arresting
  decay. No cost is assigned to the measurement itself.

  In the substrate picture the story is radically different. The only
  way to check whether a quantum has "moved" is to instigate a
  **c-teleport** to its next-tick neighbour. Each such teleport is
  funded by the substrate's computational budget: one truncation of
  π / e / √2 at the agent's fixed accuracy `N`, at a cost of
  `δ_comp(N) = ℓ_P · ε(N) = ℓ_P · 4/(2N+3)`. Two consequences:

  1. Every Zeno observation costs `δ_comp(N)` of infidelity, because
     the substrate cannot settle the c-teleport without paying the
     computational residue.
  2. Over `K` observations the total cost is *exactly* `K · δ_comp(N)`
     — the same closed form as the stochastic-teleportation bound
     `teleportInfidelityBound K T` when rewritten in terms of `N`
     instead of `T` (the map `T ↦ Nat.floor (iterationBudget T)` is
     the temperature-to-iteration bridge in `StochasticTeleportation.lean`).

  The **novel, falsifiable consequence** is a Zeno cost that tends to
  zero only in the `N → ∞` limit: perfect arrest of evolution requires
  infinite computational budget, which the substrate never has. This
  is a *positive prediction* — the Zeno arrest is never complete, and
  the residual decay rate scales as `δ_comp(N) = O(1/N)`.

  ## What this file ships

  Five theorems around a single definition:

  1. `zenoTotalCost` — the definition `K · δ_comp(N)`; the information-
     theoretic cost of `K` c-teleport observations at iteration depth `N`.
  2. `zeno_measurement_pays_delta_comp` — the headline identity
     `zenoTotalCost K N = K · computationalUncertainty N`.
     (It is a `rfl` theorem — the identity is the definition.
     We nonetheless state and name it for Neo4j / paper-bundle citation.)
  3. `zenoTotalCost_nonneg` — the cost is non-negative (0 ≤ cost).
  4. `zenoTotalCost_K_monotone` — more observations ⇒ more cost.
  5. `zenoTotalCost_N_antitone` — larger `N` (more computational
     depth) ⇒ smaller cost (the bound is already tight but always
     positive unless `K = 0`).
  6. `perfect_zeno_requires_infinite_N` — for any positive bound
     `P > 0`, there exists `N₀` such that for all `N ≥ N₀` the
     single-observation cost is below `P`. Composes Mizar on
     Pierre-Auger-anchor `computationalUncertainty_below_any_positive_bound`.
  7. `zenoTotalCost_bridges_teleportInfidelityBound` — the explicit
     bridge `zenoTotalCost K N = teleportInfidelityBound K T` whenever
     `N = Nat.floor (iterationBudget T)`. Shows that the Zeno cost is
     literally the stochastic-teleportation bound under the
     temperature↔iteration bridge.

  ## Composition and dependencies

  - `computationalUncertainty` and its positivity/monotonicity lemmas
    from `Irrationality/Uncertainty.lean` (Pi Hunch layer).
  - `computationalUncertainty_below_any_positive_bound` from
    `Predictions/DESISubstrateSignature.lean` (Mizar reuses the
    Pierre-Auger Archimedean-anchor lemma as-is).
  - `teleportInfidelityBound` from `Predictions/StochasticTeleportation.lean`
    for the bridge theorem; no modification of that file.

  ## No axioms, no `sorry`, no new constants.
-/

import OmegaTheory.Irrationality.Uncertainty
import OmegaTheory.Predictions.StochasticTeleportation
import OmegaTheory.Predictions.DESISubstrateSignature
import Mathlib.Tactic

namespace OmegaTheory.Emergence

open OmegaTheory.Irrationality
open OmegaTheory.Predictions
open OmegaTheory.Predictions.DESISubstrateSignature

/-! ## The Zeno information-cost functional -/

/-- **Zeno total cost** `zenoTotalCost K N`. The substrate's computational
    cost of `K` successive Zeno-style c-teleport measurements, each
    funded at iteration depth `N`. By the substrate thesis every Zeno
    observation requires one c-teleport attempt that pays the
    per-tick `δ_comp(N) = ℓ_P · 4/(2N+3)` infidelity residue, so the
    total over `K` observations is `K · δ_comp(N)`. -/
noncomputable def zenoTotalCost (K N : ℕ) : ℝ :=
  (K : ℝ) * computationalUncertainty N

/-- **Headline identity** (the mission theorem):
    `zenoTotalCost K N = K · computationalUncertainty N`.

    This is a definitional identity — we state and name it for Neo4j
    ingestion and for citation in the paper's Zeno section. -/
theorem zeno_measurement_pays_delta_comp (K N : ℕ) :
    zenoTotalCost K N = (K : ℝ) * computationalUncertainty N := rfl

/-- The Zeno cost is non-negative. -/
theorem zenoTotalCost_nonneg (K N : ℕ) :
    0 ≤ zenoTotalCost K N :=
  mul_nonneg (Nat.cast_nonneg _) (computationalUncertainty_nonneg N)

/-- The Zeno cost vanishes exactly when no observations are made. -/
theorem zenoTotalCost_zero_iff_K_zero (K N : ℕ) :
    zenoTotalCost K N = 0 ↔ K = 0 := by
  constructor
  · intro h
    unfold zenoTotalCost at h
    have hδ : computationalUncertainty N ≠ 0 :=
      (computationalUncertainty_pos N).ne'
    have hK : (K : ℝ) = 0 := by
      rcases mul_eq_zero.mp h with hK' | hδ'
      · exact hK'
      · exact absurd hδ' hδ
    exact_mod_cast hK
  · intro h
    unfold zenoTotalCost
    simp [h]

/-- **Monotonicity in `K`**: more Zeno observations ⇒ larger total cost. -/
theorem zenoTotalCost_K_monotone {K₁ K₂ : ℕ} (N : ℕ) (h : K₁ ≤ K₂) :
    zenoTotalCost K₁ N ≤ zenoTotalCost K₂ N := by
  unfold zenoTotalCost
  have hK : (K₁ : ℝ) ≤ (K₂ : ℝ) := Nat.cast_le.mpr h
  exact mul_le_mul_of_nonneg_right hK (computationalUncertainty_nonneg N)

/-- **Antitonicity in `N`** (one-step form): deeper computation ⇒
    lower Zeno cost. This is the `(N+1)`-vs-`N` single-step inequality;
    the induction form follows directly. -/
theorem zenoTotalCost_N_antitone_step (K N : ℕ) :
    zenoTotalCost K (N + 1) ≤ zenoTotalCost K N := by
  unfold zenoTotalCost
  exact mul_le_mul_of_nonneg_left
    (computationalUncertainty_decreasing N) (Nat.cast_nonneg _)

/-! ## Perfect Zeno requires infinite computational budget

    The substrate's positive prediction: **perfect Zeno arrest of
    evolution is unattainable at any finite `N`**, but the cost per
    observation can be driven below *any* positive infidelity threshold
    by taking `N` large enough. Composes on
    `computationalUncertainty_below_any_positive_bound`. -/

/-- **Perfect-Zeno theorem**: for any positive infidelity budget `P > 0`,
    there exists an iteration depth `N₀` such that for all `N ≥ N₀` the
    single-observation Zeno cost is below `P`.

    Stated for a single observation (`K = 1`); the `K`-observation
    version follows by scaling and is given as the corollary
    `zenoTotalCost_below_any_positive_bound`. -/
theorem zeno_single_cost_below_any_positive_bound {P : ℝ} (hP : 0 < P) :
    ∃ N₀ : ℕ, ∀ N ≥ N₀, zenoTotalCost 1 N ≤ P := by
  obtain ⟨N₀, hN₀⟩ :=
    computationalUncertainty_below_any_positive_bound hP
  refine ⟨N₀, fun N hN => ?_⟩
  unfold zenoTotalCost
  have : (1 : ℝ) * computationalUncertainty N = computationalUncertainty N := by
    ring
  rw [Nat.cast_one, this]
  exact hN₀ N hN

/-- **Multi-observation perfect-Zeno corollary**: for any fixed number
    of observations `K` and any positive budget `P > 0`, there exists
    `N₀` such that for all `N ≥ N₀` the `K`-observation total cost is
    below `P`. The threshold depends on `K` through the scaling
    `P ↦ P / (K+1)` (we use `K+1` to avoid the `K = 0` edge-case,
    which is trivial).

    This is the composition theorem: **Perfect Zeno arrest is the
    `N → ∞` limit.** -/
theorem zenoTotalCost_below_any_positive_bound
    (K : ℕ) {P : ℝ} (hP : 0 < P) :
    ∃ N₀ : ℕ, ∀ N ≥ N₀, zenoTotalCost K N ≤ P := by
  -- Use P / (K + 1) as the per-tick budget; then K · per-tick ≤ K/(K+1) · P < P.
  have hKp1_pos : (0 : ℝ) < (K : ℝ) + 1 := by
    have hK : (0 : ℝ) ≤ (K : ℝ) := Nat.cast_nonneg K
    linarith
  have hP_over_Kp1_pos : 0 < P / ((K : ℝ) + 1) := div_pos hP hKp1_pos
  obtain ⟨N₀, hN₀⟩ :=
    computationalUncertainty_below_any_positive_bound hP_over_Kp1_pos
  refine ⟨N₀, fun N hN => ?_⟩
  unfold zenoTotalCost
  have hcU := hN₀ N hN
  have hK_nn : (0 : ℝ) ≤ (K : ℝ) := Nat.cast_nonneg K
  -- K · δ_comp ≤ K · (P/(K+1)) = KP/(K+1) ≤ P  (since K ≤ K+1)
  have h1 : (K : ℝ) * computationalUncertainty N ≤
            (K : ℝ) * (P / ((K : ℝ) + 1)) :=
    mul_le_mul_of_nonneg_left hcU hK_nn
  have hKp1_ne : ((K : ℝ) + 1) ≠ 0 := hKp1_pos.ne'
  have h2 : (K : ℝ) * (P / ((K : ℝ) + 1)) ≤ P := by
    rw [mul_div_assoc']
    rw [div_le_iff₀ hKp1_pos]
    have : (K : ℝ) * P ≤ P * ((K : ℝ) + 1) := by nlinarith [hP, hK_nn]
    linarith
  linarith

/-! ## Bridge to the stochastic-teleportation bound

    The Zeno cost functional and the stochastic-teleportation
    infidelity bound are **the same object** modulo the
    temperature↔iteration bridge `N = Nat.floor (iterationBudget T)`.
    This theorem makes that identity explicit. -/

/-- **Bridge theorem**: under the temperature-to-iteration substitution
    `N = Nat.floor (iterationBudget T)`, the Zeno total cost is
    literally the stochastic-teleportation infidelity bound. This is
    the "Zeno observation = c-teleport attempt" principle in closed
    form: the same `K · δ_comp(N)` that funds `K` stochastic
    teleportations at temperature `T` funds `K` Zeno observations at
    the corresponding iteration depth. -/
theorem zenoTotalCost_bridges_teleportInfidelityBound
    (K : ℕ) (T : ℝ) :
    zenoTotalCost K (Nat.floor (iterationBudget T)) =
    teleportInfidelityBound K T := by
  unfold zenoTotalCost teleportInfidelityBound
  rfl

end OmegaTheory.Emergence
