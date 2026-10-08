#!/bin/bash

echo "Starting Web Application..."
SCRIPT_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"
APP_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
python3 "$APP_DIR/app/main.py"
echo "Web Application stopped"
