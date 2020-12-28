{ lib, fetchFromGitHub, rustPlatform, importCargo, libseccomp }:

rustPlatform.buildRustPackage rec {
  pname = "railcar";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "oracle";
    repo = "railcar";
    rev = "v${version}";
    sha256 = "09zn160qxd7760ii6rs5nhr00qmaz49x1plclscznxh9hinyjyh9";
  };

  buildInputs = [ libseccomp (importCargo ./Cargo.lock) ];

  meta = with lib; {
    description = "Rust implementation of the Open Containers Initiative oci-runtime";
    homepage = "https://github.com/oracle/railcar";
    license = with licenses; [ asl20 /* or */ upl ];
    maintainers = [ maintainers.spacekookie ];
  };
}
