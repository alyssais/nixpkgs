{ stdenv, lib, fetchFromGitHub, rustPlatform, importCargo, installShellFiles
, Foundation
}:

rustPlatform.buildRustPackage rec {
  pname = "topgrade";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "r-darwish";
    repo = pname;
    rev = "v${version}";
    sha256 = "15ad30svvr775dxp5gwlq73xydsqwfpw650c3c3ma4jshw36w0x4";
  };

  buildInputs = lib.optional stdenv.isDarwin Foundation;
  nativeBuildInputs = [ installShellFiles (importCargo ./Cargo.lock) ];

  postInstall = ''
    installManPage topgrade.8
  '';

  meta = with lib; {
    description = "Upgrade all the things";
    homepage = "https://github.com/r-darwish/topgrade";
    license = licenses.gpl3;
    maintainers = with maintainers; [ Br1ght0ne hugoreeves ];
  };
}
