# CLAUDE.md

## What this repo is

A Skyrim **VR** fork of dfxyz's *Time Flies SE* (`upstream` remote →
`github.com/dfxyz/TimeFlies`, `origin` → `github.com/kobbled/TimeFlies`). The
mod advances game time when the player crafts, reads, loots, trades, eats,
trains and so on.

This is a **Papyrus mod project, not a software library**. There is no test
suite, no CI, and no way to verify behaviour except by loading the game. The
compiler is the only automated check available — treat "it compiles clean" as
the floor, not as proof the change works.

The fork exists because upstream detects the Activate keypress through
`OnKeyDown`, which never fires in VR. `TimeFliesMain.OnVRButtonEvent` mirrors
that logic on PapyrusVR controller events.

## Layout

```
TimeFlies.esp              quests, script property bindings, MCM messages
TF-AEFishing Patch.esp     optional ESL patch, masters ccBGSSSE001-Fish.esm
Scripts/*.pex              compiled output, committed
Scripts/Source/*.psc       Papyrus sources
Interface/Translations/    MCM strings, UTF-16LE + CRLF
skyrimse.ppj               Pyro build project
.claude/docs/              deeper notes, see below
```

Read these before non-trivial work:

* `.claude/docs/architecture.md` — script map, event flow, and the crafting
  detection state machine that most bugs live in.
* `.claude/docs/papyrus-gotchas.md` — the language and save-game traps that
  have actually caused bugs here.
* `.claude/docs/build-and-deploy.md` — how to compile and where the build
  output has to go to be testable.

## Build

```bash
pyro --input-path skyrimse.ppj --game-path <install with a Papyrus Compiler folder>
```

The configured `--game-path` in `.vscode/tasks.json` may have no compiler in it,
in which case Pyro fails with *"Cannot proceed without compiler path"*. See
`.claude/docs/build-and-deploy.md` for the fallback.

**Always recompile and commit the `.pex` alongside any `.psc` change.** The game
loads `.pex` only; a source-only commit ships nothing. Rebuild only the scripts
you changed rather than all 18 — the compiler emits string tables in a
non-deterministic order, so recompiling untouched scripts produces pointless
byte-level churn.

## Conventions

* Sources use **tabs** for indentation and **CRLF** line endings. Some upstream
  blocks use 4 spaces; match whatever surrounds the line you are editing.
* `_debug(...)` for tracing, not `Debug.Trace` directly. It prefixes the
  script name and is gated on `debug_mode`.
* Time is in **hours** everywhere `pass_time()` is involved. MCM sliders that
  read `"${0}min"` must be divided by 60 at the call site; sliders that read
  `"${2}hour"` must not be.
* Never invent form IDs. Every `Game.GetFormFromFile` ID in this repo comes from
  a real plugin — verify against the actual mod before adding one.
* MCM option strings live in `Interface/Translations/TimeFlies_ENGLISH.txt`,
  which is **UTF-16LE with CRLF**. Editing it as UTF-8 corrupts the file. Any
  new `$key` used in a script must be added there or the MCM shows the raw key.

## Editing hazards

* Papyrus line continuations are a trailing `\` that must be the **last**
  character on the line. Several upstream lines have trailing whitespace after
  the `\` and survive only by luck. Shell heredocs eat backslashes — when
  scripting an edit, build continuations with `chr(92)` rather than escaping.
* Adding a script variable is safe on existing saves; changing a variable's
  type or removing a property is not.
* Adding an `Auto` property that the MCM assigns at runtime needs no ESP change.
  Adding one the ESP must fill does — and the ESP cannot be edited from here.

## Known-dirty state

`TimeFlies.esp` carries a stray `NAVI` override (`00012FB4`, ~27KB — the whole
plugin is 31KB, upstream's is 3.7KB) added by a Creation Kit save. It needs
removing in SSEEdit. Do not attempt to strip it by editing bytes.

## Scope

Do not commit to `master`; branch first. Do not push unless asked. Changes to
the `.esp` files require SSEEdit or the Creation Kit and are out of scope for
automated edits.
