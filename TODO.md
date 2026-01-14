# Factorio server (Docker) — TODO

## Purpose

This file is the single-spec for converting the existing Factorio server setup into a container-first deployment using docker-compose, with automated borgmatic backups, containerized map generation, and convenient mod management (no manual SCP of mod files).

This document is a specification and implementation checklist for an automated agent (GitHub Copilot / developer) to follow.

## Goals

- Use docker-compose with existing public Factorio server images (no custom Dockerfiles unless absolutely necessary).
- Provide borgmatic backup instructions adapted from `archive/Example-Minecraft`.
- Provide a docker-compose "profile" or service that can run a one-off container to generate map PNGs (replacement for `gen-map.sh`) and which respects mods and map-generation settings.
- Allow world generation with a given seed via a simple `.env` file.
- Let the server automatically install mods (by mod-id and optional auth token) rather than requiring manual uploads.
- Before working, read the repository and prior non-container server notes in `archive/`.

## End User Workflow

1. Clone the repository.
2. Set .env and any other configs to set what mods should be used and such
3. Run the map-gen script to generate a bunch low-detailed PNGs of map ideas. Select seeds and put them in a config or command to generate high-detail PNGs maps of the selected seeds.
4. Use one final selected seed to generate the world save.
5. Start the server.
6. Backups run automatically via borgmatic.

## High-level approach / files to add

IMPORTANT: You may deviate in any way required while building out this solution. Focus on the goals above. The instructions below are simply an idea on how it might be attainable. You will need to research what tools are available, how Factorio server images work, and how to best implement mod downloading and map generation.
If Factorio itself OR the Factorio docker image provides a way to download mods easily, use that. Avoid custom made solutions if an existing solution exists that we can integrate.

We will likely want to use factoriotools/factorio, but look into what other options exist before you commit to that.


The agent should create these artifacts:

- `docker-compose.yml` — primary compose stack. Use existing images; include services:
  - `factorio` (server)
  - `borgmatic` (backup runner)
  - (maybe?) `mods-downloader` (helper container or one-off job)
  - `gen-map` profile/service for generating PNGs.
- `.env.example` — list configurable env vars (SEED, MAP_NAME, FACTORIO_IMAGE, MOD_IDS, MOD_PORTAL_TOKEN, BACKUP_REPO, BACKUP_SCHEDULE, etc.).
- (maybe?) `scripts/fetch-mods.sh` — script that downloads mods from the Factorio mod portal using a list of mod IDs + token into a `mods/` directory.
- `scripts/gen-map.sh` (container-friendly) — wraps `docker compose run --profile gen-map ...` or `docker compose run gen-map` and accepts seed / mod-list / map-gen-settings.
- `borgmatic/` — borgmatic config (use Example-Minecraft's layout as reference). Keep sensitive keys out of repo; use env or secrets.
- Anything else as required to meet the goals.

## Docker-compose design notes (templates)

Provide a `factorio` service using a public image and bind mounts for persistent data. Example (replace placeholders):

Notes:

- Use the official/most-updated Factorio server image you prefer; leave the image as an env variable so the agent can pick one (or search Docker Hub).
- The `mods` volume is probably a host directory which will be populated by `fetch-mods.sh` and mounted to the container so Factorio will pick them up. If the chosen image supports auto-download via environment variables, that should be used instead.

## Mod management strategy

Goal: control mods by ID (no manual file copy).

Recommended flow:

The end user server admin should be able to specify which mods to use via some kind of config or in the .env file. The server admin should not have to manually upload mod files.

## World creation

need a way to generate a new world with a given seed

Use Factorio's CLI to create a save with a given seed and optional map-gen-settings JSON.

## Map PNG generation

Provide a `gen-map` profile/service in `docker-compose.yml` that runs in a one-shot mode that generates a map preview PNG or uses a small helper tool to convert the save to a PNGs.

Read the gen-map.sh file in the archive, that's how I used to do it before containerizing.

Compatibility with mods

- Because mods can change entity placement and map generation, `gen-map` must run after the exact mod set is installed.
- The gen-map must be able to access mods somehow, and be configured to use them in the png generation.

## Borgmatic backups

Follow the layout and examples from `archive/Example-Minecraft/borgmatic/`.

## Agent instructions

Before implementing any of the above, fully read the repository tree and the `archive/` files. The archive contains a portion of a model for borgmatic and a docker-compose layout that should be referenced for the structure, not blindly copied. Also look at the existing `gen-map.sh` and Factorio-related notes and include or migrate relevant content.
