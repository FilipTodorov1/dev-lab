#!/usr/bin/env bash
# healthcheck.sh - check a URL and disk usage, log the result
set -euo pipefail

URL="${1:-http://localhost:8081}"
DISK_LIMIT="${DISK_LIMIT:-80}"
LOG_FILE="${LOG_FILE:-$HOME/healthcheck.log}"

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') [$1] $2" | tee -a "$LOG_FILE"
}

check_url() {
  local code
  code=$(curl -s -o /dev/null -w '%{http_code}' --max-time 5 "$URL" || true)
  if [[ "$code" == "200" ]]; then
    log OK "$URL returned $code"
  else
    log ERROR "$URL returned $code"
    return 1
  fi
}

check_disk() {
  local usage
  usage=$(df --output=pcent / | tail -1 | tr -dc '0-9')
  if (( usage > DISK_LIMIT )); then
    log WARN "Disk usage on / is ${usage}% (limit ${DISK_LIMIT}%)"
    return 1
  else
    log OK "Disk usage on / is ${usage}%"
  fi
}

status=0
check_url || status=1
check_disk || status=1
exit "$status"
