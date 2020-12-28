{ lib, fetchFromGitHub, rustPlatform, importCargo
, openssl, zeromq, czmq, pkgconfig, cmake, zlib }:

with rustPlatform;

buildRustPackage rec {
  pname = "intecture-agent";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "intecture";
    repo = "agent";
    rev = version;
    sha256 = "0j27qdgyxybaixggh7k57mpm6rifimn4z2vydk463msc8b3kgywj";
  };

  buildInputs = [ openssl zeromq czmq zlib ];

  nativeBuildInputs = [ pkgconfig cmake (importCargo ./Cargo.lock) ];

  meta = with lib; {
    description = "Authentication client/server for Intecture components";
    homepage = "https://intecture.io";
    license = licenses.mpl20;
    maintainers = [ maintainers.rushmorem ];
  };
}
