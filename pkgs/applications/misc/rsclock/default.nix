{ stdenv, rustPlatform, fetchFromGitHub, importCargo }:

rustPlatform.buildRustPackage rec {
  pname = "rsClock";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "valebes";
    repo = pname;
    rev = "v${version}";
    sha256 = "1i93qkz6d8sbk78i4rvx099hnn4lklp4cjvanpm9ssv8na4rqvh2";
  };

  buildInputs = [ (importCargo ./Cargo.lock) ];

  meta = with stdenv.lib; {
    description = "A simple terminal clock written in Rust";
    homepage = "https://github.com/valebes/rsClock";
    license = licenses.mit;
    maintainers = with maintainers; [valebes];
  };
}
