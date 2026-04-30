# T7 — Agents v4

**Status**: TODO Day 11-12 | **Effort**: 1 day, 3 agent files

## T7.1 — `prove-wizard-fast.md` (~300 lines XML)

Slim variant of v3 for Tier-99 / Tier-80 obligations.

Trigger: `tier == "99"` OR explicit `/prove-fast`.

Skip phases: A.0 NL sketch, A statement, B truth-rank, D bottom-up, E review.
Run only: automation cascade (`exact?` → `aesop` → `grind` → `linarith` → `omega`) + verify GREEN.

Saves ~60% time on routine.

## T7.2 — `irrationality-hunter-v2.md` (~700 lines XML)

Specialized for π/e/√2/Catalan G research + HD axiom port.

Pantheon emphasis: Niven, Apéry, Hermite, Lindemann-Weierstrass, Nesterenko, Mahler, Rivoal-Zudilin, Brun, Beukers.

MCP cascade upgraded: T2 goal-embedding → T4.2 `goal_to_premises` → T4.1 `propose_conjecture` → T3 hybrid retrieval.

Use cases:
- T-5 Hi-Glue (HS §D.6.1 inner heart)
- HD axiom port (Nesterenko_1996 → unconditional)
- π/e/√2/G transcendence successors

## T7.3 — `grothendieck-sage-v2.md` (update existing)

Add T4 MCP tools to toolbox. Update for 5-PHASE HYBRID + frontier V2.
Maintain role separation: sage proposes `.md` only, never edits `.lean`.

## Files

- NEW `chaos-shield/PhysicsPapers/LeanFormalizationV2/.claude/agents/prove-wizard-fast.md`
- NEW `chaos-shield/PhysicsPapers/LeanFormalizationV2/.claude/agents/irrationality-hunter-v2.md`
- EDIT `chaos-shield/PhysicsPapers/LeanFormalizationV2/.claude/agents/grothendieck-sage.md` → v2

## Verification

Each agent file dispatches successfully via Agent tool with subagent_type=<name>.
