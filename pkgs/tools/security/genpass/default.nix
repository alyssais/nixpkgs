{ stdenv
, fetchgit
, rustPlatform
, importCargo
, CoreFoundation
, libiconv
, Security
}:
rustPlatform.buildRustPackage rec {
  pname = "genpass";
  version = "0.4.9";

  src = fetchgit {
    url = "https://git.sr.ht/~cyplo/genpass";
    rev = "v${version}";
    sha256 = "1dpv2iyd48xd8yw9bmymjjrkhsgmpwvsl5b9zx3lpaaq59ypi9g9";
  };

  nativeBuildInputs = [ (importCargo ./Cargo.lock) ];
  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ CoreFoundation libiconv Security ];

  meta = with stdenv.lib; {
    description = "A simple yet robust commandline random password generator";
    homepage = "https://sr.ht/~cyplo/genpass/";
    license = licenses.agpl3;
    maintainers = with maintainers; [ cyplo ];
  };
}
