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
        --map-preview-scale 1 \
        --map-preview-size 4096
else
    echo "Generating ${MAP_PREVIEW_COUNT:-100} random map previews..."
    echo "Scale: ${MAP_PREVIEW_SCALE:-4}, Size: ${MAP_PREVIEW_SIZE:-512}"
    /opt/factorio/bin/x64/factorio \
        --generate-map-preview "/output/preview.png" \
        --map-gen-settings /factorio/config/map-gen-settings.json \
        --map-preview-count "${MAP_PREVIEW_COUNT:-100}" \
        --map-preview-scale "${MAP_PREVIEW_SCALE:-4}" \
        --map-preview-size "${MAP_PREVIEW_SIZE:-512}"
fi

echo "=== Map previews generated in /output ==="
ls -la /output/*.png 2>/dev/null || echo "No PNG files found"
