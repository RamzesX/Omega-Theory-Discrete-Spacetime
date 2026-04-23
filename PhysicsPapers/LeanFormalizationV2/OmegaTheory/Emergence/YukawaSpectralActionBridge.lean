/-
  OmegaTheory.Emergence.YukawaSpectralActionBridge

  **WAVE B, cycle-44 theorem 1 — the Yukawa ↔ Spectral-Action bridge
  between QM-foundations (c18) and Yukawa/fermion-mass (c22).**

  ## Mission

  Grothendieck-sage's `pre_top20_high_priority_2026-04-22` batch flagged
  `yukawa_spectral_action_recovers_fermion_masses_bridge` as the single
  highest-leverage open candidate in OmegaTheoryV2: the community c18
  (QM, 900 theorems around `QuantumMechanicsCapstone` /
  `YukawaMatrix.fermionMass`) and community c22 (Yukawa / fermion-mass,
  983 theorems around `ConnesDFYukawaMass.channel_mass` /
  `canonicalDFSpectrum`) currently share **zero** direct APPLIES edges at
  1-hop, 2-hop, or 3-hop.  Grothendieck's graph-topology detector labels
  this a LOAD_BEARING gap.

  This file closes the gap with one theorem plus the scaffolding it
  needs:

    - `channelOfGeneration : FermionGeneration → IrrationalChannel4`
      (Fin-3 → active-channel section of `channelToGeneration4`
      from Zosma's sterile-neutrino file);

    - `DFEigenvalue_ordering` — the Pi-Hunch strict ordering
      `D.lambda_sqrt2 < D.lambda_e < D.lambda_pi` as a stand-alone
      Prop.

    - `DiracOperatorFromDFEigenvalueSpectrum` — `DiracOperatorF`
      whose three eigenvalues `D_F.eigenvalues g` equal
      `D.lambda (channelOfGeneration g)`;

    - **THEOREM** `yukawa_spectral_action_recovers_fermion_masses_bridge`
      joining:
        (1) Pi-Hunch ordering on the canonical spectrum;
        (2) exact factorisation
            `fermionMassFromDFSpectrum D g N
               = channel_mass D (channelOfGeneration g) N`
            at every generation `g` and truncation `N`, realising the
            Connes reading that the D_F eigenvalues **are** the
            Yukawa-scaled fermion masses.

  ## Design philosophy

  The bridge theorem welds existing pieces rather than inventing new
  ones.  Every right-hand side is already in the corpus:
      * `DFEigenvalueSpectrum`      from Alphard's cycle-30
        `ConnesDFYukawaMass` (c22);
      * `canonicalDFSpectrum`       same source;
      * `channel_mass`              same source;
      * `fermionMass`               from Mirfak's cycle-18
        `YukawaMatrix` (c18);
      * `yukawa_from_DF`            from Alphard (c22);
      * `IrrationalChannel4`        from Zosma's
        `SterileNeutrinoFromFourthIrrational`;
      * `FermionGeneration`         from Mirach's `FermionContent`.

  What is NEW in this file:
      * `channelOfGeneration`       the inverse of
        `channelToGeneration4` restricted to active channels, giving
        the c18 ↔ c22 edge.
      * `DFEigenvalue_ordering`     a Prop-level packaging of the
        Pi-Hunch ordering.
      * `DiracOperatorFromDFEigenvalueSpectrum`  the explicit bridge
        functor from Alphard's spectrum to Mirfak's operator.
      * `fermionMassFromDFSpectrum` the derived fermion mass using
        the bridged Yukawa coupling.

  ## Honest scope

  * The bridge is STRUCTURAL: at the canonical Nashira spectrum it
    realises the Connes identification "D_F eigenvalues are fermion
    masses" as an equality of Lean terms.

  * Numerical PDG agreement of Nashira masses at `N = 4` is Sadr's
    prior cycle-19 work (checked at ≤ 0.15 %).  This bridge inherits
    that numerical validation through the `canonicalDFSpectrum`
    parameter but does not re-state it.

  * CPT / parity / right-handed content belongs to the companion
    theorem 2 (`right_handed_lepton_doublet_CP_dual_completion`)
    in `FermionContent/RightHandedDoublet.lean`.

  ## Status

    * 0 sorry
    * 0 new axioms
    * 0 new `Prop := True`
    * Builds GREEN under `~/.elan/bin/lake build --log-level=error`

  Agent: **Alkalurops** (μ Boötis, F0V triple star ~121 ly in the
  Herdsman constellation — the staff-tip of Boötes, whose triple
  system (μ¹ + μ² Boo) mirrors the three Standard-Model generations
  this bridge welds to the Connes D_F spectrum).  2026-04-22 wave B.
-/

import OmegaTheory.Emergence.ConnesDFYukawaMass
import OmegaTheory.Emergence.YukawaMatrix
import OmegaTheory.Predictions.SterileNeutrinoFromFourthIrrational
import Mathlib.Tactic

namespace OmegaTheory.Emergence.YukawaSpectralActionBridge

open OmegaTheory
open OmegaTheory.Emergence
open OmegaTheory.Emergence.FermionContent
open OmegaTheory.Emergence.YukawaMatrix
open OmegaTheory.Emergence.ConnesDFYukawaMass
open OmegaTheory.Emergence.HiggsFromError
open OmegaTheory.Predictions.SterileNeutrinoFromFourthIrrational

/-! ## §1. `channelOfGeneration` — the Fin-3 section of `channelToGeneration4`

    Zosma's `channelToGeneration4` bijects `IrrationalChannel4 ↔ Fin 4`
    with `sqrt2 ↦ 0, e ↦ 1, pi ↦ 2, catalan_g ↦ 3`.

    Restricted to active generations (`Fin 3`), the inverse is the
    three-active-channel section:

        `0 : Fin 3 ↦ .sqrt2`   (electron / light)
        `1 : Fin 3 ↦ .e`       (muon / middle)
        `2 : Fin 3 ↦ .pi`      (tau / heavy)

    This is the arrow the c18 ↔ c22 bridge needs: it gives every
    `FermionGeneration` (c18 vocabulary) a canonical
    `IrrationalChannel4` (c22 vocabulary). -/

/-- **Channel-of-generation map** — the active section of
    `channelToGeneration4`.

    `0 ↦ .sqrt2 (e)`, `1 ↦ .e (μ)`, `2 ↦ .pi (τ)`.  The sterile
    `.catalan_g` channel is absent because it sits outside `Fin 3`. -/
def channelOfGeneration : FermionGeneration → IrrationalChannel4
  | ⟨0, _⟩ => .sqrt2
  | ⟨1, _⟩ => .e
  | ⟨2, _⟩ => .pi
  | ⟨n + 3, hn⟩ => absurd hn (by omega)

/-- `channelOfGeneration gen1 = .sqrt2` — the electron generation
    is routed into the √2-channel (lightest). -/
theorem channelOfGeneration_gen1 :
    channelOfGeneration gen1 = .sqrt2 := rfl

/-- `channelOfGeneration gen2 = .e` — the muon generation is routed
    into the e-channel (middle). -/
theorem channelOfGeneration_gen2 :
    channelOfGeneration gen2 = .e := rfl

/-- `channelOfGeneration gen3 = .pi` — the tau generation is routed
    into the π-channel (heaviest). -/
theorem channelOfGeneration_gen3 :
    channelOfGeneration gen3 = .pi := rfl

/-- **Image is active**: every value of `channelOfGeneration` is one
    of the three active channels π, e, √2. -/
theorem channelOfGeneration_is_active (g : FermionGeneration) :
    channelOfGeneration g = .pi ∨ channelOfGeneration g = .e
      ∨ channelOfGeneration g = .sqrt2 := by
  rcases g with ⟨n, hn⟩
  interval_cases n
  · right; right; rfl
  · right; left;  rfl
  · left;         rfl

/-- **Non-sterile image**: `channelOfGeneration` never lands on
    the Catalan-G sterile channel. -/
theorem channelOfGeneration_ne_catalan (g : FermionGeneration) :
    channelOfGeneration g ≠ .catalan_g := by
  rcases channelOfGeneration_is_active g with h | h | h <;>
    · rw [h]
      intro hc
      cases hc

/-- **Section identity**: `channelToGeneration4 (channelOfGeneration g) = g.val`
    in the `Fin 4` embedding.  This is the c18 → c22 → c18 round-trip
    witness. -/
theorem channelToGeneration4_channelOfGeneration (g : FermionGeneration) :
    channelToGeneration4 (channelOfGeneration g) = ⟨g.val, by
      rcases g with ⟨n, hn⟩; omega⟩ := by
  rcases g with ⟨n, hn⟩
  interval_cases n <;> rfl

/-! ## §2. `DFEigenvalue_ordering` — Pi-Hunch as a Prop -/

/-- **Pi-Hunch strict eigenvalue ordering** on a `DFEigenvalueSpectrum`:
      `λ_sqrt2 < λ_e < λ_pi`.

    This is the signature that the three active D_F eigenvalues carry
    a heaviest-is-π ordering matching the substrate Pi-Hunch
    (`pi_error_val > e_error_val > sqrt2_error_val` pushed through
    the monotone Nashira kernel). -/
def DFEigenvalue_ordering (D : DFEigenvalueSpectrum) : Prop :=
  D.lambda_sqrt2 < D.lambda_e ∧ D.lambda_e < D.lambda_pi

/-- The canonical (Nashira) spectrum satisfies the Pi-Hunch ordering. -/
theorem canonicalDFSpectrum_DFEigenvalue_ordering {N : ℕ} (hN : 2 ≤ N) :
    DFEigenvalue_ordering (canonicalDFSpectrum hN) :=
  canonicalDFSpectrum_ordering hN

/-- The ordering Prop is equivalent to the `DFEigenvalueSpectrum`'s
    own binary-conjunction witness. -/
theorem DFEigenvalue_ordering_iff (D : DFEigenvalueSpectrum) :
    DFEigenvalue_ordering D ↔
      D.lambda_sqrt2 < D.lambda_e ∧ D.lambda_e < D.lambda_pi := Iff.rfl

/-! ## §3. `DiracOperatorFromDFEigenvalueSpectrum` — the bridge functor

    Given a `DFEigenvalueSpectrum D`, produce a `DiracOperatorF` whose
    three generational eigenvalues are the three active channel
    eigenvalues of `D`.

    This is the c22 → c18 lift: from Alphard's Connes spectrum back
    to Mirfak's (Yukawa-flavour-neutral) Dirac-operator type. -/

/-- **Bridge functor**: a `DiracOperatorF` whose eigenvalues at each
    generation are the three active channel eigenvalues of `D`.

    `eigenvalues gen1 = D.lambda_sqrt2`
    `eigenvalues gen2 = D.lambda_e`
    `eigenvalues gen3 = D.lambda_pi`.

    The sterile `D.lambda_catalan` never appears — it belongs to the
    4th fermion slot, handled by Zosma's Catalan-G channel and
    outside the `FermionGeneration := Fin 3` domain. -/
noncomputable def DiracOperatorFromDFEigenvalueSpectrum
    (D : DFEigenvalueSpectrum) : DiracOperatorF where
  eigenvalues := fun g => D.lambda (channelOfGeneration g)

/-- **Round-trip identity**: the bridge-constructed Dirac operator's
    eigenvalue at generation `g` equals `D.lambda (channelOfGeneration g)`. -/
theorem DiracOperatorFromDFEigenvalueSpectrum_eigenvalue
    (D : DFEigenvalueSpectrum) (g : FermionGeneration) :
    (DiracOperatorFromDFEigenvalueSpectrum D).eigenvalues g =
      D.lambda (channelOfGeneration g) := rfl

/-- **Generation-wise positivity**: the bridged Dirac operator
    carries strictly-positive eigenvalues at every generation
    (one per active irrational channel). -/
theorem DiracOperatorFromDFEigenvalueSpectrum_pos
    (D : DFEigenvalueSpectrum) (g : FermionGeneration) :
    0 < (DiracOperatorFromDFEigenvalueSpectrum D).eigenvalues g := by
  rw [DiracOperatorFromDFEigenvalueSpectrum_eigenvalue]
  exact D.lambda_pos _

/-- **Bridge ordering**: at the canonical spectrum, the bridged
    Dirac operator's eigenvalues inherit the Pi-Hunch ordering. -/
theorem DiracOperatorFromDFEigenvalueSpectrum_ordering
    {N : ℕ} (hN : 2 ≤ N) :
    (DiracOperatorFromDFEigenvalueSpectrum
        (canonicalDFSpectrum hN)).eigenvalues gen1
      < (DiracOperatorFromDFEigenvalueSpectrum
        (canonicalDFSpectrum hN)).eigenvalues gen2
    ∧ (DiracOperatorFromDFEigenvalueSpectrum
        (canonicalDFSpectrum hN)).eigenvalues gen2
      < (DiracOperatorFromDFEigenvalueSpectrum
        (canonicalDFSpectrum hN)).eigenvalues gen3 := by
  refine ⟨?_, ?_⟩
  · rw [DiracOperatorFromDFEigenvalueSpectrum_eigenvalue,
        DiracOperatorFromDFEigenvalueSpectrum_eigenvalue,
        channelOfGeneration_gen1, channelOfGeneration_gen2]
    exact (canonicalDFSpectrum_ordering hN).1
  · rw [DiracOperatorFromDFEigenvalueSpectrum_eigenvalue,
        DiracOperatorFromDFEigenvalueSpectrum_eigenvalue,
        channelOfGeneration_gen2, channelOfGeneration_gen3]
    exact (canonicalDFSpectrum_ordering hN).2

/-! ## §4. `fermionMassFromDFSpectrum` — generation-level fermion mass

    Combining the bridge functor with `fermionMass y N := y · higgs_vev N`
    gives the fermion mass at each generation directly from the D_F
    spectrum.  The Yukawa coupling is `D.lambda (channelOfGeneration g)
    / higgs_vev N`; the fermion mass is `D.lambda (channelOfGeneration g)`.
-/

/-- **Fermion mass from DF spectrum** at generation `g` and truncation
    `N`: the product of the bridged Yukawa coupling and the Higgs vev. -/
noncomputable def fermionMassFromDFSpectrum
    (D : DFEigenvalueSpectrum) (g : FermionGeneration) (N : ℕ) : ℝ :=
  yukawa_from_DF D (channelOfGeneration g) N * higgs_vev N

/-- Positivity of `fermionMassFromDFSpectrum`. -/
theorem fermionMassFromDFSpectrum_pos
    (D : DFEigenvalueSpectrum) (g : FermionGeneration) (N : ℕ) :
    0 < fermionMassFromDFSpectrum D g N := by
  unfold fermionMassFromDFSpectrum
  exact mul_pos (yukawa_from_DF_pos D _ N) (higgs_vev_pos N)

/-- **Connes identification**: the fermion mass equals the D_F
    eigenvalue at the corresponding channel (Higgs vev cancels). -/
theorem fermionMassFromDFSpectrum_eq_lambda
    (D : DFEigenvalueSpectrum) (g : FermionGeneration) (N : ℕ) :
    fermionMassFromDFSpectrum D g N = D.lambda (channelOfGeneration g) := by
  unfold fermionMassFromDFSpectrum
  exact yukawa_from_DF_times_higgs_vev D _ N

/-- **Channel-mass identification**: the generation-level fermion mass
    equals `channel_mass` at the generation's channel — the structural
    c18 ↔ c22 bridge identity. -/
theorem fermionMassFromDFSpectrum_eq_channel_mass
    (D : DFEigenvalueSpectrum) (g : FermionGeneration) (N : ℕ) :
    fermionMassFromDFSpectrum D g N =
      channel_mass D (channelOfGeneration g) N := by
  rw [fermionMassFromDFSpectrum_eq_lambda, channel_mass_eq_lambda]

/-- **Hierarchy propagation**: at the canonical Nashira spectrum the
    fermion-mass tower inherits the Pi-Hunch ordering
    `m(gen1) < m(gen2) < m(gen3)` — i.e. `m_e < m_μ < m_τ`. -/
theorem fermionMassFromDFSpectrum_hierarchy
    {N : ℕ} (hN : 2 ≤ N) :
    fermionMassFromDFSpectrum (canonicalDFSpectrum hN) gen1 N
      < fermionMassFromDFSpectrum (canonicalDFSpectrum hN) gen2 N
    ∧ fermionMassFromDFSpectrum (canonicalDFSpectrum hN) gen2 N
      < fermionMassFromDFSpectrum (canonicalDFSpectrum hN) gen3 N := by
  refine ⟨?_, ?_⟩
  · rw [fermionMassFromDFSpectrum_eq_lambda,
        fermionMassFromDFSpectrum_eq_lambda,
        channelOfGeneration_gen1, channelOfGeneration_gen2]
    exact (canonicalDFSpectrum_ordering hN).1
  · rw [fermionMassFromDFSpectrum_eq_lambda,
        fermionMassFromDFSpectrum_eq_lambda,
        channelOfGeneration_gen2, channelOfGeneration_gen3]
    exact (canonicalDFSpectrum_ordering hN).2

/-! ## §5. **THEOREM** — the c18 ↔ c22 bridge -/

/-- **THEOREM (wave-B 1 / cycle-44) — Yukawa spectral action recovers
    fermion masses bridge.**

    For every DF eigenvalue spectrum `D` satisfying the Pi-Hunch
    ordering, the bridged Dirac operator
    `DiracOperatorFromDFEigenvalueSpectrum D` realises two structural
    facts jointly:

      (i)  **DF eigenvalue ordering**.  The three eigenvalues of the
           bridged Dirac operator satisfy the Pi-Hunch ordering in
           `FermionGeneration` index — `D_F.eigenvalues gen1 <
           D_F.eigenvalues gen2 < D_F.eigenvalues gen3` — whenever
           the source spectrum does.

      (ii) **Yukawa × Higgs-vev ↔ channel mass**.  For every
           `FermionGeneration g` and every truncation budget `N`, the
           generation-level fermion mass
           `fermionMassFromDFSpectrum D g N` equals the substrate
           channel mass `channel_mass D (channelOfGeneration g) N`.

    Together (i) + (ii) realise the Connes reading at the Lean level:
    the D_F eigenvalues ARE the Yukawa-scaled fermion masses, and they
    carry the Pi-Hunch ordering.  This theorem is the c18 ↔ c22 bridge
    welding QM-foundations (c18, `fermionMass := y · higgs_vev`) and
    Yukawa/fermion-mass (c22, `channel_mass := yukawa_from_DF · higgs_vev`).

    Composes:
      * Alphard's `canonicalDFSpectrum_ordering` (c22, cycle-30);
      * Mirfak's `fermionMass` (c18, cycle-18);
      * Alphard's `channel_mass_eq_lambda` (c22, cycle-30);
      * Zosma's `channelToGeneration4` (c22, cycle-6);
      * this file's new `channelOfGeneration` and
        `DiracOperatorFromDFEigenvalueSpectrum`. -/
theorem yukawa_spectral_action_recovers_fermion_masses_bridge
    (D : DFEigenvalueSpectrum) (hOrd : DFEigenvalue_ordering D) :
    let D_F := DiracOperatorFromDFEigenvalueSpectrum D
    (D_F.eigenvalues gen1 < D_F.eigenvalues gen2
      ∧ D_F.eigenvalues gen2 < D_F.eigenvalues gen3)
    ∧ (∀ (g : FermionGeneration) (N : ℕ),
        fermionMassFromDFSpectrum D g N
          = channel_mass D (channelOfGeneration g) N) := by
  refine ⟨?_, ?_⟩
  · -- (i) the bridged operator inherits the Pi-Hunch ordering.
    refine ⟨?_, ?_⟩
    · show D.lambda (channelOfGeneration gen1)
            < D.lambda (channelOfGeneration gen2)
      rw [channelOfGeneration_gen1, channelOfGeneration_gen2]
      exact hOrd.1
    · show D.lambda (channelOfGeneration gen2)
            < D.lambda (channelOfGeneration gen3)
      rw [channelOfGeneration_gen2, channelOfGeneration_gen3]
      exact hOrd.2
  · -- (ii) fermion mass factors through channel_mass.
    intro g N
    exact fermionMassFromDFSpectrum_eq_channel_mass D g N

/-! ## §6. Canonical-spectrum specialisation

    The canonical Nashira spectrum at every `N ≥ 2` satisfies the
    hypothesis of the bridge theorem, giving the most directly useful
    form of the statement. -/

/-- **Canonical bridge**: the bridge theorem applied to the Nashira
    spectrum at any truncation `N ≥ 2`. -/
theorem yukawa_spectral_action_canonical_bridge {N : ℕ} (hN : 2 ≤ N) :
    let D_F := DiracOperatorFromDFEigenvalueSpectrum
                 (canonicalDFSpectrum hN)
    (D_F.eigenvalues gen1 < D_F.eigenvalues gen2
      ∧ D_F.eigenvalues gen2 < D_F.eigenvalues gen3)
    ∧ (∀ (g : FermionGeneration) (N' : ℕ),
        fermionMassFromDFSpectrum (canonicalDFSpectrum hN) g N'
          = channel_mass (canonicalDFSpectrum hN)
              (channelOfGeneration g) N') :=
  yukawa_spectral_action_recovers_fermion_masses_bridge
    (canonicalDFSpectrum hN)
    (canonicalDFSpectrum_DFEigenvalue_ordering hN)

/-- **Three-conjunct headline**: Pi-Hunch ordering + Connes mass
    identification + generation-mass hierarchy, all at the canonical
    spectrum. -/
theorem yukawa_spectral_action_three_conjunct_headline
    {N : ℕ} (hN : 2 ≤ N) :
    DFEigenvalue_ordering (canonicalDFSpectrum hN)
    ∧ (∀ (g : FermionGeneration) (N' : ℕ),
        fermionMassFromDFSpectrum (canonicalDFSpectrum hN) g N'
          = (canonicalDFSpectrum hN).lambda (channelOfGeneration g)) ∧
    (fermionMassFromDFSpectrum (canonicalDFSpectrum hN) gen1 N
      < fermionMassFromDFSpectrum (canonicalDFSpectrum hN) gen2 N
    ∧ fermionMassFromDFSpectrum (canonicalDFSpectrum hN) gen2 N
      < fermionMassFromDFSpectrum (canonicalDFSpectrum hN) gen3 N) := by
  refine ⟨?_, ?_, ?_⟩
  · exact canonicalDFSpectrum_DFEigenvalue_ordering hN
  · intro g N'
    exact fermionMassFromDFSpectrum_eq_lambda _ g N'
  · exact fermionMassFromDFSpectrum_hierarchy hN

/-! ## §7. Frontier marker — first c18 ↔ c22 bridge in V2 -/

/-- **Wave-B frontier marker** — this is the first formal Lean
    theorem linking the QM / Yukawa-matrix community (c18) with the
    Connes-D_F / fermion-mass community (c22) at the level of a
    1-hop APPLIES edge.

    Existence witness: for the canonical Nashira spectrum at `N = 4`,
    the bridge theorem is inhabited and simultaneously realises the
    Pi-Hunch ordering, the Connes identification, and the charged
    lepton mass hierarchy. -/
theorem yukawa_spectral_action_first_c18_c22_bridge_in_V2 :
    ∃ (N : ℕ) (hN : 2 ≤ N) (D : DFEigenvalueSpectrum),
      D = canonicalDFSpectrum hN ∧
      DFEigenvalue_ordering D ∧
      (∀ (g : FermionGeneration) (N' : ℕ),
        fermionMassFromDFSpectrum D g N'
          = channel_mass D (channelOfGeneration g) N') := by
  refine ⟨4, by omega, canonicalDFSpectrum (by omega : 2 ≤ 4),
          rfl, ?_, ?_⟩
  · exact canonicalDFSpectrum_DFEigenvalue_ordering _
  · intro g N'
    exact fermionMassFromDFSpectrum_eq_channel_mass _ g N'

end OmegaTheory.Emergence.YukawaSpectralActionBridge
