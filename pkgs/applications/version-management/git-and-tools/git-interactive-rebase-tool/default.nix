{ stdenv, fetchFromGitHub, rustPlatform, importCargo
, ncurses5, libiconv, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "git-interactive-rebase-tool";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "MitMaro";
    repo = pname;
    rev = version;
    sha256 = "10z3di2qypgsmg2z7xfs9nlrf9vng5i7l8dvqadv1l4lb9zz7i8q";
  };

  buildInputs = [ ncurses5 (importCargo ./Cargo.lock) ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ];

  cargoParallelTestThreads = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/MitMaro/git-interactive-rebase-tool";
    description = "Native cross platform full feature terminal based sequence editor for git interactive rebase";
    changelog = "https://github.com/MitMaro/git-interactive-rebase-tool/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ masaeedu zowoq ];
  };
}
