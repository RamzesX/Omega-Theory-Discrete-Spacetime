/-
  OmegaTheory.Emergence.DiracFSpectrumReal

  **Eigenvalues of the finite Dirac operator D_F are real numbers.**

  Cycle-2 mission (target 3/6).  This file closes the reality side of
  the finite Dirac operator's spectrum.  The concrete `D_F` blocks for
  charged leptons, up-type quarks, down-type quarks and neutrinos were constructed
  in `DiracFSpectrum.lean` as the Hermitian real-diagonal complex
  matrices `electronD_F`, `upQuarkD_F`, `downQuarkD_F`, `neutrinoD_F`.
  Their eigenvalues are by construction the Yukawa couplings of each
  species.

  The mathematical content of this file is that those eigenvalues are
  *real*.  There are two honest ways to state this in Lean 4:

    * **Type-signature reality**.  `Matrix.IsHermitian.eigenvalues`
      already returns a function `n → ℝ`; this is a theorem of
      Mathlib's spectral theorem packaged into the type.  We state it
      explicitly as `hermitian_eigenvalues_are_real_valued`.

    * **Spectral reality**.  The ℂ-valued spectrum of a Hermitian
      matrix coincides with the image of the real eigenvalue function
      under `algebraMap ℝ ℂ`.  Every ℂ-spectrum element `z` is the
      canonical embedding of some real `λ`, i.e. `z = algebraMap ℝ ℂ λ`,
      and `Complex.im z = 0`.  This is `hermitian_complex_spectrum_elt_is_real`.

  The central theorem of this file is `dirac_spectrum_elt_is_real`:
  every complex spectral value of any Dirac block has vanishing
  imaginary part.  A per-species specialisation and the headline
  frontier bundle `dirac_spectrum_hermitian_spectral_real` follow.

  HARD CONSTRAINTS honoured:
    * 0 sorry
    * 0 new axioms
    * build GREEN on Lean 4.29 + Mathlib 4.29
    * extends `DiracFSpectrum` (no redefinition of matrices)

  Agent: Vindemiatrix (ε Virginis, "grape harvester"), 2026-04-20.
-/

import OmegaTheory.Emergence.DiracFSpectrum
import Mathlib.LinearAlgebra.Matrix.Hermitian
import Mathlib.Analysis.Matrix.Spectrum

namespace OmegaTheory.Emergence.DiracFSpectrumReal

open OmegaTheory.Emergence
open OmegaTheory.Emergence.DiracFSpectrum
open OmegaTheory.Emergence.FermionContent
open Matrix

/-! ## 1. Reality at the type level

The first honest way to say "eigenvalues of a Hermitian matrix are
real" is to observe that Mathlib's `Matrix.IsHermitian.eigenvalues`
returns a function into `ℝ`.  We expose this as an explicit
proposition so downstream consumers can cite it. -/

/-- **Reality (type level)**: for any Hermitian complex matrix `A` over
    a finite index type, the `eigenvalues` produced by Mathlib's
    spectral theorem take values in `ℝ`.  This is a *type-signature*
    statement — the existential is witnessed by the eigenvalue itself. -/
theorem hermitian_eigenvalues_are_real_valued
    {n : Type} [Fintype n] [DecidableEq n]
    {A : Matrix n n ℂ} (hA : A.IsHermitian) (i : n) :
    ∃ r : ℝ, hA.eigenvalues i = r :=
  ⟨hA.eigenvalues i, rfl⟩

/-! ## 2. Reality at the ℂ-spectrum level

The deeper reality statement concerns the complex spectrum
`spectrum ℂ A`.  Every element of `spectrum ℂ A` comes, via the
spectral theorem, from some real eigenvalue under the canonical
embedding `algebraMap ℝ ℂ`.  In particular, its imaginary part
vanishes. -/

/-- **Reality (complex-spectrum level)**: every element `z` of
    `spectrum ℂ A` of a Hermitian complex matrix is the canonical
    real embedding of some eigenvalue, `z = ((hA.eigenvalues i) : ℂ)`. -/
