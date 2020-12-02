{ stdenv, lib, rustPlatform, importCargo, fetchFromGitHub
, ncurses, CoreServices
}:

rustPlatform.buildRustPackage rec {
  pname = "dijo";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "NerdyPepper";
    repo = "dijo";
    rev = "v${version}";
    sha256 = "1lcvj0pri5v64zygkf2p24vr72y39agrq1r3kb8dfgz8yy3vcz0a";
  };

  nativeBuildInputs = [ (importCargo ./Cargo.lock) ];
  buildInputs = [ ncurses ] ++ lib.optional stdenv.isDarwin CoreServices;

  meta = with lib; {
    description = "Scriptable, curses-based, digital habit tracker";
    homepage = "https://github.com/NerdyPepper/dijo";
    license = licenses.mit;
    maintainers = with maintainers; [ infinisil ];
  };
}
