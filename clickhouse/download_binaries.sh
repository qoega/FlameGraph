#!/usr/bin/env bash
# Download the latest ClickHouse binary using the official installer.
# Usage: ./download_binaries.sh
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p "${DIR}/dist"
cd "${DIR}/dist"

if [[ ! -x clickhouse ]]; then
    echo "Fetching ClickHouse via install script" >&2
    curl https://clickhouse.com/ | sh
fi
