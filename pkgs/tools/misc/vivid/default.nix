{ stdenv, fetchFromGitHub, rustPlatform, importCargo }:

rustPlatform.buildRustPackage rec {
  pname = "vivid";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = pname;
    rev = "v${version}";
    sha256 = "0m928hy2q8byfpm55nziiz86gcnhdnw3zpj78d8wx0pp318zjbla";
  };

  nativeBuildInputs = [ (importCargo ./Cargo.lock) ];

  meta = with stdenv.lib; {
    description = "A generator for LS_COLORS with support for multiple color themes";
    homepage = "https://github.com/sharkdp/vivid";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.dtzWill ];
    platforms = platforms.unix;
  };
}
