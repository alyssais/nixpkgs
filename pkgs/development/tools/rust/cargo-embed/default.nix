{ stdenv, lib
, rustPlatform, fetchFromGitHub, importCargo
, libusb1, pkg-config, rustfmt }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-embed";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "probe-rs";
    repo = pname;
    rev = "v${version}";
    sha256 = "0klkgl7c42vhqxj6svw26lcr7rccq89bl17jn3p751x6281zvr35";
  };

  nativeBuildInputs = [ pkg-config rustfmt ];
  buildInputs = [ libusb1 (importCargo ./Cargo.lock) ];

  meta = with lib; {
    description = "A cargo extension for working with microcontrollers";
    homepage = "https://probe.rs/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ fooker ];
  };
}
