{ rustPlatform, fetchFromGitHub, importCargo, lib, runCommand
, openssl, pkgconfig, stdenv, curl, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "wasm-bindgen-cli";
  version = "0.2.67";

  src = fetchFromGitHub {
    owner = "rustwasm";
    repo = "wasm-bindgen";
    rev = version;
    sha256 = "0qx178aicbn59b150j5r78zya5n0yljvw4c4lhvg8x4cpfshjb5j";
  };

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security curl ];
  nativeBuildInputs = [ pkgconfig (importCargo ./Cargo.lock) ];

  cargoBuildFlags = [ "-p" pname ];

  meta = with lib; {
    homepage = "https://rustwasm.github.io/docs/wasm-bindgen/";
    license = licenses.asl20;
    description = "Facilitating high-level interactions between wasm modules and JavaScript";
    maintainers = with maintainers; [ ma27 ];
    platforms = platforms.unix;
  };
}
