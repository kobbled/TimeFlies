# Architecture

## Plugin contents

`TimeFlies.esp` masters `Skyrim.esm` and `Update.esm`. It holds:

| Record | Form ID | Purpose |
|---|---|---|
| `QUST TimeFlies` | `xx000D64` | main quest — carries `TimeFliesMain` + `TimeFliesMCM`, and the player alias |
| `QUST TimeFliesModHandler` | `xx000D65` | carries `TimeFliesMods`, the support-script dispatcher |
| `QUST TimeFliesSupportFor*` | 12 quests | one per supported mod, each carrying its `TF*` script |
| `MESG TimeFliesNotificationShort` | `xx000D63` | `%.0f minute(s) passed.` |
| `MESG TimeFliesNotificationLong` | `xx000D62` | `%.0f hour(s) and %.0f minute(s) passed.` |
| `INGR SlaughterfishEgg01` | `0007E8C5` | override inherited from upstream |
| `NAVI` | `00012FB4` | **dirty CK edit, should be removed** |

`TimeFlies` is start-game-enabled and run-once. Its single alias,
`TimeFliesPlayerAlias`, is a forced reference on `PlayerRef` (`0x14`) and
carries the `TimeFliesPlayerAlias` script.

## Object graph

```
TimeFliesPlayerAlias  (ReferenceAlias on the player)
        │  forwards every event, holds no logic
        ▼
TimeFliesMain  ──────────────────┐  all timekeeping, all decisions
        ▲                        │
        │ main                   │ mods
TimeFliesMCM                     ▼
 (SKI_ConfigBase)          TimeFliesMods
 owns every setting,        dispatcher — asks each TF* script
 writes them onto main      in turn whether it claims the item
                                 │
                                 ▼
                    TFHearthfire, TFCampfire, TFSunHelm, … (12)
```

Every tunable lives as an `Auto` property on `TimeFliesMain`. `TimeFliesMCM`
does not read them from the ESP — `initialize()` and `load_defaults()` assign
them at runtime, which is why adding a new setting needs no plugin edit.

`TimeFliesMCM.Pages` and `ModName` are inherited from `SKI_ConfigBase`;
`TimeFliesMods.prepare_pages()` fills the 17-entry page array.

## Event flow

The alias forwards; `TimeFliesMain` decides:

| Alias event | Main handler |
|---|---|
| `OnItemAdded` | `handle_added_item` — the crafting path |
| `OnItemRemoved` | `handle_removed_item` — eating, spell books, campfire fuel |
| `OnSit` / `OnGetUp` | `handle_using_furniture` / `handle_leaving_furniture` |
| `OnSpellCast` | `handle_spellcast` — crafting spells, prayer |
| `OnObjectEquipped` / `Unequipped` | fishing pole, shovel tracking |
| `OnPlayerLoadGame` | `handle_loadgame` — day notification, VR re-registration |

`TimeFliesMain` also receives `OnMenuOpen` / `OnMenuClose` (registered by the
MCM), `OnKeyDown` (flatscreen), and `OnVRButtonEvent` (VR).

## The crafting state machine

**This is where nearly every "time didn't pass" bug lives.** `handle_added_item`
charges crafting time only if at least one of three flags is set:

| Flag | Set by | Meaning |
|---|---|---|
| `is_crafting_station` | `handle_using_furniture`, **only if the Crafting Menu is already open when `OnSit` fires** | forge, workbench, tanning rack, cookpot |
| `is_crafting_spell` | `handle_spellcast`, if the Crafting Menu is open 2s after the cast | Atronach Forge and similar |
| `is_crafting_menu` | `OnKeyDown` / `OnVRButtonEvent`, if 2s after an Activate press the Crafting Menu is open **and** `furniture_using == None` | menu-driven crafting with no furniture |

If all three are false, `handle_added_item` returns early and the craft is free.
It also returns early when `src` is non-`None` (the item came from a container,
so it was moved rather than made) or the console is open.

All three are cleared at the end of `OnMenuClose`, along with
`activate_key_pressed` and `time_advanced`.

Trace this in `Papyrus.0.log` — `handle_added_item` logs the flags directly:

```
Time Flies: Crafting via Workstation (False), Spell (False), Menu (False)
```

All three `False` on a craft that should have cost time is the smoking gun.

### Known weakness

`handle_using_furniture` samples `UI.IsMenuOpen("Crafting Menu")` at the instant
`OnSit` fires. If the menu has not opened yet, the flag never sets and that craft
is free. Unfixed, inherited from upstream, and a plausible cause of residual
intermittency.

