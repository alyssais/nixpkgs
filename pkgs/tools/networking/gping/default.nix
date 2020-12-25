{ lib
, rustPlatform
, importCargo
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "gping";
  version = "1.0.1-post2";

  src = fetchFromGitHub {
    owner = "orf";
    repo = "gping";
    rev = "v${version}";
    sha256 = "0cvbwxvq1cj9xcjc3hnxrpq9yrmfkapy533cbjzsjmvgiqk11hps";
  };

  nativeBuildInputs = [ (importCargo ./Cargo.lock) ];

  meta = with lib; {
    description = "Ping, but with a graph";
    homepage = "https://github.com/orf/gping";
    license = licenses.mit;
    maintainers = with maintainers; [ andrew-d ];
  };
}
