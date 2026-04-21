# chaos-shield — repo-level developer targets.
#
# Most work happens in subtrees with their own build systems:
#   * Lean 4    — `cd PhysicsPapers/LeanFormalizationV2 && lake build`
#   * Astro     — `cd site && npm run build`
#   * Neo4j     — see PhysicsPapers/LeanFormalizationV2/.neo4j/CLAUDE.md
#
# This Makefile covers cross-cutting repo maintenance tasks only.

.PHONY: help check-links

help:
	@echo "chaos-shield — repo maintenance targets"
	@echo "  make check-links   Validate all relative .md links across the repo"
	@echo "                     (fails if any target is missing)"

check-links:
	@python3 scripts/check_links.py --root . --verbose
