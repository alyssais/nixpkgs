{ lib, rustPlatform, fetchFromGitHub, importCargo }:

rustPlatform.buildRustPackage rec {
  pname = "rnix-hashes";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = pname;
    rev = "v${version}";
    sha256 = "SzHyG5cEjaaPjTkn8puht6snjHMl8DtorOGDjxakJfA=";
  };

  nativeBuildInputs = [ (importCargo ./Cargo.lock) ];

  meta = with lib; {
    description = "Nix Hash Converter";
    homepage = "https://github.com/numtide/rnix-hashes";
    license = licenses.asl20;
    maintainers = with maintainers; [ rizary ];
  };
}
