{ stdenv, fetchFromGitHub, rustPlatform, importCargo, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "manix";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "mlvzk";
    repo  = pname;
    rev = "v${version}";
    sha256 = "0fv3sgzwjsgq2h1177r8r1cl5zrfja4ll801sd0bzj3nzmkyww7p";
  };

  nativeBuildInputs = [ (importCargo ./Cargo.lock) ];
  buildInputs = stdenv.lib.optional stdenv.isDarwin [ darwin.Security ];

  meta = with stdenv.lib; {
    description = "A Fast Documentation Searcher for Nix";
    homepage    = "https://github.com/mlvzk/manix";
    license     = [ licenses.mpl20 ];
    maintainers = [ maintainers.mlvzk ];
    platforms   = platforms.unix;
  };
}