theorem hermitian_complex_spectrum_elt_is_embedded_real
    {n : Type} [Fintype n] [DecidableEq n]
    {A : Matrix n n ℂ} (hA : A.IsHermitian) {z : ℂ}
    (hz : z ∈ spectrum ℂ A) :
    ∃ i : n, z = ((hA.eigenvalues i : ℝ) : ℂ) := by
  -- Mathlib: `spectrum ℂ A = RCLike.ofReal '' Set.range hA.eigenvalues`.
  have hImg : spectrum ℂ A = RCLike.ofReal '' Set.range hA.eigenvalues :=
    hA.spectrum_eq_image_range
  rw [hImg] at hz
  obtain ⟨r, hr_range, hr_eq⟩ := hz
  obtain ⟨i, hi⟩ := hr_range
  refine ⟨i, ?_⟩
  -- `RCLike.ofReal` for ℂ is `Complex.ofReal`, i.e. `((· : ℝ) : ℂ)`.
  have : (RCLike.ofReal r : ℂ) = ((r : ℝ) : ℂ) := rfl
  rw [← hr_eq, this, hi]

/-- **Reality (imaginary part vanishes)**: every element `z` of
    `spectrum ℂ A` of a Hermitian complex matrix has `Complex.im z = 0`. -/
theorem hermitian_complex_spectrum_elt_im_zero
    {n : Type} [Fintype n] [DecidableEq n]
    {A : Matrix n n ℂ} (hA : A.IsHermitian) {z : ℂ}
    (hz : z ∈ spectrum ℂ A) :
    Complex.im z = 0 := by
  obtain ⟨i, hi⟩ := hermitian_complex_spectrum_elt_is_embedded_real hA hz
  rw [hi]
  -- `Complex.im ((r : ℝ) : ℂ) = 0` by `Complex.ofReal_im`.
  exact Complex.ofReal_im _

/-! ## 3. The general ∀ statement across all Hermitian blocks

All `D_F` blocks for every species are Hermitian
(`electronD_F_isHermitian`, `upQuarkD_F_isHermitian`,
`downQuarkD_F_isHermitian`, `neutrinoD_F_isHermitian`).  Consequently
every element of their ℂ-spectrum has vanishing imaginary part — this
is the precise meaning of "λ ∈ spec(D_F), λ ∈ ℝ". -/

/-- **Generic Dirac spectrum reality**: given any complex matrix that
    is Hermitian, every element of its ℂ-spectrum is real (vanishing
    imaginary part). -/
theorem dirac_spectrum_elt_is_real
    {n : Type} [Fintype n] [DecidableEq n]
    {A : Matrix n n ℂ} (hA : A.IsHermitian) :
    ∀ z ∈ spectrum ℂ A, Complex.im z = 0 :=
  fun _z hz => hermitian_complex_spectrum_elt_im_zero hA hz

/-- **Generic Dirac spectrum reality (embedded-real form)**: given any
    complex matrix that is Hermitian, every element of its ℂ-spectrum
    is the canonical embedding `((λ : ℝ) : ℂ)` of some real eigenvalue. -/
theorem dirac_spectrum_elt_is_embedded_real
    {n : Type} [Fintype n] [DecidableEq n]
    {A : Matrix n n ℂ} (hA : A.IsHermitian) :
    ∀ z ∈ spectrum ℂ A, ∃ i : n, z = ((hA.eigenvalues i : ℝ) : ℂ) :=
  fun _z hz => hermitian_complex_spectrum_elt_is_embedded_real hA hz

/-! ## 4. Per-species specialisations -/

/-- **Electron-tower D_F has real spectrum.** -/
theorem electronD_F_spectrum_elt_is_real :
    ∀ z ∈ spectrum ℂ electronD_F, Complex.im z = 0 :=
  dirac_spectrum_elt_is_real electronD_F_isHermitian

/-- **Electron-tower D_F spectrum elements are embedded reals.** -/
theorem electronD_F_spectrum_elt_is_embedded_real :
    ∀ z ∈ spectrum ℂ electronD_F,
      ∃ i : FermionGeneration, z = ((electronD_F_isHermitian.eigenvalues i : ℝ) : ℂ) :=
  dirac_spectrum_elt_is_embedded_real electronD_F_isHermitian

/-- **Up-quark tower D_F has real spectrum.** -/
theorem upQuarkD_F_spectrum_elt_is_real :
    ∀ z ∈ spectrum ℂ upQuarkD_F, Complex.im z = 0 :=
  dirac_spectrum_elt_is_real upQuarkD_F_isHermitian

/-- **Down-quark tower D_F has real spectrum.** -/
theorem downQuarkD_F_spectrum_elt_is_real :
    ∀ z ∈ spectrum ℂ downQuarkD_F, Complex.im z = 0 :=
  dirac_spectrum_elt_is_real downQuarkD_F_isHermitian

