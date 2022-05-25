{stdenv, fetchurl, glibc, flex}:

let
  version = "3.3";
  sha256 = "sha256-LZffPrhGYWmzicNmCsu5DFQgCsluRS7Kn0GpY59PI4s=";
in
  stdenv.mkDerivation {
    pname = "libsepol";
    inherit version;
    src = fetchurl {
        url = "https://github.com/SELinuxProject/selinux/releases/download/${version}/libsepol-${version}.tar.gz";
        inherit sha256;
    };
    enableParallelBuilding = true;
    buildInputs = [glibc];
    nativeBuildInputs = [flex];
    preConfigure = ''
      export CC=gcc
      export PREFIX=/usr
      export SHLIBDIR=/usr/lib
      export DESTDIR=$out
    '';

  }

