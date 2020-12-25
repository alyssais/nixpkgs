{ lib, fetchFromGitHub, rustPlatform, importCargo
, libpcap, libseccomp, pkgconfig
}:

rustPlatform.buildRustPackage rec {
  pname = "sniffglue";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = pname;
    rev = "v${version}";
    sha256 = "0lkz25z0qy1giss4rnhkx9fvsdd8ckf4z1gqw46zl664x96bb705";
  };

  nativeBuildInputs = [ pkgconfig (importCargo ./Cargo.lock) ];
  buildInputs = [ libpcap libseccomp ];

  meta = with lib; {
    description = "Secure multithreaded packet sniffer";
    homepage = "https://github.com/kpcyrd/sniffglue";
    license = licenses.gpl3;
    maintainers = with maintainers; [ xrelkd ];
    platforms = platforms.linux;
  };
}
