{ stdenv, lib, fetchFromGitHub, rustPlatform, importCargo, cmake, libzip, gnupg
, libiconv, CoreFoundation, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "sit";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "sit-fyi";
    repo = "sit";
    rev = "v${version}";
    sha256 = "06xkhlfix0h6di6cnvc4blbj3mjy90scbh89dvywbx16wjlc79pf";
  };

  buildInputs = [ cmake libzip gnupg (importCargo ./Cargo.lock) ] ++
    (lib.optionals stdenv.isDarwin [ libiconv CoreFoundation Security ]);

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Serverless Information Tracker";
    homepage = "https://sit.fyi/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dywedir yrashk ];
    # Upstream has not had a release in several years, and dependencies no
    # longer compile with the latest Rust compiler.
    broken = true;
  };
}
