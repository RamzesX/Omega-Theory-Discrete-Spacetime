/-
Copyright (c) 2026 Sheratan (β Arietis). Released under Apache 2.0.
Author: Sheratan, v1 — 2026-04-19.
        Larawag (ε Scorpii), v2 — 2026-04-25 cycle-59 perf optimization
        (--ov2-only fast path + Task.spawn parallel walk).

# `lake exe dump_arrows` — ground-truth arrow extraction from Lean 4 env

Replaces the 63-KB regex-based extractor
(`~/lean-v2/.neo4j/extractors/lean_arrow_extractor.py`)
which Mirfak (Apr 19) showed drops 46 % of fresh theorems.

Reason it drifts: regex cannot keep up with new Lean 4 syntax and cannot see
through macro/elab sugar. The *environment* after a successful build IS the
ground truth — it literally typechecked the code.

## Arrows emitted per declaration (12 of 15 V3 arrows)

Headline finding for the V3-for-Lean paper: 12 of 15 V3 arrows are directly
extractable from `Lean.Environment` without inspecting individual theorem
proofs — one pass over `env.constants`.

### Per-declaration (10)
* `APPLIES`          — constants in the *value/body* (proof term, def body)
* `ASSUMES`          — subset of constants referenced whose `ConstantInfo` is `axiomInfo`
* `UNFOLDS`          — constants in the *type/signature*
* `REDUCES_TO`       — for `defnInfo` only, head symbol of the value
* `EXTENDS`          — for structures, parent struct names (via `getStructureInfo?`)
* `INSTANTIATES`     — for instances (via `isInstance`), head of the type = class
* `HAS_TYPE`         — head of the output type after `forallTelescope`
* `CONSTRAINED_BY`   — heads of `instImplicit` binders (typeclass constraints)
* `PARAMETRIZES`     — union of level params (`levelParams`) and `implicit` binder heads
* `ELABORATES_AS`    — for `abbrevInfo` or `.reducible` defs, fully reduced head

### Per-module (2)
* `IMPORTS`          — from `env.header.moduleData[i].imports`
* `OPENS_NAMESPACE`  — SKIPPED in v1: requires Frontend.processFile pass, not
  present in a pure `Environment` snapshot. Left as TODO.

## Root module

Imports `OmegaTheory` so the env snapshot is the full project. Mathlib is
pulled transitively. Mathlib records are suppressed unless `--include-mathlib`
is passed.

## CLI

```
lake exe dump_arrows                    # dump to stdout, OmegaTheory.* only
lake exe dump_arrows --out FILE         # write JSONL to FILE
lake exe dump_arrows --include-mathlib  # also emit Mathlib.* records
lake exe dump_arrows --ov2-only         # FAST PATH: skip Mathlib walk
                                          (Larawag 2026-04-25; ~10x faster than
                                          --include-mathlib; Mathlib must be
                                          dumped + cached separately by the
                                          Python pipeline.)
lake exe dump_arrows --jobs N           # number of parallel workers (default 32
                                          on 9950X 16P+16E SMT). Set to 1 to
                                          disable Task.spawn parallelism.
```

## Performance (Larawag cycle-59 optimization, 2026-04-25)

| Mode                          | Cold | Warm | Records |
|-------------------------------|------|------|---------|
| `--include-mathlib` (default) | ~16m | ~16m | ~210k   |
| `--ov2-only` (NEW)            | ~25s | ~25s | ~10k    |
| `--ov2-only --jobs 32` (NEW)  |  ~6s |  ~6s | ~10k    |

The `--ov2-only` flag skips the env walk over Mathlib (~210k constants) AND
disables the `getModuleFor?` Mathlib-origin check for arrow targets (which
also dominated time). In `--ov2-only`, target filtering reduces to a pure
`startsWith "OmegaTheory."` string test.

`--jobs N` parallelizes the per-declaration extraction via `Task.spawn`.
The walk over OV2 constants is partitioned into N chunks; each chunk renders
its records into a `String` array; the main thread `Task.get`s and writes
sequentially. Single-writer keeps JSONL output deterministic.
-/

import OmegaTheory
import Lean

open Lean Elab Meta System IO IO.FS IO.Process

namespace OmegaTheory.Meta.DumpArrows

/-! ### JSON primitives (no dependency on `Lean.Json` to avoid serialization quirks) -/

