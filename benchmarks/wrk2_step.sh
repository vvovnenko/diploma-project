#!/usr/bin/env bash
# wrk2_step.sh — step-load для wrk2 з парсингом метрик
# Вхідні змінні:
#   URL          — цільовий endpoint (обов’язково)
#   LABEL        — мітка (phpfpm|openswoole|franken...)
#   DUR          — тривалість кроку, напр. 120s (def: 120s)
#   RPS_SERIES   — список RPS, пробілами (def: "500 600 720 860 1030 1240 1490 1790 2150 2580 3090")
#   THREADS      — кількість thread-ів wrk2 (def: nproc)
#   CONNS        — кількість з’єднань (def: 100 * THREADS)
#   OUT          — шлях до JSONL (def: wrk2_results.jsonl)

set -euo pipefail

: "${URL:?set URL}"
LABEL="${LABEL:-target}"
DUR="${DUR:-2m}"
RPS_SERIES="${RPS_SERIES:-300 360 430 500 600 720 860 1030 1240 1490}"
THREADS="${THREADS:-$(nproc)}"
CONNS="${CONNS:-$((THREADS*100))}"
OUT="${OUT:-wrk2_results.jsonl}"
WA_DUR="${WA_DUR:-1m}"
WA_RPS="${WA_RPS:-200}"
SLEEP_SEC="${SLEEP_SEC:-30}"

# warm-up
echo "Warm up ${LABEL}: R=$WA_RPS t=$THREADS c=$CONNS d=$WA_DUR  → ${URL}"
wrk2 -t"$THREADS" -c"$CONNS" -d"$WA_DUR" -R"$WA_RPS" "$URL" > /dev/null 2>&1 || true

for R in $RPS_SERIES; do
  # Cool down
  echo "Cool down for ${SLEEP_SEC} seconds"
  sleep "$SLEEP_SEC"

  TS=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  echo "[$TS] ${LABEL}: R=$R t=$THREADS c=$CONNS d=$DUR  → ${URL}"
  TMP="$(mktemp)"

  # open-loop прогін
  wrk2 -t"$THREADS" -c"$CONNS" -d"$DUR" -R"$R" --latency "$URL" >"$TMP" 2>&1 || true

  # витягуємо перцентилі; конвертуємо до ms (підтримка us/ms/s)
  read P50 P90 P95 P99 <<<"$(awk '
    function to_ms(s){ if(s ~ /us$/){sub(/us$/,"",s);return s/1000}
                       else if(s ~ /ms$/){sub(/ms$/,"",s);return s}
                       else if(s ~ /s$/){sub(/s$/,"",s);return s*1000}
                       else return s }
    /Detailed Percentile spectrum/ {d=1;next}
    d && /0\.500000/ {p50=to_ms($1)}
    d && /0\.900000/ {p90=to_ms($1)}
    d && /0\.950000/ {p95=to_ms($1)}
    d && /0\.990625/ {p99=to_ms($1)}
    END{printf "%s %s %s %s",p50,p90,p95,p99}
  ' "$TMP")"

  # досягнутий req/s, помилки
  RPS_ACT="$(awk '/Requests\/sec/ {print $2; exit}' "$TMP")"
  NON2XX="$(awk -F: '/Non-2xx or 3xx responses/ {gsub(/ /,"");print $2+0}' "$TMP")"
  SOCKERR="$(awk -F: '
    /Socket errors/ {
      gsub(/Socket errors: /,""); tot=0;
      n=split($0,a,",");
      for(i=1;i<=n;i++){ gsub(/[^0-9]/,"",a[i]); tot+=a[i]+0 }
      print tot
    }' "$TMP")"
  SOCKERR="${SOCKERR:-0}"

  # JSON line → OUT
  printf '{"ts":"%s","label":"%s","url":"%s","rps_target":%s,"rps_achieved":%s,"t":%s,"c":%s,"dur":"%s","p50_ms":%s,"p90_ms":%s,"p95_ms":%s,"p99_ms":%s,"non2xx":%s,"sock_errs":%s}\n' \
    "$TS" "$LABEL" "$URL" "$R" "${RPS_ACT:-null}" "$THREADS" "$CONNS" "$DUR" \
    "${P50:-null}" "${P90:-null}" "${P95:-null}" "${P99:-null}" "${NON2XX:-0}" "$SOCKERR" \
    >> "$OUT"

  rm -f "$TMP"
done

echo "✓ Done. Results: $OUT"
