#!/usr/bin/env bash
# gen_logs.sh - create a fake nginx access log for practice
set -euo pipefail

OUT="${1:-access.log}"
ips=(10.0.0.1 10.0.0.2 10.0.0.3 192.168.1.10 192.168.1.20 172.16.0.5)
paths=(/ /login /api/users /api/orders /health /static/app.js)
codes=(200 200 200 200 301 404 500 502)

: > "$OUT"
for i in $(seq 1 1000); do
  ip=${ips[RANDOM % ${#ips[@]}]}
  path=${paths[RANDOM % ${#paths[@]}]}
  code=${codes[RANDOM % ${#codes[@]}]}
  size=$((RANDOM % 5000 + 200))
  echo "$ip - - [$(date '+%d/%b/%Y:%H:%M:%S %z')] \"GET $path HTTP/1.1\" $code $size \"-\" \"curl/8.5\"" >> "$OUT"
done
echo "Wrote 1000 lines to $OUT"

