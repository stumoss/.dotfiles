slf: super:
let
  unstable = import <nixpkgs-unstable> {};
in
{
  userPackages = super.userPackages or {} // {
    bind = super.bind;
    bc = super.bc;
    tmux = super.tmux;
    ripgrep = super.ripgrep;
    fd = super.fd;
    fzf = super.fzf;
    skim = super.skim;
    htop = super.htop;
    xsel = super.xsel;
    neovim = super.neovim;
    mosh = super.mosh;
    borgbackup = super.borgbackup;
    renameutils = super.renameutils;
    alacritty = super.alacritty;
    openssh = super.openssh;
    autocutsel = super.autocutsel;

    ## Doc Tools
    pandoc = super.pandoc;

    ## Generic dev tools
    git = super.git;
    git-extras = super.gitAndTools.git-extras;
    hub = super.gitAndTools.hub;
    gist = super.gist;
    git-lfs = super.git-lfs;
    plantuml = super.plantuml;
    jq = super.jq;
    vscode-with-extensions = super.vscode-with-extensions;

    ## Rust dev tools
    rust = super.latest.rustChannels.stable.rust;
    carnix = super.carnix;

    # Go dev tools
    go = super.go;
    go-bindata = super.go-bindata;
    goimports = super.goimports;
    go2nix = super.go2nix;

    # Docker
    docker = super.docker;
    docker-compose = super.docker_compose;

    socat = super.socat;
    sshfs = super.sshfs;
    ranger = super.ranger;
    scrot = super.scrot;
    wget = super.wget;
    unzip = super.unzip;
    stow = super.stow;
    feh = super.feh;
    asciinema = super.asciinema;
    shellcheck = super.shellcheck;
    pass = super.pass;
    gnupg = super.gnupg;

    # Video
    ffmpeg-full = super.ffmpeg-full;
    youtube-dl = super.youtube-dl;

    # Audio
    beets = super.beets;
    cmus = super.cmus; # Broken on darwin

    # Social
    weechat = super.weechat;

    # Browser
    #google-chrome = super.google-chrome; # Broken on darwin

    # Network tools
    #wireshark-gtk = super.wireshark-gtk;

    # Utilities
    tvnamer = super.python36Packages.tvnamer;
    exa = super.exa;
    go-mtpfs = super.go-mtpfs;

    ## C++ dev tools
    #clang-analyzer = super.clang-analyzer;
    #clang-tools = super.clang-tools;
    #include-what-you-use = super.include-what-you-use;
    #cmake = super.cmake;
    ##make = super.gnumake;
    ##clang = super.clang;
    #cppcheck = super.cppcheck;

    #getcert = super.writeScriptBin "getcert"
    #''
    #    #!${super.stdenv.shell}
    #    ${super.openssl}/bin/openssl s_client -showcerts -connect "$1" </dev/null 2>/dev/null | ${super.openssl}/bin/openssl x509 -outform PEM > "$2"
    #'';

    #cpp-guidelines = super.writeScriptBin "cpp-guidelines"
    #''
    #  #!${super.stdenv.shell}
    #  ${super.xdg_utils}/bin/xdg-open "http://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines"
    #'';


    ## Clearswift
    #cmake-docs = super.writeScriptBin "cmake-docs"
    #''
    #  #!${super.stdenv.shell}
    #  ${super.xdg_utils}/bin/xdg-open "https://cmake.org/cmake/help/v''${1:-2.8.12}/cmake.html"
    #'';

    dobi = super.callPackage ../pkgs/dobi/v0.11.1/default.nix { };

    nix-shell-rust = super.writeScriptBin "nix-shell-rust"
    ''
      #!${super.stdenv.shell}
      cat <<EOF > default.nix
      let
        moz_overlay = import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz);
        nixpkgs = import <nixpkgs> { overlays = [ moz_overlay ]; };
        version = "0.0.1";
      in

      with nixpkgs;

      stdenv.mkDerivation {
        name = "myproject-''${version}";
        src = ./.;

        cargoSha256 = "0x59sq2kpg4wgdrl3gwkrxkq5288yqs9ajx4ipqapccqcbax2vzv";

        buildInputs = [
          gitAndTools.gitFull
          gitAndTools.hub
          latest.rustChannels.stable.rust
          carnix
        ];
      }
      EOF
    '';

    go-static-build = super.writeScriptBin "go-static-build"
    ''
      #!${super.bash}/bin/bash -p
      CGO_ENABLED=0 ${super.go}/bin/go build -a -ldflags '-extldflags "-static"' $@
    '';

    youtube-dl-playlist = super.writeScriptBin "youtube-dl-playlist"
    ''
      #!${super.bash}/bin/bash -p
      set -euo pipefail

      VERSION=1.0.0

      function usage()
      {
        echo "$(basename $0) $VERSION"
        echo "Stuart Moss <samoss@gmail.com>"
        echo ""
        echo "USAGE:"
        echo " $(basename $0) [FLAGS] <playlist url>"
        echo ""
        echo "FLAGS:"
        echo "  -h, --help      Prints help information"
        echo "  -v, --version   Prints version information"
        echo ""
        echo "ARGS:"
        echo "  <playlist url>  The url of the youtube playlist to download"
        echo ""
      }

      while :
      do
          case "$1" in
            -h | --help)
                usage
                # no shifting needed here, we're done.
                exit 0
                ;;
            -v | --version)
                usage
                exit 0
                ;;
            --) # End of all options
                shift
                break;
                ;;
            -*)
                echo "Error: Unknown option: $1" >&2
                exit 1
                ;;
            *)  # No more options
                break
                ;;
          esac
      done

      ${super.youtube-dl}/bin/youtube-dl --extract-audio --audio-format mp3 -o "%(title)s.%(ext)s" $1
    '';

    nix-build-callpackage = super.writeScriptBin "nix-build-callpackage"
    ''
      #!${super.bash}/bin/bash -p
      nix-build -E 'with import <nixpkgs> { };  callPackage "$1" {}'
    '';

    nix-rebuild = super.writeScriptBin "nix-rebuild"
    ''
      #!${super.bash}/bin/bash -p
      exec nix-env -f '<nixpkgs>' -r -iA userPackages
    '';
  };
}

