# Setup — Tools for the π K₂-Opacity Attack Project

**Platform**: Windows 11 + WSL2 (Ubuntu 24.04.3 LTS). All commands from Windows bash run in WSL via `wsl.exe bash -c "…"`.

This document describes the **free** toolchain that covers ~90% of what a Mathematica license would give us, plus the Lean 4 + Mathlib setup for formal verification of the barrier theorems.

---

## 0. Already installed (verified 2026-04-14)

| Tool | Version | Role in project |
|---|---|---|
| **Python 3.12** | 3.12.3 | Driver language for all numerical attacks |
| **sympy** | 1.14.0 | Exact rational arithmetic; kernel/nullspace over ℚ (Targets A, B, E used this) |
| **mpmath** | 1.3.0 | Arbitrary-precision floats; built-in PSLQ via `mpmath.pslq` |
| **elan / Lean 4** | 4.29.1 | Formal proof assistant (the "solid rock" layer) |
| **lake** | shipped with Lean | Build tool for Lean 4 projects |
| **Mathlib** | v4.29.0 | Already downloaded + cached in `PhysicsPapers/LeanFormalizationV2/` |
| **Neo4j MCP** | active | Stores `pi_sun` namespace: attack vectors, facts, gaps, barriers, computational results |

Python scripts already using this stack: `sage/target_a_hermite_pade.py`, `sage/target_b_asymptotic.py`, `sage/target_e_padic.py`.

---

## 1. Recommended additions — free tools

### 1.1 PARI/GP — number theory specialist (~15 MB, 2 min)

Gold-standard tool for computational number theory. Built-in `lindep`, `algdep`, `bestappr`, fast p-adic arithmetic, modular forms. Henri Cohen's toolkit, peer-reviewed since 1985.

```bash
wsl.exe bash -c "sudo apt update && sudo apt install -y pari-gp"
```

Verify:

```bash
wsl.exe bash -c "echo 'print(algdep(Pi, 5));' | gp -q"
# expected: 0 (no algebraic relation of degree ≤ 5 for π within default precision)
```

**Why we need it**: the PSLQ falsifiability test for Conjecture 4A.4 is cleaner in PARI than in mpmath. Command pattern:

```gp
\\ look for integer relation among 1, π, π², u, v, πu, πv
lindep([1, Pi, Pi^2, u, v, Pi*u, Pi*v])
```

### 1.2 python-flint (Arb) — rigorous intervals (~40 MB, 5 min)

Turns our numerical estimates into **proven bounds**. Arb uses ball arithmetic — every value carries a certified error radius.

```bash
wsl.exe bash -c "pip3 install --user --break-system-packages python-flint"
```

Verify:

```bash
wsl.exe bash -c "python3 -c 'from flint import arb; x = arb.pi(); print(x, x.mid(), x.rad())'"
```

**Why we need it**: Target B reports "|L_n| ≈ 4.9e-74". With python-flint we can report "|L_n| ∈ [4.87e-74, 4.89e-74], **proven**". That lifts numerics to the level of formal-proof-grade evidence.

### 1.3 SageMath — full-featured CAS (~1.8 GB, 15 min)

Our `.sage` script variants already target it. SageMath bundles PARI, FLINT, GAP, Maxima, NumPy under one roof — strongest single tool after Mathematica.

```bash
wsl.exe bash -c "sudo apt install -y sagemath sagemath-jupyter"
```

Verify:

```bash
wsl.exe bash -c "sage -c 'print(hypergeometric([1/2], [3/2], 1/2).n(50))'"
```

**Why we need it**:
- `PadeApproximant` as a direct call
- `algdep`, `lindep` inherited from PARI
- `hypergeometric(...)` with symbolic `FullSimplify`-equivalent
- Modular forms library (for Nesterenko-style μ(π) work)
- Our existing `target_a_hermite_pade.sage` etc. will run as-is

**Note**: `apt install sagemath` is large (~1.8 GB download + ~4 GB installed). Skip this if disk is tight; PARI + python-flint cover most computational needs without Sage.

### 1.4 Time/size budget summary

| Tool | Size | Install time | Priority |
|---|---|---|---|
| PARI/GP | ~15 MB | 2 min | **Essential** — cheapest, biggest immediate win |
| python-flint | ~40 MB | 5 min | **Essential** — needed for rigorous bounds |
| SageMath | ~1.8 GB | 15 min | **Optional** — only if disk allows and we want richer CAS |

**Minimum viable install: PARI + python-flint, ~7 minutes total.**

---

## 2. Lean 4 + Mathlib — the "solid rock" layer

### 2.1 Current state

Lean 4.29.1 and Mathlib v4.29.0 are already installed and cached in `PhysicsPapers/LeanFormalizationV2/`. We will add the π project as a sister directory inside that Lake workspace.

### 2.2 Rebuild / verify

```bash
wsl.exe bash -c "cd /mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/LeanFormalizationV2 && ~/.elan/bin/lake exe cache get 2>&1 | tail -3"
```

If the above reports "already downloaded" / "up to date", Mathlib is ready.

### 2.3 Add the π formalization module

Create directory:

```bash
wsl.exe bash -c "mkdir -p /mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/LeanFormalizationV2/OmegaTheory/Irrationality/HermitePade"
```

Planned file layout (Session 7+):

```
OmegaTheory/Irrationality/HermitePade/
├── Basic.lean            -- Pochhammer, Taylor coefs, Padé matrix
├── F49_Existence.lean    -- rank-nullity: kernel dim = 1
├── F50_Decay.lean        -- |L_n| ≤ C·|z₀|^{3n+2}/(3n)!  (adapts existing e_error_bound)
├── F53_PiStratum.lean    -- Σ aₖπᵏ = 0 ⇒ aₖ = 0 (uses pi_transcendental axiom)
├── Decoupling.lean       -- Theorem 4C.3 — the central barrier, ~50 lines
├── TargetA_Verified.lean -- per-n verification for n = 1..6 via `decide`
└── GapF_Statement.lean   -- revised GAP_F statement with explicit `sorry`
```

