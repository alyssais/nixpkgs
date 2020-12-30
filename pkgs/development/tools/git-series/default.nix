{ stdenv, fetchFromGitHub, fetchpatch, rustPlatform, importCargo
, openssl, cmake, perl, pkgconfig, zlib, curl, libgit2, libssh2
}:

with rustPlatform;

buildRustPackage rec {
  version = "0.9.1";
  pname = "git-series";

  src = fetchFromGitHub {
    owner = "git-series";
    repo = "git-series";
    rev = version;
    sha256 = "07mgq5h6r1gf3jflbv2khcz32bdazw7z1s8xcsafdarnm13ps014";
  };

  LIBGIT2_SYS_USE_PKG_CONFIG = true;
  LIBSSH2_SYS_USE_PKG_CONFIG = true;
  nativeBuildInputs = [ cmake pkgconfig perl ];
  buildInputs = [ (importCargo ./Cargo.lock) openssl zlib curl libgit2 libssh2 ];

  postBuild = ''
    install -D "$src/git-series.1" "$out/man/man1/git-series.1"
  '';

  meta = with stdenv.lib; {
    description = "A tool to help with formatting git patches for review on mailing lists";
    longDescription = ''
          git series tracks changes to a patch series over time. git
          series also tracks a cover letter for the patch series,
          formats the series for email, and prepares pull requests.
    '';
    homepage = "https://github.com/git-series/git-series";

    license = licenses.mit;
    maintainers = with maintainers; [ edef vmandela ];
  };
}
