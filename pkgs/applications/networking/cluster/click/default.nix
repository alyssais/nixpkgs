{ darwin, fetchFromGitHub, rustPlatform, importCargo, stdenv }:

with rustPlatform;

buildRustPackage rec {
  pname = "click";
  version = "0.4.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "databricks";
    repo = "click";
    sha256 = "18mpzvvww2g6y2d3m8wcfajzdshagihn59k03xvcknd5d8zxagl3";
  };

  buildInputs = [ (importCargo ./Cargo.lock) ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  meta = with stdenv.lib; {
    description = ''The "Command Line Interactive Controller for Kubernetes"'';
    homepage = "https://github.com/databricks/click";
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.mbode ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
