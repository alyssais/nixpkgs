{ stdenv, lib, fetchFromGitHub, rustPlatform, importCargo
, pkgconfig, openssl, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "hydra-cli";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "nlewo";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fd3swdjx249971ak1bgndm5kh6rlzbfywmydn122lhfi6ry6a03";
  };

  buildInputs = [ openssl (importCargo ./Cargo.lock) ]
                ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  nativeBuildInputs = [
    pkgconfig
  ];

  meta = with stdenv.lib; {
    description = "A client for the Hydra CI";
    homepage = "https://github.com/nlewo/hydra-cli";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ gilligan lewo ];
  };

}
