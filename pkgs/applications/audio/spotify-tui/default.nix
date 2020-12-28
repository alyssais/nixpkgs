{ stdenv, fetchFromGitHub, rustPlatform, importCargo
, pkgconfig, openssl, python3, libxcb, AppKit, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "spotify-tui";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "Rigellute";
    repo = "spotify-tui";
    rev = "v${version}";
    sha256 = "0w1y37qh9n3936d59hvqzjz2878x2nwxqxc4s7mp4f9xqcfl0c5r";
  };

  nativeBuildInputs = stdenv.lib.optionals stdenv.isLinux [ pkgconfig python3 ];
  buildInputs = [ (importCargo ./Cargo.lock) ]
    ++ stdenv.lib.optionals stdenv.isLinux [ openssl libxcb ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ AppKit Security ];

  meta = with stdenv.lib; {
    description = "Spotify for the terminal written in Rust";
    homepage = "https://github.com/Rigellute/spotify-tui";
    changelog = "https://github.com/Rigellute/spotify-tui/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ jwijenbergh ];
  };
}
