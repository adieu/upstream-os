{stdenv, fetchurl, libzstd, pkg-config}:

let
  version = "29";
  sha256 = "sha256-C4Dup6oYSsb9IMr6Kh/fKQ/+zHCGmnlweeLMXGIlpSo=";
in
  stdenv.mkDerivation {
    pname = "kmod";
    inherit version;
    src = fetchurl {
        url = "https://www.kernel.org/pub/linux/utils/kernel/kmod/kmod-${version}.tar.xz";
        inherit sha256;
    };
    enableParallelBuilding = true;
    buildInputs = [libzstd];
    nativeBuildInputs = [pkg-config];
    C_INCLUDE_PATH = "/usr/include";
    configureFlags = [
        "--with-zstd"
        "--without-openssl"
        "--without-zlib"
        "--without-xz"
    ];
    preConfigure = ''
      export LDFLAGS="-Wl,-rpath,/usr/lib"
    '';

  }


