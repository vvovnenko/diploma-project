#!/usr/bin/env bash

RPS_SERIES="${RPS_SERIES:-300 360 430 500 600 720 860 1030 1240 1490}"


URL="http://phpfpm/health-check" LABEL="fpm" RPS_SERIES=$RPS_SERIES /benchmarks/wrk2_step.sh || true
URL="http://openswoole/health-check" LABEL="openswoole" RPS_SERIES=$RPS_SERIES /benchmarks/wrk2_step.sh || true
URL="http://frankenphp/health-check" LABEL="frankenphp" RPS_SERIES=$RPS_SERIES /benchmarks/wrk2_step.sh || true
/benchmarks/json_to_csv.sh || true