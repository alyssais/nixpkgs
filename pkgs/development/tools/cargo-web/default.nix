{ stdenv, fetchFromGitHub, openssl, perl, pkgconfig, rustPlatform, importCargo
, CoreServices, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-web";
  version = "0.6.26";

  src = fetchFromGitHub {
    owner = "koute";
    repo = pname;
    rev = version;
    sha256 = "1dl5brj5fnmxmwl130v36lvy4j64igdpdvjwmxw3jgg2c6r6b7cd";
  };

  nativeBuildInputs = [ openssl perl pkgconfig ];
  buildInputs = [ (importCargo ./Cargo.lock) ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ CoreServices Security ];

  meta = with stdenv.lib; {
    description = "A Cargo subcommand for the client-side Web";
    homepage = "https://github.com/koute/cargo-web";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ kevincox ];
  };
}
