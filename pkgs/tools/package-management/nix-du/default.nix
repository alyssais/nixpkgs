{ stdenv, fetchFromGitHub, rustPlatform, importCargo
, nix, boost, graphviz, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-du";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "symphorien";
    repo = "nix-du";
    rev = "v${version}";
    sha256 = "0h8ya0nn65hbyi3ssmrjarfxadx2sa61sspjlrln8knk7ppxk3mq";
  };

  doCheck = true;
  checkInputs = [ nix graphviz ];

  nativeBuildInputs = [ (importCargo ./Cargo.lock) ];
  buildInputs = [
    boost
    nix
  ] ++ stdenv.lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  meta = with stdenv.lib; {
    description = "A tool to determine which gc-roots take space in your nix store";
    homepage = "https://github.com/symphorien/nix-du";
    license = licenses.lgpl3;
    maintainers = [ maintainers.symphorien ];
    platforms = platforms.unix;
  };
}
