# Build and deploy

## The toolchain

`skyrimse.ppj` is a [Pyro](https://github.com/fireundubh/pyro) project. Pyro is
a wrapper — it does **not** contain a compiler, it locates `PapyrusCompiler.exe`
under the `--game-path` you give it. The VS Code `joelday.papyrus-lang-vscode`
extension bundles `pyro.exe` and defines the build task in `.vscode/tasks.json`.

```
pyro --input-path skyrimse.ppj --game-path <install with a Papyrus Compiler folder>
```

Project settings worth knowing:

* `Game="sse"` — SSE and VR share the same Papyrus bytecode format
  (`FA57C0DE`, version 3.2, gameID 1), so an SSE-targeted build runs in VR.
* `Anonymize="true"` — scrambles the source path, username and machine name in
  the `.pex` header. Purely cosmetic; it does not affect bytecode.
* `Output="Scripts"` — writes straight into the committed `.pex` directory.
* Imports: `Scripts/Source` plus the game's `Data/Scripts/Source`, which must
  contain `PapyrusVR.psc` (Skyrim VR Tools) and `SKI_ConfigBase.psc` (SkyUI).

## When Pyro says "Cannot proceed without compiler path"

The `--game-path` has no `Papyrus Compiler` folder. `PapyrusCompiler.exe` ships
with the **Creation Kit**, not with the game, so a plain Steam install will not
have one.

Options, best first:

1. Install the Skyrim SE Creation Kit and point `--game-path` at it.
2. Invoke a compiler from another install directly. Nemesis bundles a working
   Skyrim Papyrus compiler, for example:

```bash
"<...>/Nemesis_Engine/Papyrus Compiler/PapyrusCompiler.exe" \
  'Scripts/Source' \
  -f='TESV_Papyrus_Flags.flg' \
  -i='Scripts\Source;<game>\Data\Scripts\Source' \
  -o='<output dir>' \
  -all
```

Before trusting an unfamiliar compiler, **validate it**: rebuild a script you
have not modified and compare against the committed `.pex`. Skip the header
(magic 4 + version 2 + gameID 2 + compile time 8, then three length-prefixed
big-endian strings) and compare the remainder. Expect identical length and
identical string/function content; string-table *ordering* differs between
compiler builds and is benign.

## What to commit

The game loads `.pex` only. A `.psc`-only commit ships nothing.

Rebuild and commit the `.pex` for **every script you changed** — and only those.
The compiler emits its string table in a non-deterministic order, so
recompiling untouched scripts produces byte-level churn with no semantic
content.

## Deploying for testing

Compiling proves syntax. It proves nothing about behaviour — the only way to
test is in-game.

This repo is not the deployed mod. The build has to reach the MO2 mods folder
(`.../mods/Time Flies SE/` in the current setup) as `Scripts/`, `Interface/`,
and the `.esp` files. Two approaches:

* Copy this repo's output over the installed mod folder. Simple, but a Nexus
  update silently overwrites it — which has already happened once, reverting
  the whole VR fork to upstream.
* Install as a **separate MO2 mod** ordered after `Time Flies SE` so it wins the
  file conflict. Survives updates to the base mod.

Either way, confirm what is actually deployed before debugging. Check that the
mod folder's `Scripts/TimeFliesMain.pex` contains `OnVRButtonEvent` — if it does
not, you are running upstream and no amount of source reading will explain the
behaviour.

## Verifying a change in game

1. Enable Papyrus logging in `SkyrimVR.ini`:
   `[Papyrus]` → `bEnableLogging=1`, `bEnableTrace=1`, `bLoadDebugInformation=1`
2. Load, and watch `Documents/My Games/Skyrim VR/Logs/Script/Papyrus.0.log`.
3. `debug_mode` is hardcoded `True`, so every decision traces with a
   `Time Flies:` prefix.

Useful lines:

| Line | Means |
|---|---|
| `Crafting via Workstation (…), Spell (…), Menu (…)` | the three crafting flags — all `False` on a real craft is the core bug |
| `VR buttons registered` / `unregistered` | PapyrusVR lifecycle |
| `VR button pressed - device: … button: …` | a press survived the filters |
| `Possible fast travel` | should **not** appear while standing at a forge |
| `Time passed - N hour(s), M minute(s)` | `pass_time` actually fired |

A save/load is enough to re-run `handle_loadgame`; changes to MCM registration
need the mod toggled off and on, or *Reinitialize Time Flies*.

## Plugin edits

`TimeFlies.esp` needs SSEEdit or the Creation Kit. It currently carries a dirty
`NAVI` override (`00012FB4`) from a CK save — around 27KB of a 31KB plugin,
against upstream's 3.7KB. Remove it in SSEEdit; do not attempt byte-level
surgery on the record.
