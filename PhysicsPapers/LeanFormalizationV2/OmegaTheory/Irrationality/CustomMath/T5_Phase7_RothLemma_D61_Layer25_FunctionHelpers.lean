/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer25_FunctionHelpers

  T-5 (Roth's theorem) — **D.6.1 Layer 25: function manipulation helpers**.

  Single-thread hand-authored 2026-04-29.

  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Logic.Function.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer25_FunctionHelpers

/-! ## FN-1 — Function comp identity left -/

theorem T5_id_comp {α β : Type*} (f : α → β) : id ∘ f = f := Function.id_comp f

/-! ## FN-2 — Function comp identity right -/

theorem T5_comp_id {α β : Type*} (f : α → β) : f ∘ id = f := Function.comp_id f

/-! ## FN-3 — Function comp associative -/

theorem T5_comp_assoc {α β γ δ : Type*} (f : α → β) (g : β → γ) (h : γ → δ) :
    h ∘ (g ∘ f) = (h ∘ g) ∘ f := rfl

/-! ## FN-4 — funext -/

theorem T5_funext {α β : Type*} (f g : α → β) (h : ∀ x, f x = g x) : f = g :=
  funext h

/-! ## FN-5 — `∘` definitional unfold -/

theorem T5_comp_apply {α β γ : Type*} (g : β → γ) (f : α → β) (x : α) :
    (g ∘ f) x = g (f x) := rfl

/-! ## FN-6 — Identity application -/

theorem T5_id_apply {α : Type*} (x : α) : id x = x := rfl

/-! ## FN-7 — Constant function -/

theorem T5_const_apply {α β : Type*} (b : β) (a : α) :
    (Function.const α b) a = b := rfl

/-! ## FN-8 — Identity composed with f equals f -/

theorem T5_id_comp_simp {α : Type*} (f : ℝ → α) : id ∘ f = f := by
  funext x
  rfl

/-! ## FN-9 — Composing identity twice -/

theorem T5_id_id : (id ∘ id : ℝ → ℝ) = id := by
  funext x
  rfl

/-! ## FN-10 — Layer 25 foundational marker -/

theorem T5_D61_Layer25_completed_marker :
    (∀ {α β : Type*} (f : α → β), id ∘ f = f) ∧
    (∀ {α β : Type*} (f : α → β), f ∘ id = f) ∧
    (∀ {α β γ : Type*} (g : β → γ) (f : α → β) (x : α), (g ∘ f) x = g (f x)) ∧
    (∀ {α β : Type*} (f g : α → β), (∀ x, f x = g x) → f = g) ∧
    (∀ {α : Type*} (x : α), id x = x) :=
  ⟨@T5_id_comp,
   @T5_comp_id,
   @T5_comp_apply,
   @T5_funext,
   @T5_id_apply⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer25_FunctionHelpers
