{ lib
, fetchzip
, rustPlatform
, importCargo
, stdenv
, darwin
}:

rustPlatform.buildRustPackage {
  version = "0.28.0";
  pname = "geckodriver";
  sourceRoot = "source/testing/geckodriver";

  # Source revisions are noted alongside the binary releases:
  # https://github.com/mozilla/geckodriver/releases
  src = (fetchzip {
    url = "https://hg.mozilla.org/mozilla-central/archive/c00d2b6acd3fb1b197b25662fba0a96c11669b66.zip/testing";
    sha256 = "1jb29z4507sky85hj7kfw0mmvsqd605wilcfkrsff04pqzryc2lk";
  }).overrideAttrs (_: {
    # normally guessed by the url's file extension, force it to unpack properly
    unpackCmd = "unzip $curSrc";
  });

  nativeBuildInputs = [ (importCargo ./Cargo.lock) ];
  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  meta = with lib; {
    description = "Proxy for using W3C WebDriver-compatible clients to interact with Gecko-based browsers";
    homepage = "https://github.com/mozilla/geckodriver";
    license = licenses.mpl20;
    maintainers = with maintainers; [ jraygauthier ];
  };
}
