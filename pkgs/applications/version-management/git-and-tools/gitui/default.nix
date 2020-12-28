{ stdenv, rustPlatform, fetchFromGitHub, importCargo
, libiconv, xorg, python3, Security, AppKit
}:

rustPlatform.buildRustPackage rec {
  pname = "gitui";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "extrawurst";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ifwbi6nydh66z6cprjmz2qvy9z52rj9jg2xf054i249gy955hah";
  };

  nativeBuildInputs = [ python3 ];
  buildInputs = [ (importCargo ./Cargo.lock) ]
    ++ stdenv.lib.optional stdenv.isLinux xorg.libxcb
    ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv Security AppKit ];

  meta = with stdenv.lib; {
    description = "Blazing fast terminal-ui for git written in rust";
    homepage = "https://github.com/extrawurst/gitui";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne yanganto ];
  };
}
