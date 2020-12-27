{ stdenv, fetchFromGitHub, rustPlatform, importCargo, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "fselect";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "jhspetersson";
    repo = "fselect";
    rev = version;
    sha256 = "1cqa52n5y6g087w4yzc273jpxhzpinwkqd32azg03dkczbgx5b2v";
  };

  nativeBuildInputs = [ installShellFiles (importCargo ./Cargo.lock) ];

  postInstall = ''
    installManPage docs/fselect.1
  '';

  meta = with stdenv.lib; {
    description = "Find files with SQL-like queries";
    homepage = "https://github.com/jhspetersson/fselect";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
