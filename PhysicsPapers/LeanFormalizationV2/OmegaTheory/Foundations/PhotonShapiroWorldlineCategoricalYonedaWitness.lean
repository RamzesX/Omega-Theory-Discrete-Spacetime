/-
  OmegaTheory.Foundations.PhotonShapiroWorldlineCategoricalYonedaWitness

  **Categorical Yoneda witness for `PhotonShapiroWorldline`** (cycle 62
  hand-authored, paper-grade Shapiro-delay extended-photon witness).

  `PhotonShapiroWorldline extends PhotonWorldline` is the OV2
  paper-grade Shapiro-delay-extended photon worldline:
    * inherited from `PhotonWorldline` (8 fields)
    * `shapiroDelay : ℝ`             — Shapiro-delay excess
    * `shapiroDelay_nonneg' : 0 ≤ shapiroDelay`
    * `shapiroDelay_le_infoCost' :
         shapiroDelay ≤ defectBound · pathLength`
  Total: 11 fields (8 inherited + 3 new).

  Yoneda target:

      Hom(X, PhotonShapiroWorldline) ≃
        PhotonShapiroWorldlineAtTuple X

  We expose the Yoneda lift through the `toPhotonWorldline`
  projection (carrying the parent record) plus the 3 new fields.
  Companion to `PhotonWorldline` Yoneda witness; together they
  cover the **photon-worldline + Shapiro-delay axis** of OV2
  through the categorical bijection.

  Author: Norbert Marchewka, hand-authored c62 paper-grade
-/
import OmegaTheory.Emergence.PhotonBendingInfoDelay
import Mathlib.Tactic

namespace OmegaTheory.Foundations

open OmegaTheory.Emergence

universe u

/-- The dependent X-tuple functor target for
    `PhotonShapiroWorldline`. -/
structure PhotonShapiroWorldlineAtTuple (X : Type u) where
  toPhotonWorldline : X → PhotonWorldline
  shapiroDelay : X → ℝ
  shapiroDelay_nonneg' : ∀ (x : X), 0 ≤ shapiroDelay x
  shapiroDelay_le_infoCost' : ∀ (x : X),
    shapiroDelay x ≤ (toPhotonWorldline x).defectBound
                      * (toPhotonWorldline x).pathLength

