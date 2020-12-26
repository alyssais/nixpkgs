{ stdenv, fetchFromGitHub, rustPlatform, installShellFiles, importCargo
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "shadowenv";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = version;
    sha256 = "1h8hfyxxl4bpx8azzxj0snmzccn6xjd9vc2iyp8i2ar7aiyhf5yd";
  };

  nativeBuildInputs = [ installShellFiles (importCargo ./Cargo.lock) ];
  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  postInstall = ''
    installManPage man/man1/shadowenv.1
    installManPage man/man5/shadowlisp.5
    installShellCompletion --bash sh/completions/shadowenv.bash
    installShellCompletion --fish sh/completions/shadowenv.fish
    installShellCompletion --zsh sh/completions/_shadowenv
  '';

  meta = with stdenv.lib; {
    homepage = "https://shopify.github.io/shadowenv/";
    description = "reversible directory-local environment variable manipulations";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
