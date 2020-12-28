{ lib
, rustPlatform
, importCargo
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "svls";
  version = "0.1.17";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "svls";
    rev = "v${version}";
    sha256 = "0qcd9pkshk94c6skzld8cyzppl05hk4vcmmaya8r9l6kdi1f4b5m";
  };

  buildInputs = [ (importCargo ./Cargo.lock) ];

  meta = with lib; {
    description = "SystemVerilog language server";
    homepage = "https://github.com/dalance/svls";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}
