/-
  OmegaTheory.Paper.QuantumFoundations

  **Paper-citable headline theorems for the quantum-foundations arc.**

  This file is purely a re-export layer — it provides top-level,
  OmegaTheory-rooted aliases for deeply-nested results so that the
  Foundations-of-Physics / PRL manuscript can cite clean names:

    * `P-11  OmegaTheory.extended_gt_heisenberg` —
      the extended uncertainty bound strictly exceeds the Heisenberg
      bound `ℏ/2`.  This is the headline statement that the substrate
      produces a *genuinely stronger* inequality than textbook QM, by
      exactly the computational-uncertainty term `δ_comp(N)`.  Original:
      `OmegaTheory.Irrationality.extended_gt_heisenberg`
      (`OmegaTheory/Irrationality/Uncertainty.lean`).

    * `P-13  OmegaTheory.repairQuantumEnergy_from_bekenstein` —
      the repair-quantum energy `E_rq` multiplied by the Planck-sphere
      Bekenstein bit bound equals the Planck energy times the repair
      information content `I_rq = log₂ 5`.  A clean multiplicative
      identity tying the granular repair event on the lattice to the
      Bekenstein–Hawking area law.  Original:
      `OmegaTheory.Emergence.repairQuantumEnergy_from_bekenstein`
      (`OmegaTheory/Emergence/Gravitons.lean`).

    * `P-14a OmegaTheory.mass_info_roundtrip` —
      mass → information → mass recovers the original mass at any
      positive temperature, formalising the triad
      `mass ↔ information ↔ energy`.  Original:
      `OmegaTheory.Conservation.mass_info_roundtrip`
      (`OmegaTheory/Conservation/Correspondence.lean`).

    * `P-14b OmegaTheory.info_energy_roundtrip` —
      information → energy → information recovers the original
      information content at any positive temperature, the
      energy/information leg of the triad.  Original:
      `OmegaTheory.Conservation.info_energy_roundtrip`
      (`OmegaTheory/Conservation/Correspondence.lean`).

  **Zero new axioms, zero new proofs.**  Each alias is a one-liner
  `:=` re-export; the underlying theorems remain the canonical
  statements, and every property (hypotheses, conclusion, constants)
  is transported through unchanged.

  Author — Procyon, 2026-04-15 (V2 wave-3 paper promotion).
-/

import OmegaTheory.Irrationality.Uncertainty
import OmegaTheory.Emergence.Gravitons
import OmegaTheory.Conservation.Correspondence

namespace OmegaTheory

open OmegaTheory.Spacetime
open OmegaTheory.Irrationality
open OmegaTheory.Emergence
open OmegaTheory.Conservation

/-! ## P-11 — Extended uncertainty strictly exceeds Heisenberg -/

/-- **Paper headline (P-11).**  The extended uncertainty bound strictly
    exceeds the textbook Heisenberg floor `ℏ/2`:

            `ℏ/2 < extendedUncertaintyBound N`,

    where `extendedUncertaintyBound N = ℏ/2 + δ_comp(N)` adds the
    positive computational-uncertainty term sourced by action-threshold
    crossings on the discrete substrate.

    Physical interpretation: textbook QM's Heisenberg inequality is
    an *under*-estimate — the substrate tacks on a strictly positive
    correction `δ_comp(N)` for every truncation level `N`.  The
    correction vanishes only in the idealised `N = ∞` continuum limit,
    so any actual preparation of a joint-observable state encounters
    a genuinely stronger bound than `ℏ/2`.

    This is a direct re-export of
    `OmegaTheory.Irrationality.extended_gt_heisenberg`. -/
theorem extended_gt_heisenberg (N : ℕ) :
    hbar / 2 < extendedUncertaintyBound N :=
  OmegaTheory.Irrationality.extended_gt_heisenberg N

/-! ## P-13 — Repair-quantum energy from the Bekenstein area law -/

/-- **Paper headline (P-13).**  The repair-quantum energy satisfies the
    multiplicative identity

            `E_rq · I_max(4π ℓ_P²)  =  E_P · I_rq`,

    where
      * `E_rq = repairQuantumEnergy` is the energy of one granular
        healing event on the lattice (Planck-scale by construction);
      * `I_max(A) = bekensteinBitBound A` is the Bekenstein bit bound
        on a sphere of area `A`, evaluated at the Planck-sphere area
        `4π ℓ_P²`;
      * `E_P` is the Planck energy;
      * `I_rq = repairQuantumInformation = log₂ 5` is the information
        content of one repair instruction (5-template alphabet).

    This is a real derivation of `E_rq ≈ E_P/2` from
      (i) the Bekenstein–Hawking area law, and
      (ii) the 5-template alphabet of lattice repair instructions.

    The identity is *exact* — no `O(…)` softening — and ties the
    granular repair event directly to the holographic bit bound on
    a Planck-scale sphere, giving the paper a publishable
    Bekenstein-origin statement for the repair-quantum energy.

    This is a direct re-export of
    `OmegaTheory.Emergence.repairQuantumEnergy_from_bekenstein`. -/
theorem repairQuantumEnergy_from_bekenstein :
    repairQuantumEnergy * bekensteinBitBound (4 * Real.pi * l_P ^ 2) =
      E_P * repairQuantumInformation :=
  OmegaTheory.Emergence.repairQuantumEnergy_from_bekenstein

/-! ## P-14 — Mass ↔ information ↔ energy triad roundtrips -/

/-- **Paper headline (P-14a).**  The mass ↔ information leg of the
    triad is a roundtrip: for any mass `m` and any positive temperature
    `T`,

            `massFromInformation (informationFromMass m T) T = m`.

    In other words, translating a mass into its Landauer/Einstein
    information content at temperature `T` and back recovers the
    original mass exactly.  Derivation chain:
      * `informationFromMass m T := (m c²) / (k_B T ln 2)`
        (Einstein's `E = mc²` divided by the Landauer energy);
      * `massFromInformation I T := (k_B T ln 2 · I) / c²`
        (information times Landauer energy, divided by `c²`);
    composing the two is algebraically the identity — no approximation.

    This is a direct re-export of
    `OmegaTheory.Conservation.mass_info_roundtrip`. -/
theorem mass_info_roundtrip (m T : ℝ) (hT : 0 < T) :
    massFromInformation (informationFromMass m T hT) T = m :=
  OmegaTheory.Conservation.mass_info_roundtrip m T hT

/-- **Paper headline (P-14b).**  The information ↔ energy leg of the
    triad is a roundtrip: for any information content `I` and any
    positive temperature `T`,

            `maxInformationFromEnergy (energyFromInformation I T) T = I`.

    Translating an information content into the minimum erasure energy
    at temperature `T` (Landauer) and back recovers the original
    information content exactly.  Derivation chain:
      * `energyFromInformation I T := (k_B T ln 2) · I`
        (Landauer bound applied to `I` bits);
      * `maxInformationFromEnergy E T := E / (k_B T ln 2)`
        (bits extractable from energy `E` at temperature `T`);
    their composition is the identity.

    This is a direct re-export of
    `OmegaTheory.Conservation.info_energy_roundtrip`. -/
theorem info_energy_roundtrip (I T : ℝ) (hT : 0 < T) :
    maxInformationFromEnergy (energyFromInformation I T) T hT = I :=
  OmegaTheory.Conservation.info_energy_roundtrip I T hT

end OmegaTheory