## VR input

PapyrusVR (Skyrim VR Tools) delivers
`OnVRButtonEvent(eventType, buttonId, deviceId)`. Constants from
`PapyrusVR.psc`:

* eventType — `Touched 0`, `Untouched 1`, `Pressed 2`, `Released 3`
* deviceId — `HMD 0`, `RightController 1`, `LeftController 2`
* buttonId — `k_EButton_A 7`, `k_EButton_SteamVR_Trigger 33` (same value as
  `k_EButton_Axis1`)

Three properties that matter:

1. **All four event types fire for one physical press.** Filter to `VR_PRESSED`
   or the handler runs four times.
2. **The trigger is also attack.** The handler ignores it while a weapon or
   spell is drawn.
3. **Registrations do not survive a save/load.** PapyrusVR keeps them in memory
   with no co-save serialisation, so `handle_loadgame` clears `vr_registered`
   and calls `init()` again. `TimeFliesMCM.initialize()` also registers when the
   mod is enabled, and unregisters when disabled.

`init()`/`uninit()` are idempotent through `vr_registered`. Do not call
`uninit()` from a menu-close path — that bug disabled VR input for the rest of
the session after the first craft.

## Time units

`pass_time(float hours)` is the single sink. It adds to the `GameHour` global
and sets `time_advanced`. It **early-returns on `<= 0`**, so any calculation
that can go negative silently costs nothing.

MCM sliders labelled `${0}min` must be divided by 60 at the call site; sliders
labelled `${2}hour` / `${1}hour` must not be. Getting this backwards is a
100-minute or 1/60th error that looks like the feature simply not working.

Two shapes of calculation:

* **Fixed** — a configured duration × `random_time_multiplier()` ×
  `expertise_multiplier(skill)` × `item_value_multiplier(item)`.
* **Duration** — real seconds spent in a menu × `TimeScale.getValue()` / 3600 ×
  a per-activity multiplier. Used for reading, lockpicking, trading and looting.
  Note this reads `TimeScale` at menu *close*; a mod that varies timescale
  dynamically makes these erratic.

Some costs accumulate rather than applying per item, so a batch is one
notification: `cooking_time_to_pass` and `alchemy_time_to_pass` flush on
Crafting Menu close; `eating_time_to_pass`, `skinning_time_to_pass` and
`harvesting_time_to_pass` flush on Inventory/Container close.

`item_value_multiplier` scales crafting time between the iron baseline (1×) and
daedric (4×) via `value_ratio`, which clamps `item_val` into `[ival, dval]`.
Before the clamp existed, gear priced above daedric produced a negative
multiplier and those crafts cost nothing.

## Mod support pattern

Each `TF*` script implements the same shape:

```papyrus
Function initialize()          ; Game.GetModByName(plugin); bail if 255
Function load_defaults()
bool Function handle_added_item(Form item)     ; True = claimed, stop dispatch
bool Function handle_removed_item(Form item)
Function save_settings() / load_settings()     ; FISS
bool Function handle_page(string page)         ; MCM page rendering
```

`TimeFliesMods` calls each in a fixed order and stops at the first `True`.
Claiming an item suppresses `TimeFliesMain`'s own handling of it — note that
several scripts return `True` even on the "ignored" path, which deliberately
suppresses vanilla handling for anything from that plugin.

Detection uses `Game.GetModByName`, which **returns 255 for ESL/ESPFE plugins**.
A light-flagged supported mod silently disables its own support.

## Fork status

Forked from upstream 8.1.3; upstream is now 8.2.2.

Merged from 8.2.2:

* grain mill support (`milling_minute`, `flour`, `$milling`)
* `is_enabled &&` guard on the day notification

Deliberately not merged:

* the `caco_items[67]` → `caco_ws[49]` + `caco_tokens[90]` split, and the
  corrected `Update.esm` form IDs for Survival Mode records. Only relevant with
  CACO / iNeed / LastSeed installed. Upstream's version carries two bugs of its
  own — `caco_tokens[12]` is assigned twice leaving index 13 unset, and
  `caco_tokens[47]` uses `0xFCDAB` where neighbours suggest `0x2FCDAB`.

Local-only, not upstream:

* `OnVRButtonEvent` and the `init`/`uninit` lifecycle
* SunHelm cooking (`TFSunHelm.cooking_hour`)
* `value_ratio` clamping in `item_value_multiplier`
