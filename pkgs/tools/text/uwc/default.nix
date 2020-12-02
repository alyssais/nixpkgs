{ rustPlatform, lib, fetchFromGitLab, importCargo }:

rustPlatform.buildRustPackage rec {
  pname = "uwc";
  version = "1.0.4";

  src = fetchFromGitLab {
    owner = "dead10ck";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ywqq9hrrm3frvd2sswknxygjlxi195kcy7g7phwq63j7hkyrn50";
  };

  nativeBuildInputs = [ (importCargo ./Cargo.lock) ];

  doCheck = true;

  meta = with lib; {
    description = "Like wc, but unicode-aware, and with per-line mode";
    homepage = "https://gitlab.com/dead10ck/uwc";
    license = licenses.mit;
    maintainers = with maintainers; [ ShamrockLee ];
  };
}
