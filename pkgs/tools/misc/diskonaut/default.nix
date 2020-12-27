{ stdenv, rustPlatform, fetchFromGitHub, importCargo }:

rustPlatform.buildRustPackage rec {
  pname = "diskonaut";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "imsnif";
    repo = "diskonaut";
    rev = version;
    sha256 = "1pmbag3r2ka30zmy2rs9jps2qxj2zh0gy4a774v9yhf0b6qjid54";
  };

  nativeBuildInputs = [ (importCargo ./Cargo.lock) ];

  meta = with stdenv.lib; {
    description = "Terminal disk space navigator";
    homepage = "https://github.com/imsnif/diskonaut";
    license = licenses.mit;
    maintainers = with maintainers; [ evanjs ];
  };
}
