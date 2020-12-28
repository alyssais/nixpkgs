{ stdenv
, lib
, rustPlatform
, importCargo
, fetchpatch
, fetchFromGitHub
, pkg-config
, dbus
, openssl
, Foundation
}:

rustPlatform.buildRustPackage rec {
  pname = "tiny";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "osa1";
    repo = pname;
    rev = "v${version}";
    sha256 = "11kjndd4rzj83hzhcqvvp9nxjkana63m0h5r51xwp1ww9sn63km9";
  };

  RUSTC_BOOTSTRAP = 1;

  nativeBuildInputs = lib.optional stdenv.isLinux pkg-config;
  buildInputs = [ (importCargo ./Cargo.lock) ]
    ++ lib.optionals stdenv.isLinux [ dbus openssl ]
    ++ lib.optional stdenv.isDarwin Foundation;

  meta = with lib; {
    description = "A console IRC client";
    homepage = "https://github.com/osa1/tiny";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
