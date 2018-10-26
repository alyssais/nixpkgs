{ lib, buildPythonPackage, fetchPypi, aiohttp }:

buildPythonPackage rec {
  pname = "aiohttp_remotes";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "43c3f7e1c5ba27f29fb4dbde5d43b900b5b5fc7e37bf7e35e6eaedabaec4a3fc";
  };

  LC_ALL = "en_US.UTF-8";

  propagatedBuildInputs = [ aiohttp ];

  meta = with lib; {
    homepage = https://github.com/wikibusiness/aiohttp-remotes;
    description = "A set of useful tools for aiohttp.web server";
    license = [ licenses.mit ];
    maintainers = [ maintainers.qyliss ];
  };
}
