/-
  OmegaTheory.Irrationality.HermitePade.PiStratum

  F53 — Pi-stratum separation (Module 11 §11.4).

  Corollary of the Decoupling Theorem 4C.3 specialised to θ = π in ℝ.
  States: any ℤ-linear combination of `1, π, π², …, π^D` that vanishes
  in ℝ must be the zero combination.

  This is the "coefficient-at-each-power-of-π must vanish separately"
  step used across the π-irrationality diary (Module 04C, Module 11
  §11.4 F53, Attack 19 non-vanishing witness).

  Dependencies:
  • `decoupling_scalar` from `OmegaTheory.Irrationality.HermitePade.Decoupling`
  • `Real.pi_transcendental` — STATED AS AXIOM, citation: Lindemann (1882).
    Mathlib v4.29 ships only the analytic part of Lindemann-Weierstrass
    (`Mathlib.NumberTheory.Transcendental.Lindemann.AnalyticalPart`)
    and has NOT yet derived `Transcendental ℚ Real.pi` as a corollary.
    Checked 2026-04-15 (Capella, team v2-apr15-lean): searched Mathlib
    for `transcendental_pi`, `pi_transcendental`, `Real.pi … Transcendental`
    — zero matches; only `AnalyticalPart.lean` exists under
    `Mathlib/NumberTheory/Transcendental/Lindemann/`, no `Basic.lean`.
    Once Mathlib completes the Lindemann derivation, this axiom is
    replaced by a theorem with no further work here.
-/

import OmegaTheory.Irrationality.HermitePade.Decoupling
import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPiTranscendentalUnconditionalReal
import Mathlib.RingTheory.Algebraic.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Analysis.Real.Pi.Bounds

namespace OmegaTheory.Irrationality.HermitePade

open BigOperators Finset

/--
**Axiom (Lindemann 1882).**  The real number π is transcendental over ℚ.

Citation: F. Lindemann, *Über die Zahl π*, Math. Ann. 20 (1882), 213–225.

**RETIRED 2026-04-27** (cycle 64 closure): theorem proved unconditionally
via custom port of Lindemann-Weierstrass — see
`Irrationality/CustomMath/LindemannPremiseRatProofPiTranscendentalUnconditionalReal.lean`.
Proof uses formal subset-sum polynomial machinery + fundamental theorem
of symmetric polynomials (Mathlib `MvPolynomial.esymmAlgEquiv`) +
`IsLocalization.integerNormalization` + Euler's identity.

`#print axioms` returns `[propext, Classical.choice, Quot.sound]` only
(Lean core), confirming the axiom retirement.
-/
theorem Real.pi_transcendental : Transcendental ℚ (Real.pi : ℝ) :=
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPiTranscendentalUnconditionalReal.pi_transcendental_unconditional

/-! ## Research-axiom scoping marker (cycle 58, Libra · Vesta · 2026-04-25)

The axiom `Real.pi_transcendental` above is **research-track only**. The
paper-headline physics of OmegaTheory V2 (QM extension, GR regimes, SM gauge
group, Higgs, dark energy w=-1, baryogenesis) does NOT depend on it.

`axiom_audit` confirms paper-headline capstones depend on
`[propext, Classical.choice, Quot.sound]` only (Lean core):

* `omega_theory_v2_final_meta_capstone`
* `grand_capstone_v2_substrate_SM_plus_gravity_plus_DM_plus_DE`
* `irrationality_implies_quantum_uncertainty` (Probe/PiAndOmegaStructure)
* `four_channel_fibration_over_subsystem` (Chara cycle-44)

The axiom is genuinely needed only by the research-track Hermite–Padé layer:

* `pi_stratum_integer` at fixed degree D ≥ 2 (no paper-headline callsites today)
* `pi_stratum_vector` (vector form, same dependency chain)
* `ic_three_constants_transcendental` (research-track 3-conjunct, NOT a
  paper-headline capstone — see `ic_three_constants_paper_headline_irrationality_only`
  for the paper-headline form which uses `Real.irrational_pi` (Niven, Mathlib))
