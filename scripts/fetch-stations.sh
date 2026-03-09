#!/bin/bash
# Fetch all active monitoring stations from EA Flood Monitoring API
# Runs weekly — station metadata rarely changes

set -euo pipefail

API_BASE="https://environment.data.gov.uk/flood-monitoring"
OUT_FILE="_data/water-quality/stations.json"

echo "Fetching active stations..."

# Fetch all active stations (paginated, up to 10000)
RAW=$(curl -sf -H "Accept: application/json" \
  "${API_BASE}/id/stations?status=Active&_limit=10000" 2>/dev/null || echo "")

if [ -z "$RAW" ]; then
  echo "ERROR: Failed to fetch stations from EA API"
  exit 1
fi

# Transform to simplified format using node (available on ubuntu-latest)
node -e "
const data = JSON.parse(process.argv[1]);
const stations = (data.items || []).map(s => ({
  id: s.notation || s.stationReference || '',
  label: s.label || '',
  river: s.riverName || '',
  catchment: s.catchmentName || '',
  town: s.town || '',
  lat: s.lat || null,
  lng: s.long || null,
  type: (s.type || '').toString().split('/').pop() || 'Unknown',
  dateOpened: s.dateOpened || '',
  measures: (Array.isArray(s.measures) ? s.measures : (s.measures ? [s.measures] : [])).map(m => ({
    id: (m.notation || m['@id'] || '').toString().split('/').pop(),
    parameter: m.parameter || '',
    parameterName: m.parameterName || '',
    qualifier: m.qualifier || '',
    unit: m.unitName || '',
    period: m.period || null
  }))
})).filter(s => s.lat && s.lng);

const output = {
  stations: stations,
  meta: {
    fetched: new Date().toISOString(),
    count: stations.length,
    source: 'EA Flood Monitoring API v0.9',
    apiUrl: '${API_BASE}/id/stations'
  }
};

process.stdout.write(JSON.stringify(output, null, 2));
" "$RAW" > "$OUT_FILE"

COUNT=$(node -e "const d=JSON.parse(require('fs').readFileSync('$OUT_FILE','utf8')); console.log(d.meta.count)")
echo "Wrote $COUNT stations to $OUT_FILE"
