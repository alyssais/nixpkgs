{ stdenv, fetchFromGitHub, rustPlatform, importCargo
, pkg-config, openssl, libiconv, curl, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-outdated";
  version = "0.9.13";

  src = fetchFromGitHub {
    owner = "kbknapp";
    repo = pname;
    rev = "v${version}";
    sha256 = "1dbhaaw1c3ww0s33r7z8kxks00f9gxv1ppcbmk2fbflhp7caf7fy";
  };

  nativeBuildInputs = [ pkg-config (importCargo ./Cargo.lock) ];
  buildInputs = [ openssl ]
  ++ stdenv.lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    libiconv
    curl
  ];

  meta = with stdenv.lib; {
    description = "A cargo subcommand for displaying when Rust dependencies are out of date";
    homepage = "https://github.com/kbknapp/cargo-outdated";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ sondr3 ivan ];
  };
}
