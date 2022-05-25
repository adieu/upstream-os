{stdenv, fetchurl, glibc}:

let
  version = "10.37";
  sha256 = "sha256-TZWpbouAUpiTtFYr4SZI15i5V7G6Gq45YGu8KrlW0nA=";
in
  stdenv.mkDerivation {
    pname = "libpcre";
    inherit version;
    src = fetchurl {
        url = "https://github.com/PhilipHazel/pcre2/releases/download/pcre2-${version}/pcre2-${version}.tar.bz2";
        inherit sha256;
    };
    enableParallelBuilding = true;
    buildInputs = [glibc];
    configureFlags = [
        "--enable-newline-is-lf"
        "--enable-pcre2-8"
        "--enable-shared"
        "--enable-static"
        "--enable-unicode"
        "--disable-jit"
        "--disable-jit-sealloc"
        "--disable-pcre2-16"
        "--disable-pcre2-32"
        "--disable-pcre2grep-callout"
        "--disable-pcre2grep-callout-fork"
        "--disable-pcre2grep-jit"
        "--disable-pcre2grep-libbz2"
        "--disable-pcre2grep-libz"
        "--disable-pcre2test-libedit"
        "--disable-pcre2test-libreadline"
    ];

  }

