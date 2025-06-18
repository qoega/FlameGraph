# ClickHouse FlameGraph Integration

This directory contains helper scripts for collecting flame graphs using
[ClickHouse](https://clickhouse.com/). The scripts download a portable
ClickHouse build, start a temporary server, run a query with CPU sampling
enabled and finally convert the resulting trace log into a folded stack
format that is compatible with `flamegraph.pl`.

These scripts are primarily intended for local testing and exploration.
The `download_binaries.sh` helper fetches the latest stable build using
`curl https://clickhouse.com | sh`, so network access to `clickhouse.com`
is required. If the download fails, ensure your environment permits
outbound HTTP requests to that domain.

## Quick start

```
# download binaries and prepare local directory
./download_binaries.sh

# run example query and build flame graph
./run_example.sh > query.svg
```

The example query is just a simple aggregation over `numbers_mt`, but you
can adapt `run_example.sh` for your own workload. Make sure
`query_profiler_cpu_time_period_ns` is set to an appropriate value (the
scripts use 1ms sampling by default).
