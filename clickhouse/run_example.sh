#!/usr/bin/env bash
# Run example query under ClickHouse and produce a flame graph.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CH_BIN="${SCRIPT_DIR}/dist/clickhouse"
PID_FILE="${SCRIPT_DIR}/clickhouse.pid"
FOLDED="${SCRIPT_DIR}/trace.folded"

if [[ ! -x "${CH_BIN}" ]]; then
    CH_BIN=$(command -v clickhouse || true)
fi

if [[ ! -x "${CH_BIN}" ]]; then
    echo "ClickHouse binary not found. Run download_binaries.sh first." >&2
    exit 1
fi

"${CH_BIN}" server --daemon --pid-file="${PID_FILE}"
trap '[[ -f "${PID_FILE}" ]] && kill "$(cat "${PID_FILE}")"' EXIT

QUERY_ID=$(uuidgen)
SQL="WITH left AS (SELECT number AS n FROM numbers_mt(1000000)), right AS (SELECT number AS a, number*number AS b FROM numbers(100)) SELECT n % 10 AS g, sum(n) AS s, any(b) FROM left, right WHERE a = g GROUP BY g"

"${CH_BIN}" client --query "SET query_profiler_cpu_time_period_ns=1000000; ${SQL}" --query_id="${QUERY_ID}"
"${CH_BIN}" client --query "SYSTEM FLUSH LOGS"

"${CH_BIN}" client --query "SET allow_introspection_functions=1; SELECT concat(arrayStringConcat(arrayMap(x -> demangle(addressToSymbol(x)), trace), ';'), ' ', toString(count())) FROM system.trace_log WHERE query_id='${QUERY_ID}' AND event_date=today() GROUP BY trace ORDER BY count() DESC" > "${FOLDED}"

"$(dirname "${SCRIPT_DIR}")"/flamegraph.pl "${FOLDED}"
