{ fetchFromGitHub, lib, rustPlatform, importCargo }:

rustPlatform.buildRustPackage rec {
  pname = "mq-cli";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner  = "aprilabank";
    repo   = "mq-cli";
    rev    = "v${version}";
    sha256 = "02z85waj5jc312biv2qhbgplsggxgjmfmyv9v8b1ky0iq1mpxjw7";
  };

  nativeBuildInputs = [ (importCargo ./Cargo.lock) ];

  meta = with lib; {
    description      = "CLI tool to manage POSIX message queues";
    homepage         = "https://github.com/aprilabank/mq-cli";
    license          = licenses.mit;
    maintainers      = with maintainers; [ tazjin ];
    platforms        = platforms.linux;
    repositories.git = "git://github.com/aprilabank/mq-cli.git";
  };
}
