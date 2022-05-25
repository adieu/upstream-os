{stdenv, fetchurl, glibc, autoconf, automake, bash, libtool, pkg-config, perl, gnum4}:

let
  version = "4.4.26";
  sha256 = "sha256-6KVE3RkXHB5hkaYETJbMMUlteBugi1oA9TMQ0AHVgRQ=";
in
  stdenv.mkDerivation {
    pname = "libxcrypt";
    inherit version;
    src = fetchurl {
        url = "https://github.com/besser82/libxcrypt/archive/v${version}/libxcrypt-${version}.tar.gz";
        inherit sha256;
    };
    enableParallelBuilding = true;
    buildInputs = [glibc];
    nativeBuildInputs = [autoconf automake bash libtool pkg-config perl gnum4];
    configureFlags = [
        "--disable-failure-tokens"
        "--disable-valgrind"
        "--disable-silent-rules"
        "--enable-hashes=all"
        "--enable-obsolete-api=no"
        "--enable-obsolete-api-enosys=no"
        "--enable-shared"
        "--enable-static"
        "--with-pkgconfigdir=/usr/lib/pkgconfig"
    ];
    preConfigure = ''
      $runEnv ./autogen.sh
    '';

  }


