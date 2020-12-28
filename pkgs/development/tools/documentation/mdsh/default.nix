{ stdenv, fetchFromGitHub, rustPlatform, importCargo }:

rustPlatform.buildRustPackage rec {
  pname = "mdsh";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "zimbatm";
    repo = "mdsh";
    rev = "v${version}";
    sha256 = "02xslf5ssmyklbfsif2d7yk5aaz08n5w0dqiid6v4vlr2mkqcpjl";
  };

  buildInputs = [ (importCargo ./Cargo.lock) ];

  meta = with stdenv.lib; {
    description = "Markdown shell pre-processor";
    homepage = "https://github.com/zimbatm/mdsh";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ zimbatm ];
  };
}
