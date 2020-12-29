{ stdenv, fetchgit, rustPlatform, importCargo, pkgconfig, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "eidolon";
  version = "1.4.6";

  src = fetchgit {
    url = "https://git.sr.ht/~nicohman/eidolon";
    rev = version;
    sha256 = "1yn3k569pxzw43mmsk97088xpkdc714rks3ncchbb6ccx25kgxrr";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ (importCargo ./Cargo.lock) openssl ];

  meta = with stdenv.lib; {
    description = "A single TUI-based registry for drm-free, wine and steam games on linux, accessed through a rofi launch menu";
    homepage = "https://github.com/nicohman/eidolon";
    license = licenses.gpl3;
    maintainers = with maintainers; [ _0x4A6F ];
    platforms = platforms.linux;
  };
}
