#!/usr/bin/env nix-shell
#! nix-shell -i sh -p jq nix-prefetch-git
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

    src="$(nix-build --no-out-link -A "$attr.src")"
    sourceRoot="$(nix-instantiate -E --eval --json --argstr attr "$attr" \
        '{ attr }: (import ./. {}).${attr}.sourceRoot or "source"' | jq -r .)/"

    cp -v --no-preserve=mode "$src/${sourceRoot#*/}Cargo.lock" "$path" || true

    if grep -q '^source = "git+' "$path"
    then
	~/src/cargo-dump-git-sources/target/debug/cargo-dump-git-sources "$path" > "$(dirname "$position")/Cargo-git.lock"
    fi
done
