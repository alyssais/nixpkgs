{ lib, rustPlatform, fetchFromGitHub, importCargo }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-insta";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "insta";
    rev = version;
    sha256 = "1lcbdzh139lhmpz3pyik8nbgrbfc42z9ydz2hkg2lzjdpfdsz3ag";
  };

  patches = [ ./ignore-rustfmt-test.patch ];

  buildInputs = [ (importCargo ./Cargo.lock) ];

  cargoBuildFlags = [ "-p cargo-insta" ];

  meta = with lib; {
    description = "A Cargo subcommand for snapshot testing";
    homepage = "https://github.com/mitsuhiko/insta";
    license = licenses.asl20;
    maintainers = with lib.maintainers; [ oxalica ];
  };
}
