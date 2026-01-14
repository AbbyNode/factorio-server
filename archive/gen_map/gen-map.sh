#!/bin/bash

mode="$1"   # normal | random

if [[ "$mode" != "normal" && "$mode" != "random" ]]; then
  echo "Usage: $0 {normal|random}"
  exit 1
fi

dirServer="$HOME/Games/Servers/Factorio"
world="MapGen"

configDir="$dirServer/config/$world"
config="$configDir/config.ini"

factorio_bin="$HOME/.steam/steam/steamapps/common/Factorio/bin/x64/factorio"

if [[ "$mode" == "normal" ]]; then
  read -p "Seed: " seed
  read -p "Name Prefix: " name

  scale=1
  size=4096
  mapGenSettings="map-gen-settings.json"

  dirMap="${name}_scale-${scale}_size-${size}/"
  mkdir -p "$dirMap"

  "$factorio_bin" \
    --map-gen-settings "$mapGenSettings" \
    --map-preview-scale "$scale" \
    --map-preview-size "$size"

else
  count=100
  name="BruhOhMomentMoment"
  scale=4
  size=512

  dirMap="${name}_scale-${scale}_size-${size}/"
  mkdir -p "$dirMap"

  "$factorio_bin" \
    --map-preview-count "$count" \
    --map-preview-scale "$scale" \
    --map-preview-size "$size"
fi

read -p "Press Enter to exit..."
