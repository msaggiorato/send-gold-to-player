# Send Gold to Player - CK3 Mod

A mod that allows you to send **any exact amount** of gold to other characters using an intuitive +/- button interface.

## Features

- **Exact Amount Selection**: Use +1, +10, +100 and -1, -10, -100 buttons to dial in any precise amount
- **Quick Buttons**: Min (1 gold) and Max (all your gold) for convenience
- **Game Rule Option**: Choose at game start whether to allow sending gold to AI characters or only human players
- **Notifications**: Both sender and recipient receive toast notifications
- **Multiplayer Ready**: Designed for multiplayer games
- **Localized**: Available in English and Spanish

## Game Rule

When starting a new game, go to **Game Rules** and find **"Send Gold Target Restriction"**:

| Option | Description |
|--------|-------------|
| **Players Only** (default) | Can only send gold to human players |
| **All Characters** | Can send gold to any character including AI |

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

### Step 3: Final structure should be:

```
mod/
├── send_gold_to_player.mod          ← Launcher file (in mod folder root)
└── send_gold_to_player/             ← Mod folder
    ├── descriptor.mod
    ├── common/
    │   ├── character_interactions/
    │   │   └── send_gold_interaction.txt
    │   ├── game_rules/
    │   │   └── send_gold_rules.txt
    │   └── scripted_guis/
    │       └── send_gold_gui.txt
    ├── gui/
    │   └── send_gold_window.gui
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
4. The Send Gold window will open
5. Use the **+/-** buttons to select the exact amount
6. Click **Send** to transfer the gold

## Multiplayer

**All players need the mod installed.** CK3 verifies that all players have matching files (checksum).

1. Share this ZIP with all players
2. Everyone installs the mod
3. Host enables the mod and sets the game rule
4. All players can now send gold to each other!

## Compatibility

- **CK3 Version:** 1.12.* (and likely newer versions)
- **Ironman:** Not compatible (mods disable achievements)
- **Save Games:** Safe to add to existing saves

## Troubleshooting

**Window doesn't appear?**
- Make sure you clicked "Send Gold" from the diplomacy menu
- The window should appear automatically after selecting the interaction

**Can't see AI characters?**
- Check the game rule - it might be set to "Players Only"
- Start a new game and change the rule to "All Characters"

**Localization shows codes instead of text?**
- Make sure the .yml files have UTF-8-BOM encoding
- Re-download the mod if needed

## License

Free to use, modify, and redistribute.

---

**¡Disfruta enviando oro a tus amigos!** 🪙
