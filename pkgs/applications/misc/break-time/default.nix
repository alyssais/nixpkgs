{ fetchFromGitHub
, glib
, gtk3
, openssl
, pkg-config
, python3
, rustPlatform
, importCargo
, stdenv
, wrapGAppsHook
}:

rustPlatform.buildRustPackage rec {
  pname = "break-time";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "cdepillabout";
    repo  = "break-time";
    rev = "v${version}";
    sha256 = "18p9gfp0inbnjsc7af38fghyklr7qnl2kkr25isfy9d5m8cpxqc6";
  };

  nativeBuildInputs = [
    pkg-config
    python3 # needed for Rust xcb package
    wrapGAppsHook
  ];

  buildInputs = [
    (importCargo ./Cargo.lock)
    glib
    gtk3
    openssl
  ];

  meta = with stdenv.lib; {
    description = "Break timer that forces you to take a break";
    homepage    = "https://github.com/cdepillabout/break-time";
    license     = with licenses; [ mit ];
    maintainers = with maintainers; [ cdepillabout ];
    platforms   = platforms.linux;
  };
}

