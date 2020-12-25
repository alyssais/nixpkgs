{ lib, rustPlatform, fetchFromGitHub, importCargo }:

rustPlatform.buildRustPackage rec {
  pname = "nixpkgs-fmt";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "v${version}";
    sha256 = "0w1himwix7iv40rixj9afknwmqg2qmkif23z217gc7x63zyg9vdc";
  };

  nativeBuildInputs = [ (importCargo ./Cargo.lock) ];

  meta = with lib; {
    description = "Nix code formatter for nixpkgs";
    homepage = "https://nix-community.github.io/nixpkgs-fmt";
    license = licenses.asl20;
    maintainers = with maintainers; [ zimbatm ];
  };
}
