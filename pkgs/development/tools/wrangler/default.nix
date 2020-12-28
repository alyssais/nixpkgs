{ stdenv, fetchFromGitHub, rustPlatform, importCargo
, pkg-config, openssl, curl, darwin, perl
}:

rustPlatform.buildRustPackage rec {
  pname = "wrangler";
  version = "1.12.2";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = pname;
    rev = "v${version}";
    sha256 = "1w0j6if1fnih1036hlb9a3c6wgjw4p057llhjf0f3d568ah1244a";
  };

  nativeBuildInputs = [ perl (importCargo ./Cargo.lock) ]
    ++ stdenv.lib.optionals stdenv.isLinux [ pkg-config ];

  buildInputs = stdenv.lib.optionals stdenv.isLinux [ openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [
      curl
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.CoreServices
      darwin.apple_sdk.frameworks.CoreFoundation
    ];

  # tries to use "/homeless-shelter" and fails
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A CLI tool designed for folks who are interested in using Cloudflare Workers";
    homepage = "https://github.com/cloudflare/wrangler";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
