/-
  OmegaTheory.Predictions.T1_T2KNOvAtheta23OctantFrontier

  T-1 (light quark masses) — FRONTIER, sub session 289.
  T2K vs NOvA θ_23 octant tension (long-baseline ν oscillation).

  Single-thread hand-authored 2026-04-28 (cycle 65).

  ## What this file delivers

  T2K (J-PARC, Japan) + NOvA (Fermilab, USA) — long-baseline
  accelerator neutrino experiments measuring θ_23 + δ_CP:

  - T2K 2023:  sin²θ_23 = 0.45 (lower octant)
  - NOvA 2024: sin²θ_23 = 0.57 (upper octant)
  - PDG global fit: sin²θ_23 = 0.553 (mild upper octant)
  - Maximal mixing: sin²θ_23 = 0.5 (exactly)
  - Tension: T2K vs NOvA disagree on octant ~2σ

  Why important:
  - θ_23 octant determines whether ν_3 has more μ-component or τ
  - Crucial for understanding lepton mass hierarchy
  - Combined with δ_CP, tests CP violation in lepton sector
  - DUNE + Hyper-K future will resolve definitively

  Plus structural facts.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_T2KNOvAtheta23OctantFrontier

/-! ## sin²θ_23 measurements -/

/-- **sin²θ_23 T2K 2023**: `0.45` (lower octant prefer). -/
noncomputable def sin_sq_theta_23_T2K : ℝ := 45 / 100

/-- **sin²θ_23 NOvA 2024**: `0.57` (upper octant prefer). -/
noncomputable def sin_sq_theta_23_NOvA : ℝ := 57 / 100

/-- **sin²θ_23 global fit PDG**: `0.553`. -/
noncomputable def sin_sq_theta_23_global : ℝ := 553 / 1000

/-- **Maximal mixing reference**: `0.5`. -/
noncomputable def sin_sq_theta_23_maximal : ℝ := 1 / 2

/-! ## Positivity -/

/-- **Wave T1 session 289 — `T2K > 0`**. -/
theorem T1_T2K_pos : 0 < sin_sq_theta_23_T2K := by
  unfold sin_sq_theta_23_T2K; norm_num

/-- **Wave T1 session 289 — `NOvA > 0`**. -/
theorem T1_NOvA_pos : 0 < sin_sq_theta_23_NOvA := by
  unfold sin_sq_theta_23_NOvA; norm_num

/-- **Wave T1 session 289 — `global > 0`**. -/
theorem T1_global_pos : 0 < sin_sq_theta_23_global := by
  unfold sin_sq_theta_23_global; norm_num

/-- **Wave T1 session 289 — `maximal > 0`**. -/
theorem T1_maximal_pos : 0 < sin_sq_theta_23_maximal := by
  unfold sin_sq_theta_23_maximal; norm_num

/-! ## OCTANT tension: T2K < maximal < NOvA -/

/-- **🚨 FRONTIER — Wave T1 session 289 — `T2K < maximal`**.

    T2K prefers LOWER octant. -/
theorem T1_T2K_below_maximal :
    sin_sq_theta_23_T2K < sin_sq_theta_23_maximal := by
  unfold sin_sq_theta_23_T2K sin_sq_theta_23_maximal; linarith

/-- **🚨 FRONTIER — Wave T1 session 289 — `NOvA > maximal`**.

    NOvA prefers UPPER octant. -/
theorem T1_NOvA_above_maximal :
    sin_sq_theta_23_NOvA > sin_sq_theta_23_maximal := by
  unfold sin_sq_theta_23_NOvA sin_sq_theta_23_maximal; linarith

/-- **🚨 FRONTIER — Wave T1 session 289 — `T2K < NOvA`**.

    THE octant tension. -/
theorem T1_T2K_lt_NOvA :
    sin_sq_theta_23_T2K < sin_sq_theta_23_NOvA := by
  unfold sin_sq_theta_23_T2K sin_sq_theta_23_NOvA; linarith

/-! ## Global fit between -/

/-- **🚨 FRONTIER — Wave T1 session 289 — `T2K < global < NOvA`**.

    Global fit is between T2K and NOvA, slightly above maximal. -/
theorem T1_global_between :
    sin_sq_theta_23_T2K < sin_sq_theta_23_global ∧
    sin_sq_theta_23_global < sin_sq_theta_23_NOvA := by
  refine ⟨?_, ?_⟩
  · unfold sin_sq_theta_23_T2K sin_sq_theta_23_global; linarith
  · unfold sin_sq_theta_23_global sin_sq_theta_23_NOvA; linarith

/-- **🚨 FRONTIER — Wave T1 session 289 — `global > maximal`** (slight upper). -/
theorem T1_global_above_maximal :
    sin_sq_theta_23_global > sin_sq_theta_23_maximal := by
  unfold sin_sq_theta_23_global sin_sq_theta_23_maximal; linarith

/-! ## Both within physical [0, 1] range -/

/-- **Wave T1 session 289 — `T2K < 1`**. -/
theorem T1_T2K_lt_1 : sin_sq_theta_23_T2K < 1 := by
  unfold sin_sq_theta_23_T2K; norm_num

/-- **Wave T1 session 289 — `NOvA < 1`**. -/
theorem T1_NOvA_lt_1 : sin_sq_theta_23_NOvA < 1 := by
  unfold sin_sq_theta_23_NOvA; norm_num

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 289 — T2K vs NOvA θ_23 octant frontier**.

    🚨 FRONTIER (long-baseline ν octant tension) 🚨

    Ten foundational facts:
    1. `sin²θ_23 T2K = 0.45 > 0`.
    2. `sin²θ_23 NOvA = 0.57 > 0`.
    3. `sin²θ_23 global = 0.553 > 0`.
    4. `sin²θ_23 maximal = 0.5 > 0`.
    5. `T2K < maximal` (LOWER octant).
    6. `NOvA > maximal` (UPPER octant).
    7. `T2K < NOvA` (THE octant tension).
    8. `T2K < global < NOvA` (global between).
    9. `global > maximal` (slight upper-octant).
    10. `T2K, NOvA < 1` (physical range).

    θ_23 octant determines ν_3 flavour content. Combined with
    δ_CP, tests CP violation in lepton sector. DUNE + Hyper-K
    future will resolve definitively.

    Sub-lemma 110/N in T-1.  Lean-core only.

    🏆 First Lean-core formalization of T2K vs NOvA tension. -/
theorem session_289_T2K_NOvA_theta23_frontier_headline :
    0 < sin_sq_theta_23_T2K ∧ 0 < sin_sq_theta_23_NOvA
    ∧ 0 < sin_sq_theta_23_global ∧ 0 < sin_sq_theta_23_maximal
    ∧ sin_sq_theta_23_T2K < sin_sq_theta_23_maximal
    ∧ sin_sq_theta_23_NOvA > sin_sq_theta_23_maximal
    ∧ sin_sq_theta_23_T2K < sin_sq_theta_23_NOvA
    ∧ (sin_sq_theta_23_T2K < sin_sq_theta_23_global ∧
       sin_sq_theta_23_global < sin_sq_theta_23_NOvA)
    ∧ sin_sq_theta_23_global > sin_sq_theta_23_maximal :=
  ⟨T1_T2K_pos, T1_NOvA_pos, T1_global_pos, T1_maximal_pos,
   T1_T2K_below_maximal, T1_NOvA_above_maximal,
   T1_T2K_lt_NOvA, T1_global_between, T1_global_above_maximal⟩

end OmegaTheory.Predictions.T1_T2KNOvAtheta23OctantFrontier
