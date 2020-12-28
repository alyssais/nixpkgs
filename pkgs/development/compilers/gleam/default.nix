{ stdenv, rustPlatform, fetchFromGitHub, importCargo
, pkg-config, openssl, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "gleam";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    rev = "v${version}";
    sha256 = "0n23pn7jk4i2waczw5cczsb7v4lal4x6xqmp01y280hb2vk176fg";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl (importCargo ./Cargo.lock) ] ++
    stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    description = "A statically typed language for the Erlang VM";
    homepage = "https://gleam.run/";
    license = licenses.asl20;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
