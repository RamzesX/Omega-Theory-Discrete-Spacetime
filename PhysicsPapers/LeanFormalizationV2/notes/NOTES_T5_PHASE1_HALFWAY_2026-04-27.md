# T-5 Phase 1 Progress — 5/10 sub-lemmas DONE (2026-04-27)

**Status**: T-5 Phase 1 (Foundational lemmas) is HALFWAY complete. 5 of
10 sub-lemmas landed in single autonomous session.

## Sub-lemmas done (5/10)

| Sub | File | Theorem |
|-----|------|---------|
| 1/10 | `T5_Liouville_Bound.lean` | `liouville_bound_for_algebraic_irrational` |
| 2/10 | `T5_Heights.lean` | `Rat.naiveHeight` + bounds |
| 3/10 | `T5_LiouvilleHeightBound.lean` | `RothBoundExists` def + Liouville version |
| 4/10 | `T5_PolynomialIndex.lean` | `Polynomial.indexAtPoint` (1-var rootMultiplicity wrapper) |
| 5/10 | `T5_DerivativeCharacterization.lean` | derivative^n p root at a iff n < index |

All Lean-core only. All build GREEN.

## Sub-lemmas remaining (5/10)

6/10. **Multivariable index** — `MvPolynomial.indexAtPoint p (a : Fin n → R)`.
   Requires defining the multivariable index as the largest k such that
   all partial derivatives of order < k (in any single variable) vanish.

7/10. **Index sub-additivity** — `indexAtPoint (p + q) ≤ min (indexAtPoint p) (indexAtPoint q)`.

8/10. **Auxiliary polynomial existence** — for any (p_1/q_1, ..., p_n/q_n)
   with bounded heights, there exists `P : MvPolynomial (Fin n) ℤ` of
   bounded degree with high index at the tuple.

9/10. **Wronskian non-vanishing** — for n linearly independent functions
   y_1, ..., y_n at a point, the Wronskian determinant is nonzero.

10/10. **Roth's lemma** — index of the auxiliary polynomial is bounded
   above by `n/N · degree` where N is the iteration index.

## Phase 1 finish estimate

Each remaining sub-lemma: ~50-100 lines, ~1-2 hours Opus 4.7
single-thread. Total: ~5-10 hours to finish Phase 1.

## Phase 2-5 reminder (per attack plan)

- Phase 2: Auxiliary polynomial construction (15 sub-lemmas, ~800 lines, ~4 days)
- Phase 3: Index theorem + Roth's lemma (10 sub-lemmas, ~600 lines, ~3 days)
- Phase 4: Final Roth contradiction (5 sub-lemmas, ~300 lines, ~2 days)
- Phase 5: Project integration (3 files, ~150 lines, ~1 day)

Total T-5: **2-3 weeks single-thread** to retire RA-2 (Roth's theorem
research axiom).

## Workflow rule confirmed

Per LOCKED 2026-04-27:
- ✓ Mathlib upstream is NOT a blockade. We've ported what's needed.
- ✓ NO STUBS. Every sub-lemma has real content.
- ✓ Single-thread hand-authored. Opus 4.7 [1M context].
- ✓ Decomposable. T-5 is structurally analogous to T-4.

## Continuation

Cycle 65 entry: continue T-5 Phase 1 sub-lemmas 6-10, then Phase 2.
Each session ships 1-2 sub-lemmas, ~50-150 lines, Lean-core only.
