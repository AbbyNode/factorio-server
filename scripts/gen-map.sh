#!/bin/sh
# =============================================================================
# Factorio Map Preview Generation Script (runs inside container)
# =============================================================================
set -e

echo "=== Factorio Map Preview Generator ==="

# If a seed is provided, generate single high-detail preview
if [ -n "${MAP_SEED:-}" ]; then
    echo "Generating preview for seed: $MAP_SEED"
    /opt/factorio/bin/x64/factorio \
        --generate-map-preview "/output/seed_${MAP_SEED}.png" \
        --map-gen-settings /factorio/config/map-gen-settings.json \
        --map-gen-seed "$MAP_SEED" \
        --map-preview-size 4096
else
    echo "Generating ${MAP_PREVIEW_COUNT:-100} random map previews..."
    echo "Size: ${MAP_PREVIEW_SIZE:-512}"
    /opt/factorio/bin/x64/factorio \
        --generate-map-preview "/output/" \
        --map-gen-settings /factorio/config/map-gen-settings.json \
        --generate-map-preview-random "${MAP_PREVIEW_COUNT:-100}" \
        --map-preview-size "${MAP_PREVIEW_SIZE:-512}"
fi

echo "=== Map previews generated in /output ==="
if [ -n "$(find /output -maxdepth 1 -name '*.png' 2>/dev/null)" ]; then
    ls -la /output/*.png
else
    echo "No PNG files found"
fi
