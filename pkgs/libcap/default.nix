{stdenv, fetchurl, libattr, bash, perl}:

let
  version = "2.60";
  sha256 = "sha256-UhCjw8ruVL9Z43JMrEpcgFV5rvs9kb+FH96Okh6ruos=";
in
  stdenv.mkDerivation {
    pname = "libcap";
    inherit version;
    src = fetchurl {
        url = "https://git.kernel.org/pub/scm/libs/libcap/libcap.git/snapshot/libcap-${version}.tar.gz";
        inherit sha256;
    };
    enableParallelBuilding = true;
    buildInputs = [libattr];
    nativeBuildInputs = [bash perl];
    preBuild = ''
      buildFlagsArray+=(
        "CC=gcc"
        "CFLAGS=-fPIC"
        "BUILD_CC=gcc"
        "prefix=/usr"
        "lib=/usr/lib"
        "LIBDIR=/usr/lib"
        "SBINDIR=/usr/sbin"
        "INCDIR=/usr/include"
        "MANDIR=/usr/share/man"
        "PKGCONFIGDIR=/usr/lib/pkgconfig"
        "GOLANG=no"
        "RAISE_SETFCAP=no"
        "PAM_CAP=no"
      )
    '';
    preInstall = ''
      installFlagsArray+=(
        "CC=gcc"
        "CFLAGS=-fPIC"
        "BUILD_CC=gcc"
        "prefix=/usr"
        "lib=/usr/lib"
        "LIBDIR=/usr/lib"
        "SBINDIR=/usr/sbin"
        "INCDIR=/usr/include"
        "MANDIR=/usr/share/man"
        "PKGCONFIGDIR=/usr/lib/pkgconfig"
        "GOLANG=no"
        "RAISE_SETFCAP=no"
        "PAM_CAP=no"
      )
    '';

  }


