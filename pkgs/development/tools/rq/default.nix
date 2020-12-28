{ stdenv, lib, fetchFromGitHub, rustPlatform, importCargo
, libiconv, llvmPackages, v8
}:

rustPlatform.buildRustPackage rec {
  pname = "rq";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "dflemstr";
    repo = pname;
    rev = "v${version}";
    sha256 = "0km9d751jr6c5qy4af6ks7nv3xfn13iqi03wq59a1c73rnf0zinp";
  };

  buildInputs = [ llvmPackages.clang-unwrapped v8 (importCargo ./Cargo.lock) ]
  ++ lib.optionals stdenv.isDarwin [ libiconv ];

  configurePhase = ''
    export LIBCLANG_PATH="${llvmPackages.clang-unwrapped}/lib"
    export V8_SOURCE="${v8}"
  '';

  meta = with lib; {
    description = "A tool for doing record analysis and transformation";
    homepage = "https://github.com/dflemstr/rq";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ aristid Br1ght0ne ];
  };
}
