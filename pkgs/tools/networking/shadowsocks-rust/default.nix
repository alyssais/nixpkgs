{ stdenv, fetchFromGitHub, rustPlatform, importCargo
, pkgconfig, openssl, libsodium, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "shadowsocks-rust";
  version = "1.8.23";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "shadowsocks";
    repo = pname;
    sha256 = "1ylasv33478cgwmr8wrd4705azfzrw495w629ncynamv7z17w3k3";
  };

  SODIUM_USE_PKG_CONFIG = 1;

  buildInputs = [ openssl libsodium ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ Security ];
  nativeBuildInputs = [ pkgconfig (importCargo ./Cargo.lock) ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/shadowsocks/shadowsocks-rust";
    description = "A Rust port of shadowsocks";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
