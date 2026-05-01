/-
Copyright (c) 2026 Algol (β Persei). Released under Apache 2.0.
Author: Algol, v1 — 2026-05-01.

# `lake exe dump_proof_steps` — FULL T1.3 with REAL elaborated goal-state capture

Replaces the LITE `T1_3_proof_steps_lite.cypher` migration (which approximated
`goal_pseudo` from `tactic_evidence` arrays). This dumper RE-ELABORATES each
OmegaTheory `.lean` source file via `Lean.Elab.IO.processCommands` with InfoTree
capture enabled, then walks `commandState.infoState.trees` to extract every
`TacticInfo` node — yielding the REAL goal-state strings before/after each
tactic, exactly as Lean's interactive mode would show.

## Per-step record (JSONL)

* `parent_thm`     — fully-qualified theorem name
* `step_idx`       — 0..N-1 position in tactic sequence
* `tactic`         — pretty-printed tactic syntax (`linarith [h]`, etc.)
* `tactic_kind`    — head node SyntaxNodeKind (debug)
* `goal_before`    — pretty-printed goal before this tactic fires
* `goal_after`     — pretty-printed goal after (may be `"no goals"`)
* `n_goals_before` / `n_goals_after`
* `file`, `line`, `col`

## CLI

```
lake exe dump_proof_steps                        # ALL OV2 files (slow)
lake exe dump_proof_steps --out FILE             # write to FILE
lake exe dump_proof_steps --file PATH            # single file (test)
lake exe dump_proof_steps --root DIR             # custom root
lake exe dump_proof_steps --limit N              # cap at N files (smoke test)
```
-/

import OmegaTheory
import Lean

open Lean Elab Meta System IO IO.FS

namespace OmegaTheory.Meta.DumpProofSteps

/-! ### JSON primitives -/

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
      if c.toNat < 0x20 then out := out ++ "?"
      else out := out.push c
  return out

def jstr (s : String) : String := "\"" ++ jsonEscape s ++ "\""
def jnat (n : Nat) : String := toString n

/-! ### Per-step record -/

structure StepRecord where
  parentThm : Name
  stepIdx : Nat
  tacticStr : String
  tacticKind : String
  goalBefore : String
  goalAfter : String
  nGoalsBefore : Nat
  nGoalsAfter : Nat
  file : String
  line : Nat
  col : Nat

def renderStep (sr : StepRecord) : String :=
  let fields : List String :=
    [ "\"parent_thm\":"     ++ jstr sr.parentThm.toString
    , "\"step_idx\":"       ++ jnat sr.stepIdx
    , "\"tactic\":"         ++ jstr sr.tacticStr
    , "\"tactic_kind\":"    ++ jstr sr.tacticKind
    , "\"goal_before\":"    ++ jstr sr.goalBefore
    , "\"goal_after\":"     ++ jstr sr.goalAfter
    , "\"n_goals_before\":" ++ jnat sr.nGoalsBefore
    , "\"n_goals_after\":"  ++ jnat sr.nGoalsAfter
    , "\"file\":"           ++ jstr sr.file
    , "\"line\":"           ++ jnat sr.line
    , "\"col\":"            ++ jnat sr.col
    ]
  "{" ++ String.intercalate "," fields ++ "}"

/-! ### Parent-theorem attribution -/

/-- Extract the declaration name from a top-level command syntax. -/
def extractDeclName? (stx : Syntax) : Option Name :=
  if stx.isOfKind ``Lean.Parser.Command.declaration then
    let inner := stx[1]
    let declId := inner[1]
    let nameStx := declId[0]
    if nameStx.isIdent then some nameStx.getId else none
  else
    none

/-- Should we skip this tactic-info kind (combinator wrappers, not leaf tactics)? -/
def isCombinatorKind (k : SyntaxNodeKind) : Bool :=
  let s := k.toString
  s == "Lean.Parser.Tactic.tacticSeq"
    || s == "Lean.Parser.Tactic.tacticSeq1Indented"
    || s == "Lean.Parser.Tactic.tacticSeqBracketed"
    || s == "Lean.Parser.Term.byTactic"
    || s == "Lean.Parser.Term.byTactic'"
    || s == "null"

