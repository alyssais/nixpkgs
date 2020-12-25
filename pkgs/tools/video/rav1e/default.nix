{ rustPlatform, fetchFromGitHub, lib, importCargo, nasm, cargo-c }:

rustPlatform.buildRustPackage rec {
  pname = "rav1e";
  version = "0.4.0-alpha";

  src = fetchFromGitHub {
    owner = "xiph";
    repo = "rav1e";
    rev = "v${version}";
    sha256 = "1fw1gxi8330kfhl9hfzpn0lcmyn5604lc74d6g6iadzz2hmv4mb9";
  };

  nativeBuildInputs = [ nasm cargo-c (importCargo ./Cargo.lock) ];

  postBuild = ''
    cargo cbuild --release --frozen --prefix=${placeholder "out"}
  '';

  postInstall = ''
    cargo cinstall --release --frozen --prefix=${placeholder "out"}
  '';

  meta = with lib; {
    description = "The fastest and safest AV1 encoder";
    longDescription = ''
      rav1e is an AV1 video encoder. It is designed to eventually cover all use
      cases, though in its current form it is most suitable for cases where
      libaom (the reference encoder) is too slow.
      Features: https://github.com/xiph/rav1e#features
    '';
    homepage = "https://github.com/xiph/rav1e";
    changelog = "https://github.com/xiph/rav1e/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = [ maintainers.primeos ];
  };
}
