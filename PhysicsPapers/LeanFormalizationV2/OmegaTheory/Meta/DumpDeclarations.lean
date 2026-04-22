/-
Copyright (c) 2026 Schedar (α Cassiopeiae). Released under Apache 2.0.
Author: Schedar, v1 — 2026-04-19.

# `lake exe dump_decls` — ground-truth declaration metadata from Lean 4 env

Replaces the regex-based `~/lean-v2/.neo4j/extractors/catalogue_scan.py` which
has known limitations:
  * multi-line signatures get truncated at the first newline
  * docstrings parsed by heuristic (misses nested `/-- ... -/` bodies)
  * source spans are line-offsets, not the real `DeclarationRange`
  * proof bodies are raw *source text*, not *elaborated* terms

The environment after a successful build IS the ground truth. We iterate
`Environment.constants`, pretty-print every `ConstantInfo.type` and `value?`
via `Meta.ppExpr`, look up docstrings via `findDocString?`, and extract
positions via `findDeclarationRangesCore?`. Module → file path comes from
`SearchPath.findWithExt` on the module name reported by `getModuleIdxFor?`.

Sibling file: `DumpArrows.lean` (Sheratan) — same iteration, different
payload. We DO NOT share helpers to keep the two files independently
reviewable; the JSON schemas are disjoint.

## Fields per record (JSON Lines, one object per line)

* `name`              — fully-qualified Lean name
* `kind`              — `theorem | def | axiom | instance | inductive | structure | opaque | ctor | quot | other`
* `type_pretty`       — elaborated type, pretty-printed (string)
* `value_pretty`      — elaborated value / proof body (optional string)
* `docstring`         — docstring (optional string)
* `file`              — absolute filesystem path to the source `.lean` file
* `module`            — fully-qualified module name (e.g. `OmegaTheory.Basic`)
* `line_start`        — 1-indexed
* `line_end`
* `col_start`
* `col_end`
* `is_private`
* `universe_params`   — list of universe parameter names
* `num_universe_params`

## CLI

```
lake exe dump_decls                    # dump to stdout, OmegaTheory.* only
lake exe dump_decls --out FILE         # write to FILE
lake exe dump_decls --include-mathlib  # also emit Mathlib.* records
```
-/

import OmegaTheory
import Lean

open Lean Elab Meta System IO IO.FS

namespace OmegaTheory.Meta.DumpDeclarations

/-- JSON string escape (RFC 8259 minimal). -/
def jsonEscape (s : String) : String := Id.run do
  let mut out := ""
  for c in s.toList do
    match c with
    | '"'  => out := out ++ "\\\""
    | '\\' => out := out ++ "\\\\"
    | '\n' => out := out ++ "\\n"
    | '\r' => out := out ++ "\\r"
    | '\t' => out := out ++ "\\t"
    | c    =>
      if c.toNat < 0x20 then
        out := out ++ s!"\\u{(String.ofList (Nat.toDigits 16 c.toNat)).leftpad 4 '0'}"
      else
        out := out.push c
  return out

def jstr (s : String) : String := "\"" ++ jsonEscape s ++ "\""
def jopt : Option String → String
  | none   => "null"
  | some s => jstr s

def jarr (xs : Array String) : String :=
  "[" ++ String.intercalate "," (xs.toList.map jstr) ++ "]"

def jnat (n : Nat) : String := toString n

def jbool : Bool → String
  | true  => "true"
  | false => "false"

/-- Kind tag for the record. Keeps compatibility with the Neo4j `kind`
property that the arrow dumper also emits (but with wider vocabulary). -/
def kindOf : ConstantInfo → String
  | .axiomInfo _    => "axiom"
  | .defnInfo  _    => "def"
  | .thmInfo   _    => "theorem"
  | .opaqueInfo _   => "opaque"
  | .quotInfo  _    => "quot"
  | .inductInfo _   => "inductive"
  | .ctorInfo  _    => "ctor"
  | .recInfo   _    => "rec"

/-- Refine `kind` for `defnInfo` by checking if the environment marks the
name as a structure or instance. We return a more specific tag for UX. -/
def refinedKind (env : Environment) (name : Name) (ci : ConstantInfo) : String :=
  let base := kindOf ci
  match ci with
  | .defnInfo _ =>
    if Lean.isStructure env name then "structure"
    else if Lean.Meta.isInstanceCore env name then "instance"
    else base
  | _ => base

