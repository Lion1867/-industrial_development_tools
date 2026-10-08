#!/usr/bin/env bash
set -euo pipefail

mkdir -p web-app/{app,config,logs,backup,scripts}
printf '%s\n' \
  'APP_NAME=web-app' 'APP_VERSION=1.0' 'HOST=0.0.0.0' 'PORT=8080' \
  'LOG_LEVEL=INFO' 'DEBUG=false' 'DATABASE_HOST=localhost' 'DATABASE_PORT=5432' \
  > web-app/config/app.conf
printf '%s\n' \
  '"""Application entry point."""' \
  > web-app/app/main.py
printf '%s\n' \
  '#!/usr/bin/env bash' \
  'SCRIPT_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"' \
  'python3 "$SCRIPT_DIR/../app/main.py"' \
  > web-app/scripts/start.sh
chmod +x web-app/scripts/start.sh
printf '%s\n' '# WEB APPLICATION' '' 'Application: web-app' 'Version: 1.0' 'Port: 8080' '' 'Configuration: config/app.conf' 'Logs: logs/application.log' 'Start script: scripts/start.sh' > web-app/README.md
touch web-app/logs/application.log
