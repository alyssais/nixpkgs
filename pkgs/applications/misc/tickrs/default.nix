{ stdenv, rustPlatform, fetchFromGitHub, importCargo, perl }:

rustPlatform.buildRustPackage rec {
  pname = "tickrs";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "tarkah";
    repo = pname;
    rev = "v${version}";
    sha256 = "159smcjrf5193yijfpvy1g9b1gin72xwbjghfyrrphwscwhb215z";
  };

  nativeBuildInputs = [ perl ];
  buildInputs = [ (importCargo ./Cargo.lock) ];

  meta = with stdenv.lib; {
    description = "Realtime ticker data in your terminal";
    homepage = "https://github.com/tarkah/tickrs";
    license = licenses.mit;
    maintainers = with maintainers; [ mredaelli ];
  };
}
