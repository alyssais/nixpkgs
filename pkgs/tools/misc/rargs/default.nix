{ stdenv, rustPlatform, fetchFromGitHub, importCargo }:

rustPlatform.buildRustPackage rec {
  pname   = "rargs";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner  = "lotabout";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "188gj05rbivci1z4z29vwdwxlj2w01v5i4avwrxjnj1dd6mmlbxd";
  };

  nativeBuildInputs = [ (importCargo ./Cargo.lock) ];

  doCheck=false;  # `rargs`'s test depends on the deprecated `assert_cli` crate, which in turn is not in Nixpkgs

  meta = with stdenv.lib; {
    description = "xargs + awk with pattern matching support";
    homepage    = "https://github.com/lolabout/rargs";
    license     = with licenses; [ mit ];
    maintainers = with maintainers; [ pblkt ]; 
  };
}