/-- Namespace filter. -/
def inNamespace (includeMathlib : Bool) (n : Name) : Bool :=
  let s := n.toString
  s.startsWith "OmegaTheory." || s == "OmegaTheory" ||
    (includeMathlib && (s.startsWith "Mathlib." || s == "Mathlib"))

/-- Is this a user-facing declaration (skip compiler aux)?
We skip the same classes Sheratan's arrow dumper skips, for symmetry. -/
def isUserFacing (n : Name) : Bool :=
  let s := n.toString
  -- Fast positive path: no suspicious markers anywhere.
  if s.contains '«' then true
  else
    let hasFragment (needle : String) : Bool :=
      (s.splitOn needle).length > 1
    let blocked :=
      hasFragment "._hyg." ||
      hasFragment "._proof_" ||
      hasFragment "._cstage" ||
      hasFragment "._eq_" ||
      hasFragment "._sunfold" ||
      s.endsWith ".match_1" ||
      s.endsWith ".match_2" ||
      s.endsWith ".match_3" ||
      s.endsWith ".brecOn" ||
      s.endsWith ".below" ||
      s.endsWith ".ibelow" ||
      s.endsWith ".rec" ||
      s.endsWith ".recOn" ||
      s.endsWith ".noConfusion" ||
      s.endsWith ".noConfusionType" ||
      s.endsWith ".sizeOf_spec" ||
      s.endsWith ".injEq" ||
      s.endsWith ".eq_def" ||
      s.endsWith ".mk.injEq"
    !blocked

/-- Pretty-print an `Expr` in a minimal Meta context. Returns `none` on any
pretty-printing failure (we never want a crash to kill the whole dump). -/
def safePP (env : Environment) (e : Expr) : IO (Option String) := do
  try
    let coreCtx : Core.Context := {
      fileName := "<dump_decls>",
      fileMap  := default
    }
    let coreState : Core.State := { env }
    let (fmt, _, _) ← (PrettyPrinter.ppExpr e).toIO coreCtx coreState
    return some fmt.pretty
  catch _ =>
    return none

/-- Look up module name for a declaration. -/
def moduleOf (env : Environment) (name : Name) : Option Name :=
  match env.getModuleIdxFor? name with
  | some idx => env.allImportedModuleNames[idx.toNat]?
  | none     =>
    -- Fall back to the current main module if not imported (main-build names).
    some env.mainModule

/-- Resolve a module name to an absolute filesystem `.lean` path via
`SearchPath`. Returns `""` if nothing matches. Uses `Lean.SearchPath.findWithExt`
(the disambiguating namespace; `System.SearchPath` alone resolves to `List FilePath`
which has no such method). -/
def moduleToFile (sp : Lean.SearchPath) (mod : Name) : IO String := do
  match ← Lean.SearchPath.findWithExt sp "lean" mod with
  | some p => pure p.toString
  | none   => pure ""

/-- Find source position tuple `(line_start, line_end, col_start, col_end)`.
Returns `(0,0,0,0)` if the declaration was imported from an `.olean` that
didn't export ranges (builtin / core decls). -/
def positionsOf (env : Environment) (name : Name) : (Nat × Nat × Nat × Nat) :=
  -- `findDeclarationRangesCore?` runs in CoreM; we simulate that by reading
  -- the extension state directly via `Environment.find?`-equivalent.
  match Lean.declRangeExt.find? (level := .exported) env name with
  | some r =>
    ( r.range.pos.line, r.range.endPos.line
    , r.range.pos.column, r.range.endPos.column )
  | none =>
    match Lean.declRangeExt.find? (level := .server) env name with
    | some r =>
      ( r.range.pos.line, r.range.endPos.line
      , r.range.pos.column, r.range.endPos.column )
    | none => (0, 0, 0, 0)

