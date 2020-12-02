{ lib, fetchurl, runCommand, writeScript, makeSetupHook }:

path:

let
  inherit (builtins) filter;
  inherit (lib) importTOML concatMapStrings;
  
  fetchCrate = { name, version, checksum, ... }: fetchurl {
    name = "${name}-${version}";
    url = "https://crates.io/api/v1/crates/${name}/${version}/download";
    sha256 = checksum;
  };

  cargoLock = importTOML path;
  cratesIODeps = filter (c: c ? source) cargoLock.package;

  # Create a directory that symlinks all the crate sources and
  # contains a cargo configuration file that redirects to those
  # sources.
  vendorDir = runCommand "cargo-vendor-dir" {} ''
    mkdir -p $out/vendor
    ${concatMapStrings ({ name, version, checksum, ... } @ crate: ''
      tar -C $out/vendor -xf ${fetchCrate crate}
      echo '{"files":{},"package":"${checksum}"}' \
          >$out/vendor/${name}-${version}/.cargo-checksum.json
    '') cratesIODeps}

    cat >$out/vendor/config <<EOF
    [source.crates-io]
    replace-with = "vendored-sources"
    [source.vendored-sources]
    directory = "vendor"
    EOF
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