/-! ### State for the InfoTree walk -/

structure WalkState where
  records : Array StepRecord := #[]
  stepCtr : Std.HashMap Name Nat := {}
  parents : Array Name := #[]
  filePath : String := ""

/-- Pretty-print a tactic syntax via `PrettyPrinter.ppTactic` inside `ctx`. -/
def ppTacticIn (ctx : ContextInfo) (stx : Syntax) : IO String := do
  try
    let fmt ← ctx.runMetaM {} (PrettyPrinter.ppTactic ⟨stx⟩)
    return fmt.pretty
  catch _ =>
    return toString stx

/-- Format a list of MVarIds via `ContextInfo.ppGoals`. -/
def ppGoalsIn (ctx : ContextInfo) (goals : List MVarId) : IO String := do
  if goals.isEmpty then return "no goals"
  try
    let fmt ← ctx.ppGoals goals
    return fmt.pretty
  catch e =>
    return s!"<pp error: {e.toString}>"

/-- Process one `TacticInfo`. Mutates the IO.Ref-held state. -/
def processTactic (stRef : IO.Ref WalkState) (ctx : ContextInfo) (ti : TacticInfo) : IO Unit := do
  if isCombinatorKind ti.stx.getKind then return
  if !ti.stx.getRange?.isSome then return
  let st ← stRef.get
  match st.parents.back? with
  | none => return
  | some parent => do
    let goalBefore ← ppGoalsIn ctx ti.goalsBefore
    let goalAfter  ← ppGoalsIn ctx ti.goalsAfter
    let tacticStr ← ppTacticIn ctx ti.stx
    let (line, col) := match ti.stx.getRange? with
      | some r =>
        let pos := ctx.fileMap.toPosition r.start
        (pos.line, pos.column)
      | none => (0, 0)
    let stepIdx := st.stepCtr.getD parent 0
    let rec_ : StepRecord := {
      parentThm := parent
      stepIdx
      tacticStr
      tacticKind := ti.stx.getKind.toString
      goalBefore
      goalAfter
      nGoalsBefore := ti.goalsBefore.length
      nGoalsAfter := ti.goalsAfter.length
      file := st.filePath
      line
      col
    }
    stRef.modify fun s =>
      { s with records := s.records.push rec_, stepCtr := s.stepCtr.insert parent (stepIdx + 1) }

/-- Walk one InfoTree, pushing/popping parent names and emitting tactic records.
    Qualifies bare decl names with the `currNamespace` from the command context
    so parent_thm matches the fully-qualified Theorem nodes in Neo4j. -/
def walkOneTree (stRef : IO.Ref WalkState) (tree : InfoTree) : IO Unit := do
  tree.visitM'
    (preNode := fun ctx info _ => do
      match info with
      | .ofCommandInfo ci =>
        if let some bareName := extractDeclName? ci.stx then
          let ns := ctx.toCommandContextInfo.currNamespace
          let qualified := if ns.isAnonymous then bareName else ns ++ bareName
          stRef.modify fun s => { s with parents := s.parents.push qualified }
      | .ofTacticInfo ti => processTactic stRef ctx ti
      | _ => pure ()
      return true)
    (postNode := fun _ info _ => do
      match info with
      | .ofCommandInfo ci =>
        if extractDeclName? ci.stx |>.isSome then
          stRef.modify fun s =>
            if s.parents.isEmpty then s
            else { s with parents := s.parents.pop }
      | _ => pure ())

/-! ### Per-file driver -/

