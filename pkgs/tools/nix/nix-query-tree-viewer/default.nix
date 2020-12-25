{ stdenv, fetchFromGitHub, rustPlatform, importCargo
, glib, gtk3, wrapGAppsHook
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-query-tree-viewer";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "cdepillabout";
    repo  = "nix-query-tree-viewer";
    rev = "v${version}";
    sha256 = "0vjcllhgq64n7mwxvyhmbqd6fpa9lwrpsnggc1kdlgd14ggq6jj6";
  };

  nativeBuildInputs = [
    wrapGAppsHook
    (importCargo ./Cargo.lock)
  ];

  buildInputs = [
    glib
    gtk3
  ];

  meta = with stdenv.lib; {
    description = "GTK viewer for the output of `nix store --query --tree`";
    homepage    = "https://github.com/cdepillabout/nix-query-tree-viewer";
    license     = with licenses; [ mit ];
    maintainers = with maintainers; [ cdepillabout ];
    platforms   = platforms.unix;
  };
}
