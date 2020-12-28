{ lib
, rustPlatform
, importCargo
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "svlint";
  version = "0.4.8";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "svlint";
    rev = "v${version}";
    sha256 = "1anbanvaikj8g5jcmjd165krzvjdwj1cl8f3vm1nmy997x8vxihf";
  };

  buildInputs = [ (importCargo ./Cargo.lock) ];

  meta = with lib; {
    description = "SystemVerilog linter";
    homepage = "https://github.com/dalance/svlint";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}
