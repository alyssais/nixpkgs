{ lib, rustPlatform, fetchFromGitHub, importCargo
, fetchpatch
, fuse
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "catfs";
  version = "unstable-2020-03-21";

  src = fetchFromGitHub {
    owner = "kahing";
    repo = pname;
    rev = "daa2b85798fa8ca38306242d51cbc39ed122e271";
    sha256 = "0zca0c4n2p9s5kn8c9f9lyxdf3df88a63nmhprpgflj86bh8wgf5";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ (importCargo ./Cargo.lock) fuse ];

  # require fuse module to be active to run tests
  # instead, run command
  doCheck = false;
  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/catfs --help > /dev/null
  '';

  meta = with lib; {
    description = "Caching filesystem written in Rust";
    homepage = "https://github.com/kahing/catfs";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jonringer ];
  };
}
