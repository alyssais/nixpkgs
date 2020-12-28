{ stdenv, fetchFromGitHub, rustPlatform, importCargo, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "itm-tools";
  version = "unstable-2019-11-15";

  src = fetchFromGitHub {
    owner = "japaric";
    repo = pname;
    rev = "e94155e44019d893ac8e6dab51cc282d344ab700";
    sha256 = "19xkjym0i7y52cfhvis49c59nzvgw4906cd8bkz8ka38mbgfqgiy";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ (importCargo ./Cargo.lock) ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Tools for analyzing ITM traces";
    homepage = "https://github.com/japaric/itm-tools";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ hh sb0 ];
  };
}
