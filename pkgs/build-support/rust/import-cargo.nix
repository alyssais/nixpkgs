{ stdenv, lib, fetchurl, fetchgit
, runCommand, writeScript, makeSetupHook, linkFarm
, cargo, jq
}:

path:

let
  inherit (builtins) dirOf elemAt filter head match pathExists toJSON;
  inherit (lib) concatMapStrings escapeShellArg hasPrefix importTOML
    optionalString optionals;

  # We don't use fetchCrate from elsewhere in Nixpkgs because it
  # calculates hashes of unpack crates, and the hashes that Cargo
  # gives us in lockfiles are for the tarballs.
  fetchCrate = { name, version, checksum, ... }: fetchurl {
    name = "${name}-${version}";
    url = "https://crates.io/api/v1/crates/${name}/${version}/download";
    sha256 = checksum;
  };

  cargoLock = importTOML path;
  externalDeps = filter (c: c ? source) cargoLock.package;

  splitGitSource = source:
    let matches = match "git\\+([^?]*)(\\?(rev|branch)=(.*))?#(.*)" source; in {
      url = elemAt matches 0;
      refType = elemAt matches 2;
      ref = elemAt matches 3;
      rev = elemAt matches 4;
    };

  gitPath = dirOf path + "/Cargo-git.lock";
  gitDeps = optionals (pathExists gitPath) (importTOML gitPath).git;

  gitDep = { source, ... }: let s = splitGitSource source; in
    head (filter (d: d.url == s.url && d.rev == s.rev) gitDeps);

  gitSourceForURL = url:
    let
      hasGitSource = { source, ... }:
        hasPrefix "git+${url}?" source || hasPrefix "git+${url}#" source;
      package = head (filter hasGitSource externalDeps);
    in
      splitGitSource package.source;

  # In modern Cargo.lock files, the checksum is included in the table
  # with all the other crate metadata, but in older ones, checksums
  # are all in a "metadata" table at the bottom.
  oldFormatChecksumFor = { name, version, source, ... }:
    cargoLock.metadata."checksum ${name} ${version} (${source})";

  vendorCrate =
    { name, version, source
    , checksum ? if hasPrefix "registry+" source
                 then oldFormatChecksumFor crate
                 else null
    , ...
    } @ crate:

    let
      sourceMatches = match "git\\+(.*)" source;
    in

    stdenv.mkDerivation {
      name =  "cargo-vendor-${name}-${version}";
      crateName = name;
      inherit version source;

      printableSource = optionalString (sourceMatches != null)
        (escapeShellArg " (${head sourceMatches})");
      
      registrySource = optionalString (hasPrefix "registry+" source)
        (fetchCrate (crate // { inherit checksum; }));
      gitSource = optionalString (hasPrefix "git+" source)
        (fetchgit (gitDep crate));

      checksumFile = toJSON { files = {}; package = checksum; };
      passAsFile = [ "checksumFile" ];

      nativeBuildInputs = [
        (cargo.overrideAttrs ({ patches ? [], ... }: {
          patches = patches ++ [
            ../../development/compilers/rust/Make-cargo-metadata-no-deps-print-all-path-deps.patch
          ];
        }))
        jq
      ];

      builder = ./vendor-crate.sh;
    };

  # Create a directory that symlinks all the crate sources and
  # contains a cargo configuration file that redirects to those
  # sources.
  vendorDir = runCommand "cargo-vendor-dir" {
    config = ''
      [source.crates-io]
      replace-with = "vendored-sources"
      ${concatMapStrings ({ url, ... }: ''

      [source."${url}"]
      git = "${url}"
      ${with gitSourceForURL url; optionalString (refType != null) ''${refType} = "${ref}"''}
      replace-with = "vendored-sources"
      '') gitDeps}
      [source.vendored-sources]
      directory = "import-cargo/vendor"
    '';
    passAsFile = [ "config" ];
  } ''
    mkdir -p $out

    ln -s ${linkFarm "cargo-vendor" (map ({ name, version, ... } @ crate: {
      name = "${name}-${version}";
      path = vendorCrate crate;
    }) externalDeps)} $out/vendor

    cp ${path} $out/Cargo.lock
    cp $configPath $out/config
  '';

in

# Create a setup hook that will initialize CARGO_HOME. Note:
# we don't point CARGO_HOME at the vendor tree directly
# because then we end up with a runtime dependency on it.
makeSetupHook {} (writeScript "make-cargo-home" ''
  if [[ -z ''${CARGO_HOME-} || $CARGO_HOME = /build ]]; then
    export CARGO_HOME=$TMPDIR/import-cargo
    cp -prd ${vendorDir} $CARGO_HOME
    chmod -R u+w $CARGO_HOME
  fi
'')
