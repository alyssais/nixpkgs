{ lib, buildRubyGem, ruby }:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "flvtool2";
  version = "1.0.6";
  source.sha256 = "0xsla1061pi4ryh3jbvwsbs8qchprchbqjy7652g2g64v37i74qj";

  meta = {
    homepage = https://github.com/unnu/flvtool2;
    description = "A tool to manipulate Macromedia Flash Video files";
    platforms = ruby.meta.platforms;
    license = lib.licenses.bsd3;
  };
}
