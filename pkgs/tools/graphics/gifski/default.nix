{ stdenv, rustPlatform, fetchFromGitHub, importCargo, pkgconfig }:

rustPlatform.buildRustPackage rec {
  pname = "gifski";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "ImageOptim";
    repo = "gifski";
    rev = version;
    sha256 = "0mr4ni75klmzfjivfv5xmcdw03y1gjvkz1d297gwh46zq1q7blf3";
  };

  nativeBuildInputs = [ pkgconfig (importCargo ./Cargo.lock) ];

  meta = with stdenv.lib; {
    description = "GIF encoder based on libimagequant (pngquant)";
    homepage = "https://gif.ski/";
    license = licenses.agpl3;
    maintainers = [ maintainers.marsam ];
  };
}
