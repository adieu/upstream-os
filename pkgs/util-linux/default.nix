{stdenv, fetchurl, libacl, libselinux, libxcrypt, coreutils, ncurses, autoconf, automake, bash, libtool, pkg-config, perl, gnum4, gettext, file}:

let
  majorMinor = "2.37";
  version = "${majorMinor}.2";
  sha256 = "sha256-agdkwarn+2B++KbdLA9sR9Xl/SeqCIIKuq2ewU4o6dk=";
in
  stdenv.mkDerivation {
    pname = "util-linux";
    inherit version;
    src = fetchurl {
        url = "https://www.kernel.org/pub/linux/utils/util-linux/v${majorMinor}/util-linux-${version}.tar.xz";
        inherit sha256;
    };
    #dontMakeSourcesWritable = true;
    strictDeps = true;
    NIX_DEBUG = true;
    enableParallelBuilding = true;
    buildInputs = [libacl libselinux libxcrypt coreutils ncurses];
    nativeBuildInputs = [autoconf automake bash libtool pkg-config perl gnum4 gettext file];
    C_INCLUDE_PATH = "/usr/include";
    configureFlags = [
        "--disable-makeinstall-chown"
        "--disable-makeinstall-setuid"
        "--disable-nls"
        "--disable-rpath"
        "--enable-all-programs"
        "--enable-libblkid"
        "--enable-libfdisk"
        "--enable-libmount"
        "--enable-libsmartcols"
        "--enable-libuuid"
        "--enable-usrdir-path"
        "--with-selinux"
        "--without-audit"
        "--without-python"
        "--without-readline"
        "--without-systemd"
        "--without-udev"
        "--without-utempter"
    ];
    preConfigure = ''
      export LDFLAGS="-Wl,-rpath,/usr/lib"
      makeFlagsArray+=(
        "usrbin_execdir=/bin"
        "usrlib_execdir=/lib"
        "usrsbin_execdir=/sbin"
      )
      $runEnv ./autogen.sh
    '';

  }


