{ lib, rustPlatform, fetchFromGitHub, importCargo, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "pueue";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "Nukesor";
    repo = pname;
    rev = "v${version}";
    sha256 = "0rqnbils0r98qglhm2jafw5d119fqdzszmk825yc0bma4icm7xzp";
  };

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = [ (importCargo ./Cargo.lock) ];

  checkFlags = [ "--skip=test_single_huge_payload" "--skip=test_create_unix_socket" ];

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/pueue completions $shell .
    done
    installShellCompletion pueue.{bash,fish} _pueue
  '';

  meta = with lib; {
    description = "A daemon for managing long running shell commands";
    homepage = "https://github.com/Nukesor/pueue";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
