{ stdenv, fetchFromGitHub, rustPlatform, importCargo, Security }:

rustPlatform.buildRustPackage rec {
  pname = "diffr";
  version = "v0.1.4";

  src = fetchFromGitHub {
    owner = "mookid";
    repo = pname;
    rev = version;
    sha256 = "18ks5g4bx6iz9hdjxmi6a41ncxpb1hnsscdlddp2gr40k3vgd0pa";
  };

  nativeBuildInputs = [ (importCargo ./Cargo.lock) ];
  buildInputs = (stdenv.lib.optional stdenv.isDarwin Security);

  preCheck = ''
    export DIFFR_TESTS_BINARY_PATH=$releaseDir/diffr
  '';

  meta = with stdenv.lib; {
    description = "Yet another diff highlighting tool";
    homepage = "https://github.com/mookid/diffr";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ davidtwco ];
  };
}
