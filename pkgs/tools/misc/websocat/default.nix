{ stdenv, fetchFromGitHub, rustPlatform, importCargo, makeWrapper
, pkgconfig, openssl, bash, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "websocat";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "vi";
    repo = "websocat";
    rev = "v${version}";
    sha256 = "0iilq96bxcb2fsljvlgy47pg514w0jf72ckz39yy3k0gwc1yfcja";
  };

  cargoBuildFlags = [ "--features=ssl" ];

  nativeBuildInputs = [ pkgconfig makeWrapper (importCargo ./Cargo.lock) ];
  buildInputs = [ openssl ] ++ stdenv.lib.optional stdenv.isDarwin Security;

  # The wrapping is required so that the "sh-c" option of websocat works even
  # if sh is not in the PATH (as can happen, for instance, when websocat is
  # started as a systemd service).
  postInstall = ''
    wrapProgram $out/bin/websocat \
      --prefix PATH : ${stdenv.lib.makeBinPath [ bash ]}
  '';

  meta = with stdenv.lib; {
    description = "Command-line client for WebSockets (like netcat/socat)";
    homepage = "https://github.com/vi/websocat";
    license = licenses.mit;
    maintainers = with maintainers; [ thoughtpolice Br1ght0ne ];
  };
}
