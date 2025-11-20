#!/usr/bin/env bash

OUT="${OUT:-wrk2_results.jsonl}"

# JSONL → CSV (через jq)
jq -r -s '
  ["ts","label","rps_target","rps_achieved","t","c","dur","p50_ms","p90_ms","p95_ms","p99_ms","non2xx","sock_errs","url"],
  (.[] | [.ts,.label,.rps_target,.rps_achieved,.t,.c,.dur,.p50_ms,.p90_ms,.p95_ms,.p99_ms,.non2xx,.sock_errs,.url])
  | @csv
' "$OUT" > wrk2_results.csv

echo "✓ Done. Results: wrk2_results.csv"