Each file stands alone; build incrementally with `lake build OmegaTheory.Irrationality.HermitePade.Decoupling` etc.

### 2.4 Build workflow (always WSL, never PowerShell)

```bash
# Incremental build
wsl.exe bash -c "cd /mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/LeanFormalizationV2 && ~/.elan/bin/lake build --log-level=error 2>&1"

# Clean rebuild (rare; only when toolchain changes)
wsl.exe bash -c "cd /mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/LeanFormalizationV2 && ~/.elan/bin/lake clean && ~/.elan/bin/lake exe cache get && ~/.elan/bin/lake build"
```

### 2.5 Lean LSP MCP (for Claude Code integration)

**Current status**: the existing `lean_loogle`, `lean_leansearch`, `lean_local_search`, `lean_diagnostic_messages`, `lean_build` MCP tools have **Windows/WSL path-translation issues** (documented in `CLAUDE.md`). Until fixed, the reliable workflow for Claude Code is:

1. **Edit `.lean` files** via the Edit/Write tools (Windows paths).
2. **Build via `wsl.exe bash`** using the commands in §2.4.
3. **Read errors from `lake build` output** in the bash response.
4. **Search Mathlib** via `lean_loogle` / `lean_leansearch` MCP tools — these work fine since they hit remote servers, not local filesystem.

### 2.6 Fixing the Lean MCP path issue (optional, one-time)

The `lean-lsp-mcp` server expects Unix paths. If we run it from WSL (with `wslpath` conversion wrapper), it will work. Install steps:

```bash
# In WSL
wsl.exe bash -c "npm install -g lean-lsp-mcp"
```

Then in `~/.config/claude-code/mcp.json` (Claude Code settings), add:

```json
{
  "mcpServers": {
    "lean-lsp": {
      "command": "wsl.exe",
      "args": ["bash", "-c", "cd $(wslpath '$CLAUDE_CWD') && lean-lsp-mcp"],
      "env": {}
    }
  }
}
```

(Exact config depends on the MCP server's CLI; check `lean-lsp-mcp --help`.)

**If this is too fiddly**, stick with §2.5's workflow — bash + MCP `lean_loogle`/`lean_leansearch` gets 95% of the value.

---

## 3. Installation summary — one-shot command

Minimum viable + Lean ready:

```bash
wsl.exe bash -c "sudo apt update && sudo apt install -y pari-gp && pip3 install --user --break-system-packages python-flint && cd /mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/LeanFormalizationV2 && ~/.elan/bin/lake exe cache get && echo '=== READY ==='"
```

Total: ~7 minutes, ~55 MB disk. After this command succeeds, every attack described in `ROADMAP.md` has the tools it needs.

**Full install** (adds SageMath, ~1.8 GB more, ~15 min):

```bash
wsl.exe bash -c "sudo apt install -y sagemath sagemath-jupyter"
```

---

## 4. Verification checklist

After install, run:

```bash
wsl.exe bash -c "
echo '=== Python stack ==='
python3 -c 'import sympy, mpmath, flint; print(f\"sympy {sympy.__version__}, mpmath {mpmath.__version__}, flint {flint.__version__}\")'

echo '=== PARI/GP ==='
gp --version | head -1
echo 'print(1 + Pi);' | gp -q

echo '=== Lean ==='
~/.elan/bin/lean --version

echo '=== Mathlib cache ==='
cd /mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/LeanFormalizationV2
~/.elan/bin/lake exe cache get --fail-if-error 2>&1 | tail -3

echo '=== Existing pi-project scripts ==='
cd /mnt/c/Users/Norbert/IdeaProjects/chaos-shield/LevelOfIrratotionalityOfPi/sage
python3 target_a_hermite_pade.py > /dev/null && echo 'target_a_hermite_pade.py: OK'
"
```

If every block reports successfully, the platform is ready for Sessions 7+.

---

## 5. Troubleshooting

**Lean `lake build` stalls or downloads from scratch**: run `~/.elan/bin/lake exe cache get` first. This pulls precompiled Mathlib `.olean` files instead of compiling from source (saves hours).

**`pip3 install` refuses with PEP 668 error**: add `--break-system-packages` (we already did for sympy/mpmath; safe for user-scope on WSL).

**`apt install sagemath` fails with "Unable to locate package"**: `sudo add-apt-repository universe && sudo apt update`. Some Ubuntu minimal images strip the universe repo.

**WSL path issues in scripts**: always use `/mnt/c/Users/Norbert/…` forward-slash paths. Never Windows `C:\Users\…` paths inside WSL commands.

---

## 6. What this setup does NOT include (and why)

- **Mathematica / Wolfram** — commercial, $376+ for personal (non-research), $2,400+ for commercial. Not justified for this project given free alternatives cover 90%.
- **Maple** — similar commercial situation.
- **MATLAB** — not relevant to number theory.
- **GAP** — would help for discrete Galois computations but we don't need it for Attack 19.

If a future session genuinely blocks on a Mathematica-only capability, we'll note it in `ROADMAP.md` as a conditional investment.

---

## References

- [PARI/GP official](https://pari.math.u-bordeaux.fr/)
- [python-flint docs](https://fredrikj.net/python-flint/)
- [SageMath](https://www.sagemath.org/)
- [Lean 4 + Mathlib](https://leanprover-community.github.io/)
- [mpmath PSLQ](https://mpmath.org/doc/current/identification.html)
