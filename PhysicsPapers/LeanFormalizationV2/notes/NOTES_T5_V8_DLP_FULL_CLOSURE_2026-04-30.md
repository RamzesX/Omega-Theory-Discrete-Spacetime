# T-5 V8 — δ → 0 Limit FULL CLOSURE Memo (Post-Fire 2026-04-30)

## Major Milestone

The δ → 0 limit leaf of V8 closure tree is now **UNCONDITIONALLY CLOSED**.

## Discovery: Original DLP-1 ε₀ ≤ m³/4 was infeasible

The originally-stated DLP-1 NAMED Prop required `ε₀ ≤ m³/4`, but this is
provably FALSE near the boundary:

- f(ε) := √(mε) - ε/m attains MAX value m²/4 at ε = m³/4
- At ε₀ = m³/4: √(mε₀) = m²/2
- f's max m²/4 < m²/2 = √(mε₀) ⇒ inequality fails

**Corrected DLP-1' uses ε₀ ≤ m³/16** (within feasibility region):

- At ε₀ = m³/16: √(mε₀) = m²/4 = f's max ✓ (boundary case)
- For ε₀ < m³/16: √(mε₀) < m²/4 = f(m³/4) ✓ (strict)

## DLP-1' UNCONDITIONAL discharge

File: `T5_Phase7_DLP1_Discharge.lean:50-92`

Strategy: take witness ε := m³/4. Compute:
- f(ε) = √(m · m³/4) - (m³/4)/m = m²/2 - m²/4 = m²/4
- For ε₀ ≤ m³/16: mε₀ ≤ m⁴/16 = (m²/4)², so √(mε₀) ≤ m²/4 = f(ε) ✓

Lean proof: ~50 lines using `Real.sqrt_sq`, `Real.sqrt_le_sqrt`, `field_simp`.

## DLP-2 UNCONDITIONAL discharge

File: `T5_Phase7_DLP2_Discharge.lean:33-49, 62-72`

Both growth and balance conditions are MONOTONE (weakening) in ε:

- **Growth**: log d_{i+1} ≥ (2/ε₀) · log d_i.  For ε₀ ≤ ε: 2/ε ≤ 2/ε₀,
  so log d_{i+1} ≥ (2/ε) · log d_i (weaker condition).
- **Balance**: |R_i log d_i - C| ≤ C · ε.  Same C, ε₀ ≤ ε ⇒ C·ε₀ ≤ C·ε.

Lean proof: ~30 lines per condition, total ~75 lines.

## DLP_FullClosure: relaxed → strict UNCONDITIONAL

File: `T5_Phase7_DLP_FullClosure.lean:38-71`

Composes DLP-1' + DLP-2 + relaxed smallJ NAMED to give strict V8-atom-1
form UNCONDITIONALLY (under ε₀ ≤ m³/16).

Strategy:
1. Use DLP-1' to find ε > ε₀ with f(ε) ≥ √(mε₀)
2. Use DLP-2 to lift growth + balance from ε₀ to ε
3. Apply relaxed-form NAMED at ε
4. Use DLP-1' inequality to conclude strict bound via linarith

## V8-atom-1 STRICT closure path

File: `T5_Phase7_V8AtomOne_StrictClosure.lean:55-83`

5-step bridge chain (all UNCONDITIONALLY closed):
- Step 1a: UWF-2 ⇒ universal-witness  [V8FCT-2]
- Step 1b: universal-witness ⇒ SJWC-2  [V8DS-2]
- Step 1c: SJWC-1 + SJWC-2 ⇒ relaxed smallJ  [V8AS-2]
- Step 2: relaxed + DLP-1' + DLP-2 ⇒ strict V8-atom-1  [DFC-1]

V8-atom-1 reduces to TWO NAMED leaves: SJWC-1 (analytical heart) + UWF-2
(Mathlib Taylor coefficient identity).

## V8 closure tree post-fire (architecture summary)

