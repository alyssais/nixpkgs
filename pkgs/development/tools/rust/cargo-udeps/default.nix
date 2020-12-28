{ stdenv, rustPlatform, fetchFromGitHub, importCargo
, pkgconfig, openssl, CoreServices, Security, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-udeps";
  version = "0.1.16";

  src = fetchFromGitHub {
    owner = "est31";
    repo = pname;
    rev = "v${version}";
    sha256 = "1h89xq91gbnbagfmvig5lkxyl08qwgdaf9vr55p599pmv190xq8s";
  };

  nativeBuildInputs = [ pkgconfig (importCargo ./Cargo.lock) ];

  buildInputs = [ openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ CoreServices Security libiconv ];

  # Requires network access
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Find unused dependencies in Cargo.toml";
    homepage = "https://github.com/est31/cargo-udeps";
    license = licenses.mit;
    maintainers = with maintainers; [ b4dm4n ];
  };
}
