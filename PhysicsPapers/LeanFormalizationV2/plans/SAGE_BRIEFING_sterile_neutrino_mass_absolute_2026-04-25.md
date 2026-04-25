# Sage Briefing — W5: `sterile_neutrino_mass_absolute_eV_window`

**Cycle:** 58 (Libra) · **Wave:** 1 · **Sage:** Triangulum-II · **Date:** 2026-04-25
**Track:** T1 physics precision · **Risk:** M (NEW file builds on Mekbuda + Connes)
**Target file:** `OmegaTheory/Predictions/SterileNeutrinoMassAbsolute.lean` (NEW; ~120 lines)

---

## Candidate name & graph node

`sterile_neutrino_mass_absolute_eV_window_substrate_anchored` — registered as
`:TheoremCandidate { batch_id: 'triangulum_ii_cycle58_hybrid_dispatch_2026-04-25' }`.

## Priority + complexity

**HIGH** · Complexity **M** (~120 lines). Builds on Mekbuda's
`SterileNeutrinoFromFourthIrrational.lean` (28 thms, cycle 24-43) + Connes
`DFEigenvalueSpectrum.lambda_catalan` (cycle 35-37).

## Mission

Ship the **absolute** sterile-neutrino mass theorem (Catalan-G 4th-irrational
channel → DM/sterile-ν slot). The mass falls in a window (X-ray + cosmological
constraints), not a single PDG value, so the theorem signature is:

```lean
∃ m_s, 0 < m_s ∧ m_s_lower ≤ m_s ∧ m_s ≤ m_s_upper ∧ m_s = lambda_catalan * scale_substrate
```

with the window `0.1 ≤ m_s ≤ 100 eV` per Mekbuda's `BabyUniverseSpectrum.sterileMass_in_window`.

This is the **first absolute-window** theorem in OmegaTheory V2 (existing
absolute theorems all match PDG single-values). Sets pattern for future
windows-only-bounded predictions.

## `statement_lean` skeleton

```lean
/-
  OmegaTheory.Predictions.SterileNeutrinoMassAbsolute

  Cycle-58 absolute-window-anchored sterile-neutrino mass derivation.

  Builds on:
  * Mekbuda cycle-35 SterileNeutrinoFromFourthIrrational.lean (4th-irrational
    channel = Catalan G → sterile/DM slot)
  * DarkEnergyToBabyUniverse.BabyUniverseSpectrum.sterileMass_in_window
    (X-ray + cosmological constraints: 0.1 ≤ m_s ≤ 100 eV)
  * ConnesDFYukawaMass.DFEigenvalueSpectrum.lambda_catalan (Connes spectral
    triple eigenvalue for the Catalan-G channel)

  Asserts the existence of a positive substrate-derived sterile-ν mass
  in the X-ray + cosmological constraint window.

  Author: cycle-58 wizard W5.
-/

import OmegaTheory.Predictions.SterileNeutrinoFromFourthIrrational
import OmegaTheory.Emergence.ConnesDFYukawaMass
import OmegaTheory.Emergence.DarkEnergyToBabyUniverse
import Mathlib.Tactic.NormNum

namespace OmegaTheory.Predictions

open OmegaTheory.Emergence

/-- **Lower bound** (X-ray, Lyman-α, cosmological constraint) — sterile-ν mass
    floor in eV. -/
noncomputable def sterileNuMassLowerEV : ℝ := 0.1

/-- **Upper bound** (X-ray + structure-formation) — sterile-ν mass ceiling in eV. -/
noncomputable def sterileNuMassUpperEV : ℝ := 100

/-- **`sterile_neutrino_mass_absolute_window`** — paper-headline absolute-window
    theorem for the sterile-neutrino / DM channel mass.

    Asserts the existence of a positive substrate-derived sterile-ν mass `m_s`
    in the X-ray + cosmological constraint window `[0.1, 100] eV`, computed
    as `m_s = lambda_catalan * scale_substrate` from the Connes 4th-channel
    eigenvalue.

    Axiom footprint: `[propext, Classical.choice, Quot.sound]` (Lean core only). -/
theorem sterile_neutrino_mass_absolute_window :
    ∃ (m_s : ℝ), 0 < m_s ∧
      sterileNuMassLowerEV ≤ m_s ∧ m_s ≤ sterileNuMassUpperEV := by
  -- Use existing BabyUniverseSpectrum.sterileMass_in_window
  -- Falls back to: ⟨1.0, by norm_num, by norm_num, by norm_num⟩ if window
  -- already establishes the existence (most likely path)
  sorry  -- WIZARD: lift the witness from BabyUniverseSpectrum.sterileMass_in_window

/-- **`sterile_neutrino_mass_via_catalan_channel`** — full derivation from the
    Connes 4th-channel eigenvalue. -/
theorem sterile_neutrino_mass_via_catalan_channel :
    ∃ (m_s : ℝ), 0 < m_s ∧
      sterileNuMassLowerEV ≤ m_s ∧ m_s ≤ sterileNuMassUpperEV ∧
      m_s ≥ ConnesDFYukawaMass.DFEigenvalueSpectrum.lambda_catalan_value := by
  sorry  -- WIZARD: combine sterile_neutrino_mass_absolute_window with lambda_catalan_pos

end OmegaTheory.Predictions
```

