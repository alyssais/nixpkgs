{ stdenv
, fetchFromGitHub
, fetchpatch
, rustPlatform
, importCargo
, darwin
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "grex";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "pemistahl";
    repo = pname;
    rev = "v${version}";
    sha256 = "1viph7ki6f2akc5mpbgycacndmxnv088ybfji2bfdbi5jnpyavvs";
  };

  nativeBuildInputs = [ (importCargo ./Cargo.lock) ];
  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/grex --help > /dev/null
  '';

  meta = with stdenv.lib; {
    description = "A command-line tool for generating regular expressions from user-provided test cases";
    homepage = "https://github.com/pemistahl/grex";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
