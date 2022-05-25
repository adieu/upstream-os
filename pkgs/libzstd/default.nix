{stdenv, fetchurl, glibc}:

let
  version = "1.5.0";
  sha256 = "sha256-DZreIixk6RLWlXsRySPiFOLgEKGPOb7BAvVy5pO6KGc=";
in
  stdenv.mkDerivation {
    pname = "libzstd";
    inherit version;
    src = fetchurl {
        url = "https://github.com/facebook/zstd/archive/v${version}.tar.gz";
        inherit sha256;
    };
    enableParallelBuilding = true;
    buildInputs = [glibc];
    preConfigure = ''
      export CC=gcc
      export PREFIX=/usr
      export DESTDIR=$out
    '';

  }

