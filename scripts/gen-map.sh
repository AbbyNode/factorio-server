#!/bin/bash
# =============================================================================
# Factorio Map Preview Generator
# =============================================================================
# 
# Generates map preview PNGs using the Factorio Docker container.
# Supports two modes:
#   1. Random mode: Generate many low-detail previews for seed exploration
#   2. Single mode: Generate one high-detail preview for a specific seed
#
# Usage:
#   ./gen-map.sh random [count]     Generate random map previews (default: 100)
#   ./gen-map.sh seed <seed>        Generate high-detail preview for specific seed
#   ./gen-map.sh help               Show this help message
#
# =============================================================================

set -e

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Change to project directory
cd "$PROJECT_DIR"

# Load environment variables if .env exists
if [ -f ".env" ]; then
    set -a
    source .env
    set +a
fi

# Default values
DEFAULT_COUNT="${MAP_PREVIEW_COUNT:-100}"
DEFAULT_SCALE="${MAP_PREVIEW_SCALE:-4}"
DEFAULT_SIZE="${MAP_PREVIEW_SIZE:-512}"
HIGH_DETAIL_SCALE=1
HIGH_DETAIL_SIZE=4096

show_help() {
    echo "Factorio Map Preview Generator"
    echo ""
    echo "Usage:"
    echo "  $0 random [count]     Generate random map previews (default: $DEFAULT_COUNT)"
    echo "  $0 seed <seed>        Generate high-detail preview for specific seed"
    echo "  $0 help               Show this help message"
    echo ""
    echo "Environment variables (set in .env):"
    echo "  MAP_PREVIEW_COUNT     Number of random previews to generate (default: $DEFAULT_COUNT)"
    echo "  MAP_PREVIEW_SCALE     Scale for random previews (default: $DEFAULT_SCALE)"
    echo "  MAP_PREVIEW_SIZE      Size for random previews in pixels (default: $DEFAULT_SIZE)"
    echo ""
    echo "Examples:"
    echo "  $0 random             Generate $DEFAULT_COUNT random previews"
    echo "  $0 random 50          Generate 50 random previews"
    echo "  $0 seed 123456        Generate high-detail preview for seed 123456"
}

generate_random() {
    local count="${1:-$DEFAULT_COUNT}"
    
    echo "=== Generating $count random map previews ==="
    echo "Scale: $DEFAULT_SCALE, Size: ${DEFAULT_SIZE}px"
    echo "Output directory: ./output/maps/"
    
    # Create output directory
    mkdir -p output/maps
    
    # Run the gen-map service with environment overrides
    docker compose --profile gen-map run --rm \
        -e MAP_PREVIEW_COUNT="$count" \
        -e MAP_PREVIEW_SCALE="$DEFAULT_SCALE" \
        -e MAP_PREVIEW_SIZE="$DEFAULT_SIZE" \
        -e MAP_SEED="" \
        gen-map
    
    echo ""
    echo "=== Complete! Check ./output/maps/ for generated previews ==="
    echo ""
    echo "Next steps:"
    echo "  1. Browse the generated previews to find seeds you like"
    echo "  2. Generate high-detail preview: $0 seed <seed>"
    echo "  3. Create world with chosen seed: edit .env and run 'docker compose --profile create-world run create-world'"
}

generate_single() {
    local seed="$1"
    
    if [ -z "$seed" ]; then
        echo "Error: Seed is required"
        echo ""
        show_help
        exit 1
    fi
    
    echo "=== Generating high-detail preview for seed: $seed ==="
    echo "Scale: $HIGH_DETAIL_SCALE, Size: ${HIGH_DETAIL_SIZE}px"
    echo "Output: ./output/maps/seed_${seed}.png"
    
    # Create output directory
    mkdir -p output/maps
    
    # Run the gen-map service with the specific seed
    docker compose --profile gen-map run --rm \
        -e MAP_SEED="$seed" \
        gen-map
    
    echo ""
    echo "=== Complete! High-detail preview generated ==="
    echo ""
    echo "Next steps:"
    echo "  1. View the preview: ./output/maps/seed_${seed}.png"
    echo "  2. Create world with this seed:"
    echo "     - Set MAP_SEED=$seed in .env"
    echo "     - Run: docker compose --profile create-world run create-world"
}

# Parse command
case "${1:-help}" in
    random)
        generate_random "$2"
        ;;
    seed)
        generate_single "$2"
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "Unknown command: $1"
        echo ""
        show_help
        exit 1
        ;;
esac
