{ stdenv, rustPlatform, fetchFromGitHub, importCargo }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-sync-readme";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "phaazon";
    repo = pname;
    rev = version;
    sha256 = "1c38q87fyfmj6nlwdpavb1xxpi26ncywkgqcwbvblad15c6ydcyc";
  };

  nativeBuildInputs = [ (importCargo ./Cargo.lock) ];

  meta = with stdenv.lib; {
    description = "A cargo plugin that generates a Markdown section in your README based on your Rust documentation";
    homepage = "https://github.com/phaazon/cargo-sync-readme";
    license = licenses.bsd3;
    maintainers = with maintainers; [ b4dm4n ];
  };
}