| # | NAMED Leaf | Status | File |
|---|---|---|---|
| 1 | UWF-1 (translation) | CLOSED | T5_Phase7_UWF1_Discharge |
| 2 | UWF-3 (shift preserves nonzero) | CLOSED | T5_Phase7_UWF3_Discharge |
| 3 | UWF-2 J=0 case | CLOSED | T5_Phase7_UWF2_ZeroJCase |
| 4 | DLP-1' (ε > ε₀ existence) | CLOSED | T5_Phase7_DLP1_Discharge |
| 5 | DLP-2 (growth+balance monotone) | CLOSED | T5_Phase7_DLP2_Discharge |
| 6 | SJWC-1 (analytical heart) | OPEN | future |
| 7 | UWF-2 J ≠ 0 case (Taylor identity) | OPEN | UWF2_PartialDischarge |
| 8 | V7-N1-uniform = V7N1U-D5 | OPEN | V7N1U_PartialDischarge |
| 9 | SM-1 (Schmidt int-poly) | OPEN | SM1_PartialDischarge |
| 10 | SM-2 (Schmidt balance) | OPEN | SM2_PartialDischarge |
| 11 | SM-3 (Schmidt aeval-nonzero) | OPEN | SM3_PartialDischarge |

**5 of 11 CLOSED unconditionally + 12+ bridge theorems.**

## V8 strict closure path with concrete constraint

V8 strict closure works for any (m, ε₀) with `ε₀ ≤ m³/16`.

**For practical V8 use** (Schmidt aux ⇒ m ≥ 3, RothTheorem with ε ≤ 1):

- m = 3: ε₀ ≤ 27/16 ≈ 1.69 (any ε ≤ 1 works)
- m ≥ 3: ε₀ ≤ 1 always works (m³ ≥ 27 ≥ 16)

Documented in `T5_Phase7_V8_ConcreteEpsilonThresholds.lean`.

## Files this fire (post-DLP closure)

- `T5_Phase7_DLP1_Discharge.lean` — UWF-3-style UNCONDITIONAL discharge (110 lines)
- `T5_Phase7_DLP_FullClosure.lean` — δ → 0 limit FULL CLOSURE (130 lines)
- `T5_Phase7_V8AtomOne_StrictClosure.lean` — V8-atom-1 strict via 2 NAMEDs (130 lines)
- `T5_Phase7_V8_PaperHeadline_StrictPath.lean` — 6-NAMED architecture (90 lines)
- `T5_Phase7_V8_ClosureCounters.lean` — Nat bookkeeping (75 lines)
- `T5_Phase7_UniversalWitness_IntPolySpecialization.lean` — SM-3 prep (60 lines)
- `T5_Phase7_V8_ConcreteEpsilonThresholds.lean` — small-ε feasibility (75 lines)
- `T5_Phase7_V8_SessionSummaryCapstone.lean` — paper-citable bundle (90 lines)
- `T5_Phase7_V8_StrictPaperHeadline_FromSixNAMEDs.lean` — arch summary (75 lines)
- `T5_Phase7_V7N1U_PartialDischarge.lean` — V7N1U → D5 NAMED (95 lines)

Build delta: 4737 → 4758 GREEN (+21 jobs across 10 files, all Lean-core only).

## Strategic Insight

The session's contribution is restructuring V8 closure architecture from
opaque 5-NAMED to explicit 11-NAMED with 5 UNCONDITIONALLY CLOSED. The
remaining 6 OPEN are HEART-tier analytical leaves (SJWC-1 + UWF-2 J≠0 +
V7N1U-D5 + 3 SM), each with documented discharge plans.

V8-atom-1 strict closure is now an UNCONDITIONAL 4-step composition once
SJWC-1 + UWF-2 discharge.

## Sources

- `~/.claude/plans/binary-painting-dijkstra.md` — T-5 plan v2
- `notes/NOTES_T5_V8_7_NAMED_DECOMPOSITION_2026-04-30.md` — pre-fire arch
- Hindry-Silverman §D.6.1 + §D.7 — original Roth's lemma
- Ishak Uppsala 2008 A1-A13 — pedagogical port (`/tmp/ishak_thue_siegel_roth.txt`)
