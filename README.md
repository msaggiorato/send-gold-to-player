# Send Gold to Player - CK3 Mod

**Compatible with CK3 1.17.x**

A mod that allows you to send gold to other characters with granular amount selection.

## Features

- **12 Amount Options**: 1, 5, 10, 25, 50, 100, 250, 500, 1000, 2500, 5000, or ALL gold
- **Game Rule**: Choose at game start whether to allow sending to AI or only players
- **Notifications**: Both sender and recipient get toast notifications
- **Multiplayer Ready**: All players need the mod installed
- **Localized**: English and Spanish

## How to Get Exact Amounts

While you can't type a specific number, you can combine multiple sends:

**Example - Send 177 gold:**
1. Send 100 gold
2. Send 50 gold  
3. Send 25 gold
4. Send 1 gold
5. Send 1 gold
= 177 gold total

## Game Rule

When starting a new game, go to **Game Rules** and find **"Send Gold: Target Restriction"**:

| Option | Description |
|--------|-------------|
| **Players Only** (default) | Only send to human players |
| **All Characters** | Send to any character including AI |

## Installation

### Step 1: Extract the ZIP

### Step 2: Copy to your CK3 mod folder

**Windows:**
```
Documents\Paradox Interactive\Crusader Kings III\mod\
```

**Mac:**
```
~/Documents/Paradox Interactive/Crusader Kings III/mod/
```

**Linux:**
```
~/.local/share/Paradox Interactive/Crusader Kings III/mod/
```

### Step 3: Structure should be:

```
mod/
├── send_gold_to_player.mod          ← Launcher file
└── send_gold_to_player/             ← Mod folder
    ├── descriptor.mod
    ├── common/
    │   ├── character_interactions/
    │   │   └── send_gold_interaction.txt
    │   ├── game_rules/
    │   │   └── send_gold_rules.txt
    │   └── scripted_effects/
    │       └── send_gold_effects.txt
    └── localization/
        ├── english/
        │   └── send_gold_l_english.yml
        └── spanish/
            └── send_gold_l_spanish.yml
```

### Step 4: Enable in Launcher

1. Launch CK3
2. Go to **Mods** in the launcher
3. Enable **"Send Gold to Player"**
4. Play!

## How to Use

1. Right-click on a character's portrait
2. Go to **Diplomacy** menu
3. Select **"Send Gold"**
4. Choose an amount from the checkboxes
5. Click **Send**

## Multiplayer

**All players need the mod installed.** The game verifies matching files.

## Compatibility

- **CK3 Version:** 1.17.x
- **Ironman:** Works (but no achievements with mods)
- **Save Games:** Safe to add mid-game

## Why No Text Input?

CK3's modding system doesn't support text input fields that scripts can read. The send_option system (checkboxes) is the most reliable way to let players choose values. I've included many granular options so you can get close to any amount.

## Troubleshooting

**Interaction not showing?**
- Check game rule setting (might be "Players Only")
- Make sure target is a valid character

**Text showing as codes?**
- Verify .yml files have UTF-8-BOM encoding
- Re-download the mod

## License

Free to use, modify, and share.

---

¡Disfruta enviando oro a tus amigos! 🪙
