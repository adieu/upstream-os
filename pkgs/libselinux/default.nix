{stdenv, fetchurl, libpcre, libsepol, bash, pkg-config-unwrapped}:

let
  version = "3.3";
  sha256 = "sha256-rP3uJ2M9JJZQjChyfD1B03SAdvZtQvzN4ua580Y6cFc=";
in
  stdenv.mkDerivation {
    pname = "libselinux";
    inherit version;
    src = fetchurl {
        url = "https://github.com/SELinuxProject/selinux/releases/download/${version}/libselinux-${version}.tar.gz";
        inherit sha256;
    };
    enableParallelBuilding = true;
    buildInputs = [libpcre libsepol];
    nativeBuildInputs = [bash pkg-config-unwrapped];
    C_INCLUDE_PATH = "/usr/include";
    preConfigure = ''
      export CC=gcc
      export PREFIX=/usr
      export SHLIBDIR=/usr/lib
      export DESTDIR=$out
      export DISABLE_RPM='y'
      export USE_PCRE2='y'
      export LDFLAGS="-Wl,-rpath,/usr/lib"
    '';

  }

