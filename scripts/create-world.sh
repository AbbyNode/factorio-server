#!/bin/sh
# =============================================================================
# Factorio World Creation Script (runs inside container)
# =============================================================================
set -e

echo "=== Factorio World Creator ==="

SAVE_NAME="${SAVE_NAME:-world}"
SAVE_FILE="/factorio/saves/${SAVE_NAME}.zip"

if [ -f "$SAVE_FILE" ]; then
    echo "WARNING: Save file already exists at $SAVE_FILE"
    echo "Delete or rename it first if you want to create a new world."
    exit 1
fi

# Build command arguments array-style to avoid eval
FACTORIO_BIN="/opt/factorio/bin/x64/factorio"
ARGS="--create $SAVE_FILE --map-gen-settings /factorio/config/map-gen-settings.json --map-settings /factorio/config/map-settings.json"

if [ -n "${MAP_SEED:-}" ]; then
    echo "Using seed: $MAP_SEED"
    ARGS="$ARGS --map-gen-seed $MAP_SEED"
else
    echo "Using random seed"
fi

echo "Creating world: $SAVE_FILE"
$FACTORIO_BIN $ARGS

echo "=== World created successfully ==="
ls -la /factorio/saves/
