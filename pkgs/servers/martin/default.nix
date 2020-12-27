{ stdenv, rustPlatform, fetchFromGitHub, importCargo, Security }:

rustPlatform.buildRustPackage rec {
  pname = "martin";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "urbica";
    repo = pname;
    rev = "v${version}";
    sha256 = "1i9zhmjkgid4s90n52wqmrl3lwswcaxd6d47ssycgjl1nv0jla4k";
  };

  nativeBuildInputs = [ (importCargo ./Cargo.lock) ];
  buildInputs = with stdenv; lib.optional isDarwin Security;

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Blazing fast and lightweight PostGIS vector tiles server";
    homepage = "https://martin.urbica.co/";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = with platforms; linux ++ darwin;
  };
}
