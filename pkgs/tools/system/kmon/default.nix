{ lib, fetchFromGitHub, rustPlatform, python3, importCargo, libxcb }:

rustPlatform.buildRustPackage rec {
  pname = "kmon";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
    sha256 = "0j6w4rg2gybcy1cv812qixravy0z0xpp33snrng11q802zq3mkmq";
  };

  nativeBuildInputs = [ python3 (importCargo ./Cargo.lock) ];

  buildInputs = [ libxcb ];

  postInstall = ''
    install -D man/kmon.8 -t $out/share/man/man8/
  '';

  meta = with lib; {
    description = "Linux Kernel Manager and Activity Monitor";
    homepage = "https://github.com/orhun/kmon";
    license = with licenses; [ gpl3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ misuzu ];
  };
}
