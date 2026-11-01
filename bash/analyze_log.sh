#!/usr/bin/env bash
# analyze_log.sh - summary of an nginx access log
set -euo pipefail

LOG="${1:?Usage: $0 <access.log>}"
[[ -f "$LOG" ]] || { echo "File not found: $LOG" >&2; exit 1; }

echo "Total requests: $(wc -l < "$LOG")"
echo
echo "Top 10 IPs:"
awk '{print $1}' "$LOG" | sort | uniq -c | sort -rn | head -10
echo
echo "Requests by status code:"
awk '{print $9}' "$LOG" | sort | uniq -c | sort -rn
echo
echo "5xx errors: $(awk '$9 ~ /^5/' "$LOG" | wc -l)"
echo
echo "Paths with the most errors (4xx/5xx):"
awk '$9 >= 400 {print $7}' "$LOG" | sort | uniq -c | sort -rn | head -5