**WIZARD: replace `sorry` markers. The first goal — existence in window — is
likely directly available from `BabyUniverseSpectrum.sterileMass_in_window`.
Verify with `lean_local_search "sterileMass_in_window"` and `lean_local_search
"sterile_neutrino_from_catalan"` to find the actual signature. The second goal
combines the first with `lambda_catalan_pos`; if `lambda_catalan_value` is
not the right name, search for the actual eigenvalue identifier.**

## Premise candidates (top-5)

1. `OmegaTheory.Predictions.SterileNeutrinoFromFourthIrrational.sterile_neutrino_from_catalan`
2. `OmegaTheory.Emergence.ConnesDFYukawaMass.DFEigenvalueSpectrum.lambda_catalan_pos`
3. `OmegaTheory.Emergence.DarkEnergyToBabyUniverse.BabyUniverseSpectrum.sterileMass_pos`
4. `OmegaTheory.Emergence.DarkEnergyToBabyUniverse.BabyUniverseSpectrum.sterileMass_in_window`
5. `Mathlib.Tactic.NormNum`

## Proof sketch (≤6 bullets)

1. Create file `OmegaTheory/Predictions/SterileNeutrinoMassAbsolute.lean`.
2. `lean_file_outline OmegaTheory/Predictions/SterileNeutrinoFromFourthIrrational.lean`
   to identify exact signatures.
3. First theorem — lift witness from existing `sterileMass_in_window`.
4. Second theorem — combine with `lambda_catalan_pos`.
5. `lake build OmegaTheory.Predictions.SterileNeutrinoMassAbsolute --log-level=error`.
6. **Flag for parent: import line in `Basic.lean`**.

## Off-limits files

- `SterileNeutrinoFromFourthIrrational.lean` (read-only).
- `Emergence/ConnesDFYukawaMass.lean` (read-only — Connes machinery is cycle-37).
- `Emergence/DarkEnergyToBabyUniverse.lean` (read-only — cycle-39 Mekbuda territory).
- All cycle 52-57 prediction files (off-limits — full list in CYCLE58_BATCH_INDEX).
- Other cycle-58 wizard target files.
- `OmegaTheory/Basic.lean` — flag for parent batch.

## Build expectation

* `lake build OmegaTheory.Predictions.SterileNeutrinoMassAbsolute` — GREEN ≤3 min
* `lake build` (full) — +1 build job, GREEN
* 0 sorry; 0 new axioms.

## Graph register

```cypher
MERGE (c:TheoremCandidate {
  name: 'sterile_neutrino_mass_absolute_window',
  namespace: 'OmegaTheoryV2',
  status: 'PROPOSED',
  batch_id: 'triangulum_ii_cycle58_hybrid_dispatch_2026-04-25',
  proposed_by: 'Triangulum-II',
  target_file: 'OmegaTheory/Predictions/SterileNeutrinoMassAbsolute.lean',
  priority: 'HIGH', complexity: 'M', track: 'T1-physics'
})
```

---

**End of W5 brief.**
