#!/bin/bash
# Deploy mod to CK3 local mod folder for testing.
# Appends " - DEV" to the mod name so it doesn't conflict with the Steam Workshop version.

SRC_DIR="$(cd "$(dirname "$0")" && pwd)"
CK3_DIR="$HOME/Documents/Paradox Interactive/Crusader Kings III"
MOD_DIR="$CK3_DIR/mod/send_gold_to_player"

# Sync mod folder contents
rsync -av --delete \
  "$SRC_DIR/send_gold_to_player/" \
  "$MOD_DIR/"

# Sync .mod file (with absolute path and DEV name)
sed \
  -e 's/name="Send Gold to Player"/name="Send Gold to Player - DEV"/' \
  -e 's|path="mod/send_gold_to_player"|path="'"$MOD_DIR"'"|' \
  "$SRC_DIR/send_gold_to_player.mod" > "$CK3_DIR/mod/send_gold_to_player.mod"

# Patch descriptor.mod inside mod folder with DEV name
sed -i '' \
  's/name="Send Gold to Player"/name="Send Gold to Player - DEV"/' \
  "$MOD_DIR/descriptor.mod"

echo "Deployed to $MOD_DIR"
