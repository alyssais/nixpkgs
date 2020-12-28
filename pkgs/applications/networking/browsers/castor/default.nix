{ stdenv
, fetchurl
, rustPlatform
, importCargo
, pkg-config
, wrapGAppsHook
, openssl
, gtk3
, gdk-pixbuf
, pango
, atk
, cairo
}:

rustPlatform.buildRustPackage rec {
  pname = "castor";
  version = "0.8.16";

  src = fetchurl {
    url = "https://git.sr.ht/~julienxx/castor/archive/${version}.tar.gz";
    sha256 = "1qwsprwazkzcs70h219fhh5jj5s5hm1k120fn3pk4qivii4lyhah";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    (importCargo ./Cargo.lock)
    openssl
    gtk3
    gdk-pixbuf
    pango
    atk
    cairo
  ];

  postInstall = "make PREFIX=$out copy-data";

  # Sometimes tests fail when run in parallel
  cargoParallelTestThreads = false;

  meta = with stdenv.lib; {
    description = "A graphical client for plain-text protocols written in Rust with GTK. It currently supports the Gemini, Gopher and Finger protocols";
    homepage = "https://sr.ht/~julienxx/Castor";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
  };
}
