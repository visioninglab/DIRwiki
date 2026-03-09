#!/bin/bash
# Update data-meta.json with fetch timestamps and status

set -euo pipefail

FETCH_TYPE="${1:-unknown}"
META_FILE="_data/water-quality/data-meta.json"
NOW=$(date -u +%Y-%m-%dT%H:%M:%SZ)

# Count records if files exist
STATION_COUNT=0
READING_COUNT=0
WARNING_COUNT=0

if [ -f "_data/water-quality/stations.json" ]; then
  STATION_COUNT=$(node -e "console.log(JSON.parse(require('fs').readFileSync('_data/water-quality/stations.json','utf8')).meta.count || 0)" 2>/dev/null || echo "0")
fi

if [ -f "_data/water-quality/latest-readings.json" ]; then
  READING_COUNT=$(node -e "console.log(JSON.parse(require('fs').readFileSync('_data/water-quality/latest-readings.json','utf8')).meta.count || 0)" 2>/dev/null || echo "0")
fi

if [ -f "_data/water-quality/flood-warnings.json" ]; then
  WARNING_COUNT=$(node -e "console.log(JSON.parse(require('fs').readFileSync('_data/water-quality/flood-warnings.json','utf8')).meta.count || 0)" 2>/dev/null || echo "0")
fi

HISTORY_COUNT=$(ls -1 _data/water-quality/history/*.json 2>/dev/null | wc -l || echo "0")

cat > "$META_FILE" <<EOF
{
  "lastFetch": "$NOW",
  "fetchType": "$FETCH_TYPE",
  "stationCount": $STATION_COUNT,
  "readingCount": $READING_COUNT,
  "warningCount": $WARNING_COUNT,
  "historyDays": $HISTORY_COUNT,
  "apiVersion": "0.9",
  "source": "EA Flood Monitoring API",
  "licence": "Open Government Licence v3.0"
}
EOF

echo "Updated $META_FILE (stations: $STATION_COUNT, readings: $READING_COUNT, warnings: $WARNING_COUNT)"
