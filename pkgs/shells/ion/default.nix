{ stdenv, fetchFromGitHub, rustPlatform, importCargo }:

rustPlatform.buildRustPackage rec {
  pname = "ion";
  version = "unstable-2020-03-22";

  src = fetchFromGitHub {
    owner = "redox-os";
    repo = "ion";
    rev = "1fbd29a6d539faa6eb0f3186a361e208d0a0bc05";
    sha256 = "0r5c87cs8jlc9kpb6bi2aypldw1lngf6gzjirf13gi7iy4q08ik7";
  };

  nativeBuildInputs = [ (importCargo ./Cargo.lock) ];

  meta = with stdenv.lib; {
    description = "Modern system shell with simple (and powerful) syntax";
    homepage = "https://gitlab.redox-os.org/redox-os/ion";
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
  };

  passthru = {
    shellPath = "/bin/ion";
  };
}
