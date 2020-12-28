{ stdenv, fetchFromGitHub, rustPlatform, importCargo
, pkg-config, openssl, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "git-backup";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "jsdw";
    repo = pname;
    rev = "v${version}";
    sha256 = "0h31j8clvk4gkw4mgva9p0ypf26zhf7f0y564fdmzyw6rsz9wzcj";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl (importCargo ./Cargo.lock) ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/jsdw/git-backup";
    description = "A tool to help you backup your git repositories from services like GitHub";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
