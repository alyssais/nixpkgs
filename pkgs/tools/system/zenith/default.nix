{ stdenv, rustPlatform, importCargo, fetchFromGitHub, IOKit }:

rustPlatform.buildRustPackage rec {
  pname = "zenith";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "bvaisvil";
    repo = pname;
    rev = version;
    sha256 = "1cxmgpq07q6vfasnkx3grpx1y0f0dg6irb9kdn17nwrypy44l92d";
  };

  nativeBuildInputs = [ (importCargo ./Cargo.lock) ];
  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ IOKit ];

  meta = with stdenv.lib; {
    description = "Sort of like top or htop but with zoom-able charts, network, and disk usage";
    homepage = "https://github.com/bvaisvil/zenith";
    license = licenses.mit;
    maintainers = with maintainers; [ bbigras ];
    # doesn't build on aarch64 https://github.com/bvaisvil/zenith/issues/19
    # see https://github.com/NixOS/nixpkgs/pull/88616
    platforms = platforms.x86;
  };
}
