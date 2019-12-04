self: super:
let
  #unstable = import (fetchTarball http://nixos.org/channels/nixos-unstable/nixexprs.tar.xz) {};
  #master = import (fetchTarball http://github.com/NixOS/nixpkgs/archive/master.tar.gz) {};
in {
  userPackages = super.userPackages or { } // {
    bind = super.bind;
    bc = super.bc;
    tmux = super.callPackage ./pkgs/tmux/default.nix { };
    ripgrep = super.ripgrep;
    fd = super.fd;
    htop = super.htop;
    xsel = super.xsel;
    neovim = super.neovim;
    mosh = super.mosh;
    borgbackup = super.borgbackup;
    renameutils = super.renameutils;
    alacritty = super.callPackage ./pkgs/alacritty/default.nix { };
    openssh = super.openssh;
    autocutsel = super.autocutsel;
    apvlv = super.apvlv;
    fdupes = super.fdupes;
    units = super.units;
    scim = super.scim;
    ncdu = super.ncdu;
    socat = super.socat;
    sshfs = super.sshfs;
    scrot = super.scrot;
    wget = super.wget;
    unzip = super.unzip;
    stow = super.stow;
    pass = super.pass.withExtensions (ext: [
      super.passExtensions.pass-genphrase
      super.passExtensions.pass-update
      super.passExtensions.pass-audit
    ]);
    gnupg = super.gnupg;
    hexyl = super.hexyl;
    bat = super.bat;
    skim = super.skim;

    ## Calendar
    remind = super.remind;

    ## Doc Tools
    pandoc = super.pandoc;
    texlive = super.texlive.combined.scheme-small;
    termtosvg = super.termtosvg;
    plantuml = super.plantuml;

    ## Generic dev tools
    git = super.git;
    git-extras = super.gitAndTools.git-extras;
    hub = super.gitAndTools.hub;
    gist = super.gist;
    git-lfs = super.git-lfs;
    jq = super.jq;
    shellcheck = super.shellcheck;
    httpie = super.httpie;

    # Docker
    docker = super.docker;
    docker-compose = super.docker_compose;

    # Image
    feh = super.feh;
    imagemagick = super.imagemagick;
    darktable = super.darktable;
    inkscape = super.inkscape;

    # Video
    ffmpeg-full = super.ffmpeg-full;
    youtube-dl = super.youtube-dl;
    mpv = super.mpv;

    # Audio
    beets = super.callPackage ./pkgs/beets/default.nix { };
    cmus = super.cmus;

    # Social
    weechat = super.weechat;

    # Browser
    #google-chrome = super.google-chrome; # Broken on darwin

    # Network tools
    #wireshark-gtk = super.wireshark-gtk;


    # Accounting
    hledger = super.hledger;

    # Utilities
    tvnamer = super.python38Packages.tvnamer;
    go-mtpfs = super.go-mtpfs;

    getcert = super.writeScriptBin "getcert" ''
      #!${super.stdenv.shell}
      ${super.openssl}/bin/openssl s_client -showcerts -connect "$1" </dev/null 2>/dev/null | ${super.openssl}/bin/openssl x509 -outform PEM > "$2"
    '';

    cpp-guidelines = super.writeScriptBin "cpp-guidelines" ''
      #!${super.stdenv.shell}
      ${super.xdg_utils}/bin/xdg-open "http://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines"
    '';
  };
}
