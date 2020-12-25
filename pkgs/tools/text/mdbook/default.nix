{ stdenv, fetchFromGitHub, rustPlatform, importCargo, CoreServices, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "mdBook";
    rev = "v${version}";
    sha256 = "0nqr5a27i91m71fhpycf60q54qplc920y1fmk9hav3pbb9wcc5dl";
  };

  nativeBuildInputs = [ (importCargo ./Cargo.lock) ];
  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with stdenv.lib; {
    description = "Create books from MarkDown";
    homepage = "https://github.com/rust-lang-nursery/mdbook";
    license = [ licenses.mpl20 ];
    maintainers = [ maintainers.havvy ];
  };
}
