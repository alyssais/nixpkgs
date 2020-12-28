{ stdenv, fetchFromGitHub, rustPlatform, importCargo
, openssl, pkgconfig, python3, xorg, cmake, libgit2, darwin, curl
}:

rustPlatform.buildRustPackage rec {
  pname = "amp";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "jmacdonald";
    repo = pname;
    rev = version;
    sha256 = "0l1vpcfq6jrq2dkrmsa4ghwdpp7c54f46gz3n7nk0i41b12hnigw";
  };

  nativeBuildInputs = [ cmake pkgconfig python3 ];
  buildInputs = [ (importCargo ./Cargo.lock) openssl xorg.libxcb libgit2 ]
    ++ stdenv.lib.optionals stdenv.isDarwin
      (with darwin.apple_sdk.frameworks; [ curl Security AppKit ]);

  # Tests need to write to the theme directory in HOME.
  preCheck = "export HOME=`mktemp -d`";

  meta = with stdenv.lib; {
    description = "A modern text editor inspired by Vim";
    homepage = "https://amp.rs";
    license = [ licenses.gpl3 ];
    maintainers = [ maintainers.sb0 ];
    platforms = platforms.unix;
  };
}
