#!/usr/bin/env bash

URL="http://phpfpm/bench/io" LABEL="fpm" /benchmarks/wrk2_step.sh || true
URL="http://openswoole/bench/io" LABEL="openswoole" /benchmarks/wrk2_step.sh || true
URL="http://frankenphp/bench/io" LABEL="frankenphp" /benchmarks/wrk2_step.sh || true
/benchmarks/json_to_csv.sh || true