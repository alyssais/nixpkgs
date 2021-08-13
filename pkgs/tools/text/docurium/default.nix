{ lib, bundlerApp }:

bundlerApp {
  pname = "docurium";
  gemdir = ./.;
  exes = [ "cm" ];

  meta = with lib; {
    homepage = "https://github.com/libgit2/docurium";
    description = "A simpler, prettier Doxygen replacement";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
