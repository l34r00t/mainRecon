#!/bin/bash
set -euo pipefail

IMAGE_NAME="mainrecon"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "[+] Rebuilding $IMAGE_NAME..."
docker build -t "$IMAGE_NAME" "$SCRIPT_DIR"
echo "[+] Done. Image: $(docker images "$IMAGE_NAME" --format '{{.Size}}')"
