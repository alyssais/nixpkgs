{ stdenv, lib, fetchurl, fetchgit
, runCommand, writeScript, writeText, makeSetupHook
, cargo, jq
}:

path:

let
  inherit (builtins) dirOf elemAt filter head match pathExists toJSON;
  inherit (lib) concatMapStrings escapeShellArg escapeShellArgs hasPrefix
    importTOML optionalString optionals;

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
    let
      matches = match "git\\+([^?]*)(\\?(rev|branch|tag)=(.*))?#(.*)" source;
    in {
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
      name =  "rust-${name}-${version}-vendored";
      crateName = name;
      inherit version source;

      printableSource = optionalString (sourceMatches != null)
        " (${head sourceMatches})";
      
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

  config = writeText "cargo-config.toml" ''
    [source.crates-io]
    replace-with = "vendored-sources"
    ${concatMapStrings ({ url, ... }: ''

    [source."${url}"]
    git = "${url}"
    ${with gitSourceForURL url; optionalString (refType != null) ''${refType} = "${ref}"''}
    replace-with = "vendored-sources"
    '') gitDeps}
    [source.vendored-sources]
    directory = "/build/.cargo/vendor"
  '';

in

# Cargo walks recursively up the directory tree looking for
# .cargo/config, so we can put our configuration there without
# conflicting with repository configuration.
makeSetupHook {} (writeScript "make-cargo-home" ''
  mkdir -p $NIX_BUILD_TOP/.cargo/vendor

  importCrate() {
      local name="$1"
      local version="$2"
      local path="$3"

      if [[ -f $path/build.rs ]]
      then
          # build.rs might want to write into the crate sources, so
          # make sure it's writeable.
          cp -rvn "$path" "$NIX_BUILD_TOP/.cargo/vendor/$name-$version"
      else
          ln -sv "$path" "$NIX_BUILD_TOP/.cargo/vendor/$name-$version"
      fi
  }

  ${concatMapStrings ({ name, version, ... } @ crate: ''
    importCrate ${escapeShellArgs [ name version (vendorCrate crate) ]}
  '') externalDeps}
  # crate sources have to be writeable for build.rs.
  chmod -R +w $NIX_BUILD_TOP/.cargo/vendor

  cp ${path} $NIX_BUILD_TOP/.cargo/Cargo.lock
  cat ${config} >> $NIX_BUILD_TOP/.cargo/config
'')
