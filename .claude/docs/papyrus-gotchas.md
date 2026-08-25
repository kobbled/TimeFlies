# Papyrus gotchas

Traps that have actually caused bugs in this repo, not a general language guide.

## Line continuations

A continuation is a trailing `\` that must be the **last** character on the
line. Trailing whitespace after it is a syntax error waiting to happen. Seven
upstream lines have it and survive only by luck — as of this writing
`TFBasicCampGear.psc:290`, `TFCampsite.psc:197` and `TimeFliesMain.psc` lines
453, 974, 1279, 1330, 1341, though those drift with every edit. Find them:

```python
import io, glob
BS = chr(92)
for f in sorted(glob.glob('Scripts/Source/*.psc')):
    s = io.open(f, encoding='utf-8', newline='').read().replace('\r\n', '\n')
    for i, l in enumerate(s.split('\n'), 1):
        if l.rstrip().endswith(BS) and l != l.rstrip():
            print(f'{f}:{i}')
```

When scripting an edit, **backslashes do not survive the shell reliably**. This
environment applies an extra round of unescaping, so `grep -P '\\[ \t]+$'`
silently matches nothing while `'\\\\[ \t]+$'` works — which is why the check
above is Python rather than grep. The same hazard applies to heredocs: a
swallowed `\` flattens a multi-line condition onto one line, which is still
valid Papyrus, so **the compiler will not catch it**.

Build continuations with `chr(92)`, and check for flattening afterwards:

```bash
awk 'length($0)>140 {print FILENAME":"NR}' Scripts/Source/*.psc
```

## Save-game compatibility

Scripts are baked into saves. What is safe to change:

| Change | Safe on an existing save? |
|---|---|
| Add a script variable | yes — initialises to its declared default |
| Add an `Auto` property assigned at runtime | yes |
| Add an `AutoReadOnly` property | yes — compile-time constant, never serialised |
| Add a function or event | yes |
| Rename or retype a variable | **no** — the old value is orphaned |
| Remove a property the ESP fills | **no** |

Prefer `AutoReadOnly Hidden` for constants. It costs nothing in the save and
needs no ESP change, which is why the PapyrusVR button/event constants are
declared that way rather than as initialised variables.

## Native SKSE registrations do not persist

`RegisterForMenu`, `RegisterForKey` and friends are stored in the save and come
back on load. **PapyrusVR's `RegisterForVRButtonEvents` does not** — Skyrim VR
Tools keeps its list in memory with no co-save serialisation.

Anything tracking registration state in a script variable will therefore lie
after a load: the variable says registered, the plugin has forgotten. Clear it
in `OnPlayerLoadGame` and register again. That is exactly what
`handle_loadgame` does with `vr_registered`.

## Events on one script are serialised

A script instance processes one event at a time. `Utility.Wait` inside an event
holds the queue for that object, and external function calls into it block too.

`TimeFliesPlayerAlias.OnItemAdded` calls `main.handle_added_item(...)`
synchronously, so a `Utility.Wait(2.0)` running in `TimeFliesMain.OnVRButtonEvent`
delays the item handling behind it. The original VR handler waited 2s on every
button *and touch* event from both controllers — up to four stacked waits per
trigger pull. Keep waits out of high-frequency handlers, and filter before
waiting, never after.

## Functions with a declared return type and no return

Papyrus warns but compiles, returning the zero value. Present in
`TimeFliesMain.collect_skills()`, `evaluate_skill_change()` and one branch of
`TFSunHelm.handle_removed_item()`. Harmless where the result is ignored;
do not copy the pattern.

## `Game.GetModByName` and light plugins

Returns 255 for ESL/ESPFE plugins. Every `TF*` support script uses it to detect
its mod and bails on 255, so a light-flagged supported mod silently disables its
own support. `Game.GetFormFromFile` *does* work with light plugins — only the
index lookup is broken.

Related: `get_prefix(form)` returns `formID >> 24`, which is `0xFE` for **every**
ESL form regardless of which plugin it came from. Prefix comparison cannot
distinguish light plugins from one another.

## `Game.GetFormFromFile` form IDs

Only the low three bytes are used; the top byte is replaced with the plugin's
load index. So `0x1CCA105` and `0xCCA105` resolve identically — a 7-digit ID is
a sign someone pasted a full form ID from xEdit without stripping the index.

Getting the *plugin* wrong is the more common error and fails silently,
returning `None`. Upstream 8.2.2 fixed a batch of these where Survival Mode
records were being looked up in CACO rather than `Update.esm`.

## `Debug.Notification` does not translate

It takes a literal string. `$key` translation only happens for MCM strings
rendered by SkyUI. `TimeFliesMCM` calls
`Debug.notification("$mod_not_enabled")`, which displays the raw key —
pre-existing, cosmetic, unfixed.

## Translation file encoding

`Interface/Translations/TimeFlies_ENGLISH.txt` is **UTF-16LE with a BOM and CRLF
line endings**, key and value separated by a **tab**. Reading or writing it as
UTF-8 corrupts it. In Python:

```python
s = open(path, 'rb').read().decode('utf-16')
...
open(path, 'wb').write(s.encode('utf-16'))
```

Any `$key` a script references must exist here or the MCM renders the raw key.

## `pass_time` early-returns on non-positive input

```papyrus
if time_passed <= 0 || is_paused
    return
endif
```

Any arithmetic that can go zero or negative therefore fails **silently** —
no notification, no log line, no time. This is what made
`item_value_multiplier` look like "crafting sometimes does nothing" rather than
like a maths bug. When time mysteriously does not pass, check the sign of the
multiplier chain before anything else.
