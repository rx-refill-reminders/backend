#!/bin/bash -eou pipefail

FILTERS=""

MODULES_DIRS="$MODULES_DIRS"
if [[ -z "$MODULES_DIRS" ]]; then
    >&2 echo "Missing MODULES_DIRS environment variable"
    exit 1
fi

FILTERS="${FILTERS}modules:"$'\n'

MODULES_DIRS_LIST=$(echo "$MODULES_DIRS" | yq '.[]')
while IFS='' read -r MODULES_DIR && [[ -n "$MODULES_DIR" ]]; do
  FILTERS="${FILTERS}  - '$MODULES_DIR/**'"$'\n'
done <<< "$MODULES_DIRS_LIST"

printf '%s' "$FILTERS"
