#!/usr/bin/env nix-shell
#! nix-shell -i sh -p jq
set -ue

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 attr" >&2
    exit 69 # EX_USAGE
fi

attr="$1"
shift

position="$(nix-instantiate --eval --json -A "$attr.meta.position" | jq -r .)"
path="$(dirname "$position")/Cargo.lock"

src="$(nix-build --no-out-link -A "$attr.src")"

cp -v "$src/Cargo.lock" "$path"
