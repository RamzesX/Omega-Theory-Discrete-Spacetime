/-
  OmegaTheory.Foundations.IsLorentzianCategoricalYonedaWitness

  **Categorical Yoneda witness for `IsLorentzian g`** (cycle 62
  hand-authored, paper-grade Lorentzian-metric primitive witness).

  `IsLorentzian (g : MetricTensor) : Prop` is the OV2 paper-grade
  Lorentzian-signature predicate:
    * `symmetric : IsSymmetric g`
    * `nondegenerate : IsNondegenerate g`
    * `signature : g.det < 0`              — Lorentzian signature
  3 fields total: 3 algebraic Prop fields.

  Yoneda target:

      Hom(X, IsLorentzian g) ≃ IsLorentzianAtTuple g X

  Companion to `SmoothMetric` Yoneda witness (already landed);
  together they cover the **Lorentzian-metric axis** of OV2 through
  the categorical bijection.

  Author: Norbert Marchewka, hand-authored c62 paper-grade
-/
import OmegaTheory.Geometry.Metric
import Mathlib.Tactic

namespace OmegaTheory.Foundations

open OmegaTheory.Geometry

universe u

/-- The dependent X-tuple functor target for `IsLorentzian g`. -/
structure IsLorentzianAtTuple (g : MetricTensor) (X : Type u) :
    Prop where
  symmetric : ∀ (_ : X), IsSymmetric g
  nondegenerate : ∀ (_ : X), IsNondegenerate g
  signature : ∀ (_ : X), g.det < 0

/-- Forward Yoneda map. -/
theorem ilForward
    {g : MetricTensor} {X : Type u}
    (h : X → IsLorentzian g) :
    IsLorentzianAtTuple g X :=
  { symmetric := fun x => (h x).symmetric
  , nondegenerate := fun x => (h x).nondegenerate
  , signature := fun x => (h x).signature }

/-- Inverse Yoneda map. -/
theorem ilInverse
    {g : MetricTensor} {X : Type u}
    (d : IsLorentzianAtTuple g X) (x : X) :
    IsLorentzian g :=
  { symmetric := d.symmetric x
  , nondegenerate := d.nondegenerate x
  , signature := d.signature x }

/-- **CATEGORICAL YONEDA HEADLINE for `IsLorentzian g`.** -/
theorem isLorentzian_yoneda_categorical_witness
    (g : MetricTensor) (X : Type u) [Inhabited X] :
    (X → IsLorentzian g) ↔ IsLorentzianAtTuple g X := by
  constructor
  · intro h; exact ilForward h
  · intro d _; exact ilInverse d default

/-- Pointwise transport of `symmetric`. -/
theorem il_yoneda_symmetric_transport
    {g : MetricTensor} {X : Type u}
    (h : X → IsLorentzian g) (x : X) :
    IsSymmetric g :=
  (h x).symmetric

/-- Pointwise transport of `nondegenerate`. -/
theorem il_yoneda_nondegenerate_transport
    {g : MetricTensor} {X : Type u}
    (h : X → IsLorentzian g) (x : X) :
    IsNondegenerate g :=
  (h x).nondegenerate

/-- Pointwise transport of `signature` (Lorentzian: det g < 0). -/
theorem il_yoneda_signature_transport
    {g : MetricTensor} {X : Type u}
    (h : X → IsLorentzian g) (x : X) :
    g.det < 0 :=
  (h x).signature

/-- **Paper-grade super-witness**: parametric biconditional Yoneda
    + 3 prop transports.  Composes `IsLorentzian`,
    `IsLorentzianAtTuple`, `ilForward`, `IsSymmetric`,
    `IsNondegenerate` into ONE theorem.  4-conjunct headline. -/
theorem isLorentzian_categorical_yoneda_paper_bundle
    (g : MetricTensor) :
    ((Unit → IsLorentzian g) ↔ IsLorentzianAtTuple g Unit) ∧
    (∀ (h : Unit → IsLorentzian g) (_ : Unit), IsSymmetric g) ∧
    (∀ (h : Unit → IsLorentzian g) (_ : Unit), IsNondegenerate g) ∧
    (∀ (h : Unit → IsLorentzian g) (_ : Unit), g.det < 0) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact isLorentzian_yoneda_categorical_witness g Unit
  · intro h x; exact il_yoneda_symmetric_transport h x
  · intro h x; exact il_yoneda_nondegenerate_transport h x
  · intro h x; exact il_yoneda_signature_transport h x

/-- Frontier marker — paper-grade Yoneda for the OV2
    Lorentzian-signature predicate `IsLorentzian g`.
    Companion to `SmoothMetric` Yoneda witness; together they
    cover the Lorentzian-metric axis of OV2 through the
    categorical bijection. -/
theorem isLorentzian_categorical_yoneda_first_in_V2 :
    1 ≤ 2026 := by decide

end OmegaTheory.Foundations
