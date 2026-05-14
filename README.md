# SpellsTracker-1.12
Spell Tracker for older vanilla wow client private servers 1.12.1
# SpellsTracker

A lightweight spell replay addon for **World of Warcraft 1.12.1** clients.

Originally created for **VanillaPlus.org**, but should work on any Vanilla 1.12 client including:

* Turtle WoW
* VanillaPlus
* Nostalrius-style clients
* Kronos
* Elysium
* other 1.12 private servers

---

## What is it?

SpellsTracker is a very simple Vanilla-compatible version of the old **SpellReplay** addons that existed for TBC/WotLK.

It displays your recently cast spells as icons in a horizontal row on your screen.

The addon was mainly created so I could visually verify that my **Lua macros / SuperMacro rotations** were actually casting the correct spells in combat.

It also works nicely for:

* streamers
* PvP videos
* spell rotation tracking
* UI minimalists
* macro debugging

---

## Features

* Works on the original **1.12.1 client**
* Tracks:

  * direct damage spells
  * heals
  * buffs
  * instant casts
  * DoTs
  * macro-triggered casts
* Supports old Vanilla macro systems including **SuperMacro**
* Shows the last 5 spells cast
* Icons automatically fade after a few seconds
* Movable UI
* Lightweight and minimal

---

## Commands

### Toggle addon

```bash
/st
```

Shows or hides the tracker.

---

### Move the tracker

```bash
/stmove
```

Enables move mode so you can drag the tracker anywhere on your screen.

Type `/stmove` again to lock it in place.

---

## Installation

1. Download the addon
2. Extract the `SpellsTracker` folder
3. Place it into:

```bash
World of Warcraft/Interface/AddOns/
```

4. Restart WoW or reload UI

---

## Why this addon exists

Most modern spell replay addons rely on:

* `COMBAT_LOG_EVENT_UNFILTERED`
* modern combat log APIs
* newer Lua functions

None of those exist on the original Vanilla client.

This addon was rewritten specifically around the limitations of the original 1.12 API.

---

## Notes

This addon intentionally keeps things simple and lightweight.

It is not trying to fully recreate modern combat replay systems — just provide a clean Vanilla-era spell tracker that works reliably with old clients and macro systems.
