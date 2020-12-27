{ stdenv, fetchFromGitHub, rustPlatform, importCargo }:

rustPlatform.buildRustPackage rec {
  pname = "svgcleaner";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = "svgcleaner";
    rev = "v${version}";
    sha256 = "1jpnqsln37kkxz98vj7gly3c2170v6zamd876nc9nfl9vns41s0f";
  };

  nativeBuildInputs = [ (importCargo ./Cargo.lock) ];

  meta = with stdenv.lib; {
    description = "A tool for tidying and optimizing SVGs";
    homepage = "https://github.com/RazrFalcon/svgcleaner";
    license = licenses.gpl2;
    maintainers = [ maintainers.mehandes ];
  };
}
