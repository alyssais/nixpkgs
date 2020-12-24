{ stdenv, fetchFromGitHub, rustPlatform, importCargo, Security, fetchpatch }:

rustPlatform.buildRustPackage rec {
  pname = "jwt-cli";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "mike-engel";
    repo = pname;
    rev = version;
    sha256 = "07mnkr7hi29fyyyn7llb30p4ndiqz4gf1lnhm44qm09alaxmfvws";
  };

  nativeBuildInputs = [ (importCargo ./Cargo.lock) ];
  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  doInstallCheck = true;
  installCheckPhase = "$out/bin/jwt --version";

  meta = with stdenv.lib; {
    description = "Super fast CLI tool to decode and encode JWTs";
    homepage = "https://github.com/mike-engel/jwt-cli";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ rycee ];
  };
}
