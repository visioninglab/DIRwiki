#!/bin/bash
# Archive daily snapshot of latest readings for trend analysis
# Runs daily at 23:55 UTC — no API call, just copies local data

set -euo pipefail

HISTORY_DIR="_data/water-quality/history"
SOURCE="_data/water-quality/latest-readings.json"
TODAY=$(date -u +%Y-%m-%d)
DEST="${HISTORY_DIR}/${TODAY}.json"

mkdir -p "$HISTORY_DIR"

if [ -f "$SOURCE" ]; then
  cp "$SOURCE" "$DEST"
  echo "Archived readings snapshot to $DEST"
else
  echo "WARNING: No latest-readings.json to archive"
fi

# Cleanup: keep only last 90 days
echo "Cleaning up archives older than 90 days..."
find "$HISTORY_DIR" -name "*.json" -type f -mtime +90 -delete 2>/dev/null || true
REMAINING=$(ls -1 "$HISTORY_DIR"/*.json 2>/dev/null | wc -l)
echo "Archive contains $REMAINING daily snapshots"
