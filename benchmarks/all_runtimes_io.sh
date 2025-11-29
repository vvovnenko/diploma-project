#!/usr/bin/env bash

RPS_SERIES="${RPS_SERIES:-60 80 100 120 140 160 190 220 250 300 360 430 500 600}"
THREADS="${THREADS:-$(nproc)}"
CONNS="${CONNS:-$((THREADS*20))}"

URL="http://phpfpm/bench/io?ms=5" LABEL="fpm" THREADS=$THREADS CONNS=$CONNS RPS_SERIES=$RPS_SERIES /benchmarks/wrk2_step.sh || true
URL="http://openswoole/bench/io?ms=5" LABEL="openswoole" THREADS=$THREADS CONNS=$CONNS RPS_SERIES=$RPS_SERIES /benchmarks/wrk2_step.sh || true
URL="http://frankenphp/bench/io?ms=5" LABEL="frankenphp" THREADS=$THREADS CONNS=$CONNS RPS_SERIES=$RPS_SERIES /benchmarks/wrk2_step.sh || true
/benchmarks/json_to_csv.sh || true