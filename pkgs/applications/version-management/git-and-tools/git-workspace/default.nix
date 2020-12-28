{ stdenv
, fetchFromGitHub
, rustPlatform
, importCargo
, Security
, pkgconfig, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "git-workspace";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "orf";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ckfk221ag6yhbqxfz432wpgbhddgzgdsaxhl1ymw90pwpnz717y";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl (importCargo ./Cargo.lock) ]
    ++ stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "Sync personal and work git repositories from multiple providers";
    homepage = "https://github.com/orf/git-workspace";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ misuzu ];
  };
}
