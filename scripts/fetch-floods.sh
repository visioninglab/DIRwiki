#!/bin/bash
# Fetch active flood warnings from EA Flood Monitoring API
# Runs every 2 hours

set -euo pipefail

API_BASE="https://environment.data.gov.uk/flood-monitoring"
OUT_FILE="_data/water-quality/flood-warnings.json"

echo "Fetching flood warnings..."

RAW=$(curl -sf -H "Accept: application/json" \
  "${API_BASE}/id/floods" 2>/dev/null || echo "")

if [ -z "$RAW" ]; then
  echo "WARNING: Failed to fetch flood warnings"
  # Write empty warnings rather than failing
  echo '{"warnings":[],"meta":{"fetched":"'$(date -u +%Y-%m-%dT%H:%M:%SZ)'","count":0,"status":"api_unavailable"}}' > "$OUT_FILE"
  exit 0
fi

node -e "
const data = JSON.parse(process.argv[1]);
const warnings = (data.items || []).map(w => ({
  id: (w['@id'] || '').toString().split('/').pop(),
  severity: w.severityLevel || null,
  severityLabel: w.severity || '',
  area: w.floodArea ? (w.floodArea.label || w.floodArea.notation || '') : '',
  areaId: w.floodArea ? (w.floodArea.notation || '') : '',
  county: w.floodArea ? (w.floodArea.county || '') : '',
  message: w.message || '',
  timeRaised: w.timeRaised || '',
  timeSeverityChanged: w.timeSeverityChanged || '',
  timeMessageChanged: w.timeMessageChanged || ''
})).filter(w => w.severity && w.severity <= 3);

const output = {
  warnings: warnings,
  meta: {
    fetched: new Date().toISOString(),
    count: warnings.length,
    source: 'EA Flood Monitoring API v0.9'
  }
};

process.stdout.write(JSON.stringify(output, null, 2));
" "$RAW" > "$OUT_FILE"

COUNT=$(node -e "const d=JSON.parse(require('fs').readFileSync('$OUT_FILE','utf8')); console.log(d.meta.count)")
echo "Wrote $COUNT active flood warnings to $OUT_FILE"
