{ lib, fetchFromGitHub, rustPlatform, importCargo, libusb-compat-0_1 }:

rustPlatform.buildRustPackage rec {
  pname = "wishbone-tool";
  version = "0.6.9";

  src = fetchFromGitHub {
    owner = "litex-hub";
    repo = "wishbone-utils";
    rev = "v${version}";
    sha256 = "0gq359ybxnqvcp93cn154bs9kwlai62gnm71yvl2nhzjdlcr3fhp";
  };
  sourceRoot = "source/wishbone-tool";

  buildInputs = [ libusb-compat-0_1 (importCargo ./Cargo.lock) ];

  meta = with lib; {
    description = "Manipulate a Wishbone device over some sort of bridge";
    homepage = "https://github.com/litex-hub/wishbone-utils";
    license = licenses.bsd2;
    maintainers = with maintainers; [ edef ];
    platforms = platforms.linux;
  };
}
