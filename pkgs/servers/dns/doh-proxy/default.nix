{ lib, buildPythonPackage, fetchPypi
, aioh2, dnspython, aiohttp_remotes, pytestrunner, flake8
}:

buildPythonPackage rec {
  pname = "doh-proxy";
  version = "0.0.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mfl84mcklby6cnsw29kpcxj7mh1cx5yw6mjs4sidr1psyni7x6c";
  };

  propagatedBuildInputs = [ aioh2 dnspython aiohttp_remotes pytestrunner flake8 ];
  doCheck = false; # Trouble packaging unittest-data-provider

  meta = with lib; {
    homepage = https://facebookexperimental.github.io/doh-proxy/;
    description = "A proof of concept DNS-Over-HTTPS proxy";
    license = licenses.bsd3;
    maintainers = [ maintainers.qyliss ];
  };
}
