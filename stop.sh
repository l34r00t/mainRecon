#!/bin/bash
set -euo pipefail

CONTAINER_NAME="mainrecon"

if docker ps -q -f name="$CONTAINER_NAME" | grep -q .; then
    echo "[+] Stopping $CONTAINER_NAME..."
    docker stop "$CONTAINER_NAME"
    docker rm "$CONTAINER_NAME" 2>/dev/null || true
    echo "[+] Stopped."
else
    echo "[-] $CONTAINER_NAME is not running."
fi
