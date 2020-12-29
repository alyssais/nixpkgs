{ stdenv, fetchFromGitHub, rustPlatform, importCargo
, pkgconfig, openssl, libsodium, llvmPackages, clang, lzma, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "rdedup";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "dpc";
    repo = "rdedup";
    rev = "rdedup-v${version}";
    sha256 = "0y34a3mpghdmcb2rx4z62q0s351bfmy1287d75mm07ryfgglgsd7";
  };

  nativeBuildInputs = [ pkgconfig llvmPackages.libclang clang ];
  buildInputs = [ (importCargo ./Cargo.lock) openssl libsodium lzma ]
    ++ (stdenv.lib.optional stdenv.isDarwin Security);

  configurePhase = ''
    export LIBCLANG_PATH="${llvmPackages.libclang}/lib"
  '';

  meta = with stdenv.lib; {
    description = "Data deduplication with compression and public key encryption";
    homepage = "https://github.com/dpc/rdedup";
    license = licenses.mpl20;
    maintainers = with maintainers; [ dywedir ];
    broken = stdenv.isDarwin;
  };
}
