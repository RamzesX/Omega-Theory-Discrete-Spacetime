// SOTA T1.2 — Tactic-evidence proxy on Theorem nodes.
//
// Scans each Theorem.proof_body (the elaborated-term pretty-print) for symbols
// that betray which tactic produced the proof. NOT a full tactic syntax tree —
// the surface `by ...` block is gone after elaboration. But the elaborated term
// preserves call-graph evidence:
//
//   `linarith`     → `Mathlib.Tactic.Linarith.*`
//   `ring`         → `Mathlib.Tactic.Ring.*`
//   `norm_num`     → `Mathlib.Tactic.NormNum.*` / `Mathlib.Meta.NormNum.*`
//   `aesop`        → `Aesop.*`
//   `simp` / `rw`  → `Eq.mpr`
//   `rfl`          → `Eq.refl`
//   `decide`       → `Decidable.decide` / `Lean.ofReduceBool`
//   `cases`        → `.casesOn`
//   `congr`        → `congrArg`
//   `absurd`       → `absurd`
//   `intro` / λ    → proof_body STARTS WITH 'fun'
//
// Idempotent — overwrites `tactic_evidence` array on every run.
// Touches OmegaTheoryV2 + Mathlib Theorem nodes.
//
// Authority: ~/.claude/plans/binary-painting-dijkstra.md T1.2
// Use: feeds T4.2 `goal_to_premises` + T4.2 `tactic_continuation` MCP tools.
//
// Created: 2026-04-30 / 2026-05-01.

MATCH (t:Theorem)
WHERE t.proof_body IS NOT NULL
WITH t,
  // Each tag is null if not present, then we filter and collect
  [
    CASE WHEN t.proof_body CONTAINS 'Mathlib.Tactic.Linarith'    THEN 'linarith'   END,
    CASE WHEN t.proof_body CONTAINS 'Mathlib.Tactic.Ring'        THEN 'ring'       END,
    CASE WHEN t.proof_body CONTAINS 'Mathlib.Tactic.NormNum'
       OR t.proof_body CONTAINS 'Mathlib.Meta.NormNum'           THEN 'norm_num'   END,
    CASE WHEN t.proof_body CONTAINS 'Mathlib.Tactic.Positivity'  THEN 'positivity' END,
    CASE WHEN t.proof_body CONTAINS 'Mathlib.Tactic.Polyrith'    THEN 'polyrith'   END,
    CASE WHEN t.proof_body CONTAINS 'Mathlib.Tactic.GCongr'      THEN 'gcongr'     END,
    CASE WHEN t.proof_body CONTAINS 'Mathlib.Tactic.FunProp'     THEN 'fun_prop'   END,
    CASE WHEN t.proof_body CONTAINS 'Aesop.'                     THEN 'aesop'      END,
    CASE WHEN t.proof_body CONTAINS 'Decidable.decide'
       OR t.proof_body CONTAINS 'Lean.ofReduceBool'              THEN 'decide'     END,
    CASE WHEN t.proof_body CONTAINS 'Eq.mpr'                     THEN 'rw_or_simp' END,
    CASE WHEN t.proof_body CONTAINS 'Eq.refl'                    THEN 'rfl'        END,
    CASE WHEN t.proof_body CONTAINS 'congrArg'
       OR t.proof_body CONTAINS 'congrFun'                       THEN 'congr'      END,
    CASE WHEN t.proof_body CONTAINS 'absurd'                     THEN 'absurd'     END,
    CASE WHEN t.proof_body CONTAINS '.casesOn'                   THEN 'cases'      END,
    CASE WHEN t.proof_body CONTAINS 'And.intro'                  THEN 'and_intro'  END,
    CASE WHEN t.proof_body CONTAINS 'Or.inl'
       OR t.proof_body CONTAINS 'Or.inr'                         THEN 'or_intro'   END,
    CASE WHEN t.proof_body CONTAINS 'Iff.mpr'
       OR t.proof_body CONTAINS 'Iff.mp '                        THEN 'iff_apply'  END,
    CASE WHEN t.proof_body CONTAINS 'Exists.intro'               THEN 'exists_intro' END,
    CASE WHEN t.proof_body CONTAINS 'Nat.rec'
       OR t.proof_body CONTAINS 'Nat.brecOn'                     THEN 'nat_induct' END,
    CASE WHEN t.proof_body STARTS WITH 'fun'
       OR t.proof_body STARTS WITH 'λ'                            THEN 'lambda'     END,
    CASE WHEN t.proof_body CONTAINS 'have '                      THEN 'have'       END
  ] AS raw
SET t.tactic_evidence = [x IN raw WHERE x IS NOT NULL],
    t.tactic_evidence_set_at = datetime();
