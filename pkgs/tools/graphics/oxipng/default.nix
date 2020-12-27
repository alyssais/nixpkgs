{ stdenv, fetchCrate, rustPlatform, importCargo }:

rustPlatform.buildRustPackage rec {
  version = "4.0.1";
  pname = "oxipng";

  src = fetchCrate {
    inherit version pname;
    sha256 = "0mgd33cb112yg1bz8jhsbk2w8p2gdiw510bfv4z82b2mg6pl6b9r";
  };

  nativeBuildInputs = [ (importCargo ./Cargo.lock) ];

  doCheck = !stdenv.isAarch64 && !stdenv.isDarwin;

  meta = with stdenv.lib; {
    homepage = "https://github.com/shssoichiro/oxipng";
    description = "A multithreaded lossless PNG compression optimizer";
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
  };
}
