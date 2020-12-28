{ stdenv
, lib
, rustPlatform
, importCargo
, fetchFromGitHub
, perl, pkgconfig, openssl, Security, libiconv, curl
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deny";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = pname;
    rev = version;
    sha256 = "0mfccjcll7dxrhdi2bhfbggmkqdp8cmq5vf8vbb05qzpvlswvkf7";
  };

  nativeBuildInputs = [ perl pkgconfig ];
  buildInputs = [ openssl (importCargo ./Cargo.lock) ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ Security libiconv curl ];

  meta = with lib; {
    description = "Cargo plugin to generate list of all licenses for a crate";
    homepage = "https://github.com/EmbarkStudios/cargo-deny";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

