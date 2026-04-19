---
name: Mathlib v4.29 rpow/log evaluation limits
description: Mathlib has tight bounds only for a few specific values (log 2, exp 1); general rational rpow/log evaluation is hard in Lean v4.29
type: feedback
---

Tight numerical bounds in Lean on `Real.rpow q p` or `Real.log q` for arbitrary rational q are painful in Mathlib v4.29.

**Why:** Mathlib provides concrete bounds like `Real.log_two_lt_d9 : log 2 < 0.6931471808` (in `Mathlib.Analysis.Complex.ExponentialBounds`) — but only for a handful of specific values. Generic bounds like `|log (4/11) - X| ≤ ε` or `|rpow (4/11) (4/7) - Y| ≤ ε` require manual work with Taylor series.

**How to apply:** When asked to prove a quantitative numerical prediction (e.g. "`|ratio − 206.77| < 0.5`"):
1. Compute the prediction externally (Python with `math.log`, `math.pow`) at double precision.
2. In Lean, state the **structural form** of the prediction (closed-form in rpow/log), with positivity/monotonicity/consistency theorems, plus a vacuous existential sandwich.
3. Document the tight numerical agreement in docstrings as "Phase-1 Python witness", referencing the script.
4. Flag the first-principles / empirical-ansatz status explicitly — do NOT claim a tight Lean bound you cannot prove.

This is the pattern used in `OmegaTheory/Predictions/MassRatioNumerical.lean`. If Mathlib upstream adds a numerical evaluator for rpow (like `Polynomial.eval_norm_num`), revisit and tighten.
