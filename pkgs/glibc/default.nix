{fetchurl, stdenv, bash, extraPkgs ? [] }:

let
  version = "2.33";
  sha256 = "sha256-LiVWAA4QXb1X8Layoy/yzxc73k8Nhd/8z9i35RoGd/8=";
in
  stdenv.mkDerivation {
    pname = "glibc";
    inherit version;
    enableParallelBuilding = true;
    NIX_NO_SELF_RPATH = true;
    nativeBuildInputs = [ bash ] ++ extraPkgs;

    src = fetchurl {
        url = "mirror://gnu/glibc/glibc-${version}.tar.xz";
        inherit sha256;
    };

    patches = [ ./skip-symlinks-check.patch ];

    postPatch =
    ''
      # nscd needs libgcc, and we don't want it dynamically linked
      # because we don't want it to depend on bootstrap-tools libs.
      echo "LDFLAGS-nscd += -static-libgcc" >> nscd/Makefile
    '';
    preConfigure = ''
      mkdir ../build
      cd ../build
      configureScript="`pwd`/../$sourceRoot/configure"
      echo "slibdir=/usr/lib" >> configparms
      echo "rtlddir=/usr/lib" >> configparms
      echo "sbindir=/usr/sbin" >> configparms
      echo "rootsbindir=/usr/sbin" >> configparms
    '';
    postConfigurexx = ''
      # Hack: get rid of the `-static' flag set by the bootstrap stdenv.
      # This has to be done *after* `configure' because it builds some
      # test binaries.
      export NIX_CFLAGS_LINK=
      export NIX_LDFLAGS_BEFORE=

      export NIX_DONT_SET_RPATH=1
      unset CFLAGS
    '';
    configureFlags = [
      "--enable-bind-now"
      "--enable-shared"
      "--enable-stack-protector=strong"
      "--enable-static-pie"
      "--disable-crypt"
      "--disable-multi-arch"
      "--disable-profile"
      "--disable-systemtap"
      "--disable-timezone-tools"
      "--disable-tunables"
      "--without-cvs"
      "--without-gd"
      "--without-selinux"
      "--libdir=/usr/lib"
      "--libexecdir=/usr/lib"
      "--enable-static-pie"
    ];
    preInstall = ''
      installFlagsArray+=("install_root=$out")
    '';
  }
