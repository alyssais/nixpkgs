{
  docurium = {
    dependencies = ["ffi-clang" "gli" "mustache" "redcarpet" "rocco" "rugged" "version_sorter"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nqhg45m5fww11gljlf5mf6jpifdp5c4abkkpwjq2mvg6hysysyq";
      type = "gem";
    };
    version = "0.6.0";
  };
  ffi = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wgvaclp4h9y8zkrgz8p2hqkrgr4j7kz0366mik0970w532cbmcq";
      type = "gem";
    };
    version = "1.15.3";
  };
  ffi-clang = {
    dependencies = ["ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06gnsjndp6y8q019z2dzjqmybglmy1419wqldyk074p7dm92snki";
      type = "gem";
    };
    version = "0.6.0";
  };
  gli = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sxpixpkbwi0g1lp9nv08hb4hw9g563zwxqfxd3nqp9c1ymcv5h3";
      type = "gem";
    };
    version = "2.20.1";
  };
  mustache = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l0p4wx15mi3wnamfv92ipkia4nsx8qi132c6g51jfdma3fiz2ch";
      type = "gem";
    };
    version = "1.1.1";
  };
  redcarpet = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bvk8yyns5s1ls437z719y5sdv9fr8kfs8dmr6g8s761dv5n8zvi";
      type = "gem";
    };
    version = "3.5.1";
  };
  rocco = {
    dependencies = ["mustache" "redcarpet"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0z3wnk8848wphrzyb61adl1jbfjlsqnzkayp2m0qmisg566352l1";
      type = "gem";
    };
    version = "0.8.2";
  };
  rugged = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04rkxwzaa6897da3mnm70g720gpxwyh71krfn6ag1dkk80x8a8yz";
      type = "gem";
    };
    version = "0.99.0";
  };
  version_sorter = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hbdw3vh856f5yg5mbj4498l6vh90cd3pn22ikr3ranzkrh73l3s";
      type = "gem";
    };
    version = "2.2.4";
  };
}
