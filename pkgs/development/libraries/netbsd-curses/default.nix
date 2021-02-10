{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "netbsd-curses";
  version = "0.3.1";

  src = fetchurl {
    url = "https://ftp.barfooze.de/pub/sabotage/tarballs/netbsd-curses-${version}.tar.xz";
    sha256 = "0crwvx9z25rhz5i37zhfchcc3hi2b2wagri1rfp52mpc5nqrdgds";
  };

  makeFlags = [ "PREFIX=$(out)" ];
  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/sabotage-linux/netbsd-curses";
    description = "Portable version of libcurses from NetBSD";
    maintainers = with maintainers; [ qyliss ];
    license = with licenses; [ bsd2 bsd3 ];
    platforms = platforms.unix;
  };
}
