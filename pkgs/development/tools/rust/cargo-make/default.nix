{ stdenv, fetchurl, runCommand, fetchCrate, rustPlatform, importCargo
, openssl, pkg-config
, Security, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-make";
  version = "0.32.9";

  src = fetchCrate {
    inherit pname version;
    sha256 = "0f6avprq0d65v5fk3kn2kvw3w024f21yq6v8y7d9rbwqxxf87jlf";
  };

  nativeBuildInputs = [ pkg-config (importCargo ./Cargo.lock) ];

  buildInputs = [ openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ Security SystemConfiguration ];

  # Some tests fail because they need network access.
  # However, Travis ensures a proper build.
  # See also:
  #   https://travis-ci.org/sagiegurari/cargo-make
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A Rust task runner and build tool";
    homepage = "https://github.com/sagiegurari/cargo-make";
    license = licenses.asl20;
    maintainers = with maintainers; [ xrelkd ma27 ];
  };
}
