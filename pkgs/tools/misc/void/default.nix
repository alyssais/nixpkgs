{ stdenv, fetchFromGitHub, rustPlatform, importCargo }:

rustPlatform.buildRustPackage rec {
  pname = "void";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "spacejam";
    repo = "void";
    rev = version;
    sha256 = "08vazw4rszqscjz988k89z28skyj3grm81bm5iwknxxagmrb20fz";
  };

  nativeBuildInputs = [ (importCargo ./Cargo.lock) ];

  # The tests are long-running and not that useful
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Terminal-based personal organizer";
    homepage = "https://github.com/spacejam/void";
    license = licenses.gpl3;
    maintainers = with maintainers; [ spacekookie ];
  };
}
