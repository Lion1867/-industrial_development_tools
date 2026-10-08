#!/usr/bin/env bash
set -euo pipefail

mkdir -p monitoring-service/{config,logs,alerts,archive,scripts}
printf '%s\n' \
  'SERVICE_NAME=monitoring' 'CHECK_INTERVAL=30' 'CPU_THRESHOLD=80' \
  'MEMORY_THRESHOLD=85' 'DISK_THRESHOLD=90' 'LOG_LEVEL=INFO' \
  > monitoring-service/config/monitoring.conf
touch monitoring-service/logs/system.log monitoring-service/alerts/alerts.log
printf '%s\n' \
  '#!/usr/bin/env bash' 'set -euo pipefail' 'echo "Monitoring check started"' \
  'echo "Checking CPU..."' 'echo "Checking memory..."' 'echo "Checking disk..."' \
  'echo "Monitoring check completed"' \
  > monitoring-service/scripts/check.sh
chmod +x monitoring-service/scripts/check.sh
