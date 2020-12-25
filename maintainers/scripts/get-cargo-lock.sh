#!/usr/bin/env nix-shell
#! nix-shell -i sh -p jq
set -ue

if [ "$#" -eq 0 ]
then
    echo "Usage: $0 attr" >&2
    exit 69 # EX_USAGE
fi

for attr
do
    position="$(nix-instantiate --eval --json -A "$attr.meta.position" | jq -r .)"
    path="$(dirname "$position")/Cargo.lock"

position="$(nix-instantiate --eval --json -A "$attr.meta.position" | jq -r .)"
path="$(dirname "$position")/Cargo.lock"

src="$(nix-build --no-out-link -A "$attr.src")"

cp -v "$src/Cargo.lock" "$path"
