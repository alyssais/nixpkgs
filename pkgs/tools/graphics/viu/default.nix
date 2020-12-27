{ lib, rustPlatform, fetchFromGitHub, importCargo }:

rustPlatform.buildRustPackage rec {
  pname = "viu";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "atanunq";
    repo = "viu";
    rev = "v${version}";
    sha256 = "1q248jnbv64mkvg18465dpvjkw2v2hfqyvdvdixyrwyrnlv5cicv";
  };

  nativeBuildInputs = [ (importCargo ./Cargo.lock) ];

  # tests are failing, reported at upstream: https://github.com/atanunq/viu/issues/40
  doCheck = false;

  meta = with lib; {
    description = "A command-line application to view images from the terminal written in Rust";
    homepage = "https://github.com/atanunq/viu";
    license = licenses.mit;
    maintainers = with maintainers; [ petabyteboy ];
  };
}
