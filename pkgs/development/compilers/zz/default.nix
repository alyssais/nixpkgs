{ lib, rustPlatform, fetchFromGitHub, importCargo, makeWrapper, z3 }:

rustPlatform.buildRustPackage rec {
  pname = "zz";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "aep";
    repo = "zz";
    rev = version;
    sha256 = "0kqrfm2r9wn0p2c3lcprsy03p9qhrwjs990va8qi59jp704l84ad";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ (importCargo ./Cargo.lock) ];

  postInstall = ''
    wrapProgram $out/bin/zz --prefix PATH ":" "${lib.getBin z3}/bin"
  '';

  meta = with lib; {
    description = "🍺🐙 ZetZ a zymbolic verifier and tranzpiler to bare metal C";
    homepage = "https://github.com/aep/zz";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