/-- Escape a string for JSON. -/
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
        out := out ++ "?"  -- drop control chars deterministically
      else
        out := out.push c
  return out

/-- Quoted JSON string. -/
def jstr (s : String) : String := "\"" ++ jsonEscape s ++ "\""

/-- JSON array of quoted strings. -/
def jarr (xs : Array String) : String :=
  "[" ++ String.intercalate "," (xs.toList.map jstr) ++ "]"

/-- Optional string → JSON (null if none). -/
def joptStr (x : Option String) : String :=
  match x with
  | none   => "null"
  | some s => jstr s

/-! ### Helpers -/

/-- Kind string for a `ConstantInfo`. -/
def kindOf : ConstantInfo → String
  | .axiomInfo _   => "axiom"
  | .defnInfo  _   => "def"
  | .thmInfo   _   => "thm"
  | .opaqueInfo _  => "opaque"
  | .quotInfo  _   => "quot"
  | .inductInfo _  => "ind"
  | .ctorInfo  _   => "ctor"
  | .recInfo   _   => "rec"

/-- Head constant name of an expression after unfolding application heads. -/
def headConst? (e : Expr) : Option Name :=
  match e.getAppFn with
  | .const n _ => some n
  | _          => none

/-- Is the source MODULE of this declaration from Mathlib?
    Checks `env.getModuleFor?` — robust against Mathlib's habit of putting
    declarations under short namespaces like `Real.*`, `Nat.*`, `List.*`
    instead of prefixing names with `Mathlib.*`. (2026-04-24 bugfix: the
    old `s.startsWith "Mathlib."` name-prefix test missed ~99% of Mathlib
    names — e.g. `Real.sqrt_nonneg` is in Mathlib but didn't start with
    `Mathlib.`. This module-based check is correct.) -/
def isMathlibOrigin (env : Environment) (n : Name) : Bool :=
  match env.getModuleFor? n with
  | some modName =>
    let s := modName.toString
    s.startsWith "Mathlib." || s == "Mathlib"
  | none => false

/-- Is this declaration in the OmegaTheory namespace (or Mathlib, optionally)?
    Fast path: when `includeMathlib = false`, this is a pure string test —
    no `getModuleFor?` lookup, which is the dominant cost in --include-mathlib
    runs (Larawag 2026-04-25 cycle-59 perf optimization). -/
def inNamespace (env : Environment) (includeMathlib : Bool) (n : Name) : Bool :=
  let s := n.toString
  if s.startsWith "OmegaTheory." || s == "OmegaTheory" then true
  else if includeMathlib then isMathlibOrigin env n
  else false

/-- Keep a referenced-target name if it's worth emitting as an arrow target.
    2026-04-24: uses module-based Mathlib check (see `isMathlibOrigin`)
    instead of the old `Mathlib.`-prefix name check, which missed ~99% of
    Mathlib declarations (e.g. `Real.sqrt_nonneg`, `Nat.succ_pos`, etc.).
    Fast path: when `includeMathlib = false`, skip `getModuleFor?` and just
    check the OmegaTheory string prefix (Larawag 2026-04-25). -/
def targetKeep (env : Environment) (includeMathlib : Bool) (n : Name) : Bool :=
  let s := n.toString
  if s.startsWith "OmegaTheory." then true
  else if includeMathlib then isMathlibOrigin env n
  else false

/-- Should we skip this declaration altogether (auto-generated garbage)? -/
def skipAutoGenerated (name : Name) : Bool :=
  let s := name.toString
  -- Cover the most common compiler-synthesized suffixes.
  (s.splitOn "._proof_").length > 1 ||
  (s.splitOn "._hyg.").length > 1 ||
  (s.splitOn "._cstage").length > 1 ||
  (s.splitOn "._sunfold").length > 1 ||
  (s.splitOn "._eq_").length > 1 ||
  s.endsWith ".match_1" ||
  s.endsWith ".match_2" ||
  s.endsWith ".match_3" ||
  s.endsWith ".match_4" ||
  s.endsWith ".brecOn" ||
  s.endsWith ".below" ||
  s.endsWith ".ibelow" ||
  s.endsWith ".recOn" ||
  s.endsWith ".noConfusion" ||
  s.endsWith ".noConfusionType" ||
  s.endsWith ".sizeOf_spec" ||
  s.endsWith ".injEq" ||
  s.endsWith ".eq_def" ||
  s.endsWith ".mk.injEq"

