#!/bin/bash

set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

./stop.sh
./start.sh "$@"