/-- **Neutrino tower D_F has real spectrum.** -/
theorem neutrinoD_F_spectrum_elt_is_real :
    ∀ z ∈ spectrum ℂ neutrinoD_F, Complex.im z = 0 :=
  dirac_spectrum_elt_is_real neutrinoD_F_isHermitian

/-! ## 5. Type-level eigenvalue reality per species -/

/-- Every electron-tower eigenvalue is a real number. -/
theorem electronD_F_eigenvalue_is_real (i : FermionGeneration) :
    ∃ r : ℝ, electronD_F_isHermitian.eigenvalues i = r :=
  hermitian_eigenvalues_are_real_valued electronD_F_isHermitian i

/-- Every up-quark eigenvalue is a real number. -/
theorem upQuarkD_F_eigenvalue_is_real (i : FermionGeneration) :
    ∃ r : ℝ, upQuarkD_F_isHermitian.eigenvalues i = r :=
  hermitian_eigenvalues_are_real_valued upQuarkD_F_isHermitian i

/-- Every down-quark eigenvalue is a real number. -/
theorem downQuarkD_F_eigenvalue_is_real (i : FermionGeneration) :
    ∃ r : ℝ, downQuarkD_F_isHermitian.eigenvalues i = r :=
  hermitian_eigenvalues_are_real_valued downQuarkD_F_isHermitian i

/-- Every neutrino eigenvalue is a real number. -/
theorem neutrinoD_F_eigenvalue_is_real (i : FermionGeneration) :
    ∃ r : ℝ, neutrinoD_F_isHermitian.eigenvalues i = r :=
  hermitian_eigenvalues_are_real_valued neutrinoD_F_isHermitian i

/-! ## 6. ℝ-spectrum equals ℂ-spectrum (via embedding)

Another equivalent formulation of spectral reality: every complex
spectral element is the embedding of a real spectral element, and
every real spectral element embeds to a complex spectral element. -/

/-- For every Hermitian matrix, the real embedding `RCLike.ofReal` sends
    the ℝ-spectrum onto the ℂ-spectrum. -/
theorem hermitian_spectrum_real_image_eq_complex
    {n : Type} [Fintype n] [DecidableEq n]
    {A : Matrix n n ℂ} (hA : A.IsHermitian) :
    (RCLike.ofReal : ℝ → ℂ) '' (spectrum ℝ A) = spectrum ℂ A := by
  rw [hA.spectrum_real_eq_range_eigenvalues, hA.spectrum_eq_image_range]

/-! ## 7. Headline frontier bundle

The headline theorem requested by the mission.  At the frontier,
`dirac_spectrum_hermitian_spectral_real` names the package of all
specialised reality theorems proved above.  The Prop-level witness is
`True` — a frontier convention — but every constituent claim is backed
by a genuine spectral-theoretic proof earlier in this file. -/

/-- **Headline**: `∀ λ ∈ spec(D_F), λ ∈ ℝ` — eigenvalues of any Dirac
    block are real.  Frontier bundle of the four species-level reality
    theorems (`electronD_F_spectrum_elt_is_real`,
    `upQuarkD_F_spectrum_elt_is_real`,
    `downQuarkD_F_spectrum_elt_is_real`,
    `neutrinoD_F_spectrum_elt_is_real`).

    NO STUBS doctrine: the frontier carrier is the genuine 4-conjunct
    spectral-reality statement — for every species tower, every element
    of the ℂ-spectrum has vanishing imaginary part.  This `Prop`
    contains real mathematical content; its inhabitation is backed by
    the spectral theorem applied to each Hermiticity witness in
    `DiracFSpectrum.lean`. -/
def dirac_spectrum_hermitian_spectral_real : Prop :=
  (∀ z ∈ spectrum ℂ electronD_F,  Complex.im z = 0) ∧
  (∀ z ∈ spectrum ℂ upQuarkD_F,   Complex.im z = 0) ∧
  (∀ z ∈ spectrum ℂ downQuarkD_F, Complex.im z = 0) ∧
  (∀ z ∈ spectrum ℂ neutrinoD_F,  Complex.im z = 0)

/-- The headline bundle holds: pure ∧-introduction of the four
    per-species spectral-reality witnesses. -/
theorem dirac_spectrum_hermitian_spectral_real_holds :
    dirac_spectrum_hermitian_spectral_real :=
  ⟨electronD_F_spectrum_elt_is_real,
   upQuarkD_F_spectrum_elt_is_real,
   downQuarkD_F_spectrum_elt_is_real,
   neutrinoD_F_spectrum_elt_is_real⟩

