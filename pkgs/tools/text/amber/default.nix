{ stdenv, fetchFromGitHub, rustPlatform, importCargo
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "amber";
  version = "0.5.8";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = pname;
    rev = "v${version}";
    sha256 = "0j9h9zzg6n4mhq2bqj71k5db595ilbgd9dn6ygmzsm74619q4454";
  };

  nativeBuildInputs = [ (importCargo ./Cargo.lock) ];
  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "A code search-and-replace tool";
    homepage = "https://github.com/dalance/amber";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.bdesham ];
  };
}
