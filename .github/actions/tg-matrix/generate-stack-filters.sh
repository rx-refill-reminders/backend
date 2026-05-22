#!/bin/bash -e

FILTERS=""

STACKS_DIR="$STACKS_DIR"
if [[ -z "$STACKS_DIR" ]]; then
    >&2 echo "Missing STACKS_DIR environment variable"
    exit 1
fi

STACK_PATHS=$(find "$STACKS_DIR" -type d -mindepth 1 -maxdepth 1 | sort)
while IFS='' read -r STACK_DIR && [[ -n "$STACK_DIR" ]]; do
  STACK_NAME=$(basename "$STACK_DIR")
  FILTERS="${FILTERS}${STACK_NAME}:"$'\n'
  FILTERS="${FILTERS}  - '$STACK_DIR/**'"$'\n'
done <<< "$STACK_PATHS"

printf '%s' "$FILTERS"