/-- Process one source file: parse → elaborate with InfoTree → walk records. -/
def processFile (filePath : String) : IO (Array String) := do
  IO.eprintln s!"[dump_proof_steps] processing: {filePath}"
  let content ← FS.readFile filePath
  let inputCtx := Parser.mkInputContext content filePath
  let (header, parserState, msgs) ← Parser.parseHeader inputCtx
  let opts : Options := Options.empty
  let (env, msgs) ← processHeader header opts msgs inputCtx
  let env := env.setMainModule `_dump_proof_steps_one_file
  let cmdState := Command.mkState env msgs opts
  let cmdState := { cmdState with infoState.enabled := true }
  let s ← Lean.Elab.IO.processCommands inputCtx parserState cmdState
  let trees := s.commandState.infoState.trees.toArray
  let stRef ← IO.mkRef ({ filePath := filePath } : WalkState)
  for tree in trees do
    walkOneTree stRef tree
  let st ← stRef.get
  let lines := st.records.map renderStep
  IO.eprintln s!"[dump_proof_steps]   captured {lines.size} tactic steps"
  return lines

/-! ### File enumeration -/

partial def listLeanFiles (root : System.FilePath) : IO (Array System.FilePath) := do
  let mut out : Array System.FilePath := #[]
  if !(← root.pathExists) then return out
  let entries ← root.readDir
  for entry in entries do
    let p := entry.path
    if (← p.isDir) then
      let nested ← listLeanFiles p
      out := out ++ nested
    else if p.toString.endsWith ".lean" then
      out := out.push p
  return out

/-! ### CLI -/

structure CliOpts where
  outPath : Option String := none
  filePath : Option String := none
  rootDir : String := "/home/norbert/lean-v2/OmegaTheory"
  limit : Option Nat := none

def parseArgs (args : List String) : CliOpts := Id.run do
  let mut opts : CliOpts := {}
  let mut xs := args
  while !xs.isEmpty do
    match xs with
    | "--out" :: v :: rest =>
      opts := { opts with outPath := some v }
      xs := rest
    | "--file" :: v :: rest =>
      opts := { opts with filePath := some v }
      xs := rest
    | "--root" :: v :: rest =>
      opts := { opts with rootDir := v }
      xs := rest
    | "--limit" :: v :: rest =>
      opts := { opts with limit := v.toNat? }
      xs := rest
    | _ :: rest => xs := rest
    | []        => xs := []
  return opts

unsafe def main (args : List String) : IO UInt32 := do
  let opts := parseArgs args
  IO.eprintln s!"[dump_proof_steps] outPath  = {opts.outPath}"
  IO.eprintln s!"[dump_proof_steps] filePath = {opts.filePath}"
  IO.eprintln s!"[dump_proof_steps] rootDir  = {opts.rootDir}"
  IO.eprintln s!"[dump_proof_steps] limit    = {opts.limit}"
  initSearchPath (← findSysroot)
  Lean.enableInitializersExecution
  let tmpPath? : Option String := opts.outPath.map (· ++ ".tmp")
  let handle? : Option FS.Handle ← match tmpPath? with
    | some p => some <$> FS.Handle.mk p FS.Mode.write
    | none   => pure none
  let write (s : String) : IO Unit := do
    match handle? with
    | some h => h.putStrLn s
    | none   => IO.println s
  let files ← match opts.filePath with
    | some p => pure #[(System.FilePath.mk p)]
    | none   => listLeanFiles (System.FilePath.mk opts.rootDir)
  let files := match opts.limit with
    | some n => files.extract 0 n
    | none => files
  IO.eprintln s!"[dump_proof_steps] processing {files.size} file(s)"
  let mut totalSteps : Nat := 0
  for file in files do
    try
      let recs ← processFile file.toString
      for r in recs do
        write r
        totalSteps := totalSteps + 1
    catch e =>
      IO.eprintln s!"[dump_proof_steps] ERROR on {file}: {e.toString}"
  IO.eprintln s!"[dump_proof_steps] total tactic steps emitted: {totalSteps}"
  match handle?, opts.outPath, tmpPath? with
  | some _, some final, some tmp => do
    IO.FS.rename tmp final
    IO.eprintln s!"[dump_proof_steps] output renamed: {tmp} → {final}"
  | _, _, _ => pure ()
  return 0

end OmegaTheory.Meta.DumpProofSteps

unsafe def main (args : List String) : IO UInt32 :=
  OmegaTheory.Meta.DumpProofSteps.main args
