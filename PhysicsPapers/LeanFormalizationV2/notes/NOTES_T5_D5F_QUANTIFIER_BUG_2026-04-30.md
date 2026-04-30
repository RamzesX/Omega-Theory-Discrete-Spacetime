# T-5 D5F Quantifier Bug Discovery + Fix — 2026-04-30

## Bug discovery

In previous fire's `T5_Phase7_V7N1U_D5_Factoring.lean`, the NAMED Prop
`T5_NAMED_V7N1U_D5c_per_q_decay` quantified (C_upper, κ) UNIVERSALLY:

```lean
def T5_NAMED_V7N1U_D5c_per_q_decay : Prop :=
  ∀ ... (P, R, ...) ...
  ∀ (C_upper : ℝ), 0 < C_upper →    -- ❌ WRONG: ∀ instead of ∃
  ∀ (κ : ℝ), 1 < κ →                 -- ❌ WRONG: ∀ instead of ∃
  ∀ (q : Fin m → ℚ), ... →
    |aeval q P| ≤ C_upper * (∏...) ^ (-κ)
```

This is LITERAL FALSE: take κ → ∞, RHS → 0, but LHS = |aeval q P| can be
positive O(1) for generic P, q.

Same architectural quantification mismatch as V8R7's universal small-eps
axis (audited 2026-04-30).

## Fix

`T5_NAMED_V7N1U_D5c_per_q_decay` redefined to be DEFINITIONALLY EQUAL to
the original V7N1U-D5 (existential form):

```lean
def T5_NAMED_V7N1U_D5c_per_q_decay : Prop :=
  T5_NAMED_V7N1U_D5_kappa_composition
```

This is HONEST but TAUTOLOGICAL — the existential coupling of (C, κ)
prevents clean factoring. D5a (κ existence ∃) and D5b (C existence ∃)
discharges remain paper-citable as standalone trivial-scaffold but do
NOT decompose D5's analytical content.

## Architectural lesson (LOCKED)

When factoring an outer `∃ x₁ x₂ ..., P(x₁, x₂, ...)` Prop into sub-NAMEDs,
quantifying the witnesses (x₁, x₂, ...) UNIVERSALLY in sub-NAMEDs is
typically WRONG — it makes the sub-NAMED literal-false. The witnesses
must be EXISTENTIALLY chosen consistently across sub-NAMEDs, OR the
factoring must be sequential (sub-NAMED 1 fixes x₁, sub-NAMED 2 uses
fixed x₁ to fix x₂, etc.).

Common pattern: `∃ C κ, ∀ q, bound(q, C, κ)` does NOT factor as
`(∃ C, ...) ∧ (∃ κ, ...) ∧ (∀ q ∀ C ∀ κ, bound(q, C, κ))` — the third
conjunct is false.

When in doubt: keep the Prop monolithic. Verify quantifier order by
asking "can this Prop be falsified by an adversary choosing the
∀-quantified inputs?"

## Discharge added

Concrete D5b discharge `T5_V7N1U_D5b_unconditional_concrete` with
`C := coeffSumPlusOne P = 1 + ∑ |coeff s P|` provides paper-citable
strengthening of trivial `C := 1` (both discharge the existential
D5b but the concrete form captures the L¹-norm of P's coefficients —
the natural absorbing constant for binomial-coefficient bounds in
multivariate Taylor expansions).

## Files updated

- `T5_Phase7_V7N1U_D5_Factoring.lean` — D5c redefined as existential
  (= V7N1U-D5 itself); composition theorem becomes identity.
- `T5_Phase7_V7N1U_D5b_ConcreteC.lean` (NEW) — concrete D5b discharge
  via coefficient sum.

Build: 4646 → 4647 GREEN. Lean-core only.

## Open: full analytical D5c discharge

V7N1U-D5 ≡ V7N1U is monolithic. Discharge requires ~200 lines: AM-QM +
Cauchy-Schwarz + balance + small-ε formula + multivariate Taylor.

## Sources

- ErdosPrimarch v8.0 BOOK_VII NO_STUBS rule
- V8 Audit memo `notes/NOTES_T5_V8_ARCHITECTURAL_AUDIT_2026-04-30.md`
