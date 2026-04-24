#!/bin/bash
# /mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/scripts/fire_claude_loop.sh
#
# SOTA WSL-level cron fire script for OmegaTheory V2 cycle pipeline.
#
# Responsibilities:
#   1. Kill any OLD Claude session/wrapper (avoids double-counting tokens).
#   2. Kill any stray embedder/reranker from a prior Phase C that didn't clean up.
#   3. Fire a fresh claude-auto-retry session with the cycle-completion /loop prompt.
#   4. Log output for post-mortem.
#
# Called by WSL system cron (crontab -e):
#   7,37 * * * * /mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/scripts/fire_claude_loop.sh
#
# Prereqs:
#   - Node LTS installed (apt or nvm)
#   - `npm i -g claude-auto-retry` + `claude-auto-retry install` run once interactively
#   - `claude` CLI authenticated (run it interactively once to log in)

set -euo pipefail

# System cron has a minimal PATH — explicitly add what we need:
#   /home/norbert/.local/bin         → claude CLI (user-local install)
#   /home/norbert/.nvm/.../node/bin  → claude-auto-retry (nvm npm global)
#   /home/norbert/.elan/bin          → lake (Lean toolchain)
export PATH="/home/norbert/.local/bin:/home/norbert/.nvm/versions/node/v24.15.0/bin:/home/norbert/.elan/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

PROJECT_DIR=/mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers
LOG_DIR=/tmp/claude_loops
mkdir -p "$LOG_DIR"

NOW="$(date +%Y%m%d_%H%M)"
LOG="$LOG_DIR/loop_${NOW}.log"

echo "=== Claude loop fire at $NOW ===" > "$LOG"

# 1. GUARD: if an interactive claude session OR prior --print wrapper is running,
#    DEFER — do not fire this tick. Prevents:
#      (a) killing the user's live session (2026-04-24 ~18:07 regression)
#      (b) spawning a concurrent --print that double-bills or collides on state.
#    The next cron tick will retry in 30 min.
if pgrep -f "claude --resume" >/dev/null 2>&1 \
   || pgrep -f "claude-auto-retry --print" >/dev/null 2>&1 \
   || pgrep -f "claude --print" >/dev/null 2>&1; then
  echo "[defer] an active claude session is running; skipping this fire" >> "$LOG"
  exit 0
fi
echo "[no-active-session] safe to fire a fresh one" >> "$LOG"

# 2. Cooldown kill — stray embed/rerank servers from prior Phase C
echo "[kill] stray llama-server / supervise_llama" >> "$LOG"
pkill -f llama-server 2>/dev/null || true
pkill -f supervise_llama 2>/dev/null || true

sleep 3

# 3. Fire fresh claude-auto-retry wrapped loop
cd "$PROJECT_DIR"
PROMPT='/loop CYCLE-COMPLETION-LOOP cycle-50+ (30min safety-net, SELF-PACING, STRICT PHASE ORDERING, MEMORY-RECALL Step 0, see PhysicsPapers/CLAUDE.md §WORKFLOW PRINCIPLES for full protocol)'

echo "[fire] $PROMPT" >> "$LOG"

# Use claude-auto-retry if installed (handles rate-limit pauses transparently).
# Falls back to plain `claude --print` if wrapper missing.
if command -v claude-auto-retry >/dev/null 2>&1; then
  claude-auto-retry --print "$PROMPT" >> "$LOG" 2>&1 || true
else
  echo "[warn] claude-auto-retry not installed; falling back to bare claude" >> "$LOG"
  claude --print "$PROMPT" >> "$LOG" 2>&1 || true
fi

echo "=== Fire complete at $(date +%Y%m%d_%H%M) ===" >> "$LOG"

# 4. Rotate old logs (keep last 30)
find "$LOG_DIR" -name "loop_*.log" -mtime +7 -delete 2>/dev/null || true
