{ stdenv
, fetchFromGitHub
, rustPlatform
, importCargo
}:

rustPlatform.buildRustPackage rec {
  pname = "kibi";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "ilai-deutel";
    repo = "kibi";
    rev = "v${version}";
    sha256 = "1x5bvvq33380k2qhs1bwz3f9zl5q1sl7iic47pxfkzv24bpjnypb";
  };

  buildInputs = [ (importCargo ./Cargo.lock) ];

  meta = with stdenv.lib; {
    description = "A text editor in ≤1024 lines of code, written in Rust";
    homepage = "https://github.com/ilai-deutel/kibi";
    license = licenses.mit;
    maintainers = with maintainers; [ robertodr ];
  };
}
