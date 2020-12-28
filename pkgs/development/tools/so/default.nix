{ stdenv, rustPlatform, fetchFromGitHub, importCargo
, openssl, pkg-config, libiconv, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "so";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "samtay";
    repo = pname;
    rev = "v${version}";
    sha256 = "09zswxxli9f5ayjwmvqhkp1yv2s4f435dcfp4cyia1zddbrh2zck";
  };

  nativeBuildInputs = [ pkg-config (importCargo ./Cargo.lock) ];
  buildInputs = [ openssl ] ++ stdenv.lib.optionals stdenv.isDarwin [
    libiconv Security
  ];

  meta = with stdenv.lib; {
    description = "A TUI interface to the StackExchange network";
    homepage = "https://github.com/samtay/so";
    license = licenses.mit;
    maintainers = with maintainers; [ mredaelli ];
  };
}
