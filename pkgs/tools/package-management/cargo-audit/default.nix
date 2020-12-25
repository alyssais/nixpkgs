{ stdenv, lib, rustPlatform, fetchFromGitHub, importCargo
, openssl, pkg-config, Security, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-audit";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "RustSec";
    repo = "cargo-audit";
    rev = "v${version}";
    sha256 = "1q8i2c3f8ir1pxkvla4dshz7n0cl97mjydc64xis5pph39f69yc1";
  };

  buildInputs = [ openssl libiconv ] ++ lib.optionals stdenv.isDarwin [ Security ];
  nativeBuildInputs = [ pkg-config (importCargo ./Cargo.lock) ];

  # The tests require network access which is not available in sandboxed Nix builds.
  doCheck = false;

  meta = with lib; {
    description = "Audit Cargo.lock files for crates with security vulnerabilities";
    homepage = "https://rustsec.org";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ basvandijk ];
  };
}