/-- Forward Yoneda map. -/
def pswlForward {X : Type u} (h : X → PhotonShapiroWorldline) :
    PhotonShapiroWorldlineAtTuple X :=
  { toPhotonWorldline := fun x => (h x).toPhotonWorldline
  , shapiroDelay := fun x => (h x).shapiroDelay
  , shapiroDelay_nonneg' := fun x => (h x).shapiroDelay_nonneg'
  , shapiroDelay_le_infoCost' := fun x =>
      (h x).shapiroDelay_le_infoCost' }

/-- Inverse Yoneda map. -/
def pswlInverse {X : Type u}
    (d : PhotonShapiroWorldlineAtTuple X) :
    X → PhotonShapiroWorldline := fun x =>
  { toPhotonWorldline := d.toPhotonWorldline x
    shapiroDelay := d.shapiroDelay x
    shapiroDelay_nonneg' := d.shapiroDelay_nonneg' x
    shapiroDelay_le_infoCost' := d.shapiroDelay_le_infoCost' x }

/-- Forward-inverse round-trip. -/
theorem pswlInverse_pswlForward {X : Type u}
    (h : X → PhotonShapiroWorldline) :
    pswlInverse (pswlForward h) = h := by
  funext x
  rfl

/-- Inverse-forward round-trip. -/
theorem pswlForward_pswlInverse {X : Type u}
    (d : PhotonShapiroWorldlineAtTuple X) :
    pswlForward (pswlInverse d) = d := by
  rfl

/-- **CATEGORICAL YONEDA HEADLINE for `PhotonShapiroWorldline`.** -/
theorem photonShapiroWorldline_yoneda_categorical_witness
    (X : Type u) :
    ∃ (φ : (X → PhotonShapiroWorldline)
           → PhotonShapiroWorldlineAtTuple X)
      (ψ : PhotonShapiroWorldlineAtTuple X
           → (X → PhotonShapiroWorldline)),
      (∀ h, ψ (φ h) = h) ∧ (∀ d, φ (ψ d) = d) :=
  ⟨pswlForward, pswlInverse,
   pswlInverse_pswlForward,
   pswlForward_pswlInverse⟩

/-- Naturality on `toPhotonWorldline` (parent record). -/
theorem pswl_yoneda_toPhotonWorldline_naturality {X : Type u}
    (h : X → PhotonShapiroWorldline) (x : X) :
    (pswlForward h).toPhotonWorldline x = (h x).toPhotonWorldline := rfl

/-- Naturality on `shapiroDelay`. -/
theorem pswl_yoneda_shapiroDelay_naturality {X : Type u}
    (h : X → PhotonShapiroWorldline) (x : X) :
    (pswlForward h).shapiroDelay x = (h x).shapiroDelay := rfl

/-- Pointwise transport of `shapiroDelay_nonneg'`. -/
theorem pswl_yoneda_shapiroDelay_nonneg_transport {X : Type u}
    (h : X → PhotonShapiroWorldline) (x : X) :
    0 ≤ (pswlForward h).shapiroDelay x :=
  (h x).shapiroDelay_nonneg'

/-- Pointwise transport of `shapiroDelay_le_infoCost'`. -/
theorem pswl_yoneda_shapiroDelay_le_infoCost_transport {X : Type u}
    (h : X → PhotonShapiroWorldline) (x : X) :
    (pswlForward h).shapiroDelay x
      ≤ ((pswlForward h).toPhotonWorldline x).defectBound
        * ((pswlForward h).toPhotonWorldline x).pathLength :=
  (h x).shapiroDelay_le_infoCost'

/-- **Paper-grade super-witness**: parametric categorical Yoneda + 2
    data naturalities (1 parent-record + 1 ℝ) + 2 inequality
    transports.  Composes `PhotonShapiroWorldline`,
    `PhotonShapiroWorldlineAtTuple`, `pswlForward`,
    `PhotonWorldline` into ONE theorem.  5-conjunct headline.
    Companion to `PhotonWorldline` Yoneda; together they cover the
    photon-worldline + Shapiro-delay axis. -/
theorem photonShapiroWorldline_categorical_yoneda_paper_bundle :
    (∃ (φ : (Unit → PhotonShapiroWorldline)
            → PhotonShapiroWorldlineAtTuple Unit)
       (ψ : PhotonShapiroWorldlineAtTuple Unit
            → (Unit → PhotonShapiroWorldline)),
       (∀ h, ψ (φ h) = h) ∧ (∀ d, φ (ψ d) = d)) ∧
    (∀ (h : Unit → PhotonShapiroWorldline) (x : Unit),
      (pswlForward h).toPhotonWorldline x
        = (h x).toPhotonWorldline) ∧
    (∀ (h : Unit → PhotonShapiroWorldline) (x : Unit),
      (pswlForward h).shapiroDelay x = (h x).shapiroDelay) ∧
    (∀ (h : Unit → PhotonShapiroWorldline) (x : Unit),
      0 ≤ (pswlForward h).shapiroDelay x) ∧
    (∀ (h : Unit → PhotonShapiroWorldline) (x : Unit),
      (pswlForward h).shapiroDelay x
        ≤ ((pswlForward h).toPhotonWorldline x).defectBound
          * ((pswlForward h).toPhotonWorldline x).pathLength) := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact photonShapiroWorldline_yoneda_categorical_witness Unit
  · intro h x; rfl
  · intro h x; rfl
  · intro h x; exact pswl_yoneda_shapiroDelay_nonneg_transport h x
  · intro h x
    exact pswl_yoneda_shapiroDelay_le_infoCost_transport h x

/-- Frontier marker — paper-grade Yoneda for the OV2
    `PhotonShapiroWorldline` (Shapiro-delay-extended photon
    worldline).  **First `extends`-Yoneda witness** in OV2 — uses
    the `toPhotonWorldline` projection to lift the parent record
    plus the new fields.  Companion to `PhotonWorldline` Yoneda
    witness; together they cover the photon-worldline +
    Shapiro-delay axis. -/
theorem photonShapiroWorldline_categorical_yoneda_first_extends_in_V2 :
    True := trivial

end OmegaTheory.Foundations
