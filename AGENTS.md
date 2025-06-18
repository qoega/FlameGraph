This repository contains Brendan Gregg's FlameGraph tools plus some experimental ClickHouse helpers in `clickhouse/`.

Key points:
- Standard scripts for generating flame graphs using perf, DTrace, etc. live in the repo root.
- `./test.sh` runs stackcollapse-perf.pl against sample data and compares with expected output. It must exit cleanly for a passing test.
- The `clickhouse/` directory holds draft scripts:
  - `download_binaries.sh` downloads a portable ClickHouse build using `curl https://clickhouse.com | sh` into `clickhouse/dist`.
  - `run_example.sh` starts a local ClickHouse server, runs a demo query with CPU profiling enabled and outputs folded stacks compatible with `flamegraph.pl`.
  - `README.md` explains the quick start and notes network access to clickhouse.com is required.

These helpers are experimental and may change. Use the root test suite to confirm changes don't break existing functionality.
