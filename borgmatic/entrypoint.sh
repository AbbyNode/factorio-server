#!/bin/bash
set -e

# =============================================================================
# Borgmatic Entrypoint Script for Factorio Server Backups
# =============================================================================

# Variables
BACKUP_NAME="${BACKUP_NAME:-factorio}"
REPO_PATH="/mnt/borg-repository/${BACKUP_NAME}"

BORGMATIC_CONFIG_DIR="/etc/borgmatic.d"
BORGMATIC_CONFIG="${BORGMATIC_CONFIG_DIR}/config.yaml"

BORG_PASSPHRASE_FILE="/run/secrets/borg_passphrase"

echo "========== Borgmatic Container Starting =========="
echo "Backup name: $BACKUP_NAME"
echo "Repository path: $REPO_PATH"

# Check if borg passphrase file exists and has valid content
check_passphrase() {
    if [ ! -f "$BORG_PASSPHRASE_FILE" ]; then
        return 1
    fi
    # Check if file is empty or only contains whitespace/comments
    if ! grep -qv '^[[:space:]]*#' "$BORG_PASSPHRASE_FILE" 2>/dev/null || \
       [ ! -s "$BORG_PASSPHRASE_FILE" ]; then
        return 1
    fi
    return 0
}

if ! check_passphrase; then
    echo "WARNING: Borg passphrase file is missing, empty, or only contains comments"
    echo "Will use 'none' encryption mode (no encryption)"
    unset BORG_PASSCOMMAND
    : "${BORG_ENCRYPTION:=none}"
else
    echo "Valid passphrase found. Will use 'repokey' encryption mode."
    export BORG_PASSCOMMAND="cat $BORG_PASSPHRASE_FILE"
    : "${BORG_ENCRYPTION:=repokey}"
fi

# Check if repository exists, if not initialize it
if [ ! -d "$REPO_PATH" ]; then
    echo "Repository does not exist at $REPO_PATH. Creating..."
    
    # Create directory if needed
    mkdir -p "$REPO_PATH"
    
    echo "Using encryption mode: $BORG_ENCRYPTION"
    
    # Initialize the repository
    borgmatic init --encryption "$BORG_ENCRYPTION" --repository "$REPO_PATH"
    
    echo "Repository initialized successfully"
else
    echo "Repository already exists at $REPO_PATH"
fi

# Execute the original borgmatic entrypoint from borgmatic-collective/docker-borgmatic
echo "Starting borgmatic service..."
exec /init "$@"
