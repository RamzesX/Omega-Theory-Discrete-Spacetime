/-
  OmegaTheory.Predictions.T1_NuclearPhysicsScalesBundle

  T-1 — nuclear physics scales bundle, sessions 488-492.

  Single-thread hand-authored 2026-04-28. Bundled-commit per protocol.

  ## What this file delivers

  Five anchored nuclear-physics numeric scales (PDG / standard values):

  - s488: nuclear charge radius constant `R_0 = 1.2 fm`
          (semi-empirical formula `R(A) = R_0 × A^(1/3)`)
  - s489: ⁵⁶Fe binding energy per nucleon `B/A = 8.79 MeV`
          (peak of the binding-energy curve — most-stable iron)
  - s490: deuteron binding energy `B_d = 2.225 MeV`
          (lightest stable bound nucleus)
  - s491: alpha particle (⁴He) binding energy `B_α = 28.3 MeV`
          (≈ 7.07 MeV/A, anchor of α-decay energetics)
  - s492: bundle composition Prop + binding-energy ordering
          (`B_d < B_α` and `B/A` of ⁵⁶Fe inside `[8, 9]` MeV/nucleon band)

  ## Substrate framing

  These scales sit one rung above ΛQCD (see T1_HadronMassFromLambdaQCDScaffold,
  s319) and one rung below atomic physics. Every value is positive, in its
  expected band, and the binding-energy ordering reflects the standard
  semi-empirical mass formula intuition without literature citation.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

namespace OmegaTheory.Predictions.T1_NuclearPhysicsScalesBundle

/-! ## Anchored nuclear-physics values

We store every value as a positive rational so that `norm_num` discharges
positivity, value, and band predicates by kernel reduction.
-/

/-- **R_0 — nuclear radius constant in fm × 10**: `12 / 10 = 1.2`.

    Used in `R(A) = R_0 × A^(1/3)` for nuclear charge-radius scaling. -/
noncomputable def R_0_fm : ℝ := 12 / 10

/-- **B/A — ⁵⁶Fe binding energy per nucleon in MeV × 100**: `879 / 100 = 8.79`.

    Iron-56 sits at the peak of the binding-energy curve. -/
noncomputable def B_per_A_Fe56_MeV : ℝ := 879 / 100

/-- **B_d — deuteron binding energy in MeV × 1000**: `2225 / 1000 = 2.225`.

    Lightest stable bound nucleus (proton + neutron). -/
noncomputable def B_deuteron_MeV : ℝ := 2225 / 1000

/-- **B_α — ⁴He binding energy in MeV × 10**: `283 / 10 = 28.3`.

    Alpha particle: very tightly-bound 4-nucleon shell-closure system. -/
noncomputable def B_alpha_MeV : ℝ := 283 / 10

/-! ## Positivity (s488-s491 base) -/

/-- **🚨 s488 — `R_0 > 0`**. -/
theorem T1_R_0_pos : 0 < R_0_fm := by
  unfold R_0_fm; norm_num

/-- **🚨 s489 — `B/A(⁵⁶Fe) > 0`**. -/
theorem T1_B_per_A_Fe56_pos : 0 < B_per_A_Fe56_MeV := by
  unfold B_per_A_Fe56_MeV; norm_num

/-- **🚨 s490 — `B_d > 0`**. -/
theorem T1_B_deuteron_pos : 0 < B_deuteron_MeV := by
  unfold B_deuteron_MeV; norm_num

/-- **🚨 s491 — `B_α > 0`**. -/
theorem T1_B_alpha_pos : 0 < B_alpha_MeV := by
  unfold B_alpha_MeV; norm_num

/-! ## R_0 = 1.2 fm band -/

/-- **🚨 s488 — `R_0 > 1` fm**. -/
theorem T1_R_0_above_1 : R_0_fm > 1 := by
  unfold R_0_fm; norm_num

/-- **🚨 s488 — `R_0 < 2` fm**. -/
theorem T1_R_0_below_2 : R_0_fm < 2 := by
  unfold R_0_fm; norm_num

/-- **🚨 s488 — `1 < R_0 < 2` fm band**. -/
theorem T1_R_0_in_1_2_band : 1 < R_0_fm ∧ R_0_fm < 2 :=
  ⟨T1_R_0_above_1, T1_R_0_below_2⟩

/-! ## ⁵⁶Fe binding energy: 8.79 MeV/A inside [8,9] -/

