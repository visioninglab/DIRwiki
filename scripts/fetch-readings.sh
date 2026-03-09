#!/bin/bash
# Fetch latest readings from EA Flood Monitoring API
# Runs every 6 hours — single bulk call per EA best practices

set -euo pipefail

API_BASE="https://environment.data.gov.uk/flood-monitoring"
OUT_FILE="_data/water-quality/latest-readings.json"

echo "Fetching latest readings..."

# Single call to ?latest — EA recommended approach
RAW=$(curl -sf -H "Accept: application/json" \
  "${API_BASE}/data/readings?latest&_limit=10000" 2>/dev/null || echo "")

if [ -z "$RAW" ]; then
  echo "ERROR: Failed to fetch readings from EA API"
  exit 1
fi

# Transform to simplified format
node -e "
const data = JSON.parse(process.argv[1]);
const readings = (data.items || []).map(r => {
  const measureId = (r.measure || '').toString().split('/').pop();
  const stationId = measureId.split('-')[0] || '';
  return {
    stationId: stationId,
    measure: measureId,
    value: r.value,
    dateTime: r.dateTime || '',
    date: r.date || ''
  };
}).filter(r => r.value !== undefined && r.value !== null);

const output = {
  readings: readings,
  meta: {
    fetched: new Date().toISOString(),
    count: readings.length,
    source: 'EA Flood Monitoring API v0.9'
  }
};

process.stdout.write(JSON.stringify(output, null, 2));
" "$RAW" > "$OUT_FILE"

COUNT=$(node -e "const d=JSON.parse(require('fs').readFileSync('$OUT_FILE','utf8')); console.log(d.meta.count)")
echo "Wrote $COUNT readings to $OUT_FILE"

# Also fetch rainfall
echo "Fetching rainfall readings..."
RAIN_RAW=$(curl -sf -H "Accept: application/json" \
  "${API_BASE}/data/readings?latest&parameter=rainfall&_limit=10000" 2>/dev/null || echo "")

if [ -n "$RAIN_RAW" ]; then
  node -e "
  const data = JSON.parse(process.argv[1]);
  const readings = (data.items || []).map(r => {
    const measureId = (r.measure || '').toString().split('/').pop();
    const stationId = measureId.split('-')[0] || '';
    return {
      stationId: stationId,
      measure: measureId,
      value: r.value,
      dateTime: r.dateTime || '',
      date: r.date || ''
    };
  }).filter(r => r.value !== undefined && r.value !== null);
  const output = {
    readings: readings,
    meta: { fetched: new Date().toISOString(), count: readings.length, source: 'EA Flood Monitoring API v0.9' }
  };
  process.stdout.write(JSON.stringify(output, null, 2));
  " "$RAIN_RAW" > _data/water-quality/rainfall-latest.json
  echo "Wrote rainfall data"
else
  echo "WARNING: Failed to fetch rainfall data"
fi
