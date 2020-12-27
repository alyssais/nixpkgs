{ lib, fetchurl, fetchgit, runCommand, writeScript, makeSetupHook
, cargo, jq
}:

path:

let
  inherit (builtins) dirOf elemAt filter head match pathExists;
  inherit (lib) concatMapStrings escapeShellArg hasPrefix importTOML last
    optionalString optionals;

  fetchCrate = { name, version, checksum, ... }: fetchurl {
    name = "${name}-${version}";
    url = "https://crates.io/api/v1/crates/${name}/${version}/download";
    sha256 = checksum;
  };

  cargoLock = importTOML path;
  cratesIODeps = filter (c: c ? source) cargoLock.package;

  splitGitSource = source:
    let matches = match "git\\+([^?]*)(\\?(rev|branch)=(.*))?#(.*)" source; in {
      url = elemAt matches 0;
      refType = elemAt matches 2;
      ref = elemAt matches 3;
      rev = elemAt matches 4;
    };

  gitDeps = let path' = dirOf path + "/Cargo-git.lock"; in
            optionals (pathExists path') (importTOML path').git;

  gitDep = { source, ... }: let s = splitGitSource source; in
    head (filter (d: d.url == s.url && d.rev == s.rev) gitDeps);

  gitSourceForURL = url:
    let
      hasGitSource = { source, ... }:
        hasPrefix "git+${url}?" source || hasPrefix "git+${url}#" source;
      package = head (filter hasGitSource cratesIODeps);
    in
      splitGitSource package.source;

  oldFormatChecksumFor = { name, version, source, ... }:
    cargoLock.metadata."checksum ${name} ${version} (${source})";

  # Create a directory that symlinks all the crate sources and
  # contains a cargo configuration file that redirects to those
  # sources.
  vendorDir = runCommand "cargo-vendor-dir" {
    nativeBuildInputs = [ cargo jq ];
  } ''
    mkdir -p $out/vendor
    cp ${path} $out/vendor/Cargo.lock

    cat >$out/vendor/config <<EOF
    [source.crates-io]
    replace-with = "vendored-sources"
    ${concatMapStrings ({ url, ... }: ''

    [source."${url}"]
    git = "${url}"
    ${with gitSourceForURL url;
      optionalString (refType != null) ''${refType} = "${ref}"''}
    replace-with = "vendored-sources"
    '') gitDeps}
    [source.vendored-sources]
    directory = "vendor"
    EOF

    ${concatMapStrings ({ name, version, checksum ? oldFormatChecksumFor crate, ... } @ crate: ''
      crateName=${escapeShellArg name}
      crateVersion=${escapeShellArg version}
      vendored="$out/vendor/$crateName-$crateVersion"
      echo -e "   \e[32;1mVendoring\e[0m $crateName $crateVersion"
      tar -C $out/vendor -xf ${fetchCrate (crate // { inherit checksum; })}
      echo '{"files":{},"package":"${checksum}"}' \
          >"$vendored/.cargo-checksum.json"
    '') (filter ({ source, ... }: hasPrefix "registry+" source) cratesIODeps)}

    ${concatMapStrings ({ name, version, source, ... } @ crate:
      let dep = gitDep crate; in ''
        crateName=${escapeShellArg name}
        crateVersion=${escapeShellArg version}
        echo -ne "   \e[32;1mVendoring\e[0m $crateName $crateVersion"
        echo -e " (${escapeShellArg source})"
        echo "            ${fetchgit dep}"
        dir="$(mktemp -d)"
        cp -r --no-preserve=mode ${fetchgit dep} "$dir"
        pushd "$dir"/* >/dev/null
        manifestPath="$(cargo metadata --no-deps --format-version 1 |
            jq -r --arg name "$crateName" --arg version "$crateVersion" \
                '.packages[]
                    | select(.name == $name and .version == $version)
                    | .manifest_path')"
        vendored="$out/vendor/$crateName-$crateVersion"
        mkdir "$vendored"
        cargo package -l --frozen --no-verify --no-metadata \
            --manifest-path "$manifestPath" |
                grep -Ev '^Cargo\.(lock|toml\.orig)$' |
                xargs tar -C "$(dirname "$manifestPath")" -c |
                tar -C "$vendored" -x
        popd >/dev/null
        echo '{"files":{},"package":null}' >"$vendored/.cargo-checksum.json"
      ''
    ) (filter ({ source, ... }: hasPrefix "git+" source) cratesIODeps)}
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