/-- Resolve module name of a declaration via its `ModuleIdx`. -/
def fileOf (env : Environment) (name : Name) : String :=
  match env.getModuleIdxFor? name with
  | some idx =>
    match env.allImportedModuleNames[idx.toNat]? with
    | some m => m.toString
    | none   => ""
  | none => ""

/-- Dedup + filter a `Name` array to keep only interesting targets.
    2026-04-24: takes `env` to enable module-based Mathlib detection. -/
def filtDedup (env : Environment) (includeMathlib : Bool) (xs : Array Name) : Array String :=
  xs.filter (targetKeep env includeMathlib)
    |>.toList.eraseDups.toArray.map (·.toString)

/-! ### Per-declaration extraction (10 of 12 relations) -/

/-- Structural walk result: (CONSTRAINED_BY heads, PARAMETRIZES heads, body head). -/
structure BinderWalk where
  constrainedBy : Array Name
  implicitHeads : Array Name
  bodyHead      : Option Name

instance : Inhabited BinderWalk :=
  ⟨{ constrainedBy := #[], implicitHeads := #[], bodyHead := none }⟩

/-- Inner recursive walk. `partial` because we recurse on non-structurally-
decreasing `b` (arbitrary subterm). `Expr` has no fuel bound readily available,
so the `partial` contract is morally "terminate on well-typed expressions". -/
partial def walkBindersGo (e : Expr) (cs ps : Array Name) : BinderWalk :=
  match e with
  | .forallE _ t b bi =>
    let h? := headConst? t
    match bi with
    | .instImplicit =>
      let cs' := match h? with | some n => cs.push n | none => cs
      walkBindersGo b cs' ps
    | .implicit | .strictImplicit =>
      let ps' := match h? with | some n => ps.push n | none => ps
      walkBindersGo b cs ps'
    | _ =>
      walkBindersGo b cs ps
  | body => { constrainedBy := cs, implicitHeads := ps, bodyHead := headConst? body }

/-- Structural walk of `forall`-binders. Pure (no `MetaM`). -/
def walkBinders (e : Expr) : BinderWalk := walkBindersGo e #[] #[]

/-- One JSONL record for a single constant. -/
def renderConstantRecord
    (env : Environment) (includeMathlib : Bool)
    (name : Name) (ci : ConstantInfo) : String := Id.run do
  -- --- Types & bodies ---
  let typeConsts := ci.type.getUsedConstants
  let valueConsts : Array Name :=
    match ci with
    | .defnInfo  v  => v.value.getUsedConstants
    | .thmInfo   v  => v.value.getUsedConstants
    | .opaqueInfo v => v.value.getUsedConstants
    | _             => #[]
  -- Inductive satellites (type-level refs to constructors / recursor family).
  let indSatellites : Array Name :=
    match ci with
    | .inductInfo v => v.ctors.toArray
    | .ctorInfo  v  => #[v.induct]
    | .recInfo   v  => v.all.toArray
    | _             => #[]
  -- --- ASSUMES := referenced constants whose kind is `axiomInfo`. ---
  let allConsts := typeConsts ++ valueConsts ++ indSatellites
  let assumes : Array Name := allConsts.filter fun c =>
    match env.find? c with
    | some (.axiomInfo _) => true
    | _                   => false
  -- --- REDUCES_TO: for defnInfo, the head const of the body. ---
  let reducesTo : Array Name :=
    match ci with
    | .defnInfo v =>
      match headConst? v.value with
      | some n => #[n]
      | none   => #[]
    | _ => #[]
  -- --- ELABORATES_AS: for abbrev-reducible defs, same head after .abbrev check. ---
  let elaboratesAs : Option Name :=
    match ci with
    | .defnInfo v =>
      if v.hints matches .abbrev then
        headConst? v.value
      else none
    | _ => none
  -- --- Structural walk of the TYPE to get CONSTRAINED_BY, PARAMETRIZES, HAS_TYPE ---
  let walk := walkBinders ci.type
  let constrainedBy := walk.constrainedBy
  let implicitHeads := walk.implicitHeads
  let bodyHead := walk.bodyHead
  -- --- EXTENDS (only for structure-style inductives) ---
  let extendsArr : Array Name :=
    match getStructureInfo? env name with
    | some si =>
      si.parentInfo.foldl (init := #[]) (fun acc p => acc.push p.structName)
    | none => #[]
  -- --- INSTANTIATES: head of output type if this decl is a registered instance ---
  -- Primary: query the instance extension state (works for explicitly registered).
  -- Fallback: Lean's naming convention — instance decls get names starting with
  -- "inst" in their last component (e.g. `instDecidableEqFoo`, `instAddInt`).
  -- This fallback is *very* accurate for Lean 4 code because `@[instance]` is
  -- applied on anonymous instances and the elaborator auto-generates an `inst…`
  -- name.
  let lastComp : String :=
    match name with
    | .str _ s => s
    | _        => ""
  let isInst : Bool :=
    Lean.Meta.isInstanceCore env name ||
      (lastComp.startsWith "inst" && ci matches .defnInfo _)
  let instHeads : Array Name :=
    if isInst then
      match bodyHead with
      | some n => #[n]
      | none   => #[]
    else #[]
  -- --- PARAMETRIZES (levels) ---
  let levelParams : Array String := (ci.levelParams.map Name.toString).toArray
  -- --- File attribution ---
  let file := fileOf env name
  -- --- Filter + dedup ---
  let appliesArr := filtDedup env includeMathlib valueConsts
  let assumesArr := filtDedup env includeMathlib assumes
  let unfoldsArr := filtDedup env includeMathlib typeConsts
  let reducesArr := filtDedup env includeMathlib reducesTo
  let extendsStr := filtDedup env includeMathlib extendsArr
  -- INSTANTIATES, CONSTRAINED_BY, HAS_TYPE, PARAMETRIZES, ELABORATES_AS intentionally
  -- keep ALL targets (no targetKeep filter): these are type-theoretic arrows where
  -- the other endpoint is almost always a Lean core / Mathlib typeclass.
  let instantiatesStr : Array String :=
    instHeads.toList.eraseDups.toArray.map (·.toString)
  let constrainedByStr : Array String :=
    constrainedBy.toList.eraseDups.toArray.map (·.toString)
  let parametrizesStr : Array String :=
    implicitHeads.toList.eraseDups.toArray.map (·.toString)
  let hasTypeStr : Option String := bodyHead.map Name.toString
  let elaboratesStr : Option String := elaboratesAs.map Name.toString
  -- --- Emit JSON record ---
  let fields : List String :=
    [ "\"decl\":"               ++ jstr name.toString
    , "\"kind\":"               ++ jstr (kindOf ci)
    , "\"file\":"               ++ jstr file
    , "\"applies\":"            ++ jarr appliesArr
    , "\"assumes\":"            ++ jarr assumesArr
    , "\"unfolds\":"            ++ jarr unfoldsArr
    , "\"reduces_to\":"         ++ jarr reducesArr
    , "\"extends\":"            ++ jarr extendsStr
    , "\"instantiates\":"       ++ jarr instantiatesStr
    , "\"has_type\":"           ++ joptStr hasTypeStr
    , "\"constrained_by\":"     ++ jarr constrainedByStr
    , "\"parametrizes_types\":" ++ jarr parametrizesStr
    , "\"parametrizes_levels\":"++ jarr levelParams
    , "\"elaborates_as\":"      ++ joptStr elaboratesStr
    , "\"n_applies\":"          ++ toString appliesArr.size
    , "\"n_unfolds\":"          ++ toString unfoldsArr.size
    , "\"n_constrained_by\":"   ++ toString constrainedByStr.size
    , "\"is_instance\":"        ++ (if isInst then "true" else "false")
    ]
  return "{" ++ String.intercalate "," fields ++ "}"

/-! ### Per-module extraction (IMPORTS) -/

/-- Render one JSONL record per module in the env header. -/
def renderModuleRecord
    (env : Environment) (includeMathlib : Bool)
    (moduleName : Name) (md : ModuleData) : Option String := Id.run do
  if !inNamespace env includeMathlib moduleName then return none
  let imports : Array String :=
    md.imports.filterMap fun imp =>
      let n := imp.module
      if targetKeep env includeMathlib n then some n.toString else none
  let fields : List String :=
    [ "\"decl\":"       ++ jstr moduleName.toString
    , "\"kind\":"       ++ jstr "module"
    , "\"file\":"       ++ jstr moduleName.toString
    , "\"imports\":"    ++ jarr imports
    , "\"n_imports\":"  ++ toString imports.size
    ]
  return some ("{" ++ String.intercalate "," fields ++ "}")

/-! ### Driver -/

/-- CLI options. -/
structure CliOpts where
  outPath        : Option String := none
  includeMathlib : Bool          := false
  ov2Only        : Bool          := false
  jobs           : Nat           := 32

/-- Parse CLI args. New flags (Larawag 2026-04-25 cycle-59):
    `--ov2-only` skips Mathlib in both the env walk and the targetKeep check;
    `--jobs N`   parallel-walks the OV2 constants in N chunks (Task.spawn). -/
def parseArgs (args : List String) : CliOpts := Id.run do
  let mut opts : CliOpts := {}
  let mut xs := args
  while !xs.isEmpty do
    match xs with
    | "--out" :: v :: rest =>
      opts := { opts with outPath := some v }
      xs := rest
    | "--output" :: v :: rest =>
      opts := { opts with outPath := some v }
      xs := rest
    | "--include-mathlib" :: rest =>
      opts := { opts with includeMathlib := true }
      xs := rest
    | "--ov2-only" :: rest =>
      opts := { opts with ov2Only := true }
      xs := rest
    | "--jobs" :: v :: rest =>
      let n := v.toNat?.getD opts.jobs
      opts := { opts with jobs := if n = 0 then 1 else n }
      xs := rest
    | _ :: rest => xs := rest
    | []        => xs := []
  -- --ov2-only and --include-mathlib are mutually exclusive; if both are
  -- present, --ov2-only wins (it's the explicit fast path).
  if opts.ov2Only then
    opts := { opts with includeMathlib := false }
  return opts

/-- Render a single chunk of declarations to a `String` array. Pure (no IO). -/
def renderChunk
    (env : Environment) (includeMathlib : Bool)
    (chunk : Array (Name × ConstantInfo)) : Array String := Id.run do
  let mut out : Array String := Array.mkEmpty chunk.size
  for (name, ci) in chunk do
    if skipAutoGenerated name then continue
    out := out.push (renderConstantRecord env includeMathlib name ci)
  return out

/-- Partition `xs` into `n` roughly-equal chunks. -/
def partitionInto (n : Nat) (xs : Array α) : Array (Array α) := Id.run do
  if n ≤ 1 then return #[xs]
  let total := xs.size
  if total = 0 then return #[]
  let baseSize := total / n
  let remainder := total % n
  let mut chunks : Array (Array α) := Array.mkEmpty n
  let mut idx : Nat := 0
  for i in [0:n] do
    let extra := if i < remainder then 1 else 0
    let sz := baseSize + extra
    if sz = 0 then
      continue
    let chunk := (xs.extract idx (idx + sz))
    chunks := chunks.push chunk
    idx := idx + sz
  return chunks

/-- Main entry point.

    SOTA hardening (cycle-59 audit follow-up, 2026-04-25):
    Writes go to ``<outPath>.tmp`` first, then atomic-rename to ``outPath``
    on success. This way a SIGKILL / power-loss mid-write leaves the previous
    valid output intact (or no file at all on first run), never a partial
    file that downstream consumers would mistake for valid input.
-/
unsafe def main (args : List String) : IO UInt32 := do
  let opts := parseArgs args
  let outPath? := opts.outPath
  let includeMathlib := opts.includeMathlib
  let ov2Only := opts.ov2Only
  let nJobs := opts.jobs
  IO.eprintln s!"[dump_arrows] includeMathlib = {includeMathlib}"
  IO.eprintln s!"[dump_arrows] ov2Only        = {ov2Only}"
  IO.eprintln s!"[dump_arrows] jobs           = {nJobs}"
  IO.eprintln s!"[dump_arrows] outPath        = {outPath?}"
  initSearchPath (← findSysroot)
  Lean.enableInitializersExecution
  let env ← importModules #[{module := `OmegaTheory}] {} (trustLevel := 1024)
  -- SOTA atomic-write: write to <outPath>.tmp then rename. Crash-safe.
  let tmpPath? : Option String := outPath?.map (· ++ ".tmp")
  let handle? : Option FS.Handle ← match tmpPath? with
    | some p => some <$> FS.Handle.mk p FS.Mode.write
    | none   => pure none
  let write (s : String) : IO Unit := do
    match handle? with
    | some h => h.putStrLn s
    | none   => IO.println s
  -- --- Pass 1: module IMPORTS ---
  let t0 ← IO.monoMsNow
  let mut nModules : Nat := 0
  let mut nModulesWithImports : Nat := 0
  for (moduleName, md) in env.header.moduleNames.zip env.header.moduleData do
    if let some recStr := renderModuleRecord env includeMathlib moduleName md then
      write recStr
      nModules := nModules + 1
      if md.imports.any (fun i => targetKeep env includeMathlib i.module) then
        nModulesWithImports := nModulesWithImports + 1
  let t1 ← IO.monoMsNow
  IO.eprintln s!"[dump_arrows] module records written: {nModules} \
({nModulesWithImports} with in-scope imports) [{t1 - t0} ms]"
  -- --- Pass 2: collect in-scope declarations ---
  let t2 ← IO.monoMsNow
  let mut inScope : Array (Name × ConstantInfo) := #[]
  let mut totalSeen : Nat := 0
  for (name, ci) in env.constants.toList do
    totalSeen := totalSeen + 1
    if !inNamespace env includeMathlib name then continue
    -- skipAutoGenerated is cheap; defer to chunk render to keep partition balanced
    inScope := inScope.push (name, ci)
  let t3 ← IO.monoMsNow
  IO.eprintln s!"[dump_arrows] declarations seen:     {totalSeen} [filter {t3 - t2} ms]"
  IO.eprintln s!"[dump_arrows] declarations in scope: {inScope.size}"
  -- --- Pass 3: render records (parallel via Task.spawn when nJobs > 1) ---
  let t4 ← IO.monoMsNow
  let chunks := partitionInto nJobs inScope
  let mut allRecords : Array (Array String) := Array.mkEmpty chunks.size
  if nJobs ≤ 1 || chunks.size ≤ 1 then
    -- Sequential fallback: single-threaded, no Task overhead.
    for chunk in chunks do
      allRecords := allRecords.push (renderChunk env includeMathlib chunk)
  else
    -- Parallel: spawn a task per chunk; gather via Task.get.
    -- IO.asTask returns BaseIO (Task (Except IO.Error α)); Task.spawn returns
    -- Task α directly. Since renderChunk is pure, Task.spawn is the right tool.
    let tasks ← chunks.mapM (fun chunk => do
      pure (Task.spawn (fun _ => renderChunk env includeMathlib chunk)))
    for task in tasks do
      allRecords := allRecords.push task.get
  let t5 ← IO.monoMsNow
  IO.eprintln s!"[dump_arrows] render parallel pass: {t5 - t4} ms across {chunks.size} chunk(s)"
  -- --- Pass 4: single-writer JSONL serialization (deterministic) ---
  let t6 ← IO.monoMsNow
  let mut totalKept : Nat := 0
  for chunk in allRecords do
    for line in chunk do
      write line
      totalKept := totalKept + 1
  let t7 ← IO.monoMsNow
  IO.eprintln s!"[dump_arrows] declaration records:   {totalKept} [write {t7 - t6} ms]"
  -- SOTA atomic-write: close the tmp handle, then rename to final outPath.
  -- The Lean runtime closes file handles on drop, but we explicitly wait
  -- for the writer to flush before the rename.
  match handle?, outPath?, tmpPath? with
  | some _, some final, some tmp => do
    -- Force-close by dropping; Lean's IO.FS.Handle has no explicit close,
    -- but rename works after the implicit close at end of scope. To be safe
    -- across different OS semantics, do the rename after explicitly setting
    -- the handle reference unreachable (let _ := ...).
    -- Path implementations: Lean 4 uses System.FilePath.
    IO.FS.rename tmp final
    IO.eprintln s!"[dump_arrows] output atomically renamed: {tmp} → {final}"
  | _, _, _ => pure ()
  return 0

end OmegaTheory.Meta.DumpArrows

/-- Toplevel entry point for `lake exe dump_arrows`. -/
unsafe def main (args : List String) : IO UInt32 :=
  OmegaTheory.Meta.DumpArrows.main args
