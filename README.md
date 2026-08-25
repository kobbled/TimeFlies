![Time Flies](./Pictures/time_flies.png)

# Time Flies VR

A Skyrim VR fork of [dfxyz's Time Flies SE](https://www.nexusmods.com/skyrimspecialedition/mods/39426),
which is itself based on Akezhar's
[Living Takes Time](http://www.nexusmods.com/skyrim/mods/44623/).

Game time passes when you perform actions that ought to take a while — crafting,
reading, looting, trading, eating, training, cooking, mining, chopping wood.
Everything is configurable in MCM.

## What this fork adds

Time Flies SE detects "the player pressed Activate, a crafting menu may be about
to open" through `OnKeyDown`. Skyrim VR has no keyboard input for that, so the
crafting, fast-travel and interior/city tracking that hangs off it never fires.

* **VR controller input.** `TimeFliesMain.OnVRButtonEvent` mirrors the existing
  `OnKeyDown` logic using **Skyrim VR Tools** (CylonSurfer, Nexus/skyrimvr)
  for its PapyrusVR API, listening for the A button and the trigger.
* **SunHelm cooking.** A configurable time cost for cooking SunHelm food items,
  with its own MCM slider on the SunHelm page.

Forked from upstream 8.1.3. Grain-mill support and a handful of fixes have been
picked up from upstream 8.2.2; the CACO waterskin/token form lists have not.
See `.claude/docs/architecture.md` for what is and isn't merged.

## Requirements

| | |
|---|---|
| Skyrim VR | the SE/AE build will not load this |
| [SKSE VR](http://skse.silverlock.org/) | |
| SkyUI VR | for the MCM |
| **Skyrim VR Tools** (CylonSurfer, Nexus/skyrimvr) | provides `PapyrusVR` — **required**, unlike upstream |
| [FISS](http://www.nexusmods.com/skyrim/mods/48265/) | optional, only to save/load your own settings presets |

Supported mods are **not required**. If you install one after Time Flies, run
*Reinitialize Time Flies* on the MCM's General page so it re-detects them.

## Features

* Time passes for crafting, smithing improvement, enchanting, alchemy, cooking,
  reading, looting, lockpicking, trading, eating, training, learning spells,
  harvesting, mining, lumbering, milling and skinning.
* Per-item-type crafting times — helmets, cuirasses, gauntlets, boots, shields,
  clothing, jewellery, each weapon class, ammo, staves, smelting and tanning are
  all configured separately.
* **Random crafting time** — each craft costs a random multiple of the configured
  value (67%–100% by default) rather than a fixed amount.
* **Expertise reduces time** — full time at skill 0, half time at skill 100.
  Applies to reading, crafting, improving, enchanting, cooking and lockpicking.
* **Item value modifies crafting time** — crafting times are normalised against
  iron equipment and scale with item value up to a 4× cap at daedric.
* Reading raises Speech based on time spent.
* Optional fade-to-black transition for anything over a configurable threshold.
* Optional combat lockout for menus, object activation and journal tabs.
* Hotkey to pause and resume time passing.

## Supported mods

| Mod | Plugin |
|---|---|
| Hearthfire (DLC) | `HearthFires.esm` |
| Anniversary Edition Fishing (CC) | `ccBGSSSE001-Fish.esm` |
| Hearthfire Extended | `hearthfireextended.esp` |
| Campfire | `Campfire.esm` |
| Basic Camp Gear | `BasicCampGear.esp` |
| Campsite | `Campsite.esp` |
| iNeed | `iNeed.esp` |
| SunHelm Survival | `SunHelmSurvival.esp` |
| Last Seed | `LastSeed.esp` |
| Skyrim Fishing | `BBD_SkyrimFishing.esp` |
| Hunting in Skyrim | `Hunting in Skyrim.esp` |
| Wounds | `Wounds.esp` |

Shovels Bury Bodies, Pilgrim/Wintersun prayer, CACO, CCOR and Honed Metal are
handled inside `TimeFliesMain` rather than as separate support scripts.

`TF-AEFishing Patch.esp` is an optional ESL-flagged patch that adjusts the AE
Fishing slaughterfish food record. It masters `ccBGSSSE001-Fish.esm`, so only
enable it if you have the AE fishing content.

## Recommendations

* A lower `timescale` (6 or so) makes the whole thing feel less silly.
* A time widget such as A Matter of Time.
* Complete Crafting Overhaul Remastered for bulk production, so a stack of
  arrows is one time cost rather than a hundred.

## Building

Requires the Papyrus compiler from the Skyrim SE Creation Kit. `skyrimse.ppj` is
a [Pyro](https://github.com/fireundubh/pyro) project; the VS Code
[papyrus-lang](https://marketplace.visualstudio.com/items?itemName=joelday.papyrus-lang-vscode)
extension bundles Pyro and provides a build task.

```
pyro --input-path skyrimse.ppj --game-path <path to a Skyrim install with a Papyrus Compiler folder>
```

Imports resolve against `Scripts/Source` and the game's `Data/Scripts/Source`,
which must contain `PapyrusVR.psc` (Skyrim VR Tools) and `SKI_ConfigBase.psc`
(SkyUI). Compiled `.pex` files are committed alongside their sources.

See `.claude/docs/build-and-deploy.md` for the full setup, including what to do
when no Creation Kit is installed.

## Known issues

* Unnecessary time can pass when separating a backpack or removing a bedroll
  from a tent. Detection relies on the item-removed event firing before the
  item-added event, which is not guaranteed. Use the pause hotkey if it bites.
* `handle_using_furniture` only sets the workstation flag if the crafting menu
  is already open when `OnSit` fires. If the menu is slow, that craft costs
  nothing. Unfixed, and inherited from upstream.
* Support scripts detect their mod with `Game.GetModByName`, which returns 255
  for ESL/ESPFE plugins. If a supported mod is light-flagged in your load order,
  its support silently disables itself.
* Debug tracing is always on (`debug_mode = True` in `TimeFliesMain` and
  `TimeFliesMCM`). Useful for diagnosis, noisy in `Papyrus.0.log`.

## Credits

All credit to Akezhar for Living Takes Time and to dfxyz for Time Flies SE —
this fork is a thin VR layer over their work.

Also to dragonsong, DrPastah, mlheur and everyone else who built
mod-compatible versions of Living Takes Time, and to CylonSurfer for
Skyrim VR Tools.

Original mod is distributed with no permissions required — modify and
redistribute freely.

## Posters

![Crafting Takes Time](./Pictures/crafting_takes_time.png)

![Reading Takes Time](./Pictures/reading_takes_time.png)

![Trading Takes Time](./Pictures/trading_takes_time.png)

![Eating and Drinking Take Time](./Pictures/eating_and_drinking_take_time.png)

![Campfire and iNeed Support](./Pictures/campfire_and_ineed_support.png)