* `ic_pi_Mahler_S_conditional` (research-track conditional, already migrated to
  `ic_pi_Mahler_S_irrational_unconditional` for axiom-free paper-headline use —
  see Atria's cycle-53 `IrrationalityClasses/AxiomNarrowing.lean`)

Substrate-thesis irrationality conclusions (Pi Hunch chain) use Mathlib's
`Real.irrational_pi` (Niven 1947), an outright THEOREM, NOT this axiom — so
the paper-headline `ℏ/2 + δ_comp > ℏ/2` chain has zero blast-radius from
`Real.pi_transcendental`.

The axiom is being eliminated incrementally via the multi-cycle
Lindemann–Weierstrass port (`OmegaTheory/Irrationality/CustomMath/LindemannBasic.lean`
+ Layer-CD companion files; Ganymede's cycle-57 W9
`OmegaTheory/Irrationality/HermitePade/PiTranscendentalLayerB.lean` lays the
Galois-bridge framework with `LindemannPremiseRat`/`LindemannPremiseInt`
hypotheses). Target: cycle 60-62 closure.
-/

/-- Research-axiom scoping marker for `Real.pi_transcendental`. Inert; included
for grep-discoverability and `axiom_audit` filtering. The marker carries no
content — it merely lets downstream tooling identify which axioms are formally
flagged research-track-only (i.e., not paper-headline-load-bearing). -/
def Real.pi_transcendental_research_track_marker : Prop := True

/-- Witness that `Real.pi_transcendental` is tagged research-track. The proof is
trivial (the marker is `True` by definition); the role of this lemma is to be
the canonical citation target when a downstream module wants to assert "the
π-transcendence axiom is paper-headline-non-load-bearing per cycle-58 hybrid
plan." Carries axiom footprint `[propext, Classical.choice, Quot.sound]` only —
NO dependency on `Real.pi_transcendental` itself. -/
theorem Real.pi_transcendental_is_research_track :
    Real.pi_transcendental_research_track_marker := trivial

/--
**F53 — π-stratum separation (integer scalars).**

If a finite ℤ-linear combination of powers of π vanishes in ℝ, then every
coefficient is zero.

Proof: direct specialisation of `decoupling_scalar` at θ = π in ℝ,
casting integer coefficients through ℚ.  Transcendence of π gives the
conclusion in ℚ, whence also in ℤ by injectivity of ℤ → ℚ.
-/
theorem pi_stratum_integer
    {D : ℕ} (c : Fin (D + 1) → ℤ)
    (h : ∑ k : Fin (D + 1),
        (c k : ℝ) * (Real.pi : ℝ) ^ (k : ℕ) = 0) :
    ∀ k, c k = 0 := by
  -- Reindex the sum to match decoupling_scalar's hypothesis shape
  have h' : ∑ k : Fin (D + 1),
      (Real.pi : ℝ) ^ (k : ℕ) * algebraMap ℚ ℝ ((c k : ℚ)) = 0 := by
    have : ∀ k : Fin (D + 1),
        (Real.pi : ℝ) ^ (k : ℕ) * algebraMap ℚ ℝ ((c k : ℚ))
          = (c k : ℝ) * (Real.pi : ℝ) ^ (k : ℕ) := by
      intro k
      simp [Rat.cast_intCast]
      ring
    simp_rw [this]
    exact h
  -- Apply the scalar decoupling theorem
  have rat_zero : ∀ k, ((c k : ℚ)) = 0 :=
    decoupling_scalar Real.pi_transcendental (fun k => (c k : ℚ)) h'
  -- ℚ-cast of an integer is zero ↔ the integer is zero
  intro k
  have := rat_zero k
  exact_mod_cast this

/--
**F53 — π-stratum separation (vector form, Module 11 §11.4).**

If an integer-matrix vector `L_n ∈ ℤ[π]^T` vanishes componentwise in
ℝ^T after evaluating π, then every π-degree component L_n^(k) also
vanishes as an integer vector.

This is the form directly used by Attack 19 to certify that a
π-polynomial identity among `{1, u, v}` (if one existed) would give
multiple integer-vector identities, one per π-power — any of which can
then be contradicted independently.
-/
theorem pi_stratum_vector
    {D T : ℕ} (v : Fin (D + 1) → Fin T → ℤ)
    (h : ∀ i : Fin T,
        ∑ k : Fin (D + 1),
          (v k i : ℝ) * (Real.pi : ℝ) ^ (k : ℕ) = 0) :
    ∀ k i, v k i = 0 := by
  intro k i
  exact pi_stratum_integer (fun k' => v k' i) (h i) k

end OmegaTheory.Irrationality.HermitePade
