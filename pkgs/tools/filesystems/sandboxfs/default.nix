{ stdenv
, fetchFromGitHub
, rustPlatform
, importCargo
, fuse
, pkg-config
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "sandboxfs";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = pname;
    rev = "sandboxfs-${version}";
    sha256 = "Ia6rq6FN4abnvLXjlQh4Q+8ra5JThKnC86UXC7s9//U=";
  };

  nativeBuildInputs = [
    pkg-config installShellFiles (importCargo ./Cargo.lock)
  ];
  buildInputs = [ fuse ];

  postInstall = "installManPage man/sandboxfs.1";

  meta = with stdenv.lib; {
    description = "A virtual file system for sandboxing";
    homepage = "https://github.com/bazelbuild/sandboxfs";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ jeremyschlatter ];
  };
}
