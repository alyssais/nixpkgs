{ stdenv, fetchFromGitHub, rustPlatform, installShellFiles, importCargo
, AppKit, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "the-way";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "out-of-cheese-error";
    repo = pname;
    rev = "v${version}";
    sha256 = "1whmvzpqm8x1q45mzrp4p40nj251drcryj9z4qjxgjlfsd5d1fxq";
  };

  nativeBuildInputs = [ installShellFiles (importCargo ./Cargo.lock) ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin  [ AppKit Security ];

  checkFlagsArray = stdenv.lib.optionals stdenv.isDarwin [ "--skip=copy" ];
  cargoParallelTestThreads = false;

  postInstall = ''
    $out/bin/the-way config default tmp.toml
    for shell in bash fish zsh; do
      THE_WAY_CONFIG=tmp.toml $out/bin/the-way complete $shell > the-way.$shell
      installShellCompletion the-way.$shell
    done
  '';

  meta = with stdenv.lib; {
    description = "Terminal code snippets manager";
    homepage = "https://github.com/out-of-cheese-error/the-way";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ numkem ];
  };
}
