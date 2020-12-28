{ stdenv, fetchFromGitHub, rustPlatform, importCargo }:

rustPlatform.buildRustPackage rec {
  pname = "ethabi";
  version = "11.0.0";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "ethabi";
    rev = "v${version}";
    sha256 = "1gqd3vwsvv1wvi659qcdywgmh41swblpwmmxb033k8irw581dwq4";
  };

  buildInputs = [ (importCargo ./Cargo.lock) ];

  meta = with stdenv.lib; {
    description = "Ethereum function call encoding (ABI) utility";
    homepage = "https://github.com/ethcore/ethabi/";
    maintainers = [ maintainers.dbrock ];
    license = licenses.gpl3;
    inherit version;
  };
}
