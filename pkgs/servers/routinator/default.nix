{ stdenv, fetchFromGitHub, rustPlatform, importCargo }:

rustPlatform.buildRustPackage rec {
  pname = "routinator";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-yH43FPeMohN6zpzEcLpbFBvO8Wz4IjuWRmsE19C7NIA=";
  };

  nativeBuildInputs = [ (importCargo ./Cargo.lock) ];

  meta = with stdenv.lib; {
    description = "An RPKI Validator written in Rust";
    homepage = "https://github.com/NLnetLabs/routinator";
    license = licenses.bsd3;
    maintainers = with maintainers; [ _0x4A6F ];
    platforms = platforms.linux;
  };
}