/-- **🚨 s489 — `B/A(⁵⁶Fe) > 8` MeV**. -/
theorem T1_B_per_A_Fe56_above_8 : B_per_A_Fe56_MeV > 8 := by
  unfold B_per_A_Fe56_MeV; norm_num

/-- **🚨 s489 — `B/A(⁵⁶Fe) < 9` MeV**. -/
theorem T1_B_per_A_Fe56_below_9 : B_per_A_Fe56_MeV < 9 := by
  unfold B_per_A_Fe56_MeV; norm_num

/-- **🚨 s489 — `8 < B/A(⁵⁶Fe) < 9` band**. -/
theorem T1_B_per_A_Fe56_in_8_9_band :
    8 < B_per_A_Fe56_MeV ∧ B_per_A_Fe56_MeV < 9 :=
  ⟨T1_B_per_A_Fe56_above_8, T1_B_per_A_Fe56_below_9⟩

/-! ## Deuteron 2.225 MeV inside [2,3] -/

/-- **🚨 s490 — `B_d > 2` MeV**. -/
theorem T1_B_deuteron_above_2 : B_deuteron_MeV > 2 := by
  unfold B_deuteron_MeV; norm_num

/-- **🚨 s490 — `B_d < 3` MeV**. -/
theorem T1_B_deuteron_below_3 : B_deuteron_MeV < 3 := by
  unfold B_deuteron_MeV; norm_num

/-- **🚨 s490 — `2 < B_d < 3` band**. -/
theorem T1_B_deuteron_in_2_3_band :
    2 < B_deuteron_MeV ∧ B_deuteron_MeV < 3 :=
  ⟨T1_B_deuteron_above_2, T1_B_deuteron_below_3⟩

/-! ## Alpha 28.3 MeV inside [28, 29] -/

/-- **🚨 s491 — `B_α > 28` MeV**. -/
theorem T1_B_alpha_above_28 : B_alpha_MeV > 28 := by
  unfold B_alpha_MeV; norm_num

/-- **🚨 s491 — `B_α < 29` MeV**. -/
theorem T1_B_alpha_below_29 : B_alpha_MeV < 29 := by
  unfold B_alpha_MeV; norm_num

/-- **🚨 s491 — `28 < B_α < 29` band**. -/
theorem T1_B_alpha_in_28_29_band :
    28 < B_alpha_MeV ∧ B_alpha_MeV < 29 :=
  ⟨T1_B_alpha_above_28, T1_B_alpha_below_29⟩

/-- **🚨 s491 — `B_α / 4 ≈ 7.075` MeV/A — within [7, 8]**. -/
theorem T1_B_alpha_per_A_in_7_8_band :
    7 < B_alpha_MeV / 4 ∧ B_alpha_MeV / 4 < 8 := by
  unfold B_alpha_MeV; refine ⟨?_, ?_⟩ <;> norm_num

/-! ## Binding-energy ordering (s492 composition input) -/

/-- **🚨 s492 — `B_d < B_α`** (deuteron less bound than alpha). -/
theorem T1_B_deuteron_lt_B_alpha : B_deuteron_MeV < B_alpha_MeV := by
  unfold B_deuteron_MeV B_alpha_MeV; norm_num

/-- **🚨 s492 — `B_α < 56 × B/A(⁵⁶Fe)`**: ⁵⁶Fe total > alpha total
    (56 × 8.79 = 492.24 vs 28.3). -/
theorem T1_B_alpha_lt_56_BperA_Fe :
    B_alpha_MeV < 56 * B_per_A_Fe56_MeV := by
  unfold B_alpha_MeV B_per_A_Fe56_MeV; norm_num

/-- **🚨 s492 — `B_d < B/A(⁵⁶Fe)`** (per-nucleon: deuteron weaker). -/
theorem T1_B_deuteron_lt_BperA_Fe :
    B_deuteron_MeV < B_per_A_Fe56_MeV := by
  unfold B_deuteron_MeV B_per_A_Fe56_MeV; norm_num

/-! ## Composition Prop -/

/-- **NuclearPhysicsScalesConsistency** — five-conjunct band predicate.

    Real Prop body composing all five sessions' bands. -/
