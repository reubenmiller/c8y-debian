#!/bin/bash

if [[ -z "$GPG_PRIVATE_KEY" ]]; then
    echo "Missing env variable: GPG_PRIVATE_KEY"
    exit 1
fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
REPO_BASE=$( cd "$SCRIPT_DIR/.." && pwd )

docker build -t "debian" -f "$SCRIPT_DIR/debian.dockerfile" "$SCRIPT_DIR"
docker run \
    --rm \
    -v "$REPO_BASE:/repo" \
    --env "GPG_PRIVATE_KEY=$GPG_PRIVATE_KEY" \
    debian /repo/scripts/build-debian.sh
