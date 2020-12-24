{ stdenv, fetchFromGitHub, rustPlatform, importCargo, Security }:

rustPlatform.buildRustPackage rec {
  pname = "sd";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "chmln";
    repo = pname;
    rev = "v${version}";
    sha256 = "0c5bsqs6c55x4j640vhzlmbiylhp5agr7lx0jrwcjazfyvxihc01";
  };

  nativeBuildInputs = [ (importCargo ./Cargo.lock) ];
  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    description = "Intuitive find & replace CLI (sed alternative)";
    homepage = "https://github.com/chmln/sd";
    license = licenses.mit;
    maintainers = with maintainers; [ amar1729 Br1ght0ne ];
  };
}
