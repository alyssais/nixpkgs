{ stdenv
, fetchFromGitHub
, rustPlatform
, importCargo
, pkg-config
, openssl
, Security
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "dogdns";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "ogham";
    repo = "dog";
    rev = "v${version}";
    sha256 = "088ib0sncv0vrvnqfvxf5zc79v7pnxd2cmgp4378r6pmgax9z9zy";
  };

  nativeBuildInputs = [ installShellFiles (importCargo ./Cargo.lock) ]
    ++ stdenv.lib.optionals stdenv.isLinux [ pkg-config ];
  buildInputs = stdenv.lib.optionals stdenv.isLinux [ openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ Security ];

  postInstall = ''
    installShellCompletion completions/dog.{bash,fish,zsh}
  '';

  meta = with stdenv.lib; {
    description = "Command-line DNS client";
    homepage = "https://dns.lookup.dog";
    license = licenses.eupl12;
    maintainers = with maintainers; [ bbigras ];
  };
}
