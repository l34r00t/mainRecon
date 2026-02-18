#!/bin/bash
set -euo pipefail

CONTAINER_NAME="mainrecon"
IMAGE_NAME="mainrecon"
DATA_DIR="${MAINRECON_DATA_DIR:-$(pwd)/data}"

mkdir -p "$DATA_DIR"

# Load tokens from .env if it exists
ENV_ARGS=()
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -f "$SCRIPT_DIR/.env" ]; then
    while IFS='=' read -r key value || [[ -n "$key" ]]; do
        [[ -z "$key" || "$key" =~ ^# ]] && continue
        ENV_ARGS+=(-e "$key=$value")
    done < "$SCRIPT_DIR/.env"
fi

# Check that the image has been built
if ! docker image inspect "$IMAGE_NAME" &>/dev/null; then
    echo "[-] Image '$IMAGE_NAME' not found. Run ./rebuild.sh first." >&2
    exit 1
fi

# Stop previous container if still running
docker rm -f "$CONTAINER_NAME" 2>/dev/null || true

echo "[+] Starting mainRecon — data directory: $DATA_DIR"
docker run --rm --name "$CONTAINER_NAME" \
    -v "$DATA_DIR:/mainData" \
    "${ENV_ARGS[@]+"${ENV_ARGS[@]}"}" \
    "$IMAGE_NAME" \
    "$@"
