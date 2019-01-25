{ buildRubyGem, ruby }:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "bundler";
  version = "2.0.1";
  source.sha256 = "1sjnfsyw80g56kj96gdfgxfb793h6d5fyyir4zf2x71wk4wq1qy7";
  dontPatchShebangs = true;

  postFixup = ''
    sed -i -e "s/activate_bin_path/bin_path/g" $out/bin/bundle
  '';
}