/-- Build one JSONL record for a declaration. -/
def renderRecord (env : Environment) (sp : Lean.SearchPath) (name : Name)
    (ci : ConstantInfo) : IO String := do
  let kind := refinedKind env name ci
  let typePP? ← safePP env ci.type
  let valuePP? ← match ci.value? (allowOpaque := true) with
    | some e => safePP env e
    | none   => pure none
  let docstring? ← Lean.findDocString? env name
  let (ls, le, cs, ce) := positionsOf env name
  let modName? := moduleOf env name
  let moduleStr := modName?.map (·.toString) |>.getD ""
  let fileStr : String ← match modName? with
    | some m => moduleToFile sp m
    | none   => pure ""
  let isPriv := Lean.isPrivateName name
  let universeParams : Array String := (ci.levelParams.map (·.toString)).toArray
  let numU := ci.numLevelParams
  let fields : List String :=
    [ "\"name\":"                 ++ jstr name.toString
    , "\"kind\":"                 ++ jstr kind
    , "\"type_pretty\":"          ++ jopt typePP?
    , "\"value_pretty\":"         ++ jopt valuePP?
    , "\"docstring\":"            ++ jopt docstring?
    , "\"file\":"                 ++ jstr fileStr
    , "\"module\":"               ++ jstr moduleStr
    , "\"line_start\":"           ++ jnat ls
    , "\"line_end\":"             ++ jnat le
    , "\"col_start\":"            ++ jnat cs
    , "\"col_end\":"              ++ jnat ce
    , "\"is_private\":"           ++ jbool isPriv
    , "\"universe_params\":"      ++ jarr universeParams
    , "\"num_universe_params\":"  ++ jnat numU
    ]
  return "{" ++ String.intercalate "," fields ++ "}"

/-- Parse a bare CLI args list. -/
def parseArgs (args : List String) : Option String × Bool := Id.run do
  let mut out : Option String := none
  let mut inclMath := false
  let mut xs := args
  while !xs.isEmpty do
    match xs with
    | "--out" :: v :: rest     => out := some v; xs := rest
    | "--include-mathlib" :: r => inclMath := true; xs := r
    | _ :: rest                => xs := rest
    | []                       => xs := []
  return (out, inclMath)

/-- Main entry point. -/
unsafe def main (args : List String) : IO UInt32 := do
  let (outPath?, includeMathlib) := parseArgs args
  IO.eprintln s!"[dump_decls] includeMathlib = {includeMathlib}"
  IO.eprintln s!"[dump_decls] outPath = {outPath?}"
  -- Initialize search paths (for `findWithExt "lean"`) and interpreter.
  initSearchPath (← findSysroot)
  Lean.enableInitializersExecution
  -- Augment search path with project root + Mathlib source so `.lean` files
  -- can be located. `initSearchPath` only loads `.olean` search roots.
  let extraRoots : List System.FilePath := [
    "/home/norbert/lean-v2",
    "/home/norbert/lean-v2/.lake/packages/mathlib",
    "/home/norbert/lean-v2/.lake/packages/batteries",
    "/home/norbert/lean-v2/.lake/packages/aesop",
    "/home/norbert/lean-v2/.lake/packages/Qq",
    "/home/norbert/lean-v2/.lake/packages/importGraph",
    "/home/norbert/lean-v2/.lake/packages/proofwidgets",
    "/home/norbert/lean-v2/.lake/packages/LeanSearchClient",
    "/home/norbert/lean-v2/.lake/packages/plausible"
  ]
  let existingSp ← searchPathRef.get
  let sp : Lean.SearchPath := extraRoots ++ existingSp
  -- Load OmegaTheory (pulls Mathlib transitively via its imports).
  let rootModule : Name := `OmegaTheory
  let env ← importModules #[{module := rootModule}] {} (trustLevel := 1024)
  -- Writer setup.
  let handle? : Option FS.Handle ← match outPath? with
    | some p => some <$> FS.Handle.mk p FS.Mode.write
    | none   => pure none
  let write (s : String) : IO Unit := do
    match handle? with
    | some h => h.putStrLn s
    | none   => IO.println s
  let mut totalSeen := 0
  let mut totalKept := 0
  for (name, ci) in env.constants.toList do
    totalSeen := totalSeen + 1
    if !inNamespace includeMathlib name then continue
    if !isUserFacing name then continue
    try
      let rec ← renderRecord env sp name ci
      write rec
      totalKept := totalKept + 1
    catch e =>
      IO.eprintln s!"[dump_decls] error on {name}: {e.toString}"
  IO.eprintln s!"[dump_decls] total declarations seen: {totalSeen}"
  IO.eprintln s!"[dump_decls] records written:         {totalKept}"
  return 0

end OmegaTheory.Meta.DumpDeclarations

/-- Toplevel `main` so `lake exe dump_decls` finds it. -/
unsafe def main (args : List String) : IO UInt32 :=
  OmegaTheory.Meta.DumpDeclarations.main args