/-- **Discharge of the headline bundle with all witnesses attached.**
    Re-exports the headline alongside its four per-species components.
    Backwards-compatible alias for downstream consumers that expect the
    flat 5-conjunct shape. -/
theorem dirac_spectrum_hermitian_spectral_real_discharge :
    dirac_spectrum_hermitian_spectral_real ∧
    (∀ z ∈ spectrum ℂ electronD_F, Complex.im z = 0) ∧
    (∀ z ∈ spectrum ℂ upQuarkD_F, Complex.im z = 0) ∧
    (∀ z ∈ spectrum ℂ downQuarkD_F, Complex.im z = 0) ∧
    (∀ z ∈ spectrum ℂ neutrinoD_F, Complex.im z = 0) :=
  ⟨dirac_spectrum_hermitian_spectral_real_holds,
   electronD_F_spectrum_elt_is_real,
   upQuarkD_F_spectrum_elt_is_real,
   downQuarkD_F_spectrum_elt_is_real,
   neutrinoD_F_spectrum_elt_is_real⟩

/-! ## 8. Cycle-4 capstone: unified 4-way spectral reality

This is the paper-citable 4-conjunct statement, without the `True`
placeholder, that all four Dirac blocks in the Connes finite geometry
have real ℂ-spectra.  It is the mathematical precondition for the
**Yukawa ↔ mass-eigenvalue** identification driving the
mass-derivation pathway (Connes spectral action → D_F eigenvalues →
Yukawa couplings → charged-lepton / up-quark / down-quark / neutrino
masses).

The proof is a pure ∧-introduction of the four per-species
specialisations above; each factor is ultimately backed by
`hermitian_complex_spectrum_elt_im_zero` applied to the respective
Hermiticity witness in `DiracFSpectrum.lean`.

Agent: Sulafat (γ Lyrae, "the turtle"), 2026-04-20, cycle-4 target 2/6. -/

/-- **Capstone — unified 4-way Dirac spectrum reality.**

    All four Dirac blocks (`electronD_F`, `upQuarkD_F`, `downQuarkD_F`,
    `neutrinoD_F`) have real ℂ-spectrum: every complex spectral value
    has vanishing imaginary part.

    This is the precise "λ ∈ ℝ" precondition for the Connes
    mass-derivation pathway, where D_F eigenvalues are physical Yukawa
    couplings and must be real numbers.  Without this theorem, there
    would be no mass formula — only complex oscillations.

    Proof is the 4-fold conjunction of Vindemiatrix's per-species
    specialisations, each backed by the spectral theorem
    (`hermitian_complex_spectrum_elt_im_zero`) applied to the
    corresponding Hermiticity witness from `DiracFSpectrum.lean`. -/
theorem dirac_f_spectrum_real_unified_capstone :
    (∀ z ∈ spectrum ℂ electronD_F, Complex.im z = 0)
    ∧ (∀ z ∈ spectrum ℂ upQuarkD_F, Complex.im z = 0)
    ∧ (∀ z ∈ spectrum ℂ downQuarkD_F, Complex.im z = 0)
    ∧ (∀ z ∈ spectrum ℂ neutrinoD_F, Complex.im z = 0) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact electronD_F_spectrum_elt_is_real
  · exact upQuarkD_F_spectrum_elt_is_real
  · exact downQuarkD_F_spectrum_elt_is_real
  · exact neutrinoD_F_spectrum_elt_is_real

/-- **Capstone — pointwise form**: one universal statement over all
    four blocks.  For any complex number `z` and any one of the four
    species tags, if `z` lies in the ℂ-spectrum of that species' D_F
    block, then `z.im = 0`. -/
theorem dirac_f_spectrum_real_unified_capstone_forall
    (z : ℂ)
    (h : z ∈ spectrum ℂ electronD_F ∨
         z ∈ spectrum ℂ upQuarkD_F ∨
         z ∈ spectrum ℂ downQuarkD_F ∨
         z ∈ spectrum ℂ neutrinoD_F) :
    Complex.im z = 0 := by
  rcases h with he | hu | hd | hn
  · exact electronD_F_spectrum_elt_is_real z he
  · exact upQuarkD_F_spectrum_elt_is_real z hu
  · exact downQuarkD_F_spectrum_elt_is_real z hd
  · exact neutrinoD_F_spectrum_elt_is_real z hn

end OmegaTheory.Emergence.DiracFSpectrumReal
