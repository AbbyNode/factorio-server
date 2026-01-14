# Factorio Server (Docker)

A containerized Factorio dedicated server setup with automated backups, easy mod management, and convenient map generation tools.

## Features

- 🐳 **Docker-based**: Uses the official `factoriotools/factorio` image
- 🔄 **Automatic mod updates**: Mods download and update automatically from the Factorio mod portal
- 🗺️ **Map preview generation**: Generate map preview PNGs to find the perfect seed
- 💾 **Automated backups**: Borgmatic-based backup system with configurable retention
- ⚙️ **Simple configuration**: All settings via `.env` file and JSON configs

## Quick Start

### 1. Clone and Configure

```bash
git clone <repository-url>
cd factorio-server

# Copy and edit environment configuration
cp .env.example .env
```

Edit `.env` to configure:
- `SAVE_NAME`: Name for your world save
- `MAP_SEED`: Seed for world generation (leave empty for random)
- `USERNAME` / `TOKEN`: Your Factorio.com credentials for mod downloads
- `PORT`: Server port (default: 34197)

### 2. Set Up Mods (Optional)

Place your `mod-list.json` in `./data/mods/` to specify which mods to use:

```json
{
    "mods": [
        { "name": "base", "enabled": true },
        { "name": "your-mod-name", "enabled": true }
    ]
}
```

With `UPDATE_MODS_ON_START=true` and valid `USERNAME`/`TOKEN`, mods will download automatically.

### 3. Generate Map Previews (Optional)

Find the perfect map seed before creating your world:

```bash
# Generate 100 random low-detail previews
./scripts/gen-map.sh random

# Or with a custom count
./scripts/gen-map.sh random 50

# Once you find seeds you like, generate high-detail previews
./scripts/gen-map.sh seed 123456
```

Preview images will be saved to `./output/maps/`.

### 4. Create World

Option A: **Automatic** (when server starts)
```bash
# Set your seed in .env (or leave empty for random)
# The server will create a new world on first start
docker compose up -d factorio
```

Option B: **Manual** (before starting server)
```bash
# Create world with configured settings
docker compose --profile create-world run --rm create-world

# Then start the server
docker compose up -d factorio
```

### 5. Start Server

```bash
docker compose up -d factorio
```

View logs:
```bash
docker compose logs -f factorio
```

Stop server:
```bash
docker compose down
```

### 6. Enable Backups

1. Create a backup passphrase (or leave empty for unencrypted backups):
   ```bash
   mkdir -p .secrets
   echo "your-secure-passphrase" > .secrets/borg_passphrase
   chmod 600 .secrets/borg_passphrase
   ```

2. Start the backup service:
   ```bash
   docker compose up -d borgmatic
   ```

Backups are stored in `./backups/` and run on the schedule defined by `BACKUP_CRON` (default: every 6 hours).

## Directory Structure

```
factorio-server/
├── docker-compose.yml      # Main compose configuration
├── .env                    # Environment variables (create from .env.example)
├── .env.example            # Example environment configuration
├── config/                 # Factorio server configuration
│   ├── map-gen-settings.json
│   ├── map-settings.json
│   └── server-settings.json
├── data/                   # Persistent data (created automatically)
│   ├── saves/              # World save files
│   └── mods/               # Mod files and mod-list.json
├── borgmatic/              # Backup configuration
│   ├── config.yaml
│   └── entrypoint.sh
├── backups/                # Borg backup repository
├── output/                 # Generated content
│   └── maps/               # Map preview PNGs
├── scripts/
│   └── gen-map.sh          # Map preview generation helper
└── .secrets/               # Secret files (not in git)
    └── borg_passphrase     # Backup encryption key
```

## Configuration Reference

### Environment Variables (.env)

| Variable | Default | Description |
|----------|---------|-------------|
| `FACTORIO_IMAGE` | `factoriotools/factorio:stable` | Docker image to use |
| `SAVE_NAME` | `world` | Name of the save file |
| `GENERATE_NEW_SAVE` | `true` | Create new save if none exists |
| `LOAD_LATEST_SAVE` | `true` | Load the latest save on startup |
| `PORT` | `34197` | Game server UDP port |
| `RCON_PORT` | `27015` | RCON TCP port |
| `MAP_SEED` | (empty) | World generation seed |
| `USERNAME` | (empty) | Factorio.com username |
| `TOKEN` | (empty) | Factorio.com API token |
| `UPDATE_MODS_ON_START` | `true` | Auto-update mods on start |
| `MAP_PREVIEW_COUNT` | `100` | Number of random previews |
| `MAP_PREVIEW_SCALE` | `4` | Preview zoom level |
| `MAP_PREVIEW_SIZE` | `512` | Preview size in pixels |
| `BACKUP_NAME` | `factorio` | Backup repository name |
| `BACKUP_CRON` | `0 */6 * * *` | Backup schedule |
| `TZ` | `UTC` | Timezone |

### Server Settings (config/server-settings.json)

Edit this file to configure:
- Server name and description
- Visibility (public/LAN)
- Player limits
- Autosave settings
- Admin permissions

### Map Generation Settings (config/map-gen-settings.json)

Controls world generation:
- Resource frequency, size, and richness
- Enemy base settings
- Starting area size
- Cliff settings
- Moisture and terrain

### Map Settings (config/map-settings.json)

Gameplay settings:
- Pollution mechanics
- Enemy evolution
- Enemy expansion
- Difficulty settings

## Commands Reference

### Server Management

```bash
# Start server
docker compose up -d factorio

# Stop server
docker compose down

# View logs
docker compose logs -f factorio

# Restart server
docker compose restart factorio
```

### Map Generation

```bash
# Generate random previews
./scripts/gen-map.sh random [count]

# Generate high-detail preview for specific seed
./scripts/gen-map.sh seed <seed>

# Or use docker compose directly
docker compose --profile gen-map run --rm gen-map
```

### World Creation

```bash
# Create new world with configured settings
docker compose --profile create-world run --rm create-world
```

### Backups

```bash
# Start backup service
docker compose up -d borgmatic

# Manual backup
docker compose exec borgmatic borgmatic --create --stats

# List backups
docker compose exec borgmatic borgmatic list

# Restore backup
docker compose exec borgmatic borgmatic extract --archive latest --destination /restore
```

## Troubleshooting

### Mods not downloading
- Ensure `USERNAME` and `TOKEN` are set in `.env`
- Get your token from https://factorio.com/profile
- Check that `UPDATE_MODS_ON_START=true`

### World not generating with seed
- Make sure `MAP_SEED` is set in `.env`
- Delete existing save file if you want to regenerate
- Use the `create-world` profile for manual world creation

### Backup errors
- Ensure `.secrets/borg_passphrase` exists (even if empty)
- Check borgmatic logs: `docker compose logs borgmatic`

## Credits

- [factoriotools/factorio-docker](https://github.com/factoriotools/factorio-docker) - Factorio Docker image
- [borgmatic-collective/borgmatic](https://github.com/borgmatic-collective/borgmatic) - Backup solution
- [Factorio](https://factorio.com) - The game

## License

MIT License - See LICENSE file for details.
