{ stdenv, fetchCrate, rustPlatform, installShellFiles, importCargo
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "hyperfine";
  version = "1.11.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "0dla2jzwcxkdx3n4fqkkh6wirqs2f31lvqsw2pjf1jbnnif54mzh";
  };

  nativeBuildInputs = [ installShellFiles (importCargo ./Cargo.lock) ];
  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  postInstall = ''
    installManPage doc/hyperfine.1

    installShellCompletion \
      $releaseDir/build/hyperfine-*/out/hyperfine.{bash,fish} \
      --zsh $releaseDir/build/hyperfine-*/out/_hyperfine
  '';

  meta = with stdenv.lib; {
    description = "Command-line benchmarking tool";
    homepage    = "https://github.com/sharkdp/hyperfine";
    license     = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.thoughtpolice ];
  };
}
