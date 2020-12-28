{ fetchFromGitHub, rustPlatform, importCargo
, cmake, SDL2, boost, fltk
}:

rustPlatform.buildRustPackage rec {
  pname = "ja2-stracciatella";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "ja2-stracciatella";
    repo = "ja2-stracciatella";
    rev = "v${version}";
    sha256 = "1pyn23syg70kiyfbs3pdlq0ixd2bxhncbamnic43rym3dmd52m29";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ SDL2 fltk boost (importCargo ./Cargo.lock) ];

  configurePhase = "cmakeConfigurePhase";

  # Use the stdenv default phases (./configure; make) instead of the
  # ones from buildRustPackage.
  buildPhase = "buildPhase";
  checkPhase = "checkPhase";
  installPhase = "installPhase";

  preConfigure = ''
    cmakeFlagsArray+=("-DEXTRA_DATA_DIR=$out/share/ja2")
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Jagged Alliance 2, with community fixes";
    license = "SFI Source Code license agreement";
    homepage = "https://ja2-stracciatella.github.io/";
  };
}