def NuclearPhysicsScalesConsistency : Prop :=
  -- s488: nuclear radius constant in (1, 2) fm
  (1 < R_0_fm ∧ R_0_fm < 2) ∧
  -- s489: ⁵⁶Fe binding energy per nucleon in (8, 9) MeV
  (8 < B_per_A_Fe56_MeV ∧ B_per_A_Fe56_MeV < 9) ∧
  -- s490: deuteron in (2, 3) MeV
  (2 < B_deuteron_MeV ∧ B_deuteron_MeV < 3) ∧
  -- s491: alpha in (28, 29) MeV
  (28 < B_alpha_MeV ∧ B_alpha_MeV < 29) ∧
  -- s492: ordering deuteron < alpha and per-nucleon deuteron < ⁵⁶Fe
  (B_deuteron_MeV < B_alpha_MeV ∧ B_deuteron_MeV < B_per_A_Fe56_MeV)

/-- **🚨 s492 — `NuclearPhysicsScalesConsistency`**. -/
theorem T1_nuclear_physics_scales_consistency :
    NuclearPhysicsScalesConsistency :=
  ⟨T1_R_0_in_1_2_band,
   T1_B_per_A_Fe56_in_8_9_band,
   T1_B_deuteron_in_2_3_band,
   T1_B_alpha_in_28_29_band,
   ⟨T1_B_deuteron_lt_B_alpha, T1_B_deuteron_lt_BperA_Fe⟩⟩

/-! ## Headline -/

/-- **HEADLINE — sessions 488-492 — nuclear physics scales bundle**.

    🏆 Bundled-commit per protocol. 5 sessions:

    - s488: `R_0 = 1.2` fm — nuclear-radius constant in `R(A) = R_0 A^(1/3)`
    - s489: `B/A(⁵⁶Fe) = 8.79` MeV — peak of binding-energy curve
    - s490: `B_d = 2.225` MeV — deuteron binding energy
    - s491: `B_α = 28.3` MeV — alpha particle binding (~7 MeV/A)
    - s492: bundle composition + ordering `B_d < B_α` and `B_d < B/A(⁵⁶Fe)`

    Plus `NuclearPhysicsScalesConsistency` Prop (5-conjunct of bands +
    ordering).

    Twelve-conjunct headline:

    1. positivity (4 base scales),
    2. R_0 ∈ (1, 2) fm,
    3. ⁵⁶Fe B/A ∈ (8, 9) MeV,
    4. deuteron B_d ∈ (2, 3) MeV,
    5. alpha B_α ∈ (28, 29) MeV,
    6. alpha per-nucleon B_α/4 ∈ (7, 8) MeV,
    7. ordering B_d < B_α,
    8. per-nucleon ordering B_d < B/A(⁵⁶Fe),
    9. ⁵⁶Fe total > alpha total (B_α < 56·B/A),
    10. composition Prop.

    Sub-lemma 488-492/N in T-1.  Lean-core only. NO STUBS. -/
theorem session_488_to_492_nuclear_physics_scales_bundle_headline :
    0 < R_0_fm ∧ 0 < B_per_A_Fe56_MeV ∧ 0 < B_deuteron_MeV ∧ 0 < B_alpha_MeV
    ∧ (1 < R_0_fm ∧ R_0_fm < 2)
    ∧ (8 < B_per_A_Fe56_MeV ∧ B_per_A_Fe56_MeV < 9)
    ∧ (2 < B_deuteron_MeV ∧ B_deuteron_MeV < 3)
    ∧ (28 < B_alpha_MeV ∧ B_alpha_MeV < 29)
    ∧ (7 < B_alpha_MeV / 4 ∧ B_alpha_MeV / 4 < 8)
    ∧ B_deuteron_MeV < B_alpha_MeV
    ∧ B_deuteron_MeV < B_per_A_Fe56_MeV
    ∧ B_alpha_MeV < 56 * B_per_A_Fe56_MeV
    ∧ NuclearPhysicsScalesConsistency :=
  ⟨T1_R_0_pos, T1_B_per_A_Fe56_pos, T1_B_deuteron_pos, T1_B_alpha_pos,
   T1_R_0_in_1_2_band,
   T1_B_per_A_Fe56_in_8_9_band,
   T1_B_deuteron_in_2_3_band,
   T1_B_alpha_in_28_29_band,
   T1_B_alpha_per_A_in_7_8_band,
   T1_B_deuteron_lt_B_alpha,
   T1_B_deuteron_lt_BperA_Fe,
   T1_B_alpha_lt_56_BperA_Fe,
   T1_nuclear_physics_scales_consistency⟩

end OmegaTheory.Predictions.T1_NuclearPhysicsScalesBundle
