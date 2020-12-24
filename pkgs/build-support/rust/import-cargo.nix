{ lib, fetchurl, fetchgit, runCommand, writeScript, makeSetupHook
, cargo, jq
}:

path:

let
  inherit (builtins) dirOf elemAt filter head match pathExists;
  inherit (lib) concatMapStrings escapeShellArg hasPrefix importTOML last
    optionals;

  fetchCrate = { name, version, checksum, ... }: fetchurl {
    name = "${name}-${version}";
    url = "https://crates.io/api/v1/crates/${name}/${version}/download";
    sha256 = checksum;
  };

  cargoLock = importTOML path;
  cratesIODeps = filter (c: c ? source) cargoLock.package;

  splitGitSource = source:
    let matches = match "git\\+([^?]*)\\?(rev|branch)=(.*)#(.*)" source; in {
      url = elemAt matches 0;
      refType = elemAt matches 1;
      ref = elemAt matches 2;
      rev = elemAt matches 3;
    };

  gitDeps = let path' = dirOf path + "/Cargo-git.lock"; in
            optionals (pathExists path') (importTOML path').git;

  gitDep = { source, ... }: let s = splitGitSource source; in
    head (filter (d: d.url == s.url && d.rev == s.rev) gitDeps);

  gitSourceForURL = url:
    let
      hasGitSource = { source, ... }: hasPrefix "git+${url}?" source;
      package = head (filter hasGitSource cratesIODeps);
    in
      splitGitSource package.source;

  # Create a directory that symlinks all the crate sources and
  # contains a cargo configuration file that redirects to those
  # sources.
  vendorDir = runCommand "cargo-vendor-dir" {
    nativeBuildInputs = [ cargo jq ];
  } ''
    mkdir -p $out/vendor

    cat >$out/vendor/config <<EOF
    [source.crates-io]
    replace-with = "vendored-sources"
    ${concatMapStrings ({ url, ... }: ''

    [source."${url}"]
    git = "${url}"
    ${with gitSourceForURL url; ''${refType} = "${ref}"''}
    replace-with = "vendored-sources"
    '') gitDeps}
    [source.vendored-sources]
    directory = "vendor"
    EOF

    ${concatMapStrings ({ name, version, checksum, ... } @ crate: ''
      vendored="$out/vendor"/${escapeShellArg "${name}-${version}"}
      tar -C $out/vendor -xf ${fetchCrate crate}
      echo '{"files":{},"package":"${checksum}"}' \
          >"$vendored/.cargo-checksum.json"
    '') (filter ({ source, ... }: hasPrefix "registry+" source) cratesIODeps)}

    ${concatMapStrings ({ name, version, ... } @ crate: let dep = gitDep crate; in ''
      crateName=${escapeShellArg name}
      crateVersion=${escapeShellArg version}
      dir="$(mktemp -d)"
      cp -r --no-preserve=mode ${fetchgit dep} "$dir"
      pushd "$dir"/* >/dev/null
      manifestPath="$(cargo metadata --format-version 1 --no-deps |
          jq -r --arg name "$crateName" --arg version "$crateVersion" \
              '.packages[]
                  | select(.name == $name and .version == $version)
                  | .manifest_path')"
      vendored="$out/vendor/$crateName-$crateVersion"
      cargo package --no-verify --manifest-path "$manifestPath"
      mkdir "$vendored"
      tar -C "$vendored" -xf target/package/*.crate --strip-components 1
      popd >/dev/null
      mv "$vendored/Cargo.toml.orig" "$vendored/Cargo.toml"
      echo '{"files":{},"package":null}' >"$vendored/.cargo-checksum.json"
    '') (filter ({ source, ... }: hasPrefix "git+" source) cratesIODeps)}
  '';

in

# Create a setup hook that will initialize CARGO_HOME. Note:
# we don't point CARGO_HOME at the vendor tree directly
# because then we end up with a runtime dependency on it.
makeSetupHook {} (writeScript "make-cargo-home" ''
  if [[ -z "''${CARGO_HOME-}" || "''${CARGO_HOME-}" = /build ]]; then
    export CARGO_HOME=$TMPDIR/vendor
    # FIXME: work around Rust 1.36 wanting a $CARGO_HOME/.package-cache file.
    #ln -s ${vendorDir}/vendor $CARGO_HOME
    cp -prd ${vendorDir}/vendor $CARGO_HOME
    chmod -R u+w $CARGO_HOME
  fi
'')
