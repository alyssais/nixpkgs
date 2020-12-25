{ stdenv
, rustPlatform
, fetchFromGitHub
, importCargo
, openssl
, pkg-config
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "tunnelto";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "agrinman";
    repo = pname;
    rev = version;
    sha256 = "1vvb619cq3n88y2s8lncwcyrhb5s4gpjfiyia91pilcpnfdb04y2";
  };

  nativeBuildInputs = [ (importCargo ./Cargo.lock) ]
    ++ stdenv.lib.optionals stdenv.isLinux [ pkg-config ];
  buildInputs = [ ]
    ++ stdenv.lib.optionals stdenv.isLinux [ openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    description = "Expose your local web server to the internet with a public URL";
    homepage = "https://tunnelto.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
