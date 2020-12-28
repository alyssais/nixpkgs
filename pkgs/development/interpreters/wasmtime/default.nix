{ rustPlatform, fetchFromGitHub, lib, importCargo
, python, cmake, llvmPackages, clang, stdenv, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "wasmtime";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = pname;
    rev = "v${version}";
    sha256 = "0q7wsnq5zdskxwzsxwm98jfnv2frnwca1dkhwndcn9yyz2gyw57m";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ python cmake clang ];
  buildInputs = [ llvmPackages.libclang (importCargo ./Cargo.lock) ] ++
   lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];
  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";

  doCheck = true;

  meta = with lib; {
    description = "Standalone JIT-style runtime for WebAssembly, using Cranelift";
    homepage = "https://github.com/bytecodealliance/wasmtime";
    license = licenses.asl20;
    maintainers = [ maintainers.matthewbauer ];
    platforms = platforms.unix;
  };
}
