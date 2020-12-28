{ stdenv, fetchFromGitHub, rustPlatform, importCargo
, openssl, pkg-config, ncurses
}:

rustPlatform.buildRustPackage rec {
  version = "0.5.1";
  pname = "rink";

  src = fetchFromGitHub {
    owner = "tiffany352";
    repo = "rink-rs";
    rev = "v${version}";
    sha256 = "1s67drjzd4cf93hpm7b2facfd6y1x0s60aq6pygj7i02bm0cb9l9";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ (importCargo ./Cargo.lock) openssl ncurses ];

  # Some tests fail and/or attempt to use internet servers.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Unit-aware calculator";
    homepage = "https://rinkcalc.app";
    license = with licenses; [ mpl20 gpl3 ];
    maintainers = with maintainers; [ sb0 Br1ght0ne ];
  };
}
