{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, importCargo
, rust
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deb";
  version = "1.24.0";

  src = fetchFromGitHub {
    owner = "mmstick";
    repo = pname;
    rev = "b49351f6770aa7aeb053dd1d4a02d6b086caad2a";
    sha256 = "1hs96yv0awgi7ggpxp7k3n21jpv642sm0529b21hs9ib6kp4vs8s";
  };

  nativeBuildInputs = [ (importCargo ./Cargo.lock) ];
  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  checkType = "debug";

  preCheck = ''
    substituteInPlace tests/command.rs \
      --replace 'target/debug' "target/${rust.toRustTarget stdenv.buildPlatform}/debug"
  '';

  meta = with lib; {
    description = "Generate Debian packages from information in Cargo.toml";
    homepage = "https://github.com/mmstick/cargo-deb";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
