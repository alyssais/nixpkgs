{ pkgs, callPackage }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2020-11-09";
    version = "unstable-${rev}";
    sha256 = "sha256-SX9dvx2JtYZBxA3+dHQKX/jrjbAMy37/SAybDjlYcSs=";
    vendoredDeps = pkgs.importCargo ./Cargo.lock;
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
