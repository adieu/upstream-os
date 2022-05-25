{stdenv, fetchurl, kmod, libattr, libacl, libcap, libselinux, libxcrypt, coreutils, util-linux, libseccomp, bash, meson, gnum4, gperf, pkg-config, ninja}:

let
  version = "247.9";
  sha256 = "sha256-YpuMiV76AAuSEJLHpWVoDGbc0Ox07RHLLdK2cBSSZ10=";
in
  stdenv.mkDerivation {
    pname = "systemd";
    inherit version;
    src = fetchurl {
        url = "https://github.com/systemd/systemd-stable/archive/v${version}/systemd-stable-${version}.tar.gz";
        inherit sha256;
    };
    enableParallelBuilding = true;
    buildInputs = [kmod libattr libacl libcap libselinux libxcrypt coreutils util-linux libseccomp];
    nativeBuildInputs = [bash meson gnum4 gperf pkg-config ninja];
    patches = [
      ./9003-repart-always-use-random-UUIDs.patch
    ];
    C_INCLUDE_PATH = "/usr/include";
    preConfigure = ''
      export LDFLAGS="-Wl,-rpath,/usr/lib"
      configureFlagsArray+=(
        "--errorlogs"
        "-Dsplit-usr=false"
        "-Dsplit-bin=true"
        "-Drootprefix=/usr"
        "-Drootlibdir=/usr/lib"
        "-Dlink-udev-shared=true"
        "-Dlink-systemctl-shared=true"
        "-Dstatic-libsystemd=false"
        "-Dstatic-libudev=false"
        "-Dsysvinit-path=/etc/init.d"
        "-Dsysvrcnd-path=/etc/rc.d"
        "-Dutmp=false"
        "-Dhibernate=false"
        "-Dldconfig=true"
        "-Dresolve=false"
        "-Defi=false"
        "-Dtpm=false"
        "-Denvironment-d=false"
        "-Dbinfmt=false"
        "-Drepart=true"
        "-Dcoredump=false"
        "-Dpstore=true"
        "-Dlogind=false"
        "-Dhostnamed=false"
        "-Dlocaled=false"
        "-Dmachined=false"
        "-Dportabled=false"
        "-Duserdb=false"
        "-Dhomed=false"
        "-Dnetworkd=false"
        "-Dtimedated=false"
        "-Dtimesyncd=false"
        "-Dremote=false"
        "-Dnss-myhostname=false"
        "-Dnss-mymachines=false"
        "-Dnss-resolve=false"
        "-Dnss-systemd=false"
        "-Dfirstboot=false"
        "-Drandomseed=true"
        "-Dbacklight=false"
        "-Dvconsole=false"
        "-Dquotacheck=false"
        "-Dsysusers=true"
        "-Dtmpfiles=true"
        "-Dimportd=false"
        "-Dhwdb=false"
        "-Drfkill=false"
        "-Dman=false"
        "-Dhtml=false"
        "-Dcertificate-root=/etc/ssl"
        "-Dpkgconfigdatadir=/usr/lib/pkgconfig"
        "-Dpkgconfiglibdir=/usr/lib/pkgconfig"
        "-Ddefault-hierarchy=hybrid"
        "-Dseccomp=auto"
        "-Dselinux=auto"
        "-Dapparmor=false"
        "-Dsmack=false"
        "-Dpolkit=false"
        "-Dima=false"
        "-Dacl=true"
        "-Daudit=false"
        "-Dblkid=true"
        "-Dfdisk=true"
        "-Dkmod=true"
        "-Dpam=false"
        "-Dpwquality=false"
        "-Dmicrohttpd=false"
        "-Dlibcryptsetup=false"
        "-Dlibcurl=false"
        "-Didn=false"
        "-Dlibidn2=false"
        "-Dlibidn=false"
        "-Dlibiptc=false"
        "-Dqrencode=false"
        "-Dgcrypt=false"
        "-Dgnutls=false"
        "-Dopenssl=false"
        "-Dp11kit=false"
        "-Delfutils=false"
        "-Dzlib=false"
        "-Dbzip2=false"
        "-Dxz=false"
        "-Dlz4=false"
        "-Dxkbcommon=false"
        "-Dpcre2=false"
        "-Dglib=false"
        "-Ddbus=false"
        "-Dgnu-efi=false"
        "-Dbashcompletiondir=no"
        "-Dzshcompletiondir=no"
        "-Dtests=false"
        "-Dslow-tests=false"
        "-Dinstall-tests=false"
        "-Doss-fuzz=false"
        "-Dllvm-fuzz=false"
      )
    '';
  }


