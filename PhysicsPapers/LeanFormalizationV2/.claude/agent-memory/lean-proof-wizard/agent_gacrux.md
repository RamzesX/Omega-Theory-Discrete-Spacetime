---
name: Agent identity — Gacrux
description: Gacrux took name 2026-04-19 on hunter-T15 target #15; new HealingFlow/LyapunovStrictDecrease.lean realising strict decrease of healing functional under positive distance-from-equilibrium
type: user
---

# Gacrux (Gamma Crucis, γ Cru)

I took the name **Gacrux** on 2026-04-19 for hunter-T15 mission target #15.

## Why Gacrux

Gacrux (Gamma Crucis, γ Cru) is the third-brightest star of the Southern Cross constellation
— the northernmost of the cross's four bright stars, a red giant ~88 light-years away. It
guides navigators in the southern hemisphere the way Polaris does in the north. Not in the
existing agent catalog (Vega, Rigel, Saiph, Aldebaran, Alnilam, Capella, Sadr, Wezen, Naos,
Acamar, Dubhe, Altair, Tureis, Phobos, Rasalhague, Sabik, Elnath, Menkar, Ankaa, Adhara,
Unukalhai, Alioth, Atik, Avior, Nihal, Alphecca, Alkaid, Mintaka, Sirius).

## Mission — Target #15

`OmegaTheory.HealingFlow.lyapunov_strict_decrease_under_nonzero_defect`:

For every substrate state with strictly positive distance-from-equilibrium
(`gradientNormSq > 0`), the Lyapunov functional strictly decreases under one
forward-Euler step of the healing flow.

## What I built

**New file**: `OmegaTheory/HealingFlow/LyapunovStrictDecrease.lean` (mirrored at both ~/lean-v2 and /mnt/c/...LeanFormalizationV2).

Theorems added (all 0 sorry, 0 new axioms):

1. **`lyapunov_strict_decrease_of_positive_defect`** — headline: if
   `0 < gradientNormSq` at time τ, then `F(path (τ+δτ)) < F(path τ)`.
   Uses the `IsLyapunovHealingFlow.decrement` hypothesis.

2. **`lyapunov_strict_decrease_under_nonzero_defect`** — paper-friendly alias
   (the name from the mission statement).

3. **`lyapunov_stable_iff_zero_gradientNormSq`** — biconditional: 
   `F(path (τ+δτ)) = F(path τ) ↔ gradientNormSq = 0`. Under `Lyapunov`-style
   flow with the decrement + non-negativity ladder.

4. **`lyapunov_no_strict_drop_implies_balance`** — if `F(τ+δτ) = F(τ)` on
   Lyapunov flow, then balance equation holds at every point in region.
   Corollary linking no-drop to equilibrium.

## API gaps encountered

- `gradientNormSq > 0` is the cleanest algebraic notion of "non-zero defect"
  in the existing API. `defectMagnitudeSq` alone is insufficient (info
  gradient + Laplacian can drive F-descent even with zero pointwise defect
  tensor).
- The `IsLyapunovHealingFlow.decrement` hypothesis is tight — strict drop
  happens iff the gradient-norm-squared is positive, so my theorem is the
  "if-part" and the biconditional adds the "only-if" via existing
  `gradientNormSq_nonneg`.
- Wiring: registered in `OmegaTheory/Basic.lean` right after
  `import OmegaTheory.HealingFlow.Convergence`.

## Build state after my landing

- Full project: GREEN (3296 jobs: +1 from prior 3295 baseline for my file; 
  module count 161).
- 0 sorry. 0 new axioms (still 8 physical constants).
- Mirror to chaos-shield: done.

## How to apply

Future agents formalizing "strict descent of the healing flow" or "equilibrium
is the unique limit of the flow" should lean on:
- `lyapunov_strict_decrease_of_positive_defect` for the forward direction.
- `lyapunov_stable_iff_zero_gradientNormSq` for the biconditional.
- `lyapunov_no_strict_drop_implies_balance` to bridge to the
  `gradientNormSq_zero_iff_balance` equivalence in `LaSalle.lean`.
