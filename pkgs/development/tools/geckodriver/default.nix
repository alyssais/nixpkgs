{ lib
, fetchzip
, rustPlatform
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

  cargoPatches = [ ./cargo-lock.patch ];
  cargoSha256 = "0jl1gvd7fhl10v7ag3ycr9ik5kp03xhnm7n4ww2ph9zv34gjhd5g";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  meta = with lib; {
    description = "Proxy for using W3C WebDriver-compatible clients to interact with Gecko-based browsers";
    homepage = "https://github.com/mozilla/geckodriver";
    license = licenses.mpl20;
    maintainers = with maintainers; [ jraygauthier ];
  };
}
