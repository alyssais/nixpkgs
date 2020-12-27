{ lib, rustPlatform, fetchFromGitHub, importCargo }:

rustPlatform.buildRustPackage rec {
  pname = "resvg";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = pname;
    rev = "v${version}";
    sha256 = "1qaca8wqwi2wqqx1yladjb4clgqdzsm8b7qsiaw0qascddjw1mcc";
  };

  nativeBuildInputs = [ (importCargo ./Cargo.lock) ];

  doCheck = false;

  meta = with lib; {
    description = "An SVG rendering library";
    homepage = "https://github.com/RazrFalcon/resvg";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
