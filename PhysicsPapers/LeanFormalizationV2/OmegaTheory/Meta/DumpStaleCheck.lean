/-
  OmegaTheory.Meta.DumpStaleCheck

  **Wave P3l** (hand-written by session lead) — DumpArrows freshness-
  check sidecar metaprogram, closing Menkent Atlas v7 candidate
  `dump_arrows_freshness_stale_file_check_metaprogram` (LOW priority).

  ## Purpose

  The ingest pipeline (`dump_decls` + `dump_arrows`) only emits records
  for declarations that landed in the Lean environment.  If a `.lean`
  file exists on disk but is **not imported** (transitively) from
  `OmegaTheory.Basic` / `OmegaTheory`, its declarations are silently
  missing from the graph — a stale-orphan regression that's hard to
  notice without a cross-check.

  This program performs that cross-check:

    1. Walks `OmegaTheory/` recursively on disk, collecting every
       `.lean` file path.
    2. Maps each path → expected module name (e.g.
       `OmegaTheory/Predictions/Foo.lean` ↦ `OmegaTheory.Predictions.Foo`).
    3. Imports the `OmegaTheory` umbrella and reads
       `env.header.moduleNames` — the set of modules actually in the env.
    4. Emits one JSONL record per disk module NOT in the env, to the
       `--out` path (default stdout).  Each record has
       `{kind: "stale", file, expected_module, reason}`.
    5. Writes a summary line to stderr with counts.

  ## Usage

      lake exe dump_stale_check --out .neo4j/stale_modules.jsonl

  Fields: `kind = "stale"` (always for this program, future-proofed
  for other freshness kinds), `file` (relative path), `expected_module`
  (dotted name), `reason` (human-readable string).

  ## Exit codes

    0 — scan complete (regardless of finding stale files)
    1 — IO / parse error

  ## Scope

  * Only scans `OmegaTheory/` (we don't care about Mathlib freshness).
  * Module name inference is purely by path — it does NOT try to parse
    the file's `namespace` declarations.  This matches how Lake resolves
    module names, so false negatives are impossible; false positives
    (expected-module name ≠ actual namespace) only occur for files that
    contain `namespace Foo` differing from their path, which is a
    structural violation that would fail the build anyway.

  ## HARD RULES

    * 0 sorry, 0 new axioms
    * Non-load-bearing: a no-op on `dump_arrows` + `dump_decls`
      (stale files are orphaned = absent from env = nothing to produce
      anyway; this program makes that situation visible).
-/

import Lean

open Lean System IO IO.FS

namespace OmegaTheory.Meta.DumpStaleCheck

/-- Recursive walk: collect every path ending in `.lean` under `root`. -/
partial def walkLeanFiles (root : FilePath) : IO (Array FilePath) := do
  let mut out : Array FilePath := #[]
  if !(← root.pathExists) then return out
  if !(← root.isDir) then
    if root.extension == some "lean" then
      out := out.push root
    return out
  for entry in (← root.readDir) do
    let p := entry.path
    if ← p.isDir then
      let sub ← walkLeanFiles p
      out := out ++ sub
    else if p.extension == some "lean" then
      out := out.push p
  return out

/-- Turn a file path like `OmegaTheory/Predictions/Foo.lean`
    into the Lean module name `OmegaTheory.Predictions.Foo`.
    Returns `none` if the path is not under `cwd` or doesn't end in `.lean`. -/
def pathToModuleName (cwd : FilePath) (p : FilePath) : Option Name := Id.run do
  let ps := p.toString
  let cs := cwd.toString ++ "/"
  if !ps.startsWith cs then return none
  let rel := ps.drop cs.length
  if !rel.endsWith ".lean" then return none
  -- Strip trailing ".lean" (5 chars) and convert slice back to String.
  let strippedStr : String := (rel.dropRight 5).toString
  let parts := strippedStr.splitOn "/"
  let mut acc : Name := Name.anonymous
  for part in parts do
    acc := Name.mkStr acc part
  return some acc

/-- Escape a string for JSONL output (pragmatic; escapes `"` and `\`). -/
def jsonEscape (s : String) : String :=
  s.foldl (fun acc c =>
    if c == '"' then acc ++ "\\\""
    else if c == '\\' then acc ++ "\\\\"
    else if c == '\n' then acc ++ "\\n"
    else acc.push c) ""

/-- Render one stale-file record as a JSONL string. -/
def renderStaleRecord (file : String) (mod : Name) (reason : String) : String :=
  "{\"kind\":\"stale\"" ++
  ",\"file\":\"" ++ jsonEscape file ++ "\"" ++
  ",\"expected_module\":\"" ++ jsonEscape mod.toString ++ "\"" ++
  ",\"reason\":\"" ++ jsonEscape reason ++ "\"}"

/-- Parse `--out PATH` from args (very minimal). -/
def parseOut (args : List String) : Option String :=
  match args with
  | "--out" :: p :: _ => some p
  | _ :: rest         => parseOut rest
  | []                => none

/-- Main entry. -/
unsafe def main (args : List String) : IO UInt32 := do
  let outPath? := parseOut args
  IO.eprintln s!"[dump_stale_check] outPath = {outPath?}"
  -- Step 1: walk disk.
  let cwd ← IO.currentDir
  let scanRoot := cwd / "OmegaTheory"
  IO.eprintln s!"[dump_stale_check] scanning {scanRoot}"
  let diskFiles ← walkLeanFiles scanRoot
  IO.eprintln s!"[dump_stale_check] disk .lean files: {diskFiles.size}"
  -- Step 2: derive expected module names (path-based).
  let mut expected : Array (FilePath × Name) := #[]
  for f in diskFiles do
    match pathToModuleName cwd f with
    | some n => expected := expected.push (f, n)
    | none   => IO.eprintln s!"[dump_stale_check] WARN: cannot derive module name from {f}"
  IO.eprintln s!"[dump_stale_check] expected modules: {expected.size}"
  -- Step 3: load env, collect module names.
  initSearchPath (← findSysroot)
  Lean.enableInitializersExecution
  let env ← importModules #[{module := `OmegaTheory}] {} (trustLevel := 1024)
  let envModules : Std.HashSet Name :=
    env.header.moduleNames.foldl (fun s m => s.insert m) {}
  IO.eprintln s!"[dump_stale_check] env modules: {envModules.size}"
  -- Step 4: diff.  Stale = on disk but not in env.
  let handle? : Option FS.Handle ← match outPath? with
    | some p => some <$> FS.Handle.mk p FS.Mode.write
    | none   => pure none
  let writeLine : String → IO Unit := fun s => do
    match handle? with
    | some h => h.putStrLn s
    | none   => IO.println s
  let mut nStale : Nat := 0
  for (f, modName) in expected do
    if !envModules.contains modName then
      let relPath := f.toString
      let line := renderStaleRecord relPath modName
        "source file exists on disk but module is not reachable from OmegaTheory umbrella"
      writeLine line
      nStale := nStale + 1
  IO.eprintln s!"[dump_stale_check] stale (source-only, env-absent): {nStale}"
  match handle? with
  | some _ => IO.eprintln s!"[dump_stale_check] output written to file"
  | none   => pure ()
  return 0

end OmegaTheory.Meta.DumpStaleCheck

/-- Toplevel entry point for `lake exe dump_stale_check`. -/
unsafe def main (args : List String) : IO UInt32 :=
  OmegaTheory.Meta.DumpStaleCheck.main args
