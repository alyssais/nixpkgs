{ stdenv, rustPlatform, fetchFromGitHub, importCargo, installShellFiles
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "kubie";
  version = "0.9.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "sbstp";
    repo = "kubie";
    sha256 = "0q1dxry10iaf7zx6vyr0da4ihqx7l8dlyhlqm8qqfz913h2wam8c";
  };

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = [ (importCargo ./Cargo.lock) ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ Security ];

  postInstall = ''
    installShellCompletion completion/kubie.bash
  '';

  meta = with stdenv.lib; {
    description = "Shell independent context and namespace switcher for kubectl";
    homepage = "https://github.com/sbstp/kubie";
    license = with licenses; [ zlib ];
    maintainers = with maintainers; [ illiusdope ];
  };
}
