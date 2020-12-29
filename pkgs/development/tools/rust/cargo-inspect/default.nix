{ stdenv, lib, rustPlatform, fetchFromGitHub, importCargo, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-inspect";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "mre";
    repo = pname;
    rev = version;
    sha256 = "026vc8d0jkc1d7dlp3ldmwks7svpvqzl0k5niri8a12cl5w5b9hj";
  };

  buildInputs = [ (importCargo ./Cargo.lock) ]
    ++ lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "See what Rust is doing behind the curtains";
    homepage = "https://github.com/mre/cargo-inspect";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ minijackson ];
  };
}
