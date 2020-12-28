. $stdenv/setup

mkdir "$out"

# The cargo output is nice and vendoring can take a while for programs
# with lots of dependencies, so reproduce it.
echo -ne "   \e[32;1mVendoring\e[0m "
echo "$crateName $version$printableSource"

if [[ -n $registrySource ]]
then
    # A crate downloaded from a registry is a tarball that we can just
    # extract.
    tar -C $out --strip-components=1 -xf $registrySource
elif [[ -n $gitSource ]]
then
    # Git crates need some processing to turn them into the
    # cargo-vendor format.
    dir="$(mktemp -d)"
    cp -r --no-preserve=mode $gitSource "$dir"
    pushd "$dir"/* >/dev/null

    # Find the Cargo.toml of this crate.
    manifestPath="$(cargo metadata --no-deps --offline --format-version 1 |
              jq -r --arg name "$crateName" --arg version "$version" \
                  '.packages[]
                      | select(.name == $name and .version == $version)
                      | .manifest_path')"

    # Remove the workspace root Cargo.lock.  The out crate doesn't
    # need a lockfile, and if there is one cargo package will try to
    # download the registry.
    rm -f "$(cargo metadata --no-deps --offline \
              --manifest-path "$manifestPath" --format-version 1 |
                  jq -r .workspace_root)/Cargo.lock"

    # Copy every crate file to the vendor directory.
    cargo package -l --frozen --no-verify --no-metadata \
          --manifest-path "$manifestPath" |
        grep -Ev '^Cargo\.(lock|toml\.orig)$' |
        xargs tar -C "$(dirname "$manifestPath")" -c |
        tar -C "$out" -x

    popd >/dev/null
else
    echo "Unsupport crate source: $source" >&2
    exit 1
fi

cp $checksumFilePath $out/.cargo-checksum.json
